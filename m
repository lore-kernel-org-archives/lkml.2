Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030485Ab2CGTuh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 14:50:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43380 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030431Ab2CGTuZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 14:50:25 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 22/29] Disintegrate asm/system.h for S390
To: paul.gortmaker@windriver.com, hpa@zytor.com
Cc: torvalds@linux-foundation.org, sfr@canb.auug.org.au, mingo@redhat.com,
        arnd@arndb.de, dhowells@redhat.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Date: Wed, 07 Mar 2012 19:50:01 +0000
Message-ID: <20120307195001.15987.31240.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120307194548.15987.36073.stgit@warthog.procyon.org.uk>
References: <20120307194548.15987.36073.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disintegrate asm/system.h for S390.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/s390/crypto/crypt_s390.h       |    1 
 arch/s390/include/asm/atomic.h      |    1 
 arch/s390/include/asm/barrier.h     |   35 ++++
 arch/s390/include/asm/ctl_reg.h     |   76 +++++++++
 arch/s390/include/asm/elf.h         |    1 
 arch/s390/include/asm/exec.h        |   12 +
 arch/s390/include/asm/facility.h    |   29 ++++
 arch/s390/include/asm/mmu.h         |   14 ++
 arch/s390/include/asm/mmu_context.h |    1 
 arch/s390/include/asm/processor.h   |   16 ++
 arch/s390/include/asm/setup.h       |   14 ++
 arch/s390/include/asm/sigp.h        |    8 +
 arch/s390/include/asm/switch_to.h   |  100 ++++++++++++
 arch/s390/include/asm/system.h      |  281 -----------------------------------
 arch/s390/include/asm/uaccess.h     |    6 +
 arch/s390/kernel/compat_signal.c    |    1 
 arch/s390/kernel/early.c            |    1 
 arch/s390/kernel/process.c          |    1 
 arch/s390/kernel/ptrace.c           |    1 
 arch/s390/kernel/setup.c            |    1 
 arch/s390/kernel/signal.c           |    1 
 arch/s390/kernel/smp.c              |    1 
 arch/s390/kernel/suspend.c          |    1 
 arch/s390/kernel/vdso.c             |    1 
 arch/s390/kvm/kvm-s390.c            |    1 
 arch/s390/mm/fault.c                |    1 
 arch/s390/mm/init.c                 |    1 
 arch/s390/mm/maccess.c              |    1 
 arch/s390/oprofile/hwsampler.c      |    1 
 drivers/s390/char/sclp_cmd.c        |    1 
 drivers/s390/cio/crw.c              |    1 
 drivers/s390/crypto/ap_bus.c        |    1 
 32 files changed, 330 insertions(+), 282 deletions(-)
 create mode 100644 arch/s390/include/asm/barrier.h
 create mode 100644 arch/s390/include/asm/ctl_reg.h
 create mode 100644 arch/s390/include/asm/exec.h
 create mode 100644 arch/s390/include/asm/facility.h
 create mode 100644 arch/s390/include/asm/switch_to.h
 delete mode 100644 arch/s390/include/asm/system.h

diff --git a/arch/s390/crypto/crypt_s390.h b/arch/s390/crypto/crypt_s390.h
index ffd1ac2..9178db6 100644
--- a/arch/s390/crypto/crypt_s390.h
+++ b/arch/s390/crypto/crypt_s390.h
@@ -17,6 +17,7 @@
 #define _CRYPTO_ARCH_S390_CRYPT_S390_H
 
 #include <asm/errno.h>
+#include <asm/facility.h>
 
 #define CRYPT_S390_OP_MASK 0xFF00
 #define CRYPT_S390_FUNC_MASK 0x00FF
diff --git a/arch/s390/include/asm/atomic.h b/arch/s390/include/asm/atomic.h
index 1a77c09..748347b 100644
--- a/arch/s390/include/asm/atomic.h
+++ b/arch/s390/include/asm/atomic.h
@@ -15,6 +15,7 @@
 
 #include <linux/compiler.h>
 #include <linux/types.h>
+#include <asm/cmpxchg.h>
 
 #define ATOMIC_INIT(i)  { (i) }
 
