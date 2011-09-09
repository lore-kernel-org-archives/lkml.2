Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758063Ab1IIBSn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 21:18:43 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:12600 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757322Ab1IIBKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 21:10:53 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6463"; a="116679160"
Message-Id: <20110909010915.258698042@codeaurora.org>
User-Agent: quilt/0.48-1
Date: Thu, 08 Sep 2011 20:08:53 -0500
From: Richard Kuo <rkuo@codeaurora.org>
To: linux-arch@vger.kernel.org, linux-hexagon@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Linas Vepstas <linas@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>
Subject: [patch v3 06/36] Hexagon: Add processor and system headers
References: <20110909010847.294039464@codeaurora.org>
Content-Disposition: inline; filename=processor.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds Hexagon information for processor/system type stuff
like context switching, register access, and irqflags.

Changed cpu_relax() to call __vmyield().

Signed-off-by: Richard Kuo <rkuo@codeaurora.org>
Signed-off-by: Linas Vepstas <linas@codeaurora.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>

---
 arch/hexagon/include/asm/asm-offsets.h |    1 
 arch/hexagon/include/asm/irqflags.h    |   62 ++++++++
 arch/hexagon/include/asm/processor.h   |  123 +++++++++++++++++
 arch/hexagon/include/asm/registers.h   |  236 +++++++++++++++++++++++++++++++++
 arch/hexagon/include/asm/system.h      |  126 +++++++++++++++++
 5 files changed, 548 insertions(+)

