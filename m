Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193Ab1IEJnr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 05:43:47 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41010 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752055Ab1IEJnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 05:43:41 -0400
Date: Mon, 5 Sep 2011 10:43:37 +0100
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Graeme Gregory <gg@slimlogic.co.uk>,
        Samuel Oritz <sameo@linux.intel.com>
Subject: Re: [PATCH 1/8] regmap: Introduce caching support
Message-ID: <20110905094337.GA30114@opensource.wolfsonmicro.com>
References: <1314978375-11539-1-git-send-email-dp@opensource.wolfsonmicro.com> <1314978375-11539-2-git-send-email-dp@opensource.wolfsonmicro.com> <4E61363A.9050607@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E61363A.9050607@metafoo.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 02, 2011 at 10:02:02PM +0200, Lars-Peter Clausen wrote:
> On 09/02/2011 05:46 PM, Dimitris Papastamos wrote:
> > This patch introduces caching support for regmap.  The regcache API
> > has evolved essentially out of ASoC soc-cache so most of the actual
> > caching types (except LZO) have been tested in the past.
> > 
> > The purpose of regcache is to optimize in time and space the handling
> > of register caches.  Time optimization is achieved by not having to go
> > over a slow bus like I2C to read the value of a register, instead it is
> > cached locally in memory and can be retrieved faster.  Regarding space
> > optimization, some of the cache types are better at packing the caches,
> > for e.g. the rbtree and the LZO caches.  By doing this the sacrifice in
> > time still wins over doing I2C transactions.
> > 
> > Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
> > ---
> >  drivers/base/regmap/Makefile   |    2 +-
> >  drivers/base/regmap/internal.h |   50 ++++++++
> >  drivers/base/regmap/regcache.c |  251 ++++++++++++++++++++++++++++++++++++++++
> >  include/linux/regmap.h         |   19 +++-
> >  4 files changed, 316 insertions(+), 6 deletions(-)
> >  create mode 100644 drivers/base/regmap/regcache.c
> > 
> > diff --git a/drivers/base/regmap/Makefile b/drivers/base/regmap/Makefile
> > index 057c13f..2e103ea 100644
> > --- a/drivers/base/regmap/Makefile
> > +++ b/drivers/base/regmap/Makefile
> > @@ -1,4 +1,4 @@
> > -obj-$(CONFIG_REGMAP) += regmap.o
> > +obj-$(CONFIG_REGMAP) += regmap.o regcache.o
> >  obj-$(CONFIG_DEBUG_FS) += regmap-debugfs.o
> >  obj-$(CONFIG_REGMAP_I2C) += regmap-i2c.o
> >  obj-$(CONFIG_REGMAP_SPI) += regmap-spi.o
> > diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
> > index 5ab3fef..b7acbeb 100644
> > [...]
> > diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
> > new file mode 100644
> > index 0000000..90b7e1f
> > --- /dev/null
> > +++ b/drivers/base/regmap/regcache.c
> > @@ -0,0 +1,251 @@
> > +/*
> > + * Register cache access API
> > + *
> > + * Copyright 2011 Wolfson Microelectronics plc
> > + *
> > + * Author: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + */
> > +
> > +#include <linux/slab.h>
> > +#include <trace/events/regmap.h>
> > +
> > +#include "internal.h"
> > +
> > +static const struct regcache_ops *cache_types[] = {
> > +};
> 
> I wonder if it makes sense to keep a list of regcache_ops this way, or whether
> it is not better to just pass the ops we want to use to regcache_init directly.

Something like the user actually setting the ops pointer to one of the
exported cache operation types, and then having regcache to use just
that directly?

