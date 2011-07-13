Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965102Ab1GMIkg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 04:40:36 -0400
Received: from mga02.intel.com ([134.134.136.20]:5933 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965029Ab1GMIkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 04:40:35 -0400
Message-Id: <aefc95$pr944@orsmga001.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,524,1304319600"; 
   d="scan'208";a="27108484"
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH] i915: slab shrinker have to return -1 if it cant shrink any objects
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: keithp@keithp.com, linux-kernel@vger.kernel.org, airlied@linux.ie,
        dri-devel@lists.freedesktop.org
In-Reply-To: <4E1D550A.80301@jp.fujitsu.com>
References: <4E0444CA.3080407@jp.fujitsu.com> <yuny60kt1nx.fsf@aiko.keithp.com> <1309424153_44559@CP5-2952> <4E1C15B2.9020800@jp.fujitsu.com> <d08817$ot4e1@azsmga001.ch.intel.com> <4E1CE48C.2070402@jp.fujitsu.com> <d08817$pb86v@azsmga001.ch.intel.com> <4E1D550A.80301@jp.fujitsu.com>
Date: Wed, 13 Jul 2011 09:40:31 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jul 2011 17:19:22 +0900, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> (2011/07/13 16:41), Chris Wilson wrote:
> > On Wed, 13 Jul 2011 09:19:24 +0900, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> >> (2011/07/12 19:06), Chris Wilson wrote:
> >>> On Tue, 12 Jul 2011 18:36:50 +0900, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> >>>> Hi,
> >>>>
> >>>> sorry for the delay.
> >>>>
> >>>>> On Wed, 29 Jun 2011 20:53:54 -0700, Keith Packard <keithp@keithp.com> wrote:
> >>>>>> On Fri, 24 Jun 2011 17:03:22 +0900, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> >> The matter is not in contention. The problem is happen if the mutex is taken
> >> by shrink_slab calling thread. i915_gem_inactive_shrink() have no way to shink
> >> objects. How do you detect such case?
> > 
> > In the primary allocator for the backing pages whilst the mutex is held we
> > do __NORETRY and a manual shrinkage of our buffers before failing. That's
> > the largest allocator, all the others are tiny and short-lived by
> > comparison and left to fail.
> 
> __NORETRY perhaps might help to avoid false positive oom. But, __NORETRY still makes
> full page reclaim and may drop a lot of innocent page cache, and then system may
> become slow down.

But in this context, that is memory the user has requested to be used with
the GPU, so the page cache is sacrificed to meet the allocation, if
possible.
 
> Of course, you don't meet such worst case scenario so easy. But you may need to
> think worst case if you touch memory management code.

Actually we'd much rather you took us into account when designing the mm.

> > That's the *error* I hit when I originally returned -1.
> 
> You misunderstand the code. The third argument is critically important.
> Only if it's 0 (ie sc->nr_to_scan==0), shrinker must not return negative.
> Thus, my patch checked nr_to_scan argument. and I've suggested look at
> shrink_icache_memory().

Ok.
 
> If you are thinking the shrinker protocol is too complicated, doc update
> patch is really welcome.

What I don't understand is the disconnect between objects to shrink and
the number of pages released. We may have tens of thousands of single page
objects that are expensive to free in comparison to a few 10-100MiB
objects that are just sitting idle. Would it be better to report the
estimated number of shrinkable pages instead?
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
