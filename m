Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758735Ab0DHNQV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 09:16:21 -0400
Received: from borg.asidev.net ([95.141.32.69]:53066 "EHLO borg.asidev.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758623Ab0DHNQS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 09:16:18 -0400
Message-ID: <4BBDD71D.1010700@evidence.eu.com>
Date: Thu, 08 Apr 2010 15:16:13 +0200
From: Claudio Scordino <claudio@evidence.eu.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Ryan Mallon <ryan@bluewatersys.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       John Nicholls <john@thinlinx.com>, Rick Bronson <rick@efn.org>,
       Sebastian Heutling <Sebastian.Heutling@who-ing.de>,
       michael trimarchi <michael@evidence.eu.com>, rmk@arm.linux.org.uk,
       hskinnemoen@atmel.com, linux@maxim.org.za
Subject: Re: [PATCH] atmel_serial: Atmel RS485 support v2
References: <4BB053C4.7050700@evidence.eu.com>	<4BB10304.6090006@bluewatersys.com>	<4BB1BF49.2000609@evidence.eu.com>	<4BB252E3.3030703@bluewatersys.com>	<4BBD8C9D.3070401@evidence.eu.com> <20100408111310.524f7354@lxorguk.ukuu.org.uk>
In-Reply-To: <20100408111310.524f7354@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox ha scritto:
> NAK - assorted problems, notably locking ones caused by the sysfs stuff
> which should probably be dropped.
> 
>> +#define TIOCSRS485	0x5461
> 
> Please provide TIOCGRS485 as well
> 
> 
> 
>> +static ssize_t show_rs485(struct device *dev, struct device_attribute *attr,
>> +			   char *buf)
>> +{
>> +	struct platform_device *pdev = to_platform_device(dev);
>> +	struct uart_port *port = platform_get_drvdata(pdev);
>> +	unsigned int current_mode;
>> +
>> +	current_mode = UART_GET_MR(port) & ATMEL_US_USMODE;
>> +	return snprintf(buf, PAGE_SIZE, "%u\n", current_mode);
>> +}
> 
> You should have TIOCGRS485 for providing the info back as part of the API
> 
>> +
>> +static ssize_t set_rs485(struct device *dev, struct device_attribute *attr,
>> +			  const char *buf, size_t len)
> 
> Expain the locking on this could you - I don't see what protects against
> parallel ioctl and sysfs stuff ?
> 
>> +static DEVICE_ATTR(rs485, 0644, show_rs485, set_rs485);
> 
> Why should this be public read ?
> 
>> +	/* Resetting serial mode to RS232 (0x0) */
>> +	mode &= ~ATMEL_US_USMODE;
>> +
>> +	if (atmel_port->rs485.flags & SER_RS485_ENABLED) {
>> +		dev_dbg(port->dev, "Setting UART to RS485\n");
>> +		UART_PUT_TTGR(port, atmel_port->rs485.delay_rts_before_send);
>> +		mode |= ATMEL_US_USMODE_RS485;
>> +	} else {
>> +		dev_dbg(port->dev, "Setting UART to RS232\n");
> 
> Locking versus sysfs ?
> 
>> +	UART_PUT_IDR(port, atmel_port->tx_done_mask);
>> +
>> +	if (atmel_port->rs485.flags & SER_RS485_ENABLED)
>> +		atmel_start_rx(port);
>>  }
> 
> Ditto
> 
>> -		UART_PUT_IER(port, ATMEL_US_ENDTX | ATMEL_US_TXBUFE);
>> +		if (atmel_port->rs485.flags & SER_RS485_ENABLED)
>> +			atmel_stop_rx(port);
>> +
> 
> Ditto
> 
> 
> Given the locking mess you are going to create I would suggest dropping
> the sysfs stuff.
> 
> Alan


Thank you for the feedback.

Let me know if this new version solves the above problems.

	Claudio


atmel_serial: Atmel RS485 support

Signed-off-by: Claudio Scordino <claudio@evidence.eu.com>
Signed-off-by: Michael Trimarchi <michael@evidence.eu.com>
Signed-off-by: Rick Bronson <rick@efn.org>
Signed-off-by: Sebastian Heutling <Sebastian.Heutling@who-ing.de>
Tested-by: Sebastian Heutling <Sebastian.Heutling@who-ing.de>
Reviewed-by: Ryan Mallon <ryan@bluewatersys.com>
---
 arch/arm/include/asm/ioctls.h           |    3 +
 arch/arm/mach-at91/include/mach/board.h |    8 +-
 drivers/serial/atmel_serial.c           |  203 +++++++++++++++++++++++++------
 3 files changed, 176 insertions(+), 38 deletions(-)

diff --git a/arch/arm/include/asm/ioctls.h b/arch/arm/include/asm/ioctls.h
index a91d8a1..7f0b6d1 100644
--- a/arch/arm/include/asm/ioctls.h
+++ b/arch/arm/include/asm/ioctls.h
@@ -53,6 +53,9 @@
 #define TIOCGPTN	_IOR('T',0x30, unsigned int) /* Get Pty Number (of pty-mux device) */
 #define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
 
+#define TIOCGRS485      0x542E
+#define TIOCSRS485      0x542F
+
 #define FIONCLEX	0x5450  /* these numbers need to be adjusted. */
 #define FIOCLEX		0x5451
 #define FIOASYNC	0x5452
diff --git a/arch/arm/mach-at91/include/mach/board.h b/arch/arm/mach-at91/include/mach/board.h
index ceaec6c..df2ed84 100644
--- a/arch/arm/mach-at91/include/mach/board.h
+++ b/arch/arm/mach-at91/include/mach/board.h
@@ -39,6 +39,7 @@
 #include <linux/usb/atmel_usba_udc.h>
 #include <linux/atmel-mci.h>
 #include <sound/atmel-ac97c.h>
+#include <linux/serial.h>
 
  /* USB Device */
 struct at91_udc_data {
@@ -143,9 +144,10 @@ extern struct platform_device *atmel_default_console_device;
 extern void __init __deprecated at91_init_serial(struct at91_uart_config *config);
 
 struct atmel_uart_data {
-	short		use_dma_tx;	/* use transmit DMA? */
-	short		use_dma_rx;	/* use receive DMA? */
-	void __iomem	*regs;		/* virtual base address, if any */
+	short			use_dma_tx;	/* use transmit DMA? */
+	short			use_dma_rx;	/* use receive DMA? */
+	void __iomem		*regs;		/* virt. base address, if any */
+	struct serial_rs485	rs485;		/* rs485 settings */
 };
 extern void __init at91_add_device_serial(void);
 
diff --git a/drivers/serial/atmel_serial.c b/drivers/serial/atmel_serial.c
index 2c9bf9b..4f4b0b9 100644
--- a/drivers/serial/atmel_serial.c
+++ b/drivers/serial/atmel_serial.c
@@ -38,6 +38,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/atmel_pdc.h>
 #include <linux/atmel_serial.h>
+#include <linux/uaccess.h>
 
 #include <asm/io.h>
 
@@ -59,6 +60,9 @@
 
 #include <linux/serial_core.h>
 
+static void atmel_start_rx(struct uart_port *port);
+static void atmel_stop_rx(struct uart_port *port);
+
 #ifdef CONFIG_SERIAL_ATMEL_TTYAT
 
 /* Use device name ttyAT, major 204 and minor 154-169.  This is necessary if we
@@ -93,6 +97,7 @@
 #define UART_GET_BRGR(port)	__raw_readl((port)->membase + ATMEL_US_BRGR)
 #define UART_PUT_BRGR(port,v)	__raw_writel(v, (port)->membase + ATMEL_US_BRGR)
 #define UART_PUT_RTOR(port,v)	__raw_writel(v, (port)->membase + ATMEL_US_RTOR)
+#define UART_PUT_TTGR(port, v)	__raw_writel(v, (port)->membase + ATMEL_US_TTGR)
 
  /* PDC registers */
 #define UART_PUT_PTCR(port,v)	__raw_writel(v, (port)->membase + ATMEL_PDC_PTCR)
@@ -147,6 +152,9 @@ struct atmel_uart_port {
 	unsigned int		irq_status_prev;
 
 	struct circ_buf		rx_ring;
+
+	struct serial_rs485	rs485;		/* rs485 settings */
+	unsigned int		tx_done_mask;
 };
 
 static struct atmel_uart_port atmel_ports[ATMEL_MAX_UART];
@@ -187,6 +195,40 @@ static bool atmel_use_dma_tx(struct uart_port *port)
 }
 #endif
 
+/* Enable or disable the rs485 support */
+void atmel_config_rs485(struct uart_port *port, struct serial_rs485 *rs485conf)
+{
+	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
+	unsigned long flags;
+	unsigned int mode;
+
+	spin_lock_irqsave(&port->lock, flags);
+
+	mode = UART_GET_MR(port);
+
+	/* Resetting serial mode to RS232 (0x0) */
+	mode &= ~ATMEL_US_USMODE;
+
+	atmel_port->rs485 = *rs485conf;
+
+	if (rs485conf->flags & SER_RS485_ENABLED) {
+		dev_dbg(port->dev, "Setting UART to RS485\n");
+		atmel_port->tx_done_mask = ATMEL_US_TXEMPTY;
+		UART_PUT_TTGR(port, rs485conf->delay_rts_before_send);
+		mode |= ATMEL_US_USMODE_RS485;
+	} else {
+		dev_dbg(port->dev, "Setting UART to RS232\n");
+		if (atmel_use_dma_tx(port))
+			atmel_port->tx_done_mask = ATMEL_US_ENDTX |
+				ATMEL_US_TXBUFE;
+		else
+			atmel_port->tx_done_mask = ATMEL_US_TXRDY;
+	}
+	UART_PUT_MR(port, mode);
+
+	spin_unlock_irqrestore(&port->lock, flags);
+}
+
 /*
  * Return TIOCSER_TEMT when transmitter FIFO and Shift register is empty.
  */
@@ -202,6 +244,7 @@ static void atmel_set_mctrl(struct uart_port *port, u_int mctrl)
 {
 	unsigned int control = 0;
 	unsigned int mode;
+	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
 
 #ifdef CONFIG_ARCH_AT91RM9200
 	if (cpu_is_at91rm9200()) {
@@ -236,6 +279,17 @@ static void atmel_set_mctrl(struct uart_port *port, u_int mctrl)
 		mode |= ATMEL_US_CHMODE_LOC_LOOP;
 	else
 		mode |= ATMEL_US_CHMODE_NORMAL;
+
+	/* Resetting serial mode to RS232 (0x0) */
+	mode &= ~ATMEL_US_USMODE;
+
+	if (atmel_port->rs485.flags & SER_RS485_ENABLED) {
+		dev_dbg(port->dev, "Setting UART to RS485\n");
+		UART_PUT_TTGR(port, atmel_port->rs485.delay_rts_before_send);
+		mode |= ATMEL_US_USMODE_RS485;
+	} else {
+		dev_dbg(port->dev, "Setting UART to RS232\n");
+	}
 	UART_PUT_MR(port, mode);
 }
 
@@ -268,12 +322,17 @@ static u_int atmel_get_mctrl(struct uart_port *port)
  */
 static void atmel_stop_tx(struct uart_port *port)
 {
+	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
+
 	if (atmel_use_dma_tx(port)) {
 		/* disable PDC transmit */
 		UART_PUT_PTCR(port, ATMEL_PDC_TXTDIS);
-		UART_PUT_IDR(port, ATMEL_US_ENDTX | ATMEL_US_TXBUFE);
-	} else
-		UART_PUT_IDR(port, ATMEL_US_TXRDY);
+	}
+	/* Disable interrupts */
+	UART_PUT_IDR(port, atmel_port->tx_done_mask);
+
+	if (atmel_port->rs485.flags & SER_RS485_ENABLED)
+		atmel_start_rx(port);
 }
 
 /*
@@ -281,17 +340,39 @@ static void atmel_stop_tx(struct uart_port *port)
  */
 static void atmel_start_tx(struct uart_port *port)
 {
+	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
+
 	if (atmel_use_dma_tx(port)) {
 		if (UART_GET_PTSR(port) & ATMEL_PDC_TXTEN)
 			/* The transmitter is already running.  Yes, we
 			   really need this.*/
 			return;
 
-		UART_PUT_IER(port, ATMEL_US_ENDTX | ATMEL_US_TXBUFE);
+		if (atmel_port->rs485.flags & SER_RS485_ENABLED)
+			atmel_stop_rx(port);
+
 		/* re-enable PDC transmit */
 		UART_PUT_PTCR(port, ATMEL_PDC_TXTEN);
-	} else
-		UART_PUT_IER(port, ATMEL_US_TXRDY);
+	}
+	/* Enable interrupts */
+	UART_PUT_IER(port, atmel_port->tx_done_mask);
+}
+
+/*
+ * start receiving - port is in process of being opened.
+ */
+static void atmel_start_rx(struct uart_port *port)
+{
+	UART_PUT_CR(port, ATMEL_US_RSTSTA);  /* reset status and receiver */
+
+	if (atmel_use_dma_rx(port)) {
+		/* enable PDC controller */
+		UART_PUT_IER(port, ATMEL_US_ENDRX | ATMEL_US_TIMEOUT |
+			port->read_status_mask);
+		UART_PUT_PTCR(port, ATMEL_PDC_RXTEN);
+	} else {
+		UART_PUT_IER(port, ATMEL_US_RXRDY);
+	}
 }
 
 /*
@@ -302,9 +383,11 @@ static void atmel_stop_rx(struct uart_port *port)
 	if (atmel_use_dma_rx(port)) {
 		/* disable PDC receive */
 		UART_PUT_PTCR(port, ATMEL_PDC_RXTDIS);
