Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421Ab0CRTZv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 15:25:51 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:60545 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143Ab0CRTZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 15:25:48 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/urgent 2/2] rcu: remove INIT_RCU_HEAD, RCU_HEAD_INIT, RCU_HEAD
Date: Thu, 18 Mar 2010 12:25:34 -0700
Message-Id: <1268940334-10892-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <20100318192513.GA10832@linux.vnet.ibm.com>
References: <20100318192513.GA10832@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Dobriyan <adobriyan@gmail.com>

call_rcu() will unconditionally reinitialize RCU head anyway.  New users
of these macros constantly appear, so remove them.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 Documentation/DocBook/kernel-locking.tmpl   |    8 --------
 arch/powerpc/mm/pgtable.c                   |    1 -
 block/cfq-iosched.c                         |    1 -
 block/genhd.c                               |    1 -
 drivers/staging/batman-adv/hard-interface.c |    1 -
 fs/file.c                                   |    3 ---
 fs/fs-writeback.c                           |    1 -
 fs/partitions/check.c                       |    1 -
 include/linux/init_task.h                   |    1 -
 include/linux/rcupdate.h                    |    6 ------
 mm/backing-dev.c                            |    1 -
 mm/slob.c                                   |    1 -
 security/selinux/avc.c                      |    1 -
 security/selinux/netnode.c                  |    2 --
 14 files changed, 0 insertions(+), 29 deletions(-)

diff --git a/Documentation/DocBook/kernel-locking.tmpl b/Documentation/DocBook/kernel-locking.tmpl
index 084f6ad..e6cc574 100644
--- a/Documentation/DocBook/kernel-locking.tmpl
+++ b/Documentation/DocBook/kernel-locking.tmpl
@@ -1725,14 +1725,6 @@ the amount of locking which needs to be done.
          if (++cache_num > MAX_CACHE_SIZE) {
                  struct object *i, *outcast = NULL;
                  list_for_each_entry(i, &amp;cache, list) {
-@@ -85,6 +94,7 @@
-         obj-&gt;popularity = 0;
-         atomic_set(&amp;obj-&gt;refcnt, 1); /* The cache holds a reference */
-         spin_lock_init(&amp;obj-&gt;lock);
-+        INIT_RCU_HEAD(&amp;obj-&gt;rcu);
-
-         spin_lock_irqsave(&amp;cache_lock, flags);
-         __cache_add(obj);
 @@ -104,12 +114,11 @@
  struct object *cache_find(int id)
  {
diff --git a/arch/powerpc/mm/pgtable.c b/arch/powerpc/mm/pgtable.c
index 99df697..82e38d1 100644
--- a/arch/powerpc/mm/pgtable.c
+++ b/arch/powerpc/mm/pgtable.c
@@ -91,7 +91,6 @@ static void pte_free_rcu_callback(struct rcu_head *head)
 
 static void pte_free_submit(struct pte_freelist_batch *batch)
 {
-	INIT_RCU_HEAD(&batch->rcu);
 	call_rcu(&batch->rcu, pte_free_rcu_callback);
 }
 
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index dee9d93..caa2100 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -3719,7 +3719,6 @@ static void *cfq_init_queue(struct request_queue *q)
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
index 76fc4d5..a79d6c3 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -77,7 +77,6 @@ static inline bool bdi_work_on_stack(struct bdi_work *work)
 static inline void bdi_work_init(struct bdi_work *work,
 				 struct wb_writeback_args *args)
 {
-	INIT_RCU_HEAD(&work->rcu_head);
 	work->args = *args;
 	work->state = WS_USED;
 }
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index e8865c1..03608a4 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -455,7 +455,6 @@ struct hd_struct *add_partition(struct gendisk *disk, int partno,
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
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 872a98e..7dd951e 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -77,12 +77,6 @@ extern void rcu_scheduler_starting(void);
 #error "Unknown RCU implementation specified to kernel configuration"
 #endif
 
-#define RCU_HEAD_INIT	{ .next = NULL, .func = NULL }
-#define RCU_HEAD(head) struct rcu_head head = RCU_HEAD_INIT
-#define INIT_RCU_HEAD(ptr) do { \
-       (ptr)->next = NULL; (ptr)->func = NULL; \
-} while (0)
-
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 
 extern struct lockdep_map rcu_lock_map;
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 0e8ca03..4745647 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -653,7 +653,6 @@ int bdi_init(struct backing_dev_info *bdi)
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
index 7100072..3dae9ef 100644
--- a/security/selinux/netnode.c
+++ b/security/selinux/netnode.c
@@ -182,8 +182,6 @@ static void sel_netnode_insert(struct sel_netnode *node)
 		BUG();
 	}
 
-	INIT_RCU_HEAD(&node->rcu);
-
 	/* we need to impose a limit on the growth of the hash table so check
 	 * this bucket to make sure it is within the specified bounds */
 	list_add_rcu(&node->list, &sel_netnode_hash[idx].list);
-- 
1.7.0

