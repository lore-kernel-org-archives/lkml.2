Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760632Ab1EAN1l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 09:27:41 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:48543 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757286Ab1EANWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 09:22:37 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 67/86] net,rcu: convert call_rcu(phonet_device_rcu_free) to kfree_rcu()
Date: Sun,  1 May 2011 06:21:47 -0700
Message-Id: <1304256126-26015-67-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110501132142.GA25494@linux.vnet.ibm.com>
References: <20110501132142.GA25494@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

The rcu callback phonet_device_rcu_free() just calls a kfree(),
so we use kfree_rcu() instead of the call_rcu(phonet_device_rcu_free).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
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
1.7.3.2

