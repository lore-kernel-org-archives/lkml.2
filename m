Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488Ab3ADA5E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 19:57:04 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:30162 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753908Ab3ADAt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 19:49:29 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v7u1 02/31] x86, 64bit, mm: make pgd next calculation consistent with pud/pmd
Date: Thu,  3 Jan 2013 16:48:22 -0800
Message-Id: <1357260531-11115-3-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just like the way we calculate next for pud and pmd, aka
round down and add size.

Also, do not do boundary-checking with 'next', and just pass 'end' down
to phys_pud_init() instead. Because the loop in phys_pud_init() stops at
PTRS_PER_PUD and thus can handle a possibly bigger 'end' properly.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/mm/init_64.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 167439c..b1178eb 100644
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

