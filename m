Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757488Ab0EZS1N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 14:27:13 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:64616 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936Ab0EZS1M (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 26 May 2010 14:27:12 -0400
Date: Wed, 26 May 2010 14:26:49 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
       xen-devel@lists.xensource.com, Don Dutile <ddutile@redhat.com>
Subject: Re: [Xen-devel] [PATCH 04/11] Fix find_unbound_irq in presence of
	ioapic irqs.
Message-ID: <20100526182649.GF5188@phenom.dumpdata.com>
References: <alpine.DEB.2.00.1005241615300.25605@kaball-desktop> <1274725657-1149-4-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274725657-1149-4-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090205.4BFD67F1.00CA:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 24, 2010 at 07:27:30PM +0100, Stefano Stabellini wrote:
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

Can you provide a more detailed description of why this is needed?

> ---
>  drivers/xen/events.c |   11 ++++++++++-
>  1 files changed, 10 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/xen/events.c b/drivers/xen/events.c
> index 8b68fc4..1356fa2 100644
> --- a/drivers/xen/events.c
> +++ b/drivers/xen/events.c
> @@ -339,9 +339,18 @@ static int find_unbound_irq(void)
>  	int irq;
>  	struct irq_desc *desc;
>  
> -	for (irq = 0; irq < nr_irqs; irq++)
> +	for (irq = 0; irq < nr_irqs; irq++) {
> +		desc = irq_to_desc(irq);
> +		/* only 0->15 have init'd desc; handle irq > 16 */
> +		if (desc == NULL)
> +			break;
> +		if (desc->chip == &no_irq_chip)
> +			break;
> +		if (desc->chip != &xen_dynamic_chip)
> +			continue;
>  		if (irq_info[irq].type == IRQT_UNBOUND)
>  			break;
> +	}
>  
>  	if (irq == nr_irqs)
>  		panic("No available IRQ to bind to: increase nr_irqs!\n");
> -- 
> 1.5.4.3
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xensource.com
> http://lists.xensource.com/xen-devel
