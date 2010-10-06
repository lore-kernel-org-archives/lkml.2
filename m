Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759864Ab0JFT3O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 15:29:14 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:17149 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755263Ab0JFT3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 15:29:13 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6128"; a="56949815"
Message-ID: <3a8c9af88e80bc39304fff99b6d7bfd6.squirrel@www.codeaurora.org>
In-Reply-To: <1286092937-29191-1-git-send-email-tlinder@codeaurora.org>
References: <1286092937-29191-1-git-send-email-tlinder@codeaurora.org>
Date: Wed, 6 Oct 2010 12:30:59 -0700 (PDT)
Subject: Re: [RFC/PATCH 2/2] usb:gadget: Add SuperSpeed support to the 
     Gadget Framework
From: tlinder@codeaurora.org
To: "tlinder" <tlinder@codeaurora.org>
Cc: linux-usb@vger.kernel.org, "Tatyana Linder" <tlinder@codeaurora.org>,
        "David Brownell" <dbrownell@users.sourceforge.net>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        "Michal Nazarewicz" <m.nazarewicz@samsung.com>,
        "Randy Dunlap" <randy.dunlap@oracle.com>,
        "Laurent Pinchart" <laurent.pinchart@ideasonboard.com>,
        "Kyungmin Park" <kyungmin.park@samsung.com>,
        "Robert Lukassen" <robert.lukassen@tomtom.com>,
        "Sarah Sharp" <sarah.a.sharp@linux.intel.com>,
        "Matthew Wilcox" <willy@linux.intel.com>,
        "Fabien Chouteau" <fabien.chouteau@barco.com>,
        "Tejun Heo" <tj@kernel.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, david.vrabel@csr.com
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding David Vrabel to review from a WUSB point of view.

