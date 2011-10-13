Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737Ab1JMC0z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 22:26:55 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:54906 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488Ab1JMCZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 22:25:38 -0400
Date: Wed, 12 Oct 2011 19:04:02 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, devicetree-discuss@lists.ozlabs.org,
        robherring2@gmail.com, claudio@evidence.eu.com,
        jesper.nilsson@axis.com, alan@lxorguk.ukuu.org.uk,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH v2 5/5] tty/serial: atmel_serial: add device tree support
Message-ID: <20111013010402.GP14042@ponder.secretlab.ca>
References: <37a19e194d02144aecd24f284f5e43979643a3c3.1318433947.git.nicolas.ferre@atmel.com>
 <46ce59e472d36715d8bed57570d2b7747323f4d4.1318433947.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46ce59e472d36715d8bed57570d2b7747323f4d4.1318433947.git.nicolas.ferre@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 12, 2011 at 06:07:00PM +0200, Nicolas Ferre wrote:
> Will use aliases to enumerate ports, if available.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Acked-by: Grant Likely <grant.likely@secretlab.ca>

> ---
>  drivers/tty/serial/atmel_serial.c |   79 +++++++++++++++++++++++++++++++++----
>  1 files changed, 71 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
> index 1074329..fc4081e 100644
> --- a/drivers/tty/serial/atmel_serial.c
> +++ b/drivers/tty/serial/atmel_serial.c
> @@ -33,6 +33,8 @@
>  #include <linux/sysrq.h>
>  #include <linux/tty_flip.h>
>  #include <linux/platform_device.h>
> +#include <linux/of.h>
> +#include <linux/of_device.h>
>  #include <linux/dma-mapping.h>
>  #include <linux/atmel_pdc.h>
>  #include <linux/atmel_serial.h>
> @@ -163,6 +165,16 @@ static unsigned long atmel_ports_in_use;
>  static struct console atmel_console;
>  #endif
>  
> +#if defined(CONFIG_OF)
> +static const struct of_device_id atmel_serial_dt_ids[] = {
> +	{ .compatible = "atmel,at91rm9200-usart" },
> +	{ .compatible = "atmel,at91sam9260-usart" },
> +	{ /* sentinel */ }
> +};
> +
> +MODULE_DEVICE_TABLE(of, atmel_serial_dt_ids);
> +#endif
> +
>  static inline struct atmel_uart_port *
>  to_atmel_uart_port(struct uart_port *uart)
>  {
> @@ -1411,6 +1423,48 @@ static struct uart_ops atmel_pops = {
>  #endif
>  };
>  
> +static void __devinit atmel_of_init_port(struct atmel_uart_port *atmel_port,
> +					 struct device_node *np)
> +{
> +	u32 rs485_delay[2];
> +
> +	/* DMA/PDC usage specification */
> +	if (of_get_property(np, "atmel,use-dma-rx", NULL))
> +		atmel_port->use_dma_rx	= 1;
> +	else
> +		atmel_port->use_dma_rx	= 0;
> +	if (of_get_property(np, "atmel,use-dma-tx", NULL))
> +		atmel_port->use_dma_tx	= 1;
> +	else
> +		atmel_port->use_dma_tx	= 0;
> +
> +	/* rs485 properties */
> +	if (of_property_read_u32_array(np, "rs485-rts-delay",
> +					    rs485_delay, 2) == 0) {
> +		struct serial_rs485 *rs485conf = &atmel_port->rs485;
> +
> +		rs485conf->delay_rts_before_send = rs485_delay[0];
> +		rs485conf->delay_rts_after_send = rs485_delay[1];
> +		rs485conf->flags = 0;
> +
> +		if (rs485conf->delay_rts_before_send == 0 &&
> +		    rs485conf->delay_rts_after_send == 0) {
> +			rs485conf->flags |= SER_RS485_RTS_ON_SEND;
> +		} else {
> +			if (rs485conf->delay_rts_before_send)
> +				rs485conf->flags |= SER_RS485_RTS_BEFORE_SEND;
> +			if (rs485conf->delay_rts_after_send)
> +				rs485conf->flags |= SER_RS485_RTS_AFTER_SEND;
> +		}
> +
> +		if (of_get_property(np, "rs485-rx-during-tx", NULL))
> +			rs485conf->flags |= SER_RS485_RX_DURING_TX;
> +
> +		if (of_get_property(np, "linux,rs485-enabled-at-boot-time", NULL))
> +			rs485conf->flags |= SER_RS485_ENABLED;
> +	}
> +}
> +
>  /*
>   * Configure the port from the platform device resource info.
>   */
> @@ -1420,6 +1474,14 @@ static void __devinit atmel_init_port(struct atmel_uart_port *atmel_port,
>  	struct uart_port *port = &atmel_port->uart;
>  	struct atmel_uart_data *pdata = pdev->dev.platform_data;
>  
> +	if (pdev->dev.of_node) {
> +		atmel_of_init_port(atmel_port, pdev->dev.of_node);
> +	} else {
> +		atmel_port->use_dma_rx	= pdata->use_dma_rx;
> +		atmel_port->use_dma_tx	= pdata->use_dma_tx;
> +		atmel_port->rs485	= pdata->rs485;
> +	}
> +
>  	port->iotype		= UPIO_MEM;
>  	port->flags		= UPF_BOOT_AUTOCONF;
>  	port->ops		= &atmel_pops;
> @@ -1433,7 +1495,7 @@ static void __devinit atmel_init_port(struct atmel_uart_port *atmel_port,
>  
>  	memset(&atmel_port->rx_ring, 0, sizeof(atmel_port->rx_ring));
>  
> -	if (pdata->regs) {
> +	if (pdata && pdata->regs) {
>  		/* Already mapped by setup code */
>  		port->membase = pdata->regs;
>  	} else {
> @@ -1450,10 +1512,6 @@ static void __devinit atmel_init_port(struct atmel_uart_port *atmel_port,
>  		/* only enable clock when USART is in use */
>  	}
>  
> -	atmel_port->use_dma_rx	= pdata->use_dma_rx;
> -	atmel_port->use_dma_tx	= pdata->use_dma_tx;
> -	atmel_port->rs485	= pdata->rs485;
> -
>  	/* Use TXEMPTY for interrupt when rs485 else TXRDY or ENDTX|TXBUFE */
>  	if (atmel_port->rs485.flags & SER_RS485_ENABLED)
>  		atmel_port->tx_done_mask = ATMEL_US_TXEMPTY;
> @@ -1718,17 +1776,21 @@ static int atmel_serial_resume(struct platform_device *pdev)
>  static int __devinit atmel_serial_probe(struct platform_device *pdev)
>  {
>  	struct atmel_uart_port *port;
> +	struct device_node *np = pdev->dev.of_node;
>  	struct atmel_uart_data *pdata = pdev->dev.platform_data;
>  	void *data;
>  	int ret = -ENODEV;
>  
>  	BUILD_BUG_ON(ATMEL_SERIAL_RINGSIZE & (ATMEL_SERIAL_RINGSIZE - 1));
>  
> -	if (pdata)
> -		ret = pdata->num;
> +	if (np)
> +		ret = of_alias_get_id(np, "serial");
> +	else
> +		if (pdata)
> +			ret = pdata->num;
>  
>  	if (ret < 0)
> -		/* port id not found in platform data:
> +		/* port id not found in platform data nor device-tree aliases:
>  		 * auto-enumerate it */
>  		ret = find_first_zero_bit(&atmel_ports_in_use,
>  				sizeof(atmel_ports_in_use));
> @@ -1827,6 +1889,7 @@ static struct platform_driver atmel_serial_driver = {
>  	.driver		= {
>  		.name	= "atmel_usart",
>  		.owner	= THIS_MODULE,
> +		.of_match_table	= of_match_ptr(atmel_serial_dt_ids),
>  	},
>  };
>  
> -- 
> 1.7.5.4
> 
