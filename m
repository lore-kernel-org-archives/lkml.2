Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463Ab0HZLUl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 07:20:41 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:49885 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240Ab0HZLUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 07:20:09 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V2 6/6] fs/9p: Add access = client option to opt in acl evaluation.
Date: Thu, 26 Aug 2010 16:49:58 +0530
Message-Id: <1282821598-16472-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1282821598-16472-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1282821598-16472-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 Documentation/filesystems/9p.txt |    4 +++-
 fs/9p/acl.c                      |   37 ++++++++++++++++++++++++++++++++++++-
 fs/9p/fid.c                      |    1 +
 fs/9p/v9fs.c                     |   12 ++++++++++++
 fs/9p/v9fs.h                     |    8 ++++++--
 fs/9p/vfs_inode.c                |   14 ++++++++++----
 fs/9p/vfs_super.c                |   16 +++++++++++-----
 7 files changed, 79 insertions(+), 13 deletions(-)

diff --git a/Documentation/filesystems/9p.txt b/Documentation/filesystems/9p.txt
index c0236e7..1a48155 100644
--- a/Documentation/filesystems/9p.txt
+++ b/Documentation/filesystems/9p.txt
@@ -111,7 +111,7 @@ OPTIONS
   		This can be used to share devices/named pipes/sockets between
 		hosts.  This functionality will be expanded in later versions.
 
-  access	there are three access modes.
+  access	there are four access modes.
 			user  = if a user tries to access a file on v9fs
 			        filesystem for the first time, v9fs sends an
 			        attach command (Tattach) for that user.
@@ -120,6 +120,8 @@ OPTIONS
 				the files on the mounted filesystem
 			any   = v9fs does single attach and performs all
 				operations as one user
+			client = ACL based access check on the 9p client
+			         side for access validation
 
   cachetag	cache tag to use the specified persistent cache.
 		cache tags for existing cache sessions can be listed at
diff --git a/fs/9p/acl.c b/fs/9p/acl.c
index e7982a1..96fa9fc 100644
--- a/fs/9p/acl.c
+++ b/fs/9p/acl.c
@@ -21,6 +21,7 @@
 #include <linux/posix_acl_xattr.h>
 #include "xattr.h"
 #include "v9fs_vfs.h"
+#include "v9fs.h"
 
 
 static struct posix_acl *__v9fs_get_acl(struct p9_fid *fid, char *name)
