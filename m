Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932377Ab0ENTsz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 15:48:55 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:59897 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932328Ab0ENTsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 15:48:47 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 14/37] lmb: Add find_memory_core_early()
Date: Fri, 14 May 2010 12:45:40 -0700
Message-Id: <1273866363-14249-15-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1273866363-14249-1-git-send-email-yinghai@kernel.org>
References: <1273866363-14249-1-git-send-email-yinghai@kernel.org>
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090208.4BEDA8E5.0183,ss=1,fgs=0
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
index d03c946..8f17f1f 100644
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
+		if (addr == LMB_ERROR)
+			continue;
+
+		return addr;
+	}
+
+	return LMB_ERROR;
+}
+#endif
+
 int __init add_from_early_node_map(struct range *range, int az,
 				   int nr_range, int nid)
 {
-- 
1.6.4.2

