Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796Ab2GWOoF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 10:44:05 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:42385 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294Ab2GWOoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 10:44:03 -0400
Message-ID: <500D632B.3000206@gmail.com>
Date: Mon, 23 Jul 2012 16:43:55 +0200
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Daniel Mack <zonque@gmail.com>
CC: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] gpiolib: fix chip->base handling in of_gpio_simple_xlate()
References: <1342977052-7880-1-git-send-email-zonque@gmail.com>
In-Reply-To: <1342977052-7880-1-git-send-email-zonque@gmail.com>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Cc: Arnd)

On 22.07.2012 19:10, Daniel Mack wrote:
> of_gpio_simple_xlate() is called for each chip when a GPIO is looked up.
> When registering several chips off the same DT node (with different pin
> offsets) however, the lookup fails as the GPIO number passed in to
> of_gpio_simple_xlate() is likely higher than the chip's ->ngpio value.
> 
> Fix that by taking into account the chip's ->base value, and return the
> relative offset of the pin inside the chip.
> 
> Signed-off-by: Daniel Mack <zonque@gmail.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Linus Walleij <linus.walleij@stericsson.com>
> ---
> 
> I'm currently porting the PXA pieces over to DT, and stumbled over what
> looks like an obvious bug to me. Correct me if I'm mistaken, but I see
> no reason why one shouldn't be able to instanciate several GPIO chips
> from a single DT node.
> 
> Thanks,
> Daniel
> 
>  drivers/gpio/gpiolib-of.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
> index d18068a..51bc232 100644
> --- a/drivers/gpio/gpiolib-of.c
> +++ b/drivers/gpio/gpiolib-of.c
> @@ -147,13 +147,13 @@ int of_gpio_simple_xlate(struct gpio_chip *gc,
>  	if (WARN_ON(gpiospec->args_count < gc->of_gpio_n_cells))
>  		return -EINVAL;
>  
> -	if (gpiospec->args[0] >= gc->ngpio)
> +	if (gpiospec->args[0] >= gc->ngpio + gc->base)
>  		return -EINVAL;
>  
>  	if (flags)
>  		*flags = gpiospec->args[1];
>  
> -	return gpiospec->args[0];
> +	return gpiospec->args[0] - gc->base;
>  }
>  EXPORT_SYMBOL(of_gpio_simple_xlate);
>  
> 


