Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175Ab0EaAEo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 20:04:44 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:41254 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800Ab0EaAEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 20:04:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=K7f/giN4oSVn2hNA5c1W18daYd+ahCStR82HYcv9J1DuJfuexZteWE0rPtt49+ffim
         4RLEoFqDa2ATu4iIiBQxc74HUb8uGGCbb6MyEipw0vHMak1Hl3Mlkje/QnDXH6hVnCFJ
         3+1duakNz/8ehwgaeNxB0t2+IXloOQl3dUl0c=
Subject: [PATCH v2] cdc-acm: fix resource reclaim in error path of acm_probe
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Oliver Neukum <oliver@neukum.name>, Greg Kroah-Hartman <gregkh@suse.de>,
       Alan Cox <alan@linux.intel.com>,
       Francesco Lavra <francescolavra@interfree.it>,
       Julian Calaby <julian.calaby@gmail.com>, linux-usb@vger.kernel.org
Content-Type: text/plain
Date: Mon, 31 May 2010 08:04:47 +0800
Message-Id: <1275264287.20355.2.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes resource reclaim in error path of acm_probe:
1. In the case of "out of memory (read urbs usb_alloc_urb)\n")",
there is no need to call acm_read_buffers_free(acm) here.
Fix it by goto alloc_fail6 instead of alloc_fail7.
2. In the case of "out of memory (write urbs usb_alloc_urb)",
usb_alloc_urb may fail in any iteration of the for loop.
Current implementation does not properly free allocated snd->urb.
Fix it by goto alloc_fail8 instead of alloc_fail7.
3. In the case of device_create_file(&intf->dev,&dev_attr_iCountryCodeRelDate)
fail, acm->country_codes is kfreed. As a result, device_remove_file for
dev_attr_wCountryCodes will not be executed in acm_disconnect.
Fix it by calling device_remove_file for dev_attr_wCountryCodes before goto
skip_countries.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/usb/class/cdc-acm.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 0c2f14f..61d7550 100644
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
-- 
1.5.4.3



