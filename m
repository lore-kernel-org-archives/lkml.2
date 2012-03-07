Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030580Ab2CGTwf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 14:52:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56426 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965200Ab2CGTwa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 14:52:30 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 07/29] Disintegrate asm/system.h for Blackfin
To: paul.gortmaker@windriver.com, hpa@zytor.com
Cc: torvalds@linux-foundation.org, sfr@canb.auug.org.au, mingo@redhat.com,
        arnd@arndb.de, dhowells@redhat.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Date: Wed, 07 Mar 2012 19:47:14 +0000
Message-ID: <20120307194714.15987.58546.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120307194548.15987.36073.stgit@warthog.procyon.org.uk>
References: <20120307194548.15987.36073.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disintegrate asm/system.h for Blackfin.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/blackfin/include/asm/atomic.h        |  122 ++++++++++++++++++
 arch/blackfin/include/asm/barrier.h       |   46 +++++++
 arch/blackfin/include/asm/exec.h          |    1 
 arch/blackfin/include/asm/irq_handler.h   |    1 
 arch/blackfin/include/asm/special_insns.h |   13 ++
 arch/blackfin/include/asm/switch_to.h     |   39 ++++++
 arch/blackfin/include/asm/system.h        |  192 -----------------------------
 arch/blackfin/kernel/asm-offsets.c        |    1 
 arch/blackfin/kernel/process.c            |    1 
 arch/blackfin/kernel/setup.c              |    1 
 arch/blackfin/kernel/trace.c              |    1 
 arch/blackfin/kernel/traps.c              |    1 
 12 files changed, 227 insertions(+), 192 deletions(-)
 create mode 100644 arch/blackfin/include/asm/barrier.h
 create mode 100644 arch/blackfin/include/asm/exec.h
 create mode 100644 arch/blackfin/include/asm/special_insns.h
 create mode 100644 arch/blackfin/include/asm/switch_to.h
 delete mode 100644 arch/blackfin/include/asm/system.h

diff --git a/arch/blackfin/include/asm/atomic.h b/arch/blackfin/include/asm/atomic.h
index 54c6e28..dd59a02 100644
--- a/arch/blackfin/include/asm/atomic.h
+++ b/arch/blackfin/include/asm/atomic.h
@@ -11,6 +11,128 @@
 
 #include <linux/linkage.h>
 
