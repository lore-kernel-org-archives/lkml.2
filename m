Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535Ab2KZQq0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 11:46:26 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:49228 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755168Ab2KZQqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 11:46:25 -0500
Date: Mon, 26 Nov 2012 08:46:18 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH 2/5 v2] Input: bu21013_ts - Move GPIO init and exit
 functions into the driver
Message-ID: <20121126164618.GA14623@core.coreip.homeip.net>
References: <1352900837-20759-1-git-send-email-lee.jones@linaro.org>
 <1352900837-20759-3-git-send-email-lee.jones@linaro.org>
 <20121122121030.GG4328@gmail.com>
 <20121124074359.GA24711@core.coreip.homeip.net>
 <20121126120143.GK12782@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121126120143.GK12782@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On Mon, Nov 26, 2012 at 12:01:43PM +0000, Lee Jones wrote:
>  /**
> + * bu21013_gpio_board_init() - configures the touch panel
> + * @reset_pin: reset pin number
> + *
> + * This function is used to configure the voltage and
> + * reset the touch panel controller.
> + */
> +static int bu21013_gpio_board_init(int reset_pin)
> +{
> +	int retval = 0;
> +
> +	retval = gpio_request_one(reset_pin, GPIOF_INIT_HIGH, "touchp_reset");

Also need to specify dircetion (even though it defaults to output).

> +	if (retval) {
> +		printk(KERN_ERR "Unable to request gpio reset_pin");
> +		return retval;
> +	}
> +
> +	return retval;
> +}
> +
> +/**
> + * bu21013_gpio_board_exit() - deconfigures the touch panel controller
> + * @reset_pin: reset pin number
> + *
> + * This function is used to deconfigure the chip selection
> + * for touch panel controller.
> + */
> +static int bu21013_gpio_board_exit(int reset_pin)
> +{
> +	int retval = 0;
> +
> +	retval = gpio_direction_output(reset_pin, 0);
> +	if (retval < 0) {
> +		printk(KERN_ERR "%s: gpio direction failed\n",
> +		       __func__);
> +		return retval;

You should not return here, as gpio has to be freed even if you unable
to toggle it.

> +	}
> +	gpio_set_value(reset_pin, 0);
> +	gpio_free(reset_pin);
> +
> +	return retval;
> +}
> +
> +/**
>   * bu21013_init_chip() - power on sequence for the bu21013 controller
>   * @data: device structure pointer
>   *
> @@ -449,6 +493,8 @@ static int __devinit bu21013_probe(struct i2c_client *client,
>  		return -EINVAL;
>  	}
>  
> +	pdata->irq = gpio_to_irq(pdata->touch_pin);
> +

No, you still can not do it since pdata is a const pointer. Does not
your compiler throw a warning here?

I already sent you a version of the patch that does not have these
issues, is there a particular reason why you needed to roll your own
instead of simply trying out the one I sent?

Thanks.

-- 
Dmitry
