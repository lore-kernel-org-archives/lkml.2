Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757721Ab0KKHAf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 02:00:35 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:40653 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752608Ab0KKHAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 02:00:34 -0500
Message-ID: <000901cb816e$22528490$66f8800a@maildom.okisemi.com>
From: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
To: "Alan Cox" <alan@linux.intel.com>
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, "Ben Dooks" <ben-linux@fluff.org>,
        "Kukjin Kim" <kgene.kim@samsung.com>,
        "Mike Frysinger" <vapier@gentoo.org>,
        "Feng Tang" <feng.tang@intel.com>,
        "Tobias Klauser" <tklauser@distanz.ch>,
        "LKML" <linux-kernel@vger.kernel.org>, <yong.y.wang@intel.com>,
        <qi.wang@intel.com>, <kok.howg.ewe@intel.com>,
        <andrew.chih.howe.khor@intel.com>
References: <4CD8D5A2.1080202@dsn.okisemi.com> <20101109103737.40bfab7b@linux.intel.com>
Subject: Re: [PATCH] EG20T: Update PCH_UART driver to 2.6.36
Date: Thu, 11 Nov 2010 16:00:30 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1983
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1983
X-Hosting-Pf: 0
X-NAI-Spam-Score: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 09, 2010 7:37 PM,  Alan Cox wrote:

> 
> > +#ifdef CONFIG_PCH_DMA
> > + #include <linux/dmaengine.h>
> > + #include <linux/pch_dma.h>
> > +#endif
> 
> The PCH DMA will have been included in the kernel anyway before this
> merge so you can remove the ifdefs and include it regardless

No.
PCH DMA have been already included at 2.6.36.
You can see "pch_dma.c" in drivers/dma.

> 
> 
> > +#if !defined(PORT_PCH_256FIFO) || !defined(PORT_PCH_64FIFO)
> > + #undef PORT_PCH_256FIFO
> > + #undef PORT_PCH_64FIFO
> > + #define PORT_PCH_256FIFO (PORT_MAX_8250+1) /* PCH UART with
> > 256 byte
> > +      FIFO */
> > + #define PORT_PCH_64FIFO (PORT_MAX_8250+2) /* PCH UART with
> > 64 byte
> > +      FIFO */
> > +#endif
> 
> FIFO config really all wants to be done at runtime.

I will modify.

