Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573Ab1IBUQx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 16:16:53 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:43326 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755393Ab1IBUQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 16:16:51 -0400
Message-ID: <4E613986.4040007@metafoo.de>
Date: Fri, 02 Sep 2011 22:16:06 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110818 Icedove/3.0.11
MIME-Version: 1.0
To: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
CC: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Graeme Gregory <gg@slimlogic.co.uk>,
        Samuel Oritz <sameo@linux.intel.com>
Subject: Re: [PATCH 2/8] regmap: Add the indexed cache support
References: <1314978375-11539-1-git-send-email-dp@opensource.wolfsonmicro.com> <1314978375-11539-3-git-send-email-dp@opensource.wolfsonmicro.com>
In-Reply-To: <1314978375-11539-3-git-send-email-dp@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2011 05:46 PM, Dimitris Papastamos wrote:
> This is the simplest form of a cache available in regcache.  Any
> registers whose default value is 0 are ignored.  If any of those
> registers are modified in the future, they will be placed in the
> cache on demand.  The cache layout is essentially using the provided
> register defaults by the regcache core directly and does not re-map
> it to another representation.
> 
> Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>

I wonder if we really still need indexed caches, because ...


> ---
>  drivers/base/regmap/Makefile           |    2 +-
>  drivers/base/regmap/internal.h         |    1 +
>  drivers/base/regmap/regcache-indexed.c |   65 ++++++++++++++++++++++++++++++++
>  drivers/base/regmap/regcache.c         |    3 +
>  include/linux/regmap.h                 |    1 +
>  5 files changed, 71 insertions(+), 1 deletions(-)
>  create mode 100644 drivers/base/regmap/regcache-indexed.c
> 
> [...]
> +static int regcache_indexed_read(struct regmap *map, unsigned int reg,
> +				 unsigned int *value)
> +{
> +	int ret;
> +
> +	ret = regcache_lookup_reg(map, reg);

... this lookup will be slower than an rbtree lookup. And given that we use two
integers per register doesn't give it much size advantage either.

I have some patches for the rbtree register cache code, which reduce some of
it's complexity and also implements the adjacent node merging and allows
smaller holes in the rbnodes register block if the block is smaller then an
rbnode. Currently these patches are based on the ASoC register cache code, but
they should be easy to rework onto of the regmap register cache code.

I did some small statistics on the number of rbnodes without and with the
patches applied:

Without patches:
Nodes:
  0: 4000-4000   1
  1: 4009-400a   2
  2: 400b-400c   2
  3: 400d-4010   4
  4: 4015-4015   1
  5: 4017-4017   1
  6: 4019-401b   3
  7: 401c-401d   2
  8: 401e-4020   3
  9: 4021-4022   2
 10: 4023-4026   4
 11: 4029-402a   2
 12: 4031-4031   1
 13: 4036-4036   1
 14: 40eb-40eb   1
 15: 40f2-40f3   2
 16: 40f8-40f9   2
 17: 40fa-40fa   1

Number of nodes: 18 (504 bytes)
Number of registers: 35 (35 bytes)
Total size: 539 bytes

With patches:
Nodes:
  0: 4000-4036  55
  1: 40eb-40fa  16

Number of nodes: 2 (56 bytes)
Number of registers: 71 (71 bytes)
Total size: 127 bytes

In comparison a ASoC flat cache for this driver would have used 250 bytes and
and regmap indexed cache would use 280 bytes. (Not that it really matters at
those sizes anyway)


> +	if (ret < 0)
> +		*value = 0;
> +	else
> +		*value = map->cache_defaults[ret].def;
> +	return 0;
> +}
> +
> [...]
> diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
> index 90b7e1f..dfefe40 100644
> --- a/drivers/base/regmap/regcache.c
> +++ b/drivers/base/regmap/regcache.c
> @@ -16,6 +16,9 @@
>  #include "internal.h"
>  
>  static const struct regcache_ops *cache_types[] = {
> +#ifdef CONFIG_REGCACHE_INDEXED

This symbol doesn't seem to be defined anywhere.

> +	&regcache_indexed_ops,
> +#endif
>  };
>  
>  int regcache_init(struct regmap *map)
> diff --git a/include/linux/regmap.h b/include/linux/regmap.h
> index b81e86a..4d1ad09 100644
> --- a/include/linux/regmap.h
> +++ b/include/linux/regmap.h
> @@ -23,6 +23,7 @@ struct spi_device;
>  /* An enum of all the supported cache types */
>  enum regcache_type {
>  	REGCACHE_NONE,
> +	REGCACHE_INDEXED,
>  };
>  
>  /**

