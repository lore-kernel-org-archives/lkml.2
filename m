Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539Ab1ATMUd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 07:20:33 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49321 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755474Ab1ATMUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 07:20:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UkWgJtybt5BQCbvnuDBXh3eEikXCSPTrCuSuGz1ghTeCkadN7VbH2YzXw5ch6bKp2V
         Q2n4eIYwIeCDtNUgsE3IBADXHu7bYJW1O632Zl/GasCUQCjeluxTgrBriewcoE1ydrXt
         WJ15c3JnsM//BZ3ZuNA45cUptDHZ8PaqhEMtA=
Date: Thu, 20 Jan 2011 13:20:25 +0100
From: Tejun Heo <tj@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [PATCH UPDATED 1/2] lockdep: move early boot local IRQ
 enable/disable status to init/main.c
Message-ID: <20110120122025.GG6036@htj.dyndns.org>
References: <AANLkTimajU0x1v6y3rH2+jr-bZ=tNLs1S_agXdGGAa3S@mail.gmail.com>
 <20110119120200.GA1057@elte.hu>
 <20110120110635.GB6036@htj.dyndns.org>
 <20110120111149.GD6036@htj.dyndns.org>
 <20110120120001.GA32671@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110120120001.GA32671@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During early boot, local IRQ is disabled until IRQ subsystem is
properly initialized.  During this time, no one should enable local
IRQ and some operations which usually are not allowed with IRQ
disabled, e.g. operations which might sleep or require communications
with other processors, are allowed.

lockdep tracked this with early_boot_irqs_off/on() callbacks.  As
other subsystems need this information too, move it to init/main.c and
make it generally available.  While at it, toggle the boolean to
early_boot_irqs_disabled instead of enabled so that it can be
initialized with %false and %true indicates the exceptional condition.

* The original patch missed conversions of several users causing build
  failures.  Updated.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
---
On Thu, Jan 20, 2011 at 01:00:01PM +0100, Ingo Molnar wrote:
> I'll be able to do more testing and see whether the bug is really
> fixed once the modular kernel build failure is fixed.

Sorry about that.  Here's the updated patch.  The second one doesn't
need to be changed.

Thanks.

 arch/x86/xen/enlighten.c     |    2 +-
 include/linux/kernel.h       |    2 ++
 include/linux/lockdep.h      |    8 --------
 init/main.c                  |   13 +++++++++++--
 kernel/lockdep.c             |   18 +-----------------
 kernel/trace/trace_irqsoff.c |    8 --------
 6 files changed, 15 insertions(+), 36 deletions(-)

Index: work/include/linux/kernel.h
===================================================================
--- work.orig/include/linux/kernel.h
+++ work/include/linux/kernel.h
@@ -243,6 +243,8 @@ extern int test_taint(unsigned flag);
 extern unsigned long get_taint(void);
 extern int root_mountflags;
 
+extern bool early_boot_irqs_disabled;
+
 /* Values used for system_state */
 extern enum system_states {
 	SYSTEM_BOOTING,
Index: work/init/main.c
===================================================================
--- work.orig/init/main.c
+++ work/init/main.c
@@ -96,6 +96,15 @@ static inline void mark_rodata_ro(void)
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
 
@@ -554,7 +563,7 @@ asmlinkage void __init start_kernel(void
 	cgroup_init_early();
 
 	local_irq_disable();
-	early_boot_irqs_off();
+	early_boot_irqs_disabled = true;
 
 /*
  * Interrupts are still disabled. Do necessary setups, then
@@ -621,7 +630,7 @@ asmlinkage void __init start_kernel(void
 	if (!irqs_disabled())
 		printk(KERN_CRIT "start_kernel(): bug: interrupts were "
 				 "enabled early\n");
-	early_boot_irqs_on();
+	early_boot_irqs_disabled = false;
 	local_irq_enable();
 
 	/* Interrupts are enabled now so all GFP allocations are safe. */
Index: work/kernel/lockdep.c
===================================================================
--- work.orig/kernel/lockdep.c
+++ work/kernel/lockdep.c
@@ -2292,22 +2292,6 @@ mark_held_locks(struct task_struct *curr
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
@@ -2319,7 +2303,7 @@ void trace_hardirqs_on_caller(unsigned l
 	if (unlikely(!debug_locks || current->lockdep_recursion))
 		return;
 
-	if (DEBUG_LOCKS_WARN_ON(unlikely(!early_boot_irqs_enabled)))
+	if (DEBUG_LOCKS_WARN_ON(unlikely(early_boot_irqs_disabled)))
 		return;
 
 	if (unlikely(curr->hardirqs_enabled)) {
Index: work/arch/x86/xen/enlighten.c
===================================================================
--- work.orig/arch/x86/xen/enlighten.c
+++ work/arch/x86/xen/enlighten.c
@@ -1194,7 +1194,7 @@ asmlinkage void __init xen_start_kernel(
 	per_cpu(xen_vcpu, 0) = &HYPERVISOR_shared_info->vcpu_info[0];
 
 	local_irq_disable();
-	early_boot_irqs_off();
+	early_boot_irqs_disabled = true;
 
 	memblock_init();
 
Index: work/include/linux/lockdep.h
===================================================================
--- work.orig/include/linux/lockdep.h
+++ work/include/linux/lockdep.h
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
Index: work/kernel/trace/trace_irqsoff.c
===================================================================
--- work.orig/kernel/trace/trace_irqsoff.c
+++ work/kernel/trace/trace_irqsoff.c
@@ -453,14 +453,6 @@ void time_hardirqs_off(unsigned long a0,
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

