Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667Ab2LMWCx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 17:02:53 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:50425 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756460Ab2LMWCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 17:02:48 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v6 02/27] x86, mm: make pgd next calculation consistent with pud/pmd
Date: Thu, 13 Dec 2012 14:01:56 -0800
Message-Id: <1355436141-8668-3-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1355436141-8668-1-git-send-email-yinghai@kernel.org>
References: <1355436141-8668-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just like PUD_SIZE, and PMD_SIZE next calculation, aka
round down and add size.

also remove not need next checking, just pass end instead.
later phys_pud_init uses PTRS_PER_PUD checking to exit early
if end is too big.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/mm/init_64.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 4178530..91f116a 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -530,9 +530,7 @@ kernel_physical_mapping_init(unsigned long start,
 		pgd_t *pgd = pgd_offset_k(start);
 		pud_t *pud;
 
-		next = (start + PGDIR_SIZE) & PGDIR_MASK;
-		if (next > end)
-			next = end;
+		next = (start & PGDIR_MASK) + PGDIR_SIZE;
 
 		if (pgd_val(*pgd)) {
 			pud = (pud_t *)pgd_page_vaddr(*pgd);
@@ -542,7 +540,7 @@ kernel_physical_mapping_init(unsigned long start,
 		}
 
 		pud = alloc_low_page();
-		last_map_addr = phys_pud_init(pud, __pa(start), __pa(next),
+		last_map_addr = phys_pud_init(pud, __pa(start), __pa(end),
 						 page_size_mask);
 
 		spin_lock(&init_mm.page_table_lock);
-- 
1.7.10.4

