Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679Ab2L0Lzd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 06:55:33 -0500
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:4898 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146Ab2L0Lz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 06:55:29 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Kirill Smelkov <kirr@navytux.spb.ru>
Subject: Re: [PATCH] [media] vivi: Constify structures
Date: Thu, 27 Dec 2012 12:55:11 +0100
User-Agent: KMail/1.13.7 (Linux/3.7.0-rc1-tschai; KDE/4.8.4; x86_64; ; )
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1356535783-24173-1-git-send-email-kirr@navytux.spb.ru>
In-Reply-To: <1356535783-24173-1-git-send-email-kirr@navytux.spb.ru>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201212271255.11159.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed December 26 2012 16:29:43 Kirill Smelkov wrote:
> Most of *_ops and other structures in vivi.c were already declared const
> but some have not. Constify and code/data will take less space:
> 
>     $ size drivers/media/platform/vivi.o
>               text    data     bss     dec     hex filename
>     before:  12569     248       8   12825    3219 drivers/media/platform/vivi.o
>     after:   12308      20       8   12336    3030 drivers/media/platform/vivi.o
> 
> i.e. vivi.o is now ~500 bytes less.
> 
> Signed-off-by: Kirill Smelkov <kirr@navytux.spb.ru>
> ---
>  drivers/media/platform/vivi.c | 26 +++++++++++++-------------
>  1 file changed, 13 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/media/platform/vivi.c b/drivers/media/platform/vivi.c
> index ec65089..bed04e1 100644
> --- a/drivers/media/platform/vivi.c
> +++ b/drivers/media/platform/vivi.c
> @@ -91,13 +91,13 @@ static const struct v4l2_fract
>     ------------------------------------------------------------------*/
>  
>  struct vivi_fmt {
> -	char  *name;
> +	const char  *name;

Just use one space before '*' since it no longer lines up to anything.

>  	u32   fourcc;          /* v4l2 format id */
>  	u8    depth;
>  	bool  is_yuv;
>  };
>  
> -static struct vivi_fmt formats[] = {
> +static const struct vivi_fmt formats[] = {
>  	{
>  		.name     = "4:2:2, packed, YUYV",
>  		.fourcc   = V4L2_PIX_FMT_YUYV,
> @@ -164,9 +164,9 @@ static struct vivi_fmt formats[] = {
>  	},
>  };
>  
> -static struct vivi_fmt *__get_format(u32 pixelformat)
> +static const struct vivi_fmt *__get_format(u32 pixelformat)
>  {
> -	struct vivi_fmt *fmt;
> +	const struct vivi_fmt *fmt;
>  	unsigned int k;
>  
>  	for (k = 0; k < ARRAY_SIZE(formats); k++) {
> @@ -181,7 +181,7 @@ static struct vivi_fmt *__get_format(u32 pixelformat)
>  	return &formats[k];
>  }
>  
> -static struct vivi_fmt *get_format(struct v4l2_format *f)
> +static const struct vivi_fmt *get_format(struct v4l2_format *f)
>  {
>  	return __get_format(f->fmt.pix.pixelformat);
>  }
> @@ -191,7 +191,7 @@ struct vivi_buffer {
>  	/* common v4l buffer stuff -- must be first */
>  	struct vb2_buffer	vb;
>  	struct list_head	list;
> -	struct vivi_fmt        *fmt;
> +	struct vivi_fmt const  *fmt;
>  };
>  
>  struct vivi_dmaqueue {
> @@ -250,7 +250,7 @@ struct vivi_dev {
>  	int			   input;
>  
>  	/* video capture */
> -	struct vivi_fmt            *fmt;
> +	struct vivi_fmt const      *fmt;

'const' should be before 'struct' for consistency reasons.

>  	struct v4l2_fract          timeperframe;
>  	unsigned int               width, height;
>  	struct vb2_queue	   vb_vidq;
> @@ -297,7 +297,7 @@ struct bar_std {
>  
>  /* Maximum number of bars are 10 - otherwise, the input print code
>     should be modified */
> -static struct bar_std bars[] = {
> +static const struct bar_std bars[] = {
>  	{	/* Standard ITU-R color bar sequence */
>  		{ COLOR_WHITE, COLOR_AMBER, COLOR_CYAN, COLOR_GREEN,
>  		  COLOR_MAGENTA, COLOR_RED, COLOR_BLUE, COLOR_BLACK, COLOR_BLACK }
> @@ -926,7 +926,7 @@ static void vivi_unlock(struct vb2_queue *vq)
>  }
>  
>  
> -static struct vb2_ops vivi_video_qops = {
> +static const struct vb2_ops vivi_video_qops = {
>  	.queue_setup		= queue_setup,
>  	.buf_prepare		= buffer_prepare,
>  	.buf_queue		= buffer_queue,
> @@ -957,7 +957,7 @@ static int vidioc_querycap(struct file *file, void  *priv,
>  static int vidioc_enum_fmt_vid_cap(struct file *file, void  *priv,
>  					struct v4l2_fmtdesc *f)
>  {
> -	struct vivi_fmt *fmt;
> +	struct vivi_fmt const *fmt;

Ditto.

>  
>  	if (f->index >= ARRAY_SIZE(formats))
>  		return -EINVAL;
> @@ -993,7 +993,7 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
>  			struct v4l2_format *f)
>  {
>  	struct vivi_dev *dev = video_drvdata(file);
> -	struct vivi_fmt *fmt;
> +	struct vivi_fmt const *fmt;

Ditto.

>  
>  	fmt = get_format(f);
>  	if (!fmt) {
> @@ -1102,7 +1102,7 @@ static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
>  static int vidioc_enum_frameintervals(struct file *file, void *priv,
>  					     struct v4l2_frmivalenum *fival)
>  {
> -	struct vivi_fmt *fmt;
> +	struct vivi_fmt const *fmt;

Ditto.

>  
>  	if (fival->index)
>  		return -EINVAL;
> @@ -1330,7 +1330,7 @@ static const struct v4l2_ioctl_ops vivi_ioctl_ops = {
>  	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
>  };
>  
> -static struct video_device vivi_template = {
> +static const struct video_device vivi_template = {
>  	.name		= "vivi",
>  	.fops           = &vivi_fops,
>  	.ioctl_ops 	= &vivi_ioctl_ops,
> 

Regards,

	Hans
