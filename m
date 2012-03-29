Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933650Ab2C2RTS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 13:19:18 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933157Ab2C2RS7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 13:18:59 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-kernel@vger.kernel.org
Cc: user-mode-linux-devel@lists.sourceforge.net, toralf.foerster@gmx.de,
        Richard Weinberger <richard@nod.at>, dhowells@redhat.com
Subject: [PATCH 1/2] um: Disintegrate asm/system.h
Date: Thu, 29 Mar 2012 19:18:49 +0200
Message-Id: <1333041530-2998-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.7.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Weinberger <richard@nod.at>
Reported-by: Toralf Förster <toralf.foerster@gmx.de>
CC: dhowells@redhat.com
---
 arch/um/drivers/mconsole_kern.c |    1 +
 arch/um/include/asm/Kbuild      |    2 +-
 arch/x86/um/asm/barrier.h       |   75 +++++++++++++++++++++
 arch/x86/um/asm/switch_to.h     |    7 ++
 arch/x86/um/asm/system.h        |  135 ---------------------------------------
 5 files changed, 84 insertions(+), 136 deletions(-)
 create mode 100644 arch/x86/um/asm/barrier.h
 create mode 100644 arch/x86/um/asm/switch_to.h
 delete mode 100644 arch/x86/um/asm/system.h

diff --git a/arch/um/drivers/mconsole_kern.c b/arch/um/drivers/mconsole_kern.c
index e672bd6..43b39d6 100644
--- a/arch/um/drivers/mconsole_kern.c
+++ b/arch/um/drivers/mconsole_kern.c
@@ -22,6 +22,7 @@
 #include <linux/workqueue.h>
 #include <linux/mutex.h>
 #include <asm/uaccess.h>
+#include <asm/switch_to.h>
 
 #include "init.h"
 #include "irq_kern.h"
diff --git a/arch/um/include/asm/Kbuild b/arch/um/include/asm/Kbuild
index 8419f5c..bb5d6e6 100644
--- a/arch/um/include/asm/Kbuild
+++ b/arch/um/include/asm/Kbuild
@@ -1,3 +1,3 @@
 generic-y += bug.h cputime.h device.h emergency-restart.h futex.h hardirq.h
 generic-y += hw_irq.h irq_regs.h kdebug.h percpu.h sections.h topology.h xor.h
