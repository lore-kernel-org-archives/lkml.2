Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758170Ab1GKQlY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 12:41:24 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:43315 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758152Ab1GKQlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 12:41:21 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 3/3] hw/9pfs: Always ask new inode in create
Date: Mon, 11 Jul 2011 22:11:00 +0530
Message-Id: <1310402460-5098-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310402460-5098-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1310402460-5098-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This make sure we don't end up reusing the unlinked inode object.
The ideal way is to use inode i_generation. But i_generation is
not available in userspace always.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/9p/v9fs.h           |   27 +++++++++++++++++++++++----
 fs/9p/vfs_inode.c      |   22 +++++++++++++++++-----
 fs/9p/vfs_inode_dotl.c |   30 +++++++++++++++++++++---------
 3 files changed, 61 insertions(+), 18 deletions(-)

diff --git a/fs/9p/v9fs.h b/fs/9p/v9fs.h
index 5d7392e..e78956c 100644
--- a/fs/9p/v9fs.h
+++ b/fs/9p/v9fs.h
@@ -153,13 +153,13 @@ extern void v9fs_vfs_put_link(struct dentry *dentry, struct nameidata *nd,
 			void *p);
 extern struct inode *v9fs_inode_from_fid(struct v9fs_session_info *v9ses,
 					 struct p9_fid *fid,
-					 struct super_block *sb);
+					 struct super_block *sb, int new);
 extern const struct inode_operations v9fs_dir_inode_operations_dotl;
 extern const struct inode_operations v9fs_file_inode_operations_dotl;
 extern const struct inode_operations v9fs_symlink_inode_operations_dotl;
 extern struct inode *v9fs_inode_from_fid_dotl(struct v9fs_session_info *v9ses,
 					      struct p9_fid *fid,
-					      struct super_block *sb);
+					      struct super_block *sb, int new);
 
 /* other default globals */
 #define V9FS_PORT	564
@@ -201,8 +201,27 @@ v9fs_get_inode_from_fid(struct v9fs_session_info *v9ses, struct p9_fid *fid,
 			struct super_block *sb)
 {
 	if (v9fs_proto_dotl(v9ses))
-		return v9fs_inode_from_fid_dotl(v9ses, fid, sb);
+		return v9fs_inode_from_fid_dotl(v9ses, fid, sb, 0);
 	else
-		return v9fs_inode_from_fid(v9ses, fid, sb);
+		return v9fs_inode_from_fid(v9ses, fid, sb, 0);
 }
+
+/**
+ * v9fs_get_new_inode_from_fid - Helper routine to populate an inode by
+ * issuing a attribute request
+ * @v9ses: session information
+ * @fid: fid to issue attribute request for
+ * @sb: superblock on which to create inode
+ *
+ */
+static inline struct inode *
+v9fs_get_new_inode_from_fid(struct v9fs_session_info *v9ses, struct p9_fid *fid,
+			    struct super_block *sb)
+{
+	if (v9fs_proto_dotl(v9ses))
+		return v9fs_inode_from_fid_dotl(v9ses, fid, sb, 1);
+	else
+		return v9fs_inode_from_fid(v9ses, fid, sb, 1);
+}
+
 #endif
diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index d13434c..cbba7c7 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -454,6 +454,11 @@ static int v9fs_test_inode(struct inode *inode, void *data)
 	return 1;
 }
 
