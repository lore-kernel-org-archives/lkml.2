Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933305Ab0ECXTb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 19:19:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12545 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932280Ab0ECXNu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 19:13:50 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>, Jan Blunck <jblunck@suse.de>,
       Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 19/39] union-mount: Introduce union_mount structure and basic operations
Date: Mon,  3 May 2010 16:12:18 -0700
Message-Id: <1272928358-20854-20-git-send-email-vaurora@redhat.com>
In-Reply-To: <1272928358-20854-1-git-send-email-vaurora@redhat.com>
References: <1272928358-20854-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Blunck <jblunck@suse.de>

This patch adds the basic structures and operations of VFS-based union
mounts (but not the ability to mount or lookup unioned file systems).
Each directory in a unioned file system has an associated union stack
created when the directory is first looked up.  The union stack is a
structure kept in a hash table indexed by mount and dentry of the
directory; thus, specific paths are unioned, not dentries alone.  The
union stack keeps a pointer to the upper path and the lower path and
can be looked up by either path.

This particular version of union mounts is based on ideas by Jan
Blunck, Bharata Rao, and many others.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 fs/Kconfig             |   13 ++
 fs/Makefile            |    1 +
 fs/dcache.c            |    4 +
 fs/union.c             |  289 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/dcache.h |   18 +++-
 include/linux/mount.h  |    3 +
 include/linux/union.h  |   53 +++++++++
 7 files changed, 380 insertions(+), 1 deletions(-)
 create mode 100644 fs/union.c
 create mode 100644 include/linux/union.h

diff --git a/fs/Kconfig b/fs/Kconfig
index 5f85b59..360227d 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -59,6 +59,19 @@ source "fs/notify/Kconfig"
 
 source "fs/quota/Kconfig"
 
+config UNION_MOUNT
+       bool "Writable overlays (union mounts) (EXPERIMENTAL)"
+       depends on EXPERIMENTAL
+       help
+         Writable overlays allow you to mount a transparent writable
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
index 1575af4..7b47f53 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -960,6 +960,10 @@ struct dentry *d_alloc(struct dentry * parent, const struct qstr *name)
 	INIT_LIST_HEAD(&dentry->d_lru);
 	INIT_LIST_HEAD(&dentry->d_subdirs);
 	INIT_LIST_HEAD(&dentry->d_alias);
