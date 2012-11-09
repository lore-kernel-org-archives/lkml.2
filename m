Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520Ab2KIEaz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 23:30:55 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:65144 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573Ab2KIEav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 23:30:51 -0500
Date: Thu, 8 Nov 2012 20:30:47 -0800
From: Michel Lespinasse <walken@google.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>
Subject: Re: linux-next: build warning after merge of the final tree (akpm
 tree related)
Message-ID: <20121109043047.GA17999@google.com>
References: <20121109151903.19728e9a7a8fe9e509bb523e@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121109151903.19728e9a7a8fe9e509bb523e@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 09, 2012 at 03:19:03PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the final tree, today's linux-next build (arm defconfig)
> produced this warning:
> 
> arch/arm/mm/mmap.c: In function 'arch_get_unmapped_area':
> arch/arm/mm/mmap.c:60:16: warning: unused variable 'start_addr' [-Wunused-variable]
> 
> Introduced by commit "mm: use vm_unmapped_area() on arm architecture".

Sorry for the mistakes. The following changes should fix what's been reported so far.

commit 1c98949798ce7a1d4a910775623e1830cf88a92c
Author: Michel Lespinasse <walken@google.com>
Date:   Thu Nov 8 20:26:34 2012 -0800

    fix mm: use vm_unmapped_area() on sparc32 architecture

diff --git a/arch/sparc/kernel/sys_sparc_32.c b/arch/sparc/kernel/sys_sparc_32.c
index a59bc637f9af..a20b5ab4c701 100644
--- a/arch/sparc/kernel/sys_sparc_32.c
+++ b/arch/sparc/kernel/sys_sparc_32.c
@@ -38,7 +38,6 @@ asmlinkage unsigned long sys_getpagesize(void)
 
 unsigned long arch_get_unmapped_area(struct file *filp, unsigned long addr, unsigned long len, unsigned long pgoff, unsigned long flags)
 {
-	struct vm_area_struct * vmm;
 	struct vm_unmapped_area_info info;
 
 	if (flags & MAP_FIXED) {

commit aa96ebbc9ec664ddafc841f7631c4a092b10c0d8
Author: Michel Lespinasse <walken@google.com>
Date:   Thu Nov 8 20:25:48 2012 -0800

    fix mm: use vm_unmapped_area() in hugetlbfs on sparc64 architecture

diff --git a/arch/sparc/mm/hugetlbpage.c b/arch/sparc/mm/hugetlbpage.c
index 42e5dba6cb26..d2b59441ebdd 100644
--- a/arch/sparc/mm/hugetlbpage.c
+++ b/arch/sparc/mm/hugetlbpage.c
@@ -60,7 +60,6 @@ hugetlb_get_unmapped_area_topdown(struct file *filp, const unsigned long addr0,
 				  const unsigned long pgoff,
 				  const unsigned long flags)
 {
-	struct vm_area_struct *vma;
 	struct mm_struct *mm = current->mm;
 	unsigned long addr = addr0;
 	struct vm_unmapped_area_info info;

commit ff4dd9742ce0a5f7c703013e70eeb84b845c8fa2
Author: Michel Lespinasse <walken@google.com>
Date:   Thu Nov 8 20:24:53 2012 -0800

    mm-use-vm_unmapped_area-on-sparc64-architecture-fix2

diff --git a/arch/sparc/kernel/sys_sparc_64.c b/arch/sparc/kernel/sys_sparc_64.c
index 2a5d61587ca2..a836ee967ecb 100644
--- a/arch/sparc/kernel/sys_sparc_64.c
+++ b/arch/sparc/kernel/sys_sparc_64.c
@@ -89,7 +89,6 @@ unsigned long arch_get_unmapped_area(struct file *filp, unsigned long addr, unsi
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct * vma;
 	unsigned long task_size = TASK_SIZE;
-	unsigned long start_addr;
 	int do_color_align;
 	struct vm_unmapped_area_info info;
 
@@ -191,7 +190,7 @@ arch_get_unmapped_area_topdown(struct file *filp, const unsigned long addr0,
 	info.length = len;
 	info.low_limit = PAGE_SIZE;
 	info.high_limit = mm->mmap_base;
-	info.align_mask = do_colour_align ? (PAGE_MASK & shm_align_mask) : 0;
+	info.align_mask = do_color_align ? (PAGE_MASK & (SHMLBA - 1)) : 0;
 	info.align_offset = pgoff << PAGE_SHIFT;
 	addr = vm_unmapped_area(&info);
 

commit ed558f3723a4ac2fb71d6c8fc70116994af6e61d
Author: Michel Lespinasse <walken@google.com>
Date:   Thu Nov 8 20:22:36 2012 -0800

    mm-use-vm_unmapped_area-on-arm-architecture-fix2

diff --git a/arch/arm/mm/mmap.c b/arch/arm/mm/mmap.c
index f4fec6d43d50..10062ceadd1c 100644
--- a/arch/arm/mm/mmap.c
+++ b/arch/arm/mm/mmap.c
@@ -57,7 +57,6 @@ arch_get_unmapped_area(struct file *filp, unsigned long addr,
 {
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
-	unsigned long start_addr;
 	int do_align = 0;
 	int aliasing = cache_is_vipt_aliasing();
 	struct vm_unmapped_area_info info;
