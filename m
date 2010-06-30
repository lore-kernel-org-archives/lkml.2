Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858Ab0F3BwT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 21:52:19 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:62905 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645Ab0F3BwR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 21:52:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kFRpJIIheVD54SzwmcSJeqoXUJvW1JdBjXeE6v9ox2cDzo0qjqkJ4Eb5jpNf0Ow4f0
         7gDA2BAEi6oaF+t2JExj4Zbdjfe/+WqRM+kaH+qxvkCpTuH4JM9iSE7boYMnmsNYB37r
         T7PPHrRX8cn8+LywUecxUWxJ4fXAiszLe9UxM=
MIME-Version: 1.0
In-Reply-To: <20100628222920.1127f8eb@neptune.home>
References: <20100509184911.3f136b77@neptune.home>
	<AANLkTik0EkPYKdnhrpF7yK6eXIrHMsNYrzSC6tyeBR0P@mail.gmail.com>
	<20100510080047.5adade6f@pluto.restena.lu>
	<20100526215829.28a4aa47@neptune.home>
	<20100530130945.5c03797f@neptune.home>
	<20100623123225.4c16e653@neptune.home>
	<alpine.LNX.2.00.1006241053360.13809@pobox.suse.cz>
	<20100628222641.489c955a@neptune.home>
	<20100628222920.1127f8eb@neptune.home>
Date: Wed, 30 Jun 2010 09:52:13 +0800
Message-ID: <AANLkTingjmM4OmkdXl9IOUe5zsj0QxTdix1h34pVHWGl@mail.gmail.com>
Subject: Re: [PATCH 1/4] HID: picolcd: fix deferred_io init/cleanup to 
	(un)register_framebuffer ordering
From: Jaya Kumar <jayakumar.lkml@gmail.com>
To: =?ISO-8859-1?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-fbdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 29, 2010 at 4:29 AM, Bruno Prémont
<bonbons@linux-vserver.org> wrote:
> We need to call fb_deferred_io_init() before we register_framebuffer()
> as otherwise, in case fbcon uses our framebuffer, we will get a BUG()
> because in picolcd_fb_imageblit() we schedule defio which has not
> been initialized yet.

Hi Bruno,

The comment above seems confusing to me in that it talks about fbcon
and defio schedule.

What I see is that you originally had in picolcd:

>        error = register_framebuffer(info);
...
>        fb_deferred_io_init(info);

which was a bug because it called register_framebuffer (ie: made the
framebuffer available for use) and only then initialized the defio
handlers which were needed for that framebuffer memory to be used.
Drivers must always call defio_init _before_ register_framebuffer. The
bug fix to picolcd below looks correct because it now does that
sequence in the correct order.

Thanks,
jaya



>
> Note: this BUG() deadlocks ttys.
>
> Signed-off-by: Bruno Prémont <bonbons@linux-vserver.org>
> ---
>  drivers/hid/hid-picolcd.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/hid/hid-picolcd.c b/drivers/hid/hid-picolcd.c
> index 95253b3..883d720 100644
> --- a/drivers/hid/hid-picolcd.c
> +++ b/drivers/hid/hid-picolcd.c
> @@ -707,18 +707,19 @@ static int picolcd_init_framebuffer(struct picolcd_data *data)
>                dev_err(dev, "failed to create sysfs attributes\n");
>                goto err_cleanup;
>        }
> +       fb_deferred_io_init(info);
>        data->fb_info    = info;
>        error = register_framebuffer(info);
>        if (error) {
>                dev_err(dev, "failed to register framebuffer\n");
>                goto err_sysfs;
>        }
> -       fb_deferred_io_init(info);
>        /* schedule first output of framebuffer */
>        schedule_delayed_work(&info->deferred_work, 0);
>        return 0;
>
>  err_sysfs:
> +       fb_deferred_io_cleanup(info);
>        device_remove_file(dev, &dev_attr_fb_update_rate);
>  err_cleanup:
>        data->fb_vbitmap = NULL;
> @@ -747,7 +748,6 @@ static void picolcd_exit_framebuffer(struct picolcd_data *data)
>        data->fb_bpp     = 0;
>        data->fb_info    = NULL;
>        device_remove_file(&data->hdev->dev, &dev_attr_fb_update_rate);
> -       fb_deferred_io_cleanup(info);
>        unregister_framebuffer(info);
>        vfree(fb_bitmap);
>        kfree(fb_vbitmap);
> --
> 1.7.1
>
>
