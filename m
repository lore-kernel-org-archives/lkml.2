Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755738Ab2JWLCS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 07:02:18 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:57611 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348Ab2JWLCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 07:02:16 -0400
Date: Tue, 23 Oct 2012 13:02:07 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Oleg Nesterov <oleg@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20121023110207.GA28324@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus

   HEAD: ef8ff74ed8dd9d4b3ba8cb9f2fc927a27c697a8b Merge branch 'tip/perf/urgent' of git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace into perf/urgent

Most of these are uprobes race fixes from Oleg, and their 
preparatory cleanups. (It's larger than what I'd normally send 
for an -rc kernel, but they looked significant enough to not 
delay them.)

There's also an oprofile fix and an uncore PMU fix.

 Thanks,

	Ingo

------------------>
Dan Carpenter (1):
      oprofile, x86: Fix wrapping bug in op_x86_get_ctrl()

Oleg Nesterov (19):
      uprobes: Do not leak UTASK_BP_HIT if find_active_uprobe() fails
      uprobes: Do not setup ->active_uprobe/state prematurely
      uprobes: Fix UPROBE_SKIP_SSTEP checks in handle_swbp()
      uprobes: Kill UTASK_BP_HIT state
      uprobes: Move clear_thread_flag(TIF_UPROBE) to uprobe_notify_resume()
      uprobes: Change write_opcode() to use FOLL_FORCE
      uprobes: Change valid_vma() to demand VM_MAYEXEC rather than VM_EXEC
      uprobes: Restrict valid_vma(false) to skip VM_SHARED vmas
      uprobes: Kill set_swbp()->is_swbp_at_addr()
      uprobes: Introduce copy_opcode(), kill read_opcode()
      uprobes: Kill set_orig_insn()->is_swbp_at_addr()
      uprobes: Simplify is_swbp_at_addr(), remove stale comments
      uprobes/x86: Only rep+nop can be emulated correctly
      uprobes: Don't return success if alloc_uprobe() fails
      uprobes: Do not delete uprobe if uprobe_unregister() fails
      uprobes: Fix handle_swbp() vs unregister() + register() race
      uprobes: Introduce prepare_uprobe()
      uprobes: Fix prepare_uprobe() race with itself
      uprobes: Fix the racy uprobe->flags manipulation

Vaibhav Nagarnaik (1):
      ring-buffer: Check for uninitialized cpu buffer before resizing

Yan, Zheng (1):
      perf/x86: Disable uncore on virtualized CPUs


 arch/x86/kernel/cpu/perf_event_intel_uncore.c |   3 +
 arch/x86/kernel/signal.c                      |   4 +-
 arch/x86/kernel/uprobes.c                     |  16 +-
 arch/x86/oprofile/nmi_int.c                   |   2 +-
 include/linux/uprobes.h                       |  11 -
 kernel/events/uprobes.c                       | 345 ++++++++++++--------------
 kernel/trace/ring_buffer.c                    |   4 +
 7 files changed, 173 insertions(+), 212 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 99d96a4..5df8d32 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -2926,6 +2926,9 @@ static int __init intel_uncore_init(void)
 	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL)
 		return -ENODEV;
 
+	if (cpu_has_hypervisor)
+		return -ENODEV;
+
 	ret = uncore_pci_init();
 	if (ret)
 		goto fail;
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 29ad351..70b27ee 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -824,10 +824,8 @@ do_notify_resume(struct pt_regs *regs, void *unused, __u32 thread_info_flags)
 		mce_notify_process();
 #endif /* CONFIG_X86_64 && CONFIG_X86_MCE */
 
-	if (thread_info_flags & _TIF_UPROBE) {
-		clear_thread_flag(TIF_UPROBE);
+	if (thread_info_flags & _TIF_UPROBE)
 		uprobe_notify_resume(regs);
-	}
 
 	/* deal with pending signal delivery */
 	if (thread_info_flags & _TIF_SIGPENDING)
diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index 9538f00..aafa555 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -651,31 +651,19 @@ void arch_uprobe_abort_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
 
 /*
  * Skip these instructions as per the currently known x86 ISA.
- * 0x66* { 0x90 | 0x0f 0x1f | 0x0f 0x19 | 0x87 0xc0 }
+ * rep=0x66*; nop=0x90
  */
 static bool __skip_sstep(struct arch_uprobe *auprobe, struct pt_regs *regs)
 {
 	int i;
 
 	for (i = 0; i < MAX_UINSN_BYTES; i++) {
-		if ((auprobe->insn[i] == 0x66))
+		if (auprobe->insn[i] == 0x66)
 			continue;
 
 		if (auprobe->insn[i] == 0x90)
 			return true;
 
-		if (i == (MAX_UINSN_BYTES - 1))
-			break;
-
-		if ((auprobe->insn[i] == 0x0f) && (auprobe->insn[i+1] == 0x1f))
-			return true;
-
-		if ((auprobe->insn[i] == 0x0f) && (auprobe->insn[i+1] == 0x19))
-			return true;
-
-		if ((auprobe->insn[i] == 0x87) && (auprobe->insn[i+1] == 0xc0))
-			return true;
-
 		break;
 	}
 	return false;
diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index 26b8a85..48768df 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -55,7 +55,7 @@ u64 op_x86_get_ctrl(struct op_x86_model_spec const *model,
 	val |= counter_config->extra;
 	event &= model->event_mask ? model->event_mask : 0xFF;
 	val |= event & 0xFF;
-	val |= (event & 0x0F00) << 24;
+	val |= (u64)(event & 0x0F00) << 24;
 
 	return val;
 }
diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
index e6f0331..2459457 100644
--- a/include/linux/uprobes.h
+++ b/include/linux/uprobes.h
@@ -35,16 +35,6 @@ struct inode;
 # include <asm/uprobes.h>
 #endif
 
-/* flags that denote/change uprobes behaviour */
-
-/* Have a copy of original instruction */
-#define UPROBE_COPY_INSN	0x1
-
-/* Dont run handlers when first register/ last unregister in progress*/
-#define UPROBE_RUN_HANDLER	0x2
-/* Can skip singlestep */
-#define UPROBE_SKIP_SSTEP	0x4
-
 struct uprobe_consumer {
 	int (*handler)(struct uprobe_consumer *self, struct pt_regs *regs);
 	/*
@@ -59,7 +49,6 @@ struct uprobe_consumer {
 #ifdef CONFIG_UPROBES
 enum uprobe_task_state {
 	UTASK_RUNNING,
-	UTASK_BP_HIT,
 	UTASK_SSTEP,
 	UTASK_SSTEP_ACK,
 	UTASK_SSTEP_TRAPPED,
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 98256bc..5cc4e7e 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -78,15 +78,23 @@ static struct mutex uprobes_mmap_mutex[UPROBES_HASH_SZ];
  */
 static atomic_t uprobe_events = ATOMIC_INIT(0);
 
+/* Have a copy of original instruction */
+#define UPROBE_COPY_INSN	0
+/* Dont run handlers when first register/ last unregister in progress*/
+#define UPROBE_RUN_HANDLER	1
+/* Can skip singlestep */
+#define UPROBE_SKIP_SSTEP	2
+
 struct uprobe {
 	struct rb_node		rb_node;	/* node in the rb tree */
 	atomic_t		ref;
 	struct rw_semaphore	consumer_rwsem;
+	struct mutex		copy_mutex;	/* TODO: kill me and UPROBE_COPY_INSN */
 	struct list_head	pending_list;
 	struct uprobe_consumer	*consumers;
 	struct inode		*inode;		/* Also hold a ref to inode */
 	loff_t			offset;
-	int			flags;
+	unsigned long		flags;
 	struct arch_uprobe	arch;
 };
 
@@ -100,17 +108,12 @@ struct uprobe {
  */
 static bool valid_vma(struct vm_area_struct *vma, bool is_register)
 {
-	if (!vma->vm_file)
-		return false;
-
-	if (!is_register)
-		return true;
+	vm_flags_t flags = VM_HUGETLB | VM_MAYEXEC | VM_SHARED;
 
-	if ((vma->vm_flags & (VM_HUGETLB|VM_READ|VM_WRITE|VM_EXEC|VM_SHARED))
-				== (VM_READ|VM_EXEC))
-		return true;
+	if (is_register)
+		flags |= VM_WRITE;
 
-	return false;
+	return vma->vm_file && (vma->vm_flags & flags) == VM_MAYEXEC;
 }
 
 static unsigned long offset_to_vaddr(struct vm_area_struct *vma, loff_t offset)
@@ -193,19 +196,44 @@ bool __weak is_swbp_insn(uprobe_opcode_t *insn)
 	return *insn == UPROBE_SWBP_INSN;
 }
 
+static void copy_opcode(struct page *page, unsigned long vaddr, uprobe_opcode_t *opcode)
+{
+	void *kaddr = kmap_atomic(page);
+	memcpy(opcode, kaddr + (vaddr & ~PAGE_MASK), UPROBE_SWBP_INSN_SIZE);
+	kunmap_atomic(kaddr);
+}
+
+static int verify_opcode(struct page *page, unsigned long vaddr, uprobe_opcode_t *new_opcode)
+{
+	uprobe_opcode_t old_opcode;
+	bool is_swbp;
+
+	copy_opcode(page, vaddr, &old_opcode);
+	is_swbp = is_swbp_insn(&old_opcode);
+
+	if (is_swbp_insn(new_opcode)) {
+		if (is_swbp)		/* register: already installed? */
+			return 0;
+	} else {
+		if (!is_swbp)		/* unregister: was it changed by us? */
+			return 0;
+	}
+
+	return 1;
+}
+
 /*
  * NOTE:
  * Expect the breakpoint instruction to be the smallest size instruction for
  * the architecture. If an arch has variable length instruction and the
  * breakpoint instruction is not of the smallest length instruction
- * supported by that architecture then we need to modify read_opcode /
+ * supported by that architecture then we need to modify is_swbp_at_addr and
  * write_opcode accordingly. This would never be a problem for archs that
  * have fixed length instructions.
  */
 
 /*
  * write_opcode - write the opcode at a given virtual address.
- * @auprobe: arch breakpointing information.
  * @mm: the probed process address space.
  * @vaddr: the virtual address to store the opcode.
  * @opcode: opcode to be written at @vaddr.
@@ -216,8 +244,8 @@ bool __weak is_swbp_insn(uprobe_opcode_t *insn)
  * For mm @mm, write the opcode at @vaddr.
  * Return 0 (success) or a negative errno.
  */
-static int write_opcode(struct arch_uprobe *auprobe, struct mm_struct *mm,
-			unsigned long vaddr, uprobe_opcode_t opcode)
+static int write_opcode(struct mm_struct *mm, unsigned long vaddr,
+			uprobe_opcode_t opcode)
 {
 	struct page *old_page, *new_page;
 	void *vaddr_old, *vaddr_new;
@@ -226,10 +254,14 @@ static int write_opcode(struct arch_uprobe *auprobe, struct mm_struct *mm,
 
 retry:
 	/* Read the page with vaddr into memory */
-	ret = get_user_pages(NULL, mm, vaddr, 1, 0, 0, &old_page, &vma);
+	ret = get_user_pages(NULL, mm, vaddr, 1, 0, 1, &old_page, &vma);
 	if (ret <= 0)
 		return ret;
 
+	ret = verify_opcode(old_page, vaddr, &opcode);
+	if (ret <= 0)
+		goto put_old;
+
 	ret = -ENOMEM;
 	new_page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma, vaddr);
 	if (!new_page)
@@ -264,63 +296,6 @@ put_old:
 }
 
 /**
- * read_opcode - read the opcode at a given virtual address.
- * @mm: the probed process address space.
- * @vaddr: the virtual address to read the opcode.
- * @opcode: location to store the read opcode.
- *
- * Called with mm->mmap_sem held (for read and with a reference to
- * mm.
- *
- * For mm @mm, read the opcode at @vaddr and store it in @opcode.
- * Return 0 (success) or a negative errno.
- */
-static int read_opcode(struct mm_struct *mm, unsigned long vaddr, uprobe_opcode_t *opcode)
-{
-	struct page *page;
-	void *vaddr_new;
-	int ret;
-
-	ret = get_user_pages(NULL, mm, vaddr, 1, 0, 1, &page, NULL);
-	if (ret <= 0)
-		return ret;
-
-	vaddr_new = kmap_atomic(page);
-	vaddr &= ~PAGE_MASK;
-	memcpy(opcode, vaddr_new + vaddr, UPROBE_SWBP_INSN_SIZE);
-	kunmap_atomic(vaddr_new);
-
-	put_page(page);
-
-	return 0;
-}
-
-static int is_swbp_at_addr(struct mm_struct *mm, unsigned long vaddr)
-{
-	uprobe_opcode_t opcode;
-	int result;
-
-	if (current->mm == mm) {
-		pagefault_disable();
-		result = __copy_from_user_inatomic(&opcode, (void __user*)vaddr,
-								sizeof(opcode));
-		pagefault_enable();
-
-		if (likely(result == 0))
-			goto out;
-	}
-
-	result = read_opcode(mm, vaddr, &opcode);
-	if (result)
-		return result;
-out:
-	if (is_swbp_insn(&opcode))
-		return 1;
-
-	return 0;
-}
-
-/**
  * set_swbp - store breakpoint at a given address.
  * @auprobe: arch specific probepoint information.
  * @mm: the probed process address space.
@@ -331,18 +306,7 @@ out:
  */
 int __weak set_swbp(struct arch_uprobe *auprobe, struct mm_struct *mm, unsigned long vaddr)
 {
-	int result;
-	/*
-	 * See the comment near uprobes_hash().
-	 */
-	result = is_swbp_at_addr(mm, vaddr);
-	if (result == 1)
-		return 0;
-
-	if (result)
-		return result;
-
-	return write_opcode(auprobe, mm, vaddr, UPROBE_SWBP_INSN);
+	return write_opcode(mm, vaddr, UPROBE_SWBP_INSN);
 }
 
 /**
@@ -357,16 +321,7 @@ int __weak set_swbp(struct arch_uprobe *auprobe, struct mm_struct *mm, unsigned
 int __weak
 set_orig_insn(struct arch_uprobe *auprobe, struct mm_struct *mm, unsigned long vaddr)
 {
-	int result;
-
-	result = is_swbp_at_addr(mm, vaddr);
-	if (!result)
-		return -EINVAL;
-
-	if (result != 1)
-		return result;
-
-	return write_opcode(auprobe, mm, vaddr, *(uprobe_opcode_t *)auprobe->insn);
+	return write_opcode(mm, vaddr, *(uprobe_opcode_t *)auprobe->insn);
 }
 
 static int match_uprobe(struct uprobe *l, struct uprobe *r)
@@ -473,7 +428,7 @@ static struct uprobe *insert_uprobe(struct uprobe *uprobe)
 	spin_unlock(&uprobes_treelock);
 
 	/* For now assume that the instruction need not be single-stepped */
-	uprobe->flags |= UPROBE_SKIP_SSTEP;
+	__set_bit(UPROBE_SKIP_SSTEP, &uprobe->flags);
 
 	return u;
 }
@@ -495,6 +450,7 @@ static struct uprobe *alloc_uprobe(struct inode *inode, loff_t offset)
 	uprobe->inode = igrab(inode);
 	uprobe->offset = offset;
 	init_rwsem(&uprobe->consumer_rwsem);
+	mutex_init(&uprobe->copy_mutex);
 
 	/* add to uprobes_tree, sorted on inode:offset */
 	cur_uprobe = insert_uprobe(uprobe);
@@ -515,7 +471,7 @@ static void handler_chain(struct uprobe *uprobe, struct pt_regs *regs)
 {
 	struct uprobe_consumer *uc;
 
-	if (!(uprobe->flags & UPROBE_RUN_HANDLER))
+	if (!test_bit(UPROBE_RUN_HANDLER, &uprobe->flags))
 		return;
 
 	down_read(&uprobe->consumer_rwsem);
@@ -621,29 +577,43 @@ static int copy_insn(struct uprobe *uprobe, struct file *filp)
 	return __copy_insn(mapping, filp, uprobe->arch.insn, bytes, uprobe->offset);
 }
 
-/*
- * How mm->uprobes_state.count gets updated
- * uprobe_mmap() increments the count if
- * 	- it successfully adds a breakpoint.
- * 	- it cannot add a breakpoint, but sees that there is a underlying
- * 	  breakpoint (via a is_swbp_at_addr()).
- *
- * uprobe_munmap() decrements the count if
- * 	- it sees a underlying breakpoint, (via is_swbp_at_addr)
- * 	  (Subsequent uprobe_unregister wouldnt find the breakpoint
- * 	  unless a uprobe_mmap kicks in, since the old vma would be
- * 	  dropped just after uprobe_munmap.)
- *
- * uprobe_register increments the count if:
- * 	- it successfully adds a breakpoint.
- *
- * uprobe_unregister decrements the count if:
- * 	- it sees a underlying breakpoint and removes successfully.
- * 	  (via is_swbp_at_addr)
- * 	  (Subsequent uprobe_munmap wouldnt find the breakpoint
- * 	  since there is no underlying breakpoint after the
- * 	  breakpoint removal.)
- */
+static int prepare_uprobe(struct uprobe *uprobe, struct file *file,
+				struct mm_struct *mm, unsigned long vaddr)
+{
+	int ret = 0;
+
+	if (test_bit(UPROBE_COPY_INSN, &uprobe->flags))
+		return ret;
+
+	mutex_lock(&uprobe->copy_mutex);
+	if (test_bit(UPROBE_COPY_INSN, &uprobe->flags))
+		goto out;
+
+	ret = copy_insn(uprobe, file);
+	if (ret)
+		goto out;
+
+	ret = -ENOTSUPP;
+	if (is_swbp_insn((uprobe_opcode_t *)uprobe->arch.insn))
+		goto out;
+
+	ret = arch_uprobe_analyze_insn(&uprobe->arch, mm, vaddr);
+	if (ret)
+		goto out;
+
+	/* write_opcode() assumes we don't cross page boundary */
+	BUG_ON((uprobe->offset & ~PAGE_MASK) +
+			UPROBE_SWBP_INSN_SIZE > PAGE_SIZE);
+
+	smp_wmb(); /* pairs with rmb() in find_active_uprobe() */
+	set_bit(UPROBE_COPY_INSN, &uprobe->flags);
+
+ out:
+	mutex_unlock(&uprobe->copy_mutex);
+
+	return ret;
+}
+
 static int
 install_breakpoint(struct uprobe *uprobe, struct mm_struct *mm,
 			struct vm_area_struct *vma, unsigned long vaddr)
@@ -661,24 +631,9 @@ install_breakpoint(struct uprobe *uprobe, struct mm_struct *mm,
 	if (!uprobe->consumers)
 		return 0;
 
-	if (!(uprobe->flags & UPROBE_COPY_INSN)) {
-		ret = copy_insn(uprobe, vma->vm_file);
-		if (ret)
-			return ret;
-
-		if (is_swbp_insn((uprobe_opcode_t *)uprobe->arch.insn))
-			return -ENOTSUPP;
-
-		ret = arch_uprobe_analyze_insn(&uprobe->arch, mm, vaddr);
-		if (ret)
-			return ret;
-
-		/* write_opcode() assumes we don't cross page boundary */
-		BUG_ON((uprobe->offset & ~PAGE_MASK) +
-				UPROBE_SWBP_INSN_SIZE > PAGE_SIZE);
-
-		uprobe->flags |= UPROBE_COPY_INSN;
-	}
+	ret = prepare_uprobe(uprobe, vma->vm_file, mm, vaddr);
+	if (ret)
+		return ret;
 
 	/*
 	 * set MMF_HAS_UPROBES in advance for uprobe_pre_sstep_notifier(),
@@ -697,15 +652,15 @@ install_breakpoint(struct uprobe *uprobe, struct mm_struct *mm,
 	return ret;
 }
 
-static void
+static int
 remove_breakpoint(struct uprobe *uprobe, struct mm_struct *mm, unsigned long vaddr)
 {
 	/* can happen if uprobe_register() fails */
 	if (!test_bit(MMF_HAS_UPROBES, &mm->flags))
-		return;
+		return 0;
 
 	set_bit(MMF_RECALC_UPROBES, &mm->flags);
-	set_orig_insn(&uprobe->arch, mm, vaddr);
+	return set_orig_insn(&uprobe->arch, mm, vaddr);
 }
 
 /*
@@ -820,7 +775,7 @@ static int register_for_each_vma(struct uprobe *uprobe, bool is_register)
 		struct mm_struct *mm = info->mm;
 		struct vm_area_struct *vma;
 
-		if (err)
+		if (err && is_register)
 			goto free;
 
 		down_write(&mm->mmap_sem);
@@ -836,7 +791,7 @@ static int register_for_each_vma(struct uprobe *uprobe, bool is_register)
 		if (is_register)
 			err = install_breakpoint(uprobe, mm, vma, info->vaddr);
 		else
-			remove_breakpoint(uprobe, mm, info->vaddr);
+			err |= remove_breakpoint(uprobe, mm, info->vaddr);
 
  unlock:
 		up_write(&mm->mmap_sem);
@@ -893,13 +848,15 @@ int uprobe_register(struct inode *inode, loff_t offset, struct uprobe_consumer *
 	mutex_lock(uprobes_hash(inode));
 	uprobe = alloc_uprobe(inode, offset);
 
-	if (uprobe && !consumer_add(uprobe, uc)) {
+	if (!uprobe) {
+		ret = -ENOMEM;
+	} else if (!consumer_add(uprobe, uc)) {
 		ret = __uprobe_register(uprobe);
 		if (ret) {
 			uprobe->consumers = NULL;
 			__uprobe_unregister(uprobe);
 		} else {
-			uprobe->flags |= UPROBE_RUN_HANDLER;
+			set_bit(UPROBE_RUN_HANDLER, &uprobe->flags);
 		}
 	}
 
@@ -932,7 +889,7 @@ void uprobe_unregister(struct inode *inode, loff_t offset, struct uprobe_consume
 	if (consumer_del(uprobe, uc)) {
 		if (!uprobe->consumers) {
 			__uprobe_unregister(uprobe);
-			uprobe->flags &= ~UPROBE_RUN_HANDLER;
+			clear_bit(UPROBE_RUN_HANDLER, &uprobe->flags);
 		}
 	}
 
@@ -1393,10 +1350,11 @@ bool uprobe_deny_signal(void)
  */
 static bool can_skip_sstep(struct uprobe *uprobe, struct pt_regs *regs)
 {
-	if (arch_uprobe_skip_sstep(&uprobe->arch, regs))
-		return true;
-
-	uprobe->flags &= ~UPROBE_SKIP_SSTEP;
+	if (test_bit(UPROBE_SKIP_SSTEP, &uprobe->flags)) {
+		if (arch_uprobe_skip_sstep(&uprobe->arch, regs))
+			return true;
+		clear_bit(UPROBE_SKIP_SSTEP, &uprobe->flags);
+	}
 	return false;
 }
 
@@ -1419,6 +1377,30 @@ static void mmf_recalc_uprobes(struct mm_struct *mm)
 	clear_bit(MMF_HAS_UPROBES, &mm->flags);
 }
 
