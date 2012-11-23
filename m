Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836Ab2KWKpg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 05:45:36 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:63857 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753964Ab2KWKpW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 05:45:22 -0500
X-IronPort-AV: E=Sophos;i="4.83,307,1352044800"; 
   d="scan'208";a="6263518"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: hpa@zytor.com, akpm@linux-foundation.org, rob@landley.net,
        isimatu.yasuaki@jp.fujitsu.com, tangchen@cn.fujitsu.com,
        laijs@cn.fujitsu.com, wency@cn.fujitsu.com, linfeng@cn.fujitsu.com,
        jiang.liu@huawei.com, yinghai@kernel.org,
        kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, mgorman@suse.de,
        rientjes@google.com, rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-doc@vger.kernel.org
Subject: [PATCH v2 3/5] page_alloc: Introduce zone_movable_limit[] to keep movable limit for nodes
Date: Fri, 23 Nov 2012 18:44:03 +0800
Message-Id: <1353667445-7593-4-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1353667445-7593-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1353667445-7593-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/23 18:44:50,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/23 18:44:52,
	Serialize complete at 2012/11/23 18:44:52
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces a new array zone_movable_limit[] to store the
ZONE_MOVABLE limit from movablecore_map boot option for all nodes.
The function sanitize_zone_movable_limit() will find out to which
node the ranges in movable_map.map[] belongs, and calculates the
low boundary of ZONE_MOVABLE for each node.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Reviewed-by: Wen Congyang <wency@cn.fujitsu.com>
Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Tested-by: Lin Feng <linfeng@cn.fujitsu.com>
---
 mm/page_alloc.c |   55 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 55 insertions(+), 0 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index fb5cf12..f23d76a 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -206,6 +206,7 @@ static unsigned long __meminitdata arch_zone_highest_possible_pfn[MAX_NR_ZONES];
 static unsigned long __initdata required_kernelcore;
 static unsigned long __initdata required_movablecore;
 static unsigned long __meminitdata zone_movable_pfn[MAX_NUMNODES];
+static unsigned long __meminitdata zone_movable_limit[MAX_NUMNODES];
 
 /* movable_zone is the "real" zone pages in ZONE_MOVABLE are taken from */
 int movable_zone;
@@ -4323,6 +4324,55 @@ static unsigned long __meminit zone_absent_pages_in_node(int nid,
 	return __absent_pages_in_range(nid, zone_start_pfn, zone_end_pfn);
 }
 
+/**
+ * sanitize_zone_movable_limit - Sanitize the zone_movable_limit array.
+ *
+ * zone_movable_limit is initialized as 0. This function will try to get
+ * the first ZONE_MOVABLE pfn of each node from movablecore_map, and
+ * assigne them to zone_movable_limit.
+ * zone_movable_limit[nid] == 0 means no limit for the node.
+ *
+ * Note: Each range is represented as [start_pfn, end_pfn)
+ */
+static void __meminit sanitize_zone_movable_limit(void)
+{
+	int map_pos = 0, i, nid;
+	unsigned long start_pfn, end_pfn;
+
+	if (!movablecore_map.nr_map)
+		return;
+
+	/* Iterate all ranges from minimum to maximum */
+	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid) {
+		/*
+		 * If we have found lowest pfn of ZONE_MOVABLE of the node
+		 * specified by user, just go on to check next range.
+		 */
+		if (zone_movable_limit[nid])
+			continue;
+
+		while (map_pos < movablecore_map.nr_map) {
+			if (end_pfn <= movablecore_map.map[map_pos].start)
+				break;
+
+			if (start_pfn >= movablecore_map.map[map_pos].end) {
+				map_pos++;
+				continue;
+			}
+
+			/*
+			 * The start_pfn of ZONE_MOVABLE is either the minimum
+			 * pfn specified by movablecore_map, or 0, which means
+			 * the node has no ZONE_MOVABLE.
+			 */
+			zone_movable_limit[nid] = max(start_pfn,
+					movablecore_map.map[map_pos].start);
+
+			break;
+		}
+	}
+}
+
 #else /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
 static inline unsigned long __meminit zone_spanned_pages_in_node(int nid,
 					unsigned long zone_type,
@@ -4341,6 +4391,10 @@ static inline unsigned long __meminit zone_absent_pages_in_node(int nid,
 	return zholes_size[zone_type];
 }
 
+static void __meminit sanitize_zone_movable_limit(void)
+{
+}
+
 #endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
 
 static void __meminit calculate_node_totalpages(struct pglist_data *pgdat,
@@ -4906,6 +4960,7 @@ void __init free_area_init_nodes(unsigned long *max_zone_pfn)
 
 	/* Find the PFNs that ZONE_MOVABLE begins at in each node */
 	memset(zone_movable_pfn, 0, sizeof(zone_movable_pfn));
+	sanitize_zone_movable_limit();
 	find_zone_movable_pfns_for_nodes();
 
 	/* Print out the zone ranges */
-- 
1.7.1

