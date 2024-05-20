#! /usr/bin/bash

TMP_DIR="$HOME/tmp"
PATH_PYTHON=$(which python3)
function install_dependencies () {
    if [ -f /etc/lsb-release ]; then
	# assume yes when doing api install
	alias apt-get="apt-get --assume-yes"

        sudo apt update
	sudo apt install neovim
	if [ ! -d $TMP_DIR ]; then
	    mkdir -p $TMP_DIR
	fi
	local tmp_node_script=$TMP_DIR/nodesource_setup.sh
	# sudo chmod 777 $tmp_node_script
	curl -sL https://deb.nodesource.com/setup_20.x -o $tmp_node_script
	sudo chmod 777 $tmp_node_script
	sudo $tmp_node_script
	sudo apt-get install nodejs -y
    fi
}

function setup_nvim () {
    local NVIM_CONFIG_DIR="$HOME/.config/nvim"
    echo $NVIM_CONFIG_DIR
    # create path for nvim config
    if [ ! -d $NVIM_CONFIG_DIR ]; then
	mkdir -p $NVIM_CONFIG_DIR
    fi
    if [ ! -f $NVIM_CONFIG_DIR/init.vim ]; then
        ln -s $(pwd)/vim_setting/.vimrc ${NVIM_CONFIG_DIR}/init.vim
    else
	echo "Config file link exists"
    fi
    # Install vim-plug for Neovim if not already installed
    if [ ! -f "$NVIM_CONFIG_DIR/autoload/plug.vim" ]; then
        curl -fLo "$NVIM_CONFIG_DIR/autoload/plug.vim" --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    fi
    nvim \
	+PlugInstall \
	+CocInstall coc-styled-components \
	+CocInstall coc-eslint \
	+qall
    echo "Neovim and plugins have been installed successfully."
    echo "alias vim=\"nvim\"" >> ~/.bashrc
}

install_dependencies

setup_nvim
