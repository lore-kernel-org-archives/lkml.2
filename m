Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136Ab1KLSlG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Nov 2011 13:41:06 -0500
Received: from www.linutronix.de ([62.245.132.108]:40343 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095Ab1KLSlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Nov 2011 13:41:04 -0500
Date: Sat, 12 Nov 2011 19:41:02 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [ANNOUNCE] 3.0.9-rt25
Message-ID: <alpine.LFD.2.02.1111121409500.2694@ionos>
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

I'm pleased to announce the 3.0.9-rt25 release.

3.0.9-rt24 is a not announced intermediate release, which only
updates to 3.0.9. No rt changes except dropping patches which made it
into 3.0.9.

Changes from 3.0.9-rt24 to 3.0.9-rt25

  * Lock unsymmetry fix in softirq.c (reported by Yong)

  * Correct RT substituion for spin_trylock_irq()

  * Make SCSI/FCoE RT aware


Delta patch against 3.0.9-rt25

  https://tglx.de/~tglx/rt/3.0/incr/patch-3.0.9-rt24-rt25.patch.gz

also appended below.


Patch against 3.0.9 can be found here:

  https://tglx.de/~tglx/rt/3.0/patch-3.0.9-rt25.patch.gz


The split quilt queue is available at:

  https://tglx.de/~tglx/rt/3.0/patches-3.0.9-rt25.tar.gz


The 3.0 RT series has reached the production stability point. As
always there might be not yet discovered minor issues left, so please
give it a proper testing.

With this release I'm handing off 3.0-rt to Steven Rostedt. 3.0-rt is
now in maintenance mode, so it will only get bug fixes and updates to
future 3.0.y stable releases.

Steven plans to set up a git tree which imports the current quilt
queue and he will add bug fixes and stable updates incrementaly on top
of that. Releases will be available as patch against the stable base
version as well. Thanks Steven for stepping up!

I also want to say thanks to everyone who helped with review, patches,
testing and bugreports!

3.0-rt was a huge step and it went surprisingly well given the fact,
that it has been a major rewrite of large parts of the RT core
technology. Thanks again to all who helped to make this possible.

I'm moving on to 3.2-rt which will be available soon.

Enjoy,

	tglx

--------------->
Index: linux-3.0/include/linux/spinlock_rt.h
===================================================================
--- linux-3.0.orig/include/linux/spinlock_rt.h
+++ linux-3.0/include/linux/spinlock_rt.h
@@ -132,7 +132,7 @@ static inline unsigned long spin_lock_tr
 	} while (0)
 
 #define spin_trylock_bh(lock)	__cond_lock(lock, rt_spin_trylock_bh(lock))
-#define spin_trylock_irq(lock)	__cond_lock(lock, rt_spin_trylock(lock))
+#define spin_trylock_irq(lock)	spin_trylock(lock)
 
 #define spin_trylock_irqsave(lock, flags)	\
 	rt_spin_trylock_irqsave(lock, &(flags))
Index: linux-3.0/kernel/softirq.c
===================================================================
--- linux-3.0.orig/kernel/softirq.c
+++ linux-3.0/kernel/softirq.c
@@ -415,8 +415,8 @@ void local_bh_enable(void)
 		local_irq_disable();
 		if (local_softirq_pending())
 			__do_softirq();
-		local_unlock(local_softirq_lock);
 		local_irq_enable();
+		local_unlock(local_softirq_lock);
 		WARN_ON(current->softirq_nestcnt != 1);
 	}
 	current->softirq_nestcnt--;
