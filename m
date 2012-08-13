Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751395Ab2HMMnH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 08:43:07 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52071 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046Ab2HMMnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 08:43:06 -0400
Message-ID: <5028F657.8020504@canonical.com>
Date: Mon, 13 Aug 2012 14:43:03 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Rob Clark <rob.clark@linaro.org>, linaro-mm-sig@lists.linaro.org,
        linux-media@vger.kernel.org, sumit.semwal@linaro.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [Linaro-mm-sig] [PATCH 2/4] dma-fence: dma-buf synchronization
 (v8 )
References: <20120810145728.5490.44707.stgit@patser.local> <20120810145750.5490.5639.stgit@patser.local> <20120810202916.GI5738@phenom.ffwll.local> <CAF6AEGvzaJmVmnZmEp0QBfja8Vzb0mpLa_2J6bdUZj=fgDAHVg@mail.gmail.com> <502681AE.9030507@canonical.com> <20120811193954.GC5132@phenom.ffwll.local>
In-Reply-To: <20120811193954.GC5132@phenom.ffwll.local>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

Op 11-08-12 21:39, Daniel Vetter schreef:
>>>>> +
>>>>> +     if (!ret) {
>>>>> +             cb->base.flags = 0;
>>>>> +             cb->base.func = __dma_fence_wake_func;
>>>>> +             cb->base.private = priv;
>>>>> +             cb->fence = fence;
>>>>> +             cb->func = func;
>>>>> +             __add_wait_queue(&fence->event_queue, &cb->base);
>>>>> +     }
>>>>> +     spin_unlock_irqrestore(&fence->event_queue.lock, flags);
>>>>> +
>>>>> +     return ret;
>>>>> +}
>>>>> +EXPORT_SYMBOL_GPL(dma_fence_add_callback);
>>>> I think for api completenes we should also have a
>>>> dma_fence_remove_callback function.
>>> We did originally but Maarten found it was difficult to deal with
>>> properly when the gpu's hang.  I think his alternative was just to
>>> require the hung driver to signal the fence.  I had kicked around the
>>> idea of a dma_fence_cancel() alternative to signal that could pass an
>>> error thru to the waiting driver.. although not sure if the other
>>> driver could really do anything differently at that point.
>> No, there is a very real reason I removed dma_fence_remove_callback. It is
>> absolutely non-trivial to cancel it once added, since you have to deal with
>> all kinds of race conditions.. See i915_gem_reset_requests in my git tree:
>> http://cgit.freedesktop.org/~mlankhorst/linux/commit/?id=673c4b2550bc63ec134bca47a95dabd617a689ce
> I don't see the point in that code ... Why can't we drop the kref
> _outside_ of the critical section protected by event_queue_lock? Then you
> pretty much have an open-coded version of dma_fence_callback_cancel in
> there.

The event_queue_lock protects 2 things:
1. Refcount to dma_fence won't drop to 0 if val->fences[i] != NULL
Creator is supposed to keep a refcount until after dma_fence_signal
returns. Adding a refcount you release in the callback won't help
you here much.

2. Integrity of request->prime_list
The list_del's are otherwise not serialized, leaving a corrupted
list if 2 fences signal at the same time. kref_put in the non-free'ing
case is simply an atomic decrement, so there's no measurable penalty
for keeping it in the lock.

So no, you could remove it from the kref_put, but val->fences[i] = NULL
assignment would still need it, so there's no real penalty left for
putting kref_put in the spinlock to also protect the second case
without dropping/retaking lock.

I'll add dma_fence_remove_callback that returns a bool of whether
the callback was removed or not. In the latter case the fence already
fired. However, if you call dma_fence_remove_callback twice, on the
wrong fence, or without ever calling dma_fence_add_callback you'd
undefined behavior, and there's no guarantee I could detech such
situation, but with those constraints I think it could be useful to
have.

It sucks but prime_rm_lock is the inner lock so the only way not to
deadlock is doing what I'm doing there, or not getting the hardware
locked in the first place.

>
>> This is the only way to do it completely deadlock/memory corruption free
>> since you essentially have a locking inversion to avoid. I had it wrong
>> the first 2 times too, even when I knew about a lot of the locking
>> complications. If you want to do it, in most cases it will likely be easier
>> to just eat the signal and ignore it instead of canceling.
>>
>>>>> +
>>>>> +/**
>>>>> + * dma_fence_wait - wait for a fence to be signaled
>>>>> + *
>>>>> + * @fence:   [in]    The fence to wait on
>>>>> + * @intr:    [in]    if true, do an interruptible wait
>>>>> + * @timeout: [in]    absolute time for timeout, in jiffies.
>>>> I don't quite like this, I think we should keep the styl of all other
>>>> wait_*_timeout functions and pass the arg as timeout in jiffies (and also
>>>> the same return semantics). Otherwise well have funny code that needs to
>>>> handle return values differently depending upon whether it waits upon a
>>>> dma_fence or a native object (where it would us the wait_*_timeout
>>>> functions directly).
>>> We did start out this way, but there was an ugly jiffies roll-over
>>> problem that was difficult to deal with properly.  Using an absolute
>>> time avoided the problem.
>> Yeah, this makes it easier to wait on multiple fences, instead of
>> resetting the timeout over and over and over again, or manually
>> recalculating.
> I don't see how updating the jiffies_left timeout is that onerous, and in
> any case we can easily wrap that up into a little helper function, passing
> in an array of dma_fence pointers.
>
> Creating interfaces that differ from established kernel api patterns otoh
> isn't good imo. I.e. I want dma_fence_wait_bla to be a drop-in replacement
> for the corresponding wait_event_bla function/macro, which the same
> semantics for the timeout and return values.
>
> Differing in such things only leads to confusion when reading patches imo.
>
Ok, I'll see if I can make a set of functions that follow the normal rules
for these types of functions.

~Maarten
