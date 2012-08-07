Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031119Ab2HGWqI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 18:46:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36543 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031104Ab2HGWqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:46:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Kevin Cernekee <cernekee@gmail.com>, Felipe Balbi <balbi@ti.com>
Subject: [ 13/49] usb: gadget: Fix g_ether interface link status
Date: Tue,  7 Aug 2012 15:44:31 -0700
Message-Id: <20120807222028.050350415@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807222026.848194739@linuxfoundation.org>
References: <20120807222026.848194739@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -803,12 +803,6 @@ int gether_setup(struct usb_gadget *g, u
 
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
@@ -822,6 +816,12 @@ int gether_setup(struct usb_gadget *g, u
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


