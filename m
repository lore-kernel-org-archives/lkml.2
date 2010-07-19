Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967322Ab0GTAD4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 20:03:56 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:64415 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967061Ab0GSX64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 19:58:56 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 39/49] x86, memblock: Add memblock_x86_register_active_regions() and memblock_x86_hole_size()
Date: Mon, 19 Jul 2010 16:56:48 -0700
Message-Id: <1279583818-14249-40-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1279583818-14249-1-git-send-email-yinghai@kernel.org>
References: <1279583818-14249-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4C44E689.0241,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

memblock_x86_register_active_regions() will be used to fill early_node_map,
the result will be memblock.memory.region AND numa data

memblock_x86_hole_size will be used to find hole size on memblock.memory.region
with specified range.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/include/asm/memblock.h |    4 ++
 arch/x86/mm/memblock.c          |   67 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 71 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/memblock.h b/arch/x86/include/asm/memblock.h
index 72639ce..16af28d 100644
--- a/arch/x86/include/asm/memblock.h
+++ b/arch/x86/include/asm/memblock.h
@@ -11,4 +11,8 @@ void memblock_x86_free_range(u64 start, u64 end);
 struct range;
 int get_free_all_memory_range(struct range **rangep, int nodeid);
 
+void memblock_x86_register_active_regions(int nid, unsigned long start_pfn,
+					 unsigned long last_pfn);
+u64 memblock_x86_hole_size(u64 start, u64 end);
+
 #endif
diff --git a/arch/x86/mm/memblock.c b/arch/x86/mm/memblock.c
index ab4e2dc..bceb885 100644
--- a/arch/x86/mm/memblock.c
+++ b/arch/x86/mm/memblock.c
@@ -238,3 +238,70 @@ void __init memblock_x86_free_range(u64 start, u64 end)
 
 	memblock_free(start, end - start);
 }
+
+/*
+ * Finds an active region in the address range from start_pfn to last_pfn and
+ * returns its range in ei_startpfn and ei_endpfn for the memblock entry.
+ */
+static int __init memblock_x86_find_active_region(const struct memblock_region *ei,
+				  unsigned long start_pfn,
+				  unsigned long last_pfn,
+				  unsigned long *ei_startpfn,
+				  unsigned long *ei_endpfn)
+{
+	u64 align = PAGE_SIZE;
+
+	*ei_startpfn = round_up(ei->base, align) >> PAGE_SHIFT;
+	*ei_endpfn = round_down(ei->base + ei->size, align) >> PAGE_SHIFT;
+
+	/* Skip map entries smaller than a page */
+	if (*ei_startpfn >= *ei_endpfn)
+		return 0;
+
+	/* Skip if map is outside the node */
+	if (*ei_endpfn <= start_pfn || *ei_startpfn >= last_pfn)
+		return 0;
+
+	/* Check for overlaps */
+	if (*ei_startpfn < start_pfn)
+		*ei_startpfn = start_pfn;
+	if (*ei_endpfn > last_pfn)
+		*ei_endpfn = last_pfn;
+
+	return 1;
+}
+
+/* Walk the memblock.memory map and register active regions within a node */
+void __init memblock_x86_register_active_regions(int nid, unsigned long start_pfn,
+					 unsigned long last_pfn)
+{
+	unsigned long ei_startpfn;
+	unsigned long ei_endpfn;
+	struct memblock_region *r;
+
+	for_each_memblock(memory, r)
+		if (memblock_x86_find_active_region(r, start_pfn, last_pfn,
+					   &ei_startpfn, &ei_endpfn))
+			add_active_range(nid, ei_startpfn, ei_endpfn);
+}
+
+/*
+ * Find the hole size (in bytes) in the memory range.
+ * @start: starting address of the memory range to scan
+ * @end: ending address of the memory range to scan
+ */
+u64 __init memblock_x86_hole_size(u64 start, u64 end)
+{
+	unsigned long start_pfn = start >> PAGE_SHIFT;
+	unsigned long last_pfn = end >> PAGE_SHIFT;
+	unsigned long ei_startpfn, ei_endpfn, ram = 0;
+	struct memblock_region *r;
+
+	for_each_memblock(memory, r)
+		if (memblock_x86_find_active_region(r, start_pfn, last_pfn,
+					   &ei_startpfn, &ei_endpfn))
+			ram += ei_endpfn - ei_startpfn;
+
+	return end - start - ((u64)ram << PAGE_SHIFT);
+}
+
-- 
1.6.4.2

