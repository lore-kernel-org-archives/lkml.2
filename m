Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664Ab2JAMMD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 08:12:03 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:43919 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929Ab2JAMMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 08:12:01 -0400
Message-ID: <50698880.1090103@gmail.com>
Date: Mon, 01 Oct 2012 07:11:44 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@stericsson.com>
CC: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Thomas Gleixner <tglx@linutronix.de>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 2/4 v2] irqdomain: augment add_simple() to allocate descs
References: <1349076922-25874-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1349076922-25874-1-git-send-email-linus.walleij@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2012 02:35 AM, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> Currently we rely on all IRQ chip instances to dynamically
> allocate their IRQ descriptors unless they use the linear
> IRQ domain. So for irqdomain_add_legacy() and
> irqdomain_add_simple() the caller need to make sure that
> descriptors are allocated.
> 
> Let's slightly augment the yet unused irqdomain_add_simple()
> to also allocate descriptors as a means to simplify usage
> and avoid code duplication throughout the kernel.
> 
> We warn if descriptors cannot be allocated, e.g. if a
> platform has the bad habit of hogging descriptors at boot
> time.
> 
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Paul Mundt <lethal@linux-sh.org>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Looks good.

Reviewed-by: Rob Herring <rob.herring@calxeda.com>

> ---
> ChangeLog v1->v2:
> - Switch descriptor allocation on IS_ENABLED(CONFIG_SPARSE_IRQ)
>   so it won't attempt to allocate descriptors in the non-sparse
>   case.
> - Use of_node_to_nid() to make sure we work on platforms with their
>   own node concept.
> - Specify irq_alloc_descs(first_irq, first_irq ...) to emulate
>   irq_alloc_desc_at().
> ---
>  kernel/irq/irqdomain.c | 33 ++++++++++++++++++++++++++++-----
>  1 file changed, 28 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
> index 49a7772..4e69e24 100644
> --- a/kernel/irq/irqdomain.c
> +++ b/kernel/irq/irqdomain.c
> @@ -148,7 +148,8 @@ static unsigned int irq_domain_legacy_revmap(struct irq_domain *domain,
>   * @host_data: Controller private data pointer
>   *
>   * Allocates a legacy irq_domain if irq_base is positive or a linear
> - * domain otherwise.
> + * domain otherwise. For the legacy domain, IRQ descriptors will also
> + * be allocated.
>   *
>   * This is intended to implement the expected behaviour for most
>   * interrupt controllers which is that a linear mapping should
> @@ -162,11 +163,33 @@ struct irq_domain *irq_domain_add_simple(struct device_node *of_node,
>  					 const struct irq_domain_ops *ops,
>  					 void *host_data)
>  {
> -	if (first_irq > 0)
> -		return irq_domain_add_legacy(of_node, size, first_irq, 0,
> +	if (first_irq > 0) {
> +		int irq_base;
> +
> +		if (IS_ENABLED(CONFIG_SPARSE_IRQ)) {
> +			/*
> +			 * Set the descriptor allocator to search for a
> +			 * 1-to-1 mapping, such as irq_alloc_desc_at().
> +			 * Use of_node_to_nid() which is defined to
> +			 * numa_node_id() on platforms that have no custom
> +			 * implementation.
> +			 */
> +			irq_base = irq_alloc_descs(first_irq, first_irq, size,
> +						   of_node_to_nid(of_node));
> +			if (irq_base < 0) {
> +				WARN(1, "Cannot allocate irq_descs @ IRQ%d, assuming pre-allocated\n",
> +				     first_irq);
> +				irq_base = first_irq;
> +			}
> +		} else
> +			irq_base = first_irq;
> +
> +		return irq_domain_add_legacy(of_node, size, irq_base, 0,
>  					     ops, host_data);
> -	else
> -		return irq_domain_add_linear(of_node, size, ops, host_data);
> +	}
> +
> +	/* A linear domain is the default */
> +	return irq_domain_add_linear(of_node, size, ops, host_data);
>  }
>  
>  /**
> 
