Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689Ab2JOH4V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 03:56:21 -0400
Received: from mga01.intel.com ([192.55.52.88]:21648 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752248Ab2JOH4T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 03:56:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,587,1344236400"; 
   d="scan'208";a="235033110"
From: "Shevchenko, Andriy" <andriy.shevchenko@intel.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "spear-devel@list.st.com" <spear-devel@list.st.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dt: add helper function to read u8 & u16 variables &
 arrays
Thread-Topic: [PATCH] dt: add helper function to read u8 & u16 variables &
 arrays
Thread-Index: AQHNqKOqLdjCc5+BsEK9xzC+oOhiCpe58wsA
Date: Mon, 15 Oct 2012 07:56:16 +0000
Message-ID: <1350287772.10584.178.camel@smile>
References: <425b4bec021bce9a2de49959121907aeede6a0b9.1350064805.git.viresh.kumar@linaro.org>
In-Reply-To: <425b4bec021bce9a2de49959121907aeede6a0b9.1350064805.git.viresh.kumar@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.237.72.62]
Content-Type: text/plain; charset="utf-8"
Content-ID: <E68CA57CCA85984193E2D9B56BC2E995@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q9F7uQXI023840

On Fri, 2012-10-12 at 23:31 +0530, Viresh Kumar wrote: 
> This adds following helper routines:
> - of_property_read_u8_array()
> - of_property_read_u16_array()
> - of_property_read_u8()
> - of_property_read_u16()
> 
> First two actually share most of the code with of_property_read_u32_array(), so
> the common part is taken out into a macro, which can be used by all three
> *_array() routines.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/of/base.c  | 73 +++++++++++++++++++++++++++++++++++++++++++-----------
>  include/linux/of.h | 30 ++++++++++++++++++++++
>  2 files changed, 89 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/of/base.c b/drivers/of/base.c
> index 38892a9..446fe7f 100644
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -670,6 +670,64 @@ struct device_node *of_find_node_by_phandle(phandle handle)
>  }
>  EXPORT_SYMBOL(of_find_node_by_phandle);
>  
> +#define of_property_read_array(_np, _pname, _out, _sz, _type)		\
> +	struct property *_prop = of_find_property(_np, _pname, NULL);	\
> +	const __be32 *_val;						\
> +									\
> +	if (!_prop)							\
> +		return -EINVAL;						\
> +	if (!_prop->value)						\
> +		return -ENODATA;					\
> +	if ((_sz * sizeof(*_out)) > _prop->length)			\
> +		return -EOVERFLOW;					\
> +									\
> +	_val = _prop->value;						\
> +	while (_sz--)							\
> +		*_out++ = (_type)be32_to_cpup(_val++);			\
How about 
*_out++ = (typeof(*_out))...
?