+static int is_swbp_at_addr(struct mm_struct *mm, unsigned long vaddr)
+{
+	struct page *page;
+	uprobe_opcode_t opcode;
+	int result;
+
+	pagefault_disable();
+	result = __copy_from_user_inatomic(&opcode, (void __user*)vaddr,
+							sizeof(opcode));
+	pagefault_enable();
+
+	if (likely(result == 0))
+		goto out;
+
+	result = get_user_pages(NULL, mm, vaddr, 1, 0, 1, &page, NULL);
+	if (result < 0)
+		return result;
+
+	copy_opcode(page, vaddr, &opcode);
+	put_page(page);
+ out:
+	return is_swbp_insn(&opcode);
+}
+
 static struct uprobe *find_active_uprobe(unsigned long bp_vaddr, int *is_swbp)
 {
 	struct mm_struct *mm = current->mm;
@@ -1489,38 +1471,41 @@ static void handle_swbp(struct pt_regs *regs)
 		}
 		return;
 	}
+	/*
+	 * TODO: move copy_insn/etc into _register and remove this hack.
+	 * After we hit the bp, _unregister + _register can install the
+	 * new and not-yet-analyzed uprobe at the same address, restart.
+	 */
+	smp_rmb(); /* pairs with wmb() in install_breakpoint() */
+	if (unlikely(!test_bit(UPROBE_COPY_INSN, &uprobe->flags)))
+		goto restart;
 
 	utask = current->utask;
 	if (!utask) {
 		utask = add_utask();
 		/* Cannot allocate; re-execute the instruction. */
 		if (!utask)
-			goto cleanup_ret;
+			goto restart;
 	}
