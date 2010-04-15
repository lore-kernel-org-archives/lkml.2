Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758002Ab0DOXMP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 19:12:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57612 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932273Ab0DOXG6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 19:06:58 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 20/35] union-mount: Implement union lookup
Date: Thu, 15 Apr 2010 16:04:27 -0700
Message-Id: <1271372682-21225-21-git-send-email-vaurora@redhat.com>
In-Reply-To: <1271372682-21225-20-git-send-email-vaurora@redhat.com>
References: <1271372682-21225-1-git-send-email-vaurora@redhat.com>
 <1271372682-21225-2-git-send-email-vaurora@redhat.com>
 <1271372682-21225-3-git-send-email-vaurora@redhat.com>
 <1271372682-21225-4-git-send-email-vaurora@redhat.com>
 <1271372682-21225-5-git-send-email-vaurora@redhat.com>
 <1271372682-21225-6-git-send-email-vaurora@redhat.com>
 <1271372682-21225-7-git-send-email-vaurora@redhat.com>
 <1271372682-21225-8-git-send-email-vaurora@redhat.com>
 <1271372682-21225-9-git-send-email-vaurora@redhat.com>
 <1271372682-21225-10-git-send-email-vaurora@redhat.com>
 <1271372682-21225-11-git-send-email-vaurora@redhat.com>
 <1271372682-21225-12-git-send-email-vaurora@redhat.com>
 <1271372682-21225-13-git-send-email-vaurora@redhat.com>
 <1271372682-21225-14-git-send-email-vaurora@redhat.com>
 <1271372682-21225-15-git-send-email-vaurora@redhat.com>
 <1271372682-21225-16-git-send-email-vaurora@redhat.com>
 <1271372682-21225-17-git-send-email-vaurora@redhat.com>
 <1271372682-21225-18-git-send-email-vaurora@redhat.com>
 <1271372682-21225-19-git-send-email-vaurora@redhat.com>
 <1271372682-21225-20-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement unioned directories, whiteouts, and fallthrus in pathname
lookup routines.  do_lookup() and lookup_hash() call lookup_union()
after looking up the dentry from the top-level file system.
lookup_union() is centered around __lookup_hash(), which does cached
and/or real lookups and revalidates each dentry in the union stack.

The added cost to a non-union mount pathname lookup in a
CONFIG_UNION_MOUNT kernel is either one or two mount flag tests per
pathname component, in needs_union_lookup().

XXX - implement negative union cache entries
---
 fs/namei.c            |  191 ++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/union.c            |   67 +++++++++++++++++
 include/linux/union.h |    9 +++
 3 files changed, 266 insertions(+), 1 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 991767b..b179062 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -32,6 +32,7 @@
 #include <linux/fcntl.h>
 #include <linux/device_cgroup.h>
 #include <linux/fs_struct.h>
+#include <linux/union.h>
 #include <asm/uaccess.h>
 
 #include "internal.h"
