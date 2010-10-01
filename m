Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837Ab0JAApu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 20:45:50 -0400
Received: from gate.crashing.org ([63.228.1.57]:54868 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754842Ab0JAApr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 20:45:47 -0400
Subject: Re: [patch 46/47] powerpc: Use new irq allocator
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@osdl.org>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai@kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "Eric W. Biederman" <ebiederm@xmission.com>
In-Reply-To: <20100930221743.014571381@linutronix.de>
References: <20100930221351.682772535@linutronix.de>
	 <20100930221743.014571381@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Oct 2010 10:42:17 +1000
Message-ID: <1285893737.2463.4.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-30 at 23:18 +0000, Thomas Gleixner wrote:
> plain text document attachment (powerpc-use-new-allocator.patch)
> Use the new functions and free the descriptor when the virq is
> destroyed.

Looks ok as a first pass, but we should go further and replace the
allocator we have in powerpc to use yours instead.

Then I should get rid of my big irq_map that maps virq to HW number &
domain pointers and instead put those in the irq data. Any objection to
me sticking some archdata there for that purpose ?

That would make things much cleaner and in fact move one large step
toward being able to make powerpc virq scheme generic, which seems to be
a good idea from what I've heard :-)

Cheers,
Ben.

> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  arch/powerpc/kernel/irq.c |   17 +++++++++--------
>  1 file changed, 9 insertions(+), 8 deletions(-)
> 
> Index: linux-2.6-tip/arch/powerpc/kernel/irq.c
> ===================================================================
> --- linux-2.6-tip.orig/arch/powerpc/kernel/irq.c
> +++ linux-2.6-tip/arch/powerpc/kernel/irq.c
> @@ -676,16 +676,15 @@ void irq_set_virq_count(unsigned int cou
>  static int irq_setup_virq(struct irq_host *host, unsigned int virq,
>  			    irq_hw_number_t hwirq)
>  {
> -	struct irq_desc *desc;
> +	int res;
>  
> -	desc = irq_to_desc_alloc_node(virq, 0);
> -	if (!desc) {
> +	res = irq_alloc_desc_at(virq, 0);
> +	if (res != virq) {
>  		pr_debug("irq: -> allocating desc failed\n");
>  		goto error;
>  	}
>  
> -	/* Clear IRQ_NOREQUEST flag */
> -	desc->status &= ~IRQ_NOREQUEST;
> +	irq_clear_status_flags(virq, IRQ_NOREQUEST);
>  
>  	/* map it */
>  	smp_wmb();
> @@ -694,11 +693,13 @@ static int irq_setup_virq(struct irq_hos
>  
>  	if (host->ops->map(host, virq, hwirq)) {
>  		pr_debug("irq: -> mapping failed, freeing\n");
> -		goto error;
> +		goto errdesc;
>  	}
>  
>  	return 0;
>  
> +errdesc:
> +	irq_free_descs(virq, 1);
>  error:
>  	irq_free_virt(virq, 1);
>  	return -1;
> @@ -877,9 +878,9 @@ void irq_dispose_mapping(unsigned int vi
>  	smp_mb();
>  	irq_map[virq].hwirq = host->inval_irq;
>  
> -	/* Set some flags */
> -	irq_to_desc(virq)->status |= IRQ_NOREQUEST;
> +	irq_set_status_flags(virq, IRQ_NOREQUEST);
>  
> +	irq_free_descs(virq, 1);
>  	/* Free it */
>  	irq_free_virt(virq, 1);
>  }
> 


