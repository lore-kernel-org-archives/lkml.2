Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947Ab0HYNsB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 09:48:01 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:55252 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917Ab0HYNqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 09:46:44 -0400
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Naren A Devaiah <naren.devaiah@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Wed, 25 Aug 2010 19:11:56 +0530
Message-Id: <20100825134156.5447.43216.sendpatchset@localhost6.localdomain6>
In-Reply-To: <20100825134117.5447.55209.sendpatchset@localhost6.localdomain6>
References: <20100825134117.5447.55209.sendpatchset@localhost6.localdomain6>
Subject: [PATCHv11 2.6.36-rc2-tip 3/15]  3: uprobes: Slot allocation for Execution out of line(XOL)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Provides slot allocation mechanism for execution out of line for use
with user space breakpointing.

Traditional method of replacing the original instructions on
breakpoint hit are racy when used on multithreaded applications.

Alternatives for the traditional method include:
	- Emulating the breakpointed instruction.
	- Execution out of line.

Emulating the instruction:
	This approach would use a in-kernel instruction emulator to
emulate the breakpointed instruction. This approach could be looked in
at a later point of time.

Execution out of line:
	In execution out of line strategy, a new vma is injected into
the target process, a copy of the instructions which are breakpointed
is stored in one of the slots. On breakpoint hit, the copy of the
instruction is single-stepped leaving the breakpoint instruction as
is.  This method is architecture independent.

This method is useful while handling multithreaded processes.

This patch allocates one page per process for slots to be used to copy
the breakpointed instructions.

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

Changelog from V5: Merged into uprobes.

Changelog form V3:
 * Added a memory barrier after the slot gets initialized.

Changelog from V2: (addressing Oleg's comments)
 * Removed code in !CONFIG_UPROBES_XOL
 * Functions now pass pointer to uprobes_xol_area instead of pointer
   to void.

 include/linux/uprobes.h |    2 
 kernel/uprobes.c        |  283 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 285 insertions(+), 0 deletions(-)

diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
index faacb2f..84a078c 100644
--- a/include/linux/uprobes.h
+++ b/include/linux/uprobes.h
@@ -37,6 +37,8 @@ struct user_bkpt_task_arch_info {};
 struct user_bkpt_arch_info;
 #endif
 
+#define UINSNS_PER_PAGE	(PAGE_SIZE/UPROBES_XOL_SLOT_BYTES)
+#define MAX_UPROBES_XOL_SLOTS UINSNS_PER_PAGE
 
 struct task_struct;
 struct pt_regs;
diff --git a/kernel/uprobes.c b/kernel/uprobes.c
index 8a659c9..230adf3 100644
--- a/kernel/uprobes.c
+++ b/kernel/uprobes.c
@@ -30,6 +30,12 @@
 #include <linux/uaccess.h>
 #include <linux/highmem.h>
 #include <linux/pagemap.h>
+#include <linux/err.h>
+#include <linux/errno.h>
+#include <linux/mman.h>
+#include <linux/file.h>
+#include <linux/pid.h>
+#include <linux/slab.h>
 
 struct user_bkpt_arch_info *arch = &user_bkpt_arch_info;
 
@@ -458,6 +464,283 @@ static int bad_arch_param(const char *param_name, int value)
 	return -ENOSYS;
 }
 
