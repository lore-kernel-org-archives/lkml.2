Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751779Ab0K3OcG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 09:32:06 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:63226 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936Ab0K3OcF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 09:32:05 -0500
Date: Tue, 30 Nov 2010 15:31:52 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Alberto Panizzo <maramaopercheseimorto@gmail.com>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Magnus Damm <damm@opensource.se>,
        =?ISO-8859-1?Q?M=E1rton_N=E9meth?= <nm127@freemail.hu>,
        linux-media@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH 2/3] mx3_camera: Support correctly the YUV222 and BAYER
 configurations of CSI
In-Reply-To: <1291127115.6537.5.camel@realization>
Message-ID: <Pine.LNX.4.64.1011301530170.18790@axis700.grange>
References: <1290964687.3016.5.camel@realization>  <1290965045.3016.11.camel@realization>
 <1291127115.6537.5.camel@realization>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V02:K0:5GnYcJ+0F8GawjlHUUJZvP+9oSznV9C6IqRKRBVvp65
 PqEQa6+U6LEgp8+EVyxHr/QqZAhVUjbpNcm67T93b/vWEKUwXL
 eK/LHFFw2d8o2/9JfIOUZMpdAsTabnHOZ2S4gD9Nhx8hhgQOKN
 R/Ie0bz97yJh3HZiJ7hmceIQsEwMuEMBdtNnOjHH9KR0aza9ND
 W1oiAsEXmc9Mwfk11LiqO07mUfqY70H1eLzRX1ZKjs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Nov 2010, Alberto Panizzo wrote:

> On dom, 2010-11-28 at 18:24 +0100, Alberto Panizzo wrote:
> > This patch is tested and works with the OV2640 camera that output
> > YUV422 (UYVY) and RGB565 data.
> > 
> > The YUV422 format is managed to be converted in IPU internal YUV444 format
> > so this stream could be used in the future to feed directly other IPU
> > blocks.
> > The RGB565 format is managed as GENERIC and can be moved only from CSI
> > to memory.
> > 
> > Signed-off-by: Alberto Panizzo <maramaopercheseimorto@gmail.com>
> > ---
> > 
> > Before applying, please give me feedback if this break in some way other
> > pixel formats!
> > 
> > 
> 
> Hi Guennadi,
> Have you got time to test this patch?
> I think that this will solve the problems that lead to the need of
> translating the 10 bits mbus codes to the corresponding 8 bit ones.

Yes, I certainly will review and (hopefully) test this patch, just, 
please, give me some time. Since this is 2.6.38 material anyway, we still 
have a bit of time.

Thanks
Guennadi

