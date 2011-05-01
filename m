Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760111Ab1EAN32 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 09:29:28 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:38977 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757274Ab1EANWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 09:22:37 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 59/86] net,rcu: convert call_rcu(xps_dev_maps_release) to kfree_rcu()
Date: Sun,  1 May 2011 06:21:39 -0700
Message-Id: <1304256126-26015-59-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110501132142.GA25494@linux.vnet.ibm.com>
References: <20110501132142.GA25494@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

The rcu callback xps_dev_maps_release() just calls a kfree(),
so we use kfree_rcu() instead of the call_rcu(xps_dev_maps_release).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 net/core/net-sysfs.c |   12 ++----------
 1 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 48ffc21..80b2aad 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -891,14 +891,6 @@ static ssize_t show_xps_map(struct netdev_queue *queue,
 	return len;
 }
 
-static void xps_dev_maps_release(struct rcu_head *rcu)
-{
-	struct xps_dev_maps *dev_maps =
-	    container_of(rcu, struct xps_dev_maps, rcu);
-
-	kfree(dev_maps);
-}
-
 static DEFINE_MUTEX(xps_map_mutex);
 #define xmap_dereference(P)		\
 	rcu_dereference_protected((P), lockdep_is_held(&xps_map_mutex))
@@ -1008,7 +1000,7 @@ static ssize_t store_xps_map(struct netdev_queue *queue,
 	}
 
 	if (dev_maps)
-		call_rcu(&dev_maps->rcu, xps_dev_maps_release);
+		kfree_rcu(dev_maps, rcu);
 
 	netdev_queue_numa_node_write(queue, (numa_node >= 0) ? numa_node :
 					    NUMA_NO_NODE);
@@ -1080,7 +1072,7 @@ static void netdev_queue_release(struct kobject *kobj)
 
 		if (!nonempty) {
 			RCU_INIT_POINTER(dev->xps_maps, NULL);
-			call_rcu(&dev_maps->rcu, xps_dev_maps_release);
+			kfree_rcu(dev_maps, rcu);
 		}
 	}
 
-- 
1.7.3.2

