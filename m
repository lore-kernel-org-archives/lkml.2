Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573Ab2HKTWc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2012 15:22:32 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:40009 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989Ab2HKTW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2012 15:22:27 -0400
Date: Sat, 11 Aug 2012 21:22:47 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Rob Clark <rob.clark@linaro.org>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        sumit.semwal@linaro.org, linaro-mm-sig@lists.linaro.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org
Subject: Re: [Linaro-mm-sig] [PATCH 2/4] dma-fence: dma-buf synchronization
 (v8 )
Message-ID: <20120811192247.GB5132@phenom.ffwll.local>
Mail-Followup-To: Rob Clark <rob.clark@linaro.org>,
	Maarten Lankhorst <maarten.lankhorst@canonical.com>,
	sumit.semwal@linaro.org, linaro-mm-sig@lists.linaro.org,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org
References: <20120810145728.5490.44707.stgit@patser.local>
 <20120810145750.5490.5639.stgit@patser.local>
 <20120810202916.GI5738@phenom.ffwll.local>
 <CAF6AEGvzaJmVmnZmEp0QBfja8Vzb0mpLa_2J6bdUZj=fgDAHVg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF6AEGvzaJmVmnZmEp0QBfja8Vzb0mpLa_2J6bdUZj=fgDAHVg@mail.gmail.com>
X-Operating-System: Linux phenom 3.4.0-rc3+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 11, 2012 at 10:14:40AM -0500, Rob Clark wrote:
> On Fri, Aug 10, 2012 at 3:29 PM, Daniel Vetter <daniel@ffwll.ch> wrote:
> > On Fri, Aug 10, 2012 at 04:57:52PM +0200, Maarten Lankhorst wrote:
> >> +
> >> +     if (!ret) {
> >> +             cb->base.flags = 0;
> >> +             cb->base.func = __dma_fence_wake_func;
> >> +             cb->base.private = priv;
> >> +             cb->fence = fence;
> >> +             cb->func = func;
> >> +             __add_wait_queue(&fence->event_queue, &cb->base);
> >> +     }
> >> +     spin_unlock_irqrestore(&fence->event_queue.lock, flags);
> >> +
> >> +     return ret;
> >> +}
> >> +EXPORT_SYMBOL_GPL(dma_fence_add_callback);
> >
> > I think for api completenes we should also have a
> > dma_fence_remove_callback function.
> 
> We did originally but Maarten found it was difficult to deal with
> properly when the gpu's hang.  I think his alternative was just to
> require the hung driver to signal the fence.  I had kicked around the
> idea of a dma_fence_cancel() alternative to signal that could pass an
> error thru to the waiting driver.. although not sure if the other
> driver could really do anything differently at that point.

Well, the idea is not to cancel all callbacks, but just a single one, in
case a driver wants to somehow abort the wait. E.g. when the own gpu dies
I guess we should clear all these fence callbacks so that they can't
clobber the hw state after the reset.

> >> +
> >> +/**
> >> + * dma_fence_wait - wait for a fence to be signaled
> >> + *
> >> + * @fence:   [in]    The fence to wait on
> >> + * @intr:    [in]    if true, do an interruptible wait
> >> + * @timeout: [in]    absolute time for timeout, in jiffies.
> >
> > I don't quite like this, I think we should keep the styl of all other
> > wait_*_timeout functions and pass the arg as timeout in jiffies (and also
> > the same return semantics). Otherwise well have funny code that needs to
> > handle return values differently depending upon whether it waits upon a
> > dma_fence or a native object (where it would us the wait_*_timeout
> > functions directly).
> 
> We did start out this way, but there was an ugly jiffies roll-over
> problem that was difficult to deal with properly.  Using an absolute
> time avoided the problem.

Well, as-is the api works differently than all the other _timeout apis
I've seen in the kernel, which makes it confusing. Also, I don't quite see
what jiffies wraparound issue there is?

> > Also, I think we should add the non-_timeout variants, too, just for
> > completeness.

This request here has the same reasons, essentially: If we offer a
dma_fence wait api that matches the usual wait apis closely, it's harder
to get their usage wrong. I know that i915 has some major cludge for a
wait_seqno interface internally, but that's no reason to copy that
approach ;-)

Cheers, Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