+asmlinkage unsigned long __raw_xchg_1_asm(volatile void *ptr, unsigned long value);
+asmlinkage unsigned long __raw_xchg_2_asm(volatile void *ptr, unsigned long value);
+asmlinkage unsigned long __raw_xchg_4_asm(volatile void *ptr, unsigned long value);
+asmlinkage unsigned long __raw_cmpxchg_1_asm(volatile void *ptr,
+					unsigned long new, unsigned long old);
+asmlinkage unsigned long __raw_cmpxchg_2_asm(volatile void *ptr,
+					unsigned long new, unsigned long old);
+asmlinkage unsigned long __raw_cmpxchg_4_asm(volatile void *ptr,
+					unsigned long new, unsigned long old);
+
+static inline unsigned long __xchg(unsigned long x, volatile void *ptr,
+				   int size)
+{
+	unsigned long tmp;
+
+	switch (size) {
+	case 1:
+		tmp = __raw_xchg_1_asm(ptr, x);
+		break;
+	case 2:
+		tmp = __raw_xchg_2_asm(ptr, x);
+		break;
+	case 4:
+		tmp = __raw_xchg_4_asm(ptr, x);
+		break;
+	}
+
+	return tmp;
+}
+
+/*
+ * Atomic compare and exchange.  Compare OLD with MEM, if identical,
+ * store NEW in MEM.  Return the initial value in MEM.  Success is
+ * indicated by comparing RETURN with OLD.
+ */
+static inline unsigned long __cmpxchg(volatile void *ptr, unsigned long old,
+				      unsigned long new, int size)
+{
+	unsigned long tmp;
+
+	switch (size) {
+	case 1:
+		tmp = __raw_cmpxchg_1_asm(ptr, new, old);
+		break;
+	case 2:
+		tmp = __raw_cmpxchg_2_asm(ptr, new, old);
+		break;
+	case 4:
+		tmp = __raw_cmpxchg_4_asm(ptr, new, old);
+		break;
+	}
+
+	return tmp;
+}
+#define cmpxchg(ptr, o, n) \
+	((__typeof__(*(ptr)))__cmpxchg((ptr), (unsigned long)(o), \
+		(unsigned long)(n), sizeof(*(ptr))))
+
+#else /* !CONFIG_SMP */
+
+struct __xchg_dummy {
+	unsigned long a[100];
+};
+#define __xg(x) ((volatile struct __xchg_dummy *)(x))
+
+#include <mach/blackfin.h>
+#include <asm/irqflags.h>
+
+static inline unsigned long __xchg(unsigned long x, volatile void *ptr,
+				   int size)
+{
+	unsigned long tmp = 0;
+	unsigned long flags;
+
+	flags = hard_local_irq_save();
+
+	switch (size) {
+	case 1:
+		__asm__ __volatile__
+			("%0 = b%2 (z);\n\t"
+			 "b%2 = %1;\n\t"
+			 : "=&d" (tmp) : "d" (x), "m" (*__xg(ptr)) : "memory");
+		break;
+	case 2:
+		__asm__ __volatile__
+			("%0 = w%2 (z);\n\t"
+			 "w%2 = %1;\n\t"
+			 : "=&d" (tmp) : "d" (x), "m" (*__xg(ptr)) : "memory");
+		break;
+	case 4:
+		__asm__ __volatile__
+			("%0 = %2;\n\t"
+			 "%2 = %1;\n\t"
+			 : "=&d" (tmp) : "d" (x), "m" (*__xg(ptr)) : "memory");
+		break;
+	}
+	hard_local_irq_restore(flags);
+	return tmp;
+}
+
+#include <asm-generic/cmpxchg-local.h>
+
+/*
+ * cmpxchg_local and cmpxchg64_local are atomic wrt current CPU. Always make
+ * them available.
+ */
+#define cmpxchg_local(ptr, o, n)				  	       \
+	((__typeof__(*(ptr)))__cmpxchg_local_generic((ptr), (unsigned long)(o),\
+			(unsigned long)(n), sizeof(*(ptr))))
+#define cmpxchg64_local(ptr, o, n) __cmpxchg64_local_generic((ptr), (o), (n))
+
+#include <asm-generic/cmpxchg.h>
+
+#endif /* !CONFIG_SMP */
+
+#define xchg(ptr, x) ((__typeof__(*(ptr)))__xchg((unsigned long)(x), (ptr), sizeof(*(ptr))))
+#define tas(ptr) ((void)xchg((ptr), 1))
+
+#ifdef CONFIG_SMP
+
+#include <linux/linkage.h>
+
 asmlinkage int __raw_uncached_fetch_asm(const volatile int *ptr);
 asmlinkage int __raw_atomic_update_asm(volatile int *ptr, int value);
 asmlinkage int __raw_atomic_clear_asm(volatile int *ptr, int value);
diff --git a/arch/blackfin/include/asm/barrier.h b/arch/blackfin/include/asm/barrier.h
new file mode 100644
index 0000000..88340c4
--- /dev/null
+++ b/arch/blackfin/include/asm/barrier.h
@@ -0,0 +1,46 @@
+/*
+ * Copyright 2004-2009 Analog Devices Inc.
+ *               Tony Kou (tonyko@lineo.ca)
+ *
+ * Licensed under the GPL-2 or later
+ */
+
+#ifndef _BLACKFIN_BARRIER_H
+#define _BLACKFIN_BARRIER_H
+
+#include <asm/cache.h>
+
+/*
+ * Force strict CPU ordering.
+ */
+#ifdef CONFIG_SMP
+
+#ifdef __ARCH_SYNC_CORE_DCACHE
+/* Force Core data cache coherence */
+# define mb()	do { barrier(); smp_check_barrier(); smp_mark_barrier(); } while (0)
+# define rmb()	do { barrier(); smp_check_barrier(); } while (0)
+# define wmb()	do { barrier(); smp_mark_barrier(); } while (0)
+# define read_barrier_depends()	do { barrier(); smp_check_barrier(); } while (0)
+#else
+# define mb()	barrier()
+# define rmb()	barrier()
+# define wmb()	barrier()
+# define read_barrier_depends()	do { } while (0)
+#endif
+
+#else /* !CONFIG_SMP */
+
+#define mb()	barrier()
+#define rmb()	barrier()
+#define wmb()	barrier()
+#define read_barrier_depends()	do { } while (0)
+
+#endif /* !CONFIG_SMP */
+
+#define smp_mb()  mb()
+#define smp_rmb() rmb()
+#define smp_wmb() wmb()
+#define set_mb(var, value) do { var = value; mb(); } while (0)
+#define smp_read_barrier_depends()	read_barrier_depends()
+
+#endif /* _BLACKFIN_BARRIER_H */
diff --git a/arch/blackfin/include/asm/exec.h b/arch/blackfin/include/asm/exec.h
new file mode 100644
index 0000000..54c2e1d
--- /dev/null
+++ b/arch/blackfin/include/asm/exec.h
@@ -0,0 +1 @@
+/* define arch_align_stack() here */
diff --git a/arch/blackfin/include/asm/irq_handler.h b/arch/blackfin/include/asm/irq_handler.h
index ee73f79..4fbf835 100644
--- a/arch/blackfin/include/asm/irq_handler.h
+++ b/arch/blackfin/include/asm/irq_handler.h
@@ -9,6 +9,7 @@
 
 #include <linux/types.h>
 #include <linux/linkage.h>
