Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149Ab0DTVqJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 17:46:09 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:54127 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752764Ab0DTVpS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 17:45:18 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       "David S. Miller" <davem@davemloft.net>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH tip/core/rcu 20/23] remove all rcu head initializations, except on_stack initializations
Date: Tue, 20 Apr 2010 14:44:52 -0700
Message-Id: <1271799895-21028-20-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <20100420214431.GA20777@linux.vnet.ibm.com>
References: <20100420214431.GA20777@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

Remove all rcu head inits. We don't care about the RCU head state before passing
it to call_rcu() anyway. Only leave the "on_stack" variants so debugobjects can
keep track of objects on stack.

This patch applies to current -tip based on 2.6.34-rc2.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: David S. Miller <davem@davemloft.net>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: akpm@linux-foundation.org
CC: mingo@elte.hu
CC: laijs@cn.fujitsu.com
CC: dipankar@in.ibm.com
CC: josh@joshtriplett.org
CC: dvhltc@us.ibm.com
CC: niv@us.ibm.com
CC: tglx@linutronix.de
CC: peterz@infradead.org
CC: rostedt@goodmis.org
CC: Valdis.Kletnieks@vt.edu
CC: dhowells@redhat.com
CC: eric.dumazet@gmail.com
CC: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 arch/powerpc/mm/pgtable.c                   |    1 -
 block/cfq-iosched.c                         |    1 -
 block/genhd.c                               |    1 -
 drivers/staging/batman-adv/hard-interface.c |    1 -
 fs/file.c                                   |    3 --
 fs/fs-writeback.c                           |   31 ++++++++++++++++++++++----
 fs/partitions/check.c                       |    1 -
 include/linux/init_task.h                   |    1 -
 kernel/rcutiny.c                            |    6 +++++
 kernel/rcutorture.c                         |    2 +
 kernel/rcutree.c                            |    4 +++
 mm/backing-dev.c                            |    1 -
 mm/slob.c                                   |    1 -
 security/selinux/avc.c                      |    1 -
 security/selinux/netnode.c                  |    2 -
 15 files changed, 38 insertions(+), 19 deletions(-)

diff --git a/arch/powerpc/mm/pgtable.c b/arch/powerpc/mm/pgtable.c
index ebc2f38..2c7e801 100644
--- a/arch/powerpc/mm/pgtable.c
+++ b/arch/powerpc/mm/pgtable.c
@@ -92,7 +92,6 @@ static void pte_free_rcu_callback(struct rcu_head *head)
 
 static void pte_free_submit(struct pte_freelist_batch *batch)
 {
-	INIT_RCU_HEAD(&batch->rcu);
 	call_rcu(&batch->rcu, pte_free_rcu_callback);
 }
 
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 838834b..0b695dd 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -3741,7 +3741,6 @@ static void *cfq_init_queue(struct request_queue *q)
 	 * second, in order to have larger depth for async operations.
 	 */
 	cfqd->last_delayed_sync = jiffies - HZ;
-	INIT_RCU_HEAD(&cfqd->rcu);
 	return cfqd;
 }
 
diff --git a/block/genhd.c b/block/genhd.c
index d13ba76..27e85a2 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -987,7 +987,6 @@ int disk_expand_part_tbl(struct gendisk *disk, int partno)
 	if (!new_ptbl)
 		return -ENOMEM;
 
-	INIT_RCU_HEAD(&new_ptbl->rcu_head);
 	new_ptbl->len = target;
 
 	for (i = 0; i < len; i++)
diff --git a/drivers/staging/batman-adv/hard-interface.c b/drivers/staging/batman-adv/hard-interface.c
index befd488..96ea0e5 100644
--- a/drivers/staging/batman-adv/hard-interface.c
+++ b/drivers/staging/batman-adv/hard-interface.c
@@ -301,7 +301,6 @@ int hardif_add_interface(char *dev, int if_num)
 	batman_if->if_num = if_num;
 	batman_if->dev = dev;
 	batman_if->if_active = IF_INACTIVE;
-	INIT_RCU_HEAD(&batman_if->rcu);
 
 	printk(KERN_INFO "batman-adv:Adding interface: %s\n", dev);
 	avail_ifs++;
diff --git a/fs/file.c b/fs/file.c
index 34bb7f7..cccaead 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -178,7 +178,6 @@ static struct fdtable * alloc_fdtable(unsigned int nr)
 	fdt->open_fds = (fd_set *)data;
 	data += nr / BITS_PER_BYTE;
 	fdt->close_on_exec = (fd_set *)data;
-	INIT_RCU_HEAD(&fdt->rcu);
 	fdt->next = NULL;
 
 	return fdt;
