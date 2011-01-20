Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754457Ab1ATUWy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 15:22:54 -0500
Received: from hera.kernel.org ([140.211.167.34]:54734 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754284Ab1ATUWw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 15:22:52 -0500
Date: Thu, 20 Jan 2011 20:21:43 GMT
From: tip-bot for Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        penberg@kernel.org, tj@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        penberg@kernel.org, tj@kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110120110635.GB6036@htj.dyndns.org>
References: <20110120110635.GB6036@htj.dyndns.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] lockdep: Move early boot local IRQ enable/disable status to init/main.c
Message-ID: <tip-2ce802f62ba32a7d95748ac92bf351f76affb6ff@git.kernel.org>
Git-Commit-ID: 2ce802f62ba32a7d95748ac92bf351f76affb6ff
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 20 Jan 2011 20:21:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2ce802f62ba32a7d95748ac92bf351f76affb6ff
Gitweb:     http://git.kernel.org/tip/2ce802f62ba32a7d95748ac92bf351f76affb6ff
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Thu, 20 Jan 2011 12:06:35 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 20 Jan 2011 13:32:33 +0100

lockdep: Move early boot local IRQ enable/disable status to init/main.c

During early boot, local IRQ is disabled until IRQ subsystem is
properly initialized.  During this time, no one should enable
local IRQ and some operations which usually are not allowed with
IRQ disabled, e.g. operations which might sleep or require
communications with other processors, are allowed.

lockdep tracked this with early_boot_irqs_off/on() callbacks.
As other subsystems need this information too, move it to
init/main.c and make it generally available.  While at it,
toggle the boolean to early_boot_irqs_disabled instead of
enabled so that it can be initialized with %false and %true
indicates the exceptional condition.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Pekka Enberg <penberg@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <20110120110635.GB6036@htj.dyndns.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/xen/enlighten.c     |    2 +-
 include/linux/kernel.h       |    2 ++
 include/linux/lockdep.h      |    8 --------
 init/main.c                  |   13 +++++++++++--
 kernel/lockdep.c             |   18 +-----------------
 kernel/trace/trace_irqsoff.c |    8 --------
 6 files changed, 15 insertions(+), 36 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 7e8d3bc..50542ef 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1194,7 +1194,7 @@ asmlinkage void __init xen_start_kernel(void)
 	per_cpu(xen_vcpu, 0) = &HYPERVISOR_shared_info->vcpu_info[0];
 
 	local_irq_disable();
-	early_boot_irqs_off();
+	early_boot_irqs_disabled = true;
 
 	memblock_init();
 
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 5a9d905..d07d805 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -243,6 +243,8 @@ extern int test_taint(unsigned flag);
 extern unsigned long get_taint(void);
 extern int root_mountflags;
 
+extern bool early_boot_irqs_disabled;
+
 /* Values used for system_state */
 extern enum system_states {
 	SYSTEM_BOOTING,
diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 71c09b2..f638fd7 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -436,16 +436,8 @@ do {								\
 #endif /* CONFIG_LOCKDEP */
 
 #ifdef CONFIG_TRACE_IRQFLAGS
-extern void early_boot_irqs_off(void);
-extern void early_boot_irqs_on(void);
 extern void print_irqtrace_events(struct task_struct *curr);
 #else
-static inline void early_boot_irqs_off(void)
-{
-}
-static inline void early_boot_irqs_on(void)
-{
-}
 static inline void print_irqtrace_events(struct task_struct *curr)
 {
 }
diff --git a/init/main.c b/init/main.c
index 00799c1..33c37c3 100644
--- a/init/main.c
+++ b/init/main.c
@@ -96,6 +96,15 @@ static inline void mark_rodata_ro(void) { }
 extern void tc_init(void);
 #endif
 
+/*
+ * Debug helper: via this flag we know that we are in 'early bootup code'
+ * where only the boot processor is running with IRQ disabled.  This means
+ * two things - IRQ must not be enabled before the flag is cleared and some
+ * operations which are not allowed with IRQ disabled are allowed while the
+ * flag is set.
+ */
+bool early_boot_irqs_disabled __read_mostly;
+
 enum system_states system_state __read_mostly;
 EXPORT_SYMBOL(system_state);
 
@@ -554,7 +563,7 @@ asmlinkage void __init start_kernel(void)
 	cgroup_init_early();
 
 	local_irq_disable();
-	early_boot_irqs_off();
+	early_boot_irqs_disabled = true;
 
 /*
  * Interrupts are still disabled. Do necessary setups, then
@@ -621,7 +630,7 @@ asmlinkage void __init start_kernel(void)
 	if (!irqs_disabled())
 		printk(KERN_CRIT "start_kernel(): bug: interrupts were "
 				 "enabled early\n");
-	early_boot_irqs_on();
+	early_boot_irqs_disabled = false;
 	local_irq_enable();
 
 	/* Interrupts are enabled now so all GFP allocations are safe. */
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 42ba65d..0d2058d 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -2292,22 +2292,6 @@ mark_held_locks(struct task_struct *curr, enum mark_type mark)
 }
 
 /*
- * Debugging helper: via this flag we know that we are in
- * 'early bootup code', and will warn about any invalid irqs-on event:
- */
-static int early_boot_irqs_enabled;
-
-void early_boot_irqs_off(void)
-{
-	early_boot_irqs_enabled = 0;
-}
-
-void early_boot_irqs_on(void)
-{
-	early_boot_irqs_enabled = 1;
-}
-
-/*
  * Hardirqs will be enabled:
  */
 void trace_hardirqs_on_caller(unsigned long ip)
@@ -2319,7 +2303,7 @@ void trace_hardirqs_on_caller(unsigned long ip)
 	if (unlikely(!debug_locks || current->lockdep_recursion))
 		return;
 
-	if (DEBUG_LOCKS_WARN_ON(unlikely(!early_boot_irqs_enabled)))
+	if (DEBUG_LOCKS_WARN_ON(unlikely(early_boot_irqs_disabled)))
 		return;
 
 	if (unlikely(curr->hardirqs_enabled)) {
diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index 5cf8c60..92b6e1e 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -453,14 +453,6 @@ void time_hardirqs_off(unsigned long a0, unsigned long a1)
  * Stubs:
  */
 
-void early_boot_irqs_off(void)
-{
-}
-
-void early_boot_irqs_on(void)
-{
-}
-
 void trace_softirqs_on(unsigned long ip)
 {
 }
