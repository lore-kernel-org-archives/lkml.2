Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756391Ab0DIGMm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 02:12:42 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:37708 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755531Ab0DIGHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 02:07:21 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 14/39] lmb: Add find_memory_core_early()
Date: Thu,  8 Apr 2010 23:03:43 -0700
Message-Id: <1270793048-23796-15-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1270793048-23796-1-git-send-email-yinghai@kernel.org>
References: <1270793048-23796-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4BBEC3E3.0076,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to node range in early_node_map[] with __lmb_find_area
to find free range.

Will be used by lmb_find_area_node()

lmb_find_area_node will be used to find right buffer for NODE_DATA

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 include/linux/mm.h |    2 ++
 mm/page_alloc.c    |   29 +++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index fb19bb9..7774e1d 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1159,6 +1159,8 @@ extern void free_bootmem_with_active_regions(int nid,
 						unsigned long max_low_pfn);
 int add_from_early_node_map(struct range *range, int az,
 				   int nr_range, int nid);
+u64 __init find_memory_core_early(int nid, u64 size, u64 align,
+					u64 goal, u64 limit);
 void *__alloc_memory_core_early(int nodeid, u64 size, u64 align,
 				 u64 goal, u64 limit);
 typedef int (*work_fn_t)(unsigned long, unsigned long, void *);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index d03c946..12a74ad 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -21,6 +21,7 @@
 #include <linux/pagemap.h>
 #include <linux/jiffies.h>
 #include <linux/bootmem.h>
+#include <linux/lmb.h>
 #include <linux/compiler.h>
 #include <linux/kernel.h>
 #include <linux/kmemcheck.h>
@@ -3393,6 +3394,34 @@ void __init free_bootmem_with_active_regions(int nid,
 	}
 }
 
+#ifdef CONFIG_HAVE_LMB
+u64 __init find_memory_core_early(int nid, u64 size, u64 align,
+					u64 goal, u64 limit)
+{
+	int i;
+
+	/* Need to go over early_node_map to find out good range for node */
+	for_each_active_range_index_in_nid(i, nid) {
+		u64 addr;
+		u64 ei_start, ei_last;
+
+		ei_last = early_node_map[i].end_pfn;
+		ei_last <<= PAGE_SHIFT;
+		ei_start = early_node_map[i].start_pfn;
+		ei_start <<= PAGE_SHIFT;
+		addr = __lmb_find_area(ei_start, ei_last,
+					 goal, limit, size, align);
+
+		if (addr == -1ULL)
+			continue;
+
+		return addr;
+	}
+
+	return -1ULL;
+}
+#endif
+
 int __init add_from_early_node_map(struct range *range, int az,
 				   int nr_range, int nid)
 {
-- 
1.6.4.2

