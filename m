Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482Ab1FIXsE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 19:48:04 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:59772 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757366Ab1FIXsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 19:48:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=rTJ1+0zsAX7crHdWEna0c8OBcB4DD88FmQEDDNITVUnm/TDowCQ1qCHFwB+D8ldbkc
         DkiOII98jJnO8KHm6qtMMLZNCUQevCogBh07kMD0tN35efk8E2aYy32LoA67ZmMM7uhA
         PZ1LBmlR04oK6oomgvrIQxGWG51CeCCIw1A6g=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 4/4] x86: Call idle_exit() after irq_enter()
Date: Fri, 10 Jun 2011 01:47:27 +0200
Message-Id: <1307663247-5397-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1307663247-5397-1-git-send-email-fweisbec@gmail.com>
References: <1307663247-5397-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

idle_exit() calls the idle notifier, which uses RCU. But
this is called before we call irq_enter(), thus before we
exit the RCU extended quiescent state if we are in idle.

Fix this by calling the idle exit notifier after irq_enter().

This fixes the following warning:

[    0.559953] ===================================================
[    0.559954] [ INFO: suspicious rcu_dereference_check() usage. ]
[    0.559956] ---------------------------------------------------
[    0.559958] kernel/notifier.c:81 invoked rcu_dereference_check() while in RCU extended quiescent state!
[    0.559960]
[    0.559961] other info that might help us debug this:
[    0.559961]
[    0.559962]
[    0.559963] rcu_scheduler_active = 1, debug_locks = 1
[    0.559965] 1 lock held by kworker/0:0/0:
[    0.559966]  #0:  (rcu_read_lock){......}, at: [<ffffffff81785ce0>] __atomic_notifier_call_chain+0x0/0xa0
[    0.559976]
[    0.559977] stack backtrace:
[    0.559980] Pid: 0, comm: kworker/0:0 Not tainted 3.0.0-rc1+ #108
[    0.559981] Call Trace:
[    0.559983]  <IRQ>  [<ffffffff8108e176>] lockdep_rcu_dereference+0xb6/0xf0
[    0.559990]  [<ffffffff81785cca>] notifier_call_chain+0x13a/0x150
[    0.559993]  [<ffffffff81785d47>] __atomic_notifier_call_chain+0x67/0xa0
[    0.559996]  [<ffffffff81785ce0>] ? notifier_call_chain+0x150/0x150
[    0.560000]  [<ffffffff812a454e>] ? do_raw_spin_unlock+0x5e/0xb0
[    0.560000]  [<ffffffff81785d91>] atomic_notifier_call_chain+0x11/0x20
[    0.560000]  [<ffffffff8100af73>] exit_idle+0x43/0x50
[    0.560000]  [<ffffffff81027869>] smp_apic_timer_interrupt+0x39/0xa0
[    0.560000]  [<ffffffff81789e13>] apic_timer_interrupt+0x13/0x20
[    0.560000]  <EOI>  [<ffffffff810301e6>] ? native_safe_halt+0x6/0x10
[    0.560000]  [<ffffffff8108fecd>] ? trace_hardirqs_on+0xd/0x10
[    0.560000]  [<ffffffff810130ac>] default_idle+0x2c/0x50
[    0.560000]  [<ffffffff810131c8>] amd_e400_idle+0x58/0x130
[    0.560000]  [<ffffffff8100b069>] cpu_idle+0xb9/0x110
[    0.560000]  [<ffffffff817795af>] start_secondary+0x1cf/0x1d6

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/apic/apic.c              |    6 +++---
 arch/x86/kernel/apic/io_apic.c           |    3 ++-
 arch/x86/kernel/cpu/mcheck/mce.c         |    2 +-
 arch/x86/kernel/cpu/mcheck/therm_throt.c |    2 +-
 arch/x86/kernel/cpu/mcheck/threshold.c   |    2 +-
 arch/x86/kernel/irq.c                    |    5 ++---
 6 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index fabf01e..d3db17c 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -855,8 +855,8 @@ void __irq_entry smp_apic_timer_interrupt(struct pt_regs *regs)
 	 * Besides, if we don't timer interrupts ignore the global
 	 * interrupt lock, which is the WrongThing (tm) to do.
 	 */
