Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064Ab1CREHW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 00:07:22 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62139 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752338Ab1CREHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 00:07:18 -0400
Message-ID: <4D82DADF.4010802@cn.fujitsu.com>
Date: Fri, 18 Mar 2011 12:09:03 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>,
        Remi Denis-Courmont <remi.denis-courmont@nokia.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 28/36] net,rcu: convert call_rcu(phonet_device_rcu_free) to
 kfree_rcu()
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-18 12:05:55,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-18 12:05:55,
	Serialize complete at 2011-03-18 12:05:55
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



The rcu callback phonet_device_rcu_free() just calls a kfree(),
so we use kfree_rcu() instead of the call_rcu(phonet_device_rcu_free).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 net/phonet/pn_dev.c |   10 +---------
 1 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/net/phonet/pn_dev.c b/net/phonet/pn_dev.c
index 947038d..1566672 100644
--- a/net/phonet/pn_dev.c
+++ b/net/phonet/pn_dev.c
@@ -162,14 +162,6 @@ int phonet_address_add(struct net_device *dev, u8 addr)
 	return err;
 }
 
-static void phonet_device_rcu_free(struct rcu_head *head)
-{
-	struct phonet_device *pnd;
-
-	pnd = container_of(head, struct phonet_device, rcu);
-	kfree(pnd);
-}
-
 int phonet_address_del(struct net_device *dev, u8 addr)
 {
 	struct phonet_device_list *pndevs = phonet_device_list(dev_net(dev));
@@ -188,7 +180,7 @@ int phonet_address_del(struct net_device *dev, u8 addr)
 	mutex_unlock(&pndevs->lock);
 
 	if (pnd)
-		call_rcu(&pnd->rcu, phonet_device_rcu_free);
+		kfree_rcu(pnd, rcu);
 
 	return err;
 }
-- 
1.7.4
