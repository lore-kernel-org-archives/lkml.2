Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760024Ab1EANYI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 09:24:08 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:38470 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758398Ab1EANW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 09:22:56 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 57/86] net,rcu: convert call_rcu(rps_map_release) to kfree_rcu()
Date: Sun,  1 May 2011 06:21:37 -0700
Message-Id: <1304256126-26015-57-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110501132142.GA25494@linux.vnet.ibm.com>
References: <20110501132142.GA25494@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

The rcu callback rps_map_release() just calls a kfree(),
so we use kfree_rcu() instead of the call_rcu(rps_map_release).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 net/core/net-sysfs.c |   11 ++---------
 1 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 5ceb257..c410f28 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -565,13 +565,6 @@ static ssize_t show_rps_map(struct netdev_rx_queue *queue,
 	return len;
 }
 
-static void rps_map_release(struct rcu_head *rcu)
-{
-	struct rps_map *map = container_of(rcu, struct rps_map, rcu);
-
-	kfree(map);
-}
-
 static ssize_t store_rps_map(struct netdev_rx_queue *queue,
 		      struct rx_queue_attribute *attribute,
 		      const char *buf, size_t len)
@@ -619,7 +612,7 @@ static ssize_t store_rps_map(struct netdev_rx_queue *queue,
 	spin_unlock(&rps_map_lock);
 
 	if (old_map)
-		call_rcu(&old_map->rcu, rps_map_release);
+		kfree_rcu(old_map, rcu);
 
 	free_cpumask_var(mask);
 	return len;
@@ -728,7 +721,7 @@ static void rx_queue_release(struct kobject *kobj)
 	map = rcu_dereference_raw(queue->rps_map);
 	if (map) {
 		RCU_INIT_POINTER(queue->rps_map, NULL);
-		call_rcu(&map->rcu, rps_map_release);
+		kfree_rcu(map, rcu);
 	}
 
 	flow_table = rcu_dereference_raw(queue->rps_flow_table);
-- 
1.7.3.2

