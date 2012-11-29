Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188Ab2K2KBS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 05:01:18 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:33734 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071Ab2K2KBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 05:01:14 -0500
Message-ID: <50B7325F.20002@gmail.com>
Date: Thu, 29 Nov 2012 18:01:03 +0800
From: Mark Zhang <nvmarkzhang@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Terje Bergstrom <tbergstrom@nvidia.com>
CC: thierry.reding@avionic-design.de, linux-tegra@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC,v2,3/8] video: tegra: host: Add channel and client support
References: <1353935954-13763-4-git-send-email-tbergstrom@nvidia.com>
In-Reply-To: <1353935954-13763-4-git-send-email-tbergstrom@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2012 09:19 PM, Terje Bergström <tbergstrom@nvidia.com> wrote:
> Add support for host1x client modules, and host1x channels to submit
> work to the clients. The work is submitted in dmabuf buffers, so add
> support for dmabuf memory management, too.
[...]
> diff --git a/drivers/video/tegra/host/bus_client.c b/drivers/video/tegra/host/bus_client.c
[...]
> +int nvhost_client_device_init(struct platform_device *dev)
> +{
> +	int err;
> +	struct nvhost_master *nvhost_master = nvhost_get_host(dev);
> +	struct nvhost_channel *ch;
> +	struct nvhost_device_data *pdata = platform_get_drvdata(dev);
> +
> +	ch = nvhost_alloc_channel(dev);
> +	if (ch == NULL)
> +		return -ENODEV;
> +
> +	/* store the pointer to this device for channel */
> +	ch->dev = dev;
> +
> +	err = nvhost_channel_init(ch, nvhost_master, pdata->index);
> +	if (err)
> +		goto fail;
> +
> +	err = nvhost_module_init(dev);
> +	if (err)
> +		goto fail;
> +
> +	err = nvhost_device_list_add(dev);
> +	if (err)
> +		goto fail;
> +
> +	dev_info(&dev->dev, "initialized\n");
> +
> +	return 0;
> +
> +fail:
> +	/* Add clean-up */

Yes, add "nvhost_module_deinit" here?

> +	nvhost_free_channel(ch);
> +	return err;
> +}
> +EXPORT_SYMBOL(nvhost_client_device_init);
> +
> +int nvhost_client_device_suspend(struct platform_device *dev)
> +{
> +	int ret = 0;
> +	struct nvhost_device_data *pdata = platform_get_drvdata(dev);
> +
> +	ret = nvhost_channel_suspend(pdata->channel);
> +	dev_info(&dev->dev, "suspend status: %d\n", ret);
> +	if (ret)
> +		return ret;
> +
> +	return ret;

Minor issue: just "return ret" is OK. That "if" doesn't make sense.

> +}
> +EXPORT_SYMBOL(nvhost_client_device_suspend);
> diff --git a/drivers/video/tegra/host/chip_support.c b/drivers/video/tegra/host/chip_support.c
> index 5a44147..8765c83 100644
> --- a/drivers/video/tegra/host/chip_support.c
> +++ b/drivers/video/tegra/host/chip_support.c
> @@ -25,7 +25,7 @@
>  #include "chip_support.h"
>  #include "host1x/host1x01.h"
>  
> -struct nvhost_chip_support *nvhost_chip_ops;
> +static struct nvhost_chip_support *nvhost_chip_ops;
>  

All right, already fixed here. Sorry, so just ignore what I said about
this in my reply to your patch 1.