diff --git a/arch/s390/include/asm/barrier.h b/arch/s390/include/asm/barrier.h
new file mode 100644
index 0000000..451273a
--- /dev/null
+++ b/arch/s390/include/asm/barrier.h
@@ -0,0 +1,35 @@
+/*
+ * Copyright IBM Corp. 1999, 2009
+ *
+ * Author(s): Martin Schwidefsky <schwidefsky@de.ibm.com>
+ */
+
+#ifndef __ASM_BARRIER_H
+#define __ASM_BARRIER_H
+
+/*
+ * Force strict CPU ordering.
+ * And yes, this is required on UP too when we're talking
+ * to devices.
+ *
+ * This is very similar to the ppc eieio/sync instruction in that is
+ * does a checkpoint syncronisation & makes sure that 
+ * all memory ops have completed wrt other CPU's ( see 7-15 POP  DJB ).
+ */
+
+#define eieio()	asm volatile("bcr 15,0" : : : "memory")
+#define SYNC_OTHER_CORES(x)   eieio()
+#define mb()    eieio()
+#define rmb()   eieio()
+#define wmb()   eieio()
+#define read_barrier_depends() do { } while(0)
+#define smp_mb()       mb()
+#define smp_rmb()      rmb()
+#define smp_wmb()      wmb()
+#define smp_read_barrier_depends()    read_barrier_depends()
+#define smp_mb__before_clear_bit()     smp_mb()
+#define smp_mb__after_clear_bit()      smp_mb()
+
+#define set_mb(var, value)      do { var = value; mb(); } while (0)
+
+#endif /* __ASM_BARRIER_H */
diff --git a/arch/s390/include/asm/ctl_reg.h b/arch/s390/include/asm/ctl_reg.h
new file mode 100644
index 0000000..ecde941
--- /dev/null
+++ b/arch/s390/include/asm/ctl_reg.h
@@ -0,0 +1,76 @@
+/*
+ * Copyright IBM Corp. 1999, 2009
+ *
+ * Author(s): Martin Schwidefsky <schwidefsky@de.ibm.com>
+ */
+
+#ifndef __ASM_CTL_REG_H
+#define __ASM_CTL_REG_H
+
+#ifdef __s390x__
+
+#define __ctl_load(array, low, high) ({				\
+	typedef struct { char _[sizeof(array)]; } addrtype;	\
+	asm volatile(						\
+		"	lctlg	%1,%2,%0\n"			\
+		: : "Q" (*(addrtype *)(&array)),		\
+		    "i" (low), "i" (high));			\
+	})
+
+#define __ctl_store(array, low, high) ({			\
+	typedef struct { char _[sizeof(array)]; } addrtype;	\
+	asm volatile(						\
+		"	stctg	%1,%2,%0\n"			\
+		: "=Q" (*(addrtype *)(&array))			\
+		: "i" (low), "i" (high));			\
+	})
+
+#else /* __s390x__ */
+
+#define __ctl_load(array, low, high) ({				\
+	typedef struct { char _[sizeof(array)]; } addrtype;	\
+	asm volatile(						\
+		"	lctl	%1,%2,%0\n"			\
+		: : "Q" (*(addrtype *)(&array)),		\
+		    "i" (low), "i" (high));			\
+})
+
+#define __ctl_store(array, low, high) ({			\
+	typedef struct { char _[sizeof(array)]; } addrtype;	\
+	asm volatile(						\
+		"	stctl	%1,%2,%0\n"			\
+		: "=Q" (*(addrtype *)(&array))			\
+		: "i" (low), "i" (high));			\
+	})
+
+#endif /* __s390x__ */
+
+#define __ctl_set_bit(cr, bit) ({	\
+	unsigned long __dummy;		\
+	__ctl_store(__dummy, cr, cr);	\
+	__dummy |= 1UL << (bit);	\
+	__ctl_load(__dummy, cr, cr);	\
+})
+
+#define __ctl_clear_bit(cr, bit) ({	\
+	unsigned long __dummy;		\
+	__ctl_store(__dummy, cr, cr);	\
+	__dummy &= ~(1UL << (bit));	\
+	__ctl_load(__dummy, cr, cr);	\
+})
+
+#ifdef CONFIG_SMP
+
+extern void smp_ctl_set_bit(int cr, int bit);
+extern void smp_ctl_clear_bit(int cr, int bit);
+#define ctl_set_bit(cr, bit) smp_ctl_set_bit(cr, bit)
+#define ctl_clear_bit(cr, bit) smp_ctl_clear_bit(cr, bit)
+
+#else
+
+#define ctl_set_bit(cr, bit) __ctl_set_bit(cr, bit)
+#define ctl_clear_bit(cr, bit) __ctl_clear_bit(cr, bit)
+
+#endif /* CONFIG_SMP */
+
+#endif /* __ASM_CTL_REG_H */
diff --git a/arch/s390/include/asm/elf.h b/arch/s390/include/asm/elf.h
index 547f1a6..c4ee39f 100644
--- a/arch/s390/include/asm/elf.h
+++ b/arch/s390/include/asm/elf.h
@@ -129,7 +129,6 @@ typedef s390_fp_regs compat_elf_fpregset_t;
 typedef s390_compat_regs compat_elf_gregset_t;
 
 #include <linux/sched.h>	/* for task_struct */
-#include <asm/system.h>		/* for save_access_regs */
 #include <asm/mmu_context.h>
 
 #include <asm/vdso.h>
