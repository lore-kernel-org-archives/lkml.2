Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697Ab2JCIhY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 04:37:24 -0400
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:35593 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753192Ab2JCIhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 04:37:20 -0400
Message-ID: <506BF93B.5010805@vmware.com>
Date: Wed, 03 Oct 2012 10:37:15 +0200
From: Thomas Hellstrom <thellstrom@vmware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Daniel Vetter <daniel@ffwll.ch>
CC: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, sumit.semwal@linaro.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 1/5] dma-buf: remove fallback for !CONFIG_DMA_SHARED_BUFFER
References: <20120928124148.14366.21063.stgit@patser.local> <5065B0C9.7040209@canonical.com> <5065FDAA.5080103@vmware.com> <50696699.7020009@canonical.com> <506A8DC8.5020706@vmware.com> <20121002080341.GA5679@phenom.ffwll.local> <506BED25.2060804@vmware.com> <CAKMK7uGDaCCL-UT7JaArd3qrnMSc74r32fQ2dnouO3csRGvakg@mail.gmail.com>
In-Reply-To: <CAKMK7uGDaCCL-UT7JaArd3qrnMSc74r32fQ2dnouO3csRGvakg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2012 09:54 AM, Daniel Vetter wrote:
> On Wed, Oct 3, 2012 at 9:45 AM, Thomas Hellstrom <thellstrom@vmware.com> wrote:
>> On 10/02/2012 10:03 AM, Daniel Vetter wrote:
>>> On Tue, Oct 02, 2012 at 08:46:32AM +0200, Thomas Hellstrom wrote:
>>>> On 10/01/2012 11:47 AM, Maarten Lankhorst wrote:
>>>>> I was doing a evil hack where I 'released' lru_lock to lockdep before
>>>>> doing the annotation
>>>>> for a blocking acquire, and left trylock annotations as they were. This
>>>>> made lockdep do the
>>>>> right thing.
>>>> I've never looked into how lockdep works. Is this something that can
>>>> be done permanently or just for testing
>>>> purposes? Although not related to this, is it possible to do
>>>> something similar to the trylock reversal in the
>>>> fault() code where mmap_sem() and reserve() change order using a
>>>> reserve trylock?
>>> lockdep just requires a bunch of annotations, is a compile-time configure
>>> option CONFIG_PROVE_LOCKING and if disabled, has zero overhead. And it's
>>> rather awesome in detected deadlocks and handling crazy locking schemes
>>> correctly:
>>> - correctly handles trylocks
>>> - correctly handles nested locking (i.e. grabbing a global lock, then
>>>     grabbing subordinate locks in an unordered sequence since the global
>>>     lock ensures that no deadlocks can happen).
>>> - any kinds of inversions with special contexts like hardirq, softirq
>>> - same for page-reclaim, i.e. it will yell if you could (potentially)
>>>     deadlock because your shrinker grabs a lock that you hold while calling
>>>     kmalloc.
>>> - there are special annotates for various subsystems, e.g. to check for
>>>     del_timer_sync vs. locks held by that timer. Or the console_lock
>>>     annotations I've just recently submitted.
>>> - all that with a really flexible set of annotation primitives that afaics
>>>     should work for almost any insane locking scheme. The fact that Maarten
>>>     could come up with proper reservation annotations without any changes
>>> to
>>>     lockdep testifies this (he only had to fix a tiny thing to make it a
>>> bit
>>>     more strict in a corner case).
>>>
>>> In short I think it's made of awesome. The only downside is that it lacks
>>> documentation, you have to read the code to understand it :(
>>>
>>> The reason I've suggested to Maarten to abolish the trylock_reservation
>>> within the lru_lock is that in that way lockdep only ever sees the
>>> trylock, and hence is less strict about complainig about deadlocks. But
>>> semantically it's an unconditional reserve. Maarten had some horrible
>>> hacks that leaked the lockdep annotations out of the new reservation code,
>>> which allowed ttm to be properly annotated.  But those also reduced the
>>> usefulness for any other users of the reservation code, and so Maarten
>>> looked into whether he could remove that trylock dance in ttm.
>>>
>>> Imo having excellent lockdep support for cross-device reservations is a
>>> requirment, and ending up with less strict annotations for either ttm
>>> based drivers or other drivers is not good. And imo the ugly layering that
>>> Maarten had in his first proof-of-concept also indicates that something is
>>> amiss in the design.
>>>
>>>
>> So if I understand you correctly, the reservation changes in TTM are
>> motivated by the
>> fact that otherwise, in the generic reservation code, lockdep can only be
>> annotated for a trylock and not a waiting lock, when it *is* in fact a
>> waiting lock.
>>
>> I'm completely unfamiliar with setting up lockdep annotations, but the only
>> place a
>> deadlock might occur is if the trylock fails and we do a
>> wait_for_unreserve().
>> Isn't it possible to annotate the call to wait_for_unreserve() just like an
>> interruptible waiting lock
>> (that is always interrupted, but at least any deadlock will be catched?).
> Hm, I have to admit that idea hasn't crossed my mind, but it's indeed
> a hole in our current reservation lockdep annotations - since we're
> blocking for the unreserve, other threads could potential block
> waiting on us to release a lock we're holding already, resulting in a
> deadlock.
>
> Since no other locking primitive that I know of has this
> wait_for_unlocked interface, I don't know how we could map this in
> lockdep. One idea is to grab the lock and release it again immediately
> (only in the annotations, not the real lock ofc). But I need to check
> the lockdep code to see whether that doesn't trip it up.

I imagine doing the same as mutex_lock_interruptible() does in the
interrupted path should work...

>
> Cheers, Daniel

