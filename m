Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757934Ab1JEIiR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 04:38:17 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50042 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752658Ab1JEIiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 04:38:13 -0400
Date: Wed, 5 Oct 2011 09:38:09 +0100
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regcache: Use bsearch() to search the register defaults
Message-ID: <20111005083809.GA16418@opensource.wolfsonmicro.com>
References: <1317762396-1248-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317762396-1248-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 04, 2011 at 10:06:36PM +0100, Mark Brown wrote:
> Rather than open coding a binary search use the standard bsearch() using
> the comparison function we're already using for sort() on insert. This
> fixes a lockup I was observing due to iterating on min <= max rather
> than min < max when we fail to look up.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/base/regmap/regcache.c |   40 ++++++++++++++++++++--------------------
>  1 files changed, 20 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
> index 18ab5b3..bf82783 100644
> --- a/drivers/base/regmap/regcache.c
> +++ b/drivers/base/regmap/regcache.c
> @@ -13,6 +13,7 @@
>  #include <linux/slab.h>
>  #include <linux/export.h>
>  #include <trace/events/regmap.h>
> +#include <linux/bsearch.h>
>  #include <linux/sort.h>
>  
>  #include "internal.h"
> @@ -356,25 +357,7 @@ unsigned int regcache_get_val(const void *base, unsigned int idx,
>  	return -1;
>  }
>  
> -int regcache_lookup_reg(struct regmap *map, unsigned int reg)
> -{
> -	unsigned int min, max, index;
> -
> -	min = 0;
> -	max = map->num_reg_defaults - 1;
> -	do {
> -		index = (min + max) / 2;
> -		if (map->reg_defaults[index].reg == reg)
> -			return index;
> -		if (map->reg_defaults[index].reg < reg)
> -			min = index + 1;
> -		else
> -			max = index;
> -	} while (min <= max);
> -	return -1;
> -}
> -
> -static int regcache_insert_cmp(const void *a, const void *b)
> +static int regcache_default_cmp(const void *a, const void *b)
>  {
>  	const struct reg_default *_a = a;
>  	const struct reg_default *_b = b;
> @@ -382,6 +365,23 @@ static int regcache_insert_cmp(const void *a, const void *b)
>  	return _a->reg - _b->reg;
>  }
>  
> +int regcache_lookup_reg(struct regmap *map, unsigned int reg)
> +{
> +	struct reg_default key;
> +	struct reg_default *r;
> +
> +	key.reg = reg;
> +	key.def = 0;
> +
> +	r = bsearch(&key, map->reg_defaults, map->num_reg_defaults,
> +		    sizeof(struct reg_default), regcache_default_cmp);
> +
> +	if (r)
> +		return r - map->reg_defaults;
> +	else
> +		return -1;
> +}
> +
>  int regcache_insert_reg(struct regmap *map, unsigned int reg,
>  			unsigned int val)
>  {
> @@ -397,6 +397,6 @@ int regcache_insert_reg(struct regmap *map, unsigned int reg,
>  	map->reg_defaults[map->num_reg_defaults - 1].reg = reg;
>  	map->reg_defaults[map->num_reg_defaults - 1].def = val;
>  	sort(map->reg_defaults, map->num_reg_defaults,
> -	     sizeof(struct reg_default), regcache_insert_cmp, NULL);
> +	     sizeof(struct reg_default), regcache_default_cmp, NULL);
>  	return 0;
>  }
> -- 
> 1.7.6.3
> 

Looks good :)

Acked-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
