Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758505Ab0EGVMj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 17:12:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5764 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758424Ab0EGVMg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 17:12:36 -0400
From: Don Zickus <dzickus@redhat.com>
To: mingo@elte.hu, fweisbec@gmail.com
Cc: peterz@infradead.org, gorcunov@gmail.com, aris@redhat.com,
       linux-kernel@vger.kernel.org, randy.dunlap@oracle.com,
       dzickus@redhat.com
Subject: [PATCH 6/8] [x86] watchdog: cleanup hw_nmi.c cruft
Date: Fri,  7 May 2010 17:11:49 -0400
Message-Id: <1273266711-18706-7-git-send-email-dzickus@redhat.com>
In-Reply-To: <1273266711-18706-1-git-send-email-dzickus@redhat.com>
References: <1273266711-18706-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The design of the hardlockup watchdog has changed and cruft was left
behind in the hw_nmi.c file.  Just remove the code that isn't used
anymore.

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/x86/kernel/apic/hw_nmi.c |   58 -----------------------------------------
 1 files changed, 0 insertions(+), 58 deletions(-)

diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
index 8c3edfb..3b40082 100644
--- a/arch/x86/kernel/apic/hw_nmi.c
+++ b/arch/x86/kernel/apic/hw_nmi.c
@@ -9,74 +9,16 @@
  *
  */
 
-#include <asm/apic.h>
-#include <linux/smp.h>
 #include <linux/cpumask.h>
-#include <linux/sched.h>
-#include <linux/percpu.h>
-#include <linux/cpumask.h>
-#include <linux/kernel_stat.h>
-#include <asm/mce.h>
 #include <linux/kdebug.h>
 #include <linux/notifier.h>
 #include <linux/kprobes.h>
-
-
 #include <linux/nmi.h>
 #include <linux/module.h>
 
 /* For reliability, we're prepared to waste bits here. */
 static DECLARE_BITMAP(backtrace_mask, NR_CPUS) __read_mostly;
 
-static DEFINE_PER_CPU(unsigned, last_irq_sum);
-
-/*
- * Take the local apic timer and PIT/HPET into account. We don't
- * know which one is active, when we have highres/dyntick on
- */
-static inline unsigned int get_timer_irqs(int cpu)
-{
-	unsigned int irqs = per_cpu(irq_stat, cpu).irq0_irqs;
-
-#if defined(CONFIG_X86_LOCAL_APIC)
-	irqs += per_cpu(irq_stat, cpu).apic_timer_irqs;
-#endif
-
-	return irqs;
-}
-
-static inline int mce_in_progress(void)
-{
-#if defined(CONFIG_X86_MCE)
-	return atomic_read(&mce_entry) > 0;
-#endif
-	return 0;
-}
-
-int hw_nmi_is_cpu_stuck(struct pt_regs *regs)
-{
-	unsigned int sum;
-	int cpu = smp_processor_id();
-
-	/* if we are doing an mce, just assume the cpu is not stuck */
-	/* Could check oops_in_progress here too, but it's safer not to */
-	if (mce_in_progress())
-		return 0;
-
-	/* We determine if the cpu is stuck by checking whether any
-	 * interrupts have happened since we last checked.  Of course
-	 * an nmi storm could create false positives, but the higher
-	 * level logic should account for that
-	 */
-	sum = get_timer_irqs(cpu);
-	if (__get_cpu_var(last_irq_sum) == sum) {
-		return 1;
-	} else {
-		__get_cpu_var(last_irq_sum) = sum;
-		return 0;
-	}
-}
-
 u64 hw_nmi_get_sample_period(void)
 {
 	return (u64)(cpu_khz) * 1000 * 60;
-- 
1.7.0.1