+#ifdef CONFIG_UNION_MOUNT
+	INIT_LIST_HEAD(&dentry->d_unions);
+	dentry->d_union_lower_count = 0;
+#endif
 
 	if (parent) {
 		dentry->d_parent = dget(parent);
diff --git a/fs/union.c b/fs/union.c
new file mode 100644
index 0000000..4377cf4
--- /dev/null
+++ b/fs/union.c
@@ -0,0 +1,289 @@
+/*
+ * VFS based union mount for Linux
+ *
+ * Copyright (C) 2004-2007 IBM Corporation, IBM Deutschland Entwicklung GmbH.
+ * Copyright (C) 2007-2009 Novell Inc.
+ *
+ *   Author(s): Jan Blunck (j.blunck@tu-harburg.de)
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ */
+
+#include <linux/bootmem.h>
+#include <linux/init.h>
+#include <linux/types.h>
+#include <linux/hash.h>
+#include <linux/fs.h>
+#include <linux/mount.h>
+#include <linux/fs_struct.h>
+#include <linux/slab.h>
+#include <linux/union.h>
+
+/*
+ * This is borrowed from fs/inode.c. The hashtable for lookups. Somebody
+ * should try to make this good - I've just made it work.
+ */
+static unsigned int union_hash_mask __read_mostly;
+static unsigned int union_hash_shift __read_mostly;
+static struct hlist_head *union_hashtable __read_mostly;
+static unsigned int union_rhash_mask __read_mostly;
+static unsigned int union_rhash_shift __read_mostly;
+static struct hlist_head *union_rhashtable __read_mostly;
+
+/*
+ * Locking Rules:
+ * - dcache_lock (for union_rlookup() only)
+ * - union_lock
+ */
+DEFINE_SPINLOCK(union_lock);
+
+static struct kmem_cache *union_cache __read_mostly;
+
+static unsigned long hash(struct dentry *dentry, struct vfsmount *mnt)
+{
+	unsigned long tmp;
+
+	tmp = ((unsigned long)mnt * (unsigned long)dentry) ^
+		(GOLDEN_RATIO_PRIME + (unsigned long)mnt) / L1_CACHE_BYTES;
+	tmp = tmp ^ ((tmp ^ GOLDEN_RATIO_PRIME) >> union_hash_shift);
+	return tmp & union_hash_mask;
+}
+
+static __initdata unsigned long union_hash_entries;
+
+static int __init set_union_hash_entries(char *str)
+{
+	if (!str)
+		return 0;
+	union_hash_entries = simple_strtoul(str, &str, 0);
+	return 1;
+}
+
+__setup("union_hash_entries=", set_union_hash_entries);
+
+static int __init init_union(void)
+{
+	int loop;
+
+	union_cache = KMEM_CACHE(union_dir, SLAB_PANIC | SLAB_MEM_SPREAD);
+	union_hashtable = alloc_large_system_hash("Union-cache",
+						  sizeof(struct hlist_head),
+						  union_hash_entries,
+						  14,
+						  0,
+						  &union_hash_shift,
+						  &union_hash_mask,
+						  0);
+
+	for (loop = 0; loop < (1 << union_hash_shift); loop++)
+		INIT_HLIST_HEAD(&union_hashtable[loop]);
+
+
+	union_rhashtable = alloc_large_system_hash("rUnion-cache",
+						  sizeof(struct hlist_head),
+						  union_hash_entries,
+						  14,
+						  0,
+						  &union_rhash_shift,
+						  &union_rhash_mask,
+						  0);
+
+	for (loop = 0; loop < (1 << union_rhash_shift); loop++)
+		INIT_HLIST_HEAD(&union_rhashtable[loop]);
+
+	return 0;
+}
+
+fs_initcall(init_union);
+
+static struct union_dir *union_alloc(struct path *upper, struct path *lower)
+{
+	struct union_dir *ud;
+
+	BUG_ON(!S_ISDIR(upper->dentry->d_inode->i_mode));
+	BUG_ON(!S_ISDIR(lower->dentry->d_inode->i_mode));
+
+	ud = kmem_cache_alloc(union_cache, GFP_ATOMIC);
+	if (!ud)
+		return NULL;
+
+	atomic_set(&ud->u_count, 1);
+	INIT_LIST_HEAD(&ud->u_unions);
+	INIT_HLIST_NODE(&ud->u_hash);
+	INIT_HLIST_NODE(&ud->u_rhash);
+
+	ud->u_upper.mnt = upper->mnt;
+	ud->u_upper.dentry = upper->dentry;
+	ud->u_lower.mnt = mntget(lower->mnt);
+	ud->u_lower.dentry = dget(lower->dentry);
+
+	return ud;
+}
+
+struct union_dir *union_get(struct union_dir *ud)
+{
+	BUG_ON(!atomic_read(&ud->u_count));
+	atomic_inc(&ud->u_count);
+	return ud;
+}
+
+static int __union_put(struct union_dir *ud)
+{
+	if (!atomic_dec_and_test(&ud->u_count))
+		return 0;
+
+	BUG_ON(!hlist_unhashed(&ud->u_hash));
+	BUG_ON(!hlist_unhashed(&ud->u_rhash));
+
+	kmem_cache_free(union_cache, ud);
+	return 1;
+}
+
+void union_put(struct union_dir *ud)
+{
+	struct path tmp = ud->u_lower;
+
+	if (__union_put(ud))
+		path_put(&tmp);
+}
+
+static void __union_hash(struct union_dir *ud)
+{
+	hlist_add_head(&ud->u_hash, union_hashtable +
+		       hash(ud->u_upper.dentry, ud->u_upper.mnt));
+	hlist_add_head(&ud->u_rhash, union_rhashtable +
+		       hash(ud->u_lower.dentry, ud->u_lower.mnt));
+}
+
+static void __union_unhash(struct union_dir *ud)
+{
+	hlist_del_init(&ud->u_hash);
+	hlist_del_init(&ud->u_rhash);
+}
+
+static struct union_dir *union_cache_lookup(struct dentry *dentry, struct vfsmount *mnt)
+{
+	struct hlist_head *head = union_hashtable + hash(dentry, mnt);
+	struct hlist_node *node;
+	struct union_dir *ud;
+
+	hlist_for_each_entry(ud, node, head, u_hash) {
+		if ((ud->u_upper.dentry == dentry) &&
+		    (ud->u_upper.mnt == mnt))
+			return ud;
+	}
+
+	return NULL;
+}
+
+static struct union_dir *union_cache_rlookup(struct dentry *dentry, struct vfsmount *mnt)
+{
+	struct hlist_head *head = union_rhashtable + hash(dentry, mnt);
+	struct hlist_node *node;
+	struct union_dir *ud;
+
+	hlist_for_each_entry(ud, node, head, u_rhash) {
+		if ((ud->u_lower.dentry == dentry) &&
+		    (ud->u_lower.mnt == mnt))
+			return ud;
+	}
+
+	return NULL;
+}
+
+/*
+ * append_to_union - add a path to the bottom of the union stack
+ *
+ * Allocate and attach a union cache entry linking the new, upper
+ * mnt/dentry to the "covered" matching lower mnt/dentry.  It's okay
+ * if the union cache entry already exists.
+ */
+
+int append_to_union(struct path *upper, struct path *lower)
+{
+	struct union_dir *new, *ud;
+
+	BUG_ON(!S_ISDIR(upper->dentry->d_inode->i_mode));
+	BUG_ON(!S_ISDIR(lower->dentry->d_inode->i_mode));
+
+	/* Common case is that it's already been created, do a lookup first */
+
+	spin_lock(&union_lock);
+	ud = union_cache_lookup(upper->dentry, upper->mnt);
+	if (ud) {
+		BUG_ON((ud->u_lower.dentry != lower->dentry) ||
+		       (ud->u_lower.mnt != lower->mnt));
+		spin_unlock(&union_lock);
+		return 0;
+	}
+	spin_unlock(&union_lock);
+
+	new = union_alloc(upper, lower);
+	if (!new)
+		return -ENOMEM;
+
+	spin_lock(&union_lock);
+	ud = union_cache_lookup(upper->dentry, upper->mnt);
+	if (ud) {
+		/* Someone added it while we were allocating, no problem */
+		BUG_ON((ud->u_lower.dentry != lower->dentry) ||
+		       (ud->u_lower.mnt != lower->mnt));
+		spin_unlock(&union_lock);
+		union_put(new);
+		return 0;
+	}
+	__union_hash(new);
+	spin_unlock(&union_lock);
+	return 0;
+}
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
+ * union_down_one - get the next lower directory in the union stack
+ *
+ * This is called to traverse the union stack from the given layer to
+ * the next lower layer. union_down_one() is called by various
+ * lookup functions that are aware of union mounts.
+ *
+ * Returns non-zero if followed to the next lower layer, zero otherwise.
+ *
+ * See note on up/down terminology above.
+ */
+int union_down_one(struct vfsmount **mnt, struct dentry **dentry)
+{
+	struct union_dir *ud;
+
+	if (!IS_MNT_UNION(*mnt))
+		return 0;
+
+	spin_lock(&union_lock);
+	ud = union_cache_lookup(*dentry, *mnt);
+	spin_unlock(&union_lock);
+	if (ud) {
+		path_get(&ud->u_lower);
+		dput(*dentry);
+		*dentry = ud->u_lower.dentry;
+		mntput(*mnt);
+		*mnt = ud->u_lower.mnt;
+		return 1;
+	}
+	return 0;
+}
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index e035c51..1745881 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -100,7 +100,23 @@ struct dentry {
 	struct hlist_node d_hash;	/* lookup hash list */
 	struct dentry *d_parent;	/* parent directory */
 	struct qstr d_name;
-
+#ifdef CONFIG_UNION_MOUNT
+	/*
+	 * Union mount structures that reference this dentry as the
+	 * upper layer are linked through the d_unions field.  If this
+	 * list is not empty, then this dentry is part of a unioned
+	 * directory stack.  Protected by union_lock.
+	 */
+	struct list_head d_unions;
+	/*
+	 * Reference count of union_dirs with this dentry in the
+	 * u_lower field of a union mount structure - that is, it is a
+	 * dentry for a lower layer of a union.  This count is NOT
+	 * incremented for the dentry that is part of the topmost
+	 * layer of a union.
+	 */
+	unsigned int d_union_lower_count;
+#endif
 	struct list_head d_lru;		/* LRU list */
 	/*
 	 * d_child and d_rcu can share memory
diff --git a/include/linux/mount.h b/include/linux/mount.h
index f6b714c..0517114 100644
--- a/include/linux/mount.h
+++ b/include/linux/mount.h
@@ -64,6 +64,9 @@ struct vfsmount {
 	struct list_head mnt_slave_list;/* list of slave mounts */
 	struct list_head mnt_slave;	/* slave list entry */
 	struct vfsmount *mnt_master;	/* slave is on master->mnt_slave_list */
+#ifdef CONFIG_UNION_MOUNT
+	struct list_head mnt_unions;	/* list of union_mount structures */
+#endif
 	struct mnt_namespace *mnt_ns;	/* containing namespace */
 	int mnt_id;			/* mount identifier */
 	int mnt_group_id;		/* peer group identifier */
diff --git a/include/linux/union.h b/include/linux/union.h
new file mode 100644
index 0000000..d66beb7
--- /dev/null
+++ b/include/linux/union.h
@@ -0,0 +1,53 @@
+/*
+ * VFS based union mount for Linux
+ *
+ * Copyright (C) 2004-2007 IBM Corporation, IBM Deutschland Entwicklung GmbH.
+ * Copyright (C) 2007 Novell Inc.
+ *   Author(s): Jan Blunck (j.blunck@tu-harburg.de)
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ *
+ */
+#ifndef __LINUX_UNION_H
+#define __LINUX_UNION_H
+#ifdef __KERNEL__
+
+#include <linux/list.h>
+#include <asm/atomic.h>
+
+struct dentry;
+struct vfsmount;
+
+#ifdef CONFIG_UNION_MOUNT
+
+/*
+ * The union mount structure.
+ */
+struct union_dir {
+	atomic_t u_count;		/* reference count */
+	struct list_head u_unions;	/* list head for d_unions */
+	struct list_head u_list;	/* list head for mnt_unions */
+	struct hlist_node u_hash;	/* list head for searching */
+	struct hlist_node u_rhash;	/* list head for reverse searching */
+
+	struct path u_upper;		/* this is me */
+	struct path u_lower;		/* this is what I overlay */
+};
+
+#define IS_MNT_UNION(mnt)	((mnt)->mnt_flags & MNT_UNION)
+
+extern int append_to_union(struct path *, struct path*);
+extern int union_down_one(struct vfsmount **, struct dentry **);
+
+#else /* CONFIG_UNION_MOUNT */
+
+#define IS_MNT_UNION(x)			(0)
+#define append_to_union(x, y)		({ BUG(); (0); })
+#define union_down_one(x, y)		({ (0); })
+
+#endif	/* CONFIG_UNION_MOUNT */
+#endif	/* __KERNEL__ */
+#endif	/* __LINUX_UNION_H */
-- 
1.6.3.3

