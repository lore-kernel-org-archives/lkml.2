Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933666Ab2JAXlo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:41:44 -0400
Received: from 1wt.eu ([62.212.114.60]:34954 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932326Ab2JAW70 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 18:59:26 -0400
Message-Id: <20121001225157.781095283@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:52:01 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Marcel Holtmann <marcel@holtmann.org>, Bing Zhao <bzhao@marvell.com>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 004/180] Bluetooth: btusb: fix bInterval for high/super speed isochronous endpoints
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Bing Zhao <bzhao@marvell.com>

commit fa0fb93f2ac308a76fa64eb57c18511dadf97089 upstream

For high-speed/super-speed isochronous endpoints, the bInterval
value is used as exponent, 2^(bInterval-1). Luckily we have
usb_fill_int_urb() function that handles it correctly. So we just
call this function to fill in the RX URB.

Cc: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Acked-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Gustavo F. Padovan <padovan@profusion.mobi>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/bluetooth/btusb.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 75185a6..a562761 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -470,15 +470,10 @@ static int btusb_submit_isoc_urb(struct hci_dev *hdev, gfp_t mem_flags)
 
 	pipe = usb_rcvisocpipe(data->udev, data->isoc_rx_ep->bEndpointAddress);
 
-	urb->dev      = data->udev;
-	urb->pipe     = pipe;
-	urb->context  = hdev;
-	urb->complete = btusb_isoc_complete;
-	urb->interval = data->isoc_rx_ep->bInterval;
+	usb_fill_int_urb(urb, data->udev, pipe, buf, size, btusb_isoc_complete,
+				hdev, data->isoc_rx_ep->bInterval);
 
 	urb->transfer_flags  = URB_FREE_BUFFER | URB_ISO_ASAP;
-	urb->transfer_buffer = buf;
-	urb->transfer_buffer_length = size;
 
 	__fill_isoc_descriptor(urb, size,
 			le16_to_cpu(data->isoc_rx_ep->wMaxPacketSize));
-- 
1.7.2.1.45.g54fbc