@@ -85,7 +86,18 @@ static struct posix_acl *v9fs_get_cached_acl(struct inode *inode, int type)
 
 int v9fs_check_acl(struct inode *inode, int mask)
 {
-	struct posix_acl *acl = v9fs_get_cached_acl(inode, ACL_TYPE_ACCESS);
+	struct posix_acl *acl;
+	struct v9fs_session_info *v9ses;
+
+	v9ses = v9fs_inode2v9ses(inode);
+	if ((v9ses->flags & V9FS_ACCESS_MASK) != V9FS_ACCESS_CLIENT) {
+		/*
+		 * On access = client mode get the acl
+		 * values from the server
+		 */
+		return 0;
+	}
+	acl = v9fs_get_cached_acl(inode, ACL_TYPE_ACCESS);
 
 	if (IS_ERR(acl))
 		return PTR_ERR(acl);
@@ -208,7 +220,13 @@ static size_t v9fs_xattr_list_acl_access(struct dentry *dentry, char *list,
 					 size_t list_len, const char *name,
 					 size_t name_len, int type)
 {
+	struct v9fs_session_info *v9ses;
 	const size_t size = sizeof(POSIX_ACL_XATTR_ACCESS);
+
+	v9ses = v9fs_inode2v9ses(dentry->d_inode);
+	if ((v9ses->flags & V9FS_ACCESS_MASK) != V9FS_ACCESS_CLIENT)
+		return 0;
+
 	if (list && size <= list_len)
 		memcpy(list, POSIX_ACL_XATTR_ACCESS, size);
 	return size;
@@ -218,7 +236,13 @@ static size_t v9fs_xattr_list_acl_default(struct dentry *dentry, char *list,
 					  size_t list_len, const char *name,
 					  size_t name_len, int type)
 {
+	struct v9fs_session_info *v9ses;
 	const size_t size = sizeof(POSIX_ACL_XATTR_DEFAULT);
+
+	v9ses = v9fs_inode2v9ses(dentry->d_inode);
+	if ((v9ses->flags & V9FS_ACCESS_MASK) != V9FS_ACCESS_CLIENT)
+		return 0;
+
 	if (list && size <= list_len)
 		memcpy(list, POSIX_ACL_XATTR_DEFAULT, size);
 	return size;
@@ -227,12 +251,17 @@ static size_t v9fs_xattr_list_acl_default(struct dentry *dentry, char *list,
 static int v9fs_xattr_get_acl(struct dentry *dentry, const char *name,
 			      void *buffer, size_t size, int type)
 {
+	struct v9fs_session_info *v9ses;
 	struct posix_acl *acl;
 	int error;
 
 	if (strcmp(name, "") != 0)
 		return -EINVAL;
 
+	v9ses = v9fs_inode2v9ses(dentry->d_inode);
+	if ((v9ses->flags & V9FS_ACCESS_MASK) != V9FS_ACCESS_CLIENT)
+		return -EOPNOTSUPP;
+
 	acl = v9fs_get_cached_acl(dentry->d_inode, type);
 	if (IS_ERR(acl))
 		return PTR_ERR(acl);
@@ -250,10 +279,16 @@ static int v9fs_xattr_set_acl(struct dentry *dentry, const char *name,
 {
 	int retval;
 	struct posix_acl *acl;
+	struct v9fs_session_info *v9ses;
 	struct inode *inode = dentry->d_inode;
 
 	if (strcmp(name, "") != 0)
 		return -EINVAL;
+
+	v9ses = v9fs_inode2v9ses(dentry->d_inode);
+	if ((v9ses->flags & V9FS_ACCESS_MASK) != V9FS_ACCESS_CLIENT)
+		return -EOPNOTSUPP;
+
 	if (S_ISLNK(inode->i_mode))
 		return -EOPNOTSUPP;
 	if (!is_owner_or_cap(inode))
diff --git a/fs/9p/fid.c b/fs/9p/fid.c
index 3585636..4876a0e 100644
--- a/fs/9p/fid.c
+++ b/fs/9p/fid.c
@@ -149,6 +149,7 @@ struct p9_fid *v9fs_fid_lookup(struct dentry *dentry)
 	switch (access) {
 	case V9FS_ACCESS_SINGLE:
 	case V9FS_ACCESS_USER:
+	case V9FS_ACCESS_CLIENT:
 		uid = current_fsuid();
 		any = 0;
 		break;
diff --git a/fs/9p/v9fs.c b/fs/9p/v9fs.c
index 38dc0e0..735ff25 100644
--- a/fs/9p/v9fs.c
+++ b/fs/9p/v9fs.c
@@ -193,6 +193,8 @@ static int v9fs_parse_options(struct v9fs_session_info *v9ses, char *opts)
 				v9ses->flags |= V9FS_ACCESS_USER;
 			else if (strcmp(s, "any") == 0)
 				v9ses->flags |= V9FS_ACCESS_ANY;
+			else if (strcmp(s, "client") == 0)
+				v9ses->flags |= V9FS_ACCESS_CLIENT;
 			else {
 				v9ses->flags |= V9FS_ACCESS_SINGLE;
 				v9ses->uid = simple_strtoul(s, &e, 10);
@@ -278,6 +280,16 @@ struct p9_fid *v9fs_session_init(struct v9fs_session_info *v9ses,
 
 	v9ses->maxdata = v9ses->clnt->msize - P9_IOHDRSZ;
 
+	if (!v9fs_proto_dotl(v9ses) &&
+	    ((v9ses->flags & V9FS_ACCESS_MASK) == V9FS_ACCESS_CLIENT)) {
+		/*
+		 * We support ACCESS_CLIENT only for dotl.
+		 * Fall back to ACCESS_USER
+		 */
+		v9ses->flags &= ~V9FS_ACCESS_MASK;
+		v9ses->flags |= V9FS_ACCESS_USER;
+	}
+	/*FIXME !! */
 	/* for legacy mode, fall back to V9FS_ACCESS_ANY */
 	if (!(v9fs_proto_dotu(v9ses) || v9fs_proto_dotl(v9ses)) &&
 		((v9ses->flags&V9FS_ACCESS_MASK) == V9FS_ACCESS_USER)) {
diff --git a/fs/9p/v9fs.h b/fs/9p/v9fs.h
index 4c963c9..8bb7792 100644
--- a/fs/9p/v9fs.h
+++ b/fs/9p/v9fs.h
@@ -33,13 +33,17 @@
  *
  * Session flags reflect options selected by users at mount time
  */
+#define	V9FS_ACCESS_ANY (V9FS_ACCESS_SINGLE | \
+			 V9FS_ACCESS_USER |   \
+			 V9FS_ACCESS_CLIENT)
+#define V9FS_ACCESS_MASK V9FS_ACCESS_ANY
+
 enum p9_session_flags {
 	V9FS_PROTO_2000U	= 0x01,
 	V9FS_PROTO_2000L	= 0x02,
 	V9FS_ACCESS_SINGLE	= 0x04,
 	V9FS_ACCESS_USER	= 0x08,
-	V9FS_ACCESS_ANY		= 0x0C,
-	V9FS_ACCESS_MASK	= 0x0C,
+	V9FS_ACCESS_CLIENT	= 0x10
 };
 
 /* possible values of ->cache */
diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 3e365f6..9040db5 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -500,10 +500,16 @@ v9fs_inode_dotl(struct v9fs_session_info *v9ses, struct p9_fid *fid,
 	v9fs_vcookie_set_qid(ret, &st->qid);
 	v9fs_cache_inode_get_cookie(ret);
 #endif
-	err = v9fs_get_acl(ret, fid);
-	if (err) {
-		iput(ret);
-		goto error;
+	if ((v9ses->flags & V9FS_ACCESS_MASK) == V9FS_ACCESS_CLIENT) {
+		/*
+		 * On access = client mode get the acl
+		 * values from the server
+		 */
+		err = v9fs_get_acl(ret, fid);
+		if (err) {
+			iput(ret);
+			goto error;
+		}
 	}
 	kfree(st);
 	return ret;
diff --git a/fs/9p/vfs_super.c b/fs/9p/vfs_super.c
index a120a48..e15e9ac 100644
--- a/fs/9p/vfs_super.c
+++ b/fs/9p/vfs_super.c
@@ -90,7 +90,8 @@ v9fs_fill_super(struct super_block *sb, struct v9fs_session_info *v9ses,
 	    MS_NOATIME;
 
 #ifdef CONFIG_9P_FS_POSIX_ACL
-	sb->s_flags |= MS_POSIXACL;
+	if ((v9ses->flags & V9FS_ACCESS_MASK) == V9FS_ACCESS_CLIENT)
+		sb->s_flags |= MS_POSIXACL;
 #endif
 
 	save_mount_options(sb, data);
@@ -178,10 +179,15 @@ static int v9fs_get_sb(struct file_system_type *fs_type, int flags,
 		p9stat_free(st);
 		kfree(st);
 	}
-	retval = v9fs_get_acl(inode, fid);
-	if (retval)
-		goto release_sb;
-
+	if ((v9ses->flags & V9FS_ACCESS_MASK) == V9FS_ACCESS_CLIENT) {
+		/*
+		 * On access = client mode get the acl
+		 * values from the server
+		 */
+		retval = v9fs_get_acl(inode, fid);
+		if (retval)
+			goto release_sb;
+	}
 	v9fs_fid_add(root, fid);
 
 	P9_DPRINTK(P9_DEBUG_VFS, " simple set mount, return 0\n");
-- 
1.7.0.4

