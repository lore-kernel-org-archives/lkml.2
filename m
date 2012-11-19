Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639Ab2KSPuK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 10:50:10 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:35249 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752881Ab2KSPtj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 10:49:39 -0500
X-IronPort-AV: E=Sophos;i="4.83,281,1352044800"; 
   d="scan'208";a="6232236"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: tangchen@cn.fujitsu.com, wency@cn.fujitsu.com, linfeng@cn.fujitsu.com,
        rob@landley.net, akpm@linux-foundation.org,
        isimatu.yasuaki@jp.fujitsu.com, laijs@cn.fujitsu.com,
        jiang.liu@huawei.com, kosaki.motohiro@jp.fujitsu.com,
        minchan.kim@gmail.com, mgorman@suse.de, rientjes@google.com,
        yinghai@kernel.org, rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-doc@vger.kernel.org
Subject: [PATCH 3/5] page_alloc: Sanitize zone_movable_pfn.
Date: Mon, 19 Nov 2012 22:27:24 +0800
Message-Id: <1353335246-9127-4-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1353335246-9127-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1353335246-9127-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/19 22:28:19,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/19 22:28:25,
	Serialize complete at 2012/11/19 22:28:25
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

zone_movable_pfn is initialiesd as 0. This patch set its elements to the
first pfn of ZONE_MOVABLE of the corresponding node. The map info is from
movablecore_map boot option. zone_movable_pfn[nid] == 0 means the node has
no ZONE_MOVABLE.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Reviewed-by: Wen Congyang <wency@cn.fujitsu.com>
Tested-by: Lin Feng <linfeng@cn.fujitsu.com>
---
 mm/page_alloc.c |   58 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 58 insertions(+), 0 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 198106f..ae29970 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4323,6 +4323,59 @@ static unsigned long __meminit zone_absent_pages_in_node(int nid,
 	return __absent_pages_in_range(nid, zone_start_pfn, zone_end_pfn);
 }
 
+/**
+ * sanitize_zone_movable_pfn - Sanitize the zone_movable_pfn array.
+ *
+ * zone_movable_pfn is initialized as 0. This function will try to get the
+ * first ZONE_MOVABLE pfn of each node from movablecore_map, and assigne
+ * them to zone_movable_pfn.
+ * zone_movable_pfn[nid] == 0 means the node has no ZONE_MOVABLE.
+ *
+ * Note: Each range is represented as [start_pfn, end_pfn)
+ */
+static void __meminit sanitize_zone_movable_pfn(void)
+{
+	int i = 0, j = 0, nid;
+	unsigned long start_pfn, end_pfn, movable_start, tmp_start;
+
+	if (!movablecore_map.nr_map)
+		return;
+
+	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid) {
+		/* Assume there is no ZONE_MOVABLE on the node at first */
+		movable_start = ULONG_MAX;
+
+		while (j < movablecore_map.nr_map) {
+			if (movablecore_map.map[j].start >= end_pfn)
+				break;
+			if (movablecore_map.map[j].end <= start_pfn) {
+				j++;
+				continue;
+			}
+
+			movable_start = max(start_pfn, movablecore_map.map[j].start);
+			if (!zone_movable_pfn[nid])
+				zone_movable_pfn[nid] = ULONG_MAX;
+
+			/*
+			 * Sections covering tow or more nodes
+			 * should not be skipped.
+			 */
+			if (movablecore_map.map[j].end < end_pfn)
+				j++;
+
+			break;
+		}
+
+		/*
+		 * The start_pfn of ZONE_MOVABLE is either the minimum pfn
+		 * specified by movablecore_map, or the end of the node,
+		 * which means the node has no ZONE_MOVABLE.
+		 */
+		zone_movable_pfn[nid] = min(movable_start, zone_movable_pfn[nid]);
+	}
+}
+
 #else /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
 static inline unsigned long __meminit zone_spanned_pages_in_node(int nid,
 					unsigned long zone_type,
@@ -4341,6 +4394,10 @@ static inline unsigned long __meminit zone_absent_pages_in_node(int nid,
 	return zholes_size[zone_type];
 }
 
+static void __meminit sanitize_zone_movable_pfn()
+{
+}
+
 #endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
 
 static void __meminit calculate_node_totalpages(struct pglist_data *pgdat,
@@ -4906,6 +4963,7 @@ void __init free_area_init_nodes(unsigned long *max_zone_pfn)
 
 	/* Find the PFNs that ZONE_MOVABLE begins at in each node */
 	memset(zone_movable_pfn, 0, sizeof(zone_movable_pfn));
+	sanitize_zone_movable_pfn();
 	find_zone_movable_pfns_for_nodes();
 
 	/* Print out the zone ranges */
-- 
1.7.1

