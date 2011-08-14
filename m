Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812Ab1HNQPS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:15:18 -0400
Received: from mail.globalsuite.net ([69.46.103.200]:53696 "EHLO
	mail.globalsuite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754475Ab1HNQO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:14:56 -0400
X-AuditID: c0a8013c-b7b24ae000000ba8-c7-4e47eb153802
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
        Glauber Costa <glommer@parallels.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v3 3/4] limit nr_dentries per superblock
Date: Sun, 14 Aug 2011 19:13:51 +0400
Message-Id: <1313334832-1150-4-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1313334832-1150-1-git-send-email-glommer@parallels.com>
References: <1313334832-1150-1-git-send-email-glommer@parallels.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch lays the foundation for us to limit the dcache size.
Each super block can have only a maximum amount of dentries under its
sub-tree. Allocation fails if we we're over limit and the cache
can't be pruned to free up space for the newcomers.

Signed-off-by: Glauber Costa <glommer@parallels.com>
CC: Dave Chinner <david@fromorbit.com>
CC: Eric Dumazet <eric.dumazet@gmail.com>
---
 fs/dcache.c        |   28 ++++++++++++++++++++++++++++
 fs/super.c         |    1 +
 include/linux/fs.h |    1 +
 3 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 815d9fd..ddd02a2 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1180,6 +1180,31 @@ void shrink_dcache_parent(struct dentry * parent)
 }
 EXPORT_SYMBOL(shrink_dcache_parent);
 
+static inline int dcache_mem_check(struct super_block *sb)
+{
+	struct shrink_control sc = {
+		.gfp_mask = GFP_KERNEL,
+	};
+
+	if (sb->s_nr_dentry_max == INT_MAX)
+		return 0;
+
+	do {
+		int nr_dentry;
+
+		nr_dentry = percpu_counter_read_positive(&sb->s_nr_dentry);
+		if (nr_dentry > sb->s_nr_dentry_max)
+			nr_dentry =
+				percpu_counter_sum_positive(&sb->s_nr_dentry);
+		if (nr_dentry < sb->s_nr_dentry_max)
+			return 0;
+
+	/* nr_pages = 1, lru_pages = 0 should get delta ~ 2 */
+	} while (shrink_one_shrinker(&sb->s_shrink, &sc, 1, 0));
+
+	return -ENOMEM;
+}
+
 /**
  * __d_alloc	-	allocate a dcache entry
  * @sb: filesystem it will belong to
@@ -1195,6 +1220,9 @@ struct dentry *__d_alloc(struct super_block *sb, const struct qstr *name)
 	struct dentry *dentry;
 	char *dname;
 
+	if (dcache_mem_check(sb))
+		return NULL;
+
 	dentry = kmem_cache_alloc(dentry_cache, GFP_KERNEL);
 	if (!dentry)
 		return NULL;
diff --git a/fs/super.c b/fs/super.c
index e95ac4f..3db40fb 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -121,6 +121,7 @@ static struct super_block *alloc_super(struct file_system_type *type)
 		}
 
 		percpu_counter_init(&s->s_nr_dentry, 0);
+		s->s_nr_dentry_max = INT_MAX;
 
 #ifdef CONFIG_SMP
 		s->s_files = alloc_percpu(struct list_head);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 8150f52..bc773c3 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1400,6 +1400,7 @@ struct super_block {
 	int			s_nr_dentry_unused;	/* # of dentry on lru */
 
 	struct percpu_counter 	s_nr_dentry;		/* # of dentry on this sb */
+	int 			s_nr_dentry_max;	/* max # of dentry on this sb*/
 
 	/* s_inode_lru_lock protects s_inode_lru and s_nr_inodes_unused */
 	spinlock_t		s_inode_lru_lock ____cacheline_aligned_in_smp;
-- 
1.7.6

