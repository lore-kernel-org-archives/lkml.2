Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757263Ab2KZVi4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 16:38:56 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:46980 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756354Ab2KZViz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 16:38:55 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] No need to call irq_domain_legacy_revmap() for twice
To: Mike Qiu <qiudayu@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, benh@kernel.crashing.org,
        Mike Qiu <qiudayu@linux.vnet.ibm.com>
In-Reply-To: <1348479475-13074-1-git-send-email-qiudayu@linux.vnet.ibm.com>
References: <1348479475-13074-1-git-send-email-qiudayu@linux.vnet.ibm.com>
Date: Mon, 26 Nov 2012 20:17:39 +0000
Message-Id: <20121126201739.13F213E09C2@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Sep 2012 17:37:55 +0800, Mike Qiu <qiudayu@linux.vnet.ibm.com> wrote:
> Function irq_create_mapping() calls irq_find_mapping(). The later
> function has checked if the indicated IRQ domain has hw IRQ mapped to
> virtual IRQ through legacy mode or not and return the value of the
> legacy irq number by call irq_domain_legacy_revmap(). We needn't
> to call irq_domain_legacy_revmap() to do same check in
> irq_create_mapping() again.
> 
> The patch removes the duplicate call.
> 
> Signed-off-by: Mike Qiu <qiudayu@linux.vnet.ibm.com>
> ---
>  kernel/irq/irqdomain.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
> index 49a7772..286d672 100644
> --- a/kernel/irq/irqdomain.c
> +++ b/kernel/irq/irqdomain.c
> @@ -547,9 +547,12 @@ unsigned int irq_create_mapping(struct irq_domain *domain,
>  		return virq;
>  	}
>  
> -	/* Get a virtual interrupt number */
> +	/*
> +	 * For IRQ domain with type of IRQ_DOMAIN_MAP_LEGACY, we needn't
> +	 * create the IRQ mapping for non-existing one, so just return 0.
> +	 */
>  	if (domain->revmap_type == IRQ_DOMAIN_MAP_LEGACY)
> -		return irq_domain_legacy_revmap(domain, hwirq);
> +		return 0;

But it does need to return the virq assigned to the hwirq. That is why
it has to call the revmap function.

g.

