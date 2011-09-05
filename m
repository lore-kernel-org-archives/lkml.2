Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159Ab1IEJz0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 05:55:26 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53768 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751980Ab1IEJzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 05:55:23 -0400
Date: Mon, 5 Sep 2011 10:55:19 +0100
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Graeme Gregory <gg@slimlogic.co.uk>,
        Samuel Oritz <sameo@linux.intel.com>
Subject: Re: [PATCH 2/8] regmap: Add the indexed cache support
Message-ID: <20110905095519.GC30114@opensource.wolfsonmicro.com>
References: <1314978375-11539-1-git-send-email-dp@opensource.wolfsonmicro.com> <1314978375-11539-3-git-send-email-dp@opensource.wolfsonmicro.com> <4E613986.4040007@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E613986.4040007@metafoo.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 02, 2011 at 10:16:06PM +0200, Lars-Peter Clausen wrote:
> On 09/02/2011 05:46 PM, Dimitris Papastamos wrote:
> > This is the simplest form of a cache available in regcache.  Any
> > registers whose default value is 0 are ignored.  If any of those
> > registers are modified in the future, they will be placed in the
> > cache on demand.  The cache layout is essentially using the provided
> > register defaults by the regcache core directly and does not re-map
> > it to another representation.
> > 
> > Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
> 
> I wonder if we really still need indexed caches, because ...
> 
> 
> > ---
> >  drivers/base/regmap/Makefile           |    2 +-
> >  drivers/base/regmap/internal.h         |    1 +
> >  drivers/base/regmap/regcache-indexed.c |   65 ++++++++++++++++++++++++++++++++
> >  drivers/base/regmap/regcache.c         |    3 +
> >  include/linux/regmap.h                 |    1 +
> >  5 files changed, 71 insertions(+), 1 deletions(-)
> >  create mode 100644 drivers/base/regmap/regcache-indexed.c
> > 
> > [...]
> > +static int regcache_indexed_read(struct regmap *map, unsigned int reg,
> > +				 unsigned int *value)
> > +{
> > +	int ret;
> > +
> > +	ret = regcache_lookup_reg(map, reg);
> 
> ... this lookup will be slower than an rbtree lookup. And given that we use two
> integers per register doesn't give it much size advantage either.

The indexed cache grew out of the flat cache somehow.  Do you think the
flat cache would be more appropriate than the indexed cache?  One thing
with the flat cache is that we need to make a flat copy of the
cache_defaults (either partial or full).  With the indexed cache we can
use the cache_defaults directly.

I've got a patch that changes the regcache_lookup_reg() to actually use binary
search.  The array is kept sorted after insertions and since insertions
are less common than readbacks it should improve things a bit.

> I have some patches for the rbtree register cache code, which reduce some of
> it's complexity and also implements the adjacent node merging and allows
> smaller holes in the rbnodes register block if the block is smaller then an
> rbnode. Currently these patches are based on the ASoC register cache code, but
> they should be easy to rework onto of the regmap register cache code.
> 
> I did some small statistics on the number of rbnodes without and with the
> patches applied:
> 
> Without patches:
> Nodes:
>   0: 4000-4000   1
>   1: 4009-400a   2
>   2: 400b-400c   2
>   3: 400d-4010   4
>   4: 4015-4015   1
>   5: 4017-4017   1
>   6: 4019-401b   3
>   7: 401c-401d   2
>   8: 401e-4020   3
>   9: 4021-4022   2
>  10: 4023-4026   4
>  11: 4029-402a   2
>  12: 4031-4031   1
>  13: 4036-4036   1
>  14: 40eb-40eb   1
>  15: 40f2-40f3   2
>  16: 40f8-40f9   2
>  17: 40fa-40fa   1
> 
> Number of nodes: 18 (504 bytes)
> Number of registers: 35 (35 bytes)
> Total size: 539 bytes
> 
> With patches:
> Nodes:
>   0: 4000-4036  55
>   1: 40eb-40fa  16
> 
> Number of nodes: 2 (56 bytes)
> Number of registers: 71 (71 bytes)
> Total size: 127 bytes
> 
> In comparison a ASoC flat cache for this driver would have used 250 bytes and
> and regmap indexed cache would use 280 bytes. (Not that it really matters at
> those sizes anyway)

Awesome!!  You could mail me those patches and I'll re-work them to
apply them on top of regcache.

> > +	if (ret < 0)
> > +		*value = 0;
> > +	else
> > +		*value = map->cache_defaults[ret].def;
> > +	return 0;
> > +}
> > +
> > [...]
> > diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
> > index 90b7e1f..dfefe40 100644
> > --- a/drivers/base/regmap/regcache.c
> > +++ b/drivers/base/regmap/regcache.c
> > @@ -16,6 +16,9 @@
> >  #include "internal.h"
> >  
> >  static const struct regcache_ops *cache_types[] = {
> > +#ifdef CONFIG_REGCACHE_INDEXED
> 
> This symbol doesn't seem to be defined anywhere.

Yes I need to remove all of these.

Thanks,
Dimitris
