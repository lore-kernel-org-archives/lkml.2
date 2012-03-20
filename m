Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964845Ab2CTUDS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 16:03:18 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47802 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932170Ab2CTUDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 16:03:15 -0400
Message-ID: <4F68E27E.3000408@gmail.com>
Date: Tue, 20 Mar 2012 15:03:10 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: linus.walleij@linaro.org, devicetree-discuss@lists.ozlabs.org,
        linus.walleij@stericsson.com, s.hauer@pengutronix.de,
        linux-kernel@vger.kernel.org, rob.herring@calxeda.com,
        linux-tegra@vger.kernel.org, dongas86@gmail.com
Subject: Re: [PATCH V2 1/6] dt: add property iteration helpers
References: <1332265479-1260-1-git-send-email-swarren@wwwdotorg.org>
In-Reply-To: <1332265479-1260-1-git-send-email-swarren@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2012 12:44 PM, Stephen Warren wrote:
> This patch adds macros of_property_for_each_u32() and
> of_property_for_each_string(), which iterate over an array of values
> within a device-tree property. Usage is for example:
> 
> struct property *prop;
> const __be32 *p;
> u32 u;
> of_property_for_each_u32(np, "propname", prop, p, u)
> 	printk("U32 value: %x\n", u);
> 
> struct property *prop;
> const char *s;
> of_property_for_each_string(np, "propname", prop, s)
> 	printk("String value: %s\n", s);
> 
> Based on work by Rob Herring <robherring2@gmail.com>
> 
> Signed-off-by: Stephen Warren <swarren@wwwdotorg.org>
> ---
> v2: Simplified the implementation per suggestion by Rob Herring.
> ---
>  include/linux/of_iter_prop.h |  101 ++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 101 insertions(+), 0 deletions(-)
>  create mode 100644 include/linux/of_iter_prop.h

I don't think this makes sense to be a new header as it's use is pretty
much the same as other property functions. I would un-inline the helper
functions to of/base.c and move the defines to of.h.

Rob

> diff --git a/include/linux/of_iter_prop.h b/include/linux/of_iter_prop.h
> new file mode 100644
> index 0000000..e3df23c
> --- /dev/null
> +++ b/include/linux/of_iter_prop.h
> @@ -0,0 +1,101 @@
> +/*
> + * Copyright (c) 2011-2012 NVIDIA CORPORATION. All rights reserved.
> + *
> + * Iterate over properties that store arrays.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +#ifndef __OF_ITER_PROP_H__
> +#define __OF_ITER_PROP_H__
> +
> +#include <linux/of.h>
> +
> +#ifdef CONFIG_OF
> +static inline const __be32 *of_prop_next_u32(struct property *prop,
> +					     const __be32 *cur, u32 *pu)
> +{
> +	const void *curv = cur;
> +
> +	if (!prop)
> +		return NULL;
> +
> +	if (!cur) {
> +		curv = prop->value;
> +		goto out_val;
> +	}
> +
> +	curv += sizeof(*cur);
> +	if (curv >= prop->value + prop->length)
> +		return NULL;
> +
> +out_val:
> +	*pu = be32_to_cpup(curv);
> +	return curv;
> +}
> +
> +/*
> + * struct property *prop;
> + * const __be32 *p;
> + * u32 u;
> + *
> + * of_property_for_each_u32(np, "propname", prop, p, u)
> + *         printk("U32 value: %x\n", u);
> + */
> +#define of_property_for_each_u32(np, propname, prop, p, u)	\
> +	for (prop = of_find_property(np, propname, NULL),	\
> +		p = of_prop_next_u32(prop, NULL, &u);		\
> +		p;						\
> +		p = of_prop_next_u32(prop, p, &u))
> +
> +static inline const char *of_prop_next_string(struct property *prop,
> +					      const char *cur)
> +{
> +	const void *curv = cur;
> +
> +	if (!prop)
> +		return NULL;
> +
> +	if (!cur)
> +		return prop->value;
> +
> +	curv += strlen(cur) + 1;
> +	if (curv >= prop->value + prop->length)
> +		return NULL;
> +
> +	return curv;
> +}
> +
> +/*
> + * struct property *prop;
> + * const char *s;
> + *
> + * of_property_for_each_string(np, "propname", prop, s)
> + *         printk("String value: %s\n", s);
> + */
> +#define of_property_for_each_string(np, propname, prop, s)	\
> +	for (prop = of_find_property(np, propname, NULL),	\
> +		s = of_prop_next_string(prop, NULL);		\
> +		s;						\
> +		s = of_prop_next_string(prop, s))
> +
> +#else
> +
> +#define of_property_for_each_u32(np, propname, prop, p, u) \
> +	while (0)
> +
> +#define of_property_for_each_string(np, propname, prop, s) \
> +	while (0)
> +
> +#endif /* CONFIG_OF */
> +
> +#endif /* __OF_ITER_PROP_H__ */

