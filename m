Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170Ab0KLKJ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 05:09:28 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39126 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752891Ab0KLKJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 05:09:26 -0500
Date: Fri, 12 Nov 2010 10:07:28 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Cc: Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Mike Frysinger <vapier@gentoo.org>, Feng Tang <feng.tang@intel.com>,
        Tobias Klauser <tklauser@distanz.ch>, linux-kernel@vger.kernel.org,
        yong.y.wang@intel.com, qi.wang@intel.com, kok.howg.ewe@intel.com,
        andrew.chih.howe.khor@intel.com
Subject: Re: [PATCH v2] EG20T: Update PCH_UART driver to 2.6.36
Message-ID: <20101112100728.103fdc0b@lxorguk.ukuu.org.uk>
In-Reply-To: <4CDCACAE.2050804@dsn.okisemi.com>
References: <4CDCACAE.2050804@dsn.okisemi.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Nov 2010 11:55:42 +0900
Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com> wrote:

> Hi Alan,
> 
> I have modified for your indications.
> (As to details, please refer previous my response mail)
> Please check below.

Thanks.. More comments below

I have looked at the locking and agree it looks right.

+#include <linux/interrupt.h>
+#include <linux/io.h>
+
+#ifdef CONFIG_PCH_DMA
+#include <linux/dmaengine.h>
+#include <linux/pch_dma.h>
+#endif

You do not need this ifdef. Even if you are not using the DMA feature it
will still compile. DMA/non-DMA needs to be runtime. See below

+enum {
+	PCH_UART_HAL_INVALID_PARAM = EINVAL,
+	PCH_UART_HAL_NOT_INITIALIZED = 256,
+	PCH_UART_HAL_NOT_REQUESTED,
+	PCH_UART_HAL_BASE_NOT_SET,
+	PCH_UART_HAL_INVALID_BAUD,
+	PCH_UART_HAL_INVALID_PARITY,
+	PCH_UART_HAL_INVALID_WLS,
+	PCH_UART_HAL_INVALID_FIFO_CLR,
+	PCH_UART_HAL_INVALID_DMAMODE,
+	PCH_UART_HAL_INVALID_FIFOSIZE,
+	PCH_UART_HAL_INVALID_TRIGGER,
+	PCH_UART_HAL_INVALID_STB,
+	PCH_UART_HAL_READ_ERROR,
+};

These should be replaced with ordinary Linux error codes in the functions.

+struct eg20t_port {
+	struct uart_port port;
+	int port_type;
+	void __iomem *membase;
+	resource_size_t mapbase;
+	unsigned int iobase;
+	struct pci_dev *pdev;
+	int fifo_size;
+	int base_baud;
+	int start_tx;
+	int start_rx;
+	int tx_empty;
+	int int_dis_flag;
+	int trigger;
+	int trigger_level;
+	struct pch_uart_buffer rxbuf;
+	unsigned int dmsr;
+	unsigned int fcr;
+#ifdef CONFIG_PCH_DMA
+	struct dma_async_tx_descriptor	*desc_tx;
+	struct dma_async_tx_descriptor	*desc_rx;
+	struct pch_dma_slave		param_tx;
+	struct pch_dma_slave		param_rx;
+	struct dma_chan			*chan_tx;
+	struct dma_chan			*chan_rx;
+	struct scatterlist		sg_tx;
+	struct scatterlist		sg_rx;
+	int				tx_dma_use;
+	void				*rx_buf_virt;
+	dma_addr_t			rx_buf_dma;
+#endif
+};

