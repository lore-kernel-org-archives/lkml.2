Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935310Ab1IOW5b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 18:57:31 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45442 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S935301Ab1IOW5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 18:57:09 -0400
Date: Thu, 15 Sep 2011 23:57:05 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Graeme Gregory <gg@slimlogic.co.uk>,
        Samuel Oritz <sameo@linux.intel.com>
Subject: Re: [PATCH 6/6 v3] regmap: Incorporate the regcache core into regmap
Message-ID: <20110915225703.GC3218@opensource.wolfsonmicro.com>
References: <1316082879-21810-1-git-send-email-dp@opensource.wolfsonmicro.com>
 <1316082879-21810-7-git-send-email-dp@opensource.wolfsonmicro.com>
 <4E721784.90302@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E721784.90302@metafoo.de>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 15, 2011 at 05:19:32PM +0200, Lars-Peter Clausen wrote:

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

> Would it make sense to move this into _regmap_write ? In that case the code
> wouldn't have to be duplicated in regmap_update_bits and as a bonus it wouldn't
> have to deal with the mutex either.

That does seem sensible, yes.

> > +	if (!map->cache_bypass) {
> > +		ret = regcache_read(map, reg, val);
> > +		if (!ret) {
> > +			mutex_unlock(&map->lock);
> > +			return 0;
> > +		}

> So in case regmap_readable is not true for this register regcache_read will
> return -EIO and we'll fallback to an uncached read. This doesn't make sense in
> my opinion. Or what are the except semantics regmap_readable supposed to be?

It's a bit interesting but falling back to asking the hardware is
probably the right thing to do for cases where you're doing things like
using unspecified registers to activate undocumented features - the
register isn't really documented as being there and may do odd things
but if the device manufacturer gives you an approved sequence then you
can probably use it safely.
