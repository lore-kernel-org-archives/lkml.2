Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071Ab2BUUCo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 15:02:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21908 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753818Ab2BUTwz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 14:52:55 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 62/73] union-mount: Implement union-aware rename() [ver #2]
To: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        valerie.aurora@gmail.com
Cc: linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com> (Further development)
Date: Tue, 21 Feb 2012 18:05:17 +0000
Message-ID: <20120221180516.25235.71792.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
References: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On rename() of a file on union mount, copyup and whiteout the source
file.

XXX - fix comments and make more readable

XXX - Convert newly empty unioned dirs to not-unioned

Original-author: Valerie Aurora <vaurora@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com> (Further development)
---

 fs/namei.c |  120 +++++++++++++++++++++++++++++++++++++++++++++++++++---------
 1 files changed, 101 insertions(+), 19 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index efad85e..dad7bef 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3045,7 +3045,7 @@ SYSCALL_DEFINE2(mkdir, const char __user *, pathname, umode_t, mode)
 
 /**
  * vfs_whiteout: Create a whiteout for the given directory entry
- * @dir: Parent inode
+ * @parent: Parent directory
  * @dentry: Directory entry to whiteout
  *
  * Create a whiteout for the given directory entry.  A whiteout prevents lookup
@@ -3060,15 +3060,17 @@ SYSCALL_DEFINE2(mkdir, const char __user *, pathname, umode_t, mode)
  * a positive one if it exists, and a negative if not.  When this function
  * returns, the caller should dput() the old, now defunct dentry it passed in.
  * The dentry for the whiteout itself is created inside this function.
+ *
+ * The caller must hold the i_mutex lock on the parent directory.
  */
-static int vfs_whiteout(struct inode *dir, struct dentry *old_dentry, int isdir)
+static int vfs_whiteout(struct dentry *parent, struct dentry *old_dentry, int isdir)
 {
-	struct inode *old_inode = old_dentry->d_inode;
-	struct dentry *parent, *whiteout;
+	struct inode *dir = parent->d_inode, *old_inode = old_dentry->d_inode;
+	struct dentry *whiteout;
 	bool do_dput = false;
 	int err = 0;
 
-	BUG_ON(old_dentry->d_parent->d_inode != dir);
+	BUG_ON(old_dentry->d_parent != parent);
 
 	if (!dir->i_op || !dir->i_op->whiteout)
 		return -EOPNOTSUPP;
@@ -3092,11 +3094,10 @@ static int vfs_whiteout(struct inode *dir, struct dentry *old_dentry, int isdir)
 			goto error_unlock;
 	}
 
-	parent = dget_parent(old_dentry);
 	err = -ENOMEM;
-	whiteout = d_alloc_name(parent, old_dentry->d_name.name);
+	whiteout = d_alloc(parent, &old_dentry->d_name);
 	if (!whiteout)
-		goto error_put_parent;
+		goto error_unlock;
 
 	if (old_inode && isdir) {
 		dentry_unhash(old_dentry);
@@ -3116,13 +3117,10 @@ static int vfs_whiteout(struct inode *dir, struct dentry *old_dentry, int isdir)
 	}
 
 	dput(whiteout);
-	dput(parent);
 	return err;
 
 error_put_whiteout:
 	dput(whiteout);
-error_put_parent:
-	dput(parent);
 error_unlock:
 	if (old_inode)
 		mutex_unlock(&old_inode->i_mutex);
@@ -3208,7 +3206,7 @@ static int do_whiteout(struct nameidata *nd, struct path *path, int isdir)
 		path->dentry = dentry;
 	}
 
-	err = vfs_whiteout(nd->path.dentry->d_inode, dentry, isdir);
+	err = vfs_whiteout(nd->path.dentry, dentry, isdir);
 
 out:
 	path_put(&safe);
