Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786Ab2JBIDM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 04:03:12 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:56660 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462Ab2JBIC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 04:02:56 -0400
Date: Tue, 2 Oct 2012 10:03:41 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Thomas Hellstrom <thellstrom@vmware.com>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, sumit.semwal@linaro.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 1/5] dma-buf: remove fallback for
 !CONFIG_DMA_SHARED_BUFFER
Message-ID: <20121002080341.GA5679@phenom.ffwll.local>
Mail-Followup-To: Thomas Hellstrom <thellstrom@vmware.com>,
	Maarten Lankhorst <maarten.lankhorst@canonical.com>,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, sumit.semwal@linaro.org,
	linux-media@vger.kernel.org
References: <20120928124148.14366.21063.stgit@patser.local>
 <5065B0C9.7040209@canonical.com>
 <5065FDAA.5080103@vmware.com>
 <50696699.7020009@canonical.com>
 <506A8DC8.5020706@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <506A8DC8.5020706@vmware.com>
X-Operating-System: Linux phenom 3.4.0-rc3+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2012 at 08:46:32AM +0200, Thomas Hellstrom wrote:
> On 10/01/2012 11:47 AM, Maarten Lankhorst wrote:
> >I was doing a evil hack where I 'released' lru_lock to lockdep before doing the annotation
> >for a blocking acquire, and left trylock annotations as they were. This made lockdep do the
> >right thing.
> I've never looked into how lockdep works. Is this something that can
> be done permanently or just for testing
> purposes? Although not related to this, is it possible to do
> something similar to the trylock reversal in the
> fault() code where mmap_sem() and reserve() change order using a
> reserve trylock?

lockdep just requires a bunch of annotations, is a compile-time configure
option CONFIG_PROVE_LOCKING and if disabled, has zero overhead. And it's
rather awesome in detected deadlocks and handling crazy locking schemes
correctly:
- correctly handles trylocks
- correctly handles nested locking (i.e. grabbing a global lock, then
  grabbing subordinate locks in an unordered sequence since the global
  lock ensures that no deadlocks can happen).
- any kinds of inversions with special contexts like hardirq, softirq
- same for page-reclaim, i.e. it will yell if you could (potentially)
  deadlock because your shrinker grabs a lock that you hold while calling
  kmalloc.
- there are special annotates for various subsystems, e.g. to check for
  del_timer_sync vs. locks held by that timer. Or the console_lock
  annotations I've just recently submitted.
- all that with a really flexible set of annotation primitives that afaics
  should work for almost any insane locking scheme. The fact that Maarten
  could come up with proper reservation annotations without any changes to
  lockdep testifies this (he only had to fix a tiny thing to make it a bit
  more strict in a corner case).

In short I think it's made of awesome. The only downside is that it lacks
documentation, you have to read the code to understand it :(

The reason I've suggested to Maarten to abolish the trylock_reservation
within the lru_lock is that in that way lockdep only ever sees the
trylock, and hence is less strict about complainig about deadlocks. But
semantically it's an unconditional reserve. Maarten had some horrible
hacks that leaked the lockdep annotations out of the new reservation code,
which allowed ttm to be properly annotated.  But those also reduced the
usefulness for any other users of the reservation code, and so Maarten
looked into whether he could remove that trylock dance in ttm.

Imo having excellent lockdep support for cross-device reservations is a
requirment, and ending up with less strict annotations for either ttm
based drivers or other drivers is not good. And imo the ugly layering that
Maarten had in his first proof-of-concept also indicates that something is
amiss in the design.

[I'll refrain from comment on ttm specifics to not make a fool of me ;-)]

> >>And this is even before it starts to get interesting, like how you guarantee that when you release a buffer from
> >>the delayed delete list, you're the only process having a reference?
> >l thought list_kref made sure of that? Even if not the only one with a reference, the list_empty check would
> >make sure it would only run once. I'l fix it up again so it doesn't become a WARN_ON_ONCE, I didn't know
> >it could run multiple times at the time, so I'll change it back to unlikely.
> Yes, you've probably right. A case we've seen earlier (before the
> atomicity was introduced) was one or more threads
> picked up a bo from the LRU list and prepared to reserve it, while
> the delayed delete function removed them from the
> ddestroy list. Then the first thread queued an accelerated eviction,
> adding a new fence and the bo was left hanging.
> I don't think that can happen with the reserve trylocks within the
> lru spinlock, though.
> 
> >
> >>Now, it's probably possible to achieve what you're trying to do, if we accept the lock reversal in
> >>[1], but since I have newborn twins and I have about one hour of spare time a week with I now spent on this
> >>review and I guess there are countless more hours before this can work. (These code paths were never tested, right?)
> >>One of the biggest TTM reworks was to introduce the atomicity assumption and remove a lot of code that was
> >>prone to deadlocks, races and buffer leaks. I'm not prepared to revert that work without an extremely
> >>good reason, and "It can be done" is not such a reason.
> >Deepest apologies, I only did a quick glance at the code part of this email, overlooked this part since
> >I was swamped with other things and meant to do a full reply on monday. I didn't mean to make it sound
> >like I only cared blindly about merging my code, just wanted to find a good solution.
> >>We *need* to carefully weigh it against any benefits you have in your work, and you need to test these codepaths
> >>in parallell cases subject to heavy aperture / vram thrashing and frequent signals causing interrupted waits.
> >Agreed, is there already a tester for this or should I write my own?
> Although I think it would be nice to have a highly parallel execbuf
> implementation on an extremely simple software GPU,
> what I typically do is to take an existing driver (none of them
> implements parallel reserve yet, but vmware is about to soon)
> 
> a) Use an application that frequently recycles buffers, so that the
> delayed-delete code gets busy (Perhaps google-earth, panning over a
> landscape not too high above the earth)
> b) Hack the drivers aperture / vram sizes to something small, so
> that you can see that the eviction code gets hit.
> c) Adjust the memory limits in TTM sysfs memory accounting (You can
> write and change on the fly), so that you can see that the swapping
> code gets hit.
> d) Code a signal delivery so that every 20th time or so the eviction
> code is about to wait, it receives an -ERESTARTSYS with a harmless
> signal.
> e) start another instance of google-earth.

tbh, this should be a simple testsuite that you can just run. Like we're
(slowly) building up for drm/i915 in intel-gpu-tools. At least that'll be
one of the merge requirements for i915.ko.

Cheers, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
