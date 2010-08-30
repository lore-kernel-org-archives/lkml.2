Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756335Ab0H3V42 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 17:56:28 -0400
Received: from proxima.lp0.eu ([81.2.80.65]:44333 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756249Ab0H3V4S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 17:56:18 -0400
X-Greylist: delayed 380 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Aug 2010 17:56:18 EDT
Message-ID: <4C7C27B5.5080904@simon.arlott.org.uk>
Date: Mon, 30 Aug 2010 22:50:45 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100605 Thunderbird/3.0.4
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] cxacru: Use a bulk URB to access the command endpoint
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The command endpoint is a bulk endpoint, but interrupt transfers
are used to access it when checking status, load firmware or alter
the configuration.

This causes an error if CONFIG_USB_DEBUG is enabled after commit
f661c6f8c67bd55e93348f160d590ff9edf08904, which checks for this
mismatch.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
---
 drivers/usb/atm/cxacru.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/atm/cxacru.c b/drivers/usb/atm/cxacru.c
index 593fc5e..3b45f57 100644
--- a/drivers/usb/atm/cxacru.c
+++ b/drivers/usb/atm/cxacru.c
@@ -49,7 +49,7 @@
 
 static const char cxacru_driver_name[] = "cxacru";
 
-#define CXACRU_EP_CMD		0x01	/* Bulk/interrupt in/out */
+#define CXACRU_EP_CMD		0x01	/* Bulk in/out */
 #define CXACRU_EP_DATA		0x02	/* Bulk in/out */
 
 #define CMD_PACKET_SIZE		64	/* Should be maxpacket(ep)? */
@@ -1171,15 +1171,15 @@ static int cxacru_bind(struct usbatm_data *usbatm_instance,
 		goto fail;
 	}
 
-	usb_fill_int_urb(instance->rcv_urb,
-			usb_dev, usb_rcvintpipe(usb_dev, CXACRU_EP_CMD),
+	usb_fill_bulk_urb(instance->rcv_urb,
+			usb_dev, usb_rcvbulkpipe(usb_dev, CXACRU_EP_CMD),
 			instance->rcv_buf, PAGE_SIZE,
-			cxacru_blocking_completion, &instance->rcv_done, 1);
+			cxacru_blocking_completion, &instance->rcv_done);
 
-	usb_fill_int_urb(instance->snd_urb,
-			usb_dev, usb_sndintpipe(usb_dev, CXACRU_EP_CMD),
+	usb_fill_bulk_urb(instance->snd_urb,
+			usb_dev, usb_sndbulkpipe(usb_dev, CXACRU_EP_CMD),
 			instance->snd_buf, PAGE_SIZE,
-			cxacru_blocking_completion, &instance->snd_done, 4);
+			cxacru_blocking_completion, &instance->snd_done);
 
 	mutex_init(&instance->cm_serialize);
 
-- 
1.7.0.4
-- 
Simon Arlott
