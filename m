Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308Ab2KQDkz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 22:40:55 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:27539 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754287Ab2KQDkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 22:40:53 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v8 38/46] x86, mm: use limit_pfn for end pfn
Date: Fri, 16 Nov 2012 19:39:15 -0800
Message-Id: <1353123563-3103-39-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1353123563-3103-1-git-send-email-yinghai@kernel.org>
References: <1353123563-3103-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

instead of shifting end to get that.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/mm/init.c |   20 +++++++++++---------
 1 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 4bf1c53..f410dc6 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -203,10 +203,12 @@ static int __meminit split_mem_range(struct map_range *mr, int nr_range,
 				     unsigned long start,
 				     unsigned long end)
 {
-	unsigned long start_pfn, end_pfn;
+	unsigned long start_pfn, end_pfn, limit_pfn;
 	unsigned long pfn;
 	int i;
 
+	limit_pfn = PFN_DOWN(end);
+
 	/* head if not big page alignment ? */
 	pfn = start_pfn = PFN_DOWN(start);
 #ifdef CONFIG_X86_32
@@ -223,8 +225,8 @@ static int __meminit split_mem_range(struct map_range *mr, int nr_range,
 #else /* CONFIG_X86_64 */
 	end_pfn = round_up(pfn, PFN_DOWN(PMD_SIZE));
 #endif
-	if (end_pfn > PFN_DOWN(end))
-		end_pfn = PFN_DOWN(end);
+	if (end_pfn > limit_pfn)
+		end_pfn = limit_pfn;
 	if (start_pfn < end_pfn) {
 		nr_range = save_mr(mr, nr_range, start_pfn, end_pfn, 0);
 		pfn = end_pfn;
@@ -233,11 +235,11 @@ static int __meminit split_mem_range(struct map_range *mr, int nr_range,
 	/* big page (2M) range */
 	start_pfn = round_up(pfn, PFN_DOWN(PMD_SIZE));
 #ifdef CONFIG_X86_32
-	end_pfn = PFN_DOWN(round_down(end, PMD_SIZE));
+	end_pfn = round_down(limit_pfn, PFN_DOWN(PMD_SIZE));
 #else /* CONFIG_X86_64 */
 	end_pfn = round_up(pfn, PFN_DOWN(PUD_SIZE));
-	if (end_pfn > PFN_DOWN(round_down(end, PMD_SIZE)))
-		end_pfn = PFN_DOWN(round_down(end, PMD_SIZE));
+	if (end_pfn > round_down(limit_pfn, PFN_DOWN(PMD_SIZE)))
+		end_pfn = round_down(limit_pfn, PFN_DOWN(PMD_SIZE));
 #endif
 
 	if (start_pfn < end_pfn) {
@@ -249,7 +251,7 @@ static int __meminit split_mem_range(struct map_range *mr, int nr_range,
 #ifdef CONFIG_X86_64
 	/* big page (1G) range */
 	start_pfn = round_up(pfn, PFN_DOWN(PUD_SIZE));
-	end_pfn = PFN_DOWN(round_down(end, PUD_SIZE));
+	end_pfn = round_down(limit_pfn, PFN_DOWN(PUD_SIZE));
 	if (start_pfn < end_pfn) {
 		nr_range = save_mr(mr, nr_range, start_pfn, end_pfn,
 				page_size_mask &
@@ -259,7 +261,7 @@ static int __meminit split_mem_range(struct map_range *mr, int nr_range,
 
 	/* tail is not big page (1G) alignment */
 	start_pfn = round_up(pfn, PFN_DOWN(PMD_SIZE));
-	end_pfn = PFN_DOWN(round_down(end, PMD_SIZE));
+	end_pfn = round_down(limit_pfn, PFN_DOWN(PMD_SIZE));
 	if (start_pfn < end_pfn) {
 		nr_range = save_mr(mr, nr_range, start_pfn, end_pfn,
 				page_size_mask & (1<<PG_LEVEL_2M));
@@ -269,7 +271,7 @@ static int __meminit split_mem_range(struct map_range *mr, int nr_range,
 
 	/* tail is not big page (2M) alignment */
 	start_pfn = pfn;
-	end_pfn = PFN_DOWN(end);
+	end_pfn = limit_pfn;
 	nr_range = save_mr(mr, nr_range, start_pfn, end_pfn, 0);
 
 	/* try to merge same page size and continuous */
-- 
1.7.7

