Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242Ab2K1Vsp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 16:48:45 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:36928 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755752Ab2K1Vsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 16:48:40 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v9 37/46] x86, mm: use pfn instead of pos in split_mem_range
Date: Wed, 28 Nov 2012 13:47:48 -0800
Message-Id: <1354139277-17376-38-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1354139277-17376-1-git-send-email-yinghai@kernel.org>
References: <1354139277-17376-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

could save some bit shifting operations.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/mm/init.c |   29 ++++++++++++++---------------
 1 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 15fdaba..dd4e98d 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -204,12 +204,11 @@ static int __meminit split_mem_range(struct map_range *mr, int nr_range,
 				     unsigned long end)
 {
 	unsigned long start_pfn, end_pfn;
-	unsigned long pos;
+	unsigned long pfn;
 	int i;
 
 	/* head if not big page alignment ? */
-	start_pfn = PFN_DOWN(start);
-	pos = PFN_PHYS(start_pfn);
+	pfn = start_pfn = PFN_DOWN(start);
 #ifdef CONFIG_X86_32
 	/*
 	 * Don't use a large page for the first 2/4MB of memory
@@ -217,26 +216,26 @@ static int __meminit split_mem_range(struct map_range *mr, int nr_range,
 	 * and overlapping MTRRs into large pages can cause
 	 * slowdowns.
 	 */
-	if (pos == 0)
+	if (pfn == 0)
 		end_pfn = PFN_DOWN(PMD_SIZE);
 	else
-		end_pfn = PFN_DOWN(round_up(pos, PMD_SIZE));
+		end_pfn = round_up(pfn, PFN_DOWN(PMD_SIZE));
 #else /* CONFIG_X86_64 */
-	end_pfn = PFN_DOWN(round_up(pos, PMD_SIZE));
+	end_pfn = round_up(pfn, PFN_DOWN(PMD_SIZE));
 #endif
 	if (end_pfn > PFN_DOWN(end))
 		end_pfn = PFN_DOWN(end);
 	if (start_pfn < end_pfn) {
 		nr_range = save_mr(mr, nr_range, start_pfn, end_pfn, 0);
-		pos = PFN_PHYS(end_pfn);
+		pfn = end_pfn;
 	}
 
 	/* big page (2M) range */
-	start_pfn = PFN_DOWN(round_up(pos, PMD_SIZE));
+	start_pfn = round_up(pfn, PFN_DOWN(PMD_SIZE));
 #ifdef CONFIG_X86_32
 	end_pfn = PFN_DOWN(round_down(end, PMD_SIZE));
 #else /* CONFIG_X86_64 */
-	end_pfn = PFN_DOWN(round_up(pos, PUD_SIZE));
+	end_pfn = round_up(pfn, PFN_DOWN(PUD_SIZE));
 	if (end_pfn > PFN_DOWN(round_down(end, PMD_SIZE)))
 		end_pfn = PFN_DOWN(round_down(end, PMD_SIZE));
 #endif
@@ -244,32 +243,32 @@ static int __meminit split_mem_range(struct map_range *mr, int nr_range,
 	if (start_pfn < end_pfn) {
 		nr_range = save_mr(mr, nr_range, start_pfn, end_pfn,
 				page_size_mask & (1<<PG_LEVEL_2M));
-		pos = PFN_PHYS(end_pfn);
+		pfn = end_pfn;
 	}
 
 #ifdef CONFIG_X86_64
 	/* big page (1G) range */
-	start_pfn = PFN_DOWN(round_up(pos, PUD_SIZE));
+	start_pfn = round_up(pfn, PFN_DOWN(PUD_SIZE));
 	end_pfn = PFN_DOWN(round_down(end, PUD_SIZE));
 	if (start_pfn < end_pfn) {
 		nr_range = save_mr(mr, nr_range, start_pfn, end_pfn,
 				page_size_mask &
 				 ((1<<PG_LEVEL_2M)|(1<<PG_LEVEL_1G)));
-		pos = PFN_PHYS(end_pfn);
+		pfn = end_pfn;
 	}
 
 	/* tail is not big page (1G) alignment */
-	start_pfn = PFN_DOWN(round_up(pos, PMD_SIZE));
+	start_pfn = round_up(pfn, PFN_DOWN(PMD_SIZE));
 	end_pfn = PFN_DOWN(round_down(end, PMD_SIZE));
 	if (start_pfn < end_pfn) {
 		nr_range = save_mr(mr, nr_range, start_pfn, end_pfn,
 				page_size_mask & (1<<PG_LEVEL_2M));
-		pos = PFN_PHYS(end_pfn);
+		pfn = end_pfn;
 	}
 #endif
 
 	/* tail is not big page (2M) alignment */
-	start_pfn = PFN_DOWN(pos);
+	start_pfn = pfn;
 	end_pfn = PFN_DOWN(end);
 	nr_range = save_mr(mr, nr_range, start_pfn, end_pfn, 0);
 
-- 
1.7.7

