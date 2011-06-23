Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759250Ab1FWLK3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 07:10:29 -0400
Received: from smtp.citrix.com ([66.165.176.89]:46728 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754214Ab1FWLK2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 07:10:28 -0400
X-IronPort-AV: E=Sophos;i="4.65,412,1304308800"; 
   d="scan'208";a="14760562"
From: <stefano.stabellini@eu.citrix.com>
To: hpa@zytor.com
CC: hpa@linux.intel.com, konrad.wilk@oracle.com, mingo@elte.hu,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Stefano.Stabellini@eu.citrix.com, yinghai@kernel.org,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH] x86_64: do not assume head_64.S used 4KB pages when !use_pse
Date: Thu, 23 Jun 2011 12:14:25 +0100
Message-ID: <1308827665-28890-1-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

head_64.S, which sets up the initial page table on x86_64, is not aware
of PSE being enabled or disabled and it always allocates the initial
mapping using 2MB pages.

Therefore on x86_64 find_early_table_space shouldn't update the amount
of pages needed for pte pages depending on the size of the initial
mapping, because we know for sure that no pte pages have been allocated
yet.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Reported-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/init.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 36bacfe..1e3098b 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -42,12 +42,19 @@ static void __init find_early_table_space(unsigned long start,
 			(PMD_SIZE * PTRS_PER_PMD));
 	pmd_mapped *= (PMD_SIZE * PTRS_PER_PMD);
 
+	/* 
+	 * On x86_64 do not limit the size we need to cover with 4KB pages
+	 * depending on the initial allocation because head_64.S always uses
+	 * 2MB pages.
+	 */
+#ifdef CONFIG_X86_32
 	if (start < PFN_PHYS(max_pfn_mapped)) {
 		if (PFN_PHYS(max_pfn_mapped) < end)
 			size -= PFN_PHYS(max_pfn_mapped) - start;
 		else
 			size = 0;
 	}
+#endif
 
 #ifndef __PAGETABLE_PUD_FOLDED
 	if (end > pud_mapped) {
-- 
1.7.2.3

