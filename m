Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932234Ab0FOSm1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 14:42:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3803 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932207Ab0FOSmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 14:42:17 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 19/38] union-mount: Introduce union_dir structure and basic operations
Date: Tue, 15 Jun 2010 11:39:49 -0700
Message-Id: <1276627208-17242-20-git-send-email-vaurora@redhat.com>
In-Reply-To: <1276627208-17242-1-git-send-email-vaurora@redhat.com>
References: <1276627208-17242-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the basic structures and operations of VFS-based union
mounts (but not the ability to mount or lookup unioned file systems).
Each directory in a unioned file system has an associated union stack
created when the directory is first looked up.  The union stack is a
union_dir structure kept in a hash table indexed by mount and dentry
of the directory; thus, specific paths are unioned, not dentries
alone.  The union_dir keeps a pointer to the upper path and the lower
path and can be looked up by either path.  Currently only two layers
are supported, but the union_dir struct is flexible enough to allow
more than two layers.

This particular version of union mounts is based on ideas by Jan
Blunck, Bharata Rao, and many others.

Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 fs/Kconfig             |   13 +++++
 fs/Makefile            |    1 +
 fs/dcache.c            |    3 +
 fs/union.c             |  119 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/union.h             |   66 ++++++++++++++++++++++++++
 include/linux/dcache.h |    4 +-
 include/linux/fs.h     |    1 +
 7 files changed, 206 insertions(+), 1 deletions(-)
 create mode 100644 fs/union.c
 create mode 100644 fs/union.h

diff --git a/fs/Kconfig b/fs/Kconfig
index 5f85b59..f99c3a9 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -59,6 +59,19 @@ source "fs/notify/Kconfig"
 
 source "fs/quota/Kconfig"
 
+config UNION_MOUNT
+       bool "Union mounts (writable overlasy) (EXPERIMENTAL)"
+       depends on EXPERIMENTAL
+       help
+         Union mounts allow you to mount a transparent writable
+	 layer over a read-only file system, for example, an ext3
+	 partition on a hard drive over a CD-ROM root file system
+	 image.
+
+	 See <file:Documentation/filesystems/union-mounts.txt> for details.
+
+	 If unsure, say N.
+
 source "fs/autofs/Kconfig"
 source "fs/autofs4/Kconfig"
 source "fs/fuse/Kconfig"
diff --git a/fs/Makefile b/fs/Makefile
index 97f340f..1949af2 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -52,6 +52,7 @@ obj-$(CONFIG_NFS_COMMON)	+= nfs_common/
 obj-$(CONFIG_GENERIC_ACL)	+= generic_acl.o
 
 obj-y				+= quota/
+obj-$(CONFIG_UNION_MOUNT)	+= union.o
 
 obj-$(CONFIG_PROC_FS)		+= proc/
 obj-y				+= partitions/
diff --git a/fs/dcache.c b/fs/dcache.c
index 1575af4..54ff5a3 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -960,6 +960,9 @@ struct dentry *d_alloc(struct dentry * parent, const struct qstr *name)
 	INIT_LIST_HEAD(&dentry->d_lru);
 	INIT_LIST_HEAD(&dentry->d_subdirs);
 	INIT_LIST_HEAD(&dentry->d_alias);
