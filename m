Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278Ab2IWRQQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 13:16:16 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:50838 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417Ab2IWRQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 13:16:15 -0400
From: Federico Vaga <federico.vaga@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH v2 3/4] sta2x11_vip: convert to videobuf2 and control framework
Date: Sun, 23 Sep 2012 19:20:04 +0200
Message-ID: <1568507.e1NUzqJ3mL@harkonnen>
User-Agent: KMail/4.8.5 (Linux/3.5.3-1.fc17.x86_64; KDE/4.8.5; x86_64; ; )
In-Reply-To: <201209211147.06204.hverkuil@xs4all.nl>
References: <1348219298-23273-1-git-send-email-federico.vaga@gmail.com> <1348219298-23273-3-git-send-email-federico.vaga@gmail.com> <201209211147.06204.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +struct sta2x11_vip_fh {
> > +	struct v4l2_fh fh;
> > +};
> 
> No need to make a sta2x11_vip_fh struct, just use v4l2_fh directly. It
> doesn't add anything. In fact, it's not even used.

Thank you :)


> >  static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
> >  
> >  				  struct v4l2_format *f)
> >  
> >  {
> > 
> > -	struct video_device *dev = priv;
> > -	struct sta2x11_vip *vip = video_get_drvdata(dev);
> > +	struct sta2x11_vip *vip = video_drvdata(file);
> > 
> >  	int interlace_lim;
> > 
> > -	if (V4L2_PIX_FMT_UYVY != f->fmt.pix.pixelformat)
> > -		return -EINVAL;
> > -
> > 
> >  	if (V4L2_STD_525_60 & vip->std)
> >  	
> >  		interlace_lim = 240;
> >  	
> >  	else
> > 
> > @@ -827,6 +522,8 @@ static int vidioc_try_fmt_vid_cap(struct file
> > *file, void *priv,> 
> >  		return -EINVAL;
> 
> No -EINVAL allowed anymore in try_fmt_vid_cap. I generally handle
> unknown field values in try_fmt_vid_cap as if FIELD_ANY was
> specified.

ok, unknown -> any

> > 
> >  	memcpy(&vip->format, &f->fmt.pix, sizeof(struct 
v4l2_pix_format));
> 
> Just use an assignment: vip->format = f->fmt.pix
> 

> > 
> >  	memcpy(&f->fmt.pix, &vip->format, sizeof(struct 
v4l2_pix_format));
> 
> Assignment
> 

Fixed


> > -
> > 
> >  static const struct v4l2_ioctl_ops vip_ioctl_ops = {
> >  
> >  	.vidioc_querycap = vidioc_querycap,
> > 
> > -	.vidioc_s_std = vidioc_s_std,
> > +	/* FMT handling */
> > +	.vidioc_enum_fmt_vid_cap = vidioc_enum_fmt_vid_cap,
> > +	.vidioc_g_fmt_vid_cap = vidioc_g_fmt_vid_cap,
> > +	.vidioc_s_fmt_vid_cap = vidioc_s_fmt_vid_cap,
> > +	.vidioc_try_fmt_vid_cap = vidioc_try_fmt_vid_cap,
> > +	/* Buffer handlers */
> > +	.vidioc_reqbufs = vb2_ioctl_reqbufs,
> > +	.vidioc_querybuf = vb2_ioctl_querybuf,
> > +	.vidioc_qbuf = vb2_ioctl_qbuf,
> > +	.vidioc_dqbuf = vb2_ioctl_dqbuf,
> > +	.vidioc_create_bufs = vb2_ioctl_create_bufs,
> 
> If you want to use create_bufs, then in queue_setup() you need to
> handle the fmt argument. See e.g. vivi.c for an example.

Fixed

I will send a patch v3 tomorrow
-- 
Federico Vaga
