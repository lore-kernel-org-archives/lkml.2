Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739Ab1AKE4i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 23:56:38 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:57523 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044Ab1AKE4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 23:56:30 -0500
Date: Tue, 11 Jan 2011 13:54:23 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Jeremy Kerr <jeremy.kerr@canonical.com>
Cc: linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Uwe Kleine-K??nig <u.kleine-koenig@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>
Subject: Re: Locking in the clk API
Message-ID: <20110111045423.GP3760@linux-sh.org>
References: <201101111016.42819.jeremy.kerr@canonical.com> <20110111031552.GJ3760@linux-sh.org> <201101111211.30172.jeremy.kerr@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201101111211.30172.jeremy.kerr@canonical.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeremy,

On Tue, Jan 11, 2011 at 12:11:29PM +0800, Jeremy Kerr wrote:
> > This looks like a complete disaster, and is also completely inconsistent
> > with how the API is being used by the vast majority of users today.
> 
> I've been basing this on the mxc clock code, which acquires a mutex for all 
> clk_enable()s. This may not be representative of the majority of clock usage.
> 
> From a quick search there are a few other cases of non-atomic clock usage:
> 
> tcc:		clk_enable() acquires a global clocks_mutex
> tegra:	has a clk_enable_cansleep()
> davinci: clk_set_parent() aquires a global clocks_mutex
> 
> Excluding the davinci code (we won't worry about set_parent for now...), if we 
> can port mxc and tcc to a sleepable clk_enable, perhaps we could just go with 
> purely atomic operations.
> 
> We'd still need some method of using sleeping clocks though. How about making 
> clk_enable() BUG if the clock is not atomic, and add clk_enable_cansleep() for 
> the cases where clk->ops.enable may sleep.
> 
Yes, that sounds reasonable. I don't particularly care for the atomic
flag on the clock however since that's really the default behaviour for
almost everyone at the moment. On the other hand, the mutex API will
already blow up if someone tries to grab it within atomic context (with
the _trylock exception). Still, making the API explicit and tossing in a
might_sleep() or so will at least help figure out which assumptions are
being made and/or violated.

> Do we need something similar for other parts of the API? (clk_set_rate?)
> 
I suppose that's an inevitable thing at least in terms of keeping the API
balanced and consistent.

One other thing to be aware of is that the clkdev code maintains its own
list mutex, so the addition and deletion of clkdev lookups in addition to
the clkdev-backed clk_get() will all be sleepable. It would however be
possible to back a one-shot atomic-safe clk_get() with a mutex_trylock()
for the common cases, but it's not entirely obvious that it would be
worth the complexity it would introduce.

If you're going to do this work it would also be helpful to spell out the
locking semantics within linux/clk.h at the same time (it might even be
worthwhile doing this incrementally and getting all of the platforms
in-line before attempting to consolidate things too aggressively), as
it's apparent from the cases you cite there are at least a couple of
boards that aren't quite in line with what everyone else is doing.

In general we have to accept that the dynamic creation, deletion, and
looking up of clocks is going to be a sleepable case, and the rest will
likely have to be split out in to _cansleep and default atomic-safe
variants.

set_rate/parent and friends likewise are done atomically for some and
sleepable for others, so it doesn't seem like there's going to be much
choice other than simply splitting out the API for these cases.

Also, I'm not sure if you've noticed yet or not, but note that there is
now a drivers/clk due to the shuffling of the clkdev code, so you may
want to piggyback on top of this instead of using the top-level kernel/
