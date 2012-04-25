Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759034Ab2DYLo4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 07:44:56 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43063 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758589Ab2DYLoz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 07:44:55 -0400
MIME-Version: 1.0
In-Reply-To: <20120425073311.20124.58619.stgit@notabene.brown>
References: <20120425072931.20124.56635.stgit@notabene.brown>
	<20120425073311.20124.58619.stgit@notabene.brown>
Date: Wed, 25 Apr 2012 14:44:54 +0300
Message-ID: <CANOLnOMYqnjopeyEcP3MfuGLinTzmdz9Shoc+cwYGQaDiAiZ-g@mail.gmail.com>
Subject: Re: [PATCH 6/6] twl4030-usb: Don't report EVENT_ID when there is VBUS.
From: Grazvydas Ignotas <notasas@gmail.com>
To: NeilBrown <neilb@suse.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2012 at 10:33 AM, NeilBrown <neilb@suse.de> wrote:
> Some USB chargers tie the ID pin low via various resistors.
> So they can cause VBUS to be high and ID to be low.
>
> The 'A' end of an OTG cable never receives VBUS, it only ever generates it.
>
> So if we see VBUS and are not generating it, this must be a charger,
> not the A end of an OTG cable, so in that case, ignore the fact that
> ID is low.
>
> This assumes that VBUS_PRES isn't asserted when the charge pump is
> providing VBUS.  The document isn't clear on this and some experiments
> suggest that it isn't.

Like already mentioned, this is not what I see on pandora. I don't
know, maybe it's due to some errata or different versions of TWL chip
act different, or perhaps even board design issue, but that's how it
is here.

If you look at git history, this has been changed back and forth
several times, like in commit def6f8b9. Perhaps some platform_data
could be added to handle this, I don't know..

>
> Signed-off-by: NeilBrown <neilb@suse.de>
> ---
>
>  drivers/usb/otg/twl4030-usb.c |   19 ++++++++++---------
>  1 file changed, 10 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/usb/otg/twl4030-usb.c b/drivers/usb/otg/twl4030-usb.c
> index bd8fe9b..990400f 100644
> --- a/drivers/usb/otg/twl4030-usb.c
> +++ b/drivers/usb/otg/twl4030-usb.c
> @@ -268,15 +268,16 @@ static enum usb_phy_events twl4030_usb_linkstat(struct twl4030_usb *twl)
>                        STS_HW_CONDITIONS);
>        if (status < 0)
>                dev_err(twl->dev, "USB link status err %d\n", status);
> -       else if (status & (BIT(7) | BIT(2))) {
> -               if (status & (BIT(7)))
> -                        twl->vbus_supplied = true;
> -
> -               if (status & BIT(2))
> -                       linkstat = USB_EVENT_ID;
> -               else
> -                       linkstat = USB_EVENT_VBUS;
> -       } else
> +       else if (status & (BIT(7))) {
> +               /* We have VBUS so ignore ID_PRES - it is only meaningful
> +                * as an indicator of an A plug when there is no
> +                * VBUS.
> +                */
> +               twl->vbus_supplied = true;
> +               linkstat = USB_EVENT_VBUS;
> +       } else if (status & BIT(2))
> +               linkstat = USB_EVENT_ID;
> +       else
>                linkstat = USB_EVENT_NONE;
>
>        dev_dbg(twl->dev, "HW_CONDITIONS 0x%02x/%d; link %d\n",
>
>

-- 
Gražvydas
