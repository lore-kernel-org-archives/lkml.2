Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909Ab2H3S1I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 14:27:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53405 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754552Ab2H3S1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 14:27:05 -0400
Message-ID: <503FB074.7080702@gmail.com>
Date: Thu, 30 Aug 2012 13:27:00 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Murali Karicheri <m-karicheri2@ti.com>
CC: grant.likely@secretlab.ca, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] of: add devres version of of_iomap
References: <1346340744-22218-1-git-send-email-m-karicheri2@ti.com>
In-Reply-To: <1346340744-22218-1-git-send-email-m-karicheri2@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2012 10:32 AM, Murali Karicheri wrote:
> This adds devres version of the of_iomap() to allow resource to be cleaned
> through devres.

If you have a struct device, then don't you already have a resource and
can just use devm_ioremap in a driver? New drivers should not be using
of_iomap.

Rob

> 
> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
> ---
>  drivers/of/address.c       |   26 ++++++++++++++++++++++++--
>  include/linux/of_address.h |    2 ++
>  2 files changed, 26 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/of/address.c b/drivers/of/address.c
> index 7e262a6..d3da426 100644
> --- a/drivers/of/address.c
> +++ b/drivers/of/address.c
> @@ -602,10 +602,9 @@ struct device_node *of_find_matching_node_by_address(struct device_node *from,
>  	return NULL;
>  }
>  
> -
>  /**
>   * of_iomap - Maps the memory mapped IO for a given device_node
> - * @device:	the device whose io range will be mapped
> + * @device_node: Ptr to the device node that has the reg property
>   * @index:	index of the io range
>   *
>   * Returns a pointer to the mapped memory
> @@ -620,3 +619,26 @@ void __iomem *of_iomap(struct device_node *np, int index)
>  	return ioremap(res.start, resource_size(&res));
>  }
>  EXPORT_SYMBOL(of_iomap);
> +
> +/**
> + * of_devm_iomap - devres version of of_iomap
> + * @device:	the device whose io range will be mapped
> + * @index:	index of the io range
> + *
> + * Returns a pointer to the mapped memory
> + */
> +void __iomem *of_devm_iomap(struct device *dev, int index)
> +{
> +	struct device_node *np;
> +	struct resource res;
> +
> +	if (!dev)
> +		return NULL;
> +
> +	np = dev->of_node;
> +	if (of_address_to_resource(np, index, &res))
> +		return NULL;
> +
> +	return devm_ioremap(dev, res.start, resource_size(&res));
> +}
> +EXPORT_SYMBOL(of_devm_iomap);
> diff --git a/include/linux/of_address.h b/include/linux/of_address.h
> index 01b925a..67efa5f 100644
> --- a/include/linux/of_address.h
> +++ b/include/linux/of_address.h
> @@ -3,6 +3,7 @@
>  #include <linux/ioport.h>
>  #include <linux/errno.h>
>  #include <linux/of.h>
> +#include <linux/device.h>
>  
>  #ifdef CONFIG_OF_ADDRESS
>  extern u64 of_translate_address(struct device_node *np, const __be32 *addr);
> @@ -13,6 +14,7 @@ extern struct device_node *of_find_matching_node_by_address(
>  					const struct of_device_id *matches,
>  					u64 base_address);
>  extern void __iomem *of_iomap(struct device_node *device, int index);
> +extern void __iomem *of_devm_iomap(struct device *dev, int index);
>  
>  /* Extract an address from a device, returns the region size and
>   * the address space flags too. The PCI version uses a BAR number
> 
