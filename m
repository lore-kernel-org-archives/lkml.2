Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756473Ab0GFWsI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 18:48:08 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:31964 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757258Ab0GFWny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 18:43:54 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
       Jan Beulich <jbeulich@novell.com>
Subject: [PATCH 38/49] x86, memblock: Add get_free_all_memory_range()
Date: Tue,  6 Jul 2010 15:39:31 -0700
Message-Id: <1278455982-24621-39-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1278455982-24621-1-git-send-email-yinghai@kernel.org>
References: <1278455982-24621-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4C33B16E.0173,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_free_all_memory_range is for CONFIG_NO_BOOTMEM=y, and will be called by
free_all_memory_core_early().

It will use early_node_map aka active ranges subtract memblock.reserved to
get all free range, and those ranges will convert to slab pages.

-v4: increase range size

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Jan Beulich <jbeulich@novell.com>
---
 arch/x86/include/asm/memblock.h |    2 +
 arch/x86/mm/memblock.c          |  102 ++++++++++++++++++++++++++++++++++++++-
 2 files changed, 103 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/memblock.h b/arch/x86/include/asm/memblock.h
index e11ddf0..72639ce 100644
--- a/arch/x86/include/asm/memblock.h
+++ b/arch/x86/include/asm/memblock.h
@@ -8,5 +8,7 @@ void memblock_x86_to_bootmem(u64 start, u64 end);
 
 void memblock_x86_reserve_range(u64 start, u64 end, char *name);
 void memblock_x86_free_range(u64 start, u64 end);
+struct range;
+int get_free_all_memory_range(struct range **rangep, int nodeid);
 
 #endif
diff --git a/arch/x86/mm/memblock.c b/arch/x86/mm/memblock.c
index 4e065b5..249754b 100644
--- a/arch/x86/mm/memblock.c
+++ b/arch/x86/mm/memblock.c
@@ -86,7 +86,107 @@ u64 __init memblock_x86_find_in_range_size(u64 start, u64 *sizep, u64 align)
 	return MEMBLOCK_ERROR;
 }
 
-#ifndef CONFIG_NO_BOOTMEM
+static __init struct range *find_range_array(int count)
+{
+	u64 end, size, mem;
+	struct range *range;
+
+	size = sizeof(struct range) * count;
+	end = memblock.current_limit;
+
+	mem = memblock_find_in_range(0, end, size, sizeof(struct range));
+	if (mem == MEMBLOCK_ERROR)
+		panic("can not find more space for range array");
+
+	/*
+	 * This range is tempoaray, so don't reserve it, it will not be
+	 * overlapped because We will not alloccate new buffer before
+	 * We discard this one
+	 */
+	range = __va(mem);
+	memset(range, 0, size);
+
+	return range;
+}
+
+#ifdef CONFIG_NO_BOOTMEM
+static void __init memblock_x86_subtract_reserved(struct range *range, int az)
+{
+	int count;
+	u64 final_start, final_end;
+	struct memblock_region *r;
+
+	/* Take out region array itself at first*/
+	if (memblock.reserved.regions != memblock_reserved_init_regions)
+		memblock_free(__pa(memblock.reserved.regions), sizeof(struct memblock_region) * memblock.reserved.max);
+
+	count  = memblock.reserved.cnt;
+
+	pr_info("Subtract (%d early reservations)\n", count);
+
+	for_each_memblock(reserved, r) {
+		pr_info("  [%010llx - %010llx]\n", (u64)r->base, (u64)r->base + r->size);
+		final_start = PFN_DOWN(r->base);
+		final_end = PFN_UP(r->base + r->size);
+		if (final_start >= final_end)
+			continue;
+		subtract_range(range, az, final_start, final_end);
+	}
+	/* Put region array back ? */
+	if (memblock.reserved.regions != memblock_reserved_init_regions)
+		memblock_reserve(__pa(memblock.reserved.regions), sizeof(struct memblock_region) * memblock.reserved.max);
+}
+
+struct count_data {
+	int nr;
+};
+
+static int __init count_work_fn(unsigned long start_pfn,
+				unsigned long end_pfn, void *datax)
+{
+	struct count_data *data = datax;
+
+	data->nr++;
+
+	return 0;
+}
+
+static int __init count_early_node_map(int nodeid)
+{
+	struct count_data data;
+
+	data.nr = 0;
+	work_with_active_regions(nodeid, count_work_fn, &data);
+
+	return data.nr;
+}
+
+int __init get_free_all_memory_range(struct range **rangep, int nodeid)
+{
+	int count;
+	struct range *range;
+	int nr_range;
+
+	count = (memblock.reserved.cnt + count_early_node_map(nodeid)) * 2;
+
+	range = find_range_array(count);
+	nr_range = 0;
+
+	/*
+	 * Use early_node_map[] and memblock.reserved.region to get range array
+	 * at first
+	 */
+	nr_range = add_from_early_node_map(range, count, nr_range, nodeid);
+#ifdef CONFIG_X86_32
+	subtract_range(range, count, max_low_pfn, -1ULL);
+#endif
+	memblock_x86_subtract_reserved(range, count);
+	nr_range = clean_sort_range(range, count);
+
+	*rangep = range;
+	return nr_range;
+}
+#else
 void __init memblock_x86_to_bootmem(u64 start, u64 end)
 {
 	int count;
-- 
1.6.4.2

