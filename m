Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753703Ab1IHXOO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 19:14:14 -0400
Received: from smtp-68.nebula.fi ([83.145.220.68]:44262 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507Ab1IHXOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 19:14:04 -0400
Date: Fri, 9 Sep 2011 00:38:43 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Deepthy Ravi <deepthy.ravi@ti.com>
Cc: linux-media@vger.kernel.org, tony@atomide.com, linux@arm.linux.org.uk,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, mchehab@infradead.org,
        laurent.pinchart@ideasonboard.com, g.liakhovetski@gmx.de,
        Vaibhav Hiremath <hvaibhav@ti.com>
Subject: Re: [PATCH 4/8] ispvideo: Add support for G/S/ENUM_STD ioctl
Message-ID: <20110908213843.GE1724@valkosipuli.localdomain>
References: <1315488922-16152-1-git-send-email-deepthy.ravi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315488922-16152-1-git-send-email-deepthy.ravi@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Deepathy,

Thanks for the patches.

On Thu, Sep 08, 2011 at 07:05:22PM +0530, Deepthy Ravi wrote:
> From: Vaibhav Hiremath <hvaibhav@ti.com>
> 
> In order to support TVP5146 (for that matter any video decoder),
> it is important to support G/S/ENUM_STD ioctl on /dev/videoX
> device node.

Why on video nodes rather than the subdev node?

I don't think *_STD ioctls should be handled differently from any others,
i.e. this is directly related to that subdev, so the control should go
through the subdev node.

That said, generic applications aren't necessarily aware of the subdev nodes
and I think this is something that should be handled in a libv4l plugin.
This appears quite generic to me; walking the graph and accessing the right
subdev node can be done in user space.

> Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
> Signed-off-by: Deepthy Ravi <deepthy.ravi@ti.com>
> ---
>  drivers/media/video/omap3isp/ispvideo.c |   98 ++++++++++++++++++++++++++++++-
>  drivers/media/video/omap3isp/ispvideo.h |    1 +
>  2 files changed, 98 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/omap3isp/ispvideo.c b/drivers/media/video/omap3isp/ispvideo.c
> index d5b8236..ff0ffed 100644
> --- a/drivers/media/video/omap3isp/ispvideo.c
> +++ b/drivers/media/video/omap3isp/ispvideo.c
> @@ -37,6 +37,7 @@
>  #include <plat/iovmm.h>
>  #include <plat/omap-pm.h>
>  
> +#include <media/tvp514x.h>
>  #include "ispvideo.h"
>  #include "isp.h"
>  
> @@ -1136,7 +1137,97 @@ isp_video_g_input(struct file *file, void *fh, unsigned int *input)
>  static int
>  isp_video_s_input(struct file *file, void *fh, unsigned int input)
>  {
> -	return input == 0 ? 0 : -EINVAL;
> +	struct isp_video *video = video_drvdata(file);
> +	struct media_entity *entity = &video->video.entity;
> +	struct media_entity_graph graph;
> +	struct v4l2_subdev *subdev;
> +	struct v4l2_routing route;
> +	int ret = 0;
> +
> +	media_entity_graph_walk_start(&graph, entity);
> +	while ((entity = media_entity_graph_walk_next(&graph))) {
> +		if (media_entity_type(entity) ==
> +				MEDIA_ENT_T_V4L2_SUBDEV) {
> +			subdev = media_entity_to_v4l2_subdev(entity);
> +			if (subdev != NULL) {
> +				if (input == 0)
> +					route.input = INPUT_CVBS_VI4A;
> +				else
> +					route.input = INPUT_SVIDEO_VI2C_VI1C;
> +				route.output = 0;
> +				ret = v4l2_subdev_call(subdev, video, s_routing,
> +						route.input, route.output, 0);
> +				if (ret < 0 && ret != -ENOIOCTLCMD)
> +					return ret;
> +			}
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static int isp_video_querystd(struct file *file, void *fh, v4l2_std_id *a)
> +{
> +	struct isp_video_fh *vfh = to_isp_video_fh(fh);
> +	struct isp_video *video = video_drvdata(file);
> +	struct media_entity *entity = &video->video.entity;
> +	struct media_entity_graph graph;
> +	struct v4l2_subdev *subdev;
> +	int ret = 0;
> +
> +	media_entity_graph_walk_start(&graph, entity);
> +	while ((entity = media_entity_graph_walk_next(&graph))) {
> +		if (media_entity_type(entity) ==
> +				MEDIA_ENT_T_V4L2_SUBDEV) {
> +			subdev = media_entity_to_v4l2_subdev(entity);
> +			if (subdev != NULL) {
> +				ret = v4l2_subdev_call(subdev, video, querystd,
> +						a);
> +				if (ret < 0 && ret != -ENOIOCTLCMD)
> +					return ret;
> +			}
> +		}
> +	}
> +
> +	vfh->standard.id = *a;
> +	return 0;
> +}
> +
> +static int isp_video_g_std(struct file *file, void *fh, v4l2_std_id *norm)
> +{
> +	struct isp_video_fh *vfh = to_isp_video_fh(fh);
> +	struct isp_video *video = video_drvdata(file);
> +
> +	mutex_lock(&video->mutex);
> +	*norm = vfh->standard.id;
> +	mutex_unlock(&video->mutex);
> +
> +	return 0;
> +}
> +
> +static int isp_video_s_std(struct file *file, void *fh, v4l2_std_id *norm)
> +{
> +	struct isp_video *video = video_drvdata(file);
> +	struct media_entity *entity = &video->video.entity;
> +	struct media_entity_graph graph;
> +	struct v4l2_subdev *subdev;
> +	int ret = 0;
> +
> +	media_entity_graph_walk_start(&graph, entity);
> +	while ((entity = media_entity_graph_walk_next(&graph))) {
> +		if (media_entity_type(entity) ==
> +				MEDIA_ENT_T_V4L2_SUBDEV) {
> +			subdev = media_entity_to_v4l2_subdev(entity);
> +			if (subdev != NULL) {
> +				ret = v4l2_subdev_call(subdev, core, s_std,
> +						*norm);
> +				if (ret < 0 && ret != -ENOIOCTLCMD)
> +					return ret;
> +			}
> +		}
> +	}
> +
> +	return 0;
>  }
>  
>  static const struct v4l2_ioctl_ops isp_video_ioctl_ops = {
> @@ -1161,6 +1252,9 @@ static const struct v4l2_ioctl_ops isp_video_ioctl_ops = {
>  	.vidioc_enum_input		= isp_video_enum_input,
>  	.vidioc_g_input			= isp_video_g_input,
>  	.vidioc_s_input			= isp_video_s_input,
> +	.vidioc_querystd		= isp_video_querystd,
> +	.vidioc_g_std			= isp_video_g_std,
> +	.vidioc_s_std			= isp_video_s_std,
>  };
>  
>  /* -----------------------------------------------------------------------------
> @@ -1325,6 +1419,8 @@ int omap3isp_video_register(struct isp_video *video, struct v4l2_device *vdev)
>  		printk(KERN_ERR "%s: could not register video device (%d)\n",
>  			__func__, ret);
>  
> +	video->video.tvnorms		= V4L2_STD_NTSC | V4L2_STD_PAL;
> +	video->video.current_norm	= V4L2_STD_NTSC;
>  	return ret;
>  }
>  
> diff --git a/drivers/media/video/omap3isp/ispvideo.h b/drivers/media/video/omap3isp/ispvideo.h
> index 53160aa..bb8feb6 100644
> --- a/drivers/media/video/omap3isp/ispvideo.h
> +++ b/drivers/media/video/omap3isp/ispvideo.h
> @@ -182,6 +182,7 @@ struct isp_video_fh {
>  	struct isp_video *video;
>  	struct isp_video_queue queue;
>  	struct v4l2_format format;
> +	struct v4l2_standard standard;
>  	struct v4l2_fract timeperframe;
>  };
>  
> -- 
> 1.7.0.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
