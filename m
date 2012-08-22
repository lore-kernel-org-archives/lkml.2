Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932442Ab2HVM6p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 08:58:45 -0400
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:35901 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752374Ab2HVM6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 08:58:40 -0400
X-Greylist: delayed 384 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Aug 2012 08:58:40 EDT
Message-ID: <5034D5FA.9000607@vmware.com>
Date: Wed, 22 Aug 2012 14:52:10 +0200
From: Thomas Hellstrom <thellstrom@vmware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
CC: sumit.semwal@linaro.org, rob.clark@linaro.org,
        Daniel Vetter <daniel@ffwll.ch>, jakob@vmware.com,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Subject: Re: [RFC patch 4/4] Re: dma-buf-mgr: multiple dma-buf synchronization
 (v3)
References: <20120810145728.5490.44707.stgit@patser.local> <20120810145804.5490.14858.stgit@patser.local> <20120815231246.GI5533@phenom.ffwll.local> <5034C77C.9050501@canonical.com>
In-Reply-To: <5034C77C.9050501@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Maarten,
please see some comments inline.

On 08/22/2012 01:50 PM, Maarten Lankhorst wrote:
> Hey Dan,
>
> Op 16-08-12 01:12, Daniel Vetter schreef:
>> Hi Maarten,
>>
>> Ok, here comes the promised review (finally!), but it's rather a
>> high-level thingy. I've mostly thought about how we could create a neat
>> api with the following points. For a bit of clarity, I've grouped the
>> different considerations a bit.
>> <snip>
> Thanks, I have significantly reworked the api based on your comments.
>
> Documentation is currently lacking, and will get updated again for the final version.
>
> Full patch series also includes some ttm changes to make use of dma-reservation,
> with the intention of moving out fencing from ttm too, but that requires more work.
>
> For the full series see:
> http://cgit.freedesktop.org/~mlankhorst/linux/log/?h=v10-wip
>
> My plan is to add a pointer for dma_reservation to a dma-buf,
> so all users of dma-reservation can perform reservations across
> multiple devices as well. Since the default for ttm likely will
> mean only a few buffers are shared I didn't want to complicate
> the abi for ttm much further so only added a pointer that can be
> null to use ttm's reservation_object structure.
>
> The major difference with ttm is that each reservation object
> gets its own lock for fencing and reservations, but they can
> be merged:

TTM previously had a lock on each buffer object which protected sync_obj 
and sync_obj_arg, however
when fencing multiple buffers, say 100 buffers or so in a single command 
submission, it meant 100
locks / unlocks that weren't really necessary, since just updating the 
sync_obj and sync_obj_arg members
is a pretty quick operation, whereas locking may be a pretty slow 
operation, so those locks were removed
for efficiency.
The reason a single lock (the lru lock) is used to protect reservation 
is that a TTM object that is being reserved
*atomically* needs to be taken off LRU lists, since processes performing 
LRU eviction don't take a ticket
when evicting, and may thus cause deadlocks; It might be possible to fix 
this within TTM by requiring a ticket
for all reservation, but then that ticket needs to be passed down the 
call chain for all functions that may perform
a reservation. It would perhaps be simpler (but perhaps not so fair) to 
use the current thread info pointer as a ticket
sequence number.

> spin_lock(obj->resv)
> __dma_object_reserve()
> grab a ref to all obj->fences
> spin_unlock(obj->resv)
>
> spin_lock(obj->resv)
> assign new fence to obj->fences
> __dma_object_unreserve()
> spin_unlock(obj->resv)
>
> There's only one thing about fences I haven't been able to map
> yet properly. vmwgfx has sync_obj_flush, but as far as I can
> tell it has not much to do with sync objects, but is rather a
> generic 'flush before release'. Maybe one of the vmwgfx devs
> could confirm whether that call is really needed there? And if
> so, if there could be some other way do that, because it seems
> to be the ttm_bo_wait call before that would be enough, if not
> it might help more to move the flush to some other call.

The fence flush should be interpreted as an operation for fencing 
mechanisms that aren't otherwise required to
signal in finite time, and where the time from flush to signal might be 
substantial. TTM is then supposed to
issue a fence flush when it knows ahead of time that it will soon 
perform a periodical poll for a buffer to be
idle, but not block waiting for the buffer to be idle. The delayed 
buffer delete mechanism is, I think, the only user
currently.
For hardware that always signal fences immediately, the flush mechanism 
is not needed.