@@ -722,6 +723,181 @@ static __always_inline void follow_dotdot(struct nameidata *nd)
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
+ * @topmost must be either a negative dentry or a directory.
+ *
+ * This function is called both to build a new union stack and to
+ * revalidate a pre-existing union stack.  So we must cope with
+ * already existing union cache entries.
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
+	struct dentry *dentry;
+	struct path upper;
+	struct path lower;
+	int err = 0;
+
+	if (d_is_whiteout(topmost->dentry))
+		return 0;
+
+	if (IS_OPAQUE(nd->path.dentry->d_inode) &&
+	    !d_is_fallthru(topmost->dentry))
+		return 0;
+
+	/* upper is the most recent positive dentry or topmost negative */
+	upper.dentry = dget(topmost->dentry);
+	upper.mnt = mntget(topmost->mnt);
+
+	/* union_down_one() drops a reference, take one */
+	path_get(&nd->path);
+
+	/* Traverse the parent dir's union stack looking for this name */
+	while (union_down_one(&nd->path.mnt, &nd->path.dentry)) {
+		/* Lookup and revalidate the child dentry */
+		lower.mnt = nd->path.mnt;
+		lower.dentry = __lookup_hash(name, nd->path.dentry, nd);
+
+		if (IS_ERR(lower.dentry)) {
+			err = PTR_ERR(lower.dentry);
+			break;
+		}
+
+		if (d_is_whiteout(lower.dentry)) {
+			dput(lower.dentry);
+			break;
+		}
+
+		if (IS_OPAQUE(nd->path.dentry->d_inode) &&
+		    !d_is_fallthru(lower.dentry))
+			break;
+
+		if (!lower.dentry->d_inode) {
+			dput(lower.dentry);
+			continue;
+		}
+
+		/*
+		 * You can't union a file with a directory!  Note that
+		 * if the topmost directory entry is positive, then it
+		 * will be a directory at this point.
+		 */
+		if (topmost->dentry->d_inode &&
+		    !S_ISDIR(lower.dentry->d_inode->i_mode)) {
+			dput(lower.dentry);
+			break;
+		}
+
+		/* Non-dir entries block anything below, so bail out */
+		if (!S_ISDIR(lower.dentry->d_inode->i_mode)) {
+			dput(topmost->dentry);
+			topmost->dentry = lower.dentry;
+			/* mntput() of previous topmost done in link_path_walk() */
+			topmost->mnt = mntget(lower.mnt);
+			break;
+		}
+
+		/* The topmost directory must always exist.  Create if necessary. */
+		if (!topmost->dentry->d_inode) {
+			dentry = union_create_topmost_dir(&parent, name, &lower);
+			if (IS_ERR(dentry)) {
+				err = PTR_ERR(dentry);
+				dput(lower.dentry);
+				break;
+			}
+			dput(topmost->dentry);
+			topmost->dentry = dentry;
+			dput(upper.dentry);
+			upper.dentry = dget(dentry);
+		}
+
+		/* Add new dentry to the union stack (handles already-created case) */
+		err = append_to_union(&upper, &lower);
+		if (err) {
+			dput(lower.dentry);
+			break;
+		}
+
+		path_put(&upper);
+		upper.mnt = mntget(lower.mnt);
+		upper.dentry = lower.dentry;
+	}
+	path_put(&nd->path);
+	path_put(&upper);
+
+	return err;
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
+static int do_union_lookup(struct nameidata *nd, struct qstr *name,
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
@@ -752,6 +928,11 @@ done:
 	path->mnt = mnt;
 	path->dentry = dentry;
 	__follow_mount(path);
+	if (needs_union_lookup(nd->path.mnt, path)) {
+		int err = do_union_lookup(nd, name, path);
+		if (err < 0)
+			return err;
+	}
 	return 0;
 
 need_lookup:
@@ -1223,8 +1404,13 @@ static int lookup_hash(struct nameidata *nd, struct qstr *name,
 		err = PTR_ERR(path->dentry);
 		path->dentry = NULL;
 		path->mnt = NULL;
+		return err;
 	}
+
+	if (needs_union_lookup(nd->path.mnt, path))
+		err = lookup_union(nd, name, path);
 	return err;
+
 }
 
 static int __lookup_one_len(const char *name, struct qstr *this,
@@ -2945,7 +3131,10 @@ SYSCALL_DEFINE4(renameat, int, olddfd, const char __user *, oldname,
 	error = -EXDEV;
 	if (oldnd.path.mnt != newnd.path.mnt)
 		goto exit2;
-
+	/* Rename on union mounts not implemented yet */
+	/* XXX much harsher check than necessary - can do some renames */
+	if (IS_UNIONED_DIR(&oldnd.path) || IS_UNIONED_DIR(&newnd.path))
+		goto exit2;
 	old_dir = oldnd.path.dentry;
 	error = -EBUSY;
 	if (oldnd.last_type != LAST_NORM)
diff --git a/fs/union.c b/fs/union.c
index 4168b62..5011d26 100644
--- a/fs/union.c
+++ b/fs/union.c
@@ -22,6 +22,7 @@
 #include <linux/fs_struct.h>
 #include <linux/slab.h>
 #include <linux/union.h>
+#include <linux/namei.h>
 
 /*
  * This is borrowed from fs/inode.c. The hashtable for lookups. Somebody
@@ -196,6 +197,43 @@ static struct union_mount *union_cache_rlookup(struct dentry *dentry, struct vfs
 }
 
 /*
+ * needs_union_lookup - Does this path need a union lookup?
+ *
+ * @parent_mnt - parent mnt, usually from associated nameidata (nd->path.mnt)
+ * @path - path of potential child union directory
+ *
+ * Short-circuit union operations on paths that can't possibly be
+ * unioned directories or don't need union lookup.
+ */
+
+int needs_union_lookup(struct vfsmount *parent_mnt, struct path *path)
+{
+	/* If this is the root of a mount, ignore the parent */
+	if (IS_ROOT(path->dentry) && !IS_MNT_UNION(path->mnt))
+		return 0;
+
+	/* The child could be from a lower layer, check the parent mnt */
+	if (!IS_MNT_UNION(parent_mnt))
+		return 0;
+
+	/* Only directories can be unioned */
+	if (path->dentry->d_inode &&
+	    !S_ISDIR(path->dentry->d_inode->i_mode))
+		return 0;
+
+	/*
+	 * XXX - A negative dentry for a directory in a unioned
+	 * directory could have a matching directory below it.  Or it
+	 * could not.  Either way, all we have is a negative dentry.
+	 * As a result, negative dentries with unioned parents always
+	 * have to go through a full union lookup.  This can be
+	 * avoided by adding a negative union cache entry for the
+	 * negative dentry.
+	 */
+	return 1;
+}
+
+/*
  * append_to_union - add a path to the bottom of the union stack
  *
  * Allocate and attach a union cache entry linking the new, upper
@@ -343,3 +381,32 @@ repeat:
 	}
 	spin_unlock(&union_lock);
 }
+
+/*
+ * union_create_topmost_dir - Create a matching dir in the topmost file system
+ */
+
+struct dentry * union_create_topmost_dir(struct path *parent, struct qstr *name,
+					 struct path *lower)
+{
+	struct dentry *dentry;
+	int mode = lower->dentry->d_inode->i_mode;
+	int res;
+
+	res = mnt_want_write(parent->mnt);
+	if (res)
+		return ERR_PTR(res);
+
+	dentry = lookup_one_len(name->name, parent->dentry, name->len);
+	if (IS_ERR(dentry))
+		goto out;
+
+	res = vfs_mkdir(parent->dentry->d_inode, dentry, mode);
+	if (res) {
+		dput(dentry);
+		goto out;
+	}
+out:
+	mnt_drop_write(parent->mnt);
+	return dentry;
+}
diff --git a/include/linux/union.h b/include/linux/union.h
index c5ead54..681b472 100644
--- a/include/linux/union.h
+++ b/include/linux/union.h
@@ -38,19 +38,28 @@ struct union_mount {
 };
 
 #define IS_MNT_UNION(mnt)	((mnt)->mnt_flags & MNT_UNION)
+#define IS_UNIONED_DIR(path)	(IS_MNT_UNION((path)->mnt) && \
+				 ((path)->dentry->d_unionized || \
+				  !list_empty(&(path)->dentry->d_unions)))
 
+extern int needs_union_lookup(struct vfsmount *, struct path *);
 extern int append_to_union(struct path *, struct path*);
 extern int union_down_one(struct vfsmount **, struct dentry **);
 extern void __d_drop_unions(struct dentry *);
 extern void shrink_d_unions(struct dentry *);
+extern struct dentry * union_create_topmost_dir(struct path *, struct qstr *,
+						struct path *);
 
 #else /* CONFIG_UNION_MOUNT */
 
 #define IS_MNT_UNION(x)			(0)
+#define IS_UNIONED_DIR(x)		(0)
+#define needs_union_lookup(x, y)	({ (0); })
 #define append_to_union(x, y)		({ BUG(); (0); })
 #define union_down_one(x, y)		({ (0); })
 #define __d_drop_unions(x)		do { } while (0)
 #define shrink_d_unions(x)		do { } while (0)
+#define union_create_topmost_dir(x, y, z)	({ BUG(); (NULL); })
 
 #endif	/* CONFIG_UNION_MOUNT */
 #endif	/* __KERNEL__ */
-- 
1.6.3.3