+#include <mach/irq.h>
 
 /* init functions only */
 extern int __init init_arch_irq(void);
diff --git a/arch/blackfin/include/asm/special_insns.h b/arch/blackfin/include/asm/special_insns.h
new file mode 100644
index 0000000..5a56bba
--- /dev/null
+++ b/arch/blackfin/include/asm/special_insns.h
@@ -0,0 +1,13 @@
+/*
+ * Copyright 2004-2009 Analog Devices Inc.
+ *               Tony Kou (tonyko@lineo.ca)
+ *
+ * Licensed under the GPL-2 or later
+ */
+
+#ifndef _BLACKFIN_SPECIAL_INSNS_H
+#define _BLACKFIN_SPECIAL_INSNS_H
+
+#define nop()  __asm__ __volatile__ ("nop;\n\t" : : )
+
+#endif	/* _BLACKFIN_SPECIAL_INSNS_H */
diff --git a/arch/blackfin/include/asm/switch_to.h b/arch/blackfin/include/asm/switch_to.h
new file mode 100644
index 0000000..aaf671b
--- /dev/null
+++ b/arch/blackfin/include/asm/switch_to.h
@@ -0,0 +1,39 @@
+/*
+ * Copyright 2004-2009 Analog Devices Inc.
+ *               Tony Kou (tonyko@lineo.ca)
+ *
+ * Licensed under the GPL-2 or later
+ */
+
+#ifndef _BLACKFIN_SWITCH_TO_H
+#define _BLACKFIN_SWITCH_TO_H
+
+#define prepare_to_switch()     do { } while(0)
+
+/*
+ * switch_to(n) should switch tasks to task ptr, first checking that
+ * ptr isn't the current task, in which case it does nothing.
+ */
+
+#include <asm/l1layout.h>
+#include <asm/mem_map.h>
+
+asmlinkage struct task_struct *resume(struct task_struct *prev, struct task_struct *next);
+
+#ifndef CONFIG_SMP
+#define switch_to(prev,next,last) \
+do {    \
+	memcpy (&task_thread_info(prev)->l1_task_info, L1_SCRATCH_TASK_INFO, \
+		sizeof *L1_SCRATCH_TASK_INFO); \
+	memcpy (L1_SCRATCH_TASK_INFO, &task_thread_info(next)->l1_task_info, \
+		sizeof *L1_SCRATCH_TASK_INFO); \
+	(last) = resume (prev, next);   \
+} while (0)
+#else
+#define switch_to(prev, next, last) \
+do {    \
+	(last) = resume(prev, next);   \
+} while (0)
+#endif
+
+#endif /* _BLACKFIN_SWITCH_TO_H */
diff --git a/arch/blackfin/include/asm/system.h b/arch/blackfin/include/asm/system.h
deleted file mode 100644
index 44bd0cc..0000000
--- a/arch/blackfin/include/asm/system.h
+++ /dev/null
@@ -1,192 +0,0 @@
-/*
- * Copyright 2004-2009 Analog Devices Inc.
- *               Tony Kou (tonyko@lineo.ca)
- *
- * Licensed under the GPL-2 or later
- */
-
-#ifndef _BLACKFIN_SYSTEM_H
-#define _BLACKFIN_SYSTEM_H
-
-#include <linux/linkage.h>
-#include <linux/irqflags.h>
-#include <mach/anomaly.h>
-#include <asm/cache.h>
-#include <asm/pda.h>
-#include <asm/irq.h>
-
-/*
- * Force strict CPU ordering.
- */
-#define nop()  __asm__ __volatile__ ("nop;\n\t" : : )
-#define smp_mb()  mb()
-#define smp_rmb() rmb()
-#define smp_wmb() wmb()
-#define set_mb(var, value) do { var = value; mb(); } while (0)
-#define smp_read_barrier_depends()	read_barrier_depends()
-
-#ifdef CONFIG_SMP
-asmlinkage unsigned long __raw_xchg_1_asm(volatile void *ptr, unsigned long value);
-asmlinkage unsigned long __raw_xchg_2_asm(volatile void *ptr, unsigned long value);
-asmlinkage unsigned long __raw_xchg_4_asm(volatile void *ptr, unsigned long value);
-asmlinkage unsigned long __raw_cmpxchg_1_asm(volatile void *ptr,
-					unsigned long new, unsigned long old);
-asmlinkage unsigned long __raw_cmpxchg_2_asm(volatile void *ptr,
-					unsigned long new, unsigned long old);
-asmlinkage unsigned long __raw_cmpxchg_4_asm(volatile void *ptr,
-					unsigned long new, unsigned long old);
-
-#ifdef __ARCH_SYNC_CORE_DCACHE
-/* Force Core data cache coherence */
-# define mb()	do { barrier(); smp_check_barrier(); smp_mark_barrier(); } while (0)
-# define rmb()	do { barrier(); smp_check_barrier(); } while (0)
-# define wmb()	do { barrier(); smp_mark_barrier(); } while (0)
-# define read_barrier_depends()	do { barrier(); smp_check_barrier(); } while (0)
-#else
-# define mb()	barrier()
-# define rmb()	barrier()
-# define wmb()	barrier()
-# define read_barrier_depends()	do { } while (0)
-#endif
-
-static inline unsigned long __xchg(unsigned long x, volatile void *ptr,
-				   int size)
-{
-	unsigned long tmp;
-
-	switch (size) {
-	case 1:
-		tmp = __raw_xchg_1_asm(ptr, x);
-		break;
-	case 2:
-		tmp = __raw_xchg_2_asm(ptr, x);
-		break;
-	case 4:
-		tmp = __raw_xchg_4_asm(ptr, x);
-		break;
-	}
-
-	return tmp;
-}
-
-/*
- * Atomic compare and exchange.  Compare OLD with MEM, if identical,
- * store NEW in MEM.  Return the initial value in MEM.  Success is
- * indicated by comparing RETURN with OLD.
- */
-static inline unsigned long __cmpxchg(volatile void *ptr, unsigned long old,
-				      unsigned long new, int size)
-{
-	unsigned long tmp;
-
-	switch (size) {
-	case 1:
-		tmp = __raw_cmpxchg_1_asm(ptr, new, old);
-		break;
-	case 2:
-		tmp = __raw_cmpxchg_2_asm(ptr, new, old);
-		break;
-	case 4:
-		tmp = __raw_cmpxchg_4_asm(ptr, new, old);
-		break;
-	}
-
-	return tmp;
-}
-#define cmpxchg(ptr, o, n) \
-	((__typeof__(*(ptr)))__cmpxchg((ptr), (unsigned long)(o), \
-		(unsigned long)(n), sizeof(*(ptr))))
-
-#else /* !CONFIG_SMP */
-
-#define mb()	barrier()
-#define rmb()	barrier()
-#define wmb()	barrier()
-#define read_barrier_depends()	do { } while (0)
-
-struct __xchg_dummy {
-	unsigned long a[100];
-};
-#define __xg(x) ((volatile struct __xchg_dummy *)(x))
-
-#include <mach/blackfin.h>
-
-static inline unsigned long __xchg(unsigned long x, volatile void *ptr,
-				   int size)
-{
-	unsigned long tmp = 0;
-	unsigned long flags;
-
-	flags = hard_local_irq_save();
-
-	switch (size) {
-	case 1:
-		__asm__ __volatile__
-			("%0 = b%2 (z);\n\t"
-			 "b%2 = %1;\n\t"
-			 : "=&d" (tmp) : "d" (x), "m" (*__xg(ptr)) : "memory");
-		break;
-	case 2:
-		__asm__ __volatile__
-			("%0 = w%2 (z);\n\t"
-			 "w%2 = %1;\n\t"
-			 : "=&d" (tmp) : "d" (x), "m" (*__xg(ptr)) : "memory");
-		break;
-	case 4:
-		__asm__ __volatile__
-			("%0 = %2;\n\t"
-			 "%2 = %1;\n\t"
-			 : "=&d" (tmp) : "d" (x), "m" (*__xg(ptr)) : "memory");
-		break;
-	}
-	hard_local_irq_restore(flags);
-	return tmp;
-}
-
-#include <asm-generic/cmpxchg-local.h>
-
-/*
- * cmpxchg_local and cmpxchg64_local are atomic wrt current CPU. Always make
- * them available.
- */
-#define cmpxchg_local(ptr, o, n)				  	       \
-	((__typeof__(*(ptr)))__cmpxchg_local_generic((ptr), (unsigned long)(o),\
-			(unsigned long)(n), sizeof(*(ptr))))
-#define cmpxchg64_local(ptr, o, n) __cmpxchg64_local_generic((ptr), (o), (n))
-
-#include <asm-generic/cmpxchg.h>
-
-#endif /* !CONFIG_SMP */
-
-#define xchg(ptr, x) ((__typeof__(*(ptr)))__xchg((unsigned long)(x), (ptr), sizeof(*(ptr))))
-#define tas(ptr) ((void)xchg((ptr), 1))
-
-#define prepare_to_switch()     do { } while(0)
-
-/*
- * switch_to(n) should switch tasks to task ptr, first checking that
- * ptr isn't the current task, in which case it does nothing.
- */
-
-#include <asm/l1layout.h>
-#include <asm/mem_map.h>
-
-asmlinkage struct task_struct *resume(struct task_struct *prev, struct task_struct *next);
-
-#ifndef CONFIG_SMP
-#define switch_to(prev,next,last) \
-do {    \
-	memcpy (&task_thread_info(prev)->l1_task_info, L1_SCRATCH_TASK_INFO, \
-		sizeof *L1_SCRATCH_TASK_INFO); \
-	memcpy (L1_SCRATCH_TASK_INFO, &task_thread_info(next)->l1_task_info, \
-		sizeof *L1_SCRATCH_TASK_INFO); \
-	(last) = resume (prev, next);   \
-} while (0)
-#else
-#define switch_to(prev, next, last) \
-do {    \
-	(last) = resume(prev, next);   \
-} while (0)
-#endif
-
-#endif	/* _BLACKFIN_SYSTEM_H */
diff --git a/arch/blackfin/kernel/asm-offsets.c b/arch/blackfin/kernel/asm-offsets.c
index 17e3546..37fcae9 100644
--- a/arch/blackfin/kernel/asm-offsets.c
+++ b/arch/blackfin/kernel/asm-offsets.c
@@ -14,6 +14,7 @@
 #include <linux/irq.h>
 #include <linux/thread_info.h>
 #include <linux/kbuild.h>
