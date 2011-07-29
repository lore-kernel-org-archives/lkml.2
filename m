Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491Ab1G2NpP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 09:45:15 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:36715 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754349Ab1G2NpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
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
Subject: [PATCH 1/4] Keep nr_dentry per super block
Date: Fri, 29 Jul 2011 17:44:16 +0400
Message-Id: <1311947059-17209-2-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1311947059-17209-1-git-send-email-glommer@parallels.com>
References: <1311947059-17209-1-git-send-email-glommer@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have per-sb shrinkers, it makes sense to have nr_dentries
stored per sb as well. We turn them into per-cpu counters so we can
keep acessing them without locking.

Signed-off-by: Glauber Costa <glommer@parallels.com>
CC: Dave Chinner <david@fromorbit.com>
---
 fs/dcache.c        |   18 ++++++++++--------
 fs/super.c         |    2 ++
 include/linux/fs.h |    2 ++
 3 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index b05aac3..9cb6395 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -115,16 +115,18 @@ struct dentry_stat_t dentry_stat = {
 	.age_limit = 45,
 };
 
-static DEFINE_PER_CPU(unsigned int, nr_dentry);
-
 #if defined(CONFIG_SYSCTL) && defined(CONFIG_PROC_FS)
+static void super_nr_dentry(struct super_block *sb, void *arg)
+{
+	int *dentries = arg;
+	*dentries += percpu_counter_sum_positive(&sb->s_nr_dentry);
+}
+
 static int get_nr_dentry(void)
 {
-	int i;
 	int sum = 0;
-	for_each_possible_cpu(i)
-		sum += per_cpu(nr_dentry, i);
-	return sum < 0 ? 0 : sum;
+	iterate_supers(super_nr_dentry, &sum);
+	return sum;
 }
 
 int proc_nr_dentry(ctl_table *table, int write, void __user *buffer,
@@ -151,7 +153,7 @@ static void __d_free(struct rcu_head *head)
 static void d_free(struct dentry *dentry)
 {
 	BUG_ON(dentry->d_count);
-	this_cpu_dec(nr_dentry);
+	percpu_counter_dec(&dentry->d_sb->s_nr_dentry);
 	if (dentry->d_op && dentry->d_op->d_release)
 		dentry->d_op->d_release(dentry);
 
@@ -1225,7 +1227,7 @@ struct dentry *__d_alloc(struct super_block *sb, const struct qstr *name)
 	INIT_LIST_HEAD(&dentry->d_u.d_child);
 	d_set_d_op(dentry, dentry->d_sb->s_d_op);
 
-	this_cpu_inc(nr_dentry);
+	percpu_counter_inc(&dentry->d_sb->s_nr_dentry);
 
 	return dentry;
 }
diff --git a/fs/super.c b/fs/super.c
index 3f56a26..b16d8e8 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -183,6 +183,8 @@ static struct super_block *alloc_super(struct file_system_type *type)
 		s->s_shrink.seeks = DEFAULT_SEEKS;
 		s->s_shrink.shrink = prune_super;
 		s->s_shrink.batch = 1024;
+
+		percpu_counter_init(&s->s_nr_dentry, 0);
 	}
 out:
 	return s;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index f23bcb7..8150f52 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1399,6 +1399,8 @@ struct super_block {
 	struct list_head	s_dentry_lru;	/* unused dentry lru */
 	int			s_nr_dentry_unused;	/* # of dentry on lru */
 
+	struct percpu_counter 	s_nr_dentry;		/* # of dentry on this sb */
+
 	/* s_inode_lru_lock protects s_inode_lru and s_nr_inodes_unused */
 	spinlock_t		s_inode_lru_lock ____cacheline_aligned_in_smp;
 	struct list_head	s_inode_lru;		/* unused inode lru */
-- 
1.7.6

