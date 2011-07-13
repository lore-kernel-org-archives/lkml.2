Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965023Ab1GMHl3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 03:41:29 -0400
Received: from mga14.intel.com ([143.182.124.37]:33305 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752643Ab1GMHl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 03:41:28 -0400
Message-Id: <d08817$pb86v@azsmga001.ch.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,523,1304319600"; 
   d="scan'208";a="26583263"
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH] i915: slab shrinker have to return -1 if it cant shrink any objects
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: keithp@keithp.com, linux-kernel@vger.kernel.org, airlied@linux.ie,
        dri-devel@lists.freedesktop.org
In-Reply-To: <4E1CE48C.2070402@jp.fujitsu.com>
References: <4E0444CA.3080407@jp.fujitsu.com> <yuny60kt1nx.fsf@aiko.keithp.com> <1309424153_44559@CP5-2952> <4E1C15B2.9020800@jp.fujitsu.com> <d08817$ot4e1@azsmga001.ch.intel.com> <4E1CE48C.2070402@jp.fujitsu.com>
Date: Wed, 13 Jul 2011 08:41:24 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jul 2011 09:19:24 +0900, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> (2011/07/12 19:06), Chris Wilson wrote:
> > On Tue, 12 Jul 2011 18:36:50 +0900, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> >> Hi,
> >>
> >> sorry for the delay.
> >>
> >>> On Wed, 29 Jun 2011 20:53:54 -0700, Keith Packard <keithp@keithp.com> wrote:
> >>>> On Fri, 24 Jun 2011 17:03:22 +0900, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> The matter is not in contention. The problem is happen if the mutex is taken
> by shrink_slab calling thread. i915_gem_inactive_shrink() have no way to shink
> objects. How do you detect such case?

In the primary allocator for the backing pages whilst the mutex is held we
do __NORETRY and a manual shrinkage of our buffers before failing. That's
the largest allocator, all the others are tiny and short-lived by
comparison and left to fail.

For a second process to hit shrink_slab whilst the driver is blocked on
the GPU, that is... unfortunate. Dropping that lock across that wait is
achievable, just very complicated.

> > No, just pointing out that the patch causes warnings from the shrinker
> > code as it tries to process (unsigned long)-1 objects. shrink_slab() does
> > not use <0 as an error code!
> 
> Look.
> 
> unsigned long shrink_slab(struct shrink_control *shrink,
>                           unsigned long nr_pages_scanned,
>                           unsigned long lru_pages)
> {
> (snip)
>                 while (total_scan >= SHRINK_BATCH) {
>                         long this_scan = SHRINK_BATCH;
>                         int shrink_ret;
>                         int nr_before;
> 
>                         nr_before = do_shrinker_shrink(shrinker, shrink, 0);
>                         shrink_ret = do_shrinker_shrink(shrinker, shrink,
>                                                         this_scan);
>                         if (shrink_ret == -1)
>                                 break;
> 

And fifteen lines above that you have:
  unsigned long max_pass = do_shrinker_shrink(shrinker, shrinker, 0);
  ...
  shrinker->nr += f(max_pass);
  if (shrinker->nr < 0) printk(KERN_ERR "...");

That's the *error* I hit when I originally returned -1.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
