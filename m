Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756551Ab2IMKQm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 06:16:42 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:59407 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521Ab2IMKQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 06:16:40 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 4/5] video:omap3isp:fix up ENOIOCTLCMD error handling
Date: Thu, 13 Sep 2012 06:03:21 +0200
Message-ID: <1946796.hhZ2Ot34qB@avalon>
User-Agent: KMail/4.8.3 (Linux/3.3.8-gentoo; KDE/4.8.3; x86_64; ; )
In-Reply-To: <1346052196-32682-5-git-send-email-gaowanlong@cn.fujitsu.com>
References: <1346052196-32682-1-git-send-email-gaowanlong@cn.fujitsu.com> <1346052196-32682-5-git-send-email-gaowanlong@cn.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wanlong,

Thanks for the patch.

On Monday 27 August 2012 15:23:15 Wanlong Gao wrote:
> At commit 07d106d0, Linus pointed out that ENOIOCTLCMD should be
> translated as ENOTTY to user mode.
> 
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> Cc: linux-media@vger.kernel.org
> Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
> ---
>  drivers/media/video/omap3isp/ispvideo.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/video/omap3isp/ispvideo.c
> b/drivers/media/video/omap3isp/ispvideo.c index b37379d..2dd982e 100644
> --- a/drivers/media/video/omap3isp/ispvideo.c
> +++ b/drivers/media/video/omap3isp/ispvideo.c
> @@ -337,7 +337,7 @@ __isp_video_get_format(struct isp_video *video, struct
> v4l2_format *format) fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
>  	ret = v4l2_subdev_call(subdev, pad, get_fmt, NULL, &fmt);
>  	if (ret == -ENOIOCTLCMD)
> -		ret = -EINVAL;
> +		ret = -ENOTTY;

I don't think this location should be changed. __isp_video_get_format() is 
called by isp_video_check_format() only, which in turn is called by 
isp_video_streamon() only. A failure to retrieve the format in 
__isp_video_get_format() does not really mean the VIDIOC_STREAMON is not 
supported.

I'll apply hunks 2 to 5 and drop hunk 1 if that's fine with you.

> 
>  	mutex_unlock(&video->mutex);
> 
> @@ -723,7 +723,7 @@ isp_video_try_format(struct file *file, void *fh, struct
> v4l2_format *format) fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
>  	ret = v4l2_subdev_call(subdev, pad, get_fmt, NULL, &fmt);
>  	if (ret)
> -		return ret == -ENOIOCTLCMD ? -EINVAL : ret;
> +		return ret == -ENOIOCTLCMD ? -ENOTTY : ret;
> 
>  	isp_video_mbus_to_pix(video, &fmt.format, &format->fmt.pix);
>  	return 0;
> @@ -744,7 +744,7 @@ isp_video_cropcap(struct file *file, void *fh, struct
> v4l2_cropcap *cropcap) ret = v4l2_subdev_call(subdev, video, cropcap,
> cropcap);
>  	mutex_unlock(&video->mutex);
> 
> -	return ret == -ENOIOCTLCMD ? -EINVAL : ret;
> +	return ret == -ENOIOCTLCMD ? -ENOTTY : ret;
>  }
> 
>  static int
> @@ -771,7 +771,7 @@ isp_video_get_crop(struct file *file, void *fh, struct
> v4l2_crop *crop) format.which = V4L2_SUBDEV_FORMAT_ACTIVE;
>  	ret = v4l2_subdev_call(subdev, pad, get_fmt, NULL, &format);
>  	if (ret < 0)
> -		return ret == -ENOIOCTLCMD ? -EINVAL : ret;
> +		return ret == -ENOIOCTLCMD ? -ENOTTY : ret;
> 
>  	crop->c.left = 0;
>  	crop->c.top = 0;
> @@ -796,7 +796,7 @@ isp_video_set_crop(struct file *file, void *fh, struct
> v4l2_crop *crop) ret = v4l2_subdev_call(subdev, video, s_crop, crop);
>  	mutex_unlock(&video->mutex);
> 
> -	return ret == -ENOIOCTLCMD ? -EINVAL : ret;
> +	return ret == -ENOIOCTLCMD ? -ENOTTY : ret;
>  }
> 
>  static int

-- 
Regards,

Laurent Pinchart

