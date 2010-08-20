Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753765Ab0HTUsr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 16:48:47 -0400
Received: from kroah.org ([198.145.64.141]:37497 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751473Ab0HTUso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 16:48:44 -0400
Date: Fri, 20 Aug 2010 13:49:21 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org, lwn@lwn.net
Subject: Re: Linux 2.6.35.3
Message-ID: <20100820204921.GH14579@kroah.com>
References: <20100820204909.GG14579@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100820204909.GG14579@kroah.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index 3cf2397..554683d 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 35
-EXTRAVERSION = .2
+EXTRAVERSION = .3
 NAME = Sheep on Meth
 
 # *DOCUMENTATION*
diff --git a/arch/x86/kernel/cpu/vmware.c b/arch/x86/kernel/cpu/vmware.c
index 227b044..ce9c6c2 100644
--- a/arch/x86/kernel/cpu/vmware.c
+++ b/arch/x86/kernel/cpu/vmware.c
@@ -23,6 +23,7 @@
 
 #include <linux/dmi.h>
 #include <linux/module.h>
+#include <linux/jiffies.h>
 #include <asm/div64.h>
 #include <asm/x86_init.h>
 #include <asm/hypervisor.h>
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index aea1d3f..439fc1f 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -210,6 +210,7 @@ static void show_map_vma(struct seq_file *m, struct vm_area_struct *vma)
 	int flags = vma->vm_flags;
 	unsigned long ino = 0;
 	unsigned long long pgoff = 0;
+	unsigned long start;
 	dev_t dev = 0;
 	int len;
 
@@ -220,8 +221,13 @@ static void show_map_vma(struct seq_file *m, struct vm_area_struct *vma)
 		pgoff = ((loff_t)vma->vm_pgoff) << PAGE_SHIFT;
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
index aaaedbd..307bf77 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2792,24 +2792,23 @@ static int do_anonymous_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	spinlock_t *ptl;
 	pte_t entry;
 
-	if (check_stack_guard_page(vma, address) < 0) {
-		pte_unmap(page_table);
+	pte_unmap(page_table);
+
+	/* Check if we need to add a guard page to the stack */
+	if (check_stack_guard_page(vma, address) < 0)
 		return VM_FAULT_SIGBUS;
-	}
 
+	/* Use the zero-page for reads */
 	if (!(flags & FAULT_FLAG_WRITE)) {
 		entry = pte_mkspecial(pfn_pte(my_zero_pfn(address),
 						vma->vm_page_prot));
-		ptl = pte_lockptr(mm, pmd);
-		spin_lock(ptl);
+		page_table = pte_offset_map_lock(mm, pmd, address, &ptl);
 		if (!pte_none(*page_table))
 			goto unlock;
 		goto setpte;
 	}
 
 	/* Allocate our own private page. */
-	pte_unmap(page_table);
-
 	if (unlikely(anon_vma_prepare(vma)))
 		goto oom;
 	page = alloc_zeroed_user_highpage_movable(vma, address);
diff --git a/mm/mlock.c b/mm/mlock.c
index 3f82720..49e5e4c 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -167,6 +167,14 @@ static long __mlock_vma_pages_range(struct vm_area_struct *vma,
 	if (vma->vm_flags & VM_WRITE)
 		gup_flags |= FOLL_WRITE;
 
+	/* We don't try to access the guard page of a stack vma */
+	if (vma->vm_flags & VM_GROWSDOWN) {
+		if (start == vma->vm_start) {
+			start += PAGE_SIZE;
+			nr_pages--;
+		}
+	}
+
 	while (nr_pages > 0) {
 		int i;
 
