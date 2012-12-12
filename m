Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782Ab2LLCCZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 21:02:25 -0500
Received: from mail-da0-f51.google.com ([209.85.210.51]:34974 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753847Ab2LLCCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 21:02:24 -0500
X-Greylist: delayed 797 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Dec 2012 21:02:24 EST
From: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        linux-arm-kernel@lists.infradead.org (moderated list:ARM PORT)
Subject: [PATCH] ARM: mm: Split memory banks that span multiple sections when sparsemem is enabled
Date: Tue, 11 Dec 2012 17:37:53 -0800
Message-Id: <1355276275-17859-1-git-send-email-arve@android.com>
X-Mailer: git-send-email 1.7.7.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a crash in mem_init which assumes all pages in a memory bank
are part of the same page array.

Signed-off-by: Arve Hjønnevåg <arve@android.com>
---
 arch/arm/mm/mmu.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index 941dfb9..516956c 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -917,6 +917,28 @@ void __init sanity_check_meminfo(void)
 		struct membank *bank = &meminfo.bank[j];
 		*bank = meminfo.bank[i];
 
+#ifdef CONFIG_SPARSEMEM
+		if (pfn_to_section_nr(bank_pfn_start(bank)) !=
+		    pfn_to_section_nr(bank_pfn_end(bank) - 1)) {
+			phys_addr_t sz;
+			unsigned long start_pfn = bank_pfn_start(bank);
+			unsigned long end_pfn = SECTION_ALIGN_UP(start_pfn + 1);
+			sz = ((phys_addr_t)(end_pfn - start_pfn) << PAGE_SHIFT);
+			
+			if (meminfo.nr_banks >= NR_BANKS) {
+				pr_crit("NR_BANKS too low, ignoring %lld bytes of memory\n",
+					(unsigned long long)(bank->size - sz));
+			} else {
+				memmove(bank + 1, bank,
+					(meminfo.nr_banks - i) * sizeof(*bank));
+				meminfo.nr_banks++;
+				bank[1].size -= sz;
+				bank[1].start = __pfn_to_phys(end_pfn);
+			}
+			bank->size = sz;
+		}
+#endif
+
 		if (bank->start > ULONG_MAX)
 			highmem = 1;
 
-- 
1.7.7.3

