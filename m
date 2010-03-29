Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124Ab0C2OkM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 10:40:12 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:60663 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752837Ab0C2Ojj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 10:39:39 -0400
Message-Id: <20100329143702.275371911@efficios.com>
References: <20100329143405.252313609@efficios.com>
User-Agent: quilt/0.46-1
Date: Mon, 29 Mar 2010 10:34:08 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com,
       laijs@cn.fujitsu.com, dipankar@in.ibm.com, josh@joshtriplett.org,
       dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
       peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, eric.dumazet@gmail.com, adobriyan@gmail.com,
       "David S. Miller" <davem@davemloft.net>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [patch 3/5] remove all rcu head initializations, except on_stack initializations
Content-Disposition: inline; filename=remove-all-rcu-head-initializations.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Mon, 29 Mar 2010 14:37:02 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 arch/powerpc/mm/pgtable.c                   |    1 
 block/cfq-iosched.c                         |    1 
 block/genhd.c                               |    1 
 drivers/staging/batman-adv/hard-interface.c |    1 
 fs/file.c                                   |    3 --
 fs/fs-writeback.c                           |   31 +++++++++++++++++++++++-----
 fs/partitions/check.c                       |    1 
 include/linux/init_task.h                   |    1 
 kernel/rcutiny.c                            |    6 +++++
 kernel/rcutorture.c                         |    2 +
 kernel/rcutree.c                            |    4 +++
 mm/backing-dev.c                            |    1 
 mm/slob.c                                   |    1 
 security/selinux/avc.c                      |    1 
 security/selinux/netnode.c                  |    2 -
 15 files changed, 38 insertions(+), 19 deletions(-)

Index: linux.trees.git/kernel/rcutiny.c
===================================================================
--- linux.trees.git.orig/kernel/rcutiny.c	2010-03-29 10:17:50.000000000 -0400
+++ linux.trees.git/kernel/rcutiny.c	2010-03-29 10:18:05.000000000 -0400
@@ -244,11 +244,13 @@ void rcu_barrier(void)
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
 
@@ -256,11 +258,13 @@ void rcu_barrier_bh(void)
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
 
@@ -268,11 +272,13 @@ void rcu_barrier_sched(void)
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
 
