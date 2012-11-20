Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749Ab2KTIVY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 03:21:24 -0500
Received: from mga01.intel.com ([192.55.52.88]:5547 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752558Ab2KTIVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 03:21:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,284,1352102400"; 
   d="scan'208";a="251740095"
From: "Shevchenko, Andriy" <andriy.shevchenko@intel.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "spear-devel@list.st.com" <spear-devel@list.st.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>
Subject: Re: [PATCH] dt: add helper function to read u8 & u16 variables &
 arrays
Thread-Topic: [PATCH] dt: add helper function to read u8 & u16 variables &
 arrays
Thread-Index: AQHNxtnmG2JUbrBB7Uaga1PphgQcjJfyYj+A
Date: Tue, 20 Nov 2012 08:21:07 +0000
Message-ID: <1353399661.20110.4.camel@smile>
References: <0ee5b74534a09d75c14b22c2d9330c4971ab30fb.1353386646.git.viresh.kumar@linaro.org>
In-Reply-To: <0ee5b74534a09d75c14b22c2d9330c4971ab30fb.1353386646.git.viresh.kumar@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.237.72.173]
Content-Type: text/plain; charset="utf-8"
Content-ID: <DC32EC40E6BD014FB4648216ECBDAA73@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qAK8LSHO020465

On Tue, 2012-11-20 at 10:15 +0530, Viresh Kumar wrote: 
> This adds following helper routines:
> - of_property_read_u8_array()
> - of_property_read_u16_array()
> - of_property_read_u8()
> - of_property_read_u16()
> 
> This expects arrays from DT to be passed as:
> - u8 array:
> 	property = /bits/ 8 <0x50 0x60 0x70>;
> - u16 array:
> 	property = /bits/ 16 <0x5000 0x6000 0x7000>;
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
> V2->V3:
> - Expect u8 & u16 arrays to be passed using: /bits/ 8 or 16
> - remove common macro, as not much common now :(

You could at least create macro to do a precheck if you want to.

Like 
#define CHECK_PROP(prop, sz, out)

{
if (!prop) 
		return -EINVAL;
	if (!prop->value)
		return -ENODATA;
	if ((sz * sizeof(*out)) > prop->length)
		return -EOVERFLOW;
}

Of course you can do even robust macro to cover types, but I don't like
ugly macros (as I can't see how it could be shaped nicely).

> - Tested on ARM platform.
> 

> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -671,12 +671,89 @@ struct device_node *of_find_node_by_phandle(phandle handle)
>  EXPORT_SYMBOL(of_find_node_by_phandle);
>  
>  /**
> + * of_property_read_u8_array - Find and read an array of u8 from a property.
> + *
> + * @np:		device node from which the property value is to be read.
> + * @propname:	name of the property to be searched.
> + * @out_value:	pointer to return value, modified only if return value is 0.
> + * @sz:		number of array elements to read
> + *
> + * Search for a property in a device node and read 8-bit value(s) from
> + * it. Returns 0 on success, -EINVAL if the property does not exist,
> + * -ENODATA if property does not have a value, and -EOVERFLOW if the
> + * property data isn't large enough.
> + *
> + * dts entry of array should be like:
> + *	property = /bits/ 8 <0x50 0x60 0x70>;
> + *
> + * The out_value is modified only if a valid u8 value can be decoded.
> + */
> +int of_property_read_u8_array(const struct device_node *np,
> +			const char *propname, u8 *out_values, size_t sz)
> +{
> +	struct property *prop = of_find_property(np, propname, NULL);
> +	const u8 *val;
> +
> +	if (!prop)
> +		return -EINVAL;
> +	if (!prop->value)
> +		return -ENODATA;
> +	if ((sz * sizeof(*out_values)) > prop->length)
> +		return -EOVERFLOW;
> +
> +	val = prop->value;
> +	while (sz--)
> +		*out_values++ = *val++;
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(of_property_read_u8_array);
> +
> +/**
> + * of_property_read_u16_array - Find and read an array of u16 from a property.
> + *
> + * @np:		device node from which the property value is to be read.
> + * @propname:	name of the property to be searched.
> + * @out_value:	pointer to return value, modified only if return value is 0.
> + * @sz:		number of array elements to read
> + *
> + * Search for a property in a device node and read 16-bit value(s) from
> + * it. Returns 0 on success, -EINVAL if the property does not exist,
> + * -ENODATA if property does not have a value, and -EOVERFLOW if the
> + * property data isn't large enough.
> + *
> + * dts entry of array should be like:
> + *	property = /bits/ 16 <0x5000 0x6000 0x7000>;
> + *
> + * The out_value is modified only if a valid u16 value can be decoded.
> + */
> +int of_property_read_u16_array(const struct device_node *np,
> +			const char *propname, u16 *out_values, size_t sz)
> +{
> +	struct property *prop = of_find_property(np, propname, NULL);
> +	const __be16 *val;
> +
> +	if (!prop)
> +		return -EINVAL;
> +	if (!prop->value)
> +		return -ENODATA;
> +	if ((sz * sizeof(*out_values)) > prop->length)
> +		return -EOVERFLOW;
> +
> +	val = prop->value;
> +	while (sz--)
> +		*out_values++ = be16_to_cpup(val++);
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(of_property_read_u16_array);
> +
> +/**
>   * of_property_read_u32_array - Find and read an array of 32 bit integers
>   * from a property.
>   *
>   * @np:		device node from which the property value is to be read.
>   * @propname:	name of the property to be searched.
>   * @out_value:	pointer to return value, modified only if return value is 0.
> + * @sz:		number of array elements to read
>   *
>   * Search for a property in a device node and read 32-bit value(s) from
>   * it. Returns 0 on success, -EINVAL if the property does not exist,

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
