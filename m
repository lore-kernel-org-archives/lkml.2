Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751393Ab2H0CC2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 22:02:28 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:49707 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822Ab2H0CC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 22:02:26 -0400
Message-ID: <503AD533.1040307@gmail.com>
Date: Mon, 27 Aug 2012 10:02:27 +0800
From: qiuxishi <qiuxishi@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: akpm@linux-foundation.org, liuj97@gmail.com,
        Wen Congyang <wency@cn.fujitsu.com>
CC: paul.gortmaker@windriver.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, bessel.wang@huawei.com,
        wujianguo@huawei.com, qiuxishi@huawei.com, jiang.liu@huawei.com,
        guohanjun@huawei.com, yinghai@kernel.org
Subject: [PATCH V2] memory-hotplug: add build zonelists when offline pages
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xishi Qiu <qiuxishi@huawei.com>

online_pages() does build_all_zonelists() and zone_pcp_update(),
I think offline_pages() should do it too.
When the zone has no  memory to allocate, remove it form other
nodes' zonelists. zone_batchsize() depends on zone's present pages,
if zone's present pages are changed, zone's pcp should be updated.


Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
---
 mm/memory_hotplug.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index bc7e7a2..5f6997f 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -973,8 +973,13 @@ repeat:

 	init_per_zone_wmark_min();

-	if (!populated_zone(zone))
+	if (!populated_zone(zone)) {
 		zone_pcp_reset(zone);
+		mutex_lock(&zonelists_mutex);
+		build_all_zonelists(NULL, NULL);
+		mutex_unlock(&zonelists_mutex);
+	} else
+		zone_pcp_update(zone);

 	if (!node_present_pages(node)) {
 		node_clear_state(node, N_HIGH_MEMORY);
-- 
1.7.6.1
