Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487Ab1LMSHo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 13:07:44 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:52814 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754754Ab1LMSHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 13:07:43 -0500
Date: Tue, 13 Dec 2011 11:07:35 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@stericsson.com>,
        Anatolij Gustschin <agust@denx.de>
Subject: Re: [PATCH RESEND] gpio: mpc8xxx: don't allow input-only pins to be
 output for MPC5121
Message-ID: <20111213180735.GD4871@ponder.secretlab.ca>
References: <1323767568-9565-1-git-send-email-w.sang@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323767568-9565-1-git-send-email-w.sang@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 13, 2011 at 10:12:48AM +0100, Wolfram Sang wrote:
> Add a 5121-custom reject if an input-only pin is requested to be output
> (see 18.3.1.1 in the refman). Also, rewrite mach-specific quirk setup to
> consume less lines which scales better.
> 
> Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>

Applied, thanks.

g.

> ---
>  drivers/gpio/gpio-mpc8xxx.c |   17 ++++++++++++-----
>  1 files changed, 12 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-mpc8xxx.c b/drivers/gpio/gpio-mpc8xxx.c
> index ec3fcf0..25dc736 100644
> --- a/drivers/gpio/gpio-mpc8xxx.c
> +++ b/drivers/gpio/gpio-mpc8xxx.c
> @@ -115,6 +115,14 @@ static int mpc8xxx_gpio_dir_in(struct gpio_chip *gc, unsigned int gpio)
>  	return 0;
>  }
>  
> +static int mpc5121_gpio_dir_out(struct gpio_chip *gc, unsigned int gpio, int val)
> +{
> +	/* GPIO 28..31 are input only on MPC5121 */
> +	if (gpio >= 28)
> +		return -EINVAL;
> +
> +	return mpc8xxx_gpio_dir_out(gc, gpio, val);
> +}
>  static int mpc8xxx_gpio_dir_out(struct gpio_chip *gc, unsigned int gpio, int val)
>  {
>  	struct of_mm_gpio_chip *mm = to_of_mm_gpio_chip(gc);
> @@ -340,11 +348,10 @@ static void __init mpc8xxx_add_controller(struct device_node *np)
>  	mm_gc->save_regs = mpc8xxx_gpio_save_regs;
>  	gc->ngpio = MPC8XXX_GPIO_PINS;
>  	gc->direction_input = mpc8xxx_gpio_dir_in;
> -	gc->direction_output = mpc8xxx_gpio_dir_out;
> -	if (of_device_is_compatible(np, "fsl,mpc8572-gpio"))
> -		gc->get = mpc8572_gpio_get;
> -	else
> -		gc->get = mpc8xxx_gpio_get;
> +	gc->direction_output = of_device_is_compatible(np, "fsl,mpc5121-gpio") ?
> +		mpc5121_gpio_dir_out : mpc8xxx_gpio_dir_out;
> +	gc->get = of_device_is_compatible(np, "fsl,mpc8572-gpio") ?
> +		mpc8572_gpio_get : mpc8xxx_gpio_get;
>  	gc->set = mpc8xxx_gpio_set;
>  	gc->to_irq = mpc8xxx_gpio_to_irq;
>  
> -- 
> 1.7.7.1
> 
