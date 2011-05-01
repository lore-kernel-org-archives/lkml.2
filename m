Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760772Ab1EANc6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 09:32:58 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:44999 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756671Ab1EANWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 09:22:33 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 39/86] net,rcu: convert call_rcu(in6_dev_finish_destroy_rcu) to kfree_rcu()
Date: Sun,  1 May 2011 06:21:19 -0700
Message-Id: <1304256126-26015-39-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110501132142.GA25494@linux.vnet.ibm.com>
References: <20110501132142.GA25494@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

The rcu callback in6_dev_finish_destroy_rcu() just calls a kfree(),
so we use kfree_rcu() instead of the call_rcu(in6_dev_finish_destroy_rcu).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 net/ipv6/addrconf.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 1493534..85787e3 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -317,12 +317,6 @@ static void snmp6_free_dev(struct inet6_dev *idev)
 
 /* Nobody refers to this device, we may destroy it. */
 
-static void in6_dev_finish_destroy_rcu(struct rcu_head *head)
-{
-	struct inet6_dev *idev = container_of(head, struct inet6_dev, rcu);
-	kfree(idev);
-}
-
 void in6_dev_finish_destroy(struct inet6_dev *idev)
 {
 	struct net_device *dev = idev->dev;
@@ -339,7 +333,7 @@ void in6_dev_finish_destroy(struct inet6_dev *idev)
 		return;
 	}
 	snmp6_free_dev(idev);
-	call_rcu(&idev->rcu, in6_dev_finish_destroy_rcu);
+	kfree_rcu(idev, rcu);
 }
 
 EXPORT_SYMBOL(in6_dev_finish_destroy);
-- 
1.7.3.2

