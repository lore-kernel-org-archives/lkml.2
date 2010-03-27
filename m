Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675Ab0C0Phs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 11:37:48 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:43322 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752158Ab0C0Php (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 11:37:45 -0400
Message-Id: <20100327153620.129892515@efficios.com>
References: <20100327153233.993367557@efficios.com>
User-Agent: quilt/0.46-1
Date: Sat, 27 Mar 2010 11:32:39 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com,
       laijs@cn.fujitsu.com, dipankar@in.ibm.com, josh@joshtriplett.org,
       dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
       peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, eric.dumazet@gmail.com, adobriyan@gmail.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [patch 6/6] kernel call_rcu usage: initialize rcu_head structures (v2)
Content-Disposition: inline; filename=rcu-init-null.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Sat, 27 Mar 2010 15:36:20 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initialize rcu_head structures with rcu_head_init() before passing them to
call_rcu().

Currently, the rcu_head debug object is not very strict: it will not complain if
a non-initialized rcu_head is passed to call_rcu(), because we currently have no
way to tag the statically initialized objects. However, we should keep the API
in place so we can activate this strict check in a near future.

This patch applies to current -tip based on 2.6.34-rc2.

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
 arch/powerpc/mm/pgtable.c                   |    2 +-
 block/cfq-iosched.c                         |    2 +-
 block/genhd.c                               |    2 +-
 drivers/staging/batman-adv/hard-interface.c |    2 +-
 fs/file.c                                   |    4 ++--
 fs/fs-writeback.c                           |   13 +++++++++----
 fs/partitions/check.c                       |    2 +-
 kernel/fork.c                               |    1 +
 kernel/pid.c                                |    1 +
 kernel/rcutiny.c                            |    6 ++++++
 kernel/rcutorture.c                         |    2 ++
 kernel/rcutree.c                            |    4 ++++
 mm/backing-dev.c                            |    2 +-
 mm/slob.c                                   |    2 +-
 net/core/drop_monitor.c                     |    2 +-
 net/core/neighbour.c                        |    4 ++--
 net/core/net_namespace.c                    |    4 ++--
 net/ipv4/cipso_ipv4.c                       |    2 +-
 net/ipv4/devinet.c                          |    4 ++--
 net/ipv4/route.c                            |    2 +-
 net/ipv6/sit.c                              |    2 +-
 net/ipv6/xfrm6_tunnel.c                     |    2 +-
 net/netfilter/nf_conntrack_expect.c         |    2 +-
 net/netfilter/nf_conntrack_extend.c         |    2 +-
 net/netfilter/nfnetlink_queue.c             |    2 +-
 net/netlabel/netlabel_domainhash.c          |    2 +-
 net/netlabel/netlabel_unlabeled.c           |    6 +++---
 net/sctp/bind_addr.c                        |    2 +-
 net/sctp/ipv6.c                             |    2 +-
 net/sctp/protocol.c                         |    2 +-
 security/selinux/avc.c                      |    2 +-
 security/selinux/netnode.c                  |    2 +-
 32 files changed, 55 insertions(+), 36 deletions(-)

Index: linux.trees.git/kernel/pid.c
===================================================================
--- linux.trees.git.orig/kernel/pid.c	2010-03-27 11:02:22.000000000 -0400
+++ linux.trees.git/kernel/pid.c	2010-03-27 11:05:54.000000000 -0400
@@ -265,6 +265,7 @@ struct pid *alloc_pid(struct pid_namespa
 
 	get_pid_ns(ns);
 	pid->level = ns->level;
+	rcu_head_init(&pid->rcu);
 	atomic_set(&pid->count, 1);
 	for (type = 0; type < PIDTYPE_MAX; ++type)
 		INIT_HLIST_HEAD(&pid->tasks[type]);
Index: linux.trees.git/kernel/fork.c
===================================================================
--- linux.trees.git.orig/kernel/fork.c	2010-03-27 11:02:22.000000000 -0400
+++ linux.trees.git/kernel/fork.c	2010-03-27 11:05:54.000000000 -0400
@@ -1038,6 +1038,7 @@ static struct task_struct *copy_process(
 	INIT_LIST_HEAD(&p->children);
 	INIT_LIST_HEAD(&p->sibling);
 	rcu_copy_process(p);
+	rcu_head_init(&p->rcu);
 	p->vfork_done = NULL;
 	spin_lock_init(&p->alloc_lock);
 
Index: linux.trees.git/kernel/rcutiny.c
===================================================================
--- linux.trees.git.orig/kernel/rcutiny.c	2010-03-27 11:05:53.000000000 -0400
+++ linux.trees.git/kernel/rcutiny.c	2010-03-27 11:05:54.000000000 -0400
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
 
Index: linux.trees.git/kernel/rcutorture.c
===================================================================
--- linux.trees.git.orig/kernel/rcutorture.c	2010-03-27 11:02:22.000000000 -0400
+++ linux.trees.git/kernel/rcutorture.c	2010-03-27 11:05:54.000000000 -0400
@@ -464,9 +464,11 @@ static void rcu_bh_torture_synchronize(v
 {
 	struct rcu_bh_torture_synchronize rcu;
 
+	rcu_head_init_on_stack(&rcu.head);
 	init_completion(&rcu.completion);
 	call_rcu_bh(&rcu.head, rcu_bh_torture_wakeme_after_cb);
 	wait_for_completion(&rcu.completion);
+	destroy_rcu_head_on_stack(&rcu.head);
 }
 
 static struct rcu_torture_ops rcu_bh_ops = {
Index: linux.trees.git/kernel/rcutree.c
===================================================================
--- linux.trees.git.orig/kernel/rcutree.c	2010-03-27 11:05:53.000000000 -0400
+++ linux.trees.git/kernel/rcutree.c	2010-03-27 11:05:54.000000000 -0400
@@ -1451,11 +1451,13 @@ void synchronize_sched(void)
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
 
@@ -1475,11 +1477,13 @@ void synchronize_rcu_bh(void)
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
 
Index: linux.trees.git/mm/backing-dev.c
===================================================================
--- linux.trees.git.orig/mm/backing-dev.c	2010-03-27 11:02:22.000000000 -0400
+++ linux.trees.git/mm/backing-dev.c	2010-03-27 11:05:54.000000000 -0400
@@ -653,7 +653,7 @@ int bdi_init(struct backing_dev_info *bd
 	bdi->max_ratio = 100;
 	bdi->max_prop_frac = PROP_FRAC_BASE;
 	spin_lock_init(&bdi->wb_lock);
-	INIT_RCU_HEAD(&bdi->rcu_head);
+	rcu_head_init(&bdi->rcu_head);
 	INIT_LIST_HEAD(&bdi->bdi_list);
 	INIT_LIST_HEAD(&bdi->wb_list);
 	INIT_LIST_HEAD(&bdi->work_list);
Index: linux.trees.git/mm/slob.c
===================================================================
--- linux.trees.git.orig/mm/slob.c	2010-03-27 11:02:22.000000000 -0400
+++ linux.trees.git/mm/slob.c	2010-03-27 11:05:54.000000000 -0400
@@ -647,7 +647,7 @@ void kmem_cache_free(struct kmem_cache *
 	if (unlikely(c->flags & SLAB_DESTROY_BY_RCU)) {
 		struct slob_rcu *slob_rcu;
 		slob_rcu = b + (c->size - sizeof(struct slob_rcu));
-		INIT_RCU_HEAD(&slob_rcu->head);
+		rcu_head_init(&slob_rcu->head);
 		slob_rcu->size = c->size;
 		call_rcu(&slob_rcu->head, kmem_rcu_free);
 	} else {
Index: linux.trees.git/fs/file.c
===================================================================
--- linux.trees.git.orig/fs/file.c	2010-03-27 11:02:22.000000000 -0400
+++ linux.trees.git/fs/file.c	2010-03-27 11:05:54.000000000 -0400
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
Index: linux.trees.git/fs/fs-writeback.c
===================================================================
--- linux.trees.git.orig/fs/fs-writeback.c	2010-03-27 11:02:22.000000000 -0400
+++ linux.trees.git/fs/fs-writeback.c	2010-03-27 11:05:54.000000000 -0400
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
Index: linux.trees.git/fs/partitions/check.c
===================================================================
--- linux.trees.git.orig/fs/partitions/check.c	2010-03-27 11:02:22.000000000 -0400
+++ linux.trees.git/fs/partitions/check.c	2010-03-27 11:05:54.000000000 -0400
@@ -455,7 +455,7 @@ struct hd_struct *add_partition(struct g
 	}
 
 	/* everything is up and running, commence */
-	INIT_RCU_HEAD(&p->rcu_head);
+	rcu_head_init(&p->rcu_head);
 	rcu_assign_pointer(ptbl->part[partno], p);
 
 	/* suppress uevent if the disk supresses it */
Index: linux.trees.git/block/cfq-iosched.c
===================================================================
--- linux.trees.git.orig/block/cfq-iosched.c	2010-03-27 11:02:22.000000000 -0400
+++ linux.trees.git/block/cfq-iosched.c	2010-03-27 11:05:54.000000000 -0400
@@ -3719,7 +3719,7 @@ static void *cfq_init_queue(struct reque
 	 * second, in order to have larger depth for async operations.
 	 */
 	cfqd->last_delayed_sync = jiffies - HZ;
-	INIT_RCU_HEAD(&cfqd->rcu);
+	rcu_head_init(&cfqd->rcu);
 	return cfqd;
 }
 
Index: linux.trees.git/block/genhd.c
===================================================================
--- linux.trees.git.orig/block/genhd.c	2010-03-27 11:02:22.000000000 -0400
+++ linux.trees.git/block/genhd.c	2010-03-27 11:05:54.000000000 -0400
@@ -987,7 +987,7 @@ int disk_expand_part_tbl(struct gendisk 
 	if (!new_ptbl)
 		return -ENOMEM;
 
-	INIT_RCU_HEAD(&new_ptbl->rcu_head);
+	rcu_head_init(&new_ptbl->rcu_head);
 	new_ptbl->len = target;
 
 	for (i = 0; i < len; i++)
Index: linux.trees.git/net/netfilter/nfnetlink_queue.c
===================================================================
--- linux.trees.git.orig/net/netfilter/nfnetlink_queue.c	2010-03-27 11:02:22.000000000 -0400
+++ linux.trees.git/net/netfilter/nfnetlink_queue.c	2010-03-27 11:05:54.000000000 -0400
@@ -112,7 +112,7 @@ instance_create(u_int16_t queue_num, int
 	inst->copy_mode = NFQNL_COPY_NONE;
 	spin_lock_init(&inst->lock);
 	INIT_LIST_HEAD(&inst->queue_list);
-	INIT_RCU_HEAD(&inst->rcu);
+	rcu_head_init(&inst->rcu);
 
 	if (!try_module_get(THIS_MODULE)) {
 		err = -EAGAIN;
Index: linux.trees.git/net/core/drop_monitor.c
===================================================================
--- linux.trees.git.orig/net/core/drop_monitor.c	2010-03-27 11:02:22.000000000 -0400
+++ linux.trees.git/net/core/drop_monitor.c	2010-03-27 11:05:54.000000000 -0400
@@ -296,7 +296,7 @@ static int dropmon_net_event(struct noti
 
 		new_stat->dev = dev;
 		new_stat->last_rx = jiffies;
-		INIT_RCU_HEAD(&new_stat->rcu);
+		rcu_head_init(&new_stat->rcu);
 		spin_lock(&trace_state_lock);
 		list_add_rcu(&new_stat->list, &hw_stats_list);
 		spin_unlock(&trace_state_lock);
Index: linux.trees.git/net/ipv6/sit.c
===================================================================
--- linux.trees.git.orig/net/ipv6/sit.c	2010-03-27 11:02:22.000000000 -0400
+++ linux.trees.git/net/ipv6/sit.c	2010-03-27 11:05:54.000000000 -0400
@@ -363,7 +363,7 @@ ipip6_tunnel_add_prl(struct ip_tunnel *t
 		goto out;
 	}
 
-	INIT_RCU_HEAD(&p->rcu_head);
+	rcu_head_init(&p->rcu_head);
 	p->next = t->prl;
 	p->addr = a->addr;
 	p->flags = a->flags;
Index: linux.trees.git/net/ipv6/xfrm6_tunnel.c
===================================================================
--- linux.trees.git.orig/net/ipv6/xfrm6_tunnel.c	2010-03-27 11:02:22.000000000 -0400
+++ linux.trees.git/net/ipv6/xfrm6_tunnel.c	2010-03-27 11:05:54.000000000 -0400
@@ -161,7 +161,7 @@ alloc_spi:
 	if (!x6spi)
 		goto out;
 
-	INIT_RCU_HEAD(&x6spi->rcu_head);
+	rcu_head_init(&x6spi->rcu_head);
 	memcpy(&x6spi->addr, saddr, sizeof(x6spi->addr));
 	x6spi->spi = spi;
 	atomic_set(&x6spi->refcnt, 1);
Index: linux.trees.git/net/netfilter/nf_conntrack_expect.c
===================================================================
--- linux.trees.git.orig/net/netfilter/nf_conntrack_expect.c	2010-03-27 11:02:22.000000000 -0400
+++ linux.trees.git/net/netfilter/nf_conntrack_expect.c	2010-03-27 11:05:54.000000000 -0400
@@ -239,7 +239,7 @@ struct nf_conntrack_expect *nf_ct_expect
 
 	new->master = me;
 	atomic_set(&new->use, 1);
-	INIT_RCU_HEAD(&new->rcu);
+	rcu_head_init(&new->rcu);
 	return new;
 }
 EXPORT_SYMBOL_GPL(nf_ct_expect_alloc);
Index: linux.trees.git/net/netfilter/nf_conntrack_extend.c
===================================================================
--- linux.trees.git.orig/net/netfilter/nf_conntrack_extend.c	2010-03-27 11:02:22.000000000 -0400
+++ linux.trees.git/net/netfilter/nf_conntrack_extend.c	2010-03-27 11:05:54.000000000 -0400
@@ -59,7 +59,7 @@ nf_ct_ext_create(struct nf_ct_ext **ext,
 	if (!*ext)
 		return NULL;
 
-	INIT_RCU_HEAD(&(*ext)->rcu);
+	rcu_head_init(&(*ext)->rcu);
 	(*ext)->offset[id] = off;
 	(*ext)->len = len;
 
Index: linux.trees.git/net/netlabel/netlabel_domainhash.c
===================================================================
--- linux.trees.git.orig/net/netlabel/netlabel_domainhash.c	2010-03-27 11:02:22.000000000 -0400
+++ linux.trees.git/net/netlabel/netlabel_domainhash.c	2010-03-27 11:05:54.000000000 -0400
@@ -315,7 +315,7 @@ int netlbl_domhsh_add(struct netlbl_dom_
 		entry_old = netlbl_domhsh_search_def(entry->domain);
 	if (entry_old == NULL) {
 		entry->valid = 1;
-		INIT_RCU_HEAD(&entry->rcu);
+		rcu_head_init(&entry->rcu);
 
 		if (entry->domain != NULL) {
 			u32 bkt = netlbl_domhsh_hash(entry->domain);
Index: linux.trees.git/net/netlabel/netlabel_unlabeled.c
===================================================================
--- linux.trees.git.orig/net/netlabel/netlabel_unlabeled.c	2010-03-27 11:02:22.000000000 -0400
+++ linux.trees.git/net/netlabel/netlabel_unlabeled.c	2010-03-27 11:05:54.000000000 -0400
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
Index: linux.trees.git/net/sctp/bind_addr.c
===================================================================
--- linux.trees.git.orig/net/sctp/bind_addr.c	2010-03-27 11:02:22.000000000 -0400
+++ linux.trees.git/net/sctp/bind_addr.c	2010-03-27 11:05:54.000000000 -0400
@@ -186,7 +186,7 @@ int sctp_add_bind_addr(struct sctp_bind_
 	addr->valid = 1;
 
 	INIT_LIST_HEAD(&addr->list);
-	INIT_RCU_HEAD(&addr->rcu);
+	rcu_head_init(&addr->rcu);
 
 	/* We always hold a socket lock when calling this function,
 	 * and that acts as a writer synchronizing lock.
Index: linux.trees.git/net/sctp/ipv6.c
===================================================================
--- linux.trees.git.orig/net/sctp/ipv6.c	2010-03-27 11:02:22.000000000 -0400
+++ linux.trees.git/net/sctp/ipv6.c	2010-03-27 11:05:54.000000000 -0400
@@ -381,7 +381,7 @@ static void sctp_v6_copy_addrlist(struct
 			addr->a.v6.sin6_scope_id = dev->ifindex;
 			addr->valid = 1;
 			INIT_LIST_HEAD(&addr->list);
-			INIT_RCU_HEAD(&addr->rcu);
+			rcu_head_init(&addr->rcu);
 			list_add_tail(&addr->list, addrlist);
 		}
 	}
Index: linux.trees.git/net/sctp/protocol.c
===================================================================
--- linux.trees.git.orig/net/sctp/protocol.c	2010-03-27 11:02:22.000000000 -0400
+++ linux.trees.git/net/sctp/protocol.c	2010-03-27 11:05:54.000000000 -0400
@@ -188,7 +188,7 @@ static void sctp_v4_copy_addrlist(struct
 			addr->a.v4.sin_addr.s_addr = ifa->ifa_local;
 			addr->valid = 1;
 			INIT_LIST_HEAD(&addr->list);
-			INIT_RCU_HEAD(&addr->rcu);
+			rcu_head_init(&addr->rcu);
 			list_add_tail(&addr->list, addrlist);
 		}
 	}
Index: linux.trees.git/net/core/net_namespace.c
===================================================================
--- linux.trees.git.orig/net/core/net_namespace.c	2010-03-27 11:06:17.000000000 -0400
+++ linux.trees.git/net/core/net_namespace.c	2010-03-27 11:07:00.000000000 -0400
@@ -126,7 +126,7 @@ static struct net_generic *net_alloc_gen
 	ng = kzalloc(generic_size, GFP_KERNEL);
 	if (ng) {
 		ng->len = INITIAL_NET_GEN_PTRS;
-		INIT_RCU_HEAD(&ng->rcu);
+		rcu_head_init(&ng->rcu);
 	}
 
 	return ng;
@@ -565,7 +565,7 @@ int net_assign_generic(struct net *net, 
 	 */
 
 	ng->len = id;
-	INIT_RCU_HEAD(&ng->rcu);
+	rcu_head_init(&ng->rcu);
 	memcpy(&ng->ptr, &old_ng->ptr, old_ng->len * sizeof(void*));
 
 	rcu_assign_pointer(net->gen, ng);
Index: linux.trees.git/net/core/neighbour.c
===================================================================
--- linux.trees.git.orig/net/core/neighbour.c	2010-03-27 11:07:06.000000000 -0400
+++ linux.trees.git/net/core/neighbour.c	2010-03-27 11:07:18.000000000 -0400
@@ -1346,7 +1346,7 @@ struct neigh_parms *neigh_parms_alloc(st
 	if (p) {
 		p->tbl		  = tbl;
 		atomic_set(&p->refcnt, 1);
-		INIT_RCU_HEAD(&p->rcu_head);
+		rcu_head_init(&p->rcu_head);
 		p->reachable_time =
 				neigh_rand_reach_time(p->base_reachable_time);
 
@@ -1414,7 +1414,7 @@ void neigh_table_init_no_netlink(struct 
 
 	write_pnet(&tbl->parms.net, &init_net);
 	atomic_set(&tbl->parms.refcnt, 1);
-	INIT_RCU_HEAD(&tbl->parms.rcu_head);
+	rcu_head_init(&tbl->parms.rcu_head);
 	tbl->parms.reachable_time =
 			  neigh_rand_reach_time(tbl->parms.base_reachable_time);
 
Index: linux.trees.git/net/ipv4/cipso_ipv4.c
===================================================================
--- linux.trees.git.orig/net/ipv4/cipso_ipv4.c	2010-03-27 11:07:33.000000000 -0400
+++ linux.trees.git/net/ipv4/cipso_ipv4.c	2010-03-27 11:07:46.000000000 -0400
@@ -502,7 +502,7 @@ int cipso_v4_doi_add(struct cipso_v4_doi
 	}
 
 	atomic_set(&doi_def->refcount, 1);
-	INIT_RCU_HEAD(&doi_def->rcu);
+	rcu_head_init(&doi_def->rcu);
 
 	spin_lock(&cipso_v4_doi_list_lock);
 	if (cipso_v4_doi_search(doi_def->doi) != NULL) {
Index: linux.trees.git/net/ipv4/devinet.c
===================================================================
--- linux.trees.git.orig/net/ipv4/devinet.c	2010-03-27 11:07:54.000000000 -0400
+++ linux.trees.git/net/ipv4/devinet.c	2010-03-27 11:08:11.000000000 -0400
@@ -115,7 +115,7 @@ static struct in_ifaddr *inet_alloc_ifa(
 	struct in_ifaddr *ifa = kzalloc(sizeof(*ifa), GFP_KERNEL);
 
 	if (ifa) {
-		INIT_RCU_HEAD(&ifa->rcu_head);
+		rcu_head_init(&ifa->rcu_head);
 	}
 
 	return ifa;
@@ -161,7 +161,7 @@ static struct in_device *inetdev_init(st
 	in_dev = kzalloc(sizeof(*in_dev), GFP_KERNEL);
 	if (!in_dev)
 		goto out;
-	INIT_RCU_HEAD(&in_dev->rcu_head);
+	rcu_head_init(&in_dev->rcu_head);
 	memcpy(&in_dev->cnf, dev_net(dev)->ipv4.devconf_dflt,
 			sizeof(in_dev->cnf));
 	in_dev->cnf.sysctl = NULL;
Index: linux.trees.git/net/ipv4/route.c
===================================================================
--- linux.trees.git.orig/net/ipv4/route.c	2010-03-27 11:08:22.000000000 -0400
+++ linux.trees.git/net/ipv4/route.c	2010-03-27 11:08:32.000000000 -0400
@@ -1434,7 +1434,7 @@ void ip_rt_redirect(__be32 old_gw, __be3
 
 				/* Copy all the information. */
 				*rt = *rth;
-				INIT_RCU_HEAD(&rt->u.dst.rcu_head);
+				rcu_head_init(&rt->u.dst.rcu_head);
 				rt->u.dst.__use		= 1;
 				atomic_set(&rt->u.dst.__refcnt, 1);
 				rt->u.dst.child		= NULL;
Index: linux.trees.git/arch/powerpc/mm/pgtable.c
===================================================================
--- linux.trees.git.orig/arch/powerpc/mm/pgtable.c	2010-03-27 11:08:59.000000000 -0400
+++ linux.trees.git/arch/powerpc/mm/pgtable.c	2010-03-27 11:09:09.000000000 -0400
@@ -91,7 +91,7 @@ static void pte_free_rcu_callback(struct
 
 static void pte_free_submit(struct pte_freelist_batch *batch)
 {
-	INIT_RCU_HEAD(&batch->rcu);
+	rcu_head_init(&batch->rcu);
 	call_rcu(&batch->rcu, pte_free_rcu_callback);
 }
 
Index: linux.trees.git/security/selinux/avc.c
===================================================================
--- linux.trees.git.orig/security/selinux/avc.c	2010-03-27 11:10:30.000000000 -0400
+++ linux.trees.git/security/selinux/avc.c	2010-03-27 11:10:52.000000000 -0400
@@ -288,7 +288,7 @@ static struct avc_node *avc_alloc_node(v
 	if (!node)
 		goto out;
 
-	INIT_RCU_HEAD(&node->rhead);
+	rcu_head_init(&node->rhead);
 	INIT_HLIST_NODE(&node->list);
 	avc_cache_stats_incr(allocations);
 
Index: linux.trees.git/security/selinux/netnode.c
===================================================================
--- linux.trees.git.orig/security/selinux/netnode.c	2010-03-27 11:10:58.000000000 -0400
+++ linux.trees.git/security/selinux/netnode.c	2010-03-27 11:11:06.000000000 -0400
@@ -182,7 +182,7 @@ static void sel_netnode_insert(struct se
 		BUG();
 	}
 
-	INIT_RCU_HEAD(&node->rcu);
+	rcu_head_init(&node->rcu);
 
 	/* we need to impose a limit on the growth of the hash table so check
 	 * this bucket to make sure it is within the specified bounds */
Index: linux.trees.git/drivers/staging/batman-adv/hard-interface.c
===================================================================
--- linux.trees.git.orig/drivers/staging/batman-adv/hard-interface.c	2010-03-27 11:13:10.000000000 -0400
+++ linux.trees.git/drivers/staging/batman-adv/hard-interface.c	2010-03-27 11:13:20.000000000 -0400
@@ -301,7 +301,7 @@ int hardif_add_interface(char *dev, int 
 	batman_if->if_num = if_num;
 	batman_if->dev = dev;
 	batman_if->if_active = IF_INACTIVE;
-	INIT_RCU_HEAD(&batman_if->rcu);
+	rcu_head_init(&batman_if->rcu);
 
 	printk(KERN_INFO "batman-adv:Adding interface: %s\n", dev);
 	avail_ifs++;

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
