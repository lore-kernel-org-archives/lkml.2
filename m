Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657Ab2LEQJo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 11:09:44 -0500
Received: from multi.imgtec.com ([194.200.65.239]:55566 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753222Ab2LEQJf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 11:09:35 -0500
From: James Hogan <james.hogan@imgtec.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, James Hogan <james.hogan@imgtec.com>
Subject: [PATCH v2 21/44] metag: ptrace
Date: Wed, 5 Dec 2012 16:08:39 +0000
Message-ID: <1354723742-6195-22-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com>
References: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2012_12_05_16_09_25
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ptrace interface for metag provides access to some core register
sets using the PTRACE_GETREGSET and PTRACE_SETREGSET operations. The
details of the internal context structures is abstracted into user API
structures to both ease use and allow flexibility to change the internal
context layouts. Copyin and copyout functions for these register sets
are exposed to allow signal handling code to use them to copy to and
from the signal context.

struct user_gp_regs (NT_PRSTATUS) provides access to the core general
purpose register context.

struct user_cb_regs (NT_METAG_CBUF) provides access to the TXCATCH*
registers which contains information abuot a memory fault, unaligned
access error or watchpoint. This can be modified to alter the way the
fault is replayed on resume ("catch replay"), or to prevent the replay
taking place.

struct user_rp_state (NT_METAG_RPIPE) provides access to the state of
the Meta read pipeline which can be used to hide memory latencies in
hand optimised data loops.

Extended DSP register state, DSP RAM, and hardware breakpoint registers
aren't yet exposed through ptrace.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 arch/metag/include/asm/ptrace.h      |   60 ++++++
 arch/metag/include/uapi/asm/ptrace.h |  113 ++++++++++
 arch/metag/kernel/ptrace.c           |  380 ++++++++++++++++++++++++++++++++++
 include/uapi/linux/elf.h             |    2 +
 4 files changed, 555 insertions(+), 0 deletions(-)
 create mode 100644 arch/metag/include/asm/ptrace.h
 create mode 100644 arch/metag/include/uapi/asm/ptrace.h
 create mode 100644 arch/metag/kernel/ptrace.c

diff --git a/arch/metag/include/asm/ptrace.h b/arch/metag/include/asm/ptrace.h
new file mode 100644
index 0000000..fcabc18
--- /dev/null
+++ b/arch/metag/include/asm/ptrace.h
@@ -0,0 +1,60 @@
+#ifndef _METAG_PTRACE_H
+#define _METAG_PTRACE_H
+
+#include <linux/compiler.h>
+#include <uapi/asm/ptrace.h>
+#include <asm/tbx.h>
+
+#ifndef __ASSEMBLY__
+
+/* this struct defines the way the registers are stored on the
+   stack during a system call. */
+
+struct pt_regs {
+	TBICTX ctx;
+	TBICTXEXTCB0 extcb0[5];
+};
+
+#define user_mode(regs) (((regs)->ctx.SaveMask & TBICTX_PRIV_BIT) > 0)
+
+#define instruction_pointer(regs) ((unsigned long)(regs)->ctx.CurrPC)
+#define profile_pc(regs) instruction_pointer(regs)
+
+#define task_pt_regs(task) \
+	((struct pt_regs *)(task_stack_page(task) + \
+			    sizeof(struct thread_info)))
+
+#define current_pt_regs() \
+	((struct pt_regs *)((char *)current_thread_info() + \
+			    sizeof(struct thread_info)))
+
+int syscall_trace_enter(struct pt_regs *regs);
+void syscall_trace_leave(struct pt_regs *regs);
+
+/* copy a struct user_gp_regs out to user */
+int metag_gp_regs_copyout(const struct pt_regs *regs,
+			  unsigned int pos, unsigned int count,
+			  void *kbuf, void __user *ubuf);
+/* copy a struct user_gp_regs in from user */
+int metag_gp_regs_copyin(struct pt_regs *regs,
+			 unsigned int pos, unsigned int count,
+			 const void *kbuf, const void __user *ubuf);
+/* copy a struct user_cb_regs out to user */
+int metag_cb_regs_copyout(const struct pt_regs *regs,
+			  unsigned int pos, unsigned int count,
+			  void *kbuf, void __user *ubuf);
+/* copy a struct user_cb_regs in from user */
+int metag_cb_regs_copyin(struct pt_regs *regs,
+			 unsigned int pos, unsigned int count,
+			 const void *kbuf, const void __user *ubuf);
+/* copy a struct user_rp_state out to user */
+int metag_rp_state_copyout(const struct pt_regs *regs,
+			   unsigned int pos, unsigned int count,
+			   void *kbuf, void __user *ubuf);
+/* copy a struct user_rp_state in from user */
+int metag_rp_state_copyin(struct pt_regs *regs,
+			  unsigned int pos, unsigned int count,
+			  const void *kbuf, const void __user *ubuf);
+
+#endif /* __ASSEMBLY__ */
+#endif /* _METAG_PTRACE_H */
diff --git a/arch/metag/include/uapi/asm/ptrace.h b/arch/metag/include/uapi/asm/ptrace.h
new file mode 100644
index 0000000..45d9780
--- /dev/null
+++ b/arch/metag/include/uapi/asm/ptrace.h
@@ -0,0 +1,113 @@
+#ifndef _UAPI_METAG_PTRACE_H
+#define _UAPI_METAG_PTRACE_H
+
+#ifndef __ASSEMBLY__
+
+/*
+ * These are the layouts of the regsets returned by the GETREGSET ptrace call
+ */
+
+/* user_gp_regs::status */
+
+/* CBMarker bit (indicates catch state / catch replay) */
+#define USER_GP_REGS_STATUS_CATCH_BIT		(1 << 22)
+#define USER_GP_REGS_STATUS_CATCH_S		22
+/* LSM_STEP field (load/store multiple step) */
+#define USER_GP_REGS_STATUS_LSM_STEP_BITS	(0x7 << 8)
+#define USER_GP_REGS_STATUS_LSM_STEP_S		8
+/* SCC bit (indicates split 16x16 condition flags) */
+#define USER_GP_REGS_STATUS_SCC_BIT		(1 << 4)
+#define USER_GP_REGS_STATUS_SCC_S		4
+
+/* normal condition flags */
+/* CF_Z bit (Zero flag) */
+#define USER_GP_REGS_STATUS_CF_Z_BIT		(1 << 3)
+#define USER_GP_REGS_STATUS_CF_Z_S		3
+/* CF_N bit (Negative flag) */
+#define USER_GP_REGS_STATUS_CF_N_BIT		(1 << 2)
+#define USER_GP_REGS_STATUS_CF_N_S		2
+/* CF_V bit (oVerflow flag) */
+#define USER_GP_REGS_STATUS_CF_V_BIT		(1 << 1)
+#define USER_GP_REGS_STATUS_CF_V_S		1
+/* CF_C bit (Carry flag) */
+#define USER_GP_REGS_STATUS_CF_C_BIT		(1 << 0)
+#define USER_GP_REGS_STATUS_CF_C_S		0
+
+/* split 16x16 condition flags */
+/* SCF_LZ bit (Low Zero flag) */
+#define USER_GP_REGS_STATUS_SCF_LZ_BIT		(1 << 3)
+#define USER_GP_REGS_STATUS_SCF_LZ_S		3
+/* SCF_HZ bit (High Zero flag) */
+#define USER_GP_REGS_STATUS_SCF_HZ_BIT		(1 << 2)
+#define USER_GP_REGS_STATUS_SCF_HZ_S		2
+/* SCF_HC bit (High Carry flag) */
+#define USER_GP_REGS_STATUS_SCF_HC_BIT		(1 << 1)
+#define USER_GP_REGS_STATUS_SCF_HC_S		1
+/* SCF_LC bit (Low Carry flag) */
+#define USER_GP_REGS_STATUS_SCF_LC_BIT		(1 << 0)
+#define USER_GP_REGS_STATUS_SCF_LC_S		0
+
+/**
+ * struct user_gp_regs - User general purpose registers
+ * @dx:		GP data unit regs (dx[reg][unit] = D{unit:0-1}.{reg:0-7})
+ * @ax:		GP address unit regs (ax[reg][unit] = A{unit:0-1}.{reg:0-3})
+ * @pc:		PC register
+ * @status:	TXSTATUS register (condition flags, LSM_STEP etc)
+ * @rpt:	TXRPT registers (branch repeat counter)
+ * @bpobits:	TXBPOBITS register ("branch prediction other" bits)
+ * @mode:	TXMODE register
+ * @_pad1:	Reserved padding to make sizeof obviously 64bit aligned
+ *
+ * This is the user-visible general purpose register state structure.
+ *
+ * It can be accessed through PTRACE_GETREGSET with NT_PRSTATUS.
+ *
+ * It is also used in the signal context.
+ */
+struct user_gp_regs {
+	unsigned long dx[8][2];
+	unsigned long ax[4][2];
+	unsigned long pc;
+	unsigned long status;
+	unsigned long rpt;
+	unsigned long bpobits;
+	unsigned long mode;
+	unsigned long _pad1;
+};
+
+/**
+ * struct user_cb_regs - User catch buffer registers
+ * @flags:	TXCATCH0 register (fault flags)
+ * @addr:	TXCATCH1 register (fault address)
+ * @data:	TXCATCH2 and TXCATCH3 registers (low and high data word)
+ *
+ * This is the user-visible catch buffer register state structure containing
+ * information about a failed memory access, and allowing the access to be
+ * modified and replayed.
+ *
+ * It can be accessed through PTRACE_GETREGSET with NT_METAG_CBUF.
+ */
+struct user_cb_regs {
+	unsigned long flags;
+	unsigned long addr;
+	unsigned long long data;
+};
+
+/**
+ * struct user_rp_state - User read pipeline state
+ * @entries:	Read pipeline entries
+ * @mask:	Mask of valid pipeline entries (RPMask from TXDIVTIME register)
+ *
+ * This is the user-visible read pipeline state structure containing the entries
+ * currently in the read pipeline and the mask of valid entries.
+ *
+ * It can be accessed through PTRACE_GETREGSET with NT_METAG_RPIPE.
+ */
+struct user_rp_state {
+	unsigned long long entries[6];
+	unsigned long mask;
+};
+
+#endif /* __ASSEMBLY__ */
+
+#endif /* _UAPI_METAG_PTRACE_H */
diff --git a/arch/metag/kernel/ptrace.c b/arch/metag/kernel/ptrace.c
new file mode 100644
index 0000000..d0af0a1
--- /dev/null
+++ b/arch/metag/kernel/ptrace.c
@@ -0,0 +1,380 @@
+/*
+ *  Copyright (C) 2005-2012 Imagination Technologies Ltd.
+ *
+ * This file is subject to the terms and conditions of the GNU General
+ * Public License.  See the file COPYING in the main directory of
+ * this archive for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/errno.h>
+#include <linux/ptrace.h>
+#include <linux/user.h>
+#include <linux/regset.h>
+#include <linux/tracehook.h>
+#include <linux/elf.h>
+#include <linux/uaccess.h>
+#include <trace/syscall.h>
+
+#define CREATE_TRACE_POINTS
+#include <trace/events/syscalls.h>
+
+/*
+ * user_regset definitions.
+ */
+
+int metag_gp_regs_copyout(const struct pt_regs *regs,
+			  unsigned int pos, unsigned int count,
+			  void *kbuf, void __user *ubuf)
+{
+	const void *ptr;
+	unsigned long data;
+	int ret;
+
+	/* D{0-1}.{0-7} */
+	ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+				  regs->ctx.DX, 0, 4*16);
+	if (ret)
+		goto out;
+	/* A{0-1}.{0-1} */
+	ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+				  regs->ctx.AX, 4*16, 4*20);
+	if (ret)
+		goto out;
+	/* A{0-1}.2 */
+	if (regs->ctx.SaveMask & TBICTX_XEXT_BIT)
+		ptr = regs->ctx.Ext.Ctx.pExt;
+	else
+		ptr = &regs->ctx.Ext.AX2;
+	ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+				  ptr, 4*20, 4*22);
+	if (ret)
+		goto out;
+	/* A{0-1}.3 */
+	ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+				  &regs->ctx.AX3, 4*22, 4*24);
+	if (ret)
+		goto out;
+	/* PC */
+	ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+				  &regs->ctx.CurrPC, 4*24, 4*25);
+	if (ret)
+		goto out;
+	/* TXSTATUS */
+	data = (unsigned long)regs->ctx.Flags;
+	if (regs->ctx.SaveMask & TBICTX_CBUF_BIT)
+		data |= USER_GP_REGS_STATUS_CATCH_BIT;
+	ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+				  &data, 4*25, 4*26);
+	if (ret)
+		goto out;
+	/* TXRPT, TXBPOBITS, TXMODE */
+	ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+				  &regs->ctx.CurrRPT, 4*26, 4*29);
+	if (ret)
+		goto out;
+	/* Padding */
+	ret = user_regset_copyout_zero(&pos, &count, &kbuf, &ubuf,
+				       4*29, 4*30);
+out:
+	return ret;
+}
+
+int metag_gp_regs_copyin(struct pt_regs *regs,
+			 unsigned int pos, unsigned int count,
+			 const void *kbuf, const void __user *ubuf)
+{
+	void *ptr;
+	unsigned long data;
+	int ret;
+
+	/* D{0-1}.{0-7} */
+	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
+				 regs->ctx.DX, 0, 4*16);
+	if (ret)
+		goto out;
+	/* A{0-1}.{0-1} */
+	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
+				 regs->ctx.AX, 4*16, 4*20);
+	if (ret)
+		goto out;
+	/* A{0-1}.2 */
+	if (regs->ctx.SaveMask & TBICTX_XEXT_BIT)
+		ptr = regs->ctx.Ext.Ctx.pExt;
+	else
+		ptr = &regs->ctx.Ext.AX2;
+	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
+				 ptr, 4*20, 4*22);
+	if (ret)
+		goto out;
+	/* A{0-1}.3 */
+	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
+				 &regs->ctx.AX3, 4*22, 4*24);
+	if (ret)
+		goto out;
+	/* PC */
+	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
+				 &regs->ctx.CurrPC, 4*24, 4*25);
+	if (ret)
+		goto out;
+	/* TXSTATUS */
+	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
+				 &data, 4*25, 4*26);
+	if (ret)
+		goto out;
+	regs->ctx.Flags = data & 0xffff;
+	if (data & USER_GP_REGS_STATUS_CATCH_BIT)
+		regs->ctx.SaveMask |= TBICTX_XCBF_BIT | TBICTX_CBUF_BIT;
+	else
+		regs->ctx.SaveMask &= ~TBICTX_CBUF_BIT;
+	/* TXRPT, TXBPOBITS, TXMODE */
+	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
+				 &regs->ctx.CurrRPT, 4*26, 4*29);
+out:
+	return ret;
+}
+
+static int metag_gp_regs_get(struct task_struct *target,
+			     const struct user_regset *regset,
+			     unsigned int pos, unsigned int count,
+			     void *kbuf, void __user *ubuf)
+{
+	const struct pt_regs *regs = task_pt_regs(target);
+	return metag_gp_regs_copyout(regs, pos, count, kbuf, ubuf);
+}
+
+static int metag_gp_regs_set(struct task_struct *target,
+			     const struct user_regset *regset,
+			     unsigned int pos, unsigned int count,
+			     const void *kbuf, const void __user *ubuf)
+{
+	struct pt_regs *regs = task_pt_regs(target);
+	return metag_gp_regs_copyin(regs, pos, count, kbuf, ubuf);
+}
+
+int metag_cb_regs_copyout(const struct pt_regs *regs,
+			  unsigned int pos, unsigned int count,
+			  void *kbuf, void __user *ubuf)
+{
+	int ret;
+
+	/* TXCATCH{0-3} */
+	if (regs->ctx.SaveMask & TBICTX_XCBF_BIT)
+		ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+					  regs->extcb0, 0, 4*4);
+	else
+		ret = user_regset_copyout_zero(&pos, &count, &kbuf, &ubuf,
+					       0, 4*4);
+	return ret;
+}
+
+int metag_cb_regs_copyin(struct pt_regs *regs,
+			 unsigned int pos, unsigned int count,
+			 const void *kbuf, const void __user *ubuf)
+{
+	int ret;
+
+	/* TXCATCH{0-3} */
+	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
+				 regs->extcb0, 0, 4*4);
+	return ret;
+}
+
+static int metag_cb_regs_get(struct task_struct *target,
+			     const struct user_regset *regset,
+			     unsigned int pos, unsigned int count,
+			     void *kbuf, void __user *ubuf)
+{
+	const struct pt_regs *regs = task_pt_regs(target);
+	return metag_cb_regs_copyout(regs, pos, count, kbuf, ubuf);
+}
+
+static int metag_cb_regs_set(struct task_struct *target,
+			     const struct user_regset *regset,
+			     unsigned int pos, unsigned int count,
+			     const void *kbuf, const void __user *ubuf)
+{
+	struct pt_regs *regs = task_pt_regs(target);
+	return metag_cb_regs_copyin(regs, pos, count, kbuf, ubuf);
+}
+
+int metag_rp_state_copyout(const struct pt_regs *regs,
+			   unsigned int pos, unsigned int count,
+			   void *kbuf, void __user *ubuf)
+{
+	unsigned long mask;
+	u64 *ptr;
+	int ret, i;
+
+	/* Empty read pipeline */
+	if (!(regs->ctx.SaveMask & TBICTX_CBRP_BIT)) {
+		ret = user_regset_copyout_zero(&pos, &count, &kbuf, &ubuf,
+					       0, 4*13);
+		goto out;
+	}
+
+	mask = (regs->ctx.CurrDIVTIME & TXDIVTIME_RPMASK_BITS) >>
+		TXDIVTIME_RPMASK_S;
+
+	/* Read pipeline entries */
+	ptr = (void *)&regs->extcb0[1];
+	for (i = 0; i < 6; ++i, ++ptr) {
+		if (mask & (1 << i))
+			ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+						  ptr, 8*i, 8*(i + 1));
+		else
+			ret = user_regset_copyout_zero(&pos, &count, &kbuf,
+						       &ubuf, 8*i, 8*(i + 1));
+		if (ret)
+			goto out;
+	}
+	/* Mask of entries */
+	ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+				  &mask, 4*12, 4*13);
+out:
+	return ret;
+}
+
+int metag_rp_state_copyin(struct pt_regs *regs,
+			  unsigned int pos, unsigned int count,
+			  const void *kbuf, const void __user *ubuf)
+{
+	struct user_rp_state rp;
+	unsigned long long *ptr;
+	int ret, i;
+
+	/* Read the entire pipeline before making any changes */
+	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
+				 &rp, 0, 4*13);
+	if (ret)
+		goto out;
+
+	/* Write pipeline entries */
+	ptr = (void *)&regs->extcb0[1];
+	for (i = 0; i < 6; ++i, ++ptr)
+		if (rp.mask & (1 << i))
+			*ptr = rp.entries[i];
+
+	/* Update RPMask in TXDIVTIME */
+	regs->ctx.CurrDIVTIME &= ~TXDIVTIME_RPMASK_BITS;
+	regs->ctx.CurrDIVTIME |= (rp.mask << TXDIVTIME_RPMASK_S)
+				 & TXDIVTIME_RPMASK_BITS;
+
+	/* Set/clear flags to indicate catch/read pipeline state */
+	if (rp.mask)
+		regs->ctx.SaveMask |= TBICTX_XCBF_BIT | TBICTX_CBRP_BIT;
+	else
+		regs->ctx.SaveMask &= ~TBICTX_CBRP_BIT;
+out:
+	return ret;
+}
+
+static int metag_rp_state_get(struct task_struct *target,
+			      const struct user_regset *regset,
+			      unsigned int pos, unsigned int count,
+			      void *kbuf, void __user *ubuf)
+{
+	const struct pt_regs *regs = task_pt_regs(target);
+	return metag_rp_state_copyout(regs, pos, count, kbuf, ubuf);
+}
+
+static int metag_rp_state_set(struct task_struct *target,
+			      const struct user_regset *regset,
+			      unsigned int pos, unsigned int count,
+			      const void *kbuf, const void __user *ubuf)
+{
+	struct pt_regs *regs = task_pt_regs(target);
+	return metag_rp_state_copyin(regs, pos, count, kbuf, ubuf);
+}
+
+enum metag_regset {
+	REGSET_GENERAL,
+	REGSET_CBUF,
+	REGSET_READPIPE,
+};
+
+static const struct user_regset metag_regsets[] = {
+	[REGSET_GENERAL] = {
+		.core_note_type = NT_PRSTATUS,
+		.n = ELF_NGREG,
+		.size = sizeof(long),
+		.align = sizeof(long long),
+		.get = metag_gp_regs_get,
+		.set = metag_gp_regs_set,
+	},
+	[REGSET_CBUF] = {
+		.core_note_type = NT_METAG_CBUF,
+		.n = sizeof(struct user_cb_regs) / sizeof(long),
+		.size = sizeof(long),
+		.align = sizeof(long long),
+		.get = metag_cb_regs_get,
+		.set = metag_cb_regs_set,
+	},
+	[REGSET_READPIPE] = {
+		.core_note_type = NT_METAG_RPIPE,
+		.n = sizeof(struct user_rp_state) / sizeof(long),
+		.size = sizeof(long),
+		.align = sizeof(long long),
+		.get = metag_rp_state_get,
+		.set = metag_rp_state_set,
+	},
+};
+
+static const struct user_regset_view user_metag_view = {
+	.name = "metag",
+	.e_machine = EM_METAG,
+	.regsets = metag_regsets,
+	.n = ARRAY_SIZE(metag_regsets)
+};
+
+const struct user_regset_view *task_user_regset_view(struct task_struct *task)
+{
+	return &user_metag_view;
+}
+
+/*
+ * Called by kernel/ptrace.c when detaching..
+ *
+ * Make sure single step bits etc are not set.
+ */
+void ptrace_disable(struct task_struct *child)
+{
+	/* nothing to do.. */
+}
+
+long arch_ptrace(struct task_struct *child, long request, unsigned long addr,
+		 unsigned long data)
+{
+	int ret;
+
+	switch (request) {
+	default:
+		ret = ptrace_request(child, request, addr, data);
+		break;
+	}
+
+	return ret;
+}
+
+int syscall_trace_enter(struct pt_regs *regs)
+{
+	int ret = 0;
+
+	if (test_thread_flag(TIF_SYSCALL_TRACE))
+		ret = tracehook_report_syscall_entry(regs);
+
+	if (unlikely(test_thread_flag(TIF_SYSCALL_TRACEPOINT)))
+		trace_sys_enter(regs, regs->ctx.DX[0].U1);
+
+	return ret ? 0 : regs->ctx.DX[0].U1;
+}
+
+void syscall_trace_leave(struct pt_regs *regs)
+{
+	if (unlikely(test_thread_flag(TIF_SYSCALL_TRACEPOINT)))
+		trace_sys_exit(regs, regs->ctx.DX[0].U1);
+
+	if (test_thread_flag(TIF_SYSCALL_TRACE))
+		tracehook_report_syscall_exit(regs, 0);
+}
diff --git a/include/uapi/linux/elf.h b/include/uapi/linux/elf.h
index 126a817..eb164a2 100644
--- a/include/uapi/linux/elf.h
+++ b/include/uapi/linux/elf.h
@@ -395,6 +395,8 @@ typedef struct elf64_shdr {
 #define NT_ARM_TLS	0x401		/* ARM TLS register */
 #define NT_ARM_HW_BREAK	0x402		/* ARM hardware breakpoint registers */
 #define NT_ARM_HW_WATCH	0x403		/* ARM hardware watchpoint registers */
+#define NT_METAG_CBUF	0x500		/* Metag catch buffer registers */
+#define NT_METAG_RPIPE	0x501		/* Metag read pipeline state */
 
 
 /* Note header in a PT_NOTE section */
-- 
1.7.7.6


