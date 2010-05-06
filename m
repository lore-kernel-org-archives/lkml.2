Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756348Ab0EFKwH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 06:52:07 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:37281 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755032Ab0EFKwE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 06:52:04 -0400
Subject: Re: [Nios2-dev] [PATCH 2/2] serial: Add driver for the Altera UART
From: Ian Abbott <abbotti@mev.co.uk>
To: "nios2-dev@sopc.et.ntust.edu.tw" <nios2-dev@sopc.et.ntust.edu.tw>
CC: "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <095aab012b2a6b3bbf4c7bc04294bb9c19316318.1273048151.git.tklauser@distanz.ch>
References: <cover.1273048151.git.tklauser@distanz.ch>
	 <095aab012b2a6b3bbf4c7bc04294bb9c19316318.1273048151.git.tklauser@distanz.ch>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 6 May 2010 11:44:44 +0100
Message-ID: <1273142684.3477.22.camel@gentoo-ija64.mev.local>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-05 at 09:35 +0100, Tobias Klauser wrote:
> Add an UART driver for the UART component available as a SOPC (System on
> Programmable Chip) component for Altera FPGAs.
[...]

> +static void altera_uart_start_tx(struct uart_port *port)
> +{
> +       struct altera_uart *pp = container_of(port, struct altera_uart, port);
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&port->lock, flags);
> +       pp->imr |= ALTERA_UART_CONTROL_TRDY_MSK;
> +       writel(pp->imr, port->membase + ALTERA_UART_CONTROL_REG);
> +       spin_unlock_irqrestore(&port->lock, flags);
> +}
> +
> +static void altera_uart_stop_tx(struct uart_port *port)
> +{
> +       struct altera_uart *pp = container_of(port, struct altera_uart, port);
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&port->lock, flags);
> +       pp->imr &= ~ALTERA_UART_CONTROL_TRDY_MSK;
> +       writel(pp->imr, port->membase + ALTERA_UART_CONTROL_REG);
> +       spin_unlock_irqrestore(&port->lock, flags);
> +}
> +
> +static void altera_uart_stop_rx(struct uart_port *port)
> +{
> +       struct altera_uart *pp = container_of(port, struct altera_uart, port);
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&port->lock, flags);
> +       pp->imr &= ~ALTERA_UART_CONTROL_RRDY_MSK;
> +       writel(pp->imr, port->membase + ALTERA_UART_CONTROL_REG);
> +       spin_unlock_irqrestore(&port->lock, flags);
> +}

Those four functions shouldn't grab port->lock because the caller in
serial_core.c grabs it before calling them.

> +static irqreturn_t altera_uart_interrupt(int irq, void *data)
> +{
> +       struct uart_port *port = data;
> +       struct altera_uart *pp = container_of(port, struct altera_uart, port);
> +       unsigned int isr;
> +
> +       isr = readl(port->membase + ALTERA_UART_STATUS_REG) & pp->imr;
> +       if (isr & ALTERA_UART_STATUS_RRDY_MSK)
> +               altera_uart_rx_chars(pp);
> +       if (isr & ALTERA_UART_STATUS_TRDY_MSK)
> +               altera_uart_tx_chars(pp);
> +       return IRQ_RETVAL(isr);
> +}

Either the interrupt routine should grab port->lock (see equivalent
function in altera_jtaguart.c for an example), or this could be done
lower down in altera_uart_rx_chars() and altera_uart_tx_chars(). (It's
less messing about to do it here in the interrupt routine though.)

> +static void altera_uart_console_putc(struct console *co, const char c)
> +{
> +       struct uart_port *port = &(altera_uart_ports + co->index)->port;
> +       int i;
> +
> +       for (i = 0; i < 0x10000; i++) {
> +               if (readl(port->membase + ALTERA_UART_STATUS_REG) &
> +                   ALTERA_UART_STATUS_TRDY_MSK)
> +                       break;
> +       }
> +       writel(c, port->membase + ALTERA_UART_TXDATA_REG);
> +       for (i = 0; i < 0x10000; i++) {
> +               if (readl(port->membase + ALTERA_UART_STATUS_REG) &
> +                   ALTERA_UART_STATUS_TRDY_MSK)
> +                       break;
> +       }
> +}

I'd suggest calling udelay(1) in each iteration of the loop.  Perhaps
the second loop is overkill.

I was also going to suggest using the port->lock spin lock, but I'm not
sure about the policy regarding that for console output (the 8250 driver
console output doesn't use the spin lock for example).

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-

