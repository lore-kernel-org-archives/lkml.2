Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758996Ab2IKLXC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 07:23:02 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:35122 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757783Ab2IKLXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 07:23:00 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH 1/2] netprio_cgroup: Remove update_netdev_tables() since it is
 unnecessary
To: davem@davemloft.net, nhorman@tuxdriver.com
Cc: john.r.fastabend@intel.com, gaofeng@cn.fujitsu.com, eric.dumazet@gmail.com,
        mark.d.rustad@intel.com, lizefan@huawei.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Tue, 11 Sep 2012 16:52:31 +0530
Message-ID: <20120911112231.13852.61794.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12091111-5816-0000-0000-00000467DF51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The update_netdev_tables() function appears to be unnecessary, since the
write_update_netdev_table() function will adjust the priomaps as and when
required anyway. So drop the usage of update_netdev_tables() entirely.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 net/core/netprio_cgroup.c |   32 --------------------------------
 1 files changed, 0 insertions(+), 32 deletions(-)

diff --git a/net/core/netprio_cgroup.c b/net/core/netprio_cgroup.c
index c75e3f9..fd339bb0 100644
--- a/net/core/netprio_cgroup.c
+++ b/net/core/netprio_cgroup.c
@@ -109,32 +109,6 @@ static int write_update_netdev_table(struct net_device *dev)
 	return ret;
 }
 
-static int update_netdev_tables(void)
-{
-	int ret = 0;
-	struct net_device *dev;
-	u32 max_len;
-	struct netprio_map *map;
-
-	rtnl_lock();
-	max_len = atomic_read(&max_prioidx) + 1;
-	for_each_netdev(&init_net, dev) {
-		map = rtnl_dereference(dev->priomap);
-		/*
-		 * don't allocate priomap if we didn't
-		 * change net_prio.ifpriomap (map == NULL),
-		 * this will speed up skb_update_prio.
-		 */
-		if (map && map->priomap_len < max_len) {
-			ret = extend_netdev_table(dev, max_len);
-			if (ret < 0)
-				break;
-		}
-	}
-	rtnl_unlock();
-	return ret;
-}
-
 static struct cgroup_subsys_state *cgrp_create(struct cgroup *cgrp)
 {
 	struct cgroup_netprio_state *cs;
@@ -153,12 +127,6 @@ static struct cgroup_subsys_state *cgrp_create(struct cgroup *cgrp)
 		goto out;
 	}
 
-	ret = update_netdev_tables();
-	if (ret < 0) {
-		put_prioidx(cs->prioidx);
-		goto out;
-	}
-
 	return &cs->css;
 out:
 	kfree(cs);

