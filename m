Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097Ab0C2Ctj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 22:49:39 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:55874 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755932Ab0C2Cqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 22:46:48 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 16/31] lmb: Add lmb_free_memory_size()
Date: Sun, 28 Mar 2010 19:43:09 -0700
Message-Id: <1269830604-26214-17-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1269830604-26214-1-git-send-email-yinghai@kernel.org>
References: <1269830604-26214-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4BB01466.01B1,ss=1,fgs=0
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
index 019520a..51a8653 100644
--- a/include/linux/lmb.h
+++ b/include/linux/lmb.h
@@ -101,6 +101,7 @@ int get_free_all_memory_range(struct range **rangep, int nodeid);
 void lmb_register_active_regions(int nid, unsigned long start_pfn,
 					 unsigned long last_pfn);
 u64 lmb_hole_size(u64 start, u64 end);
+u64 lmb_free_memory_size(u64 addr, u64 limit);
 
 #include <asm/lmb.h>
 
diff --git a/mm/lmb.c b/mm/lmb.c
index addfcb1..233c40d 100644
--- a/mm/lmb.c
+++ b/mm/lmb.c
@@ -756,6 +756,57 @@ void __init lmb_to_bootmem(u64 start, u64 end)
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
 static int __init find_overlapped_early(u64 start, u64 end)
 {
 	int i;
-- 
1.6.4.2

