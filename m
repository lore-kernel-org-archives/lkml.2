Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932438Ab0HXWyB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 18:54:01 -0400
Received: from kroah.org ([198.145.64.141]:52148 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932367Ab0HXWxx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 18:53:53 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:25:24 2010
Message-Id: <20100824222524.489096417@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:24:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [24/59] mm: make the vma list be doubly linked
In-Reply-To: <20100824224625.GA5449@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 297c5eee372478fc32fec5fe8eed711eedb13f3d upstream.

It's a really simple list, and several of the users want to go backwards
in it to find the previous vma.  So rather than have to look up the
previous entry with 'find_vma_prev()' or something similar, just make it
doubly linked instead.

Tested-by: Ian Campbell <ijc@hellion.org.uk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/mm_types.h |    2 +-
 kernel/fork.c            |    7 +++++--
 mm/mmap.c                |   21 +++++++++++++++++----
 mm/nommu.c               |    7 +++++--
 4 files changed, 28 insertions(+), 9 deletions(-)

--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -138,7 +138,7 @@ struct vm_area_struct {
 					   within vm_mm. */
 
 	/* linked list of VM areas per task, sorted by address */
-	struct vm_area_struct *vm_next;
+	struct vm_area_struct *vm_next, *vm_prev;
 
 	pgprot_t vm_page_prot;		/* Access permissions of this VMA. */
 	unsigned long vm_flags;		/* Flags, see mm.h. */
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -277,7 +277,7 @@ out:
 #ifdef CONFIG_MMU
 static int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 {
-	struct vm_area_struct *mpnt, *tmp, **pprev;
+	struct vm_area_struct *mpnt, *tmp, *prev, **pprev;
 	struct rb_node **rb_link, *rb_parent;
 	int retval;
 	unsigned long charge;
@@ -305,6 +305,7 @@ static int dup_mmap(struct mm_struct *mm
 	if (retval)
 		goto out;
 
+	prev = NULL;
 	for (mpnt = oldmm->mmap; mpnt; mpnt = mpnt->vm_next) {
 		struct file *file;
 
@@ -333,7 +334,7 @@ static int dup_mmap(struct mm_struct *mm
 		vma_set_policy(tmp, pol);
 		tmp->vm_flags &= ~VM_LOCKED;
 		tmp->vm_mm = mm;
-		tmp->vm_next = NULL;
+		tmp->vm_next = tmp->vm_prev = NULL;
 		anon_vma_link(tmp);
 		file = tmp->vm_file;
 		if (file) {
@@ -367,6 +368,8 @@ static int dup_mmap(struct mm_struct *mm
 		 */
 		*pprev = tmp;
 		pprev = &tmp->vm_next;
+		tmp->vm_prev = prev;
+		prev = tmp;
 
 		__vma_link_rb(mm, tmp, rb_link, rb_parent);
 		rb_link = &tmp->vm_rb.rb_right;
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -389,17 +389,23 @@ static inline void
 __vma_link_list(struct mm_struct *mm, struct vm_area_struct *vma,
 		struct vm_area_struct *prev, struct rb_node *rb_parent)
 {
+	struct vm_area_struct *next;
+
+	vma->vm_prev = prev;
 	if (prev) {
-		vma->vm_next = prev->vm_next;
+		next = prev->vm_next;
 		prev->vm_next = vma;
 	} else {
 		mm->mmap = vma;
 		if (rb_parent)
-			vma->vm_next = rb_entry(rb_parent,
+			next = rb_entry(rb_parent,
 					struct vm_area_struct, vm_rb);
 		else
-			vma->vm_next = NULL;
+			next = NULL;
 	}
+	vma->vm_next = next;
+	if (next)
+		next->vm_prev = vma;
 }
 
 void __vma_link_rb(struct mm_struct *mm, struct vm_area_struct *vma,
@@ -487,7 +493,11 @@ static inline void
 __vma_unlink(struct mm_struct *mm, struct vm_area_struct *vma,
 		struct vm_area_struct *prev)
 {
-	prev->vm_next = vma->vm_next;
+	struct vm_area_struct *next = vma->vm_next;
+
+	prev->vm_next = next;
+	if (next)
+		next->vm_prev = prev;
 	rb_erase(&vma->vm_rb, &mm->mm_rb);
 	if (mm->mmap_cache == vma)
 		mm->mmap_cache = prev;
@@ -1798,6 +1808,7 @@ detach_vmas_to_be_unmapped(struct mm_str
 	unsigned long addr;
 
 	insertion_point = (prev ? &prev->vm_next : &mm->mmap);
+	vma->vm_prev = NULL;
 	do {
 		rb_erase(&vma->vm_rb, &mm->mm_rb);
 		mm->map_count--;
@@ -1805,6 +1816,8 @@ detach_vmas_to_be_unmapped(struct mm_str
 		vma = vma->vm_next;
 	} while (vma && vma->vm_start < end);
 	*insertion_point = vma;
+	if (vma)
+		vma->vm_prev = prev;
 	tail_vma->vm_next = NULL;
 	if (mm->unmap_area == arch_unmap_area)
 		addr = prev ? prev->vm_end : mm->mmap_base;
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -608,7 +608,7 @@ static void protect_vma(struct vm_area_s
  */
 static void add_vma_to_mm(struct mm_struct *mm, struct vm_area_struct *vma)
 {
-	struct vm_area_struct *pvma, **pp;
+	struct vm_area_struct *pvma, **pp, *next;
 	struct address_space *mapping;
 	struct rb_node **p, *parent;
 
@@ -668,8 +668,11 @@ static void add_vma_to_mm(struct mm_stru
 			break;
 	}
 
-	vma->vm_next = *pp;
+	next = *pp;
 	*pp = vma;
+	vma->vm_next = next;
+	if (next)
+		next->vm_prev = vma;
 }
 
 /*


