Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933709Ab2GLLXX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 07:23:23 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:34676 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495Ab2GLLXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 07:23:21 -0400
MIME-Version: 1.0
In-Reply-To: <1290084457-26422-1-git-send-email-tlinder@codeaurora.org>
References: <1290084457-26422-1-git-send-email-tlinder@codeaurora.org>
Date: Thu, 12 Jul 2012 16:53:20 +0530
Message-ID: <CAOiXhaKXfVVr8Q6UREp3zZYqpwmJxU1vEyJ_ETH0Uo0FNxm51g@mail.gmail.com>
Subject: Re: [PATCH v4 2/4] usb gadget: Configure endpoint according to gadget speed.
From: Rajaram R <rajaram.officemail@gmail.com>
To: Tatyana Brokhman <tlinder@codeaurora.org>
Cc: gregkh@suse.de, linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi


On Thu, Nov 18, 2010 at 6:17 PM, Tatyana Brokhman
<tlinder@codeaurora.org> wrote:
>
> Add config_ep_by_speed() to configure the endpoint according to the gadget
> speed. Using this function will spare the FDs from handling the endpoint
> chosen descriptor.
>
> Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>
> ---
>  drivers/usb/gadget/composite.c  |   76 +++++++++++++++++++++++++++++++++++++++
>  drivers/usb/gadget/epautoconf.c |    1 +
>  include/linux/usb/composite.h   |   21 +++++++++++
>  include/linux/usb/gadget.h      |    3 ++
>  4 files changed, 101 insertions(+), 0 deletions(-)
>
---cut---

> + */
> +int config_ep_by_speed(struct usb_gadget *g,
> +                       struct usb_function *f,
> +                       struct usb_ep *_ep)
> +{
> +       struct usb_endpoint_descriptor *chosen_desc = NULL;
> +       struct usb_descriptor_header **speed_desc = NULL;
> +
> +       struct usb_descriptor_header **d_spd; /* cursor for speed desc */
> +
> +       if (!g || !f || !_ep)
> +               return -EIO;
> +
> +       /* select desired speed */
> +       switch (g->speed) {
> +       case USB_SPEED_HIGH:
> +               if (gadget_is_dualspeed(g)) {
> +                       speed_desc = f->hs_descriptors;
> +                       break;
> +               }
> +               /* else: fall through */
> +       default:
> +               speed_desc = f->descriptors;
> +       }
> +       /* find descriptors */
> +       for (d_spd = next_ep_desc(speed_desc); d_spd;
> +             d_spd = next_ep_desc(d_spd+1)) {
> +               chosen_desc = (struct usb_endpoint_descriptor *)*d_spd;
> +               if (chosen_desc->bEndpointAddress == _ep->bEndpointAddress)
> +                       goto ep_found;
> +       }
> +       return -EIO;
> +
> +ep_found:
> +       /* commit results */
> +       _ep->maxpacket = le16_to_cpu(chosen_desc->wMaxPacketSize);
> +       _ep->desc = chosen_desc;

Could you please comment on why do we need to update gadget's ep list
with function's maxpacket ? Will this not affect when we switch
functions ?

> +
> +       return 0;
> +}
