Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965352Ab1GMLe4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 07:34:56 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:27059 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964915Ab1GMLez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 07:34:55 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AowDAPt/HU55LCkBgWdsb2JhbABUhEaidBUBARYmJYh6slCRAA6BHYIKgXaBDwSjPw
Date: Wed, 13 Jul 2011 21:34:50 +1000
From: Dave Chinner <david@fromorbit.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, keithp@keithp.com,
        linux-kernel@vger.kernel.org, airlied@linux.ie,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] i915: slab shrinker have to return -1 if it cant
 shrink any objects
Message-ID: <20110713113450.GT23038@dastard>
References: <4E0444CA.3080407@jp.fujitsu.com>
 <yuny60kt1nx.fsf@aiko.keithp.com>
 <1309424153_44559@CP5-2952>
 <4E1C15B2.9020800@jp.fujitsu.com>
 <d08817$ot4e1@azsmga001.ch.intel.com>
 <4E1CE48C.2070402@jp.fujitsu.com>
 <d08817$pb86v@azsmga001.ch.intel.com>
 <4E1D550A.80301@jp.fujitsu.com>
 <aefc95$pr944@orsmga001.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aefc95$pr944@orsmga001.jf.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 13, 2011 at 09:40:31AM +0100, Chris Wilson wrote:
> On Wed, 13 Jul 2011 17:19:22 +0900, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> > (2011/07/13 16:41), Chris Wilson wrote:
> > > On Wed, 13 Jul 2011 09:19:24 +0900, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> > >> (2011/07/12 19:06), Chris Wilson wrote:
> > >>> On Tue, 12 Jul 2011 18:36:50 +0900, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> > >>>> Hi,
> > >>>>
> > >>>> sorry for the delay.
> > >>>>
> > >>>>> On Wed, 29 Jun 2011 20:53:54 -0700, Keith Packard <keithp@keithp.com> wrote:
> > >>>>>> On Fri, 24 Jun 2011 17:03:22 +0900, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> > >> The matter is not in contention. The problem is happen if the mutex is taken
> > >> by shrink_slab calling thread. i915_gem_inactive_shrink() have no way to shink
> > >> objects. How do you detect such case?
> > > 
> > > In the primary allocator for the backing pages whilst the mutex is held we
> > > do __NORETRY and a manual shrinkage of our buffers before failing. That's
> > > the largest allocator, all the others are tiny and short-lived by
> > > comparison and left to fail.
> > 
> > __NORETRY perhaps might help to avoid false positive oom. But, __NORETRY still makes
> > full page reclaim and may drop a lot of innocent page cache, and then system may
> > become slow down.
> 
> But in this context, that is memory the user has requested to be used with
> the GPU, so the page cache is sacrificed to meet the allocation, if
> possible.
>  
> > Of course, you don't meet such worst case scenario so easy. But you may need to
> > think worst case if you touch memory management code.
> 
> Actually we'd much rather you took us into account when designing the mm.

Heh. Now where have I heard that before? :/

> > If you are thinking the shrinker protocol is too complicated, doc update
> > patch is really welcome.
> 
> What I don't understand is the disconnect between objects to shrink and
> the number of pages released. We may have tens of thousands of single page
> objects that are expensive to free in comparison to a few 10-100MiB
> objects that are just sitting idle. Would it be better to report the
> estimated number of shrinkable pages instead?

Maybe. Then again, maybe not.

The shrinker API is designed for slab caches which have a fixed
object size, not a variable amount of memory per object, so if you
report the number of shrinkable pages, you can make whatever
decision you want as to the object(s) you free to free up that many
pages.

However, that means that if you have 1000 reclaimable pages, and the
dentry cache has 1000 reclaimable dentries, the same shrinker calls
will free 1000 pages from your cache, but maybe none from the dentry
cache due to slab fragmentation. Hence your cache could end up being
blown to pieces by light memory pressure by telling the shrinker how
many shrinkable pages you have cached. In that case, you want to
report a much smaller number so the cache is harder to reclaim under
light memory pressure, or don't reclaim as much as the shrinker is
asked to reclaim.

This is one of the issues I faced when converting the XFS buffer
cache to use an internal LRU and a shrinker to reclaim buffers that
hold one or more pages.  We used to cache the metadata in the page
cache and let the VM reclaim from there, but that was a crap-shoot
because page reclaim kept trashing the working set of metadata pages
and it was simply not fixable. Hence I changed the lifecycle of
buffers to include a priority based LRU for reclaiming buffer
objects and moved away from using the page cache from holding cached
metadata.

I let the shrinker know how many reclaimable buffers there are, but
it has no idea how much memory each buffer pіns. I don't even keep
track of it because from a performance perspective it is irrelevant;
what matters is maintaining a minimial working set of metadata
buffers under memory pressure.

In most cases the buffers hold only one or two pages, but because of
the reclaim reference count it can take up to 7 attempts to free a
buffer before it is finally reclaimed. Hence the buffer cache tends
to hold onto a critical working set quite well under different
levels of memory pressure because buffers more likely to be reused
are much harder to reclaim than those that are likely to be used ony
once.

As a result, the LRU resists aggressive reclaim to maintain the
necessary working set of buffers quite well.  The working set gets
smaller as memory pressure goes up, but the shrinker is not able to
completely trash the cache like the previous page-cache based
version did.  It's a very specific solution to the problem of tuning
a shrinker for good system behaviour, but it's the only way I found
that works....

Oh, and using a mutex to single thread cache reclaim rather than
spinlocks is usually a good idea from a scalability point of view
because your shrinker can be called simultaneously on every CPU.
Spinlocks really, really hurt when that happens, and performance
will plummet when it happens because you burn CPU on locks rather
than reclaimıng objects. Single threaded object reclaim is still the
fastest way to do reclaim if you have global lists and locks.

What I'm trying to say is that how you solve the shrinker balance
problem for you subsystem will be specific to how you need to hold
pages under memory pressure to maintain performance. Sorry I can't
give you a better answer than that, but that's what my experience
with caches and tuning shrinker behaviour indicates.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
