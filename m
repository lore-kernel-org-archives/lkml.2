Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759410Ab0EFSCb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 14:02:31 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:43491 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932563Ab0EFSCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 14:02:16 -0400
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <mhiramat@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Thu, 06 May 2010 23:32:07 +0530
Message-Id: <20100506180207.28877.52249.sendpatchset@localhost6.localdomain6>
In-Reply-To: <20100506180139.28877.81699.sendpatchset@localhost6.localdomain6>
References: <20100506180139.28877.81699.sendpatchset@localhost6.localdomain6>
Subject: [PATCH v3 2/10] User Space Breakpoint Assistance Layer
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

user_bkpt_core.patch

From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

User Space Breakpoint Assistance Layer (USER_BKPT)
Changelog from v2: (addressing comments from Oleg)
	* Use access_process_vm instead of replace_page based
	  background page replacement.

Changelog from v1:
	* Use k(un)map_atomic instead of k(un)map.
	* Remove BUG_ON.
	* Few parameter changes to be more consistent with sparse.
	* Added kernel-doc comments whereever necessary.
	* Introduce a check to detect if post_xol can sleep.

Currently there is no mechanism in kernel to insert/remove breakpoints.

This patch implements user space breakpoint assistance layer provides
kernel subsystems with architecture independent interface to establish
breakpoints in user applications. This patch provides core
implementation of user_bkpt and also wrappers for architecture dependent
methods.

USER_BKPT currently supports both single stepping inline and execution
out of line strategies. Two different probepoints in the same process
can have two different strategies. It handles pre-processing and
post-processing of singlestep after a breakpoint hit.

Single stepping inline strategy is the traditional method where original
instructions replace the breakpointed instructions on a breakpoint hit.
This method works well with single threaded applications. However its
racy with multithreaded applications.

Execution out of line strategy single steps on a copy of the
instruction. This method works well for both single-threaded and
multithreaded applications.

There could be other strategies like emulating an instruction. However
they are currently not implemented.

Insertion and removal of breakpoints is by "Background page
replacement". i.e make a copy of the page, modify its the contents, set
the pagetable and flush the tlbs. This page uses enhanced replace_page
to cow the page. Modified page is only reflected for the interested
process. Others sharing the page will still see the old copy.

You need to follow this up with the USER_BKPT patch for your
architecture.

Uprobes uses this facility to insert/remove breakpoint.

TODO: Merge user_bkpt layer with uprobes.

Signed-off-by: Jim Keniston <jkenisto@us.ibm.com>
Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---

 arch/Kconfig              |   13 +
 include/linux/user_bkpt.h |  305 ++++++++++++++++++++++++++
 kernel/Makefile           |    1 
 kernel/user_bkpt.c        |  536 +++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 855 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/user_bkpt.h
 create mode 100644 kernel/user_bkpt.c


diff --git a/arch/Kconfig b/arch/Kconfig
index e5eb133..116f0ea 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -52,6 +52,16 @@ config OPTPROBES
 	  This option will allow kprobes to optimize breakpoint to
 	  a jump for reducing its overhead.
 
+config USER_BKPT
+	bool "User-space breakpoint assistance (EXPERIMENTAL)"
+	depends on MODULES
+	depends on HAVE_USER_BKPT
+	help
+	  User_bkpt (User-space breakpoint assistance layer) enables
+	  kernel subsystems to establish breakpoints in user applications.
+	  This service is used by components such as uprobes.
+	  If in doubt, say "N".
+
 config HAVE_EFFICIENT_UNALIGNED_ACCESS
 	bool
 	help
@@ -85,6 +95,9 @@ config USER_RETURN_NOTIFIER
 	  Provide a kernel-internal notification when a cpu is about to
 	  switch to user mode.
 
+config HAVE_USER_BKPT
+	def_bool n
+
 config HAVE_IOREMAP_PROT
 	bool
 
