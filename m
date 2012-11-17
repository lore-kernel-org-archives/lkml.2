Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981Ab2KQDkt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 22:40:49 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:27475 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754209Ab2KQDkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 22:40:41 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v8 35/46] x86, mm: use round_up/down in split_mem_range()
Date: Fri, 16 Nov 2012 19:39:12 -0800
Message-Id: <1353123563-3103-36-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1353123563-3103-1-git-send-email-yinghai@kernel.org>
References: <1353123563-3103-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

to replace own inline version for those roundup and rounddown.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/mm/init.c |   30 ++++++++++++------------------
 1 files changed, 12 insertions(+), 18 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 8168bf8..0e625e6 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -218,13 +218,11 @@ static int __meminit split_mem_range(struct map_range *mr, int nr_range,
 	 * slowdowns.
 	 */
 	if (pos == 0)
-		end_pfn = 1<<(PMD_SHIFT - PAGE_SHIFT);
+		end_pfn = PMD_SIZE >> PAGE_SHIFT;
 	else
-		end_pfn = ((pos + (PMD_SIZE - 1))>>PMD_SHIFT)
-				 << (PMD_SHIFT - PAGE_SHIFT);
+		end_pfn = round_up(pos, PMD_SIZE) >> PAGE_SHIFT;
 #else /* CONFIG_X86_64 */
-	end_pfn = ((pos + (PMD_SIZE - 1)) >> PMD_SHIFT)
-			<< (PMD_SHIFT - PAGE_SHIFT);
+	end_pfn = round_up(pos, PMD_SIZE) >> PAGE_SHIFT;
 #endif
 	if (end_pfn > (end >> PAGE_SHIFT))
 		end_pfn = end >> PAGE_SHIFT;
@@ -234,15 +232,13 @@ static int __meminit split_mem_range(struct map_range *mr, int nr_range,
 	}
 
 	/* big page (2M) range */
-	start_pfn = ((pos + (PMD_SIZE - 1))>>PMD_SHIFT)
-			 << (PMD_SHIFT - PAGE_SHIFT);
+	start_pfn = round_up(pos, PMD_SIZE) >> PAGE_SHIFT;
 #ifdef CONFIG_X86_32
-	end_pfn = (end>>PMD_SHIFT) << (PMD_SHIFT - PAGE_SHIFT);
+	end_pfn = round_down(end, PMD_SIZE) >> PAGE_SHIFT;
 #else /* CONFIG_X86_64 */
-	end_pfn = ((pos + (PUD_SIZE - 1))>>PUD_SHIFT)
-			 << (PUD_SHIFT - PAGE_SHIFT);
-	if (end_pfn > ((end>>PMD_SHIFT)<<(PMD_SHIFT - PAGE_SHIFT)))
-		end_pfn = ((end>>PMD_SHIFT)<<(PMD_SHIFT - PAGE_SHIFT));
+	end_pfn = round_up(pos, PUD_SIZE) >> PAGE_SHIFT;
+	if (end_pfn > (round_down(end, PMD_SIZE) >> PAGE_SHIFT))
+		end_pfn = round_down(end, PMD_SIZE) >> PAGE_SHIFT;
 #endif
 
 	if (start_pfn < end_pfn) {
@@ -253,9 +249,8 @@ static int __meminit split_mem_range(struct map_range *mr, int nr_range,
 
 #ifdef CONFIG_X86_64
 	/* big page (1G) range */
-	start_pfn = ((pos + (PUD_SIZE - 1))>>PUD_SHIFT)
-			 << (PUD_SHIFT - PAGE_SHIFT);
-	end_pfn = (end >> PUD_SHIFT) << (PUD_SHIFT - PAGE_SHIFT);
+	start_pfn = round_up(pos, PUD_SIZE) >> PAGE_SHIFT;
+	end_pfn = round_down(end, PUD_SIZE) >> PAGE_SHIFT;
 	if (start_pfn < end_pfn) {
 		nr_range = save_mr(mr, nr_range, start_pfn, end_pfn,
 				page_size_mask &
@@ -264,9 +259,8 @@ static int __meminit split_mem_range(struct map_range *mr, int nr_range,
 	}
 
 	/* tail is not big page (1G) alignment */
-	start_pfn = ((pos + (PMD_SIZE - 1))>>PMD_SHIFT)
-			 << (PMD_SHIFT - PAGE_SHIFT);
-	end_pfn = (end >> PMD_SHIFT) << (PMD_SHIFT - PAGE_SHIFT);
+	start_pfn = round_up(pos, PMD_SIZE) >> PAGE_SHIFT;
+	end_pfn = round_down(end, PMD_SIZE) >> PAGE_SHIFT;
 	if (start_pfn < end_pfn) {
 		nr_range = save_mr(mr, nr_range, start_pfn, end_pfn,
 				page_size_mask & (1<<PG_LEVEL_2M));
-- 
1.7.7

