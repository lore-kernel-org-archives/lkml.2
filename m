Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822Ab0KYLi3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 06:38:29 -0500
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:2169 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486Ab0KYLi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 06:38:28 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC/PATCH v6 11/12] v4l: Make video_device inherit from media_entity
Date: Thu, 25 Nov 2010 12:38:15 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.32-23-generic; KDE/4.4.5; x86_64; ; )
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, sakari.ailus@maxwell.research.nokia.com,
        broonie@opensource.wolfsonmicro.com, lennart@poettering.net
References: <1290652099-15102-1-git-send-email-laurent.pinchart@ideasonboard.com> <1290652099-15102-12-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1290652099-15102-12-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201011251238.15331.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 25, 2010 03:28:18 Laurent Pinchart wrote:
> V4L2 devices are media entities. As such they need to inherit from
> (include) the media_entity structure.
> 
> When registering/unregistering the device, the media entity is
> automatically registered/unregistered. The entity is acquired on device
> open and released on device close.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
> ---
>  Documentation/video4linux/v4l2-framework.txt |   38 +++++++++++++++++++--
>  drivers/media/video/v4l2-dev.c               |   47 +++++++++++++++++++++++---
>  include/media/v4l2-dev.h                     |    7 ++++
>  3 files changed, 84 insertions(+), 8 deletions(-)
> 

<snip>

> diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
> index 035db52..511e1ee 100644
> --- a/drivers/media/video/v4l2-dev.c
> +++ b/drivers/media/video/v4l2-dev.c
> @@ -278,6 +278,9 @@ static int v4l2_mmap(struct file *filp, struct vm_area_struct *vm)
>  static int v4l2_open(struct inode *inode, struct file *filp)
>  {
>  	struct video_device *vdev;
> +#if defined(CONFIG_MEDIA_CONTROLLER)
> +	struct media_entity *entity = NULL;
> +#endif
>  	int ret = 0;
>  
>  	/* Check if the video device is available */
> @@ -291,6 +294,16 @@ static int v4l2_open(struct inode *inode, struct file *filp)
>  	/* and increase the device refcount */
>  	video_get(vdev);
>  	mutex_unlock(&videodev_lock);
> +#if defined(CONFIG_MEDIA_CONTROLLER)
> +	if (vdev->v4l2_dev && vdev->v4l2_dev->mdev) {
> +		entity = media_entity_get(&vdev->entity);
> +		if (!entity) {
> +			ret = -EBUSY;
> +			video_put(vdev);
> +			return ret;
> +		}
> +	}
> +#endif
>  	if (vdev->fops->open) {
>  		if (vdev->lock)
>  			mutex_lock(vdev->lock);
> @@ -303,8 +316,13 @@ static int v4l2_open(struct inode *inode, struct file *filp)
>  	}
>  
>  	/* decrease the refcount in case of an error */
> -	if (ret)
> +	if (ret) {
> +#if defined(CONFIG_MEDIA_CONTROLLER)
> +		if (vdev->v4l2_dev && vdev->v4l2_dev->mdev)
> +			media_entity_put(entity);
> +#endif
>  		video_put(vdev);
> +	}
>  	return ret;
>  }
>  
> @@ -321,7 +339,10 @@ static int v4l2_release(struct inode *inode, struct file *filp)
>  		if (vdev->lock)
>  			mutex_unlock(vdev->lock);
>  	}
> -
> +#if defined(CONFIG_MEDIA_CONTROLLER)
> +	if (vdev->v4l2_dev && vdev->v4l2_dev->mdev)
> +		media_entity_put(&vdev->entity);
> +#endif
>  	/* decrease the refcount unconditionally since the release()
>  	   return value is ignored. */
>  	video_put(vdev);
> @@ -558,12 +579,25 @@ int __video_register_device(struct video_device *vdev, int type, int nr,
>  	if (nr != -1 && nr != vdev->num && warn_if_nr_in_use)
>  		printk(KERN_WARNING "%s: requested %s%d, got %s\n", __func__,
>  			name_base, nr, video_device_node_name(vdev));
> -
> -	/* Part 5: Activate this minor. The char device can now be used. */
> +#if defined(CONFIG_MEDIA_CONTROLLER)
> +	/* Part 5: Register the entity. */
> +	if (vdev->v4l2_dev && vdev->v4l2_dev->mdev) {
> +		vdev->entity.type = MEDIA_ENTITY_TYPE_NODE_V4L;
> +		vdev->entity.name = vdev->name;
> +		vdev->entity.v4l.major = VIDEO_MAJOR;
> +		vdev->entity.v4l.minor = vdev->minor;
> +		ret = media_device_register_entity(vdev->v4l2_dev->mdev,
> +			&vdev->entity);
> +		if (ret < 0)
> +			printk(KERN_ERR "error\n"); /* TODO */

Was this forgotten, or will this be fixed in the next version? It looks
out-of-place...

> +	}
> +#endif

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
