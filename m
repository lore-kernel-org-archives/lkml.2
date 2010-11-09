Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275Ab0KIK6E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 05:58:04 -0500
Received: from mga14.intel.com ([143.182.124.37]:65019 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755085Ab0KIK6A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 05:58:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,174,1288594800"; 
   d="scan'208";a="346376485"
Date: Tue, 9 Nov 2010 10:37:37 +0000
From: Alan Cox <alan@linux.intel.com>
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Mike Frysinger <vapier@gentoo.org>,
        Feng Tang <feng.tang@intel.com>, Tobias Klauser <tklauser@distanz.ch>,
        linux-kernel@vger.kernel.org, yong.y.wang@intel.com, qi.wang@intel.com,
        kok.howg.ewe@intel.com, andrew.chih.howe.khor@intel.com
Subject: Re: [PATCH] EG20T: Update PCH_UART driver to 2.6.36
Message-ID: <20101109103737.40bfab7b@linux.intel.com>
In-Reply-To: <4CD8D5A2.1080202@dsn.okisemi.com>
References: <4CD8D5A2.1080202@dsn.okisemi.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> +#ifdef CONFIG_PCH_DMA
> + #include <linux/dmaengine.h>
> + #include <linux/pch_dma.h>
> +#endif

The PCH DMA will have been included in the kernel anyway before this
merge so you can remove the ifdefs and include it regardless


> +#if !defined(PORT_PCH_256FIFO) || !defined(PORT_PCH_64FIFO)
> + #undef PORT_PCH_256FIFO
> + #undef PORT_PCH_64FIFO
> + #define PORT_PCH_256FIFO	(PORT_MAX_8250+1) /* PCH UART with
> 256 byte
> +						     FIFO */
> + #define PORT_PCH_64FIFO	(PORT_MAX_8250+2) /* PCH UART with
> 64 byte
> +						     FIFO */
> +#endif

FIFO config really all wants to be done at runtime.



> +static inline void wr(void __iomem *addr, unsigned int value)
> +{
> +#if PCH_UART_DMA_REG_BOUNDARY == 4
> +	iowrite32(value, addr);
> +#else
> +	iowrite8(value, (void *)addr);

Why the cast ?

> +#endif

Again you've got magic ifdefs with no explanation ?
> +}
> +
> +static void pch_uart_hal_request(struct pci_dev *pdev, int fifosize,
> +				 int base_baud)
> +{
> +	struct eg20t_port *priv = pci_get_drvdata(pdev);
> +
> +	priv->trigger_level = 1;
> +	priv->fcr = 0;
> +}
> +
> +static int __get_msr(struct eg20t_port *priv, void __iomem *base)
> +{

Please avoid __ names for functions

> +	unsigned int msr;
> +
> +	msr = rr(base + PCH_UART_MSR);
> +	priv->dmsr |= msr & PCH_UART_MSR_DELTA;
> +
> +	return (int)msr;

Why - if it is unsigned then why not return unsigned values ?


> +static int pch_uart_hal_enable_interrupt(struct eg20t_port *priv,
> +					 unsigned int flag)
> +{
> +	void __iomem *base;
> +	int ret;
> +
> +	base = priv->membase;
> +	ret = __pch_uart_hal_enable_interrupt(base, flag);
> +
> +	return ret;

Why not just

	"return __pch_uart_hal_enable_interrupt(priv->membase, flag);"

in fact why not just remove all these wrappers entirely ?


> +static int push_rx(struct eg20t_port *priv, const unsigned char *buf,
> +		   int size)
> +{
> +	struct uart_port *port;
> +	struct tty_struct *tty;
> +	int sz, i, j;
> +	int loop;
> +	int pushed;
> +
> +	port = &priv->port;
> +	tty = port->state->port.tty;

tty ports are refcounted

	tty = tty_port_tty_get(...)

and when finished tty_kref_put(tty);

Also tty may be NULL, if the port closed as you were doing this, so
check the return from tty_port_tty_get and act accordingly.


> +static int handle_error(struct eg20t_port *priv, int err)
> +{
> +	int ret = 0;
> +	return ret;
> +}

Why ?????

> +
> +#ifndef CONFIG_PCH_DMA

DMA should be runtime configuration - vendors need to build generic
kernels so need things like DMA switching to be done on load not on
compile




> +static void pch_uart_set_mctrl(struct uart_port *port, unsigned int
> mctrl) +{
> +}

Seems to be unimplemented ?


> +static void pch_uart_set_termios(struct uart_port *port,
> +				 struct ktermios *termios, struct
> ktermios *old) +{
> +	int baud;
> +	unsigned int parity, bits, stb;
> +	struct eg20t_port *priv;
> +	unsigned long flags;
> +
> +	priv = container_of(port, struct eg20t_port, port);
> +	switch (termios->c_cflag & CSIZE) {
> +	case CS5:
> +		bits = PCH_UART_HAL_5BIT;
> +		break;
> +	case CS6:
> +		bits = PCH_UART_HAL_6BIT;
> +		break;
> +	case CS7:
> +		bits = PCH_UART_HAL_7BIT;
> +		break;
> +	default:		/* CS8 */
> +		bits = PCH_UART_HAL_8BIT;
> +		break;
> +	}
> +	if (termios->c_cflag & CSTOPB)
> +		stb = PCH_UART_HAL_STB2;
> +	else
> +		stb = PCH_UART_HAL_STB1;
> +
> +	if (termios->c_cflag & PARENB) {
> +		if (!(termios->c_cflag & PARODD))
> +			parity = PCH_UART_HAL_PARITY_ODD;
> +		else
> +			parity = PCH_UART_HAL_PARITY_EVEN;
> +
> +	} else {
> +		parity = PCH_UART_HAL_PARITY_NONE;
> +	}

If you don't support CPARMRK then you should clear that bit in
termios->c_flag so the caller knows it couldn't be set.


> +	baud = uart_get_baud_rate(port, termios, old, 0,
> port->uartclk / 16); +
> +	spin_lock_irqsave(&port->lock, flags);
> +
> +	uart_update_timeout(port, termios->c_cflag, baud);
> +	pch_uart_hal_set_line(priv, baud, parity, bits, stb);

Baud rate should also be written back here

       /* Don't rewrite B0 */
        if (tty_termios_baud_rate(termios))
                tty_termios_encode_baud_rate(termios, baud, baud);

> +	txbuf = __get_free_page(GFP_KERNEL|GFP_DMA);
> +	if (!txbuf)
> +		goto init_port_error_end;
> +
> +	rxbuf = __get_free_page(GFP_KERNEL|GFP_DMA);
> +	if (!rxbuf)
> +		goto init_port_free_txbuf;

No - for bus masterable DMA buffers use the dma_alloc_coherent
interfaces with the correct device pointer, otherwise it will break on
a system with an IOMMU.

I assume the correct device in this case would be the DMA controller ?


The big thing I don't understand here is the locking model - what stops
interrupts and other things interfering with each other. For almost all
of the calls coming from the serial layer the port lock protects them
but I see no protection on the IRQ side at all ?


