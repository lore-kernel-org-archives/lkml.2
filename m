Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751564Ab1IBXse (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 19:48:34 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44854 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751062Ab1IBXsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 19:48:31 -0400
Date: Sat, 3 Sep 2011 00:48:27 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Graeme Gregory <gg@slimlogic.co.uk>,
        Samuel Oritz <sameo@linux.intel.com>
Subject: Re: [PATCH 1/8] regmap: Introduce caching support
Message-ID: <20110902234827.GA31813@opensource.wolfsonmicro.com>
References: <1314978375-11539-1-git-send-email-dp@opensource.wolfsonmicro.com>
 <1314978375-11539-2-git-send-email-dp@opensource.wolfsonmicro.com>
 <4E61363A.9050607@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E61363A.9050607@metafoo.de>
X-Cookie: Just to have it is enough.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 02, 2011 at 10:02:02PM +0200, Lars-Peter Clausen wrote:
> On 09/02/2011 05:46 PM, Dimitris Papastamos wrote:

> > +static const struct regcache_ops *cache_types[] = {
> > +};

> I wonder if it makes sense to keep a list of regcache_ops this way, or whether
> it is not better to just pass the ops we want to use to regcache_init directly.

Or have a function per cache type.  I'm keen to hide the ops from users
because I don't want to have to worry about them peering inside the
internals.

> > +	if (!map->cache_defaults_raw || !map->num_cache_defaults_raw) {
> > +		dev_err(map->dev, "Client has not provided a defaults cache\n");
> > +		return -EINVAL;
> > +	}

> It should be OK to provide no default register values, in this case regmap
> should assume that the default for all registers is 0.

Yes - Dimitris, as we discussed offline it's pretty much essential for
things like PMICs where the defaults aren't meaningful and may even be
unknowable.

> > +			if (value && map->cache_ops->read)

> Will value or cache_ops->read ever be NULL? A register cache that either only
> provides read or write would be pretty useless in my opinion, and we should
> probably check for this at initialization time and not upon each access.

I agree that it's safe to assume read() if you've got cache_ops.  I
think in the case where we don't cache we should be able to come up with
a suitable noop cache type which we can assign as the ops so like you
say we can just assume a read() op.
