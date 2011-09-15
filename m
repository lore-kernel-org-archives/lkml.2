Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934062Ab1IOPcb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 11:32:31 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52921 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934023Ab1IOPca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 11:32:30 -0400
Date: Thu, 15 Sep 2011 16:32:27 +0100
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Graeme Gregory <gg@slimlogic.co.uk>,
        Samuel Oritz <sameo@linux.intel.com>
Subject: Re: [PATCH 1/6 v3] regmap: Introduce caching support
Message-ID: <20110915153227.GA7022@opensource.wolfsonmicro.com>
References: <1316082879-21810-1-git-send-email-dp@opensource.wolfsonmicro.com> <1316082879-21810-2-git-send-email-dp@opensource.wolfsonmicro.com> <4E721595.9040108@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E721595.9040108@metafoo.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 15, 2011 at 05:11:17PM +0200, Lars-Peter Clausen wrote:
> Tested-by: Lars-Peter Clausen <lars@metafoo.de> (for REGCACHE_NONE and
> REGCACHE_RBTREE)
> 
> Some minor comments though:
> 
> > -
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
> > +	unsigned int max_reg;
> > +
> > +	if (map->cache_type == REGCACHE_NONE)
> > +		return -ENOSYS;
> > +
> > +	BUG_ON(!map->cache_ops);
> > +
> > +	if (!regmap_readable(map, reg))
> > +		return -EIO;
> > +
> > +	if (map->max_register)
> > +		max_reg = map->max_register;
> > +	else
> > +		max_reg = map->num_cache_defaults_raw;
> 
> In my opinion we should initialize max_register to num_cache_defaults_raw if it
> is not set during initialization instead of doing this check each time. Also
> regmap_readable already checks whether the register is in the register range,
> so there is no need to repeat the check here.

Yes, that makes sense.

> > +
> > +
> > +	if (reg < max_reg && !regmap_volatile(map, reg))
> > +		return map->cache_ops->read(map, reg, value);
> > +	return -EINVAL;
> > +}
> > +EXPORT_SYMBOL_GPL(regcache_read);
> > +
