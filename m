Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757712Ab0JRTkt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 15:40:49 -0400
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4242 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755416Ab0JRTks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 15:40:48 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: mmotm 2010-10-13 - GSPCA SPCA561 webcam driver broken
Date: Mon, 18 Oct 2010 21:39:54 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-tschai; KDE/4.4.5; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
References: <201010140044.o9E0iuR3029069@imap1.linux-foundation.org> <201010151423.52318.hverkuil@xs4all.nl> <4CBC9969.30005@redhat.com>
In-Reply-To: <4CBC9969.30005@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010182139.54502.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, October 18, 2010 21:00:57 Mauro Carvalho Chehab wrote:
> Em 15-10-2010 09:23, Hans Verkuil escreveu:
> > On Friday, October 15, 2010 14:05:39 Mauro Carvalho Chehab wrote:
> >> Em 15-10-2010 07:02, Hans Verkuil escreveu:
> >>> On Friday, October 15, 2010 11:05:26 Andrew Morton wrote:
> >>>> On Fri, 15 Oct 2010 10:45:45 +0200 Hans Verkuil <hverkuil@xs4all.nl> wrote:
> >>>>
> >>>>> On Thursday, October 14, 2010 22:06:29 Valdis.Kletnieks@vt.edu wrote:
> >>>>>> On Wed, 13 Oct 2010 17:13:25 PDT, akpm@linux-foundation.org said:
> >>>>>>> The mm-of-the-moment snapshot 2010-10-13-17-13 has been uploaded to
> >>>
> >>> Mauro, is this something for you to fix?
> >>
> >> I have a patch fixing this conflict already:
> >>
> >> http://git.linuxtv.org/mchehab/sbtvd.git?a=commit;h=88164fbe701a0a16e9044b74443dddb6188b54cc
> >>
> >> The patch is currently on a separate tree, that I'm using to test some experimental
> >> drivers for Brazilian Digital TV system (SBTVD). I'm planning to merge this patch, among
> >> with other patches I received for .37 during this weekend.
> > 
> > No, this patch isn't sufficient. It backs out the wrong code but doesn't put
> > in the 'video_is_registered()' if statements that were in my original patch.
> > 
> > Those are really needed.
> 
> Ok, I've re-done the conflict fix patch:
> 
> http://git.kernel.org/?p=linux/kernel/git/mchehab/linux-next.git;a=commitdiff;h=f9fccbad2a67668240edeaa6ada5aea2281d10b3

I hate to say this, but it is still not right. This is the correct code:

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

As you can see, the video_is_registered is called with the lock held.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
