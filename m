Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933330Ab0HLAJL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:09:11 -0400
Received: from kroah.org ([198.145.64.141]:47947 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933240Ab0HLAIz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 20:08:55 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 17:06:17 2010
Message-Id: <20100812000617.824920522@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 17:06:11 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Johan Hovold <jhovold@gmail.com>
Subject: [56/67] USB: serial: fix stalled writes
In-Reply-To: <20100812000641.GA6348@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit b58af4066d240b18b43f202e07b9ec7461d90b17 upstream.

As David VomLehn points out, it was possible to receive an interrupt
before clearing the free-urb flag which could lead to the urb being
incorrectly marked as busy.

For the same reason, move tx_bytes accounting so that it will never be
negative.

Note that the free-flags set and clear operations do not need any
additional locking as they are manipulated while USB_SERIAL_WRITE_BUSY
is set.

Reported-by: David VomLehn <dvomlehn@cisco.com>
Tested-by: David VomLehn <dvomlehn@cisco.com>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/generic.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/drivers/usb/serial/generic.c
+++ b/drivers/usb/serial/generic.c
@@ -208,18 +208,23 @@ retry:
 	urb->transfer_buffer_length = count;
 	usb_serial_debug_data(debug, &port->dev, __func__, count,
 						urb->transfer_buffer);
+	spin_lock_irqsave(&port->lock, flags);
+	port->tx_bytes += count;
+	spin_unlock_irqrestore(&port->lock, flags);
+
+	clear_bit(i, &port->write_urbs_free);
 	result = usb_submit_urb(urb, GFP_ATOMIC);
 	if (result) {
 		dev_err(&port->dev, "%s - error submitting urb: %d\n",
 						__func__, result);
+		set_bit(i, &port->write_urbs_free);
+		spin_lock_irqsave(&port->lock, flags);
+		port->tx_bytes -= count;
+		spin_unlock_irqrestore(&port->lock, flags);
+
 		clear_bit_unlock(USB_SERIAL_WRITE_BUSY, &port->flags);
 		return result;
 	}
-	clear_bit(i, &port->write_urbs_free);
-
-	spin_lock_irqsave(&port->lock, flags);
-	port->tx_bytes += count;
-	spin_unlock_irqrestore(&port->lock, flags);
 
 	/* Try sending off another urb, unless in irq context (in which case
 	 * there will be no free urb). */


