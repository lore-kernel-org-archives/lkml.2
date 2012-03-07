Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759987Ab2CGTrM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 14:47:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5944 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759927Ab2CGTrG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 14:47:06 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 04/29] Disintegrate asm/system.h on all arches
To: paul.gortmaker@windriver.com, hpa@zytor.com
Cc: torvalds@linux-foundation.org, sfr@canb.auug.org.au, mingo@redhat.com,
        arnd@arndb.de, dhowells@redhat.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Date: Wed, 07 Mar 2012 19:46:41 +0000
Message-ID: <20120307194641.15987.33637.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120307194548.15987.36073.stgit@warthog.procyon.org.uk>
References: <20120307194548.15987.36073.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

asm/system.h is a cause of circular dependency problems because it contains
commonly used primitive stuff like barrier definitions and uncommonly used
stuff like switch_to() that might require MMU definitions.

Disintegrate asm/system.h on all arches into the following common segments:

 (1) asm/barrier.h

     Memory barrier stuff - already done for MIPS and Alpha.

 (2) asm/atomic.h

     Move xchg() and cmpxchg() here as they're atomic ops.

 (3) asm/bug.h

     Move die() and similar here.

 (4) asm/arch_hooks.h

     Move common arch hooks here (such as default_idle()).

 (5) asm/elf.h

     Move AT_VECTOR_SIZE_ARCH here.

 (6) asm/switch_to.h

     Move switch_to() here.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/alpha/include/asm/atomic.h        |   67 ++++++
 arch/alpha/include/asm/auxvec.h        |    2 
 arch/alpha/include/asm/core_lca.h      |    1 
 arch/alpha/include/asm/core_mcpcia.h   |    1 
 arch/alpha/include/asm/elf.h           |    1 
 arch/alpha/include/asm/exec.h          |    6 +
 arch/alpha/include/asm/fpu.h           |    2 
 arch/alpha/include/asm/irqflags.h      |    1 
 arch/alpha/include/asm/mce.h           |   83 ++++++++
 arch/alpha/include/asm/pal.h           |  112 ++++++++++
 arch/alpha/include/asm/pgtable.h       |    1 
 arch/alpha/include/asm/setup.h         |   36 +++
 arch/alpha/include/asm/special_insns.h |   41 ++++
 arch/alpha/include/asm/switch_to.h     |   14 +
 arch/alpha/include/asm/system.h        |  354 --------------------------------
 arch/alpha/include/asm/xchg.h          |    2 
 arch/alpha/kernel/core_apecs.c         |    1 
 arch/alpha/kernel/core_cia.c           |    1 
 arch/alpha/kernel/core_t2.c            |    1 
 arch/alpha/kernel/err_impl.h           |    2 
 arch/alpha/kernel/head.S               |    5 
 arch/alpha/kernel/irq_alpha.c          |    1 
 arch/alpha/kernel/sys_mikasa.c         |    1 
 arch/alpha/kernel/sys_noritake.c       |    1 
 arch/alpha/kernel/sys_sx164.c          |    1 
 arch/alpha/kernel/traps.c              |    1 
 arch/alpha/kernel/vmlinux.lds.S        |    2 
 arch/alpha/mm/init.c                   |    1 
 28 files changed, 384 insertions(+), 358 deletions(-)
 create mode 100644 arch/alpha/include/asm/exec.h
 create mode 100644 arch/alpha/include/asm/mce.h
 create mode 100644 arch/alpha/include/asm/special_insns.h
 create mode 100644 arch/alpha/include/asm/switch_to.h
 delete mode 100644 arch/alpha/include/asm/system.h

diff --git a/arch/alpha/include/asm/atomic.h b/arch/alpha/include/asm/atomic.h
index bd4eabd..f62251e 100644
--- a/arch/alpha/include/asm/atomic.h
+++ b/arch/alpha/include/asm/atomic.h
@@ -168,6 +168,73 @@ static __inline__ long atomic64_sub_return(long i, atomic64_t * v)
 	return result;
 }
 
+/*
+ * Atomic exchange routines.
+ */
+
+#define __ASM__MB
+#define ____xchg(type, args...)		__xchg ## type ## _local(args)
+#define ____cmpxchg(type, args...)	__cmpxchg ## type ## _local(args)
+#include <asm/xchg.h>
+
+#define xchg_local(ptr,x)						\
+  ({									\
+     __typeof__(*(ptr)) _x_ = (x);					\
+     (__typeof__(*(ptr))) __xchg_local((ptr), (unsigned long)_x_,	\
+				       sizeof(*(ptr)));			\
+  })
+
+#define cmpxchg_local(ptr, o, n)					\
+  ({									\
+     __typeof__(*(ptr)) _o_ = (o);					\
+     __typeof__(*(ptr)) _n_ = (n);					\
+     (__typeof__(*(ptr))) __cmpxchg_local((ptr), (unsigned long)_o_,	\
+					  (unsigned long)_n_,		\
+					  sizeof(*(ptr)));		\
+  })
+
+#define cmpxchg64_local(ptr, o, n)					\
+  ({									\
+	BUILD_BUG_ON(sizeof(*(ptr)) != 8);				\
+	cmpxchg_local((ptr), (o), (n));					\
+  })
+
+#ifdef CONFIG_SMP
+#undef __ASM__MB
+#define __ASM__MB	"\tmb\n"
+#endif
+#undef ____xchg
+#undef ____cmpxchg
+#define ____xchg(type, args...)		__xchg ##type(args)
+#define ____cmpxchg(type, args...)	__cmpxchg ##type(args)
+#include <asm/xchg.h>
+
+#define xchg(ptr,x)							\
+  ({									\
+     __typeof__(*(ptr)) _x_ = (x);					\
+     (__typeof__(*(ptr))) __xchg((ptr), (unsigned long)_x_,		\
+				 sizeof(*(ptr)));			\
+  })
+
+#define cmpxchg(ptr, o, n)						\
+  ({									\
+     __typeof__(*(ptr)) _o_ = (o);					\
+     __typeof__(*(ptr)) _n_ = (n);					\
+     (__typeof__(*(ptr))) __cmpxchg((ptr), (unsigned long)_o_,		\
+				    (unsigned long)_n_,	sizeof(*(ptr)));\
+  })
+
+#define cmpxchg64(ptr, o, n)						\
+  ({									\
+	BUILD_BUG_ON(sizeof(*(ptr)) != 8);				\
+	cmpxchg((ptr), (o), (n));					\
+  })
+
+#undef __ASM__MB
+#undef ____cmpxchg
+
+#define __HAVE_ARCH_CMPXCHG 1
+
 #define atomic64_cmpxchg(v, old, new) (cmpxchg(&((v)->counter), old, new))
 #define atomic64_xchg(v, new) (xchg(&((v)->counter), new))
 
