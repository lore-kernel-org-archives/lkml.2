Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193Ab0JDOVt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 10:21:49 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55813 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756146Ab0JDOVs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 10:21:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=f2Mc9m26wdnp76ibHX7kN3vTbxVIxYiLkfUToptzDa25O+5Smq+pj0tvH1Y8aO7l9i
         o+wxkMaxUTK9JPnp9BBXQHfKiZjH50qCjfnKtqtIHErdOypnRaIZjMGoDD4OdgnOAhik
         RGbw9Y4Y+do3PWwmlX5woELHnGWpyV3yoCRTA=
MIME-Version: 1.0
In-Reply-To: <1286092937-29191-1-git-send-email-tlinder@codeaurora.org>
References: <1286092937-29191-1-git-send-email-tlinder@codeaurora.org>
Date: Mon, 4 Oct 2010 19:51:46 +0530
Message-ID: <AANLkTik=VGiM4GthVpfkb07F+o+W0o3yhctH+56jzTvM@mail.gmail.com>
Subject: Re: [RFC/PATCH 2/2] usb:gadget: Add SuperSpeed support to the Gadget Framework
From: Maulik Mankad <mankad.maulik@gmail.com>
To: tlinder <tlinder@codeaurora.org>
Cc: linux-usb@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Michal Nazarewicz <m.nazarewicz@samsung.com>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Robert Lukassen <robert.lukassen@tomtom.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        Fabien Chouteau <fabien.chouteau@barco.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Oct 3, 2010 at 1:32 PM, tlinder <tlinder@codeaurora.org> wrote:
>
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

Some comments on coding guidelines below.

> ---
> This patch was verified by USBCV 3.0 and 2.0.
>
>  drivers/usb/gadget/Kconfig     |   20 ++-
>  drivers/usb/gadget/composite.c |  319 +++++++++++++++++++++++++++++++++++++---
>  include/linux/usb/ch9.h        |   54 +++++++-
>  include/linux/usb/composite.h  |   24 +++
>  include/linux/usb/gadget.h     |   19 +++
>  5 files changed, 407 insertions(+), 29 deletions(-)
>
> diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
> index cd27f9b..9afdd08 100644
> --- a/drivers/usb/gadget/Kconfig
> +++ b/drivers/usb/gadget/Kconfig
> @@ -520,11 +520,11 @@ config USB_GADGET_DUMMY_HCD
>          side is the master; the gadget side is the slave.  Gadget drivers
>          can be high, full, or low speed; and they have access to endpoints
>          like those from NET2280, PXA2xx, or SA1100 hardware.
> -
> +
>          This may help in some stages of creating a driver to embed in a
>          Linux device, since it lets you debug several parts of the gadget
>          driver without its hardware or drivers being involved.
> -
> +
>          Since such a gadget side driver needs to interoperate with a host
>          side Linux-USB device driver, this may help to debug both sides
>          of a USB protocol stack.
> @@ -552,6 +552,18 @@ config USB_GADGET_DUALSPEED
>          Means that gadget drivers should include extra descriptors
>          and code to handle dual-speed controllers.
>
> +config USB_GADGET_SUPERSPEED
> +       boolean "Gadget opperating in Super Speed"

spelling "operating"

> +       depends on USB_GADGET
> +       depends on USB_GADGET_DUALSPEED
> +       default n
> +       help
> +         Enabling this feature enables Super Speed support in the Gadget
> +         driver. It means that gadget drivers should include extra (SuperSpeed)
> +         descriptors.
> +         For composite devices: if SupeSpeed descriptors weren't supplied by

spelling "Superspeed"

