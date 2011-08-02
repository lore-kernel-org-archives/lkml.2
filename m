Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603Ab1HBOso (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 10:48:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50825 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753113Ab1HBOsi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 10:48:38 -0400
Date: Tue, 2 Aug 2011 10:48:27 -0400
From: Joss Boyer <jwboyer@redhat.com>
To: Oliver Neukum <oliver@neukum.org>,
        Alexey ORISHKO <alexey.orishko@stericsson.com>
Cc: gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3] usbnet/cdc_ncm: Don't use stack variables for DMA
Message-ID: <20110802144826.GJ2096@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 1717b6b8b1de95ed4ca53b74d2ccb563fae9b898 Mon Sep 17 00:00:00 2001
From: Josh Boyer <jwboyer@redhat.com>
Date: Tue, 2 Aug 2011 08:09:56 -0400
Subject: [PATCH] usbnet/cdc_ncm: Don't use stack variables for DMA buffers

The cdc_ncm driver still has a few places where stack variables are passed
to the cdc_ncm_do_request function.  This triggers a stack trace in
lib/dma-debug.c if the CONFIG_DEBUG_DMA_API option is set.

Adjust these calls to pass parameters that have been allocated with kzalloc.

Signed-off-by: Josh Boyer <jwboyer@redhat.com>
---

v3: Fix checkpatch errors
v2: Fix leak in error path

 drivers/net/usb/cdc_ncm.c |   54 +++++++++++++++++++++++++++++++++++----------
 1 files changed, 42 insertions(+), 12 deletions(-)

diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
index fd622a6..bbcb133 100644
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -260,23 +260,39 @@ static u8 cdc_ncm_setup(struct cdc_ncm_ctx *ctx)
 		req.wIndex = cpu_to_le16(iface_no);
 
 		if (flags & USB_CDC_NCM_NCAP_NTB_INPUT_SIZE) {
-			struct usb_cdc_ncm_ndp_input_size ndp_in_sz;
+			struct usb_cdc_ncm_ndp_input_size *ndp_in_sz;
+
+			ndp_in_sz = kzalloc(sizeof(*ndp_in_sz), GFP_KERNEL);
+			if (!ndp_in_sz) {
+				err = -ENOMEM;
+				goto size_err;
+			}
 
 			req.wLength = 8;
-			ndp_in_sz.dwNtbInMaxSize = cpu_to_le32(ctx->rx_max);
-			ndp_in_sz.wNtbInMaxDatagrams =
+			ndp_in_sz->dwNtbInMaxSize = cpu_to_le32(ctx->rx_max);
+			ndp_in_sz->wNtbInMaxDatagrams =
 					cpu_to_le16(CDC_NCM_DPT_DATAGRAMS_MAX);
-			ndp_in_sz.wReserved = 0;
-			err = cdc_ncm_do_request(ctx, &req, &ndp_in_sz, 0, NULL,
+			ndp_in_sz->wReserved = 0;
+			err = cdc_ncm_do_request(ctx, &req, ndp_in_sz, 0, NULL,
 									1000);
+			kfree(ndp_in_sz);
 		} else {
-			__le32 dwNtbInMaxSize = cpu_to_le32(ctx->rx_max);
+			__le32 *dwNtbInMaxSize;
+			dwNtbInMaxSize = kzalloc(sizeof(*dwNtbInMaxSize),
+					GFP_KERNEL);
+			if (!dwNtbInMaxSize) {
+				err = -ENOMEM;
+				goto size_err;
+			}
+			*dwNtbInMaxSize = cpu_to_le32(ctx->rx_max);
 
 			req.wLength = 4;
-			err = cdc_ncm_do_request(ctx, &req, &dwNtbInMaxSize, 0,
+			err = cdc_ncm_do_request(ctx, &req, dwNtbInMaxSize, 0,
 								NULL, 1000);
+			kfree(dwNtbInMaxSize);
 		}
 
+size_err:
 		if (err)
 			pr_debug("Setting NTB Input Size failed\n");
 	}
@@ -362,9 +378,16 @@ static u8 cdc_ncm_setup(struct cdc_ncm_ctx *ctx)
 
 	/* set Max Datagram Size (MTU) */
 	if (flags & USB_CDC_NCM_NCAP_MAX_DATAGRAM_SIZE) {
-		__le16 max_datagram_size;
+		__le16 *max_datagram_size;
 		u16 eth_max_sz = le16_to_cpu(ctx->ether_desc->wMaxSegmentSize);
 
+		max_datagram_size = kzalloc(sizeof(*max_datagram_size),
+				GFP_KERNEL);
+		if (!max_datagram_size) {
+			err = -ENOMEM;
+			goto max_dgram_err;
+		}
+
 		req.bmRequestType = USB_TYPE_CLASS | USB_DIR_IN |
 							USB_RECIP_INTERFACE;
 		req.bNotificationType = USB_CDC_GET_MAX_DATAGRAM_SIZE;
@@ -372,13 +395,17 @@ static u8 cdc_ncm_setup(struct cdc_ncm_ctx *ctx)
 		req.wIndex = cpu_to_le16(iface_no);
 		req.wLength = cpu_to_le16(2);
 
-		err = cdc_ncm_do_request(ctx, &req, &max_datagram_size, 0, NULL,
+		err = cdc_ncm_do_request(ctx, &req, max_datagram_size, 0, NULL,
 									1000);
+
 		if (err) {
 			pr_debug("GET_MAX_DATAGRAM_SIZE failed, use size=%u\n",
 						CDC_NCM_MIN_DATAGRAM_SIZE);
+			kfree(max_datagram_size);
 		} else {
-			ctx->max_datagram_size = le16_to_cpu(max_datagram_size);
+			ctx->max_datagram_size =
+				le16_to_cpu(*max_datagram_size);
+
 			/* Check Eth descriptor value */
 			if (eth_max_sz < CDC_NCM_MAX_DATAGRAM_SIZE) {
 				if (ctx->max_datagram_size > eth_max_sz)
@@ -401,10 +428,13 @@ static u8 cdc_ncm_setup(struct cdc_ncm_ctx *ctx)
 			req.wValue = 0;
 			req.wIndex = cpu_to_le16(iface_no);
 			req.wLength = 2;
-			max_datagram_size = cpu_to_le16(ctx->max_datagram_size);
+			*max_datagram_size =
+				cpu_to_le16(ctx->max_datagram_size);
 
-			err = cdc_ncm_do_request(ctx, &req, &max_datagram_size,
+			err = cdc_ncm_do_request(ctx, &req, max_datagram_size,
 								0, NULL, 1000);
+			kfree(max_datagram_size);
+max_dgram_err:
 			if (err)
 				pr_debug("SET_MAX_DATAGRAM_SIZE failed\n");
 		}
-- 
1.7.6

