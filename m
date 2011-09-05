Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751365Ab1IEQWs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 12:22:48 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:39499 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750794Ab1IEQWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 12:22:42 -0400
Message-ID: <4E64F74C.1010606@metafoo.de>
Date: Mon, 05 Sep 2011 18:22:36 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110818 Icedove/3.0.11
MIME-Version: 1.0
To: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
CC: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Graeme Gregory <gg@slimlogic.co.uk>,
        Samuel Oritz <sameo@linux.intel.com>
Subject: Re: [PATCH 6/6] regmap: Incorporate the regcache core into regmap
References: <1315230662-12401-1-git-send-email-dp@opensource.wolfsonmicro.com> <1315230662-12401-7-git-send-email-dp@opensource.wolfsonmicro.com>
In-Reply-To: <1315230662-12401-7-git-send-email-dp@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2011 03:51 PM, Dimitris Papastamos wrote:
> This patch incorporates the regcache core code into regmap.  All previous
> patches have been no-ops essentially up to this point.
> 
> The bulk read operation is not supported by regcache at the moment.  This
> will be implemented incrementally.
> 
> Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
> ---
>  drivers/base/regmap/regmap.c |   56 ++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 56 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
> index fa2bd89..df4e00a 100644
> --- a/drivers/base/regmap/regmap.c
> +++ b/drivers/base/regmap/regmap.c
> @@ -146,6 +146,13 @@ struct regmap *regmap_init(struct device *dev,
>  	map->readable_reg = config->readable_reg;
>  	map->volatile_reg = config->volatile_reg;
>  	map->precious_reg = config->precious_reg;
> +	map->cache_type = config->cache_type;
> +	map->cache_defaults = config->cache_defaults;
> +	map->num_cache_defaults = config->num_cache_defaults;
> +	map->num_cache_defaults_raw = config->num_cache_defaults_raw;
> +	map->cache_defaults_raw = config->cache_defaults_raw;
> +	map->cache_size_raw = (config->val_bits / 8) * config->num_cache_defaults_raw;
> +	map->cache_word_size = config->val_bits / 8;
>  
>  	switch (config->reg_bits) {
>  	case 4:
> @@ -201,6 +208,12 @@ struct regmap *regmap_init(struct device *dev,
>  		goto err_bus;
>  	}
>  
> +#ifdef CONFIG_REGCACHE

CONFIG_REGCACHE is not defined, so we'll end up with no regcache support.

> +	ret = regcache_init(map);
> +	if (ret < 0)
> +		goto err_bus;
> +#endif
> +
>  	regmap_debugfs_init(map);
>  
>  	return map;
> @@ -219,6 +232,9 @@ EXPORT_SYMBOL_GPL(regmap_init);
>   */
>  void regmap_exit(struct regmap *map)
>  {
> +#ifdef CONFIG_REGCACHE
> +	regcache_exit(map);
> +#endif
>  	regmap_debugfs_exit(map);
>  	kfree(map->work_buf);
>  	module_put(map->bus->owner);
> @@ -321,6 +337,20 @@ int regmap_write(struct regmap *map, unsigned int reg, unsigned int val)
>  
>  	mutex_lock(&map->lock);
>  
> +#ifdef CONFIG_REGCACHE
> +	if (!map->cache_bypass) {
> +		ret = regcache_write(map, reg, val);
> +		if (ret < 0) {
> +			mutex_unlock(&map->lock);
> +			return ret;
> +		}
> +		if (map->cache_only) {
> +			mutex_unlock(&map->lock);
> +			return 0;
> +		}
> +	}
> +#endif
> +
>  	ret = _regmap_write(map, reg, val);
>  
>  	mutex_unlock(&map->lock);
> @@ -422,6 +452,16 @@ int regmap_read(struct regmap *map, unsigned int reg, unsigned int *val)
>  
>  	mutex_lock(&map->lock);
>  
> +#ifdef CONFIG_REGCACHE
> +	if (!map->cache_bypass) {
> +		ret = regcache_read(map, reg, val);
> +		if (!ret) {
> +			mutex_unlock(&map->lock);
> +			return 0;
> +		}
> +	}

I think this will need tighter integration. For example do we want to fallback
to a hw read when the cached read fails? And also regcache_read will return for
REGCACHE_NONE, which means we neither do a cached read nor a hw read.

> +#endif
> +
>  	ret = _regmap_read(map, reg, val);
>  
>  	mutex_unlock(&map->lock);