-generic-y += ftrace.h pci.h io.h param.h delay.h mutex.h current.h
+generic-y += ftrace.h pci.h io.h param.h delay.h mutex.h current.h exec.h
diff --git a/arch/x86/um/asm/barrier.h b/arch/x86/um/asm/barrier.h
new file mode 100644
index 0000000..7d01b8c
--- /dev/null
+++ b/arch/x86/um/asm/barrier.h
@@ -0,0 +1,75 @@
+#ifndef _ASM_UM_BARRIER_H_
+#define _ASM_UM_BARRIER_H_
+
+#include <asm/asm.h>
+#include <asm/segment.h>
+#include <asm/cpufeature.h>
+#include <asm/cmpxchg.h>
+#include <asm/nops.h>
+
+#include <linux/kernel.h>
+#include <linux/irqflags.h>
+
+/*
+ * Force strict CPU ordering.
+ * And yes, this is required on UP too when we're talking
+ * to devices.
+ */
+#ifdef CONFIG_X86_32
+
+#define mb()	alternative("lock; addl $0,0(%%esp)", "mfence", X86_FEATURE_XMM2)
+#define rmb()	alternative("lock; addl $0,0(%%esp)", "lfence", X86_FEATURE_XMM2)
+#define wmb()	alternative("lock; addl $0,0(%%esp)", "sfence", X86_FEATURE_XMM)
+
+#else /* CONFIG_X86_32 */
+
+#define mb()	asm volatile("mfence" : : : "memory")
+#define rmb()	asm volatile("lfence" : : : "memory")
+#define wmb()	asm volatile("sfence" : : : "memory")
+
+#endif /* CONFIG_X86_32 */
+
+#define read_barrier_depends()	do { } while (0)
+
+#ifdef CONFIG_SMP
+
+#define smp_mb()	mb()
+#ifdef CONFIG_X86_PPRO_FENCE
+#define smp_rmb()	rmb()
+#else /* CONFIG_X86_PPRO_FENCE */
+#define smp_rmb()	barrier()
+#endif /* CONFIG_X86_PPRO_FENCE */
+
+#ifdef CONFIG_X86_OOSTORE
+#define smp_wmb()	wmb()
+#else /* CONFIG_X86_OOSTORE */
+#define smp_wmb()	barrier()
+#endif /* CONFIG_X86_OOSTORE */
+
+#define smp_read_barrier_depends()	read_barrier_depends()
+#define set_mb(var, value) do { (void)xchg(&var, value); } while (0)
+
+#else /* CONFIG_SMP */
+
+#define smp_mb()	barrier()
+#define smp_rmb()	barrier()
+#define smp_wmb()	barrier()
+#define smp_read_barrier_depends()	do { } while (0)
+#define set_mb(var, value) do { var = value; barrier(); } while (0)
+
+#endif /* CONFIG_SMP */
+
+/*
+ * Stop RDTSC speculation. This is needed when you need to use RDTSC
+ * (or get_cycles or vread that possibly accesses the TSC) in a defined
+ * code region.
+ *
+ * (Could use an alternative three way for this if there was one.)
+ */
+static inline void rdtsc_barrier(void)
+{
+	alternative(ASM_NOP3, "mfence", X86_FEATURE_MFENCE_RDTSC);
+	alternative(ASM_NOP3, "lfence", X86_FEATURE_LFENCE_RDTSC);
+}
+
+#endif
diff --git a/arch/x86/um/asm/switch_to.h b/arch/x86/um/asm/switch_to.h
new file mode 100644
index 0000000..cf97d20
--- /dev/null
+++ b/arch/x86/um/asm/switch_to.h
@@ -0,0 +1,7 @@
+#ifndef _ASM_UM_SWITCH_TO_H_
+#define _ASM_UM_SWITCH_TO_H_
+
+extern void *_switch_to(void *prev, void *next, void *last);
+#define switch_to(prev, next, last) prev = _switch_to(prev, next, last)
+
+#endif
diff --git a/arch/x86/um/asm/system.h b/arch/x86/um/asm/system.h
deleted file mode 100644
index a459fd9..0000000
--- a/arch/x86/um/asm/system.h
+++ /dev/null
@@ -1,135 +0,0 @@
-#ifndef _ASM_X86_SYSTEM_H_
-#define _ASM_X86_SYSTEM_H_
-
-#include <asm/asm.h>
-#include <asm/segment.h>
-#include <asm/cpufeature.h>
-#include <asm/cmpxchg.h>
-#include <asm/nops.h>
-
-#include <linux/kernel.h>
-#include <linux/irqflags.h>
-
-/* entries in ARCH_DLINFO: */
-#ifdef CONFIG_IA32_EMULATION
-# define AT_VECTOR_SIZE_ARCH 2
-#else
-# define AT_VECTOR_SIZE_ARCH 1
-#endif
-
-extern unsigned long arch_align_stack(unsigned long sp);
-
-void default_idle(void);
-
-/*
- * Force strict CPU ordering.
- * And yes, this is required on UP too when we're talking
- * to devices.
- */
-#ifdef CONFIG_X86_32
-/*
- * Some non-Intel clones support out of order store. wmb() ceases to be a
- * nop for these.
- */
-#define mb() alternative("lock; addl $0,0(%%esp)", "mfence", X86_FEATURE_XMM2)
-#define rmb() alternative("lock; addl $0,0(%%esp)", "lfence", X86_FEATURE_XMM2)
-#define wmb() alternative("lock; addl $0,0(%%esp)", "sfence", X86_FEATURE_XMM)
-#else
-#define mb() 	asm volatile("mfence":::"memory")
-#define rmb()	asm volatile("lfence":::"memory")
-#define wmb()	asm volatile("sfence" ::: "memory")
-#endif
-
-/**
- * read_barrier_depends - Flush all pending reads that subsequents reads
- * depend on.
- *
- * No data-dependent reads from memory-like regions are ever reordered
- * over this barrier.  All reads preceding this primitive are guaranteed
- * to access memory (but not necessarily other CPUs' caches) before any
- * reads following this primitive that depend on the data return by
- * any of the preceding reads.  This primitive is much lighter weight than
- * rmb() on most CPUs, and is never heavier weight than is
- * rmb().
- *
- * These ordering constraints are respected by both the local CPU
- * and the compiler.
- *
- * Ordering is not guaranteed by anything other than these primitives,
- * not even by data dependencies.  See the documentation for
- * memory_barrier() for examples and URLs to more information.
- *
- * For example, the following code would force ordering (the initial
- * value of "a" is zero, "b" is one, and "p" is "&a"):
- *
- * <programlisting>
- *	CPU 0				CPU 1
- *
- *	b = 2;
- *	memory_barrier();
- *	p = &b;				q = p;
- *					read_barrier_depends();
- *					d = *q;
- * </programlisting>
- *
- * because the read of "*q" depends on the read of "p" and these
- * two reads are separated by a read_barrier_depends().  However,
- * the following code, with the same initial values for "a" and "b":
- *
- * <programlisting>
- *	CPU 0				CPU 1
- *
- *	a = 2;
- *	memory_barrier();
- *	b = 3;				y = b;
- *					read_barrier_depends();
- *					x = a;
- * </programlisting>
- *
- * does not enforce ordering, since there is no data dependency between
- * the read of "a" and the read of "b".  Therefore, on some CPUs, such
- * as Alpha, "y" could be set to 3 and "x" to 0.  Use rmb()
- * in cases like this where there are no data dependencies.
- **/
-
-#define read_barrier_depends()	do { } while (0)
-
-#ifdef CONFIG_SMP
-#define smp_mb()	mb()
-#ifdef CONFIG_X86_PPRO_FENCE
-# define smp_rmb()	rmb()
-#else
-# define smp_rmb()	barrier()
-#endif
-#ifdef CONFIG_X86_OOSTORE
-# define smp_wmb() 	wmb()
-#else
-# define smp_wmb()	barrier()
-#endif
-#define smp_read_barrier_depends()	read_barrier_depends()
-#define set_mb(var, value) do { (void)xchg(&var, value); } while (0)
-#else
-#define smp_mb()	barrier()
-#define smp_rmb()	barrier()
-#define smp_wmb()	barrier()
-#define smp_read_barrier_depends()	do { } while (0)
-#define set_mb(var, value) do { var = value; barrier(); } while (0)
-#endif
-
-/*
- * Stop RDTSC speculation. This is needed when you need to use RDTSC
- * (or get_cycles or vread that possibly accesses the TSC) in a defined
- * code region.
- *
- * (Could use an alternative three way for this if there was one.)
- */
-static inline void rdtsc_barrier(void)
-{
-	alternative(ASM_NOP3, "mfence", X86_FEATURE_MFENCE_RDTSC);
-	alternative(ASM_NOP3, "lfence", X86_FEATURE_LFENCE_RDTSC);
-}
-
-extern void *_switch_to(void *prev, void *next, void *last);
-#define switch_to(prev, next, last) prev = _switch_to(prev, next, last)
-
-#endif
-- 
1.7.7.3

