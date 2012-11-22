Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964928Ab2KVS6l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:58:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37038 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964892Ab2KVS6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:58:37 -0500
Date: Wed, 21 Nov 2012 17:57:11 -0800
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Message-ID: <tip-eceb3632ac85bc08fc27f7fc9ab85672681b2635@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1353123563-3103-20-git-send-email-yinghai@kernel.org>
References: <1353123563-3103-20-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm2] x86, mm: Don't clear page table if range is ram
Git-Commit-ID: eceb3632ac85bc08fc27f7fc9ab85672681b2635
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 21 Nov 2012 17:57:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  eceb3632ac85bc08fc27f7fc9ab85672681b2635
Gitweb:     http://git.kernel.org/tip/eceb3632ac85bc08fc27f7fc9ab85672681b2635
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Fri, 16 Nov 2012 19:38:56 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sat, 17 Nov 2012 11:59:17 -0800

x86, mm: Don't clear page table if range is ram

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
Link: http://lkml.kernel.org/r/1353123563-3103-20-git-send-email-yinghai@kernel.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/init_64.c | 40 +++++++++++++++++++---------------------
 1 file changed, 19 insertions(+), 21 deletions(-)

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
 
