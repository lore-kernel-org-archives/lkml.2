Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497Ab0D1Ie7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 04:34:59 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:41889 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006Ab0D1Ie4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 04:34:56 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 28 Apr 2010 17:30:54 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       Minchan Kim <minchan.kim@gmail.com>, Christoph Lameter <cl@linux.com>,
       Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/3] mm,migration: Remove straggling migration PTEs when
 page tables are being moved after the VMA has already moved
Message-Id: <20100428173054.7b6716cf.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1272403852-10479-4-git-send-email-mel@csn.ul.ie>
References: <1272403852-10479-1-git-send-email-mel@csn.ul.ie>
	<1272403852-10479-4-git-send-email-mel@csn.ul.ie>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Apr 2010 22:30:52 +0100
Mel Gorman <mel@csn.ul.ie> wrote:

> During exec(), a temporary stack is setup and moved later to its final
> location. There is a race between migration and exec whereby a migration
> PTE can be placed in the temporary stack. When this VMA is moved under the
> lock, migration no longer knows where the PTE is, fails to remove the PTE
> and the migration PTE gets copied to the new location.  This later causes
> a bug when the migration PTE is discovered but the page is not locked.
> 
> This patch handles the situation by removing the migration PTE when page
> tables are being moved in case migration fails to find them. The alternative
> would require significant modification to vma_adjust() and the locks taken
> to ensure a VMA move and page table copy is atomic with respect to migration.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>

Here is my final proposal (before going vacation.)

I think this is very simple. The biggest problem is when move_page_range
fails, setup_arg_pages pass it all to exit() ;)

==
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

This is an band-aid patch for avoiding unmap->remap of stack pages
while it's udner exec(). At exec, pages for stack is moved by
setup_arg_pages(). Under this, (vma,page)<->address relationship
can be in broken state.
Moreover, if moving ptes fails, pages with not-valid-rmap remains
in the page table and objrmap for the page is completely broken
until exit() frees all up.

This patch adds vma->broken_rmap. If broken_rmap != 0, vma_address()
returns -EFAULT always and try_to_unmap() fails.
(IOW, the pages for stack are pinned until setup_arg_pages() ends.)

And this prevents page migration because the page's mapcount never
goes to 0 until exec() fixes it up.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 fs/exec.c                |    4 +++-
 include/linux/mm_types.h |    5 +++++
 mm/rmap.c                |    5 +++++
 3 files changed, 13 insertions(+), 1 deletion(-)

Index: mel-test/fs/exec.c
===================================================================
--- mel-test.orig/fs/exec.c
+++ mel-test/fs/exec.c
@@ -250,7 +250,8 @@ static int __bprm_mm_init(struct linux_b
 	err = insert_vm_struct(mm, vma);
 	if (err)
 		goto err;
-
+	/* prevent rmap_walk, try_to_unmap() etc..until we get fixed rmap */
+	vma->unstable_rmap = 1;
 	mm->stack_vm = mm->total_vm = 1;
 	up_write(&mm->mmap_sem);
 	bprm->p = vma->vm_end - sizeof(void *);
@@ -653,6 +654,7 @@ int setup_arg_pages(struct linux_binprm 
 		ret = -EFAULT;
 
 out_unlock:
+	vma->unstable_rmap = 0;
 	up_write(&mm->mmap_sem);
 	return ret;
 }
Index: mel-test/include/linux/mm_types.h
===================================================================
--- mel-test.orig/include/linux/mm_types.h
+++ mel-test/include/linux/mm_types.h
@@ -183,6 +183,11 @@ struct vm_area_struct {
 #ifdef CONFIG_NUMA
 	struct mempolicy *vm_policy;	/* NUMA policy for the VMA */
 #endif
+	/*
+ 	 * updated only under down_write(mmap_sem). while this is not 0,
+ 	 * objrmap is not trustable.
+ 	 */
+	int unstable_rmap;
 };
 
 struct core_thread {
Index: mel-test/mm/rmap.c
===================================================================
--- mel-test.orig/mm/rmap.c
+++ mel-test/mm/rmap.c
@@ -332,6 +332,11 @@ vma_address(struct page *page, struct vm
 {
 	pgoff_t pgoff = page->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
 	unsigned long address;
+#ifdef CONFIG_MIGRATION
+	/* While unstable_rmap is set, we cannot trust objrmap */
+	if (unlikely(vma->unstable_rmap))
+		return -EFAULT:
+#endif
 
 	address = vma->vm_start + ((pgoff - vma->vm_pgoff) << PAGE_SHIFT);
 	if (unlikely(address < vma->vm_start || address >= vma->vm_end)) {

