Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285Ab1HQRFn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 13:05:43 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:26038 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754226Ab1HQRFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 13:05:40 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6440"; a="111004091"
Message-Id: <20110817163520.513397876@codeaurora.org>
User-Agent: quilt/0.48-1
Date: Wed, 17 Aug 2011 11:35:04 -0500
From: Richard Kuo <rkuo@codeaurora.org>
To: linux-kernel@vger.kernel.org, linux-hexagon@vger.kernel.org
Subject: [patch 07/36] Hexagon: Add threadinfo
References: <20110817163457.878854582@codeaurora.org>
Content-Disposition: inline; filename=thread.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Kuo <rkuo@codeaurora.org>

---
 arch/hexagon/include/asm/current.h     |    6 +
 arch/hexagon/include/asm/thread_info.h |  197 +++++++++++++++++++++++++++++++++
 2 files changed, 203 insertions(+)

Index: linux-hexagon-kernel/arch/hexagon/include/asm/current.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/current.h	2011-07-20 15:19:37.415153317 -0500
@@ -0,0 +1,6 @@
+#ifndef _ASM_CURRENT_H
+#define _ASM_CURRENT_H
+
+#include <asm-generic/current.h>
+
+#endif /* _ASM_CURRENT_H */
Index: linux-hexagon-kernel/arch/hexagon/include/asm/thread_info.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/thread_info.h	2011-07-20 15:19:37.415153317 -0500
@@ -0,0 +1,197 @@
+/*
+ * Thread support for the Hexagon architecture
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
+#ifndef _ASM_THREAD_INFO_H
+#define _ASM_THREAD_INFO_H
+
+#ifdef __KERNEL__
+
+#ifndef __ASSEMBLY__
+#include <asm/processor.h>
+#include <asm/registers.h>
+#endif
+
+/*
+ * order is for __get_free_pages; see get_order()
+ */
+
+#ifdef CONFIG_PAGE_SIZE_4KB
+#define THREAD_SIZE	(1<<13)
+#define THREAD_SIZE_ORDER 1
+#endif
+
+#ifdef CONFIG_PAGE_SIZE_16KB
+#define THREAD_SIZE	(1<<14)
+#define THREAD_SIZE_ORDER 0
+#endif
+
+#ifdef CONFIG_PAGE_SIZE_64KB
+#define THREAD_SIZE	(1<<16)
+#define THREAD_SIZE_ORDER 0
+#endif
+
+#ifdef CONFIG_PAGE_SIZE_256KB
+#define THREAD_SIZE	(1<<18)
+#define THREAD_SIZE_ORDER 0
+#endif
+
+#ifndef __ASSEMBLY__
+
+typedef struct {
+	unsigned long seg;
+} mm_segment_t;
+
+/*
+ * This is union'd with the "bottom" of the kernel stack.
+ * It keeps track of thread info which is handy for routines
+ * to access quickly.
+ */
+
+struct thread_info {
+	struct task_struct	*task;		/* main task structure */
+	struct exec_domain      *exec_domain;   /* execution domain */
+	unsigned long		flags;          /* low level flags */
+	__u32                   cpu;            /* current cpu */
+	int                     preempt_count;  /* 0=>preemptible,<0=>BUG */
+	mm_segment_t            addr_limit;     /* segmentation sux */
+	/*
+	 * used for syscalls somehow;
+	 * seems to have a function pointer and four arguments
+	 */
+	struct restart_block    restart_block;
+	/* Points to the current pt_regs frame  */
+	struct pt_regs		*regs;
+	/*
+	 * saved kernel sp at switch_to time;
+	 * not sure if this is used (it's not in the VM model it seems;
+	 * see thread_struct)
+	 */
+	unsigned long		sp;
+};
+
+#else /* !__ASSEMBLY__ */
+
+#include <asm/asm-offsets.h>
+
+#endif  /* __ASSEMBLY__  */
+
+/*  looks like "linux/hardirq.h" uses this.  */
+
+#define PREEMPT_ACTIVE		0x10000000
+
+#ifndef __ASSEMBLY__
+
+#define INIT_THREAD_INFO(tsk)                   \
+{                                               \
+	.task           = &tsk,                 \
+	.exec_domain    = &default_exec_domain, \
+	.flags          = 0,                    \
+	.cpu            = 0,                    \
+	.preempt_count  = 1,                    \
+	.addr_limit     = KERNEL_DS,            \
+	.restart_block = {                      \
+		.fn = do_no_restart_syscall,    \
+	},                                      \
+	.sp = 0,				\
+	.regs = NULL,			\
+}
+
+#define init_thread_info        (init_thread_union.thread_info)
+#define init_stack              (init_thread_union.stack)
+
+/* Tacky preprocessor trickery */
+#define	qqstr(s) qstr(s)
+#define qstr(s) #s
+#define QUOTED_THREADINFO_REG qqstr(THREADINFO_REG)
+
+register struct thread_info *__current_thread_info asm(QUOTED_THREADINFO_REG);
+#define current_thread_info()  __current_thread_info
+
+/*  defined in process.c  */
+#if 0
+extern void free_thread_info(struct thread_info *thread);
+#endif
+
+/* thread information allocation */
+
+/*
+ * kmalloc is probably not appropriate because alignment seems
+ * not guaranteed out of kmalloc at all, and we assume thread_info
+ * is aligned to THREAD_SIZE all over the place, notably the switch and
+ * entry/exit routines.
+ */
+
+#if 0
+#define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
+#ifdef CONFIG_DEBUG_STACK_USAGE
+#define alloc_thread_info(tsk) \
+	((struct thread_info *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, \
+	THREAD_SIZE_ORDER))
+
+#else   /*  CONFIG_DEBUG_STACK_USAGE  */
+#define alloc_thread_info(tsk) \
+	((struct thread_info *)__get_free_pages(GFP_KERNEL, \
+	THREAD_SIZE_ORDER))
+#endif  /*  ! CONFIG_DEBUG_STACK_USAGE  */
+
+
+#define free_thread_info(info) \
+	free_pages((unsigned long)info, THREAD_SIZE_ORDER);
+#endif
+
+#endif /* __ASSEMBLY__ */
+
+/*
+ * thread information flags
+ * - these are process state flags that various assembly files
+ *   may need to access
+ * - pending work-to-be-done flags are in LSW
+ * - other flags in MSW
+ */
+
+#define TIF_SYSCALL_TRACE       0       /* syscall trace active */
+#define TIF_NOTIFY_RESUME       1       /* resumption notification requested */
+#define TIF_SIGPENDING          2       /* signal pending */
+#define TIF_NEED_RESCHED        3       /* rescheduling necessary */
+#define TIF_SINGLESTEP          4       /* restore ss @ return to usr mode */
+#define TIF_IRET                5       /* return with iret */
+#define TIF_RESTORE_SIGMASK     6       /* restore sig mask in do_signal() */
+/* true if poll_idle() is polling TIF_NEED_RESCHED */
+#define TIF_POLLING_NRFLAG      16
+#define TIF_MEMDIE              17      /* OOM killer killed process */
+
+#define _TIF_SYSCALL_TRACE      (1 << TIF_SYSCALL_TRACE)
+#define _TIF_NOTIFY_RESUME      (1 << TIF_NOTIFY_RESUME)
+#define _TIF_SIGPENDING         (1 << TIF_SIGPENDING)
+#define _TIF_NEED_RESCHED       (1 << TIF_NEED_RESCHED)
+#define _TIF_SINGLESTEP         (1 << TIF_SINGLESTEP)
+#define _TIF_IRET               (1 << TIF_IRET)
+#define _TIF_RESTORE_SIGMASK    (1 << TIF_RESTORE_SIGMASK)
+#define _TIF_POLLING_NRFLAG     (1 << TIF_POLLING_NRFLAG)
+
+/* work to do on interrupt/exception return - All but TIF_SYSCALL_TRACE */
+#define _TIF_WORK_MASK          (0x0000FFFF & ~_TIF_SYSCALL_TRACE)
+
+/* work to do on any return to u-space */
+#define _TIF_ALLWORK_MASK       0x0000FFFF
+
+#endif /* __KERNEL__ */
+
+#endif

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

