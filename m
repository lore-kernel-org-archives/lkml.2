Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188Ab0JILST (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 07:18:19 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39176 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754850Ab0JILSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 07:18:17 -0400
Date: Sat, 9 Oct 2010 07:18:13 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 20/18] fs: do not assign default i_ino in new_inode
Message-ID: <20101009111813.GA18852@infradead.org>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286515292-15882-1-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of always assigning an increasing inode number in new_inode
move the call to assign it into those callers that actually need it.
For now callers that need it is estimated conservatively, that is 
the call is added to all filesystems that do not assign an i_ino
by themselves.  For a few more filesystems we can avoid assigning
any inode number given that they aren't user visible, and for others
it could be done lazily when an inode number is actually needed,
but that's left for later patches.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c	2010-10-08 19:54:31.257003917 +0200
+++ linux-2.6/fs/inode.c	2010-10-08 19:54:31.825011877 +0200
@@ -839,7 +839,7 @@ EXPORT_SYMBOL_GPL(inode_add_to_sb_list);
 #define LAST_INO_BATCH 1024
 static DEFINE_PER_CPU(unsigned int, last_ino);
 
-static unsigned int last_ino_get(void)
+unsigned int last_ino_get(void)
 {
 	unsigned int *p = &get_cpu_var(last_ino);
 	unsigned int res = *p;
@@ -857,6 +857,7 @@ static unsigned int last_ino_get(void)
 	put_cpu_var(last_ino);
 	return res;
 }
