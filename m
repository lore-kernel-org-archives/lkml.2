Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932445Ab2CSQAw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 12:00:52 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:56412 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932410Ab2CSQAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 12:00:50 -0400
Message-ID: <4F67582E.9080901@gmail.com>
Date: Mon, 19 Mar 2012 11:00:46 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>, s.hauer@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, dongas86@gmail.com
Subject: Re: [PATCH 1/8] dt: add property iteration helpers
References: <1331931269-12262-1-git-send-email-swarren@wwwdotorg.org>
In-Reply-To: <1331931269-12262-1-git-send-email-swarren@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2012 03:54 PM, Stephen Warren wrote:
> This patch adds macros for_each_u32_property_value and
> for_each_string_property_value, which iterate over an array of values
> within a device-tree property. Usage is for example:
> 
> struct of_iter_string_prop iter;
> for_each_string_property_value(iter, np, "pins")
>         printk("Got value %s\n", iter.value);
> 

This seems overly complex and exposes a new struct primarily for
temporary storage. In your use, you only really use the ptr to each
string, so why not something like this:

const char *of_prop_next_string(struct property *p, const char *cur)
{
	int len;
	if (!prop)
		return NULL;
	if (!cur)
		return prop->value;
	
	len = strlen(cur) + 1;
	if (cur + len > prop->value + prop->length)
		return NULL;
	return cur + len;
}

#define of_property_for_each_string(prop, s) \
for (prop = of_find_property(), s = of_prop_next_string(prop, NULL); \
     s; \
     s = of_prop_next_string(prop, s))

Rob


> Signed-off-by: Stephen Warren <swarren@wwwdotorg.org>
> ---
>  include/linux/of_iter_prop.h |  139 ++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 139 insertions(+), 0 deletions(-)
>  create mode 100644 include/linux/of_iter_prop.h
> 
> diff --git a/include/linux/of_iter_prop.h b/include/linux/of_iter_prop.h
> new file mode 100644
> index 0000000..57e9e6a
> --- /dev/null
> +++ b/include/linux/of_iter_prop.h
> @@ -0,0 +1,139 @@
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
> +struct of_iter_u32_prop {
> +	const struct property *prop;
> +	int len;
> +	const __be32 *pvalue;
> +	u32 value;
> +};
> +
> +static inline void of_iter_u32_next(struct of_iter_u32_prop *iter)
> +{
> +	if (!iter->len)
> +		return;
> +
> +	iter->len--;
> +	if (iter->len)
> +		iter->value = be32_to_cpup(iter->pvalue++);
> +}
> +
> +static inline void of_iter_u32_init(struct of_iter_u32_prop *iter,
> +				    const struct device_node *np,
> +				    const char *name)
> +{
> +	iter->prop = of_find_property(np, name, &iter->len);
> +	if (!iter->prop) {
> +		iter->len = 0;
> +		return;
> +	}
> +
> +	iter->pvalue = iter->prop->value;
> +	if (!iter->pvalue) {
> +		iter->len = 0;
> +		return;
> +	}
> +
> +	iter->len /= sizeof(*iter->pvalue);
> +
> +	if (iter->len)
> +		iter->value = be32_to_cpup(iter->pvalue++);
> +}
> +
> +static inline bool of_iter_u32_test(struct of_iter_u32_prop *iter)
> +{
> +	return iter->len > 0;
> +}
> +
> +#define for_each_u32_property_value(iter, np, prop_name) \
> +	for (of_iter_u32_init(&iter, np, prop_name); \
> +	     of_iter_u32_test(&iter); \
> +	     of_iter_u32_next(&iter))
> +
> +struct of_iter_string_prop {
> +	const struct property *prop;
> +	int len;
> +	const char *value;
> +	const char *after;
> +};
> +
> +static inline void of_iter_string_init(struct of_iter_string_prop *iter,
> +				       const struct device_node *np,
> +				       const char *name)
> +{
> +	iter->prop = of_find_property(np, name, &iter->len);
> +	if (!iter->prop) {
> +		iter->value = NULL;
> +		return;
> +	}
> +
> +	iter->value = iter->prop->value;
> +	if (!iter->value)
> +		return;
> +
> +	iter->after = iter->value + iter->len;
> +}
> +
> +static inline bool of_iter_string_test(struct of_iter_string_prop *iter)
> +{
> +	if (!iter->value)
> +		return false;
> +
> +	return iter->value < iter->after;
> +}
> +
> +static inline void of_iter_string_next(struct of_iter_string_prop *iter)
> +{
> +	int len;
> +
> +	if (!iter->value)
> +		return;
> +
> +	len = strnlen(iter->value, iter->len);
> +	iter->len -= len + 1;
> +	iter->value += len + 1;
> +}
> +
> +#define for_each_string_property_value(iter, np, prop_name) \
> +	for (of_iter_string_init(&iter, np, prop_name); \
> +	     of_iter_string_test(&iter); \
> +	     of_iter_string_next(&iter))
> +
> +#else
> +struct of_iter_u32_prop {
> +	u32 value;
> +};
> +
> +#define for_each_u32_property_value(iter, np, prop_name) \
> +	while (0)
> +
> +struct of_iter_string_prop {
> +	const char *value;
> +};
> +
> +#define for_each_string_property_value(iter, np, prop_name) \
> +	while (0)
> +
> +#endif /* CONFIG_OF */
> +
> +#endif /* __OF_ITER_PROP_H__ */

