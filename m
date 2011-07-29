Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046Ab1G2NpL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 09:45:11 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:28677 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752960Ab1G2NpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 09:45:08 -0400
From: Glauber Costa <glommer@parallels.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, containers@lists.linux-foundation.org,
        Pavel Emelyanov <xemul@parallels.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Nick Piggin <npiggin@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        James Bottomley <JBottomley@parallels.com>,
        David Chinner <david@fromorbit.com>,
        Glauber Costa <glommer@parallels.com>
Subject: [PATCH 2/4] limit nr_dentries per superblock
Date: Fri, 29 Jul 2011 17:44:17 +0400
Message-Id: <1311947059-17209-3-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1311947059-17209-1-git-send-email-glommer@parallels.com>
References: <1311947059-17209-1-git-send-email-glommer@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch lays the foundation for us to limit the dcache size.
Each super block can have only a maximum amount of dentries under its
sub-tree. Allocation fails if we we're over limit and the cache
can't be pruned to free up space for the newcomers.

Signed-off-by: Glauber Costa <glommer@parallels.com>
CC: Dave Chinner <david@fromorbit.com>
---
 fs/dcache.c        |   45 +++++++++++++++++++++++++++++++++++++--------
 fs/super.c         |    1 +
 include/linux/fs.h |    1 +
 3 files changed, 39 insertions(+), 8 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 9cb6395..3bdb106 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -663,7 +663,7 @@ EXPORT_SYMBOL(d_prune_aliases);
  *
  * This may fail if locks cannot be acquired no problem, just try again.
  */
-static void try_prune_one_dentry(struct dentry *dentry)
+static int try_prune_one_dentry(struct dentry *dentry)
 	__releases(dentry->d_lock)
 {
 	struct dentry *parent;
@@ -680,9 +680,9 @@ static void try_prune_one_dentry(struct dentry *dentry)
 	 * fragmentation.
 	 */
 	if (!parent)
-		return;
+		return 1;
 	if (parent == dentry)
-		return;
+		return 0;
 
 	/* Prune ancestors. */
 	dentry = parent;
@@ -691,15 +691,17 @@ static void try_prune_one_dentry(struct dentry *dentry)
 		if (dentry->d_count > 1) {
 			dentry->d_count--;
 			spin_unlock(&dentry->d_lock);
-			return;
+			return 1;
 		}
 		dentry = dentry_kill(dentry, 1);
 	}
+	return 1;
 }
 
-static void shrink_dentry_list(struct list_head *list)
+static int shrink_dentry_list(struct list_head *list)
 {
 	struct dentry *dentry;
+	int pruned = 0;
 
 	rcu_read_lock();
 	for (;;) {
@@ -725,11 +727,13 @@ static void shrink_dentry_list(struct list_head *list)
 
 		rcu_read_unlock();
 
-		try_prune_one_dentry(dentry);
+		pruned += try_prune_one_dentry(dentry);
 
 		rcu_read_lock();
 	}
 	rcu_read_unlock();
+
+	return pruned;
 }
 
 /**
@@ -740,7 +744,7 @@ static void shrink_dentry_list(struct list_head *list)
  *
  * If flags contains DCACHE_REFERENCED reference dentries will not be pruned.
  */
-static void __shrink_dcache_sb(struct super_block *sb, int count, int flags)
+static int __shrink_dcache_sb(struct super_block *sb, int count, int flags)
 {
 	struct dentry *dentry;
 	LIST_HEAD(referenced);
@@ -781,7 +785,7 @@ relock:
 		list_splice(&referenced, &sb->s_dentry_lru);
 	spin_unlock(&dcache_lru_lock);
 
-	shrink_dentry_list(&tmp);
+	return shrink_dentry_list(&tmp);
 }
 
 /**
@@ -1176,6 +1180,28 @@ void shrink_dcache_parent(struct dentry * parent)
 }
 EXPORT_SYMBOL(shrink_dcache_parent);
 
+static int dcache_mem_check(struct super_block *sb)
+{
+	int nr_dentry;
+	int count;
+
+	if (percpu_counter_read_positive(&sb->s_nr_dentry) <=
+						sb->s_nr_dentry_max)
+		return 0;
+
+	do {
+		nr_dentry = percpu_counter_sum_positive(&sb->s_nr_dentry);
+
+		if (nr_dentry < sb->s_nr_dentry_max)
+			return 0;
+
+		count = (nr_dentry - sb->s_nr_dentry_max) << 1;
+
+	} while (__shrink_dcache_sb(sb, count, DCACHE_REFERENCED) > 0);
+
+	return -ENOMEM;
+}
+
 /**
  * __d_alloc	-	allocate a dcache entry
  * @sb: filesystem it will belong to
@@ -1191,6 +1217,9 @@ struct dentry *__d_alloc(struct super_block *sb, const struct qstr *name)
 	struct dentry *dentry;
 	char *dname;
 
+	if (dcache_mem_check(sb))
+		return NULL;
+
 	dentry = kmem_cache_alloc(dentry_cache, GFP_KERNEL);
 	if (!dentry)
 		return NULL;
diff --git a/fs/super.c b/fs/super.c
index b16d8e8..d4ad43a 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -185,6 +185,7 @@ static struct super_block *alloc_super(struct file_system_type *type)
 		s->s_shrink.batch = 1024;
 
 		percpu_counter_init(&s->s_nr_dentry, 0);
+		s->s_nr_dentry_max = INT_MAX;
 	}
 out:
 	return s;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 8150f52..1dfff2e 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1399,6 +1399,7 @@ struct super_block {
 	struct list_head	s_dentry_lru;	/* unused dentry lru */
 	int			s_nr_dentry_unused;	/* # of dentry on lru */
 
+	int 			s_nr_dentry_max;	/* max # of dentry on this sb*/
 	struct percpu_counter 	s_nr_dentry;		/* # of dentry on this sb */
 
 	/* s_inode_lru_lock protects s_inode_lru and s_nr_inodes_unused */
-- 
1.7.6

