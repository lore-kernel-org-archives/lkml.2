Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752417Ab1IEKRX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 06:17:23 -0400
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:3934 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871Ab1IEKRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 06:17:19 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: BUG: unable to handle kernel paging request at 6b6b6bcb (v4l2_device_disconnect+0x11/0x30)
Date: Mon, 5 Sep 2011 12:16:42 +0200
User-Agent: KMail/1.13.7 (Linux/3.0-3.slh.1-aptosid-amd64; KDE/4.6.5; x86_64; ; )
Cc: Sitsofe Wheeler <sitsofe@yahoo.com>,
        Dave Young <hidave.darkstar@gmail.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
References: <20110829204846.GA14699@sucs.org> <201109051159.08268.laurent.pinchart@ideasonboard.com> <201109051213.26482.hverkuil@xs4all.nl>
In-Reply-To: <201109051213.26482.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109051216.42579.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, September 05, 2011 12:13:26 Hans Verkuil wrote:
> On Monday, September 05, 2011 11:59:03 Laurent Pinchart wrote:
> > Hi Hans,
> > 
> > On Friday 02 September 2011 09:29:08 Sitsofe Wheeler wrote:
> > > On Fri, Sep 02, 2011 at 01:35:49PM +0800, Dave Young wrote:
> > > > On Fri, Sep 2, 2011 at 12:59 PM, Dave Young wrote:
> > > > > On Fri, Sep 2, 2011 at 3:10 AM, Sitsofe Wheeler wrote:
> > > > >> On Thu, Sep 01, 2011 at 05:02:51PM +0800, Dave Young wrote:
> > > > >>> On Tue, Aug 30, 2011 at 4:48 AM, Sitsofe Wheeler wrote:
> > > > >>> > I managed to produce an oops in 3.1.0-rc3-00270-g7a54f5e by
> > > > >>> > unplugging a
> > > > >>> 
> > > > >>> > USB webcam. See below:
> > > > >>> Could you try the attached patch?
> > > > >> 
> > > > >> This patch fixed the oops but extending the sequence (enable camera,
> > > > >> start cheese, disable camera, watch cheese pause, enable camera, quit
> > > > >> cheese, start cheese) causes the following "poison overwritten"
> > > > >> warning
> > > > > 
> > > > >> to appear:
> > > > > It seems another bug, I can reproduce this as well.
> > > > > 
> > > > > uvc_device is freed in uvc_delete,
> > > > > 
> > > > > struct v4l2_device vdev is the member of struct uvc_device, so vdev is
> > > > > also freed. Later v4l2_device operations on vdev will overwrite the
> > > > > poison memory area.
> > > > 
> > > > Please try attached patch on top of previous one,  in this patch I
> > > > move v4l2_device_put after vdev->release in function
> > > > v4l2_device_release
> > > > 
> > > > Not sure if this is a right fix, comments?
> > 
> > (inlining the patch's contents)
> > 
> > > > diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-
> > > > dev.c
> > > > index 98cee19..541dba3 100644
> > > > --- a/drivers/media/video/v4l2-dev.c
> > > > +++ b/drivers/media/video/v4l2-dev.c
> > > > @@ -172,13 +172,14 @@ static void v4l2_device_release(struct device *cd)
> > > >  		media_device_unregister_entity(&vdev->entity);
> > > >  #endif
> > > >  
> > > > +	/* Decrease v4l2_device refcount */
> > > > +	if (vdev->v4l2_dev)
> > > > +		v4l2_device_put(vdev->v4l2_dev);
> > > > +
> > > >  	/* Release video_device and perform other
> > > >  	   cleanups as needed. */
> > > >  	vdev->release(vdev);
> > > >  
> > > > -	/* Decrease v4l2_device refcount */
> > > > -	if (vdev->v4l2_dev)
> > > > -		v4l2_device_put(vdev->v4l2_dev);
> > > >  }
> > > >  
> > > >  static struct class video_class = {
> > 
> > v4l2_device_put() got introduced in commit 
> > bedf8bcf6b4f90a6e31add3721a2e71877289381 ("v4l2-device: add kref and a release 
> > function"). If I understand its purpose correctly, drivers that use a 
> > v4l2_device instance should use the v4l2_device release callback to release 
> > device structures instead of counting video_device release callbacks manually. 
> > In that case I think the v4l2-dev.c code is correct, and all drivers that use 
> > v4l2_device should be fixed.
> > 
> > The above patch fixes the problem in a central location, but seems to defeat 
> > the original purpose of v4l2_device_get/put().
> > 
> > Hans, could you please comment on that ?
> 
> The original order is correct, but what I missed is that for drivers that release
> (free) everything in the videodev release callback the v4l2_device struct is
> also freed and v4l2_device_put will fail.
> 
> To fix this, add this code just before the vdev->release call:
> 
> 	/* Do not call v4l2_device_put if there is no release callback set. */
> 	if (v4l2_dev->release == NULL)
> 		v4l2_dev = NULL;
> 
> If there is no release callback, then the refcounting is pointless anyway.
> 
> This should work.

Note that in the long run using the v4l2_device release callback instead of the
videodev release is better. But it's a lot of work to convert everything so that's
long term. I'm quite surprised BTW that this bug wasn't found much earlier.

Regards,

	Hans
