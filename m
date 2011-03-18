Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751372Ab1CREAm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 00:00:42 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59022 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750801Ab1CREAe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 00:00:34 -0400
Message-ID: <4D82D94C.2090507@cn.fujitsu.com>
Date: Fri, 18 Mar 2011 12:02:20 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Tom Herbert <therbert@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 17/36] net,rcu: convert call_rcu(xps_map_release) to kfree_rcu()
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-18 11:59:11,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-18 11:59:12,
	Serialize complete at 2011-03-18 11:59:12
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



The rcu callback xps_map_release() just calls a kfree(),
so we use kfree_rcu() instead of the call_rcu(xps_map_release).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 net/core/net-sysfs.c |   11 ++---------
 1 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 21e9208..9ae2e1d 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -876,13 +876,6 @@ static ssize_t show_xps_map(struct netdev_queue *queue,
 	return len;
 }
 
-static void xps_map_release(struct rcu_head *rcu)
-{
-	struct xps_map *map = container_of(rcu, struct xps_map, rcu);
-
-	kfree(map);
-}
-
 static void xps_dev_maps_release(struct rcu_head *rcu)
 {
 	struct xps_dev_maps *dev_maps =
@@ -987,7 +980,7 @@ static ssize_t store_xps_map(struct netdev_queue *queue,
 		map = dev_maps ?
 			xmap_dereference(dev_maps->cpu_map[cpu]) : NULL;
 		if (map && xmap_dereference(new_dev_maps->cpu_map[cpu]) != map)
-			call_rcu(&map->rcu, xps_map_release);
+			kfree_rcu(map, rcu);
 		if (new_dev_maps->cpu_map[cpu])
 			nonempty = 1;
 	}
@@ -1062,7 +1055,7 @@ static void netdev_queue_release(struct kobject *kobj)
 				else {
 					RCU_INIT_POINTER(dev_maps->cpu_map[i],
 					    NULL);
-					call_rcu(&map->rcu, xps_map_release);
+					kfree_rcu(map, rcu);
 					map = NULL;
 				}
 			}
-- 
1.7.4
