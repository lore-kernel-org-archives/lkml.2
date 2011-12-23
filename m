Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667Ab1LWKf6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 05:35:58 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:64005 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756551Ab1LWKf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 05:35:56 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Uwe =?utf-8?q?Kleine-K=C3=B6nig?=" <u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH] serial/efm32: add new driver
Date: Fri, 23 Dec 2011 10:35:22 +0000
User-Agent: KMail/1.12.2 (Linux/3.2.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        devicetree-discuss@lists.ozlabs.org,
        "Greg Kroah-Hartman" <gregkh@suse.de>, kernel@pengutronix.de,
        linux-serial@vger.kernel.org
References: <20111221202847.4ffeba10@bob.linux.org.uk> <1324561092-1945-1-git-send-email-u.kleine-koenig@pengutronix.de>
In-Reply-To: <1324561092-1945-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201112231035.23215.arnd@arndb.de>
X-Provags-ID: V02:K0:vL76epLrH95jsiXFRvp6PI7+pohJj7Z0nbbGS3dbDIf
 a0wB2Ur8vD1y9g5dDMtj1Vq9ZiZG71fQHzmetzyCyOWgJmI6Bu
 n+3C3V8BDa0hKKr6sUt3GuE6hKHK2i7QbS8b9MmfbjJuW7U2Wg
 b2VK5VO6rfQWhbA0+gcDrBt8OTFp5p1V/EwbVkOmLbajPVC9N1
 1JpcR4EstOI7MHWnoP7WYidWhvTR7l614L1j29ZFA5gSGfe1q9
 PYvgk0t8QulrsyDvA0+tXPnsB66Kb2JaAf6bPfh8twF80y093H
 +e97Z6K1wrmOpEuM6TNbjkmsyc7HiSxO6opqdrZ4wg+AklC/gE
 g/0qw9g1Q/1gk1UDtNzs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 December 2011, Uwe Kleine-König wrote:

> @@ -0,0 +1,14 @@
> +* Energymicro efm32 UART
> +
> +Required properties:
> +- compatible : Should be "efm32,usart"
> +- reg : Address and length of the register set
> +- interrupts : Should contain uart interrupt
> +
> +Example:
> +
> +uart@0x4000c400 {
> +	compatible = "efm32,usart";
> +	reg = <0x4000c400 0x400>;
> +	interrupts = <15>;
> +};

Do you know if the usart was actually designed by energymicro or licensed
from another party? If it is a licensed part, it would be better to
list the "compatible" value under the company name that made it.

I would suggest that you also support the "clock-frequency" and/or
"current-speed" properties that are defined for serial ports, see the
of_serial driver.

> diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
> index 925a1e5..cfeb0f3 100644
> --- a/drivers/tty/serial/Kconfig
> +++ b/drivers/tty/serial/Kconfig
> @@ -1610,4 +1610,14 @@ config SERIAL_XILINX_PS_UART_CONSOLE
>  	help
>  	  Enable a Xilinx PS UART port to be the system console.
>  
> +config SERIAL_EFM32_USART
> +	bool "EFM32 USART port."
> +	depends on ARCH_EFM32
> +	select SERIAL_CORE

Why not tristate? If it's not a console, you should be able to use
it as a module.

I would generally prefer not to make the driver depend on the
platform, so we can get better compile time coverage. I think a better
set of dependencies would be

	depends on HAVE_CLK
	depends on OF
	default ARCH_EFM32

> +static void efm32_usart_write32(struct efm32_usart_port *efm_port,
> +		u32 value, unsigned offset)
> +{
> +	__raw_writel(value, efm_port->port.membase + offset);
> +}
> +
> +static u32 efm32_usart_read32(struct efm32_usart_port *efm_port,
> +		unsigned offset)
> +{
> +	return __raw_readl(efm_port->port.membase + offset);
> +}

Please use writel_relaxed() instead of __raw_writel().

> +static int __devinit efm32_usart_probe(struct platform_device *pdev)
> +{
> +	struct efm32_usart_port *efm_port;
> +	struct resource *res;
> +	int ret;
> +
> +	efm_port = kzalloc(sizeof(*efm_port), GFP_KERNEL);
> +	if (!efm_port) {
> +		dev_dbg(&pdev->dev, "failed to allocate private data\n");
> +		return -ENOMEM;
> +	}
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res) {
> +		ret = -ENODEV;
> +		dev_dbg(&pdev->dev, "failed to determine base address\n");
> +		goto err_get_base;
> +	}
> +
> +	if (resource_size(res) < 60) {
> +		ret = -EINVAL;
> +		dev_dbg(&pdev->dev, "memory resource too small\n");
> +		goto err_too_small;
> +	}

of_iomap() would be simpler here. I think you can leave out the assignment to 
mapbase, and go straight to membase here.

checking the resource size should not be necessary, because that would imply
having an invalid device tree, which you don't have to check at run time.

	Arnd
