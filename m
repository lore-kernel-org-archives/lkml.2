Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685Ab1ISQ3F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 12:29:05 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:44917 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752947Ab1ISQ3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 12:29:02 -0400
Message-ID: <4E776DAF.2050204@metafoo.de>
Date: Mon, 19 Sep 2011 18:28:31 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110818 Icedove/3.0.11
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Graeme Gregory <gg@slimlogic.co.uk>,
        Samuel Oritz <sameo@linux.intel.com>
Subject: Re: [PATCH 6/6 v5] regmap: Incorporate the regcache core into regmap
References: <1316439245-26221-1-git-send-email-dp@opensource.wolfsonmicro.com> <1316439245-26221-7-git-send-email-dp@opensource.wolfsonmicro.com> <4E77667D.8030404@metafoo.de> <20110919161358.GA540@opensource.wolfsonmicro.com>
In-Reply-To: <20110919161358.GA540@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2011 06:13 PM, Mark Brown wrote:
> On Mon, Sep 19, 2011 at 05:57:49PM +0200, Lars-Peter Clausen wrote:
>> On 09/19/2011 03:34 PM, Dimitris Papastamos wrote:
> 
>>> +	if (!map->cache_bypass) {
>>> +		ret = regcache_write(map, reg, val);
>>> +		if (!ret || map->cache_only)
>>> +			return 0;
> 
>> The hw write shouldn't be skipped if the cache write is successful. We should
>> only exit here if cache_only is set.
> 
> There's a couple of other issues too.  I've already got the following
> patch for this one locally:
> 
> --- a/drivers/base/regmap/regmap.c
> +++ b/drivers/base/regmap/regmap.c
> @@ -304,7 +304,9 @@ static int _regmap_write(struct regmap *map,
> unsigned int re
>  
>         if (!map->cache_bypass) {
>                 ret = regcache_write(map, reg, val);
> -               if (!ret || map->cache_only)
> +               if (ret != 0)
> +                       return ret;

Hm... last time we said we want to fallback to hw read/write even if the cache
operation has failed. The issue is that regcache_write will check for
regmap_writeable, so you'll get different behaviour if caching is enabled for
registers where regmap_writeable returns false.

> +               if (map->cache_only)
>                         return 0;
>         }
>  
>> I also wonder if we should pass the return value of regcache_write on to the
>> caller if cache_only is set.
> 
> Yup.
> 
>> Btw. what should happen if both cache_bypass and cache_only are set? Or is that
>> an invalid configuration?
> 
> That's not sensible.  Probably BUG_ON().

BUG_ON might be a bit to strict, if we wanted to allow cache_only to be enabled
through debugfs like it is done for ASoC right now.
