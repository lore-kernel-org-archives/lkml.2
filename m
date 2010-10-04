Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196Ab0JDH0H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 03:26:07 -0400
Received: from mga11.intel.com ([192.55.52.93]:46760 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753012Ab0JDH0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 03:26:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,277,1283756400"; 
   d="scan'208";a="613008612"
Date: Mon, 4 Oct 2010 03:26:02 -0400
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: tlinder <tlinder@codeaurora.org>
Cc: linux-usb@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Michal Nazarewicz <m.nazarewicz@samsung.com>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Robert Lukassen <robert.lukassen@tomtom.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        Fabien Chouteau <fabien.chouteau@barco.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH 2/2] usb:gadget: Add SuperSpeed support to the
 Gadget Framework
Message-ID: <20101004072602.GB2256@xanatos>
References: <1286092937-29191-1-git-send-email-tlinder@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286092937-29191-1-git-send-email-tlinder@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tatyana,

Comments inline.  I'm not familiar with the gadget framework; I'm just
curious about some descriptor choices.

On Sun, Oct 03, 2010 at 10:02:15AM +0200, tlinder wrote:
> diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
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

Can you please set wBytesPerInterval to something sane for periodic
endpoints?  Perhaps have it set to the maximum packet size times the max
burst size times Mult plus one, or less if the device *knows* it's going
to send less data.  It's used for xHC host controller scheduling, so
it's important to get right for maximum bandwidth usage.

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

Why are you not setting wMaxPacketSize for periodic endpoints?  Does it
get set later?  (I can't tell from this snippet.)

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

...

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

So this gadget will be able to support all speeds?

> +	ss_cap->bFunctionalitySupport = USB_LOW_SPEED_OPERATION;
> +	ss_cap->bU1devExitLat = 0;
> +	ss_cap->bU2DevExitLat = 0;

Are you really sure you want to set the exit latency for low power
states to less than 1 microsecond?  Without real hardware it would be
difficult to test, but this seems overly optimistic.


> diff --git a/include/linux/usb/ch9.h b/include/linux/usb/ch9.h
> index da2ed77..69e528a 100644
> --- a/include/linux/usb/ch9.h
> +++ b/include/linux/usb/ch9.h

...

> +/*Container ID Capability descriptor: Defines the instance unique ID used to
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

I don't see generation of a container ID in the code.  Are you going to
implement it?  It's only required for USB 3.0 hubs, and I'm not sure if
the gadget framework supports hubs.  Nothing else in your code seems to
use this definition.

Sarah
