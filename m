Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306Ab2JZESU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 00:18:20 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:51211 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965Ab2JZESR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 00:18:17 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6876"; a="1923137"
From: Hemant Kumar <hemantk@codeaurora.org>
To: oneukum@suse.de
Cc: gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Hemant Kumar <hemantk@codeaurora.org>
Subject: [PATCH] net: usb: Fix memory leak on Tx data path
Date: Thu, 25 Oct 2012 21:17:54 -0700
Message-Id: <1351225074-2078-1-git-send-email-hemantk@codeaurora.org>
X-Mailer: git-send-email 1.7.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver anchors the tx urbs and defers the urb submission if
a transmit request comes when the interface is suspended.
Anchoring urb increments the urb reference count. These
deferred urbs are later accessed by calling usb_get_from_anchor()
for submission during interface resume. usb_get_from_anchor()
unanchors the urb but urb reference count remains same.
This causes the urb reference count to remain non-zero
after usb_free_urb() gets called and urb never gets freed.
Hence call usb_put_urb() after anchoring the urb to properly
balance the reference count for these deferred urbs. Also,
unanchor these deferred urbs during disconnect, to free them
up.

Signed-off-by: Hemant Kumar <hemantk@codeaurora.org>
---
 drivers/net/usb/usbnet.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index 1867fe2..00b7598 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -1168,6 +1168,7 @@ netdev_tx_t usbnet_start_xmit (struct sk_buff *skb,
 		usb_anchor_urb(urb, &dev->deferred);
 		/* no use to process more packets */
 		netif_stop_queue(net);
+		usb_put_urb(urb);
 		spin_unlock_irqrestore(&dev->txq.lock, flags);
 		netdev_dbg(dev->net, "Delaying transmission for resumption\n");
 		goto deferred;
@@ -1317,6 +1318,8 @@ void usbnet_disconnect (struct usb_interface *intf)
 
 	cancel_work_sync(&dev->kevent);
 
+	usb_scuttle_anchored_urbs(&dev->deferred);
+
 	if (dev->driver_info->unbind)
 		dev->driver_info->unbind (dev, intf);
 
-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