+#ifdef CONFIG_UNION_MOUNT
+	dentry->d_union_dir = NULL;
+#endif
 
 	if (parent) {
 		dentry->d_parent = dget(parent);
diff --git a/fs/union.c b/fs/union.c
new file mode 100644
index 0000000..02abb7c
--- /dev/null
+++ b/fs/union.c
@@ -0,0 +1,119 @@
+ /*
+ * VFS-based union mounts for Linux
+ *
+ * Copyright (C) 2004-2007 IBM Corporation, IBM Deutschland Entwicklung GmbH.
+ * Copyright (C) 2007-2009 Novell Inc.
+ * Copyright (C) 2009-2010 Red Hat, Inc.
+ *
+ *   Author(s): Jan Blunck (j.blunck@tu-harburg.de)
+ *              Valerie Aurora <vaurora@redhat.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+#include <linux/bootmem.h>
+#include <linux/init.h>
+#include <linux/types.h>
+#include <linux/fs.h>
+#include <linux/mount.h>
+#include <linux/fs_struct.h>
+#include <linux/slab.h>
+
+#include "union.h"
+
+static struct kmem_cache *union_cache;
+
+static int __init init_union(void)
+{
+	union_cache = KMEM_CACHE(union_dir, SLAB_PANIC | SLAB_MEM_SPREAD);
+	return 0;
+}
+
+fs_initcall(init_union);
+
+/**
+ * union_alloc - allocate a union_dir
+ *
+ * @path: path of directory underneath another directory
+ *
+ * Allocate a union_dir for this directory.  We only allocate
+ * union_dirs for the second and lower layers - the read-only layers.
+ * Top-level dentries don't have a union_dir, just a pointer to the
+ * union_dir of the directory in the layer below it.  u_lower is
+ * initialized to NULL by default.  If there is another layer below
+ * this and a matching directory in the layer, then we allocate a
+ * union_dir for it and then set u_lower of the above union_dir to
+ * point to it.
+ */
+
+static struct union_dir *union_alloc(struct path *path)
+{
+	struct union_dir *ud;
+
+	BUG_ON(!S_ISDIR(path->dentry->d_inode->i_mode));
+
+	ud = kmem_cache_alloc(union_cache, GFP_ATOMIC);
+	if (!ud)
+		return NULL;
+
+	ud->u_this = *path;
+	ud->u_lower = NULL;
+
+	return ud;
+}
+
+static void union_put(struct union_dir *ud)
+{
+	path_put(&ud->u_this);
+	kmem_cache_free(union_cache, ud);
+}
+
+/**
+ * union_add_dir - Add another layer to a unioned directory
+ *
+ * @upper - directory in the previous layer
+ * @lower - directory in the current layer
+ * @next_ud - location of pointer to this union_dir
+ *
+ * Must have a reference (i.e., call path_get()) to @lower before
+ * passing to this function.
+ */
+
+int union_add_dir(struct path *upper, struct path *lower,
+		  struct union_dir **next_ud)
+{
+	struct union_dir *ud;
+
+	BUG_ON(*next_ud != NULL);
+
+	ud = union_alloc(lower);
+	if (!ud)
+		return -ENOMEM;
+	*next_ud = ud;
+
+	return 0;
+}
+
+/**
+ * d_free_unions - free all unions for this dentry
+ *
+ * @dentry - topmost dentry in the union stack to remove
+ *
+ * This must be called when freeing a dentry.
+ */
+void d_free_unions(struct dentry *dentry)
+{
+	struct union_dir *this, *next;
+
+	this = dentry->d_union_dir;
+
+	while (this != NULL) {
+		next = this->u_lower;
+		union_put(this);
+		this = next;
+	}
+	dentry->d_union_dir = NULL;
+}
diff --git a/fs/union.h b/fs/union.h
new file mode 100644
index 0000000..04efc1f
--- /dev/null
+++ b/fs/union.h
@@ -0,0 +1,66 @@
+ /*
+ * VFS-based union mounts for Linux
+ *
+ * Copyright (C) 2004-2007 IBM Corporation, IBM Deutschland Entwicklung GmbH.
+ * Copyright (C) 2007-2009 Novell Inc.
+ * Copyright (C) 2009-2010 Red Hat, Inc.
+ *
+ *   Author(s): Jan Blunck (j.blunck@tu-harburg.de)
+ *              Valerie Aurora <vaurora@redhat.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+#ifndef __LINUX_UNION_H
+#define __LINUX_UNION_H
+#ifdef __KERNEL__
+
+#ifdef CONFIG_UNION_MOUNT
+
+/*
+ * WARNING! Confusing terminology alert.
+ *
+ * Note that the directions "up" and "down" in union mounts are the
+ * opposite of "up" and "down" in normal VFS operation terminology.
+ * "up" in the rest of the VFS means "towards the root of the mount
+ * tree."  If you mount B on top of A, following B "up" will get you
+ * A.  In union mounts, "up" means "towards the most recently mounted
+ * layer of the union stack."  If you union mount B on top of A,
+ * following A "up" will get you to B.  Another way to put it is that
+ * "up" in the VFS means going from this mount towards the direction
+ * of its mnt->mnt_parent pointer, but "up" in union mounts means
+ * going in the opposite direction (until you run out of union
+ * layers).
+ */
+
+/*
+ * The union_dir structure.  Basically just a singly-linked list with
+ * a pointer to the referenced dentry, whose head is d_union_dir in
+ * the dentry of the topmost directory.  We can't link this list
+ * purely through list elements in the dentry because lower layer
+ * dentries can be part of multiple union stacks.  However, the
+ * topmost dentry is only part of one union stack.  So we point at the
+ * lower layer dentries through a linked list rooted in the topmost
+ * dentry.
+ */
+struct union_dir {
+	struct path u_this;		/* this is me */
+	struct union_dir *u_lower;	/* this is what I overlay */
+};
+
+#define IS_MNT_UNION(mnt)	((mnt)->mnt_flags & MNT_UNION)
+
+extern int union_add_dir(struct path *, struct path *, struct union_dir **);
+extern void d_free_unions(struct dentry *);
+
+#else /* CONFIG_UNION_MOUNT */
+
+#define IS_MNT_UNION(x)			(0)
+#define union_add_dir(x, y, z)		({ BUG(); (NULL); })
+#define d_free_unions(x)		do { } while (0)
+
+#endif	/* CONFIG_UNION_MOUNT */
+#endif	/* __KERNEL__ */
+#endif	/* __LINUX_UNION_H */
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 01d6011..509a637 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -100,7 +100,9 @@ struct dentry {
 	struct hlist_node d_hash;	/* lookup hash list */
 	struct dentry *d_parent;	/* parent directory */
 	struct qstr d_name;
-
+#ifdef CONFIG_UNION_MOUNT
+	struct union_dir *d_union_dir;	/* head of union stack */
+#endif
 	struct list_head d_lru;		/* LRU list */
 	/*
 	 * d_child and d_rcu can share memory
diff --git a/include/linux/fs.h b/include/linux/fs.h
index dbd9881..32e6988 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1395,6 +1395,7 @@ struct super_block {
 	 * read-only.
 	 */
 	int s_hard_readonly_users;
+
 };
 
 extern struct timespec current_fs_time(struct super_block *sb);
-- 
1.6.3.3

