Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504Ab0HXJBC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 05:01:02 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43249 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754483Ab0HXJA6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 05:00:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=aSKT+7FXgil6CGvS1EHizACs3DzEjetgBGrMp4FrRZ/5tLwg8gZ8LJzbiWmIBg16UT
         xdScame5MU9Z/78CgxLCXjY1kqyJrpPxYNPT9MFuo+uvtbwgTqcY4IyjZ7JgwBQcYHjw
         zsbKkIaT6JwaQrDNRuA6uvTwiosUEjlI5Jnoo=
MIME-Version: 1.0
In-Reply-To: <1282634338.11025.5.camel@mola>
References: <1282634338.11025.5.camel@mola>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Tue, 24 Aug 2010 17:00:37 +0800
Message-ID: <AANLkTim553rFApc41D6=19hBESPRwQtosrYii3d8aQti@mail.gmail.com>
Subject: Re: [PATCH v2] mfd: tps6586x - free allocated resources when unload
 the module
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mike Rapoport <mike@compulab.co.il>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 24, 2010 at 3:18 PM, Axel Lin <axel.lin@gmail.com> wrote:
> For the resources allocated in tps6586x_i2c_probe(),
> we need to free it in tps6586x_i2c_remove().
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
> Changes since V1:
> Current implementation allows gpiochip_add() fail in probe,
> thus just show a wraning if gpiochip_remove() fail.
>
> I don't have this hardware handy,
> I am not sure that does it make sense to allow gpiochip_add() fail in probe.

That's fully possible.

>
>  drivers/mfd/tps6586x.c |   13 +++++++++++++
>  1 files changed, 13 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/mfd/tps6586x.c b/drivers/mfd/tps6586x.c
> index 1c91936..2f9336c 100644
> --- a/drivers/mfd/tps6586x.c
> +++ b/drivers/mfd/tps6586x.c
> @@ -344,6 +344,19 @@ err_add_devs:
>
>  static int __devexit tps6586x_i2c_remove(struct i2c_client *client)
>  {
> +       struct tps6586x *tps6586x = i2c_get_clientdata(client);
> +       struct tps6586x_platform_data *pdata = client->dev.platform_data;
> +       int ret;
> +
> +       if (pdata->gpio_base) {
> +               ret = gpiochip_remove(&tps6586x->gpio);
> +               if (ret)
> +                       dev_err(&client->dev, "Can't remove gpio chip: %d\n",
> +                               ret);
> +       }
> +
> +       tps6586x_remove_subdevs(tps6586x);
> +       kfree(tps6586x);
>        return 0;
>  }
>
> --
> 1.7.2
>
>
>
>
