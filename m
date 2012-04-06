Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105Ab2DFDhP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 23:37:15 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51429 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775Ab2DFDhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 23:37:13 -0400
Message-ID: <4F7E64E4.3080509@gmail.com>
Date: Thu, 05 Apr 2012 22:37:08 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: David Daney <ddaney.cavm@gmail.com>
CC: devicetree-discuss@lists.ozlabs.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: Re: [PATCH] irq/irq_domain: Quit ignoring error returns from irq_alloc_desc_from().
References: <1333669933-25267-1-git-send-email-ddaney.cavm@gmail.com>
In-Reply-To: <1333669933-25267-1-git-send-email-ddaney.cavm@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05/2012 06:52 PM, David Daney wrote:
> From: David Daney <david.daney@cavium.com>
> 
> In commit 4bbdd45a (irq_domain/powerpc: eliminate irq_map; use
> irq_alloc_desc() instead) code was added that ignores error returns
> from irq_alloc_desc_from() by (silently) casting the return value to
> unsigned.  The negitive value error return now suddenly looks like a
> valid irq number.
> 
> Commits cc79ca69 (irq_domain: Move irq_domain code from powerpc to
> kernel/irq) and 1bc04f2c (irq_domain: Add support for base irq and
> hwirq in legacy mappings) move this code to its current location in
> irqdomain.c
> 
> The result of all of this is a null pointer dereference OOPS if one of
> the error cases is hit.
> 
> The fix: Don't cast away the negativeness of the return value and then
> check for errors.
> 
> Signed-off-by: David Daney <david.daney@cavium.com>
> ---
>  kernel/irq/irqdomain.c |   11 ++++++-----
>  1 files changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
> index af48e59..9d3e3ae 100644
> --- a/kernel/irq/irqdomain.c
> +++ b/kernel/irq/irqdomain.c
> @@ -351,6 +351,7 @@ unsigned int irq_create_mapping(struct irq_domain *domain,
>  				irq_hw_number_t hwirq)
>  {
>  	unsigned int virq, hint;
> +	int irq;
>  
>  	pr_debug("irq: irq_create_mapping(0x%p, 0x%lx)\n", domain, hwirq);
>  
> @@ -380,14 +381,14 @@ unsigned int irq_create_mapping(struct irq_domain *domain,
>  	hint = hwirq % irq_virq_count;
>  	if (hint == 0)
>  		hint++;
> -	virq = irq_alloc_desc_from(hint, 0);

You are not looking at mainline. hint was removed in later versions, and
the referenced commit ids don't exist.

Rob

> -	if (!virq)
> -		virq = irq_alloc_desc_from(1, 0);
> -	if (!virq) {
> +	irq = irq_alloc_desc_from(hint, 0);
> +	if (irq <= 0)
> +		irq = irq_alloc_desc_from(1, 0);
> +	if (irq <= 0) {
>  		pr_debug("irq: -> virq allocation failed\n");
>  		return 0;
>  	}
> -
> +	virq = irq;
>  	if (irq_setup_virq(domain, virq, hwirq)) {
>  		if (domain->revmap_type != IRQ_DOMAIN_MAP_LEGACY)
>  			irq_free_desc(virq);

