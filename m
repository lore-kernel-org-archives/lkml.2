Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758934Ab2DJOqH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 10:46:07 -0400
Received: from www.linutronix.de ([62.245.132.108]:53315 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753922Ab2DJOqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 10:46:05 -0400
Date: Tue, 10 Apr 2012 16:46:03 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: [ANNOUNCE] 3.4-rc2-rt1
Message-ID: <alpine.LFD.2.02.1204101642050.2542@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear RT Folks,

I'm pleased to announce the 3.4-rc2-rt1 release.

This is a straight forward update of the 3.2 series to 3.4-rc2. It's
slightly smaller than the 3.2 series. I hope to stabilize it fast so I
can concentrate on shuffling more parts of RT into 3.5.

The RT patch against 3.4-rc2-rt1 can be found here:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.4/patch-3.4-rc2-rt1.patch.xz


The split quilt queue is available at:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.4/patches-3.4-rc2-rt1.tar.xz

Enjoy,

	tglx
---
Index: linux-3.2/fs/autofs4/autofs_i.h
===================================================================
--- linux-3.2.orig/fs/autofs4/autofs_i.h
+++ linux-3.2/fs/autofs4/autofs_i.h
@@ -34,6 +34,7 @@
 #include <linux/sched.h>
 #include <linux/mount.h>
 #include <linux/namei.h>
+#include <linux/delay.h>
 #include <asm/current.h>
 #include <asm/uaccess.h>
 
Index: linux-3.2/fs/autofs4/expire.c
===================================================================
--- linux-3.2.orig/fs/autofs4/expire.c
+++ linux-3.2/fs/autofs4/expire.c
@@ -170,7 +170,7 @@ again:
 			parent = p->d_parent;
 			if (!seq_spin_trylock(&parent->d_lock)) {
 				seq_spin_unlock(&p->d_lock);
-				cpu_relax();
+				cpu_chill();
 				goto relock;
 			}
 			seq_spin_unlock(&p->d_lock);
Index: linux-3.2/fs/dcache.c
===================================================================
--- linux-3.2.orig/fs/dcache.c
+++ linux-3.2/fs/dcache.c
@@ -37,6 +37,7 @@
 #include <linux/rculist_bl.h>
 #include <linux/prefetch.h>
 #include <linux/ratelimit.h>
+#include <linux/delay.h>
 #include "internal.h"
 
 /*
@@ -410,7 +411,7 @@ static inline struct dentry *dentry_kill
 	if (inode && !spin_trylock(&inode->i_lock)) {
 relock:
 		seq_spin_unlock(&dentry->d_lock);
-		cpu_relax();
+		cpu_chill();
 		return dentry; /* try again with same dentry */
 	}
 	if (IS_ROOT(dentry))
@@ -796,7 +797,7 @@ relock:
 
 		if (!seq_spin_trylock(&dentry->d_lock)) {
 			spin_unlock(&dcache_lru_lock);
-			cpu_relax();
+			cpu_chill();
 			goto relock;
 		}
 