@@ -312,7 +311,6 @@ struct files_struct *dup_fd(struct files_struct *oldf, int *errorp)
 	new_fdt->close_on_exec = (fd_set *)&newf->close_on_exec_init;
 	new_fdt->open_fds = (fd_set *)&newf->open_fds_init;
 	new_fdt->fd = &newf->fd_array[0];
-	INIT_RCU_HEAD(&new_fdt->rcu);
 	new_fdt->next = NULL;
 
 	spin_lock(&oldf->file_lock);
@@ -430,7 +428,6 @@ struct files_struct init_files = {
 		.fd		= &init_files.fd_array[0],
 		.close_on_exec	= (fd_set *)&init_files.close_on_exec_init,
 		.open_fds	= (fd_set *)&init_files.open_fds_init,
-		.rcu		= RCU_HEAD_INIT,
 	},
 	.file_lock	= __SPIN_LOCK_UNLOCKED(init_task.file_lock),
 };
diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 4b37f7c..ea38c65 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -75,12 +75,33 @@ static inline bool bdi_work_on_stack(struct bdi_work *work)
 	return test_bit(WS_ONSTACK_B, &work->state);
 }
 
-static inline void bdi_work_init(struct bdi_work *work,
-				 struct wb_writeback_args *args)
+static inline void __bdi_work_init(struct bdi_work *work,
+				   struct wb_writeback_args *args,
+				   int on_stack)
 {
-	INIT_RCU_HEAD(&work->rcu_head);
 	work->args = *args;
 	work->state = WS_USED;
+	if (on_stack) {
+		work->state |= WS_ONSTACK;
+		init_rcu_head_on_stack(&work->rcu_head);
+	}
+}
+
+static inline void bdi_work_init(struct bdi_work *work,
+				 struct wb_writeback_args *args)
+{
+	__bdi_work_init(work, args, false);
+}
+
+static inline void bdi_work_init_on_stack(struct bdi_work *work,
+					  struct wb_writeback_args *args)
+{
+	__bdi_work_init(work, args, true);
+}
+
+static inline void bdi_destroy_work_on_stack(struct bdi_work *work)
+{
+	destroy_rcu_head_on_stack(&work->rcu_head);
 }
 
 /**
@@ -233,11 +254,11 @@ static void bdi_sync_writeback(struct backing_dev_info *bdi,
 	};
 	struct bdi_work work;
 
-	bdi_work_init(&work, &args);
-	work.state |= WS_ONSTACK;
+	bdi_work_init_on_stack(&work, &args);
 
 	bdi_queue_work(bdi, &work);
 	bdi_wait_on_work_clear(&work);
+	bdi_destroy_work_on_stack(&work);
 }
 
 /**
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index e238ab2..7444e6f 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -456,7 +456,6 @@ struct hd_struct *add_partition(struct gendisk *disk, int partno,
 	}
 
 	/* everything is up and running, commence */
-	INIT_RCU_HEAD(&p->rcu_head);
 	rcu_assign_pointer(ptbl->part[partno], p);
 
 	/* suppress uevent if the disk supresses it */
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index b1ed1cd..7996fc2 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -49,7 +49,6 @@ extern struct group_info init_groups;
 		{ .first = &init_task.pids[PIDTYPE_PGID].node },	\
 		{ .first = &init_task.pids[PIDTYPE_SID].node },		\
 	},								\
