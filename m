Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130Ab0CTO0Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 10:26:16 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:37351 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766Ab0CTO0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 10:26:13 -0400
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Masami Hiramatsu <mhiramat@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Date: Sat, 20 Mar 2010 19:56:07 +0530
Message-Id: <20100320142607.11427.59640.sendpatchset@localhost6.localdomain6>
In-Reply-To: <20100320142455.11427.76925.sendpatchset@localhost6.localdomain6>
References: <20100320142455.11427.76925.sendpatchset@localhost6.localdomain6>
Subject: [PATCH v1 6/10] Slot allocation for Execution out of line
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Slot allocation for Execution out of line strategy(XOL)

This patch provides slot allocation mechanism for execution out of
line strategy for use with user space breakpoint infrastructure.

Traditional method of replacing the original instructions on breakpoint
hit are racy when used on multithreaded applications.

Alternatives for the traditional method include:
	- Emulating the breakpointed instruction.
	- Execution out of line.

Emulating the instruction:
	This approach would use a in-kernel instruction emulator to
emulate the breakpointed instruction. This approach could be looked in
at a later point of time.

Execution out of line:
	In execution out of line strategy, a new vma is injected into
the target process, a copy of the instructions which are breakpointed is
stored in one of the slots. On breakpoint hit, the copy of the
instruction is single-stepped leaving the breakpoint instruction as is.
This method is architecture independent.

This method is useful while handling multithreaded processes.

This patch allocates one page per process for slots to be used to copy the
breakpointed instructions.

Current slot allocation mechanism:
1. Allocate one dedicated slot per user breakpoint. Each slot is big
enuf to accomodate the biggest instruction for that architecture. (16
bytes for x86).
2. We currently allocate only one page for slots. Hence the number of
slots is limited to active breakpoint hits on that process.
3. Bitmap to track used slots.

Signed-off-by: Jim Keniston <jkenisto@us.ibm.com>
Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---

 arch/Kconfig                  |    4 +
 include/linux/user_bkpt_xol.h |   61 +++++++++
 kernel/Makefile               |    1 
 kernel/user_bkpt_xol.c        |  290 +++++++++++++++++++++++++++++++++++++++++
 4 files changed, 356 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/user_bkpt_xol.h
 create mode 100644 kernel/user_bkpt_xol.c


diff --git a/arch/Kconfig b/arch/Kconfig
index 5667434..1a53e30 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -99,6 +99,10 @@ config USER_RETURN_NOTIFIER
 config HAVE_USER_BKPT
 	def_bool n
 
+config USER_BKPT_XOL
+	def_bool y
+	depends on USER_BKPT
+
 config HAVE_IOREMAP_PROT
 	bool
 
diff --git a/include/linux/user_bkpt_xol.h b/include/linux/user_bkpt_xol.h
new file mode 100644
index 0000000..b1d4d5a
--- /dev/null
+++ b/include/linux/user_bkpt_xol.h
@@ -0,0 +1,61 @@
+#ifndef _LINUX_XOL_H
+#define _LINUX_XOL_H
+/*
+ * User-space BreakPoint support (user_bkpt) -- Allocation of instruction
+ * slots for execution out of line (XOL)
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
+ * Copyright (C) IBM Corporation, 2009, 2010
+ * Authors:
+ *	Srikar Dronamraju
+ *	Jim Keniston
+ */
+
+#define UINSNS_PER_PAGE	(PAGE_SIZE/USER_BKPT_XOL_SLOT_BYTES)
+#define MAX_USER_BKPT_XOL_SLOTS UINSNS_PER_PAGE
+
+#ifdef CONFIG_USER_BKPT_XOL
+extern unsigned long xol_get_insn_slot(struct user_bkpt *user_bkpt,
+							void *xol_area);
+extern void xol_free_insn_slot(unsigned long, void *xol_area);
+extern int xol_validate_vaddr(struct pid *pid, unsigned long vaddr,
+							void *xol_area);
+extern void *xol_alloc_area(void);
+extern void xol_free_area(void *xol_area);
+#else /* CONFIG_USER_BKPT_XOL */
+static inline unsigned long xol_get_insn_slot(struct user_bkpt *user_bkpt,
+							void *xol_area)
+{
+	return 0;
+}
+static inline void xol_free_insn_slot(unsigned long slot_addr, void *xol_area)
+{
+}
+static inline int xol_validate_vaddr(struct pid *pid, unsigned long vaddr,
+							void *xol_area)
+{
+	return -ENOSYS;
+}
+static inline void *xol_alloc_area(void)
+{
+	return NULL;
+}
+static inline void xol_free_area(void *xol_area)
+{
+}
+#endif /* CONFIG_USER_BKPT_XOL */
+
+#endif  /* _LINUX_XOL_H */
diff --git a/kernel/Makefile b/kernel/Makefile
index 36a35b0..e404aa0 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -106,6 +106,7 @@ obj-$(CONFIG_HAVE_HW_BREAKPOINT) += hw_breakpoint.o
 obj-$(CONFIG_USER_RETURN_NOTIFIER) += user-return-notifier.o
 obj-$(CONFIG_PADATA) += padata.o
 obj-$(CONFIG_USER_BKPT) += user_bkpt.o
