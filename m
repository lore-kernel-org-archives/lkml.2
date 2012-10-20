Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282Ab2JTQYe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 12:24:34 -0400
Received: from mail-yh0-f46.google.com ([209.85.213.46]:59192 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754139Ab2JTQW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 12:22:58 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [RFC PATCH 2/8] irq_work: Let the arch tell us about self-IPI support
Date: Sat, 20 Oct 2012 12:22:41 -0400
Message-Id: <1350750167-14263-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1350750167-14263-1-git-send-email-fweisbec@gmail.com>
References: <1350750167-14263-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This prepares us to make printk working on nohz CPUs
using irq work.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/alpha/include/asm/irq_work.h   |    5 ++++-
 arch/alpha/kernel/time.c            |    2 +-
 arch/powerpc/include/asm/irq_work.h |    4 +++-
 arch/powerpc/kernel/time.c          |    2 +-
 arch/sparc/include/asm/irq_work.h   |    4 +++-
 arch/sparc/kernel/pcr.c             |    2 +-
 arch/x86/include/asm/irq_work.h     |    9 +++++----
 arch/x86/kernel/irq_work.c          |    2 +-
 include/asm-generic/irq_work.h      |   14 ++++++++++++++
 9 files changed, 33 insertions(+), 11 deletions(-)

diff --git a/arch/alpha/include/asm/irq_work.h b/arch/alpha/include/asm/irq_work.h
index 814ff3d..3d32132 100644
--- a/arch/alpha/include/asm/irq_work.h
+++ b/arch/alpha/include/asm/irq_work.h
@@ -1,6 +1,9 @@
 #ifndef _ALPHA_IRQ_WORK_H
 #define _ALPHA_IRQ_WORK_H
 
-extern void arch_irq_work_raise(void);
+extern void __arch_irq_work_raise(void);
+#define arch_irq_work_raise __arch_irq_work_raise
+
+#include <asm-generic/irq_work.h>
 
 #endif
diff --git a/arch/alpha/kernel/time.c b/arch/alpha/kernel/time.c
index e336694..91c5eec 100644
--- a/arch/alpha/kernel/time.c
+++ b/arch/alpha/kernel/time.c
@@ -90,7 +90,7 @@ DEFINE_PER_CPU(u8, irq_work_pending);
 #define test_irq_work_pending()      __get_cpu_var(irq_work_pending)
 #define clear_irq_work_pending()     __get_cpu_var(irq_work_pending) = 0
 
-void arch_irq_work_raise(void)
+void __arch_irq_work_raise(void)
 {
 	set_irq_work_pending_flag();
 }
diff --git a/arch/powerpc/include/asm/irq_work.h b/arch/powerpc/include/asm/irq_work.h
index 8b9927f..8aa36aa 100644
--- a/arch/powerpc/include/asm/irq_work.h
+++ b/arch/powerpc/include/asm/irq_work.h
@@ -1,6 +1,8 @@
 #ifndef _ASM_POWERPC_IRQ_WORK_H
 #define _ASM_POWERPC_IRQ_WORK_H
 
-extern void arch_irq_work_raise(void);
+extern void __arch_irq_work_raise(void);
+#define arch_irq_work_raise __arch_irq_work_raise
 
+#include <asm-generic/irq_work.h>
 #endif
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index c9986fd..31565ac 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -466,7 +466,7 @@ DEFINE_PER_CPU(u8, irq_work_pending);
 
 #endif /* 32 vs 64 bit */
 
-void arch_irq_work_raise(void)
+void __arch_irq_work_raise(void)
 {
 	preempt_disable();
 	set_irq_work_pending_flag();
diff --git a/arch/sparc/include/asm/irq_work.h b/arch/sparc/include/asm/irq_work.h
index 1d062a6..383772d 100644
--- a/arch/sparc/include/asm/irq_work.h
+++ b/arch/sparc/include/asm/irq_work.h
@@ -1,6 +1,8 @@
 #ifndef ___ASM_SPARC_IRQ_H
 #define ___ASM_SPARC_IRQ_H
 
-extern void arch_irq_work_raise(void);
+extern void __arch_irq_work_raise(void);
+#define arch_irq_work_raise __arch_irq_work_raise
 
+#include <asm-generic/irq_work.h>
 #endif
diff --git a/arch/sparc/kernel/pcr.c b/arch/sparc/kernel/pcr.c
index 269af58..d1e1ecf 100644
--- a/arch/sparc/kernel/pcr.c
+++ b/arch/sparc/kernel/pcr.c
@@ -43,7 +43,7 @@ void __irq_entry deferred_pcr_work_irq(int irq, struct pt_regs *regs)
 	set_irq_regs(old_regs);
 }
 
-void arch_irq_work_raise(void)
+void __arch_irq_work_raise(void)
 {
 	set_softint(1 << PIL_DEFERRED_PCR_WORK);
 }
diff --git a/arch/x86/include/asm/irq_work.h b/arch/x86/include/asm/irq_work.h
index 38eed96..dad8266 100644
--- a/arch/x86/include/asm/irq_work.h
+++ b/arch/x86/include/asm/irq_work.h
@@ -1,10 +1,11 @@
 #ifndef _ASM_X86_IRQ_WORK_H
 #define _ASM_X86_IRQ_WORK_H
 
-#ifndef CONFIG_X86_LOCAL_APIC
-#include <asm-generic/irq_work.h>
-# else
-extern void arch_irq_work_raise(void);
+#ifdef CONFIG_X86_LOCAL_APIC
+extern void __arch_irq_work_raise(void);
+#define arch_irq_work_raise __arch_irq_work_raise
 #endif
 
+#include <asm-generic/irq_work.h>
+
 #endif
diff --git a/arch/x86/kernel/irq_work.c b/arch/x86/kernel/irq_work.c
index 95f5d4e..7389d5e 100644
--- a/arch/x86/kernel/irq_work.c
+++ b/arch/x86/kernel/irq_work.c
@@ -19,7 +19,7 @@ void smp_irq_work_interrupt(struct pt_regs *regs)
 }
 
 #ifdef CONFIG_X86_LOCAL_APIC
-void arch_irq_work_raise(void)
+void __arch_irq_work_raise(void)
 {
 	if (!cpu_has_apic)
 		return;
diff --git a/include/asm-generic/irq_work.h b/include/asm-generic/irq_work.h
index a2d4108..e3e4f02 100644
--- a/include/asm-generic/irq_work.h
+++ b/include/asm-generic/irq_work.h
@@ -4,6 +4,20 @@
 /*
  * Lame architectures will get the timer tick callback
  */
+#ifndef arch_irq_work_raise
 static inline void arch_irq_work_raise(void) { }
+#endif
+
+/*
+ * Unless told otherwise, consider the arch doesn't implement irq work
+ * using self IPIs but through another way like defaulting to the hook
+ * on the sched tick.
+ */
+#ifndef arch_irq_work_has_ipi
+static inline bool arch_irq_work_has_ipi(void)
+{
+	return false;
+}
+#endif
 
 #endif
-- 
1.7.5.4