diff --git a/arch/s390/include/asm/exec.h b/arch/s390/include/asm/exec.h
new file mode 100644
index 0000000..c4a93d6
--- /dev/null
+++ b/arch/s390/include/asm/exec.h
@@ -0,0 +1,12 @@
+/*
+ * Copyright IBM Corp. 1999, 2009
+ *
+ * Author(s): Martin Schwidefsky <schwidefsky@de.ibm.com>
+ */
+
+#ifndef __ASM_EXEC_H
+#define __ASM_EXEC_H
+
+extern unsigned long arch_align_stack(unsigned long sp);
+
+#endif /* __ASM_EXEC_H */
diff --git a/arch/s390/include/asm/facility.h b/arch/s390/include/asm/facility.h
new file mode 100644
index 0000000..0890581
--- /dev/null
+++ b/arch/s390/include/asm/facility.h
@@ -0,0 +1,29 @@
+/*
+ * Copyright IBM Corp. 1999, 2009
+ *
+ * Author(s): Martin Schwidefsky <schwidefsky@de.ibm.com>
+ */
+
+#ifndef __ASM_FACILITY_H
+#define __ASM_FACILITY_H
+
+#include <asm/lowcore.h>
+
+#define MAX_FACILITY_BIT (256*8)	/* stfle_fac_list has 256 bytes */
+
+/*
+ * The test_facility function uses the bit odering where the MSB is bit 0.
+ * That makes it easier to query facility bits with the bit number as
+ * documented in the Principles of Operation.
+ */
+static inline int test_facility(unsigned long nr)
+{
+	unsigned char *ptr;
+
+	if (nr >= MAX_FACILITY_BIT)
+		return 0;
+	ptr = (unsigned char *) &S390_lowcore.stfle_fac_list + (nr >> 3);
+	return (*ptr & (0x80 >> (nr & 7))) != 0;
+}
+
+#endif /* __ASM_FACILITY_H */
diff --git a/arch/s390/include/asm/mmu.h b/arch/s390/include/asm/mmu.h
index 4506791..1c7d6ce 100644
--- a/arch/s390/include/asm/mmu.h
+++ b/arch/s390/include/asm/mmu.h
@@ -21,4 +21,18 @@ typedef struct {
 	.context.pgtable_list = LIST_HEAD_INIT(name.context.pgtable_list),    \
 	.context.gmap_list = LIST_HEAD_INIT(name.context.gmap_list),
 
+static inline int tprot(unsigned long addr)
+{
+	int rc = -EFAULT;
+
+	asm volatile(
+		"	tprot	0(%1),0\n"
+		"0:	ipm	%0\n"
+		"	srl	%0,28\n"
+		"1:\n"
+		EX_TABLE(0b,1b)
+		: "+d" (rc) : "a" (addr) : "cc");
+	return rc;
+}
+
 #endif
diff --git a/arch/s390/include/asm/mmu_context.h b/arch/s390/include/asm/mmu_context.h
index 5682f16..5d09e40 100644
--- a/arch/s390/include/asm/mmu_context.h
+++ b/arch/s390/include/asm/mmu_context.h
@@ -12,6 +12,7 @@
 #include <asm/pgalloc.h>
 #include <asm/uaccess.h>
 #include <asm/tlbflush.h>
+#include <asm/ctl_reg.h>
 #include <asm-generic/mm_hooks.h>
 
 static inline int init_new_context(struct task_struct *tsk,
diff --git a/arch/s390/include/asm/processor.h b/arch/s390/include/asm/processor.h
index d25843a..320aa82 100644
--- a/arch/s390/include/asm/processor.h
+++ b/arch/s390/include/asm/processor.h
@@ -14,6 +14,7 @@
 #define __ASM_S390_PROCESSOR_H
 
 #include <linux/linkage.h>
+#include <linux/irqflags.h>
 #include <asm/cpu.h>
 #include <asm/page.h>
 #include <asm/ptrace.h>
@@ -304,6 +305,21 @@ static inline void __noreturn disabled_wait(unsigned long code)
 }
 
 /*
+ * Use to set psw mask except for the first byte which
+ * won't be changed by this function.
+ */
+static inline void
+__set_psw_mask(unsigned long mask)
+{
+	__load_psw_mask(mask | (arch_local_save_flags() & ~(-1UL >> 8)));
+}
+
+#define local_mcck_enable() \
+	__set_psw_mask(psw_kernel_bits | PSW_MASK_DAT | PSW_MASK_MCHECK)
+#define local_mcck_disable() \
+	__set_psw_mask(psw_kernel_bits | PSW_MASK_DAT)
+
+/*
  * Basic Machine Check/Program Check Handler.
  */
 
diff --git a/arch/s390/include/asm/setup.h b/arch/s390/include/asm/setup.h
index 097183c..b21e46e 100644
--- a/arch/s390/include/asm/setup.h
+++ b/arch/s390/include/asm/setup.h
@@ -140,6 +140,20 @@ extern char vmpoff_cmd[];
 #define NSS_NAME_SIZE	8
 extern char kernel_nss_name[];
 
+#ifdef CONFIG_PFAULT
+extern int pfault_init(void);
+extern void pfault_fini(void);
+#else /* CONFIG_PFAULT */
+#define pfault_init()		({-1;})
+#define pfault_fini()		do { } while (0)
+#endif /* CONFIG_PFAULT */
+
+extern void cmma_init(void);
+
+extern void (*_machine_restart)(char *command);
+extern void (*_machine_halt)(void);
+extern void (*_machine_power_off)(void);
+
 #else /* __ASSEMBLY__ */
 
 #ifndef __s390x__
diff --git a/arch/s390/include/asm/sigp.h b/arch/s390/include/asm/sigp.h
index 06faf6a..d7008d1 100644
--- a/arch/s390/include/asm/sigp.h
+++ b/arch/s390/include/asm/sigp.h
@@ -14,6 +14,14 @@
 /* Get real cpu address from logical cpu number. */
 extern unsigned short __cpu_logical_map[];
 
+static inline unsigned short stap(void)
+{
+	unsigned short cpu_address;
+
+	asm volatile("stap %0" : "=m" (cpu_address));
+	return cpu_address;
+}
+
 static inline int cpu_logical_map(int cpu)
 {
 #ifdef CONFIG_SMP
diff --git a/arch/s390/include/asm/switch_to.h b/arch/s390/include/asm/switch_to.h
new file mode 100644
index 0000000..6ad1fc7
--- /dev/null
+++ b/arch/s390/include/asm/switch_to.h
@@ -0,0 +1,100 @@
+/*
+ * Copyright IBM Corp. 1999, 2009
+ *
+ * Author(s): Martin Schwidefsky <schwidefsky@de.ibm.com>
+ */
+
+#ifndef __ASM_SWITCH_TO_H
+#define __ASM_SWITCH_TO_H
+
+struct task_struct;
+
+extern struct task_struct *__switch_to(void *, void *);
+extern void update_per_regs(struct task_struct *task);
+
+static inline void save_fp_regs(s390_fp_regs *fpregs)
+{
+	asm volatile(
+		"	std	0,%O0+8(%R0)\n"
+		"	std	2,%O0+24(%R0)\n"
+		"	std	4,%O0+40(%R0)\n"
+		"	std	6,%O0+56(%R0)"
+		: "=Q" (*fpregs) : "Q" (*fpregs));
+	if (!MACHINE_HAS_IEEE)
+		return;
+	asm volatile(
+		"	stfpc	%0\n"
+		"	std	1,%O0+16(%R0)\n"
+		"	std	3,%O0+32(%R0)\n"
+		"	std	5,%O0+48(%R0)\n"
+		"	std	7,%O0+64(%R0)\n"
+		"	std	8,%O0+72(%R0)\n"
+		"	std	9,%O0+80(%R0)\n"
+		"	std	10,%O0+88(%R0)\n"
+		"	std	11,%O0+96(%R0)\n"
+		"	std	12,%O0+104(%R0)\n"
+		"	std	13,%O0+112(%R0)\n"
+		"	std	14,%O0+120(%R0)\n"
+		"	std	15,%O0+128(%R0)\n"
+		: "=Q" (*fpregs) : "Q" (*fpregs));
+}
+
+static inline void restore_fp_regs(s390_fp_regs *fpregs)
+{
+	asm volatile(
+		"	ld	0,%O0+8(%R0)\n"
+		"	ld	2,%O0+24(%R0)\n"
+		"	ld	4,%O0+40(%R0)\n"
+		"	ld	6,%O0+56(%R0)"
+		: : "Q" (*fpregs));
+	if (!MACHINE_HAS_IEEE)
+		return;
+	asm volatile(
+		"	lfpc	%0\n"
+		"	ld	1,%O0+16(%R0)\n"
+		"	ld	3,%O0+32(%R0)\n"
+		"	ld	5,%O0+48(%R0)\n"
+		"	ld	7,%O0+64(%R0)\n"
+		"	ld	8,%O0+72(%R0)\n"
+		"	ld	9,%O0+80(%R0)\n"
+		"	ld	10,%O0+88(%R0)\n"
+		"	ld	11,%O0+96(%R0)\n"
+		"	ld	12,%O0+104(%R0)\n"
+		"	ld	13,%O0+112(%R0)\n"
+		"	ld	14,%O0+120(%R0)\n"
+		"	ld	15,%O0+128(%R0)\n"
+		: : "Q" (*fpregs));
+}
+
+static inline void save_access_regs(unsigned int *acrs)
+{
+	asm volatile("stam 0,15,%0" : "=Q" (*acrs));
+}
+
+static inline void restore_access_regs(unsigned int *acrs)
+{
+	asm volatile("lam 0,15,%0" : : "Q" (*acrs));
+}
+
+#define switch_to(prev,next,last) do {					\
+	if (prev->mm) {							\
+		save_fp_regs(&prev->thread.fp_regs);			\
+		save_access_regs(&prev->thread.acrs[0]);		\
+	}								\
+	if (next->mm) {							\
+		restore_fp_regs(&next->thread.fp_regs);			\
+		restore_access_regs(&next->thread.acrs[0]);		\
+		update_per_regs(next);					\
+	}								\
+	prev = __switch_to(prev,next);					\
+} while (0)
+
+extern void account_vtime(struct task_struct *, struct task_struct *);
+extern void account_tick_vtime(struct task_struct *);
+
+#define finish_arch_switch(prev) do {					     \
+	set_fs(current->thread.mm_segment);				     \
+	account_vtime(prev, current);					     \
+} while (0)
+
+#endif /* __ASM_SWITCH_TO_H */
diff --git a/arch/s390/include/asm/system.h b/arch/s390/include/asm/system.h
deleted file mode 100644
index d73cc6b..0000000
--- a/arch/s390/include/asm/system.h
+++ /dev/null
@@ -1,281 +0,0 @@
-/*
- * Copyright IBM Corp. 1999, 2009
- *
- * Author(s): Martin Schwidefsky <schwidefsky@de.ibm.com>
- */
-
-#ifndef __ASM_SYSTEM_H
-#define __ASM_SYSTEM_H
-
-#include <linux/kernel.h>
-#include <linux/errno.h>
-#include <asm/types.h>
-#include <asm/ptrace.h>
-#include <asm/setup.h>
-#include <asm/processor.h>
-#include <asm/lowcore.h>
-#include <asm/cmpxchg.h>
-
-#ifdef __KERNEL__
-
-struct task_struct;
-
-extern struct task_struct *__switch_to(void *, void *);
-extern void update_per_regs(struct task_struct *task);
-
-static inline void save_fp_regs(s390_fp_regs *fpregs)
-{
-	asm volatile(
-		"	std	0,%O0+8(%R0)\n"
-		"	std	2,%O0+24(%R0)\n"
-		"	std	4,%O0+40(%R0)\n"
-		"	std	6,%O0+56(%R0)"
-		: "=Q" (*fpregs) : "Q" (*fpregs));
-	if (!MACHINE_HAS_IEEE)
-		return;
-	asm volatile(
-		"	stfpc	%0\n"
-		"	std	1,%O0+16(%R0)\n"
-		"	std	3,%O0+32(%R0)\n"
-		"	std	5,%O0+48(%R0)\n"
-		"	std	7,%O0+64(%R0)\n"
-		"	std	8,%O0+72(%R0)\n"
-		"	std	9,%O0+80(%R0)\n"
-		"	std	10,%O0+88(%R0)\n"
-		"	std	11,%O0+96(%R0)\n"
-		"	std	12,%O0+104(%R0)\n"
-		"	std	13,%O0+112(%R0)\n"
-		"	std	14,%O0+120(%R0)\n"
-		"	std	15,%O0+128(%R0)\n"
-		: "=Q" (*fpregs) : "Q" (*fpregs));
-}
-
-static inline void restore_fp_regs(s390_fp_regs *fpregs)
-{
-	asm volatile(
-		"	ld	0,%O0+8(%R0)\n"
-		"	ld	2,%O0+24(%R0)\n"
-		"	ld	4,%O0+40(%R0)\n"
-		"	ld	6,%O0+56(%R0)"
-		: : "Q" (*fpregs));
-	if (!MACHINE_HAS_IEEE)
-		return;
-	asm volatile(
-		"	lfpc	%0\n"
-		"	ld	1,%O0+16(%R0)\n"
-		"	ld	3,%O0+32(%R0)\n"
-		"	ld	5,%O0+48(%R0)\n"
-		"	ld	7,%O0+64(%R0)\n"
-		"	ld	8,%O0+72(%R0)\n"
-		"	ld	9,%O0+80(%R0)\n"
-		"	ld	10,%O0+88(%R0)\n"
-		"	ld	11,%O0+96(%R0)\n"
-		"	ld	12,%O0+104(%R0)\n"
-		"	ld	13,%O0+112(%R0)\n"
-		"	ld	14,%O0+120(%R0)\n"
-		"	ld	15,%O0+128(%R0)\n"
-		: : "Q" (*fpregs));
-}
-
-static inline void save_access_regs(unsigned int *acrs)
-{
-	asm volatile("stam 0,15,%0" : "=Q" (*acrs));
-}
-
-static inline void restore_access_regs(unsigned int *acrs)
-{
-	asm volatile("lam 0,15,%0" : : "Q" (*acrs));
-}
-
-#define switch_to(prev,next,last) do {					\
-	if (prev->mm) {							\
-		save_fp_regs(&prev->thread.fp_regs);			\
-		save_access_regs(&prev->thread.acrs[0]);		\
-	}								\
-	if (next->mm) {							\
-		restore_fp_regs(&next->thread.fp_regs);			\
-		restore_access_regs(&next->thread.acrs[0]);		\
-		update_per_regs(next);					\
-	}								\
-	prev = __switch_to(prev,next);					\
-} while (0)
-
-extern void account_vtime(struct task_struct *, struct task_struct *);
-extern void account_tick_vtime(struct task_struct *);
-
-#ifdef CONFIG_PFAULT
-extern int pfault_init(void);
-extern void pfault_fini(void);
-#else /* CONFIG_PFAULT */
-#define pfault_init()		({-1;})
-#define pfault_fini()		do { } while (0)
-#endif /* CONFIG_PFAULT */
-
-extern void cmma_init(void);
-extern int memcpy_real(void *, void *, size_t);
-extern void copy_to_absolute_zero(void *dest, void *src, size_t count);
-extern int copy_to_user_real(void __user *dest, void *src, size_t count);
-extern int copy_from_user_real(void *dest, void __user *src, size_t count);
-
-#define finish_arch_switch(prev) do {					     \
-	set_fs(current->thread.mm_segment);				     \
-	account_vtime(prev, current);					     \
-} while (0)
-
-#define nop() asm volatile("nop")
-
-/*
- * Force strict CPU ordering.
- * And yes, this is required on UP too when we're talking
- * to devices.
- *
- * This is very similar to the ppc eieio/sync instruction in that is
- * does a checkpoint syncronisation & makes sure that 
- * all memory ops have completed wrt other CPU's ( see 7-15 POP  DJB ).
- */
-
-#define eieio()	asm volatile("bcr 15,0" : : : "memory")
-#define SYNC_OTHER_CORES(x)   eieio()
-#define mb()    eieio()
-#define rmb()   eieio()
-#define wmb()   eieio()
-#define read_barrier_depends() do { } while(0)
-#define smp_mb()       mb()
-#define smp_rmb()      rmb()
-#define smp_wmb()      wmb()
-#define smp_read_barrier_depends()    read_barrier_depends()
-#define smp_mb__before_clear_bit()     smp_mb()
-#define smp_mb__after_clear_bit()      smp_mb()
-
-
-#define set_mb(var, value)      do { var = value; mb(); } while (0)
-
-#ifdef __s390x__
-
-#define __ctl_load(array, low, high) ({				\
-	typedef struct { char _[sizeof(array)]; } addrtype;	\
-	asm volatile(						\
-		"	lctlg	%1,%2,%0\n"			\
-		: : "Q" (*(addrtype *)(&array)),		\
-		    "i" (low), "i" (high));			\
-	})
-
-#define __ctl_store(array, low, high) ({			\
-	typedef struct { char _[sizeof(array)]; } addrtype;	\
-	asm volatile(						\
-		"	stctg	%1,%2,%0\n"			\
-		: "=Q" (*(addrtype *)(&array))			\
-		: "i" (low), "i" (high));			\
-	})
-
-#else /* __s390x__ */
-
-#define __ctl_load(array, low, high) ({				\
-	typedef struct { char _[sizeof(array)]; } addrtype;	\
-	asm volatile(						\
-		"	lctl	%1,%2,%0\n"			\
-		: : "Q" (*(addrtype *)(&array)),		\
-		    "i" (low), "i" (high));			\
-})
-
-#define __ctl_store(array, low, high) ({			\
-	typedef struct { char _[sizeof(array)]; } addrtype;	\
-	asm volatile(						\
-		"	stctl	%1,%2,%0\n"			\
-		: "=Q" (*(addrtype *)(&array))			\
-		: "i" (low), "i" (high));			\
-	})
-
-#endif /* __s390x__ */
-
-#define __ctl_set_bit(cr, bit) ({	\
-	unsigned long __dummy;		\
-	__ctl_store(__dummy, cr, cr);	\
-	__dummy |= 1UL << (bit);	\
-	__ctl_load(__dummy, cr, cr);	\
-})
-
-#define __ctl_clear_bit(cr, bit) ({	\
-	unsigned long __dummy;		\
-	__ctl_store(__dummy, cr, cr);	\
-	__dummy &= ~(1UL << (bit));	\
-	__ctl_load(__dummy, cr, cr);	\
-})
-
-/*
- * Use to set psw mask except for the first byte which
- * won't be changed by this function.
- */
-static inline void
-__set_psw_mask(unsigned long mask)
-{
-	__load_psw_mask(mask | (arch_local_save_flags() & ~(-1UL >> 8)));
-}
-
-#define local_mcck_enable() \
-	__set_psw_mask(psw_kernel_bits | PSW_MASK_DAT | PSW_MASK_MCHECK)
-#define local_mcck_disable() \
-	__set_psw_mask(psw_kernel_bits | PSW_MASK_DAT)
-
-#ifdef CONFIG_SMP
-
-extern void smp_ctl_set_bit(int cr, int bit);
-extern void smp_ctl_clear_bit(int cr, int bit);
-#define ctl_set_bit(cr, bit) smp_ctl_set_bit(cr, bit)
-#define ctl_clear_bit(cr, bit) smp_ctl_clear_bit(cr, bit)
-
-#else
-
-#define ctl_set_bit(cr, bit) __ctl_set_bit(cr, bit)
-#define ctl_clear_bit(cr, bit) __ctl_clear_bit(cr, bit)
-
-#endif /* CONFIG_SMP */
-
-#define MAX_FACILITY_BIT (256*8)	/* stfle_fac_list has 256 bytes */
-
-/*
- * The test_facility function uses the bit odering where the MSB is bit 0.
- * That makes it easier to query facility bits with the bit number as
- * documented in the Principles of Operation.
- */
-static inline int test_facility(unsigned long nr)
-{
-	unsigned char *ptr;
-
-	if (nr >= MAX_FACILITY_BIT)
-		return 0;
-	ptr = (unsigned char *) &S390_lowcore.stfle_fac_list + (nr >> 3);
-	return (*ptr & (0x80 >> (nr & 7))) != 0;
-}
-
-static inline unsigned short stap(void)
-{
-	unsigned short cpu_address;
-
-	asm volatile("stap %0" : "=m" (cpu_address));
-	return cpu_address;
-}
-
-extern void (*_machine_restart)(char *command);
-extern void (*_machine_halt)(void);
-extern void (*_machine_power_off)(void);
-
-extern unsigned long arch_align_stack(unsigned long sp);
-
-static inline int tprot(unsigned long addr)
-{
-	int rc = -EFAULT;
-
-	asm volatile(
-		"	tprot	0(%1),0\n"
-		"0:	ipm	%0\n"
-		"	srl	%0,28\n"
-		"1:\n"
-		EX_TABLE(0b,1b)
-		: "+d" (rc) : "a" (addr) : "cc");
-	return rc;
-}
-
-#endif /* __KERNEL__ */
-
-#endif
diff --git a/arch/s390/include/asm/uaccess.h b/arch/s390/include/asm/uaccess.h
index 2b23885..8f2cada 100644
--- a/arch/s390/include/asm/uaccess.h
+++ b/arch/s390/include/asm/uaccess.h
@@ -16,6 +16,7 @@
  */
 #include <linux/sched.h>
 #include <linux/errno.h>