[...]
> +
> +struct mem_handle *nvhost_dmabuf_get(u32 id, struct platform_device *dev)
> +{
> +	struct mem_handle *h;
> +	struct dma_buf *buf;
> +
> +	buf = dma_buf_get(to_dmabuf_fd(id));
> +	if (IS_ERR_OR_NULL(buf))
> +		return (struct mem_handle *)buf;
> +
> +	h = (struct mem_handle *)dma_buf_attach(buf, &dev->dev);
> +	if (IS_ERR_OR_NULL(h))
> +		dma_buf_put(buf);

Return an error here.

> +
> +	return (struct mem_handle *) ((u32)h | mem_mgr_type_dmabuf);
> +}
> +
[...]
>  int nvhost_init_host1x01_support(struct nvhost_master *host,
>  	struct nvhost_chip_support *op)
>  {
> +	op->channel = host1x_channel_ops;
> +	op->cdma = host1x_cdma_ops;
> +	op->push_buffer = host1x_pushbuffer_ops;
>  	host->sync_aperture = host->aperture + HOST1X_CHANNEL_SYNC_REG_BASE;
>  	op->syncpt = host1x_syncpt_ops;
>  	op->intr = host1x_intr_ops;
>  
> +	op->nvhost_dev.alloc_nvhost_channel = t20_alloc_nvhost_channel;
> +	op->nvhost_dev.free_nvhost_channel = t20_free_nvhost_channel;
> +

I recall in previous version, there is t30-related alloc_nvhost_channel
& free_nvhost_channel. Why remove them?

>  	return 0;
>  }
[...]
> +static int push_buffer_init(struct push_buffer *pb)
> +{
> +	struct nvhost_cdma *cdma = pb_to_cdma(pb);
> +	struct nvhost_master *master = cdma_to_dev(cdma);
> +	pb->mapped = NULL;
> +	pb->phys = 0;
> +	pb->handle = NULL;
> +
> +	cdma_pb_op().reset(pb);
> +
> +	/* allocate and map pushbuffer memory */
> +	pb->mapped = dma_alloc_writecombine(&master->dev->dev,
> +			PUSH_BUFFER_SIZE + 4, &pb->phys, GFP_KERNEL);
> +	if (IS_ERR_OR_NULL(pb->mapped)) {
> +		pb->mapped = NULL;
> +		goto fail;

Return directly here. "goto fail" makes "push_buffer_destroy" get called.

> +	}
> +
> +	/* memory for storing mem client and handles for each opcode pair */
> +	pb->handle = kzalloc(NVHOST_GATHER_QUEUE_SIZE *
> +				sizeof(struct mem_handle *),
> +			GFP_KERNEL);
> +	if (!pb->handle)
> +		goto fail;
> +
> +	/* put the restart at the end of pushbuffer memory */

Just for curious, why "pb->mapped + 1K" is the end of a 4K pushbuffer?

> +	*(pb->mapped + (PUSH_BUFFER_SIZE >> 2)) =
> +		nvhost_opcode_restart(pb->phys);
> +
> +	return 0;
> +
> +fail:
> +	push_buffer_destroy(pb);
> +	return -ENOMEM;
> +}
> +
[...]
> +
> +/**
> + * Sleep (if necessary) until the requested event happens
> + *   - CDMA_EVENT_SYNC_QUEUE_EMPTY : sync queue is completely empty.
> + *     - Returns 1
> + *   - CDMA_EVENT_PUSH_BUFFER_SPACE : there is space in the push buffer
> + *     - Return the amount of space (> 0)
> + * Must be called with the cdma lock held.
> + */
> +unsigned int nvhost_cdma_wait_locked(struct nvhost_cdma *cdma,
> +		enum cdma_event event)
> +{
> +	for (;;) {
> +		unsigned int space = cdma_status_locked(cdma, event);
> +		if (space)
> +			return space;
> +
> +		/* If somebody has managed to already start waiting, yield */
> +		if (cdma->event != CDMA_EVENT_NONE) {
> +			mutex_unlock(&cdma->lock);
> +			schedule();
> +			mutex_lock(&cdma->lock);
> +			continue;
> +		}
> +		cdma->event = event;
> +
> +		mutex_unlock(&cdma->lock);
> +		down(&cdma->sem);
> +		mutex_lock(&cdma->lock);

I'm newbie of nvhost but I feel here is very tricky, about the lock and
unlock of this mutex: cdma->lock. Does it require this mutex is locked
before calling this function? And do we need to unlock it before the
code: "return space;" above? IMHO, this is not a good design and can we
find out a better solution?

> +	}
> +	return 0;
> +}
[...]

> +/*
> + * Dump contents of job to debug output.
> + */
> +void nvhost_job_dump(struct device *dev, struct nvhost_job *job);
> +
>  #endif
> 
