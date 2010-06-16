Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758663Ab0FPGCx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 02:02:53 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:42441 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754759Ab0FPGCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 02:02:51 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 16/37] x86, lmb: Add lmb_free_memory_in_range()
Date: Tue, 15 Jun 2010 22:42:25 -0700
Message-Id: <1276666966-14259-17-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1276666966-14259-1-git-send-email-yinghai@kernel.org>
References: <1276666966-14259-1-git-send-email-yinghai@kernel.org>
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090203.4C186506.002F,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It will return free memory size in specified range.

We can not use memory_size - reserved_size here, because some reserved area
may not be in the scope of lmb.memory.region.

Use lmb.memory.region subtracting lmb.reserved.region to get free range array.
then count size of all free ranges.

-v2: Ben insist on using _in_range

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/include/asm/lmb.h |    1 +
 arch/x86/mm/lmb.c          |   48 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/lmb.h b/arch/x86/include/asm/lmb.h
index 02fe25d..3a304f8 100644
--- a/arch/x86/include/asm/lmb.h
+++ b/arch/x86/include/asm/lmb.h
@@ -15,5 +15,6 @@ void lmb_register_active_regions(int nid, unsigned long start_pfn,
 					 unsigned long last_pfn);
 u64 lmb_hole_size(u64 start, u64 end);
 u64 lmb_find_in_range_node(int nid, u64 start, u64 end, u64 size, u64 align);
+u64 lmb_free_memory_in_range(u64 addr, u64 limit);
 
 #endif
diff --git a/arch/x86/mm/lmb.c b/arch/x86/mm/lmb.c
index 399d223..991dd55 100644
--- a/arch/x86/mm/lmb.c
+++ b/arch/x86/mm/lmb.c
@@ -217,6 +217,54 @@ void __init lmb_to_bootmem(u64 start, u64 end)
 }
 #endif
 
+u64 __init lmb_free_memory_in_range(u64 addr, u64 limit)
+{
+	int i, count;
+	struct range *range;
+	int nr_range;
+	u64 final_start, final_end;
+	u64 free_size;
+	struct lmb_region *r;
+
+	count = (lmb.reserved.cnt + lmb.memory.cnt) * 2;
+
+	range = find_range_array(count);
+	nr_range = 0;
+
+	addr = PFN_UP(addr);
+	limit = PFN_DOWN(limit);
+
+	for_each_lmb(memory, r) {
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
+	for_each_lmb(reserved, r) {
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
 void __init lmb_reserve_range(u64 start, u64 end, char *name)
 {
 	if (start == end)
-- 
1.6.4.2

