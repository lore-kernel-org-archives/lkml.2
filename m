Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652Ab0GHRSA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 13:18:00 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:50324 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756285Ab0GHRR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 13:17:57 -0400
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Naren A Devaiah <naren.devaiah@in.ibm.com>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Thu, 08 Jul 2010 22:40:27 +0530
Message-Id: <20100708171027.29165.90396.sendpatchset@localhost6.localdomain6>
In-Reply-To: <20100708171003.29165.57615.sendpatchset@localhost6.localdomain6>
References: <20100708171003.29165.57615.sendpatchset@localhost6.localdomain6>
Subject: [PATCHv8 2.6.35-rc4-tip 2/12]  uprobes: Breakpoint insertion/removal in user space applications.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


uprobes: Breakpoint insertion/removal in user space applications.

Changelog from V5: (Merge user_bkpt into uprobes)
  * Merged user_bkpt into uprobes as suggested by Christoph Hellwig
    and Peter Zijlstra.

Changelog from V3: (reimplement background page replacement)
  * Replemented background page replacement based on inputs
    from Peter Zijlstra.

Changelog from v2: (addressing comments from Oleg)
  * Use access_process_vm instead of replace_page based
    background page replacement.

Changelog from v1:
  * Use k(un)map_atomic instead of k(un)map.
  * Remove BUG_ON.
  * Few parameter changes to be more consistent with sparse.
  * Added kernel-doc comments whereever necessary.
  * Introduce a check to detect if post_xol can sleep.

Provides a mechanism in kernel to insert/remove breakpoints in
user space applications including
   - architecture independent mechanism to establish breakpoints in
     userspace applications.
   - helper functions for reading/writing/validating data/opcodes from
     target process's address space.
   - wrappers and default implementation(whereever possible) of
     architecture dependent functions(setting breakpoint)
   - preprocessing and postprocessing of singlestep on breakpoint hit

Single stepping inline is the traditional method where original
instructions replace the breakpointed instructions on a breakpoint
hit.  This method works well with single threaded applications.
However its racy with multithreaded applications.

In execution out of line, threads single steps on a copy of the
instruction. This method works well for both single-threaded and
multithreaded applications.

Uprobes uses execution out of line method.

There could be other strategies like emulating an instruction. However
they are currently not implemented.

Insertion and removal of breakpoints is by "Background page
replacement". i.e make a copy of the page, modify its the contents,
set the pagetable and flush the tlbs. This page uses enhanced
replace_page to cow the page. Modified page is only reflected for the
interested process. Others sharing the page will still see the old
copy.

You need to follow this up with the uprobes patch for your
architecture to define architecture specific functionality for
reading/writing/validating data/opcodes.

Signed-off-by: Jim Keniston <jkenisto@us.ibm.com>
Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---

 arch/Kconfig            |   14 +
 include/linux/uprobes.h |  189 +++++++++++++++++++
 kernel/Makefile         |    1 
 kernel/uprobes.c        |  466 +++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 670 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/uprobes.h
 create mode 100644 kernel/uprobes.c


diff --git a/arch/Kconfig b/arch/Kconfig
index 4877a8c..87bd26b 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -47,6 +47,17 @@ config OPTPROBES
 	depends on !PREEMPT
 	select KALLSYMS_ALL
 
+config UPROBES
+	bool "User-space probes (EXPERIMENTAL)"
+	depends on ARCH_SUPPORTS_UPROBES
+	depends on MMU
+	help
+	  Uprobes enables kernel subsystems to establish probepoints
+	  in user applications and execute handler functions when
+	  the probepoints are hit. For more information, refer to
+	  Documentation/uprobes.txt.
+	  If in doubt, say "N".
+
 config HAVE_EFFICIENT_UNALIGNED_ACCESS
 	bool
 	help
@@ -80,6 +91,9 @@ config USER_RETURN_NOTIFIER
 	  Provide a kernel-internal notification when a cpu is about to
 	  switch to user mode.
 
+config ARCH_SUPPORTS_UPROBES
+	def_bool n
+
 config HAVE_IOREMAP_PROT
 	bool
 
diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
new file mode 100644
index 0000000..02d9927
--- /dev/null
+++ b/include/linux/uprobes.h
@@ -0,0 +1,189 @@
+#ifndef _LINUX_UPROBES_H
+#define _LINUX_UPROBES_H
+/*
+ * Userspace Probes (UProbes)
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
+#ifdef CONFIG_ARCH_SUPPORTS_UPROBES
+#include <asm/uprobes.h>
+#else
+/*
+ * ARCH_SUPPORTS_UPROBES has not be defined.
+ */
+typedef u8 user_bkpt_opcode_t;
+#define UPROBES_XOL_SLOT_BYTES 1
+
+struct bkpt_arch_info {};
+struct user_bkpt_task_arch_info {};
+struct user_bkpt_arch_info user_bkpt_arch_info;
+#endif
+
+
+struct task_struct;
+struct pt_regs;
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
+ * @fixups:	set of fixups to be executed by @arch->post_xol()
+ * @arch_info:	architecture-specific info about this probepoint
+ */
+struct user_bkpt {
+	unsigned long vaddr;
+	unsigned long xol_vaddr;
+	user_bkpt_opcode_t opcode;
+	u8 insn[UPROBES_XOL_SLOT_BYTES];
+	u16 fixups;
+	struct bkpt_arch_info arch_info;
+};
+
+/* Post-execution fixups.  Some architectures may define others. */
+
+/* No fixup needed */
+#define UPROBES_FIX_NONE	0x0
+/* Adjust IP back to vicinity of actual insn */
+#define UPROBES_FIX_IP	0x1
+/* Adjust the return address of a call insn */
+#define UPROBES_FIX_CALL	0x2
+/* Might sleep while doing Fixup */
+#define UPROBES_FIX_SLEEPY	0x4
+
+#ifndef UPROBES_FIX_DEFAULT
+#define UPROBES_FIX_DEFAULT UPROBES_FIX_IP
+#endif
+
+/**
+ * struct user_bkpt_arch_info - architecture-specific parameters and
+ * functions
+ *
+ * Most architectures can use the default versions of @read_opcode(),
+ * @set_bkpt(), @set_orig_insn(), and @is_bkpt_insn();
+ * All functions (including @validate_address()) can assume
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
+ *	architecture.  This must be <= UPROBES_XOL_SLOT_BYTES;
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
+ *	@read_opcode().
+ * @set_bkpt:
+ *	For task @tsk, store @bkpt_insn at @user_bkpt->vaddr.  Return 0
+ *	(success) or a negative errno. Defaults to @set_bkpt().
+ * @set_orig_insn:
+ *	For task @tsk, restore the original opcode (@user_bkpt->opcode) at
+ *	@user_bkpt->vaddr.  If @check is true, first verify that there's
+ *	actually a breakpoint instruction there.  Return 0 (success) or
+ *	a negative errno.  Defaults to @set_orig_insn().
+ * @is_bkpt_insn:
+ *	Return %true if @user_bkpt->opcode is @bkpt_insn.  Defaults to
+ *	@is_bkpt_insn(), which just tests (user_bkpt->opcode ==
+ *	arch->bkpt_insn).
+ * @analyze_insn:
+ *	Analyze @user_bkpt->insn.  Return 0 if @user_bkpt->insn is an
+ *	instruction you can probe, or a negative errno (typically -%EPERM)
+ *	otherwise. Determine what sort of
+ *	XOL-related fixups @post_xol() (and possibly @pre_xol()) will need
+ *	to do for this instruction, and annotate @user_bkpt accordingly.
+ *	You may modify @user_bkpt->insn (e.g., the x86_64 port does this
+ *	for rip-relative instructions).
+ * @pre_xol:
+ *	Called just before executing the instruction associated
+ *	with @user_bkpt out of line.  @user_bkpt->xol_vaddr is the address
+ *	in @tsk's virtual address space where @user_bkpt->insn has been
+ *	copied.  @pre_xol() should at least set the instruction pointer in
+ *	@regs to @user_bkpt->xol_vaddr -- which is what the default,
+ *	@pre_xol(), does.
+ * @post_xol:
+ *	Called after executing the instruction associated with
+ *	@user_bkpt out of line.  @post_xol() should perform the fixups
+ *	specified in @user_bkpt->fixups, which includes ensuring that the
+ *	instruction pointer in @regs points at the next instruction in
+ *	the probed instruction stream.  @tskinfo is as for @pre_xol().
+ *	You must provide this function.
+ */
+
+struct user_bkpt_arch_info {
+	user_bkpt_opcode_t bkpt_insn;
+	u8 ip_advancement_by_bkpt_insn;
+	u8 max_insn_bytes;
+	void (*set_ip)(struct pt_regs *regs, unsigned long vaddr);
+	int (*validate_address)(struct task_struct *tsk, unsigned long vaddr);
+	int (*read_opcode)(struct task_struct *tsk, unsigned long vaddr,
+						user_bkpt_opcode_t *opcode);
+	int (*set_bkpt)(struct task_struct *tsk,
+				struct user_bkpt *user_bkpt);
+	int (*set_orig_insn)(struct task_struct *tsk,
+				struct user_bkpt *user_bkpt, bool check);
+	bool (*is_bkpt_insn)(struct user_bkpt *user_bkpt);
+	int (*analyze_insn)(struct task_struct *tsk,
+					struct user_bkpt *user_bkpt);
+	int (*pre_xol)(struct task_struct *tsk,
+				struct user_bkpt *user_bkpt,
+				struct user_bkpt_task_arch_info *tskinfo,
+				struct pt_regs *regs);
+	int (*post_xol)(struct task_struct *tsk,
+				struct user_bkpt *user_bkpt,
+				struct user_bkpt_task_arch_info *tskinfo,
+				struct pt_regs *regs);
+};
+
+/* Unexported functions & macros for use by arch-specific code */
+#define user_bkpt_opcode_sz (sizeof(user_bkpt_opcode_t))
+extern unsigned long uprobes_read_vm(struct task_struct *tsk,
+			void __user *vaddr, void *kbuf,
+			unsigned long nbytes);
+extern unsigned long uprobes_write_data(struct task_struct *tsk,
+			void __user *vaddr, const void *kbuf,
+			unsigned long nbytes);
+
+extern struct user_bkpt_arch_info user_bkpt_arch_info;
+
+#endif	/* _LINUX_UPROBES_H */
diff --git a/kernel/Makefile b/kernel/Makefile
index ce53fb2..ec70eab 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -105,6 +105,7 @@ obj-$(CONFIG_PERF_EVENTS) += perf_event.o
 obj-$(CONFIG_HAVE_HW_BREAKPOINT) += hw_breakpoint.o
 obj-$(CONFIG_USER_RETURN_NOTIFIER) += user-return-notifier.o
 obj-$(CONFIG_PADATA) += padata.o
