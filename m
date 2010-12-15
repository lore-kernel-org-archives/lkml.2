Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722Ab0LOWVD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 17:21:03 -0500
Received: from claw.goop.org ([74.207.240.146]:47885 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751881Ab0LOWUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 17:20:12 -0500
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>, Linux-MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Xen-devel <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 8/9] xen/mmu: use apply_to_page_range_batch() in xen_remap_domain_mfn_range()
Date: Wed, 15 Dec 2010 14:19:54 -0800
Message-Id: <8ab8e7f173f9bf7b7ec131bd92d4591ba207a905.1292450600.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <cover.1292450600.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1292450600.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1292450600.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1292450600.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/mmu.c |   19 ++++++++++++-------
 1 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 2b2b98a..930bddc 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -2656,14 +2656,19 @@ struct remap_data {
 	struct mmu_update *mmu_update;
 };
 
-static int remap_area_mfn_pte_fn(pte_t *ptep, unsigned long addr, void *data)
+static int remap_area_mfn_pte_fn(pte_t *ptep, unsigned count,
+				 unsigned long addr, void *data)
 {
 	struct remap_data *rmd = data;
-	pte_t pte = pte_mkspecial(pfn_pte(rmd->mfn++, rmd->prot));
 
-	rmd->mmu_update->ptr = arbitrary_virt_to_machine(ptep).maddr;
-	rmd->mmu_update->val = pte_val_ma(pte);
-	rmd->mmu_update++;
+	while (count--) {
+		pte_t pte = pte_mkspecial(pfn_pte(rmd->mfn++, rmd->prot));
+
+		rmd->mmu_update->ptr = arbitrary_virt_to_machine(ptep).maddr;
+		rmd->mmu_update->val = pte_val_ma(pte);
+		rmd->mmu_update++;
+		ptep++;
+	}
 
 	return 0;
 }
@@ -2692,8 +2697,8 @@ int xen_remap_domain_mfn_range(struct vm_area_struct *vma,
 		range = (unsigned long)batch << PAGE_SHIFT;
 
 		rmd.mmu_update = mmu_update;
-		err = apply_to_page_range(vma->vm_mm, addr, range,
-					  remap_area_mfn_pte_fn, &rmd);
+		err = apply_to_page_range_batch(vma->vm_mm, addr, range,
+						remap_area_mfn_pte_fn, &rmd);
 		if (err)
 			goto out;
 
-- 
1.7.3.3

