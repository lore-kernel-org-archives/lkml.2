Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563Ab2LQRKd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 12:10:33 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:48814 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304Ab2LQRKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 12:10:30 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] serial: tegra: add serial driver
To: Laxman Dewangan <ldewangan@nvidia.com>, alan@linux.intel.com,
        gregkh@linuxfoundation.org, jslaby@suse.cz
Cc: rob.herring@calxeda.com, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-tegra@vger.kernel.org,
        swarren@wwwdotorg.org, Laxman Dewangan <ldewangan@nvidia.com>
In-Reply-To: <1355746249-15347-1-git-send-email-ldewangan@nvidia.com>
References: <1355746249-15347-1-git-send-email-ldewangan@nvidia.com>
Date: Mon, 17 Dec 2012 17:10:27 +0000
Message-Id: <20121217171027.6AE573E0BDD@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Dec 2012 17:40:49 +0530, Laxman Dewangan <ldewangan@nvidia.com> wrote:
> Nvidia's Tegra has multiple uart controller which supports:
> - APB dma based controller fifo read/write.
> - End Of Data interrupt in incoming data to know whether end
>   of frame achieve or not.
> - Hw controlled RTS and CTS flow control to reduce SW overhead.
> 
> Add serial driver to use all above feature.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>

Hi Laxman,

Comments below...

> ---
>  .../bindings/serial/nvidia,serial-tegra.txt        |   26 +
>  drivers/tty/serial/Kconfig                         |   14 +
>  drivers/tty/serial/Makefile                        |    1 +
>  drivers/tty/serial/serial_tegra.c                  | 1398 ++++++++++++++++++++
>  include/linux/serial_tegra.h                       |   33 +
>  5 files changed, 1472 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/serial/nvidia,serial-tegra.txt
>  create mode 100644 drivers/tty/serial/serial_tegra.c
>  create mode 100644 include/linux/serial_tegra.h
> 
> diff --git a/Documentation/devicetree/bindings/serial/nvidia,serial-tegra.txt b/Documentation/devicetree/bindings/serial/nvidia,serial-tegra.txt
> new file mode 100644
> index 0000000..fc5803b
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/serial/nvidia,serial-tegra.txt

Nit: nvidia-tegra.txt would be sufficient.

> @@ -0,0 +1,26 @@
> +NVIDIA Tegra20/Tegra30 high speed (dma based) UART controller driver.
> +
> +Required properties:
> +- compatible : should be "nvidia,tegra20-hsuart", "nvidia,tegra30-hsuart".
> +- reg: Should contain UART controller registers location and length.
> +- interrupts: Should contain UART controller interrupts.
> +- nvidia,dma-request-selector : The Tegra DMA controller's phandle and
> +  request selector for this UART controller.
> +- port-number: Uart port number for /dev/ttyHSx where x is port number.

Drop port-number. Use an alias instead (/aliases/serial#)

Otherwise the binding looks fine.

> diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
> index 59c23d0..57dbbc1 100644
> --- a/drivers/tty/serial/Kconfig
> +++ b/drivers/tty/serial/Kconfig
> @@ -269,6 +269,20 @@ config SERIAL_SIRFSOC_CONSOLE
>            your boot loader about how to pass options to the kernel at
>            boot time.)
>  
> +config SERIAL_SAMSUNG_UARTS_4
> +	bool

? This looks like a stale hunk

> +config SERIAL_TEGRA
> +	tristate "Nvidia Tegra20/30 SoC serial controller"
> +	depends on ARCH_TEGRA && TEGRA20_APB_DMA
> +	select SERIAL_CORE
> +	help
> +	  Support for the on-chip UARTs on the Nvidia Tegra seria SOCs
> +	  providing /dev/ttyHS0, 1, 2, 3 and 4 (note, some machines may not
> +	  provide all of these ports, depending on how the serial port
> +	  are enabled). This driver uses the APB dma to achieve higher baudrate
> +	  and better performance.
> +
>  config SERIAL_MAX3100
>  	tristate "MAX3100 support"
>  	depends on SPI
[...]
> +static void tegra_uart_set_mctrl(struct uart_port *u, unsigned int mctrl)
> +{
> +	struct tegra_uart_port *tup = to_tegra_uport(u);
> +	unsigned long mcr;
> +
> +	mcr = tup->mcr_shadow;
> +	if (mctrl & TIOCM_RTS) {
> +		tup->rts_active = true;
> +		set_rts(tup, true);
> +	} else {
> +		tup->rts_active = false;
> +		set_rts(tup, false);
> +	}

Or simply:
	tup->rts_active = !!(mctrl & TIOCM_RTS)
	set_rts(tup, tup->rts_active);

The driver seems rather verbose in this regard. It isn't something I'd
nak over, but it does increase the maintenance burden.

> +
> +	if (mctrl & TIOCM_DTR)
> +		set_dtr(tup, true);
> +	else
> +		set_dtr(tup, false);
> +	return;
> +}
> +static int __devinit tegra_uart_probe(struct platform_device *pdev)
> +{
> +	struct tegra_uart_port *tup;
> +	struct uart_port *u;
> +	struct tegra_uart_platform_data *pdata = pdev->dev.platform_data;

Since this is a new driver, and all new board support will use device
tree, when would this platform_data pointer get set? Can you drop the
platform_data support code entirely?

The driver itself is a lot of code. I've not gone through it in the
detail that I'd like to, but it appears to be fine. Fix up the above
comments and you can add my:

Reviewed-by: Grant Likely <grant.likely@secretlab.ca>

