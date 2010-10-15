Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438Ab0JOJEo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 05:04:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43789 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753035Ab0JOJEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 05:04:43 -0400
Date: Fri, 15 Oct 2010 02:05:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Valdis.Kletnieks@vt.edu, Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: mmotm 2010-10-13 - GSPCA SPCA561 webcam driver broken
Message-Id: <20101015020526.1819545f.akpm@linux-foundation.org>
In-Reply-To: <201010151045.45630.hverkuil@xs4all.nl>
References: <201010140044.o9E0iuR3029069@imap1.linux-foundation.org>
	<5158.1287086789@localhost>
	<201010151045.45630.hverkuil@xs4all.nl>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Oct 2010 10:45:45 +0200 Hans Verkuil <hverkuil@xs4all.nl> wrote:

> On Thursday, October 14, 2010 22:06:29 Valdis.Kletnieks@vt.edu wrote:
> > On Wed, 13 Oct 2010 17:13:25 PDT, akpm@linux-foundation.org said:
> > > The mm-of-the-moment snapshot 2010-10-13-17-13 has been uploaded to
> > > 
> > >    http://userweb.kernel.org/~akpm/mmotm/
> > 
> > This broke my webcam.  I bisected it down to this commit, and things
> > work again after reverting the 2 code lines of change.
> > 
> > commit 9e4d79a98ebd857ec729f5fa8f432f35def4d0da
> > Author: Hans Verkuil <hverkuil@xs4all.nl>
> > Date:   Sun Sep 26 08:16:56 2010 -0300
> > 
> >     V4L/DVB: v4l2-dev: after a disconnect any ioctl call will be blocked
> >     
> >     Until now all fops except release and (unlocked_)ioctl returned an error
> >     after the device node was unregistered. Extend this as well to the ioctl
> >     fops. There is nothing useful that an application can do here and it
> >     complicates the driver code unnecessarily.
> >     
> >     Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
> >     Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> > 
> > 
> > diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
> > index d4a3532..f069c61 100644
> > --- a/drivers/media/video/v4l2-dev.c
> > +++ b/drivers/media/video/v4l2-dev.c
> > @@ -221,8 +221,8 @@ static long v4l2_ioctl(struct file *filp, unsigned int cmd, 
> >         struct video_device *vdev = video_devdata(filp);
> >         int ret;
> >  
> > -       /* Allow ioctl to continue even if the device was unregistered.
> > -          Things like dequeueing buffers might still be useful. */
> > +       if (!vdev->fops->ioctl)
> > +               return -ENOTTY;
> >         if (vdev->fops->unlocked_ioctl) {
> >                 ret = vdev->fops->unlocked_ioctl(filp, cmd, arg);
> >         } else if (vdev->fops->ioctl) {
> > 
> > I suspect this doesn't do what's intended if a driver is using ->unlocked_ioctl
> > rather than ->ioctl, and it should be reverted - it only saves at most one
> > if statement.
> > 
> > 
> 
> I'm not sure what is going on here. It looks like this patch is mangled in your
> tree since the same patch in the v4l-dvb repository looks like this:
> 
> diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c                                                         
> index 32575a6..26d39c4 100644                                                                                                        
> --- a/drivers/media/video/v4l2-dev.c                                                                                                 
> +++ b/drivers/media/video/v4l2-dev.c                                                                                                 
> @@ -222,8 +222,8 @@ static int v4l2_ioctl(struct inode *inode, struct file *filp,                                                    
>                                                                                                                                      
>         if (!vdev->fops->ioctl)                                                                                                      
>                 return -ENOTTY;                                                                                                      
> -       /* Allow ioctl to continue even if the device was unregistered.                                                              
> -          Things like dequeueing buffers might still be useful. */
> +       if (!video_is_registered(vdev))
> +               return -ENODEV;
>         return vdev->fops->ioctl(filp, cmd, arg);
>  }
>  
> @@ -234,8 +234,8 @@ static long v4l2_unlocked_ioctl(struct file *filp,
>  
>         if (!vdev->fops->unlocked_ioctl)
>                 return -ENOTTY;
> -       /* Allow ioctl to continue even if the device was unregistered.
> -          Things like dequeueing buffers might still be useful. */
> +       if (!video_is_registered(vdev))
> +               return -ENODEV;
>         return vdev->fops->unlocked_ioctl(filp, cmd, arg);
>  }
> 
> In your diff there is a mismatch between ioctl and unlocked_ioctl which no doubt
> is causing all the problems for you.

The patch which Valdis quoted is what is in linux-next.  I'm not
at which stage the mangling happened?
