Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425Ab2KQDnl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 22:43:41 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:16892 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754212Ab2KQDko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 22:40:44 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v8 36/46] x86, mm: use PFN_DOWN in split_mem_range()
Date: Fri, 16 Nov 2012 19:39:13 -0800
Message-Id: <1353123563-3103-37-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1353123563-3103-1-git-send-email-yinghai@kernel.org>
References: <1353123563-3103-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

to replace own inline version for shifting.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/mm/init.c |   44 ++++++++++++++++++++++----------------------
 1 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 0e625e6..1cca052 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -208,8 +208,8 @@ static int __meminit split_mem_range(struct map_range *mr, int nr_range,
 	int i;
 
 	/* head if not big page alignment ? */
-	start_pfn = start >> PAGE_SHIFT;
-	pos = start_pfn << PAGE_SHIFT;
+	start_pfn = PFN_DOWN(start);
+	pos = PFN_PHYS(start_pfn);
 #ifdef CONFIG_X86_32
 	/*
 	 * Don't use a large page for the first 2/4MB of memory
@@ -218,59 +218,59 @@ static int __meminit split_mem_range(struct map_range *mr, int nr_range,
 	 * slowdowns.
 	 */
 	if (pos == 0)
-		end_pfn = PMD_SIZE >> PAGE_SHIFT;
+		end_pfn = PFN_DOWN(PMD_SIZE);
 	else
-		end_pfn = round_up(pos, PMD_SIZE) >> PAGE_SHIFT;
+		end_pfn = PFN_DOWN(round_up(pos, PMD_SIZE));
 #else /* CONFIG_X86_64 */
-	end_pfn = round_up(pos, PMD_SIZE) >> PAGE_SHIFT;
+	end_pfn = PFN_DOWN(round_up(pos, PMD_SIZE));
 #endif
-	if (end_pfn > (end >> PAGE_SHIFT))
-		end_pfn = end >> PAGE_SHIFT;
+	if (end_pfn > PFN_DOWN(end))
+		end_pfn = PFN_DOWN(end);
 	if (start_pfn < end_pfn) {
 		nr_range = save_mr(mr, nr_range, start_pfn, end_pfn, 0);
-		pos = end_pfn << PAGE_SHIFT;
+		pos = PFN_PHYS(end_pfn);
 	}
 
 	/* big page (2M) range */
-	start_pfn = round_up(pos, PMD_SIZE) >> PAGE_SHIFT;
+	start_pfn = PFN_DOWN(round_up(pos, PMD_SIZE));
 #ifdef CONFIG_X86_32
-	end_pfn = round_down(end, PMD_SIZE) >> PAGE_SHIFT;
+	end_pfn = PFN_DOWN(round_down(end, PMD_SIZE));
 #else /* CONFIG_X86_64 */
-	end_pfn = round_up(pos, PUD_SIZE) >> PAGE_SHIFT;
-	if (end_pfn > (round_down(end, PMD_SIZE) >> PAGE_SHIFT))
-		end_pfn = round_down(end, PMD_SIZE) >> PAGE_SHIFT;
+	end_pfn = PFN_DOWN(round_up(pos, PUD_SIZE));
+	if (end_pfn > PFN_DOWN(round_down(end, PMD_SIZE)))
+		end_pfn = PFN_DOWN(round_down(end, PMD_SIZE));
 #endif
 
 	if (start_pfn < end_pfn) {
 		nr_range = save_mr(mr, nr_range, start_pfn, end_pfn,
 				page_size_mask & (1<<PG_LEVEL_2M));
-		pos = end_pfn << PAGE_SHIFT;
+		pos = PFN_PHYS(end_pfn);
 	}
 
 #ifdef CONFIG_X86_64
 	/* big page (1G) range */
-	start_pfn = round_up(pos, PUD_SIZE) >> PAGE_SHIFT;
-	end_pfn = round_down(end, PUD_SIZE) >> PAGE_SHIFT;
+	start_pfn = PFN_DOWN(round_up(pos, PUD_SIZE));
+	end_pfn = PFN_DOWN(round_down(end, PUD_SIZE));
 	if (start_pfn < end_pfn) {
 		nr_range = save_mr(mr, nr_range, start_pfn, end_pfn,
 				page_size_mask &
 				 ((1<<PG_LEVEL_2M)|(1<<PG_LEVEL_1G)));
-		pos = end_pfn << PAGE_SHIFT;
+		pos = PFN_PHYS(end_pfn);
 	}
 
 	/* tail is not big page (1G) alignment */
-	start_pfn = round_up(pos, PMD_SIZE) >> PAGE_SHIFT;
-	end_pfn = round_down(end, PMD_SIZE) >> PAGE_SHIFT;
+	start_pfn = PFN_DOWN(round_up(pos, PMD_SIZE));
+	end_pfn = PFN_DOWN(round_down(end, PMD_SIZE));
 	if (start_pfn < end_pfn) {
 		nr_range = save_mr(mr, nr_range, start_pfn, end_pfn,
 				page_size_mask & (1<<PG_LEVEL_2M));
-		pos = end_pfn << PAGE_SHIFT;
+		pos = PFN_PHYS(end_pfn);
 	}
 #endif
 
 	/* tail is not big page (2M) alignment */
-	start_pfn = pos>>PAGE_SHIFT;
-	end_pfn = end>>PAGE_SHIFT;
+	start_pfn = PFN_DOWN(pos);
+	end_pfn = PFN_DOWN(end);
 	nr_range = save_mr(mr, nr_range, start_pfn, end_pfn, 0);
 
 	/* try to merge same page size and continuous */
-- 
1.7.7

