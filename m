Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759923Ab2J2PsX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 11:48:23 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:20672 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759838Ab2J2PsO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 11:48:14 -0400
X-IronPort-AV: E=Sophos;i="4.80,673,1344182400"; 
   d="scan'208";a="6093336"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>,
        LKML <linux-kernel@vger.kernel.org>, x86 maintainers <x86@kernel.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, Rusty Russell <rusty@rustcorp.com.au>,
        Yinghai Lu <yinghai@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Yasuaki ISIMATU <isimatu.yasuaki@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Wen Congyang <wency@cn.fujitsu.com>, linux-mm@kvack.org
Subject: [V5 PATCH 03/26] memory_hotplug: ensure every online node has NORMAL memory
Date: Mon, 29 Oct 2012 23:20:53 +0800
Message-Id: <1351524078-20363-2-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1351523301-20048-1-git-send-email-laijs@cn.fujitsu.com>
References: <1351523301-20048-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/29 23:18:30,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/29 23:18:33,
	Serialize complete at 2012/10/29 23:18:33
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Old  memory hotplug code and new online/movable may cause a online node
don't have any normal memory, but memory-management acts bad when we have
nodes which is online but don't have any normal memory.
Example: it may cause a bound task fail on all kernel allocation and
cause the task can't create task or create other kernel object.

So we disable non-normal-memory-node here, we will enable it
when we prepared.


Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 mm/memory_hotplug.c |   40 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index bdcdaf6..9af9641 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -589,6 +589,12 @@ static int online_pages_range(unsigned long start_pfn, unsigned long nr_pages,
 	return 0;
 }
 
+/* ensure every online node has NORMAL memory */
+static bool can_online_high_movable(struct zone *zone)
+{
+	return node_state(zone_to_nid(zone), N_NORMAL_MEMORY);
+}
+
 /* check which state of node_states will be changed when online memory */
 static void node_states_check_changes_online(unsigned long nr_pages,
 	struct zone *zone, struct memory_notify *arg)
@@ -654,6 +660,12 @@ int __ref online_pages(unsigned long pfn, unsigned long nr_pages, int online_typ
 	 */
 	zone = page_zone(pfn_to_page(pfn));
 
+	if ((zone_idx(zone) > ZONE_NORMAL || online_type == ONLINE_MOVABLE) &&
+	    !can_online_high_movable(zone)) {
+		unlock_memory_hotplug();
+		return -1;
+	}
+
 	if (online_type == ONLINE_KERNEL && zone_idx(zone) == ZONE_MOVABLE) {
 		if (move_pfn_range_left(zone - 1, zone, pfn, pfn + nr_pages)) {
 			unlock_memory_hotplug();
@@ -1058,6 +1070,30 @@ check_pages_isolated(unsigned long start_pfn, unsigned long end_pfn)
 	return offlined;
 }
 
+/* ensure the node has NORMAL memory if it is still online */
+static bool can_offline_normal(struct zone *zone, unsigned long nr_pages)
+{
+	struct pglist_data *pgdat = zone->zone_pgdat;
+	unsigned long present_pages = 0;
+	enum zone_type zt;
+
+	for (zt = 0; zt <= ZONE_NORMAL; zt++)
+		present_pages += pgdat->node_zones[zt].present_pages;
+
+	if (present_pages > nr_pages)
+		return true;
+
+	present_pages = 0;
+	for (; zt <= ZONE_MOVABLE; zt++)
+		present_pages += pgdat->node_zones[zt].present_pages;
+
+	/*
+	 * we can't offline the last normal memory until all
+	 * higher memory is offlined.
+	 */
+	return present_pages == 0;
+}
+
 /* check which state of node_states will be changed when offline memory */
 static void node_states_check_changes_offline(unsigned long nr_pages,
 		struct zone *zone, struct memory_notify *arg)
@@ -1145,6 +1181,10 @@ static int __ref __offline_pages(unsigned long start_pfn,
 	node = zone_to_nid(zone);
 	nr_pages = end_pfn - start_pfn;
 
+	ret = -EINVAL;
+	if (zone_idx(zone) <= ZONE_NORMAL && !can_offline_normal(zone, nr_pages))
+		goto out;
+
 	/* set above range as isolated */
 	ret = start_isolate_page_range(start_pfn, end_pfn, MIGRATE_MOVABLE, true);
 	if (ret)
-- 
1.7.4.4

