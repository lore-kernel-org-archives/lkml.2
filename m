Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756452Ab1ISP63 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 11:58:29 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:42862 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755531Ab1ISP61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 11:58:27 -0400
Message-ID: <4E77667D.8030404@metafoo.de>
Date: Mon, 19 Sep 2011 17:57:49 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110818 Icedove/3.0.11
MIME-Version: 1.0
To: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
CC: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Graeme Gregory <gg@slimlogic.co.uk>,
        Samuel Oritz <sameo@linux.intel.com>
Subject: Re: [PATCH 6/6 v5] regmap: Incorporate the regcache core into regmap
References: <1316439245-26221-1-git-send-email-dp@opensource.wolfsonmicro.com> <1316439245-26221-7-git-send-email-dp@opensource.wolfsonmicro.com>
In-Reply-To: <1316439245-26221-7-git-send-email-dp@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2011 03:34 PM, Dimitris Papastamos wrote:
> This patch incorporates the regcache core code into regmap.  All previous
> patches have been no-ops essentially up to this point.
> 
> The bulk read operation is not supported by regcache at the moment.  This
> will be implemented incrementally.
> 
> Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
> Tested-by: Lars-Peter Clausen <lars@metafoo.de>

Hi

Two issues with this version.

> [...]
> @@ -290,6 +302,12 @@ static int _regmap_write(struct regmap *map, unsigned int reg,
>  	int ret;
>  	BUG_ON(!map->format.format_write && !map->format.format_val);
>  
> +	if (!map->cache_bypass) {
> +		ret = regcache_write(map, reg, val);
> +		if (!ret || map->cache_only)
> +			return 0;

The hw write shouldn't be skipped if the cache write is successful. We should
only exit here if cache_only is set.

I also wonder if we should pass the return value of regcache_write on to the
caller if cache_only is set.

Btw. what should happen if both cache_bypass and cache_only are set? Or is that
an invalid configuration?

> +	}
> +
>  	trace_regmap_reg_write(map->dev, reg, val);
>  
>  	if (map->format.format_write) {
> @@ -428,6 +446,14 @@ int regmap_read(struct regmap *map, unsigned int reg, unsigned int *val)
>  
>  	mutex_lock(&map->lock);
>  
> +	if (!map->cache_bypass) {
> +		ret = regcache_read(map, reg, val);
> +		if (!ret) {
> +			mutex_unlock(&map->lock);
> +			return 0;
> +		}
> +	}

This should go into _regmap_read. Otherwise regmap_update_bits will always use
a hw read.

Also if cache_only is set I guess we shouldn't fallback to a hw read.
> +
>  	ret = _regmap_read(map, reg, val);
>  
>  	mutex_unlock(&map->lock);

