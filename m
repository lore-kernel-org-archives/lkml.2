Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209Ab2GPKLX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 06:11:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46479 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512Ab2GPKLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 06:11:20 -0400
Message-ID: <5003E8C3.7060209@canonical.com>
Date: Mon, 16 Jul 2012 12:11:15 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Rob Clark <rob.clark@linaro.org>
CC: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, sumit.semwal@linaro.org,
        daniel.vetter@ffwll.ch, Rob Clark <rob@ti.com>
Subject: Re: [RFC] dma-fence: dma-buf synchronization (v2)
References: <1342193911-16157-1-git-send-email-rob.clark@linaro.org>
In-Reply-To: <1342193911-16157-1-git-send-email-rob.clark@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Rob,

Op 13-07-12 17:38, Rob Clark schreef:
> ...
> +/**
> + * dma_buf_attach_fence - Attach a fence to a dma-buf.
> + *
> + * @buf: the dma-buf to attach to
> + * @fence: the fence to attach
> + *
> + * A fence can only be attached to a single dma-buf.  The dma-buf takes
> + * ownership of the fence, which is unref'd when the fence is signaled.
> + * The fence takes a reference to the dma-buf so the buffer will not be
> + * freed while there is a pending fence.
> + */
> +int dma_buf_attach_fence(struct dma_buf *buf, struct dma_fence *fence)
> +{
> +	unsigned long flags;
> +	int ret = -EINVAL;
> +
> +	if (WARN_ON(!buf || !fence))
> +		return -EINVAL;
> +
> +	spin_lock_irqsave(&fence->event_queue.lock, flags);
> +	if (!fence->attached) {
> +		get_dma_buf(buf);
> +		fence->attached = true;
> +		list_add(&fence->list_node, &buf->fence_list);
> +		ret = 0;
> +	}
> +	spin_unlock_irqrestore(&fence->event_queue.lock, flags);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(dma_buf_attach_fence);
This design that a fence can only be attached to 1 dmabuf?
Wouldn't it be better to kill the fence_list and just create an array
of pointers to all the fences attached to current dmabuf?
Or some other design that would allow multiple fences to be
attached to a single dmabuf, and a single fence to multiple
dma-bufs without being attached to all and without too many
memory allocations. Maybe we should add a limit in a #define
to how many fences can be attached to a single dmabuf?
More than 4 fences on a single dma-buf is likely overkill, but I don't
want to place a limit yet on how many dma-bufs can attach to a
single fence.
> +/**
> + * dma_buf_get_fence - Get the most recent pending fence attached to the
> + * dma-buf.
> + *
> + * @buf: the dma-buf whose fence to get
> + *
> + * If this returns NULL, there are no pending fences.  Otherwise this
> + * takes a reference to the returned fence, so the caller must later
> + * call dma_fence_put() to release the reference.
> + */
> +struct dma_fence *dma_buf_get_fence(struct dma_buf *buf)
> +{
> +	struct dma_fence *fence = NULL;
> +	unsigned long flags;
> +
> +	if (WARN_ON(!buf))
> +		return ERR_PTR(-EINVAL);
> +
> +	spin_lock_irqsave(&fence->event_queue.lock, flags);
> +	if (!list_empty(&buf->fence_list)) {
> +		fence = list_first_entry(&buf->fence_list,
> +				struct dma_fence, list_node);
> +		dma_fence_get(fence);
> +	}
> +	spin_unlock_irqrestore(&fence->event_queue.lock, flags);
> +
> +	return fence;
> +}
> +EXPORT_SYMBOL_GPL(dma_buf_get_fence);
Would mean obsoleting this function, since there's
no longer a single fence.

> + * dma_fence_put - Release a reference to the fence.
> + */
> +void dma_fence_put(struct dma_fence *fence)
> +{
> +	WARN_ON(!fence);
> +	kref_put(&fence->refcount, release_fence);
> +}
> +EXPORT_SYMBOL_GPL(dma_fence_put);
Make this inline?

> +/**
> + * dma_fence_get - Take a reference to the fence.
> + *
> + * In most cases this is used only internally by dma-fence.
> + */
> +void dma_fence_get(struct dma_fence *fence)
> +{
> +	WARN_ON(!fence);
> +	kref_get(&fence->refcount);
> +}
> +EXPORT_SYMBOL_GPL(dma_fence_get);
Same.

> +/**
> + * dma_fence_add_callback - Add a callback to be called when the fence
> + * is signaled.
> + *
> + * @fence: The fence to wait on
> + * @cb: The callback to register
> + *
> + * Any number of callbacks can be registered to a fence, but a callback
> + * can only be registered to once fence at a time.
> + *
> + * Note that the callback can be called from an atomic context.  If
> + * fence is already signaled, this function will return -ENOENT (and
> + * *not* call the callback)
> + */
> +int dma_fence_add_callback(struct dma_fence *fence,
> +		struct dma_fence_cb *cb)
> +{
> +	unsigned long flags;
> +	int ret;
> +
> +	if (WARN_ON(!fence || !cb))
> +		return -EINVAL;
> +
> +	ret = check_signaling(fence);
> +
> +	spin_lock_irqsave(&fence->event_queue.lock, flags);
> +	if (ret == -ENOENT) {
> +		/* if state changed while we dropped the lock, dispatch now */
> +		signal_fence(fence);
> +	} else if (!fence->signaled && !ret) {
> +		dma_fence_get(fence);
> +		cb->fence = fence;
> +		__add_wait_queue(&fence->event_queue, &cb->base);
> +		ret = 0;
> +	} else {
> +		ret = -EINVAL;
> +	}
> +	spin_unlock_irqrestore(&fence->event_queue.lock, flags);
Unconditionally taking same spinlock twice seems a bit overkill,
maybe just drop it in check_signalling if needed?

Some standardized base for hardware dma-buf fence objects would
also be nice, it will make implementing it for drm a lot easier.

~Maarten
