Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815Ab0KYOhk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 09:37:40 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:56130 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219Ab0KYOhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 09:37:39 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFC/PATCH v6 11/12] v4l: Make video_device inherit from media_entity
Date: Thu, 25 Nov 2010 15:37:51 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36-gentoo-r1; KDE/4.5.3; x86_64; ; )
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, sakari.ailus@maxwell.research.nokia.com,
        broonie@opensource.wolfsonmicro.com, lennart@poettering.net
References: <1290652099-15102-1-git-send-email-laurent.pinchart@ideasonboard.com> <1290652099-15102-12-git-send-email-laurent.pinchart@ideasonboard.com> <201011251238.15331.hverkuil@xs4all.nl>
In-Reply-To: <201011251238.15331.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201011251537.52329.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans,

Thanks for the review.

On Thursday 25 November 2010 12:38:15 Hans Verkuil wrote:
> On Thursday, November 25, 2010 03:28:18 Laurent Pinchart wrote:
> > V4L2 devices are media entities. As such they need to inherit from
> > (include) the media_entity structure.
> > 
> > When registering/unregistering the device, the media entity is
> > automatically registered/unregistered. The entity is acquired on device
> > open and released on device close.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
> > ---
> > 
> >  Documentation/video4linux/v4l2-framework.txt |   38
> >  +++++++++++++++++++-- drivers/media/video/v4l2-dev.c               |  
> >  47 +++++++++++++++++++++++--- include/media/v4l2-dev.h                 
> >     |    7 ++++
> >  3 files changed, 84 insertions(+), 8 deletions(-)
> 
> <snip>
> 
> > diff --git a/drivers/media/video/v4l2-dev.c
> > b/drivers/media/video/v4l2-dev.c index 035db52..511e1ee 100644
> > --- a/drivers/media/video/v4l2-dev.c
> > +++ b/drivers/media/video/v4l2-dev.c

[snip]

> > @@ -558,12 +579,25 @@ int __video_register_device(struct video_device
> > *vdev, int type, int nr,
> > 
> >  	if (nr != -1 && nr != vdev->num && warn_if_nr_in_use)
> >  	
> >  		printk(KERN_WARNING "%s: requested %s%d, got %s\n", __func__,
> >  		
> >  			name_base, nr, video_device_node_name(vdev));
> > 
> > -
> > -	/* Part 5: Activate this minor. The char device can now be used. */
> > +#if defined(CONFIG_MEDIA_CONTROLLER)
> > +	/* Part 5: Register the entity. */
> > +	if (vdev->v4l2_dev && vdev->v4l2_dev->mdev) {
> > +		vdev->entity.type = MEDIA_ENTITY_TYPE_NODE_V4L;
> > +		vdev->entity.name = vdev->name;
> > +		vdev->entity.v4l.major = VIDEO_MAJOR;
> > +		vdev->entity.v4l.minor = vdev->minor;
> > +		ret = media_device_register_entity(vdev->v4l2_dev->mdev,
> > +			&vdev->entity);
> > +		if (ret < 0)
> > +			printk(KERN_ERR "error\n"); /* TODO */
> 
> Was this forgotten, or will this be fixed in the next version? It looks
> out-of-place...

OOPS. I totally forgot about that one. I'll fix it for the next version.

-- 
Regards,

Laurent Pinchart
