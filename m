Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394Ab1IZKTp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 06:19:45 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:54873 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753332Ab1IZKTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 06:19:41 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andy Henroid <andrew.d.henroid@intel.com>
Subject: [PATCH 6/7] x86: Call idle notifier after irq_enter()
Date: Mon, 26 Sep 2011 12:19:11 +0200
Message-Id: <1317032352-25571-7-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317032352-25571-1-git-send-email-fweisbec@gmail.com>
References: <1317032352-25571-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Interrupts notify the idle exit state before calling irq_enter().
But the notifier code calls rcu_read_lock() and this is not
allowed while rcu is in an extended quiescent state. We need
to wait for rcu_irq_enter() to be called before doing so
otherwise this results in a grumpy RCU:

[    0.099991] WARNING: at include/linux/rcupdate.h:194 __atomic_notifier_call_chain+0xd2/0x110()
[    0.099991] Hardware name: AMD690VM-FMH
[    0.099991] Modules linked in:
[    0.099991] Pid: 0, comm: swapper Not tainted 3.0.0-rc6+ #255
[    0.099991] Call Trace:
[    0.099991]  <IRQ>  [<ffffffff81051c8a>] warn_slowpath_common+0x7a/0xb0
[    0.099991]  [<ffffffff81051cd5>] warn_slowpath_null+0x15/0x20
[    0.099991]  [<ffffffff817d6fa2>] __atomic_notifier_call_chain+0xd2/0x110
[    0.099991]  [<ffffffff817d6ff1>] atomic_notifier_call_chain+0x11/0x20
[    0.099991]  [<ffffffff81001873>] exit_idle+0x43/0x50
[    0.099991]  [<ffffffff81020439>] smp_apic_timer_interrupt+0x39/0xa0
[    0.099991]  [<ffffffff817da253>] apic_timer_interrupt+0x13/0x20
[    0.099991]  <EOI>  [<ffffffff8100ae67>] ? default_idle+0xa7/0x350
[    0.099991]  [<ffffffff8100ae65>] ? default_idle+0xa5/0x350
[    0.099991]  [<ffffffff8100b19b>] amd_e400_idle+0x8b/0x110
[    0.099991]  [<ffffffff810cb01f>] ? rcu_enter_nohz+0x8f/0x160
[    0.099991]  [<ffffffff810019a0>] cpu_idle+0xb0/0x110
[    0.099991]  [<ffffffff817a7505>] rest_init+0xe5/0x140
[    0.099991]  [<ffffffff817a7468>] ? rest_init+0x48/0x140
[    0.099991]  [<ffffffff81cc5ca3>] start_kernel+0x3d1/0x3dc
[    0.099991]  [<ffffffff81cc5321>] x86_64_start_reservations+0x131/0x135
[    0.099991]  [<ffffffff81cc5412>] x86_64_start_kernel+0xed/0xf4

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Andy Henroid <andrew.d.henroid@intel.com>
---
 arch/x86/kernel/apic/apic.c              |    6 +++---
 arch/x86/kernel/apic/io_apic.c           |    2 +-
 arch/x86/kernel/cpu/mcheck/mce.c         |    2 +-
 arch/x86/kernel/cpu/mcheck/therm_throt.c |    2 +-
 arch/x86/kernel/cpu/mcheck/threshold.c   |    2 +-
 arch/x86/kernel/irq.c                    |    6 +++---
 6 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index b9338b8..82af921 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -856,8 +856,8 @@ void __irq_entry smp_apic_timer_interrupt(struct pt_regs *regs)
 	 * Besides, if we don't timer interrupts ignore the global
 	 * interrupt lock, which is the WrongThing (tm) to do.
 	 */
-	exit_idle();
 	irq_enter();
+	exit_idle();
 	local_apic_timer_interrupt();
 	irq_exit();
 
@@ -1790,8 +1790,8 @@ void smp_spurious_interrupt(struct pt_regs *regs)
 {
 	u32 v;
 
-	exit_idle();
 	irq_enter();
+	exit_idle();
 	/*
 	 * Check if this really is a spurious interrupt and ACK it
 	 * if it is a vectored one.  Just in case...
@@ -1827,8 +1827,8 @@ void smp_error_interrupt(struct pt_regs *regs)
 		"Illegal register address",	/* APIC Error Bit 7 */
 	};
 
-	exit_idle();
 	irq_enter();
+	exit_idle();
 	/* First tickle the hardware, only then report what went on. -- REW */
 	v0 = apic_read(APIC_ESR);
 	apic_write(APIC_ESR, 0);
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index e529339..e1b5eec 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2275,8 +2275,8 @@ asmlinkage void smp_irq_move_cleanup_interrupt(void)
 	unsigned vector, me;
 
 	ack_APIC_irq();
-	exit_idle();
 	irq_enter();
+	exit_idle();
 
 	me = smp_processor_id();
 	for (vector = FIRST_EXTERNAL_VECTOR; vector < NR_VECTORS; vector++) {
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index ff1ae9b..7ba9757 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -470,8 +470,8 @@ static inline void mce_get_rip(struct mce *m, struct pt_regs *regs)
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
index 27c6251..f6bbc64 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -396,8 +396,8 @@ static void (*smp_thermal_vector)(void) = unexpected_thermal_interrupt;
 
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
index 6c0802e..73cf928 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -180,8 +180,8 @@ unsigned int __irq_entry do_IRQ(struct pt_regs *regs)
 	unsigned vector = ~regs->orig_ax;
 	unsigned irq;
 
-	exit_idle();
 	irq_enter();
+	exit_idle();
 
 	irq = __this_cpu_read(vector_irq[vector]);
 
@@ -208,10 +208,10 @@ void smp_x86_platform_ipi(struct pt_regs *regs)
 
 	ack_APIC_irq();
 
-	exit_idle();
-
 	irq_enter();
 
+	exit_idle();
+
 	inc_irq_stat(x86_platform_ipis);
 
 	if (x86_platform_ipi_callback)
-- 
1.7.5.4