-	.rcu		= RCU_HEAD_INIT,				\
 	.level		= 0,						\
 	.numbers	= { {						\
 		.nr		= 0,					\
diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index b1804ff..38729d3 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -245,11 +245,13 @@ void rcu_barrier(void)
 {
 	struct rcu_synchronize rcu;
 
+	init_rcu_head_on_stack(&rcu.head);
 	init_completion(&rcu.completion);
 	/* Will wake me after RCU finished. */
 	call_rcu(&rcu.head, wakeme_after_rcu);
 	/* Wait for it. */
 	wait_for_completion(&rcu.completion);
+	destroy_rcu_head_on_stack(&rcu.head);
 }
 EXPORT_SYMBOL_GPL(rcu_barrier);
 
@@ -257,11 +259,13 @@ void rcu_barrier_bh(void)
 {
 	struct rcu_synchronize rcu;
 
+	init_rcu_head_on_stack(&rcu.head);
 	init_completion(&rcu.completion);
 	/* Will wake me after RCU finished. */
 	call_rcu_bh(&rcu.head, wakeme_after_rcu);
 	/* Wait for it. */
 	wait_for_completion(&rcu.completion);
+	destroy_rcu_head_on_stack(&rcu.head);
 }
 EXPORT_SYMBOL_GPL(rcu_barrier_bh);
 
@@ -269,11 +273,13 @@ void rcu_barrier_sched(void)
 {
 	struct rcu_synchronize rcu;
 
+	init_rcu_head_on_stack(&rcu.head);
 	init_completion(&rcu.completion);
 	/* Will wake me after RCU finished. */
 	call_rcu_sched(&rcu.head, wakeme_after_rcu);
 	/* Wait for it. */
 	wait_for_completion(&rcu.completion);
+	destroy_rcu_head_on_stack(&rcu.head);
 }
 EXPORT_SYMBOL_GPL(rcu_barrier_sched);
 
diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 58df55b..077defb 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -464,9 +464,11 @@ static void rcu_bh_torture_synchronize(void)
 {
 	struct rcu_bh_torture_synchronize rcu;
 
+	init_rcu_head_on_stack(&rcu.head);
 	init_completion(&rcu.completion);
 	call_rcu_bh(&rcu.head, rcu_bh_torture_wakeme_after_cb);
 	wait_for_completion(&rcu.completion);
+	destroy_rcu_head_on_stack(&rcu.head);
 }
 
 static struct rcu_torture_ops rcu_bh_ops = {
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index ba69969..d443734 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1484,11 +1484,13 @@ void synchronize_sched(void)
 	if (rcu_blocking_is_gp())
 		return;
 
+	init_rcu_head_on_stack(&rcu.head);
 	init_completion(&rcu.completion);
 	/* Will wake me after RCU finished. */
 	call_rcu_sched(&rcu.head, wakeme_after_rcu);
 	/* Wait for it. */
 	wait_for_completion(&rcu.completion);
+	destroy_rcu_head_on_stack(&rcu.head);
 }
 EXPORT_SYMBOL_GPL(synchronize_sched);
 
@@ -1508,11 +1510,13 @@ void synchronize_rcu_bh(void)
 	if (rcu_blocking_is_gp())
 		return;
 
+	init_rcu_head_on_stack(&rcu.head);
 	init_completion(&rcu.completion);
 	/* Will wake me after RCU finished. */
 	call_rcu_bh(&rcu.head, wakeme_after_rcu);
 	/* Wait for it. */
 	wait_for_completion(&rcu.completion);
+	destroy_rcu_head_on_stack(&rcu.head);
 }
 EXPORT_SYMBOL_GPL(synchronize_rcu_bh);
 
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index f13e067..1bba4ae 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -656,7 +656,6 @@ int bdi_init(struct backing_dev_info *bdi)
 	bdi->max_ratio = 100;
 	bdi->max_prop_frac = PROP_FRAC_BASE;
 	spin_lock_init(&bdi->wb_lock);
-	INIT_RCU_HEAD(&bdi->rcu_head);
 	INIT_LIST_HEAD(&bdi->bdi_list);
 	INIT_LIST_HEAD(&bdi->wb_list);
 	INIT_LIST_HEAD(&bdi->work_list);
diff --git a/mm/slob.c b/mm/slob.c
index 837ebd6..6de238d 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -647,7 +647,6 @@ void kmem_cache_free(struct kmem_cache *c, void *b)
 	if (unlikely(c->flags & SLAB_DESTROY_BY_RCU)) {
 		struct slob_rcu *slob_rcu;
 		slob_rcu = b + (c->size - sizeof(struct slob_rcu));
-		INIT_RCU_HEAD(&slob_rcu->head);
 		slob_rcu->size = c->size;
 		call_rcu(&slob_rcu->head, kmem_rcu_free);
 	} else {
diff --git a/security/selinux/avc.c b/security/selinux/avc.c
index 989fef8..bf4e3bc 100644
--- a/security/selinux/avc.c
+++ b/security/selinux/avc.c
@@ -288,7 +288,6 @@ static struct avc_node *avc_alloc_node(void)
 	if (!node)
 		goto out;
 
-	INIT_RCU_HEAD(&node->rhead);
 	INIT_HLIST_NODE(&node->list);
 	avc_cache_stats_incr(allocations);
 
diff --git a/security/selinux/netnode.c b/security/selinux/netnode.c
index dc92792..65ebfe9 100644
--- a/security/selinux/netnode.c
+++ b/security/selinux/netnode.c
@@ -183,8 +183,6 @@ static void sel_netnode_insert(struct sel_netnode *node)
 		BUG();
 	}
 
-	INIT_RCU_HEAD(&node->rcu);
-
 	/* we need to impose a limit on the growth of the hash table so check
 	 * this bucket to make sure it is within the specified bounds */
 	list_add_rcu(&node->list, &sel_netnode_hash[idx].list);
-- 
1.7.0

