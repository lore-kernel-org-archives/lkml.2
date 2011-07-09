Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560Ab1GJI6U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 04:58:20 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:50527 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755494Ab1GJI6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 04:58:15 -0400
Date: Sat, 9 Jul 2011 11:13:20 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 1/4] dt: expose device resource allocator
Message-ID: <20110709171320.GA2805@ponder.secretlab.ca>
References: <1310115250-3859-1-git-send-email-marc.zyngier@arm.com>
 <1310115250-3859-2-git-send-email-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310115250-3859-2-git-send-email-marc.zyngier@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 08, 2011 at 09:54:07AM +0100, Marc Zyngier wrote:
> of_device_alloc() takes care of allocating both a platform
> device and its associated resource, as part of the runtime
> device-tree to platform_device conversion.
> 
> The resource allocation itself is useful on its own, and
> would be used by the core driver subsystem.  Create the
> of_device_alloc_resources() function, and let of_device_alloc()
> use it.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Hi Marc,

Comments below.

> ---
>  drivers/of/platform.c       |   60 +++++++++++++++++++++++++++++-------------
>  include/linux/of_platform.h |    2 +
>  2 files changed, 43 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/of/platform.c b/drivers/of/platform.c
> index e75af39..f839f79 100644
> --- a/drivers/of/platform.c
> +++ b/drivers/of/platform.c
> @@ -122,22 +122,16 @@ void of_device_make_bus_id(struct device *dev)
>  }
>  
>  /**
> - * of_device_alloc - Allocate and initialize an of_device
> - * @np: device node to assign to device
> - * @bus_id: Name to assign to the device.  May be null to use default name.
> - * @parent: Parent device.
> + * of_device_alloc_resources - Allocate and initialize resources for an
> + *			       of_device
> + * @np: device node to fetch resources from
> + * @num_res: number of allocated resources
>   */
> -struct platform_device *of_device_alloc(struct device_node *np,
> -				  const char *bus_id,
> -				  struct device *parent)
> +struct resource *of_device_alloc_resources(struct device_node *np,
> +					   int *num_res)
>  {
> -	struct platform_device *dev;
>  	int rc, i, num_reg = 0, num_irq;
> -	struct resource *res, temp_res;
> -
> -	dev = platform_device_alloc("", -1);
> -	if (!dev)
> -		return NULL;
> +	struct resource *res = NULL, temp_res;
>  
>  	/* count the io and irq resources */
>  	while (of_address_to_resource(np, num_reg, &temp_res) == 0)
> @@ -148,19 +142,47 @@ struct platform_device *of_device_alloc(struct device_node *np,
>  	if (num_irq || num_reg) {
>  		res = kzalloc(sizeof(*res) * (num_irq + num_reg), GFP_KERNEL);
>  		if (!res) {
> -			platform_device_put(dev);
> +			*num_res = -1;

I would argue that it is not a good idea to modify num_res in the
failure case.  Though I man not be fond of the pattern, the common
convention in the kernel is to use ERR_PTR when a function needs to
differentiate between a failure case and simply "no data".

>  			return NULL;
>  		}
>  
> -		dev->num_resources = num_reg + num_irq;
> -		dev->resource = res;
> -		for (i = 0; i < num_reg; i++, res++) {
> -			rc = of_address_to_resource(np, i, res);
> +		for (i = 0; i < num_reg; i++) {
> +			rc = of_address_to_resource(np, i, &res[i]);

Nit: the patch would be less invasive if the 'res' pointer handling
was left alone.  Just keep a copy of the starting position to use for
returning.

>  			WARN_ON(rc);
>  		}
> -		WARN_ON(of_irq_to_resource_table(np, res, num_irq) != num_irq);
> +		WARN_ON(of_irq_to_resource_table(np, &res[i], num_irq) != num_irq);
> +	}
> +
> +	*num_res = num_irq + num_reg;
> +	return res;
> +}
> +
> +/**
> + * of_device_alloc - Allocate and initialize an of_device
> + * @np: device node to assign to device
> + * @bus_id: Name to assign to the device.  May be null to use default name.
> + * @parent: Parent device.
> + */
> +struct platform_device *of_device_alloc(struct device_node *np,
> +				  const char *bus_id,
> +				  struct device *parent)
> +{
> +	struct platform_device *dev;
> +	int num_res;
> +	struct resource *res;
> +
> +	dev = platform_device_alloc("", -1);
> +	if (!dev)
> +		return NULL;
> +
> +	res = of_device_alloc_resources(np, &num_res);
> +	if (num_res == -1) {
> +		platform_device_put(dev);
> +		return NULL;
>  	}
>  
> +	dev->num_resources = num_res;
> +	dev->resource = res;
>  	dev->dev.of_node = of_node_get(np);
>  #if defined(CONFIG_PPC) || defined(CONFIG_MICROBLAZE)
>  	dev->dev.dma_mask = &dev->archdata.dma_mask;
> diff --git a/include/linux/of_platform.h b/include/linux/of_platform.h
> index 5a6f458..773a880 100644
> --- a/include/linux/of_platform.h
> +++ b/include/linux/of_platform.h
> @@ -77,6 +77,8 @@ struct of_platform_driver
>  extern const struct of_device_id of_default_bus_match_table[];
>  
>  /* Platform drivers register/unregister */
> +extern struct resource *of_device_alloc_resources(struct device_node *np,
> +						  int *num_res);
>  extern struct platform_device *of_device_alloc(struct device_node *np,
>  					 const char *bus_id,
>  					 struct device *parent);
> -- 
> 1.7.0.4
> 
> 
