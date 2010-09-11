Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450Ab0IKPkm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 11:40:42 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:41145 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753171Ab0IKPkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 11:40:31 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: David Miller <davem@davemloft.net>
Subject: [PATCH net-next-2.6] cx82310_eth: allow empty URBs
Date: Sat, 11 Sep 2010 17:40:16 +0200
User-Agent: KMail/1.9.10
Cc: netdev@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201009111740.18843.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Empty received URBs are currently counted as errors but the device sends them
sometimes as part of regular traffic - so remove this check.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- linux-2.6.36-rc3-/drivers/net/usb/cx82310_eth.c	2010-09-11 17:31:44.000000000 +0200
+++ linux-2.6.36-rc3/drivers/net/usb/cx82310_eth.c	2010-09-11 17:21:22.000000000 +0200
@@ -150,11 +150,11 @@ static int cx82310_bind(struct usbnet *d
 
 	/*
 	 * this must not include ethernet header as the device can send partial
-	 * packets with no header (URB is at least 2 bytes long, so 2 is OK)
+	 * packets with no header (and sometimes even empty URBs)
 	 */
-	dev->net->hard_header_len = 2;
+	dev->net->hard_header_len = 0;
 	/* we can send at most 1514 bytes of data (+ 2-byte header) per URB */
-	dev->hard_mtu = CX82310_MTU + dev->net->hard_header_len;
+	dev->hard_mtu = CX82310_MTU + 2;
 	/* we can receive URBs up to 4KB from the device */
 	dev->rx_urb_size = 4096;
 
@@ -228,12 +228,6 @@ static int cx82310_rx_fixup(struct usbne
 			return 1;
 	}
 
-	if (skb->len < 2) {
-		dev_err(&dev->udev->dev, "RX frame too short: %d B\n",
-			skb->len);
-		return 0;
-	}
-
 	/* a skb can contain multiple packets */
 	while (skb->len > 1) {
 		/* first two bytes are packet length */


-- 
Ondrej Zary
