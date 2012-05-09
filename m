Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756956Ab2EIK7m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 06:59:42 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:20878 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584Ab2EIK7k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 06:59:40 -0400
Date: Wed, 09 May 2012 12:59:34 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH 1/1] v4l: mem2mem_testdev: Fix race conditions in driver.
In-reply-to: <1336423141-10956-1-git-send-email-desowin@gmail.com>
To: "=?utf-8?Q?'Tomasz_Mo=C5=84'?=" <desowin@gmail.com>,
        "'Mauro Carvalho Chehab'" <mchehab@infradead.org>,
        "'Guennadi Liakhovetski'" <g.liakhovetski@gmx.de>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, pawel@osciak.com
Message-id: <005301cd2dd2$d1972ca0$74c585e0$%szyprowski@samsung.com>
Organization: SPRC
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=utf-8
Content-language: pl
Content-transfer-encoding: 8BIT
Thread-index: Ac0skbMV8KX0M6ImSwa9nx5avE1rvABPYp5g
References: <1336423141-10956-1-git-send-email-desowin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

On Monday, May 07, 2012 10:39 PM Tomasz Moń wrote:

> The mem2mem_testdev allows multiple instances to be opened in parallel.
> Source and destination queue data are being shared between all
> instances, which can lead to kernel oops due to race conditions (most
> likely to happen inside device_run()).
> 
> Attached patch fixes mentioned problem by storing queue data per device
> context.
> 
> Signed-off-by: Tomasz Moń <desowin@gmail.com>

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

Thanks for fixing this bug!

> ---
>  drivers/media/video/mem2mem_testdev.c |   50 +++++++++++++++++----------------
>  1 file changed, 26 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/media/video/mem2mem_testdev.c b/drivers/media/video/mem2mem_testdev.c
> index 12897e8..ae7ca12 100644
> --- a/drivers/media/video/mem2mem_testdev.c
> +++ b/drivers/media/video/mem2mem_testdev.c
> @@ -110,22 +110,6 @@ enum {
>  	V4L2_M2M_DST = 1,
>  };
> 
> -/* Source and destination queue data */
> -static struct m2mtest_q_data q_data[2];
> -
> -static struct m2mtest_q_data *get_q_data(enum v4l2_buf_type type)
> -{
> -	switch (type) {
> -	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
> -		return &q_data[V4L2_M2M_SRC];
> -	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
> -		return &q_data[V4L2_M2M_DST];
> -	default:
> -		BUG();
> -	}
> -	return NULL;
> -}
> -
>  #define V4L2_CID_TRANS_TIME_MSEC	V4L2_CID_PRIVATE_BASE
>  #define V4L2_CID_TRANS_NUM_BUFS		(V4L2_CID_PRIVATE_BASE + 1)
> 
> @@ -198,8 +182,26 @@ struct m2mtest_ctx {
>  	int			aborting;
> 
>  	struct v4l2_m2m_ctx	*m2m_ctx;
> +
> +	/* Source and destination queue data */
> +	struct m2mtest_q_data   q_data[2];
>  };
> 
> +static struct m2mtest_q_data *get_q_data(struct m2mtest_ctx *ctx,
> +					 enum v4l2_buf_type type)
> +{
> +	switch (type) {
> +	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
> +		return &ctx->q_data[V4L2_M2M_SRC];
> +	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
> +		return &ctx->q_data[V4L2_M2M_DST];
> +	default:
> +		BUG();
> +	}
> +	return NULL;
> +}
> +
> +
>  static struct v4l2_queryctrl *get_ctrl(int id)
>  {
>  	int i;
> @@ -223,7 +225,7 @@ static int device_process(struct m2mtest_ctx *ctx,
>  	int tile_w, bytes_left;
>  	int width, height, bytesperline;
> 
> -	q_data = get_q_data(V4L2_BUF_TYPE_VIDEO_OUTPUT);
> +	q_data = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
> 
>  	width	= q_data->width;
>  	height	= q_data->height;
> @@ -436,7 +438,7 @@ static int vidioc_g_fmt(struct m2mtest_ctx *ctx, struct v4l2_format *f)
>  	if (!vq)
>  		return -EINVAL;
> 
> -	q_data = get_q_data(f->type);
> +	q_data = get_q_data(ctx, f->type);
> 
>  	f->fmt.pix.width	= q_data->width;
>  	f->fmt.pix.height	= q_data->height;
> @@ -535,7 +537,7 @@ static int vidioc_s_fmt(struct m2mtest_ctx *ctx, struct v4l2_format *f)
>  	if (!vq)
>  		return -EINVAL;
> 
> -	q_data = get_q_data(f->type);
> +	q_data = get_q_data(ctx, f->type);
>  	if (!q_data)
>  		return -EINVAL;
> 
> @@ -747,7 +749,7 @@ static int m2mtest_queue_setup(struct vb2_queue *vq,
>  	struct m2mtest_q_data *q_data;
>  	unsigned int size, count = *nbuffers;
> 
> -	q_data = get_q_data(vq->type);
> +	q_data = get_q_data(ctx, vq->type);
> 
>  	size = q_data->width * q_data->height * q_data->fmt->depth >> 3;
> 
> @@ -775,7 +777,7 @@ static int m2mtest_buf_prepare(struct vb2_buffer *vb)
> 
>  	dprintk(ctx->dev, "type: %d\n", vb->vb2_queue->type);
> 
> -	q_data = get_q_data(vb->vb2_queue->type);
> +	q_data = get_q_data(ctx, vb->vb2_queue->type);
> 
>  	if (vb2_plane_size(vb, 0) < q_data->sizeimage) {
>  		dprintk(ctx->dev, "%s data will not fit into plane (%lu < %lu)\n",
> @@ -860,6 +862,9 @@ static int m2mtest_open(struct file *file)
>  	ctx->transtime = MEM2MEM_DEF_TRANSTIME;
>  	ctx->num_processed = 0;
> 
> +	ctx->q_data[V4L2_M2M_SRC].fmt = &formats[0];
> +	ctx->q_data[V4L2_M2M_DST].fmt = &formats[0];
> +
>  	ctx->m2m_ctx = v4l2_m2m_ctx_init(dev->m2m_dev, ctx, &queue_init);
> 
>  	if (IS_ERR(ctx->m2m_ctx)) {
> @@ -982,9 +987,6 @@ static int m2mtest_probe(struct platform_device *pdev)
>  		goto err_m2m;
>  	}
> 
> -	q_data[V4L2_M2M_SRC].fmt = &formats[0];
> -	q_data[V4L2_M2M_DST].fmt = &formats[0];
> -
>  	return 0;
> 
>  	v4l2_m2m_release(dev->m2m_dev);
> --
> 1.7.10

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center



