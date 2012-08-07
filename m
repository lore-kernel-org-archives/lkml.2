Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932424Ab2HGW2e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 18:28:34 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:38566 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932379Ab2HGW23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:28:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Kevin Cernekee <cernekee@gmail.com>, Felipe Balbi <balbi@ti.com>
Subject: [ 029/122] usb: gadget: Fix g_ether interface link status
Date: Tue,  7 Aug 2012 15:25:17 -0700
Message-Id: <20120807221950.849213000@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807221948.220495155@linuxfoundation.org>
References: <20120807221948.220495155@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/u_ether.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/usb/gadget/u_ether.c
+++ b/drivers/usb/gadget/u_ether.c
@@ -798,12 +798,6 @@ int gether_setup_name(struct usb_gadget
 
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
@@ -817,6 +811,12 @@ int gether_setup_name(struct usb_gadget
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


