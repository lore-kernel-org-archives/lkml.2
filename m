Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051Ab0EUKEi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 06:04:38 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44552 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752476Ab0EUKEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 06:04:36 -0400
Date: Fri, 21 May 2010 11:11:36 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: felipe.balbi@nokia.com
Cc: David Brownell <david-b@pacbell.net>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/5] gpiolib: introduce set_debounce method
Message-ID: <20100521111136.53dba6c9@lxorguk.ukuu.org.uk>
In-Reply-To: <20100521064925.GF925@nokia.com>
References: <20100520194509.GB10739@sirena.org.uk>
	<598314.1671.qm@web180305.mail.gq1.yahoo.com>
	<20100521064925.GF925@nokia.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index cd85fd1..ed1ed74 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -1461,9 +1461,14 @@ int gpio_set_debounce(unsigned gpio, unsigned debounce)
>   
>          spin_lock_irqsave(&gpio_lock, flags);
>   
> +       chip = desc->chip;
> +       if (!(chip->flags & GPIO_FLAG_DEBOUNCE)) {
> +               spin_unlock_irqrestore(&gpio_lock, flags);
> +               return 0;
> +       }
> +

If you add the feature check then presumably someone trying to do
debounce on a port without the feature isn't paying attention so this
should WARN at the very least. Also it shouldn't be a return 0.

This however seems a bit excessive and inconsistent. Every other function
simply returns -EINVAL if the request is unsupported. So not only does it
complicate the code it makes the code inconsistent with its existing
regular behaviour. The initial patch is consistent, regular and follows
expected gpiolib behaviour in all respects.

> that could be used later for adding debounce emulation for chips that 
> doesn't support hw debouncing.

You don't need flags for this - the request will just start working if
someone adds the feature.

GPIO is almost always fairly tightly platform bound so features only
existing on certain ports is fine. The platform vendor will have made
sure they relevant ports have suitable debounce facilities.

Alan
