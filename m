Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757536Ab2HVPMy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 11:12:54 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:42768 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756430Ab2HVPMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 11:12:50 -0400
Date: Wed, 22 Aug 2012 17:13:11 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Thomas Hellstrom <thellstrom@vmware.com>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        sumit.semwal@linaro.org, rob.clark@linaro.org,
        Daniel Vetter <daniel@ffwll.ch>, jakob@vmware.com,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Subject: Re: [RFC patch 4/4] Re: dma-buf-mgr: multiple dma-buf
 synchronization (v3)
Message-ID: <20120822151311.GB5186@phenom.ffwll.local>
Mail-Followup-To: Thomas Hellstrom <thellstrom@vmware.com>,
	Maarten Lankhorst <maarten.lankhorst@canonical.com>,
	sumit.semwal@linaro.org, rob.clark@linaro.org, jakob@vmware.com,
	linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
References: <20120810145728.5490.44707.stgit@patser.local>
 <20120810145804.5490.14858.stgit@patser.local>
 <20120815231246.GI5533@phenom.ffwll.local>
 <5034C77C.9050501@canonical.com>
 <5034D5FA.9000607@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5034D5FA.9000607@vmware.com>
X-Operating-System: Linux phenom 3.4.0-rc3+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 02:52:10PM +0200, Thomas Hellstrom wrote:
> Hi, Maarten,
> please see some comments inline.
> 
> On 08/22/2012 01:50 PM, Maarten Lankhorst wrote:
> >Hey Dan,
> >
> >Op 16-08-12 01:12, Daniel Vetter schreef:
> >>Hi Maarten,
> >>
> >>Ok, here comes the promised review (finally!), but it's rather a
> >>high-level thingy. I've mostly thought about how we could create a neat
> >>api with the following points. For a bit of clarity, I've grouped the
> >>different considerations a bit.
> >><snip>
> >Thanks, I have significantly reworked the api based on your comments.
> >
> >Documentation is currently lacking, and will get updated again for the final version.
> >
> >Full patch series also includes some ttm changes to make use of dma-reservation,
> >with the intention of moving out fencing from ttm too, but that requires more work.
> >
> >For the full series see:
> >http://cgit.freedesktop.org/~mlankhorst/linux/log/?h=v10-wip
> >
> >My plan is to add a pointer for dma_reservation to a dma-buf,
> >so all users of dma-reservation can perform reservations across
> >multiple devices as well. Since the default for ttm likely will
> >mean only a few buffers are shared I didn't want to complicate
> >the abi for ttm much further so only added a pointer that can be
> >null to use ttm's reservation_object structure.
> >
> >The major difference with ttm is that each reservation object
> >gets its own lock for fencing and reservations, but they can
> >be merged:
> 
> TTM previously had a lock on each buffer object which protected
> sync_obj and sync_obj_arg, however
> when fencing multiple buffers, say 100 buffers or so in a single
> command submission, it meant 100
> locks / unlocks that weren't really necessary, since just updating
> the sync_obj and sync_obj_arg members
> is a pretty quick operation, whereas locking may be a pretty slow
> operation, so those locks were removed
> for efficiency.
> The reason a single lock (the lru lock) is used to protect
> reservation is that a TTM object that is being reserved
> *atomically* needs to be taken off LRU lists, since processes
> performing LRU eviction don't take a ticket
> when evicting, and may thus cause deadlocks; It might be possible to
> fix this within TTM by requiring a ticket
> for all reservation, but then that ticket needs to be passed down
> the call chain for all functions that may perform
> a reservation. It would perhaps be simpler (but perhaps not so fair)
> to use the current thread info pointer as a ticket
> sequence number.

While discussing this stuff with Maarten I've read through the generic
mutex code, and I think we could adapt the ideas from in there (which
would boil down to a single atomice op for the fastpath for both reserve
and unreserve, which even have per-arch optimized asm). So I think we can
make the per-obj lock as fast as it's possible, since the current ttm
fences already use that atomic op.

For passing the reservation_ticket down the callstacks I guess with a
common reservation systems used for shared buffers (which is the idea
here) we can make a good case to add a pointer to the current thread info.
Especially for cross-device reservations through dma_buf I think that
would simplify the interfaces quite a bit.

Wrt the dma_ prefix I agree it's not a stellar name, but since the
intention is to use this together with dma_buf and dma_fence to faciliate
cross-device madness it does fit somewhat ...

Fyi I hopefully get around to play with Maarten's patches a bit, too. One
of the things I'd like to add to the current reservation framework is
lockdep annotations. Since if we use this across devices it's way too easy
to nest reservations improperly, or to create deadlocks because one thread
grabs another lock while holding reservations, while another tries to
reserve buffers while holding that lock.

> >spin_lock(obj->resv) __dma_object_reserve() grab a ref to all
> >obj->fences spin_unlock(obj->resv)
> >
> >spin_lock(obj->resv) assign new fence to obj->fences
> >__dma_object_unreserve() spin_unlock(obj->resv)
> >
> >There's only one thing about fences I haven't been able to map yet
> >properly. vmwgfx has sync_obj_flush, but as far as I can tell it has
> >not much to do with sync objects, but is rather a generic 'flush before
> >release'. Maybe one of the vmwgfx devs could confirm whether that call
> >is really needed there? And if so, if there could be some other way do
> >that, because it seems to be the ttm_bo_wait call before that would be
> >enough, if not it might help more to move the flush to some other call.
> 
> The fence flush should be interpreted as an operation for fencing
> mechanisms that aren't otherwise required to signal in finite time, and
> where the time from flush to signal might be substantial. TTM is then
> supposed to issue a fence flush when it knows ahead of time that it will
> soon perform a periodical poll for a buffer to be idle, but not block
> waiting for the buffer to be idle. The delayed buffer delete mechanism
> is, I think, the only user currently.  For hardware that always signal
> fences immediately, the flush mechanism is not needed.

Hm, atm we only call back to the driver for dma_fences when adding a
callback (or waiting for the fence in a blocking fashion). I guess we
could add another interface that just does this call, without adding any
callback - as a heads-up of sorts for drivers where making a fence signal
in time is expensive and/or should be done as early as possible if timely
signaling is required.
-Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
