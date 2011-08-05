Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095Ab1HEAgn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 20:36:43 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:14033 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753772Ab1HEAgi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 20:36:38 -0400
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
Subject: [PATCH v2 3/4] limit nr_dentries per superblock
Date: Fri,  5 Aug 2011 04:35:43 +0400
Message-Id: <1312504544-1108-4-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1312504544-1108-1-git-send-email-glommer@parallels.com>
References: <1312504544-1108-1-git-send-email-glommer@parallels.com>
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
 fs/dcache.c        |   25 +++++++++++++++++++++++++
 fs/super.c         |    1 +
 include/linux/fs.h |    1 +
 3 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index ac19d24..52a0faf 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1180,6 +1180,28 @@ void shrink_dcache_parent(struct dentry * parent)
 }
 EXPORT_SYMBOL(shrink_dcache_parent);
 
+static int dcache_mem_check(struct super_block *sb)
+{
+	int i;
+	int nr_dentry;
+	struct shrink_control sc = {
+		.gfp_mask = GFP_KERNEL,
+	};
+
+	do {
+		nr_dentry = 0;
+		for_each_possible_cpu(i)
+			nr_dentry += per_cpu(*sb->s_nr_dentry, i);
+
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
@@ -1195,6 +1217,9 @@ struct dentry *__d_alloc(struct super_block *sb, const struct qstr *name)
 	struct dentry *dentry;
 	char *dname;
 
+	if (dcache_mem_check(sb))
+		return NULL;
+
 	dentry = kmem_cache_alloc(dentry_cache, GFP_KERNEL);
 	if (!dentry)
 		return NULL;
diff --git a/fs/super.c b/fs/super.c
index 9345385..d9bcae8 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -130,6 +130,7 @@ static struct super_block *alloc_super(struct file_system_type *type)
 		}
 		for_each_possible_cpu(i)
 			*per_cpu_ptr(s->s_nr_dentry, i) = 0;
+		s->s_nr_dentry_max = INT_MAX;
 
 #ifdef CONFIG_SMP
 		s->s_files = alloc_percpu(struct list_head);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 35113fd..e90dcb4 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1399,6 +1399,7 @@ struct super_block {
 	struct list_head	s_dentry_lru;	/* unused dentry lru */
 	int			s_nr_dentry_unused;	/* # of dentry on lru */
 
+	int 			s_nr_dentry_max;	/* max # of dentry on this sb*/
 	int __percpu 		*s_nr_dentry;		/* # of dentry on this sb */
 
 	/* s_inode_lru_lock protects s_inode_lru and s_nr_inodes_unused */
-- 
1.7.6

