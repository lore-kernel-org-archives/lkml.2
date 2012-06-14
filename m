Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251Ab2FNIyO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 04:54:14 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:10465 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987Ab2FNIyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 04:54:12 -0400
From: Jiang Liu <jiang.liu@huawei.com>
To: Minchan Kim <minchan@kernel.org>
CC: Jiang Liu <jiang.liu@huawei.com>, Keping Chen <chenkeping@huawei.com>,
        Mel Gorman <mgorman@suse.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Tony Luck <tony.luck@intel.com>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        Jiang Liu <liuj97@gmail.com>
Subject: [PATCH] trivial, memory hotplug: add kswapd_is_running() for better readability
Date: Thu, 14 Jun 2012 16:49:36 +0800
Message-ID: <1339663776-196-1-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.8.msysgit.0
In-Reply-To: <4FD97718.6060008@kernel.org>
References: <4FD97718.6060008@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.108.108.229]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add kswapd_is_running() to check whether the kswapd worker thread is already
running before calling kswapd_run() when onlining memory pages.

It's based on a draft version from Minchan Kim <minchan@kernel.org>.

Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 include/linux/swap.h |    5 +++++
 mm/memory_hotplug.c  |    3 ++-
 mm/vmscan.c          |    3 +--
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index c84ec68..36249d5 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -301,6 +301,11 @@ static inline void scan_unevictable_unregister_node(struct node *node)
 
 extern int kswapd_run(int nid);
 extern void kswapd_stop(int nid);
+static inline bool kswapd_is_running(int nid)
+{
+	return !!(NODE_DATA(nid)->kswapd);
+}
+
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR
 extern int mem_cgroup_swappiness(struct mem_cgroup *mem);
 #else
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 0d7e3ec..88e479d 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -522,7 +522,8 @@ int __ref online_pages(unsigned long pfn, unsigned long nr_pages)
 	init_per_zone_wmark_min();
 
 	if (onlined_pages) {
-		kswapd_run(zone_to_nid(zone));
+		if (!kswapd_is_running(zone_to_nid(zone)))
+			kswapd_run(zone_to_nid(zone));
 		node_set_state(zone_to_nid(zone), N_HIGH_MEMORY);
 	}
 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 7585101..3dafdbe 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2941,8 +2941,7 @@ int kswapd_run(int nid)
 	pg_data_t *pgdat = NODE_DATA(nid);
 	int ret = 0;
 
-	if (pgdat->kswapd)
-		return 0;
+	BUG_ON(pgdat->kswapd);
 
 	pgdat->kswapd = kthread_run(kswapd, pgdat, "kswapd%d", nid);
 	if (IS_ERR(pgdat->kswapd)) {
-- 
1.7.1


