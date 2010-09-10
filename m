Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587Ab0IJVgN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 17:36:13 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:43984 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753045Ab0IJVgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 17:36:12 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: David Brownell <david-b@pacbell.net>
Subject: [PATCH v2] usbnet: do not count empty skbs as errors in rx_process()
Date: Fri, 10 Sep 2010 23:35:58 +0200
User-Agent: KMail/1.9.10
Cc: David Brownell <dbrownell@users.sourceforge.net>, netdev@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
References: <436709.64173.qm@web180305.mail.gq1.yahoo.com>
In-Reply-To: <436709.64173.qm@web180305.mail.gq1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201009102336.00722.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If rx_fixup() returns an empty skb (because it consumed all data inside), do
not count it as error.

This is needed for cx82310_eth. It also may allow other usbnet minidrivers'
rx_fixup() functions to be simplified (no need to leave the last packet in the
skb anymore).

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
The patch does not pass checkpatch.pl because the function calls match the
style used in usbnet.c.

--- linux-2.6.36-rc3-orig/drivers/net/usb/usbnet.c	2010-08-29 17:36:04.000000000 +0200
+++ linux-2.6.36-rc3/drivers/net/usb/usbnet.c	2010-09-10 20:10:10.000000000 +0200
@@ -387,17 +387,11 @@
 {
 	if (dev->driver_info->rx_fixup &&
 	    !dev->driver_info->rx_fixup (dev, skb))
-		goto error;
-	// else network stack removes extra byte if we forced a short packet
-
-	if (skb->len)
-		usbnet_skb_return (dev, skb);
-	else {
-		netif_dbg(dev, rx_err, dev->net, "drop\n");
-error:
 		dev->net->stats.rx_errors++;
-		skb_queue_tail (&dev->done, skb);
-	}
+	else if (skb->len)
+		return usbnet_skb_return (dev, skb);
+
+	skb_queue_tail (&dev->done, skb);
 }
 
 /*-------------------------------------------------------------------------*/


-- 
Ondrej Zary
