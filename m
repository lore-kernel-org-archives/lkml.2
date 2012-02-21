Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075Ab2BUT7L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 14:59:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17214 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755199Ab2BUTx5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 14:53:57 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 21/73] union-mount: Create union_stack structure [ver #2]
To: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        valerie.aurora@gmail.com
Cc: linux-kernel@vger.kernel.org, Valerie Aurora <vaurora@redhat.com>,
        David Howells <dhowells@redhat.com>
Date: Tue, 21 Feb 2012 18:00:10 +0000
Message-ID: <20120221180010.25235.14553.stgit@warthog.procyon.org.uk>
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

struct union_stack records the stack of directories unioned at this
directory.  A union_stack is an array of struct paths, dynamically
allocated when the dentry for the topmost directory is created.  The
topmost dentry contains a pointer to the union_stack.

Signed-off-by: Valerie Aurora <vaurora@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/dcache.c            |    3 +++
 fs/union.h             |   53 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/dcache.h |   25 ++++++++++++++++++++++-
 3 files changed, 80 insertions(+), 1 deletions(-)
 create mode 100644 fs/union.h

diff --git a/fs/dcache.c b/fs/dcache.c
index 238684a..326a432 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1222,6 +1222,9 @@ struct dentry *__d_alloc(struct super_block *sb, const struct qstr *name)
 	dentry->d_sb = sb;
 	dentry->d_op = NULL;
 	dentry->d_fsdata = NULL;
+#ifdef CONFIG_UNION_MOUNT
+	dentry->d_union_stack = NULL;
+#endif
 	INIT_HLIST_BL_NODE(&dentry->d_hash);
 	INIT_LIST_HEAD(&dentry->d_lru);
 	INIT_LIST_HEAD(&dentry->d_subdirs);
diff --git a/fs/union.h b/fs/union.h
new file mode 100644
index 0000000..d42dc09
--- /dev/null
+++ b/fs/union.h
@@ -0,0 +1,53 @@
+/*
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
+#ifdef CONFIG_UNION_MOUNT
+
+#include <linux/mount.h>
+#include <linux/dcache.h>
+#include <linux/path.h>
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
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index cc0181b..e2d44e1 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -102,16 +102,36 @@ full_name_hash(const unsigned char *name, unsigned int len)
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
+# define DNAME_INLINE_LEN 24 /* 192 bytes */
+#else
 # define DNAME_INLINE_LEN 32 /* 192 bytes */
+#endif /* CONFIG_UNION_MOUNT */
+
+#else
+
+#ifdef CONFIG_UNION_MOUNT
+# ifdef CONFIG_SMP
+#  define DNAME_INLINE_LEN 32 /* 128 bytes */
+# else
+#  define DNAME_INLINE_LEN 36 /* 128 bytes */
+# endif
 #else
 # ifdef CONFIG_SMP
 #  define DNAME_INLINE_LEN 36 /* 128 bytes */
 # else
 #  define DNAME_INLINE_LEN 40 /* 128 bytes */
 # endif
-#endif
+#endif /* CONFIG_UNION_MOUNT */
+
+#endif /* CONFIG_64BIT */
 
 struct dentry {
 	/* RCU lookup touched fields */
@@ -132,6 +152,9 @@ struct dentry {
 	unsigned long d_time;		/* used by d_revalidate */
 	void *d_fsdata;			/* fs-specific data */
 
+#ifdef CONFIG_UNION_MOUNT
+	struct union_stack *d_union_stack;	/* dirs in union stack */
+#endif
 	struct list_head d_lru;		/* LRU list */
 	/*
 	 * d_child and d_rcu can share memory

