Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246Ab1DTI7Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 04:59:16 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:35212 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752707Ab1DTI7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 04:59:14 -0400
X-Authenticated: #2770290
X-Provags-ID: V01U2FsdGVkX1+kTxwLCk+kn5zUc60OPsaTyiKsWFqHEk3ZsEKqo4
	5Cc+po8CnhLFTf
Date: Wed, 20 Apr 2011 10:59:08 +0200
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Bob Liu <lliubbo@gmail.com>
Cc: linux-media@vger.kernel.org, linux-uvc-devel@lists.berlios.de,
        linux-kernel@vger.kernel.org, mchehab@redhat.com, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com,
        sakari.ailus@maxwell.research.nokia.com, martin_rubli@logitech.com,
        jarod@redhat.com, tj@kernel.org, arnd@arndb.de, fweisbec@gmail.com,
        agust@denx.de, gregkh@suse.de
Subject: Re: Fwd: [PATCH v2] media: uvc_driver: add NO-MMU arch support
Message-ID: <20110420085908.GA7294@minime.bse>
Mail-Followup-To: Bob Liu <lliubbo@gmail.com>, linux-media@vger.kernel.org,
	linux-uvc-devel@lists.berlios.de, linux-kernel@vger.kernel.org,
	mchehab@redhat.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com,
	sakari.ailus@maxwell.research.nokia.com, martin_rubli@logitech.com,
	jarod@redhat.com, tj@kernel.org, arnd@arndb.de, fweisbec@gmail.com,
	agust@denx.de, gregkh@suse.de
References: <1302261394-25695-1-git-send-email-lliubbo@gmail.com>
 <BANLkTikGxffMuxWq3P7QxM0213k9oRU4hw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTikGxffMuxWq3P7QxM0213k9oRU4hw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 20, 2011 at 02:02:41PM +0800, Bob Liu wrote:
> ---------- Forwarded message ----------

Forwarding broke tabs.

> @@ -445,6 +446,20 @@ int uvc_queue_mmap(struct uvc_video_queue *queue,
> struct vm_area_struct *vma)
>                addr += PAGE_SIZE;
>                size -= PAGE_SIZE;
>        }
> +#else
> +       if (i == queue->count ||
> +                       PAGE_ALIGN(size) != queue->buf_size) {

Why do you need to round up size on nommu?

> +               ret = -EINVAL;
> +               goto done;
> +       }
> +
> +       /* documentation/nommu-mmap.txt */

I don't see where Documentation/nommu-mmap.txt provides any information
on the following line(s).

> +       vma->vm_flags |= VM_IO | VM_MAYSHARE;
> +
> +       addr = (unsigned long)queue->mem + buffer->buf.m.offset;
> +       vma->vm_start = addr;
> +       vma->vm_end = addr +  queue->buf_size;

You don't need to do this here. vm_start and vm_end have already been
modified like this by do_mmap_pgoff after get_unmapped_area had been
called.

> +#endif
> 
>        vma->vm_ops = &uvc_vm_ops;
>        vma->vm_private_data = buffer;
> @@ -489,6 +504,38 @@ done:
>  }
> 
>  /*
> + * Get unmapped area.
> + *
> + * NO-MMU arch need this function to make mmap() work correctly.
> + */
> +unsigned long uvc_queue_get_unmapped_area(struct uvc_video_queue *queue,
> +               unsigned long addr, unsigned long len, unsigned long pgoff)
> +{
> +       struct uvc_buffer *buffer;
> +       unsigned int i;
> +       int ret = 0;

ret should be an unsigned long. You later try to store a pointer in
there.

> +
> +       mutex_lock(&queue->mutex);
> +       for (i = 0; i < queue->count; ++i) {
> +               buffer = &queue->buffer[i];
> +               if ((buffer->buf.m.offset >> PAGE_SHIFT) == pgoff)
> +                       break;
> +       }
> +
> +       if (i == queue->count ||
> +                       PAGE_ALIGN(len) != queue->buf_size) {
> +               ret = -EINVAL;
> +               goto done;
> +       }
> +
> +       addr = (unsigned long)queue->mem + buffer->buf.m.offset;
> +       ret = addr;
> +done:
> +       mutex_unlock(&queue->mutex);
> +       return ret;
> +}
> +
> +/*
>  * Enable or disable the video buffers queue.
>  *
>  * The queue must be enabled before starting video acquisition and must be
> diff --git a/drivers/media/video/uvc/uvc_v4l2.c
> b/drivers/media/video/uvc/uvc_v4l2.c
> index 9005a8d..9efab61 100644
> --- a/drivers/media/video/uvc/uvc_v4l2.c
> +++ b/drivers/media/video/uvc/uvc_v4l2.c
> @@ -1081,6 +1081,18 @@ static unsigned int uvc_v4l2_poll(struct file
> *file, poll_table *wait)
>        return uvc_queue_poll(&stream->queue, file, wait);
>  }
> 
> +static unsigned long uvc_v4l2_get_unmapped_area(struct file *file,
> +               unsigned long addr, unsigned long len, unsigned long pgoff,
> +               unsigned long flags)
> +{
> +       struct uvc_fh *handle = file->private_data;
> +       struct uvc_streaming *stream = handle->stream;
> +
> +       uvc_trace(UVC_TRACE_CALLS, "uvc_v4l2_get_unmapped_area\n");
> +
> +       return uvc_queue_get_unmapped_area(&stream->queue, addr, len, pgoff);
> +}
> +
>  const struct v4l2_file_operations uvc_fops = {
>        .owner          = THIS_MODULE,
>        .open           = uvc_v4l2_open,
> @@ -1089,5 +1101,6 @@ const struct v4l2_file_operations uvc_fops = {
>        .read           = uvc_v4l2_read,
>        .mmap           = uvc_v4l2_mmap,
>        .poll           = uvc_v4l2_poll,
> +       .get_unmapped_area = uvc_v4l2_get_unmapped_area,
>  };
> 
> diff --git a/drivers/media/video/uvc/uvcvideo.h
> b/drivers/media/video/uvc/uvcvideo.h
> index 45f01e7..48a2378 100644
> --- a/drivers/media/video/uvc/uvcvideo.h
> +++ b/drivers/media/video/uvc/uvcvideo.h
> @@ -580,6 +580,12 @@ extern int uvc_queue_mmap(struct uvc_video_queue *queue,
>                struct vm_area_struct *vma);
>  extern unsigned int uvc_queue_poll(struct uvc_video_queue *queue,
>                struct file *file, poll_table *wait);
> +#ifdef CONFIG_MMU
> +#define uvc_queue_get_unmapped_area NULL
> +#else
> +extern unsigned long uvc_queue_get_unmapped_area(struct uvc_video_queue *queue,
> +               unsigned long addr, unsigned long len, unsigned long pgoff);
> +#endif
>  extern int uvc_queue_allocated(struct uvc_video_queue *queue);
>  static inline int uvc_queue_streaming(struct uvc_video_queue *queue)
>  {
> diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c

Rest looks good.
Did you change anything in the generic code or is this a plain
git revert c29fcff3daafbf46d64a543c1950bbd206ad8c1c
?

Maybe one can unify the mmu and nommu versions of uvc_queue_mmap by using
remap_vmalloc_range but IMHO the nommu versions of the remap_*_range
functions are broken and should only validate if the source and destination
addresses match.

  Daniel
