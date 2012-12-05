Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932158Ab2LEQNF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 11:13:05 -0500
Received: from multi.imgtec.com ([194.200.65.239]:51616 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753588Ab2LEQJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 11:09:44 -0500
From: James Hogan <james.hogan@imgtec.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, James Hogan <james.hogan@imgtec.com>
Subject: [PATCH v2 34/44] metag: Various other headers
Date: Wed, 5 Dec 2012 16:08:52 +0000
Message-ID: <1354723742-6195-35-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com>
References: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2012_12_05_16_09_35
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the remaining metag header files:
 - byteorder.h, swab.h (byte order and swapping)
 - barrier.h, cpu.h. hwthread.h, processor.h (hardware thread related)
 - bug.h, elf.h, gpio.h, linkage.h, resource.h (other)

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 arch/metag/include/asm/barrier.h        |   85 +++++++++++++
 arch/metag/include/asm/bug.h            |   12 ++
 arch/metag/include/asm/cpu.h            |   14 ++
 arch/metag/include/asm/elf.h            |  128 +++++++++++++++++++
 arch/metag/include/asm/gpio.h           |    4 +
 arch/metag/include/asm/hwthread.h       |   40 ++++++
 arch/metag/include/asm/linkage.h        |    7 +
 arch/metag/include/asm/processor.h      |  204 +++++++++++++++++++++++++++++++
 arch/metag/include/uapi/asm/byteorder.h |    1 +
 arch/metag/include/uapi/asm/resource.h  |    7 +
 arch/metag/include/uapi/asm/swab.h      |   26 ++++
 11 files changed, 528 insertions(+), 0 deletions(-)
 create mode 100644 arch/metag/include/asm/barrier.h
 create mode 100644 arch/metag/include/asm/bug.h
 create mode 100644 arch/metag/include/asm/cpu.h
 create mode 100644 arch/metag/include/asm/elf.h
 create mode 100644 arch/metag/include/asm/gpio.h
 create mode 100644 arch/metag/include/asm/hwthread.h
 create mode 100644 arch/metag/include/asm/linkage.h
 create mode 100644 arch/metag/include/asm/processor.h
 create mode 100644 arch/metag/include/uapi/asm/byteorder.h
 create mode 100644 arch/metag/include/uapi/asm/resource.h
 create mode 100644 arch/metag/include/uapi/asm/swab.h

diff --git a/arch/metag/include/asm/barrier.h b/arch/metag/include/asm/barrier.h
new file mode 100644
index 0000000..8794fca
--- /dev/null
+++ b/arch/metag/include/asm/barrier.h
@@ -0,0 +1,85 @@
+#ifndef _ASM_METAG_BARRIER_H
+#define _ASM_METAG_BARRIER_H
+
+#include <asm/metag_mem.h>
+
+#define nop()		__asm__ __volatile__ ("NOP")
+#define mb()		wmb()
+#define rmb()		barrier()
+
+#ifdef CONFIG_METAG_META21
+
+/* HTP and above have a system event to fence writes */
+static inline void wr_fence(void)
+{
+	volatile int *flushptr = (volatile int *) LINSYSEVENT_WR_FENCE;
+	barrier();
+	*flushptr = 0;
+}
+
+#else /* CONFIG_METAG_META21 */
+
+/*
+ * ATP doesn't have system event to fence writes, so it is necessary to flush
+ * the processor write queues as well as possibly the write combiner (depending
+ * on the page being written).
+ * To ensure the write queues are flushed we do 4 writes to a system event
+ * register (in this case write combiner flush) which will also flush the write
+ * combiner.
+ */
+static inline void wr_fence(void)
+{
+	volatile int *flushptr = (volatile int *) LINSYSEVENT_WR_COMBINE_FLUSH;
+	barrier();
+	*flushptr = 0;
+	*flushptr = 0;
+	*flushptr = 0;
+	*flushptr = 0;
+}
+
+#endif /* !CONFIG_METAG_META21 */
+
+static inline void wmb(void)
+{
+	/* flush writes through the write combiner */
+	wr_fence();
+}
+
+#define read_barrier_depends()  do { } while (0)
+
+#ifndef CONFIG_SMP
+#define fence()		do { } while (0)
+#define smp_mb()        barrier()
+#define smp_rmb()       barrier()
+#define smp_wmb()       barrier()
+#else
+
+#ifdef CONFIG_METAG_SMP_WRITE_REORDERING
+/*
+ * Write to the atomic memory unlock system event register (command 0). This is
+ * needed before a write to shared memory in a critical section, to prevent
+ * external reordering of writes before the fence on other threads with writes
+ * after the fence on this thread (and to prevent the ensuing cache-memory
+ * incoherence). It is therefore ineffective if used after and on the same
+ * thread as a write.
+ */
+static inline void fence(void)
+{
+	volatile int *flushptr = (volatile int *) LINSYSEVENT_WR_ATOMIC_UNLOCK;
+	barrier();
+	*flushptr = 0;
+}
+#define smp_mb()        fence()
+#define smp_rmb()       fence()
+#define smp_wmb()       barrier()
+#else
+#define fence()		do { } while (0)
+#define smp_mb()        barrier()
+#define smp_rmb()       barrier()
+#define smp_wmb()       barrier()
+#endif
+#endif
+#define smp_read_barrier_depends()     do { } while (0)
+#define set_mb(var, value) do { var = value; smp_mb(); } while (0)
+
+#endif /* _ASM_METAG_BARRIER_H */
diff --git a/arch/metag/include/asm/bug.h b/arch/metag/include/asm/bug.h
new file mode 100644
index 0000000..d04b48c
--- /dev/null
+++ b/arch/metag/include/asm/bug.h
@@ -0,0 +1,12 @@
+#ifndef _ASM_METAG_BUG_H
+#define _ASM_METAG_BUG_H
+
+#include <asm-generic/bug.h>
+
+struct pt_regs;
+
+extern const char *trap_name(int trapno);
+extern void die(const char *str, struct pt_regs *regs, long err,
+		unsigned long addr) __attribute__ ((noreturn));
+
+#endif
diff --git a/arch/metag/include/asm/cpu.h b/arch/metag/include/asm/cpu.h
new file mode 100644
index 0000000..decf129
--- /dev/null
+++ b/arch/metag/include/asm/cpu.h
@@ -0,0 +1,14 @@
+#ifndef _ASM_METAG_CPU_H
+#define _ASM_METAG_CPU_H
+
+#include <linux/percpu.h>
+
+struct cpuinfo_metag {
+	struct cpu cpu;
+#ifdef CONFIG_SMP
+	unsigned long loops_per_jiffy;
+#endif
+};
+
+DECLARE_PER_CPU(struct cpuinfo_metag, cpu_data);
+#endif /* _ASM_METAG_CPU_H */
diff --git a/arch/metag/include/asm/elf.h b/arch/metag/include/asm/elf.h
new file mode 100644
index 0000000..d63b9d0
--- /dev/null
+++ b/arch/metag/include/asm/elf.h
@@ -0,0 +1,128 @@
+#ifndef __ASM_METAG_ELF_H
+#define __ASM_METAG_ELF_H
+
+#define EM_METAG      174
+
+/* Meta relocations */
+#define R_METAG_HIADDR16                 0
+#define R_METAG_LOADDR16                 1
+#define R_METAG_ADDR32                   2
+#define R_METAG_NONE                     3
+#define R_METAG_RELBRANCH                4
+#define R_METAG_GETSETOFF                5
+
+/* Backward compatability */
+#define R_METAG_REG32OP1                 6
+#define R_METAG_REG32OP2                 7
+#define R_METAG_REG32OP3                 8
+#define R_METAG_REG16OP1                 9
+#define R_METAG_REG16OP2                10
+#define R_METAG_REG16OP3                11
+#define R_METAG_REG32OP4                12
+
+#define R_METAG_HIOG                    13
+#define R_METAG_LOOG                    14
+
+/* GNU */
+#define R_METAG_GNU_VTINHERIT           30
+#define R_METAG_GNU_VTENTRY             31
+
+/* PIC relocations */
+#define R_METAG_HI16_GOTOFF             32
+#define R_METAG_LO16_GOTOFF             33
+#define R_METAG_GETSET_GOTOFF           34
+#define R_METAG_GETSET_GOT              35
+#define R_METAG_HI16_GOTPC              36
+#define R_METAG_LO16_GOTPC              37
+#define R_METAG_HI16_PLT                38
+#define R_METAG_LO16_PLT                39
+#define R_METAG_RELBRANCH_PLT           40
+#define R_METAG_GOTOFF                  41
+#define R_METAG_PLT                     42
+#define R_METAG_COPY                    43
+#define R_METAG_JMP_SLOT                44
+#define R_METAG_RELATIVE                45
+#define R_METAG_GLOB_DAT                46
+
+/*
+ * ELF register definitions.
+ */
+
+#include <asm/page.h>
+#include <asm/processor.h>
+#include <asm/ptrace.h>
+#include <asm/user.h>
+
+typedef unsigned long elf_greg_t;
+
+#define ELF_NGREG (sizeof(struct user_gp_regs) / sizeof(elf_greg_t))
+typedef elf_greg_t elf_gregset_t[ELF_NGREG];
+
+typedef unsigned long elf_fpregset_t;
+
+/*
+ * This is used to ensure we don't load something for the wrong architecture.
+ */
+#define elf_check_arch(x) ((x)->e_machine == EM_METAG)
+
+/*
+ * These are used to set parameters in the core dumps.
+ */
+#define ELF_CLASS	ELFCLASS32
+#define ELF_DATA	ELFDATA2LSB
+#define ELF_ARCH	EM_METAG
+
+#define ELF_PLAT_INIT(_r, load_addr)	\
+	do { _r->ctx.AX[0].U0 = 0; } while (0)
+
+#define USE_ELF_CORE_DUMP
+#define CORE_DUMP_USE_REGSET
+#define ELF_EXEC_PAGESIZE	PAGE_SIZE
+
+/* This is the location that an ET_DYN program is loaded if exec'ed.  Typical
+   use of this is to invoke "./ld.so someprog" to test out a new version of
+   the loader.  We need to make sure that it is out of the way of the program
+   that it will "exec", and that there is sufficient room for the brk.  */
+
+#define ELF_ET_DYN_BASE         0x08000000UL
+
+#define ELF_CORE_COPY_REGS(_dest, _regs)			\
+	memcpy((char *)&_dest, (char *)_regs, sizeof(struct pt_regs));
+
+/* This yields a mask that user programs can use to figure out what
+   instruction set this cpu supports.  */
+
+#define ELF_HWCAP	(0)
+
+/* This yields a string that ld.so will use to load implementation
+   specific libraries for optimization.  This is more specific in
+   intent than poking at uname or /proc/cpuinfo.  */
+
+#define ELF_PLATFORM  (NULL)
+
+#define SET_PERSONALITY(ex) \
+	set_personality(PER_LINUX | (current->personality & (~PER_MASK)))
+
+#define STACK_RND_MASK (0)
+
+#ifdef CONFIG_METAG_USER_TCM
+
+struct elf32_phdr;
+struct file;
+
+unsigned long __metag_elf_map(struct file *filep, unsigned long addr,
+			      struct elf32_phdr *eppnt, int prot, int type,
+			      unsigned long total_size);
+
+static inline unsigned long metag_elf_map(struct file *filep,
+					  unsigned long addr,
+					  struct elf32_phdr *eppnt, int prot,
+					  int type, unsigned long total_size)
+{
+	return __metag_elf_map(filep, addr, eppnt, prot, type, total_size);
+}
+#define elf_map metag_elf_map
+
+#endif
+
+#endif
diff --git a/arch/metag/include/asm/gpio.h b/arch/metag/include/asm/gpio.h
new file mode 100644
index 0000000..b3799d8
--- /dev/null
+++ b/arch/metag/include/asm/gpio.h
@@ -0,0 +1,4 @@
+#ifndef __LINUX_GPIO_H
+#warning Include linux/gpio.h instead of asm/gpio.h
+#include <linux/gpio.h>
+#endif
diff --git a/arch/metag/include/asm/hwthread.h b/arch/metag/include/asm/hwthread.h
new file mode 100644
index 0000000..8f97866
--- /dev/null
+++ b/arch/metag/include/asm/hwthread.h
@@ -0,0 +1,40 @@
+/*
+ * Copyright (C) 2008 Imagination Technologies
+ */
+#ifndef __METAG_HWTHREAD_H
+#define __METAG_HWTHREAD_H
+
+#include <linux/bug.h>
+#include <linux/io.h>
+
+#include <asm/metag_mem.h>
+
+#define BAD_HWTHREAD_ID		(0xFFU)
+#define BAD_CPU_ID		(0xFFU)
+
+extern u8 cpu_2_hwthread_id[];
+extern u8 hwthread_id_2_cpu[];
+
+/*
+ * Each hardware thread's Control Unit registers are memory-mapped
+ * and can therefore be accessed by any other hardware thread.
+ *
+ * This helper function returns the memory address where "thread"'s
+ * register "regnum" is mapped.
+ */
+static inline
+void __iomem *__CU_addr(unsigned int thread, unsigned int regnum)
+{
+	unsigned int base, thread_offset, thread_regnum;
+
+	WARN_ON(thread == BAD_HWTHREAD_ID);
+
+	base = T0UCTREG0;	/* Control unit base */
+
+	thread_offset = TnUCTRX_STRIDE * thread;
+	thread_regnum = TXUCTREGn_STRIDE * regnum;
+
+	return (void __iomem *)(base + thread_offset + thread_regnum);
+}
+
+#endif /* __METAG_HWTHREAD_H */
diff --git a/arch/metag/include/asm/linkage.h b/arch/metag/include/asm/linkage.h
new file mode 100644
index 0000000..73bf25b
--- /dev/null
+++ b/arch/metag/include/asm/linkage.h
@@ -0,0 +1,7 @@
+#ifndef __ASM_LINKAGE_H
+#define __ASM_LINKAGE_H
+
+#define __ALIGN .p2align 2
+#define __ALIGN_STR ".p2align 2"
+
+#endif
diff --git a/arch/metag/include/asm/processor.h b/arch/metag/include/asm/processor.h
new file mode 100644
index 0000000..b7d3053
--- /dev/null
+++ b/arch/metag/include/asm/processor.h
@@ -0,0 +1,204 @@
+/*
+ * Copyright (C) 2005,2006,2007,2008 Imagination Technologies
+ */
+
+#ifndef __ASM_METAG_PROCESSOR_H
+#define __ASM_METAG_PROCESSOR_H
+
+#include <linux/atomic.h>
+
+#include <asm/page.h>
+#include <asm/ptrace.h>
+#include <asm/metag_regs.h>
+
+/*
+ * Default implementation of macro that returns current
+ * instruction pointer ("program counter").
+ */
+#define current_text_addr() ({ __label__ _l; _l: &&_l; })
+
+/* The task stops where the kernel starts */
+#define TASK_SIZE	PAGE_OFFSET
+/* Add an extra page of padding at the top of the stack for the guard page. */
+#define STACK_TOP	(TASK_SIZE - PAGE_SIZE)
+#define STACK_TOP_MAX	STACK_TOP
+
+/* This decides where the kernel will search for a free chunk of vm
+ * space during mmap's.
+ */
+#define TASK_UNMAPPED_BASE	META_MEMORY_BASE
+
+typedef struct {
+	unsigned long seg;
+} mm_segment_t;
+
+#ifdef CONFIG_METAG_FPU
+struct meta_fpu_context {
+	TBICTXEXTFPU fpstate;
+	union {
+		struct {
+			TBICTXEXTBB4 fx8_15;
+			TBICTXEXTFPACC fpacc;
+		} fx8_15;
+		struct {
+			TBICTXEXTFPACC fpacc;
+			TBICTXEXTBB4 unused;
+		} nofx8_15;
+	} extfpstate;
+	bool needs_restore;
+};
+#else
+struct meta_fpu_context {};
+#endif
+
+#ifdef CONFIG_METAG_DSP
+struct meta_ext_context {
+	struct {
+		TBIEXTCTX ctx;
+		TBICTXEXTBB8 bb8;
+		TBIDUAL ax[TBICTXEXTAXX_BYTES / sizeof(TBIDUAL)];
+		TBICTXEXTHL2 hl2;
+		TBICTXEXTTDPR ext;
+		TBICTXEXTRP6 rp;
+	} regs;
+
+	/* DSPRAM A and B save areas. */
+	void *ram[2];
+
+	/* ECH encoded size of DSPRAM save areas. */
+	unsigned int ram_sz[2];
+};
+#else
+struct meta_ext_context {};
+#endif
+
+struct thread_struct {
+	PTBICTX kernel_context;
+	/* A copy of the user process Sig.SaveMask. */
+	unsigned int user_flags;
+	struct meta_fpu_context *fpu_context;
+	void __user *tls_ptr;
+	unsigned short int_depth;
+	unsigned short txdefr_failure;
+	struct meta_ext_context *dsp_context;
+};
+
+#define INIT_THREAD  { \
+	NULL,			/* kernel_context */	\
+	0,			/* user_flags */	\
+	NULL,			/* fpu_context */	\
+	NULL,			/* tls_ptr */		\
+	1,			/* int_depth - we start in kernel */	\
+	0,			/* txdefr_failure */	\
+	NULL,			/* dsp_context */	\
+}
+
+/* Needed to make #define as we are referencing 'current', that is not visible
+ * yet.
+ *
+ * Stack layout is as below.
+
+      argc            argument counter (integer)
+      argv[0]         program name (pointer)
+      argv[1...N]     program args (pointers)
+      argv[argc-1]    end of args (integer)
+      NULL
+      env[0...N]      environment variables (pointers)
+      NULL
+
+ */
+#define start_thread(regs, pc, usp) do {				   \
+	unsigned int *argc = (unsigned int *) bprm->exec;		   \
+	set_fs(USER_DS);						   \
+	current->thread.int_depth = 1;					   \
+	/* Force this process down to user land */			   \
+	regs->ctx.SaveMask = TBICTX_PRIV_BIT;				   \
+	regs->ctx.CurrPC = pc;						   \
+	regs->ctx.AX[0].U0 = usp;					   \
+	regs->ctx.DX[3].U1 = *((int *)argc);			/* argc */ \
+	regs->ctx.DX[3].U0 = (int)((int *)argc + 1);		/* argv */ \
+	regs->ctx.DX[2].U1 = (int)((int *)argc +			   \
+				   regs->ctx.DX[3].U1 + 2);	/* envp */ \
+	regs->ctx.DX[2].U0 = 0;				   /* rtld_fini */ \
+} while (0)
+
+/* Forward declaration, a strange C thing */
+struct task_struct;
+
+/* Free all resources held by a thread. */
+static inline void release_thread(struct task_struct *dead_task)
+{
+}
+
+#define copy_segments(tsk, mm)		do { } while (0)
+#define release_segments(mm)		do { } while (0)
+
+extern void exit_thread(void);
+
+/*
+ * Return saved PC of a blocked thread.
+ */
+#define	thread_saved_pc(tsk)	\
+	((unsigned long)(tsk)->thread.kernel_context->CurrPC)
+#define thread_saved_sp(tsk)	\
+	((unsigned long)(tsk)->thread.kernel_context->AX[0].U0)
+#define thread_saved_fp(tsk)	\
+	((unsigned long)(tsk)->thread.kernel_context->AX[1].U0)
+
+unsigned long get_wchan(struct task_struct *p);
+
+#define	KSTK_EIP(tsk)	((tsk)->thread.kernel_context->CurrPC)
+#define	KSTK_ESP(tsk)	((tsk)->thread.kernel_context->AX[0].U0)
+
+#define user_stack_pointer(regs)        ((regs)->ctx.AX[0].U0)
+
+int kernel_thread(int (*fn) (void *), void *arg, unsigned long flags);
+
+#define cpu_relax()     barrier()
+
+extern void setup_txprivext(void);
+
+static inline unsigned int hard_processor_id(void)
+{
+	unsigned int id;
+
+	__asm__ __volatile__(
+			    "MOV	%0, TXENABLE\n"
+			    "AND	%0, %0, %1\n"
+			    "LSR	%0, %0, %2\n"
+			    : "=&d" (id)
+			    : "I" (TXENABLE_THREAD_BITS),
+			      "K" (TXENABLE_THREAD_S)
+	);
+
+	return id;
+}
+
+#define OP3_EXIT	0
+
+#define HALT_OK		0
+#define HALT_PANIC	-1
+
+/*
+ * Halt (stop) the hardware thread. This instruction sequence is the
+ * standard way to cause a Meta hardware thread to exit. The exit code
+ * is pushed onto the stack which is interpreted by the debug adapter.
+ */
+static inline void hard_processor_halt(int exit_code)
+{
+	__asm__ __volatile__("MOV	D1Ar1, %0\n"
+			     "MOV	D0Ar6, %1\n"
+			     "MSETL	[A0StP],D0Ar6,D0Ar4,D0Ar2\n"
+			     "1: SWITCH	#0xC30006\n"
+			     "B		1b\n"
+			     : : "r" (exit_code), "K" (OP3_EXIT));
+}
+
+/* Set these hooks to call SoC specific code to restart/halt/power off. */
+extern void (*soc_restart)(char *cmd);
+extern void (*soc_halt)(void);
+
+extern void show_trace(struct task_struct *tsk, unsigned long *sp,
+		       struct pt_regs *regs);
+
+#endif
diff --git a/arch/metag/include/uapi/asm/byteorder.h b/arch/metag/include/uapi/asm/byteorder.h
new file mode 100644
index 0000000..9558416
--- /dev/null
+++ b/arch/metag/include/uapi/asm/byteorder.h
@@ -0,0 +1 @@
+#include <linux/byteorder/little_endian.h>
diff --git a/arch/metag/include/uapi/asm/resource.h b/arch/metag/include/uapi/asm/resource.h
new file mode 100644
index 0000000..526d23c
--- /dev/null
+++ b/arch/metag/include/uapi/asm/resource.h
@@ -0,0 +1,7 @@
+#ifndef _UAPI_METAG_RESOURCE_H
+#define _UAPI_METAG_RESOURCE_H
+
+#define _STK_LIM_MAX    (1 << 28)
+#include <asm-generic/resource.h>
+
+#endif /* _UAPI_METAG_RESOURCE_H */
diff --git a/arch/metag/include/uapi/asm/swab.h b/arch/metag/include/uapi/asm/swab.h
new file mode 100644
index 0000000..1076b3a
--- /dev/null
+++ b/arch/metag/include/uapi/asm/swab.h
@@ -0,0 +1,26 @@
+#ifndef __ASM_METAG_SWAB_H
+#define __ASM_METAG_SWAB_H
+
+#include <linux/compiler.h>
+#include <linux/types.h>
+#include <asm-generic/swab.h>
+
+static inline __attribute_const__ __u16 __arch_swab16(__u16 x)
+{
+	return __builtin_metag_bswaps(x);
+}
+#define __arch_swab16 __arch_swab16
+
+static inline __attribute_const__ __u32 __arch_swab32(__u32 x)
+{
+	return __builtin_metag_bswap(x);
+}
+#define __arch_swab32 __arch_swab32
+
+static inline __attribute_const__ __u64 __arch_swab64(__u64 x)
+{
+	return __builtin_metag_bswapll(x);
+}
+#define __arch_swab64 __arch_swab64
+
+#endif /* __ASM_METAG_SWAB_H */
-- 
1.7.7.6


