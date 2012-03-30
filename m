Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935306Ab2C3VIJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:08:09 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54199 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935259Ab2C3VIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:08:00 -0400
Message-Id: <20120330195735.625709827@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:58:56 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Marcel Holtmann <marcel@holtmann.org>,
        Bing Zhao <bzhao@marvell.com>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>
Subject: [ 094/108] Bluetooth: btusb: fix bInterval for high/super speed isochronous endpoints
In-Reply-To: <20120330195812.GA31833@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bing Zhao <bzhao@marvell.com>

commit fa0fb93f2ac308a76fa64eb57c18511dadf97089 upstream.

For high-speed/super-speed isochronous endpoints, the bInterval
value is used as exponent, 2^(bInterval-1). Luckily we have
usb_fill_int_urb() function that handles it correctly. So we just
call this function to fill in the RX URB.

Cc: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Acked-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Gustavo F. Padovan <padovan@profusion.mobi>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/bluetooth/btusb.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -498,15 +498,10 @@ static int btusb_submit_isoc_urb(struct
 
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


