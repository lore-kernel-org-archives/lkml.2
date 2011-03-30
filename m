Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964982Ab1C3VIm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:08:42 -0400
Received: from mga11.intel.com ([192.55.52.93]:33607 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933368Ab1C3VIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:08:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="903735749"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: Ian.Campbell@citrix.com, ian.campbell@citrix.com, davem@davemloft.net,
        ak@linux.intel.com, haiyangz@microsoft.com, mike@surcouf.co.uk,
        hjanssen@microsoft.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [171/275] arp_notify: unconditionally send gratuitous ARP for NETDEV_NOTIFY_PEERS.
Message-Id: <20110330210653.C01543E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:06:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Ian Campbell <Ian.Campbell@citrix.com>

commit d11327ad6695db8117c78d70611e71102ceec2ac upstream.

NETDEV_NOTIFY_PEER is an explicit request by the driver to send a link
notification while NETDEV_UP/NETDEV_CHANGEADDR generate link
notifications as a sort of side effect.

In the later cases the sysctl option is present because link
notification events can have undesired effects e.g. if the link is
flapping. I don't think this applies in the case of an explicit
request from a driver.

This patch makes NETDEV_NOTIFY_PEER unconditional, if preferred we
could add a new sysctl for this case which defaults to on.

This change causes Xen post-migration ARP notifications (which cause
switches to relearn their MAC tables etc) to be sent by default.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
[reported to solve hyperv live migration problem - gkh]
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Mike Surcouf <mike@surcouf.co.uk>
Cc: Hank Janssen <hjanssen@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/devinet.c |   30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

Index: linux-2.6.35.y/net/ipv4/devinet.c
===================================================================
--- linux-2.6.35.y.orig/net/ipv4/devinet.c	2011-03-29 22:50:55.819830128 -0700
+++ linux-2.6.35.y/net/ipv4/devinet.c	2011-03-29 23:03:01.802254055 -0700
@@ -1029,6 +1029,21 @@
 	return mtu >= 68;
 }
 
+static void inetdev_send_gratuitous_arp(struct net_device *dev,
+					struct in_device *in_dev)
+
+{
+	struct in_ifaddr *ifa = in_dev->ifa_list;
+
+	if (!ifa)
+		return;
+
+	arp_send(ARPOP_REQUEST, ETH_P_ARP,
+		 ifa->ifa_address, dev,
+		 ifa->ifa_address, NULL,
+		 dev->dev_addr, NULL);
+}
+
 /* Called only under RTNL semaphore */
 
 static int inetdev_event(struct notifier_block *this, unsigned long event,
@@ -1081,18 +1096,13 @@
 		}
 		ip_mc_up(in_dev);
 		/* fall through */
-	case NETDEV_NOTIFY_PEERS:
 	case NETDEV_CHANGEADDR:
+		if (!IN_DEV_ARP_NOTIFY(in_dev))
+			break;
+		/* fall through */
+	case NETDEV_NOTIFY_PEERS:
 		/* Send gratuitous ARP to notify of link change */
-		if (IN_DEV_ARP_NOTIFY(in_dev)) {
-			struct in_ifaddr *ifa = in_dev->ifa_list;
-
-			if (ifa)
-				arp_send(ARPOP_REQUEST, ETH_P_ARP,
-					 ifa->ifa_address, dev,
-					 ifa->ifa_address, NULL,
-					 dev->dev_addr, NULL);
-		}
+		inetdev_send_gratuitous_arp(dev, in_dev);
 		break;
 	case NETDEV_DOWN:
 		ip_mc_down(in_dev);