> 
> Best regards,
> Alberto!
> 
> >  drivers/media/video/mx3_camera.c |  126 +++++++++++++++++++++++++++++++++-----
> >  1 files changed, 110 insertions(+), 16 deletions(-)
> > 
> > diff --git a/drivers/media/video/mx3_camera.c b/drivers/media/video/mx3_camera.c
> > index 29c5fc3..6811d6f 100644
> > --- a/drivers/media/video/mx3_camera.c
> > +++ b/drivers/media/video/mx3_camera.c
> > @@ -55,6 +55,31 @@
> >  #define CSI_SENS_CONF_EXT_VSYNC_SHIFT		15
> >  #define CSI_SENS_CONF_DIVRATIO_SHIFT		16
> >  
> > +/*
> > + * IPU support the following data formatting (44.1.1.3 Data Flows and Formats):
> > + * 1 YUV 4:4:4 or RGB—8 bits per color component
> > + * 2 YUV 4:4:4 or RGB—10 bits per color component
> > + * 3 Generic data (from sensor to the system memory only)
> > + * The formats 1 and 2 are aligned in words of 32 bits, 3 is free and not
> > + * recognized by IPU blocks.
> > + *
> > + * Taking the value of SENS_DATA_FORMAT and DATA_WIDTH, the CSI tries to
> > + * align (or rearrange) the sampled data to fit the IPU supported formats
> > + * as follows:
> > + * - CSI_SENS_CONF_DATA_FMT_RGB_YUV444: It consider the pixel as a sequence of
> > + *	3 components of width DATA_WIDTH aligning these to a 32 bit word.
> > + *	The CSI output in this case can feed other IPU blocks.
> > + * - CSI_SENS_CONF_DATA_FMT_YUV422: It consider the pixel as a sequence of
> > + *	2 components of width DATA_WIDTH were the first is the alternating U V
> > + *	components and the second is Y. It construct the YUV444 word repeating
> > + *	the previous U, V samples aligning the results to a 32 bit word.
> > + *	The CSI output in this case can feed other IPU blocks.
> > + * - CSI_SENS_CONF_DATA_FMT_BAYER: No rework is performed in this case.
> > + *	The sensor data is given as is, considering _every sample_ as a pixel
> > + *	data. This format (combined with the GENERIC IPU pixel formats) can
> > + *	carry all the other sensor pixel formats to the system memory.
> > + *	The CSI output in this case _can not_ feed other IPU blocks.
> > + */
> >  #define CSI_SENS_CONF_DATA_FMT_RGB_YUV444	(0UL << CSI_SENS_CONF_DATA_FMT_SHIFT)
> >  #define CSI_SENS_CONF_DATA_FMT_YUV422		(2UL << CSI_SENS_CONF_DATA_FMT_SHIFT)
> >  #define CSI_SENS_CONF_DATA_FMT_BAYER		(3UL << CSI_SENS_CONF_DATA_FMT_SHIFT)
> > @@ -323,14 +348,12 @@ static enum pixel_fmt fourcc_to_ipu_pix(__u32 fourcc)
> >  {
> >  	/* Add more formats as need arises and test possibilities appear... */
> >  	switch (fourcc) {
> > -	case V4L2_PIX_FMT_RGB565:
> > -		return IPU_PIX_FMT_RGB565;
> >  	case V4L2_PIX_FMT_RGB24:
> >  		return IPU_PIX_FMT_RGB24;
> > +	case V4L2_PIX_FMT_UYVY:
> > +		return IPU_PIX_FMT_UYVY;
> > +	case V4L2_PIX_FMT_RGB565:
> >  	case V4L2_PIX_FMT_RGB332:
> > -		return IPU_PIX_FMT_RGB332;
> > -	case V4L2_PIX_FMT_YUV422P:
> > -		return IPU_PIX_FMT_YVU422P;
> >  	default:
> >  		return IPU_PIX_FMT_GENERIC;
> >  	}
> > @@ -358,9 +381,25 @@ static void mx3_videobuf_queue(struct videobuf_queue *vq,
> >  
> >  	/* This is the configuration of one sg-element */
> >  	video->out_pixel_fmt	= fourcc_to_ipu_pix(fourcc);
> > -	video->out_width	= icd->user_width;
> > -	video->out_height	= icd->user_height;
> > -	video->out_stride	= icd->user_width;
> > +
> > +	if (video->out_pixel_fmt == IPU_PIX_FMT_GENERIC) {
> > +		/*
> > +		 * IPU_PIX_FMT_GENERIC transport bytes, not pixels. So convert
> > +		 * video->out_width and stride to the correct unit.
> > +		 */
> > +		int bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
> > +						icd->current_fmt->host_fmt);
> > +		BUG_ON(bytes_per_line <= 0);
> > +
> > +		video->out_width	= bytes_per_line;
> > +		video->out_height	= icd->user_height;
> > +		video->out_stride	= bytes_per_line;
> > +	} else {
> > +		/* For IPU known formats the pixel unit is OK */
> > +		video->out_width	= icd->user_width;
> > +		video->out_height	= icd->user_height;
> > +		video->out_stride	= icd->user_width;
> > +	}
> >  
> >  #ifdef DEBUG
> >  	/* helps to see what DMA actually has written */
> > @@ -730,18 +769,68 @@ static int mx3_camera_get_formats(struct soc_camera_device *icd, unsigned int id
> >  	if (xlate) {
> >  		xlate->host_fmt	= fmt;
> >  		xlate->code	= code;
> > +		dev_dbg(dev, "Providing format %c%c%c%c in pass-through mode\n",
> > +			(xlate->host_fmt->fourcc >> (0*8)) & 0xFF,
> > +			(xlate->host_fmt->fourcc >> (1*8)) & 0xFF,
> > +			(xlate->host_fmt->fourcc >> (2*8)) & 0xFF,
> > +			(xlate->host_fmt->fourcc >> (3*8)) & 0xFF);
> >  		xlate++;
> > -		dev_dbg(dev, "Providing format %x in pass-through mode\n",
> > -			xlate->host_fmt->fourcc);
> >  	}
> >  
> >  	return formats;
> >  }
> >  
> > +static int samples_per_pixel(enum v4l2_mbus_pixelcode mcode)
> > +{
> > +	switch (mcode) {
> > +	case V4L2_MBUS_FMT_YUYV8_2X8:
> > +	case V4L2_MBUS_FMT_YVYU8_2X8:
> > +	case V4L2_MBUS_FMT_VYUY8_2X8:
> > +	case V4L2_MBUS_FMT_YVYU10_2X10:
> > +	case V4L2_MBUS_FMT_YUYV10_2X10:
> > +	case V4L2_MBUS_FMT_RGB444_2X8_PADHI_LE:
> > +	case V4L2_MBUS_FMT_RGB444_2X8_PADHI_BE:
> > +	case V4L2_MBUS_FMT_RGB555_2X8_PADHI_LE:
> > +	case V4L2_MBUS_FMT_RGB555_2X8_PADHI_BE:
> > +	case V4L2_MBUS_FMT_RGB565_2X8_LE:
> > +	case V4L2_MBUS_FMT_RGB565_2X8_BE:
> > +	case V4L2_MBUS_FMT_BGR565_2X8_LE:
> > +	case V4L2_MBUS_FMT_BGR565_2X8_BE:
> > +		return 2;
> > +	case V4L2_MBUS_FMT_SBGGR8_1X8:
> > +	case V4L2_MBUS_FMT_SBGGR10_1X10:
> > +	case V4L2_MBUS_FMT_GREY8_1X8:
> > +	case V4L2_MBUS_FMT_Y10_1X10:
> > +	case V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE:
> > +	case V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_BE:
> > +	case V4L2_MBUS_FMT_SGRBG8_1X8:
> > +		return 1;
> > +	default:
> > +		/* Add other pixel codes as needed */
> > +		return 0;
> > +	}
> > +}
> > +
> >  static void configure_geometry(struct mx3_camera_dev *mx3_cam,
> > -			       unsigned int width, unsigned int height)
> > +			       unsigned int width, unsigned int height,
> > +			       enum v4l2_mbus_pixelcode code)
> >  {
> >  	u32 ctrl, width_field, height_field;
> > +	const struct soc_mbus_pixelfmt *fmt;
> > +
> > +	fmt = soc_mbus_get_fmtdesc(code);
> > +	BUG_ON(!fmt);
> > +
> > +	if (fourcc_to_ipu_pix(fmt->fourcc) == IPU_PIX_FMT_GENERIC) {
> > +		/*
> > +		 * As we don't have an IPU native format, the CSI will be
> > +		 * configured to output BAYER and here we need to convert
> > +		 * geometry unit from pixels to samples.
> > +		 * TODO: Support vertical down sampling (YUV420)
> > +		 */
> > +		width = width * samples_per_pixel(code);
> > +		BUG_ON(!width);
> > +	}
> >  
> >  	/* Setup frame size - this cannot be changed on-the-fly... */
> >  	width_field = width - 1;
> > @@ -850,7 +939,7 @@ static int mx3_camera_set_crop(struct soc_camera_device *icd,
> >  				return ret;
> >  		}
> >  
> > -		configure_geometry(mx3_cam, mf.width, mf.height);
> > +		configure_geometry(mx3_cam, mf.width, mf.height, mf.code);
> >  	}
> >  
> >  	dev_dbg(icd->dev.parent, "Sensor cropped %dx%d\n",
> > @@ -893,7 +982,7 @@ static int mx3_camera_set_fmt(struct soc_camera_device *icd,
> >  	 * mxc_v4l2_s_fmt()
> >  	 */
> >  
> > -	configure_geometry(mx3_cam, pix->width, pix->height);
> > +	configure_geometry(mx3_cam, pix->width, pix->height, xlate->code);
> >  
> >  	mf.width	= pix->width;
> >  	mf.height	= pix->height;
> > @@ -1112,10 +1201,15 @@ static int mx3_camera_set_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
> >  		  (3 << CSI_SENS_CONF_DATA_FMT_SHIFT) |
> >  		  (3 << CSI_SENS_CONF_DATA_WIDTH_SHIFT));
> >  
> > -	/* TODO: Support RGB and YUV formats */
> > +	/* TODO: Support RGB_YUV444 formats */
> >  
> > -	/* This has been set in mx3_camera_activate(), but we clear it above */
> > -	sens_conf |= CSI_SENS_CONF_DATA_FMT_BAYER;
> > +	switch (xlate->code) {
> > +	case V4L2_MBUS_FMT_UYVY8_2X8:
> > +		sens_conf |= CSI_SENS_CONF_DATA_FMT_YUV422;
> > +		break;
> > +	default:
> > +		sens_conf |= CSI_SENS_CONF_DATA_FMT_BAYER;
> > +	}
> >  
> >  	if (common_flags & SOCAM_PCLK_SAMPLE_FALLING)
> >  		sens_conf |= 1 << CSI_SENS_CONF_PIX_CLK_POL_SHIFT;
> 
> 
> -- 
> Alberto!
> 
>         Be Persistent!
>                 - Greg Kroah-Hartman (FOSDEM 2010)
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
