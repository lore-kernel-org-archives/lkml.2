Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756390Ab2IIXTx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 19:19:53 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51573 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756476Ab2IIXRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 19:17:21 -0400
Message-Id: <20120909224153.377670259@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 09 Sep 2012 23:42:08 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Tatyana Brokhman <tlinder@codeaurora.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 18/95] usb: gadget: u_ether: fix kworker 100% CPU issue with still used
 interfaces in eth_stop
In-Reply-To: <20120909224150.641491654@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Grzeschik <m.grzeschik@pengutronix.de>

commit b1b552a69b8805e7e338074a9e8b670b4a795218 upstream.

This patch fixes an issue introduced by patch:

    72c973d usb: gadget: add usb_endpoint_descriptor to struct usb_ep

Without this patch we see a kworker taking 100% CPU, after this sequence:

- Connect gadget to a windows host
- load g_ether
- ifconfig up <ip>; ifconfig down; ifconfig up
- ping <windows host>

The "ifconfig down" results in calling eth_stop(), which will call
usb_ep_disable() and, if the carrier is still ok, usb_ep_enable():

         usb_ep_disable(link->in_ep);
         usb_ep_disable(link->out_ep);
         if (netif_carrier_ok(net)) {
                 usb_ep_enable(link->in_ep);
                 usb_ep_enable(link->out_ep);
         }

The ep should stay enabled, but will not, as ep_disable set the desc
pointer to NULL, therefore the subsequent ep_enable will fail. This leads
to permanent rescheduling of the eth_work() worker as usb_ep_queue()
(called by the worker) will fail due to the unconfigured endpoint.

We fix this issue by saving the ep descriptors and re-assign them before
usb_ep_enable().

Cc: Tatyana Brokhman <tlinder@codeaurora.org>
Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/gadget/u_ether.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/usb/gadget/u_ether.c b/drivers/usb/gadget/u_ether.c
index 90e82e2..0e52309 100644
--- a/drivers/usb/gadget/u_ether.c
+++ b/drivers/usb/gadget/u_ether.c
@@ -669,6 +669,8 @@ static int eth_stop(struct net_device *net)
 	spin_lock_irqsave(&dev->lock, flags);
 	if (dev->port_usb) {
 		struct gether	*link = dev->port_usb;
+		const struct usb_endpoint_descriptor *in;
+		const struct usb_endpoint_descriptor *out;
 
 		if (link->close)
 			link->close(link);
@@ -682,10 +684,14 @@ static int eth_stop(struct net_device *net)
 		 * their own pace; the network stack can handle old packets.
 		 * For the moment we leave this here, since it works.
 		 */
+		in = link->in_ep->desc;
+		out = link->out_ep->desc;
 		usb_ep_disable(link->in_ep);
 		usb_ep_disable(link->out_ep);
 		if (netif_carrier_ok(net)) {
 			DBG(dev, "host still using in/out endpoints\n");
+			link->in_ep->desc = in;
+			link->out_ep->desc = out;
 			usb_ep_enable(link->in_ep);
 			usb_ep_enable(link->out_ep);
 		}


