Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932Ab1IAGCo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 02:02:44 -0400
Received: from gate.crashing.org ([63.228.1.57]:33403 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753773Ab1IAGCl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 02:02:41 -0400
Subject: Re: [PATCH 3/7] serial/8250: move UPIO_TSI to powerpc
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linuxppc-dev@lists.ozlabs.org,
        linux-serial@vger.kernel.org
In-Reply-To: <1309211120-2803-4-git-send-email-arnd@arndb.de>
References: <1309211120-2803-1-git-send-email-arnd@arndb.de>
	 <1309211120-2803-4-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Sep 2011 16:02:06 +1000
Message-ID: <1314856926.4145.12.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-27 at 23:45 +0200, Arnd Bergmann wrote:
> This iotype is only used by the legacy_serial code in powerpc, so the
> code should live there, rather than be compiled in for every 8250
> driver.

Obviously untested :-)

Misses the definition of UART_IIR etc...

I'm committing a fixed version in my tree

Cheers.
Ben.

> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: linuxppc-dev@lists.ozlabs.org
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: linux-serial@vger.kernel.org
> ---
>  arch/powerpc/kernel/legacy_serial.c |   24 ++++++++++++++++++++++++
>  drivers/tty/serial/8250.c           |   23 -----------------------
>  2 files changed, 24 insertions(+), 23 deletions(-)
> 
> diff --git a/arch/powerpc/kernel/legacy_serial.c b/arch/powerpc/kernel/legacy_serial.c
> index 2b97b80..b229e1e 100644
> --- a/arch/powerpc/kernel/legacy_serial.c
> +++ b/arch/powerpc/kernel/legacy_serial.c
> @@ -47,6 +47,24 @@ static struct __initdata of_device_id legacy_serial_parents[] = {
>  static unsigned int legacy_serial_count;
>  static int legacy_serial_console = -1;
>  
> +static unsigned int tsi_serial_in(struct uart_port *p, int offset)
> +{
> +	unsigned int tmp;
> +	offset = offset << p->regshift;
> +	if (offset == UART_IIR) {
> +		tmp = readl(p->membase + (UART_IIR & ~3));
> +		return (tmp >> 16) & 0xff; /* UART_IIR % 4 == 2 */
> +	} else
> +		return readb(p->membase + offset);
> +}
> +
> +static void tsi_serial_out(struct uart_port *p, int offset, int value)
> +{
> +	offset = offset << p->regshift;
> +	if (!((offset == UART_IER) && (value & UART_IER_UUE)))
> +		writeb(value, p->membase + offset);
> +}
> +
>  static int __init add_legacy_port(struct device_node *np, int want_index,
>  				  int iotype, phys_addr_t base,
>  				  phys_addr_t taddr, unsigned long irq,
> @@ -102,6 +120,7 @@ static int __init add_legacy_port(struct device_node *np, int want_index,
>  		legacy_serial_ports[index].iobase = base;
>  	else
>  		legacy_serial_ports[index].mapbase = base;
> +
>  	legacy_serial_ports[index].iotype = iotype;
>  	legacy_serial_ports[index].uartclk = clock;
>  	legacy_serial_ports[index].irq = irq;
> @@ -112,6 +131,11 @@ static int __init add_legacy_port(struct device_node *np, int want_index,
>  	legacy_serial_infos[index].speed = spd ? be32_to_cpup(spd) : 0;
>  	legacy_serial_infos[index].irq_check_parent = irq_check_parent;
>  
> +	if (iotype == UPIO_TSI) {
> +		legacy_serial_ports[index].serial_in = tsi_serial_in;
> +		legacy_serial_ports[index].serial_out = tsi_serial_out;
> +	}
> +
>  	printk(KERN_DEBUG "Found legacy serial port %d for %s\n",
>  	       index, np->full_name);
>  	printk(KERN_DEBUG "  %s=%llx, taddr=%llx, irq=%lx, clk=%d, speed=%d\n",
> diff --git a/drivers/tty/serial/8250.c b/drivers/tty/serial/8250.c
> index c8f107e..d575ccb 100644
> --- a/drivers/tty/serial/8250.c
> +++ b/drivers/tty/serial/8250.c
> @@ -345,24 +345,6 @@ static unsigned int mem32_serial_in(struct uart_port *p, int offset)
>  	return readl(p->membase + offset);
>  }
>  
> -static unsigned int tsi_serial_in(struct uart_port *p, int offset)
> -{
> -	unsigned int tmp;
> -	offset = map_8250_in_reg(p, offset) << p->regshift;
> -	if (offset == UART_IIR) {
> -		tmp = readl(p->membase + (UART_IIR & ~3));
> -		return (tmp >> 16) & 0xff; /* UART_IIR % 4 == 2 */
> -	} else
> -		return readb(p->membase + offset);
> -}
> -
> -static void tsi_serial_out(struct uart_port *p, int offset, int value)
> -{
> -	offset = map_8250_out_reg(p, offset) << p->regshift;
> -	if (!((offset == UART_IER) && (value & UART_IER_UUE)))
> -		writeb(value, p->membase + offset);
> -}
> -
>  /* Save the LCR value so it can be re-written when a Busy Detect IRQ occurs. */
>  static inline void dwapb_save_out_value(struct uart_port *p, int offset,
>  					int value)
> @@ -431,11 +413,6 @@ static void set_io_from_upio(struct uart_port *p)
>  		p->serial_out = mem32_serial_out;
>  		break;
>  
> -	case UPIO_TSI:
> -		p->serial_in = tsi_serial_in;
> -		p->serial_out = tsi_serial_out;
> -		break;
> -
>  	case UPIO_DWAPB:
>  		p->serial_in = mem_serial_in;
>  		p->serial_out = dwapb_serial_out;