+static int v9fs_test_new_inode(struct inode *inode, void *data)
+{
+	return 0;
+}
+
 static int v9fs_set_inode(struct inode *inode,  void *data)
 {
 	struct v9fs_inode *v9inode = V9FS_I(inode);
@@ -465,15 +470,22 @@ static int v9fs_set_inode(struct inode *inode,  void *data)
 
 static struct inode *v9fs_qid_iget(struct super_block *sb,
 				   struct p9_qid *qid,
-				   struct p9_wstat *st)
+				   struct p9_wstat *st,
+				   int new)
 {
 	int retval, umode;
 	unsigned long i_ino;
 	struct inode *inode;
 	struct v9fs_session_info *v9ses = sb->s_fs_info;
+	int (*test)(struct inode *, void *);
+
+	if (new)
+		test = v9fs_test_new_inode;
+	else
+		test = v9fs_test_inode;
 
 	i_ino = v9fs_qid2ino(qid);
-	inode = iget5_locked(sb, i_ino, v9fs_test_inode, v9fs_set_inode, st);
+	inode = iget5_locked(sb, i_ino, test, v9fs_set_inode, st);
 	if (!inode)
 		return ERR_PTR(-ENOMEM);
 	if (!(inode->i_state & I_NEW))
@@ -504,7 +516,7 @@ error:
 
 struct inode *
 v9fs_inode_from_fid(struct v9fs_session_info *v9ses, struct p9_fid *fid,
-		    struct super_block *sb)
+		    struct super_block *sb, int new)
 {
 	struct p9_wstat *st;
 	struct inode *inode = NULL;
@@ -513,7 +525,7 @@ v9fs_inode_from_fid(struct v9fs_session_info *v9ses, struct p9_fid *fid,
 	if (IS_ERR(st))
 		return ERR_CAST(st);
 
-	inode = v9fs_qid_iget(sb, &st->qid, st);
+	inode = v9fs_qid_iget(sb, &st->qid, st, new);
 	p9stat_free(st);
 	kfree(st);
 	return inode;
@@ -627,7 +639,7 @@ v9fs_create(struct v9fs_session_info *v9ses, struct inode *dir,
 	}
 
 	/* instantiate inode and assign the unopened fid to the dentry */
-	inode = v9fs_get_inode_from_fid(v9ses, fid, dir->i_sb);
+	inode = v9fs_get_new_inode_from_fid(v9ses, fid, dir->i_sb);
 	if (IS_ERR(inode)) {
 		err = PTR_ERR(inode);
 		P9_DPRINTK(P9_DEBUG_VFS, "inode creation failed %d\n", err);
diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
index caa63ef..bec75f0 100644
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -108,6 +108,12 @@ static int v9fs_test_inode_dotl(struct inode *inode, void *data)
 	return 1;
 }
 
+/* Always get a new inode */
+static int v9fs_test_new_inode_dotl(struct inode *inode, void *data)
+{
+	return 0;
+}
+
 static int v9fs_set_inode_dotl(struct inode *inode,  void *data)
 {
 	struct v9fs_inode *v9inode = V9FS_I(inode);
@@ -121,16 +127,22 @@ static int v9fs_set_inode_dotl(struct inode *inode,  void *data)
 static struct inode *v9fs_qid_iget_dotl(struct super_block *sb,
 					struct p9_qid *qid,
 					struct p9_fid *fid,
-					struct p9_stat_dotl *st)
+					struct p9_stat_dotl *st,
+					int new)
 {
 	int retval;
 	unsigned long i_ino;
 	struct inode *inode;
 	struct v9fs_session_info *v9ses = sb->s_fs_info;
+	int (*test)(struct inode *, void *);
+
+	if (new)
+		test = v9fs_test_new_inode_dotl;
+	else
+		test = v9fs_test_inode_dotl;
 
 	i_ino = v9fs_qid2ino(qid);
-	inode = iget5_locked(sb, i_ino, v9fs_test_inode_dotl,
-			     v9fs_set_inode_dotl, st);
+	inode = iget5_locked(sb, i_ino, test, v9fs_set_inode_dotl, st);
 	if (!inode)
 		return ERR_PTR(-ENOMEM);
 	if (!(inode->i_state & I_NEW))
@@ -164,7 +176,7 @@ error:
 
 struct inode *
 v9fs_inode_from_fid_dotl(struct v9fs_session_info *v9ses, struct p9_fid *fid,
-			 struct super_block *sb)
+			 struct super_block *sb, int new)
 {
 	struct p9_stat_dotl *st;
 	struct inode *inode = NULL;
@@ -173,7 +185,7 @@ v9fs_inode_from_fid_dotl(struct v9fs_session_info *v9ses, struct p9_fid *fid,
 	if (IS_ERR(st))
 		return ERR_CAST(st);
 
-	inode = v9fs_qid_iget_dotl(sb, &st->qid, fid, st);
+	inode = v9fs_qid_iget_dotl(sb, &st->qid, fid, st, new);
 	kfree(st);
 	return inode;
 }
@@ -263,7 +275,7 @@ v9fs_vfs_create_dotl(struct inode *dir, struct dentry *dentry, int omode,
 		fid = NULL;
 		goto error;
 	}
-	inode = v9fs_get_inode_from_fid(v9ses, fid, dir->i_sb);
+	inode = v9fs_get_new_inode_from_fid(v9ses, fid, dir->i_sb);
 	if (IS_ERR(inode)) {
 		err = PTR_ERR(inode);
 		P9_DPRINTK(P9_DEBUG_VFS, "inode creation failed %d\n", err);
@@ -383,7 +395,7 @@ static int v9fs_vfs_mkdir_dotl(struct inode *dir,
 			goto error;
 		}
 
-		inode = v9fs_get_inode_from_fid(v9ses, fid, dir->i_sb);
+		inode = v9fs_get_new_inode_from_fid(v9ses, fid, dir->i_sb);
 		if (IS_ERR(inode)) {
 			err = PTR_ERR(inode);
 			P9_DPRINTK(P9_DEBUG_VFS, "inode creation failed %d\n",
@@ -636,7 +648,7 @@ v9fs_vfs_symlink_dotl(struct inode *dir, struct dentry *dentry,
 		}
 
 		/* instantiate inode and assign the unopened fid to dentry */
-		inode = v9fs_get_inode_from_fid(v9ses, fid, dir->i_sb);
+		inode = v9fs_get_new_inode_from_fid(v9ses, fid, dir->i_sb);
 		if (IS_ERR(inode)) {
 			err = PTR_ERR(inode);
 			P9_DPRINTK(P9_DEBUG_VFS, "inode creation failed %d\n",
@@ -789,7 +801,7 @@ v9fs_vfs_mknod_dotl(struct inode *dir, struct dentry *dentry, int omode,
 			goto error;
 		}
 
-		inode = v9fs_get_inode_from_fid(v9ses, fid, dir->i_sb);
+		inode = v9fs_get_new_inode_from_fid(v9ses, fid, dir->i_sb);
 		if (IS_ERR(inode)) {
 			err = PTR_ERR(inode);
 			P9_DPRINTK(P9_DEBUG_VFS, "inode creation failed %d\n",
-- 
1.7.4.1

