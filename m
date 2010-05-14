Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913Ab0ENTtn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 15:49:43 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:65046 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932415Ab0ENTtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 15:49:11 -0400
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
Subject: [PATCH 12/37] x86, lmb: Add get_free_all_memory_range()
Date: Fri, 14 May 2010 12:45:38 -0700
Message-Id: <1273866363-14249-13-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1273866363-14249-1-git-send-email-yinghai@kernel.org>
References: <1273866363-14249-1-git-send-email-yinghai@kernel.org>
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090202.4BEDA8E2.00E2,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_free_all_memory_range is for CONFIG_NO_BOOTMEM=y, and will be called by
free_all_memory_core_early().

It will use early_node_map aka active ranges subtract lmb.reserved to
get all free range, and those ranges will convert to slab pages.

-v4: increase range size

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Jan Beulich <jbeulich@novell.com>
---
 arch/x86/include/asm/lmb.h |    2 +
 arch/x86/mm/lmb.c          |  110 +++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 111 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/lmb.h b/arch/x86/include/asm/lmb.h
index bc85c1e..80e9e4c 100644
--- a/arch/x86/include/asm/lmb.h
+++ b/arch/x86/include/asm/lmb.h
@@ -9,5 +9,7 @@ void lmb_to_bootmem(u64 start, u64 end);
 void lmb_reserve_area(u64 start, u64 end, char *name);
 void lmb_free_area(u64 start, u64 end);
 void lmb_add_memory(u64 start, u64 end);
+struct range;
+int get_free_all_memory_range(struct range **rangep, int nodeid);
 
 #endif
diff --git a/arch/x86/mm/lmb.c b/arch/x86/mm/lmb.c
index 5d0b008..9a5e21e 100644
--- a/arch/x86/mm/lmb.c
+++ b/arch/x86/mm/lmb.c
@@ -86,7 +86,115 @@ u64 __init lmb_find_area_size(u64 start, u64 *sizep, u64 align)
 	return LMB_ERROR;
 }
 
-#ifndef CONFIG_NO_BOOTMEM
+static __init struct range *find_range_array(int count)
+{
+	u64 end, size, mem;
+	struct range *range;
+
+	size = sizeof(struct range) * count;
+	end = lmb.current_limit;
+
+	mem = lmb_find_area(0, end, size, sizeof(struct range));
+	if (mem == LMB_ERROR)
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
+static void __init subtract_lmb_reserved(struct range *range, int az)
+{
+	int i, count;
+	u64 final_start, final_end;
+
+	/* Take out region array itself at first*/
+	if (lmb.reserved.regions != lmb_reserved_init_regions)
+		lmb_free(__pa(lmb.reserved.regions), sizeof(struct lmb_region) * lmb.reserved.max);
+
+	count  = lmb.reserved.cnt;
+
+	pr_info("Subtract (%d early reservations)\n", count);
+
+	for (i = 0; i < count; i++) {
+		struct lmb_region *r = &lmb.reserved.regions[i];
+		pr_info("  #%d [%010llx - %010llx]\n", i, (u64)r->base, (u64)r->base + r->size);
+		final_start = PFN_DOWN(r->base);
+		final_end = PFN_UP(r->base + r->size);
+		if (final_start >= final_end)
+			continue;
+		subtract_range(range, az, final_start, final_end);
+	}
+	/* Put region array back ? */
+	if (lmb.reserved.regions != lmb_reserved_init_regions)
+		lmb_reserve(__pa(lmb.reserved.regions), sizeof(struct lmb_region) * lmb.reserved.max);
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
+	count = (lmb.reserved.cnt + count_early_node_map(nodeid)) * 2;
+
+	range = find_range_array(count);
+	nr_range = 0;
+
+	/*
+	 * Use early_node_map[] and lmb.reserved.region to get range array
+	 * at first
+	 */
+	nr_range = add_from_early_node_map(range, count, nr_range, nodeid);
+#ifdef CONFIG_X86_32
+	subtract_range(range, count, max_low_pfn, -1ULL);
+#endif
+	subtract_lmb_reserved(range, count);
+	nr_range = clean_sort_range(range, count);
+
+	/* Need to clear it ? */
+	if (nodeid == MAX_NUMNODES) {
+		memset(&lmb.reserved.regions[0], 0, sizeof(struct lmb_region) * lmb.reserved.max);
+		lmb.reserved.regions = NULL;
+		lmb.reserved.max = 0;
+		lmb.reserved.cnt = 0;
+	}
+
+	*rangep = range;
+	return nr_range;
+}
+#else
 void __init lmb_to_bootmem(u64 start, u64 end)
 {
 	int i, count;
-- 
1.6.4.2

