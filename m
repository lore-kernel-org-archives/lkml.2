Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341Ab2HTEEb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 00:04:31 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38485 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815Ab2HTEBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 00:01:35 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tatyana Brokhman <tlinder@codeaurora.org>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [ 38/46] usb: gadget: u_ether: fix kworker 100% CPU issue with still used interfaces in eth_stop
Date: Sun, 19 Aug 2012 20:59:14 -0700
Message-Id: <20120820035837.553778146@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.2.565.gbd578b5
In-Reply-To: <20120820035832.274275502@linuxfoundation.org>
References: <20120820035832.274275502@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/usb/gadget/u_ether.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/usb/gadget/u_ether.c
+++ b/drivers/usb/gadget/u_ether.c
@@ -669,6 +669,8 @@ static int eth_stop(struct net_device *n
 	spin_lock_irqsave(&dev->lock, flags);
 	if (dev->port_usb) {
 		struct gether	*link = dev->port_usb;
+		const struct usb_endpoint_descriptor *in;
+		const struct usb_endpoint_descriptor *out;
 
 		if (link->close)
 			link->close(link);
@@ -682,10 +684,14 @@ static int eth_stop(struct net_device *n
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


