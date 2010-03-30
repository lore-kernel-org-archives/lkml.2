Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511Ab0C3LfL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 07:35:11 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:44520 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754513Ab0C3LfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 07:35:08 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 13/29] lmb: Add lmb_free_memory_size()
Date: Tue, 30 Mar 2010 04:19:47 -0700
Message-Id: <1269948003-17221-14-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1269948003-17221-1-git-send-email-yinghai@kernel.org>
References: <1269948003-17221-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4BB1DECB.000E,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It will return free memory size in specified range.

We can not use memory_size - reserved_size here, because some reserved area
may not be in the scope of lmb.memory.region.

Use lmb.memory.region subtracting lmb.reserved.region to get free range array.
then count size of all free ranges.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 include/linux/lmb.h |    1 +
 mm/lmb.c            |   51 +++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 52 insertions(+), 0 deletions(-)

diff --git a/include/linux/lmb.h b/include/linux/lmb.h
index 4078825..b874dc0 100644
--- a/include/linux/lmb.h
+++ b/include/linux/lmb.h
@@ -100,6 +100,7 @@ int get_free_all_memory_range(struct range **rangep, int nodeid);
 void lmb_register_active_regions(int nid, unsigned long start_pfn,
 					 unsigned long last_pfn);
 u64 lmb_hole_size(u64 start, u64 end);
+u64 lmb_free_memory_size(u64 addr, u64 limit);
 
 #include <asm/lmb.h>
 
diff --git a/mm/lmb.c b/mm/lmb.c
index 97e582d..1a686ff 100644
--- a/mm/lmb.c
+++ b/mm/lmb.c
@@ -747,6 +747,57 @@ void __init lmb_to_bootmem(u64 start, u64 end)
 }
 #endif
 
+u64 __init lmb_free_memory_size(u64 addr, u64 limit)
+{
+	int i, count;
+	struct range *range;
+	int nr_range;
+	u64 final_start, final_end;
+	u64 free_size;
+
+	count = lmb.reserved.cnt * 2;
+
+	range = find_range_array(count);
+	nr_range = 0;
+
+	addr = PFN_UP(addr);
+	limit = PFN_DOWN(limit);
+
+	for (i = 0; i < lmb.memory.cnt; i++) {
+		struct lmb_property *r = &lmb.memory.region[i];
+
+		final_start = PFN_UP(r->base);
+		final_end = PFN_DOWN(r->base + r->size);
+		if (final_start >= final_end)
+			continue;
+		if (final_start >= limit || final_end <= addr)
+			continue;
+
+		nr_range = add_range(range, count, nr_range, final_start, final_end);
+	}
+	subtract_range(range, count, 0, addr);
+	subtract_range(range, count, limit, -1ULL);
+	for (i = 0; i < lmb.reserved.cnt; i++) {
+		struct lmb_property *r = &lmb.reserved.region[i];
+
+		final_start = PFN_DOWN(r->base);
+		final_end = PFN_UP(r->base + r->size);
+		if (final_start >= final_end)
+			continue;
+		if (final_start >= limit || final_end <= addr)
+			continue;
+
+		subtract_range(range, count, final_start, final_end);
+	}
+	nr_range = clean_sort_range(range, count);
+
+	free_size = 0;
+	for (i = 0; i < nr_range; i++)
+		free_size += range[i].end - range[i].start;
+
+	return free_size << PAGE_SHIFT;
+}
+
 u64 __init __lmb_find_area(u64 ei_start, u64 ei_last, u64 start, u64 end,
 				 u64 size, u64 align)
 {
-- 
1.6.4.2

