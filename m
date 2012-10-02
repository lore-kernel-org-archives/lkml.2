Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137Ab2JBGqk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 02:46:40 -0400
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:39017 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753930Ab2JBGqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 02:46:38 -0400
Message-ID: <506A8DC8.5020706@vmware.com>
Date: Tue, 02 Oct 2012 08:46:32 +0200
From: Thomas Hellstrom <thellstrom@vmware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
CC: jakob@vmware.com, dri-devel@lists.freedesktop.org, sumit.semwal@linaro.org,
        linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] dma-buf: remove fallback for !CONFIG_DMA_SHARED_BUFFER
References: <20120928124148.14366.21063.stgit@patser.local> <5065B0C9.7040209@canonical.com> <5065FDAA.5080103@vmware.com> <50696699.7020009@canonical.com>
In-Reply-To: <50696699.7020009@canonical.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2012 11:47 AM, Maarten Lankhorst wrote:
> Op 28-09-12 21:42, Thomas Hellstrom schreef:
>> On 09/28/2012 04:14 PM, Maarten Lankhorst wrote:
>>> Hey,
>>>
>>> Op 28-09-12 14:41, Maarten Lankhorst schreef:
>>>> Documentation says that code requiring dma-buf should add it to
>>>> select, so inline fallbacks are not going to be used. A link error
>>>> will make it obvious what went wrong, instead of silently doing
>>>> nothing at runtime.
>>>>
>>>    
>>>
>>> The whole patch series is in my tree, I use stg so things might
>>> move around, do not use for merging currently:
>>>
>>> http://cgit.freedesktop.org/~mlankhorst/linux/log/?h=v10-wip
>>>
>>> It contains everything in here plus the patches for ttm to make
>>> it work, I use a old snapshot of drm-next + merge of nouveau as
>>> base. Description of what the parts do:
>>>
>>> Series to fix small api issues when moving over:
>>>
>>> drm/ttm: Remove cpu_writers related code
>>> drm/ttm: Add ttm_bo_is_reserved function
>>> drm/radeon: Use ttm_bo_is_reserved
>>> drm/vmwgfx: use ttm_bo_is_reserved
>>>
>>> drm/vmwgfx: remove use of fence_obj_args
>>> drm/ttm: remove sync_obj_arg
>>> drm/ttm: remove sync_obj_arg from ttm_bo_move_accel_cleanup
>>> drm/ttm: remove sync_arg entirely
>>>
>>> drm/nouveau: unpin buffers before releasing to prevent lockdep warnings
>>> drm/nouveau: add reservation to nouveau_bo_vma_del
>>> drm/nouveau: add reservation to nouveau_gem_ioctl_cpu_prep
>>>
>>> Hey great, now we only have one user left for fence waiting before reserving,
>>> lets fix that and remove fence lock:
>>> ttm_bo_cleanup_refs_or_queue and ttm_bo_cleanup_refs have to reserve before
>>> waiting, lets do it in the squash commit so we don't have to throw lock order
>>> around everywhere:
>>>
>>> drm/ttm: remove fence_lock
>>>
>>> -- Up to this point should be mergeable now
>>>
>>> Then we start working on lru_lock removal slightly, this means the lru
>>> list no longer is empty but can contain only reserved buffers:
>>>
>>> drm/ttm: do not check if list is empty in ttm_bo_force_list_clean
>>> drm/ttm: move reservations for ttm_bo_cleanup_refs
>>>
>>> -- Still mergeable up to this point, just fixes
>>>
>>> Patch series from this email:
>>> dma-buf: remove fallback for !CONFIG_DMA_SHARED_BUFFER
>>> fence: dma-buf cross-device synchronization (v9)
>>> seqno-fence: Hardware dma-buf implementation of fencing (v3)
>>> reservation: cross-device reservation support
>>> reservation: Add lockdep annotation and selftests
>>>
>>> Now hook it up to drm/ttm in a few steps:
>>> usage around reservations:
>>> drm/ttm: make ttm reservation calls behave like reservation calls
>>> drm/ttm: use dma_reservation api
>>> dma-buf: use reservations
>>> drm/ttm: allow drivers to pass custom dma_reservation_objects for a bo
>>>
>>> then kill off the lru lock around reservation:
>>> drm/ttm: remove lru_lock around ttm_bo_reserve
>>> drm/ttm: simplify ttm_eu_*
>>>
>>> The lru_lock removal patch removes the lock around lru_lock around the
>>> reservation, this will break the assumption that items on the lru list
>>> and swap list can always be reserved, and this gets patched up too.
>>> Is there any part in ttm you disagree with? I believe that this
>>> is all mergeable, the lru_lock removal patch could be moved to before
>>> the reservation parts, this might make merging easier, but I don't
>>> think there is any ttm part of the series that are wrong on a conceptual
>>> level.
>>>
>>> ~Maarten
>>>
>> ....From another email
>>
>>>> As previously discussed, I'm unfortunately not prepared to accept removal of the reserve-lru atomicity
>>>>    into the TTM code at this point.
>>>> The current code is based on this assumption and removing it will end up with
>>>> efficiencies, breaking the delayed delete code and probably a locking nightmare when trying to write
>>>> new TTM code.
>>> The lru lock removal patch fixed the delayed delete code, it really is not different from the current
>>> situation. In fact it is more clear without the guarantee what various parts are trying to protect.
>>>
>>> Nothing prevents you from holding the lru_lock while trylocking,
>> [1]
>> While this would not cause any deadlocks, Any decent lockdep code would establish lru->reserve as the locking
>> order once a lru- reserve trylock succeeds, but the locking order is really reserve->lru for obvious reasons, which
>> means we will get a lot of lockdep errors? Yes, there are a two reversals like these already in the TTM code, and I'm
>> not very proud of them.
> I was doing a evil hack where I 'released' lru_lock to lockdep before doing the annotation
> for a blocking acquire, and left trylock annotations as they were. This made lockdep do the
> right thing.
I've never looked into how lockdep works. Is this something that can be 
done permanently or just for testing
purposes? Although not related to this, is it possible to do something 
similar to the trylock reversal in the
fault() code where mmap_sem() and reserve() change order using a reserve 
trylock?

