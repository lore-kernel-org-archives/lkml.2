Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425Ab0K0K1K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 05:27:10 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:26161 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753309Ab0K0K1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 05:27:03 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAO1p8Ex5Lcx2/2dsb2JhbACjC3K9doVHBIph
Message-Id: <ab093b7ba81b55510c73f7b9014a231fb4aba47d.1290852960.git.npiggin@kernel.dk>
In-Reply-To: <cover.1290852958.git.npiggin@kernel.dk>
References: <cover.1290852958.git.npiggin@kernel.dk>
From: Nick Piggin <npiggin@kernel.dk>
Date: Sat, 27 Nov 2010 20:45:11 +1100
Subject: [PATCH 41/46] fs: provide simple rcu-walk ACL implementation
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This simple implementation just checks for no ACLs on the inode, and
if so, then the rcu-walk may proceed, otherwise fail it.

This could easily be extended to put acls under RCU and check them
under seqlock, if need be. But this implementation is enough to show
the rcu-walk aware permissions code for path lookups is working, and
will handle cases where there are no ACLs or ACLs in just the final
element.

Convert tmpfs, ext2, btrfs. Each of these uses acl/permission code in
a different way, so convert them all to provide templates and proof of
concept.

Signed-off-by: Nick Piggin <npiggin@kernel.dk>
---
 fs/btrfs/acl.c              |   19 ++++++++++++-------
 fs/btrfs/ctree.h            |    4 ++--
 fs/btrfs/inode.c            |   14 +++++++-------
 fs/ext2/acl.c               |   11 +++++++++--
 fs/ext2/acl.h               |    8 ++++----
 fs/ext2/file.c              |    2 +-
 fs/ext2/namei.c             |    4 ++--
 fs/ext3/acl.c               |   11 +++++++++--
 fs/ext3/acl.h               |    8 ++++----
 fs/ext3/file.c              |    2 +-
 fs/ext3/namei.c             |    4 ++--
 fs/ext4/acl.c               |   11 +++++++++--
 fs/ext4/acl.h               |    4 ++--
 fs/ext4/file.c              |    2 +-
 fs/ext4/namei.c             |    4 ++--
 fs/generic_acl.c            |   20 ++++++++++++++++++++
 fs/xfs/linux-2.6/xfs_acl.c  |    8 +++++++-
 fs/xfs/linux-2.6/xfs_iops.c |    8 ++++----
 fs/xfs/xfs_acl.h            |    4 ++--
 include/linux/generic_acl.h |    1 +
 include/linux/posix_acl.h   |   19 +++++++++++++++++++
 mm/shmem.c                  |    6 +++---
 22 files changed, 123 insertions(+), 51 deletions(-)

diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
index 2222d16..c03c753 100644
--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -185,18 +185,23 @@ static int btrfs_xattr_acl_set(struct dentry *dentry, const char *name,
 	return ret;
 }
 
