Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab0I1Ppl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 11:45:41 -0400
Received: from symlink.to.noone.org ([85.10.207.172]:51132 "EHLO sym.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753724Ab0I1Ppk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 11:45:40 -0400
Date: Tue, 28 Sep 2010 17:45:39 +0200
From: Tobias Klauser <tklauser@distanz.ch>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] altera_uart: Add support for polling mode
	(IRQ-less)
Message-ID: <20100928154539.GE3137@distanz.ch>
References: <20100928133526.GB8289@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100928133526.GB8289@oksana.dev.rtsoft.ru>
X-Editor: Vi IMproved 7.1
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-09-28 at 15:35:26 +0200, Anton Vorontsov <cbouatmailru@gmail.com> wrote:
> Some Altera UART implementations doesn't route the IRQ line, so we have
> to work in polling mode.
> 
> Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
> ---
>  drivers/serial/altera_uart.c |   38 +++++++++++++++++++++++++++++---------
>  1 files changed, 29 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/serial/altera_uart.c b/drivers/serial/altera_uart.c
> index f8d8a00..2603f59 100644
> --- a/drivers/serial/altera_uart.c
> +++ b/drivers/serial/altera_uart.c
> @@ -15,6 +15,7 @@
>  
>  #include <linux/kernel.h>
>  #include <linux/init.h>
> +#include <linux/timer.h>
>  #include <linux/interrupt.h>
>  #include <linux/module.h>
>  #include <linux/console.h>
> @@ -76,6 +77,7 @@
>   */
>  struct altera_uart {
>  	struct uart_port port;
> +	struct timer_list tmr;
>  	unsigned int sigs;	/* Local copy of line sigs */
>  	unsigned short imr;	/* Local IMR mirror */
>  };
> @@ -168,6 +170,7 @@ static void altera_uart_set_termios(struct uart_port *port,
>  	tty_termios_encode_baud_rate(termios, baud, baud);
>  
>  	spin_lock_irqsave(&port->lock, flags);
> +	uart_update_timeout(port, termios->c_cflag, baud);
>  	writel(baudclk, port->membase + ALTERA_UART_DIVISOR_REG);
>  	spin_unlock_irqrestore(&port->lock, flags);
>  }
> @@ -268,6 +271,15 @@ static irqreturn_t altera_uart_interrupt(int irq, void *data)
>  	return IRQ_RETVAL(isr);
>  }
>  
> +static void altera_uart_timer(unsigned long data)
> +{
> +	struct uart_port *port = (void *)data;
> +	struct altera_uart *pp = container_of(port, struct altera_uart, port);
> +
> +	altera_uart_interrupt(0, port);
> +	mod_timer(&pp->tmr, jiffies + uart_poll_timeout(port));
> +}
> +
>  static void altera_uart_config_port(struct uart_port *port, int flags)
>  {
>  	port->type = PORT_ALTERA_UART;
> @@ -284,14 +296,6 @@ static int altera_uart_startup(struct uart_port *port)
>  	unsigned long flags;
>  	int ret;
>  
> -	ret = request_irq(port->irq, altera_uart_interrupt, IRQF_DISABLED,
> -			DRV_NAME, port);
> -	if (ret) {
> -		pr_err(DRV_NAME ": unable to attach Altera UART %d "
> -		       "interrupt vector=%d\n", port->line, port->irq);
> -		return ret;
> -	}
> -
>  	spin_lock_irqsave(&port->lock, flags);
>  
>  	/* Enable RX interrupts now */
> @@ -300,6 +304,19 @@ static int altera_uart_startup(struct uart_port *port)
>  
>  	spin_unlock_irqrestore(&port->lock, flags);

Shouldn't we only enable the RX interrupt if we actually use interrupts?
Also I would retain the order here (first register the interrupt handler
and then enable the interrupts).

Cheers,
  Tobias
