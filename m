Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948Ab1AGPVJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 10:21:09 -0500
Received: from relay03-haj2.antispameurope.com ([83.246.65.53]:48804 "EHLO
	relay03-haj2.antispameurope.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753930Ab1AGPVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 10:21:06 -0500
X-Greylist: delayed 379 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Jan 2011 10:21:05 EST
Message-ID: <4D272DDA.6010007@iis.fraunhofer.de>
Date: Fri, 07 Jan 2011 16:14:34 +0100
From: Manuel Stahl <manuel.stahl@iis.fraunhofer.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: linux-serial@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>, Thomas Weber <weber@corscience.de>,
        Johannes Reif <reif@corscience.de>, changgx <changgx@163.com>,
        miguelangel@nbee.es
Subject: [PATCH resend 2] Add sc16is7x2 driver
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms010300090103010503000509"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms010300090103010503000509
Content-Type: multipart/mixed;
 boundary="------------080008000605030805080201"

This is a multi-part message in MIME format.
--------------080008000605030805080201
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

IRQ is now implemented with work queue (like max3100).
The problem is, that the sc16is7x2 has a low active irq. But with active =

low threaded_irqs, shared irqs are not allowed.

Please try this one and report errors.

Regards,
Manuel Stahl

PS: sorry that the patch is not inline, not sure how to configure=20
thunderbird correctly

--------------080008000605030805080201
Content-Type: text/x-patch;
 name="sc16is7x2_work_queue.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
 filename="sc16is7x2_work_queue.patch"

Add sc16is7x2 driver

This patch adds support for the sc16is7x2 SPI to UART chips.
Each chip has two UARTs and 8 GPIOs.

Signed-off-by: Manuel Stahl <manuel.stahl@iis.fraunhofer.de>
---

 drivers/serial/Kconfig           |    9 +
 drivers/serial/Makefile          |    1 +
 drivers/serial/sc16is7x2.c       | 1063 ++++++++++++++++++++++++++++++++=
++++++
 include/linux/serial_core.h      |    6 +-
 include/linux/serial_sc16is7x2.h |   17 +
 5 files changed, 1095 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
index 188aff6..a070345 100644
--- a/drivers/serial/Kconfig
+++ b/drivers/serial/Kconfig
@@ -269,6 +269,15 @@ config SERIAL_8250_RM9K
=20
 comment "Non-8250 serial port support"
=20
+config SERIAL_SC16IS7X2
+	tristate "SC16IS7x2 chips"
+	depends on SPI_MASTER
+	select SERIAL_CORE
+	help
+	  Selecting this option will add support for SC16IS7x2 SPI UARTs.
+	  The GPIOs are exported via gpiolib interface.
+	  If unsure, say N.
+
 config SERIAL_AMBA_PL010
 	tristate "ARM AMBA PL010 serial port support"
 	depends on ARM_AMBA && (BROKEN || !ARCH_VERSATILE)
diff --git a/drivers/serial/Makefile b/drivers/serial/Makefile
index 8ea92e9..6ff1f0f 100644
--- a/drivers/serial/Makefile
+++ b/drivers/serial/Makefile
@@ -28,6 +28,7 @@ obj-$(CONFIG_SERIAL_8250_BOCA) +=3D 8250_boca.o
 obj-$(CONFIG_SERIAL_8250_EXAR_ST16C554) +=3D 8250_exar_st16c554.o
 obj-$(CONFIG_SERIAL_8250_HUB6) +=3D 8250_hub6.o
 obj-$(CONFIG_SERIAL_8250_MCA) +=3D 8250_mca.o
+obj-$(CONFIG_SERIAL_SC16IS7X2)	+=3D sc16is7x2.o
 obj-$(CONFIG_SERIAL_AMBA_PL010) +=3D amba-pl010.o
 obj-$(CONFIG_SERIAL_AMBA_PL011) +=3D amba-pl011.o
 obj-$(CONFIG_SERIAL_CLPS711X) +=3D clps711x.o
diff --git a/drivers/serial/sc16is7x2.c b/drivers/serial/sc16is7x2.c
new file mode 100644
index 0000000..d3156b4
--- /dev/null
+++ b/drivers/serial/sc16is7x2.c
@@ -0,0 +1,1063 @@
+/**
+ * drivers/serial/sc16is7x2.c
+ *
+ * Copyright (C) 2009 Manuel Stahl <manuel.stahl@iis.fraunhofer.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * The SC16IS7x2 device is a SPI driven dual UART with GPIOs.
+ *
+ * The driver exports two uarts and a gpiochip interface.
+ */
+
+/* #define DEBUG */
+
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/serial_reg.h>
+#include <linux/serial_core.h>
+#include <linux/serial.h>
+#include <linux/gpio.h>
+#include <linux/spi/spi.h>
+#include <linux/freezer.h>
+#include <linux/serial_sc16is7x2.h>
+
+#define MAX_SC16IS7X2		8
+#define FIFO_SIZE		64
+
+#define DRIVER_NAME		"sc16is7x2"
+#define TYPE_NAME		"SC16IS7x2"
+
+
+#define REG_READ	0x80
+#define REG_WRITE	0x00
+
+/* Special registers */
+#define REG_TXLVL	0x08	/* Transmitter FIFO Level register */
+#define REG_RXLVL	0x09	/* Receiver FIFO Level register */
+#define REG_IOD		0x0A	/* IO Direction register */
+#define REG_IOS		0x0B	/* IO State register */
+#define REG_IOI		0x0C	/* IO Interrupt Enable register */
+#define REG_IOC		0x0E	/* IO Control register */
+
+#define IOC_SRESET	0x08    /* Software reset */
+#define IOC_GPIO30	0x04    /* GPIO 3:0 unset: as IO, set: as modem pins =
*/
+#define IOC_GPIO74	0x02    /* GPIO 7:4 unset: as IO, set: as modem pins =
*/
+#define IOC_IOLATCH	0x01    /* Unset: input unlatched, set: input latche=
d */
+
+struct sc16is7x2_chip;
+
+/*
+ * Some registers must be read back to modify.
+ * To save time we cache them here in memory.
+ */
+struct sc16is7x2_channel {
+	struct sc16is7x2_chip	*chip;	/* back link */
+	struct uart_port	uart;
+
+	/* Workqueue that does all the magic */
+	struct workqueue_struct *workqueue;
+	struct work_struct	work;
+
+	u16		quot;		/* baud rate divisor */
+	u8		iir;		/* state of IIR register */
+	u8		lsr;		/* state of LSR register */
+	u8		msr;		/* state of MSR register */
+	u8		ier;		/* cache for IER register */
+	u8		fcr;		/* cache for FCR register */
+	u8		lcr;		/* cache for LCR register */
+	u8		mcr;		/* cache for MCR register */
+	u8		efr;		/* cache for EFR register */
+#ifdef DEBUG
+	bool		handle_irq;
+#endif
+	bool		handle_baud;	/* baud rate needs update */
+	bool		handle_regs;	/* other regs need update */
+	u8		buf[FIFO_SIZE+1]; /* fifo transfer buffer */
+};
+
+struct sc16is7x2_chip {
+	struct spi_device *spi;
+	struct sc16is7x2_channel channel[2];
+
+#ifdef CONFIG_GPIOLIB
+	struct gpio_chip gpio;
+	struct mutex	io_lock;	/* lock for GPIO functions */
+	u8		io_dir;		/* cache for IODir register */
+	u8		io_state;	/* cache for IOState register */
+	u8		io_gpio;	/* PIN is GPIO */
+	u8		io_control;	/* cache for IOControl register */
+#endif
+};
+
+/* ******************************** SPI ********************************=
* */
+
+static inline u8 write_cmd(u8 reg, u8 ch)
+{
+	return REG_WRITE | (reg & 0xf) << 3 | (ch & 0x1) << 1;
+}
+
+static inline u8 read_cmd(u8 reg, u8 ch)
+{
+	return REG_READ  | (reg & 0xf) << 3 | (ch & 0x1) << 1;
+}
+
+/*
+ * sc16is7x2_write - Write a new register content (sync)
+ * @reg: Register offset
+ * @ch:  Channel (0 or 1)
+ */
+static int sc16is7x2_write(struct sc16is7x2_chip *ts, u8 reg, u8 ch, u8 =
val)
+{
+	u8 out[2];
+
+	out[0] =3D write_cmd(reg, ch);
+	out[1] =3D val;
+	return spi_write(ts->spi, out, sizeof(out));
+}
+
+/**
+ * sc16is7x2_read - Read back register content
+ * @reg: Register offset
+ * @ch:  Channel (0 or 1)
+ *
+ * Returns positive 8 bit value from the device if successful or a
+ * negative value on error
+ */
+static int sc16is7x2_read(struct sc16is7x2_chip *ts, unsigned reg, unsig=
ned ch)
+{
+	return spi_w8r8(ts->spi, read_cmd(reg, ch));
+}
+
+/* ******************************** IRQ ********************************=
* */
+
+static void sc16is7x2_handle_rx(struct sc16is7x2_chip *ts, unsigned ch)
+{
+	struct sc16is7x2_channel *chan =3D &ts->channel[ch];
+	struct uart_port *uart =3D &chan->uart;
+	struct tty_struct *tty =3D uart->state->port.tty;
+	struct spi_message message;
+	struct spi_transfer t[2];
+	unsigned long flags;
+	u8 lsr =3D chan->lsr;
+	int rxlvl;
+
+	rxlvl =3D sc16is7x2_read(ts, REG_RXLVL, ch);
+	if (rxlvl <=3D 0) {
+		return;
+	} else if (rxlvl > FIFO_SIZE) {
+		/* Ensure sanity of RX level */
+		rxlvl =3D FIFO_SIZE;
+	}
+
+	dev_dbg(&ts->spi->dev, " %s (%i) %d bytes\n", __func__, ch, rxlvl);
+
+	memset(t, 0, sizeof t);
+	chan->buf[0] =3D read_cmd(UART_RX, ch);
+	t[0].len =3D 1;
+	t[0].tx_buf =3D &chan->buf[0];
+	t[1].len =3D rxlvl;
+	t[1].rx_buf =3D &chan->buf[1];
+
+	spi_message_init(&message);
+	spi_message_add_tail(&t[0], &message);
+	spi_message_add_tail(&t[1], &message);
+
+	if (spi_sync(ts->spi, &message)) {
+		dev_err(&ts->spi->dev, " SPI transfer RX handling failed\n");
+		return;
+	}
+	chan->buf[rxlvl + 1] =3D '\0';
+	dev_dbg(&ts->spi->dev, "%s\n", &chan->buf[1]);
+
+	spin_lock_irqsave(&uart->lock, flags);
+
+	if (unlikely(lsr & UART_LSR_BRK_ERROR_BITS)) {
+		/*
+		 * For statistics only
+		 */
+		if (lsr & UART_LSR_BI) {
+			lsr &=3D ~(UART_LSR_FE | UART_LSR_PE);
+			chan->uart.icount.brk++;
+			/*
+			 * We do the SysRQ and SAK checking
+			 * here because otherwise the break
+			 * may get masked by ignore_status_mask
+			 * or read_status_mask.
+			 */
+			if (uart_handle_break(&chan->uart))
+				goto ignore_char;
+		} else if (lsr & UART_LSR_PE)
+			chan->uart.icount.parity++;
+		else if (lsr & UART_LSR_FE)
+			chan->uart.icount.frame++;
+		if (lsr & UART_LSR_OE)
+			chan->uart.icount.overrun++;
+	}
+
+	/* Insert received data */
+	tty_insert_flip_string(tty, &chan->buf[1], rxlvl);
+	/* Update RX counter */
+	uart->icount.rx +=3D rxlvl;
+
+ignore_char:
+	spin_unlock_irqrestore(&uart->lock, flags);
+
+	/* Push the received data to receivers */
+	if (rxlvl)
+		tty_flip_buffer_push(tty);
+}
+
+static void sc16is7x2_handle_tx(struct sc16is7x2_chip *ts, unsigned ch)
+{
+	struct sc16is7x2_channel *chan =3D &ts->channel[ch];
+	struct uart_port *uart =3D &chan->uart;
+	struct circ_buf *xmit =3D &uart->state->xmit;
+	unsigned long flags;
+	unsigned i, len;
+	int txlvl;
+
+	if (chan->uart.x_char && chan->lsr & UART_LSR_THRE) {
+		dev_dbg(&ts->spi->dev, " tx: x-char\n");
+		sc16is7x2_write(ts, UART_TX, ch, uart->x_char);
+		uart->icount.tx++;
+		uart->x_char =3D 0;
+		return;
+	}
+	if (uart_circ_empty(xmit) || uart_tx_stopped(&chan->uart))
+		/* No data to send or TX is stopped */
+		return;
+
+	txlvl =3D sc16is7x2_read(ts, REG_TXLVL, ch);
+	if (txlvl <=3D 0) {
+		dev_dbg(&ts->spi->dev, " %s (%i) fifo full\n", __func__, ch);
+		return;
+	}
+
+	/* number of bytes to transfer to the fifo */
+	len =3D min(txlvl, (int)uart_circ_chars_pending(xmit));
+
+	dev_dbg(&ts->spi->dev, " %s (%i) %d bytes\n", __func__, ch, len);
+
+	spin_lock_irqsave(&uart->lock, flags);
+	for (i =3D 1; i <=3D len ; i++) {
+		chan->buf[i] =3D xmit->buf[xmit->tail];
+		xmit->tail =3D (xmit->tail + 1) & (UART_XMIT_SIZE - 1);
+	}
+	uart->icount.tx +=3D len;
+	spin_unlock_irqrestore(&uart->lock, flags);
+
+	chan->buf[0] =3D write_cmd(UART_TX, ch);
+	if (spi_write(ts->spi, chan->buf, len + 1))
+		dev_err(&ts->spi->dev, " SPI transfer TX handling failed\n");
+
+	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
+		uart_write_wakeup(uart);
+}
+
+static void sc16is7x2_handle_baud(struct sc16is7x2_chip *ts, unsigned ch=
)
+{
+	struct sc16is7x2_channel *chan =3D &ts->channel[ch];
+
+	if (!chan->handle_baud)
+		return;
+
+	dev_dbg(&ts->spi->dev, "%s\n", __func__);
+
+	sc16is7x2_write(ts, UART_IER, ch, 0);
+	sc16is7x2_write(ts, UART_LCR, ch, UART_LCR_DLAB); /* access DLL&DLM */
+	sc16is7x2_write(ts, UART_DLL, ch, chan->quot & 0xff);
+	sc16is7x2_write(ts, UART_DLM, ch, chan->quot >> 8);
+	sc16is7x2_write(ts, UART_LCR, ch, chan->lcr);     /* reset DLAB */
+
+	chan->handle_baud =3D false;
+}
+
+static void sc16is7x2_handle_regs(struct sc16is7x2_chip *ts, unsigned ch=
)
+{
+	struct sc16is7x2_channel *chan =3D &ts->channel[ch];
+
+	if (!chan->handle_regs)
+		return;
+
+	dev_dbg(&ts->spi->dev, "%s\n", __func__);
+
+        sc16is7x2_write(ts, UART_LCR, ch, 0xBF);  /* access EFR */
+	sc16is7x2_write(ts, UART_EFR, ch, chan->efr);
+	sc16is7x2_write(ts, UART_LCR, ch, chan->lcr);
+	sc16is7x2_write(ts, UART_FCR, ch, chan->fcr);
+	sc16is7x2_write(ts, UART_MCR, ch, chan->mcr);
+	sc16is7x2_write(ts, UART_IER, ch, chan->ier);
+
+	chan->handle_regs =3D false;
+}
+
+static void sc16is7x2_read_status(struct sc16is7x2_chip *ts, unsigned ch=
)
+{
+	struct sc16is7x2_channel *chan =3D &(ts->channel[ch]);
+/*	struct spi_message m;
+	struct spi_transfer t;
+	u8 *buf =3D chan->buf; */
+	u8 ier;
+
+#ifdef DEBUG
+	ier =3D sc16is7x2_read(ts, UART_IER, ch);
+#endif
+	chan->iir =3D sc16is7x2_read(ts, UART_IIR, ch);
+	chan->msr =3D sc16is7x2_read(ts, UART_MSR, ch);
+	chan->lsr =3D sc16is7x2_read(ts, UART_LSR, ch);
+/*
+	buf[0] =3D read_cmd(UART_IER, ch);
+	buf[1] =3D read_cmd(UART_IIR, ch);
+	buf[2] =3D read_cmd(UART_MSR, ch);
+	buf[3] =3D read_cmd(UART_LSR, ch);
+
+	t.tx_buf =3D buf;
+	t.rx_buf =3D &buf[16];
+	t.len =3D 5;
+
+	spi_message_init(&m);
+	spi_message_add_tail(&t, &m);
+	spi_sync(ts->spi, &m); */
+
+	dev_dbg(&ts->spi->dev, " %s ier=3D0x%02x iir=3D0x%02x msr=3D0x%02x lsr=3D=
0x%02x\n",
+			__func__, ier, chan->iir, chan->msr, chan->lsr);
+/*
+	dev_dbg(&ts->spi->dev, " %s ier=3D0x%02x iir=3D0x%02x msr=3D0x%02x lsr=3D=
0x%02x\n",
+			__func__, buf[17], buf[18], buf[19], buf[20]);
+*/
+}
+
+static void sc16is7x2_handle_channel(struct work_struct *w)
+{
+	struct sc16is7x2_channel *chan =3D
+			container_of(w, struct sc16is7x2_channel, work);
+	struct sc16is7x2_chip *ts =3D chan->chip;
+	unsigned ch =3D (chan =3D=3D ts->channel) ? 0 : 1;
+
+#ifdef DEBUG
+	dev_dbg(&ts->spi->dev, "%s (%i) %s\n", __func__, ch,
+			chan->handle_irq ? "irq" : "");
+	chan->handle_irq =3D false;
+#endif
+
+	do {
+		sc16is7x2_handle_baud(ts, ch);
+		sc16is7x2_handle_regs(ts, ch);
+
+		sc16is7x2_read_status(ts, ch);
+		sc16is7x2_handle_tx(ts, ch);
+		sc16is7x2_handle_rx(ts, ch);
+	} while (!(chan->iir & UART_IIR_NO_INT));
+
+	dev_dbg(&ts->spi->dev, "%s finished\n", __func__);
+}
+
+/* Trigger work thread*/
+static void sc16is7x2_dowork(struct sc16is7x2_channel *chan)
+{
+	if (!freezing(current))
+		queue_work(chan->workqueue, &chan->work);
+}
+
+static irqreturn_t sc16is7x2_irq(int irq, void *data)
+{
+	struct sc16is7x2_channel *chan =3D data;
+
+#ifdef DEBUG
+	/* Indicate irq */
+	chan->handle_irq =3D true;
+#endif
+
+	/* Trigger work thread */
+	sc16is7x2_dowork(chan);
+
+	return IRQ_HANDLED;
+}
+
+/* ******************************** UART *******************************=
** */
+
+#define to_sc16is7x2_channel(port) \
+		container_of(port, struct sc16is7x2_channel, uart)
+
+
+static unsigned int sc16is7x2_tx_empty(struct uart_port *port)
+{
+	struct sc16is7x2_channel *chan =3D to_sc16is7x2_channel(port);
+	struct sc16is7x2_chip *ts =3D chan->chip;
+	unsigned lsr;
+
+	dev_dbg(&ts->spi->dev, "%s =3D %s\n", __func__,
+			chan->lsr & UART_LSR_TEMT ? "yes" : "no");
+
+	lsr =3D chan->lsr;
+	return lsr & UART_LSR_TEMT ? TIOCSER_TEMT : 0;
+}
+
+static unsigned int sc16is7x2_get_mctrl(struct uart_port *port)
+{
+	struct sc16is7x2_channel *chan =3D to_sc16is7x2_channel(port);
+	struct sc16is7x2_chip *ts =3D chan->chip;
+	unsigned int status;
+	unsigned int ret;
+
+	dev_dbg(&ts->spi->dev, "%s (0x%02x)\n", __func__, chan->msr);
+
+	status =3D chan->msr;
+
+	ret =3D 0;
+	if (status & UART_MSR_DCD)
+		ret |=3D TIOCM_CAR;
+	if (status & UART_MSR_RI)
+		ret |=3D TIOCM_RNG;
+	if (status & UART_MSR_DSR)
+		ret |=3D TIOCM_DSR;
+	if (status & UART_MSR_CTS)
+		ret |=3D TIOCM_CTS;
+	return ret;
+}
+
+static void sc16is7x2_set_mctrl(struct uart_port *port, unsigned int mct=
rl)
+{
+	struct sc16is7x2_channel *chan =3D to_sc16is7x2_channel(port);
+	struct sc16is7x2_chip *ts =3D chan->chip;
+
+	dev_dbg(&ts->spi->dev, "%s (0x%02x)\n", __func__, mctrl);
+
+	/* TODO: set DCD and DSR
+	 * CTS/RTS is handled automatically
+	 */
+}
+
+static void sc16is7x2_stop_tx(struct uart_port *port)
+{
+	/* Do nothing */
+}
+
+static void sc16is7x2_start_tx(struct uart_port *port)
+{
+	struct sc16is7x2_channel *chan =3D to_sc16is7x2_channel(port);
+	struct sc16is7x2_chip *ts =3D chan->chip;
+
+	dev_dbg(&ts->spi->dev, "%s\n", __func__);
+
+	/* Trigger work thread for sending data */
+	sc16is7x2_dowork(chan);
+}
+
+static void sc16is7x2_stop_rx(struct uart_port *port)
+{
+	struct sc16is7x2_channel *chan =3D to_sc16is7x2_channel(port);
+	struct sc16is7x2_chip *ts =3D chan->chip;
+
+	dev_dbg(&ts->spi->dev, "%s\n", __func__);
+
+	chan->ier &=3D ~UART_IER_RLSI;
+	chan->uart.read_status_mask &=3D ~UART_LSR_DR;
+	chan->handle_regs =3D true;
+	/* Trigger work thread for doing the actual configuration change */
+	sc16is7x2_dowork(chan);
+}
+
+static void sc16is7x2_enable_ms(struct uart_port *port)
+{
+	struct sc16is7x2_channel *chan =3D to_sc16is7x2_channel(port);
+	struct sc16is7x2_chip *ts =3D chan->chip;
+
+	dev_dbg(&ts->spi->dev, "%s\n", __func__);
+
+	chan->ier |=3D UART_IER_MSI;
+	chan->handle_regs =3D true;
+	/* Trigger work thread for doing the actual configuration change */
+	sc16is7x2_dowork(chan);
+}
+
+static void sc16is7x2_break_ctl(struct uart_port *port, int break_state)=

+{
+	/* We don't support break control yet, do nothing */
+}
+
+static int sc16is7x2_startup(struct uart_port *port)
+{
+	struct sc16is7x2_channel *chan =3D to_sc16is7x2_channel(port);
+	struct sc16is7x2_chip *ts =3D chan->chip;
+	unsigned ch =3D (&ts->channel[1] =3D=3D chan) ? 1 : 0;
+	unsigned long flags;
+
+	dev_dbg(&ts->spi->dev, "\n%s (%d)\n", __func__, port->line);
+
+	/* Clear the interrupt registers. */
+	sc16is7x2_write(ts, UART_IER, ch, 0);
+	sc16is7x2_read_status(ts, ch);
+
+	/* Initialize work queue */
+	chan->workqueue =3D create_freezeable_workqueue("sc16is7x2");
+	if (!chan->workqueue) {
+		dev_err(&ts->spi->dev, "Workqueue creation failed\n");
+		return -EBUSY;
+	}
+	INIT_WORK(&chan->work, sc16is7x2_handle_channel);
+
+	/* Setup IRQ. Actually we have a low active IRQ, but we want
+	 * one shot behaviour */
+	if (request_irq(ts->spi->irq, sc16is7x2_irq,
+			IRQF_TRIGGER_FALLING | IRQF_SHARED,
+			"sc16is7x2", chan)) {
+		dev_err(&ts->spi->dev, "IRQ request failed\n");
+		destroy_workqueue(chan->workqueue);
+		chan->workqueue =3D NULL;
+		return -EBUSY;
+	}
+
+
+	spin_lock_irqsave(&chan->uart.lock, flags);
+	chan->lcr =3D UART_LCR_WLEN8;
+	chan->mcr =3D 0;
+	chan->fcr =3D 0;
+	chan->ier =3D UART_IER_RLSI | UART_IER_RDI | UART_IER_THRI;
+	spin_unlock_irqrestore(&chan->uart.lock, flags);
+
+	sc16is7x2_write(ts, UART_FCR, ch, UART_FCR_ENABLE_FIFO |
+		       UART_FCR_CLEAR_RCVR | UART_FCR_CLEAR_XMIT);
+	sc16is7x2_write(ts, UART_FCR, ch, chan->fcr);
+	/* Now, initialize the UART */
+	sc16is7x2_write(ts, UART_LCR, ch, chan->lcr);
+	sc16is7x2_write(ts, UART_MCR, ch, chan->mcr);
+	sc16is7x2_write(ts, UART_IER, ch, chan->ier);
+
+	return 0;
+}
+
+static void sc16is7x2_shutdown(struct uart_port *port)
+{
+	struct sc16is7x2_channel *chan =3D to_sc16is7x2_channel(port);
+	struct sc16is7x2_chip *ts =3D chan->chip;
+	unsigned long flags;
+	unsigned ch =3D port->line & 0x01;
+
+	dev_dbg(&ts->spi->dev, "%s\n", __func__);
+
+	BUG_ON(!chan);
+	BUG_ON(!ts);
+
+	/* Free the interrupt */
+	free_irq(ts->spi->irq, chan);
+
+	if (chan->workqueue) {
+		/* Flush and destroy work queue */
+		flush_workqueue(chan->workqueue);
+		destroy_workqueue(chan->workqueue);
+		chan->workqueue =3D NULL;
+	}
+
+	/* Suspend HW */
+	spin_lock_irqsave(&chan->uart.lock, flags);
+	chan->ier =3D UART_IERX_SLEEP;
+	spin_unlock_irqrestore(&chan->uart.lock, flags);
+	sc16is7x2_write(ts, UART_IER, ch, chan->ier);
+}
+
+static void
+sc16is7x2_set_termios(struct uart_port *port, struct ktermios *termios,
+		       struct ktermios *old)
+{
+	struct sc16is7x2_channel *chan =3D to_sc16is7x2_channel(port);
+	struct sc16is7x2_chip *ts =3D chan->chip;
+	unsigned long flags;
+	unsigned int baud;
+	u8 lcr, fcr =3D 0;
+
+	/* Ask the core to calculate the divisor for us. */
+	baud =3D uart_get_baud_rate(port, termios, old,
+				  port->uartclk / 16 / 0xffff,
+				  port->uartclk / 16);
+	chan->quot =3D uart_get_divisor(port, baud);
+	chan->handle_baud =3D true;
+
+	dev_dbg(&ts->spi->dev, "%s (baud %u)\n", __func__, baud);
+
+	/* set word length */
+	switch (termios->c_cflag & CSIZE) {
+	case CS5:
+		lcr =3D UART_LCR_WLEN5;
+		break;
+	case CS6:
+		lcr =3D UART_LCR_WLEN6;
+		break;
+	case CS7:
+		lcr =3D UART_LCR_WLEN7;
+		break;
+	default:
+	case CS8:
+		lcr =3D UART_LCR_WLEN8;
+		break;
+	}
+
+	if (termios->c_cflag & CSTOPB)
+		lcr |=3D UART_LCR_STOP;
+	if (termios->c_cflag & PARENB)
+		lcr |=3D UART_LCR_PARITY;
+	if (!(termios->c_cflag & PARODD))
+		lcr |=3D UART_LCR_EPAR;
+#ifdef CMSPAR
+	if (termios->c_cflag & CMSPAR)
+		lcr |=3D UART_LCR_SPAR;
+#endif
+
+	fcr =3D UART_FCR_ENABLE_FIFO;
+	/* configure the fifo */
+	if (baud < 2400)
+		fcr |=3D UART_FCR_TRIGGER_1;
+	else
+		fcr |=3D UART_FCR_R_TRIG_01 | UART_FCR_T_TRIG_10;
+
+	chan->efr =3D UART_EFR_ECB;
+	chan->mcr |=3D UART_MCR_RTS;
+	if (termios->c_cflag & CRTSCTS)
+		chan->efr |=3D UART_EFR_CTS | UART_EFR_RTS;
+
+	/*
+	 * Ok, we're now changing the port state.  Do it with
+	 * interrupts disabled.
+	 */
+	spin_lock_irqsave(&chan->uart.lock, flags);
+
+	/* we are sending char from a workqueue so enable */
+	chan->uart.state->port.tty->low_latency =3D 1;
+
+	/* Update the per-port timeout. */
+	uart_update_timeout(port, termios->c_cflag, baud);
+
+	chan->uart.read_status_mask =3D UART_LSR_OE | UART_LSR_THRE | UART_LSR_=
DR;
+	if (termios->c_iflag & INPCK)
+		chan->uart.read_status_mask |=3D UART_LSR_FE | UART_LSR_PE;
+	if (termios->c_iflag & (BRKINT | PARMRK))
+		chan->uart.read_status_mask |=3D UART_LSR_BI;
+
+	/* Characters to ignore */
+	chan->uart.ignore_status_mask =3D 0;
+	if (termios->c_iflag & IGNPAR)
+		chan->uart.ignore_status_mask |=3D UART_LSR_PE | UART_LSR_FE;
+	if (termios->c_iflag & IGNBRK) {
+		chan->uart.ignore_status_mask |=3D UART_LSR_BI;
+		/*
+		 * If we're ignoring parity and break indicators,
+		 * ignore overruns too (for real raw support).
+		 */
+		if (termios->c_iflag & IGNPAR)
+			chan->uart.ignore_status_mask |=3D UART_LSR_OE;
+	}
+
+	/* ignore all characters if CREAD is not set */
+	if ((termios->c_cflag & CREAD) =3D=3D 0)
+		chan->uart.ignore_status_mask |=3D UART_LSR_DR;
+
+	/* CTS flow control flag and modem status interrupts */
+	chan->ier &=3D ~UART_IER_MSI;
+	if (UART_ENABLE_MS(&chan->uart, termios->c_cflag))
+		chan->ier |=3D UART_IER_MSI;
+
+	chan->lcr =3D lcr;	/* Save LCR */
+	chan->fcr =3D fcr;	/* Save FCR */
+	chan->handle_regs =3D true;
+
+	spin_unlock_irqrestore(&chan->uart.lock, flags);
+
+	/* Trigger work thread for doing the actual configuration change */
+	sc16is7x2_dowork(chan);
+}
+
+static const char * sc16is7x2_type(struct uart_port *port)
+{
+	pr_debug("%s\n", __func__);
+	return TYPE_NAME;
+}
+
+static void sc16is7x2_release_port(struct uart_port *port)
+{
+	pr_debug("%s\n", __func__);
+}
+
+static int sc16is7x2_request_port(struct uart_port *port)
+{
+	pr_debug("%s\n", __func__);
+	return 0;
+}
+
+static void sc16is7x2_config_port(struct uart_port *port, int flags)
+{
+	struct sc16is7x2_channel *chan =3D to_sc16is7x2_channel(port);
+	struct sc16is7x2_chip *ts =3D chan->chip;
+
+	dev_dbg(&ts->spi->dev, "%s\n", __func__);
+	if (flags & UART_CONFIG_TYPE)
+		chan->uart.type =3D PORT_SC16IS7X2;
+}
+
+static int
+sc16is7x2_verify_port(struct uart_port *port, struct serial_struct *ser)=

+{
+	if (ser->type =3D=3D PORT_UNKNOWN || ser->type =3D=3D PORT_SC16IS7X2)
+		return 0;
+
+	return -EINVAL;
+}
+
+static struct uart_ops sc16is7x2_uart_ops =3D {
+	.tx_empty	=3D sc16is7x2_tx_empty,
+	.set_mctrl	=3D sc16is7x2_set_mctrl,
+	.get_mctrl	=3D sc16is7x2_get_mctrl,
+	.stop_tx        =3D sc16is7x2_stop_tx,
+	.start_tx	=3D sc16is7x2_start_tx,
+	.stop_rx	=3D sc16is7x2_stop_rx,
+	.enable_ms      =3D sc16is7x2_enable_ms,
+	.break_ctl      =3D sc16is7x2_break_ctl,
+	.startup	=3D sc16is7x2_startup,
+	.shutdown	=3D sc16is7x2_shutdown,
+	.set_termios	=3D sc16is7x2_set_termios,
+	.type		=3D sc16is7x2_type,
+	.release_port   =3D sc16is7x2_release_port,
+	.request_port   =3D sc16is7x2_request_port,
+	.config_port	=3D sc16is7x2_config_port,
+	.verify_port	=3D sc16is7x2_verify_port,
+};
+
+
+/* ******************************** GPIO *******************************=
** */
+
+#ifdef CONFIG_GPIOLIB
+
+static int sc16is7x2_gpio_request(struct gpio_chip *gpio, unsigned offse=
t)
+{
+	struct sc16is7x2_chip *ts =3D
+			container_of(gpio, struct sc16is7x2_chip, gpio);
+	int control =3D (offset < 4) ? IOC_GPIO30 : IOC_GPIO74;
+	int ret =3D 0;
+
+	BUG_ON(offset > 8);
+	dev_dbg(&ts->spi->dev, "%s: offset =3D %d\n", __func__, offset);
+
+	mutex_lock(&ts->io_lock);
+
+	/* GPIO 0:3 and 4:7 can only be controlled as block */
+	ts->io_gpio |=3D BIT(offset);
+	if (ts->io_control & control) {
+		dev_dbg(&ts->spi->dev, "activate GPIOs %s\n",
+				(offset < 4) ? "0-3" : "4-7");
+		ts->io_control &=3D ~control;
+		ret =3D sc16is7x2_write(ts, REG_IOC, 0, ts->io_control);
+	}
+
+	mutex_unlock(&ts->io_lock);
+
+	return ret;
+}
+
+static void sc16is7x2_gpio_free(struct gpio_chip *gpio, unsigned offset)=

+{
+	struct sc16is7x2_chip *ts =3D
+			container_of(gpio, struct sc16is7x2_chip, gpio);
+	int control =3D (offset < 4) ? IOC_GPIO30 : IOC_GPIO74;
+	int mask =3D (offset < 4) ? 0x0f : 0xf0;
+
+	BUG_ON(offset > 8);
+
+	mutex_lock(&ts->io_lock);
+
+	/* GPIO 0:3 and 4:7 can only be controlled as block */
+	ts->io_gpio &=3D ~BIT(offset);
+	dev_dbg(&ts->spi->dev, "%s: io_gpio =3D 0x%02X\n", __func__, ts->io_gpi=
o);
+	if (!(ts->io_control & control) && !(ts->io_gpio & mask)) {
+		dev_dbg(&ts->spi->dev, "deactivate GPIOs %s\n",
+				(offset < 4) ? "0-3" : "4-7");
+		ts->io_control |=3D control;
+		sc16is7x2_write(ts, REG_IOC, 0, ts->io_control);
+	}
+
+	mutex_unlock(&ts->io_lock);
+}
+
+static int sc16is7x2_direction_input(struct gpio_chip *gpio, unsigned of=
fset)
+{
+	struct sc16is7x2_chip *ts =3D
+			container_of(gpio, struct sc16is7x2_chip, gpio);
+	unsigned io_dir;
+
+	BUG_ON(offset > 8);
+
+	mutex_lock(&ts->io_lock);
+
+	ts->io_dir &=3D ~BIT(offset);
+	io_dir =3D ts->io_dir;
+
+	mutex_unlock(&ts->io_lock);
+
+	return sc16is7x2_write(ts, REG_IOD, 0, io_dir);
+}
+
+static int sc16is7x2_direction_output(struct gpio_chip *gpio, unsigned o=
ffset,
+				    int value)
+{
+	struct sc16is7x2_chip *ts =3D
+			container_of(gpio, struct sc16is7x2_chip, gpio);
+
+	BUG_ON(offset > 8);
+
+	mutex_lock(&ts->io_lock);
+
+	if (value)
+		ts->io_state |=3D BIT(offset);
+	else
+		ts->io_state &=3D ~BIT(offset);
+
+	ts->io_dir |=3D BIT(offset);
+
+	mutex_unlock(&ts->io_lock);
+
+	sc16is7x2_write(ts, REG_IOS, 0, ts->io_state);
+	return sc16is7x2_write(ts, REG_IOD, 0, ts->io_dir);
+}
+
+static int sc16is7x2_get(struct gpio_chip *gpio, unsigned offset)
+{
+	struct sc16is7x2_chip *ts =3D
+			container_of(gpio, struct sc16is7x2_chip, gpio);
+	int level =3D -EINVAL;
+
+	BUG_ON(offset > 8);
+
+	mutex_lock(&ts->io_lock);
+
+	if (ts->io_dir & BIT(offset)) {
+		/* Output: return cached level */
+		level =3D (ts->io_state >> offset) & 0x01;
+	} else {
+		/* Input: read out all pins */
+		level =3D sc16is7x2_read(ts, REG_IOS, 0);
+		if (level >=3D 0) {
+			ts->io_state =3D level;
+			level =3D (ts->io_state >> offset) & 0x01;
+		}
+	}
+
+	mutex_unlock(&ts->io_lock);
+
+	return level;
+}
+
+static void sc16is7x2_set(struct gpio_chip *gpio, unsigned offset, int v=
alue)
+{
+	struct sc16is7x2_chip *ts =3D
+			container_of(gpio, struct sc16is7x2_chip, gpio);
+	unsigned io_state;
+
+	BUG_ON(offset > 8);
+
+	mutex_lock(&ts->io_lock);
+
+	if (value)
+		ts->io_state |=3D BIT(offset);
+	else
+		ts->io_state &=3D ~BIT(offset);
+	io_state =3D ts->io_state;
+
+	mutex_unlock(&ts->io_lock);
+
+	sc16is7x2_write(ts, REG_IOS, 0, io_state);
+}
+
+#endif /* CONFIG_GPIOLIB */
+
+/* ******************************** INIT *******************************=
** */
+
+static struct uart_driver sc16is7x2_uart_driver;
+
+static int sc16is7x2_register_gpio(struct sc16is7x2_chip *ts,
+		struct sc16is7x2_platform_data *pdata)
+{
+#ifdef CONFIG_GPIOLIB
+	ts->gpio.label =3D (pdata->label) ? pdata->label : DRIVER_NAME;
+	ts->gpio.request	=3D sc16is7x2_gpio_request;
+	ts->gpio.free		=3D sc16is7x2_gpio_free;
+	ts->gpio.get		=3D sc16is7x2_get;
+	ts->gpio.set		=3D sc16is7x2_set;
+	ts->gpio.direction_input =3D sc16is7x2_direction_input;
+	ts->gpio.direction_output =3D sc16is7x2_direction_output;
+
+	ts->gpio.base =3D pdata->gpio_base;
+	ts->gpio.names =3D pdata->names;
+	ts->gpio.ngpio =3D SC16IS7X2_NR_GPIOS;
+	ts->gpio.can_sleep =3D 1;
+	ts->gpio.dev =3D &ts->spi->dev;
+	ts->gpio.owner =3D THIS_MODULE;
+
+	mutex_init(&ts->io_lock);
+
+	/* disable all GPIOs, enable on request */
+	ts->io_gpio =3D 0;
+	ts->io_control =3D IOC_GPIO30 | IOC_GPIO74;
+	ts->io_state =3D 0;
+	ts->io_dir =3D 0;
+
+	sc16is7x2_write(ts, REG_IOI, 0, 0); /* no support for irqs yet */
+	sc16is7x2_write(ts, REG_IOC, 0, ts->io_control);
+	sc16is7x2_write(ts, REG_IOS, 0, ts->io_state);
+	sc16is7x2_write(ts, REG_IOD, 0, ts->io_dir);
+
+	return gpiochip_add(&ts->gpio);
+#else
+	return 0;
+#endif
+}
+
+static int sc16is7x2_register_uart_port(struct sc16is7x2_chip *ts,
+		struct sc16is7x2_platform_data *pdata, unsigned ch)
+{
+	struct sc16is7x2_channel *chan =3D &(ts->channel[ch]);
+	struct uart_port *uart =3D &chan->uart;
+
+	/* Disable irqs and go to sleep */
+	sc16is7x2_write(ts, UART_IER, ch, UART_IERX_SLEEP);
+
+	chan->chip =3D ts;
+
+	uart->irq =3D ts->spi->irq;
+	uart->uartclk =3D pdata->uartclk;
+	uart->fifosize =3D FIFO_SIZE;
+	uart->ops =3D &sc16is7x2_uart_ops;
+	uart->flags =3D UPF_SKIP_TEST | UPF_BOOT_AUTOCONF;
+	uart->line =3D pdata->uart_base + ch;
+	uart->type =3D PORT_SC16IS7X2;
+	uart->dev =3D &ts->spi->dev;
+
+	return uart_add_one_port(&sc16is7x2_uart_driver, uart);
+}
+
+static int __devinit sc16is7x2_probe(struct spi_device *spi)
+{
+	struct sc16is7x2_chip *ts;
+	struct sc16is7x2_platform_data *pdata;
+	int ret;
+
+	/* Only even uart base numbers are supported */
+	pdata =3D spi->dev.platform_data;
+	if (!pdata || !pdata->gpio_base || pdata->uart_base & 1) {
+		dev_dbg(&spi->dev, "incorrect or missing platform data\n");
+		return -EINVAL;
+	}
+
+	ts =3D kzalloc(sizeof(struct sc16is7x2_chip), GFP_KERNEL);
+	if (!ts)
+		return -ENOMEM;
+
+	spi_set_drvdata(spi, ts);
+	ts->spi =3D spi;
+
+	/* Reset the chip */
+	sc16is7x2_write(ts, REG_IOC, 0, IOC_SRESET);
+
+	ret =3D sc16is7x2_register_uart_port(ts, pdata, 0);
+	if (ret)
+		goto exit_destroy;
+	ret =3D sc16is7x2_register_uart_port(ts, pdata, 1);
+	if (ret)
+		goto exit_uart0;
+
+	ret =3D sc16is7x2_register_gpio(ts, pdata);
+	if (ret)
+		goto exit_uart1;
+
+	dev_info(&spi->dev, DRIVER_NAME " at CS%d (irq %d), 2 UARTs, 8 GPIOs\n"=

+			"    eser%d, eser%d, gpiochip%d\n",
+			spi->chip_select, spi->irq,
+			pdata->uart_base, pdata->uart_base + 1,
+			pdata->gpio_base);
+
+	return 0;
+
+exit_uart1:
+	uart_remove_one_port(&sc16is7x2_uart_driver, &ts->channel[1].uart);
+
+exit_uart0:
+	uart_remove_one_port(&sc16is7x2_uart_driver, &ts->channel[0].uart);
+
+exit_destroy:
+	dev_set_drvdata(&spi->dev, NULL);
+	kfree(ts);
+	return ret;
+}
+
+static int __devexit sc16is7x2_remove(struct spi_device *spi)
+{
+	struct sc16is7x2_chip *ts =3D spi_get_drvdata(spi);
+	int ret;
+
+	if (ts =3D=3D NULL)
+		return -ENODEV;
+
+	ret =3D uart_remove_one_port(&sc16is7x2_uart_driver, &ts->channel[0].ua=
rt);
+	if (ret)
+		return ret;
+
+	ret =3D uart_remove_one_port(&sc16is7x2_uart_driver, &ts->channel[1].ua=
rt);
+	if (ret)
+		return ret;
+
+#ifdef CONFIG_GPIOLIB
+	ret =3D gpiochip_remove(&ts->gpio);
+	if (ret)
+		return ret;
+#endif
+
+	kfree(ts);
+
+	return 0;
+}
+
+static struct uart_driver sc16is7x2_uart_driver =3D {
+	.owner          =3D THIS_MODULE,
+	.driver_name    =3D DRIVER_NAME,
+	.dev_name       =3D "eser",
+	.nr             =3D MAX_SC16IS7X2,
+};
+
+/* Spi driver data */
+static struct spi_driver sc16is7x2_spi_driver =3D {
+	.driver =3D {
+		.name		=3D DRIVER_NAME,
+		.bus		=3D &spi_bus_type,
+		.owner		=3D THIS_MODULE,
+	},
+	.probe		=3D sc16is7x2_probe,
+	.remove		=3D __devexit_p(sc16is7x2_remove),
+};
+
+/* Driver init function */
+static int __init sc16is7x2_init(void)
+{
+	int ret =3D uart_register_driver(&sc16is7x2_uart_driver);
+	if (ret)
+		return ret;
+
+	return spi_register_driver(&sc16is7x2_spi_driver);
+}
+
+/* Driver exit function */
+static void __exit sc16is7x2_exit(void)
+{
+	spi_unregister_driver(&sc16is7x2_spi_driver);
+	uart_unregister_driver(&sc16is7x2_uart_driver);
+}
+
+/* register after spi postcore initcall and before
+ * subsys initcalls that may rely on these GPIOs
+ */
+subsys_initcall(sc16is7x2_init);
+module_exit(sc16is7x2_exit);
+
+MODULE_AUTHOR("Manuel Stahl");
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("SC16IS7x2 SPI based UART chip");
+MODULE_ALIAS("spi:" DRIVER_NAME);
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index a23fa29..28b9e85 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -45,7 +45,8 @@
 #define PORT_OCTEON	17	/* Cavium OCTEON internal UART */
 #define PORT_AR7	18	/* Texas Instruments AR7 internal UART */
 #define PORT_U6_16550A	19	/* ST-Ericsson U6xxx internal UART */
-#define PORT_MAX_8250	19	/* max port ID */
+#define PORT_SC16IS7X2	20	/* SC16IS7x2 SPI UART */
+#define PORT_MAX_8250	20	/* max port ID */
=20
 /*
  * ARM specific type numbers.  These are not currently guaranteed
@@ -202,6 +203,9 @@
 /* VIA VT8500 SoC */
 #define PORT_VT8500	97
=20
+/* SC16IS7x2 SPI UART */
+#define PORT_SC16IS7X2	98
+
 #ifdef __KERNEL__
=20
 #include <linux/compiler.h>
diff --git a/include/linux/serial_sc16is7x2.h b/include/linux/serial_sc16=
is7x2.h
new file mode 100755
index 0000000..931fe50
--- /dev/null
+++ b/include/linux/serial_sc16is7x2.h
@@ -0,0 +1,17 @@
+#ifndef LINUX_SPI_SC16IS752_H
+#define LINUX_SPI_SC16IS752_H
+
+#define SC16IS7X2_NR_GPIOS 8
+
+struct sc16is7x2_platform_data {
+	unsigned int	uartclk;
+	/* uart line number of the first channel */
+	unsigned	uart_base;
+	/* number assigned to the first GPIO */
+	unsigned	gpio_base;
+	char		*label;
+	/* list of GPIO names (array length =3D SC16IS7X2_NR_GPIOS) */
+	const char	*const *names;
+};
+
+#endif

--------------080008000605030805080201--

--------------ms010300090103010503000509
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIUWDCC
BC4wggMWoAMCAQICAgEMMA0GCSqGSIb3DQEBBQUAMHExCzAJBgNVBAYTAkRFMRwwGgYDVQQK
ExNEZXV0c2NoZSBUZWxla29tIEFHMR8wHQYDVQQLExZULVRlbGVTZWMgVHJ1c3QgQ2VudGVy
MSMwIQYDVQQDExpEZXV0c2NoZSBUZWxla29tIFJvb3QgQ0EgMjAeFw0wNzEyMDUxNTE4NTha
Fw0xOTA2MzAyMzU5NTlaMGcxCzAJBgNVBAYTAkRFMRMwEQYDVQQKEwpGcmF1bmhvZmVyMSEw
HwYDVQQLExhGcmF1bmhvZmVyIENvcnBvcmF0ZSBQS0kxIDAeBgNVBAMTF0ZyYXVuaG9mZXIg
Um9vdCBDQSAyMDA3MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwz0eyWWNW4g3
9z7BIbZU3rA6VxsaHO6YCHQBWm+13zZXK0RFzvNGE2V2lZhUx6iFFW4SpBfoC+EhpzE9Kd3/
o9ZP0rSJ/WNK2qtT71kFtE/iOyqRmcDLZVeBozCTkA7Jvf0VMjIIpEh8VgXyuzaJ4kjCb0uS
DCVFvq0+1McB7bHIErQwCG6nb396IKe7tOU1gFQsGY/ZS8Adq0P4YRSU+7AdXbeR7GLAkdFe
3acLsy0fZjkYPK4EFOXSfTbZss2nE7DMRZ1WBFFxMzZcL11RE55PSJAOl1pLcNu5edmh1pTI
ktCl+2C/La2ecQAXhsD9SGadFEwFTkzRcUQL0HoPsQIDAQABo4HZMIHWMB8GA1UdIwQYMBaA
FDHDeRu69VPXF+CJei0XbAqzK50zMA4GA1UdDwEB/wQEAwIBBjAdBgNVHQ4EFgQUL0VCHjEF
gNVw2PgdV8tbetU9nPcwEgYDVR0TAQH/BAgwBgEB/wIBATBwBgNVHR8EaTBnMGWgY6Bhhl9o
dHRwOi8vcGtpLnRlbGVzZWMuZGUvY2dpLWJpbi9zZXJ2aWNlL2FmX0Rvd25sb2FkQVJMLmNy
bD8tY3JsX2Zvcm1hdD1YXzUwOSYtaXNzdWVyPURUX1JPT1RfQ0FfMjANBgkqhkiG9w0BAQUF
AAOCAQEAGrdMejzl3cJjst6GJU5FYkz08o9fXdfljc4O1/WU4YuTMTanmiPnZ+FSwVoY1pnh
gGQ4D0o1M11meijcOH83cs1SdW4Qjmx9jPcp63fCuRkF1Lc9YbroBRLUUGJT7yJUYvxNAcNe
1A2DdGlR1TyerNukK3xthJbTcU3P1S1xo5LEP1XPmz0jdwdX6cjOHZe2M/uRl2CWD/f23m8l
kBKrGUfVRCOuwZI1KL8qQ14P6gdd0kTQhYLjErxH6iyt+PBBUn02uiKfeqAy70u8+ToHtinG
fThfNVV+OPI/fLPuLW4heF+5E8/v3mWAyCX1Zi1USq3O2S4OMM+AM6eLGXLqQTCCBMYwggOu
oAMCAQICCmEdMxkAAAAAAAMwDQYJKoZIhvcNAQEFBQAwZzELMAkGA1UEBhMCREUxEzARBgNV
BAoTCkZyYXVuaG9mZXIxITAfBgNVBAsTGEZyYXVuaG9mZXIgQ29ycG9yYXRlIFBLSTEgMB4G
A1UEAxMXRnJhdW5ob2ZlciBSb290IENBIDIwMDcwHhcNMDcxMjEyMTQ0OTM1WhcNMTkwNjMw
MjM1OTU5WjBnMQswCQYDVQQGEwJERTETMBEGA1UEChMKRnJhdW5ob2ZlcjEhMB8GA1UECxMY
RnJhdW5ob2ZlciBDb3Jwb3JhdGUgUEtJMSAwHgYDVQQDExdGcmF1bmhvZmVyIFVzZXIgQ0Eg
MjAwNzCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMJ0EFHLddGB8Ss1nVqCOq+S
rs0C/K7I+yB3Dv9oEhWQSadnfGgkX/oOJhplPkqeCQrTh08zEYprVaJLTaVPVhvjx3h5+KML
3lVGZIfajA89TolhLwk+ml29VbqV5nLhNrSwdZy157b6dCu5JffxvpO5wXCn95Z/TLyLdeux
gVHs/MnhczvmBbBRS+Ow9UoKn+PZvyYmUEdOHg8cA5PGFaRP9q88q734VnlI+W4+y7BoN5wt
uqVrqWbbpOQ2sHYo9riv3b+x5WdsMrVieKGApQ/dNvgB5vuuAchRnsANZHgpAiPCzP7/QFYY
qk2undcxEXwPgo72oifB3uQZ3xHOV/cCAwEAAaOCAXIwggFuMBIGA1UdEwEB/wQIMAYBAf8C
AQAwHQYDVR0OBBYEFE8dr4jKbbiqHAn5xdER7Vm0k/oLMA4GA1UdDwEB/wQEAwIBBjAfBgNV
HSMEGDAWgBQvRUIeMQWA1XDY+B1Xy1t61T2c9zB1BgNVHR8EbjBsMGqgaKBmhjFodHRwOi8v
Y3JsLnBraS5mcmF1bmhvZmVyLmRlL2ZoZy1yb290LWNhLTIwMDcuY3JshjFodHRwOi8vY3Js
LmZyYXVuaG9mZXItcGtpLmRlL2ZoZy1yb290LWNhLTIwMDcuY3JsMIGQBggrBgEFBQcBAQSB
gzCBgDA+BggrBgEFBQcwAoYyaHR0cDovL2NlcnQucGtpLmZyYXVuaG9mZXIuZGUvZmhnLXJv
b3QtY2EtMjAwNy5jZXIwPgYIKwYBBQUHMAKGMmh0dHA6Ly9jZXJ0LmZyYXVuaG9mZXItcGtp
LmRlL2ZoZy1yb290LWNhLTIwMDcuY2VyMA0GCSqGSIb3DQEBBQUAA4IBAQAAd2yMM/nuVwQl
ysuIOeZOTKTOwpZLGYZNuERXwpWpEDfsMFUxX/Wetbu1a1qhd+x6SyXY4V1CzcFDOGF3wA7b
yIV/6dyC53I9luZTjy9zjUsjLZucD4jeNja3QEu39sQsYsuE3MTfFFJgr/NeAFMHVkkHGx3l
VXb+F3J3+9xeXHk/wB/yIKd/RIiMMTT4+a+ra2MTCsYAe4kgJ0vz2TXYGN8tujjCgsUUbwfJ
C9wrOiCJMNJM1i7sUVqVKIoswW7h5QpWUNu1E4RAsDEz7depXCYaAIwPprEIkr0dE63zqHhm
M4egS7iGmBfNQohUO6jJOWNcJ9dIxqc0c/4WUHg8MIIFpDCCBIygAwIBAgIKXts1tgAAAACh
VTANBgkqhkiG9w0BAQUFADBnMQswCQYDVQQGEwJERTETMBEGA1UEChMKRnJhdW5ob2ZlcjEh
MB8GA1UECxMYRnJhdW5ob2ZlciBDb3Jwb3JhdGUgUEtJMSAwHgYDVQQDExdGcmF1bmhvZmVy
IFVzZXIgQ0EgMjAwNzAeFw0wOTEyMDkxNDQ3MTlaFw0xNTEyMDgxNDQ3MTlaMFgxCzAJBgNV
BAYTAkRFMRMwEQYDVQQKEwpGcmF1bmhvZmVyMQwwCgYDVQQLEwNJSVMxDzANBgNVBAsTBlBl
b3BsZTEVMBMGA1UEAxMMTWFudWVsIFN0YWhsMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIB
CgKCAQEAyc3xmHk19YZAmko+jIM52UsU0keIMlZuSsQvl7HCAGEzifKcfmrR6EX1lYPUKVZJ
BpqMSG3jyA4GW6gR/7cwz0IbnwFPC40KHPODRVIWDIJbZrP6zl+hF+G6/ZTe7ttPahSNhfeq
wkhQZJYQwoxEPoaODFpgQ8St+WRRkgfi3jvjuUIddgWV4NyVAm6m5fmF9a6iv20e+ZSW0As7
brNVf4Xvl5+y58MWniD3hjryz2OsqH1+NrFk8dxPjR4z3tWfty4x4J5af1z25tKX3xnJtx6Q
l61FI1UlSUqR3DHxkmLY7RRCccxtpwOES2YgmBBpJzrxCJ+cYwVJIVHR7I/3qwIDAQABo4IC
XzCCAlswDgYDVR0PAQH/BAQDAgbAMCkGA1UdEQQiMCCBHm1hbnVlbC5zdGFobEBpaXMuZnJh
dW5ob2Zlci5kZTAdBgNVHQ4EFgQUbNwp94oWTogPsGGtBT3dcKtNhXUwHwYDVR0jBBgwFoAU
Tx2viMptuKocCfnF0RHtWbST+gswdQYDVR0fBG4wbDBqoGigZoYxaHR0cDovL2NybC5wa2ku
ZnJhdW5ob2Zlci5kZS9maGctdXNlci1jYS0yMDA3LmNybIYxaHR0cDovL2NybC5mcmF1bmhv
ZmVyLXBraS5kZS9maGctdXNlci1jYS0yMDA3LmNybDCCAQoGCCsGAQUFBwEBBIH9MIH6MD4G
CCsGAQUFBzAChjJodHRwOi8vY2VydC5wa2kuZnJhdW5ob2Zlci5kZS9maGctdXNlci1jYS0y
MDA3LmNlcjA+BggrBgEFBQcwAoYyaHR0cDovL2NlcnQuZnJhdW5ob2Zlci1wa2kuZGUvZmhn
LXVzZXItY2EtMjAwNy5jZXIwOwYIKwYBBQUHMAGGL2h0dHA6Ly9maGctdXNlci1jYS0yMDA3
Lm9jc3AucGtpLmZyYXVuaG9mZXIuZGUvMDsGCCsGAQUFBzABhi9odHRwOi8vZmhnLXVzZXIt
Y2EtMjAwNy5vY3NwLmZyYXVuaG9mZXItcGtpLmRlLzATBgNVHSUEDDAKBggrBgEFBQcDBDBE
BgNVHSAEPTA7MDkGCysGAQQBhgpQAwEBMCowKAYIKwYBBQUHAgEWHGh0dHA6Ly9wa2kuZnJh
dW5ob2Zlci5kZS9jcC8wDQYJKoZIhvcNAQEFBQADggEBACWdlXdPPIhNtjC0aYQgGYQ9+e0N
XHqtaQsxgzZ2D4Rp34VeuZPWkF/YMDXgxB9sarzCO4WcBxz0QWjWiQOtAYzPc+2U3C3Pyw6Y
Mc0yxSpg6R602Hy/O1aNn7XZ50gujpIjuwo0fAFhg8OI63uolkgKAYyoUcTRHc4Z4kwb8bgg
+5a56lKIqBwTweqd2VaNnW0FCfk5bJsaw2j3bHnWkS2D9BWt0U+t+/zCqMYT9E38vTP57kho
vpb44u+8m6Xaaorn3bCK2WzHH5HZp/mVEZ6TZw+mJ+Ltjrcnz+9JAFYZxtpSpZN/k1zRM0P6
6CKxV9JfFqwQJnso0LtpcfLFGuMwggWwMIIEmKADAgECAgpe2zMWAAAAAKFUMA0GCSqGSIb3
DQEBBQUAMGcxCzAJBgNVBAYTAkRFMRMwEQYDVQQKEwpGcmF1bmhvZmVyMSEwHwYDVQQLExhG
cmF1bmhvZmVyIENvcnBvcmF0ZSBQS0kxIDAeBgNVBAMTF0ZyYXVuaG9mZXIgVXNlciBDQSAy
MDA3MB4XDTA5MTIwOTE0NDcxOVoXDTE1MTIwODE0NDcxOVowWDELMAkGA1UEBhMCREUxEzAR
BgNVBAoTCkZyYXVuaG9mZXIxDDAKBgNVBAsTA0lJUzEPMA0GA1UECxMGUGVvcGxlMRUwEwYD
VQQDEwxNYW51ZWwgU3RhaGwwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC18idY
1AthSSVhkq1AFUnVfm5pzin5dEuixfJs+PaEQah9OWHYqSCxvXYL/58MtfpCsMl8HpIUsnuh
O4GPDjdxawgLSItU/LCF5/cmdc6swyi2efJC5QviHJ/aB/MbD3TKl9aGQXE0K85/iS4KQT2c
GM8uvWhF3yNNJIuauJ8BMX55vyelXT1rsldiGsBwKQ2PRcoM24jdtw/4DigsImSAkV6rxgg7
CeV92wE1trfx7OOoK9PPgAE9D95oiZz25f2MH7NnD4Wzo+73chdoQnhPZHNBojcxdyg+Rf3O
PCuKfXLYdTgEzEFGNFIwojaKoJ2ws1t2z3O62h7Tye0EMBtTAgMBAAGjggJrMIICZzAOBgNV
HQ8BAf8EBAMCBDAwKQYDVR0RBCIwIIEebWFudWVsLnN0YWhsQGlpcy5mcmF1bmhvZmVyLmRl
MB0GA1UdDgQWBBR3QN2wMBSsk+rxgVGtX5Plvb9tNzAfBgNVHSMEGDAWgBRPHa+Iym24qhwJ
+cXREe1ZtJP6CzB1BgNVHR8EbjBsMGqgaKBmhjFodHRwOi8vY3JsLnBraS5mcmF1bmhvZmVy
LmRlL2ZoZy11c2VyLWNhLTIwMDcuY3JshjFodHRwOi8vY3JsLmZyYXVuaG9mZXItcGtpLmRl
L2ZoZy11c2VyLWNhLTIwMDcuY3JsMIIBCgYIKwYBBQUHAQEEgf0wgfowPgYIKwYBBQUHMAKG
Mmh0dHA6Ly9jZXJ0LnBraS5mcmF1bmhvZmVyLmRlL2ZoZy11c2VyLWNhLTIwMDcuY2VyMD4G
CCsGAQUFBzAChjJodHRwOi8vY2VydC5mcmF1bmhvZmVyLXBraS5kZS9maGctdXNlci1jYS0y
MDA3LmNlcjA7BggrBgEFBQcwAYYvaHR0cDovL2ZoZy11c2VyLWNhLTIwMDcub2NzcC5wa2ku
ZnJhdW5ob2Zlci5kZS8wOwYIKwYBBQUHMAGGL2h0dHA6Ly9maGctdXNlci1jYS0yMDA3Lm9j
c3AuZnJhdW5ob2Zlci1wa2kuZGUvMB8GA1UdJQQYMBYGCisGAQQBgjcKAwQGCCsGAQUFBwME
MEQGA1UdIAQ9MDswOQYLKwYBBAGGClADAQEwKjAoBggrBgEFBQcCARYcaHR0cDovL3BraS5m
cmF1bmhvZmVyLmRlL2NwLzANBgkqhkiG9w0BAQUFAAOCAQEAIny6T0ZtZyrpF4dLpcM6G07I
HDC4cdGFLqfnqRLfMLwgdgxACPkYB8VbApcGKiSxcXaZEaz8CLLMrdwXkta1o+ZA6dz90Y1T
dYlvHvdsuhGeIkNwlJoGwlf4Ts4+7pi2d7sbYX3GFSzD3KcBn6DJp71pl4+MEcvkwVVaBKCw
+ohHssiRmG40fYAmdxBqPmjGyer4PftJdkvZQqmhqVDFp1NTJU9k/CQaIB24iSnuXfjHi1+z
Lz4flTgIGuN6lNAKGGt51kBl+WGy8olUDuyMwFAP7f1WIK4OWKWK0SbmMeDZtdN/aEpRRQ6l
0QATNFeFf1cK8auS+lRgG7lj74w/KzGCA24wggNqAgEBMHUwZzELMAkGA1UEBhMCREUxEzAR
BgNVBAoTCkZyYXVuaG9mZXIxITAfBgNVBAsTGEZyYXVuaG9mZXIgQ29ycG9yYXRlIFBLSTEg
MB4GA1UEAxMXRnJhdW5ob2ZlciBVc2VyIENBIDIwMDcCCl7bNbYAAAAAoVUwCQYFKw4DAhoF
AKCCAc4wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTEwMTA3
MTUxNDQwWjAjBgkqhkiG9w0BCQQxFgQUbfhWyslUPdZth3WiaHMbkWNsEZ0wXwYJKoZIhvcN
AQkPMVIwUDALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqG
SIb3DQMCAgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGEBgkrBgEEAYI3EAQxdzB1MGcx
CzAJBgNVBAYTAkRFMRMwEQYDVQQKEwpGcmF1bmhvZmVyMSEwHwYDVQQLExhGcmF1bmhvZmVy
IENvcnBvcmF0ZSBQS0kxIDAeBgNVBAMTF0ZyYXVuaG9mZXIgVXNlciBDQSAyMDA3Agpe2zMW
AAAAAKFUMIGGBgsqhkiG9w0BCRACCzF3oHUwZzELMAkGA1UEBhMCREUxEzARBgNVBAoTCkZy
YXVuaG9mZXIxITAfBgNVBAsTGEZyYXVuaG9mZXIgQ29ycG9yYXRlIFBLSTEgMB4GA1UEAxMX
RnJhdW5ob2ZlciBVc2VyIENBIDIwMDcCCl7bMxYAAAAAoVQwDQYJKoZIhvcNAQEBBQAEggEA
ZdeQyVatrReJNKGspq02ey1RcAYJUqh1F3Wsnq8hGXa9eZsrc99drF7AIihZ5oKeDPpGnmPh
vCsD86QPjJs5L2+3dwv+yzpTR3oRTzpOcaJyCT9R844VB9Spo7WjskkCSp11E4qp303Mqav5
AUw+/1/POvDm+igzUvFzDr0Hd6simB/JVj4E4a0EXkP3n8VWBUCqtenCh2COy28YvemepM/2
ZDa8borFwjdSarwq3DJelU4jbODAjSGA8rzWMQpGcAp42SFiw560hiOzpL4O7xo8fmb4OCCc
L2jir6aKORf4NE8/5R2CfiajhGNQLapTZN4Y3oZX3C0nFvpnTinrHgAAAAAAAA==
--------------ms010300090103010503000509--
