Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759070Ab0E1D2g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 23:28:36 -0400
Received: from mail-pz0-f176.google.com ([209.85.222.176]:43360 "EHLO
	mail-pz0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756734Ab0E1D2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 23:28:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=pX1kZB/tpHUAZixiXlW90yyvzsYbanjRIsR3SgHQVi1LCjtxtTu2/rD06P04zXSZPA
         QvDkM56E1vepcnp56TzfY9yw62HpIj1F9gmmxkvGO7kQACybnNd/uoC33+Ng5lhkOIL2
         rOfODODNTDk/G62/8UqoShfgUio8cP+lcXkOU=
Subject: [PATCH] cdc-acm: fix resource reclaim in error path of acm_probe
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Oliver Neukum <oliver@neukum.name>, Greg Kroah-Hartman <gregkh@suse.de>,
       Alan Cox <alan@linux.intel.com>,
       Francesco Lavra <francescolavra@interfree.it>,
       Julian Calaby <julian.calaby@gmail.com>, linux-usb@vger.kernel.org
Content-Type: text/plain
Date: Fri, 28 May 2010 11:28:31 +0800
Message-Id: <1275017311.11371.2.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes resource reclaim in error path of acm_probe:
1. In the case of "out of memory (write urbs usb_alloc_urb)",
usb_alloc_urb may fail in any iteration of the for loop.
Current implementation does not properly free allocated snd->urb.
2. In the case of device_create_file(&intf->dev,&dev_attr_iCountryCodeRelDate)
fail, acm->country_codes is kfreed. As a result, device_remove_file for
dev_attr_wCountryCodes will not be executed in acm_disconnect.
3. This patch also improves the error handling by only reclaim successfully
allocated resources instead of iterate over all entries in the for loop.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/usb/class/cdc-acm.c |   40 +++++++++++++++++++++++-----------------
 1 files changed, 23 insertions(+), 17 deletions(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 0c2f14f..e215b9a 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -950,8 +950,9 @@ static int acm_probe(struct usb_interface *intf,
 	int data_interface_num;
 	unsigned long quirks;
 	int num_rx_buf;
-	int i;
+	int i, j, k;
 	int combined_interfaces = 0;
+	int retval;
 
 	/* normal quirks */
 	quirks = (unsigned long)id->driver_info;
@@ -1201,14 +1202,14 @@ made_compressed_probe:
 		if (rcv->urb == NULL) {
 			dev_dbg(&intf->dev,
 				"out of memory (read urbs usb_alloc_urb)\n");
-			goto alloc_fail7;
+			goto alloc_fail6;
 		}
 
 		rcv->urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
 		rcv->instance = acm;
 	}
-	for (i = 0; i < num_rx_buf; i++) {
-		struct acm_rb *rb = &(acm->rb[i]);
+	for (j = 0; j < num_rx_buf; j++) {
+		struct acm_rb *rb = &(acm->rb[j]);
 
 		rb->base = usb_alloc_coherent(acm->dev, readsize,
 				GFP_KERNEL, &rb->dma);
@@ -1218,14 +1219,14 @@ made_compressed_probe:
 			goto alloc_fail7;
 		}
 	}
-	for (i = 0; i < ACM_NW; i++) {
-		struct acm_wb *snd = &(acm->wb[i]);
+	for (k = 0; k < ACM_NW; k++) {
+		struct acm_wb *snd = &(acm->wb[k]);
 
 		snd->urb = usb_alloc_urb(0, GFP_KERNEL);
 		if (snd->urb == NULL) {
 			dev_dbg(&intf->dev,
 				"out of memory (write urbs usb_alloc_urb)");
-			goto alloc_fail7;
+			goto alloc_fail8;
 		}
 
 		if (usb_endpoint_xfer_int(epwrite))
@@ -1242,8 +1243,8 @@ made_compressed_probe:
 
 	usb_set_intfdata(intf, acm);
 
-	i = device_create_file(&intf->dev, &dev_attr_bmCapabilities);
-	if (i < 0)
+	retval = device_create_file(&intf->dev, &dev_attr_bmCapabilities);
+	if (retval < 0)
 		goto alloc_fail8;
 
 	if (cfd) { /* export the country data */
@@ -1255,15 +1256,17 @@ made_compressed_probe:
 							cfd->bLength - 4);
 		acm->country_rel_date = cfd->iCountryCodeRelDate;
 
-		i = device_create_file(&intf->dev, &dev_attr_wCountryCodes);
-		if (i < 0) {
+		retval = device_create_file(&intf->dev,
+						&dev_attr_wCountryCodes);
+		if (retval < 0) {
 			kfree(acm->country_codes);
 			goto skip_countries;
 		}
 
-		i = device_create_file(&intf->dev,
+		retval = device_create_file(&intf->dev,
 						&dev_attr_iCountryCodeRelDate);
-		if (i < 0) {
+		if (retval < 0) {
+			device_remove_file(&intf->dev, &dev_attr_wCountryCodes);
 			kfree(acm->country_codes);
 			goto skip_countries;
 		}
@@ -1296,11 +1299,14 @@ skip_countries:
 
 	return 0;
 alloc_fail8:
-	for (i = 0; i < ACM_NW; i++)
-		usb_free_urb(acm->wb[i].urb);
+	while (--k >= 0)
+		usb_free_urb(acm->wb[k].urb);
 alloc_fail7:
-	acm_read_buffers_free(acm);
-	for (i = 0; i < num_rx_buf; i++)
+	while (--j >= 0)
+		usb_free_coherent(acm->dev, readsize, acm->rb[j].base,
+					acm->rb[j].dma);
+alloc_fail6:
+	while (--i >= 0)
 		usb_free_urb(acm->ru[i].urb);
 	usb_free_urb(acm->ctrlurb);
 alloc_fail5:
-- 
1.5.4.3



