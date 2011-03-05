Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932765Ab1CEBFs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 20:05:48 -0500
Received: from kroah.org ([198.145.64.141]:47745 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932695Ab1CEBFL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 20:05:11 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar  4 17:03:53 2011
Message-Id: <20110305010353.482533027@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Fri, 04 Mar 2011 17:03:11 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ian Campbell <ian.campbell@citrix.com>,
        "David S. Miller" <davem@davemloft.net>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Mike Surcouf <mike@surcouf.co.uk>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [17/18] arp_notify: unconditionally send gratuitous ARP for NETDEV_NOTIFY_PEERS.
In-Reply-To: <20110305010410.GA18668@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

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
[reported to solve hyperv live migration problem - gkh]
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Mike Surcouf <mike@surcouf.co.uk>
Cc: Hank Janssen <hjanssen@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/devinet.c |   30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -1025,6 +1025,21 @@ static inline bool inetdev_valid_mtu(uns
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
@@ -1076,18 +1091,13 @@ static int inetdev_event(struct notifier
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


