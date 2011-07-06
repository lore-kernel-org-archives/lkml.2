Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258Ab1GFU7h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 16:59:37 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59811 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755821Ab1GFU7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 16:59:36 -0400
Date: Wed, 6 Jul 2011 14:59:33 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Thomas Abraham <thomas.abraham@linaro.org>
Subject: Re: [PATCH 1/2] dt: add helper function to read u32 arrays
Message-ID: <20110706205933.GA5371@ponder.secretlab.ca>
References: <1309984979-8847-1-git-send-email-robherring2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309984979-8847-1-git-send-email-robherring2@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 06, 2011 at 03:42:58PM -0500, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> Rework of_property_read_u32 to read an array of values. Then
> of_property_read_u32 becomes an inline with array size of 1.
> 
> Also make struct device_node ptr const.
> 
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> Cc: Thomas Abraham <thomas.abraham@linaro.org>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> ---
> 
> Grant, 
> 
> Perhaps you want to roll this into the original patch?

Applied, thanks.  The original is already in devicetree/next, so I've
just applied this on top as a separate commit.

> 
> It would also be nice if there were empty versions of the helpers
> as well.

Go ahead and submit a patch to add them if you need it.

g.

> 
> Rob
> 
>  drivers/of/base.c  |   19 +++++++++++++------
>  include/linux/of.h |   14 ++++++++++++--
>  2 files changed, 25 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/of/base.c b/drivers/of/base.c
> index b8b65fd..745537d 100644
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -596,32 +596,39 @@ struct device_node *of_find_node_by_phandle(phandle handle)
>  EXPORT_SYMBOL(of_find_node_by_phandle);
>  
>  /**
> - * of_property_read_u32 - Find and read a 32 bit integer from a property
> + * of_property_read_u32_array - Find and read an array of 32 bit integers
> + * from a property.
> + *
>   * @np:		device node from which the property value is to be read.
>   * @propname:	name of the property to be searched.
>   * @out_value:	pointer to return value, modified only if return value is 0.
>   *
> - * Search for a property in a device node and read a 32-bit value from
> + * Search for a property in a device node and read 32-bit value(s) from
>   * it. Returns 0 on success, -EINVAL if the property does not exist,
>   * -ENODATA if property does not have a value, and -EOVERFLOW if the
>   * property data isn't large enough.
>   *
>   * The out_value is modified only if a valid u32 value can be decoded.
>   */
> -int of_property_read_u32(struct device_node *np, char *propname, u32 *out_value)
> +int of_property_read_u32_array(const struct device_node *np, char *propname,
> +			       u32 *out_values, size_t sz)
>  {
>  	struct property *prop = of_find_property(np, propname, NULL);
> +	const __be32 *val;
>  
>  	if (!prop)
>  		return -EINVAL;
>  	if (!prop->value)
>  		return -ENODATA;
> -	if (sizeof(*out_value) > prop->length)
> +	if ((sz * sizeof(*out_values)) > prop->length)
>  		return -EOVERFLOW;
> -	*out_value = be32_to_cpup(prop->value);
> +
> +	val = prop->value;
> +	while (sz--)
> +		*out_values++ = be32_to_cpup(val++);
>  	return 0;
>  }
> -EXPORT_SYMBOL_GPL(of_property_read_u32);
> +EXPORT_SYMBOL_GPL(of_property_read_u32_array);
>  
>  /**
>   * of_property_read_string - Find and read a string from a property
> diff --git a/include/linux/of.h b/include/linux/of.h
> index 4fc4c1b..41f10e2 100644
> --- a/include/linux/of.h
> +++ b/include/linux/of.h
> @@ -195,8 +195,18 @@ extern struct device_node *of_find_node_with_property(
>  extern struct property *of_find_property(const struct device_node *np,
>  					 const char *name,
>  					 int *lenp);
> -extern int of_property_read_u32(struct device_node *np, char *propname,
> -					u32 *out_value);
> +extern int of_property_read_u32_array(const struct device_node *np,
> +				      char *propname,
> +				      u32 *out_values,
> +				      size_t sz);
> +
> +static inline int of_property_read_u32(const struct device_node *np,
> +				       char *propname,
> +				       u32 *out_value)
> +{
> +	return of_property_read_u32_array(np, propname, out_value, 1);
> +}
> +
>  extern int of_property_read_string(struct device_node *np, char *propname,
>  					char **out_string);
>  extern int of_device_is_compatible(const struct device_node *device,
> -- 
> 1.7.4.1
> 
