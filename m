Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136Ab2KLL4j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 06:56:39 -0500
Received: from vaxjo.synopsys.com ([198.182.60.75]:64701 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934Ab2KLLuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 06:50:35 -0500
From: <Vineet.Gupta1@synopsys.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <tglx@linutronix.de>, <arnd@arndb.de>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [RFC Patch v1 38/55] ARC: Low level event capture/logging
Date: Mon, 12 Nov 2012 17:18:56 +0530
Message-ID: <1352720953-24321-8-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1352720953-24321-1-git-send-email-vgupta@synopsys.com>
References: <1352720953-24321-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vineet Gupta <vgupta@synopsys.com>

Poorman's version of LTT

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/Kconfig                     |    7 +
 arch/arc/Makefile                    |    3 +
 arch/arc/include/asm/event-log-asm.h |  185 +++++++++++++++++++++
 arch/arc/include/asm/event-log.h     |  102 ++++++++++++
 arch/arc/kernel/Makefile             |    1 +
 arch/arc/kernel/asm-offsets.c        |   15 ++
 arch/arc/kernel/entry.S              |   31 ++++
 arch/arc/kernel/event-log.c          |  304 ++++++++++++++++++++++++++++++++++
 arch/arc/kernel/signal.c             |    3 +
 arch/arc/mm/tlb.c                    |    3 +
 arch/arc/mm/tlbex.S                  |    7 +
 11 files changed, 661 insertions(+), 0 deletions(-)
 create mode 100644 arch/arc/include/asm/event-log-asm.h
 create mode 100644 arch/arc/include/asm/event-log.h
 create mode 100644 arch/arc/kernel/event-log.c

diff --git a/arch/arc/Kconfig b/arch/arc/Kconfig
index e096545..15d740c 100644
--- a/arch/arc/Kconfig
+++ b/arch/arc/Kconfig
@@ -323,6 +323,13 @@ config ARC_DBG_TLB_PARANOIA
 	depends on ARC_DBG
 	default n
 
+config ARC_DBG_EVENT_TIMELINE
+	bool "Low level event capture"
+	depends on ARC_DBG
+	default n
+	help
+	  Capture low level events: IRQ/Trap/Exception
+
 config ARC_DBG_TLB_MISS_COUNT
 	bool "Profile TLB Misses"
 	default n
diff --git a/arch/arc/Makefile b/arch/arc/Makefile
index 7ef6767..a533546 100644
--- a/arch/arc/Makefile
+++ b/arch/arc/Makefile
@@ -47,6 +47,9 @@ endif
 disable_small_data := y
 cflags-$(disable_small_data)		+= -mno-sdata -fcall-used-gp
 
+# Low level event tracing with Metaware debugger assist needs symbol info
+cflags-$(CONFIG_ARC_DBG_EVENT_TIMELINE) += -g
+
 cflags-$(CONFIG_CPU_BIG_ENDIAN)		+= -mbig-endian
 ldflags-$(CONFIG_CPU_BIG_ENDIAN)	+= -EB
 
diff --git a/arch/arc/include/asm/event-log-asm.h b/arch/arc/include/asm/event-log-asm.h
new file mode 100644
index 0000000..bc29e7d
--- /dev/null
+++ b/arch/arc/include/asm/event-log-asm.h
@@ -0,0 +1,185 @@
+/*
+ *  Low level Event Capture API callable from Assembly Code
+ *  vineetg: Feb 2008
+ *
+ *  TBD: SMP Safe
+ *
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __ASM_ARC_EVENT_LOG_ASM_H
+#define __ASM_ARC_EVENT_LOG_ASM_H
+
+#include <asm/event-log.h>
+
+#ifdef __ASSEMBLY__
+
+#ifndef CONFIG_ARC_DBG_EVENT_TIMELINE
+
+.macro TAKE_SNAP_ASM reg_scratch, reg_ptr, type
+.endm
+
+.macro TAKE_SNAP_C_FROM_ASM type
+.endm
+
+#else
+
+#include <asm/asm-offsets.h>
+
+/*
+ * Macro to invoke the ASM event logger routine from assmebly code
+ * This is generated in-place in caller.
+ *
+ * @reg_scratch and @reg_ptr:
+ *	Registers provided by caller for coding the macro itself.
+ *	At this point if call, say Low level ISR, the Reg-File might not have
+ *	been saved, so only use reg safe.
+ * @type:
+ *	The low level event, defined in event-log.h
+ */
+.macro TAKE_SNAP_ASM reg_scratch, reg_ptr, type
+
+	/*
+	 * Earlier we used to save only reg_scratch and clobber reg_ptr and rely
+	 * on caller to understand this. Too much trouble.
+	 * Now we save both
+	 */
+	st \reg_scratch, [tmp_save_reg]
+	st \reg_ptr, [tmp_save_reg2]
+
+	ld \reg_ptr, [timeline_ctr]
+
+	/* HACK to detect if the circular log buffer is being overflowed */
+	brne \reg_ptr, MAX_SNAPS, 1f
+	flag 1
+	nop
+1:
+#ifdef CONFIG_ARC_HAS_HW_MPY
+	mpyu \reg_ptr, \reg_ptr, EVLOG_RECORD_SZ
+#else
+#error "even logger broken for !CONFIG_ARC_HAS_HW_MPY
+#endif
+
+	add \reg_ptr, timeline_log, \reg_ptr
+
+	/*############ Common data ########## */
+
+	/* TIMER1 count in timeline_log[timeline_ctr].time */
+	lr \reg_scratch, [ARC_REG_TIMER1_CNT]
+	st \reg_scratch, [\reg_ptr, EVLOG_FIELD_TIME]
+
+	/* current task ptr in timeline_log[timeline_ctr].task */
+	ld \reg_scratch, [_current_task]
+	ld \reg_scratch, [\reg_scratch, TASK_TGID]
+	st \reg_scratch, [\reg_ptr, EVLOG_FIELD_TASK]
+
+	/* Type of event (Intr/Excp/Trap etc) */
+	mov \reg_scratch, \type
+	st \reg_scratch, [\reg_ptr, EVLOG_FIELD_EVENT_ID]
+
+	/* save SP at time of exception */
+	st sp, [\reg_ptr, EVLOG_FIELD_SP]
+
+	st 0, [\reg_ptr, EVLOG_FIELD_EXTRA]
+	st 0, [\reg_ptr, EVLOG_FIELD_CAUSE]
+	st 0, [\reg_ptr, EVLOG_FIELD_EXTRA3]
+
+	lr \reg_scratch, [status32]
+	st \reg_scratch, [\reg_ptr, EVLOG_FIELD_EXTRA2]
+
+	/* ############ Event specific data ########## */
+	mov \reg_scratch, \type
+	and.f 0, \reg_scratch, EVENT_CLASS_EXIT
+	bz 1f
+
+	/* Stuff to do for all kernel exit events */
+	ld \reg_scratch, [sp, PT_status32]
+	st \reg_scratch, [\reg_ptr, EVLOG_FIELD_EXTRA]
+
+	/* preempt count in log->sp */
+	and \reg_scratch, sp, ~(0x2000 - 1)
+	ld \reg_scratch, [\reg_scratch, THREAD_INFO_PREEMPT_COUNT]
+	st \reg_scratch, [\reg_ptr, EVLOG_FIELD_SP]
+
+	ld \reg_scratch, [sp, PT_ret]
+	st \reg_scratch, [\reg_ptr, EVLOG_FIELD_EFA]
+
+	mov \reg_scratch, \type
+1:
+2:
+	/* for Trap, Syscall number  */
+	cmp \reg_scratch, SNAP_TRAP_IN
+	bnz 3f
+	st r8, [\reg_ptr, EVLOG_FIELD_CAUSE]
+	lr \reg_scratch, [erstatus]
+	st \reg_scratch, [\reg_ptr, EVLOG_FIELD_EXTRA]
+	j 99f
+3:
+5:
+	/* For Exceptions (TLB/ProtV etc) */
+	cmp \reg_scratch, SNAP_EXCP_IN
+	bnz 6f
+
+	lr \reg_scratch, [ecr]
+	st \reg_scratch, [\reg_ptr, EVLOG_FIELD_CAUSE]
+	lr \reg_scratch, [eret]
+	st \reg_scratch, [\reg_ptr, EVLOG_FIELD_EFA]
+	lr \reg_scratch, [erstatus]
+	st \reg_scratch, [\reg_ptr, EVLOG_FIELD_EXTRA]
+	lr \reg_scratch, [efa]
+	st \reg_scratch, [\reg_ptr, EVLOG_FIELD_EXTRA3]
+	j 99f
+
+6:	/* for Interrupts, IRQ */
+	cmp \reg_scratch, SNAP_INTR_OUT
+	bnz 7f
+	lr \reg_scratch, [icause1]
+	st \reg_scratch, [\reg_ptr, EVLOG_FIELD_CAUSE]
+	j 99f
+
+7:
+	cmp \reg_scratch, SNAP_INTR_OUT2
+	bnz 8f
+	lr \reg_scratch, [icause2]
+	st \reg_scratch, [\reg_ptr, EVLOG_FIELD_CAUSE]
+	j 99f
+
+8:
+	cmp \reg_scratch, SNAP_EXCP_OUT_FAST
+	bnz 9f
+	lr \reg_scratch, [erstatus]
+	st \reg_scratch, [\reg_ptr, EVLOG_FIELD_EXTRA]
+	j 99f
+
+	/* place holder for next */
+9:
+
+99:
+	/* increment timeline_ctr  with mode on max */
+	ld \reg_scratch, [timeline_ctr]
+	add \reg_scratch, \reg_scratch, 1
+	and \reg_scratch, \reg_scratch, MAX_SNAPS_MASK
+	st \reg_scratch, [timeline_ctr]
+
+	/* Restore back orig scratch reg */
+	ld \reg_scratch, [tmp_save_reg]
+	ld \reg_ptr, [tmp_save_reg2]
+.endm
+
+/*
+ * Macro to invoke the "C" event logger routine from assmebly code
+ */
+.macro TAKE_SNAP_C_FROM_ASM type
+	mov r0, \type
+	bl take_snap2
+.endm
+
+#endif	/* CONFIG_ARC_DBG_EVENT_TIMELINE */
+
+#endif	/* __ASSEMBLY__ */
+
+#endif
diff --git a/arch/arc/include/asm/event-log.h b/arch/arc/include/asm/event-log.h
new file mode 100644
index 0000000..423f549
--- /dev/null
+++ b/arch/arc/include/asm/event-log.h
@@ -0,0 +1,102 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ *  vineetg: Dec 2009
+ *      Reworked the numbering scheme into Event Classes for making it easier to
+ *      do class specific things in the snapshot routines
+ *
+ *  vineetg: Feb 2008
+ *      System Event Logging APIs
+ */
+
+#ifndef __ASM_ARC_EVENT_LOG_H
+#define __ASM_ARC_EVENT_LOG_H
+
+/*######################################################################
+ *
+ *    Event Logging API
+ *
+ *#####################################################################*/
+
+/* Size of the log buffer */
+#define MAX_SNAPS	1024
+#define MAX_SNAPS_MASK	(MAX_SNAPS-1)
+
+/* Helpers to setup Event IDs:
+ * 8 classes of events possible
+ * 23 unique events for each Class
+ * Right now we have only 3 classes:
+ * Entry into kernel, exit from kernel and everything else is custom event
+ *
+ * Need for this fancy numbering scheme so that in event logger, class specific
+ * things, common for all events in class, could be easily done
+ */
+#define EVENT_ID(x)             (0x100 << x)
+#define EVENT_CLASS_ENTER       0x01	/* Need to start from 1, not 0 */
+#define EVENT_CLASS_EXIT        0x02
+#define EVENT_CLASS_CUSTOM      0x80
+
+#define KERNEL_ENTER_EVENT(x)   (EVENT_ID(x)|EVENT_CLASS_ENTER)
+#define KERNEL_EXIT_EVENT(x)    (EVENT_ID(x)|EVENT_CLASS_EXIT)
+#define CUSTOM_EVENT(x)         (EVENT_ID(x)|EVENT_CLASS_CUSTOM)
+
+/* Actual Event IDs used in kernel code */
+#define SNAP_INTR_IN            KERNEL_ENTER_EVENT(0)
+#define SNAP_EXCP_IN            KERNEL_ENTER_EVENT(1)
+#define SNAP_TRAP_IN            KERNEL_ENTER_EVENT(2)
+#define SNAP_INTR_IN2           KERNEL_ENTER_EVENT(3)
+
+#define SNAP_INTR_OUT           KERNEL_EXIT_EVENT(0)
+#define SNAP_EXCP_OUT           KERNEL_EXIT_EVENT(1)
+#define SNAP_TRAP_OUT           KERNEL_EXIT_EVENT(2)
+#define SNAP_INTR_OUT2          KERNEL_EXIT_EVENT(3)
+#define SNAP_EXCP_OUT_FAST      KERNEL_EXIT_EVENT(4)
+
+#define SNAP_PRE_CTXSW_2_U      CUSTOM_EVENT(0)
+#define SNAP_PRE_CTXSW_2_K      CUSTOM_EVENT(1)
+#define SNAP_DO_PF_ENTER        CUSTOM_EVENT(2)
+#define SNAP_DO_PF_EXIT         CUSTOM_EVENT(3)
+#define SNAP_TLB_FLUSH_ALL      CUSTOM_EVENT(4)
+#define SNAP_PREEMPT_SCH_IRQ    CUSTOM_EVENT(5)
+#define SNAP_PREEMPT_SCH        CUSTOM_EVENT(6)
+#define SNAP_SIGRETURN          CUSTOM_EVENT(7)
+#define SNAP_BEFORE_SIG         CUSTOM_EVENT(8)
+
+#define SNAP_SENTINEL           CUSTOM_EVENT(22)
+
+#ifndef CONFIG_ARC_DBG_EVENT_TIMELINE
+
+#define take_snap(type, extra, ptreg)
+#define sort_snaps(halt_after_sort)
+
+#else
+
+#ifndef __ASSEMBLY__
+
+typedef struct {
+
+	/*  0 */ char nm[16];
+	/* 16 */ unsigned int extra; /* Traps: Syscall num, Intr: IRQ, Excep */
+	/* 20 */ unsigned int fault_addr;
+	/* 24 */ unsigned int cause;
+	/* 28 */ unsigned int task;
+	/* 32 */ unsigned long time;
+	/* 36 */ unsigned int event;
+	/* 40 */ unsigned int sp;
+	/* 44 */ unsigned int extra2;
+	/* 40 */ unsigned int extra3;
+
+} timeline_log_t;
+
+void take_snap(int type, unsigned int extra, unsigned int extra2);
+void sort_snaps(int halt_after_sort);
+
+#endif /* __ASSEMBLY__ */
+
+#endif /* CONFIG_ARC_DBG_EVENT_TIMELINE */
+
+#endif /* __ASM_ARC_EVENT_PROFILE_H */
diff --git a/arch/arc/kernel/Makefile b/arch/arc/kernel/Makefile
index 9151bbe..ec1f130 100644
--- a/arch/arc/kernel/Makefile
+++ b/arch/arc/kernel/Makefile
@@ -12,6 +12,7 @@ obj-y	:= arcksyms.o setup.o irq.o time.o reset.o ptrace.o entry.o process.o \
 	   signal.o traps.o sys.o troubleshoot.o stacktrace.o
 
 obj-$(CONFIG_MODULES)			+= arcksyms.o module.o
+obj-$(CONFIG_ARC_DBG_EVENT_TIMELINE)	+= event-log.o
 obj-$(CONFIG_ARC_FPU_SAVE_RESTORE)	+= fpu.o
 CFLAGS_fpu.o   += -mdpfp
 
diff --git a/arch/arc/kernel/asm-offsets.c b/arch/arc/kernel/asm-offsets.c
index b0e7254..0c06b7a 100644
--- a/arch/arc/kernel/asm-offsets.c
+++ b/arch/arc/kernel/asm-offsets.c
@@ -13,6 +13,7 @@
 #include <linux/thread_info.h>
 #include <asm/page.h>
 #include <linux/kbuild.h>
+#include <asm/event-log.h>
 
 int main(void)
 {
@@ -45,5 +46,19 @@ int main(void)
 
 	DEFINE(MM_CTXT_ASID, offsetof(mm_context_t, asid));
 
+#ifdef CONFIG_ARC_DBG_EVENT_TIMELINE
+	BLANK();
+	DEFINE(EVLOG_FIELD_EXTRA, offsetof(timeline_log_t, extra));
+	DEFINE(EVLOG_FIELD_EFA, offsetof(timeline_log_t, fault_addr));
+	DEFINE(EVLOG_FIELD_CAUSE, offsetof(timeline_log_t, cause));
+	DEFINE(EVLOG_FIELD_TASK, offsetof(timeline_log_t, task));
+	DEFINE(EVLOG_FIELD_TIME, offsetof(timeline_log_t, time));
+	DEFINE(EVLOG_FIELD_EVENT_ID, offsetof(timeline_log_t, event));
+	DEFINE(EVLOG_FIELD_SP, offsetof(timeline_log_t, sp));
+	DEFINE(EVLOG_RECORD_SZ, sizeof(timeline_log_t));
+	DEFINE(EVLOG_FIELD_EXTRA2, offsetof(timeline_log_t, extra2));
+	DEFINE(EVLOG_FIELD_EXTRA3, offsetof(timeline_log_t, extra3));
+#endif
+
 	return 0;
 }
diff --git a/arch/arc/kernel/entry.S b/arch/arc/kernel/entry.S
index 13a0052..5babb8a 100644
--- a/arch/arc/kernel/entry.S
+++ b/arch/arc/kernel/entry.S
@@ -148,6 +148,7 @@ VECTOR   reserved                ; Reserved Exceptions
 #include <asm/errno.h>
 #include <asm/arcregs.h>
 #include <asm/irqflags.h>
+#include <asm/event-log-asm.h>
 
 ;##################### Scratch Mem for IRQ stack switching #############
 
@@ -213,6 +214,8 @@ ARC_ENTRY handle_interrupt_level2
 	st      r9, [r10, THREAD_INFO_PREEMPT_COUNT]
 
 1:
+	TAKE_SNAP_C_FROM_ASM  SNAP_INTR_IN2
+
 	;------------------------------------------------------
 	; setup params for Linux common ISR and invoke it
 	;------------------------------------------------------
@@ -245,6 +248,9 @@ ARC_ENTRY handle_interrupt_level1
 	SWITCH_TO_KERNEL_STK
 	SAVE_ALL_INT1
 
+	; snapshot routine takes care of disabling nested intr
+	TAKE_SNAP_C_FROM_ASM  SNAP_INTR_IN
+
 	lr  r0, [icause1]
 	and r0, r0, 0x1f
 
@@ -267,6 +273,8 @@ ARC_ENTRY instr_service
 
 	EXCPN_PROLOG_FREEUP_REG r9
 
+	TAKE_SNAP_ASM r8, r9, SNAP_EXCP_IN
+
 	lr  r9, [erstatus]
 
 	SWITCH_TO_KERNEL_STK
@@ -291,6 +299,8 @@ ARC_ENTRY mem_service
 
 	EXCPN_PROLOG_FREEUP_REG r9
 
+	TAKE_SNAP_ASM r8, r9, SNAP_EXCP_IN
+
 	lr  r9, [erstatus]
 
 	SWITCH_TO_KERNEL_STK
@@ -342,6 +352,8 @@ ARC_ENTRY EV_TLBProtV
 
 	EXCPN_PROLOG_FREEUP_REG r9
 
+	TAKE_SNAP_ASM r8, r9, SNAP_EXCP_IN
+
 	;Which mode (user/kernel) was the system in when Exception occured
 	lr  r9, [erstatus]
 
@@ -400,6 +412,8 @@ ARC_ENTRY EV_PrivilegeV
 
 	EXCPN_PROLOG_FREEUP_REG r9
 
+	TAKE_SNAP_ASM r8, r9, SNAP_EXCP_IN
+
 	lr  r9, [erstatus]
 
 	SWITCH_TO_KERNEL_STK
@@ -526,6 +540,8 @@ ARC_ENTRY EV_Trap
 	; Need at least 1 reg to code the early exception prolog
 	EXCPN_PROLOG_FREEUP_REG r9
 
+	TAKE_SNAP_ASM r10, r9,  SNAP_TRAP_IN
+
 	;Which mode (user/kernel) was the system in when intr occured
 	lr  r9, [erstatus]
 
@@ -733,6 +749,7 @@ not_exception:
 	st      r9, [r10, THREAD_INFO_PREEMPT_COUNT]
 
 149:
+	TAKE_SNAP_C_FROM_ASM SNAP_INTR_OUT2
 	;return from level 2
 	RESTORE_ALL_INT2
 debug_marker_l2:
@@ -745,6 +762,7 @@ not_level2_interrupt:
 	bbit0  r10, STATUS_A1_BIT, not_level1_interrupt
 
 	;return from level 1
+	TAKE_SNAP_C_FROM_ASM SNAP_INTR_OUT
 
 	RESTORE_ALL_INT1
 debug_marker_l1:
@@ -754,6 +772,19 @@ not_level1_interrupt:
 
 	;this case is for syscalls or Exceptions (with fake rtie)
 
+#ifdef CONFIG_ARC_DBG_EVENT_TIMELINE
+	ld r8, [sp, PT_orig_r8]
+	cmp r8, NR_syscalls+1
+	jeq  149f
+	TAKE_SNAP_ASM r9, r10, SNAP_TRAP_OUT
+	j 150f
+
+149:
+	TAKE_SNAP_ASM r9, r10, SNAP_EXCP_OUT
+150:
+
+#endif
+
 	RESTORE_ALL_SYS
 debug_marker_syscall:
 	rtie
diff --git a/arch/arc/kernel/event-log.c b/arch/arc/kernel/event-log.c
new file mode 100644
index 0000000..f8ab807
--- /dev/null
+++ b/arch/arc/kernel/event-log.c
@@ -0,0 +1,304 @@
+/*
+ * event-log.c : Poorman's version of LTT for low level event capturing
+ *
+ * captures IRQ/Exceptions/Sys-Calls/arbitrary function call
+ * XXX: Not SMP Safe
+ *
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ *  vineetg Jan 2009
+ *      -Converted strcpy to strncpy
+ *
+ *  vineetg: Feb 2008: Event capturing Framework
+ *      -Captures the event-id and related info in circular log buffer
+ *
+ *      -USAGE:
+ *          Events are defined in API file, include/asm-arc/event-log.h
+ *          To log the event, "C" code calls API
+ *              take_snap(event-id, event-specific-info)
+ *          To log the event, ASM caller calls a "asm" macro
+ *              TAKE_SNAP_ASM reg-x, reg-y, event-id
+ *          To stop the capture and sort the log buffer,
+ *              sort_snaps(halt-after-sort)
+ *
+ *      -The reason for 2 APIs is that in low level handlers
+ *          which we are interested in capturing, often don't have
+ *          stack switched, thus a "C" API wont work. Also there
+ *          is a very strict requirement of which registers are usable
+ *          hence the 2 regs
+ *
+ *      -Done primarily to chase the Random Segmentation Faults
+ *          when we switched from gcc 3.4 to 4.2
+ */
+
+#include <linux/sort.h>
+#include <linux/sched.h>
+#include <linux/interrupt.h>
+#include <asm/current.h>
+#include <asm/event-log.h>
+#include <linux/module.h>
+#include <linux/reboot.h>
+
+#ifdef CONFIG_ARC_CURR_IN_REG
+/*
+ * current on ARC is a register variable "r25" setup on entry to kernel and
+ * restored back to user value on return.
+ * However if the event snap shotting return is called very late from
+ * ISR/Exception return code, r25 might already have been restored to user
+ * value, hence would no longer point to current task. This can cause weird
+ * de-referencing crashes. Safest option is to undef it and instead define
+ * it in terms of current_thread_info() which is derived from SP
+ */
+#undef current
+#define current (current_thread_info()->task)
+#endif
+
+/*
+ * Log buffer which stores the event info
+ *
+ *  There is race condition when the counter goes 1 more than
+ *  max-value (if IRQ sneaks in in the logging routine. Since
+ *  we don't want to do fancy intr-enable-disable etc,
+ *  we keep 1 extra element in log buffer
+ */
+timeline_log_t timeline_log[MAX_SNAPS + 1];
+
+/* counter in log bugger for next entry */
+int timeline_ctr;
+
+/* Used in the low level asm handler to free up a reg */
+int tmp_save_reg, tmp_save_reg2;
+int l2_ctr;
+
+/* Event capture API */
+void take_snap(int event, unsigned int arg1, unsigned int arg2)
+{
+	timeline_log_t *entry = &timeline_log[timeline_ctr];
+
+	entry->time = read_aux_reg(ARC_REG_TIMER1_CNT);
+	entry->task = current->pid;
+	entry->event = event;
+	entry->extra2 = read_aux_reg(0xa);	/* status32 */
+
+	entry->cause = read_aux_reg(0x403);	/* ecr */
+	entry->fault_addr = read_aux_reg(0x404);	/* efa */
+
+	entry->extra = arg1;
+	entry->sp = arg2;
+
+	entry->extra3 =
+	    (unsigned int)__builtin_return_address(0);
+
+	if (timeline_ctr == (MAX_SNAPS - 1))
+		timeline_ctr = 0;
+	else
+		timeline_ctr++;
+
+}
+EXPORT_SYMBOL(take_snap);
+
+void take_snap2(int event)
+{
+	unsigned long x, flags = 0, stat32;
+	timeline_log_t *entry = &timeline_log[timeline_ctr];
+
+	stat32 = read_aux_reg(0xa);	/* status32 */
+
+	/* In case this is for Level 1 ISR, disable further Interrupts
+	 * so that timeline_ctr is not clobbered
+	 */
+	if (event == SNAP_INTR_IN)
+		local_irq_save(flags);
+
+	entry->time = read_aux_reg(ARC_REG_TIMER1_CNT);
+	entry->task = current->pid;
+	entry->event = event;
+	entry->extra2 = stat32;
+
+	entry->sp = current_thread_info()->preempt_count;
+
+	if (event == SNAP_INTR_IN2) {
+		entry->cause = read_aux_reg(0x40B);	/* icause2 */
+		entry->extra = read_aux_reg(0x0C);	/* statsu32_l2 */
+		__asm__ __volatile__("mov %0, ilink2   \r\n" : "=r"(x));
+		entry->fault_addr = x;
+	} else if (event == SNAP_INTR_IN) {
+		entry->cause = read_aux_reg(0x40A);	/* icause1 */
+		entry->extra = read_aux_reg(0x0B);	/* statsu32_l1 */
+		__asm__ __volatile__("mov %0, ilink1   \r\n" : "=r"(x));
+		entry->fault_addr = x;
+	}
+
+	if (timeline_ctr == (MAX_SNAPS - 1))
+		timeline_ctr = 0;
+	else
+		timeline_ctr++;
+
+	if (current_thread_info()->preempt_count == 0xFFFFFFFF)
+		sort_snaps(1);
+
+	if (event == SNAP_INTR_IN)
+		local_irq_restore(flags);
+}
+EXPORT_SYMBOL(take_snap2);
+
+/* CMP routine called by event sort
+ * When comparing the click time entries of @a to @b:
+ *  gt: returns 1
+ *  lt:  -1
+ *  eq: returns 0
+ */
+static int snap_cmp(const void *a, const void *b)
+{
+	timeline_log_t *click_a, *click_b;
+
+	click_a = (timeline_log_t *) a;
+	click_b = (timeline_log_t *) b;
+
+	if (click_a->time == click_b->time)
+		return 0;
+	else if (click_a->time < click_b->time)
+		return -1;
+
+	return 1;
+}
+
+/* Event Sort API, so that counter Rollover is not visibel to user */
+void sort_snaps(int halt_after_sort)
+{
+	int i;
+	unsigned int flags, tmp;
+
+	/* TODO SMP */
+	local_irq_save(flags);
+
+	take_snap(SNAP_SENTINEL, 0, 0);
+
+	sort(timeline_log, MAX_SNAPS, sizeof(timeline_log_t), snap_cmp, NULL);
+
+	for (i = 0; i < MAX_SNAPS; i++) {
+		memset(timeline_log[i].nm, 0, 16);
+
+		switch (timeline_log[i].event) {
+		case SNAP_TLB_FLUSH_ALL:
+			strcpy(timeline_log[i].nm, "TLB FLUSH ALL");
+			break;
+		case 85:
+			strcpy(timeline_log[i].nm, "FORK");
+			break;
+		case 86:
+			strcpy(timeline_log[i].nm, "EXEC");
+			break;
+		case 99:
+			strcpy(timeline_log[i].nm, "Slow-TLB-Write");
+			break;
+		case SNAP_EXCP_IN:
+			switch (timeline_log[i].cause >> 16) {
+			case 0x21:
+				strcpy(timeline_log[i].nm, "I-TLB");
+				break;
+			case 0x22:
+				strcpy(timeline_log[i].nm, "D-TLB");
+				break;
+			case 0x23:
+				strcpy(timeline_log[i].nm, "PROT-V-TLB");
+				break;
+			default:
+				strcpy(timeline_log[i].nm, "?#?");
+				break;
+			}
+			break;
+		case SNAP_EXCP_OUT_FAST:
+			strcpy(timeline_log[i].nm, "TLB Refill");
+			break;
+		case SNAP_EXCP_OUT:
+			strcpy(timeline_log[i].nm, "Excp-RET");
+			break;
+		case SNAP_TRAP_IN:
+			strcpy(timeline_log[i].nm, "SyCall :");
+			switch (timeline_log[i].cause) {
+			case 1:
+				strcat(timeline_log[i].nm, "Exit");
+				break;
+			case 2:
+				strcat(timeline_log[i].nm, "fork");
+				break;
+			case 114:
+				strcat(timeline_log[i].nm, "wait4");
+				break;
+			default:
+				strcat(timeline_log[i].nm, "???");
+			}
+			break;
+		case SNAP_TRAP_OUT:
+			strcpy(timeline_log[i].nm, "SyCall-RET");
+			break;
+		case SNAP_PRE_CTXSW_2_U:
+			strcpy(timeline_log[i].nm, "2-U-Ctx-sw");
+			break;
+		case SNAP_SENTINEL:
+			memset(&timeline_log[i], 0, sizeof(timeline_log[i]));
+			strcpy(timeline_log[i].nm, "----------");
+			break;
+		case SNAP_PRE_CTXSW_2_K:
+			strcpy(timeline_log[i].nm, "2-K-Ctx-sw");
+			break;
+		case SNAP_INTR_OUT:
+			strcpy(timeline_log[i].nm, "IRQ-OUT");
+			break;
+		case SNAP_INTR_OUT2:
+			strcpy(timeline_log[i].nm, "IRQ(2)-OUT");
+			break;
+		case SNAP_INTR_IN:
+			strcpy(timeline_log[i].nm, "IRQ-in");
+			break;
+		case SNAP_INTR_IN2:
+			strcpy(timeline_log[i].nm, "IRQ(2)-in");
+			break;
+		case SNAP_DO_PF_EXIT:
+			strcpy(timeline_log[i].nm, "PF-RET");
+			break;
+		case SNAP_PREEMPT_SCH_IRQ:
+			strcpy(timeline_log[i].nm, "Prem-Sch IRQ");
+			break;
+		case SNAP_PREEMPT_SCH:
+			strcpy(timeline_log[i].nm, "Prem-Sch");
+			break;
+		case SNAP_DO_PF_ENTER:
+			tmp = timeline_log[i].cause >> 16;
+			switch (tmp) {
+			case 0x21:
+				strcpy(timeline_log[i].nm, "PF-in:I-TLB");
+				break;
+			case 0x22:
+				strcpy(timeline_log[i].nm, "PF-in:D-TLB");
+				break;
+			case 0x23:
+				strcpy(timeline_log[i].nm, "PF-in:PROTV");
+				break;
+			default:
+				strcpy(timeline_log[i].nm, "PF-in:???");
+				break;
+			}
+			break;
+		case SNAP_SIGRETURN:
+			strcpy(timeline_log[i].nm, "sigreturn");
+			break;
+		case SNAP_BEFORE_SIG:
+			strcpy(timeline_log[i].nm, "before sig");
+			break;
+		}
+
+	}
+
+	if (halt_after_sort)
+		__asm__("flag 1");
+	else
+		local_irq_restore(flags);
+
+}
+EXPORT_SYMBOL(sort_snaps);
diff --git a/arch/arc/kernel/signal.c b/arch/arc/kernel/signal.c
index bc834da..2ec908b 100644
--- a/arch/arc/kernel/signal.c
+++ b/arch/arc/kernel/signal.c
@@ -54,6 +54,7 @@
 #include <linux/syscalls.h>
 #include <linux/tracehook.h>
 #include <asm/ucontext.h>
+#include <asm/event-log.h>
 
 #define _BLOCKABLE (~(sigmask(SIGKILL) | sigmask(SIGSTOP)))
 
@@ -137,6 +138,8 @@ SYSCALL_DEFINE0(rt_sigreturn)
 		if (do_sigaltstack(&sf->uc.uc_stack, NULL, regs->sp) == -EFAULT)
 			goto badframe;
 
+	take_snap(SNAP_SIGRETURN, 0, 0);
+
 	return regs->r0;
 
 badframe:
diff --git a/arch/arc/mm/tlb.c b/arch/arc/mm/tlb.c
index c10111d..0e5cb9f 100644
--- a/arch/arc/mm/tlb.c
+++ b/arch/arc/mm/tlb.c
@@ -56,6 +56,7 @@
 #include <asm/setup.h>
 #include <asm/mmu_context.h>
 #include <asm/tlb.h>
+#include <asm/event-log.h>
 
 /*			Need for ARC MMU v2
  *
@@ -191,6 +192,8 @@ noinline void local_flush_tlb_all(void)
 	unsigned int entry;
 	struct cpuinfo_arc_mmu *mmu = &cpuinfo_arc700[smp_processor_id()].mmu;
 
+	take_snap(SNAP_TLB_FLUSH_ALL, 0, 0);
+
 	local_irq_save(flags);
 
 	/* Load PD0 and PD1 with template for a Blank Entry */
diff --git a/arch/arc/mm/tlbex.S b/arch/arc/mm/tlbex.S
index fc5b971..86804d3 100644
--- a/arch/arc/mm/tlbex.S
+++ b/arch/arc/mm/tlbex.S
@@ -41,6 +41,7 @@
 #include <asm/entry.h>
 #include <asm/tlb.h>
 #include <asm/pgtable.h>
+#include <asm/event-log-asm.h>
 #include <asm/arcregs.h>
 #include <asm/cache.h>
 #include <asm/processor.h>
@@ -194,6 +195,9 @@ ex_saved_reg1:
 	st_s  r2, [r0, 8]
 	st_s  r3, [r0, 12]
 
+	; take a snapshot of upon entering FAST Path TLB Hdlr
+	TAKE_SNAP_ASM r0, r1, SNAP_EXCP_IN
+
 	; VERIFY if the ASID in MMU-PID Reg is same as
 	; one in Linux data structures
 
@@ -317,6 +321,9 @@ do_slow_path_pf:
 	; That requires freeing up r9
 	EXCPN_PROLOG_FREEUP_REG r9
 
+	; take a snapshot of upon entering SLOW Path TLB Hdlr
+	TAKE_SNAP_ASM r8, r9, SNAP_DO_PF_ENTER
+
 	lr  r9, [erstatus]
 
 	SWITCH_TO_KERNEL_STK
-- 
1.7.4.1

