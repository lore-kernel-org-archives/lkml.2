Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263Ab2KLVYd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 16:24:33 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:24655 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858Ab2KLVTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 16:19:33 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 12/46] x86, mm: use pfn_range_is_mapped() with CPA
Date: Mon, 12 Nov 2012 13:18:08 -0800
Message-Id: <1352755122-25660-13-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1352755122-25660-1-git-send-email-yinghai@kernel.org>
References: <20121112193044.GA11615@phenom.dumpdata.com>
 <1352755122-25660-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are going to map ram only, so under max_low_pfn_mapped,
between 4g and max_pfn_mapped does not mean mapped at all.

Use pfn_range_is_mapped() directly.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
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

