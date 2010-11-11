Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597Ab0KKLek (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 06:34:40 -0500
Received: from www.tglx.de ([62.245.132.106]:40090 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755321Ab0KKLej (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 06:34:39 -0500
Date: Thu, 11 Nov 2010 12:34:31 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dirk Brandewie <dirk.brandewie@gmail.com>
cc: linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 4/6] ce4100: Add errata fixes for UART on CE4100
In-Reply-To: <395c11879580e72e3a47272ef8cf5e04fa334210.1289331834.git.dirk.brandewie@gmail.com>
Message-ID: <alpine.LFD.2.00.1011111231430.2900@localhost6.localdomain6>
References: <cover.1289331834.git.dirk.brandewie@gmail.com> <395c11879580e72e3a47272ef8cf5e04fa334210.1289331834.git.dirk.brandewie@gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 9 Nov 2010, dirk.brandewie@gmail.com wrote:

> From: Dirk Brandewie <dirk.brandewie@gmail.com>
> 
> This patch enables the UART on the CE4100.  The UART has a couple of
> issues that need to be worked around.  First the UART is mostly PC
> compatible except that it is clocked eight times faster than a
> standard PC so the default configuration provided in
> arch/x86/include/asm/serial.h needs to be overridden. Second the TX
> interrupt may not be set correctly all the time. Lastly accessing the
> UART via I/O space for early_prink() hangs the chip when the IOAPIC is
> enabled.
> 
> A custom mem_serial_in() is provided to work around the TX interrupt
> issue. The configuration issues are dealt with in the call back
> registered with the 8250 driver via serial8250_set_isa_configurator()
> 
> Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
> ---
>  arch/x86/kernel/ce4100.c |   92 ++++++++++++++++++++++++++++++++++++++++++++-
>  1 files changed, 89 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kernel/ce4100.c b/arch/x86/kernel/ce4100.c
> index b8f1c48..d2c0d51 100644
> --- a/arch/x86/kernel/ce4100.c
> +++ b/arch/x86/kernel/ce4100.c
> @@ -12,25 +12,111 @@
>  #include <linux/kernel.h>
>  #include <linux/irq.h>
>  #include <linux/module.h>
> +#include <linux/serial_reg.h>
> +#include <linux/serial_8250.h>
>  
>  #include <asm/setup.h>
> -
> +#include <asm/io.h>
>  
>  static int ce4100_i8042_detect(void)
>  {
>  	return 0;
>  }
>  
> -static void __init sdv_arch_setup(void)
> +static void __init sdv_find_smp_config(void)
>  {
> +}
> +
> +#ifdef CONFIG_SERIAL_8250
> +
>  
> +static unsigned int mem_serial_in(struct uart_port *p, int offset)
> +{
> +	offset = offset << p->regshift;
> +	return readl(p->membase + offset);
>  }
>  
> +/*
> + * The UART Tx interrupts are not set under some conditions and therefore serial
> + * transmission hangs. This is a silicon issue and has not been root caused. The
> + * workaround for this silicon issue checks UART_LSR_THRE bit and UART_LSR_TEMT
> + * bit of LSR register in interrupt handler to see whether at least one of these
> + * two bits is set, if so then process the transmit request. If this workaround
> + * is not applied, then the serial transmission may hang. This workaround is for
> + * errata number 9 in Errata - B step.
> +*/
>  
> -static void __init sdv_find_smp_config(void)
> +static unsigned int ce4100_mem_serial_in(struct uart_port *p, int offset)
> +{
> +	unsigned int ret, ier, lsr;
> +
> +	if (offset == UART_IIR) {
> +		offset = offset << p->regshift;
> +		ret = readl(p->membase + offset);
> +		if (ret & UART_IIR_NO_INT) {
> +			/* see if the TX interrupt should have really set */
> +			ier = mem_serial_in(p, UART_IER);
> +			/* see if the UART's XMIT interrupt is enabled */
> +			if (ier & UART_IER_THRI) {
> +				lsr = mem_serial_in(p, UART_LSR);
> +				/* now check to see if the UART should be
> +				   generating an interrupt (but isn't) */
> +				if (lsr & (UART_LSR_THRE | UART_LSR_TEMT))
> +					ret &= ~UART_IIR_NO_INT;
> +			}
> +		}
> +	} else
> +		ret =  mem_serial_in(p, offset);
> +	return ret;
> +}
> +
> +static void ce4100_mem_serial_out(struct uart_port *p, int offset, int value)
> +{
> +	offset = offset << p->regshift;
> +	writel(value, p->membase + offset);
> +}
> +
> +static void ce4100_serial_fixup(int port, struct uart_port *up,
> +	unsigned short *capabilites)
> +{
> +#ifdef CONFIG_EARLY_PRINTK
> +	/*
> +	 * Over ride the legacy port configuration that comes from
> +	 * asm/serial.h. Using the ioport driver then switching to the
> +	 * PCI memmaped driver hangs the IOAPIC
> +	 */
> +	if (up->iotype !=  UPIO_MEM32) {
> +		up->uartclk  = 14745600;
> +		up->mapbase = 0xdffe0200;

  What does the uartclk, mapbase fixups in the CONFIG_EARLY_PRINTK=n case ?

> +		set_fixmap_nocache(FIX_EARLYCON_MEM_BASE,
> +				up->mapbase & PAGE_MASK);
> +		up->membase =
> +			(void __iomem *)__fix_to_virt(FIX_EARLYCON_MEM_BASE);
> +		up->membase += up->mapbase & ~PAGE_MASK;
> +		up->iotype   = UPIO_MEM32;
> +		up->regshift = 2;
> +	}
> +#endif
> +	up->iobase = 0;
> +	up->serial_in = ce4100_mem_serial_in;
> +	up->serial_out = ce4100_mem_serial_out;
> +
> +	*capabilites |= (1 << 12);
> +}

Thanks,

	tglx