+EXPORT_SYMBOL(last_ino_get);
 
 /**
  *	new_inode 	- obtain an inode
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2010-10-08 19:54:31.262004266 +0200
+++ linux-2.6/include/linux/fs.h	2010-10-08 19:54:31.826022563 +0200
@@ -2184,6 +2184,7 @@ extern struct inode * iget_locked(struct
 extern int insert_inode_locked4(struct inode *, unsigned long, int (*test)(struct inode *, void *), void *);
 extern int insert_inode_locked(struct inode *);
 extern void unlock_new_inode(struct inode *);
+extern unsigned int last_ino_get(void);
 
 extern void iref(struct inode *inode);
 extern void iref_locked(struct inode *inode);
Index: linux-2.6/drivers/infiniband/hw/ipath/ipath_fs.c
===================================================================
--- linux-2.6.orig/drivers/infiniband/hw/ipath/ipath_fs.c	2010-10-08 19:53:46.539005524 +0200
+++ linux-2.6/drivers/infiniband/hw/ipath/ipath_fs.c	2010-10-08 19:54:36.795003567 +0200
@@ -57,6 +57,7 @@ static int ipathfs_mknod(struct inode *d
 		goto bail;
 	}
 
+	inode->i_ino = last_ino_get();
 	inode->i_mode = mode;
 	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 	inode->i_private = data;
Index: linux-2.6/drivers/infiniband/hw/qib/qib_fs.c
===================================================================
--- linux-2.6.orig/drivers/infiniband/hw/qib/qib_fs.c	2010-10-08 19:53:46.540005523 +0200
+++ linux-2.6/drivers/infiniband/hw/qib/qib_fs.c	2010-10-08 19:54:47.625206039 +0200
@@ -58,6 +58,7 @@ static int qibfs_mknod(struct inode *dir
 		goto bail;
 	}
 
+	inode->i_ino = last_ino_get();
 	inode->i_mode = mode;
 	inode->i_uid = 0;
 	inode->i_gid = 0;
Index: linux-2.6/drivers/misc/ibmasm/ibmasmfs.c
===================================================================
--- linux-2.6.orig/drivers/misc/ibmasm/ibmasmfs.c	2010-10-08 19:53:46.550006500 +0200
+++ linux-2.6/drivers/misc/ibmasm/ibmasmfs.c	2010-10-08 19:54:36.804260795 +0200
@@ -146,6 +147,7 @@ static struct inode *ibmasmfs_make_inode
 	struct inode *ret = new_inode(sb);
 
 	if (ret) {
+		ret->i_ino = last_ino_get();
 		ret->i_mode = mode;
 		ret->i_atime = ret->i_mtime = ret->i_ctime = CURRENT_TIME;
 	}
Index: linux-2.6/drivers/oprofile/oprofilefs.c
===================================================================
--- linux-2.6.orig/drivers/oprofile/oprofilefs.c	2010-10-08 19:53:46.552018094 +0200
+++ linux-2.6/drivers/oprofile/oprofilefs.c	2010-10-08 19:54:36.811254300 +0200
@@ -28,6 +28,7 @@ static struct inode *oprofilefs_get_inod
 	struct inode *inode = new_inode(sb);
 
 	if (inode) {
+		inode->i_ino = last_ino_get();
 		inode->i_mode = mode;
 		inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 	}
Index: linux-2.6/drivers/usb/core/inode.c
===================================================================
--- linux-2.6.orig/drivers/usb/core/inode.c	2010-10-08 19:53:46.560005872 +0200
+++ linux-2.6/drivers/usb/core/inode.c	2010-10-08 19:54:36.818261564 +0200
@@ -276,6 +276,7 @@ static struct inode *usbfs_get_inode (st
 	struct inode *inode = new_inode(sb);
 
 	if (inode) {
+		inode->i_ino = last_ino_get();
 		inode->i_mode = mode;
 		inode->i_uid = current_fsuid();
 		inode->i_gid = current_fsgid();
Index: linux-2.6/drivers/usb/gadget/f_fs.c
===================================================================
--- linux-2.6.orig/drivers/usb/gadget/f_fs.c	2010-10-08 19:53:46.565007478 +0200
+++ linux-2.6/drivers/usb/gadget/f_fs.c	2010-10-08 19:54:36.828006430 +0200
@@ -980,6 +980,7 @@ ffs_sb_make_inode(struct super_block *sb
 	if (likely(inode)) {
 		struct timespec current_time = CURRENT_TIME;
 
+		inode->i_ino	 = usbfs_get_inode();
 		inode->i_mode    = perms->mode;
 		inode->i_uid     = perms->uid;
 		inode->i_gid     = perms->gid;
Index: linux-2.6/drivers/usb/gadget/inode.c
===================================================================
--- linux-2.6.orig/drivers/usb/gadget/inode.c	2010-10-08 19:53:46.569006151 +0200
+++ linux-2.6/drivers/usb/gadget/inode.c	2010-10-08 19:54:36.836003916 +0200
@@ -1994,6 +1994,7 @@ gadgetfs_make_inode (struct super_block
 	struct inode *inode = new_inode (sb);
 
 	if (inode) {
+		inode->i_ino = last_ino_get();
 		inode->i_mode = mode;
 		inode->i_uid = default_uid;
 		inode->i_gid = default_gid;
Index: linux-2.6/fs/anon_inodes.c
===================================================================
--- linux-2.6.orig/fs/anon_inodes.c	2010-10-08 19:53:46.579023472 +0200
+++ linux-2.6/fs/anon_inodes.c	2010-10-08 19:54:36.841260935 +0200
@@ -193,6 +193,7 @@ static struct inode *anon_inode_mkinode(
 	if (!inode)
 		return ERR_PTR(-ENOMEM);
 
+	inode->i_ino = last_ino_get();
 	inode->i_fop = &anon_inode_fops;
 
 	inode->i_mapping->a_ops = &anon_aops;
Index: linux-2.6/fs/autofs4/inode.c
===================================================================
--- linux-2.6.orig/fs/autofs4/inode.c	2010-10-08 19:53:46.584004056 +0200
+++ linux-2.6/fs/autofs4/inode.c	2010-10-08 19:54:36.844257862 +0200
@@ -398,6 +398,7 @@ struct inode *autofs4_get_inode(struct s
 		inode->i_gid = sb->s_root->d_inode->i_gid;
 	}
 	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
+	inode->i_ino = last_ino_get();
 
 	if (S_ISDIR(inf->mode)) {
 		inode->i_nlink = 2;
Index: linux-2.6/fs/binfmt_misc.c
===================================================================
--- linux-2.6.orig/fs/binfmt_misc.c	2010-10-08 19:53:46.590254230 +0200
+++ linux-2.6/fs/binfmt_misc.c	2010-10-08 19:54:36.848004265 +0200
@@ -495,6 +495,7 @@ static struct inode *bm_get_inode(struct
 	struct inode * inode = new_inode(sb);
 
 	if (inode) {
+		inode->i_ino = last_ino_get();
 		inode->i_mode = mode;
 		inode->i_atime = inode->i_mtime = inode->i_ctime =
 			current_fs_time(inode->i_sb);
Index: linux-2.6/fs/configfs/inode.c
===================================================================
--- linux-2.6.orig/fs/configfs/inode.c	2010-10-08 19:53:46.596006221 +0200
+++ linux-2.6/fs/configfs/inode.c	2010-10-08 19:54:36.852004405 +0200
@@ -135,6 +135,7 @@ struct inode * configfs_new_inode(mode_t
 {
 	struct inode * inode = new_inode(configfs_sb);
 	if (inode) {
+		inode->i_ino = last_ino_get();
 		inode->i_mapping->a_ops = &configfs_aops;
 		mapping_new_set_bdi(inode->i_mapping,
 				&configfs_backing_dev_info);
Index: linux-2.6/fs/debugfs/inode.c
===================================================================
--- linux-2.6.orig/fs/debugfs/inode.c	2010-10-08 19:53:46.601005522 +0200
+++ linux-2.6/fs/debugfs/inode.c	2010-10-08 19:54:36.856005522 +0200
@@ -40,6 +40,7 @@ static struct inode *debugfs_get_inode(s
 	struct inode *inode = new_inode(sb);
 
 	if (inode) {
+		inode->i_ino = last_ino_get();
 		inode->i_mode = mode;
 		inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 		switch (mode & S_IFMT) {
Index: linux-2.6/fs/ext4/mballoc.c
===================================================================
--- linux-2.6.orig/fs/ext4/mballoc.c	2010-10-08 19:53:46.608006221 +0200
+++ linux-2.6/fs/ext4/mballoc.c	2010-10-08 19:54:36.863255767 +0200
@@ -2373,6 +2373,7 @@ static int ext4_mb_init_backend(struct s
 		printk(KERN_ERR "EXT4-fs: can't get new inode\n");
 		goto err_freesgi;
 	}
+	sbi->s_buddy_cache->i_ino = last_ino_get();
 	EXT4_I(sbi->s_buddy_cache)->i_disksize = 0;
 	for (i = 0; i < ngroups; i++) {
 		desc = ext4_get_group_desc(sb, i, NULL);
Index: linux-2.6/fs/freevxfs/vxfs_inode.c
===================================================================
--- linux-2.6.orig/fs/freevxfs/vxfs_inode.c	2010-10-08 19:53:46.613006291 +0200
+++ linux-2.6/fs/freevxfs/vxfs_inode.c	2010-10-08 19:54:36.868255697 +0200
@@ -260,6 +260,7 @@ vxfs_get_fake_inode(struct super_block *
 	struct inode			*ip = NULL;
 
 	if ((ip = new_inode(sbp))) {
+		ip->i_ino = last_ino_get();
 		vxfs_iinit(ip, vip);
 		ip->i_mapping->a_ops = &vxfs_aops;
 	}
Index: linux-2.6/fs/fuse/control.c
===================================================================
--- linux-2.6.orig/fs/fuse/control.c	2010-10-08 19:53:46.615011669 +0200
+++ linux-2.6/fs/fuse/control.c	2010-10-08 19:54:36.872256884 +0200
@@ -218,6 +218,7 @@ static struct dentry *fuse_ctl_add_dentr
 	if (!inode)
 		return NULL;
 
+	inode->i_ino = last_ino_get();
 	inode->i_mode = mode;
 	inode->i_uid = fc->user_id;
 	inode->i_gid = fc->group_id;
Index: linux-2.6/fs/hugetlbfs/inode.c
===================================================================
--- linux-2.6.orig/fs/hugetlbfs/inode.c	2010-10-08 19:53:46.619033250 +0200
+++ linux-2.6/fs/hugetlbfs/inode.c	2010-10-08 19:54:36.882256326 +0200
@@ -455,6 +455,7 @@ static struct inode *hugetlbfs_get_inode
 	inode = new_inode(sb);
 	if (inode) {
 		struct hugetlbfs_inode_info *info;
+		inode->i_ino = last_ino_get();
 		inode->i_mode = mode;
 		inode->i_uid = uid;
 		inode->i_gid = gid;
Index: linux-2.6/fs/ocfs2/dlmfs/dlmfs.c
===================================================================
--- linux-2.6.orig/fs/ocfs2/dlmfs/dlmfs.c	2010-10-08 19:53:46.623010272 +0200
+++ linux-2.6/fs/ocfs2/dlmfs/dlmfs.c	2010-10-08 19:54:36.886255906 +0200
@@ -400,6 +400,7 @@ static struct inode *dlmfs_get_root_inod
 	if (inode) {
 		ip = DLMFS_I(inode);
 
+		inode->i_ino = last_ino_get();
 		inode->i_mode = mode;
 		inode->i_uid = current_fsuid();
 		inode->i_gid = current_fsgid();
@@ -425,6 +426,7 @@ static struct inode *dlmfs_get_inode(str
 	if (!inode)
 		return NULL;
 
+	inode->i_ino = last_ino_get();
 	inode->i_mode = mode;
 	inode->i_uid = current_fsuid();
 	inode->i_gid = current_fsgid();
Index: linux-2.6/fs/pipe.c
===================================================================
--- linux-2.6.orig/fs/pipe.c	2010-10-08 19:53:46.629004475 +0200
+++ linux-2.6/fs/pipe.c	2010-10-08 19:54:36.893255906 +0200
@@ -954,6 +954,8 @@ static struct inode * get_pipe_inode(voi
 	if (!inode)
 		goto fail_inode;
 
+	inode->i_ino = last_ino_get();
+
 	pipe = alloc_pipe_info(inode);
 	if (!pipe)
 		goto fail_iput;
Index: linux-2.6/fs/proc/base.c
===================================================================
--- linux-2.6.orig/fs/proc/base.c	2010-10-08 19:53:46.634003986 +0200
+++ linux-2.6/fs/proc/base.c	2010-10-08 19:54:36.898253951 +0200
@@ -1600,6 +1600,7 @@ static struct inode *proc_pid_make_inode
 
 	/* Common stuff */
 	ei = PROC_I(inode);
