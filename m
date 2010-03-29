Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249Ab0C2Tng (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 15:43:36 -0400
Received: from mail.bluewatersys.com ([202.124.120.130]:41375 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752859Ab0C2Tne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 15:43:34 -0400
Message-ID: <4BB10304.6090006@bluewatersys.com>
Date: Tue, 30 Mar 2010 08:44:04 +1300
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Claudio Scordino <claudio@evidence.eu.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       John Nicholls <john@thinlinx.com>, Rick Bronson <rick@efn.org>,
       Sebastian Heutling <Sebastian.Heutling@who-ing.de>,
       michael trimarchi <michael@evidence.eu.com>, alan@lxorguk.ukuu.org.uk,
       rmk@arm.linux.org.uk, hskinnemoen@atmel.com, linux@maxim.org.za
Subject: Re: [PATCH] atmel_serial: Atmel RS485 support v2
References: <4BB053C4.7050700@evidence.eu.com>
In-Reply-To: <4BB053C4.7050700@evidence.eu.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Claudio Scordino wrote:
> Hi all,
> 
>    this is the new version of the patch to add RS485 support to the
>    atmel_serial driver. It's been changed according to Ryan Mallon's
>    comments.
> 
> This new patch has been tested again (with and without DMA) by Sebastian
> Heutling (CC:-ed).

A few more, mostly nitpicky, comments below.

> Many thanks to all,
> 
>            Claudio
> 
> 
> atmel_serial: Atmel RS485 support
> 
> Signed-off-by: Claudio Scordino <claudio@evidence.eu.com>
> Signed-off-by: Michael Trimarchi <michael@evidence.eu.com>
> Signed-off-by: Rick Bronson <rick@efn.org>
> Signed-off-by: Sebastian Heutling <Sebastian.Heutling@who-ing.de>
> ---
>  arch/arm/include/asm/ioctls.h           |    2 +
>  arch/arm/mach-at91/include/mach/board.h |    2 +
>  drivers/serial/atmel_serial.c           |  244 ++++++++++++++++++++++++++-----
>  3 files changed, 212 insertions(+), 36 deletions(-)
> 
> diff --git a/arch/arm/include/asm/ioctls.h b/arch/arm/include/asm/ioctls.h
> index a91d8a1..82f2177 100644
> --- a/arch/arm/include/asm/ioctls.h
> +++ b/arch/arm/include/asm/ioctls.h
> @@ -70,6 +70,8 @@
>  #define TIOCGICOUNT	0x545D	/* read serial port inline interrupt counts */
>  #define FIOQSIZE	0x545E
>  
> +#define TIOCSRS485	0x5461
> +
>  /* Used for packet mode */
>  #define TIOCPKT_DATA		 0
>  #define TIOCPKT_FLUSHREAD	 1
> diff --git a/arch/arm/mach-at91/include/mach/board.h b/arch/arm/mach-at91/include/mach/board.h
> index ceaec6c..fd8a385 100644
> --- a/arch/arm/mach-at91/include/mach/board.h
> +++ b/arch/arm/mach-at91/include/mach/board.h
> @@ -39,6 +39,7 @@
>  #include <linux/usb/atmel_usba_udc.h>
>  #include <linux/atmel-mci.h>
>  #include <sound/atmel-ac97c.h>
> +#include <linux/serial.h>
>  
>   /* USB Device */
>  struct at91_udc_data {
> @@ -146,6 +147,7 @@ struct atmel_uart_data {
>  	short		use_dma_tx;	/* use transmit DMA? */
>  	short		use_dma_rx;	/* use receive DMA? */
>  	void __iomem	*regs;		/* virtual base address, if any */
> +	struct serial_rs485	rs485;	/* rs485 settings */
>  };

Can you re-indent this structure so the rest of the members line up with
the new rs485 one.

>  extern void __init at91_add_device_serial(void);
>  
> diff --git a/drivers/serial/atmel_serial.c b/drivers/serial/atmel_serial.c
> index 2c9bf9b..826a885 100644
> --- a/drivers/serial/atmel_serial.c
> +++ b/drivers/serial/atmel_serial.c
> @@ -38,6 +38,7 @@
>  #include <linux/dma-mapping.h>
>  #include <linux/atmel_pdc.h>
>  #include <linux/atmel_serial.h>
> +#include <linux/uaccess.h>
>  
>  #include <asm/io.h>
>  
> @@ -59,6 +60,9 @@
>  
>  #include <linux/serial_core.h>
>  
> +static void atmel_start_rx(struct uart_port *port);
> +static void atmel_stop_rx(struct uart_port *port);
> +
>  #ifdef CONFIG_SERIAL_ATMEL_TTYAT
>  
>  /* Use device name ttyAT, major 204 and minor 154-169.  This is necessary if we
> @@ -93,6 +97,7 @@
>  #define UART_GET_BRGR(port)	__raw_readl((port)->membase + ATMEL_US_BRGR)
>  #define UART_PUT_BRGR(port,v)	__raw_writel(v, (port)->membase + ATMEL_US_BRGR)
>  #define UART_PUT_RTOR(port,v)	__raw_writel(v, (port)->membase + ATMEL_US_RTOR)
> +#define UART_PUT_TTGR(port, v)	__raw_writel(v, (port)->membase + ATMEL_US_TTGR)
>  
>   /* PDC registers */
>  #define UART_PUT_PTCR(port,v)	__raw_writel(v, (port)->membase + ATMEL_PDC_PTCR)
> @@ -147,6 +152,10 @@ struct atmel_uart_port {
>  	unsigned int		irq_status_prev;
>  
>  	struct circ_buf		rx_ring;
> +
> +	struct serial_rs485	rs485;		/* rs485 settings */
> +
> +	unsigned int		tx_done_mask;
>  };

Do we need all the whitespace here?

>  static struct atmel_uart_port atmel_ports[ATMEL_MAX_UART];
> @@ -187,6 +196,81 @@ static bool atmel_use_dma_tx(struct uart_port *port)
>  }
>  #endif
>  
> +/* Enable or disable the rs485 support */
> +void atmel_config_rs485(struct uart_port *port, struct serial_rs485 *rs485conf)
> +{
> +	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
> +	unsigned long flags;
> +	unsigned int mode;
> +
> +	spin_lock_irqsave(&port->lock, flags);
> +
> +	mode = UART_GET_MR(port);
> +
> +	/* Resetting serial mode to RS232 (0x0) */
> +	mode &= ~ATMEL_US_USMODE;
> +
> +	atmel_port->rs485 = *rs485conf;
> +
> +	if (rs485conf->flags & SER_RS485_ENABLED) {
> +		dev_dbg(port->dev, "Setting UART to RS485\n");
> +		atmel_port->tx_done_mask = ATMEL_US_TXEMPTY;
> +		UART_PUT_TTGR(port, rs485conf->delay_rts_before_send);
> +		mode |= ATMEL_US_USMODE_RS485;
> +	} else {
> +		dev_dbg(port->dev, "Setting UART to RS232\n");
> +		if (atmel_use_dma_tx(port))
> +			atmel_port->tx_done_mask = ATMEL_US_ENDTX | \
> +				ATMEL_US_TXBUFE;

You only need to use backslashes on split lines in macro definitions.

> +		else
> +			atmel_port->tx_done_mask = ATMEL_US_TXRDY;
> +	}
> +	UART_PUT_MR(port, mode);
> +
> +	spin_unlock_irqrestore(&port->lock, flags);
> +}
> +
> +
> +static ssize_t show_rs485(struct device *dev, struct device_attribute *attr, \
> +			   char *buf)
> +{

Same here, and a couple more places.

> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct uart_port *port = platform_get_drvdata(pdev);
> +	unsigned int current_mode;
> +
> +	current_mode = UART_GET_MR(port) & ATMEL_US_USMODE;
> +	return snprintf(buf, PAGE_SIZE, "%u\n", current_mode);
> +}
> +
> +static ssize_t set_rs485(struct device *dev, struct device_attribute *attr, \
> +			  const char *buf, size_t len)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct uart_port *port = platform_get_drvdata(pdev);
> +	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
> +	struct serial_rs485 rs485conf = atmel_port->rs485;
> +	unsigned int value;
> +
> +	if (!buf)
> +		return -EINVAL;
> +
> +	value = !!(simple_strtoul(buf, NULL, 0));
> +
> +	if (value) {
> +		rs485conf.flags |= SER_RS485_ENABLED;
> +		/* 0x4 is the normal reset value. */
> +		rs485conf.delay_rts_before_send = 0x00000004;
> +	} else {
> +		rs485conf.flags &= ~(SER_RS485_ENABLED);

Don't need the parenthesis here.

> +	}
> +
> +	atmel_config_rs485(port, &rs485conf);
> +
> +	return strnlen(buf, PAGE_SIZE);
> +}
> +
> +static DEVICE_ATTR(rs485, 0644, show_rs485, set_rs485);
> +
>  /*
>   * Return TIOCSER_TEMT when transmitter FIFO and Shift register is empty.
>   */
> @@ -202,6 +286,7 @@ static void atmel_set_mctrl(struct uart_port *port, u_int mctrl)
>  {
>  	unsigned int control = 0;
>  	unsigned int mode;
> +	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
>  
>  #ifdef CONFIG_ARCH_AT91RM9200
>  	if (cpu_is_at91rm9200()) {
> @@ -236,6 +321,17 @@ static void atmel_set_mctrl(struct uart_port *port, u_int mctrl)
>  		mode |= ATMEL_US_CHMODE_LOC_LOOP;
>  	else
>  		mode |= ATMEL_US_CHMODE_NORMAL;
> +
> +	/* Resetting serial mode to RS232 (0x0) */
> +	mode &= ~ATMEL_US_USMODE;
> +
> +	if (atmel_port->rs485.flags & SER_RS485_ENABLED) {
> +		dev_dbg(port->dev, "Keeping UART to RS485\n");

"Setting" UART to RS485 probably makes more sense here (and couple of
other places).

> +		UART_PUT_TTGR(port, atmel_port->rs485.delay_rts_before_send);
> +		mode |= ATMEL_US_USMODE_RS485;
> +	} else {
> +		dev_dbg(port->dev, "Keeping UART to RS232\n");
> +	}
>  	UART_PUT_MR(port, mode);
>  }
>  
> @@ -268,12 +364,17 @@ static u_int atmel_get_mctrl(struct uart_port *port)
>   */
>  static void atmel_stop_tx(struct uart_port *port)
>  {
> +	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
> +
>  	if (atmel_use_dma_tx(port)) {
>  		/* disable PDC transmit */
>  		UART_PUT_PTCR(port, ATMEL_PDC_TXTDIS);
> -		UART_PUT_IDR(port, ATMEL_US_ENDTX | ATMEL_US_TXBUFE);
> -	} else
> -		UART_PUT_IDR(port, ATMEL_US_TXRDY);
> +	}
> +	/* Disable interrupts */
> +	UART_PUT_IDR(port, atmel_port->tx_done_mask);
> +
> +	if (atmel_port->rs485.flags & SER_RS485_ENABLED)
> +		atmel_start_rx(port);
>  }
>  
>  /*
> @@ -281,17 +382,39 @@ static void atmel_stop_tx(struct uart_port *port)
>   */
>  static void atmel_start_tx(struct uart_port *port)
>  {
> +	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
> +
>  	if (atmel_use_dma_tx(port)) {
>  		if (UART_GET_PTSR(port) & ATMEL_PDC_TXTEN)
>  			/* The transmitter is already running.  Yes, we
>  			   really need this.*/
>  			return;
>  
> -		UART_PUT_IER(port, ATMEL_US_ENDTX | ATMEL_US_TXBUFE);
> +		if (atmel_port->rs485.flags & SER_RS485_ENABLED)
> +			atmel_stop_rx(port);
> +
>  		/* re-enable PDC transmit */
>  		UART_PUT_PTCR(port, ATMEL_PDC_TXTEN);
> -	} else
> -		UART_PUT_IER(port, ATMEL_US_TXRDY);
> +	}
> +	/* Enable interrupts */
> +	UART_PUT_IER(port, atmel_port->tx_done_mask);
> +}
> +
> +/*
> + * start receiving - port is in process of being opened.
> + */
> +static void atmel_start_rx(struct uart_port *port)
> +{
> +	UART_PUT_CR(port, ATMEL_US_RSTSTA);  /* reset status and receiver */
> +
> +	if (atmel_use_dma_rx(port)) {
> +		/* enable PDC controller */
> +		UART_PUT_IER(port, ATMEL_US_ENDRX | ATMEL_US_TIMEOUT | \
> +			port->read_status_mask);
> +		UART_PUT_PTCR(port, ATMEL_PDC_RXTEN);
> +	} else {
> +		UART_PUT_IER(port, ATMEL_US_RXRDY);
> +	}
>  }
>  
>  /*
> @@ -302,9 +425,11 @@ static void atmel_stop_rx(struct uart_port *port)
>  	if (atmel_use_dma_rx(port)) {
>  		/* disable PDC receive */
>  		UART_PUT_PTCR(port, ATMEL_PDC_RXTDIS);
> -		UART_PUT_IDR(port, ATMEL_US_ENDRX | ATMEL_US_TIMEOUT);
> -	} else
> +		UART_PUT_IDR(port, ATMEL_US_ENDRX | ATMEL_US_TIMEOUT | \
> +			port->read_status_mask);
> +	} else {
>  		UART_PUT_IDR(port, ATMEL_US_RXRDY);
> +	}
>  }
>  
>  /*
> @@ -428,8 +553,9 @@ static void atmel_rx_chars(struct uart_port *port)
>  static void atmel_tx_chars(struct uart_port *port)
>  {
>  	struct circ_buf *xmit = &port->state->xmit;
> +	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
>  
> -	if (port->x_char && UART_GET_CSR(port) & ATMEL_US_TXRDY) {
> +	if (port->x_char && UART_GET_CSR(port) & atmel_port->tx_done_mask) {
>  		UART_PUT_CHAR(port, port->x_char);
>  		port->icount.tx++;
>  		port->x_char = 0;
> @@ -437,7 +563,7 @@ static void atmel_tx_chars(struct uart_port *port)
>  	if (uart_circ_empty(xmit) || uart_tx_stopped(port))
>  		return;
>  
> -	while (UART_GET_CSR(port) & ATMEL_US_TXRDY) {
> +	while (UART_GET_CSR(port) & atmel_port->tx_done_mask) {
>  		UART_PUT_CHAR(port, xmit->buf[xmit->tail]);
>  		xmit->tail = (xmit->tail + 1) & (UART_XMIT_SIZE - 1);
>  		port->icount.tx++;
> @@ -449,7 +575,8 @@ static void atmel_tx_chars(struct uart_port *port)
>  		uart_write_wakeup(port);
>  
>  	if (!uart_circ_empty(xmit))
> -		UART_PUT_IER(port, ATMEL_US_TXRDY);
> +		/* Enable interrupts */
> +		UART_PUT_IER(port, atmel_port->tx_done_mask);
>  }
>  
>  /*
> @@ -501,18 +628,10 @@ atmel_handle_transmit(struct uart_port *port, unsigned int pending)
>  {
>  	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
>  
> -	if (atmel_use_dma_tx(port)) {
> -		/* PDC transmit */
> -		if (pending & (ATMEL_US_ENDTX | ATMEL_US_TXBUFE)) {
> -			UART_PUT_IDR(port, ATMEL_US_ENDTX | ATMEL_US_TXBUFE);
> -			tasklet_schedule(&atmel_port->tasklet);
> -		}
> -	} else {
> -		/* Interrupt transmit */
> -		if (pending & ATMEL_US_TXRDY) {
> -			UART_PUT_IDR(port, ATMEL_US_TXRDY);
> -			tasklet_schedule(&atmel_port->tasklet);
> -		}
> +	if (pending & atmel_port->tx_done_mask) {
> +		/* Either PDC or interrupt transmission */
> +		UART_PUT_IDR(port, atmel_port->tx_done_mask);
> +		tasklet_schedule(&atmel_port->tasklet);
>  	}
>  }
>  
> @@ -590,9 +709,15 @@ static void atmel_tx_dma(struct uart_port *port)
>  
>  		UART_PUT_TPR(port, pdc->dma_addr + xmit->tail);
>  		UART_PUT_TCR(port, count);
> -		/* re-enable PDC transmit and interrupts */
> +		/* re-enable PDC transmit */
>  		UART_PUT_PTCR(port, ATMEL_PDC_TXTEN);
> -		UART_PUT_IER(port, ATMEL_US_ENDTX | ATMEL_US_TXBUFE);
> +		/* Enable interrupts */
> +		UART_PUT_IER(port, atmel_port->tx_done_mask);
> +	} else {
> +		if (atmel_port->rs485.flags & SER_RS485_ENABLED) {
> +			/* DMA done, stop TX, start RX for RS485 */
> +			atmel_start_rx(port);
> +		}
>  	}
>  
>  	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
> @@ -1017,6 +1142,7 @@ static void atmel_set_termios(struct uart_port *port, struct ktermios *termios,
>  {
>  	unsigned long flags;
>  	unsigned int mode, imr, quot, baud;
> +	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
>  
>  	/* Get current mode register */
>  	mode = UART_GET_MR(port) & ~(ATMEL_US_USCLKS | ATMEL_US_CHRL
> @@ -1115,6 +1241,17 @@ static void atmel_set_termios(struct uart_port *port, struct ktermios *termios,
>  	/* disable receiver and transmitter */
>  	UART_PUT_CR(port, ATMEL_US_TXDIS | ATMEL_US_RXDIS);
>  
> +	/* Resetting serial mode to RS232 (0x0) */
> +	mode &= ~ATMEL_US_USMODE;
> +
> +	if (atmel_port->rs485.flags & SER_RS485_ENABLED) {
> +		dev_dbg(port->dev, "Keeping UART to RS485\n");
> +		UART_PUT_TTGR(port, atmel_port->rs485.delay_rts_before_send);
> +		mode |= ATMEL_US_USMODE_RS485;
> +	} else {
> +		dev_dbg(port->dev, "Keeping UART to RS232\n");
> +	}
> +
>  	/* set the parity, stop bits and data size */
>  	UART_PUT_MR(port, mode);
>  
> @@ -1231,6 +1368,30 @@ static void atmel_poll_put_char(struct uart_port *port, unsigned char ch)
>  }
>  #endif
>  
> +static int
> +atmel_ioctl(struct uart_port *port, unsigned int cmd, unsigned long arg)
> +{
> +	struct serial_rs485 rs485conf;
> +
> +	switch (cmd) {
> +	case TIOCSRS485:
> +		if (copy_from_user(&rs485conf, (struct serial_rs485 *) arg, \
> +					sizeof(rs485conf)))
> +			return -EFAULT;
> +
> +		dev_dbg(port->dev, "enable e/o disable rs485\n");

You could remove this dev_dbg since amtel_config_rs485 already prints
debug information.

> +
> +		atmel_config_rs485(port, &rs485conf);
> +		break;
> +
> +	default:
> +		return -ENOIOCTLCMD;
> +	}
> +	return 0;
> +}
> +
> +
> +
>  static struct uart_ops atmel_pops = {
>  	.tx_empty	= atmel_tx_empty,
>  	.set_mctrl	= atmel_set_mctrl,
> @@ -1250,6 +1411,7 @@ static struct uart_ops atmel_pops = {
>  	.config_port	= atmel_config_port,
>  	.verify_port	= atmel_verify_port,
>  	.pm		= atmel_serial_pm,
> +	.ioctl		= atmel_ioctl,
>  #ifdef CONFIG_CONSOLE_POLL
>  	.poll_get_char	= atmel_poll_get_char,
>  	.poll_put_char	= atmel_poll_put_char,
> @@ -1265,13 +1427,12 @@ static void __devinit atmel_init_port(struct atmel_uart_port *atmel_port,
>  	struct uart_port *port = &atmel_port->uart;
>  	struct atmel_uart_data *data = pdev->dev.platform_data;
>  
> -	port->iotype	= UPIO_MEM;
> -	port->flags	= UPF_BOOT_AUTOCONF;
> -	port->ops	= &atmel_pops;
> -	port->fifosize	= 1;
> -	port->line	= pdev->id;
> -	port->dev	= &pdev->dev;
> -
> +	port->iotype		= UPIO_MEM;
> +	port->flags		= UPF_BOOT_AUTOCONF;
> +	port->ops		= &atmel_pops;
> +	port->fifosize		= 1;
> +	port->line		= pdev->id;
> +	port->dev		= &pdev->dev;
>  	port->mapbase	= pdev->resource[0].start;
>  	port->irq	= pdev->resource[1].start;
>  
> @@ -1299,8 +1460,16 @@ static void __devinit atmel_init_port(struct atmel_uart_port *atmel_port,
>  
>  	atmel_port->use_dma_rx = data->use_dma_rx;
>  	atmel_port->use_dma_tx = data->use_dma_tx;
> -	if (atmel_use_dma_tx(port))
> +	atmel_port->rs485	= data->rs485;
> +	/* Use TXEMPTY for interrupt when rs485 else TXRDY or ENDTX|TXBUFE */
> +	if (atmel_port->rs485.flags & SER_RS485_ENABLED)
> +		atmel_port->tx_done_mask = ATMEL_US_TXEMPTY;
> +	else if (atmel_use_dma_tx(port)) {
>  		port->fifosize = PDC_BUFFER_SIZE;
> +		atmel_port->tx_done_mask = ATMEL_US_ENDTX | ATMEL_US_TXBUFE;
> +	} else {
> +		atmel_port->tx_done_mask = ATMEL_US_TXRDY;
> +	}
>  }
>  
>  /*
> @@ -1334,6 +1503,7 @@ static void atmel_console_putchar(struct uart_port *port, int ch)
>  static void atmel_console_write(struct console *co, const char *s, u_int count)
>  {
>  	struct uart_port *port = &atmel_ports[co->index].uart;
> +	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
>  	unsigned int status, imr;
>  	unsigned int pdc_tx;
>  
> @@ -1341,7 +1511,7 @@ static void atmel_console_write(struct console *co, const char *s, u_int count)
>  	 * First, save IMR and then disable interrupts
>  	 */
>  	imr = UART_GET_IMR(port);
> -	UART_PUT_IDR(port, ATMEL_US_RXRDY | ATMEL_US_TXRDY);
> +	UART_PUT_IDR(port, ATMEL_US_RXRDY | atmel_port->tx_done_mask);
>  
>  	/* Store PDC transmit status and disable it */
>  	pdc_tx = UART_GET_PTSR(port) & ATMEL_PDC_TXTEN;
> @@ -1355,7 +1525,7 @@ static void atmel_console_write(struct console *co, const char *s, u_int count)
>  	 */
>  	do {
>  		status = UART_GET_CSR(port);
> -	} while (!(status & ATMEL_US_TXRDY));
> +	} while (!(status & atmel_port->tx_done_mask));
>  
>  	/* Restore PDC transmit status */
>  	if (pdc_tx)
> @@ -1587,7 +1757,7 @@ static int __devinit atmel_serial_probe(struct platform_device *pdev)
>  	device_init_wakeup(&pdev->dev, 1);
>  	platform_set_drvdata(pdev, port);
>  
> -	return 0;
> +	return device_create_file(&(pdev->dev), &dev_attr_rs485);
>  
>  err_add_port:
>  	kfree(port->rx_ring.buf);
> @@ -1619,6 +1789,8 @@ static int __devexit atmel_serial_remove(struct platform_device *pdev)
>  
>  	clk_put(atmel_port->clk);
>  
> +	device_remove_file(&(pdev->dev), &dev_attr_rs485);
> +
>  	return ret;
>  }
>  

~Ryan

-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

Ryan Mallon         		5 Amuri Park, 404 Barbadoes St
ryan@bluewatersys.com         	PO Box 13 889, Christchurch 8013
http://www.bluewatersys.com	New Zealand
Phone: +64 3 3779127		Freecall: Australia 1800 148 751
Fax:   +64 3 3779135			  USA 1800 261 2934
