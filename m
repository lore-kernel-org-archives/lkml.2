Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932541Ab2K1WAU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 17:00:20 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:44923 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756177Ab2K1Vso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 16:48:44 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v9 17/46] x86, mm: Align start address to correct big page size
Date: Wed, 28 Nov 2012 13:47:28 -0800
Message-Id: <1354139277-17376-18-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1354139277-17376-1-git-send-email-yinghai@kernel.org>
References: <1354139277-17376-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are going to use buffer in BRK to map small range just under memory top,
and use those new mapped ram to map ram range under it.

The ram range that will be mapped at first could be only page aligned,
but ranges around it are ram too, we could use bigger page to map it to
avoid small page size.

We will adjust page_size_mask in following patch:
	x86, mm: Use big page size for small memory range
to use big page size for small ram range.

Before that patch, this patch will make sure start address to be
aligned down according to bigger page size, otherwise entry in page
page will not have correct value.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/mm/init_32.c |    1 +
 arch/x86/mm/init_64.c |    5 +++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 11a5800..27f7fc6 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -310,6 +310,7 @@ repeat:
 					__pgprot(PTE_IDENT_ATTR |
 						 _PAGE_PSE);
 
+				pfn &= PMD_MASK >> PAGE_SHIFT;
 				addr2 = (pfn + PTRS_PER_PTE-1) * PAGE_SIZE +
 					PAGE_OFFSET + PAGE_SIZE-1;
 
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 32c7e38..869372a 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -464,7 +464,7 @@ phys_pmd_init(pmd_t *pmd_page, unsigned long address, unsigned long end,
 			pages++;
 			spin_lock(&init_mm.page_table_lock);
 			set_pte((pte_t *)pmd,
-				pfn_pte(address >> PAGE_SHIFT,
+				pfn_pte((address & PMD_MASK) >> PAGE_SHIFT,
 					__pgprot(pgprot_val(prot) | _PAGE_PSE)));
 			spin_unlock(&init_mm.page_table_lock);
 			last_map_addr = next;
@@ -541,7 +541,8 @@ phys_pud_init(pud_t *pud_page, unsigned long addr, unsigned long end,
 			pages++;
 			spin_lock(&init_mm.page_table_lock);
 			set_pte((pte_t *)pud,
-				pfn_pte(addr >> PAGE_SHIFT, PAGE_KERNEL_LARGE));
+				pfn_pte((addr & PUD_MASK) >> PAGE_SHIFT,
+					PAGE_KERNEL_LARGE));
 			spin_unlock(&init_mm.page_table_lock);
 			last_map_addr = next;
 			continue;
-- 
1.7.7

