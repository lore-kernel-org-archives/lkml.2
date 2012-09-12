Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158Ab2ILGIW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 02:08:22 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:53152 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755982Ab2ILGIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 02:08:20 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [v2 PATCH 2/2] netprio_cgroup: Use memcpy instead of the for-loop to
 copy priomap
To: davem@davemloft.net, nhorman@tuxdriver.com
Cc: David.Laight@aculab.com, john.r.fastabend@intel.com,
        gaofeng@cn.fujitsu.com, eric.dumazet@gmail.com,
        mark.d.rustad@intel.com, lizefan@huawei.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com
Date: Wed, 12 Sep 2012 11:37:47 +0530
Message-ID: <20120912060747.11037.42623.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20120912060741.11037.37347.stgit@srivatsabhat.in.ibm.com>
References: <20120912060741.11037.37347.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12091206-7014-0000-0000-000001E1C7AA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the current (inefficient) for-loop with memcpy, to copy priomap.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 net/core/netprio_cgroup.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/core/netprio_cgroup.c b/net/core/netprio_cgroup.c
index fd339bb0..83bbd0e 100644
--- a/net/core/netprio_cgroup.c
+++ b/net/core/netprio_cgroup.c
@@ -73,7 +73,6 @@ static int extend_netdev_table(struct net_device *dev, u32 new_len)
 			   ((sizeof(u32) * new_len));
 	struct netprio_map *new_priomap = kzalloc(new_size, GFP_KERNEL);
 	struct netprio_map *old_priomap;
-	int i;
 
 	old_priomap  = rtnl_dereference(dev->priomap);
 
@@ -82,10 +81,10 @@ static int extend_netdev_table(struct net_device *dev, u32 new_len)
 		return -ENOMEM;
 	}
 
-	for (i = 0;
-	     old_priomap && (i < old_priomap->priomap_len);
-	     i++)
-		new_priomap->priomap[i] = old_priomap->priomap[i];
+	if (old_priomap)
+		memcpy(new_priomap->priomap, old_priomap->priomap,
+			old_priomap->priomap_len *
+					sizeof(old_priomap->priomap[0]));
 
 	new_priomap->priomap_len = new_len;
 