+obj-$(CONFIG_USER_BKPT_XOL) += user_bkpt_xol.o
 
 ifneq ($(CONFIG_SCHED_OMIT_FRAME_POINTER),y)
 # According to Alan Modra <alan@linuxcare.com.au>, the -fno-omit-frame-pointer is
diff --git a/kernel/user_bkpt_xol.c b/kernel/user_bkpt_xol.c
new file mode 100644
index 0000000..ebcb7df
--- /dev/null
+++ b/kernel/user_bkpt_xol.c
@@ -0,0 +1,290 @@
+/*
+ * User-space BreakPoint support (user_bkpt) -- Allocation of instruction
+ * slots for execution out of line (XOL)
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
+ * Copyright (C) IBM Corporation, 2009, 2010
+ * Authors:
+ *	Srikar Dronamraju
+ *	Jim Keniston
+ */
+
+/*
+ * Every probepoint gets its own slot.  Once it's assigned a slot, it
+ * keeps that slot until the probepoint goes away. Only definite number
+ * of slots are allocated.
+ */
+#include <linux/mm.h>
+#include <linux/err.h>
+#include <linux/errno.h>
+#include <linux/mman.h>
+#include <linux/file.h>
+#include <linux/pid.h>
+#include <linux/sched.h>
+#include <linux/user_bkpt.h>
+#include <linux/user_bkpt_xol.h>
+
+struct user_bkpt_xol_area {
+	spinlock_t lock;	/* protects bitmap and slot (de)allocation*/
+	unsigned long *bitmap;	/* 0 = free slot */
+
+	/*
+	 * We keep the vma's vm_start rather than a pointer to the vma
+	 * itself.  The probed process or a naughty kernel module could make
+	 * the vma go away, and we must handle that reasonably gracefully.
+	 */
+	unsigned long vaddr;		/* Page(s) of instruction slots */
+};
+
+static int xol_add_vma(struct user_bkpt_xol_area *area)
+{
+	struct vm_area_struct *vma;
+	struct mm_struct *mm;
+	struct file *file;
+	unsigned long addr;
+
+	mm = get_task_mm(current);
+	if (!mm)
+		return -ESRCH;
+
+	down_write(&mm->mmap_sem);
+	/*
+	 * Find the end of the top mapping and skip a page.
+	 * If there is no space for PAGE_SIZE above
+	 * that, mmap will ignore our address hint.
+	 *
+	 * We allocate a "fake" unlinked shmem file because
+	 * anonymous memory might not be granted execute
+	 * permission when the selinux security hooks have
+	 * their way.
+	 */
+	vma = rb_entry(rb_last(&mm->mm_rb), struct vm_area_struct, vm_rb);
+	addr = vma->vm_end + PAGE_SIZE;
+	file = shmem_file_setup("uprobes/xol", PAGE_SIZE, VM_NORESERVE);
+	if (!file) {
+		printk(KERN_ERR "user_bkpt_xol failed to setup shmem_file "
+			"while allocating vma for pid/tgid %d/%d for "
+			"single-stepping out of line.\n",
+			current->pid, current->tgid);
+		goto fail;
+	}
+	addr = do_mmap_pgoff(file, addr, PAGE_SIZE, PROT_EXEC, MAP_PRIVATE, 0);
+	fput(file);
+
+	if (addr & ~PAGE_MASK) {
+		printk(KERN_ERR "user_bkpt_xol failed to allocate a vma for "
+				"pid/tgid %d/%d for single-stepping out of "
+				"line.\n", current->pid, current->tgid);
+		goto fail;
+	}
+	vma = find_vma(mm, addr);
+	BUG_ON(!vma);
+
+	/* Don't expand vma on mremap(). */
+	vma->vm_flags |= VM_DONTEXPAND | VM_DONTCOPY;
+	area->vaddr = vma->vm_start;
+	up_write(&mm->mmap_sem);
+	mmput(mm);
+	return 0;
+
+fail:
+	up_write(&mm->mmap_sem);
+	mmput(mm);
+	return -ENOMEM;
+}
+
+/**
+ * xol_alloc_area - Allocate process's user_bkpt_xol_area.
+ * This area will be used for storing instructions for execution out of
+ * line.
+ */
+void *xol_alloc_area(void)
+{
+	struct user_bkpt_xol_area *area = NULL;
+
+	area = kzalloc(sizeof(*area), GFP_USER);
+	if (unlikely(!area))
+		return NULL;
+
+	area->bitmap = kzalloc(BITS_TO_LONGS(UINSNS_PER_PAGE) * sizeof(long),
+								GFP_USER);
+
+	if (!area->bitmap)
+		goto fail;
+	if (xol_add_vma(area)) {
+		kfree(area->bitmap);
+		goto fail;
+	}
+	spin_lock_init(&area->lock);
+	return (void *)area;
+
+fail:
+	kfree(area);
+	return NULL;
+}
+
+void xol_free_area(void *xol_area)
+{
+	struct user_bkpt_xol_area *area;
+
+	area = (struct user_bkpt_xol_area *)xol_area;
+	kfree(area->bitmap);
+	kfree(area);
+}
+
+/*
+ * Find a slot
+ *  - searching in existing vmas for a free slot.
+ *  - If no free slot in existing vmas, return 0;
+ *  called with lock acquired.
+ */
+static unsigned long xol_take_insn_slot(struct user_bkpt_xol_area *area)
+{
+	unsigned long slot_addr;
+	int slot_nr;
+
+	slot_nr = find_first_zero_bit(area->bitmap, UINSNS_PER_PAGE);
+	if (slot_nr < UINSNS_PER_PAGE) {
+		set_bit(slot_nr, area->bitmap);
+		slot_addr = area->vaddr +
+				(slot_nr * USER_BKPT_XOL_SLOT_BYTES);
+		return slot_addr;
+	}
+
+	return 0;
+}
+
+/**
+ * xol_get_insn_slot - If user_bkpt was not allocated a slot, then
+ * allocate a slot. If user_bkpt_insert_bkpt is already called, (i.e
+ * user_bkpt.vaddr != 0) then copy the instruction into the slot.
+ * Returns the allocated slot address or 0.
+ * @user_bkpt: probepoint information
+ * @xol_area refers the unique per process user_bkpt_xol_area for
+ * this process.
+ */
+unsigned long xol_get_insn_slot(struct user_bkpt *user_bkpt, void *xol_area)
+{
+	struct user_bkpt_xol_area *area;
+	unsigned long flags;
+	int len;
+
+	area = (struct user_bkpt_xol_area *)xol_area;
+	if (unlikely(!area))
+		return 0;
+
+	if (!user_bkpt->xol_vaddr) {
+		spin_lock_irqsave(&area->lock, flags);
+		if (likely(!user_bkpt->xol_vaddr))
+			user_bkpt->xol_vaddr = xol_take_insn_slot(area);
+		spin_unlock_irqrestore(&area->lock, flags);
+
+		/*
+		 * Initialize the slot if user_bkpt->vaddr points to valid
+		 * instruction slot.
+		 */
+		if (likely(user_bkpt->xol_vaddr) && user_bkpt->vaddr) {
+			len = access_process_vm(current, user_bkpt->xol_vaddr,
+				user_bkpt->insn, USER_BKPT_XOL_SLOT_BYTES, 1);
+			if (unlikely(len < USER_BKPT_XOL_SLOT_BYTES))
+				printk(KERN_ERR "Failed to copy instruction"
+						" at %#lx len = %d\n",
+						user_bkpt->vaddr, len);
+		}
+	}
+	return user_bkpt->xol_vaddr;
+}
+
+/**
+ * xol_free_insn_slot - If slot was earlier allocated by
+ * @xol_get_insn_slot(), make the slot available for
+ * subsequent requests.
+ * @slot_addr: slot address as returned by
+ * @xol_get_insn_area().
+ * @xol_area refers the unique per process user_bkpt_xol_area for
+ * this process.
+ */
+void xol_free_insn_slot(unsigned long slot_addr, void *xol_area)
+{
+	struct user_bkpt_xol_area *area;
+	unsigned long vma_end;
+	int found = 0;
+
+	area = (struct user_bkpt_xol_area *)xol_area;
+	if (unlikely(!slot_addr || IS_ERR_VALUE(slot_addr)))
+		return;
+
+	if (unlikely(!area))
+		return;
+
+	vma_end = area->vaddr + PAGE_SIZE;
+	if (area->vaddr <= slot_addr && slot_addr < vma_end) {
+		int slot_nr;
+		unsigned long offset = slot_addr - area->vaddr;
+		unsigned long flags;
+
+		BUG_ON(offset % USER_BKPT_XOL_SLOT_BYTES);
+
+		slot_nr = offset / USER_BKPT_XOL_SLOT_BYTES;
+		BUG_ON(slot_nr >= UINSNS_PER_PAGE);
+
+		spin_lock_irqsave(&area->lock, flags);
+		clear_bit(slot_nr, area->bitmap);
+		spin_unlock_irqrestore(&area->lock, flags);
+		found = 1;
+	}
+
+	if (!found)
+		printk(KERN_ERR "%s: no XOL vma for slot address %#lx\n",
+						__func__, slot_addr);
+}
+
+/**
+ * xol_validate_vaddr - Verify if the specified address is in an
+ * executable vma, but not in an XOL vma.
+ *	- Return 0 if the specified virtual address is in an
+ *	  executable vma, but not in an XOL vma.
+ *	- Return 1 if the specified virtual address is in an
+ *	  XOL vma.
+ *	- Return -EINTR otherwise.(i.e non executable vma, or
+ *	  not a valid address
+ * @pid: the probed process
+ * @vaddr: virtual address of the instruction to be validated.
+ * @xol_area refers the unique per process user_bkpt_xol_area for
+ * this process.
+ */
+int xol_validate_vaddr(struct pid *pid, unsigned long vaddr, void *xol_area)
+{
+	struct user_bkpt_xol_area *area;
+	struct task_struct *tsk;
+	unsigned long vma_end;
+	int result;
+
+	area = (struct user_bkpt_xol_area *) xol_area;
+	tsk = pid_task(pid, PIDTYPE_PID);
+	result = user_bkpt_validate_insn_addr(tsk, vaddr);
+	if (result != 0)
+		return result;
+
+	if (unlikely(!area))
+		return 0;
+
+	vma_end = area->vaddr + PAGE_SIZE;
+	if (area->vaddr <= vaddr && vaddr < vma_end)
+		result = 1;
+
+	return result;
+}