+/* Slot allocation for XOL */
+
+/*
+ * Every probepoint gets its own slot.  Once it's assigned a slot, it
+ * keeps that slot until the probepoint goes away. Only definite number
+ * of slots are allocated.
+ */
+
+struct uprobes_xol_area {
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
+static int xol_add_vma(struct uprobes_xol_area *area)
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
+		printk(KERN_ERR "uprobes_xol failed to setup shmem_file "
+			"while allocating vma for pid/tgid %d/%d for "
+			"single-stepping out of line.\n",
+			current->pid, current->tgid);
+		goto fail;
+	}
+	addr = do_mmap_pgoff(file, addr, PAGE_SIZE, PROT_EXEC, MAP_PRIVATE, 0);
+	fput(file);
+
+	if (addr & ~PAGE_MASK) {
+		printk(KERN_ERR "uprobes_xol failed to allocate a vma for "
+				"pid/tgid %d/%d for single-stepping out of "
+				"line.\n", current->pid, current->tgid);
+		goto fail;
+	}
+	vma = find_vma(mm, addr);
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
+/*
+ * xol_alloc_area - Allocate process's uprobes_xol_area.
+ * This area will be used for storing instructions for execution out of
+ * line.
+ *
+ * Called with mm->uproc->mutex locked.
+ * Returns the allocated area or NULL.
+ */
+static struct uprobes_xol_area *xol_alloc_area(void)
+{
+	struct uprobes_xol_area *area = NULL;
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
+	return area;
+
+fail:
+	kfree(area);
+	return NULL;
+}
+
+/*
+ * xol_free_area - Free the area allocated for slots.
+ * @xol_area refers the unique per process uprobes_xol_area for
+ * this process.
+ *
+ */
+static void xol_free_area(struct uprobes_xol_area *xol_area)
+{
+	kfree(xol_area->bitmap);
+	kfree(xol_area);
+}
+
+/*
+ * Find a slot
+ *  - searching in existing vmas for a free slot.
+ *  - If no free slot in existing vmas, return 0;
+ *
+ * Called when holding xol_area->lock
+ */
+static unsigned long xol_take_insn_slot(struct uprobes_xol_area *area)
+{
+	unsigned long slot_addr;
+	int slot_nr;
+
+	slot_nr = find_first_zero_bit(area->bitmap, UINSNS_PER_PAGE);
+	if (slot_nr < UINSNS_PER_PAGE) {
+		set_bit(slot_nr, area->bitmap);
+		slot_addr = area->vaddr +
+				(slot_nr * UPROBES_XOL_SLOT_BYTES);
+		return slot_addr;
+	}
+
+	return 0;
+}
+
+/*
+ * xol_get_insn_slot - If user_bkpt  was not allocated a slot, then
+ * allocate a slot. If uprobes_insert_bkpt is already called, (i.e
+ * user_bkpt.vaddr != 0) then copy the instruction into the slot.
+ * @user_bkpt: probepoint information
+ * @xol_area refers the unique per process uprobes_xol_area for
+ * this process.
+ *
+ * Called with mm->uproc->mutex locked.
+ * Returns the allocated slot address or 0.
+ */
+static unsigned long xol_get_insn_slot(struct user_bkpt *user_bkpt,
+				struct uprobes_xol_area *xol_area)
+{
+	unsigned long flags, xol_vaddr = 0;
+	int len;
+
+	if (unlikely(!xol_area))
+		return 0;
+
+	if (user_bkpt->xol_vaddr)
+		return user_bkpt->xol_vaddr;
+
+	spin_lock_irqsave(&xol_area->lock, flags);
+	xol_vaddr = xol_take_insn_slot(xol_area);
+	spin_unlock_irqrestore(&xol_area->lock, flags);
+
+	/*
+	 * Initialize the slot if user_bkpt->vaddr points to valid
+	 * instruction slot.
+	 */
+	if (likely(xol_vaddr) && user_bkpt->vaddr) {
+		len = access_process_vm(current, xol_vaddr, user_bkpt->insn,
+						UPROBES_XOL_SLOT_BYTES, 1);
+		if (unlikely(len < UPROBES_XOL_SLOT_BYTES))
+			printk(KERN_ERR "Failed to copy instruction at %#lx "
+					"len = %d\n", user_bkpt->vaddr, len);
+	}
+
+	/*
+	 * Update user_bkpt->xol_vaddr after giving a chance for the slot to
+	 * be initialized.
+	 */
+	mb();
+	user_bkpt->xol_vaddr = xol_vaddr;
+	return user_bkpt->xol_vaddr;
+}
+
+/*
+ * xol_free_insn_slot - If slot was earlier allocated by
+ * @xol_get_insn_slot(), make the slot available for
+ * subsequent requests.
+ * @slot_addr: slot address as returned by
+ * @xol_get_insn_area().
+ * @xol_area refers the unique per process uprobes_xol_area for
+ * this process.
+ */
+static void xol_free_insn_slot(unsigned long slot_addr,
+				struct uprobes_xol_area *xol_area)
+{
+	unsigned long vma_end;
+	int found = 0;
+
+	if (unlikely(!slot_addr || IS_ERR_VALUE(slot_addr)))
+		return;
+
+	if (unlikely(!xol_area))
+		return;
+
+	vma_end = xol_area->vaddr + PAGE_SIZE;
+	if (xol_area->vaddr <= slot_addr && slot_addr < vma_end) {
+		int slot_nr;
+		unsigned long offset = slot_addr - xol_area->vaddr;
+		unsigned long flags;
+
+		BUG_ON(offset % UPROBES_XOL_SLOT_BYTES);
+
+		slot_nr = offset / UPROBES_XOL_SLOT_BYTES;
+		BUG_ON(slot_nr >= UINSNS_PER_PAGE);
+
+		spin_lock_irqsave(&xol_area->lock, flags);
+		clear_bit(slot_nr, xol_area->bitmap);
+		spin_unlock_irqrestore(&xol_area->lock, flags);
+		found = 1;
+	}
+
+	if (!found)
+		printk(KERN_ERR "%s: no XOL vma for slot address %#lx\n",
+						__func__, slot_addr);
+}
+
+/*
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
+ * @xol_area refers the unique per process uprobes_xol_area for
+ * this process.
+ */
+static int xol_validate_vaddr(struct pid *pid, unsigned long vaddr,
+				struct uprobes_xol_area *xol_area)
+{
+	struct task_struct *tsk;
+	unsigned long vma_end;
+	int result;
+
+	if (unlikely(!xol_area))
+		return 0;
+
+	tsk = get_pid_task(pid, PIDTYPE_PID);
+	if (unlikely(!tsk))
+		return -EINVAL;
+
+	result = validate_address(tsk, vaddr);
+	if (result != 0)
+		goto validate_end;
+
+	vma_end = xol_area->vaddr + PAGE_SIZE;
+	if (xol_area->vaddr <= vaddr && vaddr < vma_end)
+		result = 1;
+
+validate_end:
+	put_task_struct(tsk);
+	return result;
+}
+/* end of slot allocation for XOL */
+
 static int __init init_uprobes(void)
 {
 	int result = 0;
