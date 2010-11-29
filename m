Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732Ab0K2GCw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 01:02:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11588 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751732Ab0K2GCv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 01:02:51 -0500
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Amerigo Wang <amwang@redhat.com>, David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <jaxboe@fusionio.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Venkatesh Pallipadi <venki@google.com>, linux-am33-list@redhat.com
Subject: [PATCH] kernel: clean up USE_GENERIC_SMP_HELPERS
Date: Mon, 29 Nov 2010 14:06:07 +0800
Message-Id: <1291010778-5669-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For arch which needs USE_GENERIC_SMP_HELPERS, it has to
select USE_GENERIC_SMP_HELPERS, rather than leaving a choice
to user, since they don't provide their own implementions.

Also, move on_each_cpu() to kernel/smp.c, it is strange
to put it in kernel/softirq.c.

For arch which doesn't use USE_GENERIC_SMP_HELPERS, e.g.
blackfin, only on_each_cpu() is compiled.

Signed-off-by: Amerigo Wang <amwang@redhat.com>
---
 arch/mn10300/Kconfig |    6 +-----
 arch/x86/Kconfig     |    5 +----
 kernel/Makefile      |    2 +-
 kernel/smp.c         |   20 ++++++++++++++++++++
 kernel/softirq.c     |   19 -------------------
 5 files changed, 23 insertions(+), 29 deletions(-)

diff --git a/arch/mn10300/Kconfig b/arch/mn10300/Kconfig
index 41ba385..8ed41cf 100644
--- a/arch/mn10300/Kconfig
+++ b/arch/mn10300/Kconfig
@@ -203,6 +203,7 @@ endmenu
 config SMP
 	bool "Symmetric multi-processing support"
 	default y
+	select USE_GENERIC_SMP_HELPERS
 	depends on MN10300_PROC_MN2WS0038 || MN10300_PROC_MN2WS0050
 	---help---
 	  This enables support for systems with more than one CPU. If you have
@@ -226,11 +227,6 @@ config NR_CPUS
 	depends on SMP
 	default "2"
 
-config USE_GENERIC_SMP_HELPERS
-	bool
-	depends on SMP
-	default y
-
 source "kernel/Kconfig.preempt"
 
 config MN10300_CURRENT_IN_E2
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index e330da2..736beea 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -65,6 +65,7 @@ config X86
 	select HAVE_SPARSE_IRQ
 	select GENERIC_IRQ_PROBE
 	select GENERIC_PENDING_IRQ if SMP
+	select USE_GENERIC_SMP_HELPERS if SMP
 
 config INSTRUCTION_DECODER
 	def_bool (KPROBES || PERF_EVENTS)
@@ -203,10 +204,6 @@ config HAVE_INTEL_TXT
 	def_bool y
 	depends on EXPERIMENTAL && DMAR && ACPI
 
-config USE_GENERIC_SMP_HELPERS
-	def_bool y
-	depends on SMP
-
 config X86_32_SMP
 	def_bool y
 	depends on X86_32 && SMP
diff --git a/kernel/Makefile b/kernel/Makefile
index 0b5ff08..55f2f93 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -43,7 +43,7 @@ obj-$(CONFIG_RT_MUTEXES) += rtmutex.o
 obj-$(CONFIG_DEBUG_RT_MUTEXES) += rtmutex-debug.o
 obj-$(CONFIG_RT_MUTEX_TESTER) += rtmutex-tester.o
 obj-$(CONFIG_GENERIC_ISA_DMA) += dma.o
-obj-$(CONFIG_USE_GENERIC_SMP_HELPERS) += smp.o
+obj-$(CONFIG_SMP) += smp.o
 ifneq ($(CONFIG_SMP),y)
 obj-y += up.o
 endif
diff --git a/kernel/smp.c b/kernel/smp.c
index 12ed8b0..708f248 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -13,6 +13,7 @@
 #include <linux/smp.h>
 #include <linux/cpu.h>
 
+#ifdef CONFIG_USE_GENERIC_SMP_HELPERS
 static struct {
 	struct list_head	queue;
 	raw_spinlock_t		lock;
@@ -529,3 +530,22 @@ void ipi_call_unlock_irq(void)
 {
 	raw_spin_unlock_irq(&call_function.lock);
 }
+#endif /* USE_GENERIC_SMP_HELPERS */
+
+/*
+ * Call a function on all processors
+ */
+int on_each_cpu(void (*func) (void *info), void *info, int wait)
+{
+	int ret = 0;
+
+	preempt_disable();
+	ret = smp_call_function(func, info, wait);
+	local_irq_disable();
+	func(info);
+	local_irq_enable();
+	preempt_enable();
+	return ret;
+}
+EXPORT_SYMBOL(on_each_cpu);
+
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 18f4be0..0ca9f48 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -883,25 +883,6 @@ static __init int spawn_ksoftirqd(void)
 }
 early_initcall(spawn_ksoftirqd);
 
-#ifdef CONFIG_SMP
-/*
- * Call a function on all processors
- */
-int on_each_cpu(void (*func) (void *info), void *info, int wait)
-{
-	int ret = 0;
-
-	preempt_disable();
-	ret = smp_call_function(func, info, wait);
-	local_irq_disable();
-	func(info);
-	local_irq_enable();
-	preempt_enable();
-	return ret;
-}
-EXPORT_SYMBOL(on_each_cpu);
-#endif
-
 /*
  * [ These __weak aliases are kept in a separate compilation unit, so that
  *   GCC does not inline them incorrectly. ]
-- 
1.7.1