>
> PS: For ttm devs some of the code may look familiar, I don't know
> if the kernel accepts I-told-you-so tag or not, but if it does
> you might want to add them now. :-)
>
> PPS: I'm aware that I still need to add a signaled op to fences
>
> diff --git a/Documentation/DocBook/device-drivers.tmpl b/Documentation/DocBook/device-drivers.tmpl
> index 030f705..7da9637 100644
> --- a/Documentation/DocBook/device-drivers.tmpl
> +++ b/Documentation/DocBook/device-drivers.tmpl
> @@ -129,6 +129,8 @@ X!Edrivers/base/interface.c
>   !Edrivers/base/dma-fence.c
>   !Iinclude/linux/dma-fence.h
>   !Iinclude/linux/dma-seqno-fence.h
> +!Edrivers/base/dma-reservation.c
> +!Iinclude/linux/dma-reservation.h
>   !Edrivers/base/dma-coherent.c
>   !Edrivers/base/dma-mapping.c
>        </sect1>
> diff --git a/drivers/base/Makefile b/drivers/base/Makefile
> index 6e9f217..b26e639 100644
> --- a/drivers/base/Makefile
> +++ b/drivers/base/Makefile
> @@ -10,7 +10,7 @@ obj-$(CONFIG_CMA) += dma-contiguous.o
>   obj-y			+= power/
>   obj-$(CONFIG_HAS_DMA)	+= dma-mapping.o
>   obj-$(CONFIG_HAVE_GENERIC_DMA_COHERENT) += dma-coherent.o
> -obj-$(CONFIG_DMA_SHARED_BUFFER) += dma-buf.o dma-fence.o
> +obj-$(CONFIG_DMA_SHARED_BUFFER) += dma-buf.o dma-fence.o dma-reservation.o
>   obj-$(CONFIG_ISA)	+= isa.o
>   obj-$(CONFIG_FW_LOADER)	+= firmware_class.o
>   obj-$(CONFIG_NUMA)	+= node.o
> diff --git a/drivers/base/dma-buf.c b/drivers/base/dma-buf.c
> index 24e88fe..3c84ead 100644
> --- a/drivers/base/dma-buf.c
> +++ b/drivers/base/dma-buf.c
> @@ -25,8 +25,10 @@
>   #include <linux/fs.h>
>   #include <linux/slab.h>
>   #include <linux/dma-buf.h>
> +#include <linux/dma-fence.h>
>   #include <linux/anon_inodes.h>
>   #include <linux/export.h>
> +#include <linux/dma-reservation.h>
>   
>   static inline int is_dma_buf_file(struct file *);
>   
> @@ -40,6 +42,9 @@ static int dma_buf_release(struct inode *inode, struct file *file)
>   	dmabuf = file->private_data;
>   
>   	dmabuf->ops->release(dmabuf);
> +
> +	if (dmabuf->resv == (struct dma_reservation_object*)&dmabuf[1])
> +		dma_reservation_object_fini(dmabuf->resv);
>   	kfree(dmabuf);
>   	return 0;
>   }
> @@ -94,6 +99,8 @@ struct dma_buf *dma_buf_export(void *priv, const struct dma_buf_ops *ops,
>   {
>   	struct dma_buf *dmabuf;
>   	struct file *file;
> +	size_t alloc_size = sizeof(struct dma_buf);
> +	alloc_size += sizeof(struct dma_reservation_object);
>   
>   	if (WARN_ON(!priv || !ops
>   			  || !ops->map_dma_buf
> @@ -105,13 +112,15 @@ struct dma_buf *dma_buf_export(void *priv, const struct dma_buf_ops *ops,
>   		return ERR_PTR(-EINVAL);
>   	}
>   
> -	dmabuf = kzalloc(sizeof(struct dma_buf), GFP_KERNEL);
> +	dmabuf = kzalloc(alloc_size, GFP_KERNEL);
>   	if (dmabuf == NULL)
>   		return ERR_PTR(-ENOMEM);
>   
>   	dmabuf->priv = priv;
>   	dmabuf->ops = ops;
>   	dmabuf->size = size;
> +	dmabuf->resv = (struct dma_reservation_object*)&dmabuf[1];
> +	dma_reservation_object_init(dmabuf->resv);
>   
>   	file = anon_inode_getfile("dmabuf", &dma_buf_fops, dmabuf, flags);
>   
> diff --git a/drivers/base/dma-reservation.c b/drivers/base/dma-reservation.c
> new file mode 100644
> index 0000000..e7cf4fa
> --- /dev/null
> +++ b/drivers/base/dma-reservation.c
> @@ -0,0 +1,321 @@
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
> +#include <linux/dma-fence.h>
> +#include <linux/dma-reservation.h>
> +#include <linux/export.h>
> +#include <linux/sched.h>
> +#include <linux/slab.h>
> +
> +atomic64_t dma_reservation_counter = ATOMIC64_INIT(0);
> +EXPORT_SYMBOL_GPL(dma_reservation_counter);
> +
> +int
> +__dma_object_reserve(struct dma_reservation_object *obj, bool intr,
> +		     bool no_wait, dma_reservation_ticket_t *ticket)
> +{
> +	int ret;
> +	u64 sequence = ticket ? ticket->seqno : 0;
> +
> +	while (unlikely(atomic_cmpxchg(&obj->reserved, 0, 1) != 0)) {
> +		/**
> +		 * Deadlock avoidance for multi-dmabuf reserving.
> +		 */
> +		if (sequence && obj->sequence) {
> +			/**
> +			 * We've already reserved this one.
> +			 */
> +			if (unlikely(sequence == obj->sequence))
> +				return -EDEADLK;
> +			/**
> +			 * Already reserved by a thread that will not back
> +			 * off for us. We need to back off.
> +			 */
> +			if (unlikely(sequence - obj->sequence < (1ULL << 63)))
> +				return -EAGAIN;
> +		}
> +
> +		if (no_wait)
> +			return -EBUSY;
> +
> +		spin_unlock(&obj->lock);
> +		ret = dma_object_wait_unreserved(obj, intr);
> +		spin_lock(&obj->lock);
> +
> +		if (unlikely(ret))
> +			return ret;
> +	}
> +
> +	/**
> +	 * Wake up waiters that may need to recheck for deadlock,
> +	 * if we decreased the sequence number.
> +	 */
> +	if (sequence && unlikely((obj->sequence - sequence < (1ULL << 63)) ||
> +	    !obj->sequence))
> +		wake_up_all(&obj->event_queue);
> +
> +	obj->sequence = sequence;
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(__dma_object_reserve);

Since this function and the corresponding unreserve is exported, it 
should probably be
documented (this holds for TTM as well) that they need memory barriers 
to protect
data, since IIRC the linux atomic_xxx operations do not necessarily 
order memory
reads and writes. For the corresponding unlocked dma_object_reserve and
dma_object_unreserve, the spinlocks should take care of that.


/Thomas

