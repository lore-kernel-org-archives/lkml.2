Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659Ab1EFHua (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 03:50:30 -0400
Received: from cantor.suse.de ([195.135.220.2]:51199 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754282Ab1EFHu3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 03:50:29 -0400
Date: Fri, 6 May 2011 09:50:27 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v4] mm: make expand_downwards symmetrical to expand_upwards
Message-ID: <20110506075027.GB32495@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,
I am sorry to repost this kind of trivial cleanup for the 4th time,
but after recent discussion (https://lkml.org/lkml/2011/5/3/323)
with Hugh I think that it makes sense to keep the original
expand_{upwards,downwards} without being explicit about the stack in the
name. As Hugh pointed out, IA64 uses expand_upwards for something that
is not really a stack (it is a backing storage for registers).
The following patch reworks the original one so it is not incremental.
If you prefer incremental one I can send that one instead. 
Just for record this patch obsoletes:
	mm-make-expand_downwards-symmetrical-with-expand_upwards.patch
	mm-make-expand_downwards-symmetrical-with-expand_upwards-v3.patch
in your current (2011-04-29-16-25) mm tree.

---
>From 1b679558f464530c59c93930b958a3436a250c25 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Fri, 15 Apr 2011 14:56:26 +0200
Subject: [PATCH] mm: make expand_downwards symmetrical to expand_upwards

Currently we have expand_upwards exported while expand_downwards is
accessible only via expand_stack or expand_stack_downwards.

check_stack_guard_page is a nice example of the asymmetry. It uses
expand_stack for VM_GROWSDOWN while expand_upwards is called for
VM_GROWSUP case.

Let's clean this up by exporting both functions and make those names
consistent. Let's use expand_{upwards,downwards} because expanding
doesn't always involve stack manipulation (an example is
ia64_do_page_fault which uses expand_upwards for registers backing store
expansion).
expand_downwards has to be defined for both CONFIG_STACK_GROWS{UP,DOWN}
because get_arg_page calls the downwards version in the early process
initialization phase for growsup configuration.

CC: Hugh Dickins <hughd@google.com>
Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 fs/exec.c          |    2 +-
 include/linux/mm.h |    8 +++++---
 mm/memory.c        |    2 +-
 mm/mmap.c          |    7 +------
 4 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 5e62d26..c2668ff 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -194,7 +194,7 @@ struct page *get_arg_page(struct linux_binprm *bprm, unsigned long pos,
 
 #ifdef CONFIG_STACK_GROWSUP
 	if (write) {
-		ret = expand_stack_downwards(bprm->vma, pos);
+		ret = expand_downwards(bprm->vma, pos);
 		if (ret < 0)
 			return NULL;
 	}
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 692dbae..2d4f62b 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1494,15 +1494,17 @@ unsigned long ra_submit(struct file_ra_state *ra,
 			struct address_space *mapping,
 			struct file *filp);
 
-/* Do stack extension */
+/* Generic expand stack which grows the stack according to GROWS{UP,DOWN} */
 extern int expand_stack(struct vm_area_struct *vma, unsigned long address);
+
+/* CONFIG_STACK_GROWSUP still needs to to grow downwards at some places */
+extern int expand_downwards(struct vm_area_struct *vma,
+		unsigned long address);
 #if VM_GROWSUP
 extern int expand_upwards(struct vm_area_struct *vma, unsigned long address);
 #else
   #define expand_upwards(vma, address) do { } while (0)
 #endif
-extern int expand_stack_downwards(struct vm_area_struct *vma,
-				  unsigned long address);
 
 /* Look up the first VMA which satisfies  addr < vm_end,  NULL if none. */
 extern struct vm_area_struct * find_vma(struct mm_struct * mm, unsigned long addr);
diff --git a/mm/memory.c b/mm/memory.c
index ce22a25..f404fb6 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2969,7 +2969,7 @@ static inline int check_stack_guard_page(struct vm_area_struct *vma, unsigned lo
 		if (prev && prev->vm_end == address)
 			return prev->vm_flags & VM_GROWSDOWN ? 0 : -ENOMEM;
 
-		expand_stack(vma, address - PAGE_SIZE);
+		expand_downwards(vma, address - PAGE_SIZE);
 	}
 	if ((vma->vm_flags & VM_GROWSUP) && address + PAGE_SIZE == vma->vm_end) {
 		struct vm_area_struct *next = vma->vm_next;
diff --git a/mm/mmap.c b/mm/mmap.c
index e27e0cf..4c10287 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1782,7 +1782,7 @@ int expand_upwards(struct vm_area_struct *vma, unsigned long address)
 /*
  * vma is the first one with address < vma->vm_start.  Have to extend vma.
  */
-static int expand_downwards(struct vm_area_struct *vma,
+int expand_downwards(struct vm_area_struct *vma,
 				   unsigned long address)
 {
 	int error;
@@ -1829,11 +1829,6 @@ static int expand_downwards(struct vm_area_struct *vma,
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
-- 
1.7.4.4


-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
