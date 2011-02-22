Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754953Ab1BVSLZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 13:11:25 -0500
Received: from smtp.outflux.net ([198.145.64.163]:59799 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754751Ab1BVSLX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 13:11:23 -0500
From: Kees Cook <kees.cook@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Eugene Teo <eugeneteo@kernel.sg>, Ralph Campbell <infinipath@qlogic.com>,
        Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Miklos Szeredi <miklos@szeredi.hu>,
        "J. Bruce Fields" <bfields@fieldses.org>, Neil Brown <neilb@suse.de>,
        Matthew Wilcox <matthew@wil.cx>, James Morris <jmorris@namei.org>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Eric Paris <eparis@parisplace.org>, Nick Piggin <npiggin@kernel.dk>,
        Arnd Bergmann <arnd@arndb.de>, Ian Campbell <ian.campbell@citrix.com>,
        Jarkko Sakkinen <ext-jarkko.2.sakkinen@nokia.com>,
        Tejun Heo <tj@kernel.org>, Casey Schaufler <casey@schaufler-ca.com>
Subject: [PATCH 1/2] fs: pass root inode mode to simple_fill_super
Date: Tue, 22 Feb 2011 10:09:57 -0800
Message-Id: <1298398198-18482-1-git-send-email-kees.cook@canonical.com>
X-Mailer: git-send-email 1.7.2.3
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There was no way to specify the mode of the root directory of filesystems
created with simple_fill_super.

Signed-off-by: Kees Cook <kees.cook@canonical.com>
---
 drivers/infiniband/hw/ipath/ipath_fs.c |    3 ++-
 drivers/infiniband/hw/qib/qib_fs.c     |    3 ++-
 drivers/xen/xenfs/super.c              |    3 ++-
 fs/binfmt_misc.c                       |    3 ++-
 fs/debugfs/inode.c                     |    3 ++-
 fs/fuse/control.c                      |    3 ++-
 fs/libfs.c                             |    4 ++--
 fs/nfsd/nfsctl.c                       |    3 ++-
 include/linux/fs.h                     |    3 ++-
 security/inode.c                       |    3 ++-
 security/selinux/selinuxfs.c           |    3 ++-
 security/smack/smackfs.c               |    3 ++-
 12 files changed, 24 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/hw/ipath/ipath_fs.c b/drivers/infiniband/hw/ipath/ipath_fs.c
index 31ae1b1..991aa4f 100644
--- a/drivers/infiniband/hw/ipath/ipath_fs.c
+++ b/drivers/infiniband/hw/ipath/ipath_fs.c
@@ -336,7 +336,8 @@ static int ipathfs_fill_super(struct super_block *sb, void *data,
 		{""},
 	};
 
-	ret = simple_fill_super(sb, IPATHFS_MAGIC, files);
+	ret = simple_fill_super(sb, IPATHFS_MAGIC, files,
+				S_IWUSR | S_IRUGO | S_IXUGO);
 	if (ret) {
 		printk(KERN_ERR "simple_fill_super failed: %d\n", ret);
 		goto bail;
diff --git a/drivers/infiniband/hw/qib/qib_fs.c b/drivers/infiniband/hw/qib/qib_fs.c
index df7fa25..de01b23 100644
--- a/drivers/infiniband/hw/qib/qib_fs.c
+++ b/drivers/infiniband/hw/qib/qib_fs.c
@@ -530,7 +530,8 @@ static int qibfs_fill_super(struct super_block *sb, void *data, int silent)
 		{""},
 	};
 
-	ret = simple_fill_super(sb, QIBFS_MAGIC, files);
+	ret = simple_fill_super(sb, QIBFS_MAGIC, files,
+				S_IWUSR | S_IRUGO | S_IXUGO);
 	if (ret) {
 		printk(KERN_ERR "simple_fill_super failed: %d\n", ret);
 		goto bail;
diff --git a/drivers/xen/xenfs/super.c b/drivers/xen/xenfs/super.c
index 1aa3897..d5d65cf 100644
--- a/drivers/xen/xenfs/super.c
+++ b/drivers/xen/xenfs/super.c
@@ -89,7 +89,8 @@ static int xenfs_fill_super(struct super_block *sb, void *data, int silent)
 	};
 	int rc;
 
-	rc = simple_fill_super(sb, XENFS_SUPER_MAGIC, xenfs_files);
+	rc = simple_fill_super(sb, XENFS_SUPER_MAGIC, xenfs_files,
+			       S_IWUSR | S_IRUGO | S_IXUGO);
 	if (rc < 0)
 		return rc;
 
diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index 1befe2e..6ad4874 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -700,7 +700,8 @@ static int bm_fill_super(struct super_block * sb, void * data, int silent)
 		[3] = {"register", &bm_register_operations, S_IWUSR},
 		/* last one */ {""}
 	};
-	int err = simple_fill_super(sb, 0x42494e4d, bm_files);
+	int err = simple_fill_super(sb, 0x42494e4d, bm_files,
+				    S_IWUSR | S_IRUGO | S_IXUGO);
 	if (!err)
 		sb->s_op = &s_ops;
 	return err;
diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index 37a8ca7..3cb33c3 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -132,7 +132,8 @@ static int debug_fill_super(struct super_block *sb, void *data, int silent)
 {
 	static struct tree_descr debug_files[] = {{""}};
 
-	return simple_fill_super(sb, DEBUGFS_MAGIC, debug_files);
+	return simple_fill_super(sb, DEBUGFS_MAGIC, debug_files,
+				 S_IWUSR | S_IRUGO | S_IXUGO);
 }
 
 static struct dentry *debug_mount(struct file_system_type *fs_type,
diff --git a/fs/fuse/control.c b/fs/fuse/control.c
index 85542a7..80bbb66 100644
--- a/fs/fuse/control.c
+++ b/fs/fuse/control.c
@@ -302,7 +302,8 @@ static int fuse_ctl_fill_super(struct super_block *sb, void *data, int silent)
 	struct fuse_conn *fc;
 	int err;
 
-	err = simple_fill_super(sb, FUSE_CTL_SUPER_MAGIC, &empty_descr);
+	err = simple_fill_super(sb, FUSE_CTL_SUPER_MAGIC, &empty_descr,
+				S_IWUSR | S_IRUGO | S_IXUGO);
 	if (err)
 		return err;
 
diff --git a/fs/libfs.c b/fs/libfs.c
index c88eab5..ea4d695 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -463,7 +463,7 @@ int simple_write_end(struct file *file, struct address_space *mapping,
  * to pass it an appropriate max_reserved value to avoid collisions.
  */
 int simple_fill_super(struct super_block *s, unsigned long magic,
-		      struct tree_descr *files)
+		      struct tree_descr *files, umode_t mode)
 {
 	struct inode *inode;
 	struct dentry *root;
@@ -484,7 +484,7 @@ int simple_fill_super(struct super_block *s, unsigned long magic,
 	 * entry at index 1
 	 */
 	inode->i_ino = 1;
-	inode->i_mode = S_IFDIR | 0755;
+	inode->i_mode = (mode & (S_IRWXUGO | S_ISVTX)) | S_IFDIR;
 	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 	inode->i_op = &simple_dir_inode_operations;
 	inode->i_fop = &simple_dir_operations;
diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index 33b3e2b..709ca56 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -1404,7 +1404,8 @@ static int nfsd_fill_super(struct super_block * sb, void * data, int silent)
 #endif
 		/* last one */ {""}
 	};
-	return simple_fill_super(sb, 0x6e667364, nfsd_files);
+	return simple_fill_super(sb, 0x6e667364, nfsd_files,
+				 S_IWUSR | S_IRUGO | S_IXUGO);
 }
 
 static struct dentry *nfsd_mount(struct file_system_type *fs_type,
diff --git a/include/linux/fs.h b/include/linux/fs.h
index bd32159..d4dd31e 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2435,7 +2435,8 @@ extern const struct file_operations simple_dir_operations;
 extern const struct inode_operations simple_dir_inode_operations;
 struct tree_descr { char *name; const struct file_operations *ops; int mode; };
 struct dentry *d_alloc_name(struct dentry *, const char *);
-extern int simple_fill_super(struct super_block *, unsigned long, struct tree_descr *);
+extern int simple_fill_super(struct super_block *, unsigned long,
+			     struct tree_descr *, umode_t mode);
 extern int simple_pin_fs(struct file_system_type *, struct vfsmount **mount, int *count);
 extern void simple_release_fs(struct vfsmount **mount, int *count);
 
diff --git a/security/inode.c b/security/inode.c
index c4df2fb..d85e416 100644
--- a/security/inode.c
+++ b/security/inode.c
@@ -128,7 +128,8 @@ static int fill_super(struct super_block *sb, void *data, int silent)
 {
 	static struct tree_descr files[] = {{""}};
 
-	return simple_fill_super(sb, SECURITYFS_MAGIC, files);
+	return simple_fill_super(sb, SECURITYFS_MAGIC, files,
+				 S_IWUSR | S_IRUGO | S_IXUGO);
 }
 
 static struct dentry *get_sb(struct file_system_type *fs_type,
diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index ea39cb7..26f9c025 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -1792,7 +1792,8 @@ static int sel_fill_super(struct super_block *sb, void *data, int silent)
 		[SEL_POLICY] = {"policy", &sel_policy_ops, S_IRUSR},
 		/* last one */ {""}
 	};
-	ret = simple_fill_super(sb, SELINUX_MAGIC, selinux_files);
+	ret = simple_fill_super(sb, SELINUX_MAGIC, selinux_files,
+				S_IWUSR | S_IRUGO | S_IXUGO);
 	if (ret)
 		goto err;
 
diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index 362d5ed..788fac4 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -1323,7 +1323,8 @@ static int smk_fill_super(struct super_block *sb, void *data, int silent)
 		/* last one */ {""}
 	};
 
-	rc = simple_fill_super(sb, SMACK_MAGIC, smack_files);
+	rc = simple_fill_super(sb, SMACK_MAGIC, smack_files,
+			       S_IWUSR | S_IRUGO | S_IXUGO);
 	if (rc != 0) {
 		printk(KERN_ERR "%s failed %d while creating inodes\n",
 			__func__, rc);
-- 
1.7.2.3

