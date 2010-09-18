Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041Ab0IRTCQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:02:16 -0400
Received: from kroah.org ([198.145.64.141]:51208 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754693Ab0IRTBZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:01:25 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 11:59:55 2010
Message-Id: <20100918185955.054154541@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:57:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Johan Hovold <jhovold@gmail.com>
Subject: [026/123] USB: mos7840: fix DMA buffers on stack and endianess bugs
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=usb-mos7840-fix-dma-buffers-on-stack-and-endianess-bugs.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johan Hovold <jhovold@gmail.com>

commit 9e221a35f82cbef0397d81fed588bafba95b550c upstream.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/mos7840.c |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -286,12 +286,19 @@ static int mos7840_get_reg_sync(struct u
 {
 	struct usb_device *dev = port->serial->dev;
 	int ret = 0;
+	u8 *buf;
+
+	buf = kmalloc(VENDOR_READ_LENGTH, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
 
 	ret = usb_control_msg(dev, usb_rcvctrlpipe(dev, 0), MCS_RDREQ,
-			      MCS_RD_RTYPE, 0, reg, val, VENDOR_READ_LENGTH,
+			      MCS_RD_RTYPE, 0, reg, buf, VENDOR_READ_LENGTH,
 			      MOS_WDR_TIMEOUT);
+	*val = buf[0];
 	dbg("mos7840_get_reg_sync offset is %x, return val %x", reg, *val);
-	*val = (*val) & 0x00ff;
+
+	kfree(buf);
 	return ret;
 }
 
@@ -344,6 +351,11 @@ static int mos7840_get_uart_reg(struct u
 	struct usb_device *dev = port->serial->dev;
 	int ret = 0;
 	__u16 Wval;
+	u8 *buf;
+
+	buf = kmalloc(VENDOR_READ_LENGTH, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
 
 	/* dbg("application number is %4x",
 	    (((__u16)port->number - (__u16)(port->serial->minor))+1)<<8); */
@@ -367,9 +379,11 @@ static int mos7840_get_uart_reg(struct u
 		}
 	}
 	ret = usb_control_msg(dev, usb_rcvctrlpipe(dev, 0), MCS_RDREQ,
-			      MCS_RD_RTYPE, Wval, reg, val, VENDOR_READ_LENGTH,
+			      MCS_RD_RTYPE, Wval, reg, buf, VENDOR_READ_LENGTH,
 			      MOS_WDR_TIMEOUT);
-	*val = (*val) & 0x00ff;
+	*val = buf[0];
+
+	kfree(buf);
 	return ret;
 }
 


