Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758773Ab1FBCKa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 22:10:30 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:41386 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753801Ab1FBCK2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 22:10:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=cLXlSEk18SufXuuhzSmj5iH1hvgQJmIibibGyFYX7DjKEmT7pkFGZbc3p28AbumhhD
         0DUocUBHNREgS2LibOgP0jO5/GJPicGhlxZ1huQErO8soHIzt9/rAG5huZTava/7k9BV
         PdzarKECo04gMh8V8KffMRdqG1C31yt6w5/Kk=
MIME-Version: 1.0
In-Reply-To: <1306948213-20767-3-git-send-email-julia@diku.dk>
References: <1306948213-20767-3-git-send-email-julia@diku.dk>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Thu, 2 Jun 2011 10:10:07 +0800
Message-ID: <BANLkTi=rAxyyktVVNB0s06pofWzo9CbP5Q@mail.gmail.com>
Subject: Re: [PATCH 3/10] drivers/usb/host/ohci-pxa27x.c: add missing clk_put
To: Julia Lawall <julia@diku.dk>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        kernel-janitors@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Mike Rapoport <mike@compulab.co.il>,
        Igor Grinberg <grinberg@compulab.co.il>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 2, 2011 at 1:10 AM, Julia Lawall <julia@diku.dk> wrote:
> From: Julia Lawall <julia@diku.dk>
>
> Add a label before the call to clk_put and jump to that in the error
> handling code that occurs after the call to clk_get has succeeded.
>
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
>
> // <smpl>
> @r exists@
> expression e1,e2;
> statement S;
> @@
>
> e1 = clk_get@p1(...);
> ... when != e1 = e2
>    when != clk_put(e1)
>    when any
> if (...) { ... when != clk_put(e1)
>               when != if (...) { ... clk_put(e1) ... }
> * return@p3 ...;
>  } else S
> // </smpl>
>
> Signed-off-by: Julia Lawall <julia@diku.dk>
>

Acked-by: Eric Miao <eric.y.miao@gmail.com>

> ---
>  drivers/usb/host/ohci-pxa27x.c |    7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/usb/host/ohci-pxa27x.c b/drivers/usb/host/ohci-pxa27x.c
> index afef7b0..80be547 100644
> --- a/drivers/usb/host/ohci-pxa27x.c
> +++ b/drivers/usb/host/ohci-pxa27x.c
> @@ -312,8 +312,10 @@ int usb_hcd_pxa27x_probe (const struct hc_driver *driver, struct platform_device
>                return PTR_ERR(usb_clk);
>
>        hcd = usb_create_hcd (driver, &pdev->dev, "pxa27x");
> -       if (!hcd)
> -               return -ENOMEM;
> +       if (!hcd) {
> +               retval = -ENOMEM;
> +               goto err0;
> +       }
>
>        r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>        if (!r) {
> @@ -368,6 +370,7 @@ int usb_hcd_pxa27x_probe (const struct hc_driver *driver, struct platform_device
>        release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
>  err1:
>        usb_put_hcd(hcd);
> + err0:
>        clk_put(usb_clk);
>        return retval;
>  }
>
>
