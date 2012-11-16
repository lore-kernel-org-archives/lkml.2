Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470Ab2KPTVX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 14:21:23 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:49538 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753393Ab2KPTUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 14:20:43 -0500
From: Tejun Heo <tj@kernel.org>
To: daniel.wagner@bmw-carit.de, srivatsa.bhat@linux.vnet.ibm.com,
        john.r.fastabend@intel.com, nhorman@tuxdriver.com
Cc: lizefan@huawei.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 6/8] netprio_cgroup: implement netprio[_set]_prio() helpers
Date: Fri, 16 Nov 2012 11:20:22 -0800
Message-Id: <1353093624-22608-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1353093624-22608-1-git-send-email-tj@kernel.org>
References: <1353093624-22608-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce two helpers - netprio_prio() and netprio_set_prio() - which
hide the details of priomap access and expansion.  This will help
implementing hierarchy support.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 net/core/netprio_cgroup.c | 72 ++++++++++++++++++++++++++++++++---------------
 1 file changed, 50 insertions(+), 22 deletions(-)

diff --git a/net/core/netprio_cgroup.c b/net/core/netprio_cgroup.c
index 9409cdf..b2af0d0 100644
--- a/net/core/netprio_cgroup.c
+++ b/net/core/netprio_cgroup.c
@@ -87,6 +87,51 @@ static int extend_netdev_table(struct net_device *dev, u32 target_idx)
 	return 0;
 }
 
+/**
+ * netprio_prio - return the effective netprio of a cgroup-net_device pair
+ * @cgrp: cgroup part of the target pair
+ * @dev: net_device part of the target pair
+ *
+ * Should be called under RCU read or rtnl lock.
+ */
+static u32 netprio_prio(struct cgroup *cgrp, struct net_device *dev)
+{
+	struct netprio_map *map = rcu_dereference_rtnl(dev->priomap);
+
+	if (map && cgrp->id < map->priomap_len)
+		return map->priomap[cgrp->id];
+	return 0;
+}
+
+/**
+ * netprio_set_prio - set netprio on a cgroup-net_device pair
+ * @cgrp: cgroup part of the target pair
+ * @dev: net_device part of the target pair
+ * @prio: prio to set
+ *
+ * Set netprio to @prio on @cgrp-@dev pair.  Should be called under rtnl
+ * lock and may fail under memory pressure for non-zero @prio.
+ */
+static int netprio_set_prio(struct cgroup *cgrp, struct net_device *dev,
+			    u32 prio)
+{
+	struct netprio_map *map;
+	int ret;
+
+	/* avoid extending priomap for zero writes */
+	map = rtnl_dereference(dev->priomap);
+	if (!prio && (!map || map->priomap_len <= cgrp->id))
+		return 0;
+
+	ret = extend_netdev_table(dev, cgrp->id);
+	if (ret)
+		return ret;
+
+	map = rtnl_dereference(dev->priomap);
+	map->priomap[cgrp->id] = prio;
+	return 0;
+}
+
 static struct cgroup_subsys_state *cgrp_css_alloc(struct cgroup *cgrp)
 {
 	struct cgroup_netprio_state *cs;
@@ -105,14 +150,10 @@ static void cgrp_css_free(struct cgroup *cgrp)
 {
 	struct cgroup_netprio_state *cs = cgrp_netprio_state(cgrp);
 	struct net_device *dev;
-	struct netprio_map *map;
 
 	rtnl_lock();
-	for_each_netdev(&init_net, dev) {
-		map = rtnl_dereference(dev->priomap);
-		if (map && cgrp->id < map->priomap_len)
-			map->priomap[cgrp->id] = 0;
-	}
+	for_each_netdev(&init_net, dev)
+		WARN_ON_ONCE(netprio_set_prio(cgrp, dev, 0));
 	rtnl_unlock();
 	kfree(cs);
 }
@@ -126,16 +167,10 @@ static int read_priomap(struct cgroup *cont, struct cftype *cft,
 			struct cgroup_map_cb *cb)
 {
 	struct net_device *dev;
-	u32 id = cont->id;
-	u32 priority;
-	struct netprio_map *map;
 
 	rcu_read_lock();
-	for_each_netdev_rcu(&init_net, dev) {
-		map = rcu_dereference(dev->priomap);
-		priority = (map && id < map->priomap_len) ? map->priomap[id] : 0;
-		cb->fill(cb, dev->name, priority);
-	}
+	for_each_netdev_rcu(&init_net, dev)
+		cb->fill(cb, dev->name, netprio_prio(cont, dev));
 	rcu_read_unlock();
 	return 0;
 }
@@ -145,7 +180,6 @@ static int write_priomap(struct cgroup *cgrp, struct cftype *cft,
 {
 	char devname[IFNAMSIZ + 1];
 	struct net_device *dev;
-	struct netprio_map *map;
 	u32 prio;
 	int ret;
 
@@ -158,14 +192,8 @@ static int write_priomap(struct cgroup *cgrp, struct cftype *cft,
 
 	rtnl_lock();
 
-	ret = extend_netdev_table(dev, cgrp->id);
-	if (ret)
-		goto out_unlock;
+	ret = netprio_set_prio(cgrp, dev, prio);
 
-	map = rtnl_dereference(dev->priomap);
-	if (map)
-		map->priomap[cgrp->id] = prio;
-out_unlock:
 	rtnl_unlock();
 	dev_put(dev);
 	return ret;
-- 
1.7.11.7

