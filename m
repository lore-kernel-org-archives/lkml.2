Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933040Ab1I1Wqy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:46:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54604 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932912Ab1I1Wqu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:46:50 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:43 2011
Message-Id: <20110928220143.896513864@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:02:20 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [176/244] bridge: fix a possible net_device leak
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Eric Dumazet <eric.dumazet@gmail.com>

[ Upstream commit 11f3a6bdc2528d1ce2af50202dbf7138fdee1b34 ]

Jan Beulich reported a possible net_device leak in bridge code after
commit bb900b27a2f4 (bridge: allow creating bridge devices with netlink)

Reported-by: Jan Beulich <JBeulich@novell.com>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Acked-by: Stephen Hemminger <shemminger@vyatta.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/bridge/br_if.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -231,6 +231,7 @@ static struct net_bridge_port *new_nbp(s
 int br_add_bridge(struct net *net, const char *name)
 {
 	struct net_device *dev;
+	int res;
 
 	dev = alloc_netdev(sizeof(struct net_bridge), name,
 			   br_dev_setup);
@@ -240,7 +241,10 @@ int br_add_bridge(struct net *net, const
 
 	dev_net_set(dev, net);
 
-	return register_netdev(dev);
+	res = register_netdev(dev);
+	if (res)
+		free_netdev(dev);
+	return res;
 }
 
 int br_del_bridge(struct net *net, const char *name)