diff --git a/include/linux/user_bkpt.h b/include/linux/user_bkpt.h
new file mode 100644
index 0000000..4773541
--- /dev/null
+++ b/include/linux/user_bkpt.h
@@ -0,0 +1,305 @@
+#ifndef _LINUX_USER_BKPT_H
+#define _LINUX_USER_BKPT_H
+/*
+ * User-space BreakPoint support (user_bkpt)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Copyright (C) IBM Corporation, 2008-2010
+ * Authors:
+ *	Srikar Dronamraju
+ *	Jim Keniston
+ */
+
+#include <asm/user_bkpt.h>
+struct task_struct;
+struct pt_regs;
+
+/**
+ * Strategy hints:
+ *
+ * %USER_BKPT_HNT_INLINE: Specifies that the instruction must
+ * be single-stepped inline.  Can be set by the caller of
+ * @arch->analyze_insn() -- e.g., if caller is out of XOL slots --
+ * or by @arch->analyze_insn() if there's no viable XOL strategy
+ * for that instruction.  Set in arch->strategies if the architecture
+ * doesn't implement XOL.
+ *
+ * %USER_BKPT_HNT_PERMSL: Specifies that the instruction slot whose
+ * address is @user_bkpt->xol_vaddr is assigned to @user_bkpt for the life of
+ * the process.  Can be used by @arch->analyze_insn() to simplify
+ * XOL in some cases.  Ignored in @arch->strategies.
+ *
+ * %USER_BKPT_HNT_TSKINFO: Set in @arch->strategies if the architecture's
+ * XOL handling requires the preservation of special
+ * task-specific info between the calls to @arch->pre_xol()
+ * and @arch->post_xol().  (E.g., XOL of x86_64 rip-relative
+ * instructions uses a scratch register, whose value is saved
+ * by pre_xol() and restored by post_xol().)  The caller
+ * of @arch->analyze_insn() should set %USER_BKPT_HNT_TSKINFO in
+ * @user_bkpt->strategy if it's set in @arch->strategies and the caller
+ * can maintain a @user_bkpt_task_arch_info object for each probed task.
+ * @arch->analyze_insn() should leave this flag set in @user_bkpt->strategy
+ * if it needs to use the per-task @user_bkpt_task_arch_info object.
+ */
+#define USER_BKPT_HNT_INLINE	0x1  /* Single-step this insn inline. */
+#define USER_BKPT_HNT_TSKINFO 0x2  /* XOL requires user_bkpt_task_arch_info */
+#define USER_BKPT_HNT_PERMSL	0x4  /* XOL slot assignment is permanent */
+
+#define USER_BKPT_HNT_MASK	0x7
+
+/**
+ * struct user_bkpt - user-space breakpoint/probepoint
+ *
+ * @vaddr:	virtual address of probepoint
+ * @xol_vaddr:	virtual address of XOL slot assigned to this probepoint
+ * @opcode:	copy of opcode at @vaddr
+ * @insn:	typically a copy of the instruction at @vaddr.  More
+ *	precisely, this is the instruction (stream) that will be
+ *	executed in place of the original instruction.
+ * @strategy:	hints about how this instruction will be executed
+ * @fixups:	set of fixups to be executed by @arch->post_xol()
+ * @arch_info:	architecture-specific info about this probepoint
+ */
+struct user_bkpt {
+	unsigned long vaddr;
+	unsigned long xol_vaddr;
+	user_bkpt_opcode_t opcode;
+	u8 insn[USER_BKPT_XOL_SLOT_BYTES];
+	u16 strategy;
+	u16 fixups;
+	struct bkpt_arch_info arch_info;
+};
+
+/* Post-execution fixups.  Some architectures may define others. */
+
+/* No fixup needed */
+#define USER_BKPT_FIX_NONE	0x0
+/* Adjust IP back to vicinity of actual insn */
+#define USER_BKPT_FIX_IP	0x1
+/* Adjust the return address of a call insn */
+#define USER_BKPT_FIX_CALL	0x2
+/* Might sleep while doing Fixup */
+#define USER_BKPT_FIX_SLEEPY	0x4
+
+#ifndef USER_BKPT_FIX_DEFAULT
+#define USER_BKPT_FIX_DEFAULT USER_BKPT_FIX_IP
+#endif
+
+#ifdef CONFIG_USER_BKPT
+extern int user_bkpt_init(u16 *strategies);
+extern int user_bkpt_insert_bkpt(struct task_struct *tsk,
+					struct user_bkpt *user_bkpt);
+extern unsigned long user_bkpt_get_bkpt_addr(struct pt_regs *regs);
+extern int user_bkpt_pre_sstep(struct task_struct *tsk,
+				struct user_bkpt *user_bkpt,
+				struct user_bkpt_task_arch_info *tskinfo,
+				struct pt_regs *regs);
+extern int user_bkpt_post_sstep(struct task_struct *tsk,
+			struct user_bkpt *user_bkpt,
+			struct user_bkpt_task_arch_info *tskinfo,
+			struct pt_regs *regs);
+extern int user_bkpt_cancel_xol(struct task_struct *tsk,
+			struct user_bkpt *user_bkpt);
+extern int user_bkpt_remove_bkpt(struct task_struct *tsk,
+			struct user_bkpt *user_bkpt);
+extern int user_bkpt_validate_insn_addr(struct task_struct *tsk,
+					unsigned long vaddr);
+extern void user_bkpt_set_ip(struct pt_regs *regs, unsigned long vaddr);
+extern bool user_bkpt_resume_can_sleep(struct user_bkpt *user_bkpt);
+#else	/* CONFIG_USER_BKPT */
+static inline int user_bkpt_init(u16 *strategies)
+{
+	return -ENOSYS;
+}
+static inline int user_bkpt_insert_bkpt(struct task_struct *tsk,
+						struct user_bkpt *user_bkpt)
+{
+	return -ENOSYS;
+}
+static inline unsigned long user_bkpt_get_bkpt_addr(struct pt_regs *regs)
+{
+	return -ENOSYS;
+}
+static inline int user_bkpt_pre_sstep(struct task_struct *tsk,
+	struct user_bkpt *user_bkpt, struct user_bkpt_task_arch_info *tskinfo,
+	struct pt_regs *regs)
+{
+	return -ENOSYS;
+}
+static inline int user_bkpt_post_sstep(struct task_struct *tsk,
+	struct user_bkpt *user_bkpt, struct user_bkpt_task_arch_info *tskinfo,
+	struct pt_regs *regs)
+{
+	return -ENOSYS;
+}
+static inline int user_bkpt_cancel_xol(struct task_struct *tsk,
+	struct user_bkpt *user_bkpt)
+{
+	return -ENOSYS;
+}
+static inline int user_bkpt_remove_bkpt(struct task_struct *tsk,
+	struct user_bkpt *user_bkpt)
+{
+	return -ENOSYS;
+}
+static inline int user_bkpt_validate_insn_addr(struct task_struct *tsk,
+	unsigned long vaddr)
+{
+	return -ENOSYS;
+}
+static inline void user_bkpt_set_ip(struct pt_regs *regs, unsigned long vaddr)
+{
+}
+static inline bool user_bkpt_resume_can_sleep(struct user_bkpt *user_bkpt)
+{
+	return false;
+}
+#endif	/* CONFIG_USER_BKPT */
+
+/**
+ * struct user_bkpt_arch_info - architecture-specific parameters and
+ * functions
+ *
+ * Most architectures can use the default versions of @read_opcode(),
+ * @set_bkpt(), @set_orig_insn(), and @is_bkpt_insn(); ia64 is an
+ * exception.  All functions (including @validate_address()) can assume
+ * that the caller has verified that the probepoint's virtual address
+ * resides in an executable VM area.
+ *
+ * @bkpt_insn:
+ *	The architecture's breakpoint instruction.  This is used by
+ *	the default versions of @set_bkpt(), @set_orig_insn(), and
+ *	@is_bkpt_insn().
+ * @ip_advancement_by_bkpt_insn:
+ *	The number of bytes the instruction pointer is advanced by
+ *	this architecture's breakpoint instruction.  For example, after
+ *	the powerpc trap instruction executes, the ip still points to the
+ *	breakpoint instruction (ip_advancement_by_bkpt_insn = 0); but the
+ *	x86 int3 instruction (1 byte) advances the ip past the int3
+ *	(ip_advancement_by_bkpt_insn = 1).
+ * @max_insn_bytes:
+ *	The maximum length, in bytes, of an instruction in this
+ *	architecture.  This must be <= USER_BKPT_XOL_SLOT_BYTES;
+ * @strategies:
+ *	Bit-map of %USER_BKPT_HNT_* values recognized by this architecture.
+ *	Include %USER_BKPT_HNT_INLINE iff this architecture doesn't support
+ *	execution out of line.  Include %USER_BKPT_HNT_TSKINFO if
+ *	XOL of at least some instructions requires communication of
+ *	per-task state between @pre_xol() and @post_xol().
+ * @set_ip:
+ *	Set the instruction pointer in @regs to @vaddr.
+ * @validate_address:
+ *	Return 0 if @vaddr is a valid instruction address, or a negative
+ *	errno (typically -%EINVAL) otherwise.  If you don't provide
+ *	@validate_address(), any address will be accepted.  Caller
+ *	guarantees that @vaddr is in an executable VM area.  This
+ *	function typically just enforces arch-specific instruction
+ *	alignment.
+ * @read_opcode:
+ *	For task @tsk, read the opcode at @vaddr and store it in
+ *	@opcode.  Return 0 (success) or a negative errno.  Defaults to
+ *	@user_bkpt_read_opcode().
+ * @set_bkpt:
+ *	For task @tsk, store @bkpt_insn at @user_bkpt->vaddr.  Return 0
+ *	(success) or a negative errno. Defaults to @user_bkpt_set_bkpt().
+ * @set_orig_insn:
+ *	For task @tsk, restore the original opcode (@user_bkpt->opcode) at
+ *	@user_bkpt->vaddr.  If @check is true, first verify that there's
+ *	actually a breakpoint instruction there.  Return 0 (success) or
+ *	a negative errno.  Defaults to @user_bkpt_set_orig_insn().
+ * @is_bkpt_insn:
+ *	Return %true if @user_bkpt->opcode is @bkpt_insn.  Defaults to
+ *	@user_bkpt_is_bkpt_insn(), which just tests (user_bkpt->opcode ==
+ *	arch->bkpt_insn).
+ * @analyze_insn:
+ *	Analyze @user_bkpt->insn.  Return 0 if @user_bkpt->insn is an
+ *	instruction you can probe, or a negative errno (typically -%EPERM)
+ *	otherwise.  The caller sets @user_bkpt->strategy to
+ *	%USER_BKPT_HNT_INLINE to suppress XOL for this instruction (e.g.,
+ *	because we're out of XOL slots).  If the instruction can be probed
+ *	but can't be executed out of line, set @user_bkpt->strategy to
+ *	%USER_BKPT_HNT_INLINE.  Otherwise, determine what sort of
+ *	XOL-related fixups @post_xol() (and possibly @pre_xol()) will need
+ *	to do for this instruction, and annotate @user_bkpt accordingly.
+ *	You may modify @user_bkpt->insn (e.g., the x86_64 port does this
+ *	for rip-relative instructions), but if you do so, you should
+ *	retain a copy in @user_bkpt->arch_info in case you have to revert
+ *	to single-stepping inline (see @cancel_xol()).
+ * @pre_xol:
+ *	Called just before executing the instruction associated
+ *	with @user_bkpt out of line.  @user_bkpt->xol_vaddr is the address
+ *	in @tsk's virtual address space where @user_bkpt->insn has been
+ *	copied.  @pre_xol() should at least set the instruction pointer in
+ *	@regs to @user_bkpt->xol_vaddr -- which is what the default,
+ *	@user_bkpt_pre_xol(), does.  If @user_bkpt->strategy includes the
+ *	%USER_BKPT_HNT_TSKINFO flag, then @tskinfo points to a per-task
+ *	copy of struct user_bkpt_task_arch_info.
+ * @post_xol:
+ *	Called after executing the instruction associated with
+ *	@user_bkpt out of line.  @post_xol() should perform the fixups
+ *	specified in @user_bkpt->fixups, which includes ensuring that the
+ *	instruction pointer in @regs points at the next instruction in
+ *	the probed instruction stream.  @tskinfo is as for @pre_xol().
+ *	You must provide this function.
+ * @cancel_xol:
+ *	The instruction associated with @user_bkpt cannot be executed
+ *	out of line after all.  (This can happen when XOL slots
+ *	are lazily assigned, and we run out of slots before we
+ *	hit this breakpoint.  This function should never be called
+ *	if @analyze_insn() was previously called for @user_bkpt with a
+ *	non-zero value of @user_bkpt->xol_vaddr and with
+ *	%USER_BKPT_HNT_PERMSL set in @user_bkpt->strategy.)  Adjust
+ *	@user_bkpt as needed so it can be single-stepped inline.  Omit this
+ *	function if you don't need it.
+ */
+
+struct user_bkpt_arch_info {
+	user_bkpt_opcode_t bkpt_insn;
+	u8 ip_advancement_by_bkpt_insn;
+	u8 max_insn_bytes;
+	u16 strategies;
+	void (*set_ip)(struct pt_regs *regs, unsigned long vaddr);
+	int (*validate_address)(struct task_struct *tsk, unsigned long vaddr);
+	int (*read_opcode)(struct task_struct *tsk, unsigned long vaddr,
+						user_bkpt_opcode_t *opcode);
+	int (*set_bkpt)(struct task_struct *tsk, struct user_bkpt *user_bkpt);
+	int (*set_orig_insn)(struct task_struct *tsk,
+				struct user_bkpt *user_bkpt, bool check);
+	bool (*is_bkpt_insn)(struct user_bkpt *user_bkpt);
+	int (*analyze_insn)(struct task_struct *tsk,
+						struct user_bkpt *user_bkpt);
+	int (*pre_xol)(struct task_struct *tsk, struct user_bkpt *user_bkpt,
+				struct user_bkpt_task_arch_info *tskinfo,
+				struct pt_regs *regs);
+	int (*post_xol)(struct task_struct *tsk, struct user_bkpt *user_bkpt,
+				struct user_bkpt_task_arch_info *tskinfo,
+				struct pt_regs *regs);
+	void (*cancel_xol)(struct task_struct *tsk,
+						struct user_bkpt *user_bkpt);
+};
+
+/* Unexported functions & macros for use by arch-specific code */
+#define user_bkpt_opcode_sz (sizeof(user_bkpt_opcode_t))
+extern unsigned long user_bkpt_read_vm(struct task_struct *tsk,
+			void __user *vaddr, void *kbuf,
+			unsigned long nbytes);
+extern unsigned long user_bkpt_write_data(struct task_struct *tsk,
+			void __user *vaddr, const void *kbuf,
+			unsigned long nbytes);
+
+extern struct user_bkpt_arch_info user_bkpt_arch_info;
+
+#endif	/* _LINUX_USER_BKPT_H */
diff --git a/kernel/Makefile b/kernel/Makefile
index a987aa1..36a35b0 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -105,6 +105,7 @@ obj-$(CONFIG_PERF_EVENTS) += perf_event.o
 obj-$(CONFIG_HAVE_HW_BREAKPOINT) += hw_breakpoint.o
 obj-$(CONFIG_USER_RETURN_NOTIFIER) += user-return-notifier.o
 obj-$(CONFIG_PADATA) += padata.o