@@ -3216,6 +3214,40 @@ out:
 }
 
 /*
+ * Create a whiteout to finish off a rename from a unionmounted directory.
+ * This prevents any file of the same name in the lowerfs from showing through.
+ */
+static int vfs_whiteout_after_rename(struct dentry *parent,
+				     const struct qstr *name)
+{
+	struct inode *dir = parent->d_inode;
+	struct dentry *whiteout;
+	int err;
+
+	if (!dir->i_op || !dir->i_op->whiteout)
+		return -EOPNOTSUPP;
+
+	/* Rename moved the old dentry somewhere else, so there can't be one
+	 * here now (the caller's locks see to that) and so there's no need to
+	 * call lookup, especially as the ->whiteout() op is expected to add
+	 * the new dentry into the tree.
+	 */
+	whiteout = d_alloc(parent, name);
+	if (!whiteout)
+		return -ENOMEM;
+
+	/* I think it's okay to pass the new whiteout as the old dentry here.
+	 * What it seems to want is the name, the parent dentry and the inode.
+	 * However, we know the inode no longer resides there and d_inode will
+	 * be NULL.
+	 */
+	err = dir->i_op->whiteout(dir, whiteout, whiteout);
+
+	dput(whiteout);
+	return err;
+}
+
+/*
  * The dentry_unhash() helper will try to drop the dentry early: we
  * should have a usage count of 2 if we're the only user of this
  * dentry, and if that is true (possibly after pruning the dcache),
@@ -3787,13 +3819,6 @@ SYSCALL_DEFINE4(renameat, int, olddfd, const char __user *, oldname,
 	error = -EXDEV;
 	if (oldnd.path.mnt != newnd.path.mnt)
 		goto exit2;
-
-	/* rename() on union mounts not implemented yet */
-	error = -EXDEV;
-	if (IS_DIR_UNIONED(oldnd.path.dentry) ||
-	    IS_DIR_UNIONED(newnd.path.dentry))
-		goto exit2;
-
 	old_dir = oldnd.path.dentry;
 	error = -EBUSY;
 	if (oldnd.last_type != LAST_NORM)
@@ -3804,6 +3829,7 @@ SYSCALL_DEFINE4(renameat, int, olddfd, const char __user *, oldname,
 		goto exit2;
 
 	oldnd.flags &= ~LOOKUP_PARENT;
+	oldnd.flags |= LOOKUP_COPY_UP;
 	newnd.flags &= ~LOOKUP_PARENT;
 	newnd.flags |= LOOKUP_RENAME_TARGET;
 
@@ -3828,6 +3854,11 @@ SYSCALL_DEFINE4(renameat, int, olddfd, const char __user *, oldname,
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
@@ -3835,6 +3866,42 @@ SYSCALL_DEFINE4(renameat, int, olddfd, const char __user *, oldname,
 	error = -ENOTEMPTY;
 	if (new.dentry == trap)
 		goto exit5;
+	error = -EXDEV;
+	/* Can't rename over directories on the lower layer */
+	if (IS_DIR_UNIONED(newnd.path.dentry) &&
+	    IS_DIR_UNIONED(new.dentry))
+		goto exit5;
+
+	/* If source should've been copied up by lookup_hash() */
+	if (IS_DIR_UNIONED(oldnd.path.dentry))
+		BUG_ON(old.mnt != oldnd.path.mnt);
+
+	/* If target is on lower layer, get negative dentry for topmost */
+	if (IS_DIR_UNIONED(newnd.path.dentry) &&
+	    new.mnt != newnd.path.mnt) {
+		/* At this point, source and target are both files, the source
+		 * is on the topmost layer and the target is on a lower layer.
+		 * We want the target dentry to disappear from the namespace
+		 * and give vfs_rename a negative dentry from the topmost
+		 * layer.
+		 *
+		 * Note: We already did lookup once, so no need to recheck perm
+		 */
+		struct dentry *dentry =
+			__lookup_hash(&newnd.last, newnd.path.dentry, &newnd);
+		if (IS_ERR(dentry)) {
+			error = PTR_ERR(dentry);
+			goto exit5;
+		}
+
+		/* We no longer need the lower target dentry.  It definitely
+		 * should be removed from the hash table */
+		/* XXX what about failure case? */
+		d_delete(new.dentry);
+		mntput(new.mnt);
+		new.mnt = mntget(newnd.path.mnt);
+		new.dentry = dentry;
+	}
 
 	error = mnt_want_write(oldnd.path.mnt);
 	if (error)
@@ -3845,6 +3912,21 @@ SYSCALL_DEFINE4(renameat, int, olddfd, const char __user *, oldname,
 		goto exit6;
 	error = vfs_rename(old_dir->d_inode, old.dentry,
 				   new_dir->d_inode, new.dentry);
+	if (error)
+		goto exit6;
+
+	/* Now whiteout the source.  We may have exposed a positive lower level
+	 * dentry, so we have to make sure it doesn't get resurrected.  We
+	 * could probe the lower levels at this point to find out whether there
+	 * is actually anything that needs whiting out.
+	 *
+	 * Note that if this fails, it may leave the lower dentry exposed, and
+	 * we may not be able to recover by simply renaming back (say we
+	 * encountered ENOMEM or ENOSPC conditions).
+	 */
+	if (IS_DIR_UNIONED(oldnd.path.dentry))
+		error = vfs_whiteout_after_rename(old_dir, &oldnd.last);
+
 exit6:
 	mnt_drop_write(oldnd.path.mnt);
 exit5:

