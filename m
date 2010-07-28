Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561Ab0G1Jcs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 05:32:48 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53612 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754513Ab0G1Jcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 05:32:45 -0400
From: Michal Simek <monstr@monstr.eu>
To: monstr@monstr.eu
Cc: Jason Wessel <jason.wessel@windriver.com>,
        John Williams <john.williams@petalogix.com>,
        "Edgar E. Iglesias" <edgar.iglesias@petalogix.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] microblaze: Add KGDB support
Date: Wed, 28 Jul 2010 11:29:13 +0200
Message-Id: <1280309353-9172-2-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1280309353-9172-1-git-send-email-monstr@monstr.eu>
References: <1280309353-9172-1-git-send-email-monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kgdb uses brki r16, 0x18 instruction to call
low level _debug_exception function which save
current state to pt_regs and call microblaze_kgdb_break
function. _debug_exception should be called only from
the kernel space. User space calling is not supported
because user application debugging uses different handling.

pt_regs_to_gdb_regs loads additional special registers
which can't be changed

 * Enable KGDB in Kconfig
 * Remove ancient not-tested KGDB support
 * Remove ancient _debug_exception code from entry.S

Only MMU KGDB support is supported.

Signed-off-by: Michal Simek <monstr@monstr.eu>
CC: Jason Wessel <jason.wessel@windriver.com>
CC: John Williams <john.williams@petalogix.com>
CC: Edgar E. Iglesias <edgar.iglesias@petalogix.com>
CC: linux-kernel@vger.kernel.org
---
 arch/microblaze/Kconfig                  |    1 +
 arch/microblaze/include/asm/exceptions.h |   16 --
 arch/microblaze/include/asm/kgdb.h       |   28 ++++
 arch/microblaze/kernel/Makefile          |    1 +
 arch/microblaze/kernel/entry.S           |  226 ++++++++++++------------------
 arch/microblaze/kernel/exceptions.c      |    1 -
 arch/microblaze/kernel/kgdb.c            |  149 ++++++++++++++++++++
 arch/microblaze/mm/fault.c               |   15 --
 8 files changed, 272 insertions(+), 165 deletions(-)
 create mode 100644 arch/microblaze/include/asm/kgdb.h
 create mode 100644 arch/microblaze/kernel/kgdb.c

diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
index a517421..be38552 100644
--- a/arch/microblaze/Kconfig
+++ b/arch/microblaze/Kconfig
@@ -14,6 +14,7 @@ config MICROBLAZE
 	select USB_ARCH_HAS_EHCI
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select HAVE_OPROFILE
+	select HAVE_ARCH_KGDB
 	select HAVE_DMA_ATTRS
 	select HAVE_DMA_API_DEBUG
 	select TRACING_SUPPORT
