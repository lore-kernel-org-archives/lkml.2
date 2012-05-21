Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801Ab2EUPau (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 11:30:50 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43253 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754448Ab2EUPar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 11:30:47 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, torvalds@linux-foundation.org, mszeredi@suse.cz
Subject: [PATCH 15/16] vfs: retry last component if opening stale dentry
Date: Mon, 21 May 2012 17:30:19 +0200
Message-Id: <1337614220-6174-16-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1337614220-6174-1-git-send-email-miklos@szeredi.hu>
References: <1337614220-6174-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

NFS optimizes away d_revalidates for last component of open.  This means that
open itself can find the dentry stale.

This patch allows the filesystem to return EOPENSTALE and the VFS will retry the
lookup on just the last component if possible.

If the lookup was done using RCU mode, including the last component, then this
is not possible since the parent dentry is lost.  In this case fall back to
non-RCU lookup.  Currently this is not used since NFS will always leave RCU
mode.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namei.c            |   37 +++++++++++++++++++++++++++++++++++--
 include/linux/errno.h |    1 +
 2 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index cdc2c05..fdab199 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2204,6 +2204,8 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
 	struct file *filp;
 	struct inode *inode;
 	int symlink_ok = 0;
+	struct path save_parent = { .dentry = NULL, .mnt = NULL };
+	bool retried = false;
 	int error;
 
 	nd->flags &= ~LOOKUP_PARENT;
@@ -2269,6 +2271,7 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
 	if (nd->last.name[nd->last.len])
 		goto exit;
 
+retry_lookup:
 	mutex_lock(&dir->d_inode->i_mutex);
 
 	dentry = lookup_hash(nd);
@@ -2351,12 +2354,21 @@ finish_lookup:
 		return NULL;
 	}
 
-	path_to_nameidata(path, nd);
+	if ((nd->flags & LOOKUP_RCU) || nd->path.mnt != path->mnt) {
+		path_to_nameidata(path, nd);
+	} else {
+		save_parent.dentry = nd->path.dentry;
+		save_parent.mnt = mntget(path->mnt);
+		nd->path.dentry = path->dentry;
+
+	}
 	nd->inode = inode;
 	/* Why this, you ask?  _Now_ we might have grown LOOKUP_JUMPED... */
 	error = complete_walk(nd);
-	if (error)
+	if (error) {
+		path_put(&save_parent);
 		return ERR_PTR(error);
+	}
 	error = -EISDIR;
 	if ((open_flag & O_CREAT) && S_ISDIR(nd->inode->i_mode))
 		goto exit;
@@ -2379,6 +2391,20 @@ common:
 	if (error)
 		goto exit;
 	filp = nameidata_to_filp(nd);
+	if (filp == ERR_PTR(-EOPENSTALE) && save_parent.dentry && !retried) {
+		BUG_ON(save_parent.dentry != dir);
+		path_put(&nd->path);
+		nd->path = save_parent;
+		nd->inode = dir->d_inode;
+		save_parent.mnt = NULL;
+		save_parent.dentry = NULL;
+		if (want_write) {
+			mnt_drop_write(nd->path.mnt);
+			want_write = 0;
+		}
+		retried = true;
+		goto retry_lookup;
+	}
 	if (!IS_ERR(filp)) {
 		error = ima_file_check(filp, op->acc_mode);
 		if (error) {
@@ -2398,6 +2424,7 @@ common:
 out:
 	if (want_write)
 		mnt_drop_write(nd->path.mnt);
+	path_put(&save_parent);
 	terminate_walk(nd);
 	return filp;
 
@@ -2461,6 +2488,12 @@ out:
 	if (base)
 		fput(base);
 	release_open_intent(nd);
+	if (filp == ERR_PTR(-EOPENSTALE)) {
+		if (flags & LOOKUP_RCU)
+			filp = ERR_PTR(-ECHILD);
+		else
+			filp = ERR_PTR(-ESTALE);
+	}
 	return filp;
 
 out_filp:
diff --git a/include/linux/errno.h b/include/linux/errno.h
index 2d09bfa..e0de516 100644
--- a/include/linux/errno.h
+++ b/include/linux/errno.h
@@ -17,6 +17,7 @@
 #define ENOIOCTLCMD	515	/* No ioctl command */
 #define ERESTART_RESTARTBLOCK 516 /* restart by calling sys_restart_syscall */
 #define EPROBE_DEFER	517	/* Driver requests probe retry */
+#define EOPENSTALE	518	/* open found a stale dentry */
 
 /* Defined for the NFSv3 protocol */
 #define EBADHANDLE	521	/* Illegal NFS file handle */
-- 
1.7.7