+#include <asm/pda.h>
 
 int main(void)
 {
diff --git a/arch/blackfin/kernel/process.c b/arch/blackfin/kernel/process.c
index 8dd0416..8c5369c 100644
--- a/arch/blackfin/kernel/process.c
+++ b/arch/blackfin/kernel/process.c
@@ -19,6 +19,7 @@
 #include <asm/blackfin.h>
 #include <asm/fixed_code.h>
 #include <asm/mem_map.h>
+#include <asm/irq.h>
 
 asmlinkage void ret_from_fork(void);
 
diff --git a/arch/blackfin/kernel/setup.c b/arch/blackfin/kernel/setup.c
index d6102c8..2aa0193 100644
--- a/arch/blackfin/kernel/setup.c
+++ b/arch/blackfin/kernel/setup.c
@@ -30,6 +30,7 @@
 #include <asm/fixed_code.h>
 #include <asm/early_printk.h>
 #include <asm/irq_handler.h>
+#include <asm/pda.h>
 
 u16 _bfin_swrst;
 EXPORT_SYMBOL(_bfin_swrst);
diff --git a/arch/blackfin/kernel/trace.c b/arch/blackfin/kernel/trace.c
index 050db44..44bbf2f 100644
--- a/arch/blackfin/kernel/trace.c
+++ b/arch/blackfin/kernel/trace.c
@@ -21,6 +21,7 @@
 #include <asm/fixed_code.h>
 #include <asm/traps.h>
 #include <asm/irq_handler.h>
+#include <asm/pda.h>
 
 void decode_address(char *buf, unsigned long address)
 {
diff --git a/arch/blackfin/kernel/traps.c b/arch/blackfin/kernel/traps.c
index 655f25d..de5c2c3 100644
--- a/arch/blackfin/kernel/traps.c
+++ b/arch/blackfin/kernel/traps.c
@@ -17,6 +17,7 @@
 #include <asm/trace.h>
 #include <asm/fixed_code.h>
 #include <asm/pseudo_instructions.h>
+#include <asm/pda.h>
 
 #ifdef CONFIG_KGDB
 # include <linux/kgdb.h>