> From: Tatyana Linder <tlinder@codeaurora.org>
>
> This patch adds the SuperSpeed functionality to the gadget framework.
> In order not to force all the FDs to supply SuperSpeed descriptors when
> operating in SuperSpeed mode the following approach was taken:
> If we're operating in SuperSpeed mode and the FD didn't supply SuperSpeed
> descriptors, the composite layer will automatically create SuperSpeed
> descriptors with default values.
> Support for new SuperSpeed BOS descriptor was added.
> Support for SET_FEATURE and GET_STATUS requests in SuperSpeed mode was
> added.
>
> Signed-off-by: Tatyana Linder <tlinder@codeaurora.org>
> ---
> This patch was verified by USBCV 3.0 and 2.0.
>
>  drivers/usb/gadget/Kconfig     |   20 ++-
>  drivers/usb/gadget/composite.c |  319
> +++++++++++++++++++++++++++++++++++++---
>  include/linux/usb/ch9.h        |   54 +++++++-
>  include/linux/usb/composite.h  |   24 +++
>  include/linux/usb/gadget.h     |   19 +++
>  5 files changed, 407 insertions(+), 29 deletions(-)
>
> diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
> index cd27f9b..9afdd08 100644
> --- a/drivers/usb/gadget/Kconfig
> +++ b/drivers/usb/gadget/Kconfig
> @@ -520,11 +520,11 @@ config USB_GADGET_DUMMY_HCD
>  	  side is the master; the gadget side is the slave.  Gadget drivers
>  	  can be high, full, or low speed; and they have access to endpoints
>  	  like those from NET2280, PXA2xx, or SA1100 hardware.
> -
> +
>  	  This may help in some stages of creating a driver to embed in a
>  	  Linux device, since it lets you debug several parts of the gadget
>  	  driver without its hardware or drivers being involved.
> -
> +
>  	  Since such a gadget side driver needs to interoperate with a host
>  	  side Linux-USB device driver, this may help to debug both sides
>  	  of a USB protocol stack.
> @@ -552,6 +552,18 @@ config USB_GADGET_DUALSPEED
>  	  Means that gadget drivers should include extra descriptors
>  	  and code to handle dual-speed controllers.
>
> +config USB_GADGET_SUPERSPEED
> +	boolean "Gadget opperating in Super Speed"
> +	depends on USB_GADGET
> +	depends on USB_GADGET_DUALSPEED
> +	default n
> +	help
> +	  Enabling this feature enables Super Speed support in the Gadget
> +	  driver. It means that gadget drivers should include extra (SuperSpeed)
> +	  descriptors.
> +	  For composite devices: if SupeSpeed descriptors weren't supplied by
> +	  the FD, they will be automatically generated with default values.
> +
>  #
>  # USB Gadget Drivers
>  #
> @@ -633,7 +645,7 @@ config USB_ETH
>  	help
>  	  This driver implements Ethernet style communication, in one of
>  	  several ways:
> -
> +
>  	   - The "Communication Device Class" (CDC) Ethernet Control Model.
>  	     That protocol is often avoided with pure Ethernet adapters, in
>  	     favor of simpler vendor-specific hardware, but is widely
> @@ -673,7 +685,7 @@ config USB_ETH_RNDIS
>  	   If you say "y" here, the Ethernet gadget driver will try to provide
>  	   a second device configuration, supporting RNDIS to talk to such
>  	   Microsoft USB hosts.
> -
> +
>  	   To make MS-Windows work with this, use Documentation/usb/linux.inf
>  	   as the "driver info file".  For versions of MS-Windows older than
>  	   XP, you'll need to download drivers from Microsoft's website; a URL
> diff --git a/drivers/usb/gadget/composite.c
> b/drivers/usb/gadget/composite.c
> index c619c80..a5dcfe1 100644
> --- a/drivers/usb/gadget/composite.c
> +++ b/drivers/usb/gadget/composite.c
> @@ -70,6 +70,102 @@ static char *iSerialNumber;
>  module_param(iSerialNumber, charp, 0);
>  MODULE_PARM_DESC(iSerialNumber, "SerialNumber string");
>
> +/** Default endpoint companion descriptor */
> +static struct usb_ss_ep_comp_descriptor ep_comp_desc = {
> +		.bDescriptorType = USB_DT_SS_ENDPOINT_COMP,
> +		.bLength = 0x06,
> +		.bMaxBurst = 0, /*the default is we don't support bursting*/
> +		.bmAttributes = 0, /*2^0 streams supported*/
> +		.wBytesPerInterval = 0,
> +};
> +
> +/**This function receives a pointer to usb_function and adds
> + * missing super speed descriptors in the ss_descriptor field
> + * according to its hs_descriptors field.
> + *
> + * In more details: this function copies f->hs_descriptors while
> + * updating the endpoint descriptor and adding endpoint
> + * companion descriptor
> + */
> +static void create_ss_descriptors(struct usb_function *f)
> +{
> +	unsigned bytes; /*number of bytes to allocate*/
> +	unsigned n_desc;    /* number of descriptors*/
> +	void *mem; /*allocated memory to copy to*/
> +	struct usb_descriptor_header **tmp;
> +	struct usb_endpoint_descriptor	*ep_desc ;
> +	struct usb_descriptor_header **src = f->hs_descriptors;
> +
> +	if (!f->hs_descriptors)
> +		return;
> +
> +	/* Count number of EPs (in order to know how many SS_EP_COMPANION
> +	   descriptors to add), the total number of descriptors and the sum of
> +	   each descriptor bLength field in order to know how much memory to
> +	   allocate*/
> +	for (bytes = 0, n_desc = 0, tmp = src; *tmp; tmp++, n_desc++) {
> +		if ((*tmp)->bDescriptorType == USB_DT_ENDPOINT) {
> +			bytes += ep_comp_desc.bLength;
> +			n_desc++;
> +		}
> +		bytes += (*tmp)->bLength;
> +	}
> +
> +	bytes += (n_desc + 1) * sizeof(*tmp);
> +	mem = kmalloc(bytes, GFP_KERNEL);
> +	if (!mem)
> +		return;
> +
> +	/* fill in pointers starting at "tmp",
> +	 * to descriptors copied starting at "mem";
> +	 * and return "ret"
> +	 */
> +	tmp = mem;
> +	f->ss_descriptors  = mem;
> +	mem += (n_desc + 1) * sizeof(*tmp);
> +	while (*src) {
> +		/*Copy the original descriptor*/
> +		memcpy(mem, *src, (*src)->bLength);
> +		switch ((*src)->bDescriptorType) {
> +		case USB_DT_ENDPOINT:
> +			/*update ep descriptor*/
> +			ep_desc = (struct usb_endpoint_descriptor *)mem;
> +			switch (ep_desc->bmAttributes &
> +				USB_ENDPOINT_XFERTYPE_MASK) {
> +			case USB_ENDPOINT_XFER_CONTROL:
> +				ep_desc->wMaxPacketSize = 512;
> +				ep_desc->bInterval = 0;
> +				break;
> +			case USB_ENDPOINT_XFER_BULK:
> +				ep_desc->wMaxPacketSize = 1024;
> +				ep_desc->bInterval = 0;
> +				break;
> +			case USB_ENDPOINT_XFER_INT:
> +			case USB_ENDPOINT_XFER_ISOC:
> +				break;
> +			}
> +			*tmp = mem;
> +			tmp++;
> +			mem += (*src)->bLength;
> +			/*add ep companion descriptor*/
> +			memcpy(mem, &ep_comp_desc, ep_comp_desc.bLength);
> +			*tmp = mem;
> +			tmp++;
> +			mem += ep_comp_desc.bLength;
> +			break;
> +		default:
> +			*tmp = mem;
> +			tmp++;
> +			mem += (*src)->bLength;
> +			break;
> +		}
> +		src++;
> +	}
> +	*tmp = NULL; /*The last (struct usb_descriptor_header *) in the
> +			descriptors vector is NULL*/
> +	f->ss_desc_allocated = true;
> +}
> +
>  /*-------------------------------------------------------------------------*/
>  /**
>   * next_ep_desc - advance to the next EP descriptor
> @@ -110,6 +206,9 @@ int ep_choose(struct usb_gadget *g, struct
> usb_function *f, struct usb_ep *_ep)
>  	struct usb_endpoint_descriptor *chosen_desc = NULL;
>  	struct usb_descriptor_header **speed_desc = NULL;
>
> +	struct usb_ss_ep_comp_descriptor *comp_desc = NULL;
> +	int want_comp_desc = 0;
> +
>  	struct usb_descriptor_header **d_spd; /* cursor for speed desc */
>
>  	if (!g || !f || !_ep)
> @@ -117,6 +216,13 @@ int ep_choose(struct usb_gadget *g, struct
> usb_function *f, struct usb_ep *_ep)
>
>  	/* select desired speed */
>  	switch (g->speed) {
> +	case USB_SPEED_SUPER:
> +		if (gadget_is_superspeed(g)) {
> +			speed_desc = f->ss_descriptors;
> +			want_comp_desc = 1;
> +			break;
> +		}
> +		/*else: Fall trough*/
>  	case USB_SPEED_HIGH:
>  		if (gadget_is_dualspeed(g)) {
>  			speed_desc = f->hs_descriptors;
> @@ -143,7 +249,18 @@ ep_found:
>  	/* commit results */
>  	_ep->maxpacket = chosen_desc->wMaxPacketSize;
>  	_ep->desc = chosen_desc;
> -
> +	_ep->comp_desc = NULL;
> +	if (want_comp_desc) {
> +		/**
> +		 * Companion descriptor should follow EP descriptor
> +		 * USB 3.0 spec, #9.6.7
> +		 */
> +		comp_desc = (struct usb_ss_ep_comp_descriptor *)*(++d_spd);
> +		if (!comp_desc ||
> +		    (comp_desc->bDescriptorType != USB_DT_SS_ENDPOINT_COMP))
> +			return -EIO;
> +		_ep->comp_desc = comp_desc;
> +	}
>  	return 0;
>  }
>
> @@ -185,6 +302,12 @@ int usb_add_function(struct usb_configuration
> *config,
>  			list_del(&function->list);
>  			function->config = NULL;
>  		}
> +		/*Add SS descriptors if there are any. This has to be done
> +		  after the bind since we need the hs_descriptors to be set in
> +		  usb_function and some of the FDs does it in the bind. */
> +		if ((gadget_is_superspeed(config->cdev->gadget)) &&
> +		    (!function->ss_not_capable) && (!function->ss_descriptors))
> +			create_ss_descriptors(function);
>  	} else
>  		value = 0;
>
> @@ -197,6 +320,8 @@ int usb_add_function(struct usb_configuration *config,
>  		config->fullspeed = true;
>  	if (!config->highspeed && function->hs_descriptors)
>  		config->highspeed = true;
> +	if (!config->superspeed && function->ss_descriptors)
> +		config->superspeed = true;
>
>  done:
>  	if (value)
> @@ -340,7 +465,9 @@ static int config_buf(struct usb_configuration
> *config,
>  	list_for_each_entry(f, &config->functions, list) {
>  		struct usb_descriptor_header **descriptors;
>
> -		if (speed == USB_SPEED_HIGH)
> +		if (speed == USB_SPEED_SUPER)
> +			descriptors = f->ss_descriptors;
> +		else if (speed == USB_SPEED_HIGH)
>  			descriptors = f->hs_descriptors;
>  		else
>  			descriptors = f->descriptors;
> @@ -366,23 +493,26 @@ static int config_desc(struct usb_composite_dev
> *cdev, unsigned w_value)
>  	u8				type = w_value >> 8;
>  	enum usb_device_speed		speed = USB_SPEED_UNKNOWN;
>
> -	if (gadget_is_dualspeed(gadget)) {
> -		int			hs = 0;
> -
> +	if (gadget->speed == USB_SPEED_SUPER)
> +		speed = gadget->speed;
> +	else if (gadget_is_dualspeed(gadget)) {
> +		int	hs = 0;
>  		if (gadget->speed == USB_SPEED_HIGH)
>  			hs = 1;
>  		if (type == USB_DT_OTHER_SPEED_CONFIG)
>  			hs = !hs;
>  		if (hs)
>  			speed = USB_SPEED_HIGH;
> -
>  	}
>
>  	/* This is a lookup by config *INDEX* */
>  	w_value &= 0xff;
>  	list_for_each_entry(c, &cdev->configs, list) {
>  		/* ignore configs that won't work at this speed */
> -		if (speed == USB_SPEED_HIGH) {
> +		if (speed == USB_SPEED_SUPER) {
> +			if (!c->superspeed)
> +				continue;
> +		} else if (speed == USB_SPEED_HIGH) {
>  			if (!c->highspeed)
>  				continue;
>  		} else {
> @@ -402,16 +532,22 @@ static int count_configs(struct usb_composite_dev
> *cdev, unsigned type)
>  	struct usb_configuration	*c;
>  	unsigned			count = 0;
>  	int				hs = 0;
> +	int				ss = 0;
>
>  	if (gadget_is_dualspeed(gadget)) {
>  		if (gadget->speed == USB_SPEED_HIGH)
>  			hs = 1;
> +		if (gadget->speed == USB_SPEED_SUPER)
> +			ss = 1;
>  		if (type == USB_DT_DEVICE_QUALIFIER)
>  			hs = !hs;
>  	}
>  	list_for_each_entry(c, &cdev->configs, list) {
>  		/* ignore configs that won't work at this speed */
> -		if (hs) {
> +		if (ss) {
> +			if (!c->superspeed)
> +				continue;
> +		} else if (hs) {
>  			if (!c->highspeed)
>  				continue;
>  		} else {
> @@ -423,6 +559,55 @@ static int count_configs(struct usb_composite_dev
> *cdev, unsigned type)
>  	return count;
>  }
>
> +/**
> + * bos() - prepares the BOS (Binary Device Object) descriptor
> + * and its device capabilities descriptors. The bos descriptor
> + * should be supported by a Superspeed device.
> + */
> +static int bos(struct usb_composite_dev *cdev)
> +{
> +	struct usb_bos_descriptor	*bos = cdev->req->buf;
> +	struct usb_ext_cap_descriptor	*usb_ext = NULL;
> +	struct ss_usb_cap_descriptor	*ss_cap = NULL;
> +
> +	bos->bLength = USB_DT_BOS_SIZE;
> +	bos->bDescriptorType = USB_DT_BOS;
> +
> +	bos->wTotalLength = USB_DT_BOS_SIZE;
> +	bos->bNumDeviceCaps = 0;
> +
> +	/* A SuperSpeed device shall include the USB2.0 extension descriptor and
> +	   shall support LPM when operating in USB2.0 HS mode.*/
> +	usb_ext = (struct usb_ext_cap_descriptor *)
> +			(cdev->req->buf+bos->wTotalLength);
> +	bos->bNumDeviceCaps++;
> +	bos->wTotalLength += USB_DT_USB_EXT_CAP_SIZE;
> +	usb_ext->bLength = USB_DT_USB_EXT_CAP_SIZE;
> +	usb_ext->bDescriptorType = USB_DT_DEVICE_CAPABILITY;
> +	usb_ext->bDevCapabilityType = USB_CAP_TYPE_EXT;
> +	usb_ext->bmAttributes = USB_LPM_SUPPORT;
> +
> +	/* The Superspeed USB Capability descriptor shall be implemented by all
> +	   Superspeed devices. */
> +	ss_cap = (struct ss_usb_cap_descriptor *)
> +		(cdev->req->buf+bos->wTotalLength);
> +	bos->bNumDeviceCaps++;
> +	bos->wTotalLength += USB_DT_SS_USB_CAP_SIZE;
> +	ss_cap->bLength = USB_DT_SS_USB_CAP_SIZE;
> +	ss_cap->bDescriptorType = USB_DT_DEVICE_CAPABILITY;
> +	ss_cap->bDevCapabilityType = SS_USB_CAP_TYPE;
> +	ss_cap->bmAttributes = 0; /*LTM is not supported yet*/
> +	ss_cap->wSpeedSupported = USB_LOW_SPEED_OPERATION |
> +				USB_FULL_SPEED_OPERATION |
> +				USB_HIGH_SPEED_OPERATION |
> +				USB_5GBPS_OPERATION;
> +	ss_cap->bFunctionalitySupport = USB_LOW_SPEED_OPERATION;
> +	ss_cap->bU1devExitLat = 0;
> +	ss_cap->bU2DevExitLat = 0;
> +
> +	return bos->wTotalLength;
> +}
> +
>  static void device_qual(struct usb_composite_dev *cdev)
>  {
>  	struct usb_qualifier_descriptor	*qual = cdev->req->buf;
> @@ -466,27 +651,40 @@ static int set_config(struct usb_composite_dev
> *cdev,
>  	unsigned		power = gadget_is_otg(gadget) ? 8 : 100;
>  	int			tmp;
>
> -	if (cdev->config)
> -		reset_config(cdev);
> -
>  	if (number) {
>  		list_for_each_entry(c, &cdev->configs, list) {
>  			if (c->bConfigurationValue == number) {
> +				/* Need to disable the FDs of the previous
> +				   configuration */
> +				if (cdev->config)
> +					reset_config(cdev);
>  				result = 0;
>  				break;
>  			}
>  		}
>  		if (result < 0)
>  			goto done;
> -	} else
> +	} else { /* Zero configuration value - need to reset the config */
> +		if (cdev->config)
> +			reset_config(cdev);
>  		result = 0;
> +	}
>
>  	INFO(cdev, "%s speed config #%d: %s\n",
>  		({ char *speed;
>  		switch (gadget->speed) {
> -		case USB_SPEED_LOW:	speed = "low"; break;
> -		case USB_SPEED_FULL:	speed = "full"; break;
> -		case USB_SPEED_HIGH:	speed = "high"; break;
> +		case USB_SPEED_LOW:
> +			speed = "low";
> +			break;
> +		case USB_SPEED_FULL:
> +			speed = "full";
> +			break;
> +		case USB_SPEED_HIGH:
> +			speed = "high";
> +			break;
> +		case USB_SPEED_SUPER:
> +			speed = "super";
> +			break;
>  		default:		speed = "?"; break;
>  		} ; speed; }), number, c ? c->label : "unconfigured");
>
> @@ -509,7 +707,9 @@ static int set_config(struct usb_composite_dev *cdev,
>  		 * function's setup callback instead of the current
>  		 * configuration's setup callback.
>  		 */
> -		if (gadget->speed == USB_SPEED_HIGH)
> +		if (gadget->speed == USB_SPEED_SUPER)
> +			descriptors = f->ss_descriptors;
> +		else if (gadget->speed == USB_SPEED_HIGH)
>  			descriptors = f->hs_descriptors;
>  		else
>  			descriptors = f->descriptors;
> @@ -592,14 +792,14 @@ int usb_add_config(struct usb_composite_dev *cdev,
>  	} else {
>  		unsigned	i;
>
> -		DBG(cdev, "cfg %d/%p speeds:%s%s\n",
> +		DBG(cdev, "cfg %d/%p speeds:%s%s%s\n",
>  			config->bConfigurationValue, config,
> +			config->superspeed ? " super" : "",
>  			config->highspeed ? " high" : "",
>  			config->fullspeed
>  				? (gadget_is_dualspeed(cdev->gadget)
>  					? " full"
> -					: " full/low")
> -				: "");
> +					: " full/low") : "");
>
>  		for (i = 0; i < MAX_CONFIG_INTERFACES; i++) {
>  			struct usb_function	*f = config->interface[i];
> @@ -851,6 +1051,7 @@ composite_setup(struct usb_gadget *gadget, const
> struct usb_ctrlrequest *ctrl)
>  	struct usb_composite_dev	*cdev = get_gadget_data(gadget);
>  	struct usb_request		*req = cdev->req;
>  	int				value = -EOPNOTSUPP;
> +	int				status = 0;
>  	u16				w_index = le16_to_cpu(ctrl->wIndex);
>  	u8				intf = w_index & 0xFF;
>  	u16				w_value = le16_to_cpu(ctrl->wValue);
> @@ -878,18 +1079,30 @@ composite_setup(struct usb_gadget *gadget, const
> struct usb_ctrlrequest *ctrl)
>  		case USB_DT_DEVICE:
>  			cdev->desc.bNumConfigurations =
>  				count_configs(cdev, USB_DT_DEVICE);
> +			cdev->desc.bMaxPacketSize0 =
> +				cdev->gadget->ep0->maxpacket;
> +			if (gadget->speed >= USB_SPEED_SUPER)
> +				cdev->desc.bcdUSB = cpu_to_le16(0x0300);
> +			else if ((gadget_is_superspeed(gadget)) &&
> +				 (gadget->speed <= USB_SPEED_HIGH))
> +				cdev->desc.bcdUSB = cpu_to_le16(0x0210);
> +
>  			value = min(w_length, (u16) sizeof cdev->desc);
>  			memcpy(req->buf, &cdev->desc, value);
>  			break;
> +
>  		case USB_DT_DEVICE_QUALIFIER:
> -			if (!gadget_is_dualspeed(gadget))
> +			if (!gadget_is_dualspeed(gadget) ||
> +			    gadget->speed >= USB_SPEED_SUPER)
>  				break;
> +
>  			device_qual(cdev);
>  			value = min_t(int, w_length,
>  				sizeof(struct usb_qualifier_descriptor));
>  			break;
>  		case USB_DT_OTHER_SPEED_CONFIG:
> -			if (!gadget_is_dualspeed(gadget))
> +			if (!gadget_is_dualspeed(gadget) ||
> +			    gadget->speed >= USB_SPEED_SUPER)
>  				break;
>  			/* FALLTHROUGH */
>  		case USB_DT_CONFIG:
> @@ -903,6 +1116,12 @@ composite_setup(struct usb_gadget *gadget, const
> struct usb_ctrlrequest *ctrl)
>  			if (value >= 0)
>  				value = min(w_length, (u16) value);
>  			break;
> +		case USB_DT_BOS:
> +			if (gadget_is_superspeed(gadget)) {
> +				value = bos(cdev);
> +				value = min(w_length, (u16) value);
> +			}
> +			break;
>  		}
>  		break;
>
> @@ -962,6 +1181,55 @@ composite_setup(struct usb_gadget *gadget, const
> struct usb_ctrlrequest *ctrl)
>  		*((u8 *)req->buf) = value;
>  		value = min(w_length, (u16) 1);
>  		break;
> +
> +		/*USB 3.0 additions*/
> +	/* Function driver should handle get_status request. If such cb
> +	  wasn't supplied we respond with default value = 0
> +	  Note: FD should supply such cb only for the first interface
> +	  of the function*/
> +	case USB_REQ_GET_STATUS:
> +		if (!gadget_is_superspeed(gadget))
> +			goto unknown;
> +		if (ctrl->bRequestType != (USB_DIR_IN | USB_RECIP_INTERFACE))
> +			goto unknown;
> +		value = 2;	/*This is the length of the get_status reply*/
> +		*((u16 *)req->buf) = 0;
> +		if (!cdev->config || w_index >= MAX_CONFIG_INTERFACES)
> +			break;
> +		f = cdev->config->interface[intf];
> +		if (!f)
> +			break;
> +		status = f->get_status ? f->get_status(f) : 0;
> +		if (status < 0)
> +			break;
> +		*((u16 *)req->buf) = status & 0x0000ffff;
> +		break;
> +	/*Function drivers should handle SetFeature(FUNCTION_SUSPEND) request.
> +	  function_suspend cb should be supplied only for the first interface
> +	  of the function*/
> +	case USB_REQ_SET_FEATURE:
> +		if (!gadget_is_superspeed(gadget))
> +			goto unknown;
> +		if (ctrl->bRequestType != (USB_DIR_IN | USB_RECIP_INTERFACE))
> +			goto unknown;
> +		switch (w_value) {
> +		case USB_INTRF_FUNC_SUSPEND:
> +			if (!cdev->config || w_index >= MAX_CONFIG_INTERFACES)
> +				break;
> +			f = cdev->config->interface[intf];
> +			if (!f)
> +				break;
> +			value = f->func_suspend ? f->func_suspend(f) : 0;
> +			if (value < 0) {
> +				ERROR(cdev, "func_suspend() returned "
> +					    "error %d\n", value);
> +				value = 0;
> +			}
> +			break;
> +		default:
> +			break;
> +		}
> +		break;
>  	default:
>  unknown:
>  		VDBG(cdev,
> @@ -1080,8 +1348,11 @@ composite_unbind(struct usb_gadget *gadget)
>  				DBG(cdev, "unbind function '%s'/%p\n",
>  						f->name, f);
>  				f->unbind(c, f);
> -				/* may free memory for "f" */
>  			}
> +			/*Free memory allocated for ss descriptors*/
> +			if (f->ss_desc_allocated && f->ss_descriptors)
> +				usb_free_descriptors(f->ss_descriptors);
> +			/* may free memory for "f" */
>  		}
>  		list_del(&c->list);
>  		if (c->unbind) {
> @@ -1254,7 +1525,6 @@ composite_resume(struct usb_gadget *gadget)
>
>  static struct usb_gadget_driver composite_driver = {
>  	.speed		= USB_SPEED_HIGH,
> -
>  	.bind		= composite_bind,
>  	.unbind		= composite_unbind,
>
> @@ -1293,6 +1563,9 @@ int usb_composite_register(struct
> usb_composite_driver *driver)
>  		driver->name = "composite";
>  	composite_driver.function =  (char *) driver->name;
>  	composite_driver.driver.name = driver->name;
> +#ifdef CONFIG_USB_GADGET_SUPERSPEED
> +	composite_driver.speed = USB_SPEED_SUPER;
> +#endif /*CONFIG_USB_GADGET_SUPERSPEED*/
>  	composite = driver;
>
>  	return usb_gadget_register_driver(&composite_driver);
> diff --git a/include/linux/usb/ch9.h b/include/linux/usb/ch9.h
> index da2ed77..69e528a 100644
> --- a/include/linux/usb/ch9.h
> +++ b/include/linux/usb/ch9.h
> @@ -125,6 +125,20 @@
>
>  #define USB_ENDPOINT_HALT		0	/* IN/OUT will STALL */
>
> +/**
> + * New Feature Selectors as added by USB 3.0
> + * See USB 3.0 spec Table 9-6
> + */
> +#define USB_DEVICE_U1_ENABLE		48	/*enables the upstream port to
> +						initiate requests for transition
> +						into U1 state*/
> +#define USB_DEVICE_U2_ENABLE		49	/*enables the upstream port to
> +						initiate requests for transition
> +						into U2 state*/
> +#define USB_DEVICE_LTM_ENABLE		50	/*enables the devise to send
> +						Latency tolerance messages.*/
> +#define USB_INTRF_FUNC_SUSPEND		0	/*function suspend*/
> +
>
>  /**
>   * struct usb_ctrlrequest - SETUP data for a USB device control request
> @@ -675,6 +689,7 @@ struct usb_bos_descriptor {
>  	__u8  bNumDeviceCaps;
>  } __attribute__((packed));
>
> +#define USB_DT_BOS_SIZE		5
>  /*-------------------------------------------------------------------------*/
>
>  /* USB_DT_DEVICE_CAPABILITY:  grouped with BOS */
> @@ -712,16 +727,51 @@ struct usb_wireless_cap_descriptor {	/* Ultra Wide
> Band */
>  	__u8  bReserved;
>  } __attribute__((packed));
>
> +/*USB 2.0 Extension descriptor*/
>  #define	USB_CAP_TYPE_EXT		2
> -
>  struct usb_ext_cap_descriptor {		/* Link Power Management */
>  	__u8  bLength;
>  	__u8  bDescriptorType;
>  	__u8  bDevCapabilityType;
> -	__u8  bmAttributes;
> +	__u32 bmAttributes;
>  #define USB_LPM_SUPPORT			(1 << 1)	/* supports LPM */
>  } __attribute__((packed));
>
> +#define USB_DT_USB_EXT_CAP_SIZE	7
> +
> +/*SuperSpeed USB Capability descriptor: Defines the set of SuperSpeed USB
> +  specific device level capabilities*/
> +#define	SS_USB_CAP_TYPE		3
> +struct ss_usb_cap_descriptor {		/* Link Power Management */
> +	__u8  bLength;
> +	__u8  bDescriptorType;
> +	__u8  bDevCapabilityType;
> +	__u8  bmAttributes;
> +#define USB_LTM_SUPPORT			(1 << 1) /* supports LTM */
> +	__u16 wSpeedSupported;
> +#define USB_LOW_SPEED_OPERATION		(1)	 /* Low speed operation */
> +#define USB_FULL_SPEED_OPERATION	(1 << 1) /* Full speed operation */
> +#define USB_HIGH_SPEED_OPERATION	(1 << 2) /* High speed operation */
> +#define USB_5GBPS_OPERATION		(1 << 3) /* Operation at 5Gbps */
> +	__u8  bFunctionalitySupport;
> +	__u8  bU1devExitLat;
> +	__u16 bU2DevExitLat;
> +} __attribute__((packed));
> +
> +#define USB_DT_SS_USB_CAP_SIZE	10
> +
> +/*Container ID Capability descriptor: Defines the instance unique ID used
> to
> +  identify the instance across all operating modes*/
> +#define	CONTAINER_ID_TYPE	4
> +struct ss_usb_container_id_descriptor {
> +	__u8  bLength;
> +	__u8  bDescriptorType;
> +	__u8  bDevCapabilityType;
> +	__u8  bReserved;
> +	__u8  ContainerID[16]; /*128-bit number*/
> +} __attribute__((packed));
> +
> +#define USB_DT_SS_CONTN_ID_SIZE	20
>  /*-------------------------------------------------------------------------*/
>
>  /* USB_DT_WIRELESS_ENDPOINT_COMP:  companion descriptor associated with
> diff --git a/include/linux/usb/composite.h b/include/linux/usb/composite.h
> index c623bed..36ab1d0 100644
> --- a/include/linux/usb/composite.h
> +++ b/include/linux/usb/composite.h
> @@ -52,6 +52,18 @@ struct usb_configuration;
>   * @hs_descriptors: Table of high speed descriptors, using interface and
>   *	string identifiers assigned during @bind().  If this pointer is null,
>   *	the function will not be available at high speed.
> + * @ss_descriptors: Table of super speed descriptors. If
> + *	wasnt supplied by the FD during @bind() and
> + *	!ss_not_capble, will be generated automaticly with
> + *	default values while working in superspeed mode. If this
> + *	pointer is null after initiation, the function will not
> + *	be available at super speed.
> + * @ss_not_capable: This flag is used by the FD to indicate if
> + *	this function is SS capble. Meaning: if SS descriptors
> + *	weren't supplied by the FD, and the flag is set ss
> + *	descriptors will NOT be automatically generated
> + * @ss_desc_allocated: This flag indicates whether the ss descriptors
> were
> + *	dynamically allocated (and needs to be released).
>   * @config: assigned when @usb_add_function() is called; this is the
>   *	configuration with which this function is associated.
>   * @bind: Before the gadget can register, all of its functions bind() to
> the
> @@ -70,6 +82,10 @@ struct usb_configuration;
>   * @setup: Used for interface-specific control requests.
>   * @suspend: Notifies functions when the host stops sending USB traffic.
>   * @resume: Notifies functions when the host restarts USB traffic.
> + * @get_status: Returns function status as a reply to
> + *	GetStatus() request when the recepient is Interface.
> + * @func_suspend: callback to be called when
> + *	SetFeature(FUNCTION_SUSPEND) is reseived
>   *
>   * A single USB function uses one or more interfaces, and should in most
>   * cases support operation at both full and high speeds.  Each function
> is
> @@ -99,6 +115,10 @@ struct usb_function {
>  	struct usb_gadget_strings	**strings;
>  	struct usb_descriptor_header	**descriptors;
>  	struct usb_descriptor_header	**hs_descriptors;
> +	struct usb_descriptor_header	**ss_descriptors;
> +
> +	unsigned			ss_desc_allocated:1;
> +	unsigned			ss_not_capable:1;
>
>  	struct usb_configuration	*config;
>
> @@ -125,6 +145,9 @@ struct usb_function {
>  	void			(*suspend)(struct usb_function *);
>  	void			(*resume)(struct usb_function *);
>
> +	/* USB 3.0 additions */
> +	int			(*get_status)(struct usb_function *);
> +	int			(*func_suspend)(struct usb_function *);
>  	/* private: */
>  	/* internals */
>  	struct list_head		list;
> @@ -229,6 +252,7 @@ struct usb_configuration {
>  	struct list_head	list;
>  	struct list_head	functions;
>  	u8			next_interface_id;
> +	unsigned		superspeed:1;
>  	unsigned		highspeed:1;
>  	unsigned		fullspeed:1;
>  	struct usb_function	*interface[MAX_CONFIG_INTERFACES];
> diff --git a/include/linux/usb/gadget.h b/include/linux/usb/gadget.h
> index bf7dc0b..40329b0 100644
> --- a/include/linux/usb/gadget.h
> +++ b/include/linux/usb/gadget.h
> @@ -139,6 +139,8 @@ struct usb_ep_ops {
>   * @desc:endpoint descriptor.  this pointer set before endpoint is
> enabled and
>   *	remains valid until the endpoint is disabled; the data byte order
>   *	is little-endian (usb-standard).
> + * @comp_desc: In case of SuperSpeed support, this is the
> + *	endpoint companion descriptor that is used to configure the endpoint
>   *
>   * the bus controller driver lists all the general purpose endpoints in
>   * gadget->ep_list.  the control endpoint (gadget->ep0) is not in that
> list,
> @@ -153,6 +155,7 @@ struct usb_ep {
>  	unsigned			maxpacket:16;
>  	u8				bEndpointAddress;
>  	struct usb_endpoint_descriptor	*desc;
> +	struct usb_ss_ep_comp_descriptor	*comp_desc;
>  };
>
>  /*-------------------------------------------------------------------------*/
> @@ -525,6 +528,22 @@ static inline int gadget_is_dualspeed(struct
> usb_gadget *g)
>  }
>
>  /**
> + * gadget_is_superspeed - return true if the hardware handles
> + * supperspeed
> + */
> +static inline int gadget_is_superspeed(struct usb_gadget *g)
> +{
> +#ifdef CONFIG_USB_GADGET_SUPERSPEED
> +	/* runtime test would check "g->is_superspeed" ... that might be
> +	 * useful to work around hardware bugs, but is mostly pointless
> +	 */
> +	return 1;
> +#else
> +	return 0;
> +#endif
> +}
> +
> +/**
>   * gadget_is_otg - return true iff the hardware is OTG-ready
>   * @g: controller that might have a Mini-AB connector
>   *
> --
> 1.6.3.3
>
> --
> Sent by an  consultant of the Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
>
>


