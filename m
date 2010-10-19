Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758006Ab0JSW7v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 18:59:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15704 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757941Ab0JSW7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 18:59:49 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 5/6] IMA: use rbtree instead of radix tree for inode
	information cache
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Cc: hch@infradead.org, zohar@us.ibm.com, warthog9@kernel.org,
        david@fromorbit.com, jmorris@namei.org, kyle@mcmartin.ca,
        hpa@zytor.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, mingo@elte.hu, eparis@redhat.com,
        viro@zeniv.linux.org.uk
Date: Tue, 19 Oct 2010 18:58:39 -0400
Message-ID: <20101019225839.12396.92630.stgit@paris.rdu.redhat.com>
In-Reply-To: <20101019225813.12396.2564.stgit@paris.rdu.redhat.com>
References: <20101019225813.12396.2564.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The IMA code needs to store the number of tasks which have an open fd
granting permission to write a file even when IMA is not in use.  It needs
this information in order to be enabled at a later point in time without
losing it's integrity garantees.  At the moment that means we store a
little bit of data about every inode in a cache.  We use a radix tree key'd
on the inode's memory address.  Dave Chinner pointed out that a radix tree
is a terrible data structure for such a sparse key space.  This patch
switches to using an rbtree which should be more efficient.

Bug report from Dave:

 I just noticed that slabtop
was reportingi an awfully high usage of radix tree nodes:

 OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME
4200331 2778082  66%    0.55K 144839       29   2317424K radix_tree_node
2321500 2060290  88%    1.00K  72581       32   2322592K xfs_inode
2235648 2069791  92%    0.12K  69864       32    279456K iint_cache

That is, 2.7M radix tree nodes are allocated, and the cache itself
is consuming 2.3GB of RAM. I know that the XFS inodei caches are
indexed by radix tree node, but for 2 million cached inodes that
would mean a density of 1 inode per radix tree node, which for a
system with 16M inodes in the filsystems is an impossibly low
density. The worst I've seen in a production system like kernel.org
is about 20-25% density, which would mean about 150−200k radix tree
nodes for that many inodes. So it's not the inode cache.

So I looked up what the iint_cache was. It appears to used for storing
per-inode IMA information, and uses a radix tree for indexing.
It uses the *address* of the struct inode as the indexing key. That
means the key space is extremely sparse - for XFS the struct inode
addresses are approximately 1000 bytes apart, which means the
closest the radix tree index keys get is ~1000. Which means
that there is a single entry per radix tree leaf node, so the radix
tree is using roughly 550 bytes for every 120byte structure being
cached. For the above example, it's probably wasting close to 1GB of
RAM....

Reported-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Eric Paris <eparis@redhat.com>
---

 security/integrity/ima/ima.h      |    4 +-
 security/integrity/ima/ima_iint.c |   85 ++++++++++++++++++++++++++++---------
 2 files changed, 67 insertions(+), 22 deletions(-)

diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index 0767717..386026a 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -101,6 +101,8 @@ static inline unsigned long ima_hash_key(u8 *digest)
 
 /* integrity data associated with an inode */
 struct ima_iint_cache {
+	struct rb_node rb_node; /* rooted in ima_iint_tree */
+	struct inode *inode;	/* back pointer to inode in question */
 	u64 version;		/* track inode changes */
 	unsigned long flags;
 	u8 digest[IMA_DIGEST_SIZE];
@@ -120,7 +122,7 @@ int ima_store_template(struct ima_template_entry *entry, int violation,
 void ima_template_show(struct seq_file *m, void *e,
 		       enum ima_show_type show);
 
-/* radix tree calls to lookup, insert, delete
+/* rbtree tree calls to lookup, insert, delete
  * integrity data associated with an inode.
  */
 struct ima_iint_cache *ima_iint_insert(struct inode *inode);
diff --git a/security/integrity/ima/ima_iint.c b/security/integrity/ima/ima_iint.c
index 0bab052..bef6e8f 100644
--- a/security/integrity/ima/ima_iint.c
+++ b/security/integrity/ima/ima_iint.c
@@ -12,21 +12,48 @@
  * File: ima_iint.c
  * 	- implements the IMA hooks: ima_inode_alloc, ima_inode_free
  *	- cache integrity information associated with an inode
- *	  using a radix tree.
+ *	  using a rbtree tree.
  */
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/spinlock.h>
-#include <linux/radix-tree.h>
+#include <linux/rbtree.h>
 #include "ima.h"
 
-RADIX_TREE(ima_iint_store, GFP_ATOMIC);
+static struct rb_root ima_iint_tree = RB_ROOT;
 DEFINE_SPINLOCK(ima_iint_lock);
 static struct kmem_cache *iint_cache __read_mostly;
 
 int iint_initialized = 0;
 
-/* ima_iint_find_get - return the iint associated with an inode
+/*
+ * __ima_iint_find - return the iint associated with an inode
+ *
+ * The caller must hold either the rcu_read_lock or the ima_iint_lock
+ */
+static struct ima_iint_cache *__ima_iint_find(struct inode *inode)
+{
+	struct ima_iint_cache *iint;
+	struct rb_node *n = ima_iint_tree.rb_node;
+
+	while (n) {
+		iint = rb_entry(n, struct ima_iint_cache, rb_node);
+
+		if (inode < iint->inode)
+			n = n->rb_left;
+		else if (inode > iint->inode)
+			n = n->rb_right;
+		else
+			break;
+	}
+	if (!n)
+		return NULL;
+
+	return iint;
+}
+
+/*
+ * ima_iint_find_get - return the iint associated with an inode
  *
  * ima_iint_find_get gets a reference to the iint. Caller must
  * remember to put the iint reference.
@@ -36,12 +63,11 @@ struct ima_iint_cache *ima_iint_find_get(struct inode *inode)
 	struct ima_iint_cache *iint;
 
 	rcu_read_lock();
-	iint = radix_tree_lookup(&ima_iint_store, (unsigned long)inode);
-	if (!iint)
-		goto out;
-	kref_get(&iint->refcount);
-out:
+	iint = __ima_iint_find(inode);
+	if (iint)
+		kref_get(&iint->refcount);
 	rcu_read_unlock();
+
 	return iint;
 }
 
@@ -51,24 +77,39 @@ out:
  */
 int ima_inode_alloc(struct inode *inode)
 {
-	struct ima_iint_cache *iint = NULL;
+	struct rb_node **p;
+	struct rb_node *new_node, *parent = NULL;
+	struct ima_iint_cache *new_iint, *test_iint;
 	int rc = 0;
 
-	iint = kmem_cache_alloc(iint_cache, GFP_NOFS);
-	if (!iint)
+	new_iint = kmem_cache_alloc(iint_cache, GFP_NOFS);
+	if (!new_iint)
 		return -ENOMEM;
 
-	rc = radix_tree_preload(GFP_NOFS);
-	if (rc < 0)
-		goto out;
+	new_iint->inode = inode;
+	new_node = &new_iint->rb_node;
 
 	spin_lock(&ima_iint_lock);
-	rc = radix_tree_insert(&ima_iint_store, (unsigned long)inode, iint);
-	spin_unlock(&ima_iint_lock);
-	radix_tree_preload_end();
+
+	p = &ima_iint_tree.rb_node;
+	while (*p) {
+		parent = *p;
+		test_iint = rb_entry(parent, struct ima_iint_cache, rb_node);
+
+		if (inode < test_iint->inode)
+			p = &(*p)->rb_left;
+		else if (inode > test_iint->inode)
+			p = &(*p)->rb_right;
+		else {
+			rc = -EEXIST;
+			goto out;
+		}
+	}
+
+	rb_link_node(new_node, parent, p);
+	rb_insert_color(new_node, &ima_iint_tree);
 out:
-	if (rc < 0)
-		kmem_cache_free(iint_cache, iint);
+	spin_unlock(&ima_iint_lock);
 
 	return rc;
 }
@@ -113,7 +154,9 @@ void ima_inode_free(struct inode *inode)
 	struct ima_iint_cache *iint;
 
 	spin_lock(&ima_iint_lock);
-	iint = radix_tree_delete(&ima_iint_store, (unsigned long)inode);
+	iint = __ima_iint_find(inode);
+	if (iint)
+		rb_erase(&iint->rb_node, &ima_iint_tree);
 	spin_unlock(&ima_iint_lock);
 	if (iint)
 		call_rcu(&iint->rcu, iint_rcu_free);

