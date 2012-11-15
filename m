Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992996Ab2KOIw7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 03:52:59 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:3871 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S2993272Ab2KOIve (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 03:51:34 -0500
X-IronPort-AV: E=Sophos;i="4.83,256,1352044800"; 
   d="scan'208";a="6205598"
From: Wen Congyang <wency@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-doc@vger.kernel.org
Cc: Rob Landley <rob@landley.net>, Andrew Morton <akpm@linux-foundation.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jiang Liu <jiang.liu@huawei.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Lin feng <linfeng@cn.fujitsu.com>, Wen Congyang <wency@cn.fujitsu.com>
Subject: [PART3 Patch v2 14/14] hotplug: update nodemasks management
Date: Thu, 15 Nov 2012 16:57:37 +0800
Message-Id: <1352969857-26623-15-git-send-email-wency@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1352969857-26623-1-git-send-email-wency@cn.fujitsu.com>
References: <1352969857-26623-1-git-send-email-wency@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/15 16:51:18,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/15 16:51:21,
	Serialize complete at 2012/11/15 16:51:21
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

update nodemasks management for N_MEMORY

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
---
 Documentation/memory-hotplug.txt |  5 ++-
 include/linux/memory.h           |  1 +
 mm/memory_hotplug.c              | 87 +++++++++++++++++++++++++++++++++-------
 3 files changed, 77 insertions(+), 16 deletions(-)

diff --git a/Documentation/memory-hotplug.txt b/Documentation/memory-hotplug.txt
index 6e6cbc7..70bc1c7 100644
--- a/Documentation/memory-hotplug.txt
+++ b/Documentation/memory-hotplug.txt
@@ -378,6 +378,7 @@ struct memory_notify {
        unsigned long start_pfn;
        unsigned long nr_pages;
        int status_change_nid_normal;
+       int status_change_nid_high;
        int status_change_nid;
 }
 
@@ -385,7 +386,9 @@ start_pfn is start_pfn of online/offline memory.
 nr_pages is # of pages of online/offline memory.
 status_change_nid_normal is set node id when N_NORMAL_MEMORY of nodemask
 is (will be) set/clear, if this is -1, then nodemask status is not changed.
-status_change_nid is set node id when N_HIGH_MEMORY of nodemask is (will be)
+status_change_nid_high is set node id when N_HIGH_MEMORY of nodemask
+is (will be) set/clear, if this is -1, then nodemask status is not changed.
+status_change_nid is set node id when N_MEMORY of nodemask is (will be)
 set/clear. It means a new(memoryless) node gets new memory by online and a
 node loses all memory. If this is -1, then nodemask status is not changed.
 If status_changed_nid* >= 0, callback should create/discard structures for the
diff --git a/include/linux/memory.h b/include/linux/memory.h
index a09216d..45e93b4 100644
--- a/include/linux/memory.h
+++ b/include/linux/memory.h
@@ -54,6 +54,7 @@ struct memory_notify {
 	unsigned long start_pfn;
 	unsigned long nr_pages;
 	int status_change_nid_normal;
+	int status_change_nid_high;
 	int status_change_nid;
 };
 
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index dfa6a91..760095d 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -475,13 +475,15 @@ static void node_states_check_changes_online(unsigned long nr_pages,
 	enum zone_type zone_last = ZONE_NORMAL;
 
 	/*
-	 * If we have HIGHMEM, node_states[N_NORMAL_MEMORY] contains nodes
-	 * which have 0...ZONE_NORMAL, set zone_last to ZONE_NORMAL.
+	 * If we have HIGHMEM or movable node, node_states[N_NORMAL_MEMORY]
+	 * contains nodes which have zones of 0...ZONE_NORMAL,
+	 * set zone_last to ZONE_NORMAL.
 	 *
-	 * If we don't have HIGHMEM, node_states[N_NORMAL_MEMORY] contains nodes
-	 * which have 0...ZONE_MOVABLE, set zone_last to ZONE_MOVABLE.
+	 * If we don't have HIGHMEM nor movable node,
+	 * node_states[N_NORMAL_MEMORY] contains nodes which have zones of
+	 * 0...ZONE_MOVABLE, set zone_last to ZONE_MOVABLE.
 	 */
-	if (N_HIGH_MEMORY == N_NORMAL_MEMORY)
+	if (N_MEMORY == N_NORMAL_MEMORY)
 		zone_last = ZONE_MOVABLE;
 
 	/*
@@ -495,12 +497,34 @@ static void node_states_check_changes_online(unsigned long nr_pages,
 	else
 		arg->status_change_nid_normal = -1;
 
+#ifdef CONFIG_HIGHMEM
+	/*
+	 * If we have movable node, node_states[N_HIGH_MEMORY]
+	 * contains nodes which have zones of 0...ZONE_HIGH,
+	 * set zone_last to ZONE_HIGH.
+	 *
+	 * If we don't have movable node, node_states[N_NORMAL_MEMORY]
+	 * contains nodes which have zones of 0...ZONE_MOVABLE,
+	 * set zone_last to ZONE_MOVABLE.
+	 */
+	zone_last = ZONE_HIGH;
+	if (N_MEMORY == N_HIGH_MEMORY)
+		zone_last = ZONE_MOVABLE;
+
+	if (zone_idx(zone) <= zone_last && !node_state(nid, N_HIGH_MEMORY))
+		arg->status_change_nid_high = nid;
+	else
+		arg->status_change_nid_high = -1;
+#else
+	arg->status_change_nid_high = arg->status_change_nid_normal;
+#endif
+
 	/*
 	 * if the node don't have memory befor online, we will need to
-	 * set the node to node_states[N_HIGH_MEMORY] after the memory
+	 * set the node to node_states[N_MEMORY] after the memory
 	 * is online.
 	 */
-	if (!node_state(nid, N_HIGH_MEMORY))
+	if (!node_state(nid, N_MEMORY))
 		arg->status_change_nid = nid;
 	else
 		arg->status_change_nid = -1;
@@ -511,7 +535,10 @@ static void node_states_set_node(int node, struct memory_notify *arg)
 	if (arg->status_change_nid_normal >= 0)
 		node_set_state(node, N_NORMAL_MEMORY);
 
-	node_set_state(node, N_HIGH_MEMORY);
+	if (arg->status_change_nid_high >= 0)
+		node_set_state(node, N_HIGH_MEMORY);
+
+	node_set_state(node, N_MEMORY);
 }
 
 
@@ -929,13 +956,15 @@ static void node_states_check_changes_offline(unsigned long nr_pages,
 	enum zone_type zt, zone_last = ZONE_NORMAL;
 
 	/*
-	 * If we have HIGHMEM, node_states[N_NORMAL_MEMORY] contains nodes
-	 * which have 0...ZONE_NORMAL, set zone_last to ZONE_NORMAL.
+	 * If we have HIGHMEM or movable node, node_states[N_NORMAL_MEMORY]
+	 * contains nodes which have zones of 0...ZONE_NORMAL,
+	 * set zone_last to ZONE_NORMAL.
 	 *
-	 * If we don't have HIGHMEM, node_states[N_NORMAL_MEMORY] contains nodes
-	 * which have 0...ZONE_MOVABLE, set zone_last to ZONE_MOVABLE.
+	 * If we don't have HIGHMEM nor movable node,
+	 * node_states[N_NORMAL_MEMORY] contains nodes which have zones of
+	 * 0...ZONE_MOVABLE, set zone_last to ZONE_MOVABLE.
 	 */
-	if (N_HIGH_MEMORY == N_NORMAL_MEMORY)
+	if (N_MEMORY == N_NORMAL_MEMORY)
 		zone_last = ZONE_MOVABLE;
 
 	/*
@@ -952,6 +981,30 @@ static void node_states_check_changes_offline(unsigned long nr_pages,
 	else
 		arg->status_change_nid_normal = -1;
 
+#ifdef CONIG_HIGHMEM
+	/*
+	 * If we have movable node, node_states[N_HIGH_MEMORY]
+	 * contains nodes which have zones of 0...ZONE_HIGH,
+	 * set zone_last to ZONE_HIGH.
+	 *
+	 * If we don't have movable node, node_states[N_NORMAL_MEMORY]
+	 * contains nodes which have zones of 0...ZONE_MOVABLE,
+	 * set zone_last to ZONE_MOVABLE.
+	 */
+	zone_last = ZONE_HIGH;
+	if (N_MEMORY == N_HIGH_MEMORY)
+		zone_last = ZONE_MOVABLE;
+
+	for (; zt <= zone_last; zt++)
+		present_pages += pgdat->node_zones[zt].present_pages;
+	if (zone_idx(zone) <= zone_last && nr_pages >= present_pages)
+		arg->status_change_nid_high = zone_to_nid(zone);
+	else
+		arg->status_change_nid_high = -1;
+#else
+	arg->status_change_nid_high = arg->status_change_nid_normal;
+#endif
+
 	/*
 	 * node_states[N_HIGH_MEMORY] contains nodes which have 0...ZONE_MOVABLE
 	 */
@@ -976,9 +1029,13 @@ static void node_states_clear_node(int node, struct memory_notify *arg)
 	if (arg->status_change_nid_normal >= 0)
 		node_clear_state(node, N_NORMAL_MEMORY);
 
-	if ((N_HIGH_MEMORY != N_NORMAL_MEMORY) &&
-	    (arg->status_change_nid >= 0))
+	if ((N_MEMORY != N_NORMAL_MEMORY) &&
+	    (arg->status_change_nid_high >= 0))
 		node_clear_state(node, N_HIGH_MEMORY);
+
+	if ((N_MEMORY != N_HIGH_MEMORY) &&
+	    (arg->status_change_nid >= 0))
+		node_clear_state(node, N_MEMORY);
 }
 
 static int __ref __offline_pages(unsigned long start_pfn,
-- 
1.8.0

