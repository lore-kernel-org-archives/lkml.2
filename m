Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500Ab3AGJrc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 04:47:32 -0500
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:3831 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519Ab3AGJrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 04:47:31 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Federico Vaga <federico.vaga@gmail.com>
Subject: Re: [PATCH V4 2/3] sta2x11_vip: convert to videobuf2 and control framework
Date: Mon, 7 Jan 2013 10:46:43 +0100
User-Agent: KMail/1.13.7 (Linux/3.8.0-rc1-tschai; KDE/4.8.4; x86_64; ; )
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>
References: <1357493343-13090-1-git-send-email-federico.vaga@gmail.com> <1357493343-13090-2-git-send-email-federico.vaga@gmail.com>
In-Reply-To: <1357493343-13090-2-git-send-email-federico.vaga@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301071046.43331.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frederico!

Just one comment, see below:

On Sun January 6 2013 18:29:02 Federico Vaga wrote:
> This patch re-write the driver and use the videobuf2
> interface instead of the old videobuf. Moreover, it uses also
> the control framework which allows the driver to inherit
> controls from its subdevice (ADV7180)
> 
> Signed-off-by: Federico Vaga <federico.vaga@gmail.com>
> Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
> ---
>  drivers/media/pci/sta2x11/Kconfig       |    2 +-
>  drivers/media/pci/sta2x11/sta2x11_vip.c | 1244 ++++++++++---------------------
>  2 file modificati, 414 inserzioni(+), 832 rimozioni(-)
> 
> diff --git a/drivers/media/pci/sta2x11/Kconfig b/drivers/media/pci/sta2x11/Kconfig
> index 6749f67..a94ccad 100644
> --- a/drivers/media/pci/sta2x11/Kconfig
> +++ b/drivers/media/pci/sta2x11/Kconfig
> @@ -2,7 +2,7 @@ config STA2X11_VIP
>  	tristate "STA2X11 VIP Video For Linux"
>  	depends on STA2X11
>  	select VIDEO_ADV7180 if MEDIA_SUBDRV_AUTOSELECT
> -	select VIDEOBUF_DMA_CONTIG
> +	select VIDEOBUF2_DMA_CONTIG
>  	depends on PCI && VIDEO_V4L2 && VIRT_TO_BUS
>  	help
>  	  Say Y for support for STA2X11 VIP (Video Input Port) capture
> diff --git a/drivers/media/pci/sta2x11/sta2x11_vip.c b/drivers/media/pci/sta2x11/sta2x11_vip.c
> index ed1337a..e379e03 100644
> --- a/drivers/media/pci/sta2x11/sta2x11_vip.c
> +++ b/drivers/media/pci/sta2x11/sta2x11_vip.c

<snip>

> -/**
> - * vidioc_try_fmt_vid_cap - set video capture format
> - * @file: descriptor of device ( not used)
> - * @priv: points to current videodevice
> - * @f: new format
> - *
> - * new video format is set which includes width and
> - * field type. width is fixed to 720, no scaling.
> - * Only UYVY is supported by this hardware.
> - * the minimum height is 200, the maximum is 576 (PAL)
> - *
> - * return value: 0, no error
> - *
> - * -EINVAL, pixel or field format not supported
> - *
> - */
>  static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
>  				  struct v4l2_format *f)
>  {
> -	struct video_device *dev = priv;
> -	struct sta2x11_vip *vip = video_get_drvdata(dev);
> +	struct sta2x11_vip *vip = video_drvdata(file);
>  	int interlace_lim;
>  
> -	if (V4L2_PIX_FMT_UYVY != f->fmt.pix.pixelformat)
> -		return -EINVAL;
> -

You should keep this check for now. See this discussion:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg56550.html

I'm going to change v4l2-compliance to make this a warning instead of an
error for now.

>  	if (V4L2_STD_525_60 & vip->std)
>  		interlace_lim = 240;
>  	else
>  		interlace_lim = 288;
>  
>  	switch (f->fmt.pix.field) {
> +	default:
>  	case V4L2_FIELD_ANY:
>  		if (interlace_lim < f->fmt.pix.height)
>  			f->fmt.pix.field = V4L2_FIELD_INTERLACED;

After updating v4l2-compliance (I've just made the change to v4l2-compliance)
can you also post the output of v4l2-compliance for this driver?

Thanks,

	Hans
