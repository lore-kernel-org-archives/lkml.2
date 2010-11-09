Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662Ab0KIKEz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 05:04:55 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45840 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684Ab0KIKEw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 05:04:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=Nq9hAufvSWGijJbFXwV9WaiXDb9+taJCrNru/9z/p/+BA+hKCeKM/N0wqT0f0CHJg7
         09pTKFN82O0OZGsBafm+dROXY3YaejU9vRhHf+N6dldKBx2yK+4qEuKNqOLWppdYSD+Z
         VVeFvGqkVceBqamXsXocxAq4gtQvC24ihsVLI=
MIME-Version: 1.0
In-Reply-To: <1288624285-32355-3-git-send-email-tlinder@codeaurora.org>
References: <1288624285-32355-1-git-send-email-tlinder@codeaurora.org>
 <1288624285-32355-2-git-send-email-tlinder@codeaurora.org> <1288624285-32355-3-git-send-email-tlinder@codeaurora.org>
From: Mike Frysinger <vapier@gentoo.org>
Date: Tue, 9 Nov 2010 05:04:29 -0500
X-Google-Sender-Auth: 4Eg3PKHESAlCxp1SxsOlLIQXpmQ
Message-ID: <AANLkTikp9czuN+xH_fnz-j+a2UL5+CeS1rZXn9wdrA1J@mail.gmail.com>
Subject: Re: [RFC/PATCH v3 2/4] usb: Configure endpoint according to gadget speed.
To: Tatyana Brokhman <tlinder@codeaurora.org>, Bob Liu <lliubbo@gmail.com>,
        uclinux-dist-devel@blackfin.uclinux.org
Cc: linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Michal Nazarewicz <m.nazarewicz@samsung.com>,
        Robert Lukassen <robert.lukassen@tomtom.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Cliff Cai <cliff.cai@analog.com>,
        Fabien Chouteau <fabien.chouteau@barco.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

maybe Bob has an opinion ...
-mike

