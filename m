Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965077Ab2JSCtj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 22:49:39 -0400
Received: from mail.kernel.org ([198.145.19.201]:52486 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965033Ab2JSCt2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 22:49:28 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Ondrej Zary <linux@rainbow-software.org>,
        Michael Leun <lkml20120218@newton.leun.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 62/76] mcs7830: Fix link state detection
Date: Thu, 18 Oct 2012 19:47:26 -0700
Message-Id: <20121019024400.104361357@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121019024350.087156547@linuxfoundation.org>
References: <20121019024350.087156547@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ondrej Zary <linux@rainbow-software.org>

commit dabdaf0caa3af520dbc1df87b2fb4e77224037bd upstream.

The device had an undocumented "feature": it can provide a sequence of
spurious link-down status data even if the link is up all the time.
A sequence of 10 was seen so update the link state only after the device
reports the same link state 20 times.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
Reported-by: Michael Leun <lkml20120218@newton.leun.net>
Tested-by: Michael Leun <lkml20120218@newton.leun.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/usb/mcs7830.c |   30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

--- a/drivers/net/usb/mcs7830.c
+++ b/drivers/net/usb/mcs7830.c
@@ -117,6 +117,7 @@ enum {
 struct mcs7830_data {
 	u8 multi_filter[8];
 	u8 config;
+	u8 link_counter;
 };
 
 static const char driver_name[] = "MOSCHIP usb-ethernet driver";
@@ -632,20 +633,31 @@ static int mcs7830_rx_fixup(struct usbne
 static void mcs7830_status(struct usbnet *dev, struct urb *urb)
 {
 	u8 *buf = urb->transfer_buffer;
-	bool link;
+	bool link, link_changed;
+	struct mcs7830_data *data = mcs7830_get_data(dev);
 
 	if (urb->actual_length < 16)
 		return;
 
 	link = !(buf[1] & 0x20);
-	if (netif_carrier_ok(dev->net) != link) {
-		if (link) {
-			netif_carrier_on(dev->net);
-			usbnet_defer_kevent(dev, EVENT_LINK_RESET);
-		} else
-			netif_carrier_off(dev->net);
-		netdev_dbg(dev->net, "Link Status is: %d\n", link);
-	}
+	link_changed = netif_carrier_ok(dev->net) != link;
+	if (link_changed) {
+		data->link_counter++;
+		/*
+		   track link state 20 times to guard against erroneous
+		   link state changes reported sometimes by the chip
+		 */
+		if (data->link_counter > 20) {
+			data->link_counter = 0;
+			if (link) {
+				netif_carrier_on(dev->net);
+				usbnet_defer_kevent(dev, EVENT_LINK_RESET);
+			} else
+				netif_carrier_off(dev->net);
+			netdev_dbg(dev->net, "Link Status is: %d\n", link);
+		}
+	} else
+		data->link_counter = 0;
 }
 
 static const struct driver_info moschip_info = {


