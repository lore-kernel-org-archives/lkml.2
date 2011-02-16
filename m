Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691Ab1BPEcJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 23:32:09 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55907 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324Ab1BPEcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 23:32:06 -0500
Date: Tue, 15 Feb 2011 21:32:01 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Tobias Klauser <tklauser@distanz.ch>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-serial@vger.kernel.org,
        nios2-dev@sopc.et.ntust.edu.tw, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] tty: serial: altera_uart: Add devicetree support
Message-ID: <20110216043201.GA11684@angua.secretlab.ca>
References: <cover.1297245277.git.tklauser@distanz.ch>
 <c7a7085602687d2f1b6ac505c030f19bafda04e3.1297245277.git.tklauser@distanz.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c7a7085602687d2f1b6ac505c030f19bafda04e3.1297245277.git.tklauser@distanz.ch>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 09, 2011 at 10:58:13AM +0100, Tobias Klauser wrote:
> With the recent switch of the (currently still out-of-tree) Nios2 Linux
> port to devicetree we want to be able to retreive the resources and
> properties from dts.
> 
> The old method to retreive resources and properties from platform data
> is still supported.
> 
> Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
> ---
>  .../devicetree/bindings/serial/altera_uart.txt     |    7 +++
>  drivers/tty/serial/altera_uart.c                   |   47 ++++++++++++++++++--
>  2 files changed, 50 insertions(+), 4 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/serial/altera_uart.txt
> 
> diff --git a/Documentation/devicetree/bindings/serial/altera_uart.txt b/Documentation/devicetree/bindings/serial/altera_uart.txt
> new file mode 100644
> index 0000000..2ab151c
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/serial/altera_uart.txt
> @@ -0,0 +1,7 @@
> +Altera UART
> +
> +Required properties:
> +- compatible : should be "ALTR,uart-1.0"
> + 
> +Optional properties:
> +- clock-frequency : frequency of the clock input to the UART
> diff --git a/drivers/tty/serial/altera_uart.c b/drivers/tty/serial/altera_uart.c
> index 3a57352..5b46ca7 100644
> --- a/drivers/tty/serial/altera_uart.c
> +++ b/drivers/tty/serial/altera_uart.c
> @@ -24,6 +24,7 @@
>  #include <linux/serial.h>
>  #include <linux/serial_core.h>
>  #include <linux/platform_device.h>
> +#include <linux/of.h>
>  #include <linux/io.h>
>  #include <linux/altera_uart.h>
>  
> @@ -507,6 +508,34 @@ static struct uart_driver altera_uart_driver = {
>  	.cons		= ALTERA_UART_CONSOLE,
>  };
>  
> +#ifdef CONFIG_OF
> +static int altera_uart_get_uartclk(struct platform_device *pdev,
> +				   struct uart_port *port)
> +{
> +	const __be32 *clk = of_get_property(pdev->dev.of_node, "clock-frequency", NULL);
> +
> +	if (!clk)
> +		return -ENODEV;
> +
> +	port->uartclk = be32_to_cpup(clk);
> +
> +	return 0;
> +}
> +#else
> +static int altera_uart_get_uartclk(struct platform_device *pdev,
> +				   struct uart_port *port)
> +{
> +	struct altera_uart_platform_uart *platp = pdev->dev.platform_data;
> +
> +	if (!platp)
> +		return -ENODEV;
> +
> +	port->uartclk = platp->uartclk;
> +
> +	return 0;
> +}
> +#endif /* CONFIG_OF */

This either/or situation isn't really desirable.  The driver should be
written so that platform_data works regardless of whether or not
CONFIG_OF is set.  So, if the of_node pointer is set, use it to get
the configuration, but fall back to platform data if it is NULL.

> +
>  static int __devinit altera_uart_probe(struct platform_device *pdev)
>  {
>  	struct altera_uart_platform_uart *platp = pdev->dev.platform_data;
> @@ -514,6 +543,7 @@ static int __devinit altera_uart_probe(struct platform_device *pdev)
>  	struct resource *res_mem;
>  	struct resource *res_irq;
>  	int i = pdev->id;
> +	int ret;
>  
>  	/* -1 emphasizes that the platform must have one port, no .N suffix */
>  	if (i == -1)
> @@ -538,6 +568,10 @@ static int __devinit altera_uart_probe(struct platform_device *pdev)
>  	else if (platp->irq)
>  		port->irq = platp->irq;
>  
> +	ret = altera_uart_get_uartclk(pdev, port);
> +	if (ret)
> +		return ret;
> +
>  	port->membase = ioremap(port->mapbase, ALTERA_UART_SIZE);
>  	if (!port->membase)
>  		return -ENOMEM;
> @@ -550,7 +584,6 @@ static int __devinit altera_uart_probe(struct platform_device *pdev)
>  	port->line = i;
>  	port->type = PORT_ALTERA_UART;
>  	port->iotype = SERIAL_IO_MEM;
> -	port->uartclk = platp->uartclk;
>  	port->ops = &altera_uart_ops;
>  	port->flags = UPF_BOOT_AUTOCONF;
>  
> @@ -573,13 +606,19 @@ static int __devexit altera_uart_remove(struct platform_device *pdev)
>  	return 0;
>  }
>  
> +static struct of_device_id altera_uart_match[] = {
> +	{ .compatible = "altr,uart-1.0", },
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, altera_uart_match);

Need to protect the MODULE_DEVICE_TABLE with #ifdef/#endif.  You don't
want to advertise device tree support when CONFIG_OF isn't selected.

> +
>  static struct platform_driver altera_uart_platform_driver = {
>  	.probe	= altera_uart_probe,
>  	.remove	= __devexit_p(altera_uart_remove),
>  	.driver	= {
> -		.name	= DRV_NAME,
> -		.owner	= THIS_MODULE,
> -		.pm	= NULL,
> +		.name		= DRV_NAME,
> +		.owner		= THIS_MODULE,
> +		.of_match_table	= altera_uart_match,
>  	},
>  };
>  
> -- 
> 1.7.0.4
> 
