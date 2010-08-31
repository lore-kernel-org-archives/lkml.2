Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756960Ab0HaID7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 04:03:59 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:44468 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756943Ab0HaIDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 04:03:47 -0400
Date: Tue, 31 Aug 2010 02:03:44 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Benjamin Herrenschmidt <benh@au1.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH] gpiolib: Add 'struct gpio_chip' forward declaration
 for !GPIOLIB case
Message-ID: <20100831080344.GA20515@angua.secretlab.ca>
References: <1282631168.22370.517.camel@pasglop>
 <20100824092623.GA20334@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100824092623.GA20334@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 24, 2010 at 01:26:23PM +0400, Anton Vorontsov wrote:
> With CONFIG_GPIOLIB=n, the 'struct gpio_chip' is not declared,
> so the following pops up on PowerPC:
> 
>   cc1: warnings being treated as errors
>   In file included from arch/powerpc/platforms/52xx/mpc52xx_common.c:19:
>   include/linux/of_gpio.h:74: warning: 'struct gpio_chip' declared
>                               inside parameter list
>   include/linux/of_gpio.h:74: warning: its scope is only this definition
>                               or declaration, which is probably not what
> 			      you want
>   include/linux/of_gpio.h:75: warning: 'struct gpio_chip' declared
>                               inside parameter list
>   make[2]: *** [arch/powerpc/platforms/52xx/mpc52xx_common.o] Error 1
> 
> This patch fixes the issue by providing the proper forward declaration.
> 
> Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>

This doesn't actually solve the problem, and gpiochip should remain undefined when CONFIG_GPIOLIB=n to catch exactly these build failures.  The real problem is that I merged a change into the mpc5200 code that required CONFIG_GPIOLIB be enabled without reflecting that requirement in Kconfig.

g.

> ---
> 
> On Tue, Aug 24, 2010 at 04:26:08PM +1000, Benjamin Herrenschmidt wrote:
> > I get that with my current stuff:
> > 
> > cc1: warnings being treated as errors
> > In file included from [..]/mpc52xx_common.c:19:
> > of_gpio.h:74: error: ‘struct gpio_chip’ declared inside parameter list
> [...]
> > make[3]: *** Waiting for unfinished jobs....
> 
> That's because with GPIOCHIP=n no one declares struct gpio_chip.
> 
> It should be either of_gpio.h or gpio.h. Let's make it gpio.h, as
> this feels more generic, and we already have some !GPIOLIB handling
> in there.
> 
>  include/linux/gpio.h |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/gpio.h b/include/linux/gpio.h
> index 03f616b..85207d2 100644
> --- a/include/linux/gpio.h
> +++ b/include/linux/gpio.h
> @@ -15,6 +15,12 @@
>  struct device;
>  
>  /*
> + * Some code might rely on the declaration. Still, it is illegal
> + * to dereference it for !GPIOLIB case.
> + */
> +struct gpio_chip;
> +
> +/*
>   * Some platforms don't support the GPIO programming interface.
>   *
>   * In case some driver uses it anyway (it should normally have
> -- 
> 1.7.0.5
> 