+static unsigned int get_msr(struct eg20t_port *priv, void __iomem *base)
+{
+	unsigned int msr = ioread8(base + PCH_UART_MSR);
+	priv->dmsr |= msr & PCH_UART_MSR_DELTA;
+
+	return msr;

msr should be a u8 ? Is there a reason priv->dmsr is unsigned int ?

+static void pch_uart_hal_enable_interrupt(struct eg20t_port *priv,
+					  unsigned int flag)
+{
+	unsigned int ier = ioread8(priv->membase + PCH_UART_IER);
+	ier |= flag & PCH_UART_IER_MASK;
+	iowrite8(ier, priv->membase + PCH_UART_IER);
+}

Same for ier and fcr ?

+static int pch_uart_hal_read(struct eg20t_port *priv, unsigned char *buf,
+			     int rx_size)
+{
+	int i;
+	unsigned int rbr, lsr;
+
+	lsr = ioread8(priv->membase + PCH_UART_LSR);
+	for (i = 0, lsr = ioread8(priv->membase + PCH_UART_LSR);
+	     i < rx_size && lsr & PCH_UART_LSR_DR;
+	     lsr = ioread8(priv->membase + PCH_UART_LSR)) {
+		rbr = ioread8(priv->membase + PCH_UART_RBR);
+		buf[i++] = (unsigned char)rbr;
+	}

Same again here - which would also lose the cast

+static int pch_uart_hal_get_line_status(struct eg20t_port *priv)
+{
+	unsigned int lsr;
+	int ret;
+
+	lsr = ioread8(priv->membase + PCH_UART_LSR);
+	ret = (int)lsr;

And here

+static int push_rx(struct eg20t_port *priv, const unsigned char *buf,
+		   int size)
+{
+	struct uart_port *port;
+	struct tty_struct *tty;
+	int sz, i, j;
+	int loop;
+	int pushed;
+
+	port = &priv->port;
+	tty = tty_port_tty_get(&port->state->port);
+	if (!tty) {
+		pr_info("%s:tty is busy now", __func__);
+		return -EBUSY;
+	}

Don't log this. It is a perfectly normal situation - no pr_info needed
(pr_debug if testing perhaps)

+
+	for (pushed = 0, i = 0, loop = 1; (pushed < size) && loop;
+	     pushed += sz, i++) {
+		sz = tty_insert_flip_string(tty, &buf[pushed], size - pushed);
+		for (j = 0; (j < 100000) && (sz == 0); j++) {
+			tty_flip_buffer_push(tty);
+			sz = tty_insert_flip_string(tty, &buf[pushed],
+						    size - pushed);
+		}
+		if (sz == 0)
+			loop = 0;
+	}

This should not be needed. tty_insert_flip_string tries to insert as much as
it can. Except when tty->low_latency is set, which requires the call is not
from an interrupt handler the flip_buffer_push will queue data to the line
discipline it will not make space.

+	room = tty_buffer_request_room(tty, size);
+
+	if (room < size)
+		dev_warn(port->dev, "Rx overrun: dropping %u bytes\n",
+			 size - room);
+	if (!room)
+		return room;
+
+	for (i = 0; i < room; i++) {
+		tty_insert_flip_char(tty, ((u8 *)sg_virt(&priv->sg_rx))[i],
+				     TTY_NORMAL);
+	}

You can replace all of that with a single call to tty_insert_flip_string ?

+	struct tty_struct *tty = tty_port_tty_get(&port->state->port);
+	if (!tty) {
+		pr_info("%s:tty is busy now", __func__);

Again don't log this.

+static void pch_uart_send_xchar(struct uart_port *port, char ch)
+{
+}

??

+	ret = pch_uart_hal_set_fifo(priv, PCH_UART_HAL_DMA_MODE0,
+				    fifo_size, priv->trigger);

Is this missing check intentional ?
+
+	ret = request_irq(priv->port.irq, pch_uart_interrupt, IRQF_SHARED,
+			KBUILD_MODNAME, priv);
+
+	if (ret < 0)
+		return ret;


+static int pch_uart_verify_port(struct uart_port *port,
+                               struct serial_struct *serinfo)
+{
+       return 0;
+}


As you don't support low latency you want to do

static int pch_uart_verify_port(struct uart_port *port,
                               struct serial_struct *serinfo)
{
	if (serinfo->flags & UPF_LOW_LATENCY)
		return -EOPNOTSUPP;
	return 0;
}

(A few other drivers also miss this)


What you could also consider doing is


static int pch_uart_verify_port(struct uart_port *port,
                               struct serial_struct *serinfo)
{
	if (serinfo->flags & UPF_LOW_LATENCY)
		use_pio_modes;
		/* Avoid tty->low_latency being set as we do not support it */
		serinfo->flags &= ~UPF_LOW_LATENCY;
	} else
		use_dma_modes;
	return 0;
}

I think that would make "setserial /dev/ttyPCH0 low_latency" select PIO
and the reverse "setserial /dev/ttyPCH0 ^low_latency" select DMA mode but it
would need testing to make sure that it is all that is needed.
