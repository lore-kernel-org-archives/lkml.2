Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412Ab1C1IpN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 04:45:13 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:46904 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746Ab1C1IpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 04:45:11 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6298"; a="82209773"
From: "Tanya Brokhman" <tlinder@codeaurora.org>
To: <balbi@ti.com>
Cc: <gregkh@suse.de>, <linux-arm-msm@vger.kernel.org>, <ablay@codeaurora.org>,
        "'open list:USB GADGET/PERIPH...'" <linux-usb@vger.kernel.org>,
        "'open list'" <linux-kernel@vger.kernel.org>
References: <1300867498-20997-1-git-send-email-tlinder@codeaurora.org> <20110325134101.GM2609@legolas.emea.dhcp.ti.com>
In-Reply-To: <20110325134101.GM2609@legolas.emea.dhcp.ti.com>
Subject: RE: [PATCH 5/5 v5] usb:gadget: Add SuperSpeed support to the Gadget Framework
Date: Mon, 28 Mar 2011 10:45:54 +0200
Message-ID: <000501cbed24$8efd1f70$acf75e50$@org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Acvq8kMpo1JpmrQQQp6O9nVNJquWPACL+uwg
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> 
> On Wed, Mar 23, 2011 at 10:04:57AM +0200, Tatyana Brokhman wrote:
> > This patch adds the SuperSpeed functionality to the gadget framework.
> > In order not to force all the gadget drivers to supply SuperSpeed
> > descriptors when operating in SuperSpeed mode the following approach
> was
> > taken:
> > If we're operating in SuperSpeed mode and the gadget driver didn't
> supply
> > SuperSpeed descriptors, the composite layer will automatically create
> > SuperSpeed descriptors with default values.
> > Support for new SuperSpeed BOS descriptor was added.
> > Support for SET_FEATURE and GET_STATUS requests in SuperSpeed mode
> was
> > added.
> 
> IMHO, this patch tries to do too much in one huge patch. It needs major
> splitting.
> 
> Also, I don't get why you decided to go the path of letting composite.c
> generate the super speed descriptors instead of expecting gadget
> drivers
> to pass those should they support super speed.
> 
> I would like the other way much better: first, it's what we already do
> for full/low speed and high speed. Second, we can easily see the
> descriptors by opening the gadget driver's code.
> 

Our goal was to provide a generic solution that will enable existing gadget
drivers to operate in SS mode with minimum changes to their code. If a
certain gadget driver wishes to operate in SS mode and the values in the
descriptors are important to it, this FD should define its own SS
descriptors as already done for HS/LS and those (SS) descriptors will be
chosen. 
Please note that a gadget driver can also choose not to have SS descriptors
generated for it all, even if it didn't provide any of its own and thus
choosing not to operate in SS mode.
If you look at our implementation of the UAS gadget driver you'll see that
we define the SS descriptors just as is done for HS/LS and those descriptors
are chosen in enumeration.
I believe that in the future all gadget drivers will define their own SS
descriptors with values that are suitable for that gadget driver and the
create_ss_descriptors() will become obsolete. As I've already mentioned this
is just a way to allow all the existing drivers to operate in SS mode with
minimum changes to their code. So this patch doesn't contradict your
approach, just extends it. 

I hope the above addressed your other questions on the design bellow. Please
let me know if this is not the case.

> There are a few more comments below, but this patch needs major, major
> splitting.

I'll address your comments and split it up in the next version. I would like
to give Greg and others a chance to comment as well before uploading another
version.

Best regards,
Tanya Brokhman
Consultant for Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum




