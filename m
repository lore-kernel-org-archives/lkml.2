Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624Ab0CSUxf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 16:53:35 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:45409 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751341Ab0CSUxb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 16:53:31 -0400
Message-Id: <20100319205233.738370786@efficios.com>
References: <20100319204739.574593298@efficios.com>
User-Agent: quilt/0.46-1
Date: Fri, 19 Mar 2010 16:47:42 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com,
       laijs@cn.fujitsu.com, dipankar@in.ibm.com, josh@joshtriplett.org,
       dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
       peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, eric.dumazet@gmail.com, adobriyan@gmail.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC patch 3/3] kernel call_rcu usage: initialize rcu_head structures
Content-Disposition: inline; filename=rcu-init-null.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Fri, 19 Mar 2010 20:52:34 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initialize rcu_head structures with rcu_head_init() before passing them to
call_rcu().

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
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
 block/cfq-iosched.c                 |    2 +-
 block/genhd.c                       |    2 +-
 fs/file.c                           |    4 ++--
 fs/fs-writeback.c                   |   13 +++++++++----
 fs/partitions/check.c               |    2 +-
 kernel/fork.c                       |    1 +
 kernel/pid.c                        |    1 +
 kernel/rcutiny.c                    |    6 ++++++
 kernel/rcutorture.c                 |    2 ++
 kernel/rcutree.c                    |    4 ++++
 mm/backing-dev.c                    |    2 +-
 mm/slob.c                           |    2 +-
 net/core/drop_monitor.c             |    2 +-
 net/ipv6/sit.c                      |    2 +-
 net/ipv6/xfrm6_tunnel.c             |    2 +-
 net/netfilter/nf_conntrack_expect.c |    2 +-
 net/netfilter/nf_conntrack_extend.c |    2 +-
 net/netfilter/nfnetlink_queue.c     |    2 +-
 net/netlabel/netlabel_domainhash.c  |    2 +-
 net/netlabel/netlabel_unlabeled.c   |    6 +++---
 net/sctp/bind_addr.c                |    2 +-
 net/sctp/ipv6.c                     |    2 +-
 net/sctp/protocol.c                 |    2 +-
 23 files changed, 43 insertions(+), 24 deletions(-)

