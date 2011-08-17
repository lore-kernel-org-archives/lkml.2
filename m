Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574Ab1HQRGS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 13:06:18 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:26066 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754491Ab1HQRGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 13:06:04 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6440"; a="111004148"
Message-Id: <20110817163521.637768691@codeaurora.org>
User-Agent: quilt/0.48-1
Date: Wed, 17 Aug 2011 11:35:16 -0500
From: Richard Kuo <rkuo@codeaurora.org>
To: linux-kernel@vger.kernel.org, linux-hexagon@vger.kernel.org
Subject: [patch 19/36] Hexagon: Add ptrace support
References: <20110817163457.878854582@codeaurora.org>
Content-Disposition: inline; filename=ptrace.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Kuo <rkuo@codeaurora.org>

---
 arch/hexagon/include/asm/ptrace.h |   90 +++++++
 arch/hexagon/kernel/ptrace.c      |  437 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 527 insertions(+)

Index: linux-hexagon-kernel/arch/hexagon/include/asm/ptrace.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/ptrace.h	2011-07-20 15:19:41.335152144 -0500
@@ -0,0 +1,90 @@
+/*
+ * Ptrace definitions for the Hexagon architecture
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
+#ifndef _ASM_PTRACE_H
+#define _ASM_PTRACE_H
+
+#include <asm/registers.h>
+
+/*  arch_ptrace and ptrace_disable use task_struct in arg lists  */
+struct task_struct;
+
+/*
+ * ptrace commands not part of Linux base set (but common to essentially
+ * all supported architectures).
+ */
+
+#define PTRACE_GETREGS	12
+#define PTRACE_SETREGS	13
+
+/*
+ * Register numbers used in ptrace calls.  0-31 represent GPRs R0-R31
+ */
+#define PT_R0		0
+#define PT_R1		1
+#define PT_R2		2
+#define PT_R3		3
+#define PT_R4		4
+#define PT_R5		5
+#define PT_R6		6
+#define PT_R7		7
+#define PT_R8		8
+#define PT_R9		9
+#define PT_R10		10
+#define PT_R11		11
+#define PT_R12		12
+#define PT_R13		13
+#define PT_R14		14
+#define PT_R15		15
+#define PT_R16		16
+#define PT_R17		17
+#define PT_R18		18
+#define PT_R19		19
+#define PT_R20		20
+#define PT_R21		21
+#define PT_R22		22
+#define PT_R23		23
+#define PT_R24		24
+#define PT_R25		25
+#define PT_R26		26
+#define PT_R27		27
+#define PT_R28		28
+#define PT_R29		29
+#define PT_R30		30
+#define PT_R31		31
+#define PT_GP		32
+#define PT_UGP		33
+#define PT_SA0		34
+#define PT_LC0		35
+#define PT_SA1		36
+#define PT_LC1		37
+#define PT_M0		38
+#define PT_M1		39
+#define PT_PREDS	40
+#define PT_PC		41
+#define PT_CAUSE	42
+#define PT_BADVA	43
+
+#define N_PTRACE_REGS	44
+
+#define profile_pc(regs) instruction_pointer(regs)
+#define instruction_pointer(regs) pt_elr(regs)
+
+#endif
Index: linux-hexagon-kernel/arch/hexagon/kernel/ptrace.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/kernel/ptrace.c	2011-07-20 15:19:41.335152144 -0500
@@ -0,0 +1,437 @@
+/*
+ * Ptrace support for Hexagon
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
+#include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/mm.h>
+#include <linux/smp.h>
+#include <linux/errno.h>
+#include <linux/ptrace.h>
+#include <linux/user.h>
+
+#include <asm/uaccess.h>
+#include <asm/page.h>
+#include <asm/pgtable.h>
+#include <asm/system.h>
+#include <asm/processor.h>
+#include <asm/cacheflush.h>
+
+/*  ToDo:  see include/linux/regset.h  */
+
+void ptrace_disable(struct task_struct *child)
+{
+	/* Boilerplate - resolves to null inline if no HW single-step */
+	user_disable_single_step(child);
+}
+
+/*
+ * Examine a specific register of a task
+ */
+static int ptrace_peekusr(struct task_struct *child, int regnum,
+			  void __user *data)
+{
+	struct pt_regs *regs = task_pt_regs(child);
+	unsigned long tmp;
+
+	switch (regnum) {
+	case PT_R0:
+		tmp = regs->r00;
+		break;
+	case PT_R1:
+		tmp = regs->r01;
+		break;
+	case PT_R2:
+		tmp = regs->r02;
+		break;
+	case PT_R3:
+		tmp = regs->r03;
+		break;
+	case PT_R4:
+		tmp = regs->r04;
+		break;
+	case PT_R5:
+		tmp = regs->r05;
+		break;
+	case PT_R6:
+		tmp = regs->r06;
+		break;
+	case PT_R7:
+		tmp = regs->r07;
+		break;
+	case PT_R8:
+		tmp = regs->r08;
+		break;
+	case PT_R9:
+		tmp = regs->r09;
+		break;
+	case PT_R10:
+		tmp = regs->r10;
+		break;
+	case PT_R11:
+		tmp = regs->r11;
+		break;
+	case PT_R12:
+		tmp = regs->r12;
+		break;
+	case PT_R13:
+		tmp = regs->r13;
+		break;
+	case PT_R14:
+		tmp = regs->r14;
+		break;
+	case PT_R15:
+		tmp = regs->r15;
+		break;
+	case PT_R16:
+		tmp = regs->r16;
+		break;
+	case PT_R17:
+		tmp = regs->r17;
+		break;
+	case PT_R18:
+		tmp = regs->r18;
+		break;
+	case PT_R19:
+		tmp = regs->r19;
+		break;
+	case PT_R20:
+		tmp = regs->r20;
+		break;
+	case PT_R21:
+		tmp = regs->r21;
+		break;
+	case PT_R22:
+		tmp = regs->r22;
+		break;
+	case PT_R23:
+		tmp = regs->r23;
+		break;
+	case PT_R24:
+		tmp = regs->r24;
+		break;
+	case PT_R25:
+		tmp = regs->r25;
+		break;
+	case PT_R26:
+		tmp = regs->r26;
+		break;
+	case PT_R27:
+		tmp = regs->r27;
+		break;
+	case PT_R28:
+		tmp = regs->r28;
+		break;
+	case PT_R29:
+		tmp = regs->r29;
+		break;
+	case PT_R30:
+		tmp = regs->r30;
+		break;
+	case PT_R31:
+		tmp = regs->r31;
+		break;
+	case PT_GP:
+		tmp = regs->gp;
+		break;
+	case PT_UGP:
+		tmp = regs->ugp;
+		break;
+	case PT_SA0:
+		tmp = regs->sa0;
+		break;
+	case PT_LC0:
+		tmp = regs->lc0;
+		break;
+	case PT_SA1:
+		tmp = regs->sa1;
+		break;
+	case PT_LC1:
+		tmp = regs->lc1;
+		break;
+	case PT_M0:
+		tmp = regs->m0;
+		break;
+	case PT_M1:
+		tmp = regs->m1;
+		break;
+	case PT_PREDS:
+		tmp = regs->preds;
+		break;
+	case PT_PC:
+		tmp = pt_elr(regs);
+		break;
+	case PT_CAUSE:
+		tmp = pt_cause(regs);
+		break;
+	case PT_BADVA:
+		tmp = pt_badva(regs);
+		break;
+	default:
+		return -EIO;
+	}
+	return put_user(tmp, (unsigned long __user *)data);
+}
+
+/*
+ * Modify a specific register of a task.  CAUSE and BADVA aren't writeable.
+ */
+static int ptrace_pokeusr(struct task_struct *child, int regnum,
+				unsigned long data)
+{
+	struct pt_regs *regs = task_pt_regs(child);
+
+	switch (regnum) {
+	case PT_R0:
+		regs->r00 = data;
+		break;
+	case PT_R1:
+		regs->r01 = data;
+		break;
+	case PT_R2:
+		regs->r02 = data;
+		break;
+	case PT_R3:
+		regs->r03 = data;
+		break;
+	case PT_R4:
+		regs->r04 = data;
+		break;
+	case PT_R5:
+		regs->r05 = data;
+		break;
+	case PT_R6:
+		regs->r06 = data;
+		break;
+	case PT_R7:
+		regs->r07 = data;
+		break;
+	case PT_R8:
+		regs->r08 = data;
+		break;
+	case PT_R9:
+		regs->r09 = data;
+		break;
+	case PT_R10:
+		regs->r10 = data;
+		break;
+	case PT_R11:
+		regs->r11 = data;
+		break;
+	case PT_R12:
+		regs->r12 = data;
+		break;
+	case PT_R13:
+		regs->r13 = data;
+		break;
+	case PT_R14:
+		regs->r14 = data;
+		break;
+	case PT_R15:
+		regs->r15 = data;
+		break;
+	case PT_R16:
+		regs->r16 = data;
+		break;
+	case PT_R17:
+		regs->r17 = data;
+		break;
+	case PT_R18:
+		regs->r18 = data;
+		break;
+	case PT_R19:
+		regs->r19 = data;
+		break;
+	case PT_R20:
+		regs->r20 = data;
+		break;
+	case PT_R21:
+		regs->r21 = data;
+		break;
+	case PT_R22:
+		regs->r22 = data;
+		break;
+	case PT_R23:
+		regs->r23 = data;
+		break;
+	case PT_R24:
+		regs->r24 = data;
+		break;
+	case PT_R25:
+		regs->r25 = data;
+		break;
+	case PT_R26:
+		regs->r26 = data;
+		break;
+	case PT_R27:
+		regs->r27 = data;
+		break;
+	case PT_R28:
+		regs->r28 = data;
+		break;
+	case PT_R29:
+		regs->r29 = data;
+		/*
+		 * This is special; SP is actually restored by the VM via the
+		 * special event record which is set by the special trap.
+		 */
+		regs->hvmer.vmpsp = data;
+		break;
+	case PT_R30:
+		regs->r30 = data;
+		break;
+	case PT_R31:
+		regs->r31 = data;
+		break;
+	case PT_GP:
+		regs->gp = data;
+		break;
+	case PT_UGP:
+		regs->ugp = data;
+		break;
+	case PT_SA0:
+		regs->sa0 = data;
+		break;
+	case PT_LC0:
+		regs->lc0 = data;
+		break;
+	case PT_SA1:
+		regs->sa1 = data;
+		break;
+	case PT_LC1:
+		regs->lc1 = data;
+		break;
+	case PT_M0:
+		regs->m0 = data;
+		break;
+	case PT_M1:
+		regs->m1 = data;
+		break;
+	case PT_PREDS:
+		regs->preds = data;
+		break;
+	case PT_PC:
+		pt_elr(regs) = data;
+		break;
+	default:
+		return -EIO;
+	}
+	return 0;
+}
+
+#define reg_acc(err, fn, reg, offset)	\
+	do {				\
+		err = fn(reg, offset);	\
+		if (err)		\
+			return err;	\
+	} while (0)
+
+/*
+ * Read the full register set of a task.  Layout is *not* the same
+ * as pt_regs, but is instead an array of longs whose indices are
+ * defined in ptrace.h.
+ */
+int ptrace_getregs(struct task_struct *child, unsigned long __user *data)
+{
+	struct pt_regs *regs = task_pt_regs(child);
+	int err;
+	int i;
+
+	if (!access_ok(VERIFY_WRITE, data, N_PTRACE_REGS * sizeof(long)))
+		return -EIO;
+
+	for (i = 0; i < 32; i++)
+		reg_acc(err, __put_user, *((unsigned long *)(&regs->r0100) + i),
+			data + i);
+
+	reg_acc(err, __put_user, regs->gp, data + PT_GP);
+	reg_acc(err, __put_user, regs->ugp, data + PT_UGP);
+	reg_acc(err, __put_user, regs->sa0, data + PT_SA0);
+	reg_acc(err, __put_user, regs->lc0, data + PT_LC0);
+	reg_acc(err, __put_user, regs->sa1, data + PT_SA1);
+	reg_acc(err, __put_user, regs->lc1, data + PT_LC1);
+	reg_acc(err, __put_user, regs->m0, data + PT_M0);
+	reg_acc(err, __put_user, regs->m1, data + PT_M1);
+	reg_acc(err, __put_user, regs->preds, data + PT_PREDS);
+	reg_acc(err, __put_user, pt_elr(regs), data + PT_PC);
+	reg_acc(err, __put_user, pt_cause(regs), data + PT_CAUSE);
+	reg_acc(err, __put_user, pt_badva(regs), data + PT_BADVA);
+
+	return 0;
+}
+
+/*
+ * Write the full register set of a task, with same layout as ptrace_getregs.
+ * BADVA and CAUSE aren't modifiable, however.
+ */
+int ptrace_setregs(struct task_struct *child, unsigned long __user *data)
+{
+	struct pt_regs *regs = task_pt_regs(child);
+	int i;
+	int err;
+
+	if (!access_ok(VERIFY_READ, data, (N_PTRACE_REGS - 2) * sizeof(long)))
+		return -EIO;
+
+	for (i = 0; i < 32; i++)
+		reg_acc(err, __get_user, *((unsigned long *)(&regs->r0100) + i),
+			data + i);
+
+	reg_acc(err, __get_user, regs->gp, data + PT_GP);
+	reg_acc(err, __get_user, regs->ugp, data + PT_UGP);
+	reg_acc(err, __get_user, regs->sa0, data + PT_SA0);
+	reg_acc(err, __get_user, regs->lc0, data + PT_LC0);
+	reg_acc(err, __get_user, regs->sa1, data + PT_SA1);
+	reg_acc(err, __get_user, regs->lc1, data + PT_LC1);
+	reg_acc(err, __get_user, regs->m0, data + PT_M0);
+	reg_acc(err, __get_user, regs->m1, data + PT_M1);
+	reg_acc(err, __get_user, regs->preds, data + PT_PREDS);
+	reg_acc(err, __get_user, pt_elr(regs), data + PT_PC);
+
+	return 0;
+}
+
+long arch_ptrace(struct task_struct *child, long request,
+		 unsigned long addr, unsigned long data)
+{
+	int ret;
+
+	switch (request) {
+	case PTRACE_PEEKUSR:	/* read register specified by addr. */
+		ret = ptrace_peekusr(child, addr, (void __user *) data);
+		break;
+	case PTRACE_POKETEXT:	/* write the word at location addr. */
+	case PTRACE_POKEDATA:
+		ret = generic_ptrace_pokedata(child, addr, data);
+		break;
+	case PTRACE_POKEUSR:	/* write register specified by addr. */
+		ret = ptrace_pokeusr(child, addr, data);
+		break;
+	case PTRACE_GETREGS:
+		ret = ptrace_getregs(child, (void __user *) data);
+		break;
+	case PTRACE_SETREGS:
+		ret = ptrace_setregs(child, (void __user *) data);
+		break;
+	default:
+		ret = ptrace_request(child, request, addr, data);
+	}
+
+	return ret;
+}

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

