Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032303Ab2COU4y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 16:56:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31937 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161586Ab2COU4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 16:56:47 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 09/38] Disintegrate asm/system.h for C6X [ver #3]
To: paul.gortmaker@windriver.com
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, arnd@arndb.de,
        David Howells <dhowells@redhat.com>, linux-c6x-dev@linux-c6x.org
Date: Thu, 15 Mar 2012 20:56:38 +0000
Message-ID: <20120315205638.28759.76347.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120315205514.28759.58969.stgit@warthog.procyon.org.uk>
References: <20120315205514.28759.58969.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disintegrate asm/system.h for C6X.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: linux-c6x-dev@linux-c6x.org
---

 arch/c6x/include/asm/Kbuild          |    1 
 arch/c6x/include/asm/barrier.h       |   27 +++++
 arch/c6x/include/asm/bitops.h        |    1 
 arch/c6x/include/asm/bug.h           |   23 +++++
 arch/c6x/include/asm/cmpxchg.h       |   68 +++++++++++++
 arch/c6x/include/asm/exec.h          |    6 +
 arch/c6x/include/asm/processor.h     |    9 ++
 arch/c6x/include/asm/setup.h         |    1 
 arch/c6x/include/asm/special_insns.h |   63 ++++++++++++
 arch/c6x/include/asm/switch_to.h     |   33 ++++++
 arch/c6x/include/asm/system.h        |  173 +---------------------------------
 arch/c6x/kernel/irq.c                |    1 
 arch/c6x/kernel/setup.c              |    1 
 arch/c6x/kernel/soc.c                |    1 
 arch/c6x/kernel/time.c               |    1 
 arch/c6x/kernel/traps.c              |    1 
 arch/c6x/platforms/timer64.c         |    1 
 17 files changed, 241 insertions(+), 170 deletions(-)
 create mode 100644 arch/c6x/include/asm/barrier.h
 create mode 100644 arch/c6x/include/asm/bug.h
 create mode 100644 arch/c6x/include/asm/cmpxchg.h
 create mode 100644 arch/c6x/include/asm/exec.h
 create mode 100644 arch/c6x/include/asm/special_insns.h
 create mode 100644 arch/c6x/include/asm/switch_to.h

diff --git a/arch/c6x/include/asm/Kbuild b/arch/c6x/include/asm/Kbuild
index 13dcf78..3af601e 100644
--- a/arch/c6x/include/asm/Kbuild
+++ b/arch/c6x/include/asm/Kbuild
@@ -3,7 +3,6 @@ include include/asm-generic/Kbuild.asm
 generic-y += atomic.h
 generic-y += auxvec.h
 generic-y += bitsperlong.h
-generic-y += bug.h
 generic-y += bugs.h
 generic-y += cputime.h
 generic-y += current.h
diff --git a/arch/c6x/include/asm/barrier.h b/arch/c6x/include/asm/barrier.h
new file mode 100644
index 0000000..538240e
--- /dev/null
+++ b/arch/c6x/include/asm/barrier.h
@@ -0,0 +1,27 @@
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
+#define nop()                    asm("NOP\n");
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
diff --git a/arch/c6x/include/asm/bitops.h b/arch/c6x/include/asm/bitops.h
index 39ab7e8..0bec7e5 100644
--- a/arch/c6x/include/asm/bitops.h
+++ b/arch/c6x/include/asm/bitops.h
@@ -15,7 +15,6 @@
 
 #include <linux/bitops.h>
 
-#include <asm/system.h>
 #include <asm/byteorder.h>
 
 /*
diff --git a/arch/c6x/include/asm/bug.h b/arch/c6x/include/asm/bug.h
new file mode 100644
index 0000000..8d59933
--- /dev/null
+++ b/arch/c6x/include/asm/bug.h
@@ -0,0 +1,23 @@
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
+#include <linux/linkage.h>
+#include <asm-generic/bug.h>
+
+struct pt_regs;
+
+extern void die(char *str, struct pt_regs *fp, int nr);
+extern asmlinkage int process_exception(struct pt_regs *regs);
+extern asmlinkage void enable_exception(void);
+
+#endif /* _ASM_C6X_BUG_H */
diff --git a/arch/c6x/include/asm/cmpxchg.h b/arch/c6x/include/asm/cmpxchg.h
new file mode 100644
index 0000000..b27c8ce
--- /dev/null
+++ b/arch/c6x/include/asm/cmpxchg.h
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
+#ifndef _ASM_C6X_CMPXCHG_H
+#define _ASM_C6X_CMPXCHG_H
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
+#endif /* _ASM_C6X_CMPXCHG_H */
diff --git a/arch/c6x/include/asm/exec.h b/arch/c6x/include/asm/exec.h
new file mode 100644
index 0000000..0fea482
--- /dev/null
+++ b/arch/c6x/include/asm/exec.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_C6X_EXEC_H
+#define _ASM_C6X_EXEC_H
+
+#define arch_align_stack(x) (x)
+
+#endif /* _ASM_C6X_EXEC_H */
diff --git a/arch/c6x/include/asm/processor.h b/arch/c6x/include/asm/processor.h
index 77ecbde..3ff7fab 100644
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
index 0000000..59672bc
--- /dev/null
+++ b/arch/c6x/include/asm/special_insns.h
@@ -0,0 +1,63 @@
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
index 0000000..af6c71f
--- /dev/null
+++ b/arch/c6x/include/asm/switch_to.h
@@ -0,0 +1,33 @@
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
+#include <linux/linkage.h>
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
index e076dc0..ccc4f86 100644
--- a/arch/c6x/include/asm/system.h
+++ b/arch/c6x/include/asm/system.h
@@ -1,168 +1,7 @@
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
+/* FILE TO BE DELETED. DO NOT ADD STUFF HERE! */
+#include <asm/barrier.h>
+#include <asm/cmpxchg.h>
+#include <asm/exec.h>
+#include <asm/special_insns.h>
+#include <asm/switch_to.h>
 extern void free_initmem(void);
-
-extern void (*c6x_restart)(void);
-extern void (*c6x_halt)(void);
-
-#endif /* _ASM_C6X_SYSTEM_H */
diff --git a/arch/c6x/kernel/irq.c b/arch/c6x/kernel/irq.c
index 0929e4b..f8a5af2 100644
--- a/arch/c6x/kernel/irq.c
+++ b/arch/c6x/kernel/irq.c
@@ -27,6 +27,7 @@
 #include <linux/kernel_stat.h>
 
 #include <asm/megamod-pic.h>
+#include <asm/special_insns.h>
 
 unsigned long irq_err_count;
 
diff --git a/arch/c6x/kernel/setup.c b/arch/c6x/kernel/setup.c
index 0c07921..ce46186 100644
--- a/arch/c6x/kernel/setup.c
+++ b/arch/c6x/kernel/setup.c
@@ -34,6 +34,7 @@
 #include <asm/dscr.h>
 #include <asm/clock.h>
 #include <asm/soc.h>
+#include <asm/special_insns.h>
 
 static const char *c6x_soc_name;
 
diff --git a/arch/c6x/kernel/soc.c b/arch/c6x/kernel/soc.c
index dd45bc3..0748c94 100644
--- a/arch/c6x/kernel/soc.c
+++ b/arch/c6x/kernel/soc.c
@@ -11,7 +11,6 @@
 #include <linux/module.h>
 #include <linux/ctype.h>
 #include <linux/etherdevice.h>
-#include <asm/system.h>
 #include <asm/setup.h>
 #include <asm/soc.h>
 
diff --git a/arch/c6x/kernel/time.c b/arch/c6x/kernel/time.c
index 4c9f136..356ee84 100644
--- a/arch/c6x/kernel/time.c
+++ b/arch/c6x/kernel/time.c
@@ -20,6 +20,7 @@
 #include <linux/timex.h>
 #include <linux/profile.h>
 
+#include <asm/special_insns.h>
 #include <asm/timer64.h>
 
 static u32 sched_clock_multiplier;
diff --git a/arch/c6x/kernel/traps.c b/arch/c6x/kernel/traps.c
index f50e3ed..1be74e5 100644
--- a/arch/c6x/kernel/traps.c
+++ b/arch/c6x/kernel/traps.c
@@ -14,6 +14,7 @@
 #include <linux/bug.h>
 
 #include <asm/soc.h>
+#include <asm/special_insns.h>
 #include <asm/traps.h>
 
 int (*c6x_nmi_handler)(struct pt_regs *regs);
diff --git a/arch/c6x/platforms/timer64.c b/arch/c6x/platforms/timer64.c
index 03c03c2..3c73d74 100644
--- a/arch/c6x/platforms/timer64.c
+++ b/arch/c6x/platforms/timer64.c
@@ -15,6 +15,7 @@
 #include <linux/of_address.h>
 #include <asm/soc.h>
 #include <asm/dscr.h>
+#include <asm/special_insns.h>
 #include <asm/timer64.h>
 
 struct timer_regs {

