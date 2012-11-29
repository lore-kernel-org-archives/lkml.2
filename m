Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868Ab2K2KnK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 05:43:10 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:3639 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392Ab2K2KnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 05:43:08 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 29 Nov 2012 02:42:51 -0800
Message-ID: <50B73D1E.5090600@nvidia.com>
Date: Thu, 29 Nov 2012 12:46:54 +0200
From: =?UTF-8?B?VGVyamUgQmVyZ3N0csO2bQ==?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Mark Zhang <nvmarkzhang@gmail.com>
CC: "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC,v2,3/8] video: tegra: host: Add channel and client support
References: <1353935954-13763-4-git-send-email-tbergstrom@nvidia.com> <50B7325F.20002@gmail.com>
In-Reply-To: <50B7325F.20002@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.11.2012 12:01, Mark Zhang wrote:
>> +fail:
>> +	/* Add clean-up */
> 
> Yes, add "nvhost_module_deinit" here?

Sounds good.

>> +int nvhost_client_device_suspend(struct platform_device *dev)
>> +{
>> +	int ret = 0;
>> +	struct nvhost_device_data *pdata = platform_get_drvdata(dev);
>> +
>> +	ret = nvhost_channel_suspend(pdata->channel);
>> +	dev_info(&dev->dev, "suspend status: %d\n", ret);
>> +	if (ret)
>> +		return ret;
>> +
>> +	return ret;
> 
> Minor issue: just "return ret" is OK. That "if" doesn't make sense.

Yes, must be some snafu when doing changes in code.

>> -struct nvhost_chip_support *nvhost_chip_ops;
>> +static struct nvhost_chip_support *nvhost_chip_ops;
>>  
> 
> All right, already fixed here. Sorry, so just ignore what I said about
> this in my reply to your patch 1.

I was wondering about this, because I thought I did make it static. But
it looks like I added that to the wrong commit. Anyway, this needs
rethinking.

>> +struct mem_handle *nvhost_dmabuf_get(u32 id, struct platform_device *dev)
>> +{
>> +	struct mem_handle *h;
>> +	struct dma_buf *buf;
>> +
>> +	buf = dma_buf_get(to_dmabuf_fd(id));
>> +	if (IS_ERR_OR_NULL(buf))
>> +		return (struct mem_handle *)buf;
>> +
>> +	h = (struct mem_handle *)dma_buf_attach(buf, &dev->dev);
>> +	if (IS_ERR_OR_NULL(h))
>> +		dma_buf_put(buf);
> 
> Return an error here.

Will do.

>> +	op->nvhost_dev.alloc_nvhost_channel = t20_alloc_nvhost_channel;
>> +	op->nvhost_dev.free_nvhost_channel = t20_free_nvhost_channel;
>> +
> 
> I recall in previous version, there is t30-related alloc_nvhost_channel
> & free_nvhost_channel. Why remove them?

I could actually refactor these all into one alloc channel. We already
store the number of channels in a data type, so a generic channel
allocator would be better than having a chip specific one.

>> +static int push_buffer_init(struct push_buffer *pb)
>> +{
>> +	struct nvhost_cdma *cdma = pb_to_cdma(pb);
>> +	struct nvhost_master *master = cdma_to_dev(cdma);
>> +	pb->mapped = NULL;
>> +	pb->phys = 0;
>> +	pb->handle = NULL;
>> +
>> +	cdma_pb_op().reset(pb);
>> +
>> +	/* allocate and map pushbuffer memory */
>> +	pb->mapped = dma_alloc_writecombine(&master->dev->dev,
>> +			PUSH_BUFFER_SIZE + 4, &pb->phys, GFP_KERNEL);
>> +	if (IS_ERR_OR_NULL(pb->mapped)) {
>> +		pb->mapped = NULL;
>> +		goto fail;
> 
> Return directly here. "goto fail" makes "push_buffer_destroy" get called.

Will do.

> 
>> +	}
>> +
>> +	/* memory for storing mem client and handles for each opcode pair */
>> +	pb->handle = kzalloc(NVHOST_GATHER_QUEUE_SIZE *
>> +				sizeof(struct mem_handle *),
>> +			GFP_KERNEL);
>> +	if (!pb->handle)
>> +		goto fail;
>> +
>> +	/* put the restart at the end of pushbuffer memory */
> 
> Just for curious, why "pb->mapped + 1K" is the end of a 4K pushbuffer?

pb->mapped is u32 *, so compiler will take care of multiplying by
sizeof(u32).

>> +unsigned int nvhost_cdma_wait_locked(struct nvhost_cdma *cdma,
>> +		enum cdma_event event)
>> +{
>> +	for (;;) {
>> +		unsigned int space = cdma_status_locked(cdma, event);
>> +		if (space)
>> +			return space;
>> +
>> +		/* If somebody has managed to already start waiting, yield */
>> +		if (cdma->event != CDMA_EVENT_NONE) {
>> +			mutex_unlock(&cdma->lock);
>> +			schedule();
>> +			mutex_lock(&cdma->lock);
>> +			continue;
>> +		}
>> +		cdma->event = event;
>> +
>> +		mutex_unlock(&cdma->lock);
>> +		down(&cdma->sem);
>> +		mutex_lock(&cdma->lock);
> 
> I'm newbie of nvhost but I feel here is very tricky, about the lock and
> unlock of this mutex: cdma->lock. Does it require this mutex is locked
> before calling this function? And do we need to unlock it before the
> code: "return space;" above? IMHO, this is not a good design and can we
> find out a better solution?

Yeah, it's not perfect and good solutions are welcome.
cdma_status_locked() must be called with a mutex. But, what we generally
wait for is for space in push buffer. The cleanup code cannot run if we
keep cdma->lock, so I release it.

The two ways to loop are because there was a race between two processes
waiting for space. One of them set cdma->event to indicate what it's
waiting for and can go to sleep, but the other has to keep spinning.

Terje
