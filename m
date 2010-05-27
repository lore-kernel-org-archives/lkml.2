Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757843Ab0E0RHM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 13:07:12 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57327 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754889Ab0E0RHK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 13:07:10 -0400
MIME-Version: 1.0
X-Originating-IP: [174.31.27.127]
In-Reply-To: <20100527041358.GA14070@pengutronix.de>
References: <AANLkTikzDvWakd7JW3DzTHinjS3dAlqzPx6K8V2qMDG7@mail.gmail.com>
	<AANLkTinkY8JYh44UOEPflBUDyQ2wat_AKShRjA3HPxrf@mail.gmail.com>
	<20100526235246.GA31068@pengutronix.de>
	<AANLkTikj8yGSK5Ovud_k8f6jWloojqDJmQ_H6pD_IFgM@mail.gmail.com>
	<20100527041358.GA14070@pengutronix.de>
Date: Thu, 27 May 2010 10:07:08 -0700
Message-ID: <AANLkTilKUfcYsPqr5kXlONJQAFCaE8D8U9ltQybIzCPu@mail.gmail.com>
Subject: Re: Controlling Driver Load Order
From: Robert Emanuele <rob@emanuele.us>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Linus Walleij <linus.ml.walleij@gmail.com>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfram,

I am using the i2c-gpio.c driver, not the i2c-at91 driver.  The Atmel
folks have expressed concerns over their i2c silicon and wrote a gpio
version.

Anyway, I better understand the subsys_initcall now and applied that
to the i2c-gpio and my i2c chip driver.  That worked perfectly for my
issue.  I'd be happy to return a patch of this.  Would be this the
sort of thing that would benefit from a config option?  Something
like:

#if defined(CONFIG_EARLY_i2C_GPIO)
subsys_initcall(i2c_gpio_init);
#else
module_init(i2c_gpio_init);
#endif

I appreciate your help and direction.

Thank you,

Rob

On Wed, May 26, 2010 at 9:13 PM, Wolfram Sang <w.sang@pengutronix.de> wrote:
> On Wed, May 26, 2010 at 06:39:13PM -0700, Robert Emanuele wrote:
>
>> Still the framebuffer device would initialize first and it would lack
>> having the i2c chips it needs ready.  That is the order I'm trying to
>> straighten out.
>
> Understood. Our pointers were probably not precise enough, sorry. Please try
> this patch and give a Tested-by-tag if it solves your problems.
>
> From: Wolfram Sang <w.sang@pengutronix.de>
> Date: Thu, 27 May 2010 06:03:48 +0200
> Subject: [PATCH] i2c-at91: use subsys_initcall() for early initialization
>
> I2C needs to be available early, so other subsystems can access it.
>
> Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
> Cc: Robert Emanuele <rob@emanuele.us>
> Cc: Ben Dooks <ben-linux@fluff.org>
> ---
>
>  drivers/i2c/busses/i2c-at91.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/i2c/busses/i2c-at91.c b/drivers/i2c/busses/i2c-at91.c
> index 305c075..bea5794 100644
> --- a/drivers/i2c/busses/i2c-at91.c
> +++ b/drivers/i2c/busses/i2c-at91.c
> @@ -313,13 +313,12 @@ static int __init at91_i2c_init(void)
>  {
>        return platform_driver_register(&at91_i2c_driver);
>  }
> +subsys_initcall(at91_i2c_init);
>
>  static void __exit at91_i2c_exit(void)
>  {
>        platform_driver_unregister(&at91_i2c_driver);
>  }
> -
> -module_init(at91_i2c_init);
>  module_exit(at91_i2c_exit);
>
>  MODULE_AUTHOR("Rick Bronson");
>
>
> --
> Pengutronix e.K.                           | Wolfram Sang                |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
>
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.9 (GNU/Linux)
>
> iEYEARECAAYFAkv98YYACgkQD27XaX1/VRsvlwCffUOH2qAsWbaG2EmIf1Cl2H+I
> 8P4AoInnCS69XCfq6wIFku1hUgeT8hlG
> =vGcD
> -----END PGP SIGNATURE-----
>
>
