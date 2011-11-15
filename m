Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626Ab1KOAsL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 19:48:11 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:38273 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943Ab1KOAsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 19:48:10 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Clemens Ladisch <clemens@ladisch.de>
Subject: Re: [PATCH] media: fix truncated entity specification
Date: Tue, 15 Nov 2011 01:47:41 +0100
User-Agent: KMail/1.13.7 (Linux/3.0.3-gentoo; KDE/4.7.3; x86_64; ; )
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
References: <4EB5ADA9.6010104@ladisch.de>
In-Reply-To: <4EB5ADA9.6010104@ladisch.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111150148.07957.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Clemens,

Thanks for the patch.

On Saturday 05 November 2011 22:42:01 Clemens Ladisch wrote:
> When enumerating an entity, assign the entire entity specification
> instead of only the first two words.  (This requires giving the
> specification union a name.)
> 
> So far, no driver actually uses more than two words, but this will
> be needed for ALSA entities.
> 
> Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
> ---
>  include/media/media-entity.h      |    2 +-
>  drivers/media/media-device.c      |    3 +--
>  drivers/media/video/v4l2-dev.c    |    4 ++--
>  drivers/media/video/v4l2-device.c |    4 ++--
>  4 files changed, 6 insertions(+), 7 deletions(-)

What about this (untested) simpler patch ?

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 16b70b4..34404f6 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -107,8 +107,7 @@ static long media_device_enum_entities(struct media_device 
 	u_ent.group_id = ent->group_id;
 	u_ent.pads = ent->num_pads;
 	u_ent.links = ent->num_links - ent->num_backlinks;
-	u_ent.v4l.major = ent->v4l.major;
-	u_ent.v4l.minor = ent->v4l.minor;
+	memcpy(&u_ent.raw, &ent->raw, sizeof(u_ent.raw));
 	if (copy_to_user(uent, &u_ent, sizeof(u_ent)))
 		return -EFAULT;
 	return 0;

> 
> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> index cd8bca6..d13de27 100644
> --- a/include/media/media-entity.h
> +++ b/include/media/media-entity.h
> @@ -98,7 +98,7 @@ struct media_entity {
> 
>  		/* Sub-device specifications */
>  		/* Nothing needed yet */
> -	};
> +	} specification;
>  };
> 
>  static inline u32 media_entity_type(struct media_entity *entity)
> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> index 16b70b4..bfb4e0b 100644
> --- a/drivers/media/media-device.c
> +++ b/drivers/media/media-device.c
> @@ -107,8 +107,7 @@ static long media_device_enum_entities(struct
> media_device *mdev, u_ent.group_id = ent->group_id;
>  	u_ent.pads = ent->num_pads;
>  	u_ent.links = ent->num_links - ent->num_backlinks;
> -	u_ent.v4l.major = ent->v4l.major;
> -	u_ent.v4l.minor = ent->v4l.minor;
> +	memcpy(&u_ent.v4l, &ent->specification, sizeof(ent->specification));
>  	if (copy_to_user(uent, &u_ent, sizeof(u_ent)))
>  		return -EFAULT;
>  	return 0;
> diff --git a/drivers/media/video/v4l2-dev.c
> b/drivers/media/video/v4l2-dev.c index a5c9ed1..1eb9ba1 100644
> --- a/drivers/media/video/v4l2-dev.c
> +++ b/drivers/media/video/v4l2-dev.c
> @@ -703,8 +703,8 @@ int __video_register_device(struct video_device *vdev,
> int type, int nr, vdev->vfl_type != VFL_TYPE_SUBDEV) {
>  		vdev->entity.type = MEDIA_ENT_T_DEVNODE_V4L;
>  		vdev->entity.name = vdev->name;
> -		vdev->entity.v4l.major = VIDEO_MAJOR;
> -		vdev->entity.v4l.minor = vdev->minor;
> +		vdev->entity.specification.v4l.major = VIDEO_MAJOR;
> +		vdev->entity.specification.v4l.minor = vdev->minor;
>  		ret = media_device_register_entity(vdev->v4l2_dev->mdev,
>  			&vdev->entity);
>  		if (ret < 0)
> diff --git a/drivers/media/video/v4l2-device.c
> b/drivers/media/video/v4l2-device.c index e6a2c3b..d8f58d8 100644
> --- a/drivers/media/video/v4l2-device.c
> +++ b/drivers/media/video/v4l2-device.c
> @@ -217,8 +217,8 @@ int v4l2_device_register_subdev_nodes(struct
> v4l2_device *v4l2_dev) if (err < 0)
>  			return err;
>  #if defined(CONFIG_MEDIA_CONTROLLER)
> -		sd->entity.v4l.major = VIDEO_MAJOR;
> -		sd->entity.v4l.minor = vdev->minor;
> +		sd->entity.specification.v4l.major = VIDEO_MAJOR;
> +		sd->entity.specification.v4l.minor = vdev->minor;
>  #endif
>  	}
>  	return 0;

-- 
Regards,

Laurent Pinchart
