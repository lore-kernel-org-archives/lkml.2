Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881Ab0KDFzz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 01:55:55 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47934 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754187Ab0KDFzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 01:55:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=FohMC6J2BWReezok+zrepvIngYkZHQYrasQBRjAlNVnMfzyceC2/22Bn+biEwCc1gL
         0T3aM7wDZC51GgN7UFZ3m0DwpAycp5conXT/ydEYgH3mLzae9sTW2iI32QmOyK4BeRzq
         Wjeb/3W/B7GKU+lqPYCySojw7zvNxWpdiMMbA=
Subject: [PATCH] mmc: Return proper error code for ushc_probe()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: David Vrabel <david.vrabel@csr.com>, Chris Ball <cjb@laptop.org>,
        linux-mmc@vger.kernel.org
Content-Type: text/plain
Date: Thu, 04 Nov 2010 13:59:11 +0800
Message-Id: <1288850351.3429.2.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mmc/host/ushc.c |   30 ++++++++++++++++++++++--------
 1 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/drivers/mmc/host/ushc.c b/drivers/mmc/host/ushc.c
index b4ead4a..f8f65df 100644
--- a/drivers/mmc/host/ushc.c
+++ b/drivers/mmc/host/ushc.c
@@ -425,7 +425,7 @@ static int ushc_probe(struct usb_interface *intf, const struct usb_device_id *id
 	struct usb_device *usb_dev = interface_to_usbdev(intf);
 	struct mmc_host *mmc;
 	struct ushc_data *ushc;
-	int ret = -ENOMEM;
+	int ret;
 
 	mmc = mmc_alloc_host(sizeof(struct ushc_data), &intf->dev);
 	if (mmc == NULL)
@@ -462,11 +462,15 @@ static int ushc_probe(struct usb_interface *intf, const struct usb_device_id *id
 	mmc->max_blk_count = 511;
 
 	ushc->int_urb = usb_alloc_urb(0, GFP_KERNEL);
-	if (ushc->int_urb == NULL)
+	if (ushc->int_urb == NULL) {
+		ret = -ENOMEM;
 		goto err;
+	}
 	ushc->int_data = kzalloc(sizeof(struct ushc_int_data), GFP_KERNEL);
-	if (ushc->int_data == NULL)
+	if (ushc->int_data == NULL) {
+		ret = -ENOMEM;
 		goto err;
+	}
 	usb_fill_int_urb(ushc->int_urb, ushc->usb_dev,
 			 usb_rcvintpipe(usb_dev,
 					intf->cur_altsetting->endpoint[0].desc.bEndpointAddress),
@@ -475,11 +479,15 @@ static int ushc_probe(struct usb_interface *intf, const struct usb_device_id *id
 			 intf->cur_altsetting->endpoint[0].desc.bInterval);
 
 	ushc->cbw_urb = usb_alloc_urb(0, GFP_KERNEL);
-	if (ushc->cbw_urb == NULL)
+	if (ushc->cbw_urb == NULL) {
+		ret = -ENOMEM;
 		goto err;
+	}
 	ushc->cbw = kzalloc(sizeof(struct ushc_cbw), GFP_KERNEL);
-	if (ushc->cbw == NULL)
+	if (ushc->cbw == NULL) {
+		ret = -ENOMEM;
 		goto err;
+	}
 	ushc->cbw->signature = USHC_CBW_SIGNATURE;
 
 	usb_fill_bulk_urb(ushc->cbw_urb, ushc->usb_dev, usb_sndbulkpipe(usb_dev, 2),
@@ -487,15 +495,21 @@ static int ushc_probe(struct usb_interface *intf, const struct usb_device_id *id
 			  cbw_callback, ushc);
 
 	ushc->data_urb = usb_alloc_urb(0, GFP_KERNEL);
-	if (ushc->data_urb == NULL)
+	if (ushc->data_urb == NULL) {
+		ret = -ENOMEM;
 		goto err;
+	}
 
 	ushc->csw_urb = usb_alloc_urb(0, GFP_KERNEL);
-	if (ushc->csw_urb == NULL)
+	if (ushc->csw_urb == NULL) {
+		ret = -ENOMEM;
 		goto err;
+	}
 	ushc->csw = kzalloc(sizeof(struct ushc_cbw), GFP_KERNEL);
-	if (ushc->csw == NULL)
+	if (ushc->csw == NULL) {
+		ret = -ENOMEM;
 		goto err;
+	}
 	usb_fill_bulk_urb(ushc->csw_urb, ushc->usb_dev, usb_rcvbulkpipe(usb_dev, 6),
 			  ushc->csw, sizeof(struct ushc_csw),
 			  csw_callback, ushc);
-- 
1.7.2



