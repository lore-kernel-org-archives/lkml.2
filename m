Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475Ab2BUSRo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 13:17:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10497 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753171Ab2BUSRk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 13:17:40 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 53/73] union-mount: Copy up directory entries on first
 readdir() [ver #2]
To: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        valerie.aurora@gmail.com
Cc: linux-kernel@vger.kernel.org, Valerie Aurora <vaurora@redhat.com>,
        David Howells <dhowells@redhat.com>
Date: Tue, 21 Feb 2012 18:04:06 +0000
Message-ID: <20120221180406.25235.70803.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
References: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Valerie Aurora <vaurora@redhat.com>

readdir() in union mounts is implemented by copying up all visible
directory entries from the lower level directories to the topmost
directory.  Directory entries that refer to lower level file system
objects are marked as "fallthru" in the topmost directory.

Thanks to Felix Fietkau <nbd@openwrt.org> for a bug fix.

Signed-off-by: Valerie Aurora <vaurora@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/readdir.c |    9 +++
 fs/union.c   |  184 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/union.h   |    7 ++
 3 files changed, 200 insertions(+), 0 deletions(-)

diff --git a/fs/readdir.c b/fs/readdir.c
index de703d6..a87ae02 100644
--- a/fs/readdir.c
+++ b/fs/readdir.c
@@ -20,6 +20,8 @@
 
 #include <asm/uaccess.h>
 
+#include "union.h"
+
 int vfs_readdir(struct file *file, filldir_t filler, void *buf)
 {
 	struct inode *inode = file->f_path.dentry->d_inode;
@@ -37,9 +39,16 @@ int vfs_readdir(struct file *file, filldir_t filler, void *buf)
 
 	res = -ENOENT;
 	if (!IS_DEADDIR(inode)) {
+		if (IS_DIR_UNIONED(file->f_path.dentry) && !IS_OPAQUE(inode)) {
+			res = union_copyup_dir(&file->f_path);
+			if (res)
+				goto out_unlock;
+		}
+
 		res = file->f_op->readdir(file, buf, filler);
 		file_accessed(file);
 	}
+out_unlock:
 	mutex_unlock(&inode->i_mutex);
 out:
 	return res;
diff --git a/fs/union.c b/fs/union.c
index f183051..0c0490f 100644
--- a/fs/union.c
+++ b/fs/union.c
@@ -22,6 +22,8 @@
 #include <linux/namei.h>
 #include <linux/fsnotify.h>
 #include <linux/xattr.h>
+#include <linux/file.h>
+#include <linux/security.h>
 
 #include "union.h"
 
@@ -202,3 +204,185 @@ out:
 	mnt_drop_write(parent->mnt);
 	return error;
 }
+
+struct union_filldir_info {
+	struct dentry *topmost_dentry;
+	int error;
+};
+
+/**
+ * union_copyup_dir_one - copy up a single directory entry
+ *
+ * Individual directory entry copyup function for union_copyup_dir.
+ * We get the entries from higher level layers first.
+ */
+static int union_copyup_dir_one(void *buf, const char *name, int namlen,
+				loff_t offset, u64 ino, unsigned int d_type)
+{
+	struct union_filldir_info *ufi = (struct union_filldir_info *) buf;
+	struct dentry *topmost_dentry = ufi->topmost_dentry;
+	struct dentry *dentry;
+	int err = 0;
+
+	switch (namlen) {
+	case 2:
+		if (name[1] != '.')
+			break;
+	case 1:
+		if (name[0] != '.')
+			break;
+		return 0;
+	}
+
+	/* Lookup this entry in the topmost directory */
+	dentry = lookup_one_len(name, topmost_dentry, namlen);
+
+	if (IS_ERR(dentry)) {
+		printk(KERN_WARNING "%s: error looking up %s\n", __func__,
+		       dentry->d_name.name);
+		err = PTR_ERR(dentry);
+		goto out;
+	}
+
+	/* XXX do we need to revalidate on readdir anyway? think NFS */
+	if (dentry->d_op && dentry->d_op->d_revalidate)
+		goto fallthru;
+
+	/* If the entry already exists, one of the following is true: it was
+	 * already copied up (due to an earlier lookup), an entry with the same
+	 * name already exists on the topmost file system, it is a whiteout, or
+	 * it is a fallthru.  In each case, the top level entry masks any
+	 * entries from lower file systems, so don't copy up this entry.
+	 */
+	if (dentry->d_inode || d_is_whiteout(dentry) || d_is_fallthru(dentry))
+		goto out_dput;
+
+	/* If the entry doesn't exist, create a fallthru entry in the topmost
+	 * file system.  All possible directory types are used, so each file
+	 * system must implement its own way of storing a fallthru entry.
+	 */
+fallthru:
+	err = topmost_dentry->d_inode->i_op->fallthru(topmost_dentry->d_inode,
+						      dentry);
+
+	/* It's okay if it exists, ultimate responsibility rests with
+	 * ->fallthru() */
+	if (err == -EEXIST)
+		err = 0;
+out_dput:
+	dput(dentry);
+out:
+	if (err)
+		ufi->error = err;
+	return err;
+}
+
+/**
+ * union_copyup_dir - copy up low-level directory entries to topmost dir
+ *
+ * readdir() is difficult to support on union file systems for two reasons: We
+ * must eliminate duplicates and apply whiteouts, and we must return something
+ * in f_pos that lets us restart in the same place when we return.  Our
+ * solution is to, on first readdir() of the directory, copy up all visible
+ * entries from the low-level file systems and mark the entries that refer to
+ * low-level file system objects as "fallthru" entries.
+ *
+ * Locking strategy: We hold the topmost dir's i_mutex on entry.  We grab the
+ * i_mutex on lower directories one by one.  So the locking order is:
+ *
+ *	Writable/topmost layers > Read-only/lower layers
+ *
+ * So there is no problem with lock ordering for union stacks with
+ * multiple lower layers.  E.g.:
+ *
+ *	(topmost) A->B->C (bottom)
+ *	(topmost) D->C->B (bottom)
+ *
+ */
+int union_copyup_dir(struct path *topmost_path)
+{
+	struct union_filldir_info ufi;
+	struct dentry *topmost_dentry = topmost_path->dentry;
+	unsigned int i, layers = topmost_dentry->d_sb->s_union_count;
+	int error = 0;
+
+	BUG_ON(IS_OPAQUE(topmost_dentry->d_inode));
+
+	if (!topmost_dentry->d_inode->i_op ||
+	    !topmost_dentry->d_inode->i_op->fallthru)
+		return -EOPNOTSUPP;
+
+	error = mnt_want_write(topmost_path->mnt);
+	if (error)
+		return error;
+
+	for (i = 0; i < layers; i++) {
+		struct file * ftmp;
+		struct inode * inode;
+		struct path *path;
+
+		path = union_find_dir(topmost_dentry, i);
+		if (!path->mnt)
+			continue;
+
+		/* dentry_open() doesn't get a path reference itself */
+		path_get(path);
+		ftmp = dentry_open(path->dentry, path->mnt,
+				   O_RDONLY | O_DIRECTORY | O_NOATIME,
+				   current_cred());
+		if (IS_ERR(ftmp)) {
+			printk (KERN_ERR "unable to open dir %s for "
+				"directory copyup: %ld\n",
+				path->dentry->d_name.name, PTR_ERR(ftmp));
+			path_put(path);
+			error = PTR_ERR(ftmp);
+			break;
+		}
+
+		inode = path->dentry->d_inode;
+		mutex_lock(&inode->i_mutex);
+
+		error = -ENOENT;
+		if (IS_DEADDIR(inode))
+			goto out_fput;
+
+		/* Read the whole directory, calling our directory entry copyup
+		 * function on each entry.
+		 */
+		ufi.topmost_dentry = topmost_dentry;
+		ufi.error = 0;
+		error = ftmp->f_op->readdir(ftmp, &ufi, union_copyup_dir_one);
+out_fput:
+		mutex_unlock(&inode->i_mutex);
+		fput(ftmp);
+
+		if (ufi.error)
+			error = ufi.error;
+		if (error)
+			break;
+
+		/* XXX Should process directories below an opaque directory in
+		 * case there are fallthrus in it
+		 */
+		if (IS_OPAQUE(path->dentry->d_inode))
+			break;
+	}
+
+	/* Mark this dir opaque to show that we have already copied up the
+	 * lower entries.  Be sure to do this AFTER the directory entries have
+	 * been copied up so that if we crash in the middle of copyup, we will
+	 * try to copyup the dir next time we read it.
+	 *
+	 * XXX - Could leave directory non-opaque, and force reread/copyup of
+	 * directory each time it is read in from disk.  That would make it
+	 * easy to update lower file systems (when not union mounted) and have
+	 * the changes show up when union mounted again.
+	 */
+	if (!error) {
+		topmost_dentry->d_inode->i_flags |= S_OPAQUE;
+		mark_inode_dirty(topmost_dentry->d_inode);
+	}
+
+	mnt_drop_write(topmost_path->mnt);
+	return error;
+}
diff --git a/fs/union.h b/fs/union.h
index 48a9277..a77bd5f 100644
--- a/fs/union.h
+++ b/fs/union.h
@@ -70,6 +70,7 @@ extern void d_free_unions(struct dentry *);
 extern int union_add_dir(struct path *, struct path *, unsigned int);
 extern int union_create_topmost_dir(struct path *, struct qstr *, struct path *,
 				    struct path *);
+extern int union_copyup_dir(struct path *);
 
 static inline
 struct path *union_find_dir(struct dentry *dentry, unsigned int layer)
@@ -130,4 +131,10 @@ static inline bool needs_lookup_union(struct path *parent_path, struct path *pat
 	return false;
 }
 
+static inline int union_copyup_dir(struct path *topmost_path)
+{
+	BUG();
+	return 0;
+}
+
 #endif	/* CONFIG_UNION_MOUNT */

