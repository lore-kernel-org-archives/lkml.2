Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755747Ab2GaExU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 00:53:20 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48854 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755179Ab2GaEvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 00:51:08 -0400
Message-Id: <20120731044315.961248342@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Tue, 31 Jul 2012 05:43:39 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Kevin Cernekee <cernekee@gmail.com>,
        Felipe Balbi <balbi@ti.com>
Subject: [ 29/73] usb: gadget: Fix g_ether interface link status
In-Reply-To: <20120731044310.013763753@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kevin Cernekee <cernekee@gmail.com>

commit 31bde1ceaa873bcaecd49e829bfabceacc4c512d upstream.

A "usb0" interface that has never been connected to a host has an unknown
operstate, and therefore the IFF_RUNNING flag is (incorrectly) asserted
when queried by ifconfig, ifplugd, etc.  This is a result of calling
netif_carrier_off() too early in the probe function; it should be called
after register_netdev().

Similar problems have been fixed in many other drivers, e.g.:

    e826eafa6 (bonding: Call netif_carrier_off after register_netdevice)
    0d672e9f8 (drivers/net: Call netif_carrier_off at the end of the probe)
    6a3c869a6 (cxgb4: fix reported state of interfaces without link)

Fix is to move netif_carrier_off() to the end of the function.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/gadget/u_ether.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/gadget/u_ether.c b/drivers/usb/gadget/u_ether.c
index 47cf48b..5b46f02 100644
--- a/drivers/usb/gadget/u_ether.c
+++ b/drivers/usb/gadget/u_ether.c
@@ -798,12 +798,6 @@ int gether_setup_name(struct usb_gadget *g, u8 ethaddr[ETH_ALEN],
 
 	SET_ETHTOOL_OPS(net, &ops);
 
-	/* two kinds of host-initiated state changes:
-	 *  - iff DATA transfer is active, carrier is "on"
-	 *  - tx queueing enabled if open *and* carrier is "on"
-	 */
-	netif_carrier_off(net);
-
 	dev->gadget = g;
 	SET_NETDEV_DEV(net, &g->dev);
 	SET_NETDEV_DEVTYPE(net, &gadget_type);
@@ -817,6 +811,12 @@ int gether_setup_name(struct usb_gadget *g, u8 ethaddr[ETH_ALEN],
 		INFO(dev, "HOST MAC %pM\n", dev->host_mac);
 
 		the_dev = dev;
+
+		/* two kinds of host-initiated state changes:
+		 *  - iff DATA transfer is active, carrier is "on"
+		 *  - tx queueing enabled if open *and* carrier is "on"
+		 */
+		netif_carrier_off(net);
 	}
 
 	return status;


