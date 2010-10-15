Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603Ab0JOKDd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 06:03:33 -0400
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:3981 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203Ab0JOKDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 06:03:32 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: mmotm 2010-10-13 - GSPCA SPCA561 webcam driver broken
Date: Fri, 15 Oct 2010 12:02:31 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-tschai; KDE/4.4.5; x86_64; ; )
Cc: Valdis.Kletnieks@vt.edu, Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
References: <201010140044.o9E0iuR3029069@imap1.linux-foundation.org> <201010151045.45630.hverkuil@xs4all.nl> <20101015020526.1819545f.akpm@linux-foundation.org>
In-Reply-To: <20101015020526.1819545f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010151202.31629.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, October 15, 2010 11:05:26 Andrew Morton wrote:
> On Fri, 15 Oct 2010 10:45:45 +0200 Hans Verkuil <hverkuil@xs4all.nl> wrote:
> 
> > On Thursday, October 14, 2010 22:06:29 Valdis.Kletnieks@vt.edu wrote:
> > > On Wed, 13 Oct 2010 17:13:25 PDT, akpm@linux-foundation.org said:
> > > > The mm-of-the-moment snapshot 2010-10-13-17-13 has been uploaded to
> > > > 
> > > >    http://userweb.kernel.org/~akpm/mmotm/
> > > 
> > > This broke my webcam.  I bisected it down to this commit, and things
> > > work again after reverting the 2 code lines of change.
> > > 
> > > commit 9e4d79a98ebd857ec729f5fa8f432f35def4d0da
> > > Author: Hans Verkuil <hverkuil@xs4all.nl>
> > > Date:   Sun Sep 26 08:16:56 2010 -0300
> > > 
> > >     V4L/DVB: v4l2-dev: after a disconnect any ioctl call will be blocked
> > >     
> > >     Until now all fops except release and (unlocked_)ioctl returned an error
> > >     after the device node was unregistered. Extend this as well to the ioctl
> > >     fops. There is nothing useful that an application can do here and it
> > >     complicates the driver code unnecessarily.
> > >     
> > >     Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
> > >     Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> > > 
> > > 
> > > diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
> > > index d4a3532..f069c61 100644
> > > --- a/drivers/media/video/v4l2-dev.c
> > > +++ b/drivers/media/video/v4l2-dev.c
> > > @@ -221,8 +221,8 @@ static long v4l2_ioctl(struct file *filp, unsigned int cmd, 
> > >         struct video_device *vdev = video_devdata(filp);
> > >         int ret;
> > >  
> > > -       /* Allow ioctl to continue even if the device was unregistered.
> > > -          Things like dequeueing buffers might still be useful. */
> > > +       if (!vdev->fops->ioctl)
> > > +               return -ENOTTY;
> > >         if (vdev->fops->unlocked_ioctl) {
> > >                 ret = vdev->fops->unlocked_ioctl(filp, cmd, arg);
> > >         } else if (vdev->fops->ioctl) {
> > > 
> > > I suspect this doesn't do what's intended if a driver is using ->unlocked_ioctl
> > > rather than ->ioctl, and it should be reverted - it only saves at most one
> > > if statement.
> > > 
> > > 
> > 
> > I'm not sure what is going on here. It looks like this patch is mangled in your
> > tree since the same patch in the v4l-dvb repository looks like this:
> > 
> > diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c                                                         
> > index 32575a6..26d39c4 100644                                                                                                        
> > --- a/drivers/media/video/v4l2-dev.c                                                                                                 
> > +++ b/drivers/media/video/v4l2-dev.c                                                                                                 
> > @@ -222,8 +222,8 @@ static int v4l2_ioctl(struct inode *inode, struct file *filp,                                                    
> >                                                                                                                                      
> >         if (!vdev->fops->ioctl)                                                                                                      
> >                 return -ENOTTY;                                                                                                      
> > -       /* Allow ioctl to continue even if the device was unregistered.                                                              
> > -          Things like dequeueing buffers might still be useful. */
> > +       if (!video_is_registered(vdev))
> > +               return -ENODEV;
> >         return vdev->fops->ioctl(filp, cmd, arg);
> >  }
> >  
> > @@ -234,8 +234,8 @@ static long v4l2_unlocked_ioctl(struct file *filp,
> >  
> >         if (!vdev->fops->unlocked_ioctl)
> >                 return -ENOTTY;
> > -       /* Allow ioctl to continue even if the device was unregistered.
> > -          Things like dequeueing buffers might still be useful. */
> > +       if (!video_is_registered(vdev))
> > +               return -ENODEV;
> >         return vdev->fops->unlocked_ioctl(filp, cmd, arg);
> >  }
> > 
> > In your diff there is a mismatch between ioctl and unlocked_ioctl which no doubt
> > is causing all the problems for you.
> 
> The patch which Valdis quoted is what is in linux-next.  I'm not
> at which stage the mangling happened?
> 

OK, I see what happened. My original patch:

http://git.linuxtv.org/media_tree.git?a=commitdiff;h=30de1fa062e42a74c54e94c8977d7dcef9a5049f;hp=f39385558f50f0b5b2bc9b47c187b81a8188fb10

clashed with Arnd Bergmann's patch:

http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=commit;h=86a5ef7d777cdd61dfe82379d559dbea069aea3d

Someone tried to resolve the conflict but made a mistake.

The result is this:

static long v4l2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
{
	struct video_device *vdev = video_devdata(filp);
	int ret;

	if (!vdev->fops->ioctl)
		return -ENOTTY;
	if (vdev->fops->unlocked_ioctl) {
		if (vdev->lock)
			mutex_lock(vdev->lock);
		ret = vdev->fops->unlocked_ioctl(filp, cmd, arg);
		if (vdev->lock)
			mutex_unlock(vdev->lock);
	} else if (vdev->fops->ioctl) {
		/* TODO: convert all drivers to unlocked_ioctl */
		lock_kernel();
		ret = vdev->fops->ioctl(filp, cmd, arg);
		unlock_kernel();
	} else
		ret = -ENOTTY;

	return ret;
}

But this is wrong.

What it should be is this:

static long v4l2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
{
	struct video_device *vdev = video_devdata(filp);
	int ret = -ENODEV;

	if (vdev->fops->unlocked_ioctl) {
		if (vdev->lock)
			mutex_lock(vdev->lock);
		if (video_is_registered(vdev))
			ret = vdev->fops->unlocked_ioctl(filp, cmd, arg);
		if (vdev->lock)
			mutex_unlock(vdev->lock);
	} else if (vdev->fops->ioctl) {
		/* TODO: convert all drivers to unlocked_ioctl */
		lock_kernel();
		if (video_is_registered(vdev))
			ret = vdev->fops->ioctl(filp, cmd, arg);
		unlock_kernel();
	} else
		ret = -ENOTTY;

	return ret;
}

Mauro, is this something for you to fix?

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
