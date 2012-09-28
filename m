Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758280Ab2I1OOl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 10:14:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56129 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757240Ab2I1OOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 10:14:39 -0400
Message-ID: <5065B0C9.7040209@canonical.com>
Date: Fri, 28 Sep 2012 16:14:33 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: jakob@vmware.com, thellstrom@vmware.com, dri-devel@lists.freedesktop.org,
        sumit.semwal@linaro.org
CC: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] dma-buf: remove fallback for !CONFIG_DMA_SHARED_BUFFER
References: <20120928124148.14366.21063.stgit@patser.local>
In-Reply-To: <20120928124148.14366.21063.stgit@patser.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

Op 28-09-12 14:41, Maarten Lankhorst schreef:
> Documentation says that code requiring dma-buf should add it to
> select, so inline fallbacks are not going to be used. A link error
> will make it obvious what went wrong, instead of silently doing
> nothing at runtime.
>
  


The whole patch series is in my tree, I use stg so things might
move around, do not use for merging currently:

http://cgit.freedesktop.org/~mlankhorst/linux/log/?h=v10-wip

It contains everything in here plus the patches for ttm to make
it work, I use a old snapshot of drm-next + merge of nouveau as
base. Description of what the parts do:

Series to fix small api issues when moving over:

drm/ttm: Remove cpu_writers related code
drm/ttm: Add ttm_bo_is_reserved function
drm/radeon: Use ttm_bo_is_reserved
drm/vmwgfx: use ttm_bo_is_reserved

drm/vmwgfx: remove use of fence_obj_args
drm/ttm: remove sync_obj_arg
drm/ttm: remove sync_obj_arg from ttm_bo_move_accel_cleanup
drm/ttm: remove sync_arg entirely

drm/nouveau: unpin buffers before releasing to prevent lockdep warnings
drm/nouveau: add reservation to nouveau_bo_vma_del
drm/nouveau: add reservation to nouveau_gem_ioctl_cpu_prep

Hey great, now we only have one user left for fence waiting before reserving,
lets fix that and remove fence lock:
ttm_bo_cleanup_refs_or_queue and ttm_bo_cleanup_refs have to reserve before
waiting, lets do it in the squash commit so we don't have to throw lock order
around everywhere:

drm/ttm: remove fence_lock

-- Up to this point should be mergeable now

Then we start working on lru_lock removal slightly, this means the lru
list no longer is empty but can contain only reserved buffers:

drm/ttm: do not check if list is empty in ttm_bo_force_list_clean
drm/ttm: move reservations for ttm_bo_cleanup_refs

-- Still mergeable up to this point, just fixes

Patch series from this email:
dma-buf: remove fallback for !CONFIG_DMA_SHARED_BUFFER
fence: dma-buf cross-device synchronization (v9)
seqno-fence: Hardware dma-buf implementation of fencing (v3)
reservation: cross-device reservation support
reservation: Add lockdep annotation and selftests

Now hook it up to drm/ttm in a few steps:
usage around reservations:
drm/ttm: make ttm reservation calls behave like reservation calls
drm/ttm: use dma_reservation api
dma-buf: use reservations
drm/ttm: allow drivers to pass custom dma_reservation_objects for a bo

then kill off the lru lock around reservation:
drm/ttm: remove lru_lock around ttm_bo_reserve
drm/ttm: simplify ttm_eu_*

The lru_lock removal patch removes the lock around lru_lock around the
reservation, this will break the assumption that items on the lru list
and swap list can always be reserved, and this gets patched up too.
Is there any part in ttm you disagree with? I believe that this 
is all mergeable, the lru_lock removal patch could be moved to before
the reservation parts, this might make merging easier, but I don't
think there is any ttm part of the series that are wrong on a conceptual
level.

~Maarten

