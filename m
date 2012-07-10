Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752406Ab2GJCbd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 22:31:33 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:25930 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751766Ab2GJCbb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 22:31:31 -0400
X-IronPort-AV: E=Sophos;i="4.77,556,1336320000"; 
   d="scan'208";a="5358976"
From: Gao feng <gaofeng@cn.fujitsu.com>
To: eric.dumazet@gmail.com, nhorman@tuxdriver.com
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        lizefan@huawei.com, tj@kernel.org, Gao feng <gaofeng@cn.fujitsu.com>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH] net: cgroup: fix access the unallocated memory in netprio cgroup
Date: Tue, 10 Jul 2012 10:31:48 +0800
Message-Id: <1341887508-20302-1-git-send-email-gaofeng@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1341837625.3265.2748.camel@edumazet-glaptop>
References: <1341837625.3265.2748.camel@edumazet-glaptop>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/07/10 10:31:21,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/07/10 10:31:23,
	Serialize complete at 2012/07/10 10:31:23
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

there are some out of bound accesses in netprio cgroup.
when creating a new netprio cgroup,we only set a prioidx for
the new cgroup,without allocate memory for dev->priomap.

because we don't want to see additional bound checkings in
fast path, so I think the best way is to allocate memory when we
creating a new netprio cgroup.

and because netdev can be created or registered after cgroup being
created, so extend_netdev_table is also needed in write_priomap.

this patch add a return value for update_netdev_tables & extend_netdev_table,
so when new_priomap is allocated failed,write_priomap will stop to access
the priomap,and return -ENOMEM back to the userspace to tell the user
what happend.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Eric Dumazet <edumazet@google.com>
---
 net/core/netprio_cgroup.c |   43 +++++++++++++++++++++++++++++--------------
 1 files changed, 29 insertions(+), 14 deletions(-)

diff --git a/net/core/netprio_cgroup.c b/net/core/netprio_cgroup.c
index aa907ed..3554f28 100644
--- a/net/core/netprio_cgroup.c
+++ b/net/core/netprio_cgroup.c
@@ -65,7 +65,7 @@ static void put_prioidx(u32 idx)
 	spin_unlock_irqrestore(&prioidx_map_lock, flags);
 }
 
-static void extend_netdev_table(struct net_device *dev, u32 new_len)
+static int extend_netdev_table(struct net_device *dev, u32 new_len)
 {
 	size_t new_size = sizeof(struct netprio_map) +
 			   ((sizeof(u32) * new_len));
@@ -77,7 +77,7 @@ static void extend_netdev_table(struct net_device *dev, u32 new_len)
 
 	if (!new_priomap) {
 		pr_warn("Unable to alloc new priomap!\n");
-		return;
+		return -ENOMEM;
 	}
 
 	for (i = 0;
@@ -90,10 +90,12 @@ static void extend_netdev_table(struct net_device *dev, u32 new_len)
 	rcu_assign_pointer(dev->priomap, new_priomap);
 	if (old_priomap)
 		kfree_rcu(old_priomap, rcu);
+	return 0;
 }
 
-static void update_netdev_tables(void)
+static int update_netdev_tables(void)
 {
+	int ret = 0;
 	struct net_device *dev;
 	u32 max_len = atomic_read(&max_prioidx) + 1;
 	struct netprio_map *map;
@@ -102,34 +104,44 @@ static void update_netdev_tables(void)
 	for_each_netdev(&init_net, dev) {
 		map = rtnl_dereference(dev->priomap);
 		if ((!map) ||
-		    (map->priomap_len < max_len))
-			extend_netdev_table(dev, max_len);
+		    (map->priomap_len < max_len)) {
+			ret = extend_netdev_table(dev, max_len);
+			if (ret < 0)
+				break;
+		}
 	}
 	rtnl_unlock();
+	return ret;
 }
 
 static struct cgroup_subsys_state *cgrp_create(struct cgroup *cgrp)
 {
 	struct cgroup_netprio_state *cs;
-	int ret;
+	int ret = -EINVAL;
 
 	cs = kzalloc(sizeof(*cs), GFP_KERNEL);
 	if (!cs)
 		return ERR_PTR(-ENOMEM);
 
-	if (cgrp->parent && cgrp_netprio_state(cgrp->parent)->prioidx) {
-		kfree(cs);
-		return ERR_PTR(-EINVAL);
-	}
+	if (cgrp->parent && cgrp_netprio_state(cgrp->parent)->prioidx)
+		goto out;
 
 	ret = get_prioidx(&cs->prioidx);
-	if (ret != 0) {
+	if (ret < 0) {
 		pr_warn("No space in priority index array\n");
-		kfree(cs);
-		return ERR_PTR(ret);
+		goto out;
+	}
+
+	ret = update_netdev_tables();
+	if (ret < 0) {
+		put_prioidx(cs->prioidx);
+		goto out;
 	}
 
 	return &cs->css;
+out:
+	kfree(cs);
+	return ERR_PTR(ret);
 }
 
 static void cgrp_destroy(struct cgroup *cgrp)
@@ -221,7 +233,10 @@ static int write_priomap(struct cgroup *cgrp, struct cftype *cft,
 	if (!dev)
 		goto out_free_devname;
 
-	update_netdev_tables();
+	ret = update_netdev_tables();
+	if (ret < 0)
+		goto out_free_devname;
+
 	ret = 0;
 	rcu_read_lock();
 	map = rcu_dereference(dev->priomap);
-- 
1.7.7.6

