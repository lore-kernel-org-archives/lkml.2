Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928Ab0JSPuF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 11:50:05 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:55161 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458Ab0JSPuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 11:50:04 -0400
To: npiggin@kernel.dk
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-reply-to: <20101019034658.215515030@kernel.dk> (npiggin@kernel.dk)
Subject: Re: [patch 26/35] fs: icache alloc anonymous inode allocation
References: <20101019034216.319085068@kernel.dk> <20101019034658.215515030@kernel.dk>
Message-Id: <E1P8ERs-0006k4-Gz@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 19 Oct 2010 17:50:00 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Oct 2010, npiggin@kernel.d wrote:
> Provide new_anon_inode function for inodes without a default inode number, and
> not on sb list. This can enable filesystems to reduce locking. "Real"
> filesystems can also reduce locking by allocating anonymous inode first, then
> adding it to lists after finding the inode number.
> 
> Signed-off-by: Nick Piggin <npiggin@kernel.dk>
> 
> ---
>  fs/anon_inodes.c   |    2 +-
>  fs/inode.c         |   32 +++++++++++++++++++++++++++++++-
>  fs/pipe.c          |    3 ++-
>  include/linux/fs.h |    2 ++
>  net/socket.c       |    3 ++-
>  5 files changed, 38 insertions(+), 4 deletions(-)
> 
> Index: linux-2.6/fs/inode.c
> ===================================================================
> --- linux-2.6.orig/fs/inode.c	2010-10-19 14:18:59.000000000 +1100
> +++ linux-2.6/fs/inode.c	2010-10-19 14:19:22.000000000 +1100
> @@ -219,6 +219,7 @@
>  #ifdef CONFIG_QUOTA
>  	memset(&inode->i_dquot, 0, sizeof(inode->i_dquot));
>  #endif
> +	INIT_LIST_HEAD(&inode->i_sb_list);
>  	inode->i_pipe = NULL;
>  	inode->i_bdev = NULL;
>  	inode->i_cdev = NULL;
> @@ -761,6 +762,8 @@
>   */
>  static void inode_sb_list_del(struct inode *inode)
>  {
> +	if (list_empty(&inode->i_sb_list))
> +		return;
>  	lg_local_lock_cpu(inode_list_lglock, inode_list_cpu(inode));
>  	list_del_rcu(&inode->i_sb_list);
>  	lg_local_unlock_cpu(inode_list_lglock, inode_list_cpu(inode));
> @@ -819,7 +822,7 @@
>   */
>  static DEFINE_PER_CPU(unsigned int, last_ino);
>  
> -static unsigned int get_next_ino(void)
> +unsigned int get_next_ino(void)
>  {
>  	unsigned int res;
>  
> @@ -838,6 +841,7 @@
>  	put_cpu();
>  	return res;
>  }
> +EXPORT_SYMBOL(get_next_ino);
>  
>  /**
>   *	new_inode 	- obtain an inode
> @@ -870,6 +874,32 @@
>  }
>  EXPORT_SYMBOL(new_inode);
>  
> +/**
> + *	new_anon_inode 	- obtain an anonymous inode
> + *	@sb: superblock
> + *
> + *	Similar to new_inode, however the inode is not given an inode
> + *	number, and is not added to the sb's list of inodes, to reduce
> + *	overheads.
> + *
> + *	A filesystem which needs an inode number must subsequently
> + *	assign one to i_ino. A filesystem which needs inodes to be on the
> + *	per-sb list (currently only used by the vfs for umount or remount)
> + *	must add the inode to that list.
> + */
> +struct inode *new_anon_inode(struct super_block *sb)
> +{
> +	struct inode *inode;
> +
> +	inode = alloc_inode(sb);
> +	if (inode) {
> +		inode->i_ino = ULONG_MAX;
> +		inode->i_state = 0;
> +	}
> +	return inode;
> +}
> +EXPORT_SYMBOL(new_anon_inode);
> +
>  void unlock_new_inode(struct inode *inode)
>  {
>  #ifdef CONFIG_DEBUG_LOCK_ALLOC
> Index: linux-2.6/fs/pipe.c
> ===================================================================
> --- linux-2.6.orig/fs/pipe.c	2010-10-19 14:18:59.000000000 +1100
> +++ linux-2.6/fs/pipe.c	2010-10-19 14:19:00.000000000 +1100
> @@ -948,7 +948,7 @@
>  
>  static struct inode * get_pipe_inode(void)
>  {
> -	struct inode *inode = new_inode(pipe_mnt->mnt_sb);
> +	struct inode *inode = new_anon_inode(pipe_mnt->mnt_sb);
>  	struct pipe_inode_info *pipe;
>  
>  	if (!inode)
> @@ -962,6 +962,7 @@
>  	pipe->readers = pipe->writers = 1;
>  	inode->i_fop = &rdwr_pipefifo_fops;
>  
> +	inode->i_ino = get_next_ino();
>  	/*
>  	 * Mark the inode dirty from the very beginning,
>  	 * that way it will never be moved to the dirty
> Index: linux-2.6/include/linux/fs.h
> ===================================================================
> --- linux-2.6.orig/include/linux/fs.h	2010-10-19 14:18:59.000000000 +1100
> +++ linux-2.6/include/linux/fs.h	2010-10-19 14:19:21.000000000 +1100
> @@ -2192,11 +2192,13 @@
>  extern int insert_inode_locked(struct inode *);
>  extern void unlock_new_inode(struct inode *);
>  
> +extern unsigned int get_next_ino(void);
>  extern void iget_failed(struct inode *);
>  extern void end_writeback(struct inode *);
>  extern void destroy_inode(struct inode *);
>  extern void __destroy_inode(struct inode *);
>  extern struct inode *new_inode(struct super_block *);
> +extern struct inode *new_anon_inode(struct super_block *);
>  extern void free_inode_nonrcu(struct inode *inode);
>  extern int should_remove_suid(struct dentry *);
>  extern int file_remove_suid(struct file *);
> Index: linux-2.6/net/socket.c
> ===================================================================
> --- linux-2.6.orig/net/socket.c	2010-10-19 14:18:59.000000000 +1100
> +++ linux-2.6/net/socket.c	2010-10-19 14:19:19.000000000 +1100
> @@ -476,13 +476,14 @@
>  	struct inode *inode;
>  	struct socket *sock;
>  
> -	inode = new_inode(sock_mnt->mnt_sb);
> +	inode = new_anon_inode(sock_mnt->mnt_sb);
>  	if (!inode)
>  		return NULL;
>  
>  	sock = SOCKET_I(inode);
>  
>  	kmemcheck_annotate_bitfield(sock, type);
> +	inode->i_ino = get_next_ino();
>  	inode->i_mode = S_IFSOCK | S_IRWXUGO;
>  	inode->i_uid = current_fsuid();
>  	inode->i_gid = current_fsgid();
> Index: linux-2.6/fs/anon_inodes.c
> ===================================================================
> --- linux-2.6.orig/fs/anon_inodes.c	2010-10-19 14:18:58.000000000 +1100
> +++ linux-2.6/fs/anon_inodes.c	2010-10-19 14:19:19.000000000 +1100
> @@ -191,7 +191,7 @@
>   */
>  static struct inode *anon_inode_mkinode(void)
>  {
> -	struct inode *inode = new_inode(anon_inode_mnt->mnt_sb);
> +	struct inode *inode = new_anon_inode(anon_inode_mnt->mnt_sb);
>  
>  	if (!inode)
>  		return ERR_PTR(-ENOMEM);

This too needs an inode->i_ino initialization (the default ULONG_MAX
will cause EOVERFLOW on 32bit fstat, AFAIK), though it could just be a
constant, say 2.

Miklos
