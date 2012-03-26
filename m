Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371Ab2CZKyQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 06:54:16 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:62340 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757222Ab2CZKyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 06:54:14 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, mszeredi@suse.cz
Subject: [PATCH 4/6] vfs: set LOOKUP_JUMPED in follow_managed
Date: Mon, 26 Mar 2012 12:54:22 +0200
Message-Id: <1332759264-23533-5-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1332759264-23533-1-git-send-email-miklos@szeredi.hu>
References: <1332759264-23533-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

This is cleaner than if callers need to do it.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namei.c |   27 +++++++++++++--------------
 1 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 3e13412..482992e 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -794,8 +794,10 @@ static int follow_automount(struct path *path, unsigned flags,
  * This may only be called in refwalk mode.
  *
  * Serialization is taken care of in namespace.c
+ *
+ * If a mount was followed, set LOOKUP_JUMPED in nd->flags
  */
-static int follow_managed(struct path *path, unsigned flags)
+static int follow_managed(struct path *path, struct nameidata *nd)
 {
 	struct vfsmount *mnt = path->mnt; /* held by caller, must be left alone */
 	unsigned managed;
@@ -839,7 +841,7 @@ static int follow_managed(struct path *path, unsigned flags)
 
 		/* Handle an automount point */
 		if (managed & DCACHE_NEED_AUTOMOUNT) {
-			ret = follow_automount(path, flags, &need_mntput);
+			ret = follow_automount(path, nd->flags, &need_mntput);
 			if (ret < 0)
 				break;
 			continue;
@@ -851,9 +853,11 @@ static int follow_managed(struct path *path, unsigned flags)
 
 	if (need_mntput && path->mnt == mnt)
 		mntput(path->mnt);
-	if (ret == -EISDIR)
-		ret = 0;
-	return ret < 0 ? ret : need_mntput;
+	if (ret < 0 && ret != -EISDIR)
+		return ret;
+	if (need_mntput)
+		nd->flags |= LOOKUP_JUMPED;
+	return 0;
 }
 
 int follow_down_one(struct path *path)
@@ -1212,13 +1216,11 @@ retry:
 
 	path->mnt = mnt;
 	path->dentry = dentry;
-	err = follow_managed(path, nd->flags);
-	if (unlikely(err < 0)) {
+	err = follow_managed(path, nd);
+	if (unlikely(err)) {
 		path_put_conditional(path, nd);
 		return err;
 	}
-	if (err)
-		nd->flags |= LOOKUP_JUMPED;
 	*inode = path->dentry->d_inode;
 	return 0;
 }
@@ -2239,12 +2241,9 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
 	if (open_flag & O_EXCL)
 		goto exit_dput;
 
-	error = follow_managed(path, nd->flags);
-	if (error < 0)
-		goto exit_dput;
-
+	error = follow_managed(path, nd);
 	if (error)
-		nd->flags |= LOOKUP_JUMPED;
+		goto exit_dput;
 
 	error = -ENOENT;
 	if (!path->dentry->d_inode)
-- 
1.7.7

