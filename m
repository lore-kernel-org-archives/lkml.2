Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760060Ab2CGTsA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 14:48:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23441 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760005Ab2CGTrx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 14:47:53 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 08/29] Disintegrate asm/system.h for C6X
To: paul.gortmaker@windriver.com, hpa@zytor.com
Cc: torvalds@linux-foundation.org, sfr@canb.auug.org.au, mingo@redhat.com,
        arnd@arndb.de, dhowells@redhat.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Date: Wed, 07 Mar 2012 19:47:25 +0000
Message-ID: <20120307194725.15987.99209.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120307194548.15987.36073.stgit@warthog.procyon.org.uk>
References: <20120307194548.15987.36073.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disintegrate asm/system.h for C6X.  Not compiled.  Appears to be missing
asm/atomic.h and asm/bug.h.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/c6x/include/asm/atomic.h        |   68 ++++++++++++++
 arch/c6x/include/asm/barrier.h       |   25 +++++
 arch/c6x/include/asm/bug.h           |   19 ++++
 arch/c6x/include/asm/processor.h     |    9 ++
 arch/c6x/include/asm/setup.h         |    1 
 arch/c6x/include/asm/special_insns.h |   64 +++++++++++++
 arch/c6x/include/asm/switch_to.h     |   31 ++++++
 arch/c6x/include/asm/system.h        |  167 ----------------------------------
 8 files changed, 217 insertions(+), 167 deletions(-)
 create mode 100644 arch/c6x/include/asm/atomic.h
 create mode 100644 arch/c6x/include/asm/barrier.h
 create mode 100644 arch/c6x/include/asm/bug.h
 create mode 100644 arch/c6x/include/asm/special_insns.h
 create mode 100644 arch/c6x/include/asm/switch_to.h
 delete mode 100644 arch/c6x/include/asm/system.h

diff --git a/arch/c6x/include/asm/atomic.h b/arch/c6x/include/asm/atomic.h
new file mode 100644
index 0000000..510d46f
--- /dev/null
+++ b/arch/c6x/include/asm/atomic.h
@@ -0,0 +1,68 @@
+/*
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2004, 2009, 2010, 2011 Texas Instruments Incorporated
+ *  Author: Aurelien Jacquiot (aurelien.jacquiot@jaluna.com)
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#ifndef _ASM_C6X_ATOMIC_H
+#define _ASM_C6X_ATOMIC_H
+
+#include <linux/irqflags.h>
+
+/*
+ * Misc. functions
+ */
+static inline unsigned int __xchg(unsigned int x, volatile void *ptr, int size)
+{
+	unsigned int tmp;
+	unsigned long flags;
+
+	local_irq_save(flags);
+
+	switch (size) {
+	case 1:
+		tmp = 0;
+		tmp = *((unsigned char *) ptr);
+		*((unsigned char *) ptr) = (unsigned char) x;
+		break;
+	case 2:
+		tmp = 0;
+		tmp = *((unsigned short *) ptr);
+		*((unsigned short *) ptr) = x;
+		break;
+	case 4:
+		tmp = 0;
+		tmp = *((unsigned int *) ptr);
+		*((unsigned int *) ptr) = x;
+		break;
+	}
+	local_irq_restore(flags);
+	return tmp;
+}
+
+#define xchg(ptr, x) \
+	((__typeof__(*(ptr)))__xchg((unsigned int)(x), (void *) (ptr), \
+				    sizeof(*(ptr))))
+#define tas(ptr)    xchg((ptr), 1)
+
+
+#include <asm-generic/cmpxchg-local.h>
+
+/*
+ * cmpxchg_local and cmpxchg64_local are atomic wrt current CPU. Always make
+ * them available.
+ */
+#define cmpxchg_local(ptr, o, n)					\
+	((__typeof__(*(ptr)))__cmpxchg_local_generic((ptr),		\
+						     (unsigned long)(o), \
+						     (unsigned long)(n), \
+						     sizeof(*(ptr))))
+#define cmpxchg64_local(ptr, o, n) __cmpxchg64_local_generic((ptr), (o), (n))
+
+#include <asm-generic/cmpxchg.h>
+
+#endif /* _ASM_C6X_ATOMIC_H */
diff --git a/arch/c6x/include/asm/barrier.h b/arch/c6x/include/asm/barrier.h
new file mode 100644
index 0000000..a845709
--- /dev/null
+++ b/arch/c6x/include/asm/barrier.h
@@ -0,0 +1,25 @@
+/*
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2004, 2009, 2010, 2011 Texas Instruments Incorporated
+ *  Author: Aurelien Jacquiot (aurelien.jacquiot@jaluna.com)
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#ifndef _ASM_C6X_BARRIER_H
+#define _ASM_C6X_BARRIER_H
+
+#define mb()                     barrier()
+#define rmb()                    barrier()
+#define wmb()                    barrier()
+#define set_mb(var, value)       do { var = value;  mb(); } while (0)
+#define set_wmb(var, value)      do { var = value; wmb(); } while (0)
+
+#define smp_mb()	         barrier()
+#define smp_rmb()	         barrier()
+#define smp_wmb()	         barrier()
+#define smp_read_barrier_depends()	do { } while (0)
+
+#endif /* _ASM_C6X_BARRIER_H */
diff --git a/arch/c6x/include/asm/bug.h b/arch/c6x/include/asm/bug.h
new file mode 100644
index 0000000..db6c7d5
--- /dev/null
+++ b/arch/c6x/include/asm/bug.h
@@ -0,0 +1,19 @@
+/*
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2004, 2009, 2010, 2011 Texas Instruments Incorporated
+ *  Author: Aurelien Jacquiot (aurelien.jacquiot@jaluna.com)
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#ifndef _ASM_C6X_BUG_H
+#define _ASM_C6X_BUG_H
+
+struct pt_regs;
+
+extern void die(char *str, struct pt_regs *fp, int nr);
+extern asmlinkage int process_exception(struct pt_regs *regs);
+
+#endif /* _ASM_C6X_BUG_H */
diff --git a/arch/c6x/include/asm/processor.h b/arch/c6x/include/asm/processor.h
index 8154c4e..c4f1c04 100644
--- a/arch/c6x/include/asm/processor.h
+++ b/arch/c6x/include/asm/processor.h
@@ -129,4 +129,13 @@ extern unsigned long get_wchan(struct task_struct *p);
 
 extern const struct seq_operations cpuinfo_op;
 
