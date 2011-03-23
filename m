Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932542Ab1CWOmj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 10:42:39 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:57779 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756097Ab1CWOmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 10:42:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Par-Gunnar Hjalmdahl" <par-gunnar.p.hjalmdahl@stericsson.com>
Subject: Re: [PATCH 2/2] mach-ux500: Add CG2900 devices
Date: Wed, 23 Mar 2011 15:42:28 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, devel@driverdev.osuosl.org,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, Pavan Savoy <pavan_savoy@sify.com>,
        Vitaly Wool <vitalywool@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Marcel Holtmann <marcel@holtmann.org>,
        Lukasz Rymanowski <Lukasz.Rymanowski@tieto.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        "Par-Gunnar Hjalmdahl" <pghatwork@gmail.com>,
        Lee Jones <lee.jones@linaro.org>
References: <1300888803-26474-1-git-send-email-par-gunnar.p.hjalmdahl@stericsson.com>
In-Reply-To: <1300888803-26474-1-git-send-email-par-gunnar.p.hjalmdahl@stericsson.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201103231542.28311.arnd@arndb.de>
X-Provags-ID: V02:K0:g1DMIvKl9u8gBiYBavDkJ6N++eCLZ04RHow11tsDqv7
 2r2O4TozMoXu82GJYwzwHMM8zEORme/CDWkRxTwuC0GzsZxda9
 KN3DjxJ3nBRCGb0MFkNKPpdU+y+pICJY2iHIlvWz4xc2pwOuJi
 1/9fR8Uk32Z3INV7y9pDtgqMg5A07tVfwK525rilWihRMoqQ7q
 6lhsvu3llQNMV8J4e/+rQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 March 2011, Par-Gunnar Hjalmdahl wrote:

> This patch adds the board specific data for the CG2900
> driver on a UX500 board.

Thanks for the follow-up in staging. I hope this will make the work
of getting this driver into shape done more easily as we have a
code base to discuss.

> diff --git a/arch/arm/mach-ux500/Makefile b/arch/arm/mach-ux500/Makefile
> index b549a8f..47c92fa 100644
> --- a/arch/arm/mach-ux500/Makefile
> +++ b/arch/arm/mach-ux500/Makefile
> @@ -2,6 +2,9 @@
>  # Makefile for the linux kernel, U8500 machine.
>  #
>  
> +ccflags-y :=					\
> +	-Idrivers/staging/cg2900/include
> +
>  obj-y				:= clock.o cpu.o devices.o devices-common.o \
>  				   id.o usb.o

Could we keep this more self-contained? Just register a
single device with the necessary resources and let the
staging driver figure out how to initialize it, rather
than splitting it between mach-ux500 and drivers/staging.

> +#ifdef CONFIG_CG2900
> +#define CG2900_BT_ENABLE_GPIO		170
> +#define CG2900_GBF_ENA_RESET_GPIO	171
> +#define CG2900_BT_CTS_GPIO		0

Don't make hardware definitions depending on Kconfig symbols.
Just describe what the hardware looks like if present, and
let the board code figure out if it's actually there.

> +static struct platform_device ux500_cg2900_device = {
> +	.name = "cg2900",
> +};
> +
> +#ifdef CONFIG_CG2900_CHIP
> +static struct platform_device ux500_cg2900_chip_device = {
> +	.name = "cg2900-chip",
> +	.dev = {
> +		.parent = &ux500_cg2900_device.dev,
> +	},
> +};
> +#endif /* CONFIG_CG2900_CHIP */
> +
> +#ifdef CONFIG_STLC2690_CHIP
> +static struct platform_device ux500_stlc2690_chip_device = {
> +	.name = "stlc2690-chip",
> +	.dev = {
> +		.parent = &ux500_cg2900_device.dev,
> +	},
> +};
> +#endif /* CONFIG_STLC2690_CHIP */
> +
> +#ifdef CONFIG_CG2900_TEST
> +static struct cg2900_platform_data cg2900_test_platform_data = {
> +	.bus = HCI_VIRTUAL,
> +	.gpio_sleep = cg2900_sleep_gpio,
> +};

Also, don't make the device registration dependent on the Kconfig.
Make sure that the hardware is there by asking the hardware, then
register it, even if we don't compile the driver using it.

I assume that this would get much simpler if you register everything
from the .probe function of the main "cg2900" device.

> diff --git a/arch/arm/mach-ux500/devices-cg2900.c b/arch/arm/mach-ux500/devices-cg2900.c
> new file mode 100644
> index 0000000..525c871
> --- /dev/null
> +++ b/arch/arm/mach-ux500/devices-cg2900.c

As far as I can tell, everything in this file can simply become part of the
staging driver. I'm fine with basically anything that compiles going into
drivers/staging, but we should keep the platform code outside of staging
clean of stuff that might have to change as part of the staging process.

	Arnd
