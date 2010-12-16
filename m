Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218Ab0LPKAf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 05:00:35 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:39189 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299Ab0LPKA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 05:00:29 -0500
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-mm <linux-mm@vger.kernel.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        SystemTap <systemtap@sources.redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Thu, 16 Dec 2010 15:27:49 +0530
Message-Id: <20101216095749.23751.39331.sendpatchset@localhost6.localdomain6>
In-Reply-To: <20101216095714.23751.52601.sendpatchset@localhost6.localdomain6>
References: <20101216095714.23751.52601.sendpatchset@localhost6.localdomain6>
Subject: [RFC] [PATCH 2.6.37-rc5-tip 3/20]  3: uprobes: Breakground page replacement.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Provides Background page replacement using replace_page() routine.
Also provides routines to read/write few bytes to vm and for
verifying if a instruction is a breakpoint instruction.

Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Jim Keniston <jkenisto@us.ibm.com>
---
 arch/Kconfig                   |   11 ++
 arch/x86/include/asm/uprobes.h |    2 
 include/linux/uprobes.h        |   76 ++++++++++++
 kernel/Makefile                |    1 
 kernel/uprobes.c               |  252 ++++++++++++++++++++++++++++++++++++++++
 5 files changed, 341 insertions(+), 1 deletions(-)
 create mode 100644 include/linux/uprobes.h
 create mode 100644 kernel/uprobes.c

diff --git a/arch/Kconfig b/arch/Kconfig
index f78c2be..6e8f26e 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -61,6 +61,17 @@ config OPTPROBES
 	depends on KPROBES && HAVE_OPTPROBES
 	depends on !PREEMPT
 
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
diff --git a/arch/x86/include/asm/uprobes.h b/arch/x86/include/asm/uprobes.h
index 0e8ad5d..5026359 100644
--- a/arch/x86/include/asm/uprobes.h
+++ b/arch/x86/include/asm/uprobes.h
@@ -25,7 +25,7 @@
 
 typedef u8 uprobe_opcode_t;
 #define MAX_UINSN_BYTES 16
-#define UPROBES_XOL_SLOT_BYTES (MAX_UINSN_BYTES)
+#define UPROBES_XOL_SLOT_BYTES	128	/* to keep it cache aligned */
 
 #define UPROBES_BKPT_INSN 0xcc
 #define UPROBES_BKPT_INSN_SIZE 1
diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
new file mode 100644
index 0000000..952e9d7
--- /dev/null
+++ b/include/linux/uprobes.h
@@ -0,0 +1,76 @@
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
+typedef u8 uprobe_opcode_t;
+
+/* Post-execution fixups.  Some architectures may define others. */
+#endif /* CONFIG_ARCH_SUPPORTS_UPROBES */
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
+/* Unexported functions & macros for use by arch-specific code */
+#define uprobe_opcode_sz (sizeof(uprobe_opcode_t))
+extern unsigned long uprobes_read_vm(struct task_struct *tsk,
+			void __user *vaddr, void *kbuf,
+			unsigned long nbytes);
+extern unsigned long uprobes_write_vm(struct task_struct *tsk,
+			void __user *vaddr, const void *kbuf,
+			unsigned long nbytes);
+
+/*
+ * Most architectures can use the default versions of @read_opcode(),
+ * @set_bkpt(), @set_orig_insn(), and @is_bkpt_insn();
+ *
+ * @set_ip:
+ *	Set the instruction pointer in @regs to @vaddr.
+ * @analyze_insn:
+ *	Analyze @user_bkpt->insn.  Return 0 if @user_bkpt->insn is an
+ *	instruction you can probe, or a negative errno (typically -%EPERM)
+ *	otherwise. Determine what sort of
+ * @pre_xol:
+ * @post_xol:
+ *	XOL-related fixups @post_xol() (and possibly @pre_xol()) will need
+ *	to do for this instruction, and annotate @user_bkpt accordingly.
+ *	You may modify @user_bkpt->insn (e.g., the x86_64 port does this
+ *	for rip-relative instructions).
+ */
+#endif	/* _LINUX_UPROBES_H */
diff --git a/kernel/Makefile b/kernel/Makefile
index 0b5ff08..e53c0c4 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -106,6 +106,7 @@ obj-$(CONFIG_PERF_EVENTS) += perf_event.o
 obj-$(CONFIG_HAVE_HW_BREAKPOINT) += hw_breakpoint.o
 obj-$(CONFIG_USER_RETURN_NOTIFIER) += user-return-notifier.o
 obj-$(CONFIG_PADATA) += padata.o
+obj-$(CONFIG_UPROBES) += uprobes.o
 
 ifneq ($(CONFIG_SCHED_OMIT_FRAME_POINTER),y)
 # According to Alan Modra <alan@linuxcare.com.au>, the -fno-omit-frame-pointer is
