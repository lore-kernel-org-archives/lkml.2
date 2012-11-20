Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752349Ab2KTHGq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 02:06:46 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:62851 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470Ab2KTHGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 02:06:43 -0500
From: Tejun Heo <tj@kernel.org>
To: daniel.wagner@bmw-carit.de, serge.hallyn@canonical.com,
        ebiederm@xmission.com, nhorman@tuxdriver.com, tgraf@suug.ch
Cc: davem@davemloft.net, lizefan@huawei.com, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/7] netprio_cgroup: simplify write_priomap()
Date: Mon, 19 Nov 2012 23:06:25 -0800
Message-Id: <1353395190-4530-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1353395190-4530-1-git-send-email-tj@kernel.org>
References: <1353395190-4530-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sscanf() doesn't bite.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
---
 net/core/netprio_cgroup.c | 56 ++++++++++-------------------------------------
 1 file changed, 11 insertions(+), 45 deletions(-)

diff --git a/net/core/netprio_cgroup.c b/net/core/netprio_cgroup.c
index f0b6b0d..66d98da 100644
--- a/net/core/netprio_cgroup.c
+++ b/net/core/netprio_cgroup.c
@@ -176,66 +176,32 @@ static int read_priomap(struct cgroup *cont, struct cftype *cft,
 static int write_priomap(struct cgroup *cgrp, struct cftype *cft,
 			 const char *buffer)
 {
-	char *devname = kstrdup(buffer, GFP_KERNEL);
-	int ret = -EINVAL;
 	u32 prioidx = cgrp_netprio_state(cgrp)->prioidx;
-	unsigned long priority;
-	char *priostr;
+	char devname[IFNAMSIZ + 1];
 	struct net_device *dev;
 	struct netprio_map *map;
+	u32 prio;
+	int ret;
 
-	if (!devname)
-		return -ENOMEM;
-
-	/*
-	 * Minimally sized valid priomap string
-	 */
-	if (strlen(devname) < 3)
-		goto out_free_devname;
-
-	priostr = strstr(devname, " ");
-	if (!priostr)
-		goto out_free_devname;
-
-	/*
-	 *Separate the devname from the associated priority
-	 *and advance the priostr pointer to the priority value
-	 */
-	*priostr = '\0';
-	priostr++;
-
-	/*
-	 * If the priostr points to NULL, we're at the end of the passed
-	 * in string, and its not a valid write
-	 */
-	if (*priostr == '\0')
-		goto out_free_devname;
-
-	ret = kstrtoul(priostr, 10, &priority);
-	if (ret < 0)
-		goto out_free_devname;
-
-	ret = -ENODEV;
+	if (sscanf(buffer, "%"__stringify(IFNAMSIZ)"s %u", devname, &prio) != 2)
+		return -EINVAL;
 
 	dev = dev_get_by_name(&init_net, devname);
 	if (!dev)
-		goto out_free_devname;
+		return -ENODEV;
 
 	rtnl_lock();
+
 	ret = write_update_netdev_table(dev);
-	if (ret < 0)
-		goto out_put_dev;
+	if (ret)
+		goto out_unlock;
 
 	map = rtnl_dereference(dev->priomap);
 	if (map)
-		map->priomap[prioidx] = priority;
-
-out_put_dev:
+		map->priomap[prioidx] = prio;
+out_unlock:
 	rtnl_unlock();
 	dev_put(dev);
-
-out_free_devname:
-	kfree(devname);
 	return ret;
 }
 
-- 
1.7.11.7

