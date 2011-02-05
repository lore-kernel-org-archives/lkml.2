Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612Ab1BERsa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 12:48:30 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:55574 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436Ab1BERrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 12:47:21 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [RFC PATCH -V2 13/17] fs/9p: Add inode hashing
Date: Sat,  5 Feb 2011 23:16:41 +0530
Message-Id: <1296928005-9529-14-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1296928005-9529-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1296928005-9529-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We didn't add the inode to inode hash in 9p. We need to do that
to get sync to work, otherwise __mark_inode_dirty will not
add the inode to super block's dirty list.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/9p/acl.c            |    2 +-
 fs/9p/v9fs_vfs.h       |    2 +
 fs/9p/vfs_inode.c      |  121 +++++++++++++++++++++++++++++------------------
 fs/9p/vfs_inode_dotl.c |   69 ++++++++++++++++++---------
 4 files changed, 124 insertions(+), 70 deletions(-)

diff --git a/fs/9p/acl.c b/fs/9p/acl.c
index 02a2cf6..5b314c7 100644
--- a/fs/9p/acl.c
+++ b/fs/9p/acl.c
@@ -21,8 +21,8 @@
 #include <linux/posix_acl_xattr.h>
 #include "xattr.h"
 #include "acl.h"
-#include "v9fs_vfs.h"
 #include "v9fs.h"
+#include "v9fs_vfs.h"
 
 static struct posix_acl *__v9fs_get_acl(struct p9_fid *fid, char *name)
 {
diff --git a/fs/9p/v9fs_vfs.h b/fs/9p/v9fs_vfs.h
index 276ad44..ce9ba20 100644
--- a/fs/9p/v9fs_vfs.h
+++ b/fs/9p/v9fs_vfs.h
@@ -54,6 +54,8 @@ void v9fs_destroy_inode(struct inode *inode);
 #endif
 
 struct inode *v9fs_get_inode(struct super_block *sb, int mode);
+int v9fs_init_inode(struct v9fs_session_info *v9ses,
+		    struct inode *inode, int mode);
 void v9fs_evict_inode(struct inode *inode);
 ino_t v9fs_qid2ino(struct p9_qid *qid);
 void v9fs_stat2inode(struct p9_wstat *, struct inode *, struct super_block *);
diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index ecd2c6f..472d447 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -243,26 +243,10 @@ void v9fs_destroy_inode(struct inode *inode)
 }
 #endif
 
-/**
- * v9fs_get_inode - helper function to setup an inode
- * @sb: superblock
- * @mode: mode to setup inode with
- *
- */
-
-struct inode *v9fs_get_inode(struct super_block *sb, int mode)
+int v9fs_init_inode(struct v9fs_session_info *v9ses,
+		    struct inode *inode, int mode)
 {
-	int err;
-	struct inode *inode;
-	struct v9fs_session_info *v9ses = sb->s_fs_info;
-
-	P9_DPRINTK(P9_DEBUG_VFS, "super block: %p mode: %o\n", sb, mode);
-
-	inode = new_inode(sb);
-	if (!inode) {
-		P9_EPRINTK(KERN_WARNING, "Problem allocating inode\n");
-		return ERR_PTR(-ENOMEM);
-	}
+	int err = 0;
 
 	inode_init_owner(inode, NULL, mode);
 	inode->i_blocks = 0;
@@ -305,7 +289,6 @@ struct inode *v9fs_get_inode(struct super_block *sb, int mode)
 		}
 
 		break;
-
 	case S_IFLNK:
 		if (!v9fs_proto_dotu(v9ses) && !v9fs_proto_dotl(v9ses)) {
 			P9_DPRINTK(P9_DEBUG_ERROR, "extended modes used with "
@@ -341,12 +324,37 @@ struct inode *v9fs_get_inode(struct super_block *sb, int mode)
 		err = -EINVAL;
 		goto error;
 	}
+error:
+	return err;
 
-	return inode;
+}
 
-error:
-	iput(inode);
-	return ERR_PTR(err);
+/**
+ * v9fs_get_inode - helper function to setup an inode
+ * @sb: superblock
+ * @mode: mode to setup inode with
+ *
+ */
+
+struct inode *v9fs_get_inode(struct super_block *sb, int mode)
+{
+	int err;
+	struct inode *inode;
+	struct v9fs_session_info *v9ses = sb->s_fs_info;
+
+	P9_DPRINTK(P9_DEBUG_VFS, "super block: %p mode: %o\n", sb, mode);
+
+	inode = new_inode(sb);
+	if (!inode) {
+		P9_EPRINTK(KERN_WARNING, "Problem allocating inode\n");
+		return ERR_PTR(-ENOMEM);
+	}
+	err = v9fs_init_inode(v9ses, inode, mode);
+	if (err) {
+		iput(inode);
+		return ERR_PTR(err);
+	}
+	return inode;
 }
 
 /*
@@ -423,39 +431,60 @@ void v9fs_evict_inode(struct inode *inode)
 	}
 }
 
-struct inode *
-v9fs_inode(struct v9fs_session_info *v9ses, struct p9_fid *fid,
-	struct super_block *sb)
+static struct inode *v9fs_qid_iget(struct super_block *sb,
+				   struct p9_qid *qid,
+				   struct p9_wstat *st)
 {
-	int err, umode;
-	struct inode *ret = NULL;
-	struct p9_wstat *st;
-
-	st = p9_client_stat(fid);
-	if (IS_ERR(st))
-		return ERR_CAST(st);
+	int retval, umode;
+	unsigned long i_ino;
+	struct inode *inode;
+	struct v9fs_session_info *v9ses = sb->s_fs_info;
 
+	i_ino = v9fs_qid2ino(qid);
+	inode = iget_locked(sb, i_ino);
+	if (!inode)
+		return ERR_PTR(-ENOMEM);
+	if (!(inode->i_state & I_NEW))
+		return inode;
+	/*
+	 * initialize the inode with the stat info
+	 * FIXME!! we may need support for stale inodes
+	 * later.
+	 */
 	umode = p9mode2unixmode(v9ses, st->mode);
