Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592Ab2CDVGj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 16:06:39 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:59399 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754888Ab2CDVGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 16:06:38 -0500
X-Authenticated: #28250155
X-Provags-ID: V01U2FsdGVkX1/Y5lhB62XYcgdrM96+jwY+i/KqEInTQ0rriNohD1
	XibfIAJsvzwCEk
From: Sven Joachim <svenjoac@gmx.de>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [ 57/72] genirq: Unmask oneshot irqs when thread was not woken
References: <20120228010511.GA8453@kroah.com>
	<20120228010434.412979550@linuxfoundation.org>
Date: Sun, 04 Mar 2012 22:06:32 +0100
In-Reply-To: <20120228010434.412979550@linuxfoundation.org> (Greg KH's message
	of "Mon, 27 Feb 2012 17:05:26 -0800")
Message-ID: <87hay4dqjr.fsf@turtle.gmx.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.94 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-02-28 02:05 +0100, Greg KH wrote:

> 3.2-stable review patch.  If anyone has any objections, please let me know.

Alas, the commit below broke the WiFi on my laptop, where
"iwlist wlan0 scan" now just reports: " wlan0     No scan results".

This is not specific to 3.2, the same problem exists in 3.0.23 and
3.3-rc6 while previous releases worked.

The laptop is an Acer TravelMate 2490 with a Broadcom chip:

,----
| 06:02.0 Network controller: Broadcom Corporation BCM4318 [AirForce One 54g] 802.11g Wireless LAN Controller (rev 02)
| 	Subsystem: AMBIT Microsystem Corp. TravelMate 2410
| 	Flags: bus master, fast devsel, latency 64, IRQ 10
| 	Memory at d0002000 (32-bit, non-prefetchable) [size=8K]
| 	Kernel driver in use: b43-pci-bridge
`----

I'll be happy to give more information when needed.

Cheers,
       Sven


> From: Thomas Gleixner <tglx@linutronix.de>
>
> commit ac5637611150281f398bb7a47e3fcb69a09e7803 upstream.
>
> When the primary handler of an interrupt which is marked IRQ_ONESHOT
> returns IRQ_HANDLED or IRQ_NONE, then the interrupt thread is not
> woken and the unmask logic of the interrupt line is never
> invoked. This keeps the interrupt masked forever.
>
> This was not noticed as most IRQ_ONESHOT users wake the thread
> unconditionally (usually because they cannot access the underlying
> device from hard interrupt context). Though this behaviour was nowhere
> documented and not necessarily intentional. Some drivers can avoid the
> thread wakeup in certain cases and run into the situation where the
> interrupt line s kept masked.
>
> Handle it gracefully.
>
> Reported-and-tested-by: Lothar Wassmann <lw@karo-electronics.de>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> ---
>  kernel/irq/chip.c |   25 +++++++++++++++++++++++--
>  1 file changed, 23 insertions(+), 2 deletions(-)
>
> --- a/kernel/irq/chip.c
> +++ b/kernel/irq/chip.c
> @@ -330,6 +330,24 @@ out_unlock:
>  }
>  EXPORT_SYMBOL_GPL(handle_simple_irq);
>  
> +/*
> + * Called unconditionally from handle_level_irq() and only for oneshot
> + * interrupts from handle_fasteoi_irq()
> + */
> +static void cond_unmask_irq(struct irq_desc *desc)
> +{
> +	/*
> +	 * We need to unmask in the following cases:
> +	 * - Standard level irq (IRQF_ONESHOT is not set)
> +	 * - Oneshot irq which did not wake the thread (caused by a
> +	 *   spurious interrupt or a primary handler handling it
> +	 *   completely).
> +	 */
> +	if (!irqd_irq_disabled(&desc->irq_data) &&
> +	    irqd_irq_masked(&desc->irq_data) && !desc->threads_oneshot)
> +		unmask_irq(desc);
> +}
> +
>  /**
>   *	handle_level_irq - Level type irq handler
>   *	@irq:	the interrupt number
> @@ -362,8 +380,8 @@ handle_level_irq(unsigned int irq, struc
>  
>  	handle_irq_event(desc);
>  
> -	if (!irqd_irq_disabled(&desc->irq_data) && !(desc->istate & IRQS_ONESHOT))
> -		unmask_irq(desc);
> +	cond_unmask_irq(desc);
> +
>  out_unlock:
>  	raw_spin_unlock(&desc->lock);
>  }
> @@ -417,6 +435,9 @@ handle_fasteoi_irq(unsigned int irq, str
>  	preflow_handler(desc);
>  	handle_irq_event(desc);
>  
> +	if (desc->istate & IRQS_ONESHOT)
> +		cond_unmask_irq(desc);
> +
>  out_eoi:
>  	desc->irq_data.chip->irq_eoi(&desc->irq_data);
>  out_unlock:
