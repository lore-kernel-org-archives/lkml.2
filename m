Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755721Ab0IARhQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 13:37:16 -0400
Received: from proxima.lp0.eu ([81.2.80.65]:57481 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754302Ab0IARhO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 13:37:14 -0400
Message-ID: <4C7E8F48.3020501@simon.arlott.org.uk>
Date: Wed, 01 Sep 2010 18:37:12 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100605 Thunderbird/3.0.4
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH (v2)] cxacru: Use a bulk/int URB to access the command endpoint
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The command endpoint is either a bulk or interrupt endpoint, but using
the wrong type of transfer causes an error if CONFIG_USB_DEBUG is
enabled after commit f661c6f8c67bd55e93348f160d590ff9edf08904, which
checks for this mismatch.

Detect which type of endpoint it is and use a bulk/int URB as
appropriate. There are other function calls specifying a bulk pipe,
but usb_clear_halt doesn't use the pipe type (only the endpoint) and
usb_bulk_msg auto-detects interrupt transfers.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
---
 drivers/usb/atm/cxacru.c |   24 ++++++++++++++++++++++--
 1 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/atm/cxacru.c b/drivers/usb/atm/cxacru.c
index 593fc5e..5af23cc 100644
--- a/drivers/usb/atm/cxacru.c
+++ b/drivers/usb/atm/cxacru.c
@@ -1127,6 +1127,7 @@ static int cxacru_bind(struct usbatm_data *usbatm_instance,
 {
 	struct cxacru_data *instance;
 	struct usb_device *usb_dev = interface_to_usbdev(intf);
+	struct usb_host_endpoint *cmd_ep = usb_dev->ep_in[CXACRU_EP_CMD];
 	int ret;
 
 	/* instance init */
@@ -1171,15 +1172,34 @@ static int cxacru_bind(struct usbatm_data *usbatm_instance,
 		goto fail;
 	}
 
-	usb_fill_int_urb(instance->rcv_urb,
+	if (!cmd_ep) {
+		dbg("cxacru_bind: no command endpoint");
+		ret = -ENODEV;
+		goto fail;
+	}
+
+	if ((cmd_ep->desc.bmAttributes & USB_ENDPOINT_XFERTYPE_MASK)
+			== USB_ENDPOINT_XFER_INT) {
+		usb_fill_int_urb(instance->rcv_urb,
 			usb_dev, usb_rcvintpipe(usb_dev, CXACRU_EP_CMD),
 			instance->rcv_buf, PAGE_SIZE,
 			cxacru_blocking_completion, &instance->rcv_done, 1);
 
-	usb_fill_int_urb(instance->snd_urb,
+		usb_fill_int_urb(instance->snd_urb,
 			usb_dev, usb_sndintpipe(usb_dev, CXACRU_EP_CMD),
 			instance->snd_buf, PAGE_SIZE,
 			cxacru_blocking_completion, &instance->snd_done, 4);
+	} else {
+		usb_fill_bulk_urb(instance->rcv_urb,
+			usb_dev, usb_rcvbulkpipe(usb_dev, CXACRU_EP_CMD),
+			instance->rcv_buf, PAGE_SIZE,
+			cxacru_blocking_completion, &instance->rcv_done);
+
+		usb_fill_bulk_urb(instance->snd_urb,
+			usb_dev, usb_sndbulkpipe(usb_dev, CXACRU_EP_CMD),
+			instance->snd_buf, PAGE_SIZE,
+			cxacru_blocking_completion, &instance->snd_done);
+	}
 
 	mutex_init(&instance->cm_serialize);
 
-- 
1.7.0.4

-- 
Simon Arlott
