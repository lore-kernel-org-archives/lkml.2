Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758523Ab0EMBWT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 21:22:19 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39181 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758176Ab0EMBVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 21:21:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=m1o74djH3LOSX5LFuJiPmiTbBldhGBMI9qxDlHnfRkc2SzDg+pl+TghVD9tFPK1Gu1
         QJGMFbWSkMfUtP3enw7vRstJP5dgx2rpsMh6qIDeIU76AsVISdqyNE82ZsPRa6lWMtMe
         pFwj3KXn+vk17qoDrmzV1sgoTIKfsAFn4vL5g=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Don Zickus <dzickus@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Eric Paris <eparis@redhat.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 6/9] x86: Cleanup hw_nmi.c cruft
Date: Thu, 13 May 2010 03:21:11 +0200
Message-Id: <1273713674-8434-7-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1273713674-8434-1-git-send-regression-fweisbec@gmail.com>
References: <1273713674-8434-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Don Zickus <dzickus@redhat.com>

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
-- 
1.6.2.3

