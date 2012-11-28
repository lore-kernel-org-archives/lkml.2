Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756321Ab2K1Vsv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 16:48:51 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:37059 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756264Ab2K1Vsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 16:48:47 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v9 12/46] x86, mm: use pfn_range_is_mapped() with CPA
Date: Wed, 28 Nov 2012 13:47:23 -0800
Message-Id: <1354139277-17376-13-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1354139277-17376-1-git-send-email-yinghai@kernel.org>
References: <1354139277-17376-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are going to map ram only in patch:
	x86, mm: Only direct map addresses that are marked as E820_RAM

so range under max_low_pfn_mapped, ranges between 4g and max_pfn_mapped
could have holes in them and the holes will not be mapped.

Use pfn_range_is_mapped() to check if the range is mapped.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/mm/pageattr.c |   16 +++-------------
 1 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index a718e0d..44acfcd 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -551,16 +551,10 @@ static int split_large_page(pte_t *kpte, unsigned long address)
 	for (i = 0; i < PTRS_PER_PTE; i++, pfn += pfninc)
 		set_pte(&pbase[i], pfn_pte(pfn, ref_prot));
 
-	if (address >= (unsigned long)__va(0) &&
-		address < (unsigned long)__va(max_low_pfn_mapped << PAGE_SHIFT))
+	if (pfn_range_is_mapped(PFN_DOWN(__pa(address)),
+				PFN_DOWN(__pa(address)) + 1))
 		split_page_count(level);
 
-#ifdef CONFIG_X86_64
-	if (address >= (unsigned long)__va(1UL<<32) &&
-		address < (unsigned long)__va(max_pfn_mapped << PAGE_SHIFT))
-		split_page_count(level);
-#endif
-
 	/*
 	 * Install the new, split up pagetable.
 	 *
@@ -729,13 +723,9 @@ static int cpa_process_alias(struct cpa_data *cpa)
 	unsigned long vaddr;
 	int ret;
 
-	if (cpa->pfn >= max_pfn_mapped)
+	if (!pfn_range_is_mapped(cpa->pfn, cpa->pfn + 1))
 		return 0;
 
-#ifdef CONFIG_X86_64
-	if (cpa->pfn >= max_low_pfn_mapped && cpa->pfn < (1UL<<(32-PAGE_SHIFT)))
-		return 0;
-#endif
 	/*
 	 * No need to redo, when the primary call touched the direct
 	 * mapping already:
-- 
1.7.7

