Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752298Ab1AYAiQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 19:38:16 -0500
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:52553 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751446Ab1AYAiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 19:38:15 -0500
From: Kevin Hilman <khilman@ti.com>
To: shubhrajyoti@ti.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] bh1780gli : Convert to dev pm ops
Organization: Texas Instruments, Inc.
References: <1295346162-6800-1-git-send-email-shubhrajyoti@ti.com>
Date: Mon, 24 Jan 2011 16:38:11 -0800
In-Reply-To: <1295346162-6800-1-git-send-email-shubhrajyoti@ti.com>
	(shubhrajyoti@ti.com's message of "Tue, 18 Jan 2011 15:52:42 +0530")
Message-ID: <87tygx3jik.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

shubhrajyoti@ti.com writes:

> From: Shubhrajyoti Datta <shubhrajyoti@ti.com>
>
> Signed-off-by: Shubhrajyoti Datta <shubhrajyoti@ti.com>
> ---
>  drivers/misc/bh1780gli.c |   20 ++++++++++----------
>  1 files changed, 10 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/misc/bh1780gli.c b/drivers/misc/bh1780gli.c
> index d5f3a3f..07224ae 100644
> --- a/drivers/misc/bh1780gli.c
> +++ b/drivers/misc/bh1780gli.c
> @@ -196,10 +196,11 @@ static int __devexit bh1780_remove(struct i2c_client *client)
>  }
>  
>  #ifdef CONFIG_PM
> -static int bh1780_suspend(struct i2c_client *client, pm_message_t mesg)
> +static int bh1780_suspend(struct device *dev)
>  {
>  	struct bh1780_data *ddata;
>  	int state, ret;
> +	struct i2c_client *client = to_i2c_client(dev);
>  
>  	ddata = i2c_get_clientdata(client);
>  	state = bh1780_read(ddata, BH1780_REG_CONTROL, "CONTROL");
> @@ -217,14 +218,14 @@ static int bh1780_suspend(struct i2c_client *client, pm_message_t mesg)
>  	return 0;
>  }
>  
> -static int bh1780_resume(struct i2c_client *client)
> +static int bh1780_resume(struct device *dev)
>  {
>  	struct bh1780_data *ddata;
>  	int state, ret;
> +	struct i2c_client *client = to_i2c_client(dev);
>  
>  	ddata = i2c_get_clientdata(client);
>  	state = ddata->power_state;
> -
>  	ret = bh1780_write(ddata, BH1780_REG_CONTROL, state,
>  				"CONTROL");
>  
> @@ -233,9 +234,7 @@ static int bh1780_resume(struct i2c_client *client)
>  
>  	return 0;
>  }
> -#else
> -#define bh1780_suspend NULL
> -#define bh1780_resume NULL
> +static SIMPLE_DEV_PM_OPS(bh1780_pm, bh1780_suspend, bh1780_resume);

Rather, keep the #else here with a NULL pm_ops ptr so you don't need the
#ifdef below.

Kevin

>  #endif /* CONFIG_PM */
>  
>  static const struct i2c_device_id bh1780_id[] = {
> @@ -247,11 +246,12 @@ static struct i2c_driver bh1780_driver = {
>  	.probe		= bh1780_probe,
>  	.remove		= bh1780_remove,
>  	.id_table	= bh1780_id,
> -	.suspend	= bh1780_suspend,
> -	.resume		= bh1780_resume,
>  	.driver = {
> -		.name = "bh1780"
> -	},
> +		.name = "bh1780",
> +#ifdef CONFIG_PM
> +		.pm	= &bh1780_pm,
> +#endif
> +},
>  };
>  
>  static int __init bh1780_init(void)