>> And this is even before it starts to get interesting, like how you guarantee that when you release a buffer from
>> the delayed delete list, you're the only process having a reference?
> l thought list_kref made sure of that? Even if not the only one with a reference, the list_empty check would
> make sure it would only run once. I'l fix it up again so it doesn't become a WARN_ON_ONCE, I didn't know
> it could run multiple times at the time, so I'll change it back to unlikely.
Yes, you've probably right. A case we've seen earlier (before the 
atomicity was introduced) was one or more threads
picked up a bo from the LRU list and prepared to reserve it, while the 
delayed delete function removed them from the
ddestroy list. Then the first thread queued an accelerated eviction, 
adding a new fence and the bo was left hanging.
I don't think that can happen with the reserve trylocks within the lru 
spinlock, though.

>
>> Now, it's probably possible to achieve what you're trying to do, if we accept the lock reversal in
>> [1], but since I have newborn twins and I have about one hour of spare time a week with I now spent on this
>> review and I guess there are countless more hours before this can work. (These code paths were never tested, right?)
>> One of the biggest TTM reworks was to introduce the atomicity assumption and remove a lot of code that was
>> prone to deadlocks, races and buffer leaks. I'm not prepared to revert that work without an extremely
>> good reason, and "It can be done" is not such a reason.
> Deepest apologies, I only did a quick glance at the code part of this email, overlooked this part since
> I was swamped with other things and meant to do a full reply on monday. I didn't mean to make it sound
> like I only cared blindly about merging my code, just wanted to find a good solution.
>> We *need* to carefully weigh it against any benefits you have in your work, and you need to test these codepaths
>> in parallell cases subject to heavy aperture / vram thrashing and frequent signals causing interrupted waits.
> Agreed, is there already a tester for this or should I write my own?
Although I think it would be nice to have a highly parallel execbuf 
implementation on an extremely simple software GPU,
what I typically do is to take an existing driver (none of them 
implements parallel reserve yet, but vmware is about to soon)

a) Use an application that frequently recycles buffers, so that the 
delayed-delete code gets busy (Perhaps google-earth, panning over a 
landscape not too high above the earth)
b) Hack the drivers aperture / vram sizes to something small, so that 
you can see that the eviction code gets hit.
c) Adjust the memory limits in TTM sysfs memory accounting (You can 
write and change on the fly), so that you can see that the swapping
code gets hit.
d) Code a signal delivery so that every 20th time or so the eviction 
code is about to wait, it receives an -ERESTARTSYS with a harmless signal.
e) start another instance of google-earth.


/Thomas

>> And I think you need to present the gains in your work that can motivate the testing-and review time for this.
> Agreed.
>
> ~Maarten

