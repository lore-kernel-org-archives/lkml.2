Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751405Ab1CJLDM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 06:03:12 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:52825 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904Ab1CJLDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 06:03:10 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Bob Liu <lliubbo@gmail.com>
Subject: Re: [PATCH] media: uvc_driver: add NO-MMU arch support
Date: Thu, 10 Mar 2011 12:03:30 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.37-gentoo-r1; KDE/4.6.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, mchehab@redhat.com, hverkuil@xs4all.nl,
        sakari.ailus@maxwell.research.nokia.com, martin_rubli@logitech.com,
        jarod@redhat.com, tj@kernel.org, arnd@arndb.de, fweisbec@gmail.com,
        agust@denx.de, gregkh@suse.de, vapier.adi@gmail.com,
        uclinux-dist-devel@blackfin.uclinux.org
References: <1299725077-13839-1-git-send-email-lliubbo@gmail.com>
In-Reply-To: <1299725077-13839-1-git-send-email-lliubbo@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201103101203.31563.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bob,

Thanks for the patch.

On Thursday 10 March 2011 03:44:37 Bob Liu wrote:
> UVC driver used to have partial no-mmu arch support, but it's removed by
> commit c29fcff3daafbf46d64a543c1950bbd206ad8c1c.
> 
> This patch added them back and expanded to fully support no-mmu arch, so
> that uvc cameras can be used on no-mmu platforms like Blackfin.
> 
> Signed-off-by: Bob Liu <lliubbo@gmail.com>
> ---
>  drivers/media/video/uvc/uvc_v4l2.c |   36
> ++++++++++++++++++++++++++++++++++++ drivers/media/video/v4l2-dev.c     | 
>  18 ++++++++++++++++++
>  drivers/usb/gadget/uvc_queue.c     |   15 +++++++++++++++
>  include/media/v4l2-dev.h           |    2 ++
>  4 files changed, 71 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/uvc/uvc_v4l2.c
> b/drivers/media/video/uvc/uvc_v4l2.c index 9005a8d..2413ec9 100644
> --- a/drivers/media/video/uvc/uvc_v4l2.c
> +++ b/drivers/media/video/uvc/uvc_v4l2.c
> @@ -1081,6 +1081,39 @@ static unsigned int uvc_v4l2_poll(struct file *file,
> poll_table *wait) return uvc_queue_poll(&stream->queue, file, wait);
>  }
> 
> +#ifndef CONFIG_MMU
> +static unsigned long uvc_v4l2_get_unmapped_area(struct file *file,
> +		unsigned long addr, unsigned long len, unsigned long pgoff,
> +		unsigned long flags)
> +{
> +	struct uvc_fh *handle = (struct uvc_fh *)file->private_data;
> +	struct uvc_streaming *stream = handle->stream;
> +	struct uvc_video_queue *queue = &stream->queue;
> +	struct uvc_buffer *uninitialized_var(buffer);
> +	unsigned int i;
> +	int ret = 0;
> +
> +	mutex_lock(&queue->mutex);
> +	for (i = 0; i < queue->count; ++i) {
> +		buffer = &queue->buffer[i];
> +		if ((buffer->buf.m.offset >> PAGE_SHIFT) == pgoff)
> +			break;
> +	}
> +
> +	if (i == queue->count ||
> +		PAGE_ALIGN(len) != queue->buf_size) {
> +		ret = -EINVAL;
> +		goto done;
> +	}
> +
> +	addr = (unsigned long)queue->mem + buffer->buf.m.offset;
> +	ret = addr;
> +done:
> +	mutex_unlock(&queue->mutex);
> +	return ret;
> +}
> +#endif
> +

Could you move the core of this function to uvc_queue.c ? Something like

unsigned long uvc_queue_get_unmapped_area(struct uvc_video_queue *queue,
	unsigned long addr, unsigned long len, unsigned long pgoff,
	unsigned long flags),

static unsigned long uvc_v4l2_get_unmapped_area(struct file *file,
		unsigned long addr, unsigned long len, unsigned long pgoff,
		unsigned long flags)
{
	struct uvc_fh *handle = (struct uvc_fh *)file->private_data;
	struct uvc_streaming *stream = handle->stream;

	return uvc_queue_get_unmapped_area(queue, addr, len, pgoff, flags);
}

> diff --git a/drivers/usb/gadget/uvc_queue.c
> b/drivers/usb/gadget/uvc_queue.c index f7395ac..24378fb 100644
> --- a/drivers/usb/gadget/uvc_queue.c
> +++ b/drivers/usb/gadget/uvc_queue.c
> @@ -431,6 +431,7 @@ uvc_queue_mmap(struct uvc_video_queue *queue, struct
> vm_area_struct *vma) break;
>  	}
> 
> +#ifdef CONFIG_MMU
>  	if (i == queue->count || size != queue->buf_size) {
>  		ret = -EINVAL;
>  		goto done;
> @@ -452,6 +453,20 @@ uvc_queue_mmap(struct uvc_video_queue *queue, struct
> vm_area_struct *vma) addr += PAGE_SIZE;
>  		size -= PAGE_SIZE;
>  	}
> +#else
> +	if (i == queue->count ||
> +		PAGE_ALIGN(size) != queue->buf_size) {
> +		ret = -EINVAL;
> +		goto done;
> +	}
> +
> +	/* documentation/nommu-mmap.txt */
> +	vma->vm_flags |= VM_IO | VM_MAYSHARE;
> +
> +	addr = (unsigned long)queue->mem + buffer->buf.m.offset;
> +	vma->vm_start = addr;
> +	vma->vm_end = addr +  queue->buf_size;
> +#endif
> 
>  	vma->vm_ops = &uvc_vm_ops;
>  	vma->vm_private_data = buffer;

Note that uvc_queue.c will be replaced by videobuf2 in the (near ?) future. 
NOMMU support will thus be removed once again. If you want to keep it, you 
should add a patch to videobuf2 to implement NOMMU support there.

-- 
Regards,

Laurent Pinchart
