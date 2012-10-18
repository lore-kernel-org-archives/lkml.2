Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756705Ab2JRUvY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 16:51:24 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:42628 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756445Ab2JRUvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 16:51:13 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 02/19] x86, mm: Use big page size for small memory range
Date: Thu, 18 Oct 2012 13:50:12 -0700
Message-Id: <1350593430-24470-5-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1350593430-24470-1-git-send-email-yinghai@kernel.org>
References: <1350593430-24470-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We could map small range in the middle of big range at first, so should use
big page size at first to avoid using small page size to break down page table.

Only can set big page bit when that range has ram area around it.

-v2: fix 32bit boundary checking. We can not count ram above max_low_pfn
	for 32 bit.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/mm/init.c |   37 +++++++++++++++++++++++++++++++++++++
 1 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index c12dfd5..09ce38f 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -88,6 +88,40 @@ static int __meminit save_mr(struct map_range *mr, int nr_range,
 	return nr_range;
 }
 
+/*
+ * adjust the page_size_mask for small range to go with
+ *	big page size instead small one if nearby are ram too.
+ */
+static void __init_refok adjust_range_page_size_mask(struct map_range *mr,
+							 int nr_range)
+{
+	int i;
+
+	for (i = 0; i < nr_range; i++) {
+		if ((page_size_mask & (1<<PG_LEVEL_2M)) &&
+		    !(mr[i].page_size_mask & (1<<PG_LEVEL_2M))) {
+			unsigned long start = round_down(mr[i].start, PMD_SIZE);
+			unsigned long end = round_up(mr[i].end, PMD_SIZE);
+
+#ifdef CONFIG_X86_32
+			if ((end >> PAGE_SHIFT) > max_low_pfn)
+				continue;
+#endif
+
+			if (memblock_is_region_memory(start, end - start))
+				mr[i].page_size_mask |= 1<<PG_LEVEL_2M;
+		}
+		if ((page_size_mask & (1<<PG_LEVEL_1G)) &&
+		    !(mr[i].page_size_mask & (1<<PG_LEVEL_1G))) {
+			unsigned long start = round_down(mr[i].start, PUD_SIZE);
+			unsigned long end = round_up(mr[i].end, PUD_SIZE);
+
+			if (memblock_is_region_memory(start, end - start))
+				mr[i].page_size_mask |= 1<<PG_LEVEL_1G;
+		}
+	}
+}
+
 static int __meminit split_mem_range(struct map_range *mr, int nr_range,
 				     unsigned long start,
 				     unsigned long end)
@@ -182,6 +216,9 @@ static int __meminit split_mem_range(struct map_range *mr, int nr_range,
 		nr_range--;
 	}
 
+	if (!after_bootmem)
+		adjust_range_page_size_mask(mr, nr_range);
+
 	for (i = 0; i < nr_range; i++)
 		printk(KERN_DEBUG " [mem %#010lx-%#010lx] page %s\n",
 				mr[i].start, mr[i].end - 1,
-- 
1.7.7