> > +
> > +int regcache_init(struct regmap *map)
> > +{
> > +	int i, j;
> > +	int count;
> > +	unsigned int val;
> > +
> > +	if (map->cache_type == REGCACHE_NONE)
> > +		return 0;
> > +
> > +	for (i = 0; i < ARRAY_SIZE(cache_types); ++i)
> > +		if (cache_types[i]->type == map->cache_type)
> > +			break;
> > +
> > +	if (i == ARRAY_SIZE(cache_types)) {
> > +		dev_err(map->dev, "Could not match compress type: %d\n",
> > +			map->cache_type);
> > +		return -EINVAL;
> > +	}
> > +
> > +	map->cache = NULL;
> > +	map->cache_ops = cache_types[i];
> > +	if (!map->cache_ops->name)
> > +		return -EINVAL;
> > +
> > +	if (!map->cache_defaults_raw || !map->num_cache_defaults_raw) {
> > +		dev_err(map->dev, "Client has not provided a defaults cache\n");
> > +		return -EINVAL;
> > +	}
> 
> It should be OK to provide no default register values, in this case regmap
> should assume that the default for all registers is 0.

I guess I'll just squash the patch that implementes readback from the HW
right into this patch if that's okay.

> > +/**
> > + * regcache_read: Fetch the value of a given register from the cache.
> > + *
> > + * @map: map to configure.
> > + * @reg: The register index.
> > + * @value: The value to be returned.
> > + *
> > + * Return a negative value on failure, 0 on success.
> > + */
> > +int regcache_read(struct regmap *map,
> > +		  unsigned int reg, unsigned int *value)
> > +{
> > +	if (map->cache_type == REGCACHE_NONE)
> > +		return 0;
> > +
> > +	BUG_ON(!map->cache_ops);
> > +
> > +	if (reg < map->num_cache_defaults_raw) {
> maybe use regmap_readable(map, reg)), but at least check against max_register
> and not num_cache_defaults_raw

Ok.

> > +		if (!map->volatile_reg ||
> > +		    (map->volatile_reg && !map->volatile_reg(map->dev, reg))) {
> 
> if (!regmap_volatile(map, reg))

Yes.

> > +			if (value && map->cache_ops->read)
> 
> Will value or cache_ops->read ever be NULL? A register cache that either only
> provides read or write would be pretty useless in my opinion, and we should
> probably check for this at initialization time and not upon each access.

Yes will check at init time.

> > +int regcache_lookup_reg(struct regmap *map, unsigned int reg)
> > +{
> > +	int i;
> unsigned int

Yes.

> >  /**
> >   * Default value for a register.  We use an array of structs rather
> >   * than a simple array as many modern devices have very sparse
> > @@ -50,9 +55,11 @@ struct reg_default {
> >   *                (eg, a clear on read interrupt status register).
> >   *
> >   * @max_register: Optional, specifies the maximum valid register index.
> > - * @reg_defaults: Power on reset values for registers (for use with
> > - *                register cache support).
> > - * @num_reg_defaults: Number of elements in reg_defaults.
> > + *
> > + * @cache_type: The actual cache type.
> > + * @cache_defaults_raw: Power on reset values for registers (for use with
> > + *                 register cache support).
> > + * @num_cache_defaults_raw: Number of elements in cache_defaults_raw.
> >   */
> >  struct regmap_config {
> >  	int reg_bits;
> > @@ -64,8 +71,10 @@ struct regmap_config {
> >  	bool (*precious_reg)(struct device *dev, unsigned int reg);
> >  
> >  	unsigned int max_register;
> > -	struct reg_default *reg_defaults;
> > -	int num_reg_defaults;
> 
> I guess these were removed by accident due to some merge conflict as they were
> added just recently. It would be good if you could re-add them and if they are
> set initialize cache_defaults using a memdup instead of reading cache_defaults_raw.
> 
> > +
> > +	enum regcache_type cache_type;
> > +	const void *cache_defaults_raw;
> > +	unsigned num_cache_defaults_raw;
> >  };
> >  
> >  typedef int (*regmap_hw_write)(struct device *dev, const void *data,

I was merely renaming these.

Thanks,
Dimitris