On Mon, Nov 1, 2010 at 11:11, Tatyana Brokhman wrote:
> Add config_ep_by_speed() to configure the endpoint according to the gadget
> speed. Using this function will spare the FDs from handling the endpoint
> chosen descriptor.
>
> Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>
> ---
>  drivers/usb/gadget/composite.c  |   76 +++++++++++++++++++++++++++++++++++++++
>  drivers/usb/gadget/epautoconf.c |    1 +
>  include/linux/usb/composite.h   |   21 +++++++++++
>  include/linux/usb/gadget.h      |    8 +++--
>  4 files changed, 103 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
> index 1160c55..ed6ec5b 100644
> --- a/drivers/usb/gadget/composite.c
> +++ b/drivers/usb/gadget/composite.c
> @@ -70,6 +70,82 @@ module_param(iSerialNumber, charp, 0);
>  MODULE_PARM_DESC(iSerialNumber, "SerialNumber string");
>
>  /*-------------------------------------------------------------------------*/
> +/**
> + * next_ep_desc() - advance to the next EP descriptor
> + * @t: currect pointer within descriptor array
> + *
> + * Return: next EP descriptor or NULL
> + *
> + * Iterate over @t until either EP descriptor found or
> + * NULL (that indicates end of list) encountered
> + */
> +static struct usb_descriptor_header**
> +next_ep_desc(struct usb_descriptor_header **t)
> +{
> +       for (; *t; t++) {
> +               if ((*t)->bDescriptorType == USB_DT_ENDPOINT)
> +                       return t;
> +       }
> +       return NULL;
> +}
> +
> +/**
> + * config_ep_by_speed() - configures the given endpoint
> + * according to gadget speed.
> + * @g: pointer to the gadget
> + * @f: usb function
> + * @_ep: the endpoint to configure
> + *
> + * Return: error code, 0 on success
> + *
> + * This function chooses the right descriptors for a given
> + * endpoint according to gadget speed and saves in in the
> + * endpoint desc field. If the endpoint already has a descriptor
> + * assigned to it - overwrites it with currently corresponding
> + * descriptor. The endpoint maxpacket field is updated according
> + * to the choosen descriptor.
> + * Note: the supplied function should hold all the descriptors
> + * for supported speeds
> + */
> +int config_ep_by_speed(struct usb_gadget *g,
> +                       struct usb_function *f,
> +                       struct usb_ep *_ep)
> +{
> +       struct usb_endpoint_descriptor *chosen_desc = NULL;
> +       struct usb_descriptor_header **speed_desc = NULL;
> +
> +       struct usb_descriptor_header **d_spd; /* cursor for speed desc */
> +
> +       if (!g || !f || !_ep)
> +               return -EIO;
> +
> +       /* select desired speed */
> +       switch (g->speed) {
> +       case USB_SPEED_HIGH:
> +               if (gadget_is_dualspeed(g)) {
> +                       speed_desc = f->hs_descriptors;
> +                       break;
> +               }
> +               /* else: fall through */
> +       default:
> +               speed_desc = f->descriptors;
> +       }
> +       /* find descriptors */
> +       for (d_spd = next_ep_desc(speed_desc); d_spd;
> +             d_spd = next_ep_desc(d_spd+1)) {
> +               chosen_desc = (struct usb_endpoint_descriptor *)*d_spd;
> +               if (chosen_desc->bEndpointAddress == _ep->bEndpointAddress)
> +                       goto ep_found;
> +       }
> +       return -EIO;
> +
> +ep_found:
> +       /* commit results */
> +       _ep->maxpacket = le16_to_cpu(chosen_desc->wMaxPacketSize);
> +       _ep->desc = chosen_desc;
> +
> +       return 0;
> +}
>
>  /**
>  * usb_add_function() - add a function to a configuration
> diff --git a/drivers/usb/gadget/epautoconf.c b/drivers/usb/gadget/epautoconf.c
> index 8a83248..84ce0fa 100644
> --- a/drivers/usb/gadget/epautoconf.c
> +++ b/drivers/usb/gadget/epautoconf.c
> @@ -184,6 +184,7 @@ ep_matches (
>                        size = 64;
>                desc->wMaxPacketSize = cpu_to_le16(size);
>        }
> +       ep->bEndpointAddress = desc->bEndpointAddress;
>        return 1;
>  }
>
> diff --git a/include/linux/usb/composite.h b/include/linux/usb/composite.h
> index 6170681..1f18326 100644
> --- a/include/linux/usb/composite.h
> +++ b/include/linux/usb/composite.h
> @@ -138,6 +138,27 @@ int usb_function_activate(struct usb_function *);
>  int usb_interface_id(struct usb_configuration *, struct usb_function *);
>
>  /**
> + * config_ep_by_speed() - configures the given endpoint
> + * according to gadget speed.
> + * @g: pointer to the gadget
> + * @f: usb function
> + * @_ep: the endpoint to configure
> + *
> + * Return: error code, 0 on success
> + *
> + * This function chooses the right descriptors for a given
> + * endpoint according to gadget speed and saves in in the
> + * endpoint desc field. If the endpoint already has a descriptor
> + * assigned to it - overwrites it with currently corresponding
> + * descriptor. The endpoint maxpacket field is updated according
> + * to the choosen descriptor.
> + * Note: the supplied function should hold all the descriptors
> + * for supported speeds
> + */
> +int config_ep_by_speed(struct usb_gadget *g, struct usb_function *f,
> +                       struct usb_ep *_ep);
> +
> +/**
>  * ep_choose - select descriptor endpoint at current device speed
>  * @g: gadget, connected and running at some speed
>  * @hs: descriptor to use for high speed operation
> diff --git a/include/linux/usb/gadget.h b/include/linux/usb/gadget.h
> index 131843d..e387922 100644
> --- a/include/linux/usb/gadget.h
> +++ b/include/linux/usb/gadget.h
> @@ -132,9 +132,10 @@ struct usb_ep_ops {
>  *     value can sometimes be reduced (hardware allowing), according to
>  *      the endpoint descriptor used to configure the endpoint.
>  * @driver_data:for use by the gadget driver.
> - * @desc:endpoint descriptor.  This pointer set before endpoint
> - *     is enabled and remains valid until the endpoint is
> - *     disabled.
> + * @bEndpointAddress: used to identify the endpoint when finding
> + *     descriptor that matches connection speed
> + * @desc:endpoint descriptor.  this pointer set before endpoint is enabled and
> + *     remains valid until the endpoint is disabled.
>  *
>  * the bus controller driver lists all the general purpose endpoints in
>  * gadget->ep_list.  the control endpoint (gadget->ep0) is not in that list,
> @@ -147,6 +148,7 @@ struct usb_ep {
>        const struct usb_ep_ops         *ops;
>        struct list_head                ep_list;
>        unsigned                        maxpacket:16;
> +       u8                              bEndpointAddress;
>        struct usb_endpoint_descriptor  *desc;
>  };
>
> --
> 1.6.3.3
>
> --
> Sent by an employee of the Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
