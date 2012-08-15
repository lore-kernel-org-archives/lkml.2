Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664Ab2HOXMc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 19:12:32 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:64717 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144Ab2HOXM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 19:12:27 -0400
Date: Thu, 16 Aug 2012 01:12:46 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: sumit.semwal@linaro.org, rob.clark@linaro.org,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Subject: Re: [Linaro-mm-sig] [PATCH 4/4] dma-buf-mgr: multiple dma-buf
 synchronization (v3)
Message-ID: <20120815231246.GI5533@phenom.ffwll.local>
Mail-Followup-To: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
	sumit.semwal@linaro.org, rob.clark@linaro.org,
	linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
References: <20120810145728.5490.44707.stgit@patser.local>
 <20120810145804.5490.14858.stgit@patser.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120810145804.5490.14858.stgit@patser.local>
X-Operating-System: Linux phenom 3.4.0-rc3+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maarten,

Ok, here comes the promised review (finally!), but it's rather a
high-level thingy. I've mostly thought about how we could create a neat
api with the following points. For a bit of clarity, I've grouped the
different considerations a bit.

Easy Integration
================

Where I mean integration of simple dma_buf importers that don't want to
deal with all the hassle of dma_fence (like v4l framegrabbers). Or drivers
where everything interesting needs cpu access anyway (like the udl
driver). The case with explicitly handling dma_fences and going through
the reservation dance should be the explicitly requested special cases.

I'm thinking of adding a new dma_buf_attach_special function which takes
an additional flags parameter (since we might need some other funky
extension later on ...). A new flag ASYNC_ATTACHMENT would indicate that
the driver will use this attachment with the dma_bufmgr and will use
dma_fences to sync with other drivers (which is also stored in a new flag
in the attachment struct).

To ensure we can have mixed attachments we need to ensure that all other
access (and also cpu access) sync up with any dma_fences left behind by
drivers with async attachments (think e.g. nouveau render, but both intel
and udl displaying a buffer). Note that we don't need any exclusion, but
only barriers, i.e. if anyone sneaks in other rendering while an dma
access from a synchronous client is underway, we don't need to care.

The same needs to happen for cpu access obviously.

Since both the cpu access functions (begin/end_cpu_access) and the device
access functions (which atm are on map/unmap_attachment) have a direction
attribute, we can even differentiate between read (i.e. shared) access and
write (i.e. exclusive) access. Note that the dma_fence syncing needs to
happen before we call the exporter's callbacks, otherwise any cache
flushing/invalidation the exporter does might not yet see all rendering.

Imo it would be good to split this up into a separate patch with:
- adding the dma_fence members to struct dma_buf (but with no way yet to
  set them).
- adding a quick helper to wait for fences attached to a dma_buf (either
  shared or exclusive access).
- adding the synchronous bool to the attachment struct, setting it by
  default and wiring, again with no way yet to use async attachments.
- we also need to add the dma_bufmgr_spinlock, since this is what protects
  the fences attached to a dma_buf for read access (at least that's my
  understanding).

Aside: This doesn't make too much sense since most drivers cheat and just
hang onto the attachment mapping (instead of doing map/unmap for each
access as the spec says they should ...). So there's no way actually for
drivers to /simply/ sync up. But the lack of a streaming api (i.e. setting
the coherency domain without map/unmap) is a known lack in the dma_buf
api, so I think I'll follow up with a patch to finally add this. I'm
thinking of something like

int dma_buf_sync_attachment(attachment, enum {BEGIN_DMA, END_DMA},
direction)

The BEGIN_DMA/END_DMA is just to avoid coming up with two nice names -
opposed to the normal dma api we need to differentiate explictly between
begin/end (like for cpu access), since a given importer knows only about
it's own usage (and hence we can't implictly flush the old coherency
domain when we switch to a new coherency domain). Synchronous attachments
would then simply as sync up with any dma_fences attached.

Aside 2: I think for async attachments we need to demand that all the
devices are coherent wrt each another - otherwise we need to allow that
the exporter can do some magic cache flushing in between when one device
signals a fence and everyone else receiving the update that the fence
signaled. If there is any hw out there that would require cache-flushing
at the gart level (i.e. not some caches which are known to the driver), we
should know about it ... (I seriously hope nothing is that brain-dead).

Allowing extensions
===================

Like I've said in irc discussion, I think we should aim for the eventual
goal that dma_buf objects are fully evictable. Having a deadlock-free
reservation system is a big step towards that. Afaict two things would be
missing on top of your current bufmgr:

- drivers would also need to be able to reserve their own, not-exported
  buffers (and any other resource objects) with the dma_bufmgr. But they
  don't necessarily want to use dma_fences to sync their private objects
  (for efficiency reasons). So I think it should be possible to embed the
  reservation fields (and only those) into any driver-private struct.

- We'd again need a special attachment mode (hence the flags array, not
  just a bool) to signal that the driver can cope with the exporter
  evicting a dma_buf. Exporters would be free to evict any object (or just
  gart mappings) if all the affected attachments are of the evictable type
  and all the fences attached to a dma_buf have signalled (a bit
  ineffiecent since we could wait for a different gart mapping, but
  eviction shouldn't happen often).

  On the driver-side we only need to check for errors in the
  map_attachment/sync_attachment calls indicating whether the buffer has
  been evicted and that we need to back off (i.e. unmap all
  reserved&mapped buffers thus far) to avoid a deadlock.

  Since synchronization between eviction and dma access would happen
  through dma_fence, an evictable always needs to be async, too.

  This is mostly useful on SoC where a (sometimes tiny) gart is shared by
  a few IC blocks (e.g. video codec, gpu, display block).

I don't think we need to do anything special to allow this, but I think we
should ensure that it is possible. The simplest way is to but the bufmgr
into it's own patch and extract any reservation fields from dma_buf into a
separate dma_bufmgr_object. That patch wouldn't mention dma_fences or add
dma_bufmgr_object to dma_buf, I think all that integration should happen
in the final patch to put things together.

Putting the bufmgr reservation logic into it's own patch should also make
review easier ;-)

Better encapsulation 
====================

I think we should avoid to expose clients as much as possible to bufmgr
internals - they should be able to treat it as a magic blackbox that tells
them when to back off and when they're good to go imo. Specifically I'm
thinking of

struct dma_bufmgr_reservation_ticket {
	seqno
	list_head *reservations
}

