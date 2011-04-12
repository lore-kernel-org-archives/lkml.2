Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634Ab1DLTfb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 15:35:31 -0400
Received: from www.linutronix.de ([62.245.132.108]:40352 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756499Ab1DLTf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 15:35:28 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Tatyana Brokhman <tlinder@codeaurora.org>
Cc: gregkh@suse.de, linux-arm-msm@vger.kernel.org, balbi@ti.com,
        ablay@codeaurora.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 1/5] usb/gadget: cleanup of "Add SuperSpeed support to the Gadget Framework"
Date: Tue, 12 Apr 2011 21:34:52 +0200
Message-Id: <1302636896-12717-2-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1302636896-12717-1-git-send-email-bigeasy@linutronix.de>
References: <20110411175917.GE4018@linutronix.de>
 <1302636896-12717-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

style, some endianess fixups

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/usb/gadget/Kconfig     |    1 -
 drivers/usb/gadget/composite.c |   62 +++++++++++++++++----------------------
 include/linux/usb/gadget.h     |    2 +-
 3 files changed, 28 insertions(+), 37 deletions(-)

diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index b4130bc..21429c7 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -609,7 +609,6 @@ config USB_GADGET_SUPERSPEED
 	boolean "Gadget operating in Super Speed"
 	depends on USB_GADGET
 	depends on USB_GADGET_DUALSPEED
-	default n
 	help
 	  Enabling this feature enables Super Speed support in the Gadget
 	  driver. It means that gadget drivers should provide extra (SuperSpeed)
diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
index d5fe1c2..a94b7b7 100644
--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -76,10 +76,7 @@ static char composite_manufacturer[50];
 /* Default endpoint companion descriptor */
 static struct usb_ss_ep_comp_descriptor default_ep_comp_desc = {
 		.bDescriptorType = USB_DT_SS_ENDPOINT_COMP,
-		.bLength = 0x06,
-		.bMaxBurst = 0, /* the default is we don't support bursting */
-		.bmAttributes = 0, /* 2^0 streams supported */
-		.wBytesPerInterval = 0,
+		.bLength = sizeof(struct usb_ss_ep_comp_descriptor),
 };
 
 /**
@@ -96,13 +93,13 @@ static struct usb_ss_ep_comp_descriptor default_ep_comp_desc = {
  */
 static void create_ss_descriptors(struct usb_function *f)
 {
-	unsigned bytes;		/* number of bytes to allocate */
-	unsigned n_desc;	/* number of descriptors */
-	void *mem;		/* allocated memory to copy to */
-	struct usb_descriptor_header **tmp;
-	struct usb_endpoint_descriptor	*ep_desc ;
-	struct usb_ss_ep_comp_descriptor *ep_comp_desc;
-	struct usb_descriptor_header **src = f->hs_descriptors;
+	struct usb_ss_ep_comp_descriptor	*ep_comp_desc;
+	struct usb_endpoint_descriptor		*ep_desc;
+	struct usb_descriptor_header		**src = f->hs_descriptors;
+	struct usb_descriptor_header		**tmp;
+	unsigned n_desc;
+	unsigned bytes;
+	void *mem;
 
 	if (!f->hs_descriptors)
 		return;
@@ -163,7 +160,7 @@ static void create_ss_descriptors(struct usb_function *f)
 			*tmp = mem;
 			tmp++;
 			/* Update wBytesPerInterval for periodic endpoints */
-			ep_comp_desc = (struct usb_ss_ep_comp_descriptor *)mem;
+			ep_comp_desc = mem;
 			switch (ep_desc->bmAttributes &
 				USB_ENDPOINT_XFERTYPE_MASK) {
 			case USB_ENDPOINT_XFER_INT:
@@ -609,47 +606,44 @@ static int count_configs(struct usb_composite_dev *cdev, unsigned type)
  */
 static int bos(struct usb_composite_dev *cdev)
 {
-	struct usb_bos_descriptor	*bos = cdev->req->buf;
-	struct usb_ext_cap_descriptor	*usb_ext = NULL;
-	struct usb_ss_cap_descriptor	*ss_cap = NULL;
-
+	struct usb_ext_cap_descriptor	*usb_ext;
+	struct usb_ss_cap_descriptor	*ss_cap;
 	struct usb_dcd_config_params	dcd_config_params;
+	struct usb_bos_descriptor	*bos = cdev->req->buf;
 
 	bos->bLength = USB_DT_BOS_SIZE;
 	bos->bDescriptorType = USB_DT_BOS;
 
-	bos->wTotalLength = USB_DT_BOS_SIZE;
+	bos->wTotalLength = cpu_to_le16(USB_DT_BOS_SIZE);
 	bos->bNumDeviceCaps = 0;
 
 	/*
 	 * A SuperSpeed device shall include the USB2.0 extension descriptor
 	 * and shall support LPM when operating in USB2.0 HS mode.
 	 */
-	usb_ext = (struct usb_ext_cap_descriptor *)
-			(cdev->req->buf+bos->wTotalLength);
+	usb_ext = cdev->req->buf + bos->wTotalLength;
 	bos->bNumDeviceCaps++;
-	bos->wTotalLength += USB_DT_USB_EXT_CAP_SIZE;
+	le16_add_cpu(&bos->wTotalLength, USB_DT_USB_EXT_CAP_SIZE);
 	usb_ext->bLength = USB_DT_USB_EXT_CAP_SIZE;
 	usb_ext->bDescriptorType = USB_DT_DEVICE_CAPABILITY;
 	usb_ext->bDevCapabilityType = USB_CAP_TYPE_EXT;
-	usb_ext->bmAttributes = USB_LPM_SUPPORT;
+	usb_ext->bmAttributes = cpu_to_le16(USB_LPM_SUPPORT);
 
 	/*
 	 * The Superspeed USB Capability descriptor shall be implemented by all
 	 * SuperSpeed devices.
 	 */
-	ss_cap = (struct usb_ss_cap_descriptor *)
-		(cdev->req->buf+bos->wTotalLength);
+	ss_cap = cdev->req->buf + bos->wTotalLength;
 	bos->bNumDeviceCaps++;
-	bos->wTotalLength += USB_DT_USB_SS_CAP_SIZE;
+	le16_add_cpu(&bos->wTotalLength, USB_DT_USB_SS_CAP_SIZE);
 	ss_cap->bLength = USB_DT_USB_SS_CAP_SIZE;
 	ss_cap->bDescriptorType = USB_DT_DEVICE_CAPABILITY;
 	ss_cap->bDevCapabilityType = USB_SS_CAP_TYPE;
 	ss_cap->bmAttributes = 0; /* LTM is not supported yet */
-	ss_cap->wSpeedSupported = USB_LOW_SPEED_OPERATION |
+	ss_cap->wSpeedSupported = cpu_to_le16(USB_LOW_SPEED_OPERATION |
 				USB_FULL_SPEED_OPERATION |
 				USB_HIGH_SPEED_OPERATION |
-				USB_5GBPS_OPERATION;
+				USB_5GBPS_OPERATION);
 	ss_cap->bFunctionalitySupport = USB_LOW_SPEED_OPERATION;
 
 	/* Get Controller configuration */
@@ -657,12 +651,13 @@ static int bos(struct usb_composite_dev *cdev)
 		cdev->gadget->ops->get_config_params(&dcd_config_params);
 	else {
 		dcd_config_params.bU1devExitLat = USB_DEFULT_U1_DEV_EXIT_LAT;
-		dcd_config_params.bU2DevExitLat = USB_DEFULT_U2_DEV_EXIT_LAT;
+		dcd_config_params.bU2DevExitLat =
+			cpu_to_le16(USB_DEFULT_U2_DEV_EXIT_LAT);
 	}
 	ss_cap->bU1devExitLat = dcd_config_params.bU1devExitLat;
 	ss_cap->bU2DevExitLat = dcd_config_params.bU2DevExitLat;
 
-	return bos->wTotalLength;
+	return le16_to_cpu(bos->wTotalLength);
 }
 
 static void device_qual(struct usb_composite_dev *cdev)
@@ -1285,7 +1280,7 @@ composite_setup(struct usb_gadget *gadget, const struct usb_ctrlrequest *ctrl)
 		status = f->get_status ? f->get_status(f) : 0;
 		if (status < 0)
 			break;
-		*((u16 *)req->buf) = status & 0x0000ffff;
+		*((u16 *)req->buf) = le16_to_cpu(status & 0x0000ffff);
 		break;
 	/*
 	 * Function drivers should handle SetFeature/ClearFeature
@@ -1305,12 +1300,9 @@ composite_setup(struct usb_gadget *gadget, const struct usb_ctrlrequest *ctrl)
 			f = cdev->config->interface[intf];
 			if (!f)
 				break;
-			value = f->func_suspend ?
-				f->func_suspend(f,
-					(u8)((w_index &
-						USB_INTR_FUNC_SUSPEND_OPT_MASK)
-							>> 8)) :
-				0;
+			value = 0;
+			if (f->func_suspend)
+				value = f->func_suspend(f, w_index >> 8);
 			if (value < 0) {
 				ERROR(cdev, "func_suspend() returned "
 					    "error %d\n", value);
diff --git a/include/linux/usb/gadget.h b/include/linux/usb/gadget.h
index 92c2d62..9d496a4 100644
--- a/include/linux/usb/gadget.h
+++ b/include/linux/usb/gadget.h
@@ -428,7 +428,7 @@ static inline void usb_ep_fifo_flush(struct usb_ep *ep)
 struct usb_dcd_config_params {
 	__u8  bU1devExitLat;	/* U1 Device exit Latency */
 #define USB_DEFULT_U1_DEV_EXIT_LAT	0x01	/* Less then 1 microsec */
-	__u16 bU2DevExitLat;	/* U2 Device exit Latency */
+	__le16 bU2DevExitLat;	/* U2 Device exit Latency */
 #define USB_DEFULT_U2_DEV_EXIT_LAT	0x1F4	/* Less then 500 microsec */
 };
 
-- 
1.7.4

