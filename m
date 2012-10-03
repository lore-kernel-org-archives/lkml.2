Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab2JCIfy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 04:35:54 -0400
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:50248 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751016Ab2JCIfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 04:35:48 -0400
Message-ID: <506BF8DF.5090704@vmware.com>
Date: Wed, 03 Oct 2012 10:35:43 +0200
From: Thomas Hellstrom <thellstrom@vmware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
CC: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, sumit.semwal@linaro.org,
        linux-media@vger.kernel.org, Daniel Vetter <daniel@ffwll.ch>
Subject: Re: [PATCH 1/5] dma-buf: remove fallback for !CONFIG_DMA_SHARED_BUFFER
References: <20120928124148.14366.21063.stgit@patser.local> <5065B0C9.7040209@canonical.com> <5065FDAA.5080103@vmware.com> <50696699.7020009@canonical.com> <506A8DC8.5020706@vmware.com> <20121002080341.GA5679@phenom.ffwll.local> <506BED25.2060804@vmware.com> <506BEFE0.2060906@canonical.com>
In-Reply-To: <506BEFE0.2060906@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2012 09:57 AM, Maarten Lankhorst wrote:
> Hey,
>
> Op 03-10-12 09:45, Thomas Hellstrom schreef:
>> On 10/02/2012 10:03 AM, Daniel Vetter wrote:
>>> On Tue, Oct 02, 2012 at 08:46:32AM +0200, Thomas Hellstrom wrote:
>>>> On 10/01/2012 11:47 AM, Maarten Lankhorst wrote:
>>>>> I was doing a evil hack where I 'released' lru_lock to lockdep before doing the annotation
>>>>> for a blocking acquire, and left trylock annotations as they were. This made lockdep do the
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
>>>     could come up with proper reservation annotations without any changes to
>>>     lockdep testifies this (he only had to fix a tiny thing to make it a bit
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
>> So if I understand you correctly, the reservation changes in TTM are motivated by the
>> fact that otherwise, in the generic reservation code, lockdep can only be
>> annotated for a trylock and not a waiting lock, when it *is* in fact a waiting lock.
>>
>> I'm completely unfamiliar with setting up lockdep annotations, but the only place a
>> deadlock might occur is if the trylock fails and we do a wait_for_unreserve().
>> Isn't it possible to annotate the call to wait_for_unreserve() just like an interruptible waiting lock
>> (that is always interrupted, but at least any deadlock will be catched?).
> That would not find all bugs, lockdep is meant to find even theoretical bugs, so annotating it as a
> waiting lock makes more sense. Otherwise lockdep will only barf when the initial trylock fails.

Really, starting a waiting reserve with a call to wait_for_unreserve() 
if CONFIG_LOCKDEP is set
shouldn't be that bad :)? That would catch also the the theoretical errors.
In fact, it should suffice with annotating for such a call?

/Thomas

> ~Maarten
>

