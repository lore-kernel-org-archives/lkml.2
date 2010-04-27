Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311Ab0D0Lyp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 07:54:45 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:13885 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab0D0Lym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 07:54:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=gw8oGo9dOzDcZuvPYIUuDzRkc9swYfDcMml2sNHORpnx95j3udA5ze+xtnhGB8RRGB
         NvyUXQ/zcDJzz3bMvS3XgwjEGchGCsspbERhJBfM/nj0rGH2H66tQr3CmUx7JHeBn+zm
         8mqmqFLnvrBYfH+iefa1t8/BKaGAxQ01rmzHU=
Date: Tue, 27 Apr 2010 13:54:36 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost
To: Arnd Bergmann <arnd@arndb.de>
cc: John Kacur <jkacur@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jan Blunck <jblunck@gmail.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 10/10] bkl: Fix-up compile problems as a result of the
 bkl-pushdown.
In-Reply-To: <201004271317.45503.arnd@arndb.de>
Message-ID: <alpine.LFD.2.00.1004271352510.3318@localhost>
References: <1272359898-32020-1-git-send-email-jkacur@redhat.com> <1272359898-32020-11-git-send-email-jkacur@redhat.com> <201004271317.45503.arnd@arndb.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-2061841137-1272369279=:3318"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-2061841137-1272369279=:3318
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT



On Tue, 27 Apr 2010, Arnd Bergmann wrote:

> On Tuesday 27 April 2010, John Kacur wrote:
> > Fix-up compile problems as a result of the bkl-pushdown.
> > In particular,  the v4l2_ioctl should call an unlocked_ioctl
> > 
> > Signed-off-by: John Kacur <jkacur@redhat.com>
> > ---
> >  drivers/media/video/v4l2-dev.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
> > index 3606694..8fbfa61 100644
> > --- a/drivers/media/video/v4l2-dev.c
> > +++ b/drivers/media/video/v4l2-dev.c
> > @@ -222,12 +222,12 @@ static long v4l2_ioctl(struct file *filp,
> >         struct video_device *vdev = video_devdata(filp);
> >         int ret;
> >  
> > -       if (!vdev->fops->ioctl)
> > +       if (!vdev->fops->unlocked_ioctl)
> >                 return -ENOTTY;
> >         /* Allow ioctl to continue even if the device was unregistered.
> >            Things like dequeueing buffers might still be useful. */
> >         lock_kernel();
> > -       ret = vdev->fops->ioctl(filp->f_path.dentry->d_inode, filp, cmd, arg);
> > +       ret = vdev->fops->unlocked_ioctl(filp, cmd, arg);
> >         unlock_kernel();
> >  
> >         return ret;
> 
> No, this is what I thought as well, at first, but the version I posted is
> actually correct.
> 
> vdev->fops is not struct file_operations but struct v4l2_file_operations,
> and the v4l2_ioctl function is used only when fops->ioctl is set, see
> __video_register_device.
> 
> The v4l2 ioctl stuff probably can use a lot of cleanup itself, but so
> far I think we're not making it worse with my patch.
> 

Hi Arnd

Well it is certainly possible that my fixup is not correct too - your 
patch cannot be correct, because it doesn't compile! Here is what I get 
when I apply your patch to a recent linus/master

make O=/bld/arnd/ drivers/media/video/v4l2-dev.o
-----CUT A BUNCH OF STUFF OUT ---
  CC      drivers/media/video/v4l2-dev.o
/home/jkacur/jk-2.6/drivers/media/video/v4l2-dev.c: In function 
¡v4l2_ioctl¢:
/home/jkacur/jk-2.6/drivers/media/video/v4l2-dev.c:230: warning: passing 
argument 1 of ¡vdev->fops->ioctl¢ from incompatible pointer type
/home/jkacur/jk-2.6/drivers/media/video/v4l2-dev.c:230: note: expected 
¡struct file *¢ but argument is of type ¡struct inode *¢
/home/jkacur/jk-2.6/drivers/media/video/v4l2-dev.c:230: warning: passing 
argument 2 of ¡vdev->fops->ioctl¢ makes integer from pointer without a 
cast
/home/jkacur/jk-2.6/drivers/media/video/v4l2-dev.c:230: note: expected 
¡unsigned int¢ but argument is of type ¡struct file *¢
/home/jkacur/jk-2.6/drivers/media/video/v4l2-dev.c:230: error: too many 
arguments to function ¡vdev->fops->ioctl¢
make[2]: *** [drivers/media/video/v4l2-dev.o] Error 1
make[1]: *** [drivers/media/video/v4l2-dev.o] Error 2
make: *** [sub-make] Error 2


Thanks
--8323328-2061841137-1272369279=:3318--
