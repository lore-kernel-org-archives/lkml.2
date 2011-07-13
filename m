Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965281Ab1GMKmk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 06:42:40 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:18236 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965209Ab1GMKmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 06:42:39 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AowDAHp1HU55LCkBgWdsb2JhbABUpzoVAQEWJiWIesMsDoYsBKM/
Date: Wed, 13 Jul 2011 20:42:36 +1000
From: Dave Chinner <david@fromorbit.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: chris@chris-wilson.co.uk, keithp@keithp.com, linux-kernel@vger.kernel.org,
        airlied@linux.ie, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] i915: slab shrinker have to return -1 if it cant
 shrink any objects
Message-ID: <20110713104236.GS23038@dastard>
References: <4E0444CA.3080407@jp.fujitsu.com>
 <yuny60kt1nx.fsf@aiko.keithp.com>
 <1309424153_44559@CP5-2952>
 <4E1C15B2.9020800@jp.fujitsu.com>
 <d08817$ot4e1@azsmga001.ch.intel.com>
 <4E1CE48C.2070402@jp.fujitsu.com>
 <d08817$pb86v@azsmga001.ch.intel.com>
 <4E1D550A.80301@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E1D550A.80301@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 13, 2011 at 05:19:22PM +0900, KOSAKI Motohiro wrote:
> (2011/07/13 16:41), Chris Wilson wrote:
> >> (snip)
> >>                 while (total_scan >= SHRINK_BATCH) {
> >>                         long this_scan = SHRINK_BATCH;
> >>                         int shrink_ret;
> >>                         int nr_before;
> >>
> >>                         nr_before = do_shrinker_shrink(shrinker, shrink, 0);
> >>                         shrink_ret = do_shrinker_shrink(shrinker, shrink,
> >>                                                         this_scan);
> >>                         if (shrink_ret == -1)
> >>                                 break;
> >>
> > 
> > And fifteen lines above that you have:
> >   unsigned long max_pass = do_shrinker_shrink(shrinker, shrinker, 0);
> >   ...
> >   shrinker->nr += f(max_pass);
> >   if (shrinker->nr < 0) printk(KERN_ERR "...");
> > 
> > That's the *error* I hit when I originally returned -1.
> 
> You misunderstand the code. The third argument is critically important.
> Only if it's 0 (ie sc->nr_to_scan==0), shrinker must not return negative.

And once again the shitty shrinker API bites a user.

> Thus, my patch checked nr_to_scan argument. and I've suggested look at
> shrink_icache_memory().

Which is going away real soon - it's not the model of perfection
that you make it out to be. ;)

> If you are thinking the shrinker protocol is too complicated, doc update
> patch is really welcome.

Slab shrinkers have a nasty, crappy interface and the shrink_slab()
code is full of bugs.  Rather that telling people to "update the
documentation" because it's too complex, how about we fix the
interface and the bugs?

Indeed, how hard is it to require a subsystem to supply two shrinker
methods, one to return the count of reclaimable objects, the other
to scan the reclaimable objects to reclaim them? After all, that's
exactly the interface I'm exposing to filesystems underneath the
shrinker API in the per-sb shrinker patchset that gets rid of
shrink_icache_memory() rather than propagating the insanity....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