Index: linux-hexagon-kernel/arch/hexagon/include/asm/irqflags.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/irqflags.h	2011-09-03 20:14:59.534980859 -0500
@@ -0,0 +1,62 @@
+/*
+ * IRQ support for the Hexagon architecture
+ *
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#ifndef _ASM_IRQFLAGS_H
+#define _ASM_IRQFLAGS_H
+
+#include <asm/hexagon_vm.h>
+#include <linux/types.h>
+
+static inline unsigned long arch_local_save_flags(void)
+{
+	return __vmgetie();
+}
+
+static inline unsigned long arch_local_irq_save(void)
+{
+	return __vmsetie(VM_INT_DISABLE);
+}
+
+static inline bool arch_irqs_disabled_flags(unsigned long flags)
+{
+	return !flags;
+}
+
+static inline bool arch_irqs_disabled(void)
+{
+	return !__vmgetie();
+}
+
+static inline void arch_local_irq_enable(void)
+{
+	__vmsetie(VM_INT_ENABLE);
+}
+
+static inline void arch_local_irq_disable(void)
+{
+	__vmsetie(VM_INT_DISABLE);
+}
+
+static inline void arch_local_irq_restore(unsigned long flags)
+{
+	__vmsetie(flags);
+}
+
+#endif
Index: linux-hexagon-kernel/arch/hexagon/include/asm/processor.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/processor.h	2011-09-07 13:00:30.940646803 -0500
@@ -0,0 +1,123 @@
+/*
+ * Process/processor support for the Hexagon architecture
+ *
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#ifndef _ASM_PROCESSOR_H
+#define _ASM_PROCESSOR_H
+
+#ifndef __ASSEMBLY__
+
+#include <asm/mem-layout.h>
+#include <asm/registers.h>
+#include <asm/hexagon_vm.h>
+
+/*  must be a macro  */
+#define current_text_addr() ({ __label__ _l; _l: &&_l; })
+
+/*  task_struct, defined elsewhere, is the "process descriptor" */
+struct task_struct;
+
+/*  this is defined in arch/process.c  */
+extern pid_t kernel_thread(int (*fn)(void *), void * arg, unsigned long flags);
+extern unsigned long thread_saved_pc(struct task_struct *tsk);
+
+extern void start_thread(struct pt_regs *, unsigned long, unsigned long);
+
+/*
+ * thread_struct is supposed to be for context switch data.
+ * Specifically, to hold the state necessary to perform switch_to...
+ */
+struct thread_struct {
+	void *switch_sp;
+};
+
+/*
+ * initializes thread_struct
+ * The only thing we have in there is switch_sp
+ * which doesn't really need to be initialized.
+ */
+
+#define INIT_THREAD { \
+}
+
+#define cpu_relax() __vmyield()
+
+/*
+ * "Unlazying all lazy status" occurs here.
+ */
+static inline void prepare_to_copy(struct task_struct *tsk)
+{
+}
+
+/*
+ * Decides where the kernel will search for a free chunk of vm space during
+ * mmaps.
+ * See also arch_get_unmapped_area.
+ * Doesn't affect if you have MAX_FIXED in the page flags set though...
+ *
+ * Apparently the convention is that ld.so will ask for "unmapped" private
+ * memory to be allocated SOMEWHERE, but it also asks for memory explicitly
+ * via MAP_FIXED at the lower * addresses starting at VA=0x0.
+ *
+ * If the two requests collide, you get authentic segfaulting action, so
+ * you have to kick the "unmapped" base requests higher up.
+ */
+#define TASK_UNMAPPED_BASE	(PAGE_ALIGN(TASK_SIZE/3))
+
+
+#define task_pt_regs(task) \
+	((struct pt_regs *)(task_stack_page(task) + THREAD_SIZE) - 1)
+
+#define KSTK_EIP(tsk) (pt_elr(task_pt_regs(tsk)))
+#define KSTK_ESP(tsk) (pt_psp(task_pt_regs(tsk)))
+
+/*  Free all resources held by a thread; defined in process.c  */
+extern void release_thread(struct task_struct *dead_task);
+
+/* Get wait channel for task P.  */
+extern unsigned long get_wchan(struct task_struct *p);
+
+/*  The following stuff is pretty HEXAGON specific.  */
+
+/*  This is really just here for __switch_to.
+    Offsets are pulled via asm-offsets.c  */
+
+/*
+ * No real reason why VM and native switch stacks should be different.
+ * Ultimately this should merge.  Note that Rev C. ABI called out only
+ * R24-27 as callee saved GPRs needing explicit attention (R29-31 being
+ * dealt with automagically by allocframe), but the current ABI has
+ * more, R16-R27.  By saving more, the worst case is that we waste some
+ * cycles if building with the old compilers.
+ */
+
+struct hexagon_switch_stack {
+	unsigned long long	r1716;
+	unsigned long long	r1918;
+	unsigned long long	r2120;
+	unsigned long long	r2322;
+	unsigned long long	r2524;
+	unsigned long long	r2726;
+	unsigned long		fp;
+	unsigned long		lr;
+};
+
+#endif /* !__ASSEMBLY__ */
+
+#endif
Index: linux-hexagon-kernel/arch/hexagon/include/asm/registers.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/registers.h	2011-09-03 20:14:59.544980887 -0500
@@ -0,0 +1,236 @@
+/*
+ * Register definitions for the Hexagon architecture
+ *
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#ifndef _ASM_REGISTERS_H
+#define _ASM_REGISTERS_H
+
+#define SP r29
+
+#ifndef __ASSEMBLY__
+
+/*  See kernel/entry.S for further documentation.  */
+
+/*
+ * Entry code copies the event record out of guest registers into
+ * this structure (which is on the stack).
+ */
+
+struct hvm_event_record {
+	unsigned long vmel;     /* Event Linkage (return address) */
+	unsigned long vmest;    /* Event context - pre-event SSR values */
+	unsigned long vmpsp;    /* Previous stack pointer */
+	unsigned long vmbadva;  /* Bad virtual address for addressing events */
+};
+
+struct pt_regs {
+	long restart_r0;        /* R0 checkpoint for syscall restart */
+	long syscall_nr;        /* Only used in system calls */
+	union {
+		struct {
+			unsigned long usr;
+			unsigned long preds;
+		};
+		long long int predsusr;
+	};
+	union {
+		struct {
+			unsigned long m0;
+			unsigned long m1;
+		};
+		long long int m1m0;
+	};
+	union {
+		struct {
+			unsigned long sa1;
+			unsigned long lc1;
+		};
+		long long int lc1sa1;
+	};
+	union {
+		struct {
+			unsigned long sa0;
+			unsigned long lc0;
+		};
+		long long int lc0sa0;
+	};
+	union {
+		struct {
+			unsigned long gp;
+			unsigned long ugp;
+		};
+		long long int ugpgp;
+	};
+	/*
+	* Be extremely careful with rearranging these, if at all.  Some code
+	* assumes the 32 registers exist exactly like this in memory;
+	* e.g. kernel/ptrace.c
+	* e.g. kernel/signal.c (restore_sigcontext)
+	*/
+	union {
+		struct {
+			unsigned long r00;
+			unsigned long r01;
+		};
+		long long int r0100;
+	};
+	union {
+		struct {
+			unsigned long r02;
+			unsigned long r03;
+		};
+		long long int r0302;
+	};
+	union {
+		struct {
+			unsigned long r04;
+			unsigned long r05;
+		};
+		long long int r0504;
+	};
+	union {
+		struct {
+			unsigned long r06;
+			unsigned long r07;
+		};
+		long long int r0706;
+	};
+	union {
+		struct {
+			unsigned long r08;
+			unsigned long r09;
+		};
+		long long int r0908;
+	};
+	union {
+	       struct {
+			unsigned long r10;
+			unsigned long r11;
+	       };
+	       long long int r1110;
+	};
+	union {
+	       struct {
+			unsigned long r12;
+			unsigned long r13;
+	       };
+	       long long int r1312;
+	};
+	union {
+	       struct {
+			unsigned long r14;
+			unsigned long r15;
+	       };
+	       long long int r1514;
+	};
+	union {
+		struct {
+			unsigned long r16;
+			unsigned long r17;
+		};
+		long long int r1716;
+	};
+	union {
+		struct {
+			unsigned long r18;
+			unsigned long r19;
+		};
+		long long int r1918;
+	};
+	union {
+		struct {
+			unsigned long r20;
+			unsigned long r21;
+		};
+		long long int r2120;
+	};
+	union {
+		struct {
+			unsigned long r22;
+			unsigned long r23;
+		};
+		long long int r2322;
+	};
+	union {
+		struct {
+			unsigned long r24;
+			unsigned long r25;
+		};
+		long long int r2524;
+	};
+	union {
+		struct {
+			unsigned long r26;
+			unsigned long r27;
+		};
+		long long int r2726;
+	};
+	union {
+		struct {
+			unsigned long r28;
+			unsigned long r29;
+	       };
+	       long long int r2928;
+	};
+	union {
+		struct {
+			unsigned long r30;
+			unsigned long r31;
+		};
+		long long int r3130;
+	};
+	/* VM dispatch pushes event record onto stack - we can build on it */
+	struct hvm_event_record hvmer;
+};
+
+/* Defines to conveniently access the values  */
+
+/*
+ * As of the VM spec 0.5, these registers are now set/retrieved via a
+ * VM call.  On the in-bound side, we just fetch the values
+ * at the entry points and stuff them into the old record in pt_regs.
+ * However, on the outbound side, probably at VM rte, we set the
+ * registers back.
+ */
+
+#define pt_elr(regs) ((regs)->hvmer.vmel)
+#define pt_set_elr(regs, val) ((regs)->hvmer.vmel = (val))
+#define pt_cause(regs) ((regs)->hvmer.vmest & (HVM_VMEST_CAUSE_MSK))
+#define user_mode(regs) \
+	(((regs)->hvmer.vmest & (HVM_VMEST_UM_MSK << HVM_VMEST_UM_SFT)) != 0)
+#define ints_enabled(regs) \
+	(((regs)->hvmer.vmest & (HVM_VMEST_IE_MSK << HVM_VMEST_IE_SFT)) != 0)
+#define pt_psp(regs) ((regs)->hvmer.vmpsp)
+#define pt_badva(regs) ((regs)->hvmer.vmbadva)
+
+#define pt_set_rte_sp(regs, sp) do {\
+	pt_psp(regs) = (sp);\
+	(regs)->SP = (unsigned long) &((regs)->hvmer);\
+	} while (0)
+
+#define pt_set_kmode(regs) \
+	(regs)->hvmer.vmest = (HVM_VMEST_IE_MSK << HVM_VMEST_IE_SFT)
+
+#define pt_set_usermode(regs) \
+	(regs)->hvmer.vmest = (HVM_VMEST_UM_MSK << HVM_VMEST_UM_SFT) \
+			    | (HVM_VMEST_IE_MSK << HVM_VMEST_IE_SFT)
+
+#endif  /*  ifndef __ASSEMBLY  */
+
+#endif
Index: linux-hexagon-kernel/arch/hexagon/include/asm/system.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/system.h	2011-09-03 20:14:59.544980887 -0500
@@ -0,0 +1,126 @@
+/*
+ * System level definitions for the Hexagon architecture
+ *
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#ifndef _ASM_SYSTEM_H
+#define _ASM_SYSTEM_H
+
+#include <linux/linkage.h>
+#include <linux/irqflags.h>
+#include <asm/atomic.h>
+#include <asm/hexagon_vm.h>
+
+struct thread_struct;
+
+extern struct task_struct *__switch_to(struct task_struct *,
+	struct task_struct *,
+	struct task_struct *);
+
+#define switch_to(p, n, r) do {\
+	r = __switch_to((p), (n), (r));\
+} while (0)
+
+
+#define rmb()				barrier()
+#define read_barrier_depends()		barrier()
+#define wmb()				barrier()
+#define mb()				barrier()
+#define smp_rmb()			barrier()
+#define smp_read_barrier_depends()	barrier()
+#define smp_wmb()			barrier()
+#define smp_mb()			barrier()
+#define smp_mb__before_atomic_dec()	barrier()
+#define smp_mb__after_atomic_dec()	barrier()
+#define smp_mb__before_atomic_inc()	barrier()
+#define smp_mb__after_atomic_inc()	barrier()
+
+/*
+ * __xchg - atomically exchange a register and a memory location
+ * @x: value to swap
+ * @ptr: pointer to memory
+ * @size:  size of the value
+ *
+ * Only 4 bytes supported currently.
+ *
+ * Note:  there was an errata for V2 about .new's and memw_locked.
+ *
+ */
+static inline unsigned long __xchg(unsigned long x, volatile void *ptr,
+				   int size)
+{
+	unsigned long retval;
+
+	/*  Can't seem to use printk or panic here, so just stop  */
+	if (size != 4) do { asm volatile("brkpt;\n"); } while (1);
+
+	__asm__ __volatile__ (
+	"1:	%0 = memw_locked(%1);\n"    /*  load into retval */
+	"	memw_locked(%1,P0) = %2;\n" /*  store into memory */
+	"	if !P0 jump 1b;\n"
+	: "=&r" (retval)
+	: "r" (ptr), "r" (x)
+	: "memory", "p0"
+	);
+	return retval;
+}
+
+/*
+ * Atomically swap the contents of a register with memory.  Should be atomic
+ * between multiple CPU's and within interrupts on the same CPU.
+ */
+#define xchg(ptr, v) ((__typeof__(*(ptr)))__xchg((unsigned long)(v), (ptr), \
+	sizeof(*(ptr))))
+
+/*  Set a value and use a memory barrier.  Used by the scheduler somewhere.  */
+#define set_mb(var, value) \
+	do { var = value; mb(); } while (0)
+
+/*
+ *  see rt-mutex-design.txt; cmpxchg supposedly checks if *ptr == A and swaps.
+ *  looks just like atomic_cmpxchg on our arch currently with a bunch of
+ *  variable casting.
+ */
+#define __HAVE_ARCH_CMPXCHG 1
+
+#define cmpxchg(ptr, old, new)					\
+({								\
+	__typeof__(ptr) __ptr = (ptr);				\
+	__typeof__(*(ptr)) __old = (old);			\
+	__typeof__(*(ptr)) __new = (new);			\
+	__typeof__(*(ptr)) __oldval = 0;			\
+								\
+	asm volatile(						\
+		"1:	%0 = memw_locked(%1);\n"		\
+		"	{ P0 = cmp.eq(%0,%2);\n"		\
+		"	  if (!P0.new) jump:nt 2f; }\n"		\
+		"	memw_locked(%1,p0) = %3;\n"		\
+		"	if (!P0) jump 1b;\n"			\
+		"2:\n"						\
+		: "=&r" (__oldval)				\
+		: "r" (__ptr), "r" (__old), "r" (__new)		\
+		: "memory", "p0"				\
+	);							\
+	__oldval;						\
+})
+
+/*  Should probably shoot for an 8-byte aligned stack pointer  */
+#define STACK_MASK (~7)
+#define arch_align_stack(x) (x & STACK_MASK)
+
+#endif
Index: linux-hexagon-kernel/arch/hexagon/include/asm/asm-offsets.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/asm-offsets.h	2011-09-03 20:14:59.544980887 -0500
@@ -0,0 +1 @@
+#include <generated/asm-offsets.h>

--

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

