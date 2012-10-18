Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729Ab2JRUv0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 16:51:26 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:24796 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756457Ab2JRUvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 16:51:13 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 03/19] x86, mm: Don't clear page table if range is ram
Date: Thu, 18 Oct 2012 13:50:14 -0700
Message-Id: <1350593430-24470-7-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1350593430-24470-1-git-send-email-yinghai@kernel.org>
References: <1350593430-24470-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After we add code use buffer in BRK to pre-map page table,
it should be safe to remove early_memmap for page table accessing.
Instead we get panic with that.

It turns out we clear the initial page table wrongly for next range that is
separated by holes.
And it only happens when we are trying to map range one by one range separately.

We need to check if the range is ram before clearing page table.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/mm/init_64.c |   37 ++++++++++++++++---------------------
 1 files changed, 16 insertions(+), 21 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index f40f383..61b3c44 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -363,20 +363,19 @@ static unsigned long __meminit
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
+			    !e820_any_mapped(addr & PAGE_MASK, next, 0))
+				set_pte(pte, __pte(0));
+			continue;
 		}
 
 		/*
@@ -418,16 +417,14 @@ phys_pmd_init(pmd_t *pmd_page, unsigned long address, unsigned long end,
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
+			    !e820_any_mapped(address & PMD_MASK, next, 0))
+				set_pmd(pmd, __pmd(0));
+			continue;
 		}
 
-		next = (address & PMD_MASK) + PMD_SIZE;
-
 		if (pmd_val(*pmd)) {
 			if (!pmd_large(*pmd)) {
 				spin_lock(&init_mm.page_table_lock);
@@ -494,13 +491,11 @@ phys_pud_init(pud_t *pud_page, unsigned long addr, unsigned long end,
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
+			    !e820_any_mapped(addr & PUD_MASK, next, 0))
+				set_pud(pud, __pud(0));
 			continue;
 		}
 
-- 
1.7.7

