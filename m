Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933520Ab2GKXt6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 19:49:58 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:45728 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754065Ab2GKXt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 19:49:56 -0400
Message-ID: <4FFE1120.4060408@gmail.com>
Date: Thu, 12 Jul 2012 01:49:52 +0200
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Rob Clark <rob.clark@linaro.org>
CC: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, sumit.semwal@linaro.org,
        daniel.vetter@ffwll.ch, Rob Clark <rob@ti.com>
Subject: Re: [PATCH] dma-fence: dma-buf synchronization
References: <1342045781-29351-1-git-send-email-rob.clark@linaro.org>
In-Reply-To: <1342045781-29351-1-git-send-email-rob.clark@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 12-07-12 00:29, Rob Clark schreef:
> From: Rob Clark <rob@ti.com>
>
> A dma-fence can be attached to a buffer which is being filled or consumed
> by hw, to allow userspace to pass the buffer without waiting to another
> device.  For example, userspace can call page_flip ioctl to display the
> next frame of graphics after kicking the GPU but while the GPU is still
> rendering.  The display device sharing the buffer with the GPU would
> attach a callback to get notified when the GPU's rendering-complete IRQ
> fires, to update the scan-out address of the display, without having to
> wake up userspace.
>
> A dma-fence is transient, one-shot deal.  It is allocated and attached
> to dma-buf's list of fences.  When the one that attached it is done,
> with the pending operation, it can signal the fence removing it from the
> dma-buf's list of fences:
>
>   + dma_buf_attach_fence()
>   + dma_fence_signal()
>
> Other drivers can access the current fence on the dma-buf (if any),
> which increment's the fences refcnt:
>
>   + dma_buf_get_fence()
>   + dma_fence_put()
>
> The one pending on the fence can add an async callback (and optionally
> cancel it.. for example, to recover from GPU hangs):
>
>   + dma_fence_add_callback()
>   + dma_fence_cancel_callback()
>
> Or wait synchronously (optionally with timeout or from atomic context):
>
>   + dma_fence_wait()
Waiting for an undefined time from atomic context is probably
not a good idea. However just checking non-blocking if the fence
has passed would be fine.
> A default software-only implementation is provided, which can be used
> by drivers attaching a fence to a buffer when they have no other means
> for hw sync.  But a memory backed fence is also envisioned, because it
> is common that GPU's can write to, or poll on some memory location for
> synchronization.  For example:
>
>   fence = dma_buf_get_fence(dmabuf);
>   if (fence->ops == &mem_dma_fence_ops) {
>     dma_buf *fence_buf;
>     mem_dma_fence_get_buf(fence, &fence_buf, &offset);
>     ... tell the hw the memory location to wait on ...
>   } else {
>     /* fall-back to sw sync * /
>     dma_fence_add_callback(fence, my_cb);
>   }
This will probably have to be done on dma-buf attach time instead,
so drivers that support both know if an interrupt needs to be inserted
in the command stream or not.

> The memory location is itself backed by dma-buf, to simplify mapping
> to the device's address space, an idea borrowed from Maarten Lankhorst.
>
> NOTE: the memory location fence is not implemented yet, the above is
> just for explaining how it would work.
>
> On SoC platforms, if some other hw mechanism is provided for synchronizing
> between IP blocks, it could be supported as an alternate implementation
> with it's own fence ops in a similar way.
>
> The other non-sw implementations would wrap the add/cancel_callback and
> wait fence ops, so that they can keep track if a device not supporting
> hw sync is waiting on the fence, and in this case should arrange to
Standardizing an errno in case the device already signalled the fence
would be nice.
> call dma_fence_signal() at some point after the condition has changed,
> to notify other devices waiting on the fence.  If there are no sw
> waiters, this can be skipped to avoid waking the CPU unnecessarily.
Can this be done inside interrupt context? I could insert some
semaphores into intel that would block execution, but I would
save a context switch if intel could release the command blocking
from inside irq context.

> The intention is to provide a userspace interface (presumably via eventfd)
> later, to be used in conjunction with dma-buf's mmap support for sw access
> to buffers (or for userspace apps that would prefer to do their own
> synchronization).
I'll have to look at this more in the morning but I see no barrier for
this being used with dmabufmgr right now.

The fence lock should probably not be static but shared with the
dmabufmgr code, with _locked variants.
Oh and in your example code I noticed inconsistent use of spin_lock
and spin_lock_irqsave, do you intend it to be used in hardirq context?

~Maarten

