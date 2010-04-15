Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932354Ab0DOXL4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 19:11:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22792 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932266Ab0DOXHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 19:07:06 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Valerie Aurora <vaurora@redhat.com>, Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH 23/35] union-mount: Copy up directory entries on first readdir()
Date: Thu, 15 Apr 2010 16:04:30 -0700
Message-Id: <1271372682-21225-24-git-send-email-vaurora@redhat.com>
In-Reply-To: <1271372682-21225-23-git-send-email-vaurora@redhat.com>
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
 <1271372682-21225-21-git-send-email-vaurora@redhat.com>
 <1271372682-21225-22-git-send-email-vaurora@redhat.com>
 <1271372682-21225-23-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

readdir() in union mounts is implemented by copying up all visible
directory entries from the lower level directories to the topmost
directory.  Directory entries that refer to lower level file system
objects are marked as "fallthru" in the topmost directory.

Thanks to Felix Fietkau <nbd@openwrt.org> for a bug fix.

Signed-off-by: Valerie Aurora <vaurora@redhat.com>
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 fs/readdir.c          |    9 +++
 fs/union.c            |  160 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/union.h |    2 +
 3 files changed, 171 insertions(+), 0 deletions(-)

diff --git a/fs/readdir.c b/fs/readdir.c
index 3a48491..da71515 100644
--- a/fs/readdir.c
+++ b/fs/readdir.c
@@ -16,6 +16,8 @@
 #include <linux/security.h>
 #include <linux/syscalls.h>
 #include <linux/unistd.h>
+#include <linux/union.h>
+#include <linux/mount.h>
 
 #include <asm/uaccess.h>
 
@@ -36,9 +38,16 @@ int vfs_readdir(struct file *file, filldir_t filler, void *buf)
 
 	res = -ENOENT;
 	if (!IS_DEADDIR(inode)) {
+		if (IS_UNIONED_DIR(&file->f_path) && !IS_OPAQUE(inode)) {
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
index 8ad9de7..e2384ad 100644
--- a/fs/union.c
+++ b/fs/union.c
@@ -5,6 +5,7 @@
  * Copyright (C) 2007-2009 Novell Inc.
  *
  *   Author(s): Jan Blunck (j.blunck@tu-harburg.de)
+ *              Valerie Aurora <vaurora@redhat.com>
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the Free
@@ -23,6 +24,8 @@
 #include <linux/slab.h>
 #include <linux/union.h>
 #include <linux/namei.h>
+#include <linux/file.h>
+#include <linux/security.h>
 
 /*
  * This is borrowed from fs/inode.c. The hashtable for lookups. Somebody
@@ -473,3 +476,160 @@ out:
 	mnt_drop_write(parent->mnt);
 	return dentry;
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
+ * (Not that we support more than two layers at the moment.)
+ */
+
+int union_copyup_dir(struct path *topmost_path)
+{
+	struct dentry *topmost_dentry = topmost_path->dentry;
+	struct path path = *topmost_path;
+	int res = 0;
+
+	BUG_ON(IS_OPAQUE(topmost_dentry->d_inode));
+
+	res = mnt_want_write(topmost_path->mnt);
+	if (res)
+		return res;
+	/*
+	 * Mark this dir opaque to show that we have already copied up
+	 * the lower entries.  Only fallthru entries pass through to
+	 * the underlying file system.
+	 */
+	topmost_dentry->d_inode->i_flags |= S_OPAQUE;
+	mark_inode_dirty(topmost_dentry->d_inode);
+
+	path_get(&path);
+	while (union_down_one(&path.mnt, &path.dentry)) {
+		struct file * ftmp;
+		struct inode * inode;
+
+		/* XXX Permit fallthrus on lower-level? Would need to
+		 * pass in opaque flag to union_copyup_dir_one() and
+		 * only copy up fallthru entries there.  We allow
+		 * fallthrus in lower level opaque directories on
+		 * lookup, so for consistency we should do one or the
+		 * other in both places. */
+		if (IS_OPAQUE(path.dentry->d_inode))
+			break;
+
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
+			continue;
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
+	}
+	path_put(&path);
+	mnt_drop_write(topmost_path->mnt);
+	return res;
+}
diff --git a/include/linux/union.h b/include/linux/union.h
index 189a84d..66deeb2 100644
--- a/include/linux/union.h
+++ b/include/linux/union.h
@@ -51,6 +51,7 @@ extern struct dentry * union_create_topmost_dir(struct path *, struct qstr *,
 						struct path *);
 extern int attach_mnt_union(struct vfsmount *, struct vfsmount *);
 extern void detach_mnt_union(struct vfsmount *);
+extern int union_copyup_dir(struct path *);
 
 #else /* CONFIG_UNION_MOUNT */
 
@@ -64,6 +65,7 @@ extern void detach_mnt_union(struct vfsmount *);
 #define union_create_topmost_dir(x, y, z)	({ BUG(); (NULL); })
 #define attach_mnt_union(x, y)		do { } while (0)
 #define detach_mnt_union(x)		do { } while (0)
+#define union_copyup_dir(x)		({ BUG(); (0); })
 
 #endif	/* CONFIG_UNION_MOUNT */
 #endif	/* __KERNEL__ */
-- 
1.6.3.3

