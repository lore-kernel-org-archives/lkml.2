Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758343Ab0FOSmf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 14:42:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2100 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932240Ab0FOSm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 14:42:29 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 22/38] union-mount: Implement union lookup
Date: Tue, 15 Jun 2010 11:39:52 -0700
Message-Id: <1276627208-17242-23-git-send-email-vaurora@redhat.com>
In-Reply-To: <1276627208-17242-1-git-send-email-vaurora@redhat.com>
References: <1276627208-17242-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement unioned directories, whiteouts, and fallthrus in pathname
lookup routines.  do_lookup() and lookup_hash() call lookup_union()
after looking up the dentry from the top-level file system.
lookup_union() is centered around __lookup_hash(), which does cached
and/or real lookups and revalidates each dentry in the union stack.

XXX - implement negative union cache entries

XXX - What about different permissions on different layers on the same
directory name?  Should complain, fail, test permissions on all
layers, what?
---
 fs/namei.c |  171 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/union.c |   94 +++++++++++++++++++++++++++++++++
 fs/union.h |    7 +++
 3 files changed, 271 insertions(+), 1 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 06aad7e..45be5e5 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -35,6 +35,7 @@
 #include <asm/uaccess.h>
 
 #include "internal.h"
+#include "union.h"
 
 /* [Feb-1997 T. Schoebel-Theuer]
  * Fundamental changes in the pathname lookup mechanisms (namei)
@@ -722,6 +723,160 @@ static __always_inline void follow_dotdot(struct nameidata *nd)
 	follow_mount(&nd->path);
 }
 
+static struct dentry *__lookup_hash(struct qstr *name, struct dentry *base,
+				    struct nameidata *nd);
+
+/*
+ * __lookup_union - Given a path from the topmost layer, lookup and
+ * revalidate each dentry in its union stack, building it if necessary
+ *
+ * @nd - nameidata for the parent of @topmost
+ * @name - pathname from this element on
+ * @topmost - path of the topmost matching dentry
+ *
+ * Given the nameidata and the path of the topmost dentry for this
+ * pathname, lookup, revalidate, and build the associated union stack.
+ * @topmost must be either a negative dentry or a directory, and not a
+ * whiteout.
+ *
+ * This function may stomp nd->path with the path of the parent
+ * directory of lower layer, so the caller must save nd->path and
+ * restore it afterwards.  You probably want to use lookup_union(),
+ * not __lookup_union().
+ */
+
+static int __lookup_union(struct nameidata *nd, struct qstr *name,
+			  struct path *topmost)
+{
+	struct path parent = nd->path;
+	struct path lower, upper;
+	struct union_dir *ud;
+	/* new_ud is the tail of the list of union dirs for this dentry */
+	struct union_dir **next_ud = &topmost->dentry->d_union_dir;
+	int err = 0;
+
+	/*
+	 * upper is either a negative dentry from the top layer, or it
+	 * is the most recent positive dentry for a directory that
+	 * we've seen.
+	 */
+	upper = *topmost;
+
+	/* Go through each dir underlying the parent, looking for a match */
+	for (ud = nd->path.dentry->d_union_dir; ud != NULL; ud = ud->u_lower) {
+		BUG_ON(ud->u_this.dentry->d_count.counter == 0);
+		/* Change the nameidata to point to this level's dir */
+		nd->path = ud->u_this;
+		/* Lookup the child in this level */
+		lower.mnt = mntget(nd->path.mnt);
+		mutex_lock(&nd->path.dentry->d_inode->i_mutex);
+		lower.dentry = __lookup_hash(name, nd->path.dentry, nd);
+		mutex_unlock(&nd->path.dentry->d_inode->i_mutex);
+
+		if (IS_ERR(lower.dentry)) {
+			mntput(lower.mnt);
+			err = PTR_ERR(lower.dentry);
+			goto out;
+		}
+
+		if (!lower.dentry->d_inode) {
+			if (d_is_whiteout(lower.dentry))
+				break;
+			if (IS_OPAQUE(nd->path.dentry->d_inode) &&
+			    !d_is_fallthru(lower.dentry))
+				break;
+			/* Plain old negative! Keep looking */
+			path_put(&lower);
+			continue;
+		}
+
+		/* Finding a non-dir ends the lookup, one way or another */
+		if (!S_ISDIR(lower.dentry->d_inode->i_mode)) {
+			/* Ignore file below dir - invalid */
+			if (upper.dentry->d_inode &&
+			    S_ISDIR(upper.dentry->d_inode->i_mode)) {
+				path_put(&lower);
+				break;
+			}
+			/* Bingo, found our target */
+			dput(topmost->dentry);
+			/* mntput(topmost) done in link_path_walk() */
+			*topmost = lower;
+			break;
+		}
+
+		/* Found a directory. Create the topmost version if it doesn't exist */
+		if (!topmost->dentry->d_inode) {
+			err = union_create_topmost_dir(&parent, name, topmost,
+						       &lower);
+			if (err) {
+				path_put(&lower);
+				return err;
+			}
+		}
+
+		err = union_add_dir(&upper, &lower, next_ud);
+		if (err)
+			break;
+
+		next_ud = &(*next_ud)->u_lower;
+		upper = lower;
+	}
+out:
+	return 0;
+}
+
+/*
+ * lookup_union - revalidate and build union stack for this path
+ *
+ * We borrow the nameidata struct from the topmost layer to do the
+ * revalidation on lower dentries, replacing the topmost parent
+ * directory's path with that of the matching parent dir in each lower
+ * layer.  This wrapper for __lookup_union() saves the topmost layer's
+ * path and restores it when we are done.
+ */
+static int lookup_union(struct nameidata *nd, struct qstr *name,
+			struct path *topmost)
+{
+	struct path saved_path;
+	int err;
+
+	BUG_ON(!IS_MNT_UNION(nd->path.mnt) && !IS_MNT_UNION(topmost->mnt));
+	BUG_ON(!mutex_is_locked(&nd->path.dentry->d_inode->i_mutex));
+
+	saved_path = nd->path;
+	path_get(&saved_path);
+
+	err = __lookup_union(nd, name, topmost);
+
+	nd->path = saved_path;
+	path_put(&saved_path);
+
+	return err;
+}
+
+/*
+ * do_union_lookup - union mount-aware part of do_lookup
+ *
+ * do_lookup()-style wrapper for lookup_union().  Follows mounts.
+ */
+
+static int do_lookup_union(struct nameidata *nd, struct qstr *name,
+			   struct path *topmost)
+{
+	struct dentry *parent = nd->path.dentry;
+	struct inode *dir = parent->d_inode;
+	int err;
+
+	mutex_lock(&dir->i_mutex);
+	err = lookup_union(nd, name, topmost);
+	mutex_unlock(&dir->i_mutex);
+
+	__follow_mount(topmost);
+
+	return err;
+}
+
 /*
  *  It's more convoluted than I'd like it to be, but... it's still fairly
  *  small and for now I'd prefer to have fast path as straight as possible.
@@ -752,6 +907,11 @@ done:
 	path->mnt = mnt;
 	path->dentry = dentry;
 	__follow_mount(path);
+	if (needs_lookup_union(&nd->path, path)) {
+		int err = do_lookup_union(nd, name, path);
+		if (err < 0)
+			return err;
+	}
 	return 0;
 
 need_lookup:
@@ -1223,8 +1383,13 @@ static int lookup_hash(struct nameidata *nd, struct qstr *name,
 		err = PTR_ERR(path->dentry);
 		path->dentry = NULL;
 		path->mnt = NULL;
+		return err;
 	}
+
+	if (needs_lookup_union(&nd->path, path))
+		err = lookup_union(nd, name, path);
 	return err;
+
 }
 
 static int __lookup_one_len(const char *name, struct qstr *this,
@@ -2888,7 +3053,11 @@ SYSCALL_DEFINE4(renameat, int, olddfd, const char __user *, oldname,
 	error = -EXDEV;
 	if (oldnd.path.mnt != newnd.path.mnt)
 		goto exit2;
-
+	/* Rename on union mounts not implemented yet */
+	/* XXX much harsher check than necessary - can do some renames */
+	if (IS_DIR_UNIONED(oldnd.path.dentry) ||
+	    IS_DIR_UNIONED(newnd.path.dentry))
+		goto exit2;
 	old_dir = oldnd.path.dentry;
 	error = -EBUSY;
 	if (oldnd.last_type != LAST_NORM)
