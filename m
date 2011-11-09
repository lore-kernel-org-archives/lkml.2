Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934750Ab1KJFCr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 00:02:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42583 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935043Ab1KJD3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:29:06 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:17 2011
Message-Id: <20111109212717.487093712@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:28:10 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Josh Boyer <jwboyer@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [168/262] usbnet/cdc_ncm: Dont use stack variables for DMA
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Boyer <jwboyer@redhat.com>

commit 75bc8ef528f7c4ea7e80384c5593487b6b3b535e upstream.

The cdc_ncm driver still has a few places where stack variables are
passed to the cdc_ncm_do_request function.  This triggers a stack trace in
lib/dma-debug.c if the CONFIG_DEBUG_DMA_API option is set.

Adjust these calls to pass parameters that have been allocated with
kzalloc.

Signed-off-by: Josh Boyer <jwboyer@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/usb/cdc_ncm.c |   47 +++++++++++++++++++++++++++++++++++++---------
 1 file changed, 38 insertions(+), 9 deletions(-)

--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -229,23 +229,40 @@ static u8 cdc_ncm_setup(struct cdc_ncm_c
 	if (ctx->rx_max != le32_to_cpu(ctx->ncm_parm.dwNtbInMaxSize)) {
 
 		if (flags & USB_CDC_NCM_NCAP_NTB_INPUT_SIZE) {
-			struct usb_cdc_ncm_ndp_input_size ndp_in_sz;
+			struct usb_cdc_ncm_ndp_input_size *ndp_in_sz;
+
+			ndp_in_sz = kzalloc(sizeof(*ndp_in_sz), GFP_KERNEL);
+			if (!ndp_in_sz) {
+				err = -ENOMEM;
+				goto size_err;
+			}
+
 			err = usb_control_msg(ctx->udev,
 					usb_sndctrlpipe(ctx->udev, 0),
 					USB_CDC_SET_NTB_INPUT_SIZE,
 					USB_TYPE_CLASS | USB_DIR_OUT
 					 | USB_RECIP_INTERFACE,
-					0, iface_no, &ndp_in_sz, 8, 1000);
+					0, iface_no, ndp_in_sz, 8, 1000);
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
+
 			err = usb_control_msg(ctx->udev,
 					usb_sndctrlpipe(ctx->udev, 0),
 					USB_CDC_SET_NTB_INPUT_SIZE,
 					USB_TYPE_CLASS | USB_DIR_OUT
 					 | USB_RECIP_INTERFACE,
-					0, iface_no, &dwNtbInMaxSize, 4, 1000);
+					0, iface_no, dwNtbInMaxSize, 4, 1000);
+			kfree(dwNtbInMaxSize);
 		}
-
+size_err:
 		if (err < 0)
 			pr_debug("Setting NTB Input Size failed\n");
 	}
@@ -326,19 +343,29 @@ static u8 cdc_ncm_setup(struct cdc_ncm_c
 
 	/* set Max Datagram Size (MTU) */
 	if (flags & USB_CDC_NCM_NCAP_MAX_DATAGRAM_SIZE) {
-		__le16 max_datagram_size;
+		__le16 *max_datagram_size;
 		u16 eth_max_sz = le16_to_cpu(ctx->ether_desc->wMaxSegmentSize);
+
+		max_datagram_size = kzalloc(sizeof(*max_datagram_size),
+				GFP_KERNEL);
+		if (!max_datagram_size) {
+			err = -ENOMEM;
+			goto max_dgram_err;
+		}
+
 		err = usb_control_msg(ctx->udev, usb_rcvctrlpipe(ctx->udev, 0),
 				USB_CDC_GET_MAX_DATAGRAM_SIZE,
 				USB_TYPE_CLASS | USB_DIR_IN
 				 | USB_RECIP_INTERFACE,
-				0, iface_no, &max_datagram_size,
+				0, iface_no, max_datagram_size,
 				2, 1000);
 		if (err < 0) {
 			pr_debug("GET_MAX_DATAGRAM_SIZE failed, use size=%u\n",
 						CDC_NCM_MIN_DATAGRAM_SIZE);
+			kfree(max_datagram_size);
 		} else {
-			ctx->max_datagram_size = le16_to_cpu(max_datagram_size);
+			ctx->max_datagram_size =
+				le16_to_cpu(*max_datagram_size);
 			/* Check Eth descriptor value */
 			if (eth_max_sz < CDC_NCM_MAX_DATAGRAM_SIZE) {
 				if (ctx->max_datagram_size > eth_max_sz)
@@ -361,8 +388,10 @@ static u8 cdc_ncm_setup(struct cdc_ncm_c
 						USB_TYPE_CLASS | USB_DIR_OUT
 						 | USB_RECIP_INTERFACE,
 						0,
-						iface_no, &max_datagram_size,
+						iface_no, max_datagram_size,
 						2, 1000);
+			kfree(max_datagram_size);
+max_dgram_err:
 			if (err < 0)
 				pr_debug("SET_MAX_DATAGRAM_SIZE failed\n");
 		}