> 
> 
> 
> > +static inline void wr(void __iomem *addr, unsigned int value)
> > +{
> > +#if PCH_UART_DMA_REG_BOUNDARY == 4
> > + iowrite32(value, addr);
> > +#else
> > + iowrite8(value, (void *)addr);
> 
> Why the cast ?

I will delete the cast.

> 
> > +#endif
> 
> Again you've got magic ifdefs with no explanation ?

I will delete this.

> > +}
> > +
> > +static void pch_uart_hal_request(struct pci_dev *pdev, int fifosize,
> > + int base_baud)
> > +{
> > + struct eg20t_port *priv = pci_get_drvdata(pdev);
> > +
> > + priv->trigger_level = 1;
> > + priv->fcr = 0;
> > +}
> > +
> > +static int __get_msr(struct eg20t_port *priv, void __iomem *base)
> > +{
> 
> Please avoid __ names for functions

I will modify.

> 
> > + unsigned int msr;
> > +
> > + msr = rr(base + PCH_UART_MSR);
> > + priv->dmsr |= msr & PCH_UART_MSR_DELTA;
> > +
> > + return (int)msr;
> 
> Why - if it is unsigned then why not return unsigned values ?

I will modify.

> 
> 
> > +static int pch_uart_hal_enable_interrupt(struct eg20t_port *priv,
> > + unsigned int flag)
> > +{
> > + void __iomem *base;
> > + int ret;
> > +
> > + base = priv->membase;
> > + ret = __pch_uart_hal_enable_interrupt(base, flag);
> > +
> > + return ret;
> 
> Why not just
> 
> "return __pch_uart_hal_enable_interrupt(priv->membase, flag);"
> 
> in fact why not just remove all these wrappers entirely ?

I agree.
I will delete thease wrappers.

> 
> 
> > +static int push_rx(struct eg20t_port *priv, const unsigned char *buf,
> > +    int size)
> > +{
> > + struct uart_port *port;
> > + struct tty_struct *tty;
> > + int sz, i, j;
> > + int loop;
> > + int pushed;
> > +
> > + port = &priv->port;
> > + tty = port->state->port.tty;
> 
> tty ports are refcounted
> 
> tty = tty_port_tty_get(...)
> 
> and when finished tty_kref_put(tty);
> 
> Also tty may be NULL, if the port closed as you were doing this, so
> check the return from tty_port_tty_get and act accordingly.

I have a question.
Though I can't find any accepted UART driver uses these functions(tty_port.../tty_kref...),
What's for ?

> 
> 
> > +static int handle_error(struct eg20t_port *priv, int err)
> > +{
> > + int ret = 0;
> > + return ret;
> > +}
> 
> Why ?????
> 

I will modify.

> > +
> > +#ifndef CONFIG_PCH_DMA
> 
> DMA should be runtime configuration - vendors need to build generic
> kernels so need things like DMA switching to be done on load not on
> compile
> 
Do you mean we souldn't use both below?
#ifndef CONFIG_PCH_DMA
#ifdef CONFIG_PCH_DMA

Many UART drivers accepted by upstream use the above macro, right ?

> 
> 
> 
> > +static void pch_uart_set_mctrl(struct uart_port *port, unsigned int
> > mctrl) +{
> > +}
> 
> Seems to be unimplemented ?

I will implement.

> 
> 
> > +static void pch_uart_set_termios(struct uart_port *port,
> > + struct ktermios *termios, struct
> > ktermios *old) +{
> > + int baud;
> > + unsigned int parity, bits, stb;
> > + struct eg20t_port *priv;
> > + unsigned long flags;
> > +
> > + priv = container_of(port, struct eg20t_port, port);
> > + switch (termios->c_cflag & CSIZE) {
> > + case CS5:
> > + bits = PCH_UART_HAL_5BIT;
> > + break;
> > + case CS6:
> > + bits = PCH_UART_HAL_6BIT;
> > + break;
> > + case CS7:
> > + bits = PCH_UART_HAL_7BIT;
> > + break;
> > + default: /* CS8 */
> > + bits = PCH_UART_HAL_8BIT;
> > + break;
> > + }
> > + if (termios->c_cflag & CSTOPB)
> > + stb = PCH_UART_HAL_STB2;
> > + else
> > + stb = PCH_UART_HAL_STB1;
> > +
> > + if (termios->c_cflag & PARENB) {
> > + if (!(termios->c_cflag & PARODD))
> > + parity = PCH_UART_HAL_PARITY_ODD;
> > + else
> > + parity = PCH_UART_HAL_PARITY_EVEN;
> > +
> > + } else {
> > + parity = PCH_UART_HAL_PARITY_NONE;
> > + }
> 
> If you don't support CPARMRK then you should clear that bit in
> termios->c_flag so the caller knows it couldn't be set.

Sorry, I don't know CPARMRK.
What's CPARMRK ?

> 
> 
> > + baud = uart_get_baud_rate(port, termios, old, 0,
> > port->uartclk / 16); +
> > + spin_lock_irqsave(&port->lock, flags);
> > +
> > + uart_update_timeout(port, termios->c_cflag, baud);
> > + pch_uart_hal_set_line(priv, baud, parity, bits, stb);
> 
> Baud rate should also be written back here
> 
>        /* Don't rewrite B0 */
>         if (tty_termios_baud_rate(termios))
>                 tty_termios_encode_baud_rate(termios, baud, baud);
> 

I will add above.


> > + txbuf = __get_free_page(GFP_KERNEL|GFP_DMA);
> > + if (!txbuf)
> > + goto init_port_error_end;
> > +
> > + rxbuf = __get_free_page(GFP_KERNEL|GFP_DMA);
> > + if (!rxbuf)
> > + goto init_port_free_txbuf;
> 
> No - for bus masterable DMA buffers use the dma_alloc_coherent
> interfaces with the correct device pointer, otherwise it will break on
> a system with an IOMMU.

I will use dma_alloc_coherent.

> 
> I assume the correct device in this case would be the DMA controller ?

Sorry, I can't understand your saying "correct device".
What does "correct device" mean ?

> 
> 
> The big thing I don't understand here is the locking model - what stops
> interrupts and other things interfering with each other. For almost all
> of the calls coming from the serial layer the port lock protects them
> but I see no protection on the IRQ side at all ?
> 

Do you mean UART Rx/Tx interrupt Enable/Disable ?
If yes, the control hava been already implemented.
For example, in handle_tx (called from IRQ handler),
you can see pch_uart_hal_disable_interrupt().


---
Thanks,

Tomoya MORINAGA
OKI SEMICONDUCTOR CO., LTD.
