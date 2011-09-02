Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755640Ab1IBUC5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 16:02:57 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:42622 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755256Ab1IBUCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 16:02:54 -0400
Message-ID: <4E61363A.9050607@metafoo.de>
Date: Fri, 02 Sep 2011 22:02:02 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110818 Icedove/3.0.11
MIME-Version: 1.0
To: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
CC: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Graeme Gregory <gg@slimlogic.co.uk>,
        Samuel Oritz <sameo@linux.intel.com>
Subject: Re: [PATCH 1/8] regmap: Introduce caching support
References: <1314978375-11539-1-git-send-email-dp@opensource.wolfsonmicro.com> <1314978375-11539-2-git-send-email-dp@opensource.wolfsonmicro.com>
In-Reply-To: <1314978375-11539-2-git-send-email-dp@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2011 05:46 PM, Dimitris Papastamos wrote:
> This patch introduces caching support for regmap.  The regcache API
> has evolved essentially out of ASoC soc-cache so most of the actual
> caching types (except LZO) have been tested in the past.
> 
> The purpose of regcache is to optimize in time and space the handling
> of register caches.  Time optimization is achieved by not having to go
> over a slow bus like I2C to read the value of a register, instead it is
> cached locally in memory and can be retrieved faster.  Regarding space
> optimization, some of the cache types are better at packing the caches,
> for e.g. the rbtree and the LZO caches.  By doing this the sacrifice in
> time still wins over doing I2C transactions.
> 
> Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
> ---
>  drivers/base/regmap/Makefile   |    2 +-
>  drivers/base/regmap/internal.h |   50 ++++++++
>  drivers/base/regmap/regcache.c |  251 ++++++++++++++++++++++++++++++++++++++++
>  include/linux/regmap.h         |   19 +++-
>  4 files changed, 316 insertions(+), 6 deletions(-)
>  create mode 100644 drivers/base/regmap/regcache.c
> 
> diff --git a/drivers/base/regmap/Makefile b/drivers/base/regmap/Makefile
> index 057c13f..2e103ea 100644
> --- a/drivers/base/regmap/Makefile
> +++ b/drivers/base/regmap/Makefile
> @@ -1,4 +1,4 @@
> -obj-$(CONFIG_REGMAP) += regmap.o
> +obj-$(CONFIG_REGMAP) += regmap.o regcache.o
>  obj-$(CONFIG_DEBUG_FS) += regmap-debugfs.o
>  obj-$(CONFIG_REGMAP_I2C) += regmap-i2c.o
>  obj-$(CONFIG_REGMAP_SPI) += regmap-spi.o
> diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
> index 5ab3fef..b7acbeb 100644
> [...]
> diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
> new file mode 100644
> index 0000000..90b7e1f
> --- /dev/null
> +++ b/drivers/base/regmap/regcache.c
> @@ -0,0 +1,251 @@
> +/*
> + * Register cache access API
> + *
> + * Copyright 2011 Wolfson Microelectronics plc
> + *
> + * Author: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/slab.h>
> +#include <trace/events/regmap.h>
> +
> +#include "internal.h"
> +
> +static const struct regcache_ops *cache_types[] = {
> +};

I wonder if it makes sense to keep a list of regcache_ops this way, or whether
it is not better to just pass the ops we want to use to regcache_init directly.

> +
> +int regcache_init(struct regmap *map)
> +{
> +	int i, j;
> +	int count;
> +	unsigned int val;
> +
> +	if (map->cache_type == REGCACHE_NONE)
> +		return 0;
> +
> +	for (i = 0; i < ARRAY_SIZE(cache_types); ++i)
> +		if (cache_types[i]->type == map->cache_type)
> +			break;
> +
> +	if (i == ARRAY_SIZE(cache_types)) {
> +		dev_err(map->dev, "Could not match compress type: %d\n",
> +			map->cache_type);
> +		return -EINVAL;
> +	}
> +
> +	map->cache = NULL;
> +	map->cache_ops = cache_types[i];
> +	if (!map->cache_ops->name)
> +		return -EINVAL;
> +
> +	if (!map->cache_defaults_raw || !map->num_cache_defaults_raw) {
> +		dev_err(map->dev, "Client has not provided a defaults cache\n");
> +		return -EINVAL;
> +	}

It should be OK to provide no default register values, in this case regmap
should assume that the default for all registers is 0.

> +
> +	/* calculate the size of cache_defaults */
> +	for (count = 0, i = 0; i < map->num_cache_defaults_raw; i++) {
> +		val = regcache_get_val(map->cache_defaults_raw,
> +				       i, map->cache_word_size);
> +		if (!val)
> +			continue;
> +		count++;
> +	}
> +
> +	map->cache_defaults = kmalloc(count * sizeof(struct reg_default),
> +				      GFP_KERNEL);
> +	if (!map->cache_defaults)
> +		return -ENOMEM;
> +
> +	/* fill the cache_defaults */
> +	map->num_cache_defaults = count;
> +	for (i = 0, j = 0; i < map->num_cache_defaults_raw; i++) {
> +		val = regcache_get_val(map->cache_defaults_raw,
> +				       i, map->cache_word_size);
> +		if (!val)
> +			continue;
> +		map->cache_defaults[j].reg = i;
> +		map->cache_defaults[j].def = val;
> +		j++;
> +	}
> +
> +	if (map->cache_ops->init) {
> +		dev_dbg(map->dev, "Initializing %s cache\n",
> +			map->cache_ops->name);
> +		return map->cache_ops->init(map);
> +	}
> +	return 0;
> +}
> +
> +void regcache_exit(struct regmap *map)
> +{
> +	if (map->cache_type == REGCACHE_NONE)
> +		return;
> +
> +	BUG_ON(!map->cache_ops);
> +
> +	kfree(map->cache_defaults);
> +	if (map->cache_ops->exit) {
> +		dev_dbg(map->dev, "Destroying %s cache\n",
> +			map->cache_ops->name);
> +		map->cache_ops->exit(map);
> +	}
> +}
> +
> +/**
> + * regcache_read: Fetch the value of a given register from the cache.
> + *
> + * @map: map to configure.
> + * @reg: The register index.
> + * @value: The value to be returned.
> + *
> + * Return a negative value on failure, 0 on success.
> + */
> +int regcache_read(struct regmap *map,
> +		  unsigned int reg, unsigned int *value)
> +{
> +	if (map->cache_type == REGCACHE_NONE)
> +		return 0;
> +
> +	BUG_ON(!map->cache_ops);
> +
> +	if (reg < map->num_cache_defaults_raw) {
maybe use regmap_readable(map, reg)), but at least check against max_register
and not num_cache_defaults_raw

> +		if (!map->volatile_reg ||
> +		    (map->volatile_reg && !map->volatile_reg(map->dev, reg))) {

if (!regmap_volatile(map, reg))

> +			if (value && map->cache_ops->read)

Will value or cache_ops->read ever be NULL? A register cache that either only
provides read or write would be pretty useless in my opinion, and we should
probably check for this at initialization time and not upon each access.

> +				return map->cache_ops->read(map, reg, value);
> +		}
> +	}
> +	return -EINVAL;
> +}
> +EXPORT_SYMBOL_GPL(regcache_read);
> +
> +/**
> + * regcache_write: Set the value of a given register in the cache.
> + *
> + * @map: map to configure.
> + * @reg: The register index.
> + * @value: The new register value.
> + *
> + * Return a negative value on failure, 0 on success.
> + */
> +int regcache_write(struct regmap *map,
> +		   unsigned int reg, unsigned int value)
> +{
> +	if (map->cache_type == REGCACHE_NONE)
> +		return 0;
> +
> +	BUG_ON(!map->cache_ops);
> +
> +	if (reg < map->num_cache_defaults_raw) {
> +		if (!map->volatile_reg ||
> +		    (map->volatile_reg && !map->volatile_reg(map->dev, reg))) {
> +			if (map->cache_ops->write)
> +				return map->cache_ops->write(map, reg, value);
> +		}
> +	}
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(regcache_write);

Same comments as for regcache_read

> +
> +/**
> + * regcache_sync: Sync the register cache with the hardware.
> + *
> + * @map: map to configure.
> + *
> + * Any registers that should not be synced should be marked as
> + * volatile.  In general drivers can choose not to use the provided
> + * syncing functionality if they so require.
> + *
> + * Return a negative value on failure, 0 on success.
> + */
> +int regcache_sync(struct regmap *map)
> +{
> +	BUG_ON(!map->cache_ops);
> +
> +	if (map->cache_ops->sync) {
> +		dev_dbg(map->dev, "Syncing %s cache\n",
> +			map->cache_ops->name);
> +		return map->cache_ops->sync(map);
> +	}
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(regcache_sync);
> +
> +bool regcache_set_val(void *base, unsigned int idx,
> +		      unsigned int val, unsigned int word_size)
> +{
> +	switch (word_size) {
> +	case 1: {
> +		u8 *cache = base;
> +		if (cache[idx] == val)
> +			return true;
> +		cache[idx] = val;
> +		break;
> +	}
> +	case 2: {
> +		u16 *cache = base;
> +		if (cache[idx] == val)
> +			return true;
> +		cache[idx] = val;
> +		break;
> +	}
> +	default:
> +		BUG();
> +	}
> +	/* unreachable */
> +	return false;
> +}
> +
> +unsigned int regcache_get_val(const void *base, unsigned int idx,
> +			      unsigned int word_size)
> +{
> +	if (!base)
> +		return -EINVAL;
> +
> +	switch (word_size) {
> +	case 1: {
> +		const u8 *cache = base;
> +		return cache[idx];
> +	}
> +	case 2: {
> +		const u16 *cache = base;
> +		return cache[idx];
> +	}
> +	default:
> +		BUG();
> +	}
> +	/* unreachable */
> +	return -1;
> +}
> +
> +int regcache_lookup_reg(struct regmap *map, unsigned int reg)
> +{
> +	int i;
unsigned int

> +
> +	for (i = 0; i < map->num_cache_defaults; ++i)
> +		if (map->cache_defaults[i].reg == reg)
> +			return i;
> +	return -1;
> +}
> +
> +int regcache_insert_reg(struct regmap *map, unsigned int reg,
> +			unsigned int val)
> +{
> +	void *tmp;
> +
> +	tmp = krealloc(map->cache_defaults,
> +		       (map->num_cache_defaults + 1) * sizeof(struct reg_default),
> +		       GFP_KERNEL);
> +	if (!tmp)
> +		return -ENOMEM;
> +	map->cache_defaults = tmp;
> +	++map->num_cache_defaults;
> +	map->cache_defaults[map->num_cache_defaults - 1].reg = reg;
> +	map->cache_defaults[map->num_cache_defaults - 1].def = val;
> +	return 0;
> +}
> diff --git a/include/linux/regmap.h b/include/linux/regmap.h
> index 449e264..b81e86a 100644
> --- a/include/linux/regmap.h
> +++ b/include/linux/regmap.h
> @@ -20,6 +20,11 @@
>  struct i2c_client;
>  struct spi_device;
>  
> +/* An enum of all the supported cache types */
> +enum regcache_type {
> +	REGCACHE_NONE,
> +};
> +
>  /**
>   * Default value for a register.  We use an array of structs rather
>   * than a simple array as many modern devices have very sparse
> @@ -50,9 +55,11 @@ struct reg_default {
>   *                (eg, a clear on read interrupt status register).
>   *
>   * @max_register: Optional, specifies the maximum valid register index.
> - * @reg_defaults: Power on reset values for registers (for use with
> - *                register cache support).
> - * @num_reg_defaults: Number of elements in reg_defaults.
> + *
> + * @cache_type: The actual cache type.
> + * @cache_defaults_raw: Power on reset values for registers (for use with
> + *                 register cache support).
> + * @num_cache_defaults_raw: Number of elements in cache_defaults_raw.
>   */
>  struct regmap_config {
>  	int reg_bits;
> @@ -64,8 +71,10 @@ struct regmap_config {
>  	bool (*precious_reg)(struct device *dev, unsigned int reg);
>  
>  	unsigned int max_register;
> -	struct reg_default *reg_defaults;
> -	int num_reg_defaults;

I guess these were removed by accident due to some merge conflict as they were
added just recently. It would be good if you could re-add them and if they are
set initialize cache_defaults using a memdup instead of reading cache_defaults_raw.

> +
> +	enum regcache_type cache_type;
> +	const void *cache_defaults_raw;
> +	unsigned num_cache_defaults_raw;
>  };
>  
>  typedef int (*regmap_hw_write)(struct device *dev, const void *data,

