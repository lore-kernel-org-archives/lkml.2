Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503Ab2KLVeG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 16:34:06 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:24576 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013Ab2KLVT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 16:19:29 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 06/46] x86, mm: Change find_early_table_space() paramters
Date: Mon, 12 Nov 2012 13:18:02 -0800
Message-Id: <1352755122-25660-7-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1352755122-25660-1-git-send-email-yinghai@kernel.org>
References: <20121112193044.GA11615@phenom.dumpdata.com>
 <1352755122-25660-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

call split_mem_range inside the function.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/mm/init.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 8f57b12..00089bf 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -196,12 +196,18 @@ static int __meminit split_mem_range(struct map_range *mr, int nr_range,
  * mr[0].start to mr[nr_range - 1].end, while accounting for possible 2M and 1GB
  * pages. Then find enough contiguous space for those page tables.
  */
-static void __init find_early_table_space(struct map_range *mr, int nr_range)
+static void __init find_early_table_space(unsigned long start, unsigned long end)
 {
 	int i;
 	unsigned long puds = 0, pmds = 0, ptes = 0, tables;
-	unsigned long start = 0, good_end;
+	unsigned long good_end;
 	phys_addr_t base;
+	struct map_range mr[NR_RANGE_MR];
+	int nr_range;
+
+	memset(mr, 0, sizeof(mr));
+	nr_range = 0;
+	nr_range = split_mem_range(mr, nr_range, start, end);
 
 	for (i = 0; i < nr_range; i++) {
 		unsigned long range, extra;
@@ -277,7 +283,7 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	 * nodes are discovered.
 	 */
 	if (!after_bootmem)
-		find_early_table_space(mr, nr_range);
+		find_early_table_space(start, end);
 
 	for (i = 0; i < nr_range; i++)
 		ret = kernel_physical_mapping_init(mr[i].start, mr[i].end,
-- 
1.7.7