+obj-$(CONFIG_UPROBES) += uprobes.o
 
 ifneq ($(CONFIG_SCHED_OMIT_FRAME_POINTER),y)
 # According to Alan Modra <alan@linuxcare.com.au>, the -fno-omit-frame-pointer is
diff --git a/kernel/uprobes.c b/kernel/uprobes.c
new file mode 100644
index 0000000..8439175
--- /dev/null
+++ b/kernel/uprobes.c
@@ -0,0 +1,466 @@
+/*
+ * Userspace Probes (UProbes)
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
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/ptrace.h>
+#include <linux/mm.h>
+#include <linux/uprobes.h>
+#include <linux/uaccess.h>
+#include <linux/highmem.h>
+#include <linux/pagemap.h>
+
+struct user_bkpt_arch_info *arch = &user_bkpt_arch_info;
+
+/**
+ * uprobes_read_vm - Read @nbytes at @vaddr from @tsk into @kbuf.
+ * @tsk: The probed task
+ * @vaddr: Source address, in user space to be read.
+ * @kbuf: Destination address, in kernel space.
+ *
+ * Context: This function may sleep.
+ *
+ * Returns number of bytes that could be copied.
+ */
+unsigned long uprobes_read_vm(struct task_struct *tsk, void __user *vaddr,
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
+ * uprobes_write_data - Write @nbytes from @kbuf at @vaddr in @tsk.
+ * Can be used to write to stack or data VM areas, but not instructions.
+ * Not exported, but available for use by arch-specific uprobes code.
+ * @tsk: The probed task
+ * @vaddr: Destination address, in user space.
+ * @kbuf: Source address, in kernel space to be read.
+ *
+ * Context: This function may sleep.
+ *
+ * Return number of bytes written.
+ */
+unsigned long uprobes_write_data(struct task_struct *tsk,
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
+static int write_opcode(struct task_struct *tsk, unsigned long vaddr,
+						user_bkpt_opcode_t opcode)
+{
+	struct mm_struct *mm;
+	struct vm_area_struct *vma;
+	struct page *old_page, *new_page;
+	void *vaddr_old, *vaddr_new;
+	pte_t orig_pte;
+	int ret = -EINVAL;
+
+	if (!tsk)
+		return ret;
+
+	mm = get_task_mm(tsk);
+	if (!mm)
+		return ret;
+
+	down_read(&mm->mmap_sem);
+
+	/* Read the page with vaddr into memory */
+	ret = get_user_pages(tsk, mm, vaddr, 1, 1, 1, &old_page, &vma);
+	if (ret <= 0)
+		goto mmput_out;
+
+	/*
+	 * check if the page we are interested is read-only mapped
+	 * Since we are interested in text pages, Our pages of interest
+	 * should be mapped read-only.
+	 */
+	if ((vma->vm_flags && (VM_READ|VM_WRITE)) != VM_READ) {
+		ret = -EINVAL;
+		goto put_out;
+	}
+
+	/* If its VM_SHARED vma, lets not write to such vma's.  */
+	if (vma->vm_flags & VM_SHARED) {
+		ret = -EINVAL;
+		goto put_out;
+	}
+
+	/* Allocate a page */
+	new_page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma, vaddr);
+	if (!new_page) {
+		ret = -ENOMEM;
+		goto put_out;
+	}
+
+	/*
+	 * lock page will serialize against do_wp_page()'s
+	 * PageAnon() handling
+	 */
+	lock_page(old_page);
+	/* mark page RO so any concurrent access will end up in do_wp_page() */
+	if (write_protect_page(vma, old_page, &orig_pte))
+		goto unlock_out;
+
+	/* copy the page now that we've got it stable */
+	vaddr_old = kmap_atomic(old_page, KM_USER0);
+	vaddr_new = kmap_atomic(new_page, KM_USER1);
+
+	memcpy(vaddr_new, vaddr_old, PAGE_SIZE);
+	/* poke the new insn in, ASSUMES we don't cross page boundary */
+	vaddr &= ~PAGE_MASK;
+	memcpy(vaddr_new + vaddr, &opcode, user_bkpt_opcode_sz);
+
+	kunmap_atomic(vaddr_new, KM_USER1);
+	kunmap_atomic(vaddr_old, KM_USER0);
+
+	lock_page(new_page);
+	/* flip pages, do_wp_page() will fail pte_same() and bail */
+	ret = replace_page(vma, old_page, new_page, orig_pte);
+
+unlock_out:
+	unlock_page(new_page);
+	unlock_page(old_page);
+	if (ret != 0)
+		page_cache_release(new_page);
+
+put_out:
+	put_page(old_page); /* we did a get_page in the beginning */
+
+mmput_out:
+	up_read(&mm->mmap_sem);
+	mmput(mm);
+	return ret;
+}
+
+/* Default implementation of arch->read_opcode */
+static int read_opcode(struct task_struct *tsk, unsigned long vaddr,
+						user_bkpt_opcode_t *opcode)
+{
+	unsigned long bytes_read;
+
+	bytes_read = uprobes_read_vm(tsk, (void __user *) vaddr, opcode,
+						user_bkpt_opcode_sz);
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
+static int check_vma(struct task_struct *tsk, unsigned long vaddr)
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
+/*
+ * validate_insn_addr - Validate if the instruction is an
+ * executable vma.
+ * Returns 0 if the vaddr is a valid instruction address.
+ * @tsk: the probed task
+ * @vaddr: virtual address of the instruction to be verified.
+ *
+ * Possible errors:
+ * -%EINVAL: Instruction passed is not a valid instruction address.
+ */
+static int validate_insn_addr(struct task_struct *tsk, unsigned long vaddr)
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
+			struct user_bkpt *user_bkpt, const char *why)
+{
+	printk(KERN_ERR "Can't place breakpoint at pid %d vaddr %#lx: %s\n",
+					tsk->pid, user_bkpt->vaddr, why);
+}
+
+/*
+ * __insert_bkpt - insert breakpoint
+ * Insert a breakpoint into the process that includes @tsk, at the
+ * virtual address @user_bkpt->vaddr.
+ *
+ * All threads of the probed process must be stopped while
+ * @__insert_bkpt() runs.
+ *
+ * Possible errors:
+ * -%ENOSYS: user_bkpt not supported for this architecture
+ * -%EINVAL: invalid instruction address
+ * -%EEXIST: breakpoint instruction already exists at that address
+ * -%EPERM: cannot probe this instruction
+ * -%EFAULT: failed to insert breakpoint instruction
+ */
+static int __insert_bkpt(struct task_struct *tsk,
+					struct user_bkpt *user_bkpt)
+{
+	int result;
+	unsigned long len;
+
+	result = validate_insn_addr(tsk, user_bkpt->vaddr);
+	if (result != 0)
+		return result;
+
+	/*
+	 * If uprobes_read_vm() transfers fewer bytes than the maximum
+	 * instruction size, assume that the probed instruction is smaller
+	 * than the max and near the end of the last page of instructions.
+	 * But there must be room at least for a breakpoint-size instruction.
+	 */
+	len = uprobes_read_vm(tsk, (void __user *) user_bkpt->vaddr,
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
+/*
+ * pre_sstep - prepare to single-step the probed instruction
+ * @tsk: the probed task
+ * @user_bkpt: the probepoint information, as returned by
+ *	@__insert_bkpt(). @user_bkpt->xol_vaddr must be the
+ *	address of an XOL instruction slot that is allocated to this
+ *	probepoint at least until after the completion of
+ *	@uprobes_post_sstep(), and populated with the contents of
+ *	@user_bkpt->insn.
+ *	@tskinfo: points to a @user_bkpt_task_arch_info object for @tsk.
+ *	@regs: reflects the saved user state of @tsk.  pre_sstep()
+ *	adjusts this.  In particular, the instruction pointer is set
+ *	to the instruction to be single-stepped.
+ * Possible errors:
+ * -%EFAULT: Failed to read or write @tsk's address space as needed.
+ *
+ * The client must ensure that the contents of @user_bkpt are not
+ * changed during the single-step operation -- i.e., between when
+ * @uprobes_pre_sstep() is called and when @uprobes_post_sstep() returns.
+ */
+static int pre_sstep(struct task_struct *tsk, struct user_bkpt *user_bkpt,
+		struct user_bkpt_task_arch_info *tskinfo, struct pt_regs *regs)
+{
+	return arch->pre_xol(tsk, user_bkpt, tskinfo, regs);
+}
+
+/*
+ * post_sstep - prepare to resume execution after single-step
+ * @tsk: the probed task
+ * @user_bkpt: the probepoint information, as with @user_bkpt_pre_sstep()
+ * @tskinfo: the @user_bkpt_task_arch_info object, if any, passed to
+ *	@pre_sstep()
+ * @regs: reflects the saved state of @tsk after the single-step
+ *	operation.  @post_sstep() adjusts @tsk's state as needed,
+ *	including pointing the instruction pointer at the instruction
+ *	following the probed instruction.
+ * Possible errors:
+ * -%EFAULT: Failed to read or write @tsk's address space as needed.
+ */
+static int post_sstep(struct task_struct *tsk, struct user_bkpt *user_bkpt,
+		struct user_bkpt_task_arch_info *tskinfo, struct pt_regs *regs)
+{
+	return arch->post_xol(tsk, user_bkpt, tskinfo, regs);
+}
+
+/**
+ * uprobes_get_bkpt_addr - compute address of bkpt given post-bkpt regs
+ * @regs: Reflects the saved state of the task after it has hit a breakpoint
+ * instruction.
+ * Return the address of the breakpoint instruction.
+ */
+unsigned long uprobes_get_bkpt_addr(struct pt_regs *regs)
+{
+	return instruction_pointer(regs) - arch->ip_advancement_by_bkpt_insn;
+}
+
+/*
+ * __remove_bkpt - remove breakpoint
+ * For the process that includes @tsk, remove the breakpoint specified
+ * by @user_bkpt, restoring the original opcode.
+ *
+ * Possible errors:
+ * -%EINVAL: @user_bkpt->vaddr is not a valid instruction address.
+ * -%ENOENT: There is no breakpoint instruction at @user_bkpt->vaddr.
+ * -%EFAULT: Failed to read/write @tsk's address space as needed.
+ */
+static int __remove_bkpt(struct task_struct *tsk,
+					struct user_bkpt *user_bkpt)
+{
+	if (validate_insn_addr(tsk, user_bkpt->vaddr) != 0)
+		return -EINVAL;
+	return arch->set_orig_insn(tsk, user_bkpt, true);
+}
+
+/*
+ * set_ip - Set instruction pointer
+ * @regs: Reflects the saved state of the task
+ */
+static void set_ip(struct pt_regs *regs, unsigned long vaddr)
+{
+	arch->set_ip(regs, vaddr);
+}
+
+/*
+ * uprobes_resume_can_sleep - Check if fixup might result in sleep.
+ * @user_bkpt: the probepoint information.
+ *
+ * Returns true if fixup might result in sleep.
+ */
+static bool uprobes_resume_can_sleep(struct user_bkpt *user_bkpt)
+{
+	return user_bkpt->fixups & UPROBES_FIX_SLEEPY;
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
+/* Validate arch-specific info during uprobes initialization. */
+static int bad_arch_param(const char *param_name, int value)
+{
+	printk(KERN_ERR "uprobes: bad value %d/%#x for parameter %s"
+		" in user_bkpt_arch_info\n", value, value, param_name);
+	return -ENOSYS;
+}
+
+static int missing_arch_func(const char *func_name)
+{
+	printk(KERN_ERR "uprobes: user_bkpt_arch_info lacks required "
+					"function: %s\n", func_name);
+	return -ENOSYS;
+}
+
+static int __init init_uprobes(void)
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
+	return result;
+}
+
+module_init(init_uprobes);
