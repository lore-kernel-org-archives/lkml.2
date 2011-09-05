Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263Ab1IEJ6X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 05:58:23 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44412 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752086Ab1IEJ6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 05:58:18 -0400
Date: Mon, 5 Sep 2011 10:58:16 +0100
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Graeme Gregory <gg@slimlogic.co.uk>,
        Samuel Oritz <sameo@linux.intel.com>
Subject: Re: [PATCH 3/8] regmap: Add the rbtree cache support
Message-ID: <20110905095816.GD30114@opensource.wolfsonmicro.com>
References: <1314978375-11539-1-git-send-email-dp@opensource.wolfsonmicro.com> <1314978375-11539-4-git-send-email-dp@opensource.wolfsonmicro.com> <4E613B22.7000908@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E613B22.7000908@metafoo.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 02, 2011 at 10:22:58PM +0200, Lars-Peter Clausen wrote:
> On 09/02/2011 05:46 PM, Dimitris Papastamos wrote:
> > This patch adds support for the rbtree cache compression type.
> > 
> > Each rbnode manages a variable length block of registers.  There can be no
> > two nodes with overlapping blocks.  Each block has a base register and a
> > currently top register, all the other registers, if any, lie in between these
> > two and in ascending order.
> > 
> > The reasoning behind the construction of this rbtree is simple.  In the
> > snd_soc_rbtree_cache_init() function, we iterate over the register defaults
> > provided by the regcache core.  For each register value that is non-zero we
> > insert it in the rbtree.  In order to determine in which rbnode we need
> > to add the register, we first look if there is another register already
> > added that is adjacent to the one we are about to add.  If that is the case
> > we append it in that rbnode block, otherwise we create a new rbnode
> > with a single register in its block and add it to the tree.
> > 
> > There are various optimizations across the implementation to speed up lookups
> > by caching the most recently used rbnode.
> > 
> > Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
> > [...]
> > +
> > +static int regcache_rbtree_init(struct regmap *map)
> > +{
> > +	struct regcache_rbtree_ctx *rbtree_ctx;
> > +	int i;
> > +	int ret;
> > +
> > +	map->cache = kmalloc(sizeof *rbtree_ctx, GFP_KERNEL);
> > +	if (!map->cache)
> > +		return -ENOMEM;
> > +
> > +	rbtree_ctx = map->cache;
> > +	rbtree_ctx->root = RB_ROOT;
> > +	rbtree_ctx->cached_rbnode = NULL;
> > +
> > +	if (!map->cache_defaults)
> > +		return 0;
> > +
> > +	for (i = 0; i < map->num_cache_defaults_raw; ++i) {
> > +		ret = regcache_lookup_reg(map, i);
> > +		if (ret < 0)
> > +			continue;
> > +		ret = regcache_rbtree_write(map,
> > +					    map->cache_defaults[ret].reg,
> > +					    map->cache_defaults[ret].def);
> > +		if (ret)
> > +			goto err;
> > +	}
> 
> You can iterate over the caches_defaults elements directly.

Yes.

Thanks,
Dimitris