-	utask->active_uprobe = uprobe;
+
 	handler_chain(uprobe, regs);
-	if (uprobe->flags & UPROBE_SKIP_SSTEP && can_skip_sstep(uprobe, regs))
-		goto cleanup_ret;
+	if (can_skip_sstep(uprobe, regs))
+		goto out;
 
-	utask->state = UTASK_SSTEP;
 	if (!pre_ssout(uprobe, regs, bp_vaddr)) {
 		arch_uprobe_enable_step(&uprobe->arch);
+		utask->active_uprobe = uprobe;
+		utask->state = UTASK_SSTEP;
 		return;
 	}
 
-cleanup_ret:
-	if (utask) {
-		utask->active_uprobe = NULL;
-		utask->state = UTASK_RUNNING;
-	}
-	if (!(uprobe->flags & UPROBE_SKIP_SSTEP))
-
-		/*
-		 * cannot singlestep; cannot skip instruction;
-		 * re-execute the instruction.
-		 */
-		instruction_pointer_set(regs, bp_vaddr);
-
+restart:
+	/*
+	 * cannot singlestep; cannot skip instruction;
+	 * re-execute the instruction.
+	 */
+	instruction_pointer_set(regs, bp_vaddr);
+out:
 	put_uprobe(uprobe);
 }
 
