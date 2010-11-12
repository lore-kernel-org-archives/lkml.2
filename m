Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480Ab0KLCoi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 21:44:38 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:59328 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753787Ab0KLCog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 21:44:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=nom4hJtmAPUaxiavJxV1SGl1MkvRTyNgmkbbI6620rw0Y98r0puOffvPoE/z/cCN1t
         2MEbr8ZGiFH5xTtv3iv+Wsry6IB3SAu3VeMwaTEmyd/g9k9N2Dx6XPbrRLcZrkusWboE
         PLZhUF7Zlo1Hu737K/izSpvCptHkkhSfXhkIQ=
Subject: [PATCH 1/3] Input: xpad - return proper error in error path
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Marko Friedemann <mfr@bmx-chemnitz.de>,
        Christoph Fritz <chf.fritz@googlemail.com>,
        linux-input@vger.kernel.org
Content-Type: text/plain
Date: Fri, 12 Nov 2010 10:48:36 +0800
Message-Id: <1289530116.20782.2.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In current implementation, xpad_probe return 0 when
usb_alloc_urb failed for xpad->bulk_out and kzalloc failed for xpad->bdata.

This patch removes the initialization for error variable,
assign the error code at the place the error happens instead.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/input/joystick/xpad.c |   33 +++++++++++++++++++++++----------
 1 files changed, 23 insertions(+), 10 deletions(-)

diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
index f9fb7fa..39c0265 100644
--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -543,21 +543,25 @@ exit:
 static int xpad_init_output(struct usb_interface *intf, struct usb_xpad *xpad)
 {
 	struct usb_endpoint_descriptor *ep_irq_out;
-	int error = -ENOMEM;
+	int error;
 
 	if (xpad->xtype != XTYPE_XBOX360 && xpad->xtype != XTYPE_XBOX)
 		return 0;
 
 	xpad->odata = usb_alloc_coherent(xpad->udev, XPAD_PKT_LEN,
 					 GFP_KERNEL, &xpad->odata_dma);
-	if (!xpad->odata)
+	if (!xpad->odata) {
+		error = -ENOMEM;
 		goto fail1;
+	}
 
 	mutex_init(&xpad->odata_mutex);
 
 	xpad->irq_out = usb_alloc_urb(0, GFP_KERNEL);
-	if (!xpad->irq_out)
+	if (!xpad->irq_out) {
+		error = -ENOMEM;
 		goto fail2;
+	}
 
 	ep_irq_out = &intf->cur_altsetting->endpoint[1].desc;
 	usb_fill_int_urb(xpad->irq_out, xpad->udev,
@@ -789,8 +793,7 @@ static int xpad_probe(struct usb_interface *intf, const struct usb_device_id *id
 	struct usb_xpad *xpad;
 	struct input_dev *input_dev;
 	struct usb_endpoint_descriptor *ep_irq_in;
-	int i;
-	int error = -ENOMEM;
+	int i, error;
 
 	for (i = 0; xpad_device[i].idVendor; i++) {
 		if ((le16_to_cpu(udev->descriptor.idVendor) == xpad_device[i].idVendor) &&
@@ -800,17 +803,23 @@ static int xpad_probe(struct usb_interface *intf, const struct usb_device_id *id
 
 	xpad = kzalloc(sizeof(struct usb_xpad), GFP_KERNEL);
 	input_dev = input_allocate_device();
-	if (!xpad || !input_dev)
+	if (!xpad || !input_dev) {
+		error = -ENOMEM;
 		goto fail1;
+	}
 
 	xpad->idata = usb_alloc_coherent(udev, XPAD_PKT_LEN,
 					 GFP_KERNEL, &xpad->idata_dma);
-	if (!xpad->idata)
+	if (!xpad->idata) {
+		error = -ENOMEM;
 		goto fail1;
+	}
 
 	xpad->irq_in = usb_alloc_urb(0, GFP_KERNEL);
-	if (!xpad->irq_in)
+	if (!xpad->irq_in) {
+		error = -ENOMEM;
 		goto fail2;
+	}
 
 	xpad->udev = udev;
 	xpad->mapping = xpad_device[i].mapping;
@@ -929,12 +938,16 @@ static int xpad_probe(struct usb_interface *intf, const struct usb_device_id *id
 		 * controller when it shows up
 		 */
 		xpad->bulk_out = usb_alloc_urb(0, GFP_KERNEL);
-		if(!xpad->bulk_out)
+		if (!xpad->bulk_out) {
+			error = -ENOMEM;
 			goto fail5;
+		}
 
 		xpad->bdata = kzalloc(XPAD_PKT_LEN, GFP_KERNEL);
-		if(!xpad->bdata)
+		if (!xpad->bdata) {
+			error = -ENOMEM;
 			goto fail6;
+		}
 
 		xpad->bdata[2] = 0x08;
 		switch (intf->cur_altsetting->desc.bInterfaceNumber) {
-- 
1.7.2



