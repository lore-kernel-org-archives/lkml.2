Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400Ab1IEKOo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 06:14:44 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:41904 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752332Ab1IEKOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 06:14:37 -0400
Message-ID: <4E64A102.4060902@metafoo.de>
Date: Mon, 05 Sep 2011 12:14:26 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110818 Icedove/3.0.11
MIME-Version: 1.0
To: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
CC: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Graeme Gregory <gg@slimlogic.co.uk>,
        Samuel Oritz <sameo@linux.intel.com>
Subject: Re: [PATCH 2/8] regmap: Add the indexed cache support
References: <1314978375-11539-1-git-send-email-dp@opensource.wolfsonmicro.com> <1314978375-11539-3-git-send-email-dp@opensource.wolfsonmicro.com> <4E613986.4040007@metafoo.de> <20110905095519.GC30114@opensource.wolfsonmicro.com>
In-Reply-To: <20110905095519.GC30114@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2011 11:55 AM, Dimitris Papastamos wrote:
> On Fri, Sep 02, 2011 at 10:16:06PM +0200, Lars-Peter Clausen wrote:
>> On 09/02/2011 05:46 PM, Dimitris Papastamos wrote:
>>> This is the simplest form of a cache available in regcache.  Any
>>> registers whose default value is 0 are ignored.  If any of those
>>> registers are modified in the future, they will be placed in the
>>> cache on demand.  The cache layout is essentially using the provided
>>> register defaults by the regcache core directly and does not re-map
>>> it to another representation.
>>>
>>> Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
>>
>> I wonder if we really still need indexed caches, because ...
>>
>>
>>> ---
>>>  drivers/base/regmap/Makefile           |    2 +-
>>>  drivers/base/regmap/internal.h         |    1 +
>>>  drivers/base/regmap/regcache-indexed.c |   65 ++++++++++++++++++++++++++++++++
>>>  drivers/base/regmap/regcache.c         |    3 +
>>>  include/linux/regmap.h                 |    1 +
>>>  5 files changed, 71 insertions(+), 1 deletions(-)
>>>  create mode 100644 drivers/base/regmap/regcache-indexed.c
>>>
>>> [...]
>>> +static int regcache_indexed_read(struct regmap *map, unsigned int reg,
>>> +				 unsigned int *value)
>>> +{
>>> +	int ret;
>>> +
>>> +	ret = regcache_lookup_reg(map, reg);
>>
>> ... this lookup will be slower than an rbtree lookup. And given that we use two
>> integers per register doesn't give it much size advantage either.
> 
> The indexed cache grew out of the flat cache somehow.  Do you think the
> flat cache would be more appropriate than the indexed cache?  One thing
> with the flat cache is that we need to make a flat copy of the
> cache_defaults (either partial or full).  With the indexed cache we can
> use the cache_defaults directly.
> 
> I've got a patch that changes the regcache_lookup_reg() to actually use binary
> search.  The array is kept sorted after insertions and since insertions
> are less common than readbacks it should improve things a bit.
> 

Even with a binary search the lookup will most likely be more expensive then
with an rbtree. Both have an log(n) running time, but the rbtree will most
likely have less nodes than registers, while with the indexed cache we have one
entry per register.

An option would be to switch back to a flat cache, since here the lookup is
basically free. But I don't think it is really worth the maintenance hassle,
the gains are rather marginal. Especially with my patches which add support for
merging adjacent nodes there is almost no overhead compared to the original
ASoC flat cache. You'll end up with one rbnode, so the cached rbnode is always
the one your were looking for and no rbtree lookup is necessary.

In my opinion we should work towards having rbtree as the only cache type, but
with optional lzo compression on the rbtree node blocks.

- Lars
