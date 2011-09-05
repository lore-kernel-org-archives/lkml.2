Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049Ab1IENxp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 09:53:45 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:53390 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128Ab1IENxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 09:53:43 -0400
From: Yang Ruirui <hidave.darkstar@gmail.com>
Reply-To: Yang Ruirui <hidave.darkstar@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sitsofe Wheeler <sitsofe@yahoo.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: BUG: unable to handle kernel paging request at 6b6b6bcb
	(v4l2_device_disconnect+0x11/0x30)
X-Mailer: Modest 3.2
References: <20110829204846.GA14699@sucs.org>
	 <20110902072908.GA523@sucs.org>
	 <201109051159.08268.laurent.pinchart@ideasonboard.com>
	  <201109051213.26482.hverkuil@xs4all.nl>
In-Reply-To: <201109051213.26482.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-ID: <1315231824.1598.4.camel@Nokia-N900>
Date: Mon, 05 Sep 2011 22:10:24 +0800
Message-Id: <1315231824.1598.5.camel@Nokia-N900>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- Original message -----
> On Monday, September 05, 2011 11:59:03 Laurent Pinchart wrote:
> > Hi Hans,
> > 
> > On Friday 02 September 2011 09:29:08 Sitsofe Wheeler wrote:
> > > On Fri, Sep 02, 2011 at 01:35:49PM +0800, Dave Young wrote:
> > > > On Fri, Sep 2, 2011 at 12:59 PM, Dave Young wrote:
> > > > > On Fri, Sep 2, 2011 at 3:10 AM, Sitsofe Wheeler wrote:
> > > > > > On Thu, Sep 01, 2011 at 05:02:51PM +0800, Dave Young wrote:
> > > > > > > On Tue, Aug 30, 2011 at 4:48 AM, Sitsofe Wheeler wrote:
> > > > > > > > I managed to produce an oops in 3.1.0-rc3-00270-g7a54f5e by
> > > > > > > > unplugging a
> > > > > > > 
> > > > > > > > USB webcam. See below:
> > > > > > > Could you try the attached patch?
> > > > > > 
> > > > > > This patch fixed the oops but extending the sequence (enable
> > > > > > camera, start cheese, disable camera, watch cheese pause,
> > > > > > enable camera, quit cheese, start cheese) causes the following
> > > > > > "poison overwritten" warning
> > > > > 
> > > > > > to appear:
> > > > > It seems another bug, I can reproduce this as well.
> > > > > 
> > > > > uvc_device is freed in uvc_delete,
> > > > > 
> > > > > struct v4l2_device vdev is the member of struct uvc_device, so
> > > > > vdev is also freed. Later v4l2_device operations on vdev will
> > > > > overwrite the poison memory area.
> > > > 
> > > > Please try attached patch on top of previous one,   in this patch I
> > > > move v4l2_device_put after vdev->release in function
> > > > v4l2_device_release
> > > > 
> > > > Not sure if this is a right fix, comments?
> > 
> > (inlining the patch's contents)
> > 
> > > > diff --git a/drivers/media/video/v4l2-dev.c
> > > > b/drivers/media/video/v4l2- dev.c
> > > > index 98cee19..541dba3 100644
> > > > --- a/drivers/media/video/v4l2-dev.c
> > > > +++ b/drivers/media/video/v4l2-dev.c
> > > > @@ -172,13 +172,14 @@ static void v4l2_device_release(struct
> > > > device *cd)        media_device_unregister_entity(&vdev->entity);
> > > > #endif
> > > > 
> > > > +    /* Decrease v4l2_device refcount */
> > > > +    if (vdev->v4l2_dev)
> > > > +        v4l2_device_put(vdev->v4l2_dev);
> > > > +
> > > >     /* Release video_device and perform other
> > > >          cleanups as needed. */
> > > >     vdev->release(vdev);
> > > > 
> > > > -    /* Decrease v4l2_device refcount */
> > > > -    if (vdev->v4l2_dev)
> > > > -        v4l2_device_put(vdev->v4l2_dev);
> > > > }
> > > > 
> > > > static struct class video_class = {
> > 
> > v4l2_device_put() got introduced in commit 
> > bedf8bcf6b4f90a6e31add3721a2e71877289381 ("v4l2-device: add kref and a
> > release   function"). If I understand its purpose correctly, drivers
> > that use a   v4l2_device instance should use the v4l2_device release
> > callback to release   device structures instead of counting
> > video_device release callbacks manually.   In that case I think the
> > v4l2-dev.c code is correct, and all drivers that use   v4l2_device
> > should be fixed.
> > 
> > The above patch fixes the problem in a central location, but seems to
> > defeat   the original purpose of v4l2_device_get/put().
> > 
> > Hans, could you please comment on that ?
> 
> The original order is correct, but what I missed is that for drivers
> that release (free) everything in the videodev release callback the
> v4l2_device struct is also freed and v4l2_device_put will fail.
> 
> To fix this, add this code just before the vdev->release call:
> 
>     /* Do not call v4l2_device_put if there is no release callback set. */
>     if (v4l2_dev->release == NULL)
>         v4l2_dev = NULL;
> 
> If there is no release callback, then the refcounting is pointless
> anyway.
> 
> This should work.
> 

thanks, will test tommorrow
> Regards,
> 
>     Hans
> 
> > 
> > > > 
> > > > > > [   191.240695] uvcvideo: Found UVC 1.00 device CNF7129
> > > > > > (04f2:b071) [   191.277965] input: CNF7129 as
> > > > > > /devices/pci0000:00/0000:00:1d.7/usb1/1-8/1-8:1.0/input/input9
> > > > > > [ 220.287366]
> > > > > > =====================================================================
> > > > > > ======== [   220.287379] BUG kmalloc-512: Poison overwritten
> > > > > > [   220.287384]
> > > > > > ---------------------------------------------------------------------
> > > > > > -------- [   220.287387]
> > > > > > [   220.287394] INFO: 0xec90f150-0xec90f150. First byte 0x6a
> > > > > > instead of 0x6b [   220.287410] INFO: Allocated in
> > > > > > uvc_probe+0x54/0xd50 age=210617 cpu=0 pid=16 [   220.287421] 
> > > > > > T.974+0x29d/0x5e0 [   220.287427]   kmem_cache_alloc+0x167/0x180
> > > > > > [   220.287433]   uvc_probe+0x54/0xd50
> > > > > > [   220.287441]   usb_probe_interface+0xd5/0x1d0
> > > > > > [   220.287448]   driver_probe_device+0x80/0x1a0
> > > > > > [   220.287455]   __device_attach+0x41/0x50
> > > > > > [   220.287460]   bus_for_each_drv+0x53/0x80
> > > > > > [   220.287466]   device_attach+0x89/0xa0
> > > > > > [   220.287472]   bus_probe_device+0x25/0x40
> > > > > > [   220.287478]   device_add+0x5a9/0x660
> > > > > > [   220.287484]   usb_set_configuration+0x562/0x670
> > > > > > [   220.287491]   generic_probe+0x36/0x90
> > > > > > [   220.287497]   usb_probe_device+0x24/0x50
> > > > > > [   220.287503]   driver_probe_device+0x80/0x1a0
> > > > > > [   220.287509]   __device_attach+0x41/0x50
> > > > > > [   220.287515]   bus_for_each_drv+0x53/0x80
> > > > > > [   220.287522] INFO: Freed in uvc_delete+0xfe/0x110 age=22
> > > > > > cpu=0 pid=1645 [   220.287530]   __slab_free+0x1f8/0x300
> > > > > > [   220.287536]   kfree+0x100/0x140
> > > > > > [   220.287541]   uvc_delete+0xfe/0x110
> > > > > > [   220.287547]   uvc_release+0x25/0x30
> > > > > > [   220.287555]   v4l2_device_release+0x9d/0xc0
> > > > > > [   220.287560]   device_release+0x19/0x90
> > > > > > [   220.287567]   kobject_release+0x3c/0x90
> > > > > > [   220.287573]   kref_put+0x2c/0x60
> > > > > > [   220.287578]   kobject_put+0x1d/0x50
> > > > > > [   220.287587]   put_device+0xf/0x20
> > > > > > [   220.287593]   v4l2_release+0x56/0x60
> > > > > > [   220.287599]   fput+0xcc/0x220
> > > > > > [   220.287605]   filp_close+0x44/0x70
> > > > > > [   220.287613]   put_files_struct+0x158/0x180
> > > > > > [   220.287619]   exit_files+0x40/0x50
> > 
> > [snip]
> > 
> > 

