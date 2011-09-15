Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934031Ab1IOPTq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 11:19:46 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:43500 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933990Ab1IOPTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 11:19:45 -0400
Message-ID: <4E721784.90302@metafoo.de>
Date: Thu, 15 Sep 2011 17:19:32 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110818 Icedove/3.0.11
MIME-Version: 1.0
To: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
CC: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Graeme Gregory <gg@slimlogic.co.uk>,
        Samuel Oritz <sameo@linux.intel.com>
Subject: Re: [PATCH 6/6 v3] regmap: Incorporate the regcache core into regmap
References: <1316082879-21810-1-git-send-email-dp@opensource.wolfsonmicro.com> <1316082879-21810-7-git-send-email-dp@opensource.wolfsonmicro.com>
In-Reply-To: <1316082879-21810-7-git-send-email-dp@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> [...]
> @@ -321,6 +333,18 @@ int regmap_write(struct regmap *map, unsigned int reg, unsigned int val)
>  
>  	mutex_lock(&map->lock);
>  
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
> +

Would it make sense to move this into _regmap_write ? In that case the code
wouldn't have to be duplicated in regmap_update_bits and as a bonus it wouldn't
have to deal with the mutex either.

>  	ret = _regmap_write(map, reg, val);
>  
>  	mutex_unlock(&map->lock);
> @@ -422,6 +446,14 @@ int regmap_read(struct regmap *map, unsigned int reg, unsigned int *val)
>  
>  	mutex_lock(&map->lock);
>  
> +	if (!map->cache_bypass) {
> +		ret = regcache_read(map, reg, val);
> +		if (!ret) {
> +			mutex_unlock(&map->lock);
> +			return 0;
> +		}

So in case regmap_readable is not true for this register regcache_read will
return -EIO and we'll fallback to an uncached read. This doesn't make sense in
my opinion. Or what are the except semantics regmap_readable supposed to be?

> +	}
> +
>  	ret = _regmap_read(map, reg, val);
>  
>  	mutex_unlock(&map->lock);

