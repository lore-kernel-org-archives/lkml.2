Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756446Ab0IPWWW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 18:22:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50795 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755761Ab0IPWOU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 18:14:20 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christoph Hellwig <hch@infradead.org>,
        Andreas Gruenbacher <agruen@suse.de>, Nick Piggin <npiggin@kernel.dk>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 08/34] union-mount: Create union_stack structure
Date: Thu, 16 Sep 2010 15:11:59 -0700
Message-Id: <1284675145-4391-9-git-send-email-vaurora@redhat.com>
In-Reply-To: <1284675145-4391-1-git-send-email-vaurora@redhat.com>
References: <1284675145-4391-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct union_stack records the stack of directories unioned at this
directory.  A union_stack is an array of struct paths, dynamically
allocated when the dentry for the topmost directory is created.  The
topmost dentry contains a pointer to the union_stack.

Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 fs/dcache.c            |    3 ++
 fs/union.h             |   54 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/dcache.h |   22 +++++++++++++++++-
 3 files changed, 77 insertions(+), 2 deletions(-)
 create mode 100644 fs/union.h

diff --git a/fs/dcache.c b/fs/dcache.c
index 2cd367a..85e2737 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -959,6 +959,9 @@ struct dentry *d_alloc(struct dentry * parent, const struct qstr *name)
 	INIT_LIST_HEAD(&dentry->d_lru);
 	INIT_LIST_HEAD(&dentry->d_subdirs);
 	INIT_LIST_HEAD(&dentry->d_alias);
+#ifdef CONFIG_UNION_MOUNT
+	dentry->d_union_stack = NULL;
+#endif
 
 	if (parent) {
 		dentry->d_parent = dget(parent);
diff --git a/fs/union.h b/fs/union.h
new file mode 100644
index 0000000..38b26fd
--- /dev/null
+++ b/fs/union.h
@@ -0,0 +1,54 @@
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
+ * The union_stack structure.  It is an array of struct paths of
+ * directories below the topmost directory in a unioned directory, The
+ * topmost dentry has a pointer to this structure.  The topmost dentry
+ * can only be part of one union, so we can reference it from the
+ * dentry, but lower dentries can be part of multiple union stacks.
+ *
+ * The number of dirs actually allocated is kept in the superblock,
+ * s_union_count.
+ */
+struct union_stack {
+	struct path u_dirs[0];
+};
+
+#endif	/* CONFIG_UNION_MOUNT */
+#endif	/* __KERNEL__ */
+#endif	/* __LINUX_UNION_H */
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 0904716..ed8ef47 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -79,12 +79,28 @@ full_name_hash(const unsigned char *name, unsigned int len)
  * Try to keep struct dentry aligned on 64 byte cachelines (this will
  * give reasonable cacheline footprint with larger lines without the
  * large memory footprint increase).
+ *
+ * XXX DNAME_INLINE_LEN_MIN is kind of pitiful on 64bit + union
+ * mounts.  May be worth tuning up, but either we go to 256 bytes and
+ * a wasteful 88 bytes of d_iname, or we lose 64-byte aligment.
  */
 #ifdef CONFIG_64BIT
+
+#ifdef CONFIG_UNION_MOUNT
+#define DNAME_INLINE_LEN_MIN 24 /* 192 bytes */
+#else
 #define DNAME_INLINE_LEN_MIN 32 /* 192 bytes */
+#endif /* CONFIG_UNION_MOUNT */
+
+#else
+
+#ifdef CONFIG_UNION_MOUNT
+#define DNAME_INLINE_LEN_MIN 36 /* 128 bytes */
 #else
 #define DNAME_INLINE_LEN_MIN 40 /* 128 bytes */
-#endif
+#endif /* CONFIG_UNION_MOUNT */
+
+#endif /* CONFIG_64BIT */
 
 struct dentry {
 	atomic_t d_count;
@@ -100,7 +116,9 @@ struct dentry {
 	struct hlist_node d_hash;	/* lookup hash list */
 	struct dentry *d_parent;	/* parent directory */
 	struct qstr d_name;
-
+#ifdef CONFIG_UNION_MOUNT
+	struct union_stack *d_union_stack;	/* dirs in union stack */
+#endif
 	struct list_head d_lru;		/* LRU list */
 	/*
 	 * d_child and d_rcu can share memory
-- 
1.6.3.3

