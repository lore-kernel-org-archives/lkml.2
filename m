Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751929Ab2JIEj7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 00:39:59 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:45153 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404Ab2JIEj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 00:39:57 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 02/10] x86, mm: Use big page size for small memory range
Date: Mon,  8 Oct 2012 21:39:10 -0700
Message-Id: <1349757558-10856-3-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1349757558-10856-1-git-send-email-yinghai@kernel.org>
References: <1349757558-10856-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We could map small range in the middle of big range at first, so should use
big page size at first to avoid using small page size to break down page table.

Only can set big page bit when that range has big ram area around it.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/mm/init.c |   32 ++++++++++++++++++++++++++++++++
 1 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index cf662ba..0c58f2d 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -88,6 +88,35 @@ static int __meminit save_mr(struct map_range *mr, int nr_range,
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
@@ -182,6 +211,9 @@ static int __meminit split_mem_range(struct map_range *mr, int nr_range,
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