diff --git a/arch/alpha/include/asm/auxvec.h b/arch/alpha/include/asm/auxvec.h
index e96fe88..a3a579d 100644
--- a/arch/alpha/include/asm/auxvec.h
+++ b/arch/alpha/include/asm/auxvec.h
@@ -21,4 +21,6 @@
 #define AT_L2_CACHESHAPE	36
 #define AT_L3_CACHESHAPE	37
 
+#define AT_VECTOR_SIZE_ARCH 4 /* entries in ARCH_DLINFO */
+
 #endif /* __ASM_ALPHA_AUXVEC_H */
diff --git a/arch/alpha/include/asm/core_lca.h b/arch/alpha/include/asm/core_lca.h
index 69d60fe..8ee6c51 100644
--- a/arch/alpha/include/asm/core_lca.h
+++ b/arch/alpha/include/asm/core_lca.h
@@ -2,6 +2,7 @@
 #define __ALPHA_LCA__H__
 
 #include <asm/compiler.h>
+#include <asm/mce.h>
 
 /*
  * Low Cost Alpha (LCA) definitions (these apply to 21066 and 21068,
diff --git a/arch/alpha/include/asm/core_mcpcia.h b/arch/alpha/include/asm/core_mcpcia.h
index 9f67a05..ad44bef 100644
--- a/arch/alpha/include/asm/core_mcpcia.h
+++ b/arch/alpha/include/asm/core_mcpcia.h
@@ -7,6 +7,7 @@
 
 #include <linux/types.h>
 #include <asm/compiler.h>
+#include <asm/mce.h>
 
 /*
  * MCPCIA is the internal name for a core logic chipset which provides
diff --git a/arch/alpha/include/asm/elf.h b/arch/alpha/include/asm/elf.h
index da5449e..968d999 100644
--- a/arch/alpha/include/asm/elf.h
+++ b/arch/alpha/include/asm/elf.h
@@ -2,6 +2,7 @@
 #define __ASM_ALPHA_ELF_H
 
 #include <asm/auxvec.h>
+#include <asm/special_insns.h>
 
 /* Special values for the st_other field in the symbol table.  */
 
diff --git a/arch/alpha/include/asm/exec.h b/arch/alpha/include/asm/exec.h
new file mode 100644
index 0000000..4a5a41f
--- /dev/null
+++ b/arch/alpha/include/asm/exec.h
@@ -0,0 +1,6 @@
+#ifndef __ALPHA_EXEC_H
+#define __ALPHA_EXEC_H
+
+#define arch_align_stack(x) (x)
+
+#endif /* __ALPHA_EXEC_H */
diff --git a/arch/alpha/include/asm/fpu.h b/arch/alpha/include/asm/fpu.h
index ecb17a7..db00f78 100644
--- a/arch/alpha/include/asm/fpu.h
+++ b/arch/alpha/include/asm/fpu.h
@@ -1,6 +1,8 @@
 #ifndef __ASM_ALPHA_FPU_H
 #define __ASM_ALPHA_FPU_H
 
+#include <asm/special_insns.h>
+
 /*
  * Alpha floating-point control register defines:
  */
diff --git a/arch/alpha/include/asm/irqflags.h b/arch/alpha/include/asm/irqflags.h
index afb3be3..ffb1726 100644
--- a/arch/alpha/include/asm/irqflags.h
+++ b/arch/alpha/include/asm/irqflags.h
@@ -1,6 +1,7 @@
 #ifndef __ALPHA_IRQFLAGS_H
 #define __ALPHA_IRQFLAGS_H
 
+#include <asm/pal.h>
 
 #define IPL_MIN		0
 #define IPL_SW0		1
