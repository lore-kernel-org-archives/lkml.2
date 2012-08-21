Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757542Ab2HUMvW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 08:51:22 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37900 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013Ab2HUMvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 08:51:20 -0400
Message-ID: <5033843E.8000902@gmail.com>
Date: Tue, 21 Aug 2012 20:51:10 +0800
From: qiuxishi <qiuxishi@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: akpm@linux-foundation.org, liuj97@gmail.com, paul.gortmaker@windriver.com
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org, bessel.wang@huawei.com,
        wujianguo@huawei.com, qiuxishi@huawei.com, jiang.liu@huawei.com,
        guohanjun@huawei.com, chenkeping@huawei.com, yinghai@kernel.org,
        wency@cn.fujitsu.com
Subject: [PATCH] memory-hotplug: add build zonelists when offline pages
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xishi Qiu <qiuxishi@huawei.com>

online_pages() does build_all_zonelists() and zone_pcp_update(),
I think offline_pages() should do it too. The node has no memory
to allocate, so remove this node's zones form other nodes' zonelists.


Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
---
 mm/memory_hotplug.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index bc7e7a2..5172bd4 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -979,7 +979,11 @@ repeat:
 	if (!node_present_pages(node)) {
 		node_clear_state(node, N_HIGH_MEMORY);
 		kswapd_stop(node);
-	}
+		mutex_lock(&zonelists_mutex);
+		build_all_zonelists(NODE_DATA(node), NULL);
+		mutex_unlock(&zonelists_mutex);
+	} else
+		zone_pcp_update(zone);

 	vm_total_pages = nr_free_pagecache_pages();
 	writeback_set_ratelimit();
-- 
1.7.6.1
