Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296Ab0HTUnY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 16:43:24 -0400
Received: from kroah.org ([198.145.64.141]:46794 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753176Ab0HTUnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 16:43:21 -0400
Date: Fri, 20 Aug 2010 13:43:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org, lwn@lwn.net
Subject: Re: Linux 2.6.27.52
Message-ID: <20100820204355.GB14579@kroah.com>
References: <20100820204324.GA14579@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100820204324.GA14579@kroah.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index 5382c55..948de60 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 27
-EXTRAVERSION = .51
+EXTRAVERSION = .52
 NAME = Trembling Tortoise
 
 # *DOCUMENTATION*
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 3384255..9d3c576 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -589,6 +589,7 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
 	unsigned long address;
 	int write, si_code;
 	int fault;
+	int should_exit_no_context = 0;
 #ifdef CONFIG_X86_64
 	unsigned long flags;
 #endif
@@ -876,6 +877,9 @@ no_context:
 	oops_end(flags, regs, SIGKILL);
 #endif
 
+	if (should_exit_no_context)
+		return;
+
 /*
  * We ran out of memory, or some other thing happened to us that made
  * us unable to handle the page fault gracefully.
@@ -901,8 +905,11 @@ do_sigbus:
 	up_read(&mm->mmap_sem);
 
 	/* Kernel mode? Handle exceptions or die */
-	if (!(error_code & PF_USER))
+	if (!(error_code & PF_USER)) {
+		should_exit_no_context = 1;
 		goto no_context;
+	}
+
 #ifdef CONFIG_X86_32
 	/* User space => ok to do another page fault */
 	if (is_prefetch(regs, address, error_code))
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index d8be92a..0325100 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -205,6 +205,7 @@ static void show_map_vma(struct seq_file *m, struct vm_area_struct *vma)
 	struct file *file = vma->vm_file;
 	int flags = vma->vm_flags;
 	unsigned long ino = 0;
+	unsigned long start;
 	dev_t dev = 0;
 	int len;
 
@@ -214,8 +215,13 @@ static void show_map_vma(struct seq_file *m, struct vm_area_struct *vma)
 		ino = inode->i_ino;
 	}
 
+	/* We don't show the stack guard page in /proc/maps */
+	start = vma->vm_start;
+	if (vma->vm_flags & VM_GROWSDOWN)
+		start += PAGE_SIZE;
+
 	seq_printf(m, "%08lx-%08lx %c%c%c%c %08llx %02x:%02x %lu %n",
-			vma->vm_start,
+			start,
 			vma->vm_end,
 			flags & VM_READ ? 'r' : '-',
 			flags & VM_WRITE ? 'w' : '-',
diff --git a/mm/memory.c b/mm/memory.c
index 1300b70f..f0282eb 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2396,6 +2396,26 @@ out_nomap:
 }
 
 /*
+ * This is like a special single-page "expand_downwards()",
+ * except we must first make sure that 'address-PAGE_SIZE'
+ * doesn't hit another vma.
+ *
+ * The "find_vma()" will do the right thing even if we wrap
+ */
+static inline int check_stack_guard_page(struct vm_area_struct *vma, unsigned long address)
+{
+	address &= PAGE_MASK;
+	if ((vma->vm_flags & VM_GROWSDOWN) && address == vma->vm_start) {
+		address -= PAGE_SIZE;
+		if (find_vma(vma->vm_mm, address) != vma)
+			return -ENOMEM;
+
+		expand_stack(vma, address);
+	}
+	return 0;
+}
+
+/*
  * We enter with non-exclusive mmap_sem (to exclude vma changes,
  * but allow concurrent faults), and pte mapped but not yet locked.
  * We return with mmap_sem still held, but pte unmapped and unlocked.
@@ -2408,9 +2428,13 @@ static int do_anonymous_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	spinlock_t *ptl;
 	pte_t entry;
 
-	/* Allocate our own private page. */
 	pte_unmap(page_table);
 
+	/* Check if we need to add a guard page to the stack */
+	if (check_stack_guard_page(vma, address) < 0)
+		return VM_FAULT_SIGBUS;
+
+	/* Allocate our own private page. */
 	if (unlikely(anon_vma_prepare(vma)))
 		goto oom;
 	page = alloc_zeroed_user_highpage_movable(vma, address);
diff --git a/mm/mmap.c b/mm/mmap.c
index f3e5bfe..08a32cf 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1573,7 +1573,7 @@ static int acct_stack_growth(struct vm_area_struct * vma, unsigned long size, un
 	 * Overcommit..  This must be the final test, as it will
 	 * update security statistics.
 	 */
-	if (security_vm_enough_memory(grow))
+	if (security_vm_enough_memory_mm(mm, grow))
 		return -ENOMEM;
 
 	/* Ok, everything looks good - let it rip */
