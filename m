Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762747Ab2ERKvl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 06:51:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42836 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344Ab2ERKvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 06:51:38 -0400
Date: Fri, 18 May 2012 03:51:21 -0700
From: tip-bot for Jan Beulich <JBeulich@suse.com>
Message-ID: <tip-20167d3421a089a1bf1bd680b150dc69c9506810@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        jbeulich@suse.com, akpm@linux-foundation.org, JBeulich@suse.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        jbeulich@suse.com, akpm@linux-foundation.org, JBeulich@suse.com,
        tglx@linutronix.de
In-Reply-To: <4FB3C27202000078000841A0@nat28.tlf.novell.com>
References: <4FB3C27202000078000841A0@nat28.tlf.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86-64:
  Fix accounting in kernel_physical_mapping_init()
Git-Commit-ID: 20167d3421a089a1bf1bd680b150dc69c9506810
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 18 May 2012 03:51:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  20167d3421a089a1bf1bd680b150dc69c9506810
Gitweb:     http://git.kernel.org/tip/20167d3421a089a1bf1bd680b150dc69c9506810
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Wed, 16 May 2012 14:06:26 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 18 May 2012 10:13:37 +0200

x86-64: Fix accounting in kernel_physical_mapping_init()

When finding a present and acceptable 2M/1G mapping, the number
of pages mapped this way shouldn't be incremented (as it was
already incremented when the earlier part of the mapping was
established). Instead, last_map_addr needs to be updated in this
case.

Further, address increments were wrong in one place each in both
phys_pmd_init() and phys_pud_init() (lacking the aligning down
to the respective page boundary).

As we're now doing the same calculation several times, fold it
into a single instance using a local variable (matching how
kernel_physical_mapping_init() itself does it at the PGD level).

Observed during code inspection, not because of an actual
problem.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/4FB3C27202000078000841A0@nat28.tlf.novell.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/mm/init_64.c |   23 +++++++++++++----------
 1 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 436a030..f9476a0 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -408,12 +408,12 @@ static unsigned long __meminit
 phys_pmd_init(pmd_t *pmd_page, unsigned long address, unsigned long end,
 	      unsigned long page_size_mask, pgprot_t prot)
 {
-	unsigned long pages = 0;
+	unsigned long pages = 0, next;
 	unsigned long last_map_addr = end;
 
 	int i = pmd_index(address);
 
-	for (; i < PTRS_PER_PMD; i++, address += PMD_SIZE) {
+	for (; i < PTRS_PER_PMD; i++, address = next) {
 		unsigned long pte_phys;
 		pmd_t *pmd = pmd_page + pmd_index(address);
 		pte_t *pte;
@@ -427,6 +427,8 @@ phys_pmd_init(pmd_t *pmd_page, unsigned long address, unsigned long end,
 			break;
 		}
 
+		next = (address & PMD_MASK) + PMD_SIZE;
+
 		if (pmd_val(*pmd)) {
 			if (!pmd_large(*pmd)) {
 				spin_lock(&init_mm.page_table_lock);
@@ -450,7 +452,7 @@ phys_pmd_init(pmd_t *pmd_page, unsigned long address, unsigned long end,
 			 * attributes.
 			 */
 			if (page_size_mask & (1 << PG_LEVEL_2M)) {
-				pages++;
+				last_map_addr = next;
 				continue;
 			}
 			new_prot = pte_pgprot(pte_clrhuge(*(pte_t *)pmd));
@@ -463,7 +465,7 @@ phys_pmd_init(pmd_t *pmd_page, unsigned long address, unsigned long end,
 				pfn_pte(address >> PAGE_SHIFT,
 					__pgprot(pgprot_val(prot) | _PAGE_PSE)));
 			spin_unlock(&init_mm.page_table_lock);
-			last_map_addr = (address & PMD_MASK) + PMD_SIZE;
+			last_map_addr = next;
 			continue;
 		}
 
@@ -483,11 +485,11 @@ static unsigned long __meminit
 phys_pud_init(pud_t *pud_page, unsigned long addr, unsigned long end,
 			 unsigned long page_size_mask)
 {
-	unsigned long pages = 0;
+	unsigned long pages = 0, next;
 	unsigned long last_map_addr = end;
 	int i = pud_index(addr);
 
-	for (; i < PTRS_PER_PUD; i++, addr = (addr & PUD_MASK) + PUD_SIZE) {
+	for (; i < PTRS_PER_PUD; i++, addr = next) {
 		unsigned long pmd_phys;
 		pud_t *pud = pud_page + pud_index(addr);
 		pmd_t *pmd;
@@ -496,8 +498,9 @@ phys_pud_init(pud_t *pud_page, unsigned long addr, unsigned long end,
 		if (addr >= end)
 			break;
 
-		if (!after_bootmem &&
-				!e820_any_mapped(addr, addr+PUD_SIZE, 0)) {
+		next = (addr & PUD_MASK) + PUD_SIZE;
+
+		if (!after_bootmem && !e820_any_mapped(addr, next, 0)) {
 			set_pud(pud, __pud(0));
 			continue;
 		}
@@ -524,7 +527,7 @@ phys_pud_init(pud_t *pud_page, unsigned long addr, unsigned long end,
 			 * attributes.
 			 */
 			if (page_size_mask & (1 << PG_LEVEL_1G)) {
-				pages++;
+				last_map_addr = next;
 				continue;
 			}
 			prot = pte_pgprot(pte_clrhuge(*(pte_t *)pud));
@@ -536,7 +539,7 @@ phys_pud_init(pud_t *pud_page, unsigned long addr, unsigned long end,
 			set_pte((pte_t *)pud,
 				pfn_pte(addr >> PAGE_SHIFT, PAGE_KERNEL_LARGE));
 			spin_unlock(&init_mm.page_table_lock);
-			last_map_addr = (addr & PUD_MASK) + PUD_SIZE;
+			last_map_addr = next;
 			continue;
 		}
 
