Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758471Ab2GLAVY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 20:21:24 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:60815 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755804Ab2GLAVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 20:21:23 -0400
MIME-Version: 1.0
In-Reply-To: <4FFE1120.4060408@gmail.com>
References: <1342045781-29351-1-git-send-email-rob.clark@linaro.org>
	<4FFE1120.4060408@gmail.com>
Date: Wed, 11 Jul 2012 19:21:22 -0500
X-Google-Sender-Auth: ocgiC0H7p9kxSKBWVtVhjmsC2Gs
Message-ID: <CAF6AEGvfTNiaHTmtn4BGv=xa6-xxg4HYV-8a2hrSbj29rby0PQ@mail.gmail.com>
Subject: Re: [PATCH] dma-fence: dma-buf synchronization
From: Rob Clark <rob.clark@linaro.org>
To: Maarten Lankhorst <m.b.lankhorst@gmail.com>
Cc: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, sumit.semwal@linaro.org,
        daniel.vetter@ffwll.ch
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2012 at 6:49 PM, Maarten Lankhorst
<m.b.lankhorst@gmail.com> wrote:
> Op 12-07-12 00:29, Rob Clark schreef:
>> From: Rob Clark <rob@ti.com>
>>
>> A dma-fence can be attached to a buffer which is being filled or consumed
>> by hw, to allow userspace to pass the buffer without waiting to another
>> device.  For example, userspace can call page_flip ioctl to display the
>> next frame of graphics after kicking the GPU but while the GPU is still
>> rendering.  The display device sharing the buffer with the GPU would
>> attach a callback to get notified when the GPU's rendering-complete IRQ
>> fires, to update the scan-out address of the display, without having to
>> wake up userspace.
>>
>> A dma-fence is transient, one-shot deal.  It is allocated and attached
>> to dma-buf's list of fences.  When the one that attached it is done,
>> with the pending operation, it can signal the fence removing it from the
>> dma-buf's list of fences:
>>
>>   + dma_buf_attach_fence()
>>   + dma_fence_signal()
>>
>> Other drivers can access the current fence on the dma-buf (if any),
>> which increment's the fences refcnt:
>>
>>   + dma_buf_get_fence()
>>   + dma_fence_put()
>>
>> The one pending on the fence can add an async callback (and optionally
>> cancel it.. for example, to recover from GPU hangs):
>>
>>   + dma_fence_add_callback()
>>   + dma_fence_cancel_callback()
>>
>> Or wait synchronously (optionally with timeout or from atomic context):
>>
>>   + dma_fence_wait()
> Waiting for an undefined time from atomic context is probably
> not a good idea. However just checking non-blocking if the fence
> has passed would be fine.

yeah, the intention was to use short timeout or no-blocking if from
atomic ctxt, or interruptible with whatever timeout if non-atomic (for
example, to implement a CPU_PREP sort of ioctl)

>> A default software-only implementation is provided, which can be used
>> by drivers attaching a fence to a buffer when they have no other means
>> for hw sync.  But a memory backed fence is also envisioned, because it
>> is common that GPU's can write to, or poll on some memory location for
>> synchronization.  For example:
>>
>>   fence = dma_buf_get_fence(dmabuf);
>>   if (fence->ops == &mem_dma_fence_ops) {
>>     dma_buf *fence_buf;
>>     mem_dma_fence_get_buf(fence, &fence_buf, &offset);
>>     ... tell the hw the memory location to wait on ...
>>   } else {
>>     /* fall-back to sw sync * /
>>     dma_fence_add_callback(fence, my_cb);
>>   }
> This will probably have to be done on dma-buf attach time instead,
> so drivers that support both know if an interrupt needs to be inserted
> in the command stream or not.

probably a hint, ie. add a flags parameter to attach() would do the job?

>> The memory location is itself backed by dma-buf, to simplify mapping
>> to the device's address space, an idea borrowed from Maarten Lankhorst.
>>
>> NOTE: the memory location fence is not implemented yet, the above is
>> just for explaining how it would work.
>>
>> On SoC platforms, if some other hw mechanism is provided for synchronizing
>> between IP blocks, it could be supported as an alternate implementation
>> with it's own fence ops in a similar way.
>>
>> The other non-sw implementations would wrap the add/cancel_callback and
>> wait fence ops, so that they can keep track if a device not supporting
>> hw sync is waiting on the fence, and in this case should arrange to
> Standardizing an errno in case the device already signalled the fence
> would be nice.

I was just using EINVAL, but perhaps there is a better choice?

>> call dma_fence_signal() at some point after the condition has changed,
>> to notify other devices waiting on the fence.  If there are no sw
>> waiters, this can be skipped to avoid waking the CPU unnecessarily.
> Can this be done inside interrupt context? I could insert some
> semaphores into intel that would block execution, but I would
> save a context switch if intel could release the command blocking
> from inside irq context.

yeah, it was the intention that signal() could be from irq handler
directly (and that registered cb's can be called from atomic ctxt..
which is sufficient if they just have to bang a register or two,
otherwise they can schedule a worker)

>> The intention is to provide a userspace interface (presumably via eventfd)
>> later, to be used in conjunction with dma-buf's mmap support for sw access
>> to buffers (or for userspace apps that would prefer to do their own
>> synchronization).
> I'll have to look at this more in the morning but I see no barrier for
> this being used with dmabufmgr right now.
>
> The fence lock should probably not be static but shared with the
> dmabufmgr code, with _locked variants.
> Oh and in your example code I noticed inconsistent use of spin_lock
> and spin_lock_irqsave, do you intend it to be used in hardirq context?

oh, whoops, I started w/ spin_lock() an then realized I wanted
signal() from irq handlers and forgot to update all the other places
where spin_lock() was used

BR,
-R

> ~Maarten
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
