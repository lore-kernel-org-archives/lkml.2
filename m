Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198Ab2KLVUU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 16:20:20 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:36311 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125Ab2KLVTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 16:19:41 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 02/46] x86, mm: Split out split_mem_range from init_memory_mapping
Date: Mon, 12 Nov 2012 13:17:58 -0800
Message-Id: <1352755122-25660-3-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1352755122-25660-1-git-send-email-yinghai@kernel.org>
References: <20121112193044.GA11615@phenom.dumpdata.com>
 <1352755122-25660-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So make init_memory_mapping smaller and readable.

Suggested-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
---
 arch/x86/mm/init.c |   42 ++++++++++++++++++++++++++----------------
 1 files changed, 26 insertions(+), 16 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index aa5b0da..6d8e102 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -146,25 +146,13 @@ static int __meminit save_mr(struct map_range *mr, int nr_range,
 	return nr_range;
 }
 
-/*
- * Setup the direct mapping of the physical memory at PAGE_OFFSET.
- * This runs before bootmem is initialized and gets pages directly from
- * the physical memory. To access them they are temporarily mapped.
- */
-unsigned long __init_refok init_memory_mapping(unsigned long start,
-					       unsigned long end)
+static int __meminit split_mem_range(struct map_range *mr, int nr_range,
+				     unsigned long start,
+				     unsigned long end)
 {
 	unsigned long start_pfn, end_pfn;
-	unsigned long ret = 0;
 	unsigned long pos;
-	struct map_range mr[NR_RANGE_MR];
-	int nr_range, i;
-
-	printk(KERN_INFO "init_memory_mapping: [mem %#010lx-%#010lx]\n",
-	       start, end - 1);
-
-	memset(mr, 0, sizeof(mr));
-	nr_range = 0;
+	int i;
 
 	/* head if not big page alignment ? */
 	start_pfn = start >> PAGE_SHIFT;
@@ -258,6 +246,28 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 			(mr[i].page_size_mask & (1<<PG_LEVEL_1G))?"1G":(
 			 (mr[i].page_size_mask & (1<<PG_LEVEL_2M))?"2M":"4k"));
 
+	return nr_range;
+}
+
+/*
+ * Setup the direct mapping of the physical memory at PAGE_OFFSET.
+ * This runs before bootmem is initialized and gets pages directly from
+ * the physical memory. To access them they are temporarily mapped.
+ */
+unsigned long __init_refok init_memory_mapping(unsigned long start,
+					       unsigned long end)
+{
+	struct map_range mr[NR_RANGE_MR];
+	unsigned long ret = 0;
+	int nr_range, i;
+
+	pr_info("init_memory_mapping: [mem %#010lx-%#010lx]\n",
+	       start, end - 1);
+
+	memset(mr, 0, sizeof(mr));
+	nr_range = 0;
+	nr_range = split_mem_range(mr, nr_range, start, end);
+
 	/*
 	 * Find space for the kernel direct mapping tables.
 	 *
-- 
1.7.7

