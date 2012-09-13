Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756965Ab2IMOIN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 10:08:13 -0400
Received: from ams-iport-1.cisco.com ([144.254.224.140]:19346 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755313Ab2IMOIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 10:08:11 -0400
X-IronPort-AV: E=Sophos;i="4.80,417,1344211200"; 
   d="scan'208";a="143761307"
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Federico Vaga <federico.vaga@gmail.com>
Subject: Re: [PATCH 3/4] videobuf2-dma-streaming: new videobuf2 memory allocator
Date: Thu, 13 Sep 2012 16:08:05 +0200
User-Agent: KMail/1.13.7 (Linux/3.5-0.slh.1-aptosid-amd64; KDE/4.8.4; x86_64; ; )
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>
References: <1347544368-30583-1-git-send-email-federico.vaga@gmail.com> <1347544368-30583-3-git-send-email-federico.vaga@gmail.com>
In-Reply-To: <1347544368-30583-3-git-send-email-federico.vaga@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201209131608.05869.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 13 September 2012 15:52:47 Federico Vaga wrote:
> Signed-off-by: Federico Vaga <federico.vaga@gmail.com>
> ---
>  drivers/media/v4l2-core/Kconfig                   |   5 +
>  drivers/media/v4l2-core/Makefile                  |   1 +
>  drivers/media/v4l2-core/videobuf2-dma-streaming.c | 205 ++++++++++++++++++++++
>  include/media/videobuf2-dma-streaming.h           |  24 +++
>  4 file modificati, 235 inserzioni(+)
>  create mode 100644 drivers/media/v4l2-core/videobuf2-dma-streaming.c
>  create mode 100644 include/media/videobuf2-dma-streaming.h
> 
> diff --git a/drivers/media/v4l2-core/Kconfig b/drivers/media/v4l2-core/Kconfig
> index 0c54e19..60548a7 100644
> --- a/drivers/media/v4l2-core/Kconfig
> +++ b/drivers/media/v4l2-core/Kconfig
> @@ -79,3 +79,8 @@ config VIDEOBUF2_DMA_SG
>  	#depends on HAS_DMA
>  	select VIDEOBUF2_CORE
>  	select VIDEOBUF2_MEMOPS
> +
> +config VIDEOBUF2_DMA_STREAMING
> +	select VIDEOBUF2_CORE
> +	select VIDEOBUF2_MEMOPS
> +	tristate
> diff --git a/drivers/media/v4l2-core/Makefile b/drivers/media/v4l2-core/Makefile
> index c2d61d4..0b2756f 100644
> --- a/drivers/media/v4l2-core/Makefile
> +++ b/drivers/media/v4l2-core/Makefile
> @@ -28,6 +28,7 @@ obj-$(CONFIG_VIDEOBUF2_MEMOPS) += videobuf2-memops.o
>  obj-$(CONFIG_VIDEOBUF2_VMALLOC) += videobuf2-vmalloc.o
>  obj-$(CONFIG_VIDEOBUF2_DMA_CONTIG) += videobuf2-dma-contig.o
>  obj-$(CONFIG_VIDEOBUF2_DMA_SG) += videobuf2-dma-sg.o
> +obj-$(CONFIG_VIDEOBUF2_DMA_STREAMING) += videobuf2-dma-streaming.o
>  
>  ccflags-y += -I$(srctree)/drivers/media/dvb-core
>  ccflags-y += -I$(srctree)/drivers/media/dvb-frontends
> diff --git a/drivers/media/v4l2-core/videobuf2-dma-streaming.c b/drivers/media/v4l2-core/videobuf2-dma-streaming.c
> new file mode 100644
> index 0000000..23475a6
> --- /dev/null
> +++ b/drivers/media/v4l2-core/videobuf2-dma-streaming.c
> @@ -0,0 +1,205 @@
> +/*
> + * videobuf2-dma-streaming.c - DMA streaming memory allocator for videobuf2
> + *
> + * Copyright (C) 2012 Federico Vaga <federico.vaga@gmail.com>
> + * *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/pagemap.h>
> +#include <linux/dma-mapping.h>
> +
> +#include <media/videobuf2-core.h>
> +#include <media/videobuf2-dma-streaming.h>
> +#include <media/videobuf2-memops.h>
> +
> +struct vb2_streaming_conf {
> +	struct device			*dev;
> +};
> +struct vb2_streaming_buf {
> +	struct vb2_streaming_conf	*conf;
> +	void				*vaddr;
> +
> +	dma_addr_t			dma_handle;
> +
> +	unsigned long			size;
> +	struct vm_area_struct		*vma;
> +
> +	atomic_t			refcount;
> +	struct vb2_vmarea_handler	handler;
> +};
> +
> +static void vb2_dma_streaming_put(void *buf_priv)
> +{
> +	struct vb2_streaming_buf *buf = buf_priv;
> +
> +	if (atomic_dec_and_test(&buf->refcount)) {
> +		dma_unmap_single(buf->conf->dev, buf->dma_handle, buf->size,
> +				 DMA_FROM_DEVICE);
> +		free_pages_exact(buf->vaddr, buf->size);
> +		kfree(buf);
> +	}
> +
> +}
> +
> +static void *vb2_dma_streaming_alloc(void *alloc_ctx, unsigned long size)
> +{
> +	struct vb2_streaming_conf *conf = alloc_ctx;
> +	struct vb2_streaming_buf *buf;
> +	int err;
> +
> +	buf = kzalloc(sizeof *buf, GFP_KERNEL);
> +	if (!buf)
> +		return ERR_PTR(-ENOMEM);
> +	buf->vaddr = alloc_pages_exact(size, GFP_KERNEL | GFP_DMA);
> +	if (!buf->vaddr) {
> +		err = -ENOMEM;
> +		goto out;
> +	}
> +	buf->dma_handle = dma_map_single(conf->dev, buf->vaddr, size,
> +					 DMA_FROM_DEVICE);
> +	err = dma_mapping_error(conf->dev, buf->dma_handle);
> +	if (err) {
> +		dev_err(conf->dev, "dma_map_single failed\n");
> +
> +		free_pages_exact(buf->vaddr, size);
> +		buf->vaddr = NULL;
> +		goto out_pages;
> +	}
> +	buf->conf = conf;
> +	buf->size = size;
> +	buf->handler.refcount = &buf->refcount;
> +	buf->handler.put = vb2_dma_streaming_put;
> +	buf->handler.arg = buf;
> +
> +	atomic_inc(&buf->refcount);
> +	return buf;
> +
> +out_pages:
> +	free_pages_exact(buf->vaddr, buf->size);
> +out:
> +	kfree(buf);
> +	return ERR_PTR(err);
> +}
> +
> +static void *vb2_dma_streaming_cookie(void *buf_priv)
> +{
> +	struct vb2_streaming_buf *buf = buf_priv;
> +
> +	return (void *)buf->dma_handle;
> +}
> +
> +static void *vb2_dma_streaming_vaddr(void *buf_priv)
> +{
> +	struct vb2_streaming_buf *buf = buf_priv;
> +
> +	if (!buf)
> +		return NULL;
> +	return buf->vaddr;
> +}
> +
> +static unsigned int vb2_dma_streaming_num_users(void *buf_priv)
> +{
> +	struct vb2_streaming_buf *buf = buf_priv;
> +
> +	return atomic_read(&buf->refcount);
> +}
> +
> +static int vb2_dma_streaming_mmap(void *buf_priv, struct vm_area_struct *vma)
> +{
> +	struct vb2_streaming_buf *buf = buf_priv;
> +	unsigned long pos, start = vma->vm_start;
> +	unsigned long size;
> +	struct page *page;
> +	int err;
> +
> +	/* Try to remap memory */
> +	size = vma->vm_end - vma->vm_start;
> +	size = (size < buf->size) ? size : buf->size;
> +	pos = (unsigned long)buf->vaddr;
> +
> +	while (size > 0) {
> +		page = virt_to_page((void *)pos);
> +		if (!page) {
> +			dev_err(buf->conf->dev, "mmap: virt_to_page failed\n");
> +			return -ENOMEM;
> +		}
> +		err = vm_insert_page(vma, start, page);
> +		if (err) {
> +			dev_err(buf->conf->dev, "mmap: insert failed %d\n", err);
> +			return -ENOMEM;
> +		}
> +		start += PAGE_SIZE;
> +		pos += PAGE_SIZE;
> +
> +		if (size > PAGE_SIZE)
> +			size -= PAGE_SIZE;
> +		else
> +			size = 0;
> +	}
> +
> +
> +	vma->vm_ops = &vb2_common_vm_ops;
> +	vma->vm_flags |= VM_DONTEXPAND;
> +	vma->vm_private_data = &buf->handler;
> +
> +	vma->vm_ops->open(vma);
> +
> +	return 0;
> +}
> +
> +static void vb2_dma_streaming_prepare(void *buf_priv)
> +{
> +	struct vb2_streaming_buf *buf = buf_priv;
> +
> +	dma_sync_single_for_device(buf->conf->dev, buf->dma_handle,
> +				   buf->size, DMA_FROM_DEVICE);
> +}
> +
> +static void vb2_dma_streaming_finish(void *buf_priv)
> +{
> +	struct vb2_streaming_buf *buf = buf_priv;
> +
> +	dma_sync_single_for_cpu(buf->conf->dev, buf->dma_handle,
> +				buf->size, DMA_FROM_DEVICE);
> +}
> +
> +const struct vb2_mem_ops vb2_dma_streaming_memops = {
> +	.alloc		= vb2_dma_streaming_alloc,
> +	.put		= vb2_dma_streaming_put,
> +	.cookie		= vb2_dma_streaming_cookie,
> +	.vaddr		= vb2_dma_streaming_vaddr,
> +	.mmap		= vb2_dma_streaming_mmap,
> +	.num_users	= vb2_dma_streaming_num_users,
> +	.prepare	= vb2_dma_streaming_prepare,
> +	.finish		= vb2_dma_streaming_finish,
> +};
> +EXPORT_SYMBOL_GPL(vb2_dma_streaming_memops);
> +
> +void *vb2_dma_streaming_init_ctx(struct device *dev)
> +{
> +	struct vb2_streaming_conf *conf;
> +
> +	conf = kmalloc(sizeof *conf, GFP_KERNEL);
> +	if (!conf)
> +		return ERR_PTR(-ENOMEM);
> +
> +	conf->dev = dev;
> +
> +	return conf;
> +}
> +EXPORT_SYMBOL_GPL(vb2_dma_streaming_init_ctx);
> +
> +void vb2_dma_streaming_cleanup_ctx(void *alloc_ctx)
> +{
> +	kfree(alloc_ctx);
> +}
> +EXPORT_SYMBOL_GPL(vb2_dma_streaming_cleanup_ctx);
> +
> +MODULE_DESCRIPTION("DMA-streaming memory allocator for videobuf2");
> +MODULE_AUTHOR("Federico Vaga <federico.vaga@gmail.com>");
> +MODULE_LICENSE("GPL v2");
> diff --git a/include/media/videobuf2-dma-streaming.h b/include/media/videobuf2-dma-streaming.h
> new file mode 100644
> index 0000000..89cbd06
> --- /dev/null
> +++ b/include/media/videobuf2-dma-streaming.h
> @@ -0,0 +1,24 @@
> +/*
> + * videobuf2-dma-streaming.h - DMA steaming memory allocator for videobuf2

typo: steaming -> streaming :-)

The header and esp. the source could really do with more documentation. It is
not at all clear from the code what the dma-streaming allocator does and how
it differs from other allocators.

Regards,

	Hans

> + *
> + * Copyright (C) 2012 Federico Vaga
> + *
> + * Author: Federico Vaga <federico.vaga@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation.
> + */
> +
> +#ifndef _MEDIA_VIDEOBUF2_DMA_STREAMING_H
> +#define _MEDIA_VIDEOBUF2_DMA_STREAMING_H
> +
> +#include <media/videobuf2-core.h>
> +#include <linux/dma-mapping.h>
> +
> +void *vb2_dma_streaming_init_ctx(struct device *dev);
> +void vb2_dma_streaming_cleanup_ctx(void *alloc_ctx);
> +
> +extern const struct vb2_mem_ops vb2_dma_streaming_memops;
> +
> +#endif
> 
