Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760129Ab1EAN0I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 09:26:08 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:60610 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753001Ab1EANWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 09:22:39 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 55/86] macvlan,rcu: convert call_rcu(macvlan_port_rcu_free) to kfree_rcu()
Date: Sun,  1 May 2011 06:21:35 -0700
Message-Id: <1304256126-26015-55-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110501132142.GA25494@linux.vnet.ibm.com>
References: <20110501132142.GA25494@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

The rcu callback macvlan_port_rcu_free() just calls a kfree(),
so we use kfree_rcu() instead of the call_rcu(macvlan_port_rcu_free).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 drivers/net/macvlan.c |   10 +---------
 1 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 78e34e9..d8e4e69 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -603,21 +603,13 @@ static int macvlan_port_create(struct net_device *dev)
 	return err;
 }
 
-static void macvlan_port_rcu_free(struct rcu_head *head)
-{
-	struct macvlan_port *port;
-
-	port = container_of(head, struct macvlan_port, rcu);
-	kfree(port);
-}
-
 static void macvlan_port_destroy(struct net_device *dev)
 {
 	struct macvlan_port *port = macvlan_port_get(dev);
 
 	dev->priv_flags &= ~IFF_MACVLAN_PORT;
 	netdev_rx_handler_unregister(dev);
-	call_rcu(&port->rcu, macvlan_port_rcu_free);
+	kfree_rcu(port, rcu);
 }
 
 static int macvlan_validate(struct nlattr *tb[], struct nlattr *data[])
-- 
1.7.3.2