diff --git a/kernel/uprobes.c b/kernel/uprobes.c
new file mode 100644
index 0000000..cb5884b
--- /dev/null
+++ b/kernel/uprobes.c
@@ -0,0 +1,252 @@
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
+#include <linux/uaccess.h>
+#include <linux/highmem.h>
+#include <linux/pagemap.h>
+#include <linux/slab.h>
+#include <linux/uprobes.h>
+#include <linux/rmap.h> /* needed for anon_vma_prepare */
+
+struct uprobe {
+	uprobe_opcode_t		opcode;
+	u16			fixups;
+};
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
+ * uprobes_write_vm - Write @nbytes from @kbuf at @vaddr in @tsk.
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
+unsigned long uprobes_write_vm(struct task_struct *tsk, void __user *vaddr,
+				const void *kbuf, unsigned long nbytes)
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
+						uprobe_opcode_t opcode)
+{
+	struct page *old_page, *new_page;
+	void *vaddr_old, *vaddr_new;
+	struct vm_area_struct *vma;
+	struct mm_struct *mm;
+	pte_t orig_pte;
+	int ret = -EINVAL;
+
+	mm = get_task_mm(tsk);
+	down_read(&mm->mmap_sem);
+
+	/* Read the page with vaddr into memory */
+	ret = get_user_pages(tsk, mm, vaddr, 1, 0, 0, &old_page, &vma);
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
+	/* copy the page now that we've got it stable */
+	vaddr_old = kmap_atomic(old_page, KM_USER0);
+	vaddr_new = kmap_atomic(new_page, KM_USER1);
+
+	memcpy(vaddr_new, vaddr_old, PAGE_SIZE);
+	/* poke the new insn in, ASSUMES we don't cross page boundary */
+	vaddr &= ~PAGE_MASK;
+	memcpy(vaddr_new + vaddr, &opcode, uprobe_opcode_sz);
+
+	kunmap_atomic(vaddr_new, KM_USER1);
+	kunmap_atomic(vaddr_old, KM_USER0);
+
+	/* mark page RO so any concurrent access will end up in do_wp_page() */
+	if (write_protect_page(vma, old_page, &orig_pte))
+		goto unlock_out;
+
+	lock_page(new_page);
+	if (!anon_vma_prepare(vma))
+		/* flip pages, do_wp_page() will fail pte_same() and bail */
+		ret = replace_page(vma, old_page, new_page, orig_pte);
+
+	unlock_page(new_page);
+	if (ret != 0)
+		page_cache_release(new_page);
+unlock_out:
+	unlock_page(old_page);
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
+/**
+ * read_opcode - read the opcode at a given virtual address.
+ * @tsk: the probed task.
+ * @vaddr: the virtual address to store the opcode.
+ * @opcode: location to store the read opcode.
+ *
+ * For task @tsk, read the opcode at @vaddr and store it in @opcode.
+ * Return 0 (success) or a negative errno.
+ */
+int __weak read_opcode(struct task_struct *tsk, unsigned long vaddr,
+						uprobe_opcode_t *opcode)
+{
+	unsigned long bytes_read;
+
+	bytes_read = uprobes_read_vm(tsk, (void __user *) vaddr, opcode,
+						uprobe_opcode_sz);
+	return (bytes_read == uprobe_opcode_sz ? 0 : -EFAULT);
+}
+
+/**
+ * set_bkpt - store breakpoint at a given address.
+ * @tsk: the probed task
+ * @vaddr: the virtual address to insert the opcode.
+ *
+ * For task @tsk, store the breakpoint instruction at @vaddr.
+ * Return 0 (success) or a negative errno.
+ */
+int __weak set_bkpt(struct task_struct *tsk, unsigned long vaddr)
+{
+	return write_opcode(tsk, vaddr, UPROBES_BKPT_INSN);
+}
+
+/**
+ * set_orig_insn - Restore the original instruction.
+ * @tsk: the probed task
+ * @vaddr: the virtual address to insert the opcode.
+ * @verify: if true, verify existance of breakpoint instruction.
+ *
+ * For task @tsk, restore the original opcode (opcode) at @vaddr.
+ * Return 0 (success) or a negative errno.
+ */
+int __weak set_orig_insn(struct task_struct *tsk, unsigned long vaddr,
+				bool verify, struct uprobe *uprobe)
+{
+	if (verify) {
+		uprobe_opcode_t opcode;
+		int result = read_opcode(tsk, vaddr, &opcode);
+		if (result)
+			return result;
+		if (opcode != UPROBES_BKPT_INSN)
+			return -EINVAL;
+	}
+	return write_opcode(tsk, vaddr, uprobe->opcode);
+}
+
+static void print_insert_fail(struct task_struct *tsk,
+			unsigned long vaddr, const char *why)
+{
+	printk(KERN_ERR "Can't place breakpoint at pid %d vaddr %#lx: %s\n",
+					tsk->pid, vaddr, why);
+}
+
+/*
+ * uprobes_resume_can_sleep - Check if fixup might result in sleep.
+ * @uprobes: the probepoint information.
+ *
+ * Returns true if fixup might result in sleep.
+ */
+static bool uprobes_resume_can_sleep(struct uprobe *uprobe)
+{
+	return uprobe->fixups & UPROBES_FIX_SLEEPY;
+}
+
+/**
+ * is_bkpt_insn - check if instruction is breakpoint instruction.
+ * @uprobe: the probepoint information.
+ * Default implementation of is_bkpt_insn
+ * Returns true if @uprobe->opcode is @bkpt_insn.
+ */
+bool __weak is_bkpt_insn(struct uprobe *uprobe)
+{
+	return (uprobe->opcode == UPROBES_BKPT_INSN);
+}
+
