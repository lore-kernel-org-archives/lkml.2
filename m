Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126Ab1EQNE7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 09:04:59 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:62420 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754842Ab1EQNE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 09:04:57 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6348"; a="91602465"
From: Tatyana Brokhman <tlinder@codeaurora.org>
To: greg@kroah.com
Cc: linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org, balbi@ti.com,
        ablay@codeaurora.org, Tatyana Brokhman <tlinder@codeaurora.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v10 4/7] usb:gadget: Add SuperSpeed support to the Gadget Framework
Date: Tue, 17 May 2011 16:03:18 +0300
Message-Id: <1305637403-3832-5-git-send-email-tlinder@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1305637403-3832-1-git-send-email-tlinder@codeaurora.org>
References: <1305637403-3832-1-git-send-email-tlinder@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the SuperSpeed functionality to the gadget framework.
Support for new SuperSpeed BOS descriptor was added.
Support for SET_FEATURE and GET_STATUS requests in SuperSpeed mode was
added.

Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>

---
 drivers/usb/gadget/Kconfig      |   11 ++
 drivers/usb/gadget/composite.c  |  238 ++++++++++++++++++++++++++++++++++++---
 drivers/usb/gadget/epautoconf.c |    7 +-
 include/linux/usb/ch9.h         |    2 -
 include/linux/usb/composite.h   |   16 +++
 include/linux/usb/gadget.h      |   34 ++++++
 6 files changed, 288 insertions(+), 20 deletions(-)

diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index 58456d1..61aa0ff 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -640,6 +640,17 @@ config USB_GADGET_DUALSPEED
 	  Means that gadget drivers should include extra descriptors
 	  and code to handle dual-speed controllers.
 
+config USB_GADGET_SUPERSPEED
+	boolean "Gadget operating in Super Speed"
+	depends on USB_GADGET
+	depends on USB_GADGET_DUALSPEED
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
index 5780f35..5be5f6d 100644
--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -129,6 +129,9 @@ int config_ep_by_speed(struct usb_gadget *g,
 	struct usb_endpoint_descriptor *chosen_desc = NULL;
 	struct usb_descriptor_header **speed_desc = NULL;
 
+	struct usb_ss_ep_comp_descriptor *comp_desc = NULL;
+	int want_comp_desc = 0;
+
 	struct usb_descriptor_header **d_spd; /* cursor for speed desc */
 
 	if (!g || !f || !_ep)
@@ -136,6 +139,13 @@ int config_ep_by_speed(struct usb_gadget *g,
 
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
@@ -157,7 +167,35 @@ ep_found:
 	/* commit results */
 	_ep->maxpacket = le16_to_cpu(chosen_desc->wMaxPacketSize);
 	_ep->desc = chosen_desc;
-
+	_ep->comp_desc = NULL;
+	_ep->maxburst = 0;
+	_ep->mult = 0;
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
+		if (g->speed == USB_SPEED_SUPER) {
+			switch (usb_endpoint_type(_ep->desc)) {
+			case USB_ENDPOINT_XFER_BULK:
+			case USB_ENDPOINT_XFER_INT:
+				_ep->maxburst = comp_desc->bMaxBurst;
+				break;
+			case USB_ENDPOINT_XFER_ISOC:
+				/* mult: bits 1:0 of bmAttributes */
+				_ep->mult = comp_desc->bmAttributes & 0x3;
+				break;
+			default:
+				/* Do nothing for control endpoints */
+				break;
+			}
+		}
+	}
 	return 0;
 }
 
