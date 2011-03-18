Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932361Ab1CRD6Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 23:58:24 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49202 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932155Ab1CRD6V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 23:58:21 -0400
Message-ID: <4D82D8C7.3040608@cn.fujitsu.com>
Date: Fri, 18 Mar 2011 12:00:07 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Patrick McHardy <kaber@trash.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 14/36] macvlan,rcu: convert call_rcu(macvlan_port_rcu_free)
 to kfree_rcu()
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-18 11:56:58,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-18 11:56:59,
	Serialize complete at 2011-03-18 11:56:59
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



The rcu callback macvlan_port_rcu_free() just calls a kfree(),
so we use kfree_rcu() instead of the call_rcu(macvlan_port_rcu_free).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 drivers/net/macvlan.c |   10 +---------
 1 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 6ed577b..6205e45 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -591,21 +591,13 @@ static int macvlan_port_create(struct net_device *dev)
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
1.7.4
