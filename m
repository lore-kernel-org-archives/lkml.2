Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934004Ab1IOPLu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 11:11:50 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:42879 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933892Ab1IOPLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 11:11:49 -0400
Message-ID: <4E721595.9040108@metafoo.de>
Date: Thu, 15 Sep 2011 17:11:17 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110818 Icedove/3.0.11
MIME-Version: 1.0
To: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
CC: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Graeme Gregory <gg@slimlogic.co.uk>,
        Samuel Oritz <sameo@linux.intel.com>
Subject: Re: [PATCH 1/6 v3] regmap: Introduce caching support
References: <1316082879-21810-1-git-send-email-dp@opensource.wolfsonmicro.com> <1316082879-21810-2-git-send-email-dp@opensource.wolfsonmicro.com>
In-Reply-To: <1316082879-21810-2-git-send-email-dp@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tested-by: Lars-Peter Clausen <lars@metafoo.de> (for REGCACHE_NONE and
REGCACHE_RBTREE)

Some minor comments though:

> -
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
> +	unsigned int max_reg;
> +
> +	if (map->cache_type == REGCACHE_NONE)
> +		return -ENOSYS;
> +
> +	BUG_ON(!map->cache_ops);
> +
> +	if (!regmap_readable(map, reg))
> +		return -EIO;
> +
> +	if (map->max_register)
> +		max_reg = map->max_register;
> +	else
> +		max_reg = map->num_cache_defaults_raw;

In my opinion we should initialize max_register to num_cache_defaults_raw if it
is not set during initialization instead of doing this check each time. Also
regmap_readable already checks whether the register is in the register range,
so there is no need to repeat the check here.

> +
> +
> +	if (reg < max_reg && !regmap_volatile(map, reg))
> +		return map->cache_ops->read(map, reg, value);
> +	return -EINVAL;
> +}
> +EXPORT_SYMBOL_GPL(regcache_read);
> +
