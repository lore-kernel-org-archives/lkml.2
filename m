Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537Ab2JaFfb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 01:35:31 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52986 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751942Ab2JaFfX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 01:35:23 -0400
X-IronPort-AV: E=Sophos;i="4.80,686,1344182400"; 
   d="scan'208";a="6105344"
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
Subject: [PART1 Patch 2/3] memory_hotplug: handle empty zone when online_movable/online_kernel
Date: Wed, 31 Oct 2012 13:40:35 +0800
Message-Id: <1351662036-7435-3-git-send-email-wency@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1351662036-7435-1-git-send-email-wency@cn.fujitsu.com>
References: <1351662036-7435-1-git-send-email-wency@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/31 13:34:07,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/31 13:34:10,
	Serialize complete at 2012/10/31 13:34:10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

make online_movable/online_kernel can empty a zone
or can move memory to a empty zone.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 mm/memory_hotplug.c | 51 +++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 45 insertions(+), 6 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 4900025..e6ec8c2 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -227,8 +227,17 @@ static void resize_zone(struct zone *zone, unsigned long start_pfn,
 
 	zone_span_writelock(zone);
 
-	zone->zone_start_pfn = start_pfn;
-	zone->spanned_pages = end_pfn - start_pfn;
+	if (end_pfn - start_pfn) {
+		zone->zone_start_pfn = start_pfn;
+		zone->spanned_pages = end_pfn - start_pfn;
+	} else {
+		/*
+		 * make it consist as free_area_init_core(),
+		 * if spanned_pages = 0, then keep start_pfn = 0
+		 */
+		zone->zone_start_pfn = 0;
+		zone->spanned_pages = 0;
+	}
 
 	zone_span_writeunlock(zone);
 }
@@ -244,10 +253,19 @@ static void fix_zone_id(struct zone *zone, unsigned long start_pfn,
 		set_page_links(pfn_to_page(pfn), zid, nid, pfn);
 }
 
-static int move_pfn_range_left(struct zone *z1, struct zone *z2,
+static int __meminit move_pfn_range_left(struct zone *z1, struct zone *z2,
 		unsigned long start_pfn, unsigned long end_pfn)
 {
+	int ret;
 	unsigned long flags;
+	unsigned long z1_start_pfn;
+
+	if (!z1->wait_table) {
+		ret = init_currently_empty_zone(z1, start_pfn,
+			end_pfn - start_pfn, MEMMAP_HOTPLUG);
+		if (ret)
+			return ret;
+	}
 
 	pgdat_resize_lock(z1->zone_pgdat, &flags);
 
@@ -261,7 +279,13 @@ static int move_pfn_range_left(struct zone *z1, struct zone *z2,
 	if (end_pfn <= z2->zone_start_pfn)
 		goto out_fail;
 
-	resize_zone(z1, z1->zone_start_pfn, end_pfn);
+	/* use start_pfn for z1's start_pfn if z1 is empty */
+	if (z1->spanned_pages)
+		z1_start_pfn = z1->zone_start_pfn;
+	else
+		z1_start_pfn = start_pfn;
+
+	resize_zone(z1, z1_start_pfn, end_pfn);
 	resize_zone(z2, end_pfn, z2->zone_start_pfn + z2->spanned_pages);
 
 	pgdat_resize_unlock(z1->zone_pgdat, &flags);
@@ -274,10 +298,19 @@ out_fail:
 	return -1;
 }
 
-static int move_pfn_range_right(struct zone *z1, struct zone *z2,
+static int __meminit move_pfn_range_right(struct zone *z1, struct zone *z2,
 		unsigned long start_pfn, unsigned long end_pfn)
 {
+	int ret;
 	unsigned long flags;
+	unsigned long z2_end_pfn;
+
+	if (!z2->wait_table) {
+		ret = init_currently_empty_zone(z2, start_pfn,
+			end_pfn - start_pfn, MEMMAP_HOTPLUG);
+		if (ret)
+			return ret;
+	}
 
 	pgdat_resize_lock(z1->zone_pgdat, &flags);
 
@@ -291,8 +324,14 @@ static int move_pfn_range_right(struct zone *z1, struct zone *z2,
 	if (start_pfn >= z1->zone_start_pfn + z1->spanned_pages)
 		goto out_fail;
 
+	/* use end_pfn for z2's end_pfn if z2 is empty */
+	if (z2->spanned_pages)
+		z2_end_pfn = z2->zone_start_pfn + z2->spanned_pages;
+	else
+		z2_end_pfn = end_pfn;
+
 	resize_zone(z1, z1->zone_start_pfn, start_pfn);
-	resize_zone(z2, start_pfn, z2->zone_start_pfn + z2->spanned_pages);
+	resize_zone(z2, start_pfn, z2_end_pfn);
 
 	pgdat_resize_unlock(z1->zone_pgdat, &flags);
 
-- 
1.8.0