diff --git a/arch/alpha/include/asm/mce.h b/arch/alpha/include/asm/mce.h
new file mode 100644
index 0000000..660285b
--- /dev/null
+++ b/arch/alpha/include/asm/mce.h
@@ -0,0 +1,83 @@
+#ifndef __ALPHA_MCE_H
+#define __ALPHA_MCE_H
+
+/*
+ * This is the logout header that should be common to all platforms
+ * (assuming they are running OSF/1 PALcode, I guess).
+ */
+struct el_common {
+	unsigned int	size;		/* size in bytes of logout area */
+	unsigned int	sbz1	: 30;	/* should be zero */
+	unsigned int	err2	:  1;	/* second error */
+	unsigned int	retry	:  1;	/* retry flag */
+	unsigned int	proc_offset;	/* processor-specific offset */
+	unsigned int	sys_offset;	/* system-specific offset */
+	unsigned int	code;		/* machine check code */
+	unsigned int	frame_rev;	/* frame revision */
+};
+
+/* Machine Check Frame for uncorrectable errors (Large format)
+ *      --- This is used to log uncorrectable errors such as
+ *          double bit ECC errors.
+ *      --- These errors are detected by both processor and systems.
+ */
+struct el_common_EV5_uncorrectable_mcheck {
+        unsigned long   shadow[8];        /* Shadow reg. 8-14, 25           */
+        unsigned long   paltemp[24];      /* PAL TEMP REGS.                 */
+        unsigned long   exc_addr;         /* Address of excepting instruction*/
+        unsigned long   exc_sum;          /* Summary of arithmetic traps.   */
+        unsigned long   exc_mask;         /* Exception mask (from exc_sum). */
+        unsigned long   pal_base;         /* Base address for PALcode.      */
+        unsigned long   isr;              /* Interrupt Status Reg.          */
+        unsigned long   icsr;             /* CURRENT SETUP OF EV5 IBOX      */
+        unsigned long   ic_perr_stat;     /* I-CACHE Reg. <11> set Data parity
+                                                         <12> set TAG parity*/
+        unsigned long   dc_perr_stat;     /* D-CACHE error Reg. Bits set to 1:
+                                                     <2> Data error in bank 0
+                                                     <3> Data error in bank 1
+                                                     <4> Tag error in bank 0
+                                                     <5> Tag error in bank 1 */
+        unsigned long   va;               /* Effective VA of fault or miss. */
+        unsigned long   mm_stat;          /* Holds the reason for D-stream 
+                                             fault or D-cache parity errors */
+        unsigned long   sc_addr;          /* Address that was being accessed
+                                             when EV5 detected Secondary cache
+                                             failure.                 */
+        unsigned long   sc_stat;          /* Helps determine if the error was
+                                             TAG/Data parity(Secondary Cache)*/
+        unsigned long   bc_tag_addr;      /* Contents of EV5 BC_TAG_ADDR    */
+        unsigned long   ei_addr;          /* Physical address of any transfer
+                                             that is logged in EV5 EI_STAT */
+        unsigned long   fill_syndrome;    /* For correcting ECC errors.     */
+        unsigned long   ei_stat;          /* Helps identify reason of any 
+                                             processor uncorrectable error
+                                             at its external interface.     */
+        unsigned long   ld_lock;          /* Contents of EV5 LD_LOCK register*/
+};
+
+struct el_common_EV6_mcheck {
+	unsigned int FrameSize;		/* Bytes, including this field */
+	unsigned int FrameFlags;	/* <31> = Retry, <30> = Second Error */
+	unsigned int CpuOffset;		/* Offset to CPU-specific info */
+	unsigned int SystemOffset;	/* Offset to system-specific info */
+	unsigned int MCHK_Code;
+	unsigned int MCHK_Frame_Rev;
+	unsigned long I_STAT;		/* EV6 Internal Processor Registers */
+	unsigned long DC_STAT;		/* (See the 21264 Spec) */
+	unsigned long C_ADDR;
+	unsigned long DC1_SYNDROME;
+	unsigned long DC0_SYNDROME;
+	unsigned long C_STAT;
+	unsigned long C_STS;
+	unsigned long MM_STAT;
+	unsigned long EXC_ADDR;
+	unsigned long IER_CM;
+	unsigned long ISUM;
+	unsigned long RESERVED0;
+	unsigned long PAL_BASE;
+	unsigned long I_CTL;
+	unsigned long PCTX;
+};
+
+
+#endif /* __ALPHA_MCE_H */
diff --git a/arch/alpha/include/asm/pal.h b/arch/alpha/include/asm/pal.h
index 9b4ba0d..6699ee5 100644
--- a/arch/alpha/include/asm/pal.h
+++ b/arch/alpha/include/asm/pal.h
@@ -48,4 +48,116 @@
 #define PAL_retsys	61
 #define PAL_rti		63
 
