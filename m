Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852Ab2HKQFZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2012 12:05:25 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47043 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563Ab2HKQFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2012 12:05:23 -0400
Message-ID: <502682C1.4060609@canonical.com>
Date: Sat, 11 Aug 2012 18:05:21 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: sumit.semwal@linaro.org, rob.clark@linaro.org,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Subject: Re: [Linaro-mm-sig] [PATCH 3/4] dma-seqno-fence: Hardware dma-buf
 implementation of fencing (v2)
References: <20120810145728.5490.44707.stgit@patser.local> <20120810145758.5490.62372.stgit@patser.local> <20120810195749.GH5738@phenom.ffwll.local>
In-Reply-To: <20120810195749.GH5738@phenom.ffwll.local>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 10-08-12 21:57, Daniel Vetter schreef:
> On Fri, Aug 10, 2012 at 04:57:58PM +0200, Maarten Lankhorst wrote:
>> This type of fence can be used with hardware synchronization for simple
>> hardware that can block execution until the condition
>> (dma_buf[offset] - value) >= 0 has been met.
>>
>> A software fallback still has to be provided in case the fence is used
>> with a device that doesn't support this mechanism. It is useful to expose
>> this for graphics cards that have an op to support this.
>>
>> Some cards like i915 can export those, but don't have an option to wait,
>> so they need the software fallback.
>>
>> I extended the original patch by Rob Clark.
>>
>> v1: Original
>> v2: Renamed from bikeshed to seqno, moved into dma-fence.c since
>>     not much was left of the file. Lots of documentation added.
>>
>> Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
> Patch looks good, two bikesheds inline. Either way
> Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
>
>> ---
>>  drivers/base/dma-fence.c  |   21 +++++++++++++++
>>  include/linux/dma-fence.h |   61 +++++++++++++++++++++++++++++++++++++++++++++
>>  2 files changed, 82 insertions(+)
>>
>> diff --git a/drivers/base/dma-fence.c b/drivers/base/dma-fence.c
>> index 93448e4..4092a58 100644
>> --- a/drivers/base/dma-fence.c
>> +++ b/drivers/base/dma-fence.c
>> @@ -266,3 +266,24 @@ struct dma_fence *dma_fence_create(void *priv)
>>  	return fence;
>>  }
>>  EXPORT_SYMBOL_GPL(dma_fence_create);
>> +
>> +static int seqno_enable_signaling(struct dma_fence *fence)
>> +{
>> +	struct dma_seqno_fence *seqno_fence = to_seqno_fence(fence);
>> +	return seqno_fence->enable_signaling(seqno_fence);
>> +}
>> +
>> +static void seqno_release(struct dma_fence *fence)
>> +{
>> +	struct dma_seqno_fence *f = to_seqno_fence(fence);
>> +
>> +	if (f->release)
>> +		f->release(f);
>> +	dma_buf_put(f->sync_buf);
>> +}
>> +
>> +const struct dma_fence_ops dma_seqno_fence_ops = {
>> +	.enable_signaling = seqno_enable_signaling,
>> +	.release = seqno_release
>> +};
>> +EXPORT_SYMBOL_GPL(dma_seqno_fence_ops);
>> diff --git a/include/linux/dma-fence.h b/include/linux/dma-fence.h
>> index e0ceddd..3ef0da0 100644
>> --- a/include/linux/dma-fence.h
>> +++ b/include/linux/dma-fence.h
>> @@ -91,6 +91,19 @@ struct dma_fence_ops {
>>  	void (*release)(struct dma_fence *fence);
>>  };
>>  
>> +struct dma_seqno_fence {
>> +	struct dma_fence base;
>> +
>> +	struct dma_buf *sync_buf;
>> +	uint32_t seqno_ofs;
>> +	uint32_t seqno;
>> +
>> +	int (*enable_signaling)(struct dma_seqno_fence *fence);
>> +	void (*release)(struct dma_seqno_fence *fence);
> I think using dma_fence_ops here is the better color. We lose type-safety
> at compile-time, but still keep type-safety at runtime (thanks to
> to_dma_seqno_fence). In addition people seem to like to constify function
> pointers, we'd save a pointer and if we extend the sw dma_fence interface.
Ok, will change.

>> +};
>> +
>> +extern const struct dma_fence_ops dma_seqno_fence_ops;
>> +
>>  struct dma_fence *dma_fence_create(void *priv);
>>  
>>  /**
>> @@ -121,4 +134,52 @@ int dma_fence_wait(struct dma_fence *fence, bool intr, unsigned long timeout);
>>  int dma_fence_add_callback(struct dma_fence *fence, struct dma_fence_cb *cb,
>>  			   dma_fence_func_t func, void *priv);
>>  
>> +/**
>> + * to_seqno_fence - cast a dma_fence to a dma_seqno_fence
>> + * @fence: dma_fence to cast to a dma_seqno_fence
>> + *
>> + * Returns NULL if the dma_fence is not a dma_seqno_fence,
>> + * or the dma_seqno_fence otherwise.
>> + */
>> +static inline struct dma_seqno_fence *
>> +to_seqno_fence(struct dma_fence *fence)
>> +{
>> +	if (fence->ops != &dma_seqno_fence_ops)
>> +		return NULL;
>> +	return container_of(fence, struct dma_seqno_fence, base);
>> +}
> I think adding an is_dma_seqno_fence would be nice ...
#define is_dma_seqno_fence !!to_dma_seqno_fence

The first thing you would do after finding out it's a seqno fence
is calling to_dma_seqno_fence, otherwise why would you care?
As such the check was pointless and deleted.

My bikeshed, go build your own!

>> +
>> +/**
>> + * dma_seqno_fence_init - initialize a seqno fence
>> + * @fence: dma_seqno_fence to initialize
>> + * @sync_buf: buffer containing the memory location to signal on
>> + * @seqno_ofs: the offset within @sync_buf
>> + * @seqno: the sequence # to signal on
>> + * @priv: value of priv member
>> + * @enable_signaling: callback which is called when some other device is
>> + *    waiting for sw notification of fence
>> + * @release: callback called during destruction before object is freed.
>> + *
>> + * This function initializes a struct dma_seqno_fence with passed parameters,
>> + * and takes a reference on sync_buf which is released on fence destruction.
>> + */
>> +static inline void
>> +dma_seqno_fence_init(struct dma_seqno_fence *fence,
>> +			struct dma_buf *sync_buf,
>> +			uint32_t seqno_ofs, uint32_t seqno, void *priv,
>> +			int (*enable_signaling)(struct dma_seqno_fence *),
>> +			void (*release)(struct dma_seqno_fence *))
>> +{
>> +	BUG_ON(!fence || !sync_buf || !enable_signaling);
>> +
>> +	__dma_fence_init(&fence->base, &dma_seqno_fence_ops, priv);
>> +
>> +	get_dma_buf(sync_buf);
>> +	fence->sync_buf = sync_buf;
>> +	fence->seqno_ofs = seqno_ofs;
>> +	fence->seqno = seqno;
>> +	fence->enable_signaling = enable_signaling;
>> +	fence->release = release;
>> +}
>> +
>>  #endif /* __DMA_FENCE_H__ */
>>
>>
>> _______________________________________________
>> Linaro-mm-sig mailing list
>> Linaro-mm-sig@lists.linaro.org
>> http://lists.linaro.org/mailman/listinfo/linaro-mm-sig

