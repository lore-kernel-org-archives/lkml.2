Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025Ab0IJRYf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 13:24:35 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:56722 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116Ab0IJRYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 13:24:34 -0400
Date: Fri, 10 Sep 2010 11:24:31 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Andres Salomon <dilinger@queued.net>
Cc: devicetree-discuss@lists.ozlabs.org, x86@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, Mitch Bradley <wmb@laptop.org>,
        linux-kernel@vger.kernel.org,
        Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
Subject: Re: [PATCH 1/2] x86: of: remove references to NO_IRQ in
 drivers/of/platform.c
Message-ID: <20100910172431.GB11284@angua.secretlab.ca>
References: <20100910060101.26c7e61c@debxo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100910060101.26c7e61c@debxo>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 10, 2010 at 06:01:01AM -0700, Andres Salomon wrote:
> 
> Instead of referencing NO_IRQ in platform.c, define some helper functions
> in irq.c to call instead from platform.c.  Keep NO_IRQ usage local to
> irq.c, and define NO_IRQ if not defined in headers.
> 
> Signed-off-by: Andres Salomon <dilinger@queued.net>

Applied, thanks.

g.

> ---
>  drivers/of/irq.c       |   39 +++++++++++++++++++++++++++++++++++++++
>  drivers/of/platform.c  |   10 +++-------
>  include/linux/of_irq.h |    3 +++
>  3 files changed, 45 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/of/irq.c b/drivers/of/irq.c
> index 6e595e5..75b0d3c 100644
> --- a/drivers/of/irq.c
> +++ b/drivers/of/irq.c
> @@ -24,6 +24,11 @@
>  #include <linux/of_irq.h>
>  #include <linux/string.h>
>  
> +/* For archs that don't support NO_IRQ (such as x86), provide a dummy value */
> +#ifndef NO_IRQ
> +#define NO_IRQ 0
> +#endif
> +
>  /**
>   * irq_of_parse_and_map - Parse and map an interrupt into linux virq space
>   * @device: Device node of the device whose interrupt is to be mapped
> @@ -347,3 +352,37 @@ int of_irq_to_resource(struct device_node *dev, int index, struct resource *r)
>  	return irq;
>  }
>  EXPORT_SYMBOL_GPL(of_irq_to_resource);
> +
> +/**
> + * of_irq_count - Count the number of IRQs a node uses
> + * @dev: pointer to device tree node
> + */
> +int of_irq_count(struct device_node *dev)
> +{
> +	int nr = 0;
> +
> +	while (of_irq_to_resource(dev, nr, NULL) != NO_IRQ)
> +		nr++;
> +
> +	return nr;
> +}
> +
> +/**
> + * of_irq_to_resource_table - Fill in resource table with node's IRQ info
> + * @dev: pointer to device tree node
> + * @res: array of resources to fill in
> + * @nr_irqs: the number of IRQs (and upper bound for num of @res elements)
> + *
> + * Returns the size of the filled in table (up to @nr_irqs).
> + */
> +int of_irq_to_resource_table(struct device_node *dev, struct resource *res,
> +		int nr_irqs)
> +{
> +	int i;
> +
> +	for (i = 0; i < nr_irqs; i++, res++)
> +		if (of_irq_to_resource(dev, i, res) == NO_IRQ)
> +			break;
> +
> +	return i;
> +}
> diff --git a/drivers/of/platform.c b/drivers/of/platform.c
> index bb72223..30726c8 100644
> --- a/drivers/of/platform.c
> +++ b/drivers/of/platform.c
> @@ -584,14 +584,13 @@ struct platform_device *of_device_alloc(struct device_node *np,
>  				  struct device *parent)
>  {
>  	struct platform_device *dev;
> -	int rc, i, num_reg = 0, num_irq = 0;
> +	int rc, i, num_reg = 0, num_irq;
>  	struct resource *res, temp_res;
>  
>  	/* First count how many resources are needed */
>  	while (of_address_to_resource(np, num_reg, &temp_res) == 0)
>  		num_reg++;
> -	while (of_irq_to_resource(np, num_irq, &temp_res) != NO_IRQ)
> -		num_irq++;
> +	num_irq = of_irq_count(np);
>  
>  	/* Allocate memory for both the struct device and the resource table */
>  	dev = kzalloc(sizeof(*dev) + (sizeof(*res) * (num_reg + num_irq)),
> @@ -608,10 +607,7 @@ struct platform_device *of_device_alloc(struct device_node *np,
>  			rc = of_address_to_resource(np, i, res);
>  			WARN_ON(rc);
>  		}
> -		for (i = 0; i < num_irq; i++, res++) {
> -			rc = of_irq_to_resource(np, i, res);
> -			WARN_ON(rc == NO_IRQ);
> -		}
> +		WARN_ON(of_irq_to_resource_table(np, res, num_irq) != num_irq);
>  	}
>  
>  	dev->dev.of_node = of_node_get(np);
> diff --git a/include/linux/of_irq.h b/include/linux/of_irq.h
> index 5929781..090cbaa 100644
> --- a/include/linux/of_irq.h
> +++ b/include/linux/of_irq.h
> @@ -64,6 +64,9 @@ extern unsigned int irq_create_of_mapping(struct device_node *controller,
>  					  unsigned int intsize);
>  extern int of_irq_to_resource(struct device_node *dev, int index,
>  			      struct resource *r);
> +extern int of_irq_count(struct device_node *dev);
> +extern int of_irq_to_resource_table(struct device_node *dev,
> +		struct resource *res, int nr_irqs);
>  
>  #endif /* CONFIG_OF_IRQ */
>  #endif /* CONFIG_OF */
> -- 
> 1.5.6.5
> 
