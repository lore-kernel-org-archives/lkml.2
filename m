Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746Ab2DEO75 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 10:59:57 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:52339 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882Ab2DEO7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 10:59:01 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, mszeredi@suse.cz
Subject: [PATCH 15/34] vfs: retry last component if opening stale dentry
Date: Thu,  5 Apr 2012 16:58:41 +0200
Message-Id: <1333637940-31884-16-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1333637940-31884-1-git-send-email-miklos@szeredi.hu>
References: <1333637940-31884-1-git-send-email-miklos@szeredi.hu>
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
index 9e4ec13..c8a8b28 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2233,6 +2233,8 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
 	struct file *filp;
 	struct inode *inode;
 	int symlink_ok = 0;
+	struct path save_parent = { .dentry = NULL, .mnt = NULL };
+	bool retried = false;
 	int error;
 
 	nd->flags &= ~LOOKUP_PARENT;
@@ -2298,6 +2300,7 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
 	if (nd->last.name[nd->last.len])
 		goto exit;
 
+retry_lookup:
 	mutex_lock(&dir->d_inode->i_mutex);
 
 	dentry = lookup_hash(nd);
@@ -2378,12 +2381,21 @@ finish_lookup:
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
@@ -2406,6 +2418,20 @@ common:
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
@@ -2425,6 +2451,7 @@ common:
 out:
 	if (want_write)
 		mnt_drop_write(nd->path.mnt);
+	path_put(&save_parent);
 	terminate_walk(nd);
 	return filp;
 
@@ -2488,6 +2515,12 @@ out:
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

