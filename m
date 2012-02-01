Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108Ab2BAGwt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 01:52:49 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:49171 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755050Ab2BAGwq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 01:52:46 -0500
Message-ID: <4F28E1E3.80507@cn.fujitsu.com>
Date: Wed, 01 Feb 2012 14:55:31 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>, Neil Horman <nhorman@tuxdriver.com>
Subject: [PATCH 2/6] netprio_cgroup: don't allocate prio table when a device
 is registered
References: <4F28E1D1.900@cn.fujitsu.com>
In-Reply-To: <4F28E1D1.900@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-02-01 14:51:24,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-02-01 14:51:25,
	Serialize complete at 2012-02-01 14:51:25
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So we delay the allocation till the priority is set through cgroup,
and this makes skb_update_priority() faster when it's not set.

This also eliminates an off-by-one bug similar with the one fixed
in the previous patch.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 net/core/netprio_cgroup.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/net/core/netprio_cgroup.c b/net/core/netprio_cgroup.c
index a296cbb..2edfa6b 100644
--- a/net/core/netprio_cgroup.c
+++ b/net/core/netprio_cgroup.c
@@ -270,7 +270,6 @@ static int netprio_device_event(struct notifier_block *unused,
 {
 	struct net_device *dev = ptr;
 	struct netprio_map *old;
-	u32 max_len = atomic_read(&max_prioidx);
 
 	/*
 	 * Note this is called with rtnl_lock held so we have update side
@@ -278,11 +277,6 @@ static int netprio_device_event(struct notifier_block *unused,
 	 */
 
 	switch (event) {
-
-	case NETDEV_REGISTER:
-		if (max_len)
-			extend_netdev_table(dev, max_len);
-		break;
 	case NETDEV_UNREGISTER:
 		old = rtnl_dereference(dev->priomap);
 		RCU_INIT_POINTER(dev->priomap, NULL);
-- 
1.7.3.1
