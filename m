Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549Ab2KLVeM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 16:34:12 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:24558 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000Ab2KLVT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 16:19:29 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 19/46] x86, mm: Don't clear page table if range is ram
Date: Mon, 12 Nov 2012 13:18:15 -0800
Message-Id: <1352755122-25660-20-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1352755122-25660-1-git-send-email-yinghai@kernel.org>
References: <20121112193044.GA11615@phenom.dumpdata.com>
 <1352755122-25660-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After we add code use buffer in BRK to pre-map buf for page table in
following patch:
	x86, mm: setup page table in top-down
it should be safe to remove early_memmap for page table accessing.
Instead we get panic with that.

It turns out that we clear the initial page table wrongly for next range
that is separated by holes.
And it only happens when we are trying to map ram range one by one.

We need to check if the range is ram before clearing page table.

We change the loop structure to remove the extra little loop and use
one loop only, and in that loop will caculate next at first, and check if
[addr,next) is covered by E820_RAM.

-v2: E820_RESERVED_KERN is treated as E820_RAM. EFI one change some E820_RAM
     to that, so next kernel by kexec will know that range is used already.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/mm/init_64.c |   40 +++++++++++++++++++---------------------
 1 files changed, 19 insertions(+), 21 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 869372a..fa28e3e 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -363,20 +363,20 @@ static unsigned long __meminit
 phys_pte_init(pte_t *pte_page, unsigned long addr, unsigned long end,
 	      pgprot_t prot)
 {
-	unsigned pages = 0;
+	unsigned long pages = 0, next;
 	unsigned long last_map_addr = end;
 	int i;
 
 	pte_t *pte = pte_page + pte_index(addr);
 
-	for(i = pte_index(addr); i < PTRS_PER_PTE; i++, addr += PAGE_SIZE, pte++) {
-
+	for (i = pte_index(addr); i < PTRS_PER_PTE; i++, addr = next, pte++) {
+		next = (addr & PAGE_MASK) + PAGE_SIZE;
 		if (addr >= end) {
-			if (!after_bootmem) {
-				for(; i < PTRS_PER_PTE; i++, pte++)
-					set_pte(pte, __pte(0));
-			}
-			break;
+			if (!after_bootmem &&
+			    !e820_any_mapped(addr & PAGE_MASK, next, E820_RAM) &&
+			    !e820_any_mapped(addr & PAGE_MASK, next, E820_RESERVED_KERN))
+				set_pte(pte, __pte(0));
+			continue;
 		}
 
 		/*
@@ -419,16 +419,15 @@ phys_pmd_init(pmd_t *pmd_page, unsigned long address, unsigned long end,
 		pte_t *pte;
 		pgprot_t new_prot = prot;
 
+		next = (address & PMD_MASK) + PMD_SIZE;
 		if (address >= end) {
-			if (!after_bootmem) {
-				for (; i < PTRS_PER_PMD; i++, pmd++)
-					set_pmd(pmd, __pmd(0));
-			}
-			break;
+			if (!after_bootmem &&
+			    !e820_any_mapped(address & PMD_MASK, next, E820_RAM) &&
+			    !e820_any_mapped(address & PMD_MASK, next, E820_RESERVED_KERN))
+				set_pmd(pmd, __pmd(0));
+			continue;
 		}
 
-		next = (address & PMD_MASK) + PMD_SIZE;
-
 		if (pmd_val(*pmd)) {
 			if (!pmd_large(*pmd)) {
 				spin_lock(&init_mm.page_table_lock);
@@ -497,13 +496,12 @@ phys_pud_init(pud_t *pud_page, unsigned long addr, unsigned long end,
 		pmd_t *pmd;
 		pgprot_t prot = PAGE_KERNEL;
 
-		if (addr >= end)
-			break;
-
 		next = (addr & PUD_MASK) + PUD_SIZE;
-
-		if (!after_bootmem && !e820_any_mapped(addr, next, 0)) {
-			set_pud(pud, __pud(0));
+		if (addr >= end) {
+			if (!after_bootmem &&
+			    !e820_any_mapped(addr & PUD_MASK, next, E820_RAM) &&
+			    !e820_any_mapped(addr & PUD_MASK, next, E820_RESERVED_KERN))
+				set_pud(pud, __pud(0));
 			continue;
 		}
 
-- 
1.7.7

