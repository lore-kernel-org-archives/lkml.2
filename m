Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932602Ab2HVNcT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 09:32:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35800 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972Ab2HVNcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 09:32:17 -0400
Message-ID: <5034DF5C.80801@canonical.com>
Date: Wed, 22 Aug 2012 15:32:12 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Thomas Hellstrom <thellstrom@vmware.com>
CC: sumit.semwal@linaro.org, rob.clark@linaro.org,
        Daniel Vetter <daniel@ffwll.ch>, jakob@vmware.com,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Subject: Re: [RFC patch 4/4] Re: dma-buf-mgr: multiple dma-buf synchronization
 (v3)
References: <20120810145728.5490.44707.stgit@patser.local> <20120810145804.5490.14858.stgit@patser.local> <20120815231246.GI5533@phenom.ffwll.local> <5034C77C.9050501@canonical.com> <5034D5FA.9000607@vmware.com>
In-Reply-To: <5034D5FA.9000607@vmware.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

Op 22-08-12 14:52, Thomas Hellstrom schreef:
> Hi, Maarten,
> please see some comments inline.
>
> On 08/22/2012 01:50 PM, Maarten Lankhorst wrote:
>> Hey Dan,
>>
>> Op 16-08-12 01:12, Daniel Vetter schreef:
>>> Hi Maarten,
>>>
>>> Ok, here comes the promised review (finally!), but it's rather a
>>> high-level thingy. I've mostly thought about how we could create a neat
>>> api with the following points. For a bit of clarity, I've grouped the
>>> different considerations a bit.
>>> <snip>
>> Thanks, I have significantly reworked the api based on your comments.
>>
>> Documentation is currently lacking, and will get updated again for the final version.
>>
>> Full patch series also includes some ttm changes to make use of dma-reservation,
>> with the intention of moving out fencing from ttm too, but that requires more work.
>>
>> For the full series see:
>> http://cgit.freedesktop.org/~mlankhorst/linux/log/?h=v10-wip
>>
>> My plan is to add a pointer for dma_reservation to a dma-buf,
>> so all users of dma-reservation can perform reservations across
>> multiple devices as well. Since the default for ttm likely will
>> mean only a few buffers are shared I didn't want to complicate
>> the abi for ttm much further so only added a pointer that can be
>> null to use ttm's reservation_object structure.
>>
>> The major difference with ttm is that each reservation object
>> gets its own lock for fencing and reservations, but they can
>> be merged:
>
> TTM previously had a lock on each buffer object which protected sync_obj and sync_obj_arg, however
> when fencing multiple buffers, say 100 buffers or so in a single command submission, it meant 100
> locks / unlocks that weren't really necessary, since just updating the sync_obj and sync_obj_arg members
> is a pretty quick operation, whereas locking may be a pretty slow operation, so those locks were removed
> for efficiency.
Speaking of which, mind if I kill sync_obj_arg? Only user is again vmwgfx and it always seems to pass the same
for flags, namely DRM_VMW_FENCE_FLAG_EXEC.
> The reason a single lock (the lru lock) is used to protect reservation is that a TTM object that is being reserved
> *atomically* needs to be taken off LRU lists, since processes performing LRU eviction don't take a ticket
> when evicting, and may thus cause deadlocks; It might be possible to fix this within TTM by requiring a ticket
> for all reservation, but then that ticket needs to be passed down the call chain for all functions that may perform
> a reservation. It would perhaps be simpler (but perhaps not so fair) to use the current thread info pointer as a ticket
> sequence number.
Yeah, that's why the ttm patch for ttm_bo_reserve_locked always calls dma_object_reserve with no_wait set to true. :)
It does its own EBUSY handling for the no_wait case, so there should be no functional changes.

I've been toying with the idea of always requiring a sequence number, I just didn't in the current patch yet
since it would mean converting every driver, so for a preliminary patch based on a unmerged api it was
not worth the time.

>> spin_lock(obj->resv)
>> __dma_object_reserve()
>> grab a ref to all obj->fences
>> spin_unlock(obj->resv)
>>
>> spin_lock(obj->resv)
>> assign new fence to obj->fences
>> __dma_object_unreserve()
>> spin_unlock(obj->resv)
>>
>> There's only one thing about fences I haven't been able to map
>> yet properly. vmwgfx has sync_obj_flush, but as far as I can
>> tell it has not much to do with sync objects, but is rather a
>> generic 'flush before release'. Maybe one of the vmwgfx devs
>> could confirm whether that call is really needed there? And if
>> so, if there could be some other way do that, because it seems
>> to be the ttm_bo_wait call before that would be enough, if not
>> it might help more to move the flush to some other call.
>
> The fence flush should be interpreted as an operation for fencing mechanisms that aren't otherwise required to
> signal in finite time, and where the time from flush to signal might be substantial. TTM is then supposed to
> issue a fence flush when it knows ahead of time that it will soon perform a periodical poll for a buffer to be
> idle, but not block waiting for the buffer to be idle. The delayed buffer delete mechanism is, I think, the only user
> currently.
> For hardware that always signal fences immediately, the flush mechanism is not needed.
So if I understand it correctly it is the same as I'm doing in fences with dma_fence::enable_sw_signals?
Great, I don't need to add another op then. Although it looks like I should export a function to manually
enable it for those cases. :)

>> <snip>
>> +
>> +int
>> +__dma_object_reserve(struct dma_reservation_object *obj, bool intr,
>> +             bool no_wait, dma_reservation_ticket_t *ticket)
>> +{
>> +    int ret;
>> +    u64 sequence = ticket ? ticket->seqno : 0;
>> +
>> +    while (unlikely(atomic_cmpxchg(&obj->reserved, 0, 1) != 0)) {
>> +        /**
>> +         * Deadlock avoidance for multi-dmabuf reserving.
>> +         */
>> +        if (sequence && obj->sequence) {
>> +            /**
>> +             * We've already reserved this one.
>> +             */
>> +            if (unlikely(sequence == obj->sequence))
>> +                return -EDEADLK;
>> +            /**
>> +             * Already reserved by a thread that will not back
>> +             * off for us. We need to back off.
>> +             */
>> +            if (unlikely(sequence - obj->sequence < (1ULL << 63)))
>> +                return -EAGAIN;
>> +        }
>> +
>> +        if (no_wait)
>> +            return -EBUSY;
>> +
>> +        spin_unlock(&obj->lock);
>> +        ret = dma_object_wait_unreserved(obj, intr);
>> +        spin_lock(&obj->lock);
>> +
>> +        if (unlikely(ret))
>> +            return ret;
>> +    }
>> +
>> +    /**
>> +     * Wake up waiters that may need to recheck for deadlock,
>> +     * if we decreased the sequence number.
>> +     */
>> +    if (sequence && unlikely((obj->sequence - sequence < (1ULL << 63)) ||
>> +        !obj->sequence))
>> +        wake_up_all(&obj->event_queue);
>> +
>> +    obj->sequence = sequence;
>> +    return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(__dma_object_reserve);
>
> Since this function and the corresponding unreserve is exported, it should probably be
> documented (this holds for TTM as well) that they need memory barriers to protect
> data, since IIRC the linux atomic_xxx operations do not necessarily order memory
> reads and writes. For the corresponding unlocked dma_object_reserve and
> dma_object_unreserve, the spinlocks should take care of that.
The documentation is still lacking, but they require the spinlocks to be taken by the caller,
else things explode. It's meant for updating fence and ending reservation atomically.

~Maarten
