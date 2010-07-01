Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933276Ab0GAVeV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:34:21 -0400
Received: from kroah.org ([198.145.64.141]:33087 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932738Ab0GAVO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:14:57 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:42:59 2010
Message-Id: <20100701174259.770525951@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:44:07 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Axel Lin <axel.lin@gmail.com>, Oliver Neukum <oneukum@suse.de>
Subject: [157/200] USB: cdc-acm: fix resource reclaim in error path of acm_probe
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Axel Lin <axel.lin@gmail.com>

commit c2572b78aa0447244a38e555ebb1b3b48a0088a5 upstream.

This patch fixes resource reclaim in error path of acm_probe:

1. In the case of "out of memory (read urbs usb_alloc_urb)\n")", there
   is no need to call acm_read_buffers_free(acm) here.  Fix it by goto
   alloc_fail6 instead of alloc_fail7.
2. In the case of "out of memory (write urbs usb_alloc_urb)",
   usb_alloc_urb may fail in any iteration of the for loop.  Current
   implementation does not properly free allocated snd->urb.  Fix it by
   goto alloc_fail8 instead of alloc_fail7.
3. In the case of device_create_file(&intf->dev,&dev_attr_iCountryCodeRelDate)
   fail, acm->country_codes is kfreed. As a result, device_remove_file
   for dev_attr_wCountryCodes will not be executed in acm_disconnect.
   Fix it by calling device_remove_file for dev_attr_wCountryCodes
   before goto skip_countries.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/class/cdc-acm.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1201,7 +1201,7 @@ made_compressed_probe:
 		if (rcv->urb == NULL) {
 			dev_dbg(&intf->dev,
 				"out of memory (read urbs usb_alloc_urb)\n");
-			goto alloc_fail7;
+			goto alloc_fail6;
 		}
 
 		rcv->urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
@@ -1225,7 +1225,7 @@ made_compressed_probe:
 		if (snd->urb == NULL) {
 			dev_dbg(&intf->dev,
 				"out of memory (write urbs usb_alloc_urb)");
-			goto alloc_fail7;
+			goto alloc_fail8;
 		}
 
 		if (usb_endpoint_xfer_int(epwrite))
@@ -1264,6 +1264,7 @@ made_compressed_probe:
 		i = device_create_file(&intf->dev,
 						&dev_attr_iCountryCodeRelDate);
 		if (i < 0) {
+			device_remove_file(&intf->dev, &dev_attr_wCountryCodes);
 			kfree(acm->country_codes);
 			goto skip_countries;
 		}
@@ -1300,6 +1301,7 @@ alloc_fail8:
 		usb_free_urb(acm->wb[i].urb);
 alloc_fail7:
 	acm_read_buffers_free(acm);
+alloc_fail6:
 	for (i = 0; i < num_rx_buf; i++)
 		usb_free_urb(acm->ru[i].urb);
 	usb_free_urb(acm->ctrlurb);


