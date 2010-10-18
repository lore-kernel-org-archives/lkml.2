Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023Ab0JRGWV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 02:22:21 -0400
Received: from bld-mail18.adl2.internode.on.net ([150.101.137.103]:47105 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753732Ab0JRGWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 02:22:06 -0400
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 20/20] fs: do not assign default i_ino in new_inode
Date: Mon, 18 Oct 2010 17:20:56 +1100
Message-Id: <1287382856-29529-21-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287382856-29529-1-git-send-email-david@fromorbit.com>
References: <1287382856-29529-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

Instead of always assigning an increasing inode number in new_inode
move the call to assign it into those callers that actually need it.
For now callers that need it is estimated conservatively, that is
the call is added to all filesystems that do not assign an i_ino
by themselves.  For a few more filesystems we can avoid assigning
any inode number given that they aren't user visible, and for others
it could be done lazily when an inode number is actually needed,
but that's left for later patches.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 drivers/infiniband/hw/ipath/ipath_fs.c |    1 +
 drivers/infiniband/hw/qib/qib_fs.c     |    1 +
 drivers/misc/ibmasm/ibmasmfs.c         |    1 +
 drivers/oprofile/oprofilefs.c          |    1 +
 drivers/usb/core/inode.c               |    1 +
 drivers/usb/gadget/f_fs.c              |    1 +
 drivers/usb/gadget/inode.c             |    1 +
 fs/anon_inodes.c                       |    1 +
 fs/autofs4/inode.c                     |    1 +
 fs/binfmt_misc.c                       |    1 +
 fs/configfs/inode.c                    |    1 +
 fs/debugfs/inode.c                     |    1 +
 fs/ext4/mballoc.c                      |    1 +
 fs/freevxfs/vxfs_inode.c               |    1 +
 fs/fuse/control.c                      |    1 +
 fs/hugetlbfs/inode.c                   |    1 +
 fs/inode.c                             |    4 ++--
 fs/ocfs2/dlmfs/dlmfs.c                 |    2 ++
 fs/pipe.c                              |    2 ++
 fs/proc/base.c                         |    2 ++
 fs/proc/proc_sysctl.c                  |    2 ++
 fs/ramfs/inode.c                       |    1 +
 fs/xfs/linux-2.6/xfs_buf.c             |    1 +
 include/linux/fs.h                     |    1 +
 ipc/mqueue.c                           |    1 +
 kernel/cgroup.c                        |    1 +
 mm/shmem.c                             |    1 +
 net/socket.c                           |    1 +
 net/sunrpc/rpc_pipe.c                  |    1 +
 security/inode.c                       |    1 +
 security/selinux/selinuxfs.c           |    1 +
 31 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/ipath/ipath_fs.c b/drivers/infiniband/hw/ipath/ipath_fs.c
index 2fca708..3d7c1df 100644
--- a/drivers/infiniband/hw/ipath/ipath_fs.c
+++ b/drivers/infiniband/hw/ipath/ipath_fs.c
@@ -57,6 +57,7 @@ static int ipathfs_mknod(struct inode *dir, struct dentry *dentry,
 		goto bail;
 	}
 
+	inode->i_ino = get_next_ino();
 	inode->i_mode = mode;
 	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 	inode->i_private = data;
diff --git a/drivers/infiniband/hw/qib/qib_fs.c b/drivers/infiniband/hw/qib/qib_fs.c
index 9f989c0..0a8da2a 100644
--- a/drivers/infiniband/hw/qib/qib_fs.c
+++ b/drivers/infiniband/hw/qib/qib_fs.c
@@ -58,6 +58,7 @@ static int qibfs_mknod(struct inode *dir, struct dentry *dentry,
 		goto bail;
 	}
 
+	inode->i_ino = get_next_ino();
 	inode->i_mode = mode;
 	inode->i_uid = 0;
 	inode->i_gid = 0;
