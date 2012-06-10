Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583Ab2FJCNT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 22:13:19 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36418 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936Ab2FJCNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 22:13:18 -0400
Date: Sat, 9 Jun 2012 19:13:15 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>, Dave Jones <davej@redhat.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrea Arcangeli <aarcange@redhat.com>,
        Sasha Levin <levinsasha928@gmail.com>
Subject: Re: kernel BUG at mm/memory.c:1228!
In-Reply-To: <20120606165330.GA27744@redhat.com>
Message-ID: <alpine.DEB.2.00.1206091904030.7832@chino.kir.corp.google.com>
References: <20120606165330.GA27744@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jun 2012, Dave Jones wrote:

> I hit this in overnight testing..
> 
> ------------[ cut here ]------------
> kernel BUG at mm/memory.c:1228!

Looks like a duplicate of the "mm: kernel BUG at mm/memory.c:1230" thread 
at http://marc.info/?t=133788420400003

Andrea suggested adding a printk of addr, end, vma->vm_start, and 
vma->vm_end to debug it.

Since it's been reported a few different times, perhaps this should be 
merged?


mm, thp: print useful information when mmap_sem is unlocked in zap_pmd_range

Andrea asked for addr, end, vma->vm_start, and vma->vm_end to be emitted 
when !rwsem_is_locked(&tlb->mm->mmap_sem).  Otherwise, debugging the 
underlying issue is more difficult.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/memory.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/mm/memory.c b/mm/memory.c
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1225,7 +1225,15 @@ static inline unsigned long zap_pmd_range(struct mmu_gather *tlb,
 		next = pmd_addr_end(addr, end);
 		if (pmd_trans_huge(*pmd)) {
 			if (next - addr != HPAGE_PMD_SIZE) {
-				VM_BUG_ON(!rwsem_is_locked(&tlb->mm->mmap_sem));
+#ifdef CONFIG_DEBUG_VM
+				if (!rwsem_is_locked(&tlb->mm->mmap_sem)) {
+					pr_err("%s: mmap_sem is unlocked! addr=%lu end=%lu vma->vm_start=%lu vma->vm_end=%lu\n",
+						__func__, addr, end,
+						vma->vm_start,
+						vma->vm_end);
+					BUG();
+				}
+#endif
 				split_huge_page_pmd(vma->vm_mm, pmd);
 			} else if (zap_huge_pmd(tlb, vma, pmd, addr))
 				goto next;