+	inode->i_ino = last_ino_get();
 	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
 	inode->i_op = &proc_def_inode_operations;
 
@@ -2542,6 +2543,7 @@ static struct dentry *proc_base_instanti
 
 	/* Initialize the inode */
 	ei = PROC_I(inode);
+	inode->i_ino = last_ino_get();
 	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
 
 	/*
Index: linux-2.6/fs/proc/proc_sysctl.c
===================================================================
--- linux-2.6.orig/fs/proc/proc_sysctl.c	2010-10-08 19:53:46.639011878 +0200
+++ linux-2.6/fs/proc/proc_sysctl.c	2010-10-08 19:54:36.902270154 +0200
@@ -23,6 +23,8 @@ static struct inode *proc_sys_make_inode
 	if (!inode)
 		goto out;
 
+	inode->i_ino = last_ino_get();
+
 	sysctl_head_get(head);
 	ei = PROC_I(inode);
 	ei->sysctl = head;
Index: linux-2.6/fs/ramfs/inode.c
===================================================================
--- linux-2.6.orig/fs/ramfs/inode.c	2010-10-08 19:53:46.645254091 +0200
+++ linux-2.6/fs/ramfs/inode.c	2010-10-08 19:54:36.911256675 +0200
@@ -58,6 +58,7 @@ struct inode *ramfs_get_inode(struct sup
 	struct inode * inode = new_inode(sb);
 
 	if (inode) {
+		inode->i_ino = last_ino_get();
 		inode_init_owner(inode, dir, mode);
 		inode->i_mapping->a_ops = &ramfs_aops;
 		mapping_new_set_bdi(inode->i_mapping, &ramfs_backing_dev_info);
Index: linux-2.6/fs/xfs/linux-2.6/xfs_buf.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_buf.c	2010-10-08 19:53:46.652123695 +0200
+++ linux-2.6/fs/xfs/linux-2.6/xfs_buf.c	2010-10-08 19:54:36.918005662 +0200
@@ -1572,6 +1572,7 @@ xfs_mapping_buftarg(
 			XFS_BUFTARG_NAME(btp));
 		return ENOMEM;
 	}
+	inode->i_ino = last_ino_get();
 	inode->i_mode = S_IFBLK;
 	inode->i_bdev = bdev;
 	inode->i_rdev = bdev->bd_dev;
Index: linux-2.6/ipc/mqueue.c
===================================================================
--- linux-2.6.orig/ipc/mqueue.c	2010-10-08 19:53:46.656255837 +0200
+++ linux-2.6/ipc/mqueue.c	2010-10-08 19:54:36.923005872 +0200
@@ -116,6 +116,7 @@ static struct inode *mqueue_get_inode(st
 
 	inode = new_inode(sb);
 	if (inode) {
+		inode->i_ino = last_ino_get();
 		inode->i_mode = mode;
 		inode->i_uid = current_fsuid();
 		inode->i_gid = current_fsgid();
Index: linux-2.6/kernel/cgroup.c
===================================================================
--- linux-2.6.orig/kernel/cgroup.c	2010-10-08 19:53:46.662006011 +0200
+++ linux-2.6/kernel/cgroup.c	2010-10-08 19:54:36.930005802 +0200
@@ -778,6 +778,7 @@ static struct inode *cgroup_new_inode(mo
 	struct inode *inode = new_inode(sb);
 
 	if (inode) {
+		inode->i_ino = last_ino_get();
 		inode->i_mode = mode;
 		inode->i_uid = current_fsuid();
 		inode->i_gid = current_fsgid();
Index: linux-2.6/mm/shmem.c
===================================================================
--- linux-2.6.orig/mm/shmem.c	2010-10-08 19:53:46.665005872 +0200
+++ linux-2.6/mm/shmem.c	2010-10-08 19:54:36.934005453 +0200
@@ -1586,6 +1586,7 @@ static struct inode *shmem_get_inode(str
 
 	inode = new_inode(sb);
 	if (inode) {
+		inode->i_ino = last_ino_get();
 		inode_init_owner(inode, dir, mode);
 		inode->i_blocks = 0;
 		mapping_new_set_bdi(inode->i_mapping, &shmem_backing_dev_info);
Index: linux-2.6/net/socket.c
===================================================================
--- linux-2.6.orig/net/socket.c	2010-10-08 19:53:46.673283354 +0200
+++ linux-2.6/net/socket.c	2010-10-08 19:54:36.943255418 +0200
@@ -480,6 +480,7 @@ static struct socket *sock_alloc(void)
 	sock = SOCKET_I(inode);
 
 	kmemcheck_annotate_bitfield(sock, type);
+	inode->i_ino = last_ino_get();
 	inode->i_mode = S_IFSOCK | S_IRWXUGO;
 	inode->i_uid = current_fsuid();
 	inode->i_gid = current_fsgid();
Index: linux-2.6/net/sunrpc/rpc_pipe.c
===================================================================
--- linux-2.6.orig/net/sunrpc/rpc_pipe.c	2010-10-08 19:53:46.678255208 +0200
+++ linux-2.6/net/sunrpc/rpc_pipe.c	2010-10-08 19:54:36.953256186 +0200
@@ -453,6 +453,7 @@ rpc_get_inode(struct super_block *sb, um
 	struct inode *inode = new_inode(sb);
 	if (!inode)
 		return NULL;
+	inode->i_ino = last_ino_get();
 	inode->i_mode = mode;
 	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 	switch(mode & S_IFMT) {
Index: linux-2.6/security/inode.c
===================================================================
--- linux-2.6.orig/security/inode.c	2010-10-08 19:53:46.685256326 +0200
+++ linux-2.6/security/inode.c	2010-10-08 19:54:36.958024869 +0200
@@ -60,6 +60,7 @@ static struct inode *get_inode(struct su
 	struct inode *inode = new_inode(sb);
 
 	if (inode) {
+		inode->i_ino = last_ino_get();
 		inode->i_mode = mode;
 		inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 		switch (mode & S_IFMT) {
Index: linux-2.6/security/selinux/selinuxfs.c
===================================================================
--- linux-2.6.orig/security/selinux/selinuxfs.c	2010-10-08 19:53:46.691005662 +0200
+++ linux-2.6/security/selinux/selinuxfs.c	2010-10-08 19:54:36.965015091 +0200
@@ -785,6 +785,7 @@ static struct inode *sel_make_inode(stru
 	struct inode *ret = new_inode(sb);
 
 	if (ret) {
+		ret->i_ino = last_ino_get();
 		ret->i_mode = mode;
 		ret->i_atime = ret->i_mtime = ret->i_ctime = CURRENT_TIME;
 	}
