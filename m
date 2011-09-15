Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934074Ab1IOPhV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 11:37:21 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48553 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933872Ab1IOPhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 11:37:20 -0400
Date: Thu, 15 Sep 2011 16:37:18 +0100
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Graeme Gregory <gg@slimlogic.co.uk>,
        Samuel Oritz <sameo@linux.intel.com>
Subject: Re: [PATCH 6/6 v3] regmap: Incorporate the regcache core into
	regmap
Message-ID: <20110915153718.GB7022@opensource.wolfsonmicro.com>
References: <1316082879-21810-1-git-send-email-dp@opensource.wolfsonmicro.com> <1316082879-21810-7-git-send-email-dp@opensource.wolfsonmicro.com> <4E721784.90302@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E721784.90302@metafoo.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 15, 2011 at 05:19:32PM +0200, Lars-Peter Clausen wrote:
> > [...]
> > @@ -321,6 +333,18 @@ int regmap_write(struct regmap *map, unsigned int reg, unsigned int val)
> >  
> >  	mutex_lock(&map->lock);
> >  
> > +	if (!map->cache_bypass) {
> > +		ret = regcache_write(map, reg, val);
> > +		if (ret < 0) {
> > +			mutex_unlock(&map->lock);
> > +			return ret;
> > +		}
> > +		if (map->cache_only) {
> > +			mutex_unlock(&map->lock);
> > +			return 0;
> > +		}
> > +	}
> > +
> 
> Would it make sense to move this into _regmap_write ? In that case the code
> wouldn't have to be duplicated in regmap_update_bits and as a bonus it wouldn't
> have to deal with the mutex either.

Hmm, yes from the point of view of simplifying and avoiding code
duplication.

> >  	ret = _regmap_write(map, reg, val);
> >  
> >  	mutex_unlock(&map->lock);
> > @@ -422,6 +446,14 @@ int regmap_read(struct regmap *map, unsigned int reg, unsigned int *val)
> >  
> >  	mutex_lock(&map->lock);
> >  
> > +	if (!map->cache_bypass) {
> > +		ret = regcache_read(map, reg, val);
> > +		if (!ret) {
> > +			mutex_unlock(&map->lock);
> > +			return 0;
> > +		}
> 
> So in case regmap_readable is not true for this register regcache_read will
> return -EIO and we'll fallback to an uncached read. This doesn't make sense in
> my opinion. Or what are the except semantics regmap_readable supposed to be?

I agree the semantics are fuzzy here.

At the moment, we basically have one means of signaling that the cache
can't handle the read request, that is, by returning an error.  We
should probably extend that or simply use fixed error codes with a
specially meaning or something similar.  I guess there is a more
elegant means of doing this though.

> > +	}
> > +
> >  	ret = _regmap_read(map, reg, val);
> >  
> >  	mutex_unlock(&map->lock);
> 
