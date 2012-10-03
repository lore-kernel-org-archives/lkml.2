Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858Ab2JCMrA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 08:47:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46891 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102Ab2JCMq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 08:46:59 -0400
Message-ID: <506C33C0.5000501@canonical.com>
Date: Wed, 03 Oct 2012 14:46:56 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Thomas Hellstrom <thellstrom@vmware.com>
CC: Daniel Vetter <daniel@ffwll.ch>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        sumit.semwal@linaro.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/5] dma-buf: remove fallback for !CONFIG_DMA_SHARED_BUFFER
References: <20120928124148.14366.21063.stgit@patser.local> <5065B0C9.7040209@canonical.com> <5065FDAA.5080103@vmware.com> <50696699.7020009@canonical.com> <506A8DC8.5020706@vmware.com> <20121002080341.GA5679@phenom.ffwll.local> <506BED25.2060804@vmware.com> <CAKMK7uGDaCCL-UT7JaArd3qrnMSc74r32fQ2dnouO3csRGvakg@mail.gmail.com> <506BF93B.5010805@vmware.com> <CAKMK7uGg5pbReAUA+cKWk-jyS3YwkUaZXE7MTcv9w7sk-4a10A@mail.gmail.com> <506C190E.5050803@vmware.com>
In-Reply-To: <506C190E.5050803@vmware.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 03-10-12 12:53, Thomas Hellstrom schreef:
> On 10/03/2012 10:53 AM, Daniel Vetter wrote:
>> On Wed, Oct 3, 2012 at 10:37 AM, Thomas Hellstrom <thellstrom@vmware.com> wrote:
>>>>> So if I understand you correctly, the reservation changes in TTM are
>>>>> motivated by the
>>>>> fact that otherwise, in the generic reservation code, lockdep can only be
>>>>> annotated for a trylock and not a waiting lock, when it *is* in fact a
>>>>> waiting lock.
>>>>>
>>>>> I'm completely unfamiliar with setting up lockdep annotations, but the
>>>>> only
>>>>> place a
>>>>> deadlock might occur is if the trylock fails and we do a
>>>>> wait_for_unreserve().
>>>>> Isn't it possible to annotate the call to wait_for_unreserve() just like
>>>>> an
>>>>> interruptible waiting lock
>>>>> (that is always interrupted, but at least any deadlock will be catched?).
>>>> Hm, I have to admit that idea hasn't crossed my mind, but it's indeed
>>>> a hole in our current reservation lockdep annotations - since we're
>>>> blocking for the unreserve, other threads could potential block
>>>> waiting on us to release a lock we're holding already, resulting in a
>>>> deadlock.
>>>>
>>>> Since no other locking primitive that I know of has this
>>>> wait_for_unlocked interface, I don't know how we could map this in
>>>> lockdep. One idea is to grab the lock and release it again immediately
>>>> (only in the annotations, not the real lock ofc). But I need to check
>>>> the lockdep code to see whether that doesn't trip it up.
>>>
>>> I imagine doing the same as mutex_lock_interruptible() does in the
>>> interrupted path should work...
>> It simply calls the unlock lockdep annotation function if it breaks
>> out. So doing a lock/unlock cycle in wait_unreserve should do what we
>> want.
>>
>> And to properly annotate the ttm reserve paths we could just add an
>> unconditional wait_unreserve call at the beginning like you suggested
>> (maybe with #ifdef CONFIG_PROVE_LOCKING in case ppl freak out about
>> the added atomic read in the uncontended case).
>> -Daniel
>
> I think atomic_read()s are cheap, at least on intel as IIRC they don't require bus locking,
> still I think we should keep it within CONFIG_PROVE_LOCKING
>
> which btw reminds me there's an optimization that can be done in that one should really only
> call atomic_cmpxchg() if a preceding atomic_read() hints that it will succeed.
>
> Now, does this mean TTM can keep the atomic reserve <-> lru list removal?
I don't think it would be a good idea to keep this across devices, there's currently no
callback to remove buffers off the lru list.

However I am convinced that the current behavior where swapout and
eviction/destruction never ever do a blocking reserve should be preserved. I looked
more into it and it seems to allow to recursely quite a few times between all the
related commands, and it wouldn't surprise me if that turned out to be cause of the
lockups before moving to the current code.
no_wait_reserve in those functions should be removed and always treated as true.

Atomic lru_lock + reserve can still be done in the places where it matters though,
but it might have to try the list for multiple bo's before it succeeds. As long as no
blocking is done the effective behavior would stay the same.

~Maarten