I also have a few gripes with the ttm-inspired "validation" moniker. Hence
my bikeshed proposal for
- "reservation ticket" the abstract thingy you get from bufmgr that
  denotes your place (ticket) in the global reservation queue
- and "reservation" for the book-keeping struct to reserve and object.

I think the ttm wording comes from validating whether all buffers are in
the right ttm (and moving them if needed), which (at least for dma_fence
deadlock prevention only) doesn't quite fit for the dma_bufmgr.

Another advantege of encapsulating the reservation_ticket is that we can
easily track these, e.g. a global list of all still outstanding
reservation can be used to prevent seqno wraparounds (we block for the old
reservation to unreserve the seqno). Or we could dump all reservations
into debugfs, which probably helps to diagnose deadlocks (if we add a bit
of debug infrastructure to associate reservations with driver state).

To make all this work neatly for your main use case, i.e. to reserve
dma_bufs to put dma_fences onto them we'd to add some helpers that init a
reservation from a dma buf and add the fences to all dma_bufs in a
reservation. But I think that should be in the last patch that ties up the
bufmgr with dma_buf.

Now once we have a reservation_ticket struct we can put it to some good
use:

Fat-trimming
============

Imo your validation struct contains too much stuff, and I'd like it to be
as small as possible so that drivers can quickly allocate lots of these
(if they also use them for private objects):

