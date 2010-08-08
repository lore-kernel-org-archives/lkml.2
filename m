Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198Ab0HHP57 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 11:57:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9214 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754965Ab0HHPzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 11:55:46 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 31/39] union-mount: Implement union-aware rename()
Date: Sun,  8 Aug 2010 11:52:48 -0400
Message-Id: <1281282776-5447-32-git-send-email-vaurora@redhat.com>
In-Reply-To: <1281282776-5447-1-git-send-email-vaurora@redhat.com>
References: <1281282776-5447-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On rename() of a file on union mount, copyup and whiteout the source
file.  Both are done under the rename mutex.  I believe this is
actually atomic.

XXX - May not need to do file copyup under the lock.
XXX - Convert newly empty unioned dirs to not-unioned

Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 fs/namei.c |   76 +++++++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 70 insertions(+), 6 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 5b22cc5..67ebf4a 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3159,6 +3159,7 @@ SYSCALL_DEFINE4(renameat, int, olddfd, const char __user *, oldname,
 {
 	struct dentry *old_dir, *new_dir;
 	struct path old, new;
+	struct path to_whiteout = {NULL, NULL};
 	struct dentry *trap;
 	struct nameidata oldnd, newnd;
 	char *from;
@@ -3174,13 +3175,9 @@ SYSCALL_DEFINE4(renameat, int, olddfd, const char __user *, oldname,
 		goto exit1;
 
 	error = -EXDEV;
+	/* Union mounts will pass below test - dirs always on topmost */
 	if (oldnd.path.mnt != newnd.path.mnt)
 		goto exit2;
-	/* Rename on union mounts not implemented yet */
-	/* XXX much harsher check than necessary - can do some renames */
-	if (IS_DIR_UNIONED(oldnd.path.dentry) ||
-	    IS_DIR_UNIONED(newnd.path.dentry))
-		goto exit2;
 	old_dir = oldnd.path.dentry;
 	error = -EBUSY;
 	if (oldnd.last_type != LAST_NORM)
@@ -3203,7 +3200,7 @@ SYSCALL_DEFINE4(renameat, int, olddfd, const char __user *, oldname,
 	error = -ENOENT;
 	if (!old.dentry->d_inode)
 		goto exit4;
-	/* unless the source is a directory trailing slashes give -ENOTDIR */
+	/* unless the source is a directory, trailing slashes give -ENOTDIR */
 	if (!S_ISDIR(old.dentry->d_inode->i_mode)) {
 		error = -ENOTDIR;
 		if (oldnd.last.name[oldnd.last.len])
@@ -3215,6 +3212,11 @@ SYSCALL_DEFINE4(renameat, int, olddfd, const char __user *, oldname,
 	error = -EINVAL;
 	if (old.dentry == trap)
 		goto exit4;
+	error = -EXDEV;
+	/* Can't rename a directory from a lower layer */
+	if (IS_DIR_UNIONED(oldnd.path.dentry) &&
+	    IS_DIR_UNIONED(old.dentry))
+		goto exit4;
 	error = lookup_hash(&newnd, &newnd.last, &new);
 	if (error)
 		goto exit4;
@@ -3222,6 +3224,48 @@ SYSCALL_DEFINE4(renameat, int, olddfd, const char __user *, oldname,
 	error = -ENOTEMPTY;
 	if (new.dentry == trap)
 		goto exit5;
+	error = -EXDEV;
+	/* Can't rename over directories on the lower layer */
+	if (IS_DIR_UNIONED(newnd.path.dentry) &&
+	    IS_DIR_UNIONED(new.dentry))
+		goto exit5;
+
+	/* If source is on lower layer, copy up */
+	if (IS_DIR_UNIONED(oldnd.path.dentry) &&
+	    (old.mnt != oldnd.path.mnt)) {
+		/* Save the lower path to avoid a second lookup for whiteout */
+		to_whiteout.mnt = mntget(old.mnt);
+		to_whiteout.dentry = dget(old.dentry);
+		error = __union_copyup(&oldnd, &old);
+		if (error)
+			goto exit5;
+	}
+
+	/* If target is on lower layer, get negative dentry for topmost */
+	if (IS_DIR_UNIONED(newnd.path.dentry) &&
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
@@ -3232,6 +3276,26 @@ SYSCALL_DEFINE4(renameat, int, olddfd, const char __user *, oldname,
 		goto exit6;
 	error = vfs_rename(old_dir->d_inode, old.dentry,
 				   new_dir->d_inode, new.dentry);
+	if (error)
+		goto exit6;
+	/* Now whiteout the source */
+	if (IS_DIR_UNIONED(oldnd.path.dentry)) {
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