Index: linux-2.6-lttng/kernel/pid.c
===================================================================
--- linux-2.6-lttng.orig/kernel/pid.c	2010-03-19 13:23:39.000000000 -0400
+++ linux-2.6-lttng/kernel/pid.c	2010-03-19 13:28:06.000000000 -0400
@@ -265,6 +265,7 @@ struct pid *alloc_pid(struct pid_namespa
 
 	get_pid_ns(ns);
 	pid->level = ns->level;
+	rcu_head_init(&pid->rcu);
 	atomic_set(&pid->count, 1);
 	for (type = 0; type < PIDTYPE_MAX; ++type)
 		INIT_HLIST_HEAD(&pid->tasks[type]);
Index: linux-2.6-lttng/kernel/fork.c
===================================================================
--- linux-2.6-lttng.orig/kernel/fork.c	2010-03-19 13:23:39.000000000 -0400
+++ linux-2.6-lttng/kernel/fork.c	2010-03-19 13:28:06.000000000 -0400
@@ -1062,6 +1062,7 @@ static struct task_struct *copy_process(
 	INIT_LIST_HEAD(&p->children);
 	INIT_LIST_HEAD(&p->sibling);
 	rcu_copy_process(p);
+	rcu_head_init(&p->rcu);
 	p->vfork_done = NULL;
 	spin_lock_init(&p->alloc_lock);
 
Index: linux-2.6-lttng/kernel/rcutiny.c
===================================================================
--- linux-2.6-lttng.orig/kernel/rcutiny.c	2010-03-19 13:23:39.000000000 -0400
+++ linux-2.6-lttng/kernel/rcutiny.c	2010-03-19 13:28:06.000000000 -0400
@@ -246,11 +246,13 @@ void rcu_barrier(void)
 {
 	struct rcu_synchronize rcu;
 
+	rcu_head_init_on_stack(&rcu.head);
 	init_completion(&rcu.completion);
 	/* Will wake me after RCU finished. */
 	call_rcu(&rcu.head, wakeme_after_rcu);
 	/* Wait for it. */
 	wait_for_completion(&rcu.completion);
+	destroy_rcu_head_on_stack(&rcu.head);
 }
 EXPORT_SYMBOL_GPL(rcu_barrier);
 
@@ -258,11 +260,13 @@ void rcu_barrier_bh(void)
 {
 	struct rcu_synchronize rcu;
 
+	rcu_head_init_on_stack(&rcu.head);
 	init_completion(&rcu.completion);
 	/* Will wake me after RCU finished. */
 	call_rcu_bh(&rcu.head, wakeme_after_rcu);
 	/* Wait for it. */
 	wait_for_completion(&rcu.completion);
+	destroy_rcu_head_on_stack(&rcu.head);
 }
 EXPORT_SYMBOL_GPL(rcu_barrier_bh);
 
@@ -270,11 +274,13 @@ void rcu_barrier_sched(void)
 {
 	struct rcu_synchronize rcu;
 
+	rcu_head_init_on_stack(&rcu.head);
 	init_completion(&rcu.completion);
 	/* Will wake me after RCU finished. */
 	call_rcu_sched(&rcu.head, wakeme_after_rcu);
 	/* Wait for it. */
 	wait_for_completion(&rcu.completion);
+	destroy_rcu_head_on_stack(&rcu.head);
 }
 EXPORT_SYMBOL_GPL(rcu_barrier_sched);
 
Index: linux-2.6-lttng/kernel/rcutorture.c
===================================================================
--- linux-2.6-lttng.orig/kernel/rcutorture.c	2010-03-19 13:23:39.000000000 -0400
+++ linux-2.6-lttng/kernel/rcutorture.c	2010-03-19 13:28:06.000000000 -0400
@@ -450,9 +450,11 @@ static void rcu_bh_torture_synchronize(v
 {
 	struct rcu_bh_torture_synchronize rcu;
 
+	rcu_head_init_on_stack(&rcu.head);
 	init_completion(&rcu.completion);
 	call_rcu_bh(&rcu.head, rcu_bh_torture_wakeme_after_cb);
 	wait_for_completion(&rcu.completion);
+	destroy_rcu_head_on_stack(&rcu.head);
 }
 
 static struct rcu_torture_ops rcu_bh_ops = {
Index: linux-2.6-lttng/kernel/rcutree.c
===================================================================
--- linux-2.6-lttng.orig/kernel/rcutree.c	2010-03-19 13:23:39.000000000 -0400
+++ linux-2.6-lttng/kernel/rcutree.c	2010-03-19 13:28:06.000000000 -0400
@@ -1449,11 +1449,13 @@ void synchronize_sched(void)
 	if (rcu_blocking_is_gp())
 		return;
 
+	rcu_head_init_on_stack(&rcu.head);
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
 
+	rcu_head_init_on_stack(&rcu.head);
 	init_completion(&rcu.completion);
 	/* Will wake me after RCU finished. */
 	call_rcu_bh(&rcu.head, wakeme_after_rcu);
 	/* Wait for it. */
 	wait_for_completion(&rcu.completion);
+	destroy_rcu_head_on_stack(&rcu.head);
 }
 EXPORT_SYMBOL_GPL(synchronize_rcu_bh);
 
Index: linux-2.6-lttng/mm/backing-dev.c
===================================================================
--- linux-2.6-lttng.orig/mm/backing-dev.c	2010-03-19 13:23:40.000000000 -0400
+++ linux-2.6-lttng/mm/backing-dev.c	2010-03-19 13:28:06.000000000 -0400
@@ -653,7 +653,7 @@ int bdi_init(struct backing_dev_info *bd
 	bdi->max_ratio = 100;
 	bdi->max_prop_frac = PROP_FRAC_BASE;
 	spin_lock_init(&bdi->wb_lock);
-	INIT_RCU_HEAD(&bdi->rcu_head);
+	rcu_head_init(&bdi->rcu_head);
 	INIT_LIST_HEAD(&bdi->bdi_list);
 	INIT_LIST_HEAD(&bdi->wb_list);
 	INIT_LIST_HEAD(&bdi->work_list);
Index: linux-2.6-lttng/mm/slob.c
===================================================================
--- linux-2.6-lttng.orig/mm/slob.c	2010-03-19 13:23:40.000000000 -0400
+++ linux-2.6-lttng/mm/slob.c	2010-03-19 13:28:06.000000000 -0400
@@ -647,7 +647,7 @@ void kmem_cache_free(struct kmem_cache *
 	if (unlikely(c->flags & SLAB_DESTROY_BY_RCU)) {
 		struct slob_rcu *slob_rcu;
 		slob_rcu = b + (c->size - sizeof(struct slob_rcu));
-		INIT_RCU_HEAD(&slob_rcu->head);
+		rcu_head_init(&slob_rcu->head);
 		slob_rcu->size = c->size;
 		call_rcu(&slob_rcu->head, kmem_rcu_free);
 	} else {
Index: linux-2.6-lttng/fs/file.c
===================================================================
--- linux-2.6-lttng.orig/fs/file.c	2010-03-19 13:23:39.000000000 -0400
+++ linux-2.6-lttng/fs/file.c	2010-03-19 13:28:06.000000000 -0400
@@ -178,7 +178,7 @@ static struct fdtable * alloc_fdtable(un
 	fdt->open_fds = (fd_set *)data;
 	data += nr / BITS_PER_BYTE;
 	fdt->close_on_exec = (fd_set *)data;
-	INIT_RCU_HEAD(&fdt->rcu);
+	rcu_head_init(&fdt->rcu);
 	fdt->next = NULL;
 
 	return fdt;
@@ -312,7 +312,7 @@ struct files_struct *dup_fd(struct files
 	new_fdt->close_on_exec = (fd_set *)&newf->close_on_exec_init;
 	new_fdt->open_fds = (fd_set *)&newf->open_fds_init;
 	new_fdt->fd = &newf->fd_array[0];
-	INIT_RCU_HEAD(&new_fdt->rcu);
+	rcu_head_init(&new_fdt->rcu);
 	new_fdt->next = NULL;
 
 	spin_lock(&oldf->file_lock);
Index: linux-2.6-lttng/fs/fs-writeback.c
===================================================================
--- linux-2.6-lttng.orig/fs/fs-writeback.c	2010-03-19 13:23:39.000000000 -0400
+++ linux-2.6-lttng/fs/fs-writeback.c	2010-03-19 13:28:06.000000000 -0400
@@ -75,9 +75,13 @@ static inline bool bdi_work_on_stack(str
 }
 
 static inline void bdi_work_init(struct bdi_work *work,
-				 struct wb_writeback_args *args)
+				 struct wb_writeback_args *args,
+				 int on_stack)
 {
-	INIT_RCU_HEAD(&work->rcu_head);
+	if (on_stack)
+		rcu_head_init_on_stack(&work->rcu_head);
+	else
+		rcu_head_init(&work->rcu_head);
 	work->args = *args;
 	work->state = WS_USED;
 }
@@ -201,7 +205,7 @@ static void bdi_alloc_queue_work(struct 
 	 */
 	work = kmalloc(sizeof(*work), GFP_ATOMIC);
 	if (work) {
-		bdi_work_init(work, args);
+		bdi_work_init(work, args, 0);
 		bdi_queue_work(bdi, work);
 	} else {
 		struct bdi_writeback *wb = &bdi->wb;
@@ -232,11 +236,12 @@ static void bdi_sync_writeback(struct ba
 	};
 	struct bdi_work work;
 
-	bdi_work_init(&work, &args);
+	bdi_work_init(&work, &args, 1);
 	work.state |= WS_ONSTACK;
 
 	bdi_queue_work(bdi, &work);
 	bdi_wait_on_work_clear(&work);
+	destroy_rcu_head_on_stack(&work.rcu_head);
 }
 
 /**
Index: linux-2.6-lttng/fs/partitions/check.c
===================================================================
--- linux-2.6-lttng.orig/fs/partitions/check.c	2010-03-19 13:23:39.000000000 -0400
+++ linux-2.6-lttng/fs/partitions/check.c	2010-03-19 13:28:06.000000000 -0400
@@ -454,7 +454,7 @@ struct hd_struct *add_partition(struct g
 	}
 
 	/* everything is up and running, commence */
-	INIT_RCU_HEAD(&p->rcu_head);
+	rcu_head_init(&p->rcu_head);
 	rcu_assign_pointer(ptbl->part[partno], p);
 
 	/* suppress uevent if the disk supresses it */
Index: linux-2.6-lttng/block/cfq-iosched.c
===================================================================
--- linux-2.6-lttng.orig/block/cfq-iosched.c	2010-03-19 13:23:40.000000000 -0400
+++ linux-2.6-lttng/block/cfq-iosched.c	2010-03-19 13:28:06.000000000 -0400
@@ -3730,7 +3730,7 @@ static void *cfq_init_queue(struct reque
 	 * second, in order to have larger depth for async operations.
 	 */
 	cfqd->last_delayed_sync = jiffies - HZ;
-	INIT_RCU_HEAD(&cfqd->rcu);
+	rcu_head_init(&cfqd->rcu);
 	return cfqd;
 }
 
Index: linux-2.6-lttng/block/genhd.c
===================================================================
--- linux-2.6-lttng.orig/block/genhd.c	2010-03-19 13:23:40.000000000 -0400
+++ linux-2.6-lttng/block/genhd.c	2010-03-19 13:28:06.000000000 -0400
@@ -987,7 +987,7 @@ int disk_expand_part_tbl(struct gendisk 
 	if (!new_ptbl)
 		return -ENOMEM;
 
-	INIT_RCU_HEAD(&new_ptbl->rcu_head);
+	rcu_head_init(&new_ptbl->rcu_head);
 	new_ptbl->len = target;
 
 	for (i = 0; i < len; i++)
Index: linux-2.6-lttng/net/netfilter/nfnetlink_queue.c
===================================================================
--- linux-2.6-lttng.orig/net/netfilter/nfnetlink_queue.c	2010-03-19 13:23:40.000000000 -0400
+++ linux-2.6-lttng/net/netfilter/nfnetlink_queue.c	2010-03-19 13:28:06.000000000 -0400
@@ -112,7 +112,7 @@ instance_create(u_int16_t queue_num, int
 	inst->copy_mode = NFQNL_COPY_NONE;
 	spin_lock_init(&inst->lock);
 	INIT_LIST_HEAD(&inst->queue_list);
-	INIT_RCU_HEAD(&inst->rcu);
+	rcu_head_init(&inst->rcu);
 
 	if (!try_module_get(THIS_MODULE)) {
 		err = -EAGAIN;
Index: linux-2.6-lttng/net/core/drop_monitor.c
===================================================================
--- linux-2.6-lttng.orig/net/core/drop_monitor.c	2010-03-19 13:23:39.000000000 -0400
+++ linux-2.6-lttng/net/core/drop_monitor.c	2010-03-19 13:28:06.000000000 -0400
@@ -296,7 +296,7 @@ static int dropmon_net_event(struct noti
 
 		new_stat->dev = dev;
 		new_stat->last_rx = jiffies;
-		INIT_RCU_HEAD(&new_stat->rcu);
+		rcu_head_init(&new_stat->rcu);
 		spin_lock(&trace_state_lock);
 		list_add_rcu(&new_stat->list, &hw_stats_list);
 		spin_unlock(&trace_state_lock);
Index: linux-2.6-lttng/net/ipv6/sit.c
===================================================================
--- linux-2.6-lttng.orig/net/ipv6/sit.c	2010-03-19 13:23:39.000000000 -0400
+++ linux-2.6-lttng/net/ipv6/sit.c	2010-03-19 13:28:06.000000000 -0400
@@ -364,7 +364,7 @@ ipip6_tunnel_add_prl(struct ip_tunnel *t
 		goto out;
 	}
 
-	INIT_RCU_HEAD(&p->rcu_head);
+	rcu_head_init(&p->rcu_head);
 	p->next = t->prl;
 	p->addr = a->addr;
 	p->flags = a->flags;
Index: linux-2.6-lttng/net/ipv6/xfrm6_tunnel.c
===================================================================
--- linux-2.6-lttng.orig/net/ipv6/xfrm6_tunnel.c	2010-03-19 13:23:39.000000000 -0400
+++ linux-2.6-lttng/net/ipv6/xfrm6_tunnel.c	2010-03-19 13:28:06.000000000 -0400
@@ -187,7 +187,7 @@ alloc_spi:
 	if (!x6spi)
 		goto out;
 
-	INIT_RCU_HEAD(&x6spi->rcu_head);
+	rcu_head_init(&x6spi->rcu_head);
 	memcpy(&x6spi->addr, saddr, sizeof(x6spi->addr));
 	x6spi->spi = spi;
 	atomic_set(&x6spi->refcnt, 1);
Index: linux-2.6-lttng/net/netfilter/nf_conntrack_expect.c
===================================================================
--- linux-2.6-lttng.orig/net/netfilter/nf_conntrack_expect.c	2010-03-19 13:23:40.000000000 -0400
+++ linux-2.6-lttng/net/netfilter/nf_conntrack_expect.c	2010-03-19 13:28:06.000000000 -0400
@@ -232,7 +232,7 @@ struct nf_conntrack_expect *nf_ct_expect
 
 	new->master = me;
 	atomic_set(&new->use, 1);
-	INIT_RCU_HEAD(&new->rcu);
+	rcu_head_init(&new->rcu);
 	return new;
 }
 EXPORT_SYMBOL_GPL(nf_ct_expect_alloc);
Index: linux-2.6-lttng/net/netfilter/nf_conntrack_extend.c
===================================================================
--- linux-2.6-lttng.orig/net/netfilter/nf_conntrack_extend.c	2010-03-19 13:23:40.000000000 -0400
+++ linux-2.6-lttng/net/netfilter/nf_conntrack_extend.c	2010-03-19 13:28:06.000000000 -0400
@@ -59,7 +59,7 @@ nf_ct_ext_create(struct nf_ct_ext **ext,
 	if (!*ext)
 		return NULL;
 
-	INIT_RCU_HEAD(&(*ext)->rcu);
+	rcu_head_init(&(*ext)->rcu);
 	(*ext)->offset[id] = off;
 	(*ext)->len = len;
 
Index: linux-2.6-lttng/net/netlabel/netlabel_domainhash.c
===================================================================
--- linux-2.6-lttng.orig/net/netlabel/netlabel_domainhash.c	2010-03-19 13:23:39.000000000 -0400
+++ linux-2.6-lttng/net/netlabel/netlabel_domainhash.c	2010-03-19 13:28:06.000000000 -0400
@@ -315,7 +315,7 @@ int netlbl_domhsh_add(struct netlbl_dom_
 		entry_old = netlbl_domhsh_search_def(entry->domain);
 	if (entry_old == NULL) {
 		entry->valid = 1;
-		INIT_RCU_HEAD(&entry->rcu);
+		rcu_head_init(&entry->rcu);
 
 		if (entry->domain != NULL) {
 			u32 bkt = netlbl_domhsh_hash(entry->domain);
Index: linux-2.6-lttng/net/netlabel/netlabel_unlabeled.c
===================================================================
--- linux-2.6-lttng.orig/net/netlabel/netlabel_unlabeled.c	2010-03-19 13:23:39.000000000 -0400
+++ linux-2.6-lttng/net/netlabel/netlabel_unlabeled.c	2010-03-19 13:28:06.000000000 -0400
@@ -327,7 +327,7 @@ static int netlbl_unlhsh_add_addr4(struc
 	entry->list.addr = addr->s_addr & mask->s_addr;
 	entry->list.mask = mask->s_addr;
 	entry->list.valid = 1;
-	INIT_RCU_HEAD(&entry->rcu);
+	rcu_head_init(&entry->rcu);
 	entry->secid = secid;
 
 	spin_lock(&netlbl_unlhsh_lock);
@@ -373,7 +373,7 @@ static int netlbl_unlhsh_add_addr6(struc
 	entry->list.addr.s6_addr32[3] &= mask->s6_addr32[3];
 	ipv6_addr_copy(&entry->list.mask, mask);
 	entry->list.valid = 1;
-	INIT_RCU_HEAD(&entry->rcu);
+	rcu_head_init(&entry->rcu);
 	entry->secid = secid;
 
 	spin_lock(&netlbl_unlhsh_lock);
@@ -410,7 +410,7 @@ static struct netlbl_unlhsh_iface *netlb
 	INIT_LIST_HEAD(&iface->addr4_list);
 	INIT_LIST_HEAD(&iface->addr6_list);
 	iface->valid = 1;
-	INIT_RCU_HEAD(&iface->rcu);
+	rcu_head_init(&iface->rcu);
 
 	spin_lock(&netlbl_unlhsh_lock);
 	if (ifindex > 0) {
Index: linux-2.6-lttng/net/sctp/bind_addr.c
===================================================================
--- linux-2.6-lttng.orig/net/sctp/bind_addr.c	2010-03-19 13:23:39.000000000 -0400
+++ linux-2.6-lttng/net/sctp/bind_addr.c	2010-03-19 13:28:06.000000000 -0400
@@ -186,7 +186,7 @@ int sctp_add_bind_addr(struct sctp_bind_
 	addr->valid = 1;
 
 	INIT_LIST_HEAD(&addr->list);
-	INIT_RCU_HEAD(&addr->rcu);
+	rcu_head_init(&addr->rcu);
 
 	/* We always hold a socket lock when calling this function,
 	 * and that acts as a writer synchronizing lock.
Index: linux-2.6-lttng/net/sctp/ipv6.c
===================================================================
--- linux-2.6-lttng.orig/net/sctp/ipv6.c	2010-03-19 13:23:39.000000000 -0400
+++ linux-2.6-lttng/net/sctp/ipv6.c	2010-03-19 13:28:06.000000000 -0400
@@ -381,7 +381,7 @@ static void sctp_v6_copy_addrlist(struct
 			addr->a.v6.sin6_scope_id = dev->ifindex;
 			addr->valid = 1;
 			INIT_LIST_HEAD(&addr->list);
-			INIT_RCU_HEAD(&addr->rcu);
+			rcu_head_init(&addr->rcu);
 			list_add_tail(&addr->list, addrlist);
 		}
 	}
Index: linux-2.6-lttng/net/sctp/protocol.c
===================================================================
--- linux-2.6-lttng.orig/net/sctp/protocol.c	2010-03-19 13:23:39.000000000 -0400
+++ linux-2.6-lttng/net/sctp/protocol.c	2010-03-19 13:28:06.000000000 -0400
@@ -188,7 +188,7 @@ static void sctp_v4_copy_addrlist(struct
 			addr->a.v4.sin_addr.s_addr = ifa->ifa_local;
 			addr->valid = 1;
 			INIT_LIST_HEAD(&addr->list);
-			INIT_RCU_HEAD(&addr->rcu);
+			rcu_head_init(&addr->rcu);
 			list_add_tail(&addr->list, addrlist);
 		}
 	}

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