@@ -209,6 +247,8 @@ int usb_add_function(struct usb_configuration *config,
 		config->fullspeed = true;
 	if (!config->highspeed && function->hs_descriptors)
 		config->highspeed = true;
+	if (!config->superspeed && function->ss_descriptors)
+		config->superspeed = true;
 
 done:
 	if (value)
@@ -352,7 +392,9 @@ static int config_buf(struct usb_configuration *config,
 	list_for_each_entry(f, &config->functions, list) {
 		struct usb_descriptor_header **descriptors;
 
-		if (speed == USB_SPEED_HIGH)
+		if (speed == USB_SPEED_SUPER)
+			descriptors = f->ss_descriptors;
+		else if (speed == USB_SPEED_HIGH)
 			descriptors = f->hs_descriptors;
 		else
 			descriptors = f->descriptors;
@@ -378,9 +420,10 @@ static int config_desc(struct usb_composite_dev *cdev, unsigned w_value)
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
@@ -394,7 +437,10 @@ static int config_desc(struct usb_composite_dev *cdev, unsigned w_value)
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
@@ -414,16 +460,22 @@ static int count_configs(struct usb_composite_dev *cdev, unsigned type)
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
@@ -435,6 +487,73 @@ static int count_configs(struct usb_composite_dev *cdev, unsigned type)
 	return count;
 }
 
+/**
+ * bos_desc() - prepares the BOS descriptor.
+ * @cdev: pointer to usb_composite device to generate the bos
+ *	descriptor for
+ *
+ * This function generates the BOS (Binary Device Object)
+ * descriptor and its device capabilities descriptors. The BOS
+ * descriptor should be supported by a SuperSpeed device.
+ */
+static int bos_desc(struct usb_composite_dev *cdev)
+{
+	struct usb_ext_cap_descriptor	*usb_ext;
+	struct usb_ss_cap_descriptor	*ss_cap;
+	struct usb_dcd_config_params	dcd_config_params;
+	struct usb_bos_descriptor	*bos = cdev->req->buf;
+
+	bos->bLength = USB_DT_BOS_SIZE;
+	bos->bDescriptorType = USB_DT_BOS;
+
+	bos->wTotalLength = cpu_to_le16(USB_DT_BOS_SIZE);
+	bos->bNumDeviceCaps = 0;
+
+	/*
+	 * A SuperSpeed device shall include the USB2.0 extension descriptor
+	 * and shall support LPM when operating in USB2.0 HS mode.
+	 */
+	usb_ext = (struct usb_ext_cap_descriptor *)
+			(cdev->req->buf+bos->wTotalLength);
+	bos->bNumDeviceCaps++;
+	le16_add_cpu(&(bos->wTotalLength), USB_DT_USB_EXT_CAP_SIZE);
+	usb_ext->bLength = USB_DT_USB_EXT_CAP_SIZE;
+	usb_ext->bDescriptorType = USB_DT_DEVICE_CAPABILITY;
+	usb_ext->bDevCapabilityType = USB_CAP_TYPE_EXT;
+	usb_ext->bmAttributes = cpu_to_le32(USB_LPM_SUPPORT);
+
+	/*
+	 * The Superspeed USB Capability descriptor shall be implemented by all
+	 * SuperSpeed devices.
+	 */
+	ss_cap = (struct usb_ss_cap_descriptor *)
+		(cdev->req->buf+bos->wTotalLength);
+	bos->bNumDeviceCaps++;
+	le16_add_cpu(&(bos->wTotalLength), USB_DT_USB_SS_CAP_SIZE);
+	ss_cap->bLength = USB_DT_USB_SS_CAP_SIZE;
+	ss_cap->bDescriptorType = USB_DT_DEVICE_CAPABILITY;
+	ss_cap->bDevCapabilityType = USB_SS_CAP_TYPE;
+	ss_cap->bmAttributes = 0; /* LTM is not supported yet */
+	ss_cap->wSpeedSupported = cpu_to_le16(USB_LOW_SPEED_OPERATION |
+				USB_FULL_SPEED_OPERATION |
+				USB_HIGH_SPEED_OPERATION |
+				USB_5GBPS_OPERATION);
+	ss_cap->bFunctionalitySupport = USB_LOW_SPEED_OPERATION;
+
+	/* Get Controller configuration */
+	if (cdev->gadget->ops->get_config_params)
+		cdev->gadget->ops->get_config_params(&dcd_config_params);
+	else {
+		dcd_config_params.bU1devExitLat = USB_DEFULT_U1_DEV_EXIT_LAT;
+		dcd_config_params.bU2DevExitLat =
+			cpu_to_le16(USB_DEFULT_U2_DEV_EXIT_LAT);
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
@@ -478,20 +597,26 @@ static int set_config(struct usb_composite_dev *cdev,
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
@@ -499,6 +624,9 @@ static int set_config(struct usb_composite_dev *cdev,
 		case USB_SPEED_LOW:	speed = "low"; break;
 		case USB_SPEED_FULL:	speed = "full"; break;
 		case USB_SPEED_HIGH:	speed = "high"; break;
+		case USB_SPEED_SUPER:
+			speed = "super";
+			break;
 		default:		speed = "?"; break;
 		} ; speed; }), number, c ? c->label : "unconfigured");
 
@@ -521,7 +649,9 @@ static int set_config(struct usb_composite_dev *cdev,
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
@@ -617,8 +747,9 @@ int usb_add_config(struct usb_composite_dev *cdev,
 	} else {
 		unsigned	i;
 
-		DBG(cdev, "cfg %d/%p speeds:%s%s\n",
+		DBG(cdev, "cfg %d/%p speeds:%s%s%s\n",
 			config->bConfigurationValue, config,
+			config->superspeed ? " super" : "",
 			config->highspeed ? " high" : "",
 			config->fullspeed
 				? (gadget_is_dualspeed(cdev->gadget)
@@ -897,6 +1028,7 @@ composite_setup(struct usb_gadget *gadget, const struct usb_ctrlrequest *ctrl)
 	struct usb_composite_dev	*cdev = get_gadget_data(gadget);
 	struct usb_request		*req = cdev->req;
 	int				value = -EOPNOTSUPP;
+	int				status = 0;
 	u16				w_index = le16_to_cpu(ctrl->wIndex);
 	u8				intf = w_index & 0xFF;
 	u16				w_value = le16_to_cpu(ctrl->wValue);
@@ -924,18 +1056,29 @@ composite_setup(struct usb_gadget *gadget, const struct usb_ctrlrequest *ctrl)
 		case USB_DT_DEVICE:
 			cdev->desc.bNumConfigurations =
 				count_configs(cdev, USB_DT_DEVICE);
+			cdev->desc.bMaxPacketSize0 =
+				cdev->gadget->ep0->maxpacket;
+			if (gadget_is_superspeed(gadget)) {
+				if (gadget->speed >= USB_SPEED_SUPER)
+					cdev->desc.bcdUSB = cpu_to_le16(0x0300);
+				else
+					cdev->desc.bcdUSB = cpu_to_le16(0x0210);
+			}
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
@@ -949,6 +1092,12 @@ composite_setup(struct usb_gadget *gadget, const struct usb_ctrlrequest *ctrl)
 			if (value >= 0)
 				value = min(w_length, (u16) value);
 			break;
+		case USB_DT_BOS:
+			if (gadget_is_superspeed(gadget)) {
+				value = bos_desc(cdev);
+				value = min(w_length, (u16) value);
+			}
+			break;
 		}
 		break;
 
@@ -1016,6 +1165,62 @@ composite_setup(struct usb_gadget *gadget, const struct usb_ctrlrequest *ctrl)
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
+		*((__le16 *)req->buf) = 0;
+		if (!cdev->config || intf >= MAX_CONFIG_INTERFACES)
+			break;
+		f = cdev->config->interface[intf];
+		if (!f)
+			break;
+		status = f->get_status ? f->get_status(f) : 0;
+		if (status < 0)
+			break;
+		*((__le16 *)req->buf) = cpu_to_le16(status & 0x0000ffff);
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
+			if (!cdev->config || intf >= MAX_CONFIG_INTERFACES)
+				break;
+			f = cdev->config->interface[intf];
+			if (!f)
+				break;
+			value = 0;
+			if (f->func_suspend)
+				value = f->func_suspend(f, w_index >> 8);
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
@@ -1379,6 +1584,9 @@ int usb_composite_probe(struct usb_composite_driver *driver,
 		driver->iProduct = driver->name;
 	composite_driver.function =  (char *) driver->name;
 	composite_driver.driver.name = driver->name;
+#ifdef CONFIG_USB_GADGET_SUPERSPEED
+	composite_driver.speed = USB_SPEED_SUPER;
+#endif /* CONFIG_USB_GADGET_SUPERSPEED */
 	composite = driver;
 	composite_gadget_bind = bind;
 
diff --git a/drivers/usb/gadget/epautoconf.c b/drivers/usb/gadget/epautoconf.c
index de3461a..7c5b450 100644
--- a/drivers/usb/gadget/epautoconf.c
+++ b/drivers/usb/gadget/epautoconf.c
@@ -142,13 +142,13 @@ ep_matches (
 	max = 0x7ff & le16_to_cpu(desc->wMaxPacketSize);
 	switch (type) {
 	case USB_ENDPOINT_XFER_INT:
-		/* INT:  limit 64 bytes full speed, 1024 high speed */
+		/* INT:  limit 64 bytes full speed, 1024 high/super speed */
 		if (!gadget->is_dualspeed && max > 64)
 			return 0;
 		/* FALLTHROUGH */
 
 	case USB_ENDPOINT_XFER_ISOC:
-		/* ISO:  limit 1023 bytes full speed, 1024 high speed */
+		/* ISO:  limit 1023 bytes full speed, 1024 high/super speed */
 		if (ep->maxpacket < max)
 			return 0;
 		if (!gadget->is_dualspeed && max > 1023)
@@ -183,7 +183,8 @@ ep_matches (
 	}
 
 	/* report (variable) full speed bulk maxpacket */
-	if (USB_ENDPOINT_XFER_BULK == type) {
+	if ((USB_ENDPOINT_XFER_BULK == type)
+	    && (gadget->speed < USB_SPEED_HIGH)) {
 		int size = ep->maxpacket;
 
 		/* min() doesn't work on bitfields with gcc-3.5 */
diff --git a/include/linux/usb/ch9.h b/include/linux/usb/ch9.h
index 0fd3fbd..7654b64 100644
--- a/include/linux/usb/ch9.h
+++ b/include/linux/usb/ch9.h
@@ -142,8 +142,6 @@
 #define USB_DEVICE_LTM_ENABLE	50	/* dev may send LTM */
 #define USB_INTRF_FUNC_SUSPEND	0	/* function suspend */
 
-#define USB_INTR_FUNC_SUSPEND_OPT_MASK	0xFF00
-
 #define USB_ENDPOINT_HALT		0	/* IN/OUT will STALL */
 
 /* Bit array elements as returned by the USB_REQ_GET_STATUS request. */
diff --git a/include/linux/usb/composite.h b/include/linux/usb/composite.h
index 5564d5e..511bc2a 100644
--- a/include/linux/usb/composite.h
+++ b/include/linux/usb/composite.h
@@ -59,6 +59,12 @@ struct usb_configuration;
  * @hs_descriptors: Table of high speed descriptors, using interface and
  *	string identifiers assigned during @bind().  If this pointer is null,
  *	the function will not be available at high speed.
+ * @ss_descriptors: Table of super speed descriptors. If
+ *	wasnt supplied by the FD during @bind() and
+ *	!ss_not_capble, will be generated automaticly with
+ *	default values while working in superspeed mode. If this
+ *	pointer is null after initiation, the function will not
+ *	be available at super speed.
  * @config: assigned when @usb_add_function() is called; this is the
  *	configuration with which this function is associated.
  * @bind: Before the gadget can register, all of its functions bind() to the
@@ -77,6 +83,10 @@ struct usb_configuration;
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
@@ -106,6 +116,7 @@ struct usb_function {
 	struct usb_gadget_strings	**strings;
 	struct usb_descriptor_header	**descriptors;
 	struct usb_descriptor_header	**hs_descriptors;
+	struct usb_descriptor_header	**ss_descriptors;
 
 	struct usb_configuration	*config;
 
@@ -132,6 +143,10 @@ struct usb_function {
 	void			(*suspend)(struct usb_function *);
 	void			(*resume)(struct usb_function *);
 
+	/* USB 3.0 additions */
+	int			(*get_status)(struct usb_function *);
+	int			(*func_suspend)(struct usb_function *,
+						u8 suspend_opt);
 	/* private: */
 	/* internals */
 	struct list_head		list;
@@ -237,6 +252,7 @@ struct usb_configuration {
 	struct list_head	list;
 	struct list_head	functions;
 	u8			next_interface_id;
+	unsigned		superspeed:1;
 	unsigned		highspeed:1;
 	unsigned		fullspeed:1;
 	struct usb_function	*interface[MAX_CONFIG_INTERFACES];
diff --git a/include/linux/usb/gadget.h b/include/linux/usb/gadget.h
index 563b4e0..733685a 100644
--- a/include/linux/usb/gadget.h
+++ b/include/linux/usb/gadget.h
@@ -131,11 +131,15 @@ struct usb_ep_ops {
  * @maxpacket:The maximum packet size used on this endpoint.  The initial
  *	value can sometimes be reduced (hardware allowing), according to
  *      the endpoint descriptor used to configure the endpoint.
+ * @mult: multiplier, 'mult' value for SS Isoc EPs
+ * @maxburst: the maximum number of bursts supported by this EP (for usb3)
  * @driver_data:for use by the gadget driver.
  * @bEndpointAddress: used to identify the endpoint when finding
  *	descriptor that matches connection speed
  * @desc: endpoint descriptor.  This pointer is set before the endpoint is
  *	enabled and remains valid until the endpoint is disabled.
+ * @comp_desc: In case of SuperSpeed support, this is the endpoint companion
+ *	descriptor that is used to configure the endpoint
  *
  * the bus controller driver lists all the general purpose endpoints in
  * gadget->ep_list.  the control endpoint (gadget->ep0) is not in that list,
@@ -148,8 +152,12 @@ struct usb_ep {
 	const struct usb_ep_ops	*ops;
 	struct list_head	ep_list;
 	unsigned		maxpacket:16;
+	unsigned				mult:2;
+	unsigned				pad:1;
+	unsigned				maxburst:4;
 	u8				bEndpointAddress;
 	const struct usb_endpoint_descriptor	*desc;
+	const struct usb_ss_ep_comp_descriptor	*comp_desc;
 };
 
 /*-------------------------------------------------------------------------*/
@@ -417,6 +425,14 @@ static inline void usb_ep_fifo_flush(struct usb_ep *ep)
 
 /*-------------------------------------------------------------------------*/
 
+struct usb_dcd_config_params {
+	__u8  bU1devExitLat;	/* U1 Device exit Latency */
+#define USB_DEFULT_U1_DEV_EXIT_LAT	0x01	/* Less then 1 microsec */
+	__le16 bU2DevExitLat;	/* U2 Device exit Latency */
+#define USB_DEFULT_U2_DEV_EXIT_LAT	0x1F4	/* Less then 500 microsec */
+};
+
+
 struct usb_gadget;
 
 /* the rest of the api to the controller hardware: device operations,
@@ -431,6 +447,7 @@ struct usb_gadget_ops {
 	int	(*pullup) (struct usb_gadget *, int is_on);
 	int	(*ioctl)(struct usb_gadget *,
 				unsigned code, unsigned long param);
+	void	(*get_config_params)(struct usb_dcd_config_params *);
 };
 
 /**
@@ -522,6 +539,23 @@ static inline int gadget_is_dualspeed(struct usb_gadget *g)
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
1.7.3.3

--
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