Index: linux-3.0/localversion-rt
===================================================================
--- linux-3.0.orig/localversion-rt
+++ linux-3.0/localversion-rt
@@ -1 +1 @@
--rt24
+-rt25
Index: linux-3.0/drivers/scsi/fcoe/fcoe.c
===================================================================
--- linux-3.0.orig/drivers/scsi/fcoe/fcoe.c
+++ linux-3.0/drivers/scsi/fcoe/fcoe.c
@@ -1113,7 +1113,7 @@ static void fcoe_percpu_thread_destroy(u
 	struct sk_buff *skb;
 #ifdef CONFIG_SMP
 	struct fcoe_percpu_s *p0;
-	unsigned targ_cpu = get_cpu();
+	unsigned targ_cpu = get_cpu_light();
 #endif /* CONFIG_SMP */
 
 	FCOE_DBG("Destroying receive thread for CPU %d\n", cpu);
@@ -1169,7 +1169,7 @@ static void fcoe_percpu_thread_destroy(u
 			kfree_skb(skb);
 		spin_unlock_bh(&p->fcoe_rx_list.lock);
 	}
-	put_cpu();
+	put_cpu_light();
 #else
 	/*
 	 * This a non-SMP scenario where the singular Rx thread is
@@ -1365,11 +1365,11 @@ err2:
 static int fcoe_alloc_paged_crc_eof(struct sk_buff *skb, int tlen)
 {
 	struct fcoe_percpu_s *fps;
-	int rc;
+	int rc, cpu = get_cpu_light();
 
-	fps = &get_cpu_var(fcoe_percpu);
+	fps = &per_cpu(fcoe_percpu, cpu);
 	rc = fcoe_get_paged_crc_eof(skb, tlen, fps);
-	put_cpu_var(fcoe_percpu);
+	put_cpu_light();
 
 	return rc;
 }
@@ -1561,6 +1561,7 @@ static inline int fcoe_filter_frames(str
 	stats->InvalidCRCCount++;
 	if (stats->InvalidCRCCount < 5)
 		printk(KERN_WARNING "fcoe: dropping frame with CRC error\n");
+	put_cpu();
 	return -EINVAL;
 }
 
@@ -1605,7 +1606,7 @@ static void fcoe_recv_frame(struct sk_bu
 	 */
 	hp = (struct fcoe_hdr *) skb_network_header(skb);
 
-	stats = per_cpu_ptr(lport->dev_stats, get_cpu());
+	stats = per_cpu_ptr(lport->dev_stats, get_cpu_light());
 	if (unlikely(FC_FCOE_DECAPS_VER(hp) != FC_FCOE_VER)) {
 		if (stats->ErrorFrames < 5)
 			printk(KERN_WARNING "fcoe: FCoE version "
@@ -1637,13 +1638,13 @@ static void fcoe_recv_frame(struct sk_bu
 		goto drop;
 
 	if (!fcoe_filter_frames(lport, fp)) {
-		put_cpu();
+		put_cpu_light();
 		fc_exch_recv(lport, fp);
 		return;
 	}
 drop:
 	stats->ErrorFrames++;
-	put_cpu();
+	put_cpu_light();
 	kfree_skb(skb);
 }
 
Index: linux-3.0/drivers/scsi/fcoe/fcoe_ctlr.c
===================================================================
--- linux-3.0.orig/drivers/scsi/fcoe/fcoe_ctlr.c
+++ linux-3.0/drivers/scsi/fcoe/fcoe_ctlr.c
@@ -716,7 +716,7 @@ static unsigned long fcoe_ctlr_age_fcfs(
 	unsigned long sel_time = 0;
 	struct fcoe_dev_stats *stats;
 
-	stats = per_cpu_ptr(fip->lp->dev_stats, get_cpu());
+	stats = per_cpu_ptr(fip->lp->dev_stats, get_cpu_light());
 
 	list_for_each_entry_safe(fcf, next, &fip->fcfs, list) {
 		deadline = fcf->time + fcf->fka_period + fcf->fka_period / 2;
@@ -749,7 +749,7 @@ static unsigned long fcoe_ctlr_age_fcfs(
 				sel_time = fcf->time;
 		}
 	}
-	put_cpu();
+	put_cpu_light();
 	if (sel_time && !fip->sel_fcf && !fip->sel_time) {
 		sel_time += msecs_to_jiffies(FCOE_CTLR_START_DELAY);
 		fip->sel_time = sel_time;
Index: linux-3.0/drivers/scsi/libfc/fc_exch.c
===================================================================
--- linux-3.0.orig/drivers/scsi/libfc/fc_exch.c
+++ linux-3.0/drivers/scsi/libfc/fc_exch.c
@@ -705,10 +705,10 @@ static struct fc_exch *fc_exch_em_alloc(
 	}
 	memset(ep, 0, sizeof(*ep));
 
-	cpu = get_cpu();
+	cpu = get_cpu_light();
 	pool = per_cpu_ptr(mp->pool, cpu);
 	spin_lock_bh(&pool->lock);
-	put_cpu();
+	put_cpu_light();
 
 	/* peek cache of free slot */
 	if (pool->left != FC_XID_UNKNOWN) {