-	ret = v9fs_get_inode(sb, umode);
-	if (IS_ERR(ret)) {
-		err = PTR_ERR(ret);
+	retval = v9fs_init_inode(v9ses, inode, umode);
+	if (retval)
 		goto error;
-	}
-
-	v9fs_stat2inode(st, ret, sb);
-	ret->i_ino = v9fs_qid2ino(&st->qid);
 
+	v9fs_stat2inode(st, inode, sb);
 #ifdef CONFIG_9P_FSCACHE
 	v9fs_vcookie_set_qid(ret, &st->qid);
-	v9fs_cache_inode_get_cookie(ret);
+	v9fs_cache_inode_get_cookie(inode);
 #endif
-	p9stat_free(st);
-	kfree(st);
-	return ret;
+	unlock_new_inode(inode);
+	return inode;
 error:
+	unlock_new_inode(inode);
+	iput(inode);
+	return ERR_PTR(retval);
+
+}
+
+struct inode *
+v9fs_inode(struct v9fs_session_info *v9ses, struct p9_fid *fid,
+	   struct super_block *sb)
+{
+	struct p9_wstat *st;
+	struct inode *inode = NULL;
+
+	st = p9_client_stat(fid);
+	if (IS_ERR(st))
+		return ERR_CAST(st);
+
+	inode = v9fs_qid_iget(sb, &st->qid, st);
 	p9stat_free(st);
 	kfree(st);
-	return ERR_PTR(err);
+	return inode;
 }
 
 /**
diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
index d5aa986..a11e04a 100644
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -86,40 +86,63 @@ static struct dentry *v9fs_dentry_from_dir_inode(struct inode *inode)
 	return dentry;
 }
 
+static struct inode *v9fs_qid_iget_dotl(struct super_block *sb,
+					struct p9_qid *qid,
+					struct p9_fid *fid,
+					struct p9_stat_dotl *st)
+{
+	int retval;
+	unsigned long i_ino;
+	struct inode *inode;
+	struct v9fs_session_info *v9ses = sb->s_fs_info;
+
+	i_ino = v9fs_qid2ino(qid);
+	inode = iget_locked(sb, i_ino);
+	if (!inode)
+		return ERR_PTR(-ENOMEM);
+	if (!(inode->i_state & I_NEW))
+		return inode;
+	/*
+	 * initialize the inode with the stat info
+	 * FIXME!! we may need support for stale inodes
+	 * later.
+	 */
+	retval = v9fs_init_inode(v9ses, inode, st->st_mode);
+	if (retval)
+		goto error;
+
+	v9fs_stat2inode_dotl(st, inode);
+#ifdef CONFIG_9P_FSCACHE
+	v9fs_vcookie_set_qid(inode, &st->qid);
+	v9fs_cache_inode_get_cookie(inode);
+#endif
+	retval = v9fs_get_acl(inode, fid);
+	if (retval)
+		goto error;
+
+	unlock_new_inode(inode);
+	return inode;
+error:
+	unlock_new_inode(inode);
+	iput(inode);
+	return ERR_PTR(retval);
+
+}
+
 struct inode *
 v9fs_inode_dotl(struct v9fs_session_info *v9ses, struct p9_fid *fid,
 	struct super_block *sb)
 {
-	struct inode *ret = NULL;
-	int err;
 	struct p9_stat_dotl *st;
+	struct inode *inode = NULL;
 
 	st = p9_client_getattr_dotl(fid, P9_STATS_BASIC);
 	if (IS_ERR(st))
 		return ERR_CAST(st);
 
-	ret = v9fs_get_inode(sb, st->st_mode);
-	if (IS_ERR(ret)) {
-		err = PTR_ERR(ret);
-		goto error;
-	}
-
-	v9fs_stat2inode_dotl(st, ret);
-	ret->i_ino = v9fs_qid2ino(&st->qid);
-#ifdef CONFIG_9P_FSCACHE
-	v9fs_vcookie_set_qid(ret, &st->qid);
-	v9fs_cache_inode_get_cookie(ret);
-#endif
-	err = v9fs_get_acl(ret, fid);
-	if (err) {
-		iput(ret);
-		goto error;
-	}
-	kfree(st);
-	return ret;
-error:
+	inode = v9fs_qid_iget_dotl(sb, &st->qid, fid, st);
 	kfree(st);
-	return ERR_PTR(err);
+	return inode;
 }
 
 /**
-- 
1.7.1