+#include <asm/ctl_reg.h>
 
 #define VERIFY_READ     0
 #define VERIFY_WRITE    1
@@ -375,4 +376,9 @@ clear_user(void __user *to, unsigned long n)
 	return n;
 }
 
+extern int memcpy_real(void *, void *, size_t);
+extern void copy_to_absolute_zero(void *dest, void *src, size_t count);
+extern int copy_to_user_real(void __user *dest, void *src, size_t count);
+extern int copy_from_user_real(void *dest, void __user *src, size_t count);
+
 #endif /* __S390_UACCESS_H */
diff --git a/arch/s390/kernel/compat_signal.c b/arch/s390/kernel/compat_signal.c
index 6fe78c2..9ad08ad 100644
--- a/arch/s390/kernel/compat_signal.c
+++ b/arch/s390/kernel/compat_signal.c
@@ -27,6 +27,7 @@
 #include <asm/ucontext.h>
 #include <asm/uaccess.h>
 #include <asm/lowcore.h>
+#include <asm/switch_to.h>
 #include "compat_linux.h"
 #include "compat_ptrace.h"
 #include "entry.h"
diff --git a/arch/s390/kernel/early.c b/arch/s390/kernel/early.c
index 52098d6..7e859f2 100644
--- a/arch/s390/kernel/early.c
+++ b/arch/s390/kernel/early.c
@@ -29,6 +29,7 @@
 #include <asm/sysinfo.h>
 #include <asm/cpcmd.h>
 #include <asm/sclp.h>
