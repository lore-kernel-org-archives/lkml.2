Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423Ab1ATLGn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 06:06:43 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36371 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755374Ab1ATLGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 06:06:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=o/SLJ1uGAlMowHe6DbdPjZErx+KaeD7UHihuyKDPg+QViQYbSpRGnRgoBvMjkH8H+z
         JP7incURbY8MUclROrDqcAuMwfFUTfUwfdJSxOB4kkXDpfzAbZN2O21PXSiVV1lc0mTx
         +xHRCl9uh4roy8IlrWaF4jaO7WaWRAyJ919kg=
Date: Thu, 20 Jan 2011 12:06:35 +0100
From: Tejun Heo <tj@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [PATCH 1/2] lockdep: move early boot local IRQ enable/disable
 status to init/main.c
Message-ID: <20110120110635.GB6036@htj.dyndns.org>
References: <AANLkTimajU0x1v6y3rH2+jr-bZ=tNLs1S_agXdGGAa3S@mail.gmail.com>
 <20110119120200.GA1057@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110119120200.GA1057@elte.hu>
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

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/kernel.h |    2 ++
 init/main.c            |   13 +++++++++++--
 kernel/lockdep.c       |   18 +-----------------
 3 files changed, 14 insertions(+), 19 deletions(-)

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
