Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759905Ab0GVSqK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 14:46:10 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:62215 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759825Ab0GVSpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 14:45:52 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 07/16] memblock: Add find_memory_core_early()
Date: Thu, 22 Jul 2010 11:43:52 -0700
Message-Id: <1279824241-17582-8-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1279824241-17582-1-git-send-email-yinghai@kernel.org>
References: <1279824241-17582-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4C4891B9.021F,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to node range in early_node_map[] with __memblock_find_in_range
to find free range.

Will be used by memblock_x86_find_in_range_node()

memblock_x86_find_in_range_node will be used to find right buffer for NODE_DATA

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 include/linux/mm.h |    2 ++
 mm/page_alloc.c    |   36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 7a9ab7d..9d27940 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1164,6 +1164,8 @@ extern void free_bootmem_with_active_regions(int nid,
 						unsigned long max_low_pfn);
 int add_from_early_node_map(struct range *range, int az,
 				   int nr_range, int nid);
+u64 __init find_memory_core_early(int nid, u64 size, u64 align,
+					u64 goal, u64 limit);
 void *__alloc_memory_core_early(int nodeid, u64 size, u64 align,
 				 u64 goal, u64 limit);
 typedef int (*work_fn_t)(unsigned long, unsigned long, void *);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 9bd339e..8c9b346 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -21,6 +21,7 @@
 #include <linux/pagemap.h>
 #include <linux/jiffies.h>
 #include <linux/bootmem.h>
+#include <linux/memblock.h>
 #include <linux/compiler.h>
 #include <linux/kernel.h>
 #include <linux/kmemcheck.h>
@@ -3612,6 +3613,41 @@ void __init free_bootmem_with_active_regions(int nid,
 	}
 }
 
+#ifdef CONFIG_HAVE_MEMBLOCK
+u64 __init find_memory_core_early(int nid, u64 size, u64 align,
+					u64 goal, u64 limit)
+{
+	int i;
+
+	/* Need to go over early_node_map to find out good range for node */
+	for_each_active_range_index_in_nid(i, nid) {
+		u64 addr;
+		u64 ei_start, ei_last;
+		u64 final_start, final_end;
+
+		ei_last = early_node_map[i].end_pfn;
+		ei_last <<= PAGE_SHIFT;
+		ei_start = early_node_map[i].start_pfn;
+		ei_start <<= PAGE_SHIFT;
+
+		final_start = max(ei_start, goal);
+		final_end = min(ei_last, limit);
+
+		if (final_start >= final_end)
+			continue;
+
+		addr = memblock_find_in_range(final_start, final_end, size, align);
+
+		if (addr == MEMBLOCK_ERROR)
+			continue;
+
+		return addr;
+	}
+
+	return MEMBLOCK_ERROR;
+}
+#endif
+
 int __init add_from_early_node_map(struct range *range, int az,
 				   int nr_range, int nid)
 {
-- 
1.6.4.2