> 
> > Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>
> 
> missing the tear line --- here
> 
> > diff --git a/drivers/usb/gadget/composite.c
> b/drivers/usb/gadget/composite.c
> > index fb7e488..d5fe1c2 100644
> > --- a/drivers/usb/gadget/composite.c
> > +++ b/drivers/usb/gadget/composite.c
> > @@ -73,6 +73,123 @@ MODULE_PARM_DESC(iSerialNumber, "SerialNumber
> string");
> >
> >  static char composite_manufacturer[50];
> >
> > +/* Default endpoint companion descriptor */
> > +static struct usb_ss_ep_comp_descriptor default_ep_comp_desc = {
> > +		.bDescriptorType = USB_DT_SS_ENDPOINT_COMP,
> > +		.bLength = 0x06,
> 
> there's a define for this:
> 
> #define USB_DT_SS_EP_COMP_SIZE		6
> 
> > +/**
> > + * create_ss_descriptors() - Generate SuperSpeed descriptors
> > + * with default values
> > + * @f: pointer to usb_function to generate the descriptors for
> > + *
> > + * This function receives a pointer to usb_function and adds
> > + * missing super speed descriptors in the ss_descriptor field
> > + * according to its hs_descriptors field.
> > + *
> > + * This function copies f->hs_descriptors while updating the
> > + * endpoint descriptor and adding endpoint companion descriptor.
> > + */
> > +static void create_ss_descriptors(struct usb_function *f)
> > +{
> > +	unsigned bytes;		/* number of bytes to allocate */
> > +	unsigned n_desc;	/* number of descriptors */
> > +	void *mem;		/* allocated memory to copy to */
> > +	struct usb_descriptor_header **tmp;
> > +	struct usb_endpoint_descriptor	*ep_desc ;
> > +	struct usb_ss_ep_comp_descriptor *ep_comp_desc;
> > +	struct usb_descriptor_header **src = f->hs_descriptors;
> > +
> > +	if (!f->hs_descriptors)
> > +		return;
> > +
> > +	/*
> > +	 * Count number of EPs (in order to know how many SS_EP_COMPANION
> > +	 * descriptors to add), the total number of descriptors and the
> sum of
> > +	 * each descriptor bLength field in order to know how much memory
> to
> > +	 * allocate.
> > +	 */
> > +	for (bytes = 0, n_desc = 0, tmp = src; *tmp; tmp++, n_desc++) {
> > +		if ((*tmp)->bDescriptorType == USB_DT_ENDPOINT) {
> > +			bytes += default_ep_comp_desc.bLength;
> > +			n_desc++;
> > +		}
> > +		bytes += (*tmp)->bLength;
> > +	}
> > +
> > +	bytes += (n_desc + 1) * sizeof(*tmp);
> > +	mem = kmalloc(bytes, GFP_KERNEL);
> > +	if (!mem)
> > +		return;
> > +
> > +	/*
> > +	 * Fill in pointers starting at "tmp", to descriptors copied
> starting
> > +	 * at "mem" and return "ret"
> > +	 */
> > +	tmp = mem;
> > +	f->ss_descriptors  = mem;
> > +	mem += (n_desc + 1) * sizeof(*tmp);
> > +	while (*src) {
> > +		/* Copy the original descriptor */
> > +		memcpy(mem, *src, (*src)->bLength);
> > +		switch ((*src)->bDescriptorType) {
> > +		case USB_DT_ENDPOINT:
> > +			/* update ep descriptor */
> > +			ep_desc = (struct usb_endpoint_descriptor *)mem;
> > +			switch (ep_desc->bmAttributes &
> > +				USB_ENDPOINT_XFERTYPE_MASK) {
> > +			case USB_ENDPOINT_XFER_CONTROL:
> > +				ep_desc->wMaxPacketSize = cpu_to_le16(512);
> > +				ep_desc->bInterval = 0;
> > +				break;
> > +			case USB_ENDPOINT_XFER_BULK:
> > +				ep_desc->wMaxPacketSize = cpu_to_le16(1024);
> > +				ep_desc->bInterval = 0;
> > +				break;
> > +			case USB_ENDPOINT_XFER_INT:
> > +			case USB_ENDPOINT_XFER_ISOC:
> > +				break;
> > +			}
> > +			*tmp = mem;
> > +			tmp++;
> > +			mem += (*src)->bLength;
> > +			/* add ep companion descriptor */
> > +			memcpy(mem, &default_ep_comp_desc,
> > +			       default_ep_comp_desc.bLength);
> > +			*tmp = mem;
> > +			tmp++;
> > +			/* Update wBytesPerInterval for periodic endpoints
*/
> > +			ep_comp_desc = (struct usb_ss_ep_comp_descriptor
> *)mem;
> > +			switch (ep_desc->bmAttributes &
> > +				USB_ENDPOINT_XFERTYPE_MASK) {
> > +			case USB_ENDPOINT_XFER_INT:
> > +			case USB_ENDPOINT_XFER_ISOC:
> > +				ep_comp_desc->wBytesPerInterval =
> > +					ep_desc->wMaxPacketSize;
> > +				break;
> > +			}
> > +			mem += default_ep_comp_desc.bLength;
> > +			break;
> > +		default:
> > +			*tmp = mem;
> > +			tmp++;
> > +			mem += (*src)->bLength;
> > +			break;
> > +		}
> > +		src++;
> > +	}
> > +	/*
> > +	 * The last (struct usb_descriptor_header *) in the descriptors
> > +	 * vector is NULL
> > +	 */
> > +	*tmp = NULL;
> > +	f->ss_desc_allocated = true;
> > +}
> 
> I would rather expect gadget drivers to provide their own descriptors
> just like we do for full/low speed and high speed descriptors. Why you
> decided to take this approach ?
> 
> > +
> >  /*------------------------------------------------------------------
> -------*/
> >  /**
> >   * next_ep_desc() - advance to the next EP descriptor
> > @@ -118,6 +235,9 @@ int config_ep_by_speed(struct usb_gadget *g,
> >  	struct usb_endpoint_descriptor *chosen_desc = NULL;
> >  	struct usb_descriptor_header **speed_desc = NULL;
> >
> > +	struct usb_ss_ep_comp_descriptor *comp_desc = NULL;
> > +	int want_comp_desc = 0;
> > +
> >  	struct usb_descriptor_header **d_spd; /* cursor for speed desc */
> >
> >  	if (!g || !f || !_ep)
> > @@ -125,6 +245,13 @@ int config_ep_by_speed(struct usb_gadget *g,
> >
> >  	/* select desired speed */
> >  	switch (g->speed) {
> > +	case USB_SPEED_SUPER:
> > +		if (gadget_is_superspeed(g)) {
> > +			speed_desc = f->ss_descriptors;
> > +			want_comp_desc = 1;
> > +			break;
> > +		}
> 
> same here, I would expect gadget drivers to be changed providing the
> correct descriptors. Just like I did when I sent my version.
> 
> In my opinion, it would be easier that way. We could see the
> descriptors
> just by opening the gadget driver code. Besides, different gadget
> drivers might want different "sane defaults".
> 
> >  	INFO(cdev, "%s speed config #%d: %s\n",
> >  		({ char *speed;
> >  		switch (gadget->speed) {
> > -		case USB_SPEED_LOW:	speed = "low"; break;
> > -		case USB_SPEED_FULL:	speed = "full"; break;
> > -		case USB_SPEED_HIGH:	speed = "high"; break;
> > +		case USB_SPEED_LOW:
> > +			speed = "low";
> > +			break;
> > +		case USB_SPEED_FULL:
> > +			speed = "full";
> > +			break;
> > +		case USB_SPEED_HIGH:
> > +			speed = "high";
> > +			break;
> > +		case USB_SPEED_SUPER:
> > +			speed = "super";
> > +			break;
> >  		default:		speed = "?"; break;
> >  		} ; speed; }), number, c ? c->label : "unconfigured");
> 
> this part isn't part of this patch.
> 
> --
> balbi