diff --git a/fs/union.c b/fs/union.c
index 02abb7c..c089c02 100644
--- a/fs/union.c
+++ b/fs/union.c
@@ -21,6 +21,7 @@
 #include <linux/mount.h>
 #include <linux/fs_struct.h>
 #include <linux/slab.h>
+#include <linux/namei.h>
 
 #include "union.h"
 
@@ -117,3 +118,96 @@ void d_free_unions(struct dentry *dentry)
 	}
 	dentry->d_union_dir = NULL;
 }
+
+/**
+ * needs_lookup_union - Avoid union lookup when not necessary
+ *
+ * @parent_path: path of the parent directory
+ * @path: path of the lookup target
+ *
+ * Check to see if the target needs union lookup.  Two cases need
+ * union lookup: the target is a directory, and the target is a
+ * negative dentry.
+ *
+ * Returns 0 if this dentry is definitely not unioned.  Returns 1 if
+ * it is possible this dentry is unioned.
+ */
+
+int needs_lookup_union(struct path *parent_path, struct path *path)
+{
+	/*
+	 * If the target is the root of the mount, then its union
+	 * stack was already created at mount time (if this is a union
+	 * mount).
+	 */
+	if (IS_ROOT(path->dentry))
+		return 0;
+
+	/* Only dentries in a unioned directory need a union lookup. */
+	if (!IS_DIR_UNIONED(parent_path->dentry))
+		return 0;
+
+	/* Whiteouts cover up everything below */
+	if (d_is_whiteout(path->dentry))
+		return 0;
+
+	/* Opaque dirs cover except if this is a fallthru */
+	if (IS_OPAQUE(parent_path->dentry->d_inode) &&
+	    !d_is_fallthru(path->dentry))
+		return 0;
+
+	/*
+	 * XXX Negative dentries in unioned directories must always go
+	 * through a full union lookup because there might be a
+	 * matching entry below it.  To improve performance, we should
+	 * mark negative dentries in some way to show they have
+	 * already been looked up in the union and nothing was found.
+	 * Maybe mark it opaque?
+	 */
+	if (!path->dentry->d_inode)
+		return 1;
+
+	/*
+	 * If it's not a directory and it's a positive dentry, then we
+	 * already have the topmost dentry and we don't need to do any
+	 * lookup in lower layers.
+	 */
+
+	if (!S_ISDIR(path->dentry->d_inode->i_mode))
+		return 0;
+
+	/* Is the union stack already constructed? */
+	if (IS_DIR_UNIONED(path->dentry))
+		return 0;
+
+	/*
+	 * XXX This is like the negative dentry case.  This directory
+	 * may have no matching directories in the lower layers, or
+	 * this may just be the first time we looked it up.  We can't
+	 * tell the difference.
+	 */
+	return 1;
+}
+
+/*
+ * union_create_topmost_dir - Create a matching dir in the topmost file system
+ */
+
+int union_create_topmost_dir(struct path *parent, struct qstr *name,
+			     struct path *topmost, struct path *lower)
+{
+	int mode = lower->dentry->d_inode->i_mode;
+	int res;
+
+	BUG_ON(topmost->dentry->d_inode);
+
+	res = mnt_want_write(parent->mnt);
+	if (res)
+		return res;
+
+	res = vfs_mkdir(parent->dentry->d_inode, topmost->dentry, mode);
+
+	mnt_drop_write(parent->mnt);
+
+	return res;
+}
diff --git a/fs/union.h b/fs/union.h
index 04efc1f..505f132 100644
--- a/fs/union.h
+++ b/fs/union.h
@@ -51,15 +51,22 @@ struct union_dir {
 };
 
 #define IS_MNT_UNION(mnt)	((mnt)->mnt_flags & MNT_UNION)
+#define IS_DIR_UNIONED(dentry)	((dentry)->d_union_dir)
 
 extern int union_add_dir(struct path *, struct path *, struct union_dir **);
 extern void d_free_unions(struct dentry *);
+int needs_lookup_union(struct path *, struct path *);
+int union_create_topmost_dir(struct path *, struct qstr *, struct path *,
+			     struct path *);
 
 #else /* CONFIG_UNION_MOUNT */
 
 #define IS_MNT_UNION(x)			(0)
+#define IS_DIR_UNIONED(x)		(0)
 #define union_add_dir(x, y, z)		({ BUG(); (NULL); })
 #define d_free_unions(x)		do { } while (0)
+#define needs_lookup_union(x, y)	({ (0); })
+#define union_create_topmost_dir(w, x, y, z)	({ BUG(); (NULL); })
 
 #endif	/* CONFIG_UNION_MOUNT */
 #endif	/* __KERNEL__ */
-- 
1.6.3.3

