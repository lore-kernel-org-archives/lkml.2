Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758602Ab2JKKej (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 06:34:39 -0400
Received: from mail-1-out2.atlantis.sk ([80.94.52.71]:42976 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758567Ab2JKKeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 06:34:11 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: "Andreas Mohr" <andi@lisas.de>
Subject: [PATCH] mcs7830: Fix link state detection
Date: Thu, 11 Oct 2012 12:33:28 +0200
User-Agent: KMail/1.9.10 (enterprise35 0.20100827.1168748)
Cc: "Greg KH" <gregkh@linuxfoundation.org>, davem@davemloft.net,
        Michael Leun <lkml20120218@newton.leun.net>, netdev@vger.kernel.org,
        Michael Leun <lkml20120218@newton.leun.net>,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201210111233.28652.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The device had an undocumented "feature": it can provide a sequence of
spurious link-down status data even if the link is up all the time.
A sequence of 10 was seen so update the link state only after the device
reports the same link state 20 times.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
Reported-by: Michael Leun <lkml20120218@newton.leun.net>
Tested-by: Michael Leun <lkml20120218@newton.leun.net>
---
 drivers/net/usb/mcs7830.c |   21 ++++++++++++++-------
 1 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/net/usb/mcs7830.c b/drivers/net/usb/mcs7830.c
index 03c2d8d..3a02a5d 100644
--- a/drivers/net/usb/mcs7830.c
+++ b/drivers/net/usb/mcs7830.c
@@ -117,6 +117,7 @@ enum {
 struct mcs7830_data {
 	u8 multi_filter[8];
 	u8 config;
+	u8 link_counter;
 };
 
 static const char driver_name[] = "MOSCHIP usb-ethernet driver";
@@ -633,19 +634,25 @@ static void mcs7830_status(struct usbnet *dev, struct 
urb *urb)
 {
 	u8 *buf = urb->transfer_buffer;
 	bool link;
+	struct mcs7830_data *data = mcs7830_get_data(dev);
 
 	if (urb->actual_length < 16)
 		return;
 
 	link = !(buf[1] & 0x20);
 	if (netif_carrier_ok(dev->net) != link) {
-		if (link) {
-			netif_carrier_on(dev->net);
-			usbnet_defer_kevent(dev, EVENT_LINK_RESET);
-		} else
-			netif_carrier_off(dev->net);
-		netdev_dbg(dev->net, "Link Status is: %d\n", link);
-	}
+		data->link_counter++;
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
-- 
Ondrej Zary