-	exit_idle();
 	irq_enter();
+	exit_idle();
 	local_apic_timer_interrupt();
 	irq_exit();
 
@@ -1788,8 +1788,8 @@ void smp_spurious_interrupt(struct pt_regs *regs)
 {
 	u32 v;
 
-	exit_idle();
 	irq_enter();
+	exit_idle();
 	/*
 	 * Check if this really is a spurious interrupt and ACK it
 	 * if it is a vectored one.  Just in case...
@@ -1814,8 +1814,8 @@ void smp_error_interrupt(struct pt_regs *regs)
 {
 	u32 v, v1;
 
-	exit_idle();
 	irq_enter();
+	exit_idle();
 	/* First tickle the hardware, only then report what went on. -- REW */
 	v = apic_read(APIC_ESR);
 	apic_write(APIC_ESR, 0);
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 45fd33d..f0744a3 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2290,8 +2290,9 @@ asmlinkage void smp_irq_move_cleanup_interrupt(void)
 	unsigned vector, me;
 
 	ack_APIC_irq();
-	exit_idle();
+
 	irq_enter();
+	exit_idle();
 
 	me = smp_processor_id();
 	for (vector = FIRST_EXTERNAL_VECTOR; vector < NR_VECTORS; vector++) {
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 3385ea2..b3cdf7c 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -478,8 +478,8 @@ static inline void mce_get_rip(struct mce *m, struct pt_regs *regs)
 asmlinkage void smp_mce_self_interrupt(struct pt_regs *regs)
 {
 	ack_APIC_irq();
-	exit_idle();
 	irq_enter();
+	exit_idle();
 	mce_notify_irq();
 	mce_schedule_work();
 	irq_exit();
diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
index 6f8c5e9..569c0fa 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -400,8 +400,8 @@ static void (*smp_thermal_vector)(void) = unexpected_thermal_interrupt;
 
 asmlinkage void smp_thermal_interrupt(struct pt_regs *regs)
 {
-	exit_idle();
 	irq_enter();
+	exit_idle();
 	inc_irq_stat(irq_thermal_count);
 	smp_thermal_vector();
 	irq_exit();
diff --git a/arch/x86/kernel/cpu/mcheck/threshold.c b/arch/x86/kernel/cpu/mcheck/threshold.c
index d746df2..aa578ca 100644
--- a/arch/x86/kernel/cpu/mcheck/threshold.c
+++ b/arch/x86/kernel/cpu/mcheck/threshold.c
@@ -19,8 +19,8 @@ void (*mce_threshold_vector)(void) = default_threshold_interrupt;
 
 asmlinkage void smp_threshold_interrupt(void)
 {
-	exit_idle();
 	irq_enter();
+	exit_idle();
 	inc_irq_stat(irq_threshold_count);
 	mce_threshold_vector();
 	irq_exit();
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 1cb0b9f..08f947d 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -180,8 +180,8 @@ unsigned int __irq_entry do_IRQ(struct pt_regs *regs)
 	unsigned vector = ~regs->orig_ax;
 	unsigned irq;
 
-	exit_idle();
 	irq_enter();
+	exit_idle();
 
 	irq = __this_cpu_read(vector_irq[vector]);
 
@@ -208,9 +208,8 @@ void smp_x86_platform_ipi(struct pt_regs *regs)
 
 	ack_APIC_irq();
 
-	exit_idle();
-
 	irq_enter();
+	exit_idle();
 
 	inc_irq_stat(x86_platform_ipis);
 
-- 
1.7.5.4

