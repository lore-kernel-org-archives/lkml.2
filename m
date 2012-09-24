Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348Ab2IXMq5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 08:46:57 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:61426 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754956Ab2IXMq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 08:46:56 -0400
X-AuditID: cbfee61a-b7f726d000000ec7-db-5060563ebe77
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: "'Federico Vaga'" <federico.vaga@gmail.com>,
        "'Mauro Carvalho Chehab'" <mchehab@infradead.org>,
        "'Pawel Osciak'" <pawel@osciak.com>,
        "'Hans Verkuil'" <hans.verkuil@cisco.com>
Cc: "'Giancarlo Asnaghi'" <giancarlo.asnaghi@st.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Jonathan Corbet'" <corbet@lwn.net>
References: <1348484332-8106-1-git-send-email-federico.vaga@gmail.com>
In-reply-to: <1348484332-8106-1-git-send-email-federico.vaga@gmail.com>
Subject: RE: [PATCH v3 1/4] v4l: vb2: add prepare/finish callbacks to allocators
Date: Mon, 24 Sep 2012 14:46:42 +0200
Organization: SPRC
Message-id: <055a01cd9a52$a87ad370$f9707a50$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2aQyIlehS86LDlTUivd1WWVcdrGAADzZqA
Content-language: pl
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHLMWRmVeSWpSXmKPExsVy+t9jQV27sIQAgw+fFCwu75rDZtGzYSur
	A5PH501yAYxRXDYpqTmZZalF+nYJXBnTbsxiKngtVbFq8wK2Bsazol2MnBwSAiYS6ybfYoWw
	xSQu3FvP1sXIxSEkMJ1RYsuxF8wQzk9Gia9XLzCBVLEJGEp0ve0CqxIRWMcosbPjESOIwyww
	lVHiycZOsCohATeJ9juTWLoYOTg4BdwlbpzzAAkLCwRIvH38C6yERUBVYs+2b6wgJfwCQhIT
	ZymAhHkFXCRaP21jgrAFJX5MvscCYjMLaEms33mcCcKWl9i85i0zSKuEgLrEo7+6IGERASOJ
	U1t6oEpEJO42PGedwCg8C8mkWUgmzUIyaRaSlgWMLKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLz
	czcxgkP9mdQOxpUNFocYBTgYlXh4Oc/HBwixJpYVV+YeYpTgYFYS4Z1omBAgxJuSWFmVWpQf
	X1Sak1p8iFGag0VJnFf4U2CAkEB6YklqdmpqQWoRTJaJg1OqgbHw7VRX9tyibVJCKnP57ML6
	F5yNEtpr8mLD8fmpexOXxDjfr4o+G8d0/7qTYlAMg+zM1qXlPqxGptn3Fsxmu12+8mr9pymz
	pT4aLBBb+HyWaZXL45qtvqJ7Gm9sc18zwzH/T3Nr8TNL3exZc2OyrwdN++HzcmPUhJBD33Sm
	XFHZpLnXsubmgUNKLMUZiYZazEXFiQDblmqzcQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

It would be great if you could keep the correct authorship of the patch by adding the following
line on top of the patch (git will handle it automatically after applying):

-->8--
From: Marek Szyprowski <m.szyprowski@samsung.com>
-->8--

On Monday, September 24, 2012 12:59 PM Federico Vaga wrote:

> This patch adds support for prepare/finish callbacks in VB2 allocators.
> These callback are used for buffer flushing.
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Acked-by: Federico Vaga <federico.vaga@gmail.com>
> ---
>  drivers/media/v4l2-core/videobuf2-core.c | 11 +++++++++++
>  include/media/videobuf2-core.h           |  7 +++++++
>  2 file modificati, 18 inserzioni(+)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-
> core.c
> index 4da3df6..079fa79 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -790,6 +790,7 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
>  {
>  	struct vb2_queue *q = vb->vb2_queue;
>  	unsigned long flags;
> +	unsigned int plane;
> 
>  	if (vb->state != VB2_BUF_STATE_ACTIVE)
>  		return;
> @@ -800,6 +801,10 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
>  	dprintk(4, "Done processing on buffer %d, state: %d\n",
>  			vb->v4l2_buf.index, vb->state);
> 
> +	/* sync buffers */
> +	for (plane = 0; plane < vb->num_planes; ++plane)
> +		call_memop(q, finish, vb->planes[plane].mem_priv);
> +
>  	/* Add the buffer to the done buffers list */
>  	spin_lock_irqsave(&q->done_lock, flags);
>  	vb->state = state;
> @@ -975,9 +980,15 @@ static int __qbuf_mmap(struct vb2_buffer *vb, const struct v4l2_buffer
> *b)
>  static void __enqueue_in_driver(struct vb2_buffer *vb)
>  {
>  	struct vb2_queue *q = vb->vb2_queue;
> +	unsigned int plane;
> 
>  	vb->state = VB2_BUF_STATE_ACTIVE;
>  	atomic_inc(&q->queued_count);
> +
> +	/* sync buffers */
> +	for (plane = 0; plane < vb->num_planes; ++plane)
> +		call_memop(q, prepare, vb->planes[plane].mem_priv);
> +
>  	q->ops->buf_queue(vb);
>  }
> 
> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> index 8dd9b6c..2508609 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h
> @@ -41,6 +41,10 @@ struct vb2_fileio_data;
>   *		 argument to other ops in this structure
>   * @put_userptr: inform the allocator that a USERPTR buffer will no longer
>   *		 be used
> + * @prepare:	called every time the buffer is passed from userspace to the
> + *		driver, usefull for cache synchronisation, optional
> + * @finish:	called every time the buffer is passed back from the driver
> + *		to the userspace, also optional
>   * @vaddr:	return a kernel virtual address to a given memory buffer
>   *		associated with the passed private structure or NULL if no
>   *		such mapping exists
> @@ -65,6 +69,9 @@ struct vb2_mem_ops {
>  					unsigned long size, int write);
>  	void		(*put_userptr)(void *buf_priv);
> 
> +	void		(*prepare)(void *buf_priv);
> +	void		(*finish)(void *buf_priv);
> +
>  	void		*(*vaddr)(void *buf_priv);
>  	void		*(*cookie)(void *buf_priv);
> 
> --
> 1.7.11.4

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


