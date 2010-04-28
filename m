Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751595Ab0D1Hcl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 03:32:41 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:60220 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033Ab0D1Hck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 03:32:40 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 28 Apr 2010 16:28:38 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       Minchan Kim <minchan.kim@gmail.com>, Christoph Lameter <cl@linux.com>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/3] mm,migration: Remove straggling migration PTEs when
 page tables are being moved after the VMA has already moved
Message-Id: <20100428162838.c762fcda.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100428114944.3570105f.kamezawa.hiroyu@jp.fujitsu.com>
References: <1272403852-10479-1-git-send-email-mel@csn.ul.ie>
	<1272403852-10479-4-git-send-email-mel@csn.ul.ie>
	<20100427223004.GF8860@random.random>
	<20100427225852.GH8860@random.random>
	<20100428102928.a3b25066.kamezawa.hiroyu@jp.fujitsu.com>
	<20100428014434.GM510@random.random>
	<20100428111248.2797801c.kamezawa.hiroyu@jp.fujitsu.com>
	<20100428024227.GN510@random.random>
	<20100428114944.3570105f.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Apr 2010 11:49:44 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Wed, 28 Apr 2010 04:42:27 +0200
> Andrea Arcangeli <aarcange@redhat.com> wrote:
 
> > migrate.c requires rmap to be able to find all ptes mapping a page at
> > all times, otherwise the migration entry can be instantiated, but it
> > can't be removed if the second rmap_walk fails to find the page.
> > 
> > So shift_arg_pages must run atomically with respect of rmap_walk, and
> > it's enough to run it under the anon_vma lock to make it atomic.
> > 
> > And split_huge_page() will have the same requirements as migrate.c
> > already has.
> > 
> > Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
> 
> Seems good.
> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> I'll test this and report if I see trouble again.
> 
> Unfortunately, I'll have a week of holidays (in Japan) in 4/29-5/05,
> my office is nearly closed. So, please consider no-mail-from-me is
> good information.
> 
Here is bad news. When move_page_tables() fails, "some ptes" are moved
but others are not and....there is no rollback routine.

I bet the best way to fix this mess up is 
 - disable overlap moving of arg pages
 - use do_mremap().

But maybe you guys want to fix this directly.
Here is a temporal fix from me. But don't trust me..
==
Subject: fix race between shift_arg_pages and rmap_walk

From: Andrea Arcangeli <aarcange@redhat.com>

migrate.c requires rmap to be able to find all ptes mapping a page at
all times, otherwise the migration entry can be instantiated, but it
can't be removed if the second rmap_walk fails to find the page.

So shift_arg_pages must run atomically with respect of rmap_walk, and
it's enough to run it under the anon_vma lock to make it atomic.

And split_huge_page() will have the same requirements as migrate.c
already has.

And, when moving overlapping ptes by move_page_tables(), it's cannot
be roll-backed as mremap does. This patch changes move_page_tables()'s
behavior and if it failes, no ptes are moved.

Changelog:
 - modified move_page_tables() to do atomic pte moving because
   "some ptes are moved but others are not" is critical for rmap_walk().
 - free pgtables at failure rather than give it all to do_exit().
   If not, objrmap will be inconsitent until exit() frees all.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---

---
 fs/exec.c   |   67 +++++++++++++++++++++++++++++++++++++-----------------------
 mm/mremap.c |   28 ++++++++++++++++++++++---
 2 files changed, 67 insertions(+), 28 deletions(-)

Index: mel-test/fs/exec.c
===================================================================
--- mel-test.orig/fs/exec.c
+++ mel-test/fs/exec.c
@@ -55,6 +55,7 @@
 #include <linux/fsnotify.h>
 #include <linux/fs_struct.h>
 #include <linux/pipe_fs_i.h>
+#include <linux/rmap.h>
 
 #include <asm/uaccess.h>
 #include <asm/mmu_context.h>