+#include <asm/facility.h>
 #include "entry.h"
 
 /*
diff --git a/arch/s390/kernel/process.c b/arch/s390/kernel/process.c
index 9672514..ae8fdd3 100644
--- a/arch/s390/kernel/process.c
+++ b/arch/s390/kernel/process.c
@@ -29,6 +29,7 @@
 #include <asm/timer.h>
 #include <asm/nmi.h>
 #include <asm/smp.h>
+#include <asm/switch_to.h>
 #include "entry.h"
 
 asmlinkage void ret_from_fork(void) asm ("ret_from_fork");
diff --git a/arch/s390/kernel/ptrace.c b/arch/s390/kernel/ptrace.c
index 441b5ada..02f300f 100644
--- a/arch/s390/kernel/ptrace.c
+++ b/arch/s390/kernel/ptrace.c
@@ -28,6 +28,7 @@
 #include <asm/pgalloc.h>
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
+#include <asm/switch_to.h>
 #include "entry.h"
 
 #ifdef CONFIG_COMPAT
diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index b7bcd21..1d7cbd3 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -61,6 +61,7 @@
 #include <asm/ebcdic.h>
 #include <asm/kvm_virtio.h>
 #include <asm/diag.h>
+#include <asm/facility.h>
 
 long psw_kernel_bits	= PSW_DEFAULT_KEY | PSW_MASK_BASE | PSW_ASC_PRIMARY |
 			  PSW_MASK_EA | PSW_MASK_BA;
diff --git a/arch/s390/kernel/signal.c b/arch/s390/kernel/signal.c
index 2d421d9..f7abd73 100644
--- a/arch/s390/kernel/signal.c
+++ b/arch/s390/kernel/signal.c
@@ -30,6 +30,7 @@
 #include <asm/ucontext.h>
 #include <asm/uaccess.h>
 #include <asm/lowcore.h>
+#include <asm/switch_to.h>
 #include "entry.h"
 
 #define _BLOCKABLE (~(sigmask(SIGKILL) | sigmask(SIGSTOP)))
diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index 2398ce6..baf1a98 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -53,6 +53,7 @@
 #include <asm/cputime.h>
 #include <asm/vdso.h>
 #include <asm/cpu.h>
+#include <asm/facility.h>
 #include "entry.h"
 
 /* logical cpu to cpu address */
