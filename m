Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759258Ab0EDRzs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 13:55:48 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44189 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756873Ab0EDRzq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 13:55:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=iT7hxZt4Wf42EWSL+6w1+vJJJMEWIFttBvk2b7Pu/qi6Nw5SAoPnTYOrVQr5U/f7+2
         sf2flg3xmhAEhc+c3JvPEIe3/pjGmoUwPWMjZLLpops8LiSP4HkhZLO1t4y5DjfAZNlg
         zz2d7tNDwAeru1SxUfGIL5o17tozvanSFsXSs=
MIME-Version: 1.0
In-Reply-To: <1272994594.13354.215.camel@localhost.localdomain>
References: <1272994594.13354.215.camel@localhost.localdomain>
Date: Tue, 4 May 2010 20:55:43 +0300
X-Google-Sender-Auth: 6n-bjArb8d4gZsFL95rIhgupecE
Message-ID: <AANLkTikl6J1RwgRidSMLm9Qa72PBcvXbrauzk_zUiuZ9@mail.gmail.com>
Subject: Re: [PATCH] Disable i8042 checks on Intel Apple Macs
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Bastien Nocera <hadess@hadess.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 4, 2010 at 8:36 PM, Bastien Nocera <hadess@hadess.net> wrote:
> As those computers never had any i8042 controllers, and the
> current lookup code could potentially lock up/hang/wait for
> timeout for long periods of time.
>
> Fixes intermittent hangs on boot on a MacbookAir1,1

My Macbook also complains (doesn't hang though) about this:

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>

> Signed-off-by: Bastien Nocera <hadess@hadess.net>
> ---
>  drivers/input/serio/i8042.c |   18 ++++++++++++++++++
>  1 files changed, 18 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/input/serio/i8042.c b/drivers/input/serio/i8042.c
> index d84a36e..2be7207 100644
> --- a/drivers/input/serio/i8042.c
> +++ b/drivers/input/serio/i8042.c
> @@ -1438,12 +1438,30 @@ static struct platform_driver i8042_driver = {
>        .shutdown       = i8042_shutdown,
>  };
>
> +static struct dmi_system_id __initdata dmi_system_table[] = {
> +       {
> +               .matches = {
> +                       DMI_MATCH(DMI_BIOS_VENDOR, "Apple Computer, Inc.")
> +               },
> +       },
> +       {
> +               .matches = {
> +                       DMI_MATCH(DMI_BIOS_VENDOR, "Apple Inc.")
> +               },
> +       },
> +       {}
> +};
> +
>  static int __init i8042_init(void)
>  {
>        int err;
>
>        dbg_init();
>
> +       /* Intel Apple Macs never have an i8042 controller */
> +       if (dmi_check_system(dmi_system_table) > 0)
> +               return -ENODEV;
> +
>        err = i8042_platform_init();
>        if (err)
>                return err;
> --
> 1.6.6
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
