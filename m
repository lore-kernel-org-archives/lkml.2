Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935740Ab0HFWkI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 18:40:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965806Ab0HFWg5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 18:36:57 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Valerie Aurora <vaurora@redhat.com>,
        Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH 24/38] union-mount: Copy up directory entries on first readdir()
Date: Fri,  6 Aug 2010 15:35:10 -0700
Message-Id: <1281134124-17041-25-git-send-email-vaurora@redhat.com>
In-Reply-To: <1281134124-17041-1-git-send-email-vaurora@redhat.com>
References: <1281134124-17041-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

readdir() in union mounts is implemented by copying up all visible
directory entries from the lower level directories to the topmost
directory.  Directory entries that refer to lower level file system
objects are marked as "fallthru" in the topmost directory.

Thanks to Felix Fietkau <nbd@openwrt.org> for a bug fix.

XXX - How to deal with fallthrus in lower layers?

Signed-off-by: Valerie Aurora <vaurora@redhat.com>
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 fs/readdir.c |    9 +++
 fs/union.c   |  162 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/union.h   |    2 +
 3 files changed, 173 insertions(+), 0 deletions(-)

diff --git a/fs/readdir.c b/fs/readdir.c
index 3a48491..dd3eae1 100644
--- a/fs/readdir.c
+++ b/fs/readdir.c
@@ -19,6 +19,8 @@
 
 #include <asm/uaccess.h>
 
