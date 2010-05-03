Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932263Ab0ECXSc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 19:18:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10555 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932243Ab0ECXOE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 19:14:04 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>, Jan Blunck <jblunck@suse.de>,
       Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 31/39] union-mount: Implement union-aware rename()
Date: Mon,  3 May 2010 16:12:30 -0700
Message-Id: <1272928358-20854-32-git-send-email-vaurora@redhat.com>
In-Reply-To: <1272928358-20854-1-git-send-email-vaurora@redhat.com>
References: <1272928358-20854-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On rename() of a file on union mount, copyup and whiteout the source
file.  Both are done under the rename mutex.  I believe this is
actually atomic.

XXX - May not need to do file copyup under the lock.
---
 fs/namei.c |   75 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 70 insertions(+), 5 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index d85d7f1..b00ece9 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3243,6 +3243,7 @@ SYSCALL_DEFINE4(renameat, int, olddfd, const char __user *, oldname,
 {
 	struct dentry *old_dir, *new_dir;
 	struct path old, new;
+	struct path to_whiteout = {NULL, NULL};
 	struct dentry *trap;
 	struct nameidata oldnd, newnd;
 	char *from;
@@ -3258,12 +3259,9 @@ SYSCALL_DEFINE4(renameat, int, olddfd, const char __user *, oldname,
 		goto exit1;
 
 	error = -EXDEV;
+	/* Union mounts will pass below test - dirs always on topmost */
 	if (oldnd.path.mnt != newnd.path.mnt)
 		goto exit2;
-	/* Rename on union mounts not implemented yet */
-	/* XXX much harsher check than necessary - can do some renames */
-	if (IS_UNIONED_DIR(&oldnd.path) || IS_UNIONED_DIR(&newnd.path))
-		goto exit2;
 	old_dir = oldnd.path.dentry;
 	error = -EBUSY;
 	if (oldnd.last_type != LAST_NORM)
@@ -3286,7 +3284,7 @@ SYSCALL_DEFINE4(renameat, int, olddfd, const char __user *, oldname,
 	error = -ENOENT;
 	if (!old.dentry->d_inode)
 		goto exit4;
-	/* unless the source is a directory trailing slashes give -ENOTDIR */
+	/* unless the source is a directory, trailing slashes give -ENOTDIR */
 	if (!S_ISDIR(old.dentry->d_inode->i_mode)) {
 		error = -ENOTDIR;
 		if (oldnd.last.name[oldnd.last.len])
@@ -3298,6 +3296,11 @@ SYSCALL_DEFINE4(renameat, int, olddfd, const char __user *, oldname,
 	error = -EINVAL;
 	if (old.dentry == trap)
 		goto exit4;
+	error = -EXDEV;
+	/* Can't rename a directory from a lower layer */
+	if (IS_UNIONED_DIR(&oldnd.path) &&
+	    IS_UNIONED_DIR(&old))
+		goto exit4;
 	error = lookup_hash(&newnd, &newnd.last, &new);
 	if (error)
 		goto exit4;
@@ -3305,6 +3308,48 @@ SYSCALL_DEFINE4(renameat, int, olddfd, const char __user *, oldname,
 	error = -ENOTEMPTY;
 	if (new.dentry == trap)
 		goto exit5;
+	error = -EXDEV;
+	/* Can't rename over directories on the lower layer */
+	if (IS_UNIONED_DIR(&newnd.path) &&
+	    IS_UNIONED_DIR(&new))
+		goto exit4;
+
+	/* If source is on lower layer, copy up */
+	if (IS_UNIONED_DIR(&oldnd.path) &&
+	    (old.mnt != oldnd.path.mnt)) {
+		/* Save the lower path to avoid a second lookup for whiteout */
+		to_whiteout.dentry = dget(old.dentry);
+		to_whiteout.mnt = mntget(old.mnt);
+		error = __union_copyup(&oldnd, &old);
+		if (error)
+			goto exit5;
+	}
+
+	/* If target is on lower layer, get negative dentry for topmost */
+	if (IS_UNIONED_DIR(&newnd.path) &&
+	    (new.mnt != newnd.path.mnt)) {
+		struct dentry *dentry;
+		/*
+		 * At this point, source and target are both files,
+		 * the source is on the topmost layer, and the target
+		 * is on a lower layer.  We want the target dentry to
+		 * disappear from the namespace, and give vfs_rename a
+		 * negative dentry from the topmost layer.
+		 */
+		/* We already did lookup once, no need to check perm */
+		dentry = __lookup_hash(&newnd.last, newnd.path.dentry, &newnd);
+		if (IS_ERR(dentry)) {
+			error = PTR_ERR(dentry);
+			goto exit5;
+		}
+		/* We no longer need the lower target dentry.  It
+		 * definitely should be removed from the hash table */
+		/* XXX what about failure case? */
+		d_delete(new.dentry);
+		mntput(new.mnt);
+		new.mnt = mntget(newnd.path.mnt);
+		new.dentry = dentry;
+	}
 
 	error = mnt_want_write(oldnd.path.mnt);
 	if (error)
@@ -3315,6 +3360,26 @@ SYSCALL_DEFINE4(renameat, int, olddfd, const char __user *, oldname,
 		goto exit6;
 	error = vfs_rename(old_dir->d_inode, old.dentry,
 				   new_dir->d_inode, new.dentry);
+	if (error)
+		goto exit6;
+	/* Now whiteout the source */
+	if (IS_UNIONED_DIR(&oldnd.path)) {
+		if (!to_whiteout.dentry) {
+			struct dentry *dentry;
+			/* We could have exposed a lower level entry */
+			dentry = __lookup_hash(&oldnd.last, oldnd.path.dentry, &oldnd);
+			if (IS_ERR(dentry)) {
+				error = PTR_ERR(dentry);
+				goto exit6;
+			}
+			to_whiteout.dentry = dentry;
+			to_whiteout.mnt = mntget(oldnd.path.mnt);
+		}
+
+		if (to_whiteout.dentry->d_inode)
+			error = do_whiteout(&oldnd, &to_whiteout, 0);
+		path_put(&to_whiteout);
+	}
 exit6:
 	mnt_drop_write(oldnd.path.mnt);
 exit5:
-- 
1.6.3.3