@@ -1974,7 +1975,7 @@ again:
 	if (dentry->d_count == 1) {
 		if (inode && !spin_trylock(&inode->i_lock)) {
 			seq_spin_unlock(&dentry->d_lock);
-			cpu_relax();
+			cpu_chill();
 			goto again;
 		}
 		dentry->d_flags &= ~DCACHE_CANT_MOUNT;
Index: linux-3.2/fs/namespace.c
===================================================================
--- linux-3.2.orig/fs/namespace.c
+++ linux-3.2/fs/namespace.c
@@ -31,6 +31,7 @@
 #include <linux/idr.h>
 #include <linux/fs_struct.h>
 #include <linux/fsnotify.h>
+#include <linux/delay.h>
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
 #include "pnode.h"
@@ -346,7 +347,7 @@ int mnt_want_write(struct vfsmount *mnt)
 	 */
 	while (mnt->mnt_flags & MNT_WRITE_HOLD) {
 		preempt_enable();
-		cpu_relax();
+		cpu_chill();
 		preempt_disable();
 	}
 	/*
Index: linux-3.2/include/linux/preempt.h
===================================================================
--- linux-3.2.orig/include/linux/preempt.h
+++ linux-3.2/include/linux/preempt.h
@@ -56,8 +56,10 @@ do { \
 
 #ifndef CONFIG_PREEMPT_RT_BASE
 # define preempt_enable_no_resched()	__preempt_enable_no_resched()
+# define preempt_check_resched_rt()	do { } while (0)
 #else
 # define preempt_enable_no_resched()	preempt_enable()
+# define preempt_check_resched_rt()	preempt_check_resched()
 #endif
 
 #define preempt_enable() \
Index: linux-3.2/kernel/irq/manage.c
===================================================================
--- linux-3.2.orig/kernel/irq/manage.c
+++ linux-3.2/kernel/irq/manage.c
@@ -995,6 +995,11 @@ __setup_irq(unsigned int irq, struct irq
 
 		/* add new interrupt at end of irq queue */
 		do {
+			/*
+			 * Or all existing action->thread_mask bits,
+			 * so we can find the next zero bit for this
+			 * new action.
+			 */
 			thread_mask |= old->thread_mask;
 			old_ptr = &old->next;
 			old = *old_ptr;
@@ -1003,14 +1008,41 @@ __setup_irq(unsigned int irq, struct irq
 	}
 
 	/*
-	 * Setup the thread mask for this irqaction. Unlikely to have
-	 * 32 resp 64 irqs sharing one line, but who knows.
+	 * Setup the thread mask for this irqaction for ONESHOT. For
+	 * !ONESHOT irqs the thread mask is 0 so we can avoid a
+	 * conditional in irq_wake_thread().
 	 */
-	if (new->flags & IRQF_ONESHOT && thread_mask == ~0UL) {
-		ret = -EBUSY;
-		goto out_mask;
+	if (new->flags & IRQF_ONESHOT) {
+		/*
+		 * Unlikely to have 32 resp 64 irqs sharing one line,
+		 * but who knows.
+		 */
+		if (thread_mask == ~0UL) {
+			ret = -EBUSY;
+			goto out_mask;
+		}
+		/*
+		 * The thread_mask for the action is or'ed to
+		 * desc->thread_active to indicate that the
+		 * IRQF_ONESHOT thread handler has been woken, but not
+		 * yet finished. The bit is cleared when a thread
+		 * completes. When all threads of a shared interrupt
+		 * line have completed desc->threads_active becomes
+		 * zero and the interrupt line is unmasked. See
+		 * handle.c:irq_wake_thread() for further information.
+		 *
+		 * If no thread is woken by primary (hard irq context)
+		 * interrupt handlers, then desc->threads_active is
+		 * also checked for zero to unmask the irq line in the
+		 * affected hard irq flow handlers
+		 * (handle_[fasteoi|level]_irq).
+		 *
+		 * The new action gets the first zero bit of
+		 * thread_mask assigned. See the loop above which or's
+		 * all existing action->thread_mask bits.
+		 */
+		new->thread_mask = 1 << ffz(thread_mask);
 	}
-	new->thread_mask = 1 << ffz(thread_mask);
 
 	if (!shared) {
 		init_waitqueue_head(&desc->wait_for_threads);
Index: linux-3.2/localversion-rt
===================================================================
--- linux-3.2.orig/localversion-rt
+++ linux-3.2/localversion-rt
@@ -1 +1 @@
--rt16
+-rt17
Index: linux-3.2/net/core/dev.c
===================================================================
--- linux-3.2.orig/net/core/dev.c
+++ linux-3.2/net/core/dev.c
@@ -1779,6 +1779,7 @@ static inline void __netif_reschedule(st
 	sd->output_queue_tailp = &q->next_sched;
 	raise_softirq_irqoff(NET_TX_SOFTIRQ);
 	local_irq_restore(flags);
+	preempt_check_resched_rt();
 }
 
 void __netif_schedule(struct Qdisc *q)
@@ -1800,6 +1801,7 @@ void dev_kfree_skb_irq(struct sk_buff *s
 		sd->completion_queue = skb;
 		raise_softirq_irqoff(NET_TX_SOFTIRQ);
 		local_irq_restore(flags);
+		preempt_check_resched_rt();
 	}
 }
 EXPORT_SYMBOL(dev_kfree_skb_irq);
@@ -2969,6 +2971,7 @@ enqueue:
 	rps_unlock(sd);
 
 	local_irq_restore(flags);
+	preempt_check_resched_rt();
 
 	atomic_long_inc(&skb->dev->rx_dropped);
 	kfree_skb(skb);
@@ -3789,6 +3792,7 @@ static void net_rps_action_and_irq_enabl
 	} else
 #endif
 		local_irq_enable();
+	preempt_check_resched_rt();
 }
 
 static int process_backlog(struct napi_struct *napi, int quota)
@@ -3861,6 +3865,7 @@ void __napi_schedule(struct napi_struct 
 	local_irq_save(flags);
 	____napi_schedule(&__get_cpu_var(softnet_data), n);
 	local_irq_restore(flags);
+	preempt_check_resched_rt();
 }
 EXPORT_SYMBOL(__napi_schedule);
 
@@ -6401,6 +6406,7 @@ static int dev_cpu_callback(struct notif
 
 	raise_softirq_irqoff(NET_TX_SOFTIRQ);
 	local_irq_enable();
+	preempt_check_resched_rt();
 
 	/* Process offline CPU's input_pkt_queue */
 	while ((skb = __skb_dequeue(&oldsd->process_queue))) {
Index: linux-3.2/block/blk-iopoll.c
===================================================================
--- linux-3.2.orig/block/blk-iopoll.c
+++ linux-3.2/block/blk-iopoll.c
@@ -38,6 +38,7 @@ void blk_iopoll_sched(struct blk_iopoll 
 	list_add_tail(&iop->list, &__get_cpu_var(blk_cpu_iopoll));
 	__raise_softirq_irqoff(BLOCK_IOPOLL_SOFTIRQ);
 	local_irq_restore(flags);
+	preempt_check_resched_rt();
 }
 EXPORT_SYMBOL(blk_iopoll_sched);
 
@@ -135,6 +136,7 @@ static void blk_iopoll_softirq(struct so
 		__raise_softirq_irqoff(BLOCK_IOPOLL_SOFTIRQ);
 
 	local_irq_enable();
+	preempt_check_resched_rt();
 }
 
 /**
@@ -204,6 +206,7 @@ static int __cpuinit blk_iopoll_cpu_noti
 				 &__get_cpu_var(blk_cpu_iopoll));
 		__raise_softirq_irqoff(BLOCK_IOPOLL_SOFTIRQ);
 		local_irq_enable();
+		preempt_check_resched_rt();
 	}
 
 	return NOTIFY_OK;
Index: linux-3.2/block/blk-softirq.c
===================================================================
--- linux-3.2.orig/block/blk-softirq.c
+++ linux-3.2/block/blk-softirq.c
@@ -50,6 +50,7 @@ static void trigger_softirq(void *data)
 		raise_softirq_irqoff(BLOCK_SOFTIRQ);
 
 	local_irq_restore(flags);
+	preempt_check_resched_rt();
 }
 
 /*
@@ -92,6 +93,7 @@ static int __cpuinit blk_cpu_notify(stru
 				 &__get_cpu_var(blk_cpu_done));
 		raise_softirq_irqoff(BLOCK_SOFTIRQ);
 		local_irq_enable();
+		preempt_check_resched_rt();
 	}
 
 	return NOTIFY_OK;
@@ -150,6 +152,7 @@ do_local:
 		goto do_local;
 
 	local_irq_restore(flags);
+	preempt_check_resched_rt();
 }
 
 /**
Index: linux-3.2/include/linux/delay.h
===================================================================
--- linux-3.2.orig/include/linux/delay.h
+++ linux-3.2/include/linux/delay.h
@@ -52,4 +52,10 @@ static inline void ssleep(unsigned int s
 	msleep(seconds * 1000);
 }
 
+#ifdef CONFIG_PREEMPT_RT_FULL
+# define cpu_chill()	msleep(1)
+#else
+# define cpu_chill()	cpu_relax()
+#endif
+
 #endif /* defined(_LINUX_DELAY_H) */
Index: linux-3.2/net/packet/af_packet.c
===================================================================
--- linux-3.2.orig/net/packet/af_packet.c
+++ linux-3.2/net/packet/af_packet.c
@@ -89,6 +89,7 @@
 #include <linux/virtio_net.h>
 #include <linux/errqueue.h>
 #include <linux/net_tstamp.h>
+#include <linux/delay.h>
 
 #ifdef CONFIG_INET
 #include <net/inet_common.h>
@@ -673,7 +674,7 @@ static void prb_retire_rx_blk_timer_expi
 	if (BLOCK_NUM_PKTS(pbd)) {
 		while (atomic_read(&pkc->blk_fill_in_prog)) {
 			/* Waiting for skb_copy_bits to finish... */
-			cpu_relax();
+			cpu_chill();
 		}
 	}
 
@@ -928,7 +929,7 @@ static void prb_retire_current_block(str
 		if (!(status & TP_STATUS_BLK_TMO)) {
 			while (atomic_read(&pkc->blk_fill_in_prog)) {
 				/* Waiting for skb_copy_bits to finish... */
-				cpu_relax();
+				cpu_chill();
 			}
 		}
 		prb_close_block(pkc, pbd, po, status);
Index: linux-3.2/net/rds/ib_rdma.c
===================================================================
--- linux-3.2.orig/net/rds/ib_rdma.c
+++ linux-3.2/net/rds/ib_rdma.c
@@ -34,6 +34,7 @@
 #include <linux/slab.h>
 #include <linux/rculist.h>
 #include <linux/llist.h>
+#include <linux/delay.h>
 
 #include "rds.h"
 #include "ib.h"
@@ -286,7 +287,7 @@ static inline void wait_clean_list_grace
 	for_each_online_cpu(cpu) {
 		flag = &per_cpu(clean_list_grace, cpu);
 		while (test_bit(CLEAN_LIST_BUSY_BIT, flag))
-			cpu_relax();
+			cpu_chill();
 	}
 }
 
