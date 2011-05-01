Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932256Ab1EANaK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 09:30:10 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:38967 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757145Ab1EANWg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 09:22:36 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 58/86] net,rcu: convert call_rcu(xps_map_release) to kfree_rcu()
Date: Sun,  1 May 2011 06:21:38 -0700
Message-Id: <1304256126-26015-58-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110501132142.GA25494@linux.vnet.ibm.com>
References: <20110501132142.GA25494@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

The rcu callback xps_map_release() just calls a kfree(),
so we use kfree_rcu() instead of the call_rcu(xps_map_release).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 net/core/net-sysfs.c |   11 ++---------
 1 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index c410f28..48ffc21 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -891,13 +891,6 @@ static ssize_t show_xps_map(struct netdev_queue *queue,
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
@@ -1002,7 +995,7 @@ static ssize_t store_xps_map(struct netdev_queue *queue,
 		map = dev_maps ?
 			xmap_dereference(dev_maps->cpu_map[cpu]) : NULL;
 		if (map && xmap_dereference(new_dev_maps->cpu_map[cpu]) != map)
-			call_rcu(&map->rcu, xps_map_release);
+			kfree_rcu(map, rcu);
 		if (new_dev_maps->cpu_map[cpu])
 			nonempty = 1;
 	}
@@ -1077,7 +1070,7 @@ static void netdev_queue_release(struct kobject *kobj)
 				else {
 					RCU_INIT_POINTER(dev_maps->cpu_map[i],
 					    NULL);
-					call_rcu(&map->rcu, xps_map_release);
+					kfree_rcu(map, rcu);
 					map = NULL;
 				}
 			}
-- 
1.7.3.2

