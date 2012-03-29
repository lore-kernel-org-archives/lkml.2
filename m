Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936742Ab2C3W7K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 18:59:10 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:41825 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934885Ab2C3VFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:05:31 -0400
Message-Id: <201203302105.q2UL53MX006283@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Thu, 29 Mar 2012 14:06:14 -0400
Subject: [PATCH] arch/tile: various improvements to stack backtracer
In-Reply-To: <4F761E1C.80808.com>
References: <4F761E1C.80808.com>
To: Chris Metcalf <cmetcalf@tilera.com>, linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 30 Mar 2012 21:05:04.0069 (UTC) FILETIME=[C7190750:01CD0EB8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a long-standing bug in the stack backtracer where we would print
garbage to the console instead of kernel function names, if the kernel
wasn't built with symbol support (e.g. mboot).

Make sure to tag every line of userspace backtrace output if we actually
have the mmap_sem, since that way if there's no tag, we know that it's
because we couldn't trylock the semaphore.

Stop doing a TLB flush and examining page tables during backtrace.
Instead, just trust that __copy_from_user_inatomic() will properly fault
and return a failure, which it should do in all cases.

Fix a latent bug where the backtracer would directly examine a signal
context in user space, rather than copying it safely to kernel memory
first.  This meant that a race with another thread could potentially
have caused a kernel panic.

Guard against unaligned sp when trying to restart backtrace at an
interrupt or signal handler point in the kernel backtracer.

Report kernel symbolic information for the call instruction rather
than for the following instruction.  We still report the actual numeric
address corresponding to the instruction after the call, for the sake
of consistency with the normal expectations for stack backtracers.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/stack.h |    1 -
 arch/tile/kernel/stack.c      |  230 ++++++++++++++++++++---------------------
 2 files changed, 112 insertions(+), 119 deletions(-)

diff --git a/arch/tile/include/asm/stack.h b/arch/tile/include/asm/stack.h
index 4d97a2d..0e9d382 100644
--- a/arch/tile/include/asm/stack.h
+++ b/arch/tile/include/asm/stack.h
@@ -25,7 +25,6 @@
 struct KBacktraceIterator {
 	BacktraceIterator it;
 	struct task_struct *task;     /* task we are backtracing */
-	pte_t *pgtable;		      /* page table for user space access */
 	int end;		      /* iteration complete. */
 	int new_context;              /* new context is starting */
 	int profile;                  /* profiling, so stop on async intrpt */
diff --git a/arch/tile/kernel/stack.c b/arch/tile/kernel/stack.c
index 9016d1c..1ab6377 100644
--- a/arch/tile/kernel/stack.c
+++ b/arch/tile/kernel/stack.c
@@ -21,9 +21,10 @@
 #include <linux/stacktrace.h>
 #include <linux/uaccess.h>
 #include <linux/mmzone.h>
+#include <linux/dcache.h>
+#include <linux/fs.h>
 #include <asm/backtrace.h>
 #include <asm/page.h>
-#include <asm/tlbflush.h>
 #include <asm/ucontext.h>
 #include <asm/sigframe.h>
 #include <asm/stack.h>
@@ -44,71 +45,23 @@ static int in_kernel_stack(struct KBacktraceIterator *kbt, unsigned long sp)
 	return sp >= kstack_base && sp < kstack_base + THREAD_SIZE;
 }
 
-/* Is address valid for reading? */
-static int valid_address(struct KBacktraceIterator *kbt, unsigned long address)
-{
-	HV_PTE *l1_pgtable = kbt->pgtable;
-	HV_PTE *l2_pgtable;
-	unsigned long pfn;
-	HV_PTE pte;
-	struct page *page;
-
-	if (l1_pgtable == NULL)
-		return 0;	/* can't read user space in other tasks */
-
-	pte = l1_pgtable[PGD_INDEX(address)];
-#ifdef CONFIG_64BIT
-	/* Find the real l1_pgtable by looking in the l0_pgtable. */
-	if (!hv_pte_get_present(pte))
-		return 0;
-	pfn = pte_pfn(pte);
-	if (pte_huge(pte)) {
-		if (!pfn_valid(pfn)) {
-			pr_err("L0 huge page has bad pfn %#lx\n", pfn);
-			return 0;
-		}
-		return hv_pte_get_present(pte) && hv_pte_get_readable(pte);
-	}
-	page = pfn_to_page(pfn);
-	BUG_ON(PageHighMem(page));  /* No HIGHMEM on 64-bit. */
-	l1_pgtable = (HV_PTE *)pfn_to_kaddr(pfn);
-	pte = l1_pgtable[PMD_INDEX(address)];
-#endif
-	if (!hv_pte_get_present(pte))
-		return 0;
-	pfn = pte_pfn(pte);
-	if (pte_huge(pte)) {
-		if (!pfn_valid(pfn)) {
-			pr_err("huge page has bad pfn %#lx\n", pfn);
-			return 0;
-		}
-		return hv_pte_get_present(pte) && hv_pte_get_readable(pte);
-	}
-
-	page = pfn_to_page(pfn);
-	if (PageHighMem(page)) {
-		pr_err("L2 page table not in LOWMEM (%#llx)\n", PFN_PHYS(pfn));
-		return 0;
-	}
-	l2_pgtable = (HV_PTE *)pfn_to_kaddr(pfn);
-	pte = l2_pgtable[PTE_INDEX(address)];
-	return hv_pte_get_present(pte) && hv_pte_get_readable(pte);
-}
-
 /* Callback for backtracer; basically a glorified memcpy */
 static bool read_memory_func(void *result, unsigned long address,
 			     unsigned int size, void *vkbt)
 {
 	int retval;
 	struct KBacktraceIterator *kbt = (struct KBacktraceIterator *)vkbt;
+
+	if (address == 0)
+		return 0;
 	if (__kernel_text_address(address)) {
 		/* OK to read kernel code. */
 	} else if (address >= PAGE_OFFSET) {
 		/* We only tolerate kernel-space reads of this task's stack */
 		if (!in_kernel_stack(kbt, address))
 			return 0;
-	} else if (!valid_address(kbt, address)) {
-		return 0;	/* invalid user-space address */
+	} else if (!kbt->is_current) {
+		return 0;	/* can't read from other user address spaces */
 	}
 	pagefault_disable();
 	retval = __copy_from_user_inatomic(result,
@@ -126,6 +79,8 @@ static struct pt_regs *valid_fault_handler(struct KBacktraceIterator* kbt)
 	unsigned long sp = kbt->it.sp;
 	struct pt_regs *p;
 
+	if (sp % sizeof(long) != 0)
+		return NULL;
 	if (!in_kernel_stack(kbt, sp))
 		return NULL;
 	if (!in_kernel_stack(kbt, sp + C_ABI_SAVE_AREA_SIZE + PTREGS_SIZE-1))
@@ -168,27 +123,27 @@ static int is_sigreturn(unsigned long pc)
 }
 
 /* Return a pt_regs pointer for a valid signal handler frame */
-static struct pt_regs *valid_sigframe(struct KBacktraceIterator* kbt)
+static struct pt_regs *valid_sigframe(struct KBacktraceIterator* kbt,
+				      struct rt_sigframe* kframe)
 {
 	BacktraceIterator *b = &kbt->it;
 
-	if (b->pc == VDSO_BASE) {
-		struct rt_sigframe *frame;
-		unsigned long sigframe_top =
-			b->sp + sizeof(struct rt_sigframe) - 1;
-		if (!valid_address(kbt, b->sp) ||
-		    !valid_address(kbt, sigframe_top)) {
-			if (kbt->verbose)
-				pr_err("  (odd signal: sp %#lx?)\n",
-				       (unsigned long)(b->sp));
+	if (b->pc == VDSO_BASE && b->sp < PAGE_OFFSET &&
+	    b->sp % sizeof(long) == 0) {
+		int retval;
+		pagefault_disable();
+		retval = __copy_from_user_inatomic(
+			kframe, (void __user __force *)b->sp,
+			sizeof(*kframe));
+		pagefault_enable();
+		if (retval != 0 ||
+		    (unsigned int)(kframe->info.si_signo) >= _NSIG)
 			return NULL;
-		}
-		frame = (struct rt_sigframe *)b->sp;
 		if (kbt->verbose) {
 			pr_err("  <received signal %d>\n",
-			       frame->info.si_signo);
+			       kframe->info.si_signo);
 		}
-		return (struct pt_regs *)&frame->uc.uc_mcontext;
+		return (struct pt_regs *)&kframe->uc.uc_mcontext;
 	}
 	return NULL;
 }
@@ -201,10 +156,11 @@ static int KBacktraceIterator_is_sigreturn(struct KBacktraceIterator *kbt)
 static int KBacktraceIterator_restart(struct KBacktraceIterator *kbt)
 {
 	struct pt_regs *p;
+	struct rt_sigframe kframe;
 
 	p = valid_fault_handler(kbt);
 	if (p == NULL)
-		p = valid_sigframe(kbt);
+		p = valid_sigframe(kbt, &kframe);
 	if (p == NULL)
 		return 0;
 	backtrace_init(&kbt->it, read_memory_func, kbt,
@@ -264,41 +220,19 @@ void KBacktraceIterator_init(struct KBacktraceIterator *kbt,
 
 	/*
 	 * Set up callback information.  We grab the kernel stack base
-	 * so we will allow reads of that address range, and if we're
-	 * asking about the current process we grab the page table
-	 * so we can check user accesses before trying to read them.
-	 * We flush the TLB to avoid any weird skew issues.
+	 * so we will allow reads of that address range.
 	 */
-	is_current = (t == NULL);
+	is_current = (t == NULL || t == current);
 	kbt->is_current = is_current;
 	if (is_current)
 		t = validate_current();
 	kbt->task = t;
-	kbt->pgtable = NULL;
 	kbt->verbose = 0;   /* override in caller if desired */
 	kbt->profile = 0;   /* override in caller if desired */
 	kbt->end = KBT_ONGOING;
-	kbt->new_context = 0;
-	if (is_current) {
-		HV_PhysAddr pgdir_pa = hv_inquire_context().page_table;
-		if (pgdir_pa == (unsigned long)swapper_pg_dir - PAGE_OFFSET) {
-			/*
-			 * Not just an optimization: this also allows
-			 * this to work at all before va/pa mappings
-			 * are set up.
-			 */
-			kbt->pgtable = swapper_pg_dir;
-		} else {
-			struct page *page = pfn_to_page(PFN_DOWN(pgdir_pa));
-			if (!PageHighMem(page))
-				kbt->pgtable = __va(pgdir_pa);
-			else
-				pr_err("page table not in LOWMEM"
-				       " (%#llx)\n", pgdir_pa);
-		}
-		local_flush_tlb_all();
+	kbt->new_context = 1;
+	if (is_current)
 		validate_stack(regs);
-	}
 
 	if (regs == NULL) {
 		if (is_current || t->state == TASK_RUNNING) {
@@ -344,6 +278,78 @@ void KBacktraceIterator_next(struct KBacktraceIterator *kbt)
 }
 EXPORT_SYMBOL(KBacktraceIterator_next);
 
+static void describe_addr(struct KBacktraceIterator *kbt,
+			  unsigned long address,
+			  int have_mmap_sem, char *buf, size_t bufsize)
+{
+	struct vm_area_struct *vma;
+	size_t namelen, remaining;
+	unsigned long size, offset, adjust;
+	char *p, *modname;
+	const char *name;
+	int rc;
+
+	/*
+	 * Look one byte back for every caller frame (i.e. those that
+	 * aren't a new context) so we look up symbol data for the
+	 * call itself, not the following instruction, which may be on
+	 * a different line (or in a different function).
+	 */
+	adjust = !kbt->new_context;
+	address -= adjust;
+
+	if (address >= PAGE_OFFSET) {
+		/* Handle kernel symbols. */
+		BUG_ON(bufsize < KSYM_NAME_LEN);
+		name = kallsyms_lookup(address, &size, &offset,
+				       &modname, buf);
+		if (name == NULL) {
+			buf[0] = '\0';
+			return;
+		}
+		namelen = strlen(buf);
+		remaining = (bufsize - 1) - namelen;
+		p = buf + namelen;
+		rc = snprintf(p, remaining, "+%#lx/%#lx ",
+			      offset + adjust, size);
+		if (modname && rc < remaining)
+			snprintf(p + rc, remaining - rc, "[%s] ", modname);
+		buf[bufsize-1] = '\0';
+		return;
+	}
+
+	/* If we don't have the mmap_sem, we can't show any more info. */
+	buf[0] = '\0';
+	if (!have_mmap_sem)
+		return;
+
+	/* Find vma info. */
+	vma = find_vma(kbt->task->mm, address);
+	if (vma == NULL || address < vma->vm_start) {
+		snprintf(buf, bufsize, "[unmapped address] ");
+		return;
+	}
+
+	if (vma->vm_file) {
+		char *s;
+		p = d_path(&vma->vm_file->f_path, buf, bufsize);
+		if (IS_ERR(p))
+			p = "?";
+		s = strrchr(p, '/');
+		if (s)
+			p = s+1;
+	} else {
+		p = "anon";
+	}
+
+	/* Generate a string description of the vma info. */
+	namelen = strlen(p);
+	remaining = (bufsize - 1) - namelen;
+	memmove(buf, p, namelen);
+	snprintf(buf + namelen, remaining, "[%lx+%lx] ",
+		 vma->vm_start, vma->vm_end - vma->vm_start);
+}
+
 /*
  * This method wraps the backtracer's more generic support.
  * It is only invoked from the architecture-specific code; show_stack()
@@ -352,6 +358,7 @@ EXPORT_SYMBOL(KBacktraceIterator_next);
 void tile_show_stack(struct KBacktraceIterator *kbt, int headers)
 {
 	int i;
+	int have_mmap_sem = 0;
 
 	if (headers) {
 		/*
@@ -368,31 +375,16 @@ void tile_show_stack(struct KBacktraceIterator *kbt, int headers)
 	kbt->verbose = 1;
 	i = 0;
 	for (; !KBacktraceIterator_end(kbt); KBacktraceIterator_next(kbt)) {
-		char *modname;
-		const char *name;
-		unsigned long address = kbt->it.pc;
-		unsigned long offset, size;
 		char namebuf[KSYM_NAME_LEN+100];
+		unsigned long address = kbt->it.pc;
 
-		if (address >= PAGE_OFFSET)
-			name = kallsyms_lookup(address, &size, &offset,
-					       &modname, namebuf);
-		else
-			name = NULL;
-
-		if (!name)
-			namebuf[0] = '\0';
-		else {
-			size_t namelen = strlen(namebuf);
-			size_t remaining = (sizeof(namebuf) - 1) - namelen;
-			char *p = namebuf + namelen;
-			int rc = snprintf(p, remaining, "+%#lx/%#lx ",
-					  offset, size);
-			if (modname && rc < remaining)
-				snprintf(p + rc, remaining - rc,
-					 "[%s] ", modname);
-			namebuf[sizeof(namebuf)-1] = '\0';
-		}
+		/* Try to acquire the mmap_sem as we pass into userspace. */
+		if (address < PAGE_OFFSET && !have_mmap_sem && kbt->task->mm)
+			have_mmap_sem =
+				down_read_trylock(&kbt->task->mm->mmap_sem);
+
+		describe_addr(kbt, address, have_mmap_sem,
+			      namebuf, sizeof(namebuf));
 
 		pr_err("  frame %d: 0x%lx %s(sp 0x%lx)\n",
 		       i++, address, namebuf, (unsigned long)(kbt->it.sp));
@@ -407,6 +399,8 @@ void tile_show_stack(struct KBacktraceIterator *kbt, int headers)
 		pr_err("Stack dump stopped; next frame identical to this one\n");
 	if (headers)
 		pr_err("Stack dump complete\n");
+	if (have_mmap_sem)
+		up_read(&kbt->task->mm->mmap_sem);
 }
 EXPORT_SYMBOL(tile_show_stack);
 
-- 
1.6.5.2

