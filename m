Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881Ab1DSLKJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 07:10:09 -0400
Received: from cantor.suse.de ([195.135.220.2]:37085 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754843Ab1DSLKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 07:10:06 -0400
Date: Tue, 19 Apr 2011 13:10:04 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>, linux-parisc@vger.kernel.org
Subject: [PATCH v3] mm: make expand_downwards symmetrical to expand_upwards
Message-ID: <20110419111004.GE21689@tiehlicka.suse.cz>
References: <20110415135144.GE8828@tiehlicka.suse.cz>
 <alpine.LSU.2.00.1104171952040.22679@sister.anvils>
 <20110418100131.GD8925@tiehlicka.suse.cz>
 <20110418135637.5baac204.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110418135637.5baac204.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 18-04-11 13:56:37, Andrew Morton wrote:
> On Mon, 18 Apr 2011 12:01:31 +0200
> Michal Hocko <mhocko@suse.cz> wrote:
> 
> > Currently we have expand_upwards exported while expand_downwards is
> > accessible only via expand_stack or expand_stack_downwards.
> > 
> > check_stack_guard_page is a nice example of the asymmetry. It uses
> > expand_stack for VM_GROWSDOWN while expand_upwards is called for
> > VM_GROWSUP case.
> > 
> > Let's clean this up by exporting both functions and make those name
> > consistent. Let's use expand_stack_{upwards,downwards} so that we are
> > explicit about stack manipulation in the name. expand_stack_downwards
> > has to be defined for both CONFIG_STACK_GROWS{UP,DOWN} because
> > get_arg_page calls the downwards version in the early process
> > initialization phase for growsup configuration.
> 
> Has this patch been tested on any stack-grows-upwards architecture?

The only one I can find in the tree is parisc and I do not have access
to any such machine. Maybe someone on the list (CCed) can help with
testing the patch bellow? Nevertheless, the patch doesn't change growsup
case. It just renames functions and exports growsdown.

IA64 which grows upwards only for registers still needs a fix because of
the rename, though. I'm sorry, I must have missed it in the grep output
before. No other arch specific code uses expand_{down,up}wards directly.

Changes since v2
 - fix compilation error on ia64
Changes since v1
 - fixed expand_downwards case for CONFIG_STACK_GROWSUP in get_arg_page.
 - rename expand_{downwards,upwards} -> expand_stack_{downwards,upwards}
--- 
>From 091cf27fe9fad875bc7f6cdbb8206c617b06fc7b Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Fri, 15 Apr 2011 14:56:26 +0200
Subject: [PATCH] mm: make expand_downwards symmetrical to expand_upwards

Currently we have expand_upwards exported while expand_downwards is
accessible only via expand_stack or expand_stack_downwards.

check_stack_guard_page is a nice example of the asymmetry. It uses
expand_stack for VM_GROWSDOWN while expand_upwards is called for
VM_GROWSUP case.

Let's clean this up by exporting both functions and make those name
consistent. Let's use expand_stack_{upwards,downwards} so that we are
explicit about stack manipulation in the name. expand_stack_downwards
has to be defined for both CONFIG_STACK_GROWS{UP,DOWN} because
get_arg_page calls the downwards version in the early process
initialization phase for growsup configuration.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 arch/ia64/mm/fault.c |    2 +-
 include/linux/mm.h   |   13 ++++++++-----
 mm/memory.c          |    4 ++--
 mm/mmap.c            |   13 ++++---------
 4 files changed, 15 insertions(+), 17 deletions(-)

diff --git a/arch/ia64/mm/fault.c b/arch/ia64/mm/fault.c
index 0799fea..aebff8a 100644
--- a/arch/ia64/mm/fault.c
+++ b/arch/ia64/mm/fault.c
@@ -197,7 +197,7 @@ ia64_do_page_fault (unsigned long address, unsigned long isr, struct pt_regs *re
 		 */
 		if (address > vma->vm_end + PAGE_SIZE - sizeof(long))
 			goto bad_area;
-		if (expand_upwards(vma, address))
+		if (expand_stack_upwards(vma, address))
 			goto bad_area;
 	}
 	goto good_area;
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 692dbae..17f9b86 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1494,15 +1494,18 @@ unsigned long ra_submit(struct file_ra_state *ra,
 			struct address_space *mapping,
 			struct file *filp);
 
-/* Do stack extension */
+/* Generic expand stack which grows the stack according to GROWS{UP,DOWN} */
 extern int expand_stack(struct vm_area_struct *vma, unsigned long address);
+
+/* CONFIG_STACK_GROWSUP still needs to to grow downwards at some places */
+extern int expand_stack_downwards(struct vm_area_struct *vma,
+		unsigned long address);
 #if VM_GROWSUP
-extern int expand_upwards(struct vm_area_struct *vma, unsigned long address);
+extern int expand_stack_upwards(struct vm_area_struct *vma,
+		unsigned long address);
 #else
-  #define expand_upwards(vma, address) do { } while (0)
+  #define expand_stack_upwards(vma, address) do { } while (0)
 #endif
-extern int expand_stack_downwards(struct vm_area_struct *vma,
-				  unsigned long address);
 
 /* Look up the first VMA which satisfies  addr < vm_end,  NULL if none. */
 extern struct vm_area_struct * find_vma(struct mm_struct * mm, unsigned long addr);
diff --git a/mm/memory.c b/mm/memory.c
index ce22a25..ba5b4d8 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2969,7 +2969,7 @@ static inline int check_stack_guard_page(struct vm_area_struct *vma, unsigned lo
 		if (prev && prev->vm_end == address)
 			return prev->vm_flags & VM_GROWSDOWN ? 0 : -ENOMEM;
 
-		expand_stack(vma, address - PAGE_SIZE);
+		expand_stack_downwards(vma, address - PAGE_SIZE);
 	}
 	if ((vma->vm_flags & VM_GROWSUP) && address + PAGE_SIZE == vma->vm_end) {
 		struct vm_area_struct *next = vma->vm_next;
@@ -2978,7 +2978,7 @@ static inline int check_stack_guard_page(struct vm_area_struct *vma, unsigned lo
 		if (next && next->vm_start == address + PAGE_SIZE)
 			return next->vm_flags & VM_GROWSUP ? 0 : -ENOMEM;
 
-		expand_upwards(vma, address + PAGE_SIZE);
+		expand_stack_upwards(vma, address + PAGE_SIZE);
 	}
 	return 0;
 }
diff --git a/mm/mmap.c b/mm/mmap.c
index e27e0cf..29c68b0 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1731,7 +1731,7 @@ static int acct_stack_growth(struct vm_area_struct *vma, unsigned long size, uns
  * PA-RISC uses this for its stack; IA64 for its Register Backing Store.
  * vma is the last one with address > vma->vm_end.  Have to extend vma.
  */
-int expand_upwards(struct vm_area_struct *vma, unsigned long address)
+int expand_stack_upwards(struct vm_area_struct *vma, unsigned long address)
 {
 	int error;
 
@@ -1782,7 +1782,7 @@ int expand_upwards(struct vm_area_struct *vma, unsigned long address)
 /*
  * vma is the first one with address < vma->vm_start.  Have to extend vma.
  */
-static int expand_downwards(struct vm_area_struct *vma,
+int expand_stack_downwards(struct vm_area_struct *vma,
 				   unsigned long address)
 {
 	int error;
@@ -1829,15 +1829,10 @@ static int expand_downwards(struct vm_area_struct *vma,
 	return error;
 }
 
-int expand_stack_downwards(struct vm_area_struct *vma, unsigned long address)
-{
-	return expand_downwards(vma, address);
-}
-
 #ifdef CONFIG_STACK_GROWSUP
 int expand_stack(struct vm_area_struct *vma, unsigned long address)
 {
-	return expand_upwards(vma, address);
+	return expand_stack_upwards(vma, address);
 }
 
 struct vm_area_struct *
@@ -1859,7 +1854,7 @@ find_extend_vma(struct mm_struct *mm, unsigned long addr)
 #else
 int expand_stack(struct vm_area_struct *vma, unsigned long address)
 {
-	return expand_downwards(vma, address);
+	return expand_stack_downwards(vma, address);
 }
 
 struct vm_area_struct *
-- 
1.7.4.1

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
