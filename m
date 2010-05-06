Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757898Ab0EFMKr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 08:10:47 -0400
Received: from mx1.zhaw.ch ([160.85.104.50]:53570 "EHLO mx1.zhaw.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757821Ab0EFMKp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 08:10:45 -0400
X-Greylist: delayed 407 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 May 2010 08:10:45 EDT
Message-ID: <4BE2B02B.4010209@zhaw.ch>
Date: Thu, 06 May 2010 14:03:55 +0200
From: Tobias Klauser <klto@zhaw.ch>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: abbotti@mev.co.uk
CC: sfr@canb.auug.org.au, gregkh@suse.de, linux-kernel@vger.kernel.org,
       linux-serial@vger.kernel.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, nios2-dev@sopc.et.ntust.edu.tw
Subject: Re: [Nios2-dev] [PATCH 2/2] serial: Add driver for the Altera UART
References: <cover.1273048151.git.tklauser@distanz.ch>	<095aab012b2a6b3bbf4c7bc04294bb9c19316318.1273048151.git.tklauser@distanz.ch> <1273142684.3477.22.camel@gentoo-ija64.mev.local>
In-Reply-To: <1273142684.3477.22.camel@gentoo-ija64.mev.local>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-PMX-Version: 5.5.9.395186, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2010.5.6.114516
X-PerlMx-Spam: Gauge=IIIIIIII, Probability=8%, Report='
 BODY_SIZE_4000_4999 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, TO_NO_NAME 0, __BOUNCE_CHALLENGE_SUBJ 0, __BOUNCE_NDR_SUBJ_EXEMPT 0, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __MOZILLA_MSGID 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __USER_AGENT 0'
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ian,

Thanks a lot for your review. Please see my notes below.

On 05/06/2010 12:44 PM, Ian Abbott wrote:
> On Wed, 2010-05-05 at 09:35 +0100, Tobias Klauser wrote:
>> Add an UART driver for the UART component available as a SOPC (System on
>> Programmable Chip) component for Altera FPGAs.
> [...]
> 
>> +static void altera_uart_start_tx(struct uart_port *port)
>> +{
>> +       struct altera_uart *pp = container_of(port, struct altera_uart, port);
>> +       unsigned long flags;
>> +
>> +       spin_lock_irqsave(&port->lock, flags);
>> +       pp->imr |= ALTERA_UART_CONTROL_TRDY_MSK;
>> +       writel(pp->imr, port->membase + ALTERA_UART_CONTROL_REG);
>> +       spin_unlock_irqrestore(&port->lock, flags);
>> +}
>> +
>> +static void altera_uart_stop_tx(struct uart_port *port)
>> +{
>> +       struct altera_uart *pp = container_of(port, struct altera_uart, port);
>> +       unsigned long flags;
>> +
>> +       spin_lock_irqsave(&port->lock, flags);
>> +       pp->imr &= ~ALTERA_UART_CONTROL_TRDY_MSK;
>> +       writel(pp->imr, port->membase + ALTERA_UART_CONTROL_REG);
>> +       spin_unlock_irqrestore(&port->lock, flags);
>> +}
>> +
>> +static void altera_uart_stop_rx(struct uart_port *port)
>> +{
>> +       struct altera_uart *pp = container_of(port, struct altera_uart, port);
>> +       unsigned long flags;
>> +
>> +       spin_lock_irqsave(&port->lock, flags);
>> +       pp->imr &= ~ALTERA_UART_CONTROL_RRDY_MSK;
>> +       writel(pp->imr, port->membase + ALTERA_UART_CONTROL_REG);
>> +       spin_unlock_irqrestore(&port->lock, flags);
>> +}
> 
> Those four functions shouldn't grab port->lock because the caller in
> serial_core.c grabs it before calling them.

Agreed, I removed the lock grabbing from altera_uart_stop_rx,
altera_uart_stop_tx, altera_uart_start_tx, altera_uart_set_mctrl and
altera_uart_get_mctrl (as suggested in the original message and the two
followups).

I also noticed, that altera_uart_break_ctl takes the lock which might be
not necessary as the caller in serial_core.c already takes port->mutex
which should be enough. Or am I wrong?

>> +static irqreturn_t altera_uart_interrupt(int irq, void *data)
>> +{
>> +       struct uart_port *port = data;
>> +       struct altera_uart *pp = container_of(port, struct altera_uart, port);
>> +       unsigned int isr;
>> +
>> +       isr = readl(port->membase + ALTERA_UART_STATUS_REG) & pp->imr;
>> +       if (isr & ALTERA_UART_STATUS_RRDY_MSK)
>> +               altera_uart_rx_chars(pp);
>> +       if (isr & ALTERA_UART_STATUS_TRDY_MSK)
>> +               altera_uart_tx_chars(pp);
>> +       return IRQ_RETVAL(isr);
>> +}
> 
> Either the interrupt routine should grab port->lock (see equivalent
> function in altera_jtaguart.c for an example), or this could be done
> lower down in altera_uart_rx_chars() and altera_uart_tx_chars(). (It's
> less messing about to do it here in the interrupt routine though.)

I added the lock to the interrupt routine (similar to altera_jtaguart.c).

>> +static void altera_uart_console_putc(struct console *co, const char c)
>> +{
>> +       struct uart_port *port = &(altera_uart_ports + co->index)->port;
>> +       int i;
>> +
>> +       for (i = 0; i < 0x10000; i++) {
>> +               if (readl(port->membase + ALTERA_UART_STATUS_REG) &
>> +                   ALTERA_UART_STATUS_TRDY_MSK)
>> +                       break;
>> +       }
>> +       writel(c, port->membase + ALTERA_UART_TXDATA_REG);
>> +       for (i = 0; i < 0x10000; i++) {
>> +               if (readl(port->membase + ALTERA_UART_STATUS_REG) &
>> +                   ALTERA_UART_STATUS_TRDY_MSK)
>> +                       break;
>> +       }
>> +}
> 
> I'd suggest calling udelay(1) in each iteration of the loop.  Perhaps
> the second loop is overkill.

Those seem to come from mcf.c on which this driver was based. I added
the udelay to the first loop and dropped the second loop which indeed
isn't needed here. I also replace the first loop with the equivalent
construct from altera_uart_tx_chars.

> I was also going to suggest using the port->lock spin lock, but I'm not
> sure about the policy regarding that for console output (the 8250 driver
> console output doesn't use the spin lock for example).

As I understood from Alan's comment on altera_jtaguart.c the lock is
needed to protect port->port.tty so I'll add it in altera_uart.c too.

Cheers,
Tobias