@@ -503,7 +504,10 @@ static int shift_arg_pages(struct vm_are
 	unsigned long length = old_end - old_start;
 	unsigned long new_start = old_start - shift;
 	unsigned long new_end = old_end - shift;
+	unsigned long moved_length;
 	struct mmu_gather *tlb;
+	int ret;
+	unsigned long unused_pgd_start, unused_pgd_end, floor, ceiling;
 
 	BUG_ON(new_start > new_end);
 
@@ -517,41 +521,54 @@ static int shift_arg_pages(struct vm_are
 	/*
 	 * cover the whole range: [new_start, old_end)
 	 */
-	if (vma_adjust(vma, new_start, old_end, vma->vm_pgoff, NULL))
-		return -ENOMEM;
+	spin_lock(&vma->anon_vma->lock);
+	vma->vm_start = new_start;
 
-	/*
-	 * move the page tables downwards, on failure we rely on
-	 * process cleanup to remove whatever mess we made.
-	 */
 	if (length != move_page_tables(vma, old_start,
-				       vma, new_start, length))
-		return -ENOMEM;
-
-	lru_add_drain();
-	tlb = tlb_gather_mmu(mm, 0);
-	if (new_end > old_start) {
+				       vma, new_start, length)) {
+		vma->vm_start = old_start;
 		/*
-		 * when the old and new regions overlap clear from new_end.
-		 */
-		free_pgd_range(tlb, new_end, old_end, new_end,
-			vma->vm_next ? vma->vm_next->vm_start : 0);
+ 		 * we have to free [new_start, new_start+length] pgds
+ 		 * which we've allocated above.
+ 		 */
+		if (new_end > old_start) {
+			unused_pgd_start = new_start;
+			unused_pgd_end = old_start;
+		} else {
+			unused_pgd_start = new_start;
+			unused_pgd_end = new_end;
+		}
+		floor = new_start;
+		ceiling = old_start;
+		ret = -ENOMEM:
 	} else {
-		/*
-		 * otherwise, clean from old_start; this is done to not touch
-		 * the address space in [new_end, old_start) some architectures
-		 * have constraints on va-space that make this illegal (IA64) -
-		 * for the others its just a little faster.
-		 */
-		free_pgd_range(tlb, old_start, old_end, new_end,
-			vma->vm_next ? vma->vm_next->vm_start : 0);
+		if (new_end > old_start) {
+			unused_pgd_start = new_end;
+			unused_pgd_end = old_end;
+		} else {
+			unused_pgd_start = old_start;
+			unused_pgd_end = old_end;
+		}
+		floor = new_end;
+		if (vma->vm_next)
+			ceiling = vma->vm_next->vm_start;
+		else
+			ceiling = 0;
+		ret = 0;
 	}
+	spin_unlock(&vma->anon_vma->lock);
+
+	lru_add_drain();
+	tlb = tlb_gather_mmu(mm, 0);
+	/* Free unnecessary PGDS */
+	free_pgd_range(tlb, unused_pgd_start, unused_pgd_end, floor, ceiling);
 	tlb_finish_mmu(tlb, new_end, old_end);
 
 	/*
 	 * Shrink the vma to just the new range.  Always succeeds.
 	 */
-	vma_adjust(vma, new_start, new_end, vma->vm_pgoff, NULL);
+	if (!ret)
+		vma->vm_end = new_end;
 
 	return 0;
 }
Index: mel-test/mm/mremap.c
===================================================================
--- mel-test.orig/mm/mremap.c
+++ mel-test/mm/mremap.c
@@ -134,22 +134,44 @@ unsigned long move_page_tables(struct vm
 {
 	unsigned long extent, next, old_end;
 	pmd_t *old_pmd, *new_pmd;
+	unsigned long from_addr, to_addr;
 
 	old_end = old_addr + len;
 	flush_cache_range(vma, old_addr, old_end);
 
-	for (; old_addr < old_end; old_addr += extent, new_addr += extent) {
+	/* At first, copy required pmd in the range */
+	for (from_addr = old_addr, to_addr = new_addr;
+	     from_addr < old_end; from_addr += extent, to_addr += extent) {
 		cond_resched();
 		next = (old_addr + PMD_SIZE) & PMD_MASK;
 		if (next - 1 > old_end)
 			next = old_end;
 		extent = next - old_addr;
-		old_pmd = get_old_pmd(vma->vm_mm, old_addr);
+		old_pmd = get_old_pmd(vma->vm_mm, from_addr);
 		if (!old_pmd)
 			continue;
-		new_pmd = alloc_new_pmd(vma->vm_mm, new_addr);
+		new_pmd = alloc_new_pmd(vma->vm_mm, to_addr);
 		if (!new_pmd)
 			break;
+		next = (to_addr + PMD_SIZE) & PMD_MASK;
+		if (extent > next - to_addr)
+			extent = next - to_addr;
+	}
+	/* -ENOMEM ? */
+	if (from_addr < old_end) /* the caller must free remaining pmds. */
+		return 0;
+
+	for (; old_addr < old_end; old_addr += extent, new_addr += extent) {
+		cond_resched();
+		next = (old_addr + PMD_SIZE) & PMD_MASK;
+		if (next - 1 > old_end)
+			next = old_end;
+		extent = next - old_addr;
+		old_pmd = get_old_pmd(vma->vm_mm, old_addr);
+		if (!old_pmd)
+			continue;
+		new_pmd = get_new_pmd(vma->vm_mm, new_addr);
+		BUG_ON(!new_pmd);
 		next = (new_addr + PMD_SIZE) & PMD_MASK;
 		if (extent > next - new_addr)
 			extent = next - new_addr;









