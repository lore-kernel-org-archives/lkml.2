Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757778Ab1FFTNc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 15:13:32 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61626 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757576Ab1FFTNa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 15:13:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=OmEhBQak87YXquZAQvNOC1ft8iwD9GK0IO+0pfMZY+OfL3BpN0lZuYnc4zY/hMK9Ww
         dvG8mVC9ivruTlmCJ9c7WUnV3PRTMhf+Q569cuoOMSdgotnjAo4lZjPl3d1gKbaMB8FJ
         DnbEtfjeRmE5jMZr2OUrjZNqr/llli9JPQTU8=
MIME-Version: 1.0
In-Reply-To: <1307387257.4327.12.camel@anish-desktop>
References: <1307387257.4327.12.camel@anish-desktop>
Date: Mon, 6 Jun 2011 21:13:29 +0200
X-Google-Sender-Auth: jkbr_27B6_8if2IrZnuUXj-YqH8
Message-ID: <BANLkTinyeBMi9LiMx0jicMLLBo=cOKdomw@mail.gmail.com>
Subject: Re: [PATCH 1/2] staging: iio replaced kmalloc with local variables.
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: anish <anish198519851985@gmail.com>
Cc: gregkh@suse.de, jic23@cam.ac.uk, manuel.stahl@iis.fraunhofer.de,
        lucas.demarchi@profusion.mobi, arnd@arndb.de,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 6, 2011 at 21:07, anish <anish198519851985@gmail.com> wrote:
> From: anish kumar <anish198519851985@gmail.com>
>
> Replace kmalloc with local variables as it was un-necessary and

Is it really unnecessary?
Or is this hardware that cannot transfer buffers on the stack?
IIRC there have been similar problems with SCSI command buffers on the stack.

> also removed the redudant code after this change.
>
> Signed-off-by: anish kumar <anish198519851985@gmail.com>
> ---
>  drivers/staging/iio/accel/kxsd9.c      |   19 +++----------------
>  drivers/staging/iio/adc/max1363_core.c |    3 +--
>  2 files changed, 4 insertions(+), 18 deletions(-)
>
> diff --git a/drivers/staging/iio/accel/kxsd9.c b/drivers/staging/iio/accel/kxsd9.c
> index 431aa0f..7f6e6e5 100644
> --- a/drivers/staging/iio/accel/kxsd9.c
> +++ b/drivers/staging/iio/accel/kxsd9.c
> @@ -255,7 +255,10 @@ static const struct attribute_group kxsd9_attribute_group = {
>
>  static int __devinit kxsd9_power_up(struct spi_device *spi)
>  {
> +       struct spi_message msg;
>        int ret;
> +       u8 tx[2], tx2[2];
> +
>        struct spi_transfer xfers[2] = {
>                {
>                        .bits_per_word = 8,
> @@ -267,19 +270,7 @@ static int __devinit kxsd9_power_up(struct spi_device *spi)
>                        .cs_change = 1,
>                },
>        };
> -       struct spi_message msg;
> -       u8 *tx2;
> -       u8 *tx = kmalloc(2, GFP_KERNEL);
>
> -       if (tx == NULL) {
> -               ret = -ENOMEM;
> -               goto error_ret;
> -       }
> -       tx2 = kmalloc(2, GFP_KERNEL);
> -       if (tx2 == NULL) {
> -               ret = -ENOMEM;
> -               goto error_free_tx;
> -       }
>        tx[0] = 0x0d;
>        tx[1] = 0x40;
>
> @@ -293,10 +284,6 @@ static int __devinit kxsd9_power_up(struct spi_device *spi)
>        spi_message_add_tail(&xfers[1], &msg);
>        ret = spi_sync(spi, &msg);
>
> -       kfree(tx2);
> -error_free_tx:
> -       kfree(tx);
> -error_ret:
>        return ret;
>
>  };
> diff --git a/drivers/staging/iio/adc/max1363_core.c b/drivers/staging/iio/adc/max1363_core.c
> index 1037087..0026242 100644
> --- a/drivers/staging/iio/adc/max1363_core.c
> +++ b/drivers/staging/iio/adc/max1363_core.c
> @@ -207,7 +207,7 @@ static int max1363_write_basic_config(struct i2c_client *client,
>                                      unsigned char d2)
>  {
>        int ret;
> -       u8 *tx_buf = kmalloc(2, GFP_KERNEL);
> +       u8 tx_buf[2];
>
>        if (!tx_buf)
>                return -ENOMEM;
> @@ -215,7 +215,6 @@ static int max1363_write_basic_config(struct i2c_client *client,
>        tx_buf[1] = d2;
>
>        ret = i2c_master_send(client, tx_buf, 2);
> -       kfree(tx_buf);
>
>        return (ret > 0) ? 0 : ret;
>  }
> --
> 1.7.0.4

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
