Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758519Ab2BJMAM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 07:00:12 -0500
Received: from smtp-out-160.synserver.de ([212.40.185.160]:1037 "EHLO
	smtp-out-156.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754750Ab2BJMAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 07:00:10 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 11921
Message-ID: <4F350716.9050407@metafoo.de>
Date: Fri, 10 Feb 2012 13:01:26 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111114 Iceowl/1.0b2 Icedove/3.1.16
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: broonie@opensource.wolfsonmicro.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH V1] regmap: Support for caching in reg_raw_write()
References: <1328873572-12603-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1328873572-12603-1-git-send-email-ldewangan@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/2012 12:32 PM, Laxman Dewangan wrote:
> Adding support for caching of data into the
> non-volatile register from the call of reg_raw_write().
> 
> This will allow the larger block of data write into multiple
> register without worrying whether register is cached or not
> through reg_raw_write().
> 

In my opinion it makes more sense to introduce a regmap_bulk_write function
for this. regmap_raw_write was not really meant to write registers but
rather binary blobs, like firmware. Also this keeps things consistent with
the read part of the regmap API.

> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
>  drivers/base/regmap/regmap.c |   25 ++++++++++++++++++++-----
>  1 files changed, 20 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
> index 80129c0..e5986ab 100644
> --- a/drivers/base/regmap/regmap.c
> +++ b/drivers/base/regmap/regmap.c
> @@ -323,6 +323,25 @@ static int _regmap_raw_write(struct regmap *map, unsigned int reg,
>  			if (!map->writeable_reg(map->dev, reg + i))
>  				return -EINVAL;
>  
> +	if (!map->cache_bypass && map->format.parse_val) {
> +		int val_bytes = map->format.val_bytes;
> +		unsigned int ival;
> +		for (i = 0; i < val_len / map->format.val_bytes; i++) {
> +			memcpy(map->work_buf, val + (i * val_bytes), val_bytes);
> +			ival = map->format.parse_val(map->work_buf);
> +			ret = regcache_write(map, reg + i, ival);
> +			if (ret) {
> +				dev_warn(map->dev,
> +					"Error in caching of register\n");
> +				return ret;
> +			}
> +		}
> +		if (map->cache_only) {
> +			map->cache_dirty = true;
> +			return 0;
> +		}
> +	}
> +
>  	map->format.format_reg(map->work_buf, reg);
>  
>  	u8[0] |= map->write_flag_mask;
> @@ -373,7 +392,7 @@ int _regmap_write(struct regmap *map, unsigned int reg,
>  	int ret;
>  	BUG_ON(!map->format.format_write && !map->format.format_val);
>  
> -	if (!map->cache_bypass) {
> +	if (!map->cache_bypass && map->format.format_write) {
>  		ret = regcache_write(map, reg, val);
>  		if (ret != 0)
>  			return ret;
> @@ -450,12 +469,8 @@ EXPORT_SYMBOL_GPL(regmap_write);
>  int regmap_raw_write(struct regmap *map, unsigned int reg,
>  		     const void *val, size_t val_len)
>  {
> -	size_t val_count = val_len / map->format.val_bytes;
>  	int ret;
>  
> -	WARN_ON(!regmap_volatile_range(map, reg, val_count) &&
> -		map->cache_type != REGCACHE_NONE);
> -
>  	mutex_lock(&map->lock);
>  
>  	ret = _regmap_raw_write(map, reg, val, val_len);

