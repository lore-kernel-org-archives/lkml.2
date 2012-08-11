Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530Ab2HKTjh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2012 15:39:37 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:44927 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570Ab2HKTjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2012 15:39:35 -0400
Date: Sat, 11 Aug 2012 21:39:54 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: Rob Clark <rob.clark@linaro.org>, linaro-mm-sig@lists.linaro.org,
        linux-media@vger.kernel.org, sumit.semwal@linaro.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [Linaro-mm-sig] [PATCH 2/4] dma-fence: dma-buf synchronization
 (v8 )
Message-ID: <20120811193954.GC5132@phenom.ffwll.local>
Mail-Followup-To: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
	Rob Clark <rob.clark@linaro.org>, linaro-mm-sig@lists.linaro.org,
	linux-media@vger.kernel.org, sumit.semwal@linaro.org,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <20120810145728.5490.44707.stgit@patser.local>
 <20120810145750.5490.5639.stgit@patser.local>
 <20120810202916.GI5738@phenom.ffwll.local>
 <CAF6AEGvzaJmVmnZmEp0QBfja8Vzb0mpLa_2J6bdUZj=fgDAHVg@mail.gmail.com>
 <502681AE.9030507@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <502681AE.9030507@canonical.com>
X-Operating-System: Linux phenom 3.4.0-rc3+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 11, 2012 at 06:00:46PM +0200, Maarten Lankhorst wrote:
> Op 11-08-12 17:14, Rob Clark schreef:
> > On Fri, Aug 10, 2012 at 3:29 PM, Daniel Vetter <daniel@ffwll.ch> wrote:
> >>> +/**
> >>> + * dma_fence_signal - signal completion of a fence
> >>> + * @fence: the fence to signal
> >>> + *
> >>> + * All registered callbacks will be called directly (synchronously) and
> >>> + * all blocked waters will be awoken. This should be always be called on
> >>> + * software only fences, or alternatively be called after
> >>> + * dma_fence_ops::enable_signaling is called.
> >> I think we need to be cleare here when dma_fence_signal can be called:
> >> - for a sw-only fence (i.e. created with dma_fence_create)
> >>   dma_fence_signal _must_ be called under all circumstances.
> >> - for any other fences, dma_fence_signal may be called, but it _must_ be
> >>   called once the ->enable_signalling func has been called and return 0
> >>   (i.e. success).
> >> - it may be called only _once_.
> 
> As we discussed on irc it might be beneficial to be able to have it called
> twice, the second time would be a noop, however.

Agreed.

[snip]

> >>> +             /* At this point, if enable_signaling returns any error
> >>> +              * a wakeup has to be performanced regardless.
> >>> +              * -ENOENT signals fence was already signaled. Any other error
> >>> +              * inidicates a catastrophic hardware error.
> >>> +              *
> >>> +              * If any hardware error occurs, nothing can be done against
> >>> +              * it, so it's treated like the fence was already signaled.
> >>> +              * No synchronization can be performed, so we have to assume
> >>> +              * the fence was already signaled.
> >>> +              */
> >>> +             ret = fence->ops->enable_signaling(fence);
> >>> +             if (ret) {
> >>> +                     signaled = true;
> >>> +                     dma_fence_signal(fence);
> >> I think we should call dma_fence_signal only for -ENOENT and pass all
> >> other errors back as-is. E.g. on -ENOMEM or so we might want to retry ...
> 
> Also discussed on irc, boolean might be a better solution until we start dealing with
> hardware on fire. :) This would however likely be dealt in the same way as signaling,
> however.

Agreed.

[snip]

> >>> +
> >>> +     if (!ret) {
> >>> +             cb->base.flags = 0;
> >>> +             cb->base.func = __dma_fence_wake_func;
> >>> +             cb->base.private = priv;
> >>> +             cb->fence = fence;
> >>> +             cb->func = func;
> >>> +             __add_wait_queue(&fence->event_queue, &cb->base);
> >>> +     }
> >>> +     spin_unlock_irqrestore(&fence->event_queue.lock, flags);
> >>> +
> >>> +     return ret;
> >>> +}
> >>> +EXPORT_SYMBOL_GPL(dma_fence_add_callback);
> >> I think for api completenes we should also have a
> >> dma_fence_remove_callback function.
> > We did originally but Maarten found it was difficult to deal with
> > properly when the gpu's hang.  I think his alternative was just to
> > require the hung driver to signal the fence.  I had kicked around the
> > idea of a dma_fence_cancel() alternative to signal that could pass an
> > error thru to the waiting driver.. although not sure if the other
> > driver could really do anything differently at that point.
> 
> No, there is a very real reason I removed dma_fence_remove_callback. It is
> absolutely non-trivial to cancel it once added, since you have to deal with
> all kinds of race conditions.. See i915_gem_reset_requests in my git tree:
> http://cgit.freedesktop.org/~mlankhorst/linux/commit/?id=673c4b2550bc63ec134bca47a95dabd617a689ce

I don't see the point in that code ... Why can't we drop the kref
_outside_ of the critical section protected by event_queue_lock? Then you
pretty much have an open-coded version of dma_fence_callback_cancel in
there.

> This is the only way to do it completely deadlock/memory corruption free
> since you essentially have a locking inversion to avoid. I had it wrong
> the first 2 times too, even when I knew about a lot of the locking
> complications. If you want to do it, in most cases it will likely be easier
> to just eat the signal and ignore it instead of canceling.
> 
> >>> +
> >>> +/**
> >>> + * dma_fence_wait - wait for a fence to be signaled
> >>> + *
> >>> + * @fence:   [in]    The fence to wait on
> >>> + * @intr:    [in]    if true, do an interruptible wait
> >>> + * @timeout: [in]    absolute time for timeout, in jiffies.
> >> I don't quite like this, I think we should keep the styl of all other
> >> wait_*_timeout functions and pass the arg as timeout in jiffies (and also
> >> the same return semantics). Otherwise well have funny code that needs to
> >> handle return values differently depending upon whether it waits upon a
> >> dma_fence or a native object (where it would us the wait_*_timeout
> >> functions directly).
> > We did start out this way, but there was an ugly jiffies roll-over
> > problem that was difficult to deal with properly.  Using an absolute
> > time avoided the problem.
> Yeah, this makes it easier to wait on multiple fences, instead of
> resetting the timeout over and over and over again, or manually
> recalculating.

I don't see how updating the jiffies_left timeout is that onerous, and in
any case we can easily wrap that up into a little helper function, passing
in an array of dma_fence pointers.

Creating interfaces that differ from established kernel api patterns otoh
isn't good imo. I.e. I want dma_fence_wait_bla to be a drop-in replacement
for the corresponding wait_event_bla function/macro, which the same
semantics for the timeout and return values.

Differing in such things only leads to confusion when reading patches imo.

> >> Also, I think we should add the non-_timeout variants, too, just for
> >> completeness.
> Would it be ok if timeout == 0 is special, then?

See above ;-)

[snip]

> >>> +struct dma_fence_ops {
> >>> +     int (*enable_signaling)(struct dma_fence *fence);
> >> I think we should mandate that enable_signalling can be called from atomic
> >> context, but not irq context (since I don't see a use-case for calling
> >> this from irq context).
> 
> What would not having this called from irq context get you? I do agree
> that you would be crazy to do so, but not sure why we should restrict it.

If we allow ->enable_signalling to be called from irq context, all
spinlocks the driver grabs need to be irq safe. If we disallow this I
guess some drivers could easily get by with plain spinlocks.

And since we both agree that it would be crazy to call ->enable_signalling
from irq context, I think we should bake this constrain into the
interface.

Cheers, Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
