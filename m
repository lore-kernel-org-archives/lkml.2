Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610Ab1A0NOZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 08:14:25 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:63128 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812Ab1A0NOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 08:14:20 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6238"; a="71972540"
From: Tatyana Brokhman <tlinder@codeaurora.org>
To: gregkh@suse.de
Cc: linux-arm-msm@vger.kernel.org, Tatyana Brokhman <tlinder@codeaurora.org>,
        linux-usb@vger.kernel.org (open list:USB GADGET/PERIPH...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH/RESEND v4 5/5] usb:gadget: Add SuperSpeed support to the Gadget Framework
Date: Thu, 27 Jan 2011 15:14:08 +0200
Message-Id: <1296134049-31823-1-git-send-email-tlinder@codeaurora.org>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the SuperSpeed functionality to the gadget framework.
In order not to force all the gadget drivers to supply SuperSpeed
descriptors when operating in SuperSpeed mode the following approach was
taken:
If we're operating in SuperSpeed mode and the gadget driver didn't supply
SuperSpeed descriptors, the composite layer will automatically create
SuperSpeed descriptors with default values.
Support for new SuperSpeed BOS descriptor was added.
Support for SET_FEATURE and GET_STATUS requests in SuperSpeed mode was
added.

Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>
---
 drivers/usb/gadget/Kconfig     |   12 ++
 drivers/usb/gadget/composite.c |  370 +++++++++++++++++++++++++++++++++++++---
 include/linux/usb/composite.h  |   25 +++
 include/linux/usb/gadget.h     |   29 +++
 4 files changed, 414 insertions(+), 22 deletions(-)

diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index 1dc9739..06382d9 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -598,6 +598,18 @@ config USB_GADGET_DUALSPEED
 	  Means that gadget drivers should include extra descriptors
 	  and code to handle dual-speed controllers.
 
+config USB_GADGET_SUPERSPEED
+	boolean "Gadget operating in Super Speed"
+	depends on USB_GADGET
+	depends on USB_GADGET_DUALSPEED
+	default n
+	help
+	  Enabling this feature enables Super Speed support in the Gadget
+	  driver. It means that gadget drivers should provide extra (SuperSpeed)
+	  descriptors to the host.
+	  For composite devices: if SuperSpeed descriptors weren't supplied by
+	  the FD, they will be automatically generated with default values.
+
 #
 # USB Gadget Drivers
 #
diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
index efb6d9c..d3d0340 100644
--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -73,6 +73,123 @@ MODULE_PARM_DESC(iSerialNumber, "SerialNumber string");
 
 static char composite_manufacturer[50];
 
