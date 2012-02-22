Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755820Ab2BVDpf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 22:45:35 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:61273 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754067Ab2BVDpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 22:45:34 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of ajeet.yadav.77@gmail.com designates 10.68.134.72 as permitted sender) smtp.mail=ajeet.yadav.77@gmail.com; dkim=pass header.i=ajeet.yadav.77@gmail.com
From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
To: Russell King <linux@arm.linux.org.uk>, Jon Medhurst <tixy@yxit.co.uk>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sumit Bhattacharya <sumitb@nvidia.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Ajeet Yadav <ajeet.yadav.77@gmail.com>,
        Naveen Yadav <yad.naveen@gmail.com>
Subject: [PATCH 3/3] ARM: dma-mapping: fix array out of bound access in  __dma_*_remap
Date: Wed, 22 Feb 2012 09:16:37 +0530
Message-Id: <1329882397-11382-1-git-send-email-ajeet.yadav.77@gmail.com>
X-Mailer: git-send-email 1.7.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let consider
off = (PTRS_PER_PTE - 1);
idx = CONSISTENT_PTE_INDEX(c->vm_start); provide us with last
vaild element in consistent_pte[];

Also __dma_alloc_remap() request 1 page, i.e size == PAGE_SIZE.

Because size, off, idx are vaild values with respect to consistent
mapping region, and its a do{}while loop, so it will exit loop after
first pass. All fine

But their is a catch, we do off++, so
do{
        do_all_important_stuff
        off++;  >>>>> now off = PTRS_PER_PTE
        if (off >= PTRS_PER_PTE) {      >>>>>> condition TRUE
                off = 0;
                pte = consistent_pte[++idx];    >>>>> we did idx++ but
idx was already pointing to last element, so we are trying to access
array out of bound
        }
} while (size -= PAGE_SIZE);>>>>>>> conditon FALSE, but its too late

The proposed solution, move if body from last to begining of do{}while.

In this case we will prevent out of bound acess, without effecting the
flow on first entry and also exit from do{}while loop.
Moving the if body to begining of do{}while ensured that on first entry
to do{}while loop, the if condition fails hence not effecting the first
entry condition.
on subsequent iterations of do{}while loop the while condition will be
checked before we execute the if conditon.

Given functions __dma_alloc_remap()/ __dma_free_remap() already haves
necessary checks to ensure that size is valid, so again if we analyse
from given example

do{
        if (off >= PTRS_PER_PTE) {      >>>>>> condition FALSE
                off = 0;
                pte = consistent_pte[++idx];    >>>>>> we avoid this
        }
        do_all_important_stuff
        off++;  >>>>>> now off = PTRS_PER_PTE
} while (size -= PAGE_SIZE);     >>>>>>> condition FAILS, we exit the
do{}while, effectively prevented the out of bound access of
consistent_pte[]

NOTE: size is valid,  so in proposed solution while conditon is
effectively
preventing the out of bound array access to occur.
If we review the code from normal access point of view, we are not
changing any flow logic, also after the exit from do{}while no access to
off, idx, pte is performed by the function.

So we do not need to worry about post do{}while statments

Signed-off-by: Naveen Yadav <yad.naveen@gmail.com>
Signed-off-by: Ajeet Yadav <ajeet.yadav.77@gmail.com>
---
 arch/arm/mm/dma-mapping.c |   19 +++++++++----------
 1 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index 932d288..0e1a2a2 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -251,16 +251,16 @@ __dma_alloc_remap(struct page *page, size_t size, gfp_t gfp, pgprot_t prot)
 		c->vm_pages = page;
 
 		do {
+			if (off >= PTRS_PER_PTE) {
+				off = 0;
+				pte = consistent_pte[++idx];
+			}
 			BUG_ON(!pte_none(*pte));
 
 			set_pte_ext(pte, mk_pte(page, prot), 0);
 			page++;
 			pte++;
 			off++;
-			if (off >= PTRS_PER_PTE) {
-				off = 0;
-				pte = consistent_pte[++idx];
-			}
 		} while (size -= PAGE_SIZE);
 
 		dsb();
@@ -275,6 +275,7 @@ static void __dma_free_remap(void *cpu_addr, size_t size)
 	struct arm_vmregion *c;
 	unsigned long addr;
 	pte_t *ptep;
+	pte_t pte;
 	int idx;
 	u32 off;
 
@@ -298,16 +299,14 @@ static void __dma_free_remap(void *cpu_addr, size_t size)
 	ptep = consistent_pte[idx] + off;
 	addr = c->vm_start;
 	do {
-		pte_t pte = ptep_get_and_clear(&init_mm, addr, ptep);
-
-		ptep++;
-		addr += PAGE_SIZE;
-		off++;
 		if (off >= PTRS_PER_PTE) {
 			off = 0;
 			ptep = consistent_pte[++idx];
 		}
-
+		pte = ptep_get_and_clear(&init_mm, addr, ptep);
+		ptep++;
+		addr += PAGE_SIZE;
+		off++;
 		if (pte_none(pte) || !pte_present(pte))
 			printk(KERN_CRIT "%s: bad page in kernel page table\n",
 			       __func__);
-- 
1.7.8.4