> +	return 0;
> +
> +/**
> + * of_property_read_u8_array - Find and read an array of u8 from a property.
> + *
> + * @np:		device node from which the property value is to be read.
> + * @propname:	name of the property to be searched.
> + * @out_value:	pointer to return value, modified only if return value is 0.
> + *
> + * Search for a property in a device node and read 8-bit value(s) from
> + * it. Returns 0 on success, -EINVAL if the property does not exist,
> + * -ENODATA if property does not have a value, and -EOVERFLOW if the
> + * property data isn't large enough.
> + *
> + * The out_value is modified only if a valid u8 value can be decoded.
> + */
> +int of_property_read_u8_array(const struct device_node *np,
> +			const char *propname, u8 *out_values, size_t sz)
> +{
> +	of_property_read_array(np, propname, out_values, sz, u8);
> +}
> +EXPORT_SYMBOL_GPL(of_property_read_u8_array);
> +
> +/**
> + * of_property_read_u16_array - Find and read an array of u16 from a property.
> + *
> + * @np:		device node from which the property value is to be read.
> + * @propname:	name of the property to be searched.
> + * @out_value:	pointer to return value, modified only if return value is 0.
> + *
> + * Search for a property in a device node and read 16-bit value(s) from
> + * it. Returns 0 on success, -EINVAL if the property does not exist,
> + * -ENODATA if property does not have a value, and -EOVERFLOW if the
> + * property data isn't large enough.
> + *
> + * The out_value is modified only if a valid u16 value can be decoded.
> + */
> +int of_property_read_u16_array(const struct device_node *np,
> +			const char *propname, u16 *out_values, size_t sz)
> +{
> +	of_property_read_array(np, propname, out_values, sz, u16);
> +}
> +EXPORT_SYMBOL_GPL(of_property_read_u16_array);
> +
>  /**
>   * of_property_read_u32_array - Find and read an array of 32 bit integers
>   * from a property.
> @@ -689,20 +747,7 @@ int of_property_read_u32_array(const struct device_node *np,
>  			       const char *propname, u32 *out_values,
>  			       size_t sz)
>  {
> -	struct property *prop = of_find_property(np, propname, NULL);
> -	const __be32 *val;
> -
> -	if (!prop)
> -		return -EINVAL;
> -	if (!prop->value)
> -		return -ENODATA;
> -	if ((sz * sizeof(*out_values)) > prop->length)
> -		return -EOVERFLOW;
> -
> -	val = prop->value;
> -	while (sz--)
> -		*out_values++ = be32_to_cpup(val++);
> -	return 0;
> +	of_property_read_array(np, propname, out_values, sz, u32);
>  }
>  EXPORT_SYMBOL_GPL(of_property_read_u32_array);
>  
> diff --git a/include/linux/of.h b/include/linux/of.h
> index 72843b7..e2d9b40 100644
> --- a/include/linux/of.h
> +++ b/include/linux/of.h
> @@ -223,6 +223,10 @@ extern struct device_node *of_find_node_with_property(
>  extern struct property *of_find_property(const struct device_node *np,
>  					 const char *name,
>  					 int *lenp);
> +extern int of_property_read_u8_array(const struct device_node *np,
> +			const char *propname, u8 *out_values, size_t sz);
> +extern int of_property_read_u16_array(const struct device_node *np,
> +			const char *propname, u16 *out_values, size_t sz);
>  extern int of_property_read_u32_array(const struct device_node *np,
>  				      const char *propname,
>  				      u32 *out_values,
> @@ -357,6 +361,18 @@ static inline struct device_node *of_find_compatible_node(
>  	return NULL;
>  }
>  
> +static inline int of_property_read_u8_array(const struct device_node *np,
> +			const char *propname, u8 *out_values, size_t sz)
> +{
> +	return -ENOSYS;
> +}
> +
> +static inline int of_property_read_u16_array(const struct device_node *np,
> +			const char *propname, u16 *out_values, size_t sz)
> +{
> +	return -ENOSYS;
> +}
> +
>  static inline int of_property_read_u32_array(const struct device_node *np,
>  					     const char *propname,
>  					     u32 *out_values, size_t sz)
> @@ -463,6 +479,20 @@ static inline bool of_property_read_bool(const struct device_node *np,
>  	return prop ? true : false;
>  }
>  
> +static inline int of_property_read_u8(const struct device_node *np,
> +				       const char *propname,
> +				       u8 *out_value)
> +{
> +	return of_property_read_u8_array(np, propname, out_value, 1);
> +}
> +
> +static inline int of_property_read_u16(const struct device_node *np,
> +				       const char *propname,
> +				       u16 *out_value)
> +{
> +	return of_property_read_u16_array(np, propname, out_value, 1);
> +}
> +
>  static inline int of_property_read_u32(const struct device_node *np,
>  				       const char *propname,
>  				       u32 *out_value)

-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy
---------------------------------------------------------------------
Intel Finland Oy
Registered Address: PL 281, 00181 Helsinki 
Business Identity Code: 0357606 - 4 
Domiciled in Helsinki 

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
