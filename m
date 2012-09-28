Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031718Ab2I1Tvr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:51:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45270 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965003Ab2I1S5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 14:57:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Felipe Balbi <balbi@ti.com>
Subject: [ 081/262] usb: gadget: dummy_hcd: add support for USB_DT_BOS on rh
Date: Fri, 28 Sep 2012 11:50:10 -0700
Message-Id: <20120928183007.693097459@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>

commit 3b9c1c5ba7a95caae8440ea47308496b14f7301a upstream.

Without a reply for USB_DT_BOS the USB3 mode does not work since
448b6eb1 ("USB: Make sure to fetch the BOS desc for roothubs.).

Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/dummy_hcd.c |   33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

--- a/drivers/usb/gadget/dummy_hcd.c
+++ b/drivers/usb/gadget/dummy_hcd.c
@@ -1916,6 +1916,27 @@ done:
 	return retval;
 }
 
+/* usb 3.0 root hub device descriptor */
+struct {
+	struct usb_bos_descriptor bos;
+	struct usb_ss_cap_descriptor ss_cap;
+} __packed usb3_bos_desc = {
+
+	.bos = {
+		.bLength		= USB_DT_BOS_SIZE,
+		.bDescriptorType	= USB_DT_BOS,
+		.wTotalLength		= cpu_to_le16(sizeof(usb3_bos_desc)),
+		.bNumDeviceCaps		= 1,
+	},
+	.ss_cap = {
+		.bLength		= USB_DT_USB_SS_CAP_SIZE,
+		.bDescriptorType	= USB_DT_DEVICE_CAPABILITY,
+		.bDevCapabilityType	= USB_SS_CAP_TYPE,
+		.wSpeedSupported	= cpu_to_le16(USB_5GBPS_OPERATION),
+		.bFunctionalitySupport	= ilog2(USB_5GBPS_OPERATION),
+	},
+};
+
 static inline void
 ss_hub_descriptor(struct usb_hub_descriptor *desc)
 {
@@ -2006,6 +2027,18 @@ static int dummy_hub_control(
 		else
 			hub_descriptor((struct usb_hub_descriptor *) buf);
 		break;
+
+	case DeviceRequest | USB_REQ_GET_DESCRIPTOR:
+		if (hcd->speed != HCD_USB3)
+			goto error;
+
+		if ((wValue >> 8) != USB_DT_BOS)
+			goto error;
+
+		memcpy(buf, &usb3_bos_desc, sizeof(usb3_bos_desc));
+		retval = sizeof(usb3_bos_desc);
+		break;
+
 	case GetHubStatus:
 		*(__le32 *) buf = cpu_to_le32(0);
 		break;


