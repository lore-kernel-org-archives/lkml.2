Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308Ab2JAIuI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 04:50:08 -0400
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:50510 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751492Ab2JAIuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 04:50:05 -0400
Message-ID: <50695937.40404@vmware.com>
Date: Mon, 01 Oct 2012 10:49:59 +0200
From: Thomas Hellstrom <thellstrom@vmware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
CC: jakob@vmware.com, dri-devel@lists.freedesktop.org, sumit.semwal@linaro.org,
        linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] dma-buf: remove fallback for !CONFIG_DMA_SHARED_BUFFER
References: <20120928124148.14366.21063.stgit@patser.local> <5065B0C9.7040209@canonical.com> <5065FDAA.5080103@vmware.com> <5066041A.7000201@vmware.com> <506710B3.7050401@canonical.com>
In-Reply-To: <506710B3.7050401@canonical.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/2012 05:16 PM, Maarten Lankhorst wrote:
> Op 28-09-12 22:10, Thomas Hellstrom schreef:
>> On 09/28/2012 09:42 PM, Thomas Hellstrom wrote:
>>> On 09/28/2012 04:14 PM, Maarten Lankhorst wrote:
>>>> Hey,
>>>>
>>>> Op 28-09-12 14:41, Maarten Lankhorst schreef:
>>>>> Documentation says that code requiring dma-buf should add it to
>>>>> select, so inline fallbacks are not going to be used. A link error
>>>>> will make it obvious what went wrong, instead of silently doing
>>>>> nothing at runtime.
>>>>>
>>>>
>>>> The whole patch series is in my tree, I use stg so things might
>>>> move around, do not use for merging currently:
>>>>
>>>> http://cgit.freedesktop.org/~mlankhorst/linux/log/?h=v10-wip
>>>>
>>>> It contains everything in here plus the patches for ttm to make
>>>> it work, I use a old snapshot of drm-next + merge of nouveau as
>>>> base. Description of what the parts do:
>>>>
>>>> Series to fix small api issues when moving over:
>>>>
>>>> drm/ttm: Remove cpu_writers related code
>>>> drm/ttm: Add ttm_bo_is_reserved function
>>>> drm/radeon: Use ttm_bo_is_reserved
>>>> drm/vmwgfx: use ttm_bo_is_reserved
>>>>
>>>> drm/vmwgfx: remove use of fence_obj_args
>>>> drm/ttm: remove sync_obj_arg
>>>> drm/ttm: remove sync_obj_arg from ttm_bo_move_accel_cleanup
>>>> drm/ttm: remove sync_arg entirely
>>>>
>>>> drm/nouveau: unpin buffers before releasing to prevent lockdep warnings
>>>> drm/nouveau: add reservation to nouveau_bo_vma_del
>>>> drm/nouveau: add reservation to nouveau_gem_ioctl_cpu_prep
>>>>
>>>> Hey great, now we only have one user left for fence waiting before reserving,
>>>> lets fix that and remove fence lock:
>>>> ttm_bo_cleanup_refs_or_queue and ttm_bo_cleanup_refs have to reserve before
>>>> waiting, lets do it in the squash commit so we don't have to throw lock order
>>>> around everywhere:
>>>>
>>>> drm/ttm: remove fence_lock
>>>>
>>>> -- Up to this point should be mergeable now
>>>>
>>>> Then we start working on lru_lock removal slightly, this means the lru
>>>> list no longer is empty but can contain only reserved buffers:
>>>>
>>>> drm/ttm: do not check if list is empty in ttm_bo_force_list_clean
>>>> drm/ttm: move reservations for ttm_bo_cleanup_refs
>>>>
>>>> -- Still mergeable up to this point, just fixes
>>>>
>>>> Patch series from this email:
>>>> dma-buf: remove fallback for !CONFIG_DMA_SHARED_BUFFER
>>>> fence: dma-buf cross-device synchronization (v9)
>>>> seqno-fence: Hardware dma-buf implementation of fencing (v3)
>>>> reservation: cross-device reservation support
>>>> reservation: Add lockdep annotation and selftests
>>>>
>>>> Now hook it up to drm/ttm in a few steps:
>>>> usage around reservations:
>>>> drm/ttm: make ttm reservation calls behave like reservation calls
>>>> drm/ttm: use dma_reservation api
>>>> dma-buf: use reservations
>>>> drm/ttm: allow drivers to pass custom dma_reservation_objects for a bo
>>>>
>>>> then kill off the lru lock around reservation:
>>>> drm/ttm: remove lru_lock around ttm_bo_reserve
>>>> drm/ttm: simplify ttm_eu_*
>>>>
>>>> The lru_lock removal patch removes the lock around lru_lock around the
>>>> reservation, this will break the assumption that items on the lru list
>>>> and swap list can always be reserved, and this gets patched up too.
>>>> Is there any part in ttm you disagree with? I believe that this
>>>> is all mergeable, the lru_lock removal patch could be moved to before
>>>> the reservation parts, this might make merging easier, but I don't
>>>> think there is any ttm part of the series that are wrong on a conceptual
>>>> level.
>>>>
>>>> ~Maarten
>>>>
>>> ....From another email
>>>
>>>>> As previously discussed, I'm unfortunately not prepared to accept removal of the reserve-lru atomicity
>>>>>    into the TTM code at this point.
>>>>> The current code is based on this assumption and removing it will end up with
>>>>> efficiencies, breaking the delayed delete code and probably a locking nightmare when trying to write
>>>>> new TTM code.
>>>> The lru lock removal patch fixed the delayed delete code, it really is not different from the current
>>>> situation. In fact it is more clear without the guarantee what various parts are trying to protect.
>>>>
>>>> Nothing prevents you from holding the lru_lock while trylocking,
>>> [1]
>>> While this would not cause any deadlocks, Any decent lockdep code would establish lru->reserve as the locking
>>> order once a lru- reserve trylock succeeds, but the locking order is really reserve->lru for obvious reasons, which
>>> means we will get a lot of lockdep errors? Yes, there are a two reversals like these already in the TTM code, and I'm
>>> not very proud of them.
>>>
>>> leaving that guarantee intact for that part. Can you really just review
>>> the patch and tell me where it breaks and/or makes the code unreadable?
>>>
>>> OK. Now I'm looking at
>>> http://cgit.freedesktop.org/~mlankhorst/linux/tree/drivers/gpu/drm/ttm/ttm_bo.c?h=v10-wip&id=1436e2e64697c744d6e186618448e1e6354846bb
>>>
>>> And let's start with a function that's seen some change, ttm_mem_evict_first:
>>>
>>> *) Line 715: You're traversing a list using list_for_each() calling a function that may remove the list entr||||y
>>> *) Line 722: You're unlocking the lock protecting the list in the middle of list traversal
>>> *) Line 507: WARN_ON_ONCE in a code path quite likely to get called?
> When will it get called?
> ttm_bo_delayed_delete calls it if it's already on delayed destroy list.
> ttm_mem_evict_first only calls it if on that list too.
> ttm_bo_swapout won't call it either if not on the list.
>
Two threads calling ttm_bo_delayed_delete at the same time?

Anyway, in the swapout code there is an additional deadlock and no loop 
on reserved buffers

And this is really my point, by removing the atomicity you get into this 
kind of deadlock- and locking mess,
and TTM transits from hard to maintain to unmaintainable.

Furthermore, I've requested four times now that we bring this up on the 
design level, but you consequently
refuse to answer my questions asking me to review the code instead. With 
that kind of argumentation,
I could easily write a patch that changes your reservation objects to 
take a spinlock before reserving and a list
of functions to be called with that block held just after reserving, and 
ask you to review that, Then we could
compare the amount of stable and tested code needing a thorough 
retesting our pathes touch.

So, until we've agreed on a design, This is a firm NAK from my side when 
it comes to the TTM part.

Thanks,
Thomas



