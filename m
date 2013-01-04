Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394Ab3ADAzF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 19:55:05 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:26789 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754575Ab3ADAtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 19:49:45 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Alexander Duyck <alexander.h.duyck@intel.com>
Subject: [PATCH v7u1 09/31] x86, 64bit: #PF handler set page to cover 2M only
Date: Thu,  3 Jan 2013 16:48:29 -0800
Message-Id: <1357260531-11115-10-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now #PF hanlder could map 1G per #PF, That causes same problem that
is fixed by
	x86, mm: Only direct map addresses that are marked as E820_RAM

only add one 2M mapping instead of 1G accessing one time for dynamically
per #PF.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Alexander Duyck <alexander.h.duyck@intel.com>
---
 arch/x86/kernel/head64.c |   42 +++++++++++++++++++++++++-----------------
 1 file changed, 25 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 25591f9..a3fc233 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -52,15 +52,15 @@ int __init early_make_pgtable(unsigned long address)
 	unsigned long physaddr = address - __PAGE_OFFSET;
 	unsigned long i;
 	pgdval_t pgd, *pgd_p;
-	pudval_t *pud_p;
+	pudval_t pud, *pud_p;
 	pmdval_t pmd, *pmd_p;
 
 	/* Invalid address or early pgt is done ?  */
 	if (physaddr >= MAXMEM || read_cr3() != __pa(early_level4_pgt))
 		return -1;
 
-	i = (address >> PGDIR_SHIFT) & (PTRS_PER_PGD - 1);
-	pgd_p = &early_level4_pgt[i].pgd;
+again:
+	pgd_p = &early_level4_pgt[pgd_index(address)].pgd;
 	pgd = *pgd_p;
 
 	/*
@@ -68,29 +68,37 @@ int __init early_make_pgtable(unsigned long address)
 	 * critical -- __PAGE_OFFSET would point us back into the dynamic
 	 * range and we might end up looping forever...
 	 */
-	if (pgd && next_early_pgt < EARLY_DYNAMIC_PAGE_TABLES) {
+	if (pgd)
 		pud_p = (pudval_t *)((pgd & PTE_PFN_MASK) + __START_KERNEL_map - phys_base);
-	} else {
-		if (next_early_pgt >= EARLY_DYNAMIC_PAGE_TABLES-1)
+	else {
+		if (next_early_pgt >= EARLY_DYNAMIC_PAGE_TABLES) {
 			reset_early_page_tables();
+			goto again;
+		}
 
 		pud_p = (pudval_t *)early_dynamic_pgts[next_early_pgt++];
 		for (i = 0; i < PTRS_PER_PUD; i++)
 			pud_p[i] = 0;
-
 		*pgd_p = (pgdval_t)pud_p - __START_KERNEL_map + phys_base + _KERNPG_TABLE;
 	}
-	i = (address >> PUD_SHIFT) & (PTRS_PER_PUD - 1);
-	pud_p += i;
-
-	pmd_p = (pmdval_t *)early_dynamic_pgts[next_early_pgt++];
-	pmd = (physaddr & PUD_MASK) + (__PAGE_KERNEL_LARGE & ~_PAGE_GLOBAL);
-	for (i = 0; i < PTRS_PER_PMD; i++) {
-		pmd_p[i] = pmd;
-		pmd += PMD_SIZE;
-	}
+	pud_p += pud_index(address);
+	pud = *pud_p;
 
-	*pud_p = (pudval_t)pmd_p - __START_KERNEL_map + phys_base + _KERNPG_TABLE;
+	if (pud)
+		pmd_p = (pmdval_t *)((pud & PTE_PFN_MASK) + __START_KERNEL_map - phys_base);
+	else {
+		if (next_early_pgt >= EARLY_DYNAMIC_PAGE_TABLES) {
+			reset_early_page_tables();
+			goto again;
+		}
+
+		pmd_p = (pmdval_t *)early_dynamic_pgts[next_early_pgt++];
+		for (i = 0; i < PTRS_PER_PMD; i++)
+			pmd_p[i] = 0;
+		*pud_p = (pudval_t)pmd_p - __START_KERNEL_map + phys_base + _KERNPG_TABLE;
+	}
+	pmd = (physaddr & PMD_MASK) + (__PAGE_KERNEL_LARGE & ~_PAGE_GLOBAL);
+	pmd_p[pmd_index(address)] = pmd;
 
 	return 0;
 }
-- 
1.7.10.4

