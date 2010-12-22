Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854Ab0LVNCN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 08:02:13 -0500
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:54088 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876Ab0LVNCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 08:02:11 -0500
From: "M. Mohan Kumar" <mohan@in.ibm.com>
To: v9fs-developer@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] fs/9p: TREADLINK fix
Date: Wed, 22 Dec 2010 18:32:07 +0530
Message-Id: <1293022927-27141-1-git-send-email-mohan@in.ibm.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use copy_to_user function to copy symlink information to the userspace
address. As part of this change v9fs_vfs_followlink_dotl also changed.

Signed-off-by: M. Mohan Kumar <mohan@in.ibm.com>
---
 fs/9p/vfs_inode.c |   43 +++++++++++++++++++++----------------------
 1 files changed, 21 insertions(+), 22 deletions(-)

diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 2ce3668..9d3b910 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -1995,26 +1995,26 @@ error:
 }
 
 static int
-v9fs_vfs_readlink_dotl(struct dentry *dentry, char *buffer, int buflen)
+v9fs_vfs_readlink_dotl(struct dentry *dentry, char __user *buffer, int buflen)
 {
-	int retval;
+	int retval = -EPERM;
 	struct p9_fid *fid;
 	char *target = NULL;
 
 	P9_DPRINTK(P9_DEBUG_VFS, " %s\n", dentry->d_name.name);
-	retval = -EPERM;
 	fid = v9fs_fid_lookup(dentry);
 	if (IS_ERR(fid))
 		return PTR_ERR(fid);
-
 	retval = p9_client_readlink(fid, &target);
 	if (retval < 0)
-		return retval;
-
-	strncpy(buffer, target, buflen);
-	P9_DPRINTK(P9_DEBUG_VFS, "%s -> %s\n", dentry->d_name.name, buffer);
-
-	retval = strnlen(buffer, buflen);
+		goto error;
+	retval = copy_to_user(buffer, target, buflen);
+	if (retval < 0)
+		goto error;
+	P9_DPRINTK(P9_DEBUG_VFS, "%s -> %s\n", dentry->d_name.name, target);
+	retval = strnlen(target, buflen);
+error:
+	kfree(target);
 	return retval;
 }
 
@@ -2028,23 +2028,22 @@ v9fs_vfs_readlink_dotl(struct dentry *dentry, char *buffer, int buflen)
 static void *
 v9fs_vfs_follow_link_dotl(struct dentry *dentry, struct nameidata *nd)
 {
-	int len = 0;
-	char *link = __getname();
+	int retval;
+	struct p9_fid *fid;
+	char *link = NULL;
 
 	P9_DPRINTK(P9_DEBUG_VFS, "%s n", dentry->d_name.name);
 
-	if (!link)
-		link = ERR_PTR(-ENOMEM);
-	else {
-		len = v9fs_vfs_readlink_dotl(dentry, link, PATH_MAX);
-		if (len < 0) {
-			__putname(link);
-			link = ERR_PTR(len);
-		} else
-			link[min(len, PATH_MAX-1)] = 0;
+	fid = v9fs_fid_lookup(dentry);
+	if (IS_ERR(fid))
+		return fid;
+	retval = p9_client_readlink(fid, &link);
+	if (retval < 0) {
+		kfree(link);
+		link = ERR_PTR(retval);
 	}
-	nd_set_link(nd, link);
 
+	nd_set_link(nd, link);
 	return NULL;
 }
 
-- 
1.7.0.4