> +struct dmabufmgr_validate {
> +	struct list_head head;
> +	struct kref refcount;

I see the need for refcounting the validation, so that we can wait on it
without it disappearing under us. But imo it makes more sence if we
reference count the proposed reservation_ticket instead and move a few
related fields to that:
- I think we should move the waitqueue from the dma_buf object (or the
  bufmgr_object) to the reservation_ticket, too. Conceptually we only need
  to wait on the reservation to unreserve all buffers, not on individual
  buffers. The only case where waiting on the reservation_ticket is
  different from waiting on the buffer is when there's contention and a
  driver needs to back off. But in that case it's fairer for the
  reservation to complete instead of trying to snatch away the buffer.

> +
> +	bool reserved;

Afaict can tell that's only used in the reservation backoff code, I think
we can ditch this by being a bit more clever there (e.g. splice of the
list of already reserved buffers).

> +	bool shared;

We could shove this bit into bit0 of the below pointer. With some helpers
to set up the reservation, no user of the bufmgr api would notice this.

> +	struct dma_buf *bo;
> +	void *priv;

priv is imo unncessery, users can embed this struct into anything if they
need more context for reservations.

> +
> +	unsigned num_fences, num_waits;
> +	struct dma_fence *fences[DMA_BUF_MAX_SHARED_FENCE];
> +	struct dma_fence_cb wait[DMA_BUF_MAX_SHARED_FENCE];

Imo this shouldn't be part of the reservation itself:
- for fences we only need a list of the (preferrably unique) dma_fence we
  need to wait on before the batch can use all the reserved dma_bufs. And
  we only need this list to attach our own callback to it, so this list is
  (I think) only required within fence_buffers

- the callback structs are a bit more obnoxious, since we need one for
  every fence we need to wait on. And these need to be attached to a
  reference-counted struct (or we need to allocate them individually,
  which is even more wasteful).
  
  With my proposal we have two refcounted struct: reservation_ticket and
  the dma_fence we newly attach to all dma_bufs, which will signal the
  completion of the batchbuffer we are processing. Adding the callbacks to
  the reservation_ticket doesn't make any more sense (that should get
  free'd after the unreserve), but the dma_fence needs to be around until
  all old fences have signaled anyway, for before the new batch can't
  start.

So what about we adjust the flow of fence_buffers a bit:

- it walks all the buffers on the reservation_ticket, assembling a list of
  fences we need to wait on. While doing so it also puts the new fence
  into place (either shared or exclusive).
- then it allocates the cb array, storing a pointer to it into the new
  dma_fence
- for every fence it adds the callback, increment the reference count of
  the new dma_fence
- the dma_fence code needs to free the attached cb array (if there's any)
  on the final kput.

> +};

Aside: I think it'd be good to document which members are protected by
which looks. I could deduce the following locking rules:

- the fence lists in dma_fence are read-protected by dma_bufmgr_lock.
  Writing is only allowed if you also hold a valid reservation on that
  buffer.
- seqno in the reservation_ticket is immutable, the list global list of
  reservation tickets (my new proposal, handy for debuggin) is protected
  by dma_bufmgr_lock
- any other field in reservation_ticket and all fields in reservation are
  presumed to be only manipulated by one thread (the one doing the
  reservation/batchbuffer submission), additional locking is the callers
  problem (if required, would indicate some big issue though imo).

Proposed patch sequence
=======================

I.e. this is the summary of all the above blablabla:

- First a patch that integrates the dma_fence book-keeping into dma_buf,
  adds the required wait helpers and wires them up at all the right
  places.

- A patch introducing the dma reservation framework, with the 3 struct
  dma_reservation_ticket, dma_reservation and dma_reservation_item
  or whatever you're gonna call them. I think having this separate is good
  to triple-check the reservation logic in review.

- A final patch to wire things up, essentially adding a
  dma_reservation_object embedded into dma_buf and adding the
  fence_buffers function to exchange the fences, plus any other neat
  helpers (waiting on all fences of a reservation for synchronous
  fallback, stitching together the reservations list, reserve dma_bufs
  instead of reservation_objects).

btw, if you agree somewhat with my ideas, I think it'd be good to just
discuss the structs and function interfaces a bit first - otherwise I fear
you'll need to change the code way too often.

Now let's here back the your flames ;-)

Cheers, Daniel

PS: I was somehow under the impression that the reservation code has some
minimal fairness guarantee: If you try to reserve a buffer, but need to
backoff due to a potential deadlock, not later reservation_ticket can
snatch that buffer while the retry is happening. Somehow I've though ttm
would implement this, but I'm too lazy to check ;-)

In any case this is not required for the basic version - we only need a
neat interface and no deadlocks for that.

PPS: I think bikeshedding the documentation isn't useful yet, before we've
settled on an interface for the dma_bufmgr.

On Fri, Aug 10, 2012 at 04:58:06PM +0200, Maarten Lankhorst wrote:
> Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
> 
> dma-buf-mgr handles the case of reserving single or multiple dma-bufs
> while trying to prevent deadlocks from buffers being reserved
> simultaneously. For this to happen extra functions have been introduced:
> 
>   + dma_buf_reserve()
>   + dma_buf_unreserve()
>   + dma_buf_wait_unreserved()
> 
> Reserve a single buffer, optionally with a sequence to indicate this
> is part of a multi-dmabuf reservation. This function will return
> -EDEADLK and return immediately if reserving would cause a deadlock.
> In case a single buffer is being reserved, no sequence is needed,
> otherwise please use the dmabufmgr calls.
> 
> If you want to attach a exclusive dma-fence, you have to wait
> until all shared fences have signalled completion. If there are none,
> or if a shared fence has to be attached, wait until last exclusive
> fence has signalled completion.
> 
> The new fence has to be attached before unreserving the buffer,
> and in exclusive mode all previous fences will have be removed
> from the buffer, and unreffed when done with it.
> 
> dmabufmgr methods:
> 
>   + dmabufmgr_validate_init()
> This function inits a dmabufmgr_validate structure and appends
> it to the tail of the list, with refcount set to 1.
>   + dmabufmgr_validate_put()
> Convenience function to unref and free a dmabufmgr_validate
> structure. However if it's used for custom callback signalling,
> a custom function should be implemented.
> 
>   + dmabufmgr_reserve_buffers()
> This function takes a linked list of dmabufmgr_validate's, each one
> requires the following members to be set by the caller:
> - validate->head, list head
> - validate->bo, must be set to the dma-buf to reserve.
> - validate->shared, set to true if opened in shared mode.
> - validate->priv, can be used by the caller to identify this buffer.
> 
> This function will then set the following members on succesful completion:
> 
> - validate->num_fences, amount of valid fences to wait on before this
>   buffer can be accessed. This can be 0.
> - validate->fences[0...num_fences-1] fences to wait on
> 
>   + dmabufmgr_backoff_reservation()
> This can be used when the caller encounters an error between reservation
> and usage. No new fence will be attached and all reservations will be
> undone without side effects.
> 
>   + dmabufmgr_fence_buffer_objects
> Upon successful completion a new fence will have to be attached.
> This function releases old fences and attaches the new one.
> 
>   + dmabufmgr_wait_completed_cpu
> A simple cpu waiter convenience function. Waits until all fences have
> signalled completion before returning.
> 
> The rationale of refcounting dmabufmgr_validate lies in the wait
> dma_fence_cb wait member. Before calling dma_fence_add_callback
> you should increase the refcount on dmabufmgr_validate with
> dmabufmgr_validate_get, and on signal completion you should call
> kref_put(&val->refcount, custom_free_signal); after all callbacks
> have added you drop the refcount by 1 also, when refcount drops to
> 0 all callbacks have been signalled, and dmabufmgr_validate
> has been waited on and can be freed. Since this will require
> atomic spinlocks to unlink the list and signal completion, a
> deadlock could occur if you try to call add_callback otherwise,
> so the refcount is used as a means of preventing this from
> occuring by having your custom free function take a device specific
> lock, removing from list and freeing the data. The nice/evil part
> about this is that this will also guarantee no memory leaks can occur
> behind your back. This allows delays completion by moving the
> dmabufmgr_validate list to be a part of the committed reservation.
> 
> v1: Original version
> v2: Use dma-fence
> v3: Added refcounting to dmabufmgr-validate
> v4: Fixed dmabufmgr_wait_completed_cpu prototype, added more
>     documentation and added Documentation/dma-buf-synchronization.txt
> ---
>  Documentation/DocBook/device-drivers.tmpl |    2 
>  Documentation/dma-buf-synchronization.txt |  197 +++++++++++++++++++++
>  drivers/base/Makefile                     |    2 
>  drivers/base/dma-buf-mgr.c                |  277 +++++++++++++++++++++++++++++
>  drivers/base/dma-buf.c                    |  114 ++++++++++++
>  include/linux/dma-buf-mgr.h               |  121 +++++++++++++
>  include/linux/dma-buf.h                   |   24 +++
>  7 files changed, 736 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/dma-buf-synchronization.txt
>  create mode 100644 drivers/base/dma-buf-mgr.c
>  create mode 100644 include/linux/dma-buf-mgr.h
> 
> diff --git a/Documentation/DocBook/device-drivers.tmpl b/Documentation/DocBook/device-drivers.tmpl
> index 36252ac..2fc050c 100644
> --- a/Documentation/DocBook/device-drivers.tmpl
> +++ b/Documentation/DocBook/device-drivers.tmpl
> @@ -128,6 +128,8 @@ X!Edrivers/base/interface.c
>  !Edrivers/base/dma-buf.c
>  !Edrivers/base/dma-fence.c
>  !Iinclude/linux/dma-fence.h
> +!Edrivers/base/dma-buf-mgr.c
> +!Iinclude/linux/dma-buf-mgr.h
>  !Edrivers/base/dma-coherent.c
>  !Edrivers/base/dma-mapping.c
>       </sect1>
> diff --git a/Documentation/dma-buf-synchronization.txt b/Documentation/dma-buf-synchronization.txt
> new file mode 100644
> index 0000000..dd4685e
> --- /dev/null
> +++ b/Documentation/dma-buf-synchronization.txt
> @@ -0,0 +1,197 @@
> +                    DMA Buffer Synchronization API Guide
> +                    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> +
> +                            Maarten Lankhorst
> +                    <maarten.lankhorst@canonical.com>
> +                        <m.b.lankhorst@gmail.com>
> +
> +This is a followup to dma-buf-sharing.txt, which should be read first.
> +Unless you're dealing with the most simplest of cases, you're going to need
> +synchronization. This is done with the help of dma-fence and dma-buf-mgr.
> +
> +
> +dma-fence
> +---------
> +
> +dma-fence is simply a synchronization primitive used mostly by dma-buf-mgr.
> +In general, driver writers would not need to implement their own kind of
> +dma-fence, but re-use the existing types. The possibility is left open for
> +platforms which support alternate means of hardware synchronization between
> +IP blocks to provide their own implementation shared by the drivers on that
> +platform.
> +
> +The base dma-fence is sufficient for software based signaling. Ie. when the
> +signaling driver gets an irq, calls dma_fence_signal() which wakes other
> +driver(s) that are waiting for the fence to be signaled.
> +
> +But to support cases where no CPU involvement is required in the buffer
> +handoff between two devices, different fence implementations can be used. By
> +comparing the ops pointer with known ops, it is possible to see if the fence
> +you are waiting on works in a special way known to your driver, and act
> +differently based upon that. For example dma_seqno_fence allows hardware
> +waiting until the condition is met:
> +
> +    (s32)((sync_buf)[seqno_ofs] - seqno) >= 0
> +
> +But all dma-fences should have a software fallback, for the driver creating
> +the fence does not know if the driver waiting on the fence supports hardware
> +signaling.  The enable_signaling() callback is to notify the fence
> +implementation (or possibly the creator of the fence) that some other driver
> +is waiting for software notification and dma_fence_signal() must be called
> +once the fence is passed.  This could be used to enable some irq that would
> +not normally be enabled, etc, so that the CPU is woken once the fence condition
> +has arrived.
> +
> +
> +dma-buf-mgr overview
> +--------------------
> +
> +dma-buf-mgr is a reservation manager, and it is used to handle the case where
> +multiple devices want to access multiple dma-bufs in an arbitrary order, it
> +uses dma-fences for synchronization. There are 3 steps that are important here:
> +
> +1. Reservation of all dma-buf buffers with dma-buf-mgr
> +  - Create a struct dmabufmgr_validate for each one with a call to
> +    dmabufmgr_validate_init()
> +  - Reserve the list with dmabufmgr_reserve_buffers()
> +2. Queueing waits and allocating a new dma-fence
> +  - dmabufmgr_wait_completed_cpu or custom implementation.
> +    * Custom implementation can use dma_fence_wait, dma_fence_add_callback
> +      or a custom method that would depend on the fence type.
> +    * An implementation that uses dma_fence_add_callback can use the
> +      refcounting of dmabufmgr_validate to do signal completion, when
> +      the original list head is empty, all fences would have been signaled,
> +      and the command sequence can start running. This requires a custom put.
> +  - dma_fence_create, dma_seqno_fence_init or custom implementation
> +    that calls __dma_fence_init.
> +3. Committing with the new dma-fence.
> +  - dmabufmgr_fence_buffer_objects
> +  - reduce refcount of list by 1 with dmabufmgr_validate_put or custom put.
> +
> +The waits queued in step 2 don't have to be completed before commit, this
> +allows users of dma-buf-mgr to prevent stalls for as long as possible.
> +
> +
> +dma-fence operations
> +--------------------
> +
> +dma_fence_get() increments the refcount on a dma-fence by 1.
> +dma_fence_put() decrements the refcount by 1.
> +    Each dma-buf the dma-fence is attached to will also hold a reference to the
> +    dma-fence, but this can will be removed by dma-buf-mgr upon committing a
> +    reservation.
> +
> +dma_fence_ops.enable_signaling()
> +    Indicates dma_fence_signal will have to be called, any error code returned
> +    will cause the fence to be signaled. On success, if the dma_fence creator
> +    didn't already hold a refcount, it should increase the refcount, and
> +    decrease it after calling dma_fence_signal.
> +
> +dma_fence_ops.release()
> +    Can be NULL, this function allows additional commands to run on destruction
> +    of the dma_fence.
> +
> +dma_fence_signal()
> +    Signal completion for software callbacks on a dma-fence, this will unblock
> +    dma_fence_wait() calls and run all the callbacks added with
> +    dma_fence_add_callback().
> +
> +dma_fence_wait()
> +    Do a synchronous wait on this dma-fence. It is assumed the caller directly
> +    or indirectly (dma-buf-mgr between reservation and committing) holds a
> +    reference to the dma-fence, otherwise the dma-fence might be freed
> +    before return, resulting in undefined behavior.
> +
> +dma_fence_add_callback()
> +    Add a software callback to the dma-fence. Same restrictions apply to
> +    refcount as it does to dma_fence_wait, however the caller doesn't need to
> +    keep a refcount to dma-fence afterwards: when software access is enabled,
> +    the creator of the dma-fence is required to keep the fence alive until
> +    after it signals with dma_fence_signal. The callback itself can be called
> +    from irq context.
> +
> +    This function returns -EINVAL if an input parameter is NULL, or -ENOENT
> +    if the fence was already signaled.
> +
> +    *WARNING*:
> +    Cancelling a callback should only be done if you really know what you're
> +    doing, since deadlocks and race conditions could occur all too easily. For
> +    this reason, it should only ever be done on hardware lockup recovery.
> +
> +dma_fence_create()
> +    Create a software only fence, the creator must keep its reference until
> +    after it calls dma_fence_signal.
> +
> +__dma_fence_init()
> +    Initializes an allocated fence, the caller doesn't have to keep its
> +    refcount after committing with this fence, but it will need to hold a
> +    refcount again if dma_fence_ops.enable_signaling gets called. This can
> +    be used for other implementing other types of dma_fence.
> +
> +dma_seqno_fence_init()
> +    Initializes a dma_seqno_fence, the caller will need to be able to
> +    enable software completion, but it also completes when
> +    (s32)((sync_buf)[seqno_ofs] - seqno) >= 0 is true.
> +
> +    The dma_seqno_fence will take a refcount on sync_buf until it's destroyed.
> +
> +    Certain hardware have instructions to insert this type of wait condition
> +    in the command stream, so no intervention from software would be needed.
> +    This type of fence can be destroyed before completed, however a reference
> +    on the sync_buf dma-buf can be taken. It is encouraged to re-use the same
> +    dma-buf, since mapping or unmapping the sync_buf to the device's vm can be
> +    expensive.
> +
> +
> +dma-buf-mgr operations
> +----------------------
> +
> +dmabufmgr_validate_init()
> +    Initialize a struct dmabufmgr_validate for use with dmabufmgr methods, and
> +    appends it to the list.
> +
> +dmabufmgr_validate_get()
> +dmabufmgr_validate_put()
> +    Decrease or increase a reference to a dmabufmgr_validate, these are
> +    convenience functions and don't have to be used. The dmabufmgr commands
> +    below will never touch the refcount.
> +
> +dmabufmgr_reserve_buffers()
> +    Attempts to reserve a list of dmabufmgr_validate. This function does not
> +    decrease or increase refcount on dmabufmgr_validate.
> +
> +    When this command returns 0 (success), the following
> +    dmabufmgr_validate members become valid:
> +    num_fences, fences[0...num_fences)
> +
> +    The caller will have to queue waits on those fences before calling
> +    dmabufmgr_fence_buffer_objects, dma_fence_add_callback will keep
> +    the fence alive until it is signaled.
> +
> +    As such, by incrementing refcount on dmabufmgr_validate before calling
> +    dma_fence_add_callback, and making the callback decrement refcount on
> +    dmabufmgr_validate, or releasing refcount if dma_fence_add_callback
> +    failed, the dmabufmgr_validate would be freed when all the fences
> +    have been signaled, and only after the last ref is released, which should
> +    be after dmabufmgr_fence_buffer_objects. With proper locking, when the
> +    list_head holding the list of dmabufmgr_validate's becomes empty it
> +    indicates all fences for all dma-bufs have been signaled.
> +
> +dmabufmgr_backoff_reservation()
> +    Unreserves a list of dmabufmgr_validate's, after dmabufmgr_reserve_buffers
> +    was called. This function does not decrease or increase refcount on
> +    dmabufmgr_validate.
> +
> +dmabufmgr_fence_buffer_objects()
> +    Commits the list of dmabufmgr_validate's with the dma-fence specified.
> +    This should be done after dmabufmgr_reserve_buffers was called succesfully.
> +    dmabufmgr_backoff_reservation doesn't need to be called after this.
> +    This function does not decrease or increase refcount on dmabufmgr_validate.
> +
> +dmabufmgr_wait_completed_cpu()
> +    Will block until all dmabufmgr_validate's have been completed, a signal
> +    has been received, or the wait timed out. This is a convenience function
> +    to speed up initial implementations, however since this blocks
> +    synchronously this is not the best way to wait.
> +    Can be called after dmabufmgr_reserve_buffers returned, but before
> +    dmabufmgr_backoff_reservation or dmabufmgr_fence_buffer_objects.
> diff --git a/drivers/base/Makefile b/drivers/base/Makefile
> index 6e9f217..f11d40f 100644
> --- a/drivers/base/Makefile
> +++ b/drivers/base/Makefile
> @@ -10,7 +10,7 @@ obj-$(CONFIG_CMA) += dma-contiguous.o
>  obj-y			+= power/
>  obj-$(CONFIG_HAS_DMA)	+= dma-mapping.o
>  obj-$(CONFIG_HAVE_GENERIC_DMA_COHERENT) += dma-coherent.o
> -obj-$(CONFIG_DMA_SHARED_BUFFER) += dma-buf.o dma-fence.o
> +obj-$(CONFIG_DMA_SHARED_BUFFER) += dma-buf.o dma-fence.o dma-buf-mgr.o
>  obj-$(CONFIG_ISA)	+= isa.o
>  obj-$(CONFIG_FW_LOADER)	+= firmware_class.o
>  obj-$(CONFIG_NUMA)	+= node.o
> diff --git a/drivers/base/dma-buf-mgr.c b/drivers/base/dma-buf-mgr.c
> new file mode 100644
> index 0000000..899a99b
> --- /dev/null
> +++ b/drivers/base/dma-buf-mgr.c
> @@ -0,0 +1,277 @@
> +/*
> + * Copyright (C) 2012 Canonical Ltd
> + *
> + * Based on ttm_bo.c which bears the following copyright notice,
> + * but is dual licensed:
> + *
> + * Copyright (c) 2006-2009 VMware, Inc., Palo Alto, CA., USA
> + * All Rights Reserved.
> + *
> + * Permission is hereby granted, free of charge, to any person obtaining a
> + * copy of this software and associated documentation files (the
> + * "Software"), to deal in the Software without restriction, including
> + * without limitation the rights to use, copy, modify, merge, publish,
> + * distribute, sub license, and/or sell copies of the Software, and to
> + * permit persons to whom the Software is furnished to do so, subject to
> + * the following conditions:
> + *
> + * The above copyright notice and this permission notice (including the
> + * next paragraph) shall be included in all copies or substantial portions
> + * of the Software.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
> + * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
> + * FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL
> + * THE COPYRIGHT HOLDERS, AUTHORS AND/OR ITS SUPPLIERS BE LIABLE FOR ANY CLAIM,
> + * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
> + * OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
> + * USE OR OTHER DEALINGS IN THE SOFTWARE.
> + *
> + **************************************************************************/
> +/*
> + * Authors: Thomas Hellstrom <thellstrom-at-vmware-dot-com>
> + */
> +
> +
> +#include <linux/dma-buf-mgr.h>
> +#include <linux/export.h>
> +#include <linux/sched.h>
> +#include <linux/slab.h>
> +
> +static void dmabufmgr_backoff_reservation_locked(struct list_head *list)
> +{
> +	struct dmabufmgr_validate *entry;
> +
> +	list_for_each_entry(entry, list, head) {
> +		struct dma_buf *bo = entry->bo;
> +		if (!entry->reserved)
> +			continue;
> +		entry->reserved = false;
> +
> +		entry->num_fences = 0;
> +
> +		atomic_set(&bo->reserved, 0);
> +		wake_up_all(&bo->event_queue);
> +	}
> +}
> +
> +static int
> +dmabufmgr_wait_unreserved_locked(struct list_head *list,
> +				    struct dma_buf *bo)
> +{
> +	int ret;
> +
> +	spin_unlock(&dma_buf_reserve_lock);
> +	ret = dma_buf_wait_unreserved(bo, true);
> +	spin_lock(&dma_buf_reserve_lock);
> +	if (unlikely(ret != 0))
> +		dmabufmgr_backoff_reservation_locked(list);
> +	return ret;
> +}
> +
> +/**
> + * dmabufmgr_backoff_reservation - cancel a reservation
> + * @list:	[in]	a linked list of struct dmabufmgr_validate
> + *
> + * This function cancels a previous reservation done by
> + * dmabufmgr_reserve_buffers. This is useful in case something
> + * goes wrong between reservation and committing.
> + *
> + * Please read Documentation/dma-buf-synchronization.txt
> + */
> +void
> +dmabufmgr_backoff_reservation(struct list_head *list)
> +{
> +	if (list_empty(list))
> +		return;
> +
> +	spin_lock(&dma_buf_reserve_lock);
> +	dmabufmgr_backoff_reservation_locked(list);
> +	spin_unlock(&dma_buf_reserve_lock);
> +}
> +EXPORT_SYMBOL_GPL(dmabufmgr_backoff_reservation);
> +
> +/**
> + * dmabufmgr_reserve_buffers - reserve a list of dmabufmgr_validate
> + * @list:	[in]	a linked list of struct dmabufmgr_validate
> + *
> + * Please read Documentation/dma-buf-synchronization.txt
> + */
> +int
> +dmabufmgr_reserve_buffers(struct list_head *list)
> +{
> +	struct dmabufmgr_validate *entry;
> +	int ret;
> +	u32 val_seq;
> +
> +	if (list_empty(list))
> +		return 0;
> +
> +	list_for_each_entry(entry, list, head) {
> +		entry->reserved = false;
> +		entry->num_fences = 0;
> +	}
> +
> +retry:
> +	spin_lock(&dma_buf_reserve_lock);
> +	val_seq = atomic_inc_return(&dma_buf_reserve_counter);
> +
> +	list_for_each_entry(entry, list, head) {
> +		struct dma_buf *bo = entry->bo;
> +
> +retry_this_bo:
> +		ret = dma_buf_reserve_locked(bo, true, true, true, val_seq);
> +		switch (ret) {
> +		case 0:
> +			break;
> +		case -EBUSY:
> +			ret = dmabufmgr_wait_unreserved_locked(list, bo);
> +			if (unlikely(ret != 0)) {
> +				spin_unlock(&dma_buf_reserve_lock);
> +				return ret;
> +			}
> +			goto retry_this_bo;
> +		case -EAGAIN:
> +			dmabufmgr_backoff_reservation_locked(list);
> +			spin_unlock(&dma_buf_reserve_lock);
> +			ret = dma_buf_wait_unreserved(bo, true);
> +			if (unlikely(ret != 0))
> +				return ret;
> +			goto retry;
> +		default:
> +			dmabufmgr_backoff_reservation_locked(list);
> +			spin_unlock(&dma_buf_reserve_lock);
> +			return ret;
> +		}
> +
> +		entry->reserved = true;
> +
> +		if (entry->shared &&
> +		    bo->fence_shared_count == DMA_BUF_MAX_SHARED_FENCE) {
> +			WARN_ON_ONCE(1);
> +			dmabufmgr_backoff_reservation_locked(list);
> +			spin_unlock(&dma_buf_reserve_lock);
> +			return -EINVAL;
> +		}
> +
> +		if (!entry->shared && bo->fence_shared_count) {
> +			entry->num_fences = bo->fence_shared_count;
> +
> +			BUILD_BUG_ON(sizeof(entry->fences) !=
> +				     sizeof(bo->fence_shared));
> +
> +			memcpy(entry->fences, bo->fence_shared,
> +			       sizeof(bo->fence_shared));
> +		} else if (bo->fence_excl) {
> +			entry->num_fences = 1;
> +			entry->fences[0] = bo->fence_excl;
> +		} else
> +			entry->num_fences = 0;
> +	}
> +	spin_unlock(&dma_buf_reserve_lock);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(dmabufmgr_reserve_buffers);
> +
> +/**
> + * dmabufmgr_wait_completed_cpu - wait synchronously for completion on cpu
> + * @list:	[in]	a linked list of struct dmabufmgr_validate
> + * @intr:	[in]	perform an interruptible wait
> + * @timeout:	[in]	absolute timeout in jiffies
> + *
> + * Since this function waits synchronously it is meant mostly for cases where
> + * stalling is unimportant, or to speed up initial implementations.
> + */
> +int
> +dmabufmgr_wait_completed_cpu(struct list_head *list, bool intr,
> +			     unsigned long timeout)
> +{
> +	struct dmabufmgr_validate *entry;
> +	int i, ret = 0;
> +
> +	list_for_each_entry(entry, list, head) {
> +		for (i = 0; i < entry->num_fences && !ret; i++)
> +			ret = dma_fence_wait(entry->fences[i], intr, timeout);
> +
> +		if (ret && ret != -ERESTARTSYS)
> +			pr_err("waiting returns %i\n", ret);
> +		if (ret)
> +			return ret;
> +	}
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(dmabufmgr_wait_completed_cpu);
> +
> +/**
> + * dmabufmgr_fence_buffer_objects - commit a reservation with a new fence
> + * @fence:	[in]	the fence that indicates completion
> + * @list:	[in]	a linked list of struct dmabufmgr_validate
> + *
> + * This function should be called after a hardware command submission is
> + * completed succesfully. The fence is used to indicate completion of
> + * those commands.
> + *
> + * Please read Documentation/dma-buf-synchronization.txt
> + */
> +void
> +dmabufmgr_fence_buffer_objects(struct dma_fence *fence, struct list_head *list)
> +{
> +	struct dmabufmgr_validate *entry;
> +	struct dma_buf *bo;
> +
> +	if (list_empty(list) || WARN_ON(!fence))
> +		return;
> +
> +	/* Until deferred fput hits mainline, release old things here */
> +	list_for_each_entry(entry, list, head) {
> +		bo = entry->bo;
> +
> +		if (!entry->shared) {
> +			int i;
> +			for (i = 0; i < bo->fence_shared_count; ++i) {
> +				dma_fence_put(bo->fence_shared[i]);
> +				bo->fence_shared[i] = NULL;
> +			}
> +			bo->fence_shared_count = 0;
> +			if (bo->fence_excl) {
> +				dma_fence_put(bo->fence_excl);
> +				bo->fence_excl = NULL;
> +			}
> +		}
> +
> +		entry->reserved = false;
> +	}
> +
> +	spin_lock(&dma_buf_reserve_lock);
> +
> +	list_for_each_entry(entry, list, head) {
> +		bo = entry->bo;
> +
> +		dma_fence_get(fence);
> +		if (entry->shared)
> +			bo->fence_shared[bo->fence_shared_count++] = fence;
> +		else
> +			bo->fence_excl = fence;
> +
> +		dma_buf_unreserve_locked(bo);
> +	}
> +
> +	spin_unlock(&dma_buf_reserve_lock);
> +}
> +EXPORT_SYMBOL_GPL(dmabufmgr_fence_buffer_objects);
> +
> +/**
> + * dmabufmgr_validate_free - simple free function for dmabufmgr_validate
> + * @ref:	[in]	pointer to dmabufmgr_validate::refcount to free
> + *
> + * Can be called when refcount drops to 0, but isn't required to be used.
> + */
> +void dmabufmgr_validate_free(struct kref *ref)
> +{
> +	struct dmabufmgr_validate *val;
> +	val = container_of(ref, struct dmabufmgr_validate, refcount);
> +	list_del(&val->head);
> +	kfree(val);
> +}
> +EXPORT_SYMBOL_GPL(dmabufmgr_validate_free);
> diff --git a/drivers/base/dma-buf.c b/drivers/base/dma-buf.c
> index 24e88fe..a19a518 100644
> --- a/drivers/base/dma-buf.c
> +++ b/drivers/base/dma-buf.c
> @@ -25,14 +25,20 @@
>  #include <linux/fs.h>
>  #include <linux/slab.h>
>  #include <linux/dma-buf.h>
> +#include <linux/dma-fence.h>
>  #include <linux/anon_inodes.h>
>  #include <linux/export.h>
> +#include <linux/sched.h>
> +
> +atomic_t dma_buf_reserve_counter = ATOMIC_INIT(1);
> +DEFINE_SPINLOCK(dma_buf_reserve_lock);
>  
>  static inline int is_dma_buf_file(struct file *);
>  
>  static int dma_buf_release(struct inode *inode, struct file *file)
>  {
>  	struct dma_buf *dmabuf;
> +	int i;
>  
>  	if (!is_dma_buf_file(file))
>  		return -EINVAL;
> @@ -40,6 +46,15 @@ static int dma_buf_release(struct inode *inode, struct file *file)
>  	dmabuf = file->private_data;
>  
>  	dmabuf->ops->release(dmabuf);
> +
> +	BUG_ON(waitqueue_active(&dmabuf->event_queue));
> +	BUG_ON(atomic_read(&dmabuf->reserved));
> +
> +	if (dmabuf->fence_excl)
> +		dma_fence_put(dmabuf->fence_excl);
> +	for (i = 0; i < dmabuf->fence_shared_count; ++i)
> +		dma_fence_put(dmabuf->fence_shared[i]);
> +
>  	kfree(dmabuf);
>  	return 0;
>  }
> @@ -119,6 +134,7 @@ struct dma_buf *dma_buf_export(void *priv, const struct dma_buf_ops *ops,
>  
>  	mutex_init(&dmabuf->lock);
>  	INIT_LIST_HEAD(&dmabuf->attachments);
> +	init_waitqueue_head(&dmabuf->event_queue);
>  
>  	return dmabuf;
>  }
> @@ -503,3 +519,101 @@ void dma_buf_vunmap(struct dma_buf *dmabuf, void *vaddr)
>  		dmabuf->ops->vunmap(dmabuf, vaddr);
>  }
>  EXPORT_SYMBOL_GPL(dma_buf_vunmap);
> +
> +int
> +dma_buf_reserve_locked(struct dma_buf *dmabuf, bool interruptible,
> +		       bool no_wait, bool use_sequence, u32 sequence)
> +{
> +	int ret;
> +
> +	while (unlikely(atomic_cmpxchg(&dmabuf->reserved, 0, 1) != 0)) {
> +		/**
> +		 * Deadlock avoidance for multi-dmabuf reserving.
> +		 */
> +		if (use_sequence && dmabuf->seq_valid) {
> +			/**
> +			 * We've already reserved this one.
> +			 */
> +			if (unlikely(sequence == dmabuf->val_seq))
> +				return -EDEADLK;
> +			/**
> +			 * Already reserved by a thread that will not back
> +			 * off for us. We need to back off.
> +			 */
> +			if (unlikely(sequence - dmabuf->val_seq < (1 << 31)))
> +				return -EAGAIN;
> +		}
> +
> +		if (no_wait)
> +			return -EBUSY;
> +
> +		spin_unlock(&dma_buf_reserve_lock);
> +		ret = dma_buf_wait_unreserved(dmabuf, interruptible);
> +		spin_lock(&dma_buf_reserve_lock);
> +
> +		if (unlikely(ret))
> +			return ret;
> +	}
> +
> +	if (use_sequence) {
> +		/**
> +		 * Wake up waiters that may need to recheck for deadlock,
> +		 * if we decreased the sequence number.
> +		 */
> +		if (unlikely((dmabuf->val_seq - sequence < (1 << 31))
> +			     || !dmabuf->seq_valid))
> +			wake_up_all(&dmabuf->event_queue);
> +
> +		dmabuf->val_seq = sequence;
> +		dmabuf->seq_valid = true;
> +	} else {
> +		dmabuf->seq_valid = false;
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(dma_buf_reserve_locked);
> +
> +int
> +dma_buf_reserve(struct dma_buf *dmabuf, bool interruptible, bool no_wait,
> +		bool use_sequence, u32 sequence)
> +{
> +	int ret;
> +
> +	spin_lock(&dma_buf_reserve_lock);
> +	ret = dma_buf_reserve_locked(dmabuf, interruptible, no_wait,
> +				     use_sequence, sequence);
> +	spin_unlock(&dma_buf_reserve_lock);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(dma_buf_reserve);
> +
> +int
> +dma_buf_wait_unreserved(struct dma_buf *dmabuf, bool interruptible)
> +{
> +	if (interruptible) {
> +		return wait_event_interruptible(dmabuf->event_queue,
> +				atomic_read(&dmabuf->reserved) == 0);
> +	} else {
> +		wait_event(dmabuf->event_queue,
> +			   atomic_read(&dmabuf->reserved) == 0);
> +		return 0;
> +	}
> +}
> +EXPORT_SYMBOL_GPL(dma_buf_wait_unreserved);
> +
> +void dma_buf_unreserve_locked(struct dma_buf *dmabuf)
> +{
> +	atomic_set(&dmabuf->reserved, 0);
> +	wake_up_all(&dmabuf->event_queue);
> +}
> +EXPORT_SYMBOL_GPL(dma_buf_unreserve_locked);
> +
> +void dma_buf_unreserve(struct dma_buf *dmabuf)
> +{
> +	spin_lock(&dma_buf_reserve_lock);
> +	dma_buf_unreserve_locked(dmabuf);
> +	spin_unlock(&dma_buf_reserve_lock);
> +}
> +EXPORT_SYMBOL_GPL(dma_buf_unreserve);
> diff --git a/include/linux/dma-buf-mgr.h b/include/linux/dma-buf-mgr.h
> new file mode 100644
> index 0000000..df30ee4
> --- /dev/null
> +++ b/include/linux/dma-buf-mgr.h
> @@ -0,0 +1,121 @@
> +/*
> + * Header file for dma buffer sharing framework.
> + *
> + * Copyright(C) 2011 Linaro Limited. All rights reserved.
> + * Author: Sumit Semwal <sumit.semwal@ti.com>
> + *
> + * Many thanks to linaro-mm-sig list, and specially
> + * Arnd Bergmann <arnd@arndb.de>, Rob Clark <rob@ti.com> and
> + * Daniel Vetter <daniel@ffwll.ch> for their support in creation and
> + * refining of this idea.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published by
> + * the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License along with
> + * this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +#ifndef __DMA_BUF_MGR_H__
> +#define __DMA_BUF_MGR_H__
> +
> +#include <linux/dma-buf.h>
> +#include <linux/dma-fence.h>
> +#include <linux/list.h>
> +
> +/**
> + * struct dmabufmgr_validate - reservation structure for a dma-buf
> + * @head:	list entry
> + * @refcount:	refcount
> + * @reserved:	internal use: signals if reservation is succesful
> + * @shared:	whether shared or exclusive access was requested
> + * @bo:		pointer to a dma-buf to reserve
> + * @priv:	pointer to user-specific data
> + * @num_fences:	number of fences to wait on
> + * @num_waits:	amount of waits queued
> + * @fences:	fences to wait on
> + * @wait:	dma_fence_cb that can be passed to dma_fence_add_callback
> + *
> + * Based on struct ttm_validate_buffer, but unrecognisably modified.
> + * num_fences and fences are only valid after dmabufmgr_reserve_buffers
> + * is called.
> + */
> +struct dmabufmgr_validate {
> +	struct list_head head;
> +	struct kref refcount;
> +
> +	bool reserved;
> +	bool shared;
> +	struct dma_buf *bo;
> +	void *priv;
> +
> +	unsigned num_fences, num_waits;
> +	struct dma_fence *fences[DMA_BUF_MAX_SHARED_FENCE];
> +	struct dma_fence_cb wait[DMA_BUF_MAX_SHARED_FENCE];
> +};
> +
> +/**
> + * dmabufmgr_validate_init - initialize a dmabufmgr_validate struct
> + * @val:	[in]	pointer to dmabufmgr_validate
> + * @list:	[in]	pointer to list to append val to
> + * @bo:		[in]	pointer to dma-buf
> + * @priv:	[in]	pointer to user-specific data
> + * @shared:	[in]	request shared or exclusive access
> + */
> +static inline void
> +dmabufmgr_validate_init(struct dmabufmgr_validate *val,
> +			struct list_head *list, struct dma_buf *bo,
> +			void *priv, bool shared)
> +{
> +	kref_init(&val->refcount);
> +	list_add_tail(&val->head, list);
> +	val->bo = bo;
> +	val->priv = priv;
> +	val->shared = shared;
> +}
> +
> +extern void dmabufmgr_validate_free(struct kref *ref);
> +
> +/**
> + * dmabufmgr_validate_get - increase refcount on a dmabufmgr_validate
> + * @val:	[in]	pointer to dmabufmgr_validate
> + */
> +static inline struct dmabufmgr_validate *
> +dmabufmgr_validate_get(struct dmabufmgr_validate *val)
> +{
> +	kref_get(&val->refcount);
> +	return val;
> +}
> +
> +/**
> + * dmabufmgr_validate_put - decrease refcount on a dmabufmgr_validate
> + * @val:	[in]	pointer to dmabufmgr_validate
> + *
> + * Returns true if the caller removed last refcount on val,
> + * false otherwise.
> + */
> +static inline bool
> +dmabufmgr_validate_put(struct dmabufmgr_validate *val)
> +{
> +	return kref_put(&val->refcount, dmabufmgr_validate_free);
> +}
> +
> +extern int
> +dmabufmgr_reserve_buffers(struct list_head *list);
> +
> +extern void
> +dmabufmgr_backoff_reservation(struct list_head *list);
> +
> +extern void
> +dmabufmgr_fence_buffer_objects(struct dma_fence *fence, struct list_head *list);
> +
> +extern int
> +dmabufmgr_wait_completed_cpu(struct list_head *list, bool intr,
> +			     unsigned long timeout);
> +
> +#endif /* __DMA_BUF_MGR_H__ */
> diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
> index bd2e52c..8b14103 100644
> --- a/include/linux/dma-buf.h
> +++ b/include/linux/dma-buf.h
> @@ -35,6 +35,11 @@ struct device;
>  struct dma_buf;
>  struct dma_buf_attachment;
>  
> +extern atomic_t dma_buf_reserve_counter;
> +extern spinlock_t dma_buf_reserve_lock;
> +
> +#define DMA_BUF_MAX_SHARED_FENCE 8
> +
>  /**
>   * struct dma_buf_ops - operations possible on struct dma_buf
>   * @attach: [optional] allows different devices to 'attach' themselves to the
> @@ -122,6 +127,18 @@ struct dma_buf {
>  	/* mutex to serialize list manipulation and attach/detach */
>  	struct mutex lock;
>  	void *priv;
> +
> +	/** event queue for waking up when this dmabuf becomes unreserved */
> +	wait_queue_head_t event_queue;
> +
> +	atomic_t reserved;
> +
> +	/** These require dma_buf_reserve to be called before modification */
> +	bool seq_valid;
> +	u32 val_seq;
> +	struct dma_fence *fence_excl;
> +	struct dma_fence *fence_shared[DMA_BUF_MAX_SHARED_FENCE];
> +	u32 fence_shared_count;
>  };
>  
>  /**
> @@ -183,5 +200,12 @@ int dma_buf_mmap(struct dma_buf *, struct vm_area_struct *,
>  		 unsigned long);
>  void *dma_buf_vmap(struct dma_buf *);
>  void dma_buf_vunmap(struct dma_buf *, void *vaddr);
> +int dma_buf_reserve_locked(struct dma_buf *, bool intr, bool no_wait,
> +			   bool use_seq, u32 seq);
> +int dma_buf_reserve(struct dma_buf *, bool intr, bool no_wait,
> +		    bool use_seq, u32 seq);
> +int dma_buf_wait_unreserved(struct dma_buf *, bool interruptible);
> +void dma_buf_unreserve_locked(struct dma_buf *);
> +void dma_buf_unreserve(struct dma_buf *);
>  
>  #endif /* __DMA_BUF_H__ */
> 
> 
> _______________________________________________
> Linaro-mm-sig mailing list
> Linaro-mm-sig@lists.linaro.org
> http://lists.linaro.org/mailman/listinfo/linaro-mm-sig

-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
