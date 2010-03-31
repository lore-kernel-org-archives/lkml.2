Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933017Ab0CaCYy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 22:24:54 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:24401 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932915Ab0CaCWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 22:22:01 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
       Jan Beulich <jbeulich@novell.com>
Subject: [PATCH 09/33] lmb: Add get_free_all_memory_range()
Date: Tue, 30 Mar 2010 19:16:54 -0700
Message-Id: <1270001838-15857-10-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1270001838-15857-1-git-send-email-yinghai@kernel.org>
References: <1270001838-15857-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4BB2B16D.0090,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_free_all_memory_range is for CONFIG_NO_BOOTMEM=y, and will be called by
free_all_memory_core_early().

It will use early_node_map aka active ranges subtract lmb.reserved to
get all free range, and those ranges will convert to slab pages.

-v3: use __lmb_find_base() to get range free buffer.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Jan Beulich <jbeulich@novell.com>
---
 include/linux/lmb.h |    2 +
 mm/lmb.c            |   86 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 87 insertions(+), 1 deletions(-)

diff --git a/include/linux/lmb.h b/include/linux/lmb.h
index 1e236d1..2ee2cc1 100644
--- a/include/linux/lmb.h
+++ b/include/linux/lmb.h
@@ -92,6 +92,8 @@ u64 __lmb_find_area(u64 ei_start, u64 ei_last, u64 start, u64 end,
 u64 lmb_find_area(u64 start, u64 end, u64 size, u64 align);
 
 void lmb_to_bootmem(u64 start, u64 end);
+struct range;
+int get_free_all_memory_range(struct range **rangep, int nodeid);
 
 #include <asm/lmb.h>
 
diff --git a/mm/lmb.c b/mm/lmb.c
index f25f98c..62efdb4 100644
--- a/mm/lmb.c
+++ b/mm/lmb.c
@@ -630,7 +630,91 @@ void __init lmb_free_area(u64 start, u64 end)
 	__check_and_double_region_array(&lmb.reserved, &lmb_reserved_region[0]);
 }
 
-#ifndef CONFIG_NO_BOOTMEM
+static __init struct range *find_range_array(int count)
+{
+	u64 end, size, mem;
+	struct range *range;
+
+	size = sizeof(struct range) * count;
+	end = lmb.default_alloc_limit;
+
+	mem = __lmb_find_base(size, sizeof(struct range), end);
+	if (mem == -1ULL)
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
+	if (lmb.reserved.region != lmb_reserved_region)
+		lmb_free(__pa(lmb.reserved.region), sizeof(struct lmb_property) * lmb.reserved.nr_regions);
+
+	count  = lmb.reserved.cnt;
+
+	pr_info("Subtract (%d early reservations)\n", count);
+
+	for (i = 0; i < count; i++) {
+		struct lmb_property *r = &lmb.reserved.region[i];
+		pr_info("  #%d [%010llx - %010llx]\n", i, r->base, r->base + r->size);
+		final_start = PFN_DOWN(r->base);
+		final_end = PFN_UP(r->base + r->size);
+		if (final_start >= final_end)
+			continue;
+		subtract_range(range, az, final_start, final_end);
+	}
+	/* Put region array back ? */
+	if (lmb.reserved.region != lmb_reserved_region)
+		lmb_reserve(__pa(lmb.reserved.region), sizeof(struct lmb_property) * lmb.reserved.nr_regions);
+}
+
+int __init get_free_all_memory_range(struct range **rangep, int nodeid)
+{
+	int count;
+	struct range *range;
+	int nr_range;
+
+	count = lmb.reserved.cnt * 2;
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
+		memset(&lmb.reserved.region[0], 0, sizeof(struct lmb_property) * lmb.reserved.nr_regions);
+		lmb.reserved.region = NULL;
+		lmb.reserved.nr_regions = 0;
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