Index: linux.trees.git/kernel/rcutorture.c
===================================================================
--- linux.trees.git.orig/kernel/rcutorture.c	2010-03-29 10:17:50.000000000 -0400
+++ linux.trees.git/kernel/rcutorture.c	2010-03-29 10:18:05.000000000 -0400
@@ -464,9 +464,11 @@ static void rcu_bh_torture_synchronize(v
 {
 	struct rcu_bh_torture_synchronize rcu;
 
+	init_rcu_head_on_stack(&rcu.head);
 	init_completion(&rcu.completion);
 	call_rcu_bh(&rcu.head, rcu_bh_torture_wakeme_after_cb);
 	wait_for_completion(&rcu.completion);
+	destroy_rcu_head_on_stack(&rcu.head);
 }
 
 static struct rcu_torture_ops rcu_bh_ops = {
Index: linux.trees.git/kernel/rcutree.c
===================================================================
--- linux.trees.git.orig/kernel/rcutree.c	2010-03-29 10:17:50.000000000 -0400
+++ linux.trees.git/kernel/rcutree.c	2010-03-29 10:18:05.000000000 -0400
@@ -1449,11 +1449,13 @@ void synchronize_sched(void)
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
 
@@ -1473,11 +1475,13 @@ void synchronize_rcu_bh(void)
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
 
Index: linux.trees.git/mm/backing-dev.c
===================================================================
--- linux.trees.git.orig/mm/backing-dev.c	2010-03-29 10:17:50.000000000 -0400
+++ linux.trees.git/mm/backing-dev.c	2010-03-29 10:18:05.000000000 -0400
@@ -653,7 +653,6 @@ int bdi_init(struct backing_dev_info *bd
 	bdi->max_ratio = 100;
 	bdi->max_prop_frac = PROP_FRAC_BASE;
 	spin_lock_init(&bdi->wb_lock);
-	INIT_RCU_HEAD(&bdi->rcu_head);
 	INIT_LIST_HEAD(&bdi->bdi_list);
 	INIT_LIST_HEAD(&bdi->wb_list);
 	INIT_LIST_HEAD(&bdi->work_list);
Index: linux.trees.git/mm/slob.c
===================================================================
--- linux.trees.git.orig/mm/slob.c	2010-03-29 10:17:50.000000000 -0400
+++ linux.trees.git/mm/slob.c	2010-03-29 10:18:05.000000000 -0400
@@ -647,7 +647,6 @@ void kmem_cache_free(struct kmem_cache *
 	if (unlikely(c->flags & SLAB_DESTROY_BY_RCU)) {
 		struct slob_rcu *slob_rcu;
 		slob_rcu = b + (c->size - sizeof(struct slob_rcu));
-		INIT_RCU_HEAD(&slob_rcu->head);
 		slob_rcu->size = c->size;
 		call_rcu(&slob_rcu->head, kmem_rcu_free);
 	} else {
Index: linux.trees.git/fs/file.c
===================================================================
--- linux.trees.git.orig/fs/file.c	2010-03-29 10:17:50.000000000 -0400
+++ linux.trees.git/fs/file.c	2010-03-29 10:18:05.000000000 -0400
@@ -178,7 +178,6 @@ static struct fdtable * alloc_fdtable(un
 	fdt->open_fds = (fd_set *)data;
 	data += nr / BITS_PER_BYTE;
 	fdt->close_on_exec = (fd_set *)data;
-	INIT_RCU_HEAD(&fdt->rcu);
 	fdt->next = NULL;
 
 	return fdt;
@@ -312,7 +311,6 @@ struct files_struct *dup_fd(struct files
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
Index: linux.trees.git/fs/fs-writeback.c
===================================================================
--- linux.trees.git.orig/fs/fs-writeback.c	2010-03-29 10:17:50.000000000 -0400
+++ linux.trees.git/fs/fs-writeback.c	2010-03-29 10:18:05.000000000 -0400
@@ -74,12 +74,33 @@ static inline bool bdi_work_on_stack(str
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
@@ -232,11 +253,11 @@ static void bdi_sync_writeback(struct ba
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
Index: linux.trees.git/fs/partitions/check.c
===================================================================
--- linux.trees.git.orig/fs/partitions/check.c	2010-03-29 10:17:50.000000000 -0400
+++ linux.trees.git/fs/partitions/check.c	2010-03-29 10:18:05.000000000 -0400
@@ -455,7 +455,6 @@ struct hd_struct *add_partition(struct g
 	}
 
 	/* everything is up and running, commence */
-	INIT_RCU_HEAD(&p->rcu_head);
 	rcu_assign_pointer(ptbl->part[partno], p);
 
 	/* suppress uevent if the disk supresses it */
Index: linux.trees.git/block/cfq-iosched.c
===================================================================
--- linux.trees.git.orig/block/cfq-iosched.c	2010-03-29 10:17:50.000000000 -0400
+++ linux.trees.git/block/cfq-iosched.c	2010-03-29 10:18:05.000000000 -0400
@@ -3719,7 +3719,6 @@ static void *cfq_init_queue(struct reque
 	 * second, in order to have larger depth for async operations.
 	 */
 	cfqd->last_delayed_sync = jiffies - HZ;
-	INIT_RCU_HEAD(&cfqd->rcu);
 	return cfqd;
 }
 
Index: linux.trees.git/block/genhd.c
===================================================================
--- linux.trees.git.orig/block/genhd.c	2010-03-29 10:17:50.000000000 -0400
+++ linux.trees.git/block/genhd.c	2010-03-29 10:18:05.000000000 -0400
@@ -987,7 +987,6 @@ int disk_expand_part_tbl(struct gendisk 
 	if (!new_ptbl)
 		return -ENOMEM;
 
-	INIT_RCU_HEAD(&new_ptbl->rcu_head);
 	new_ptbl->len = target;
 
 	for (i = 0; i < len; i++)
Index: linux.trees.git/arch/powerpc/mm/pgtable.c
===================================================================
--- linux.trees.git.orig/arch/powerpc/mm/pgtable.c	2010-03-29 10:17:50.000000000 -0400
+++ linux.trees.git/arch/powerpc/mm/pgtable.c	2010-03-29 10:18:05.000000000 -0400
@@ -91,7 +91,6 @@ static void pte_free_rcu_callback(struct
 
 static void pte_free_submit(struct pte_freelist_batch *batch)
 {
-	INIT_RCU_HEAD(&batch->rcu);
 	call_rcu(&batch->rcu, pte_free_rcu_callback);
 }
 
Index: linux.trees.git/security/selinux/avc.c
===================================================================
--- linux.trees.git.orig/security/selinux/avc.c	2010-03-29 10:17:50.000000000 -0400
+++ linux.trees.git/security/selinux/avc.c	2010-03-29 10:18:05.000000000 -0400
@@ -288,7 +288,6 @@ static struct avc_node *avc_alloc_node(v
 	if (!node)
 		goto out;
 
-	INIT_RCU_HEAD(&node->rhead);
 	INIT_HLIST_NODE(&node->list);
 	avc_cache_stats_incr(allocations);
 
Index: linux.trees.git/security/selinux/netnode.c
===================================================================
--- linux.trees.git.orig/security/selinux/netnode.c	2010-03-29 10:17:50.000000000 -0400
+++ linux.trees.git/security/selinux/netnode.c	2010-03-29 10:18:05.000000000 -0400
@@ -182,8 +182,6 @@ static void sel_netnode_insert(struct se
 		BUG();
 	}
 
-	INIT_RCU_HEAD(&node->rcu);
-
 	/* we need to impose a limit on the growth of the hash table so check
 	 * this bucket to make sure it is within the specified bounds */
 	list_add_rcu(&node->list, &sel_netnode_hash[idx].list);
Index: linux.trees.git/drivers/staging/batman-adv/hard-interface.c
===================================================================
--- linux.trees.git.orig/drivers/staging/batman-adv/hard-interface.c	2010-03-29 10:17:50.000000000 -0400
+++ linux.trees.git/drivers/staging/batman-adv/hard-interface.c	2010-03-29 10:18:05.000000000 -0400
@@ -301,7 +301,6 @@ int hardif_add_interface(char *dev, int 
 	batman_if->if_num = if_num;
 	batman_if->dev = dev;
 	batman_if->if_active = IF_INACTIVE;
-	INIT_RCU_HEAD(&batman_if->rcu);
 
 	printk(KERN_INFO "batman-adv:Adding interface: %s\n", dev);
 	avail_ifs++;
Index: linux.trees.git/include/linux/init_task.h
===================================================================
--- linux.trees.git.orig/include/linux/init_task.h	2010-03-29 10:17:50.000000000 -0400
+++ linux.trees.git/include/linux/init_task.h	2010-03-29 10:18:05.000000000 -0400
@@ -49,7 +49,6 @@ extern struct group_info init_groups;
 		{ .first = &init_task.pids[PIDTYPE_PGID].node },	\
 		{ .first = &init_task.pids[PIDTYPE_SID].node },		\
 	},								\
-	.rcu		= RCU_HEAD_INIT,				\
 	.level		= 0,						\
 	.numbers	= { {						\
 		.nr		= 0,					\

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
