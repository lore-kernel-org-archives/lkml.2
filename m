Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935202Ab2JaIu4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 04:50:56 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60176 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S935132Ab2JaIuM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 04:50:12 -0400
X-IronPort-AV: E=Sophos;i="4.80,687,1344182400"; 
   d="scan'208";a="6107356"
From: Wen Congyang <wency@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-doc@vger.kernel.org
Cc: Rob Landley <rob@landley.net>, Andrew Morton <akpm@linux-foundation.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jiang Liu <jiang.liu@huawei.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>, Yinghai Lu <yinghai@kernel.org>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>
Subject: [PART4 Patch 2/2] memory_hotplug: allow online/offline memory to result movable node
Date: Wed, 31 Oct 2012 16:15:34 +0800
Message-Id: <1351671334-10243-3-git-send-email-wency@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1351671334-10243-1-git-send-email-wency@cn.fujitsu.com>
References: <1351671334-10243-1-git-send-email-wency@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/31 16:09:04,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/31 16:09:12,
	Serialize complete at 2012/10/31 16:09:12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

Now, memory management can handle movable node or nodes which don't have
any normal memory, so we can dynamic configure and add movable node by:
	online a ZONE_MOVABLE memory from a previous offline node
	offline the last normal memory which result a non-normal-memory-node

movable-node is very important for power-saving,
hardware partitioning and high-available-system(hardware fault management).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 mm/memory_hotplug.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index d07c66f..4aceb03 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -589,11 +589,19 @@ static int online_pages_range(unsigned long start_pfn, unsigned long nr_pages,
 	return 0;
 }
 
+#ifdef CONFIG_MOVABLE_NODE
+/* when CONFIG_MOVABLE_NODE, we allow online node don't have normal memory */
+static bool can_online_high_movable(struct zone *zone)
+{
+	return true;
+}
+#else /* #ifdef CONFIG_MOVABLE_NODE */
 /* ensure every online node has NORMAL memory */
 static bool can_online_high_movable(struct zone *zone)
 {
 	return node_state(zone_to_nid(zone), N_NORMAL_MEMORY);
 }
+#endif /* #ifdef CONFIG_MOVABLE_NODE */
 
 /* check which state of node_states will be changed when online memory */
 static void node_states_check_changes_online(unsigned long nr_pages,
@@ -1097,6 +1105,13 @@ check_pages_isolated(unsigned long start_pfn, unsigned long end_pfn)
 	return offlined;
 }
 
+#ifdef CONFIG_MOVABLE_NODE
+/* when CONFIG_MOVABLE_NODE, we allow online node don't have normal memory */
+static bool can_offline_normal(struct zone *zone, unsigned long nr_pages)
+{
+	return true;
+}
+#else /* #ifdef CONFIG_MOVABLE_NODE */
 /* ensure the node has NORMAL memory if it is still online */
 static bool can_offline_normal(struct zone *zone, unsigned long nr_pages)
 {
@@ -1120,6 +1135,7 @@ static bool can_offline_normal(struct zone *zone, unsigned long nr_pages)
 	 */
 	return present_pages == 0;
 }
+#endif /* #ifdef CONFIG_MOVABLE_NODE */
 
 /* check which state of node_states will be changed when offline memory */
 static void node_states_check_changes_offline(unsigned long nr_pages,
-- 
1.8.0

