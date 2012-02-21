Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988Ab2BUUGx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 15:06:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56830 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753386Ab2BUTww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 14:52:52 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 30/73] union-mount: Create needs_lookup_union() [ver #2]
To: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        valerie.aurora@gmail.com
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Tue, 21 Feb 2012 18:01:18 +0000
Message-ID: <20120221180118.25235.36997.stgit@warthog.procyon.org.uk>
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

needs_lookup_union() tests if a path could possibly require a union
lookup.

Original-author: Valerie Aurora <vaurora@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/union.h             |   25 +++++++++++++++++++++++++
 include/linux/dcache.h |    2 ++
 2 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/fs/union.h b/fs/union.h
index 990dd16..757f28c 100644
--- a/fs/union.h
+++ b/fs/union.h
@@ -73,6 +73,26 @@ struct path *union_find_dir(struct dentry *dentry, unsigned int layer)
 	return &dentry->d_union_stack->u_dirs[layer];
 }
 
+/*
+ * Determine whether we need to perform unionmount traversal or the copyup of a
+ * dentry.
+ */
+static inline
+bool needs_lookup_union(struct path *parent_path, struct path *path)
+{
+	if (!IS_DIR_UNIONED(parent_path->dentry))
+		return false;
+
+	/* Either already built or crossed a mountpoint to not-unioned mnt */
+	/* XXX are bind mounts root? think not */
+	if (IS_ROOT(path->dentry))
+		return false;
+
+	/* It's okay not to have the lock; will recheck in lookup_union() */
+	/* XXX set for root dentry at mount? */
+	return !(path->dentry->d_flags & DCACHE_UNION_LOOKUP_DONE);
+}
+
 #else /* CONFIG_UNION_MOUNT */
 
 static inline
@@ -100,4 +120,9 @@ static inline int union_create_topmost_dir(struct path *parent, struct qstr *nam
 	return 0;
 }
 
+static inline bool needs_lookup_union(struct path *parent_path, struct path *path)
+{
+	return false;
+}
+
 #endif	/* CONFIG_UNION_MOUNT */
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index e2d44e1..79833ae 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -245,6 +245,8 @@ struct dentry_operations {
 #define DCACHE_MANAGED_DENTRY \
 	(DCACHE_MOUNTED|DCACHE_NEED_AUTOMOUNT|DCACHE_MANAGE_TRANSIT)
 
+#define DCACHE_UNION_LOOKUP_DONE 0x100000 /* Union lookup was called on this dentry */
+
 extern seqlock_t rename_lock;
 
 static inline int dname_external(struct dentry *dentry)