> +         the FD, they will be automatically generated with default values.
> +
>  #
>  # USB Gadget Drivers
>  #
> @@ -633,7 +645,7 @@ config USB_ETH
>        help
>          This driver implements Ethernet style communication, in one of
>          several ways:
> -
> +
>           - The "Communication Device Class" (CDC) Ethernet Control Model.
>             That protocol is often avoided with pure Ethernet adapters, in
>             favor of simpler vendor-specific hardware, but is widely
> @@ -673,7 +685,7 @@ config USB_ETH_RNDIS
>           If you say "y" here, the Ethernet gadget driver will try to provide
>           a second device configuration, supporting RNDIS to talk to such
>           Microsoft USB hosts.
> -
> +
>           To make MS-Windows work with this, use Documentation/usb/linux.inf
>           as the "driver info file".  For versions of MS-Windows older than
>           XP, you'll need to download drivers from Microsoft's website; a URL
> diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
> index c619c80..a5dcfe1 100644
> --- a/drivers/usb/gadget/composite.c
> +++ b/drivers/usb/gadget/composite.c
> @@ -70,6 +70,102 @@ static char *iSerialNumber;
>  module_param(iSerialNumber, charp, 0);
>  MODULE_PARM_DESC(iSerialNumber, "SerialNumber string");
>
> +/** Default endpoint companion descriptor */
> +static struct usb_ss_ep_comp_descriptor ep_comp_desc = {
> +               .bDescriptorType = USB_DT_SS_ENDPOINT_COMP,
> +               .bLength = 0x06,
> +               .bMaxBurst = 0, /*the default is we don't support bursting*/

Commenting style not proper. It should be like "/* Leave a space as shown */"

> +               .bmAttributes = 0, /*2^0 streams supported*/
> +               .wBytesPerInterval = 0,
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
> +       unsigned bytes; /*number of bytes to allocate*/
> +       unsigned n_desc;    /* number of descriptors*/
> +       void *mem; /*allocated memory to copy to*/
> +       struct usb_descriptor_header **tmp;
> +       struct usb_endpoint_descriptor  *ep_desc ;
> +       struct usb_descriptor_header **src = f->hs_descriptors;
> +
> +       if (!f->hs_descriptors)
> +               return;
> +
> +       /* Count number of EPs (in order to know how many SS_EP_COMPANION
> +          descriptors to add), the total number of descriptors and the sum of
> +          each descriptor bLength field in order to know how much memory to
> +          allocate*/

Multi line comment style as per coding guidelines is as below.

/*
 * First line
 * Second line
 * Third line
 */


> +       for (bytes = 0, n_desc = 0, tmp = src; *tmp; tmp++, n_desc++) {
> +               if ((*tmp)->bDescriptorType == USB_DT_ENDPOINT) {
> +                       bytes += ep_comp_desc.bLength;
> +                       n_desc++;
> +               }
> +               bytes += (*tmp)->bLength;
> +       }
> +
> +       bytes += (n_desc + 1) * sizeof(*tmp);
> +       mem = kmalloc(bytes, GFP_KERNEL);
> +       if (!mem)
> +               return;
> +
> +       /* fill in pointers starting at "tmp",
> +        * to descriptors copied starting at "mem";
> +        * and return "ret"
> +        */

Same here.

> +       tmp = mem;
> +       f->ss_descriptors  = mem;
> +       mem += (n_desc + 1) * sizeof(*tmp);
> +       while (*src) {
> +               /*Copy the original descriptor*/
> +               memcpy(mem, *src, (*src)->bLength);
> +               switch ((*src)->bDescriptorType) {
> +               case USB_DT_ENDPOINT:
> +                       /*update ep descriptor*/
> +                       ep_desc = (struct usb_endpoint_descriptor *)mem;
> +                       switch (ep_desc->bmAttributes &
> +                               USB_ENDPOINT_XFERTYPE_MASK) {
> +                       case USB_ENDPOINT_XFER_CONTROL:
> +                               ep_desc->wMaxPacketSize = 512;
> +                               ep_desc->bInterval = 0;
> +                               break;
> +                       case USB_ENDPOINT_XFER_BULK:
> +                               ep_desc->wMaxPacketSize = 1024;
> +                               ep_desc->bInterval = 0;
> +                               break;
> +                       case USB_ENDPOINT_XFER_INT:
> +                       case USB_ENDPOINT_XFER_ISOC:
> +                               break;
> +                       }
> +                       *tmp = mem;
> +                       tmp++;
> +                       mem += (*src)->bLength;
> +                       /*add ep companion descriptor*/
> +                       memcpy(mem, &ep_comp_desc, ep_comp_desc.bLength);
> +                       *tmp = mem;
> +                       tmp++;
> +                       mem += ep_comp_desc.bLength;
> +                       break;
> +               default:
> +                       *tmp = mem;
> +                       tmp++;
> +                       mem += (*src)->bLength;
> +                       break;
> +               }
> +               src++;
> +       }
> +       *tmp = NULL; /*The last (struct usb_descriptor_header *) in the
> +                       descriptors vector is NULL*/

Fix commenting style.

> +       f->ss_desc_allocated = true;
> +}
> +
>  /*-------------------------------------------------------------------------*/
>  /**
>  * next_ep_desc - advance to the next EP descriptor
> @@ -110,6 +206,9 @@ int ep_choose(struct usb_gadget *g, struct usb_function *f, struct usb_ep *_ep)
>        struct usb_endpoint_descriptor *chosen_desc = NULL;
>        struct usb_descriptor_header **speed_desc = NULL;
>
> +       struct usb_ss_ep_comp_descriptor *comp_desc = NULL;
> +       int want_comp_desc = 0;
> +
>        struct usb_descriptor_header **d_spd; /* cursor for speed desc */
>
>        if (!g || !f || !_ep)
> @@ -117,6 +216,13 @@ int ep_choose(struct usb_gadget *g, struct usb_function *f, struct usb_ep *_ep)
>
>        /* select desired speed */
>        switch (g->speed) {
> +       case USB_SPEED_SUPER:
> +               if (gadget_is_superspeed(g)) {
> +                       speed_desc = f->ss_descriptors;
> +                       want_comp_desc = 1;
> +                       break;
> +               }
> +               /*else: Fall trough*/
>        case USB_SPEED_HIGH:
>                if (gadget_is_dualspeed(g)) {
>                        speed_desc = f->hs_descriptors;
> @@ -143,7 +249,18 @@ ep_found:
>        /* commit results */
>        _ep->maxpacket = chosen_desc->wMaxPacketSize;
>        _ep->desc = chosen_desc;
> -
> +       _ep->comp_desc = NULL;
> +       if (want_comp_desc) {
> +               /**
> +                * Companion descriptor should follow EP descriptor
> +                * USB 3.0 spec, #9.6.7
> +                */

Same here. No two **.

> +               comp_desc = (struct usb_ss_ep_comp_descriptor *)*(++d_spd);
> +               if (!comp_desc ||
> +                   (comp_desc->bDescriptorType != USB_DT_SS_ENDPOINT_COMP))
> +                       return -EIO;
> +               _ep->comp_desc = comp_desc;
> +       }
>        return 0;
>  }
>
> @@ -185,6 +302,12 @@ int usb_add_function(struct usb_configuration *config,
>                        list_del(&function->list);
>                        function->config = NULL;
>                }
> +               /*Add SS descriptors if there are any. This has to be done
> +                 after the bind since we need the hs_descriptors to be set in
> +                 usb_function and some of the FDs does it in the bind. */

And here.

Please run scripts/checkpatch.pl to fix up the coding style issues at
several places in this patch.

Regards,
Maulik