+#include "union.h"
+
 int vfs_readdir(struct file *file, filldir_t filler, void *buf)
 {
 	struct inode *inode = file->f_path.dentry->d_inode;
@@ -36,9 +38,16 @@ int vfs_readdir(struct file *file, filldir_t filler, void *buf)
 
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
index c089c02..917248d 100644
--- a/fs/union.c
+++ b/fs/union.c
@@ -22,6 +22,8 @@
 #include <linux/fs_struct.h>
 #include <linux/slab.h>
 #include <linux/namei.h>
+#include <linux/file.h>
+#include <linux/security.h>
 
 #include "union.h"
 
@@ -211,3 +213,163 @@ int union_create_topmost_dir(struct path *parent, struct qstr *name,
 
 	return res;
 }
+
+/**
+ * union_copyup_dir_one - copy up a single directory entry
+ *
+ * Individual directory entry copyup function for union_copyup_dir.
+ * We get the entries from higher level layers first.
+ */
+
+static int union_copyup_dir_one(void *buf, const char *name, int namlen,
+				loff_t offset, u64 ino, unsigned int d_type)
+{
+	struct dentry *topmost_dentry = (struct dentry *) buf;
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
+	/*
+	 * If the entry already exists, one of the following is true:
+	 * it was already copied up (due to an earlier lookup), an
+	 * entry with the same name already exists on the topmost file
+	 * system, it is a whiteout, or it is a fallthru.  In each
+	 * case, the top level entry masks any entries from lower file
+	 * systems, so don't copy up this entry.
+	 */
+	if (dentry->d_inode || d_is_whiteout(dentry) || d_is_fallthru(dentry))
+		goto out_dput;
+
+	/*
+	 * If the entry doesn't exist, create a fallthru entry in the
+	 * topmost file system.  All possible directory types are
+	 * used, so each file system must implement its own way of
+	 * storing a fallthru entry.
+	 */
+	err = topmost_dentry->d_inode->i_op->fallthru(topmost_dentry->d_inode,
+						      dentry);
+out_dput:
+	dput(dentry);
+out:
+	return err;
+}
+
+/**
+ * union_copyup_dir - copy up low-level directory entries to topmost dir
+ *
+ * readdir() is difficult to support on union file systems for two
+ * reasons: We must eliminate duplicates and apply whiteouts, and we
+ * must return something in f_pos that lets us restart in the same
+ * place when we return.  Our solution is to, on first readdir() of
+ * the directory, copy up all visible entries from the low-level file
+ * systems and mark the entries that refer to low-level file system
+ * objects as "fallthru" entries.
+ *
+ * Locking strategy: We hold the topmost dir's i_mutex on entry.  We
+ * grab the i_mutex on lower directories one by one.  So the locking
+ * order is:
+ *
+ * Writable/topmost layers > Read-only/lower layers
+ *
+ * So there is no problem with lock ordering for union stacks with
+ * multiple lower layers.  E.g.:
+ *
+ * (topmost) A->B->C (bottom)
+ * (topmost) D->C->B (bottom)
+ *
+ */
+
+int union_copyup_dir(struct path *topmost_path)
+{
+	struct dentry *topmost_dentry = topmost_path->dentry;
+	struct union_dir *ud;
+	int res = 0;
+
+	BUG_ON(IS_OPAQUE(topmost_dentry->d_inode));
+
+	if (!topmost_dentry->d_inode->i_op || !topmost_dentry->d_inode->i_op->fallthru)
+		return -EOPNOTSUPP;
+
+	res = mnt_want_write(topmost_path->mnt);
+	if (res)
+		return res;
+
+	for (ud = topmost_path->dentry->d_union_dir; ud != NULL; ud = ud->u_lower) {
+		struct file * ftmp;
+		struct inode * inode;
+		struct path path;
+
+		BUG_ON(ud->u_this.dentry->d_count.counter == 0);
+		path = ud->u_this;
+		/* dentry_open() doesn't get a path reference itself */
+		path_get(&path);
+		ftmp = dentry_open(path.dentry, path.mnt,
+				   O_RDONLY | O_DIRECTORY | O_NOATIME,
+				   current_cred());
+		if (IS_ERR(ftmp)) {
+			printk (KERN_ERR "unable to open dir %s for "
+				"directory copyup: %ld\n",
+				path.dentry->d_name.name, PTR_ERR(ftmp));
+			path_put(&path);
+			res = PTR_ERR(ftmp);
+			break;
+		}
+
+		inode = path.dentry->d_inode;
+		mutex_lock(&inode->i_mutex);
+
+		res = -ENOENT;
+		if (IS_DEADDIR(inode))
+			goto out_fput;
+		/*
+		 * Read the whole directory, calling our directory
+		 * entry copyup function on each entry.  Pass in the
+		 * topmost dentry as our private data so we can create
+		 * new entries in the topmost directory.
+		 */
+		res = ftmp->f_op->readdir(ftmp, topmost_dentry,
+					  union_copyup_dir_one);
+out_fput:
+		mutex_unlock(&inode->i_mutex);
+		fput(ftmp);
+
+		if (res)
+			break;
+
+		/* XXX Should process directories below an opaque
+		 * directory in case there are fallthrus in it */
+		if (IS_OPAQUE(path.dentry->d_inode))
+			break;
+	}
+	/*
+	 * Mark this dir opaque to show that we have already copied up
+	 * the lower entries.  Be sure to do this AFTER the directory
+	 * entries have been copied up in case of a crash.
+	 */
+	if (!res) {
+		topmost_dentry->d_inode->i_flags |= S_OPAQUE;
+		mark_inode_dirty(topmost_dentry->d_inode);
+	}
+
+	mnt_drop_write(topmost_path->mnt);
+	return res;
+}
diff --git a/fs/union.h b/fs/union.h
index 505f132..80c2421 100644
--- a/fs/union.h
+++ b/fs/union.h
@@ -58,6 +58,7 @@ extern void d_free_unions(struct dentry *);
 int needs_lookup_union(struct path *, struct path *);
 int union_create_topmost_dir(struct path *, struct qstr *, struct path *,
 			     struct path *);
+extern int union_copyup_dir(struct path *);
 
 #else /* CONFIG_UNION_MOUNT */
 
@@ -67,6 +68,7 @@ int union_create_topmost_dir(struct path *, struct qstr *, struct path *,
 #define d_free_unions(x)		do { } while (0)
 #define needs_lookup_union(x, y)	({ (0); })
 #define union_create_topmost_dir(w, x, y, z)	({ BUG(); (NULL); })
+#define union_copyup_dir(x)		({ BUG(); (0); })
 
 #endif	/* CONFIG_UNION_MOUNT */
 #endif	/* __KERNEL__ */
-- 
1.6.3.3

