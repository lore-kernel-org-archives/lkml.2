Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704Ab0DVFno (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 01:43:44 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:36726 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870Ab0DVFnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 01:43:43 -0400
Date: Thu, 22 Apr 2010 14:42:41 +0900
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: linux-mm <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>, Andi Kleen <andi@firstfloor.org>
Subject: [BUG] rmap: fix page_address_in_vma() to walk through
 anon_vma_chain
Message-ID: <20100422054241.GB10957@spritzerA.linux.bs1.fc.nec.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found a bug on page_address_in_vma() related to anon_vma_chain.

I wrote a patch, but according to a comment in include/linux/rmap.h,
I suspect this doesn't meet lock requirement of anon_vma_chain
(mmap_sem and page_table_lock, see below).

                           mmap_sem      page_table_lock
  mm/ksm.c:
    write_protect_page()   hold          not hold
    replace_page()         hold          not hold
  mm/memory-failure.c:
    add_to_kill()          not hold      hold
  mm/mempolicy.c:
    new_vma_page()         hold          not hold
  mm/swapfile.c:
    unuse_vma()            hold          not hold

Any comments?

Thanks,
Naoya Horiguchi
---
Subject: [BUG] rmap: fix page_address_in_vma() to walk through anon_vma_chain

page_address_in_vma() checks if a given page is associated with a given vma.
Currently it just compares vma->anon_vma and page_anon_vma(page).
But in 2.6.34, a vma can have multiple anon_vmas with anon_vma_chain,
so we have to check all anon_vmas in the "same_vma" chain.
Otherwise, when a page is shared by multiple processes,
some (page,vma) pairs can be misjudged as not-mapped.

Need Work: Meet lock requirement of anon_vma_chain.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
---
 mm/rmap.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 526704e..2e7462b 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -340,14 +340,22 @@ vma_address(struct page *page, struct vm_area_struct *vma)
 unsigned long page_address_in_vma(struct page *page, struct vm_area_struct *vma)
 {
 	if (PageAnon(page)) {
-		if (vma->anon_vma != page_anon_vma(page))
-			return -EFAULT;
+		struct anon_vma_chain *avc;
+		/*
+		 * Walking same_vma list needs mmap_sem and page_table_lock.
+		 * Do users of this function meet it?
+		 */
+		list_for_each_entry(avc, &vma->anon_vma_chain, same_vma)
+			if (avc->anon_vma == page_anon_vma(page))
+				goto get_address;
+		return -EFAULT;
 	} else if (page->mapping && !(vma->vm_flags & VM_NONLINEAR)) {
 		if (!vma->vm_file ||
 		    vma->vm_file->f_mapping != page->mapping)
 			return -EFAULT;
 	} else
 		return -EFAULT;
+get_address:
 	return vma_address(page, vma);
 }
 
-- 
1.7.0