@@ -1552,13 +1537,12 @@ static void handle_singlestep(struct uprobe_task *utask, struct pt_regs *regs)
 }
 
 /*
- * On breakpoint hit, breakpoint notifier sets the TIF_UPROBE flag.  (and on
- * subsequent probe hits on the thread sets the state to UTASK_BP_HIT) and
- * allows the thread to return from interrupt.
+ * On breakpoint hit, breakpoint notifier sets the TIF_UPROBE flag and
+ * allows the thread to return from interrupt. After that handle_swbp()
+ * sets utask->active_uprobe.
  *
- * On singlestep exception, singlestep notifier sets the TIF_UPROBE flag and
- * also sets the state to UTASK_SSTEP_ACK and allows the thread to return from
- * interrupt.
+ * On singlestep exception, singlestep notifier sets the TIF_UPROBE flag
+ * and allows the thread to return from interrupt.
  *
  * While returning to userspace, thread notices the TIF_UPROBE flag and calls
  * uprobe_notify_resume().
@@ -1567,11 +1551,13 @@ void uprobe_notify_resume(struct pt_regs *regs)
 {
 	struct uprobe_task *utask;
 
+	clear_thread_flag(TIF_UPROBE);
+
 	utask = current->utask;
-	if (!utask || utask->state == UTASK_BP_HIT)
-		handle_swbp(regs);
-	else
+	if (utask && utask->active_uprobe)
 		handle_singlestep(utask, regs);
+	else
+		handle_swbp(regs);
 }
 
 /*
@@ -1580,17 +1566,10 @@ void uprobe_notify_resume(struct pt_regs *regs)
  */
 int uprobe_pre_sstep_notifier(struct pt_regs *regs)
 {
-	struct uprobe_task *utask;
-
 	if (!current->mm || !test_bit(MMF_HAS_UPROBES, &current->mm->flags))
 		return 0;
 
-	utask = current->utask;
-	if (utask)
-		utask->state = UTASK_BP_HIT;
-
 	set_thread_flag(TIF_UPROBE);
-
 	return 1;
 }
 
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index b32ed0e..b979426 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1567,6 +1567,10 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size,
 
 		put_online_cpus();
 	} else {
+		/* Make sure this CPU has been intitialized */
+		if (!cpumask_test_cpu(cpu_id, buffer->cpumask))
+			goto out;
+
 		cpu_buffer = buffer->buffers[cpu_id];
 
 		if (nr_pages == cpu_buffer->nr_pages)