-int btrfs_check_acl(struct inode *inode, int mask)
+int btrfs_check_acl_rcu(struct inode *inode, int mask, unsigned int flags)
 {
 	struct posix_acl *acl;
 	int error = -EAGAIN;
 
-	acl = btrfs_get_acl(inode, ACL_TYPE_ACCESS);
+	if (flags & IPERM_FLAG_RCU) {
+		if (!negative_cached_acl(inode, ACL_TYPE_ACCESS))
+			return -ECHILD;
+	} else {
+		acl = btrfs_get_acl(inode, ACL_TYPE_ACCESS);
 
-	if (IS_ERR(acl))
-		return PTR_ERR(acl);
-	if (acl) {
-		error = posix_acl_permission(inode, acl, mask);
-		posix_acl_release(acl);
+		if (IS_ERR(acl))
+			return PTR_ERR(acl);
+		if (acl) {
+			error = posix_acl_permission(inode, acl, mask);
+			posix_acl_release(acl);
+		}
 	}
 
 	return error;
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 8db9234..403b069 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2544,9 +2544,9 @@ int btrfs_sync_fs(struct super_block *sb, int wait);
 
 /* acl.c */
 #ifdef CONFIG_BTRFS_FS_POSIX_ACL
-int btrfs_check_acl(struct inode *inode, int mask);
+int btrfs_check_acl_rcu(struct inode *inode, int mask, unsigned int flags);
 #else
-#define btrfs_check_acl NULL
+#define btrfs_check_acl_rcu NULL
 #endif
 int btrfs_init_acl(struct btrfs_trans_handle *trans,
 		   struct inode *inode, struct inode *dir);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index aab3087..c9844e1 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7033,11 +7033,11 @@ static int btrfs_set_page_dirty(struct page *page)
 	return __set_page_dirty_nobuffers(page);
 }
 
-static int btrfs_permission(struct inode *inode, int mask)
+static int btrfs_permission_rcu(struct inode *inode, int mask, unsigned int flags)
 {
 	if ((BTRFS_I(inode)->flags & BTRFS_INODE_READONLY) && (mask & MAY_WRITE))
 		return -EACCES;
-	return generic_permission(inode, mask, btrfs_check_acl);
+	return generic_permission_rcu(inode, mask, flags, btrfs_check_acl_rcu);
 }
 
 static const struct inode_operations btrfs_dir_inode_operations = {
@@ -7056,11 +7056,11 @@ static const struct inode_operations btrfs_dir_inode_operations = {
 	.getxattr	= btrfs_getxattr,
 	.listxattr	= btrfs_listxattr,
 	.removexattr	= btrfs_removexattr,
-	.permission	= btrfs_permission,
+	.permission_rcu	= btrfs_permission_rcu,
 };
 static const struct inode_operations btrfs_dir_ro_inode_operations = {
 	.lookup		= btrfs_lookup,
-	.permission	= btrfs_permission,
+	.permission_rcu	= btrfs_permission_rcu,
 };
 
 static const struct file_operations btrfs_dir_file_operations = {
@@ -7129,14 +7129,14 @@ static const struct inode_operations btrfs_file_inode_operations = {
 	.getxattr	= btrfs_getxattr,
 	.listxattr      = btrfs_listxattr,
 	.removexattr	= btrfs_removexattr,
-	.permission	= btrfs_permission,
+	.permission_rcu	= btrfs_permission_rcu,
 	.fallocate	= btrfs_fallocate,
 	.fiemap		= btrfs_fiemap,
 };
 static const struct inode_operations btrfs_special_inode_operations = {
 	.getattr	= btrfs_getattr,
 	.setattr	= btrfs_setattr,
-	.permission	= btrfs_permission,
+	.permission_rcu	= btrfs_permission_rcu,
 	.setxattr	= btrfs_setxattr,
 	.getxattr	= btrfs_getxattr,
 	.listxattr	= btrfs_listxattr,
@@ -7146,7 +7146,7 @@ static const struct inode_operations btrfs_symlink_inode_operations = {
 	.readlink	= generic_readlink,
 	.follow_link	= page_follow_link_light,
 	.put_link	= page_put_link,
-	.permission	= btrfs_permission,
+	.permission_rcu	= btrfs_permission_rcu,
 	.setxattr	= btrfs_setxattr,
 	.getxattr	= btrfs_getxattr,
 	.listxattr	= btrfs_listxattr,
diff --git a/fs/ext2/acl.c b/fs/ext2/acl.c
index 2bcc043..43196d7 100644
--- a/fs/ext2/acl.c
+++ b/fs/ext2/acl.c
@@ -232,10 +232,17 @@ ext2_set_acl(struct inode *inode, int type, struct posix_acl *acl)
 }
 
 int
-ext2_check_acl(struct inode *inode, int mask)
+ext2_check_acl_rcu(struct inode *inode, int mask, unsigned int flags)
 {
-	struct posix_acl *acl = ext2_get_acl(inode, ACL_TYPE_ACCESS);
+	struct posix_acl *acl;
+
+	if (flags & IPERM_FLAG_RCU) {
+		if (!negative_cached_acl(inode, ACL_TYPE_ACCESS))
+			return -ECHILD;
+		return -EAGAIN;
+	}
 
+	acl = ext2_get_acl(inode, ACL_TYPE_ACCESS);
 	if (IS_ERR(acl))
 		return PTR_ERR(acl);
 	if (acl) {
diff --git a/fs/ext2/acl.h b/fs/ext2/acl.h
index 3ff6cbb..fb49393 100644
--- a/fs/ext2/acl.h
+++ b/fs/ext2/acl.h
@@ -54,15 +54,15 @@ static inline int ext2_acl_count(size_t size)
 #ifdef CONFIG_EXT2_FS_POSIX_ACL
 
 /* acl.c */
-extern int ext2_check_acl (struct inode *, int);
+extern int ext2_check_acl_rcu(struct inode *, int, unsigned int);
 extern int ext2_acl_chmod (struct inode *);
 extern int ext2_init_acl (struct inode *, struct inode *);
 
 #else
 #include <linux/sched.h>
-#define ext2_check_acl	NULL
-#define ext2_get_acl	NULL
-#define ext2_set_acl	NULL
+#define ext2_check_acl_rcu	NULL
+#define ext2_get_acl		NULL
+#define ext2_set_acl		NULL
 
 static inline int
 ext2_acl_chmod (struct inode *inode)
diff --git a/fs/ext2/file.c b/fs/ext2/file.c
index 49eec94..a34fc5a 100644
--- a/fs/ext2/file.c
+++ b/fs/ext2/file.c
@@ -102,6 +102,6 @@ const struct inode_operations ext2_file_inode_operations = {
 	.removexattr	= generic_removexattr,
 #endif
 	.setattr	= ext2_setattr,
-	.check_acl	= ext2_check_acl,
+	.check_acl_rcu	= ext2_check_acl_rcu,
 	.fiemap		= ext2_fiemap,
 };
diff --git a/fs/ext2/namei.c b/fs/ext2/namei.c
index f8aecd2..5366e02 100644
--- a/fs/ext2/namei.c
+++ b/fs/ext2/namei.c
@@ -417,7 +417,7 @@ const struct inode_operations ext2_dir_inode_operations = {
 	.removexattr	= generic_removexattr,
 #endif
 	.setattr	= ext2_setattr,
-	.check_acl	= ext2_check_acl,
+	.check_acl_rcu	= ext2_check_acl_rcu,
 };
 
 const struct inode_operations ext2_special_inode_operations = {
@@ -428,5 +428,5 @@ const struct inode_operations ext2_special_inode_operations = {
 	.removexattr	= generic_removexattr,
 #endif
 	.setattr	= ext2_setattr,
-	.check_acl	= ext2_check_acl,
+	.check_acl_rcu	= ext2_check_acl_rcu,
 };
diff --git a/fs/ext3/acl.c b/fs/ext3/acl.c
index 8a11fe2..cff7c13 100644
--- a/fs/ext3/acl.c
+++ b/fs/ext3/acl.c
@@ -240,10 +240,17 @@ ext3_set_acl(handle_t *handle, struct inode *inode, int type,
 }
 
 int
-ext3_check_acl(struct inode *inode, int mask)
+ext3_check_acl_rcu(struct inode *inode, int mask, unsigned int flags)
 {
-	struct posix_acl *acl = ext3_get_acl(inode, ACL_TYPE_ACCESS);
+	struct posix_acl *acl;
+
+	if (flags & IPERM_FLAG_RCU) {
+		if (!negative_cached_acl(inode, ACL_TYPE_ACCESS))
+			return -ECHILD;
+		return -EAGAIN;
+	}
 
+	acl = ext3_get_acl(inode, ACL_TYPE_ACCESS);
 	if (IS_ERR(acl))
 		return PTR_ERR(acl);
 	if (acl) {
diff --git a/fs/ext3/acl.h b/fs/ext3/acl.h
index 5973346..f2536e6 100644
--- a/fs/ext3/acl.h
+++ b/fs/ext3/acl.h
@@ -54,13 +54,13 @@ static inline int ext3_acl_count(size_t size)
 #ifdef CONFIG_EXT3_FS_POSIX_ACL
 
 /* acl.c */
-extern int ext3_check_acl (struct inode *, int);
-extern int ext3_acl_chmod (struct inode *);
-extern int ext3_init_acl (handle_t *, struct inode *, struct inode *);
+extern int ext3_check_acl_rcu(struct inode *, int, unsigned int);
+extern int ext3_acl_chmod(struct inode *);
+extern int ext3_init_acl(handle_t *, struct inode *, struct inode *);
 
 #else  /* CONFIG_EXT3_FS_POSIX_ACL */
 #include <linux/sched.h>
-#define ext3_check_acl NULL
+#define ext3_check_acl_rcu NULL
 
 static inline int
 ext3_acl_chmod(struct inode *inode)
diff --git a/fs/ext3/file.c b/fs/ext3/file.c
index f55df0e..74e5ef7 100644
--- a/fs/ext3/file.c
+++ b/fs/ext3/file.c
@@ -79,7 +79,7 @@ const struct inode_operations ext3_file_inode_operations = {
 	.listxattr	= ext3_listxattr,
 	.removexattr	= generic_removexattr,
 #endif
-	.check_acl	= ext3_check_acl,
+	.check_acl_rcu	= ext3_check_acl_rcu,
 	.fiemap		= ext3_fiemap,
 };
 
diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index bce9dce..9b10438 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -2464,7 +2464,7 @@ const struct inode_operations ext3_dir_inode_operations = {
 	.listxattr	= ext3_listxattr,
 	.removexattr	= generic_removexattr,
 #endif
-	.check_acl	= ext3_check_acl,
+	.check_acl_rcu	= ext3_check_acl_rcu,
 };
 
 const struct inode_operations ext3_special_inode_operations = {
@@ -2475,5 +2475,5 @@ const struct inode_operations ext3_special_inode_operations = {
 	.listxattr	= ext3_listxattr,
 	.removexattr	= generic_removexattr,
 #endif
-	.check_acl	= ext3_check_acl,
+	.check_acl_rcu	= ext3_check_acl_rcu,
 };
diff --git a/fs/ext4/acl.c b/fs/ext4/acl.c
index 5e2ed45..ebc7127 100644
--- a/fs/ext4/acl.c
+++ b/fs/ext4/acl.c
@@ -238,10 +238,17 @@ ext4_set_acl(handle_t *handle, struct inode *inode, int type,
 }
 
 int
-ext4_check_acl(struct inode *inode, int mask)
+ext4_check_acl_rcu(struct inode *inode, int mask, unsigned int flags)
 {
-	struct posix_acl *acl = ext4_get_acl(inode, ACL_TYPE_ACCESS);
+	struct posix_acl *acl;
+
+	if (flags & IPERM_FLAG_RCU) {
+		if (!negative_cached_acl(inode, ACL_TYPE_ACCESS))
+			return -ECHILD;
+		return -EAGAIN;
+	}
 
+	acl = ext4_get_acl(inode, ACL_TYPE_ACCESS);
 	if (IS_ERR(acl))
 		return PTR_ERR(acl);
 	if (acl) {
diff --git a/fs/ext4/acl.h b/fs/ext4/acl.h
index 9d843d5..71e8da7 100644
--- a/fs/ext4/acl.h
+++ b/fs/ext4/acl.h
@@ -54,13 +54,13 @@ static inline int ext4_acl_count(size_t size)
 #ifdef CONFIG_EXT4_FS_POSIX_ACL
 
 /* acl.c */
-extern int ext4_check_acl(struct inode *, int);
+extern int ext4_check_acl_rcu(struct inode *, int, unsigned int);
 extern int ext4_acl_chmod(struct inode *);
 extern int ext4_init_acl(handle_t *, struct inode *, struct inode *);
 
 #else  /* CONFIG_EXT4_FS_POSIX_ACL */
 #include <linux/sched.h>
-#define ext4_check_acl NULL
+#define ext4_check_acl_rcu NULL
 
 static inline int
 ext4_acl_chmod(struct inode *inode)
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 5a5c55d..f6be0af 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -200,7 +200,7 @@ const struct inode_operations ext4_file_inode_operations = {
 	.listxattr	= ext4_listxattr,
 	.removexattr	= generic_removexattr,
 #endif
-	.check_acl	= ext4_check_acl,
+	.check_acl_rcu	= ext4_check_acl_rcu,
 	.fallocate	= ext4_fallocate,
 	.fiemap		= ext4_fiemap,
 };
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 92203b8..6145f55 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2511,7 +2511,7 @@ const struct inode_operations ext4_dir_inode_operations = {
 	.listxattr	= ext4_listxattr,
 	.removexattr	= generic_removexattr,
 #endif
-	.check_acl	= ext4_check_acl,
+	.check_acl_rcu	= ext4_check_acl_rcu,
 	.fiemap         = ext4_fiemap,
 };
 
@@ -2523,5 +2523,5 @@ const struct inode_operations ext4_special_inode_operations = {
 	.listxattr	= ext4_listxattr,
 	.removexattr	= generic_removexattr,
 #endif
-	.check_acl	= ext4_check_acl,
+	.check_acl_rcu	= ext4_check_acl_rcu,
 };
diff --git a/fs/generic_acl.c b/fs/generic_acl.c
index 6bc9e3a..3b250e5 100644
--- a/fs/generic_acl.c
+++ b/fs/generic_acl.c
@@ -190,6 +190,26 @@ generic_acl_chmod(struct inode *inode)
 }
 
 int
+generic_check_acl_rcu(struct inode *inode, int mask, unsigned int flags)
+{
+	if (flags & IPERM_FLAG_RCU) {
+		if (!negative_cached_acl(inode, ACL_TYPE_ACCESS))
+			return -ECHILD;
+	} else {
+		struct posix_acl *acl;
+
+		acl = get_cached_acl(inode, ACL_TYPE_ACCESS);
+
+		if (acl) {
+			int error = posix_acl_permission(inode, acl, mask);
+			posix_acl_release(acl);
+			return error;
+		}
+	}
+	return -EAGAIN;
+}
+
+int
 generic_check_acl(struct inode *inode, int mask)
 {
 	struct posix_acl *acl = get_cached_acl(inode, ACL_TYPE_ACCESS);
diff --git a/fs/xfs/linux-2.6/xfs_acl.c b/fs/xfs/linux-2.6/xfs_acl.c
index b277186..70053f6 100644
--- a/fs/xfs/linux-2.6/xfs_acl.c
+++ b/fs/xfs/linux-2.6/xfs_acl.c
@@ -219,7 +219,7 @@ xfs_set_acl(struct inode *inode, int type, struct posix_acl *acl)
 }
 
 int
-xfs_check_acl(struct inode *inode, int mask)
+xfs_check_acl_rcu(struct inode *inode, int mask, unsigned int flags)
 {
 	struct xfs_inode *ip = XFS_I(inode);
 	struct posix_acl *acl;
@@ -234,6 +234,12 @@ xfs_check_acl(struct inode *inode, int mask)
 	if (!XFS_IFORK_Q(ip))
 		return -EAGAIN;
 
+	if (flags & IPERM_FLAG_RCU) {
+		if (!negative_cached_acl(inode, ACL_TYPE_ACCESS))
+			return -ECHILD;
+		return -EAGAIN;
+	}
+
 	acl = xfs_get_acl(inode, ACL_TYPE_ACCESS);
 	if (IS_ERR(acl))
 		return PTR_ERR(acl);
diff --git a/fs/xfs/linux-2.6/xfs_iops.c b/fs/xfs/linux-2.6/xfs_iops.c
index 94d5fd6..c8751c7 100644
--- a/fs/xfs/linux-2.6/xfs_iops.c
+++ b/fs/xfs/linux-2.6/xfs_iops.c
@@ -643,7 +643,7 @@ xfs_vn_fiemap(
 }
 
 static const struct inode_operations xfs_inode_operations = {
-	.check_acl		= xfs_check_acl,
+	.check_acl_rcu		= xfs_check_acl_rcu,
 	.getattr		= xfs_vn_getattr,
 	.setattr		= xfs_vn_setattr,
 	.setxattr		= generic_setxattr,
@@ -670,7 +670,7 @@ static const struct inode_operations xfs_dir_inode_operations = {
 	.rmdir			= xfs_vn_unlink,
 	.mknod			= xfs_vn_mknod,
 	.rename			= xfs_vn_rename,
-	.check_acl		= xfs_check_acl,
+	.check_acl_rcu		= xfs_check_acl_rcu,
 	.getattr		= xfs_vn_getattr,
 	.setattr		= xfs_vn_setattr,
 	.setxattr		= generic_setxattr,
@@ -695,7 +695,7 @@ static const struct inode_operations xfs_dir_ci_inode_operations = {
 	.rmdir			= xfs_vn_unlink,
 	.mknod			= xfs_vn_mknod,
 	.rename			= xfs_vn_rename,
-	.check_acl		= xfs_check_acl,
+	.check_acl_rcu		= xfs_check_acl_rcu,
 	.getattr		= xfs_vn_getattr,
 	.setattr		= xfs_vn_setattr,
 	.setxattr		= generic_setxattr,
@@ -708,7 +708,7 @@ static const struct inode_operations xfs_symlink_inode_operations = {
 	.readlink		= generic_readlink,
 	.follow_link		= xfs_vn_follow_link,
 	.put_link		= xfs_vn_put_link,
-	.check_acl		= xfs_check_acl,
+	.check_acl_rcu		= xfs_check_acl_rcu,
 	.getattr		= xfs_vn_getattr,
 	.setattr		= xfs_vn_setattr,
 	.setxattr		= generic_setxattr,
diff --git a/fs/xfs/xfs_acl.h b/fs/xfs/xfs_acl.h
index 0135e2a..6560d56 100644
--- a/fs/xfs/xfs_acl.h
+++ b/fs/xfs/xfs_acl.h
@@ -42,7 +42,7 @@ struct xfs_acl {
 #define SGI_ACL_DEFAULT_SIZE	(sizeof(SGI_ACL_DEFAULT)-1)
 
 #ifdef CONFIG_XFS_POSIX_ACL
-extern int xfs_check_acl(struct inode *inode, int mask);
+extern int xfs_check_acl_rcu(struct inode *inode, int mask, unsigned int flags);
 extern struct posix_acl *xfs_get_acl(struct inode *inode, int type);
 extern int xfs_inherit_acl(struct inode *inode, struct posix_acl *default_acl);
 extern int xfs_acl_chmod(struct inode *inode);
@@ -52,7 +52,7 @@ extern int posix_acl_default_exists(struct inode *inode);
 extern const struct xattr_handler xfs_xattr_acl_access_handler;
 extern const struct xattr_handler xfs_xattr_acl_default_handler;
 #else
-# define xfs_check_acl					NULL
+# define xfs_check_acl_rcu					NULL
 # define xfs_get_acl(inode, type)			NULL
 # define xfs_inherit_acl(inode, default_acl)		0
 # define xfs_acl_chmod(inode)				0
diff --git a/include/linux/generic_acl.h b/include/linux/generic_acl.h
index 574bea4..b57e89c 100644
--- a/include/linux/generic_acl.h
+++ b/include/linux/generic_acl.h
@@ -11,5 +11,6 @@ extern const struct xattr_handler generic_acl_default_handler;
 int generic_acl_init(struct inode *, struct inode *);
 int generic_acl_chmod(struct inode *);
 int generic_check_acl(struct inode *inode, int mask);
+int generic_check_acl_rcu(struct inode *inode, int mask, unsigned int flags);
 
 #endif /* LINUX_GENERIC_ACL_H */
diff --git a/include/linux/posix_acl.h b/include/linux/posix_acl.h
index 6760816..d68283a 100644
--- a/include/linux/posix_acl.h
+++ b/include/linux/posix_acl.h
@@ -108,6 +108,25 @@ static inline struct posix_acl *get_cached_acl(struct inode *inode, int type)
 	return acl;
 }
 
+static inline int negative_cached_acl(struct inode *inode, int type)
+{
+	struct posix_acl **p, *acl;
+	switch (type) {
+	case ACL_TYPE_ACCESS:
+		p = &inode->i_acl;
+		break;
+	case ACL_TYPE_DEFAULT:
+		p = &inode->i_default_acl;
+		break;
+	default:
+		BUG();
+	}
+	acl = ACCESS_ONCE(*p);
+	if (acl)
+		return 0;
+	return 1;
+}
+
 static inline void set_cached_acl(struct inode *inode,
 				  int type,
 				  struct posix_acl *acl)
diff --git a/mm/shmem.c b/mm/shmem.c
index 5ee67c9..8f40d25 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2485,7 +2485,7 @@ static const struct inode_operations shmem_inode_operations = {
 	.getxattr	= generic_getxattr,
 	.listxattr	= generic_listxattr,
 	.removexattr	= generic_removexattr,
-	.check_acl	= generic_check_acl,
+	.check_acl_rcu	= generic_check_acl_rcu,
 #endif
 
 };
@@ -2508,7 +2508,7 @@ static const struct inode_operations shmem_dir_inode_operations = {
 	.getxattr	= generic_getxattr,
 	.listxattr	= generic_listxattr,
 	.removexattr	= generic_removexattr,
-	.check_acl	= generic_check_acl,
+	.check_acl_rcu	= generic_check_acl_rcu,
 #endif
 };
 
@@ -2519,7 +2519,7 @@ static const struct inode_operations shmem_special_inode_operations = {
 	.getxattr	= generic_getxattr,
 	.listxattr	= generic_listxattr,
 	.removexattr	= generic_removexattr,
-	.check_acl	= generic_check_acl,
+	.check_acl_rcu	= generic_check_acl_rcu,
 #endif
 };
 
-- 
1.7.1

