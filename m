Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759202Ab0JYRfr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 13:35:47 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:55113 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754522Ab0JYRfq (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 25 Oct 2010 13:35:46 -0400
Date: Mon, 25 Oct 2010 13:35:22 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ian Campbell <ian.campbell@citrix.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, xen-devel@lists.xensource.com, tglx@linutronix.de
Subject: Re: [PATCH 1/5] xen: events: use irq_alloc_desc(_at) instead of
 open-coding an IRQ allocator.
Message-ID: <20101025173522.GA5590@dumpdata.com>
References: <1288023736.11153.40.camel@zakaz.uk.xensource.com>
 <1288023813-31989-1-git-send-email-ian.campbell@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288023813-31989-1-git-send-email-ian.campbell@citrix.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 25, 2010 at 05:23:29PM +0100, Ian Campbell wrote:
> Encapsulate allocate and free in xen_irq_alloc and xen_irq_free.
> 
> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> ---
>  drivers/xen/events.c |   68 ++++++++++++++++++++-----------------------------
>  1 files changed, 28 insertions(+), 40 deletions(-)
> 
> diff --git a/drivers/xen/events.c b/drivers/xen/events.c
> index 97612f5..c8f3e43 100644
> --- a/drivers/xen/events.c
> +++ b/drivers/xen/events.c
> @@ -394,41 +394,29 @@ static int find_unbound_pirq(void)
>  	return -1;
>  }
>  
> -static int find_unbound_irq(void)
> +static int xen_irq_alloc(void)
>  {
> -	struct irq_data *data;
> -	int irq, res;
> -	int start = get_nr_hw_irqs();
> +	int irq = irq_alloc_desc(0);
>  
> -	if (start == nr_irqs)
> -		goto no_irqs;
> -
> -	/* nr_irqs is a magic value. Must not use it.*/
> -	for (irq = nr_irqs-1; irq > start; irq--) {
> -		data = irq_get_irq_data(irq);
> -		/* only 0->15 have init'd desc; handle irq > 16 */
> -		if (!data)
> -			break;
> -		if (data->chip == &no_irq_chip)
> -			break;
> -		if (data->chip != &xen_dynamic_chip)
> -			continue;
> -		if (irq_info[irq].type == IRQT_UNBOUND)
> -			return irq;
> -	}
> -
> -	if (irq == start)
> -		goto no_irqs;
> +	if (irq < 0)
> +		panic("No available IRQ to bind to: increase nr_irqs!\n");
>  
> -	res = irq_alloc_desc_at(irq, 0);
> +	return irq;
> +}

So I am curious what the /proc/interrupts looks?The issue (and the reason
for this implementation above) was that under PV with PCI devices we would
overlap PCI devices IRQs with Xen event channels. So we could have a USB device
at IRQ 16 _and_ also a xen_spinlock4 handler. That would throw off the system
since the xen_spinlock4 was an edge type handler while the USB device was an
level (at least on my box).

But with this shinny sparse_irq rework, maybe this is not an issue anymore?
Can we mix a level and edge chip handler under one IRQ?
What do you see when you pass in a PCI device and say give the guest 32 CPUs??