-		UART_PUT_IDR(port, ATMEL_US_ENDRX | ATMEL_US_TIMEOUT);
-	} else
+		UART_PUT_IDR(port, ATMEL_US_ENDRX | ATMEL_US_TIMEOUT |
+			port->read_status_mask);
+	} else {
 		UART_PUT_IDR(port, ATMEL_US_RXRDY);
+	}
 }
 
 /*
@@ -428,8 +511,9 @@ static void atmel_rx_chars(struct uart_port *port)
 static void atmel_tx_chars(struct uart_port *port)
 {
 	struct circ_buf *xmit = &port->state->xmit;
+	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
 
-	if (port->x_char && UART_GET_CSR(port) & ATMEL_US_TXRDY) {
+	if (port->x_char && UART_GET_CSR(port) & atmel_port->tx_done_mask) {
 		UART_PUT_CHAR(port, port->x_char);
 		port->icount.tx++;
 		port->x_char = 0;
@@ -437,7 +521,7 @@ static void atmel_tx_chars(struct uart_port *port)
 	if (uart_circ_empty(xmit) || uart_tx_stopped(port))
 		return;
 
-	while (UART_GET_CSR(port) & ATMEL_US_TXRDY) {
+	while (UART_GET_CSR(port) & atmel_port->tx_done_mask) {
 		UART_PUT_CHAR(port, xmit->buf[xmit->tail]);
 		xmit->tail = (xmit->tail + 1) & (UART_XMIT_SIZE - 1);
 		port->icount.tx++;
@@ -449,7 +533,8 @@ static void atmel_tx_chars(struct uart_port *port)
 		uart_write_wakeup(port);
 
 	if (!uart_circ_empty(xmit))
-		UART_PUT_IER(port, ATMEL_US_TXRDY);
+		/* Enable interrupts */
+		UART_PUT_IER(port, atmel_port->tx_done_mask);
 }
 
 /*
@@ -501,18 +586,10 @@ atmel_handle_transmit(struct uart_port *port, unsigned int pending)
 {
 	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
 
-	if (atmel_use_dma_tx(port)) {
-		/* PDC transmit */
-		if (pending & (ATMEL_US_ENDTX | ATMEL_US_TXBUFE)) {
-			UART_PUT_IDR(port, ATMEL_US_ENDTX | ATMEL_US_TXBUFE);
-			tasklet_schedule(&atmel_port->tasklet);
-		}
-	} else {
-		/* Interrupt transmit */
-		if (pending & ATMEL_US_TXRDY) {
-			UART_PUT_IDR(port, ATMEL_US_TXRDY);
-			tasklet_schedule(&atmel_port->tasklet);
-		}
+	if (pending & atmel_port->tx_done_mask) {
+		/* Either PDC or interrupt transmission */
+		UART_PUT_IDR(port, atmel_port->tx_done_mask);
+		tasklet_schedule(&atmel_port->tasklet);
 	}
 }
 
@@ -590,9 +667,15 @@ static void atmel_tx_dma(struct uart_port *port)
 
 		UART_PUT_TPR(port, pdc->dma_addr + xmit->tail);
 		UART_PUT_TCR(port, count);
-		/* re-enable PDC transmit and interrupts */
+		/* re-enable PDC transmit */
 		UART_PUT_PTCR(port, ATMEL_PDC_TXTEN);
-		UART_PUT_IER(port, ATMEL_US_ENDTX | ATMEL_US_TXBUFE);
+		/* Enable interrupts */
+		UART_PUT_IER(port, atmel_port->tx_done_mask);
+	} else {
+		if (atmel_port->rs485.flags & SER_RS485_ENABLED) {
+			/* DMA done, stop TX, start RX for RS485 */
+			atmel_start_rx(port);
+		}
 	}
 
 	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
@@ -1017,6 +1100,7 @@ static void atmel_set_termios(struct uart_port *port, struct ktermios *termios,
 {
 	unsigned long flags;
 	unsigned int mode, imr, quot, baud;
+	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
 
 	/* Get current mode register */
 	mode = UART_GET_MR(port) & ~(ATMEL_US_USCLKS | ATMEL_US_CHRL
@@ -1115,6 +1199,17 @@ static void atmel_set_termios(struct uart_port *port, struct ktermios *termios,
 	/* disable receiver and transmitter */
 	UART_PUT_CR(port, ATMEL_US_TXDIS | ATMEL_US_RXDIS);
 
+	/* Resetting serial mode to RS232 (0x0) */
+	mode &= ~ATMEL_US_USMODE;
+
+	if (atmel_port->rs485.flags & SER_RS485_ENABLED) {
+		dev_dbg(port->dev, "Setting UART to RS485\n");
+		UART_PUT_TTGR(port, atmel_port->rs485.delay_rts_before_send);
+		mode |= ATMEL_US_USMODE_RS485;
+	} else {
+		dev_dbg(port->dev, "Setting UART to RS232\n");
+	}
+
 	/* set the parity, stop bits and data size */
 	UART_PUT_MR(port, mode);
 
@@ -1231,6 +1326,35 @@ static void atmel_poll_put_char(struct uart_port *port, unsigned char ch)
 }
 #endif
 
+static int
+atmel_ioctl(struct uart_port *port, unsigned int cmd, unsigned long arg)
+{
+	struct serial_rs485 rs485conf;
+
+	switch (cmd) {
+	case TIOCSRS485:
+		if (copy_from_user(&rs485conf, (struct serial_rs485 *) arg,
+					sizeof(rs485conf)))
+			return -EFAULT;
+
+		atmel_config_rs485(port, &rs485conf);
+		break;
+
+	case TIOCGRS485:
+		if (copy_to_user((struct serial_rs485 *) arg,
+					&(to_atmel_uart_port(port)->rs485),
+					sizeof(rs485conf)))
+			return -EFAULT;
+		break;
+
+	default:
+		return -ENOIOCTLCMD;
+	}
+	return 0;
+}
+
+
+
 static struct uart_ops atmel_pops = {
 	.tx_empty	= atmel_tx_empty,
 	.set_mctrl	= atmel_set_mctrl,
@@ -1250,6 +1374,7 @@ static struct uart_ops atmel_pops = {
 	.config_port	= atmel_config_port,
 	.verify_port	= atmel_verify_port,
 	.pm		= atmel_serial_pm,
+	.ioctl		= atmel_ioctl,
 #ifdef CONFIG_CONSOLE_POLL
 	.poll_get_char	= atmel_poll_get_char,
 	.poll_put_char	= atmel_poll_put_char,
@@ -1265,13 +1390,12 @@ static void __devinit atmel_init_port(struct atmel_uart_port *atmel_port,
 	struct uart_port *port = &atmel_port->uart;
 	struct atmel_uart_data *data = pdev->dev.platform_data;
 
-	port->iotype	= UPIO_MEM;
-	port->flags	= UPF_BOOT_AUTOCONF;
-	port->ops	= &atmel_pops;
-	port->fifosize	= 1;
-	port->line	= pdev->id;
-	port->dev	= &pdev->dev;
-
+	port->iotype		= UPIO_MEM;
+	port->flags		= UPF_BOOT_AUTOCONF;
+	port->ops		= &atmel_pops;
+	port->fifosize		= 1;
+	port->line		= pdev->id;
+	port->dev		= &pdev->dev;
 	port->mapbase	= pdev->resource[0].start;
 	port->irq	= pdev->resource[1].start;
 
@@ -1299,8 +1423,16 @@ static void __devinit atmel_init_port(struct atmel_uart_port *atmel_port,
 
 	atmel_port->use_dma_rx = data->use_dma_rx;
 	atmel_port->use_dma_tx = data->use_dma_tx;
-	if (atmel_use_dma_tx(port))
+	atmel_port->rs485	= data->rs485;
+	/* Use TXEMPTY for interrupt when rs485 else TXRDY or ENDTX|TXBUFE */
+	if (atmel_port->rs485.flags & SER_RS485_ENABLED)
+		atmel_port->tx_done_mask = ATMEL_US_TXEMPTY;
+	else if (atmel_use_dma_tx(port)) {
 		port->fifosize = PDC_BUFFER_SIZE;
+		atmel_port->tx_done_mask = ATMEL_US_ENDTX | ATMEL_US_TXBUFE;
+	} else {
+		atmel_port->tx_done_mask = ATMEL_US_TXRDY;
+	}
 }
 
 /*
@@ -1334,6 +1466,7 @@ static void atmel_console_putchar(struct uart_port *port, int ch)
 static void atmel_console_write(struct console *co, const char *s, u_int count)
 {
 	struct uart_port *port = &atmel_ports[co->index].uart;
+	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
 	unsigned int status, imr;
 	unsigned int pdc_tx;
 
@@ -1341,7 +1474,7 @@ static void atmel_console_write(struct console *co, const char *s, u_int count)
 	 * First, save IMR and then disable interrupts
 	 */
 	imr = UART_GET_IMR(port);
-	UART_PUT_IDR(port, ATMEL_US_RXRDY | ATMEL_US_TXRDY);
+	UART_PUT_IDR(port, ATMEL_US_RXRDY | atmel_port->tx_done_mask);
 
 	/* Store PDC transmit status and disable it */
 	pdc_tx = UART_GET_PTSR(port) & ATMEL_PDC_TXTEN;
@@ -1355,7 +1488,7 @@ static void atmel_console_write(struct console *co, const char *s, u_int count)
 	 */
 	do {
 		status = UART_GET_CSR(port);
-	} while (!(status & ATMEL_US_TXRDY));
+	} while (!(status & atmel_port->tx_done_mask));
 
 	/* Restore PDC transmit status */
 	if (pdc_tx)
-- 
1.6.0.4


