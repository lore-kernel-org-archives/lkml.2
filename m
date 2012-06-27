Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932082Ab2F0Ktl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 06:49:41 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:48790 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757189Ab2F0Ktc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 06:49:32 -0400
MIME-Version: 1.0
In-Reply-To: <20120627091055.GW31212@elgon.mountain>
References: <20120627085800.GA3007@mwanda> <20120627091055.GW31212@elgon.mountain>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Wed, 27 Jun 2012 18:49:10 +0800
X-Google-Sender-Auth: sqQ4ISlNEzyCoM3olxhIqPayytM
Message-ID: <CAK5ve-J9CgB=uz-09=POPoygWvNs7k_R3tbZVAzi0VLKTpvOqA@mail.gmail.com>
Subject: Re: [patch -resend] leds-lp5523: BUG() in error handling in probe()
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Richard Purdie <rpurdie@rpsys.net>, linux-leds@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2012 at 5:10 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> Inside the error handling in lp5523_init_led(), there is a place that
> calls to led_classdev_unregister().  When we unregister the LED drivers,
> it tries to set the brightness to OFF.  In this driver setting the
> brightness is done through a work queue and the work queue hasn't been
> initialized yet.
>
> The result is that we trigger a WARN_ON() in the __queue_work().
>
> The fix is to move the INIT_WORK() in front of the call to
> lp5523_init_led().
>

Thanks for resending this, I applied this in my for-next branch.

> Matt Renzelmann found this using a bug finding tool.

Just be curious, what's kind of the tool here?

-Bryan

>
> Reported-by: Matt Renzelmann <mjr@cs.wisc.edu>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> I don't have this hardware, so I can't test it.  I originally sent this
> on Fri, 13 Apr 2012, and that was before Bryan Wu took on the LED
> subsystem.  Also when I sent it, the WARN_ON() in __queue_work() was
> a BUG_ON() so I've updated the commit message.
>
> diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
> index 857a3e1..e8a2712 100644
> --- a/drivers/leds/leds-lp5523.c
> +++ b/drivers/leds/leds-lp5523.c
> @@ -943,6 +943,9 @@ static int __devinit lp5523_probe(struct i2c_client *client,
>                if (pdata->led_config[i].led_current == 0)
>                        continue;
>
> +               INIT_WORK(&chip->leds[led].brightness_work,
> +                       lp5523_led_brightness_work);
> +
>                ret = lp5523_init_led(&chip->leds[led], &client->dev, i, pdata);
>                if (ret) {
>                        dev_err(&client->dev, "error initializing leds\n");
> @@ -956,9 +959,6 @@ static int __devinit lp5523_probe(struct i2c_client *client,
>                          LP5523_REG_LED_CURRENT_BASE + chip->leds[led].chan_nr,
>                          chip->leds[led].led_current);
>
> -               INIT_WORK(&(chip->leds[led].brightness_work),
> -                       lp5523_led_brightness_work);
> -
>                led++;
>        }
>



-- 
Bryan Wu <bryan.wu@canonical.com>
Kernel Developer    +86.186-168-78255 Mobile
Canonical Ltd.      www.canonical.com
Ubuntu - Linux for human beings | www.ubuntu.com
