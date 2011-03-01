Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022Ab1CAIvw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 03:51:52 -0500
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:50986 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755936Ab1CAIvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 03:51:49 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 4/6] fs/9p: Make the writeback_fid owned by root
Date: Tue,  1 Mar 2011 14:21:22 +0530
Message-Id: <1298969484-16199-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1298969484-16199-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1298969484-16199-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes to make sure writeback fid is owned by root

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/9p/fid.c |   92 ++++++++++++++++++++++++++++++++++++-----------------------
 1 files changed, 56 insertions(+), 36 deletions(-)

diff --git a/fs/9p/fid.c b/fs/9p/fid.c
index 9d6a5d3..cd63e00 100644
--- a/fs/9p/fid.c
+++ b/fs/9p/fid.c
@@ -125,46 +125,17 @@ err_out:
 	return -ENOMEM;
 }
 
-/**
- * v9fs_fid_lookup - lookup for a fid, try to walk if not found
- * @dentry: dentry to look for fid in
- *
- * Look for a fid in the specified dentry for the current user.
- * If no fid is found, try to create one walking from a fid from the parent
- * dentry (if it has one), or the root dentry. If the user haven't accessed
- * the fs yet, attach now and walk from the root.
- */
-
-struct p9_fid *v9fs_fid_lookup(struct dentry *dentry)
+static struct p9_fid *v9fs_fid_lookup_with_uid(struct dentry *dentry,
+					       uid_t uid, int any)
 {
-	int i, n, l, clone, any, access;
-	u32 uid;
-	struct p9_fid *fid, *old_fid = NULL;
 	struct dentry *ds;
-	struct v9fs_session_info *v9ses;
 	char **wnames, *uname;
+	int i, n, l, clone, access;
+	struct v9fs_session_info *v9ses;
+	struct p9_fid *fid, *old_fid = NULL;
 
 	v9ses = v9fs_inode2v9ses(dentry->d_inode);
 	access = v9ses->flags & V9FS_ACCESS_MASK;
-	switch (access) {
-	case V9FS_ACCESS_SINGLE:
-	case V9FS_ACCESS_USER:
-	case V9FS_ACCESS_CLIENT:
-		uid = current_fsuid();
-		any = 0;
-		break;
-
-	case V9FS_ACCESS_ANY:
-		uid = v9ses->uid;
-		any = 1;
-		break;
-
-	default:
-		uid = ~0;
-		any = 0;
-		break;
-	}
-
 	fid = v9fs_fid_find(dentry, uid, any);
 	if (fid)
 		return fid;
@@ -250,6 +221,45 @@ err_out:
 	return fid;
 }
 
+/**
+ * v9fs_fid_lookup - lookup for a fid, try to walk if not found
+ * @dentry: dentry to look for fid in
+ *
+ * Look for a fid in the specified dentry for the current user.
+ * If no fid is found, try to create one walking from a fid from the parent
+ * dentry (if it has one), or the root dentry. If the user haven't accessed
+ * the fs yet, attach now and walk from the root.
+ */
+
+struct p9_fid *v9fs_fid_lookup(struct dentry *dentry)
+{
+	uid_t uid;
+	int  any, access;
+	struct v9fs_session_info *v9ses;
+
+	v9ses = v9fs_inode2v9ses(dentry->d_inode);
+	access = v9ses->flags & V9FS_ACCESS_MASK;
+	switch (access) {
+	case V9FS_ACCESS_SINGLE:
+	case V9FS_ACCESS_USER:
+	case V9FS_ACCESS_CLIENT:
+		uid = current_fsuid();
+		any = 0;
+		break;
+
+	case V9FS_ACCESS_ANY:
+		uid = v9ses->uid;
+		any = 1;
+		break;
+
+	default:
+		uid = ~0;
+		any = 0;
+		break;
+	}
+	return v9fs_fid_lookup_with_uid(dentry, uid, any);
+}
+
 struct p9_fid *v9fs_fid_clone(struct dentry *dentry)
 {
 	struct p9_fid *fid, *ret;
@@ -262,13 +272,24 @@ struct p9_fid *v9fs_fid_clone(struct dentry *dentry)
 	return ret;
 }
 
+static struct p9_fid *v9fs_fid_clone_with_uid(struct dentry *dentry, uid_t uid)
+{
+	struct p9_fid *fid, *ret;
+
+	fid = v9fs_fid_lookup_with_uid(dentry, uid, 0);
+	if (IS_ERR(fid))
+		return fid;
+
+	ret = p9_client_walk(fid, 0, NULL, 1);
+	return ret;
+}
 
 struct p9_fid *v9fs_writeback_fid(struct dentry *dentry)
 {
 	int err;
 	struct p9_fid *fid;
 
-	fid = v9fs_fid_clone(dentry);
+	fid = v9fs_fid_clone_with_uid(dentry, 0);
 	if (IS_ERR(fid))
 		goto error_out;
 	/*
@@ -276,7 +297,6 @@ struct p9_fid *v9fs_writeback_fid(struct dentry *dentry)
 	 * dirty pages. We always request for the open fid in read-write
 	 * mode so that a partial page write which result in page
 	 * read can work.
-	 * FIXME!!: we should make the fid owned by uid = 0
 	 */
 	err = p9_client_open(fid, O_RDWR);
 	if (err < 0) {
-- 
1.7.1

