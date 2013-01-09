Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758116Ab3AIWau (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 17:30:50 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:52532 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758044Ab3AIWat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 17:30:49 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH 02/10] goldfish: add the goldfish virtual bus
Date: Wed, 9 Jan 2013 22:30:40 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: arve@android.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        mikechan@google.com
References: <20130109142212.9239.62026.stgit@bob.linux.org.uk> <20130109142305.9239.37581.stgit@bob.linux.org.uk>
In-Reply-To: <20130109142305.9239.37581.stgit@bob.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201301092230.40331.arnd@arndb.de>
X-Provags-ID: V02:K0:yxlayqG5+9lqWlN7gVfsoACTvb7pzpLJcRQ02jjc/6f
 kQ6eXpGE16iL0hdxI0nEY9/dUGoAlHTESCszagXxEkkiUqEfHm
 xMwG/idn7EO9J4vuTRT8bUvYzG8duh4PBaZk7KjpMDvdV1Xwu1
 HcAZI/MYu0SFmjqvi7RINoN2fHINUiFetHJ30wbnq1uTYz8ww4
 gS5rnf+L4KMF2dN95QHEAjzh53P1/DLt7OU66UEhTyrA3BKEB2
 TvYRA+QEtMRGKTzV3+sUv4VVXyWu724x3sgvgmeLCMlHki6bC1
 ly71kk074F15nQEGFd/lHxKgV3a25jthTYFFzuSB3216ESWKjm
 TTBDkQfhrBK4e1urX3Pg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 January 2013, Alan Cox wrote:
> From: Jun Nakajima <jnakajim@gmail.com>
> 
> This imports the current Google code and cleans it up slightly to use pr_ and
> to properly request its resources.
> 
> Goldfish is an emulator used for Android development. It has a virtual bus where
> the emulator passes platform device information to the guest which then creates
> the appropriate devices.
> 
> This part of the emulation is not architecture specific so should not be hiding
> in architecture trees as it does in the Google Android tree. The constants it
> uses do depend on the platform and so live in arch/goldfish.h

Ah, quite nice.

>  drivers/platform/Makefile            |    1 
>  drivers/platform/goldfish/Makefile   |    4 +
>  drivers/platform/goldfish/pdev_bus.c |  265 ++++++++++++++++++++++++++++++++++
>  3 files changed, 270 insertions(+)

Maybe drivers/bus would be more appropriate though. Every platform
handles platforms differently, and x86 seems to be the only one that
likes the model of putting stuff under drivers/platform.

> +static int __devexit goldfish_pdev_bus_remove(struct platform_device *pdev)
> +{
> +	free_irq(pdev_bus_irq, pdev);
> +	release_region(pdev_bus_addr, GOLDFISH_IO_SIZE);
> +	return 0;
> +}
> +
> +static struct platform_driver goldfish_pdev_bus_driver = {
> +	.probe = goldfish_pdev_bus_probe,
> +	.remove = __devexit_p(goldfish_pdev_bus_remove),
> +	.driver = {
> +		.name = "goldfish_pdev_bus"
> +	}
> +};

__devinit/__devexit are going away, so you can skip adding them
for new code.

> +
> +static int __init goldfish_pdev_bus_init(void)
> +{
> +	return platform_driver_register(&goldfish_pdev_bus_driver);
> +}
> +
> +static void __exit goldfish_pdev_bus_exit(void)
> +{
> +	platform_driver_unregister(&goldfish_pdev_bus_driver);
> +}
> +
> +module_init(goldfish_pdev_bus_init);
> +module_exit(goldfish_pdev_bus_exit);

The module_platform_driver() macro takes care of this.

> +static struct resource goldfish_pdev_bus_resources[] = {
> +	{
> +		.start  = GOLDFISH_PDEV_BUS_BASE,
> +		.end    = GOLDFISH_PDEV_BUS_BASE + GOLDFISH_PDEV_BUS_END - 1,
> +		.flags  = IORESOURCE_IO,
> +	},
> +	{
> +		.start	= GOLDFISH_PDEV_BUS_IRQ,
> +		.end	= GOLDFISH_PDEV_BUS_IRQ,
> +		.flags	= IORESOURCE_IRQ,
> +	}
> +};
> +
> +struct platform_device goldfish_pdev_bus_device = {
> +	.name = "goldfish_pdev_bus",
> +	.id = -1,
> +	.num_resources = ARRAY_SIZE(goldfish_pdev_bus_resources),
> +	.resource = goldfish_pdev_bus_resources
> +};
> +
> +static int __init goldfish_init(void)
> +{
> +	return platform_device_register(&goldfish_pdev_bus_device);
> +}
> +device_initcall(goldfish_init);

This is the part that I think should actually be part of the architecture
tree. That way, no architecture specific header files will be necessary,
and it's possible to create the platform device differently, e.g. from
devicetree on architectures that support it, or from ACPI.

Note that statically declaring a platform device is not recommended any
more, a call to platform_device_register_simple() makes this code
simpler and smaller, and allows proper reference counting on the device.

	Arnd
