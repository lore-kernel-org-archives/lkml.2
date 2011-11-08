Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932877Ab1KHO6f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 09:58:35 -0500
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:58407 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932665Ab1KHO6d convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 09:58:33 -0500
MIME-Version: 1.0
In-Reply-To: <1319805325-24689-13-git-send-email-heikki.krogerus@linux.intel.com>
References: <1319805325-24689-1-git-send-email-heikki.krogerus@linux.intel.com>
	<1319805325-24689-13-git-send-email-heikki.krogerus@linux.intel.com>
Date: Tue, 8 Nov 2011 20:28:31 +0530
Message-ID: <CAAe_U6Kpwc3XQCjQ9m0hNCn8jmaQPQ+achEVTwD+zSfDNihmdA@mail.gmail.com>
Subject: Re: [PATCHv6 12/19] usb: otg: twl6030: Start using struct usb_otg
From: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Felipe Balbi <balbi@ti.com>, Greg KH <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hema HK <hemahk@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Heikki,

On Fri, Oct 28, 2011 at 6:05 PM, Heikki Krogerus
<heikki.krogerus@linux.intel.com> wrote:
> Use struct usb_otg members with OTG specific functions instead
> of usb_phy members.
>
> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> Tested-by: Kishon Vijay Abraham I <kishon@ti.com>
> Cc: Hema HK <hemahk@ti.com>
> ---
>  drivers/usb/otg/twl6030-usb.c |  103 ++++++++++++++++++++++------------------
>  1 files changed, 57 insertions(+), 46 deletions(-)
>
> diff --git a/drivers/usb/otg/twl6030-usb.c b/drivers/usb/otg/twl6030-usb.c
> index 2f5c299..6de03fd 100644
> --- a/drivers/usb/otg/twl6030-usb.c
> +++ b/drivers/usb/otg/twl6030-usb.c
> @@ -87,7 +87,7 @@
>  #define        VBUS_DET                        BIT(2)
>
>  struct twl6030_usb {
> -       struct usb_phy  otg;
> +       struct usb_phy          xceiv;

here _usb_phy_ is a member of transceiver (by transceiver I mean
twl6030_usb). This makes  _usb_phy_ getting created when you create
your transceiver object. By this we are actually tying our usb_phy to
our transceiver. But in hardware, phy and twl6030 are separate
entities.

>        struct device           *dev;
>
>        /* for vbus reporting with irqs disabled */
> @@ -107,7 +107,7 @@ struct twl6030_usb {
>        unsigned long           features;
>  };
>
> -#define xceiv_to_twl(x)                container_of((x), struct twl6030_usb, otg)
> +#define xceiv_to_twl(x)                container_of((x), struct twl6030_usb, xceiv)
>
>  /*-------------------------------------------------------------------------*/
>
> @@ -178,9 +178,9 @@ static int twl6030_phy_suspend(struct usb_phy *x, int suspend)
>        return 0;
>  }
>
> -static int twl6030_start_srp(struct usb_phy *x)
> +static int twl6030_start_srp(struct usb_otg *otg)
>  {
> -       struct twl6030_usb *twl = xceiv_to_twl(x);
> +       struct twl6030_usb *twl = xceiv_to_twl(otg->xceiv);
>
>        twl6030_writeb(twl, TWL_MODULE_USB, 0x24, USB_VBUS_CTRL_SET);
>        twl6030_writeb(twl, TWL_MODULE_USB, 0x84, USB_VBUS_CTRL_SET);

Here if you see, start_srp is a otg function and it operates on
twl6030. Maybe thats why I think, separating usb_phy from twl6030_usb
should be the first step than separating otg from twl6030_usb.

Thanks
Kishon