diff --git a/arch/microblaze/include/asm/exceptions.h b/arch/microblaze/include/asm/exceptions.h
index fa0e366..6479097 100644
--- a/arch/microblaze/include/asm/exceptions.h
+++ b/arch/microblaze/include/asm/exceptions.h
@@ -69,22 +69,6 @@ asmlinkage void full_exception(struct pt_regs *regs, unsigned int type,
 void die(const char *str, struct pt_regs *fp, long err);
 void _exception(int signr, struct pt_regs *regs, int code, unsigned long addr);
 
-#if defined(CONFIG_KGDB)
-void (*debugger)(struct pt_regs *regs);
-int (*debugger_bpt)(struct pt_regs *regs);
-int (*debugger_sstep)(struct pt_regs *regs);
-int (*debugger_iabr_match)(struct pt_regs *regs);
-int (*debugger_dabr_match)(struct pt_regs *regs);
-void (*debugger_fault_handler)(struct pt_regs *regs);
-#else
-#define debugger(regs)			do { } while (0)
-#define debugger_bpt(regs)		0
-#define debugger_sstep(regs)		0
-#define debugger_iabr_match(regs)	0
-#define debugger_dabr_match(regs)	0
-#define debugger_fault_handler		((void (*)(struct pt_regs *))0)
-#endif
-
 #endif /*__ASSEMBLY__ */
 #endif /* __KERNEL__ */
 #endif /* _ASM_MICROBLAZE_EXCEPTIONS_H */
diff --git a/arch/microblaze/include/asm/kgdb.h b/arch/microblaze/include/asm/kgdb.h
new file mode 100644
index 0000000..78b17d4
--- /dev/null
+++ b/arch/microblaze/include/asm/kgdb.h
@@ -0,0 +1,28 @@
+#ifdef __KERNEL__
+#ifndef __MICROBLAZE_KGDB_H__
+#define __MICROBLAZE_KGDB_H__
+
+#ifndef __ASSEMBLY__
+
+#define CACHE_FLUSH_IS_SAFE	1
+#define BUFMAX			2048
+
+/*
+ * 32 32-bit general purpose registers (r0-r31)
+ *  6 32-bit special registers (pc, msr, ear, esr, fsr, btr)
+ * 12 32-bit PVR
+ *   7 32-bit MMU Regs (redr, rpid, rzpr, rtlbx, rtlbsx, rtlblo, rtlbhi)
+ * ------
+ *  57 registers
+ */
+#define NUMREGBYTES	(57 * 4)
+
+#define BREAK_INSTR_SIZE	4
+static inline void arch_kgdb_breakpoint(void)
+{
+	__asm__ __volatile__("brki r16, 0x18;");
+}
+
+#endif /* __ASSEMBLY__ */
+#endif /* __MICROBLAZE_KGDB_H__ */
+#endif /* __KERNEL__ */
diff --git a/arch/microblaze/kernel/Makefile b/arch/microblaze/kernel/Makefile
index d66ddef..5eecc9f 100644
--- a/arch/microblaze/kernel/Makefile
+++ b/arch/microblaze/kernel/Makefile
@@ -28,5 +28,6 @@ obj-$(CONFIG_MODULES)		+= microblaze_ksyms.o module.o
 obj-$(CONFIG_MMU)		+= misc.o
 obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
 obj-$(CONFIG_FUNCTION_TRACER)	+= ftrace.o mcount.o
+obj-$(CONFIG_KGDB)		+= kgdb.o
 
 obj-y	+= entry$(MMU).o
diff --git a/arch/microblaze/kernel/entry.S b/arch/microblaze/kernel/entry.S
index 7a19d89..b5f0765 100644
--- a/arch/microblaze/kernel/entry.S
+++ b/arch/microblaze/kernel/entry.S
@@ -868,140 +868,112 @@ IRQ_return: /* MS: Make global symbol for debugging */
 	nop
 
 /*
- * `Debug' trap
- *  We enter dbtrap in "BIP" (breakpoint) mode.
- *  So we exit the breakpoint mode with an 'rtbd' and proceed with the
- *  original dbtrap.
- *  however, wait to save state first
+ * Debug trap for KGDB. Enter to _debug_exception by brki r16, 0x18
+ * and call handling function with saved pt_regs
  */
 C_ENTRY(_debug_exception):
+#ifdef CONFIG_KGDB
 	/* BIP bit is set on entry, no interrupts can occur */
-	swi	r1, r0, TOPHYS(PER_CPU(ENTRY_SP))
-
-	swi	r11, r0, TOPHYS(r0_ram + PTO + PT_R11); /* Save r11 */
-	set_bip;	/*equalize initial state for all possible entries*/
-	clear_eip;
-	enable_irq;
-	lwi	r11, r0, TOPHYS(PER_CPU(KM));/* See if already in kernel mode.*/
-	beqi	r11, 1f;		/* Jump ahead if coming from user */
-	/* Kernel-mode state save.  */
-	lwi	r11, r0, TOPHYS(PER_CPU(ENTRY_SP)); /* Reload kernel stack-ptr*/
-	tophys(r1,r11);
-	swi	r11, r1, (PT_R1-PT_SIZE); /* Save original SP. */
-	lwi	r11, r0, TOPHYS(r0_ram + PTO + PT_R11); /* restore r11 */
-
-	addik	r1, r1, -STATE_SAVE_SIZE; /* Make room on the stack.  */
-	swi	r3, r1, PTO + PT_R3;
-	swi	r4, r1, PTO + PT_R4;
-	SAVE_REGS;
-
-	addi	r11, r0, 1; 		/* Was in kernel-mode.  */
-	swi	r11, r1, PTO + PT_MODE;
-	brid	2f;
-	nop;				/* Fill delay slot */
-1:      /* User-mode state save.  */
-	lwi	r11, r0, TOPHYS(r0_ram + PTO + PT_R11); /* restore r11 */
-	lwi	r1, r0, TOPHYS(PER_CPU(CURRENT_SAVE)); /* get saved current */
-	tophys(r1,r1);
-	lwi	r1, r1, TS_THREAD_INFO;	/* get the thread info */
-	addik	r1, r1, THREAD_SIZE;	/* calculate kernel stack pointer */
-	tophys(r1,r1);
-
-	addik	r1, r1, -STATE_SAVE_SIZE; /* Make room on the stack.  */
-	swi	r3, r1, PTO + PT_R3;
-	swi	r4, r1, PTO + PT_R4;
-	SAVE_REGS;
+	addik   r1, r1, CONFIG_KERNEL_BASE_ADDR - CONFIG_KERNEL_START - STATE_SAVE_SIZE;
+	/* save all regs to pt_reg structure */
+	swi	r0, r1, PTO+PT_R0;	/* R0 must be saved too */
+	swi	r2, r1, PTO+PT_R2;
+	swi	r3, r1, PTO+PT_R3;
+	swi	r4, r1, PTO+PT_R4;
+	swi	r5, r1, PTO+PT_R5;
+	swi	r6, r1, PTO+PT_R6;
+	swi	r7, r1, PTO+PT_R7;
+	swi	r8, r1, PTO+PT_R8;
+	swi	r9, r1, PTO+PT_R9;
+	swi	r10, r1, PTO+PT_R10;
+	swi	r11, r1, PTO+PT_R11;
+	swi	r12, r1, PTO+PT_R12;
+	swi	r13, r1, PTO+PT_R13;
+	swi	r14, r1, PTO+PT_R14
+	swi	r15, r1, PTO+PT_R15;
+	swi	r16, r1, PTO+PT_R16
+	swi	r16, r1, PTO+PT_PC; /* PC and r16 are the same */
+	swi	r17, r1, PTO+PT_R17
+	swi	r18, r1, PTO+PT_R18;
+	swi	r19, r1, PTO+PT_R19;
+	swi	r20, r1, PTO+PT_R20;
+	swi	r21, r1, PTO+PT_R21;
+	swi	r22, r1, PTO+PT_R22;
+	swi	r23, r1, PTO+PT_R23;
+	swi	r24, r1, PTO+PT_R24;
+	swi	r25, r1, PTO+PT_R25;
+	swi	r26, r1, PTO+PT_R26;
+	swi	r27, r1, PTO+PT_R27;
+	swi	r28, r1, PTO+PT_R28;
+	swi	r29, r1, PTO+PT_R29;
+	swi	r30, r1, PTO+PT_R30;
+	swi	r31, r1, PTO+PT_R31;	/* Save current task reg */
+	/* save special purpose registers to pt_regs */
+	mfs	r11, rmsr;
+	swi	r11, r1, PTO+PT_MSR;
+	mfs	r11, rear;
+	swi	r11, r1, PTO+PT_EAR;
+	mfs	r11, resr;
+	swi	r11, r1, PTO+PT_ESR;
+	mfs	r11, rfsr;
+	swi	r11, r1, PTO+PT_FSR;
+
+	/* stack pointer is in physical address at it is decrease
+	 * by STATE_SAVE_SIZE but we need to get correct R1 value */
+	addik   r11, r1, CONFIG_KERNEL_START - CONFIG_KERNEL_BASE_ADDR + STATE_SAVE_SIZE;
+	swi	r11, r1, PTO+PT_R1
 
-	swi	r0, r1, PTO+PT_MODE; /* Was in user-mode.  */
-	lwi	r11, r0, TOPHYS(PER_CPU(ENTRY_SP));
-	swi	r11, r1, PTO+PT_R1; /* Store user SP.  */
-	addi	r11, r0, 1;
-	swi	r11, r0, TOPHYS(PER_CPU(KM));	/* Now we're in kernel-mode.  */
-2:	lwi	CURRENT_TASK, r0, TOPHYS(PER_CPU(CURRENT_SAVE));
-	/* Save away the syscall number.  */
-	swi	r0, r1, PTO+PT_R0;
 	tovirt(r1,r1)
-
-	addi	r5, r0, SIGTRAP		     /* send the trap signal */
-	add	r6, r0, CURRENT_TASK; /* Get current task ptr into r11 */
-	addk	r7, r0, r0		     /* 3rd param zero */
-
-	set_vms;
-	la	r11, r0, send_sig;
-	la	r15, r0, dbtrap_call;
-dbtrap_call:	rtbd	r11, 0;
+	addi	r5, r1, PTO /* pass pt_reg address as the first arg */
+	la	r15, r0, dbtrap_call; /* return address */
+dbtrap_call:	rtbd	r0, microblaze_kgdb_break
 	nop;
 
 	set_bip;			/*  Ints masked for state restore*/
-	lwi	r11, r1, PTO+PT_MODE;
-	bnei	r11, 2f;
-
-	/* Get current task ptr into r11 */
-	lwi	r11, CURRENT_TASK, TS_THREAD_INFO;	/* get thread info */
-	lwi	r11, r11, TI_FLAGS;	/* get flags in thread info */
-	andi	r11, r11, _TIF_NEED_RESCHED;
-	beqi	r11, 5f;
-
-/* Call the scheduler before returning from a syscall/trap. */
-
-	bralid	r15, schedule;	/* Call scheduler */
-	nop;				/* delay slot */
-	/* XXX Is PT_DTRACE handling needed here? */
-	/* XXX m68knommu also checks TASK_STATE & TASK_COUNTER here.  */
-
-	/* Maybe handle a signal */
-5:	lwi	r11, CURRENT_TASK, TS_THREAD_INFO;	/* get thread info */
-	lwi	r11, r11, TI_FLAGS;	/* get flags in thread info */
-	andi	r11, r11, _TIF_SIGPENDING;
-	beqi	r11, 1f;		/* Signals to handle, handle them */
-
-/* Handle a signal return; Pending signals should be in r18.  */
-	/* Not all registers are saved by the normal trap/interrupt entry
-	   points (for instance, call-saved registers (because the normal
-	   C-compiler calling sequence in the kernel makes sure they're
-	   preserved), and call-clobbered registers in the case of
-	   traps), but signal handlers may want to examine or change the
-	   complete register state.  Here we save anything not saved by
-	   the normal entry sequence, so that it may be safely restored
-	   (in a possibly modified form) after do_signal returns.  */
-
-	la	r5, r1, PTO;		/* Arg 1: struct pt_regs *regs */
-	addi  r7, r0, 0;	/* Arg 3: int in_syscall */
-	bralid	r15, do_signal;	/* Handle any signals */
-	add	r6, r0, r0;		/* Arg 2: sigset_t *oldset */
-
-
-/* Finally, return to user state.  */
-1:	swi	r0, r0, PER_CPU(KM);	/* Now officially in user state. */
-	swi	CURRENT_TASK, r0, PER_CPU(CURRENT_SAVE); /* save current */
 	VM_OFF;
 	tophys(r1,r1);
-
-	lwi	r3, r1, PTO+PT_R3; /* restore saved r3, r4 registers */
-	lwi	r4, r1, PTO+PT_R4;
-	RESTORE_REGS
-	addik	r1, r1, STATE_SAVE_SIZE		/* Clean up stack space.  */
-
-
-	lwi	r1, r1, PT_R1 - PT_SIZE;
-					/* Restore user stack pointer. */
-	bri	6f;
-
-/* Return to kernel state.  */
-2:	VM_OFF;
-	tophys(r1,r1);
-	lwi	r3, r1, PTO+PT_R3; /* restore saved r3, r4 registers */
+	/* restore all regs */
+	lwi	r11, r1, PTO+PT_MSR;
+	mts	rmsr , r11;
+	nop;
+	lwi	r2, r1, PTO+PT_R2;
+	lwi	r3, r1, PTO+PT_R3;
 	lwi	r4, r1, PTO+PT_R4;
-	RESTORE_REGS
-	addik	r1, r1, STATE_SAVE_SIZE		/* Clean up stack space.  */
-
+	lwi	r5, r1, PTO+PT_R5;
+	lwi	r6, r1, PTO+PT_R6;
+	lwi	r7, r1, PTO+PT_R7;
+	lwi	r8, r1, PTO+PT_R8;
+	lwi	r9, r1, PTO+PT_R9;
+	lwi	r10, r1, PTO+PT_R10;
+	lwi	r11, r1, PTO+PT_R11;
+	lwi	r12, r1, PTO+PT_R12;
+	lwi	r13, r1, PTO+PT_R13;
+	lwi	r14, r1, PTO+PT_R14;
+	lwi	r15, r1, PTO+PT_R15;
+	lwi	r16, r1, PTO+PT_PC;
+	lwi	r17, r1, PTO+PT_R17;
+	lwi	r18, r1, PTO+PT_R18;
+	lwi	r19, r1, PTO+PT_R19;
+	lwi	r20, r1, PTO+PT_R20;
+	lwi	r21, r1, PTO+PT_R21;
+	lwi	r22, r1, PTO+PT_R22;
+	lwi	r23, r1, PTO+PT_R23;
+	lwi	r24, r1, PTO+PT_R24;
+	lwi	r25, r1, PTO+PT_R25;
+	lwi	r26, r1, PTO+PT_R26;
+	lwi	r27, r1, PTO+PT_R27;
+	lwi	r28, r1, PTO+PT_R28;
+	lwi	r29, r1, PTO+PT_R29;
+	lwi	r30, r1, PTO+PT_R30;
+	lwi	r31, r1, PTO+PT_R31;
+	addik	r1, r1, STATE_SAVE_SIZE		/* Clean up stack space */
 	tovirt(r1,r1);
-6:
 DBTRAP_return:		/* Make global symbol for debugging */
-	rtbd	r14, 0;	/* Instructions to return from an IRQ */
+	rtbd	r16, 0;	/* Instructions to return from an IRQ */
 	nop;
-
-
+#else
+	bri 0;
+#endif
 
 ENTRY(_switch_to)
 	/* prepare return value */
@@ -1096,15 +1068,6 @@ ENTRY(_switch_to)
 ENTRY(_reset)
 	brai	0x70; /* Jump back to FS-boot */
 
-ENTRY(_break)
-	mfs	r5, rmsr
-	nop
-	swi	r5, r0, 0x250 + TOPHYS(r0_ram)
-	mfs	r5, resr
-	nop
-	swi	r5, r0, 0x254 + TOPHYS(r0_ram)
-	bri	0
-
 	/* These are compiled and loaded into high memory, then
 	 * copied into place in mach_early_setup */
 	.section	.init.ivt, "ax"
@@ -1116,12 +1079,9 @@ ENTRY(_break)
 	nop
 	brai	TOPHYS(_user_exception); /* syscall handler */
 	brai	TOPHYS(_interrupt);	/* Interrupt handler */
-	brai	TOPHYS(_break);		/* nmi trap handler */
+	brai	TOPHYS(_debug_exception);	/* debug trap handler */
 	brai	TOPHYS(_hw_exception_handler);	/* HW exception handler */
 
-	.org	0x60
-	brai	TOPHYS(_debug_exception);	/* debug trap handler*/
-
 .section .rodata,"a"
 #include "syscall_table.S"
 
diff --git a/arch/microblaze/kernel/exceptions.c b/arch/microblaze/kernel/exceptions.c
index 02cbdfe..627ca54 100644
--- a/arch/microblaze/kernel/exceptions.c
+++ b/arch/microblaze/kernel/exceptions.c
@@ -53,7 +53,6 @@ void _exception(int signr, struct pt_regs *regs, int code, unsigned long addr)
 	siginfo_t info;
 
 	if (kernel_mode(regs)) {
-		debugger(regs);
 		die("Exception in kernel mode", regs, signr);
 	}
 	info.si_signo = signr;
diff --git a/arch/microblaze/kernel/kgdb.c b/arch/microblaze/kernel/kgdb.c
new file mode 100644
index 0000000..65c7c19
--- /dev/null
+++ b/arch/microblaze/kernel/kgdb.c
@@ -0,0 +1,149 @@
+/*
+ * Microblaze KGDB support
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#include <linux/kgdb.h>
+#include <linux/kdebug.h>
+#include <linux/irq.h>
+#include <linux/io.h>
+#include <asm/cacheflush.h>
+#include <asm/asm-offsets.h>
+#include <asm/pvr.h>
+
+#define GDB_REG		0
+#define GDB_PC		32
+#define GDB_MSR		33
+#define GDB_EAR		34
+#define GDB_ESR		35
+#define GDB_FSR		36
+#define GDB_BTR		37
+#define GDB_PVR		38
+#define GDB_REDR	50
+#define GDB_RPID	51
+#define GDB_RZPR	52
+#define GDB_RTLBX	53
+#define GDB_RTLBSX	54 /* mfs can't read it */
+#define GDB_RTLBLO	55
+#define GDB_RTLBHI	56
+
+/* keep pvr separately because it is unchangeble */
+struct pvr_s pvr;
+
+void pt_regs_to_gdb_regs(unsigned long *gdb_regs, struct pt_regs *regs)
+{
+	int i;
+	unsigned long *pt_regb = (unsigned long *)regs;
+	int temp;
+	/* registers r0 - r31, pc, msr, ear, esr, fsr + do not save pt_mode */
+	for (i = 0; i < (sizeof(struct pt_regs) / 4) - 1; i++)
+		gdb_regs[i] = pt_regb[i];
+
+	/* Branch target register can't be changed */
+	__asm__ __volatile__ ("mfs %0, rbtr;" : "=r"(temp) : );
+	gdb_regs[GDB_BTR] = temp;
+
+	/* pvr part  - we have 11 pvr regs */
+	for (i = 0; i < sizeof(struct pvr_s)/4; i++)
+		gdb_regs[GDB_PVR + i] = pvr.pvr[i];
+
+	/* read special registers - can't be changed */
+	__asm__ __volatile__ ("mfs %0, redr;" : "=r"(temp) : );
+	gdb_regs[GDB_REDR] = temp;
+	__asm__ __volatile__ ("mfs %0, rpid;" : "=r"(temp) : );
+	gdb_regs[GDB_RPID] = temp;
+	__asm__ __volatile__ ("mfs %0, rzpr;" : "=r"(temp) : );
+	gdb_regs[GDB_RZPR] = temp;
+	__asm__ __volatile__ ("mfs %0, rtlbx;" : "=r"(temp) : );
+	gdb_regs[GDB_RTLBX] = temp;
+	__asm__ __volatile__ ("mfs %0, rtlblo;" : "=r"(temp) : );
+	gdb_regs[GDB_RTLBLO] = temp;
+	__asm__ __volatile__ ("mfs %0, rtlbhi;" : "=r"(temp) : );
+	gdb_regs[GDB_RTLBHI] = temp;
+}
+
+void gdb_regs_to_pt_regs(unsigned long *gdb_regs, struct pt_regs *regs)
+{
+	int i;
+	unsigned long *pt_regb = (unsigned long *)regs;
+
+	/* pt_regs and gdb_regs have the same 37 values.
+	 * The rest of gdb_regs are unused and can't be changed. */
+	for (i = 0; i < (sizeof(struct pt_regs) / 4) - 1; i++)
+		pt_regb[i] = gdb_regs[i];
+}
+
+void microblaze_kgdb_break(struct pt_regs *regs)
+{
+	kgdb_handle_exception(1, SIGTRAP, 0, regs);
+
+	/* Jump over the first arch_kgdb_breakpoint which is barrier to
+	 * get kgdb work. The same solution is used for powerpc */
+	if (*(u32 *) (regs->pc) == *(u32 *) (&arch_kgdb_ops.gdb_bpt_instr))
+		regs->pc += BREAK_INSTR_SIZE;
+}
+
+/* untested */
+void sleeping_thread_to_gdb_regs(unsigned long *gdb_regs, struct task_struct *p)
+{
+	int i;
+	unsigned long *pt_regb = (unsigned long *)(p->thread.regs);
+
+	/* registers r0 - r31, pc, msr, ear, esr, fsr + do not save pt_mode */
+	for (i = 0; i < (sizeof(struct pt_regs) / 4) - 1; i++)
+		gdb_regs[i] = pt_regb[i];
+
+	/* pvr part  - we have 11 pvr regs */
+	for (i = 0; i < sizeof(struct pvr_s)/4; i++)
+		gdb_regs[GDB_PVR + i] = pvr.pvr[i];
+}
+
+void kgdb_arch_set_pc(struct pt_regs *regs, unsigned long ip)
+{
+	regs->pc = ip;
+}
+
+int kgdb_arch_handle_exception(int vector, int signo, int err_code,
+			       char *remcom_in_buffer, char *remcom_out_buffer,
+			       struct pt_regs *regs)
+{
+	char *ptr;
+	unsigned long address;
+	int cpu = smp_processor_id();
+
+	switch (remcom_in_buffer[0]) {
+	case 's':
+	case 'c':
+		/* handle the optional parameter */
+		ptr = &remcom_in_buffer[1];
+		if (kgdb_hex2long(&ptr, &address))
+			regs->pc = address;
+		atomic_set(&kgdb_cpu_doing_single_step, -1);
+		if (remcom_in_buffer[0] == 's')
+			atomic_set(&kgdb_cpu_doing_single_step, cpu);
+
+		return 0;
+	}
+	return -1; /* this means that we do not want to exit from the handler */
+}
+
+int kgdb_arch_init(void)
+{
+	get_pvr(&pvr); /* Fill PVR structure */
+	return 0;
+}
+
+void kgdb_arch_exit(void)
+{
+	/* Nothing to do */
+}
+
+/*
+ * Global data
+ */
+struct kgdb_arch arch_kgdb_ops = {
+	.gdb_bpt_instr = {0xba, 0x0c, 0x00, 0x18}, /* brki r16, 0x18 */
+};
diff --git a/arch/microblaze/mm/fault.c b/arch/microblaze/mm/fault.c
index b224c65..57bd2a0 100644
--- a/arch/microblaze/mm/fault.c
+++ b/arch/microblaze/mm/fault.c
@@ -37,10 +37,6 @@
 #include <linux/uaccess.h>
 #include <asm/exceptions.h>
 
-#if defined(CONFIG_KGDB)
-int debugger_kernel_faults = 1;
-#endif
-
 static unsigned long pte_misses;	/* updated by do_page_fault() */
 static unsigned long pte_errors;	/* updated by do_page_fault() */
 
@@ -81,10 +77,6 @@ void bad_page_fault(struct pt_regs *regs, unsigned long address, int sig)
 	}
 
 	/* kernel has accessed a bad area */
-#if defined(CONFIG_KGDB)
-	if (debugger_kernel_faults)
-		debugger(regs);
-#endif
 	die("kernel access of bad area", regs, sig);
 }
 
@@ -115,13 +107,6 @@ void do_page_fault(struct pt_regs *regs, unsigned long address,
 	if ((error_code & 0x13) == 0x13 || (error_code & 0x11) == 0x11)
 		is_write = 0;
 
-#if defined(CONFIG_KGDB)
-	if (debugger_fault_handler && regs->trap == 0x300) {
-		debugger_fault_handler(regs);
-		return;
-	}
-#endif /* CONFIG_KGDB */
-
 	if (unlikely(in_atomic() || !mm)) {
 		if (kernel_mode(regs))
 			goto bad_area_nosemaphore;
-- 
1.5.5.6

