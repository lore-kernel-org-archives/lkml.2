Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955Ab0LFRQr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 12:16:47 -0500
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:21441 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753934Ab0LFRQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 12:16:45 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: dQvFtAcVM1kEIrfAxF3XaxUKECsV9o52IdjybHOe2EkSiJx
 C4uKG91vj
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20101206171642.624172159@linux.com>
User-Agent: quilt/0.48-1
Date: Mon, 06 Dec 2010 11:16:29 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [Use cpuops V1 11/11] Xen: Use this_cpu_ops
References: <20101206171618.302060721@linux.com>
Content-Disposition: inline; filename=cpuops_xen
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use this_cpu_ops to reduce code size and simplify things in various places.

V3->V4:
	Move instance of this_cpu_inc_return to a later patchset so that
	this patch can be applied without infrastructure changes.

Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Christoph Lameter <cl@linux.com>

---
 arch/x86/xen/enlighten.c  |    4 ++--
 arch/x86/xen/multicalls.h |    2 +-
 arch/x86/xen/spinlock.c   |    8 ++++----
 arch/x86/xen/time.c       |    8 ++++----
 drivers/xen/events.c      |   10 +++++-----
 5 files changed, 16 insertions(+), 16 deletions(-)

Index: linux-2.6/arch/x86/xen/enlighten.c
===================================================================
--- linux-2.6.orig/arch/x86/xen/enlighten.c	2010-12-03 14:49:17.000000000 -0600
+++ linux-2.6/arch/x86/xen/enlighten.c	2010-12-06 10:48:26.000000000 -0600
@@ -574,8 +574,8 @@ static void xen_write_idt_entry(gate_des
 
 	preempt_disable();
 
-	start = __get_cpu_var(idt_desc).address;
-	end = start + __get_cpu_var(idt_desc).size + 1;
+	start = __this_cpu_read(idt_desc.address);
+	end = start + __this_cpu_read(idt_desc.size) + 1;
 
 	xen_mc_flush();
 
Index: linux-2.6/arch/x86/xen/multicalls.h
===================================================================
--- linux-2.6.orig/arch/x86/xen/multicalls.h	2010-12-03 14:48:27.000000000 -0600
+++ linux-2.6/arch/x86/xen/multicalls.h	2010-12-06 10:48:26.000000000 -0600
@@ -22,7 +22,7 @@ static inline void xen_mc_batch(void)
 	unsigned long flags;
 	/* need to disable interrupts until this entry is complete */
 	local_irq_save(flags);
-	__get_cpu_var(xen_mc_irq_flags) = flags;
+	__this_cpu_write(xen_mc_irq_flags, flags);
 }
 
 static inline struct multicall_space xen_mc_entry(size_t args)
Index: linux-2.6/arch/x86/xen/spinlock.c
===================================================================
--- linux-2.6.orig/arch/x86/xen/spinlock.c	2010-12-03 14:48:27.000000000 -0600
+++ linux-2.6/arch/x86/xen/spinlock.c	2010-12-06 10:48:26.000000000 -0600
@@ -159,8 +159,8 @@ static inline struct xen_spinlock *spinn
 {
 	struct xen_spinlock *prev;
 
-	prev = __get_cpu_var(lock_spinners);
-	__get_cpu_var(lock_spinners) = xl;
+	prev = __this_cpu_read(lock_spinners);
+	__this_cpu_write(lock_spinners, xl);
 
 	wmb();			/* set lock of interest before count */
 
@@ -179,14 +179,14 @@ static inline void unspinning_lock(struc
 	asm(LOCK_PREFIX " decw %0"
 	    : "+m" (xl->spinners) : : "memory");
 	wmb();			/* decrement count before restoring lock */
-	__get_cpu_var(lock_spinners) = prev;
+	__this_cpu_write(lock_spinners, prev);
 }
 
 static noinline int xen_spin_lock_slow(struct arch_spinlock *lock, bool irq_enable)
 {
 	struct xen_spinlock *xl = (struct xen_spinlock *)lock;
 	struct xen_spinlock *prev;
-	int irq = __get_cpu_var(lock_kicker_irq);
+	int irq = __this_cpu_read(lock_kicker_irq);
 	int ret;
 	u64 start;
 
Index: linux-2.6/arch/x86/xen/time.c
===================================================================
--- linux-2.6.orig/arch/x86/xen/time.c	2010-12-03 14:48:27.000000000 -0600
+++ linux-2.6/arch/x86/xen/time.c	2010-12-06 10:48:26.000000000 -0600
@@ -135,24 +135,24 @@ static void do_stolen_accounting(void)
 
 	/* Add the appropriate number of ticks of stolen time,
 	   including any left-overs from last time. */
-	stolen = runnable + offline + __get_cpu_var(xen_residual_stolen);
+	stolen = runnable + offline + __this_cpu_read(xen_residual_stolen);
 
 	if (stolen < 0)
 		stolen = 0;
 
 	ticks = iter_div_u64_rem(stolen, NS_PER_TICK, &stolen);
-	__get_cpu_var(xen_residual_stolen) = stolen;
+	__this_cpu_write(xen_residual_stolen, stolen);
 	account_steal_ticks(ticks);
 
 	/* Add the appropriate number of ticks of blocked time,
 	   including any left-overs from last time. */
-	blocked += __get_cpu_var(xen_residual_blocked);
+	blocked += __this_cpu_read(xen_residual_blocked);
 
 	if (blocked < 0)
 		blocked = 0;
 
 	ticks = iter_div_u64_rem(blocked, NS_PER_TICK, &blocked);
-	__get_cpu_var(xen_residual_blocked) = blocked;
+	__this_cpu_write(xen_residual_blocked, blocked);
 	account_idle_ticks(ticks);
 }
 
Index: linux-2.6/drivers/xen/events.c
===================================================================
--- linux-2.6.orig/drivers/xen/events.c	2010-12-06 08:57:20.000000000 -0600
+++ linux-2.6/drivers/xen/events.c	2010-12-06 10:48:26.000000000 -0600
@@ -355,7 +355,7 @@ static void unmask_evtchn(int port)
 		struct evtchn_unmask unmask = { .port = port };
 		(void)HYPERVISOR_event_channel_op(EVTCHNOP_unmask, &unmask);
 	} else {
-		struct vcpu_info *vcpu_info = __get_cpu_var(xen_vcpu);
+		struct vcpu_info *vcpu_info = __this_cpu_read(xen_vcpu);
 
 		sync_clear_bit(port, &s->evtchn_mask[0]);
 
@@ -1101,7 +1101,7 @@ static void __xen_evtchn_do_upcall(void)
 {
 	int cpu = get_cpu();
 	struct shared_info *s = HYPERVISOR_shared_info;
-	struct vcpu_info *vcpu_info = __get_cpu_var(xen_vcpu);
+	struct vcpu_info *vcpu_info = __this_cpu_read(xen_vcpu);
  	unsigned count;
 
 	do {
@@ -1141,8 +1141,8 @@ static void __xen_evtchn_do_upcall(void)
 
 		BUG_ON(!irqs_disabled());
 
-		count = __get_cpu_var(xed_nesting_count);
-		__get_cpu_var(xed_nesting_count) = 0;
+		count = __this_cpu_read(xed_nesting_count);
+		__this_cpu_write(xed_nesting_count, 0);
 	} while (count != 1 || vcpu_info->evtchn_upcall_pending);
 
 out:

