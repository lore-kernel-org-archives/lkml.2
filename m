Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030852Ab2COVHB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 17:07:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15494 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161560Ab2COU4V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 16:56:21 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 06/38] Disintegrate asm/system.h for AVR32 [ver #3]
To: paul.gortmaker@windriver.com
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, arnd@arndb.de,
        David Howells <dhowells@redhat.com>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>
Date: Thu, 15 Mar 2012 20:56:12 +0000
Message-ID: <20120315205612.28759.40076.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120315205514.28759.58969.stgit@warthog.procyon.org.uk>
References: <20120315205514.28759.58969.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disintegrate asm/system.h for AVR32.  This has not been compiled at all.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
---

 arch/avr32/include/asm/atomic.h        |    2 
 arch/avr32/include/asm/barrier.h       |   27 +++++
 arch/avr32/include/asm/bitops.h        |    1 
 arch/avr32/include/asm/bug.h           |    5 +
 arch/avr32/include/asm/cmpxchg.h       |  117 ++++++++++++++++++++
 arch/avr32/include/asm/exec.h          |   13 ++
 arch/avr32/include/asm/special_insns.h |   13 ++
 arch/avr32/include/asm/switch_to.h     |   46 ++++++++
 arch/avr32/include/asm/system.h        |  184 +-------------------------------
 arch/avr32/mach-at32ap/cpufreq.c       |    1 
 arch/avr32/oprofile/op_model_avr32.c   |    1 
 11 files changed, 228 insertions(+), 182 deletions(-)
 create mode 100644 arch/avr32/include/asm/barrier.h
 create mode 100644 arch/avr32/include/asm/cmpxchg.h
 create mode 100644 arch/avr32/include/asm/exec.h
 create mode 100644 arch/avr32/include/asm/special_insns.h
 create mode 100644 arch/avr32/include/asm/switch_to.h

diff --git a/arch/avr32/include/asm/atomic.h b/arch/avr32/include/asm/atomic.h
index e0ac263..6140727 100644
--- a/arch/avr32/include/asm/atomic.h
+++ b/arch/avr32/include/asm/atomic.h
@@ -15,7 +15,7 @@
 #define __ASM_AVR32_ATOMIC_H
 
 #include <linux/types.h>
-#include <asm/system.h>
+#include <asm/cmpxchg.h>
 
 #define ATOMIC_INIT(i)  { (i) }
 
diff --git a/arch/avr32/include/asm/barrier.h b/arch/avr32/include/asm/barrier.h
new file mode 100644
index 0000000..808001c
--- /dev/null
+++ b/arch/avr32/include/asm/barrier.h
@@ -0,0 +1,27 @@
+/*
+ * Copyright (C) 2004-2006 Atmel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __ASM_AVR32_BARRIER_H
+#define __ASM_AVR32_BARRIER_H
+
+#define mb()			asm volatile("" : : : "memory")
+#define rmb()			mb()
+#define wmb()			asm volatile("sync 0" : : : "memory")
+#define read_barrier_depends()  do { } while(0)
+#define set_mb(var, value)      do { var = value; mb(); } while(0)
+
+#ifdef CONFIG_SMP
+# error "The AVR32 port does not support SMP"
+#else
+# define smp_mb()		barrier()
+# define smp_rmb()		barrier()
+# define smp_wmb()		barrier()
+# define smp_read_barrier_depends() do { } while(0)
+#endif
+
+
+#endif /* __ASM_AVR32_BARRIER_H */
diff --git a/arch/avr32/include/asm/bitops.h b/arch/avr32/include/asm/bitops.h
index b70c19b..ebe7ad3 100644
--- a/arch/avr32/include/asm/bitops.h
+++ b/arch/avr32/include/asm/bitops.h
@@ -13,7 +13,6 @@
 #endif
 
 #include <asm/byteorder.h>
-#include <asm/system.h>
 
 /*
  * clear_bit() doesn't provide any barrier for the compiler
diff --git a/arch/avr32/include/asm/bug.h b/arch/avr32/include/asm/bug.h
index 2aa373cc..85a92d0 100644
--- a/arch/avr32/include/asm/bug.h
+++ b/arch/avr32/include/asm/bug.h
@@ -70,4 +70,9 @@
 
 #include <asm-generic/bug.h>
 
+struct pt_regs;
+void die(const char *str, struct pt_regs *regs, long err);
+void _exception(long signr, struct pt_regs *regs, int code,
+		unsigned long addr);
+
 #endif /* __ASM_AVR32_BUG_H */
diff --git a/arch/avr32/include/asm/cmpxchg.h b/arch/avr32/include/asm/cmpxchg.h
new file mode 100644
index 0000000..962a6ae
--- /dev/null
+++ b/arch/avr32/include/asm/cmpxchg.h
@@ -0,0 +1,117 @@
+/*
+ * Atomic operations that C can't guarantee us.  Useful for
+ * resource counting etc.
+ *
+ * But use these as seldom as possible since they are slower than
+ * regular operations.
+ *
+ * Copyright (C) 2004-2006 Atmel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __ASM_AVR32_CMPXCHG_H
+#define __ASM_AVR32_CMPXCHG_H
+
+#define xchg(ptr,x) \
+	((__typeof__(*(ptr)))__xchg((unsigned long)(x),(ptr),sizeof(*(ptr))))
+
+extern void __xchg_called_with_bad_pointer(void);
+
+static inline unsigned long xchg_u32(u32 val, volatile u32 *m)
+{
+	u32 ret;
+
+	asm volatile("xchg %[ret], %[m], %[val]"
+			: [ret] "=&r"(ret), "=m"(*m)
+			: "m"(*m), [m] "r"(m), [val] "r"(val)
+			: "memory");
+	return ret;
+}
+
+static inline unsigned long __xchg(unsigned long x,
+				       volatile void *ptr,
+				       int size)
+{
+	switch(size) {
+	case 4:
+		return xchg_u32(x, ptr);
+	default:
+		__xchg_called_with_bad_pointer();
+		return x;
+	}
+}
+
+static inline unsigned long __cmpxchg_u32(volatile int *m, unsigned long old,
+					  unsigned long new)
+{
+	__u32 ret;
+
+	asm volatile(
+		"1:	ssrf	5\n"
+		"	ld.w	%[ret], %[m]\n"
+		"	cp.w	%[ret], %[old]\n"
+		"	brne	2f\n"
+		"	stcond	%[m], %[new]\n"
+		"	brne	1b\n"
+		"2:\n"
+		: [ret] "=&r"(ret), [m] "=m"(*m)
+		: "m"(m), [old] "ir"(old), [new] "r"(new)
+		: "memory", "cc");
+	return ret;
+}
+
+extern unsigned long __cmpxchg_u64_unsupported_on_32bit_kernels(
+        volatile int * m, unsigned long old, unsigned long new);
+#define __cmpxchg_u64 __cmpxchg_u64_unsupported_on_32bit_kernels
+
+/* This function doesn't exist, so you'll get a linker error
+   if something tries to do an invalid cmpxchg().  */
+extern void __cmpxchg_called_with_bad_pointer(void);
+
+#define __HAVE_ARCH_CMPXCHG 1
+
+static inline unsigned long __cmpxchg(volatile void *ptr, unsigned long old,
+				      unsigned long new, int size)
+{
+	switch (size) {
+	case 4:
+		return __cmpxchg_u32(ptr, old, new);
+	case 8:
+		return __cmpxchg_u64(ptr, old, new);
+	}
+
+	__cmpxchg_called_with_bad_pointer();
+	return old;
+}
+
+#define cmpxchg(ptr, old, new)					\
+	((typeof(*(ptr)))__cmpxchg((ptr), (unsigned long)(old),	\
+				   (unsigned long)(new),	\
+				   sizeof(*(ptr))))
+
+#include <asm-generic/cmpxchg-local.h>
+
+static inline unsigned long __cmpxchg_local(volatile void *ptr,
+				      unsigned long old,
+				      unsigned long new, int size)
+{
+	switch (size) {
+	case 4:
+		return __cmpxchg_u32(ptr, old, new);
+	default:
+		return __cmpxchg_local_generic(ptr, old, new, size);
+	}
+
+	return old;
+}
+
+#define cmpxchg_local(ptr, old, new)					\
+	((typeof(*(ptr)))__cmpxchg_local((ptr), (unsigned long)(old),	\
+				   (unsigned long)(new),		\
+				   sizeof(*(ptr))))
+
+#define cmpxchg64_local(ptr, o, n) __cmpxchg64_local_generic((ptr), (o), (n))
+
+#endif /* __ASM_AVR32_CMPXCHG_H */
diff --git a/arch/avr32/include/asm/exec.h b/arch/avr32/include/asm/exec.h
new file mode 100644
index 0000000..f467be8
--- /dev/null
+++ b/arch/avr32/include/asm/exec.h
@@ -0,0 +1,13 @@
+/*
+ * Copyright (C) 2004-2006 Atmel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __ASM_AVR32_EXEC_H
+#define __ASM_AVR32_EXEC_H
+
+#define arch_align_stack(x)	(x)
+
+#endif /* __ASM_AVR32_EXEC_H */
diff --git a/arch/avr32/include/asm/special_insns.h b/arch/avr32/include/asm/special_insns.h
new file mode 100644
index 0000000..f922218
--- /dev/null
+++ b/arch/avr32/include/asm/special_insns.h
@@ -0,0 +1,13 @@
+/*
+ * Copyright (C) 2004-2006 Atmel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __ASM_AVR32_SPECIAL_INSNS_H
+#define __ASM_AVR32_SPECIAL_INSNS_H
+
+#define nop() asm volatile("nop")
+
+#endif /* __ASM_AVR32_SPECIAL_INSNS_H */
diff --git a/arch/avr32/include/asm/switch_to.h b/arch/avr32/include/asm/switch_to.h
new file mode 100644
index 0000000..9a8e9d5
--- /dev/null
+++ b/arch/avr32/include/asm/switch_to.h
@@ -0,0 +1,46 @@
+/*
+ * Copyright (C) 2004-2006 Atmel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __ASM_AVR32_SWITCH_TO_H
+#define __ASM_AVR32_SWITCH_TO_H
+
+/*
+ * Help PathFinder and other Nexus-compliant debuggers keep track of
+ * the current PID by emitting an Ownership Trace Message each time we
+ * switch task.
+ */
+#ifdef CONFIG_OWNERSHIP_TRACE
+#include <asm/ocd.h>
+#define finish_arch_switch(prev)			\
+	do {						\
+		ocd_write(PID, prev->pid);		\
+		ocd_write(PID, current->pid);		\
+	} while(0)
+#endif
+
+/*
+ * switch_to(prev, next, last) should switch from task `prev' to task
+ * `next'. `prev' will never be the same as `next'.
+ *
+ * We just delegate everything to the __switch_to assembly function,
+ * which is implemented in arch/avr32/kernel/switch_to.S
+ *
+ * mb() tells GCC not to cache `current' across this call.
+ */
+struct cpu_context;
+struct task_struct;
+extern struct task_struct *__switch_to(struct task_struct *,
+				       struct cpu_context *,
+				       struct cpu_context *);
+#define switch_to(prev, next, last)					\
+	do {								\
+		last = __switch_to(prev, &prev->thread.cpu_context + 1,	\
+				   &next->thread.cpu_context);		\
+	} while (0)
+
+
+#endif /* __ASM_AVR32_SWITCH_TO_H */
diff --git a/arch/avr32/include/asm/system.h b/arch/avr32/include/asm/system.h
index 62d9ded..0d84f9e 100644
--- a/arch/avr32/include/asm/system.h
+++ b/arch/avr32/include/asm/system.h
@@ -1,178 +1,6 @@
-/*
- * Copyright (C) 2004-2006 Atmel Corporation
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-#ifndef __ASM_AVR32_SYSTEM_H
-#define __ASM_AVR32_SYSTEM_H
-
-#include <linux/compiler.h>
-#include <linux/linkage.h>
-#include <linux/types.h>
-
-#include <asm/ptrace.h>
-#include <asm/sysreg.h>
-
-#define xchg(ptr,x) \
-	((__typeof__(*(ptr)))__xchg((unsigned long)(x),(ptr),sizeof(*(ptr))))
-
-#define nop() asm volatile("nop")
-
-#define mb()			asm volatile("" : : : "memory")
-#define rmb()			mb()
-#define wmb()			asm volatile("sync 0" : : : "memory")
-#define read_barrier_depends()  do { } while(0)
-#define set_mb(var, value)      do { var = value; mb(); } while(0)
-
-/*
- * Help PathFinder and other Nexus-compliant debuggers keep track of
- * the current PID by emitting an Ownership Trace Message each time we
- * switch task.
- */
-#ifdef CONFIG_OWNERSHIP_TRACE
-#include <asm/ocd.h>
-#define finish_arch_switch(prev)			\
-	do {						\
-		ocd_write(PID, prev->pid);		\
-		ocd_write(PID, current->pid);		\
-	} while(0)
-#endif
-
-/*
- * switch_to(prev, next, last) should switch from task `prev' to task
- * `next'. `prev' will never be the same as `next'.
- *
- * We just delegate everything to the __switch_to assembly function,
- * which is implemented in arch/avr32/kernel/switch_to.S
- *
- * mb() tells GCC not to cache `current' across this call.
- */
-struct cpu_context;
-struct task_struct;
-extern struct task_struct *__switch_to(struct task_struct *,
-				       struct cpu_context *,
-				       struct cpu_context *);
-#define switch_to(prev, next, last)					\
-	do {								\
-		last = __switch_to(prev, &prev->thread.cpu_context + 1,	\
-				   &next->thread.cpu_context);		\
-	} while (0)
-
-#ifdef CONFIG_SMP
-# error "The AVR32 port does not support SMP"
-#else
-# define smp_mb()		barrier()
-# define smp_rmb()		barrier()
-# define smp_wmb()		barrier()
-# define smp_read_barrier_depends() do { } while(0)
-#endif
-
-#include <linux/irqflags.h>
-
-extern void __xchg_called_with_bad_pointer(void);
-
-static inline unsigned long xchg_u32(u32 val, volatile u32 *m)
-{
-	u32 ret;
-
-	asm volatile("xchg %[ret], %[m], %[val]"
-			: [ret] "=&r"(ret), "=m"(*m)
-			: "m"(*m), [m] "r"(m), [val] "r"(val)
-			: "memory");
-	return ret;
-}
-
-static inline unsigned long __xchg(unsigned long x,
-				       volatile void *ptr,
-				       int size)
-{
-	switch(size) {
-	case 4:
-		return xchg_u32(x, ptr);
-	default:
-		__xchg_called_with_bad_pointer();
-		return x;
-	}
-}
-
-static inline unsigned long __cmpxchg_u32(volatile int *m, unsigned long old,
-					  unsigned long new)
-{
-	__u32 ret;
-
-	asm volatile(
-		"1:	ssrf	5\n"
-		"	ld.w	%[ret], %[m]\n"
-		"	cp.w	%[ret], %[old]\n"
-		"	brne	2f\n"
-		"	stcond	%[m], %[new]\n"
-		"	brne	1b\n"
-		"2:\n"
-		: [ret] "=&r"(ret), [m] "=m"(*m)
-		: "m"(m), [old] "ir"(old), [new] "r"(new)
-		: "memory", "cc");
-	return ret;
-}
-
-extern unsigned long __cmpxchg_u64_unsupported_on_32bit_kernels(
-        volatile int * m, unsigned long old, unsigned long new);
-#define __cmpxchg_u64 __cmpxchg_u64_unsupported_on_32bit_kernels
-
-/* This function doesn't exist, so you'll get a linker error
-   if something tries to do an invalid cmpxchg().  */
-extern void __cmpxchg_called_with_bad_pointer(void);
-
-#define __HAVE_ARCH_CMPXCHG 1
-
-static inline unsigned long __cmpxchg(volatile void *ptr, unsigned long old,
-				      unsigned long new, int size)
-{
-	switch (size) {
-	case 4:
-		return __cmpxchg_u32(ptr, old, new);
-	case 8:
-		return __cmpxchg_u64(ptr, old, new);
-	}
-
-	__cmpxchg_called_with_bad_pointer();
-	return old;
-}
-
-#define cmpxchg(ptr, old, new)					\
-	((typeof(*(ptr)))__cmpxchg((ptr), (unsigned long)(old),	\
-				   (unsigned long)(new),	\
-				   sizeof(*(ptr))))
-
-#include <asm-generic/cmpxchg-local.h>
-
-static inline unsigned long __cmpxchg_local(volatile void *ptr,
-				      unsigned long old,
-				      unsigned long new, int size)
-{
-	switch (size) {
-	case 4:
-		return __cmpxchg_u32(ptr, old, new);
-	default:
-		return __cmpxchg_local_generic(ptr, old, new, size);
-	}
-
-	return old;
-}
-
-#define cmpxchg_local(ptr, old, new)					\
-	((typeof(*(ptr)))__cmpxchg_local((ptr), (unsigned long)(old),	\
-				   (unsigned long)(new),		\
-				   sizeof(*(ptr))))
-
-#define cmpxchg64_local(ptr, o, n) __cmpxchg64_local_generic((ptr), (o), (n))
-
-struct pt_regs;
-void die(const char *str, struct pt_regs *regs, long err);
-void _exception(long signr, struct pt_regs *regs, int code,
-		unsigned long addr);
-
-#define arch_align_stack(x)	(x)
-
-#endif /* __ASM_AVR32_SYSTEM_H */
+/* FILE TO BE DELETED. DO NOT ADD STUFF HERE! */
+#include <asm/barrier.h>
+#include <asm/cmpxchg.h>
+#include <asm/exec.h>
+#include <asm/special_insns.h>
+#include <asm/switch_to.h>
diff --git a/arch/avr32/mach-at32ap/cpufreq.c b/arch/avr32/mach-at32ap/cpufreq.c
index 6277433..18b7656 100644
--- a/arch/avr32/mach-at32ap/cpufreq.c
+++ b/arch/avr32/mach-at32ap/cpufreq.c
@@ -19,7 +19,6 @@
 #include <linux/clk.h>
 #include <linux/err.h>
 #include <linux/export.h>
-#include <asm/system.h>
 
 static struct clk *cpuclk;
 
diff --git a/arch/avr32/oprofile/op_model_avr32.c b/arch/avr32/oprofile/op_model_avr32.c
index a3e9b3c..f74b780 100644
--- a/arch/avr32/oprofile/op_model_avr32.c
+++ b/arch/avr32/oprofile/op_model_avr32.c
@@ -17,7 +17,6 @@
 #include <linux/types.h>
 
 #include <asm/sysreg.h>
-#include <asm/system.h>
 
 #define AVR32_PERFCTR_IRQ_GROUP	0
 #define AVR32_PERFCTR_IRQ_LINE	1

