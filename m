Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609Ab1ISQOE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 12:14:04 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45881 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756445Ab1ISQOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 12:14:01 -0400
Date: Mon, 19 Sep 2011 17:13:59 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Graeme Gregory <gg@slimlogic.co.uk>,
        Samuel Oritz <sameo@linux.intel.com>
Subject: Re: [PATCH 6/6 v5] regmap: Incorporate the regcache core into regmap
Message-ID: <20110919161358.GA540@opensource.wolfsonmicro.com>
References: <1316439245-26221-1-git-send-email-dp@opensource.wolfsonmicro.com>
 <1316439245-26221-7-git-send-email-dp@opensource.wolfsonmicro.com>
 <4E77667D.8030404@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E77667D.8030404@metafoo.de>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 19, 2011 at 05:57:49PM +0200, Lars-Peter Clausen wrote:
> On 09/19/2011 03:34 PM, Dimitris Papastamos wrote:

> > +	if (!map->cache_bypass) {
> > +		ret = regcache_write(map, reg, val);
> > +		if (!ret || map->cache_only)
> > +			return 0;

> The hw write shouldn't be skipped if the cache write is successful. We should
> only exit here if cache_only is set.

There's a couple of other issues too.  I've already got the following
patch for this one locally:

--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -304,7 +304,9 @@ static int _regmap_write(struct regmap *map,
unsigned int re
 
        if (!map->cache_bypass) {
                ret = regcache_write(map, reg, val);
-               if (!ret || map->cache_only)
+               if (ret != 0)
+                       return ret;
+               if (map->cache_only)
                        return 0;
        }
 
> I also wonder if we should pass the return value of regcache_write on to the
> caller if cache_only is set.

Yup.

> Btw. what should happen if both cache_bypass and cache_only are set? Or is that
> an invalid configuration?

That's not sensible.  Probably BUG_ON().

> > @@ -428,6 +446,14 @@ int regmap_read(struct regmap *map, unsigned int reg, unsigned int *val)

> >  	mutex_lock(&map->lock);

> > +	if (!map->cache_bypass) {
> > +		ret = regcache_read(map, reg, val);
> > +		if (!ret) {
> > +			mutex_unlock(&map->lock);
> > +			return 0;
> > +		}
> > +	}

> This should go into _regmap_read. Otherwise regmap_update_bits will always use
> a hw read.

Yup, got that too.

> Also if cache_only is set I guess we shouldn't fallback to a hw read.

Probably.  Cache only is *mostly* there for write side stuff, but it'd
be useful to add this.  I've got a patch to do this.