+obj-$(CONFIG_USER_BKPT) += user_bkpt.o
 
 ifneq ($(CONFIG_SCHED_OMIT_FRAME_POINTER),y)
 # According to Alan Modra <alan@linuxcare.com.au>, the -fno-omit-frame-pointer is
diff --git a/kernel/user_bkpt.c b/kernel/user_bkpt.c
new file mode 100644
index 0000000..b61647f
--- /dev/null
+++ b/kernel/user_bkpt.c
@@ -0,0 +1,536 @@
+/*
+ * User-space BreakPoint support (user_bkpt)
+ *
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Copyright (C) IBM Corporation, 2008-2010
+ * Authors:
+ *	Srikar Dronamraju
+ *	Jim Keniston
+ *	Ananth N Mavinakayanahalli
+ */
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/ptrace.h>
+#include <linux/mm.h>
+#include <linux/user_bkpt.h>
+#include <linux/uaccess.h>
+#include <linux/highmem.h>
+#include <linux/pagemap.h>
+
+static struct user_bkpt_arch_info *arch = &user_bkpt_arch_info;
+
+static bool uses_xol_strategy(u16 strategy)
+{
+	return !(strategy & USER_BKPT_HNT_INLINE);
+}
+
+static bool validate_strategy(u16 strategy, u16 valid_bits)
+{
+	return ((strategy & (~valid_bits)) == 0);
+}
+
+/**
+ * user_bkpt_init - initialize the user_bkpt data structures
+ * @strategies indicates which breakpoint-related strategies are
+ * supported by the client:
+ *   %USER_BKPT_HNT_INLINE: Client supports only single-stepping inline.
+ *	Otherwise client must provide an instruction slot
+ *	(USER_BKPT_XOL_SLOT_BYTES bytes) in the probed process's address
+ *	space for each instruction to be executed out of line.
+ *   %USER_BKPT_HNT_TSKINFO: Client can provide and maintain one
+ *	@user_bkpt_task_arch_info object for each probed task.  (Failure to
+ *	support this will prevent XOL of rip-relative instructions on
+ *	x86_64, at least.)
+ * Upon return, @strategies is updated to reflect those strategies
+ * required by this particular architecture's implementation of user_bkpt:
+ *   %USER_BKPT_HNT_INLINE: Architecture or client supports only
+ *	single-stepping inline.
+ *   %USER_BKPT_HNT_TSKINFO: Architecture uses @user_bkpt_task_arch_info,
+ *   and will expect it to be passed to @user_bkpt_pre_sstep() and
+ *   @user_bkpt_post_sstep() as needed (see @user_bkpt_insert_bkpt()).
+ * Possible errors:
+ * -%ENOSYS: user_bkpt not supported for this architecture.
+ * -%EINVAL: unrecognized flags in @strategies
+ */
+int user_bkpt_init(u16 *strategies)
+{
+	u16 inline_bit, tskinfo_bit;
+	u16 client_strategies = *strategies;
+
+	if (!validate_strategy(client_strategies,
+			USER_BKPT_HNT_INLINE | USER_BKPT_HNT_TSKINFO))
+		return -EINVAL;
+
+	inline_bit = (client_strategies | arch->strategies) &
+						USER_BKPT_HNT_INLINE;
+	tskinfo_bit = (client_strategies & arch->strategies) &
+						USER_BKPT_HNT_TSKINFO;
+	*strategies = (inline_bit | tskinfo_bit);
+	return 0;
+}
+
+/**
+ * user_bkpt_read_vm - Read @nbytes at @vaddr from @tsk into @kbuf.
+ * @tsk: The probed task
+ * @vaddr: Source address, in user space to be read.
+ * @kbuf: Destination address, in kernel space.
+ *
+ * Context: This function may sleep.
+ *
+ * Returns number of bytes that could be copied.
+ */
+unsigned long user_bkpt_read_vm(struct task_struct *tsk, void __user *vaddr,
+					void *kbuf, unsigned long nbytes)
+{
+	if (tsk == current) {
+		unsigned long nleft = copy_from_user(kbuf, vaddr, nbytes);
+		return nbytes - nleft;
+	} else
+		return access_process_vm(tsk, (unsigned long) vaddr, kbuf,
+							nbytes, 0);
+}
+
+/**
+ * user_bkpt_write_data - Write @nbytes from @kbuf at @vaddr in @tsk.
+ * Can be used to write to stack or data VM areas, but not instructions.
+ * Not exported, but available for use by arch-specific user_bkpt code.
+ * @tsk: The probed task
+ * @vaddr: Destination address, in user space.
+ * @kbuf: Source address, in kernel space to be read.
+ *
+ * Context: This function may sleep.
+ *
+ * Return number of bytes written.
+ */
+unsigned long user_bkpt_write_data(struct task_struct *tsk,
+				void __user *vaddr, const void *kbuf,
+				unsigned long nbytes)
+{
+	unsigned long nleft;
+
+	if (tsk == current) {
+		nleft = copy_to_user(vaddr, kbuf, nbytes);
+		return nbytes - nleft;
+	} else
+		return access_process_vm(tsk, (unsigned long) vaddr,
+						(void *) kbuf, nbytes, 1);
+}
+
+/*
+ * Given an address, get its pte. Very similar to get_locked_pte except
+ * there is no spinlock involved.
+ */
+static pte_t *get_pte(struct mm_struct *mm, unsigned long vaddr)
+{
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *pte;
+
+	pgd = pgd_offset(mm, vaddr);
+	pud = pud_alloc(mm, pgd, vaddr);
+	if (!pud)
+		return NULL;
+	pmd = pmd_alloc(mm, pud, vaddr);
+	if (!pmd)
+		return NULL;
+	pte = pte_alloc_map(mm, pmd, vaddr);
+	return pte;
+}
+
+static int write_opcode(struct task_struct *tsk, unsigned long vaddr,
+						user_bkpt_opcode_t opcode)
+{
+	int ret;
+
+	if (!tsk)
+		return -EINVAL;
+
+	ret = access_process_vm(tsk, vaddr, &opcode, user_bkpt_opcode_sz, 1);
+	return (ret == user_bkpt_opcode_sz ? 0 : -EFAULT);
+}
+
+/* Default implementation of arch->read_opcode */
+static int read_opcode(struct task_struct *tsk, unsigned long vaddr,
+						user_bkpt_opcode_t *opcode)
+{
+	unsigned long bytes_read;
+
+	bytes_read = user_bkpt_read_vm(tsk, (void __user *) vaddr, opcode,
+							user_bkpt_opcode_sz);
+	return (bytes_read == user_bkpt_opcode_sz ? 0 : -EFAULT);
+}
+
+/* Default implementation of arch->set_bkpt */
+static int set_bkpt(struct task_struct *tsk, struct user_bkpt *user_bkpt)
+{
+	return write_opcode(tsk, user_bkpt->vaddr, arch->bkpt_insn);
+}
+
+/* Default implementation of arch->set_orig_insn */
+static int set_orig_insn(struct task_struct *tsk,
+				struct user_bkpt *user_bkpt, bool check)
+{
+	if (check) {
+		user_bkpt_opcode_t opcode;
+		int result = arch->read_opcode(tsk, user_bkpt->vaddr,
+								&opcode);
+		if (result)
+			return result;
+		if (opcode != arch->bkpt_insn)
+			return -EINVAL;
+	}
+	return write_opcode(tsk, user_bkpt->vaddr, user_bkpt->opcode);
+}
+
+/* Return 0 if vaddr is in an executable VM area, or -EINVAL otherwise. */
+static inline int check_vma(struct task_struct *tsk, unsigned long vaddr)
+{
+	struct vm_area_struct *vma;
+	struct mm_struct *mm;
+	int ret = -EINVAL;
+
+	mm = get_task_mm(tsk);
+	if (!mm)
+		return -EINVAL;
+	down_read(&mm->mmap_sem);
+	vma = find_vma(mm, vaddr);
+	if (vma && vaddr >= vma->vm_start && (vma->vm_flags & VM_EXEC))
+		ret = 0;
+	up_read(&mm->mmap_sem);
+	mmput(mm);
+	return ret;
+}
+
+/**
+ * user_bkpt_validate_insn_addr - Validate if the instruction is an
+ * executable vma.
+ * Returns 0 if the vaddr is a valid instruction address.
+ * @tsk: the probed task
+ * @vaddr: virtual address of the instruction to be verified.
+ *
+ * Possible errors:
+ * -%EINVAL: Instruction passed is not a valid instruction address.
+ */
+int user_bkpt_validate_insn_addr(struct task_struct *tsk, unsigned long vaddr)
+{
+	int result;
+
+	result = check_vma(tsk, vaddr);
+	if (result != 0)
+		return result;
+	if (arch->validate_address)
+		result = arch->validate_address(tsk, vaddr);
+	return result;
+}
+
+static void print_insert_fail(struct task_struct *tsk,
+				struct user_bkpt *user_bkpt, const char *why)
+{
+	printk(KERN_ERR "Can't place breakpoint at pid %d vaddr %#lx: %s\n",
+					tsk->pid, user_bkpt->vaddr, why);
+}
+
+/**
+ * user_bkpt_insert_bkpt - insert breakpoint
+ * Insert a breakpoint into the process that includes @tsk, at the
+ * virtual address @user_bkpt->vaddr.
+ *
+ * @user_bkpt->strategy affects how this breakpoint will be handled:
+ *   %USER_BKPT_HNT_INLINE: Probed instruction will be single-stepped inline.
+ *   %USER_BKPT_HNT_TSKINFO: As above.
+ *   %USER_BKPT_HNT_PERMSL: An XOL instruction slot in the probed process's
+ *	address space has been allocated to this probepoint, and will
+ *	remain so allocated as long as it's needed.  @user_bkpt->xol_vaddr is
+ *	its address.  (This slot can be reallocated if
+ *	@user_bkpt_insert_bkpt() fails.)  The client is NOT required to
+ *	allocate an instruction slot before calling @user_bkpt_insert_bkpt().
+ * @user_bkpt_insert_bkpt() updates @user_bkpt->strategy as needed:
+ *   %USER_BKPT_HNT_INLINE: Architecture or client cannot do XOL for this
+ *	probepoint.
+ *   %USER_BKPT_HNT_TSKINFO: @user_bkpt_task_arch_info will be used for this
+ *	probepoint.
+ *
+ * All threads of the probed process must be stopped while
+ * @user_bkpt_insert_bkpt() runs.
+ *
+ * Possible errors:
+ * -%ENOSYS: user_bkpt not supported for this architecture
+ * -%EINVAL: unrecognized/invalid strategy flags
+ * -%EINVAL: invalid instruction address
+ * -%EEXIST: breakpoint instruction already exists at that address
+ * -%EPERM: cannot probe this instruction
+ * -%EFAULT: failed to insert breakpoint instruction
+ * [TBD: Validate xol_vaddr?]
+ */
+int user_bkpt_insert_bkpt(struct task_struct *tsk, struct user_bkpt *user_bkpt)
+{
+	int result;
+	unsigned long len;
+
+	if (!validate_strategy(user_bkpt->strategy, USER_BKPT_HNT_MASK))
+		return -EINVAL;
+
+	result = user_bkpt_validate_insn_addr(tsk, user_bkpt->vaddr);
+	if (result != 0)
+		return result;
+
+	/*
+	 * If user_bkpt_read_vm() transfers fewer bytes than the maximum
+	 * instruction size, assume that the probed instruction is smaller
+	 * than the max and near the end of the last page of instructions.
+	 * But there must be room at least for a breakpoint-size instruction.
+	 */
+	len = user_bkpt_read_vm(tsk, (void __user *) user_bkpt->vaddr,
+				user_bkpt->insn, arch->max_insn_bytes);
+	if (len < user_bkpt_opcode_sz) {
+		print_insert_fail(tsk, user_bkpt,
+				"error reading original instruction");
+		return -EFAULT;
+	}
+	memcpy(&user_bkpt->opcode, user_bkpt->insn, user_bkpt_opcode_sz);
+	if (arch->is_bkpt_insn(user_bkpt)) {
+		print_insert_fail(tsk, user_bkpt,
+					"bkpt already exists at that addr");
+		return -EEXIST;
+	}
+
+	result = arch->analyze_insn(tsk, user_bkpt);
+	if (result < 0) {
+		print_insert_fail(tsk, user_bkpt,
+					"instruction type cannot be probed");
+		return result;
+	}
+
+	result = arch->set_bkpt(tsk, user_bkpt);
+	if (result < 0) {
+		print_insert_fail(tsk, user_bkpt,
+					"failed to insert bkpt instruction");
+		return result;
+	}
+	return 0;
+}
+
+/**
+ * user_bkpt_pre_sstep - prepare to single-step the probed instruction
+ * @tsk: the probed task
+ * @user_bkpt: the probepoint information, as returned by
+ *	@user_bkpt_insert_bkpt().  Unless the %USER_BKPT_HNT_INLINE flag is
+ *	set in @user_bkpt->strategy, @user_bkpt->xol_vaddr must be the
+ *	address of an XOL instruction slot that is allocated to this
+ *	probepoint at least until after the completion of
+ *	@user_bkpt_post_sstep(), and populated with the contents of
+ *	@user_bkpt->insn.  [Need to be more precise here to account for
+ *	untimely exit or USER_BKPT_HNT_BOOSTED.]
+ * @tskinfo: points to a @user_bkpt_task_arch_info object for @tsk, if
+ *	the %USER_BKPT_HNT_TSKINFO flag is set in @user_bkpt->strategy.
+ * @regs: reflects the saved user state of @tsk.  @user_bkpt_pre_sstep()
+ *	adjusts this.  In particular, the instruction pointer is set
+ *	to the instruction to be single-stepped.
+ * Possible errors:
+ * -%EFAULT: Failed to read or write @tsk's address space as needed.
+ *
+ * The client must ensure that the contents of @user_bkpt are not
+ * changed during the single-step operation -- i.e., between when
+ * @user_bkpt_pre_sstep() is called and when @user_bkpt_post_sstep() returns.
+ * Additionally, if single-stepping inline is used for this probepoint,
+ * the client must serialize the single-step operation (so multiple
+ * threads don't step on each other while the opcode replacement is
+ * taking place).
+ */
+int user_bkpt_pre_sstep(struct task_struct *tsk, struct user_bkpt *user_bkpt,
+		struct user_bkpt_task_arch_info *tskinfo, struct pt_regs *regs)
+{
+	int result;
+
+	if (uses_xol_strategy(user_bkpt->strategy))
+		return arch->pre_xol(tsk, user_bkpt, tskinfo, regs);
+
+	/*
+	 * Single-step this instruction inline.  Replace the breakpoint
+	 * with the original opcode.
+	 */
+	result = arch->set_orig_insn(tsk, user_bkpt, false);
+	if (result == 0)
+		arch->set_ip(regs, user_bkpt->vaddr);
+	return result;
+}
+
+/**
+ * user_bkpt_post_sstep - prepare to resume execution after single-step
+ * @tsk: the probed task
+ * @user_bkpt: the probepoint information, as with @user_bkpt_pre_sstep()
+ * @tskinfo: the @user_bkpt_task_arch_info object, if any, passed to
+ *	@user_bkpt_pre_sstep()
+ * @regs: reflects the saved state of @tsk after the single-step
+ *	operation.  @user_bkpt_post_sstep() adjusts @tsk's state as needed,
+ *	including pointing the instruction pointer at the instruction
+ *	following the probed instruction.
+ * Possible errors:
+ * -%EFAULT: Failed to read or write @tsk's address space as needed.
+ */
+int user_bkpt_post_sstep(struct task_struct *tsk, struct user_bkpt *user_bkpt,
+		struct user_bkpt_task_arch_info *tskinfo, struct pt_regs *regs)
+{
+	if (uses_xol_strategy(user_bkpt->strategy))
+		return arch->post_xol(tsk, user_bkpt, tskinfo, regs);
+
+	/*
+	 * Single-stepped this instruction inline.  Put the breakpoint
+	 * instruction back.
+	 */
+	return arch->set_bkpt(tsk, user_bkpt);
+}
+
+/**
+ * user_bkpt_cancel_xol - cancel XOL for this probepoint
+ * @tsk: a task in the probed process
+ * @user_bkpt: the probepoint information
+ * Switch @user_bkpt's single-stepping strategy from out-of-line to inline.
+ * If the client employs lazy XOL-slot allocation, it can call this function
+ * if it determines that it can't provide an XOL slot for @user_bkpt.
+ * @user_bkpt_cancel_xol() adjusts @user_bkpt appropriately.
+ *
+ * @user_bkpt_cancel_xol()'s behavior is undefined if @user_bkpt_pre_sstep()
+ * has already been called for @user_bkpt.
+ *
+ * Possible errors:
+ * Can't think of any yet.
+ */
+int user_bkpt_cancel_xol(struct task_struct *tsk, struct user_bkpt *user_bkpt)
+{
+	if (arch->cancel_xol)
+		arch->cancel_xol(tsk, user_bkpt);
+	user_bkpt->strategy |= USER_BKPT_HNT_INLINE;
+	return 0;
+}
+
+/**
+ * user_bkpt_get_bkpt_addr - compute address of bkpt given post-bkpt regs
+ * @regs: Reflects the saved state of the task after it has hit a breakpoint
+ * instruction.
+ * Return the address of the breakpoint instruction.
+ */
+unsigned long user_bkpt_get_bkpt_addr(struct pt_regs *regs)
+{
+	return instruction_pointer(regs) - arch->ip_advancement_by_bkpt_insn;
+}
+
+/**
+ * user_bkpt_remove_bkpt - remove breakpoint
+ * For the process that includes @tsk, remove the breakpoint specified
+ * by @user_bkpt, restoring the original opcode.
+ *
+ * Possible errors:
+ * -%EINVAL: @user_bkpt->vaddr is not a valid instruction address.
+ * -%ENOENT: There is no breakpoint instruction at @user_bkpt->vaddr.
+ * -%EFAULT: Failed to read/write @tsk's address space as needed.
+ */
+int user_bkpt_remove_bkpt(struct task_struct *tsk, struct user_bkpt *user_bkpt)
+{
+	if (user_bkpt_validate_insn_addr(tsk, user_bkpt->vaddr) != 0)
+		return -EINVAL;
+	return arch->set_orig_insn(tsk, user_bkpt, true);
+}
+
+/**
+ * user_bkpt_set_ip - Set instruction pointer
+ * @regs: Reflects the saved state of the task
+ */
+void user_bkpt_set_ip(struct pt_regs *regs, unsigned long vaddr)
+{
+	arch->set_ip(regs, vaddr);
+}
+
+/**
+ * user_bkpt_resume_can_sleep - Check if fixup might result in sleep.
+ * @user_bkpt: the probepoint information.
+ *
+ * Returns true if fixup might result in sleep.
+ */
+bool user_bkpt_resume_can_sleep(struct user_bkpt *user_bkpt)
+{
+	return user_bkpt->fixups & USER_BKPT_FIX_SLEEPY;
+}
+
+/* Default implementation of arch->is_bkpt_insn */
+static bool is_bkpt_insn(struct user_bkpt *user_bkpt)
+{
+	return (user_bkpt->opcode == arch->bkpt_insn);
+}
+
+/* Default implementation of arch->pre_xol */
+static int pre_xol(struct task_struct *tsk,
+			struct user_bkpt *user_bkpt,
+			struct user_bkpt_task_arch_info *tskinfo,
+			struct pt_regs *regs)
+{
+	arch->set_ip(regs, user_bkpt->xol_vaddr);
+	return 0;
+}
+
+/* Validate arch-specific info during user_bkpt initialization. */
+static int bad_arch_param(const char *param_name, int value)
+{
+	printk(KERN_ERR "user_bkpt: bad value %d/%#x for parameter %s"
+		" in user_bkpt_arch_info\n", value, value, param_name);
+	return -ENOSYS;
+}
+
+static int missing_arch_func(const char *func_name)
+{
+	printk(KERN_ERR "user_bkpt: user_bkpt_arch_info lacks required "
+					"function: %s\n", func_name);
+	return -ENOSYS;
+}
+
+static int __init init_user_bkpt(void)
+{
+	int result = 0;
+
+	/* Accept any value of bkpt_insn. */
+	if (arch->max_insn_bytes < 1)
+		result = bad_arch_param("max_insn_bytes",
+						arch->max_insn_bytes);
+	if (arch->ip_advancement_by_bkpt_insn > arch->max_insn_bytes)
+		result = bad_arch_param("ip_advancement_by_bkpt_insn",
+				arch->ip_advancement_by_bkpt_insn);
+	/* Accept any value of strategies. */
+	if (!arch->set_ip)
+		result = missing_arch_func("set_ip");
+	/* Null validate_address() is OK. */
+	if (!arch->read_opcode)
+		arch->read_opcode = read_opcode;
+	if (!arch->set_bkpt)
+		arch->set_bkpt = set_bkpt;
+	if (!arch->set_orig_insn)
+		arch->set_orig_insn = set_orig_insn;
+	if (!arch->is_bkpt_insn)
+		arch->is_bkpt_insn = is_bkpt_insn;
+	if (!arch->analyze_insn)
+		result = missing_arch_func("analyze_insn");
+	if (!arch->pre_xol)
+		arch->pre_xol = pre_xol;
+	if (uses_xol_strategy(arch->strategies) && !arch->post_xol)
+		result = missing_arch_func("post_xol");
+	/* Null cancel_xol() is OK. */
+	return result;
+}
+
+module_init(init_user_bkpt);