diff --git a/arch/s390/kernel/suspend.c b/arch/s390/kernel/suspend.c
index 3d8ab80..aa1494d 100644
--- a/arch/s390/kernel/suspend.c
+++ b/arch/s390/kernel/suspend.c
@@ -9,6 +9,7 @@
 #include <linux/pfn.h>
 #include <linux/suspend.h>
 #include <linux/mm.h>
+#include <asm/ctl_reg.h>
 
 /*
  * References to section boundaries
diff --git a/arch/s390/kernel/vdso.c b/arch/s390/kernel/vdso.c
index 8187da6..aed1e65 100644
--- a/arch/s390/kernel/vdso.c
+++ b/arch/s390/kernel/vdso.c
@@ -30,6 +30,7 @@
 #include <asm/mmu_context.h>
 #include <asm/sections.h>
 #include <asm/vdso.h>
+#include <asm/facility.h>
 
 #if defined(CONFIG_32BIT) || defined(CONFIG_COMPAT)
 extern char vdso32_start, vdso32_end;
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 78d3f8a..d56de16 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -27,6 +27,7 @@
 #include <asm/lowcore.h>
 #include <asm/pgtable.h>
 #include <asm/nmi.h>
+#include <asm/switch_to.h>
 #include "kvm-s390.h"
 #include "gaccess.h"
 
diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
index 7620f61..3915870 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -35,6 +35,7 @@
 #include <asm/pgtable.h>
 #include <asm/irq.h>
 #include <asm/mmu_context.h>
+#include <asm/facility.h>
 #include "../kernel/entry.h"
 
 #ifndef CONFIG_64BIT
diff --git a/arch/s390/mm/init.c b/arch/s390/mm/init.c
index 2e4870e..2bea060 100644
--- a/arch/s390/mm/init.c
+++ b/arch/s390/mm/init.c
@@ -37,6 +37,7 @@
 #include <asm/tlb.h>
 #include <asm/tlbflush.h>
 #include <asm/sections.h>
+#include <asm/ctl_reg.h>
 
 pgd_t swapper_pg_dir[PTRS_PER_PGD] __attribute__((__aligned__(PAGE_SIZE)));
 
diff --git a/arch/s390/mm/maccess.c b/arch/s390/mm/maccess.c
index 6ea70a0..7bb15fc 100644
--- a/arch/s390/mm/maccess.c
+++ b/arch/s390/mm/maccess.c
@@ -12,6 +12,7 @@
 #include <linux/types.h>
 #include <linux/errno.h>
 #include <linux/gfp.h>
+#include <asm/ctl_reg.h>
 
 /*
  * This function writes to kernel memory bypassing DAT and possible
diff --git a/arch/s390/oprofile/hwsampler.c b/arch/s390/oprofile/hwsampler.c
index 9daee91..f9a0e5d 100644
--- a/arch/s390/oprofile/hwsampler.c
+++ b/arch/s390/oprofile/hwsampler.c
@@ -18,6 +18,7 @@
 #include <linux/oom.h>
 #include <linux/oprofile.h>
 
+#include <asm/facility.h>
 #include <asm/lowcore.h>
 #include <asm/irq.h>
 
diff --git a/drivers/s390/char/sclp_cmd.c b/drivers/s390/char/sclp_cmd.c
index 0b54a91..2e58f47 100644
--- a/drivers/s390/char/sclp_cmd.c
+++ b/drivers/s390/char/sclp_cmd.c
@@ -21,6 +21,7 @@
 #include <asm/chpid.h>
 #include <asm/sclp.h>
 #include <asm/setup.h>
+#include <asm/ctl_reg.h>
 
 #include "sclp.h"
 
diff --git a/drivers/s390/cio/crw.c b/drivers/s390/cio/crw.c
index 425f741..d0a2dff 100644
--- a/drivers/s390/cio/crw.c
+++ b/drivers/s390/cio/crw.c
@@ -13,6 +13,7 @@
 #include <linux/init.h>
 #include <linux/wait.h>
 #include <asm/crw.h>
+#include <asm/ctl_reg.h>
 
 static DEFINE_MUTEX(crw_handler_mutex);
 static crw_handler_t crw_handlers[NR_RSCS];
diff --git a/drivers/s390/crypto/ap_bus.c b/drivers/s390/crypto/ap_bus.c
index 090ea2a..be0caae 100644
--- a/drivers/s390/crypto/ap_bus.c
+++ b/drivers/s390/crypto/ap_bus.c
@@ -45,6 +45,7 @@
 #include <asm/isc.h>
 #include <linux/hrtimer.h>
 #include <linux/ktime.h>
+#include <asm/facility.h>
 
 #include "ap_bus.h"
 