diff --git a/drivers/misc/ibmasm/ibmasmfs.c b/drivers/misc/ibmasm/ibmasmfs.c
index 8844a3f..1ebe935 100644
--- a/drivers/misc/ibmasm/ibmasmfs.c
+++ b/drivers/misc/ibmasm/ibmasmfs.c
@@ -146,6 +146,7 @@ static struct inode *ibmasmfs_make_inode(struct super_block *sb, int mode)
 	struct inode *ret = new_inode(sb);
 
 	if (ret) {
+		ret->i_ino = get_next_ino();
 		ret->i_mode = mode;
 		ret->i_atime = ret->i_mtime = ret->i_ctime = CURRENT_TIME;
 	}
diff --git a/drivers/oprofile/oprofilefs.c b/drivers/oprofile/oprofilefs.c
index 2766a6d..5acc58d 100644
--- a/drivers/oprofile/oprofilefs.c
+++ b/drivers/oprofile/oprofilefs.c
@@ -28,6 +28,7 @@ static struct inode *oprofilefs_get_inode(struct super_block *sb, int mode)
 	struct inode *inode = new_inode(sb);
 
 	if (inode) {
+		inode->i_ino = get_next_ino();
 		inode->i_mode = mode;
 		inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 	}
diff --git a/drivers/usb/core/inode.c b/drivers/usb/core/inode.c
index 095fa53..e2f63c0 100644
--- a/drivers/usb/core/inode.c
+++ b/drivers/usb/core/inode.c
@@ -276,6 +276,7 @@ static struct inode *usbfs_get_inode (struct super_block *sb, int mode, dev_t de
 	struct inode *inode = new_inode(sb);
 
 	if (inode) {
+		inode->i_ino = get_next_ino();
 		inode->i_mode = mode;
 		inode->i_uid = current_fsuid();
 		inode->i_gid = current_fsgid();
diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
index e4f5950..e093fd8 100644
--- a/drivers/usb/gadget/f_fs.c
+++ b/drivers/usb/gadget/f_fs.c
@@ -980,6 +980,7 @@ ffs_sb_make_inode(struct super_block *sb, void *data,
 	if (likely(inode)) {
 		struct timespec current_time = CURRENT_TIME;
 
+		inode->i_ino	 = usbfs_get_inode();
 		inode->i_mode    = perms->mode;
 		inode->i_uid     = perms->uid;
 		inode->i_gid     = perms->gid;
diff --git a/drivers/usb/gadget/inode.c b/drivers/usb/gadget/inode.c
index fc35406..136e78d 100644
--- a/drivers/usb/gadget/inode.c
+++ b/drivers/usb/gadget/inode.c
@@ -1994,6 +1994,7 @@ gadgetfs_make_inode (struct super_block *sb,
 	struct inode *inode = new_inode (sb);
 
 	if (inode) {
+		inode->i_ino = get_next_ino();
 		inode->i_mode = mode;
 		inode->i_uid = default_uid;
 		inode->i_gid = default_gid;
diff --git a/fs/anon_inodes.c b/fs/anon_inodes.c
index 451be78..327c484 100644
--- a/fs/anon_inodes.c
+++ b/fs/anon_inodes.c
@@ -189,6 +189,7 @@ static struct inode *anon_inode_mkinode(void)
 	if (!inode)
 		return ERR_PTR(-ENOMEM);
 
+	inode->i_ino = get_next_ino();
 	inode->i_fop = &anon_inode_fops;
 
 	inode->i_mapping->a_ops = &anon_aops;
diff --git a/fs/autofs4/inode.c b/fs/autofs4/inode.c
index 821b2b9..ac87e49 100644
--- a/fs/autofs4/inode.c
+++ b/fs/autofs4/inode.c
@@ -398,6 +398,7 @@ struct inode *autofs4_get_inode(struct super_block *sb,
 		inode->i_gid = sb->s_root->d_inode->i_gid;
 	}
 	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
+	inode->i_ino = get_next_ino();
 
 	if (S_ISDIR(inf->mode)) {
 		inode->i_nlink = 2;
diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index fd0cc0b..37c4aef 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -495,6 +495,7 @@ static struct inode *bm_get_inode(struct super_block *sb, int mode)
 	struct inode * inode = new_inode(sb);
 
 	if (inode) {
+		inode->i_ino = get_next_ino();
 		inode->i_mode = mode;
 		inode->i_atime = inode->i_mtime = inode->i_ctime =
 			current_fs_time(inode->i_sb);
diff --git a/fs/configfs/inode.c b/fs/configfs/inode.c
index cf78d44..253476d 100644
--- a/fs/configfs/inode.c
+++ b/fs/configfs/inode.c
@@ -135,6 +135,7 @@ struct inode * configfs_new_inode(mode_t mode, struct configfs_dirent * sd)
 {
 	struct inode * inode = new_inode(configfs_sb);
 	if (inode) {
+		inode->i_ino = get_next_ino();
 		inode->i_mapping->a_ops = &configfs_aops;
 		inode->i_mapping->backing_dev_info = &configfs_backing_dev_info;
 		inode->i_op = &configfs_inode_operations;
diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index 30a87b3..a4ed838 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -40,6 +40,7 @@ static struct inode *debugfs_get_inode(struct super_block *sb, int mode, dev_t d
 	struct inode *inode = new_inode(sb);
 
 	if (inode) {
+		inode->i_ino = get_next_ino();
 		inode->i_mode = mode;
 		inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 		switch (mode & S_IFMT) {
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 4b4ad4b..96e2bf3 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2373,6 +2373,7 @@ static int ext4_mb_init_backend(struct super_block *sb)
 		printk(KERN_ERR "EXT4-fs: can't get new inode\n");
 		goto err_freesgi;
 	}
+	sbi->s_buddy_cache->i_ino = get_next_ino();
 	EXT4_I(sbi->s_buddy_cache)->i_disksize = 0;
 	for (i = 0; i < ngroups; i++) {
 		desc = ext4_get_group_desc(sb, i, NULL);
diff --git a/fs/freevxfs/vxfs_inode.c b/fs/freevxfs/vxfs_inode.c
index 79d1b4e..8c04eac 100644
--- a/fs/freevxfs/vxfs_inode.c
+++ b/fs/freevxfs/vxfs_inode.c
@@ -260,6 +260,7 @@ vxfs_get_fake_inode(struct super_block *sbp, struct vxfs_inode_info *vip)
 	struct inode			*ip = NULL;
 
 	if ((ip = new_inode(sbp))) {
+		ip->i_ino = get_next_ino();
 		vxfs_iinit(ip, vip);
 		ip->i_mapping->a_ops = &vxfs_aops;
 	}
diff --git a/fs/fuse/control.c b/fs/fuse/control.c
index 3773fd6..3f67de2 100644
--- a/fs/fuse/control.c
+++ b/fs/fuse/control.c
@@ -218,6 +218,7 @@ static struct dentry *fuse_ctl_add_dentry(struct dentry *parent,
 	if (!inode)
 		return NULL;
 
+	inode->i_ino = get_next_ino();
 	inode->i_mode = mode;
 	inode->i_uid = fc->user_id;
 	inode->i_gid = fc->group_id;
diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 6e5bd42..b83f9ff 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -455,6 +455,7 @@ static struct inode *hugetlbfs_get_inode(struct super_block *sb, uid_t uid,
 	inode = new_inode(sb);
 	if (inode) {
 		struct hugetlbfs_inode_info *info;
+		inode->i_ino = get_next_ino();
 		inode->i_mode = mode;
 		inode->i_uid = uid;
 		inode->i_gid = gid;
diff --git a/fs/inode.c b/fs/inode.c
index adcd1f3..6a9b1ea 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -811,7 +811,7 @@ repeat:
 #define LAST_INO_BATCH 1024
 static DEFINE_PER_CPU(unsigned int, last_ino);
 
-static unsigned int get_next_ino(void)
+unsigned int get_next_ino(void)
 {
 	unsigned int *p = &get_cpu_var(last_ino);
 	unsigned int res = *p;
@@ -829,6 +829,7 @@ static unsigned int get_next_ino(void)
 	put_cpu_var(last_ino);
 	return res;
 }
+EXPORT_SYMBOL(get_next_ino);
 
 /**
  *	new_inode 	- obtain an inode
@@ -852,7 +853,6 @@ struct inode *new_inode(struct super_block *sb)
 		 * set the inode state before we make the inode accessible to
 		 * the outside world.
 		 */
-		inode->i_ino = get_next_ino();
 		inode->i_state = 0;
 		inode_sb_list_add(inode);
 	}
diff --git a/fs/ocfs2/dlmfs/dlmfs.c b/fs/ocfs2/dlmfs/dlmfs.c
index c2903b8..124d400 100644
--- a/fs/ocfs2/dlmfs/dlmfs.c
+++ b/fs/ocfs2/dlmfs/dlmfs.c
@@ -400,6 +400,7 @@ static struct inode *dlmfs_get_root_inode(struct super_block *sb)
 	if (inode) {
 		ip = DLMFS_I(inode);
 
+		inode->i_ino = get_next_ino();
 		inode->i_mode = mode;
 		inode->i_uid = current_fsuid();
 		inode->i_gid = current_fsgid();
@@ -425,6 +426,7 @@ static struct inode *dlmfs_get_inode(struct inode *parent,
 	if (!inode)
 		return NULL;
 
+	inode->i_ino = get_next_ino();
 	inode->i_mode = mode;
 	inode->i_uid = current_fsuid();
 	inode->i_gid = current_fsgid();
diff --git a/fs/pipe.c b/fs/pipe.c
index 279eef9..acd453b 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -954,6 +954,8 @@ static struct inode * get_pipe_inode(void)
 	if (!inode)
 		goto fail_inode;
 
+	inode->i_ino = get_next_ino();
+
 	pipe = alloc_pipe_info(inode);
 	if (!pipe)
 		goto fail_iput;
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 8e4adda..d2efd66 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1600,6 +1600,7 @@ static struct inode *proc_pid_make_inode(struct super_block * sb, struct task_st
 
 	/* Common stuff */
 	ei = PROC_I(inode);
+	inode->i_ino = get_next_ino();
 	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
 	inode->i_op = &proc_def_inode_operations;
 
@@ -2542,6 +2543,7 @@ static struct dentry *proc_base_instantiate(struct inode *dir,
 
 	/* Initialize the inode */
 	ei = PROC_I(inode);
+	inode->i_ino = get_next_ino();
 	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
 
 	/*
diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index 5be436e..f473a7b 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -23,6 +23,8 @@ static struct inode *proc_sys_make_inode(struct super_block *sb,
 	if (!inode)
 		goto out;
 
+	inode->i_ino = get_next_ino();
+
 	sysctl_head_get(head);
 	ei = PROC_I(inode);
 	ei->sysctl = head;
diff --git a/fs/ramfs/inode.c b/fs/ramfs/inode.c
index a5ebae7..67fadb1 100644
--- a/fs/ramfs/inode.c
+++ b/fs/ramfs/inode.c
@@ -58,6 +58,7 @@ struct inode *ramfs_get_inode(struct super_block *sb,
 	struct inode * inode = new_inode(sb);
 
 	if (inode) {
+		inode->i_ino = get_next_ino();
 		inode_init_owner(inode, dir, mode);
 		inode->i_mapping->a_ops = &ramfs_aops;
 		inode->i_mapping->backing_dev_info = &ramfs_backing_dev_info;
diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index 286e36e..a47e6db 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -1572,6 +1572,7 @@ xfs_mapping_buftarg(
 			XFS_BUFTARG_NAME(btp));
 		return ENOMEM;
 	}
+	inode->i_ino = get_next_ino();
 	inode->i_mode = S_IFBLK;
 	inode->i_bdev = bdev;
 	inode->i_rdev = bdev->bd_dev;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index abdb756..213272b 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2189,6 +2189,7 @@ extern struct inode * iget_locked(struct super_block *, unsigned long);
 extern int insert_inode_locked4(struct inode *, unsigned long, int (*test)(struct inode *, void *), void *);
 extern int insert_inode_locked(struct inode *);
 extern void unlock_new_inode(struct inode *);
+extern unsigned int get_next_ino(void);
 
 extern void iref(struct inode *inode);
 extern void iget_failed(struct inode *);
diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index d53a2c1..a72f3c5 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -116,6 +116,7 @@ static struct inode *mqueue_get_inode(struct super_block *sb,
 
 	inode = new_inode(sb);
 	if (inode) {
+		inode->i_ino = get_next_ino();
 		inode->i_mode = mode;
 		inode->i_uid = current_fsuid();
 		inode->i_gid = current_fsgid();
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index c9483d8..e28f8e5 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -778,6 +778,7 @@ static struct inode *cgroup_new_inode(mode_t mode, struct super_block *sb)
 	struct inode *inode = new_inode(sb);
 
 	if (inode) {
+		inode->i_ino = get_next_ino();
 		inode->i_mode = mode;
 		inode->i_uid = current_fsuid();
 		inode->i_gid = current_fsgid();
diff --git a/mm/shmem.c b/mm/shmem.c
index 419de2c..504ae65 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1586,6 +1586,7 @@ static struct inode *shmem_get_inode(struct super_block *sb, const struct inode
 
 	inode = new_inode(sb);
 	if (inode) {
+		inode->i_ino = get_next_ino();
 		inode_init_owner(inode, dir, mode);
 		inode->i_blocks = 0;
 		inode->i_mapping->backing_dev_info = &shmem_backing_dev_info;
diff --git a/net/socket.c b/net/socket.c
index 715ca57..56114ec 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -480,6 +480,7 @@ static struct socket *sock_alloc(void)
 	sock = SOCKET_I(inode);
 
 	kmemcheck_annotate_bitfield(sock, type);
+	inode->i_ino = get_next_ino();
 	inode->i_mode = S_IFSOCK | S_IRWXUGO;
 	inode->i_uid = current_fsuid();
 	inode->i_gid = current_fsgid();
diff --git a/net/sunrpc/rpc_pipe.c b/net/sunrpc/rpc_pipe.c
index 8c8eef2..70da9a4 100644
--- a/net/sunrpc/rpc_pipe.c
+++ b/net/sunrpc/rpc_pipe.c
@@ -453,6 +453,7 @@ rpc_get_inode(struct super_block *sb, umode_t mode)
 	struct inode *inode = new_inode(sb);
 	if (!inode)
 		return NULL;
+	inode->i_ino = get_next_ino();
 	inode->i_mode = mode;
 	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 	switch(mode & S_IFMT) {
diff --git a/security/inode.c b/security/inode.c
index 8c777f0..d3321c2 100644
--- a/security/inode.c
+++ b/security/inode.c
@@ -60,6 +60,7 @@ static struct inode *get_inode(struct super_block *sb, int mode, dev_t dev)
 	struct inode *inode = new_inode(sb);
 
 	if (inode) {
+		inode->i_ino = get_next_ino();
 		inode->i_mode = mode;
 		inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 		switch (mode & S_IFMT) {
diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index 79a1bb6..9e98cdc 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -785,6 +785,7 @@ static struct inode *sel_make_inode(struct super_block *sb, int mode)
 	struct inode *ret = new_inode(sb);
 
 	if (ret) {
+		ret->i_ino = get_next_ino();
 		ret->i_mode = mode;
 		ret->i_atime = ret->i_mtime = ret->i_ctime = CURRENT_TIME;
 	}
-- 
1.7.1

