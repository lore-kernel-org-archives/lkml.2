Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248Ab1LFVWK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 16:22:10 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:63305 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896Ab1LFVWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 16:22:06 -0500
Message-ID: <4EDE877A.4080708@gmail.com>
Date: Tue, 06 Dec 2011 15:22:02 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Anton Vorontsov <cbouatmailru@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Jeff Garzik <jgarzik@redhat.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        devicetree-discuss@lists.ozlabs.org,
        LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>, linux-next@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/2] of/irq: Get rid of NO_IRQ usage
References: <20111110151852.GA7465@oksana.dev.rtsoft.ru> <20111110152541.GA3207@oksana.dev.rtsoft.ru>
In-Reply-To: <20111110152541.GA3207@oksana.dev.rtsoft.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2011 09:25 AM, Anton Vorontsov wrote:
> PPC32/64 defines NO_IRQ to zero, so no problems expected.
> ARM defines NO_IRQ to -1, but OF code relies on IRQ domains support,
> which returns correct ('0') value in 'no irq' case. So everything
> should be fine.
> 
> Other arches might break if some of their OF drivers rely on NO_IRQ
> being not 0. If so, the drivers must be fixed, finally.
> 
> Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
> ---
>  drivers/of/irq.c |   30 ++++++++++++++++++------------
>  1 files changed, 18 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/of/irq.c b/drivers/of/irq.c
> index 6d3dd39..2dd4937 100644
> --- a/drivers/of/irq.c
> +++ b/drivers/of/irq.c
> @@ -26,11 +26,6 @@
>  #include <linux/string.h>
>  #include <linux/slab.h>
>  
> -/* For archs that don't support NO_IRQ (such as x86), provide a dummy value */
> -#ifndef NO_IRQ
> -#define NO_IRQ 0
> -#endif
> -
>  /**
>   * irq_of_parse_and_map - Parse and map an interrupt into linux virq space
>   * @device: Device node of the device whose interrupt is to be mapped
> @@ -42,12 +37,23 @@
>  unsigned int irq_of_parse_and_map(struct device_node *dev, int index)
>  {
>  	struct of_irq oirq;
> +	int ret = 0;
>  
>  	if (of_irq_map_one(dev, index, &oirq))
> -		return NO_IRQ;
> -
> -	return irq_create_of_mapping(oirq.controller, oirq.specifier,
> -				     oirq.size);
> +		goto no_irq;
> +
> +	ret = irq_create_of_mapping(oirq.controller, oirq.specifier,
> +				    oirq.size);
> +no_irq:
> +#ifdef NO_IRQ
> +#if NO_IRQ != 0
> +	if (ret == NO_IRQ)
> +		pr_warn("Hit NO_IRQ case for your arch. Drivers might expect "
> +			"NO_IRQ, but we return 0. If anything breaks, driver "
> +			"have to be fixed.\n");
> +#endif
> +#endif

This warning code is really ugly. Can we just drop it? In my searching
of in kernel dts files, there's only 1 instance I have found (Versatile
AB watchdog) that would hit this.

If not, you don't need to handle irq_create_of_mapping return as that is
already always 0 for no irq or error.

Otherwise, looks fine.

Rob

> +	return ret;
>  }
>  EXPORT_SYMBOL_GPL(irq_of_parse_and_map);
>  
> @@ -345,7 +351,7 @@ int of_irq_to_resource(struct device_node *dev, int index, struct resource *r)
>  
>  	/* Only dereference the resource if both the
>  	 * resource and the irq are valid. */
> -	if (r && irq != NO_IRQ) {
> +	if (r && irq) {
>  		r->start = r->end = irq;
>  		r->flags = IORESOURCE_IRQ;
>  		r->name = dev->full_name;
> @@ -363,7 +369,7 @@ int of_irq_count(struct device_node *dev)
>  {
>  	int nr = 0;
>  
> -	while (of_irq_to_resource(dev, nr, NULL) != NO_IRQ)
> +	while (of_irq_to_resource(dev, nr, NULL))
>  		nr++;
>  
>  	return nr;
> @@ -383,7 +389,7 @@ int of_irq_to_resource_table(struct device_node *dev, struct resource *res,
>  	int i;
>  
>  	for (i = 0; i < nr_irqs; i++, res++)
> -		if (of_irq_to_resource(dev, i, res) == NO_IRQ)
> +		if (!of_irq_to_resource(dev, i, res))
>  			break;
>  
>  	return i;