+/* Default endpoint companion descriptor */
+static struct usb_ss_ep_comp_descriptor default_ep_comp_desc = {
+		.bDescriptorType = USB_DT_SS_ENDPOINT_COMP,
+		.bLength = 0x06,
+		.bMaxBurst = 0, /* the default is we don't support bursting */
+		.bmAttributes = 0, /* 2^0 streams supported */
+		.wBytesPerInterval = 0,
+};
+
+/**
+ * create_ss_descriptors() - Generate SuperSpeed descriptors
+ * with default values
+ * @f: pointer to usb_function to generate the descriptors for
+ *
+ * This function receives a pointer to usb_function and adds
+ * missing super speed descriptors in the ss_descriptor field
+ * according to its hs_descriptors field.
+ *
+ * This function copies f->hs_descriptors while updating the
+ * endpoint descriptor and adding endpoint companion descriptor.
+ */
+static void create_ss_descriptors(struct usb_function *f)
+{
+	unsigned bytes;		/* number of bytes to allocate */
+	unsigned n_desc;	/* number of descriptors */
+	void *mem;		/* allocated memory to copy to */
+	struct usb_descriptor_header **tmp;
+	struct usb_endpoint_descriptor	*ep_desc ;
+	struct usb_ss_ep_comp_descriptor *ep_comp_desc;
+	struct usb_descriptor_header **src = f->hs_descriptors;
+
+	if (!f->hs_descriptors)
+		return;
+
+	/*
+	 * Count number of EPs (in order to know how many SS_EP_COMPANION
+	 * descriptors to add), the total number of descriptors and the sum of
+	 * each descriptor bLength field in order to know how much memory to
+	 * allocate.
+	 */
+	for (bytes = 0, n_desc = 0, tmp = src; *tmp; tmp++, n_desc++) {
+		if ((*tmp)->bDescriptorType == USB_DT_ENDPOINT) {
+			bytes += default_ep_comp_desc.bLength;
+			n_desc++;
+		}
+		bytes += (*tmp)->bLength;
+	}
+
+	bytes += (n_desc + 1) * sizeof(*tmp);
+	mem = kmalloc(bytes, GFP_KERNEL);
+	if (!mem)
+		return;
+
+	/*
+	 * Fill in pointers starting at "tmp", to descriptors copied starting
+	 * at "mem" and return "ret"
+	 */
+	tmp = mem;
+	f->ss_descriptors  = mem;
+	mem += (n_desc + 1) * sizeof(*tmp);
+	while (*src) {
+		/* Copy the original descriptor */
+		memcpy(mem, *src, (*src)->bLength);
+		switch ((*src)->bDescriptorType) {
+		case USB_DT_ENDPOINT:
+			/* update ep descriptor */
+			ep_desc = (struct usb_endpoint_descriptor *)mem;
+			switch (ep_desc->bmAttributes &
+				USB_ENDPOINT_XFERTYPE_MASK) {
+			case USB_ENDPOINT_XFER_CONTROL:
+				ep_desc->wMaxPacketSize = cpu_to_le16(512);
+				ep_desc->bInterval = 0;
+				break;
+			case USB_ENDPOINT_XFER_BULK:
+				ep_desc->wMaxPacketSize = cpu_to_le16(1024);
+				ep_desc->bInterval = 0;
+				break;
+			case USB_ENDPOINT_XFER_INT:
+			case USB_ENDPOINT_XFER_ISOC:
+				break;
+			}
+			*tmp = mem;
+			tmp++;
+			mem += (*src)->bLength;
+			/* add ep companion descriptor */
+			memcpy(mem, &default_ep_comp_desc,
+			       default_ep_comp_desc.bLength);
+			*tmp = mem;
+			tmp++;
+			/* Update wBytesPerInterval for periodic endpoints */
+			ep_comp_desc = (struct usb_ss_ep_comp_descriptor *)mem;
+			switch (ep_desc->bmAttributes &
+				USB_ENDPOINT_XFERTYPE_MASK) {
+			case USB_ENDPOINT_XFER_INT:
+			case USB_ENDPOINT_XFER_ISOC:
+				ep_comp_desc->wBytesPerInterval =
+					ep_desc->wMaxPacketSize;
+				break;
+			}
+			mem += default_ep_comp_desc.bLength;
+			break;
+		default:
+			*tmp = mem;
+			tmp++;
+			mem += (*src)->bLength;
+			break;
+		}
+		src++;
+	}
+	/*
+	 * The last (struct usb_descriptor_header *) in the descriptors
+	 * vector is NULL
+	 */
+	*tmp = NULL;
+	f->ss_desc_allocated = true;
+}
+
 /*-------------------------------------------------------------------------*/
 /**
  * next_ep_desc() - advance to the next EP descriptor
@@ -118,6 +235,9 @@ int config_ep_by_speed(struct usb_gadget *g,
 	struct usb_endpoint_descriptor *chosen_desc = NULL;
 	struct usb_descriptor_header **speed_desc = NULL;
 
+	struct usb_ss_ep_comp_descriptor *comp_desc = NULL;
+	int want_comp_desc = 0;
+
 	struct usb_descriptor_header **d_spd; /* cursor for speed desc */
 
 	if (!g || !f || !_ep)
@@ -125,6 +245,13 @@ int config_ep_by_speed(struct usb_gadget *g,
 
 	/* select desired speed */
 	switch (g->speed) {
+	case USB_SPEED_SUPER:
+		if (gadget_is_superspeed(g)) {
+			speed_desc = f->ss_descriptors;
+			want_comp_desc = 1;
+			break;
+		}
+		/* else: Fall trough */
 	case USB_SPEED_HIGH:
 		if (gadget_is_dualspeed(g)) {
 			speed_desc = f->hs_descriptors;
@@ -147,7 +274,18 @@ ep_found:
 	/* commit results */
 	_ep->maxpacket = le16_to_cpu(chosen_desc->wMaxPacketSize);
 	_ep->desc = chosen_desc;
-
+	_ep->comp_desc = NULL;
+	if (want_comp_desc) {
+		/*
+		 * Companion descriptor should follow EP descriptor
+		 * USB 3.0 spec, #9.6.7
+		 */
+		comp_desc = (struct usb_ss_ep_comp_descriptor *)*(++d_spd);
+		if (!comp_desc ||
+		    (comp_desc->bDescriptorType != USB_DT_SS_ENDPOINT_COMP))
+			return -EIO;
+		_ep->comp_desc = comp_desc;
+	}
 	return 0;
 }
 
@@ -187,6 +325,14 @@ int usb_add_function(struct usb_configuration *config,
 			list_del(&function->list);
 			function->config = NULL;
 		}
+		/*
+		 * Add SS descriptors if there are any. This has to be done
+		 * after the bind since we need the hs_descriptors to be set in
+		 * usb_function and some of the FDs does it in the bind.
+		 */
+		if ((gadget_is_superspeed(config->cdev->gadget)) &&
+		    (!function->ss_not_capable) && (!function->ss_descriptors))
+			create_ss_descriptors(function);
 	} else
 		value = 0;
 
@@ -199,6 +345,8 @@ int usb_add_function(struct usb_configuration *config,
 		config->fullspeed = true;
 	if (!config->highspeed && function->hs_descriptors)
 		config->highspeed = true;
+	if (!config->superspeed && function->ss_descriptors)
+		config->superspeed = true;
 
 done:
 	if (value)
@@ -342,7 +490,9 @@ static int config_buf(struct usb_configuration *config,
 	list_for_each_entry(f, &config->functions, list) {
 		struct usb_descriptor_header **descriptors;
 
-		if (speed == USB_SPEED_HIGH)
+		if (speed == USB_SPEED_SUPER)
+			descriptors = f->ss_descriptors;
+		else if (speed == USB_SPEED_HIGH)
 			descriptors = f->hs_descriptors;
 		else
 			descriptors = f->descriptors;
@@ -368,9 +518,10 @@ static int config_desc(struct usb_composite_dev *cdev, unsigned w_value)
 	u8				type = w_value >> 8;
 	enum usb_device_speed		speed = USB_SPEED_UNKNOWN;
 
-	if (gadget_is_dualspeed(gadget)) {
-		int			hs = 0;
-
+	if (gadget->speed == USB_SPEED_SUPER)
+		speed = gadget->speed;
+	else if (gadget_is_dualspeed(gadget)) {
+		int	hs = 0;
 		if (gadget->speed == USB_SPEED_HIGH)
 			hs = 1;
 		if (type == USB_DT_OTHER_SPEED_CONFIG)
@@ -384,7 +535,10 @@ static int config_desc(struct usb_composite_dev *cdev, unsigned w_value)
 	w_value &= 0xff;
 	list_for_each_entry(c, &cdev->configs, list) {
 		/* ignore configs that won't work at this speed */
-		if (speed == USB_SPEED_HIGH) {
+		if (speed == USB_SPEED_SUPER) {
+			if (!c->superspeed)
+				continue;
+		} else if (speed == USB_SPEED_HIGH) {
 			if (!c->highspeed)
 				continue;
 		} else {
@@ -404,16 +558,22 @@ static int count_configs(struct usb_composite_dev *cdev, unsigned type)
 	struct usb_configuration	*c;
 	unsigned			count = 0;
 	int				hs = 0;
+	int				ss = 0;
 
 	if (gadget_is_dualspeed(gadget)) {
 		if (gadget->speed == USB_SPEED_HIGH)
 			hs = 1;
+		if (gadget->speed == USB_SPEED_SUPER)
+			ss = 1;
 		if (type == USB_DT_DEVICE_QUALIFIER)
 			hs = !hs;
 	}
 	list_for_each_entry(c, &cdev->configs, list) {
 		/* ignore configs that won't work at this speed */
-		if (hs) {
+		if (ss) {
+			if (!c->superspeed)
+				continue;
+		} else if (hs) {
 			if (!c->highspeed)
 				continue;
 		} else {
@@ -425,6 +585,73 @@ static int count_configs(struct usb_composite_dev *cdev, unsigned type)
 	return count;
 }
 
+/**
+ * bos() - prepares the BOS descriptor.
+ * @cdev: pointer to usb_composite device to generate the bos
+ *	descriptor for
+ *
+ * This function generates the BOS (Binary Device Object)
+ * descriptor and its device capabilities descriptors. The BOS
+ * descriptor should be supported by a SuperSpeed device.
+ */
+static int bos(struct usb_composite_dev *cdev)
+{
+	struct usb_bos_descriptor	*bos = cdev->req->buf;
+	struct usb_ext_cap_descriptor	*usb_ext = NULL;
+	struct usb_ss_cap_descriptor	*ss_cap = NULL;
+
+	struct usb_dcd_config_params	dcd_config_params;
+
+	bos->bLength = USB_DT_BOS_SIZE;
+	bos->bDescriptorType = USB_DT_BOS;
+
+	bos->wTotalLength = USB_DT_BOS_SIZE;
+	bos->bNumDeviceCaps = 0;
+
+	/*
+	 * A SuperSpeed device shall include the USB2.0 extension descriptor
+	 * and shall support LPM when operating in USB2.0 HS mode.
+	 */
+	usb_ext = (struct usb_ext_cap_descriptor *)
+			(cdev->req->buf+bos->wTotalLength);
+	bos->bNumDeviceCaps++;
+	bos->wTotalLength += USB_DT_USB_EXT_CAP_SIZE;
+	usb_ext->bLength = USB_DT_USB_EXT_CAP_SIZE;
+	usb_ext->bDescriptorType = USB_DT_DEVICE_CAPABILITY;
+	usb_ext->bDevCapabilityType = USB_CAP_TYPE_EXT;
+	usb_ext->bmAttributes = USB_LPM_SUPPORT;
+
+	/*
+	 * The Superspeed USB Capability descriptor shall be implemented by all
+	 * SuperSpeed devices.
+	 */
+	ss_cap = (struct usb_ss_cap_descriptor *)
+		(cdev->req->buf+bos->wTotalLength);
+	bos->bNumDeviceCaps++;
+	bos->wTotalLength += USB_DT_USB_SS_CAP_SIZE;
+	ss_cap->bLength = USB_DT_USB_SS_CAP_SIZE;
+	ss_cap->bDescriptorType = USB_DT_DEVICE_CAPABILITY;
+	ss_cap->bDevCapabilityType = USB_SS_CAP_TYPE;
+	ss_cap->bmAttributes = 0; /* LTM is not supported yet */
+	ss_cap->wSpeedSupported = USB_LOW_SPEED_OPERATION |
+				USB_FULL_SPEED_OPERATION |
+				USB_HIGH_SPEED_OPERATION |
+				USB_5GBPS_OPERATION;
+	ss_cap->bFunctionalitySupport = USB_LOW_SPEED_OPERATION;
+
+	/* Get Controller configuration */
+	if (cdev->gadget->ops->get_config_params)
+		cdev->gadget->ops->get_config_params(&dcd_config_params);
+	else {
+		dcd_config_params.bU1devExitLat = USB_DEFULT_U1_DEV_EXIT_LAT;
+		dcd_config_params.bU2DevExitLat = USB_DEFULT_U2_DEV_EXIT_LAT;
+	}
+	ss_cap->bU1devExitLat = dcd_config_params.bU1devExitLat;
+	ss_cap->bU2DevExitLat = dcd_config_params.bU2DevExitLat;
+
+	return bos->wTotalLength;
+}
+
 static void device_qual(struct usb_composite_dev *cdev)
 {
 	struct usb_qualifier_descriptor	*qual = cdev->req->buf;
@@ -468,27 +695,42 @@ static int set_config(struct usb_composite_dev *cdev,
 	unsigned		power = gadget_is_otg(gadget) ? 8 : 100;
 	int			tmp;
 
-	if (cdev->config)
-		reset_config(cdev);
-
 	if (number) {
 		list_for_each_entry(c, &cdev->configs, list) {
 			if (c->bConfigurationValue == number) {
+				/*
+				 * Need to disable the FDs of the previous
+				 * configuration
+				 */
+				if (cdev->config)
+					reset_config(cdev);
 				result = 0;
 				break;
 			}
 		}
 		if (result < 0)
 			goto done;
-	} else
+	} else { /* Zero configuration value - need to reset the config */
+		if (cdev->config)
+			reset_config(cdev);
 		result = 0;
+	}
 
 	INFO(cdev, "%s speed config #%d: %s\n",
 		({ char *speed;
 		switch (gadget->speed) {
-		case USB_SPEED_LOW:	speed = "low"; break;
-		case USB_SPEED_FULL:	speed = "full"; break;
-		case USB_SPEED_HIGH:	speed = "high"; break;
+		case USB_SPEED_LOW:
+			speed = "low";
+			break;
+		case USB_SPEED_FULL:
+			speed = "full";
+			break;
+		case USB_SPEED_HIGH:
+			speed = "high";
+			break;
+		case USB_SPEED_SUPER:
+			speed = "super";
+			break;
 		default:		speed = "?"; break;
 		} ; speed; }), number, c ? c->label : "unconfigured");
 
@@ -511,7 +753,9 @@ static int set_config(struct usb_composite_dev *cdev,
 		 * function's setup callback instead of the current
 		 * configuration's setup callback.
 		 */
-		if (gadget->speed == USB_SPEED_HIGH)
+		if (gadget->speed == USB_SPEED_SUPER)
+			descriptors = f->ss_descriptors;
+		else if (gadget->speed == USB_SPEED_HIGH)
 			descriptors = f->hs_descriptors;
 		else
 			descriptors = f->descriptors;
@@ -596,14 +840,14 @@ int usb_add_config(struct usb_composite_dev *cdev,
 	} else {
 		unsigned	i;
 
-		DBG(cdev, "cfg %d/%p speeds:%s%s\n",
+		DBG(cdev, "cfg %d/%p speeds:%s%s%s\n",
 			config->bConfigurationValue, config,
+			config->superspeed ? " super" : "",
 			config->highspeed ? " high" : "",
 			config->fullspeed
 				? (gadget_is_dualspeed(cdev->gadget)
 					? " full"
-					: " full/low")
-				: "");
+					: " full/low") : "");
 
 		for (i = 0; i < MAX_CONFIG_INTERFACES; i++) {
 			struct usb_function	*f = config->interface[i];
@@ -721,7 +965,8 @@ static int get_string(struct usb_composite_dev *cdev,
 		return s->bLength;
 	}
 
-	/* Otherwise, look up and return a specified string.  First
+	/*
+	 * Otherwise, look up and return a specified string.  First
 	 * check if the string has not been overridden.
 	 */
 	if (cdev->manufacturer_override == id)
@@ -876,6 +1121,7 @@ composite_setup(struct usb_gadget *gadget, const struct usb_ctrlrequest *ctrl)
 	struct usb_composite_dev	*cdev = get_gadget_data(gadget);
 	struct usb_request		*req = cdev->req;
 	int				value = -EOPNOTSUPP;
+	int				status = 0;
 	u16				w_index = le16_to_cpu(ctrl->wIndex);
 	u8				intf = w_index & 0xFF;
 	u16				w_value = le16_to_cpu(ctrl->wValue);
@@ -903,18 +1149,28 @@ composite_setup(struct usb_gadget *gadget, const struct usb_ctrlrequest *ctrl)
 		case USB_DT_DEVICE:
 			cdev->desc.bNumConfigurations =
 				count_configs(cdev, USB_DT_DEVICE);
+			cdev->desc.bMaxPacketSize0 =
+				cdev->gadget->ep0->maxpacket;
+			if (gadget->speed >= USB_SPEED_SUPER)
+				cdev->desc.bcdUSB = cpu_to_le16(0x0300);
+			else if ((gadget_is_superspeed(gadget)) &&
+				 (gadget->speed <= USB_SPEED_HIGH))
+				cdev->desc.bcdUSB = cpu_to_le16(0x0210);
+
 			value = min(w_length, (u16) sizeof cdev->desc);
 			memcpy(req->buf, &cdev->desc, value);
 			break;
 		case USB_DT_DEVICE_QUALIFIER:
-			if (!gadget_is_dualspeed(gadget))
+			if (!gadget_is_dualspeed(gadget) ||
+			    gadget->speed >= USB_SPEED_SUPER)
 				break;
 			device_qual(cdev);
 			value = min_t(int, w_length,
 				sizeof(struct usb_qualifier_descriptor));
 			break;
 		case USB_DT_OTHER_SPEED_CONFIG:
-			if (!gadget_is_dualspeed(gadget))
+			if (!gadget_is_dualspeed(gadget) ||
+			    gadget->speed >= USB_SPEED_SUPER)
 				break;
 			/* FALLTHROUGH */
 		case USB_DT_CONFIG:
@@ -928,6 +1184,12 @@ composite_setup(struct usb_gadget *gadget, const struct usb_ctrlrequest *ctrl)
 			if (value >= 0)
 				value = min(w_length, (u16) value);
 			break;
+		case USB_DT_BOS:
+			if (gadget_is_superspeed(gadget)) {
+				value = bos(cdev);
+				value = min(w_length, (u16) value);
+			}
+			break;
 		}
 		break;
 
@@ -987,6 +1249,64 @@ composite_setup(struct usb_gadget *gadget, const struct usb_ctrlrequest *ctrl)
 		*((u8 *)req->buf) = value;
 		value = min(w_length, (u16) 1);
 		break;
+
+	/*
+	 * USB 3.0 additions:
+	 * Function driver should handle get_status request. If such cb
+	 * wasn't supplied we respond with default value = 0
+	 * Note: function driver should supply such cb only for the first
+	 * interface of the function
+	 */
+	case USB_REQ_GET_STATUS:
+		if (!gadget_is_superspeed(gadget))
+			goto unknown;
+		if (ctrl->bRequestType != (USB_DIR_IN | USB_RECIP_INTERFACE))
+			goto unknown;
+		value = 2;	/* This is the length of the get_status reply */
+		*((u16 *)req->buf) = 0;
+		if (!cdev->config || w_index >= MAX_CONFIG_INTERFACES)
+			break;
+		f = cdev->config->interface[intf];
+		if (!f)
+			break;
+		status = f->get_status ? f->get_status(f) : 0;
+		if (status < 0)
+			break;
+		*((u16 *)req->buf) = status & 0x0000ffff;
+		break;
+	/*
+	 * Function drivers should handle SetFeature/ClearFeature
+	 * (FUNCTION_SUSPEND) request. function_suspend cb should be supplied
+	 * only for the first interface of the function
+	 */
+	case USB_REQ_CLEAR_FEATURE:
+	case USB_REQ_SET_FEATURE:
+		if (!gadget_is_superspeed(gadget))
+			goto unknown;
+		if (ctrl->bRequestType != (USB_DIR_OUT | USB_RECIP_INTERFACE))
+			goto unknown;
+		switch (w_value) {
+		case USB_INTRF_FUNC_SUSPEND:
+			if (!cdev->config || w_index >= MAX_CONFIG_INTERFACES)
+				break;
+			f = cdev->config->interface[intf];
+			if (!f)
+				break;
+			value = f->func_suspend ?
+				f->func_suspend(f,
+					(u8)(w_index &
+					     USB_INTR_FUNC_SUSPEND_OPT_MASK)) :
+				0;
+			if (value < 0) {
+				ERROR(cdev, "func_suspend() returned "
+					    "error %d\n", value);
+				value = 0;
+			}
+			break;
+		default:
+			break;
+		}
+		break;
 	default:
 unknown:
 		VDBG(cdev,
@@ -1106,8 +1426,11 @@ composite_unbind(struct usb_gadget *gadget)
 				DBG(cdev, "unbind function '%s'/%p\n",
 						f->name, f);
 				f->unbind(c, f);
-				/* may free memory for "f" */
 			}
+			/* Free memory allocated for ss descriptors */
+			if (f->ss_desc_allocated && f->ss_descriptors)
+				usb_free_descriptors(f->ss_descriptors);
+			/* may free memory for "f" */
 		}
 		list_del(&c->list);
 		if (c->unbind) {
@@ -1345,6 +1668,9 @@ extern int usb_composite_probe(struct usb_composite_driver *driver,
 		driver->name = "composite";
 	composite_driver.function =  (char *) driver->name;
 	composite_driver.driver.name = driver->name;
+#ifdef CONFIG_USB_GADGET_SUPERSPEED
+	composite_driver.speed = USB_SPEED_SUPER;
+#endif /* CONFIG_USB_GADGET_SUPERSPEED */
 	composite = driver;
 	composite_gadget_bind = bind;
 
diff --git a/include/linux/usb/composite.h b/include/linux/usb/composite.h
index 4f56e44..e9fa7d8 100644
--- a/include/linux/usb/composite.h
+++ b/include/linux/usb/composite.h
@@ -51,6 +51,18 @@ struct usb_configuration;
  * @hs_descriptors: Table of high speed descriptors, using interface and
  *	string identifiers assigned during @bind().  If this pointer is null,
  *	the function will not be available at high speed.
+ * @ss_descriptors: Table of super speed descriptors. If
+ *	wasnt supplied by the FD during @bind() and
+ *	!ss_not_capble, will be generated automaticly with
+ *	default values while working in superspeed mode. If this
+ *	pointer is null after initiation, the function will not
+ *	be available at super speed.
+ * @ss_not_capable: This flag is used by the FD to indicate if
+ *	this function is SS capble. Meaning: if SS descriptors
+ *	weren't supplied by the FD, and the flag is set ss
+ *	descriptors will NOT be automatically generated
+ * @ss_desc_allocated: This flag indicates whether the ss descriptors were
+ *	dynamically allocated (and needs to be released).
  * @config: assigned when @usb_add_function() is called; this is the
  *	configuration with which this function is associated.
  * @bind: Before the gadget can register, all of its functions bind() to the
@@ -69,6 +81,10 @@ struct usb_configuration;
  * @setup: Used for interface-specific control requests.
  * @suspend: Notifies functions when the host stops sending USB traffic.
  * @resume: Notifies functions when the host restarts USB traffic.
+ * @get_status: Returns function status as a reply to
+ *	GetStatus() request when the recepient is Interface.
+ * @func_suspend: callback to be called when
+ *	SetFeature(FUNCTION_SUSPEND) is reseived
  *
  * A single USB function uses one or more interfaces, and should in most
  * cases support operation at both full and high speeds.  Each function is
@@ -98,6 +114,10 @@ struct usb_function {
 	struct usb_gadget_strings	**strings;
 	struct usb_descriptor_header	**descriptors;
 	struct usb_descriptor_header	**hs_descriptors;
+	struct usb_descriptor_header	**ss_descriptors;
+
+	unsigned			ss_desc_allocated:1;
+	unsigned			ss_not_capable:1;
 
 	struct usb_configuration	*config;
 
@@ -124,6 +144,10 @@ struct usb_function {
 	void			(*suspend)(struct usb_function *);
 	void			(*resume)(struct usb_function *);
 
+	/* USB 3.0 additions */
+	int			(*get_status)(struct usb_function *);
+	int			(*func_suspend)(struct usb_function *,
+						u8 suspend_opt);
 	/* private: */
 	/* internals */
 	struct list_head		list;
@@ -229,6 +253,7 @@ struct usb_configuration {
 	struct list_head	list;
 	struct list_head	functions;
 	u8			next_interface_id;
+	unsigned		superspeed:1;
 	unsigned		highspeed:1;
 	unsigned		fullspeed:1;
 	struct usb_function	*interface[MAX_CONFIG_INTERFACES];
diff --git a/include/linux/usb/gadget.h b/include/linux/usb/gadget.h
index 1bb7b3e..339552b 100644
--- a/include/linux/usb/gadget.h
+++ b/include/linux/usb/gadget.h
@@ -136,6 +136,8 @@ struct usb_ep_ops {
  *	descriptor that matches connection speed
  * @desc: endpoint descriptor.  This pointer is set before the endpoint is
  *	enabled and remains valid until the endpoint is disabled.
+ * @comp_desc: In case of SuperSpeed support, this is the endpoint companion
+ *	descriptor that is used to configure the endpoint
  *
  * the bus controller driver lists all the general purpose endpoints in
  * gadget->ep_list.  the control endpoint (gadget->ep0) is not in that list,
@@ -150,6 +152,7 @@ struct usb_ep {
 	unsigned		maxpacket:16;
 	u8				bEndpointAddress;
 	const struct usb_endpoint_descriptor	*desc;
+	const struct usb_ss_ep_comp_descriptor	*comp_desc;
 };
 
 /*-------------------------------------------------------------------------*/
@@ -417,6 +420,14 @@ static inline void usb_ep_fifo_flush(struct usb_ep *ep)
 
 /*-------------------------------------------------------------------------*/
 
+struct usb_dcd_config_params {
+	__u8  bU1devExitLat;	/* U1 Device exit Latency */
+#define USB_DEFULT_U1_DEV_EXIT_LAT	0x01	/* Less then 1 microsec */
+	__u16 bU2DevExitLat;	/* U2 Device exit Latency */
+#define USB_DEFULT_U2_DEV_EXIT_LAT	0x1F4	/* Less then 500 microsec */
+};
+
+
 struct usb_gadget;
 
 /* the rest of the api to the controller hardware: device operations,
@@ -431,6 +442,7 @@ struct usb_gadget_ops {
 	int	(*pullup) (struct usb_gadget *, int is_on);
 	int	(*ioctl)(struct usb_gadget *,
 				unsigned code, unsigned long param);
+	void	(*get_config_params)(struct usb_dcd_config_params *);
 };
 
 /**
@@ -522,6 +534,23 @@ static inline int gadget_is_dualspeed(struct usb_gadget *g)
 }
 
 /**
+ * gadget_is_superspeed() - return true if the hardware handles
+ * supperspeed
+ * @g: controller that might support supper speed
+ */
+static inline int gadget_is_superspeed(struct usb_gadget *g)
+{
+#ifdef CONFIG_USB_GADGET_SUPERSPEED
+	/* runtime test would check "g->is_superspeed" ... that might be
+	 * useful to work around hardware bugs, but is mostly pointless
+	 */
+	return 1;
+#else
+	return 0;
+#endif
+}
+
+/**
  * gadget_is_otg - return true iff the hardware is OTG-ready
  * @g: controller that might have a Mini-AB connector
  *
-- 
1.6.3.3

--
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