+/* Reset the board */
+#define HARD_RESET_NOW()
+
+extern unsigned int c6x_core_freq;
+
+
+extern void (*c6x_restart)(void);
+extern void (*c6x_halt)(void);
+
 #endif /* ASM_C6X_PROCESSOR_H */
diff --git a/arch/c6x/include/asm/setup.h b/arch/c6x/include/asm/setup.h
index 1808f27..a01e318 100644
--- a/arch/c6x/include/asm/setup.h
+++ b/arch/c6x/include/asm/setup.h
@@ -27,6 +27,7 @@ extern unsigned int c6x_devstat;
 extern unsigned char c6x_fuse_mac[6];
 
 extern void machine_init(unsigned long dt_ptr);
+extern void time_init(void);
 
 #endif /* !__ASSEMBLY__ */
 #endif /* _ASM_C6X_SETUP_H */
diff --git a/arch/c6x/include/asm/special_insns.h b/arch/c6x/include/asm/special_insns.h
new file mode 100644
index 0000000..3be40df
--- /dev/null
+++ b/arch/c6x/include/asm/special_insns.h
@@ -0,0 +1,64 @@
+/*
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2004, 2009, 2010, 2011 Texas Instruments Incorporated
+ *  Author: Aurelien Jacquiot (aurelien.jacquiot@jaluna.com)
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#ifndef _ASM_C6X_SPECIAL_INSNS_H
+#define _ASM_C6X_SPECIAL_INSNS_H
+
+
+#define get_creg(reg) \
+	({ unsigned int __x; \
+	   asm volatile ("mvc .s2 " #reg ",%0\n" : "=b"(__x)); __x; })
+
+#define set_creg(reg, v) \
+	do { unsigned int __x = (unsigned int)(v); \
+		asm volatile ("mvc .s2 %0," #reg "\n" : : "b"(__x)); \
+	} while (0)
+
+#define or_creg(reg, n) \
+	do { unsigned __x, __n = (unsigned)(n);		  \
+		asm volatile ("mvc .s2 " #reg ",%0\n"	  \
+			      "or  .l2 %1,%0,%0\n"	  \
+			      "mvc .s2 %0," #reg "\n"	  \
+			      "nop\n"			  \
+			      : "=&b"(__x) : "b"(__n));	  \
+	} while (0)
+
+#define and_creg(reg, n) \
+	do { unsigned __x, __n = (unsigned)(n);		  \
+		asm volatile ("mvc .s2 " #reg ",%0\n"	  \
+			      "and .l2 %1,%0,%0\n"	  \
+			      "mvc .s2 %0," #reg "\n"	  \
+			      "nop\n"    \
+			      : "=&b"(__x) : "b"(__n));	  \
+	} while (0)
+
+#define get_coreid() (get_creg(DNUM) & 0xff)
+
+/* Set/get IST */
+#define set_ist(x)	set_creg(ISTP, x)
+#define get_ist()       get_creg(ISTP)
+
+/*
+ * Exception management
+ */
+asmlinkage void enable_exception(void);
+#define disable_exception()
+#define get_except_type()        get_creg(EFR)
+#define ack_exception(type)      set_creg(ECR, 1 << (type))
+#define get_iexcept()            get_creg(IERR)
+#define set_iexcept(mask)        set_creg(IERR, (mask))
+
+#define _extu(x, s, e)							\
+	({      unsigned int __x;					\
+		asm volatile ("extu .S2 %3,%1,%2,%0\n" :		\
+			      "=b"(__x) : "n"(s), "n"(e), "b"(x));	\
+	       __x; })
+
+#endif /* _ASM_C6X_SPECIAL_INSNS_H */
diff --git a/arch/c6x/include/asm/switch_to.h b/arch/c6x/include/asm/switch_to.h
new file mode 100644
index 0000000..83bb5a4
--- /dev/null
+++ b/arch/c6x/include/asm/switch_to.h
@@ -0,0 +1,31 @@
+/*
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2004, 2009, 2010, 2011 Texas Instruments Incorporated
+ *  Author: Aurelien Jacquiot (aurelien.jacquiot@jaluna.com)
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#ifndef _ASM_C6X_SWITCH_TO_H
+#define _ASM_C6X_SWITCH_TO_H
+
+#define prepare_to_switch()    do { } while (0)
+
+struct task_struct;
+struct thread_struct;
+asmlinkage void *__switch_to(struct thread_struct *prev,
+			     struct thread_struct *next,
+			     struct task_struct *tsk);
+
+#define switch_to(prev, next, last)				\
+	do {							\
+		current->thread.wchan = (u_long) __builtin_return_address(0); \
+		(last) = __switch_to(&(prev)->thread,		\
+				     &(next)->thread, (prev));	\
+		mb();						\
+		current->thread.wchan = 0;			\
+	} while (0)
+
+#endif /* _ASM_C6X_SWITCH_TO_H */
diff --git a/arch/c6x/include/asm/system.h b/arch/c6x/include/asm/system.h
deleted file mode 100644
index 7b1cfa9..0000000
--- a/arch/c6x/include/asm/system.h
+++ /dev/null
@@ -1,167 +0,0 @@
-/*
- *  Port on Texas Instruments TMS320C6x architecture
- *
- *  Copyright (C) 2004, 2009, 2010, 2011 Texas Instruments Incorporated
- *  Author: Aurelien Jacquiot (aurelien.jacquiot@jaluna.com)
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License version 2 as
- *  published by the Free Software Foundation.
- */
-#ifndef _ASM_C6X_SYSTEM_H
-#define _ASM_C6X_SYSTEM_H
-
-#include <linux/linkage.h>
-#include <linux/irqflags.h>
-
-#define prepare_to_switch()    do { } while (0)
-
-struct task_struct;
-struct thread_struct;
-asmlinkage void *__switch_to(struct thread_struct *prev,
-			     struct thread_struct *next,
-			     struct task_struct *tsk);
-
-#define switch_to(prev, next, last)				\
-	do {							\
-		current->thread.wchan = (u_long) __builtin_return_address(0); \
-		(last) = __switch_to(&(prev)->thread,		\
-				     &(next)->thread, (prev));	\
-		mb();						\
-		current->thread.wchan = 0;			\
-	} while (0)
-
-/* Reset the board */
-#define HARD_RESET_NOW()
-
-#define get_creg(reg) \
-	({ unsigned int __x; \
-	   asm volatile ("mvc .s2 " #reg ",%0\n" : "=b"(__x)); __x; })
-
-#define set_creg(reg, v) \
-	do { unsigned int __x = (unsigned int)(v); \
-		asm volatile ("mvc .s2 %0," #reg "\n" : : "b"(__x)); \
-	} while (0)
-
-#define or_creg(reg, n) \
-	do { unsigned __x, __n = (unsigned)(n);		  \
-		asm volatile ("mvc .s2 " #reg ",%0\n"	  \
-			      "or  .l2 %1,%0,%0\n"	  \
-			      "mvc .s2 %0," #reg "\n"	  \
-			      "nop\n"			  \
-			      : "=&b"(__x) : "b"(__n));	  \
-	} while (0)
-
-#define and_creg(reg, n) \
-	do { unsigned __x, __n = (unsigned)(n);		  \
-		asm volatile ("mvc .s2 " #reg ",%0\n"	  \
-			      "and .l2 %1,%0,%0\n"	  \
-			      "mvc .s2 %0," #reg "\n"	  \
-			      "nop\n"    \
-			      : "=&b"(__x) : "b"(__n));	  \
-	} while (0)
-
-#define get_coreid() (get_creg(DNUM) & 0xff)
-
-/* Set/get IST */
-#define set_ist(x)	set_creg(ISTP, x)
-#define get_ist()       get_creg(ISTP)
-
-/*
- * Exception management
- */
-asmlinkage void enable_exception(void);
-#define disable_exception()
-#define get_except_type()        get_creg(EFR)
-#define ack_exception(type)      set_creg(ECR, 1 << (type))
-#define get_iexcept()            get_creg(IERR)
-#define set_iexcept(mask)        set_creg(IERR, (mask))
-
-/*
- * Misc. functions
- */
-#define nop()                    asm("NOP\n");
-#define mb()                     barrier()
-#define rmb()                    barrier()
-#define wmb()                    barrier()
-#define set_mb(var, value)       do { var = value;  mb(); } while (0)
-#define set_wmb(var, value)      do { var = value; wmb(); } while (0)
-
-#define smp_mb()	         barrier()
-#define smp_rmb()	         barrier()
-#define smp_wmb()	         barrier()
-#define smp_read_barrier_depends()	do { } while (0)
-
-#define xchg(ptr, x) \
-	((__typeof__(*(ptr)))__xchg((unsigned int)(x), (void *) (ptr), \
-				    sizeof(*(ptr))))
-#define tas(ptr)    xchg((ptr), 1)
-
-unsigned int _lmbd(unsigned int, unsigned int);
-unsigned int _bitr(unsigned int);
-
-struct __xchg_dummy { unsigned int a[100]; };
-#define __xg(x) ((volatile struct __xchg_dummy *)(x))
-
-static inline unsigned int __xchg(unsigned int x, volatile void *ptr, int size)
-{
-	unsigned int tmp;
-	unsigned long flags;
-
-	local_irq_save(flags);
-
-	switch (size) {
-	case 1:
-		tmp = 0;
-		tmp = *((unsigned char *) ptr);
-		*((unsigned char *) ptr) = (unsigned char) x;
-		break;
-	case 2:
-		tmp = 0;
-		tmp = *((unsigned short *) ptr);
-		*((unsigned short *) ptr) = x;
-		break;
-	case 4:
-		tmp = 0;
-		tmp = *((unsigned int *) ptr);
-		*((unsigned int *) ptr) = x;
-		break;
-	}
-	local_irq_restore(flags);
-	return tmp;
-}
-
-#include <asm-generic/cmpxchg-local.h>
-
-/*
- * cmpxchg_local and cmpxchg64_local are atomic wrt current CPU. Always make
- * them available.
- */
-#define cmpxchg_local(ptr, o, n)					\
-	((__typeof__(*(ptr)))__cmpxchg_local_generic((ptr),		\
-						     (unsigned long)(o), \
-						     (unsigned long)(n), \
-						     sizeof(*(ptr))))
-#define cmpxchg64_local(ptr, o, n) __cmpxchg64_local_generic((ptr), (o), (n))
-
-#include <asm-generic/cmpxchg.h>
-
-#define _extu(x, s, e)							\
-	({      unsigned int __x;					\
-		asm volatile ("extu .S2 %3,%1,%2,%0\n" :		\
-			      "=b"(__x) : "n"(s), "n"(e), "b"(x));	\
-	       __x; })
-
-
-extern unsigned int c6x_core_freq;
-
-struct pt_regs;
-
-extern void die(char *str, struct pt_regs *fp, int nr);
-extern asmlinkage int process_exception(struct pt_regs *regs);
-extern void time_init(void);
-
-extern void (*c6x_restart)(void);
-extern void (*c6x_halt)(void);
-
-#endif /* _ASM_C6X_SYSTEM_H */

