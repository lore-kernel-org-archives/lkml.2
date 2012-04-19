Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932909Ab2DSVIX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 17:08:23 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41537 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932812Ab2DSVIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 17:08:19 -0400
Message-Id: <20120419210308.569898358@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 19 Apr 2012 14:04:07 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Tomoya MORINAGA <tomoya.rohm@gmail.com>,
        Felipe Balbi <balbi@ti.com>
Subject: [ 64/75] usb: gadget: pch_udc: Fix USB suspend issue
In-Reply-To: <20120419210322.GA6478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomoya MORINAGA <tomoya.rohm@gmail.com>

commit 84566abba058b2aae8d603dfa90b5a3778a6714f upstream.

ISSUE:
After USB Suspend, a system rarely freezes.

CAUSE:
When USB Suspend occurred, the driver is not notifying
a gadget of the event.

Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/pch_udc.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/usb/gadget/pch_udc.c
+++ b/drivers/usb/gadget/pch_udc.c
@@ -2476,8 +2476,15 @@ static void pch_udc_dev_isr(struct pch_u
 	if (dev_intr & UDC_DEVINT_SC)
 		pch_udc_svc_cfg_interrupt(dev);
 	/* USB Suspend interrupt */
-	if (dev_intr & UDC_DEVINT_US)
+	if (dev_intr & UDC_DEVINT_US) {
+		if (dev->driver
+			&& dev->driver->suspend) {
+			spin_unlock(&dev->lock);
+			dev->driver->suspend(&dev->gadget);
+			spin_lock(&dev->lock);
+		}
 		dev_dbg(&dev->pdev->dev, "USB_SUSPEND\n");
+	}
 	/* Clear the SOF interrupt, if enabled */
 	if (dev_intr & UDC_DEVINT_SOF)
 		dev_dbg(&dev->pdev->dev, "SOF\n");