+#ifdef __KERNEL__
+#ifndef __ASSEMBLY__
+
+extern void halt(void) __attribute__((noreturn));
+#define __halt() __asm__ __volatile__ ("call_pal %0 #halt" : : "i" (PAL_halt))
+
+#define imb() \
+__asm__ __volatile__ ("call_pal %0 #imb" : : "i" (PAL_imb) : "memory")
+
+#define draina() \
+__asm__ __volatile__ ("call_pal %0 #draina" : : "i" (PAL_draina) : "memory")
+
+#define __CALL_PAL_R0(NAME, TYPE)				\
+extern inline TYPE NAME(void)					\
+{								\
+	register TYPE __r0 __asm__("$0");			\
+	__asm__ __volatile__(					\
+		"call_pal %1 # " #NAME				\
+		:"=r" (__r0)					\
+		:"i" (PAL_ ## NAME)				\
+		:"$1", "$16", "$22", "$23", "$24", "$25");	\
+	return __r0;						\
+}
+
+#define __CALL_PAL_W1(NAME, TYPE0)				\
+extern inline void NAME(TYPE0 arg0)				\
+{								\
+	register TYPE0 __r16 __asm__("$16") = arg0;		\
+	__asm__ __volatile__(					\
+		"call_pal %1 # "#NAME				\
+		: "=r"(__r16)					\
+		: "i"(PAL_ ## NAME), "0"(__r16)			\
+		: "$1", "$22", "$23", "$24", "$25");		\
+}
+
+#define __CALL_PAL_W2(NAME, TYPE0, TYPE1)			\
+extern inline void NAME(TYPE0 arg0, TYPE1 arg1)			\
+{								\
+	register TYPE0 __r16 __asm__("$16") = arg0;		\
+	register TYPE1 __r17 __asm__("$17") = arg1;		\
+	__asm__ __volatile__(					\
+		"call_pal %2 # "#NAME				\
+		: "=r"(__r16), "=r"(__r17)			\
+		: "i"(PAL_ ## NAME), "0"(__r16), "1"(__r17)	\
+		: "$1", "$22", "$23", "$24", "$25");		\
+}
+
+#define __CALL_PAL_RW1(NAME, RTYPE, TYPE0)			\
+extern inline RTYPE NAME(TYPE0 arg0)				\
+{								\
+	register RTYPE __r0 __asm__("$0");			\
+	register TYPE0 __r16 __asm__("$16") = arg0;		\
+	__asm__ __volatile__(					\
+		"call_pal %2 # "#NAME				\
+		: "=r"(__r16), "=r"(__r0)			\
+		: "i"(PAL_ ## NAME), "0"(__r16)			\
+		: "$1", "$22", "$23", "$24", "$25");		\
+	return __r0;						\
+}
+
+#define __CALL_PAL_RW2(NAME, RTYPE, TYPE0, TYPE1)		\
+extern inline RTYPE NAME(TYPE0 arg0, TYPE1 arg1)		\
+{								\
+	register RTYPE __r0 __asm__("$0");			\
+	register TYPE0 __r16 __asm__("$16") = arg0;		\
+	register TYPE1 __r17 __asm__("$17") = arg1;		\
+	__asm__ __volatile__(					\
+		"call_pal %3 # "#NAME				\
+		: "=r"(__r16), "=r"(__r17), "=r"(__r0)		\
+		: "i"(PAL_ ## NAME), "0"(__r16), "1"(__r17)	\
+		: "$1", "$22", "$23", "$24", "$25");		\
+	return __r0;						\
+}
+
+__CALL_PAL_W1(cflush, unsigned long);
+__CALL_PAL_R0(rdmces, unsigned long);
+__CALL_PAL_R0(rdps, unsigned long);
+__CALL_PAL_R0(rdusp, unsigned long);
+__CALL_PAL_RW1(swpipl, unsigned long, unsigned long);
+__CALL_PAL_R0(whami, unsigned long);
+__CALL_PAL_W2(wrent, void*, unsigned long);
+__CALL_PAL_W1(wripir, unsigned long);
+__CALL_PAL_W1(wrkgp, unsigned long);
+__CALL_PAL_W1(wrmces, unsigned long);
+__CALL_PAL_RW2(wrperfmon, unsigned long, unsigned long, unsigned long);
+__CALL_PAL_W1(wrusp, unsigned long);
+__CALL_PAL_W1(wrvptptr, unsigned long);
+
+/*
+ * TB routines..
+ */
+#define __tbi(nr,arg,arg1...)					\
+({								\
+	register unsigned long __r16 __asm__("$16") = (nr);	\
+	register unsigned long __r17 __asm__("$17"); arg;	\
+	__asm__ __volatile__(					\
+		"call_pal %3 #__tbi"				\
+		:"=r" (__r16),"=r" (__r17)			\
+		:"0" (__r16),"i" (PAL_tbi) ,##arg1		\
+		:"$0", "$1", "$22", "$23", "$24", "$25");	\
+})
+
+#define tbi(x,y)	__tbi(x,__r17=(y),"1" (__r17))
+#define tbisi(x)	__tbi(1,__r17=(x),"1" (__r17))
+#define tbisd(x)	__tbi(2,__r17=(x),"1" (__r17))
+#define tbis(x)		__tbi(3,__r17=(x),"1" (__r17))
+#define tbiap()		__tbi(-1, /* no second argument */)
+#define tbia()		__tbi(-2, /* no second argument */)
+
+#endif /* !__ASSEMBLY__ */
+#endif /* __KERNEL__ */
+
 #endif /* __ALPHA_PAL_H */
diff --git a/arch/alpha/include/asm/pgtable.h b/arch/alpha/include/asm/pgtable.h
index de98a73..81a4342 100644
--- a/arch/alpha/include/asm/pgtable.h
+++ b/arch/alpha/include/asm/pgtable.h
@@ -15,6 +15,7 @@
 #include <asm/page.h>
 #include <asm/processor.h>	/* For TASK_SIZE */
 #include <asm/machvec.h>
+#include <asm/setup.h>
 
 struct mm_struct;
 struct vm_area_struct;
diff --git a/arch/alpha/include/asm/setup.h b/arch/alpha/include/asm/setup.h
index 2e023a4..b50014b 100644
--- a/arch/alpha/include/asm/setup.h
+++ b/arch/alpha/include/asm/setup.h
@@ -3,4 +3,40 @@
 
 #define COMMAND_LINE_SIZE	256
 
+/*
+ * We leave one page for the initial stack page, and one page for
+ * the initial process structure. Also, the console eats 3 MB for
+ * the initial bootloader (one of which we can reclaim later).
+ */
+#define BOOT_PCB	0x20000000
+#define BOOT_ADDR	0x20000000
+/* Remove when official MILO sources have ELF support: */
+#define BOOT_SIZE	(16*1024)
+
+#ifdef CONFIG_ALPHA_LEGACY_START_ADDRESS
+#define KERNEL_START_PHYS	0x300000 /* Old bootloaders hardcoded this.  */
+#else
+#define KERNEL_START_PHYS	0x1000000 /* required: Wildfire/Titan/Marvel */
+#endif
+
+#define KERNEL_START	(PAGE_OFFSET+KERNEL_START_PHYS)
+#define SWAPPER_PGD	KERNEL_START
+#define INIT_STACK	(PAGE_OFFSET+KERNEL_START_PHYS+0x02000)
+#define EMPTY_PGT	(PAGE_OFFSET+KERNEL_START_PHYS+0x04000)
+#define EMPTY_PGE	(PAGE_OFFSET+KERNEL_START_PHYS+0x08000)
+#define ZERO_PGE	(PAGE_OFFSET+KERNEL_START_PHYS+0x0A000)
+
+#define START_ADDR	(PAGE_OFFSET+KERNEL_START_PHYS+0x10000)
+
+/*
+ * This is setup by the secondary bootstrap loader.  Because
+ * the zero page is zeroed out as soon as the vm system is
+ * initialized, we need to copy things out into a more permanent
+ * place.
+ */
+#define PARAM			ZERO_PGE
+#define COMMAND_LINE		((char*)(PARAM + 0x0000))
+#define INITRD_START		(*(unsigned long *) (PARAM+0x100))
+#define INITRD_SIZE		(*(unsigned long *) (PARAM+0x108))
+
 #endif
diff --git a/arch/alpha/include/asm/special_insns.h b/arch/alpha/include/asm/special_insns.h
new file mode 100644
index 0000000..88d3452
--- /dev/null
+++ b/arch/alpha/include/asm/special_insns.h
@@ -0,0 +1,41 @@
+#ifndef __ALPHA_SPECIAL_INSNS_H
+#define __ALPHA_SPECIAL_INSNS_H
+
+enum implver_enum {
+	IMPLVER_EV4,
+	IMPLVER_EV5,
+	IMPLVER_EV6
+};
+
+#ifdef CONFIG_ALPHA_GENERIC
+#define implver()				\
+({ unsigned long __implver;			\
+   __asm__ ("implver %0" : "=r"(__implver));	\
+   (enum implver_enum) __implver; })
+#else
+/* Try to eliminate some dead code.  */
+#ifdef CONFIG_ALPHA_EV4
+#define implver() IMPLVER_EV4
+#endif
+#ifdef CONFIG_ALPHA_EV5
+#define implver() IMPLVER_EV5
+#endif
+#if defined(CONFIG_ALPHA_EV6)
+#define implver() IMPLVER_EV6
+#endif
+#endif
+
+enum amask_enum {
+	AMASK_BWX = (1UL << 0),
+	AMASK_FIX = (1UL << 1),
+	AMASK_CIX = (1UL << 2),
+	AMASK_MAX = (1UL << 8),
+	AMASK_PRECISE_TRAP = (1UL << 9),
+};
+
+#define amask(mask)						\
+({ unsigned long __amask, __input = (mask);			\
+   __asm__ ("amask %1,%0" : "=r"(__amask) : "rI"(__input));	\
+   __amask; })
+
+#endif /* __ALPHA_SPECIAL_INSNS_H */
diff --git a/arch/alpha/include/asm/switch_to.h b/arch/alpha/include/asm/switch_to.h
new file mode 100644
index 0000000..44c0d4f
--- /dev/null
+++ b/arch/alpha/include/asm/switch_to.h
@@ -0,0 +1,14 @@
+#ifndef __ALPHA_SWITCH_TO_H
+#define __ALPHA_SWITCH_TO_H
+
+
+struct task_struct;
+extern struct task_struct *alpha_switch_to(unsigned long, struct task_struct *);
+
+#define switch_to(P,N,L)						 \
+  do {									 \
+    (L) = alpha_switch_to(virt_to_phys(&task_thread_info(N)->pcb), (P)); \
+    check_mmu_context();						 \
+  } while (0)
+
+#endif /* __ALPHA_SWITCH_TO_H */
diff --git a/arch/alpha/include/asm/system.h b/arch/alpha/include/asm/system.h
deleted file mode 100644
index 9f78e69..0000000
--- a/arch/alpha/include/asm/system.h
+++ /dev/null
@@ -1,354 +0,0 @@
-#ifndef __ALPHA_SYSTEM_H
-#define __ALPHA_SYSTEM_H
-
-#include <asm/pal.h>
-#include <asm/page.h>
-#include <asm/barrier.h>
-
-/*
- * System defines.. Note that this is included both from .c and .S
- * files, so it does only defines, not any C code.
- */
-
-/*
- * We leave one page for the initial stack page, and one page for
- * the initial process structure. Also, the console eats 3 MB for
- * the initial bootloader (one of which we can reclaim later).
- */
-#define BOOT_PCB	0x20000000
-#define BOOT_ADDR	0x20000000
-/* Remove when official MILO sources have ELF support: */
-#define BOOT_SIZE	(16*1024)
-
-#ifdef CONFIG_ALPHA_LEGACY_START_ADDRESS
-#define KERNEL_START_PHYS	0x300000 /* Old bootloaders hardcoded this.  */
-#else
-#define KERNEL_START_PHYS	0x1000000 /* required: Wildfire/Titan/Marvel */
-#endif
-
-#define KERNEL_START	(PAGE_OFFSET+KERNEL_START_PHYS)
-#define SWAPPER_PGD	KERNEL_START
-#define INIT_STACK	(PAGE_OFFSET+KERNEL_START_PHYS+0x02000)
-#define EMPTY_PGT	(PAGE_OFFSET+KERNEL_START_PHYS+0x04000)
-#define EMPTY_PGE	(PAGE_OFFSET+KERNEL_START_PHYS+0x08000)
-#define ZERO_PGE	(PAGE_OFFSET+KERNEL_START_PHYS+0x0A000)
-
-#define START_ADDR	(PAGE_OFFSET+KERNEL_START_PHYS+0x10000)
-
-/*
- * This is setup by the secondary bootstrap loader.  Because
- * the zero page is zeroed out as soon as the vm system is
- * initialized, we need to copy things out into a more permanent
- * place.
- */
-#define PARAM			ZERO_PGE
-#define COMMAND_LINE		((char*)(PARAM + 0x0000))
-#define INITRD_START		(*(unsigned long *) (PARAM+0x100))
-#define INITRD_SIZE		(*(unsigned long *) (PARAM+0x108))
-
-#ifndef __ASSEMBLY__
-#include <linux/kernel.h>
-#define AT_VECTOR_SIZE_ARCH 4 /* entries in ARCH_DLINFO */
-
-/*
- * This is the logout header that should be common to all platforms
- * (assuming they are running OSF/1 PALcode, I guess).
- */
-struct el_common {
-	unsigned int	size;		/* size in bytes of logout area */
-	unsigned int	sbz1	: 30;	/* should be zero */
-	unsigned int	err2	:  1;	/* second error */
-	unsigned int	retry	:  1;	/* retry flag */
-	unsigned int	proc_offset;	/* processor-specific offset */
-	unsigned int	sys_offset;	/* system-specific offset */
-	unsigned int	code;		/* machine check code */
-	unsigned int	frame_rev;	/* frame revision */
-};
-
-/* Machine Check Frame for uncorrectable errors (Large format)
- *      --- This is used to log uncorrectable errors such as
- *          double bit ECC errors.
- *      --- These errors are detected by both processor and systems.
- */
-struct el_common_EV5_uncorrectable_mcheck {
-        unsigned long   shadow[8];        /* Shadow reg. 8-14, 25           */
-        unsigned long   paltemp[24];      /* PAL TEMP REGS.                 */
-        unsigned long   exc_addr;         /* Address of excepting instruction*/
-        unsigned long   exc_sum;          /* Summary of arithmetic traps.   */
-        unsigned long   exc_mask;         /* Exception mask (from exc_sum). */
-        unsigned long   pal_base;         /* Base address for PALcode.      */
-        unsigned long   isr;              /* Interrupt Status Reg.          */
-        unsigned long   icsr;             /* CURRENT SETUP OF EV5 IBOX      */
-        unsigned long   ic_perr_stat;     /* I-CACHE Reg. <11> set Data parity
-                                                         <12> set TAG parity*/
-        unsigned long   dc_perr_stat;     /* D-CACHE error Reg. Bits set to 1:
-                                                     <2> Data error in bank 0
-                                                     <3> Data error in bank 1
-                                                     <4> Tag error in bank 0
-                                                     <5> Tag error in bank 1 */
-        unsigned long   va;               /* Effective VA of fault or miss. */
-        unsigned long   mm_stat;          /* Holds the reason for D-stream 
-                                             fault or D-cache parity errors */
-        unsigned long   sc_addr;          /* Address that was being accessed
-                                             when EV5 detected Secondary cache
-                                             failure.                 */
-        unsigned long   sc_stat;          /* Helps determine if the error was
-                                             TAG/Data parity(Secondary Cache)*/
-        unsigned long   bc_tag_addr;      /* Contents of EV5 BC_TAG_ADDR    */
-        unsigned long   ei_addr;          /* Physical address of any transfer
-                                             that is logged in EV5 EI_STAT */
-        unsigned long   fill_syndrome;    /* For correcting ECC errors.     */
-        unsigned long   ei_stat;          /* Helps identify reason of any 
-                                             processor uncorrectable error
-                                             at its external interface.     */
-        unsigned long   ld_lock;          /* Contents of EV5 LD_LOCK register*/
-};
-
-struct el_common_EV6_mcheck {
-	unsigned int FrameSize;		/* Bytes, including this field */
-	unsigned int FrameFlags;	/* <31> = Retry, <30> = Second Error */
-	unsigned int CpuOffset;		/* Offset to CPU-specific info */
-	unsigned int SystemOffset;	/* Offset to system-specific info */
-	unsigned int MCHK_Code;
-	unsigned int MCHK_Frame_Rev;
-	unsigned long I_STAT;		/* EV6 Internal Processor Registers */
-	unsigned long DC_STAT;		/* (See the 21264 Spec) */
-	unsigned long C_ADDR;
-	unsigned long DC1_SYNDROME;
-	unsigned long DC0_SYNDROME;
-	unsigned long C_STAT;
-	unsigned long C_STS;
-	unsigned long MM_STAT;
-	unsigned long EXC_ADDR;
-	unsigned long IER_CM;
-	unsigned long ISUM;
-	unsigned long RESERVED0;
-	unsigned long PAL_BASE;
-	unsigned long I_CTL;
-	unsigned long PCTX;
-};
-
-extern void halt(void) __attribute__((noreturn));
-#define __halt() __asm__ __volatile__ ("call_pal %0 #halt" : : "i" (PAL_halt))
-
-#define switch_to(P,N,L)						 \
-  do {									 \
-    (L) = alpha_switch_to(virt_to_phys(&task_thread_info(N)->pcb), (P)); \
-    check_mmu_context();						 \
-  } while (0)
-
-struct task_struct;
-extern struct task_struct *alpha_switch_to(unsigned long, struct task_struct*);
-
-#define imb() \
-__asm__ __volatile__ ("call_pal %0 #imb" : : "i" (PAL_imb) : "memory")
-
-#define draina() \
-__asm__ __volatile__ ("call_pal %0 #draina" : : "i" (PAL_draina) : "memory")
-
-enum implver_enum {
-	IMPLVER_EV4,
-	IMPLVER_EV5,
-	IMPLVER_EV6
-};
-
-#ifdef CONFIG_ALPHA_GENERIC
-#define implver()				\
-({ unsigned long __implver;			\
-   __asm__ ("implver %0" : "=r"(__implver));	\
-   (enum implver_enum) __implver; })
-#else
-/* Try to eliminate some dead code.  */
-#ifdef CONFIG_ALPHA_EV4
-#define implver() IMPLVER_EV4
-#endif
-#ifdef CONFIG_ALPHA_EV5
-#define implver() IMPLVER_EV5
-#endif
-#if defined(CONFIG_ALPHA_EV6)
-#define implver() IMPLVER_EV6
-#endif
-#endif
-
-enum amask_enum {
-	AMASK_BWX = (1UL << 0),
-	AMASK_FIX = (1UL << 1),
-	AMASK_CIX = (1UL << 2),
-	AMASK_MAX = (1UL << 8),
-	AMASK_PRECISE_TRAP = (1UL << 9),
-};
-
-#define amask(mask)						\
-({ unsigned long __amask, __input = (mask);			\
-   __asm__ ("amask %1,%0" : "=r"(__amask) : "rI"(__input));	\
-   __amask; })
-
-#define __CALL_PAL_R0(NAME, TYPE)				\
-extern inline TYPE NAME(void)					\
-{								\
-	register TYPE __r0 __asm__("$0");			\
-	__asm__ __volatile__(					\
-		"call_pal %1 # " #NAME				\
-		:"=r" (__r0)					\
-		:"i" (PAL_ ## NAME)				\
-		:"$1", "$16", "$22", "$23", "$24", "$25");	\
-	return __r0;						\
-}
-
-#define __CALL_PAL_W1(NAME, TYPE0)				\
-extern inline void NAME(TYPE0 arg0)				\
-{								\
-	register TYPE0 __r16 __asm__("$16") = arg0;		\
-	__asm__ __volatile__(					\
-		"call_pal %1 # "#NAME				\
-		: "=r"(__r16)					\
-		: "i"(PAL_ ## NAME), "0"(__r16)			\
-		: "$1", "$22", "$23", "$24", "$25");		\
-}
-
-#define __CALL_PAL_W2(NAME, TYPE0, TYPE1)			\
-extern inline void NAME(TYPE0 arg0, TYPE1 arg1)			\
-{								\
-	register TYPE0 __r16 __asm__("$16") = arg0;		\
-	register TYPE1 __r17 __asm__("$17") = arg1;		\
-	__asm__ __volatile__(					\
-		"call_pal %2 # "#NAME				\
-		: "=r"(__r16), "=r"(__r17)			\
-		: "i"(PAL_ ## NAME), "0"(__r16), "1"(__r17)	\
-		: "$1", "$22", "$23", "$24", "$25");		\
-}
-
-#define __CALL_PAL_RW1(NAME, RTYPE, TYPE0)			\
-extern inline RTYPE NAME(TYPE0 arg0)				\
-{								\
-	register RTYPE __r0 __asm__("$0");			\
-	register TYPE0 __r16 __asm__("$16") = arg0;		\
-	__asm__ __volatile__(					\
-		"call_pal %2 # "#NAME				\
-		: "=r"(__r16), "=r"(__r0)			\
-		: "i"(PAL_ ## NAME), "0"(__r16)			\
-		: "$1", "$22", "$23", "$24", "$25");		\
-	return __r0;						\
-}
-
-#define __CALL_PAL_RW2(NAME, RTYPE, TYPE0, TYPE1)		\
-extern inline RTYPE NAME(TYPE0 arg0, TYPE1 arg1)		\
-{								\
-	register RTYPE __r0 __asm__("$0");			\
-	register TYPE0 __r16 __asm__("$16") = arg0;		\
-	register TYPE1 __r17 __asm__("$17") = arg1;		\
-	__asm__ __volatile__(					\
-		"call_pal %3 # "#NAME				\
-		: "=r"(__r16), "=r"(__r17), "=r"(__r0)		\
-		: "i"(PAL_ ## NAME), "0"(__r16), "1"(__r17)	\
-		: "$1", "$22", "$23", "$24", "$25");		\
-	return __r0;						\
-}
-
-__CALL_PAL_W1(cflush, unsigned long);
-__CALL_PAL_R0(rdmces, unsigned long);
-__CALL_PAL_R0(rdps, unsigned long);
-__CALL_PAL_R0(rdusp, unsigned long);
-__CALL_PAL_RW1(swpipl, unsigned long, unsigned long);
-__CALL_PAL_R0(whami, unsigned long);
-__CALL_PAL_W2(wrent, void*, unsigned long);
-__CALL_PAL_W1(wripir, unsigned long);
-__CALL_PAL_W1(wrkgp, unsigned long);
-__CALL_PAL_W1(wrmces, unsigned long);
-__CALL_PAL_RW2(wrperfmon, unsigned long, unsigned long, unsigned long);
-__CALL_PAL_W1(wrusp, unsigned long);
-__CALL_PAL_W1(wrvptptr, unsigned long);
-
-/*
- * TB routines..
- */
-#define __tbi(nr,arg,arg1...)					\
-({								\
-	register unsigned long __r16 __asm__("$16") = (nr);	\
-	register unsigned long __r17 __asm__("$17"); arg;	\
-	__asm__ __volatile__(					\
-		"call_pal %3 #__tbi"				\
-		:"=r" (__r16),"=r" (__r17)			\
-		:"0" (__r16),"i" (PAL_tbi) ,##arg1		\
-		:"$0", "$1", "$22", "$23", "$24", "$25");	\
-})
-
-#define tbi(x,y)	__tbi(x,__r17=(y),"1" (__r17))
-#define tbisi(x)	__tbi(1,__r17=(x),"1" (__r17))
-#define tbisd(x)	__tbi(2,__r17=(x),"1" (__r17))
-#define tbis(x)		__tbi(3,__r17=(x),"1" (__r17))
-#define tbiap()		__tbi(-1, /* no second argument */)
-#define tbia()		__tbi(-2, /* no second argument */)
-
-/*
- * Atomic exchange routines.
- */
-
-#define __ASM__MB
-#define ____xchg(type, args...)		__xchg ## type ## _local(args)
-#define ____cmpxchg(type, args...)	__cmpxchg ## type ## _local(args)
-#include <asm/xchg.h>
-
-#define xchg_local(ptr,x)						\
-  ({									\
-     __typeof__(*(ptr)) _x_ = (x);					\
-     (__typeof__(*(ptr))) __xchg_local((ptr), (unsigned long)_x_,	\
-				       sizeof(*(ptr)));			\
-  })
-
-#define cmpxchg_local(ptr, o, n)					\
-  ({									\
-     __typeof__(*(ptr)) _o_ = (o);					\
-     __typeof__(*(ptr)) _n_ = (n);					\
-     (__typeof__(*(ptr))) __cmpxchg_local((ptr), (unsigned long)_o_,	\
-					  (unsigned long)_n_,		\
-					  sizeof(*(ptr)));		\
-  })
-
-#define cmpxchg64_local(ptr, o, n)					\
-  ({									\
-	BUILD_BUG_ON(sizeof(*(ptr)) != 8);				\
-	cmpxchg_local((ptr), (o), (n));					\
-  })
-
-#ifdef CONFIG_SMP
-#undef __ASM__MB
-#define __ASM__MB	"\tmb\n"
-#endif
-#undef ____xchg
-#undef ____cmpxchg
-#define ____xchg(type, args...)		__xchg ##type(args)
-#define ____cmpxchg(type, args...)	__cmpxchg ##type(args)
-#include <asm/xchg.h>
-
-#define xchg(ptr,x)							\
-  ({									\
-     __typeof__(*(ptr)) _x_ = (x);					\
-     (__typeof__(*(ptr))) __xchg((ptr), (unsigned long)_x_,		\
-				 sizeof(*(ptr)));			\
-  })
-
-#define cmpxchg(ptr, o, n)						\
-  ({									\
-     __typeof__(*(ptr)) _o_ = (o);					\
-     __typeof__(*(ptr)) _n_ = (n);					\
-     (__typeof__(*(ptr))) __cmpxchg((ptr), (unsigned long)_o_,		\
-				    (unsigned long)_n_,	sizeof(*(ptr)));\
-  })
-
-#define cmpxchg64(ptr, o, n)						\
-  ({									\
-	BUILD_BUG_ON(sizeof(*(ptr)) != 8);				\
-	cmpxchg((ptr), (o), (n));					\
-  })
-
-#undef __ASM__MB
-#undef ____cmpxchg
-
-#define __HAVE_ARCH_CMPXCHG 1
-
-#endif /* __ASSEMBLY__ */
-
-#define arch_align_stack(x) (x)
-
-#endif
diff --git a/arch/alpha/include/asm/xchg.h b/arch/alpha/include/asm/xchg.h
index beba1b8..1d1b436 100644
--- a/arch/alpha/include/asm/xchg.h
+++ b/arch/alpha/include/asm/xchg.h
@@ -1,4 +1,4 @@
-#ifndef __ALPHA_SYSTEM_H
+#ifndef _ALPHA_ATOMIC_H
 #error Do not include xchg.h directly!
 #else
 /*
diff --git a/arch/alpha/kernel/core_apecs.c b/arch/alpha/kernel/core_apecs.c
index ca46b2c..708c831 100644
--- a/arch/alpha/kernel/core_apecs.c
+++ b/arch/alpha/kernel/core_apecs.c
@@ -21,6 +21,7 @@
 
 #include <asm/ptrace.h>
 #include <asm/smp.h>
+#include <asm/mce.h>
 
 #include "proto.h"
 #include "pci_impl.h"
diff --git a/arch/alpha/kernel/core_cia.c b/arch/alpha/kernel/core_cia.c
index 1d6ee6c..c44339e 100644
--- a/arch/alpha/kernel/core_cia.c
+++ b/arch/alpha/kernel/core_cia.c
@@ -23,6 +23,7 @@
 #include <linux/bootmem.h>
 
 #include <asm/ptrace.h>
+#include <asm/mce.h>
 
 #include "proto.h"
 #include "pci_impl.h"
diff --git a/arch/alpha/kernel/core_t2.c b/arch/alpha/kernel/core_t2.c
index 2f770e9..3ada4f7 100644
--- a/arch/alpha/kernel/core_t2.c
+++ b/arch/alpha/kernel/core_t2.c
@@ -21,6 +21,7 @@
 
 #include <asm/ptrace.h>
 #include <asm/delay.h>
+#include <asm/mce.h>
 
 #include "proto.h"
 #include "pci_impl.h"
diff --git a/arch/alpha/kernel/err_impl.h b/arch/alpha/kernel/err_impl.h
index 0c010ca..ae529c4 100644
--- a/arch/alpha/kernel/err_impl.h
+++ b/arch/alpha/kernel/err_impl.h
@@ -7,6 +7,8 @@
  * 	implementations.
  */
 
+#include <asm/mce.h>
+
 union el_timestamp;
 struct el_subpacket;
 struct ev7_lf_subpackets;
diff --git a/arch/alpha/kernel/head.S b/arch/alpha/kernel/head.S
index 3f6dcba..c352499 100644
--- a/arch/alpha/kernel/head.S
+++ b/arch/alpha/kernel/head.S
@@ -9,12 +9,11 @@
 
 #include <linux/init.h>
 #include <asm/asm-offsets.h>
+#include <asm/pal.h>
+#include <asm/setup.h>
 
 __HEAD
-.globl swapper_pg_dir
 .globl _stext
-swapper_pg_dir=SWAPPER_PGD
-
 	.set noreorder
 	.globl	__start
 	.ent	__start
diff --git a/arch/alpha/kernel/irq_alpha.c b/arch/alpha/kernel/irq_alpha.c
index 51b7fbd..772ddfd 100644
--- a/arch/alpha/kernel/irq_alpha.c
+++ b/arch/alpha/kernel/irq_alpha.c
@@ -11,6 +11,7 @@
 #include <asm/machvec.h>
 #include <asm/dma.h>
 #include <asm/perf_event.h>
+#include <asm/mce.h>
 
 #include "proto.h"
 #include "irq_impl.h"
diff --git a/arch/alpha/kernel/sys_mikasa.c b/arch/alpha/kernel/sys_mikasa.c
index 21c8ce4..5e82dc1 100644
--- a/arch/alpha/kernel/sys_mikasa.c
+++ b/arch/alpha/kernel/sys_mikasa.c
@@ -17,6 +17,7 @@
 #include <linux/bitops.h>
 
 #include <asm/ptrace.h>
+#include <asm/mce.h>
 #include <asm/dma.h>
 #include <asm/irq.h>
 #include <asm/mmu_context.h>
diff --git a/arch/alpha/kernel/sys_noritake.c b/arch/alpha/kernel/sys_noritake.c
index c5404a5..063e594 100644
--- a/arch/alpha/kernel/sys_noritake.c
+++ b/arch/alpha/kernel/sys_noritake.c
@@ -18,6 +18,7 @@
 #include <linux/bitops.h>
 
 #include <asm/ptrace.h>
+#include <asm/mce.h>
 #include <asm/dma.h>
 #include <asm/irq.h>
 #include <asm/mmu_context.h>
diff --git a/arch/alpha/kernel/sys_sx164.c b/arch/alpha/kernel/sys_sx164.c
index 2b78a15..d063b36 100644
--- a/arch/alpha/kernel/sys_sx164.c
+++ b/arch/alpha/kernel/sys_sx164.c
@@ -25,6 +25,7 @@
 #include <asm/core_cia.h>
 #include <asm/hwrpb.h>
 #include <asm/tlbflush.h>
+#include <asm/special_insns.h>
 
 #include "proto.h"
 #include "irq_impl.h"
diff --git a/arch/alpha/kernel/traps.c b/arch/alpha/kernel/traps.c
index 0414e02..80d987c 100644
--- a/arch/alpha/kernel/traps.c
+++ b/arch/alpha/kernel/traps.c
@@ -24,6 +24,7 @@
 #include <asm/sysinfo.h>
 #include <asm/hwrpb.h>
 #include <asm/mmu_context.h>
+#include <asm/special_insns.h>
 
 #include "proto.h"
 
diff --git a/arch/alpha/kernel/vmlinux.lds.S b/arch/alpha/kernel/vmlinux.lds.S
index f937ad1..647b84c 100644
--- a/arch/alpha/kernel/vmlinux.lds.S
+++ b/arch/alpha/kernel/vmlinux.lds.S
@@ -2,6 +2,7 @@
 #include <asm/thread_info.h>
 #include <asm/cache.h>
 #include <asm/page.h>
+#include <asm/setup.h>
 
 OUTPUT_FORMAT("elf64-alpha")
 OUTPUT_ARCH(alpha)
@@ -25,6 +26,7 @@ SECTIONS
 		*(.fixup)
 		*(.gnu.warning)
 	} :kernel
+	swapper_pg_dir = SWAPPER_PGD;
 	_etext = .;	/* End of text section */
 
 	NOTES :kernel :note
diff --git a/arch/alpha/mm/init.c b/arch/alpha/mm/init.c
index 69a6c21..1ad6ca7 100644
--- a/arch/alpha/mm/init.c
+++ b/arch/alpha/mm/init.c
@@ -30,6 +30,7 @@
 #include <asm/mmu_context.h>
 #include <asm/console.h>
 #include <asm/tlb.h>
+#include <asm/setup.h>
 
 extern void die_if_kernel(char *,struct pt_regs *,long);
 

