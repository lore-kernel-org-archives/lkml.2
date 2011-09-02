Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409Ab1IBUX2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 16:23:28 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:43629 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752442Ab1IBUX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 16:23:26 -0400
Message-ID: <4E613B22.7000908@metafoo.de>
Date: Fri, 02 Sep 2011 22:22:58 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110818 Icedove/3.0.11
MIME-Version: 1.0
To: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
CC: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Graeme Gregory <gg@slimlogic.co.uk>,
        Samuel Oritz <sameo@linux.intel.com>
Subject: Re: [PATCH 3/8] regmap: Add the rbtree cache support
References: <1314978375-11539-1-git-send-email-dp@opensource.wolfsonmicro.com> <1314978375-11539-4-git-send-email-dp@opensource.wolfsonmicro.com>
In-Reply-To: <1314978375-11539-4-git-send-email-dp@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2011 05:46 PM, Dimitris Papastamos wrote:
> This patch adds support for the rbtree cache compression type.
> 
> Each rbnode manages a variable length block of registers.  There can be no
> two nodes with overlapping blocks.  Each block has a base register and a
> currently top register, all the other registers, if any, lie in between these
> two and in ascending order.
> 
> The reasoning behind the construction of this rbtree is simple.  In the
> snd_soc_rbtree_cache_init() function, we iterate over the register defaults
> provided by the regcache core.  For each register value that is non-zero we
> insert it in the rbtree.  In order to determine in which rbnode we need
> to add the register, we first look if there is another register already
> added that is adjacent to the one we are about to add.  If that is the case
> we append it in that rbnode block, otherwise we create a new rbnode
> with a single register in its block and add it to the tree.
> 
> There are various optimizations across the implementation to speed up lookups
> by caching the most recently used rbnode.
> 
> Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
> [...]
> +
> +static int regcache_rbtree_init(struct regmap *map)
> +{
> +	struct regcache_rbtree_ctx *rbtree_ctx;
> +	int i;
> +	int ret;
> +
> +	map->cache = kmalloc(sizeof *rbtree_ctx, GFP_KERNEL);
> +	if (!map->cache)
> +		return -ENOMEM;
> +
> +	rbtree_ctx = map->cache;
> +	rbtree_ctx->root = RB_ROOT;
> +	rbtree_ctx->cached_rbnode = NULL;
> +
> +	if (!map->cache_defaults)
> +		return 0;
> +
> +	for (i = 0; i < map->num_cache_defaults_raw; ++i) {
> +		ret = regcache_lookup_reg(map, i);
> +		if (ret < 0)
> +			continue;
> +		ret = regcache_rbtree_write(map,
> +					    map->cache_defaults[ret].reg,
> +					    map->cache_defaults[ret].def);
> +		if (ret)
> +			goto err;
> +	}

You can iterate over the caches_defaults elements directly.

[...]
> diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
> index dfefe40..2b148d4 100644
> --- a/drivers/base/regmap/regcache.c
> +++ b/drivers/base/regmap/regcache.c
> @@ -19,6 +19,9 @@ static const struct regcache_ops *cache_types[] = {
>  #ifdef CONFIG_REGCACHE_INDEXED
>  	&regcache_indexed_ops,
>  #endif
> +#ifdef CONFIG_REGCACHE_RBTREE

This symbol is also not defined. It looks as if all the Kconfig changes are not
included in the patchset.

> +	&regcache_rbtree_ops,
> +#endif
>  };


