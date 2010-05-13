Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257Ab0EMGxv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 02:53:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:56751 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753503Ab0EMGxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 02:53:48 -0400
Date: Thu, 13 May 2010 06:53:23 GMT
From: tip-bot for Don Zickus <dzickus@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       eparis@redhat.com, peterz@infradead.org, randy.dunlap@oracle.com,
       gorcunov@gmail.com, fweisbec@gmail.com, tglx@linutronix.de,
       dzickus@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       eparis@redhat.com, peterz@infradead.org, gorcunov@gmail.com,
       randy.dunlap@oracle.com, fweisbec@gmail.com, tglx@linutronix.de,
       dzickus@redhat.com, mingo@elte.hu
In-Reply-To: <1273266711-18706-7-git-send-email-dzickus@redhat.com>
References: <1273266711-18706-7-git-send-email-dzickus@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/nmi] x86: Cleanup hw_nmi.c cruft
Message-ID: <tip-10f9014912a2b1cb59c39cdea777e6d9afa8f17e@git.kernel.org>
Git-Commit-ID: 10f9014912a2b1cb59c39cdea777e6d9afa8f17e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 13 May 2010 06:53:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  10f9014912a2b1cb59c39cdea777e6d9afa8f17e
Gitweb:     http://git.kernel.org/tip/10f9014912a2b1cb59c39cdea777e6d9afa8f17e
Author:     Don Zickus <dzickus@redhat.com>
AuthorDate: Fri, 7 May 2010 17:11:49 -0400
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Wed, 12 May 2010 23:55:48 +0200

x86: Cleanup hw_nmi.c cruft

The design of the hardlockup watchdog has changed and cruft was left
behind in the hw_nmi.c file.  Just remove the code that isn't used
anymore.

Signed-off-by: Don Zickus <dzickus@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Eric Paris <eparis@redhat.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
LKML-Reference: <1273266711-18706-7-git-send-email-dzickus@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
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
