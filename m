Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358Ab2LEWsV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 17:48:21 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:34529 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361Ab2LEWsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 17:48:19 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] gpio: twl4030: Correct status reporting when the GPIO is used as output
To: Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
In-Reply-To: <1354700985-4453-1-git-send-email-peter.ujfalusi@ti.com>
References: <1354700985-4453-1-git-send-email-peter.ujfalusi@ti.com>
Date: Wed, 05 Dec 2012 22:48:13 +0000
Message-Id: <20121205224813.584123E0E22@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Dec 2012 10:49:45 +0100, Peter Ujfalusi <peter.ujfalusi@ti.com> wrote:
> When the GPIO is configured as output we need to read the GPIODATAOUT*
> register to get correct information. When the GPIO is output the GPIODATAIN*
> registers report 0 all the time (no feedback from output path).
> 
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> ---
>  drivers/gpio/gpio-twl4030.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpio/gpio-twl4030.c b/drivers/gpio/gpio-twl4030.c
> index 55b4fe4..e7aa620 100644
> --- a/drivers/gpio/gpio-twl4030.c
> +++ b/drivers/gpio/gpio-twl4030.c
> @@ -191,13 +191,19 @@ static int twl4030_get_gpio_datain(int gpio)
>  	u8 d_bnk = gpio >> 3;
>  	u8 d_off = gpio & 0x7;
>  	u8 base = 0;
> +	int direction;
>  	int ret = 0;
>  
>  	if (unlikely((gpio >= TWL4030_GPIO_MAX)
>  		|| !(gpio_usage_count & BIT(gpio))))
>  		return -EPERM;
>  
> -	base = REG_GPIODATAIN1 + d_bnk;
> +	direction = gpio_twl4030_read(REG_GPIODATADIR1 + d_bnk);
> +	if (direction > 0 && (direction >> d_off) & 0x1)
> +		base = REG_SETGPIODATAOUT1 + d_bnk;
> +	else
> +		base = REG_GPIODATAIN1 + d_bnk;
> +

This is probably quite expensive considering that reads need to go out
the i2c bus. Things like the output state and the pin direction should
be cached by the driver in its private data structure so that you don't
add an additional i2c round trip.

g.

