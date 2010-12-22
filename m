Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562Ab0LVL4o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 06:56:44 -0500
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:2380 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114Ab0LVL4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 06:56:42 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: halli manjunatha <manjunatha_halli@ti.com>
Subject: Re: [PATCH v7 2/7] drivers:media:radio: wl128x: fmdrv_v4l2 sources
Date: Wed, 22 Dec 2010 12:56:34 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc7-durdane; KDE/4.4.5; x86_64; ; )
Cc: mchehab@infradead.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
References: <1292583996-4440-1-git-send-email-manjunatha_halli@ti.com> <201012181238.56021.hverkuil@xs4all.nl> <AANLkTinLy_NBFDLyR9yKP72GFR0M2sCV42FnQemJ2D84@mail.gmail.com>
In-Reply-To: <AANLkTinLy_NBFDLyR9yKP72GFR0M2sCV42FnQemJ2D84@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012221256.34611.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, December 22, 2010 07:19:54 halli manjunatha wrote:
> 10 at 5:08 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > On Friday, December 17, 2010 12:06:31 manjunatha_halli@ti.com wrote:
> >> From: Manjunatha Halli <manjunatha_halli@ti.com>
> >>
> >> This module interfaces V4L2 subsystem and FM common module.
> >> It registers itself with V4L2 as Radio module.
> >>
> >> Signed-off-by: Manjunatha Halli <manjunatha_halli@ti.com>
> >> ---
> >>  drivers/media/radio/wl128x/fmdrv_v4l2.c |  588 +++++++++++++++++++++++++++++++
> >>  drivers/media/radio/wl128x/fmdrv_v4l2.h |   33 ++
> >>  2 files changed, 621 insertions(+), 0 deletions(-)
> >>  create mode 100644 drivers/media/radio/wl128x/fmdrv_v4l2.c
> >>  create mode 100644 drivers/media/radio/wl128x/fmdrv_v4l2.h
> >>
> >> diff --git a/drivers/media/radio/wl128x/fmdrv_v4l2.c b/drivers/media/radio/wl128x/fmdrv_v4l2.c
> >> new file mode 100644
> >> index 0000000..623102f
> >> --- /dev/null
> >> +++ b/drivers/media/radio/wl128x/fmdrv_v4l2.c
> >
> > <snip>
> >
> >> +static const struct v4l2_file_operations fm_drv_fops = {
> >> +     .owner = THIS_MODULE,
> >> +     .read = fm_v4l2_fops_read,
> >> +     .write = fm_v4l2_fops_write,
> >> +     .poll = fm_v4l2_fops_poll,
> >> +     .ioctl = video_ioctl2,
> >
> > Please use unlocked_ioctl. The .ioctl call is deprecated since it relied on the
> > Big Kernel Lock which is in the process of being removed from the kernel. The
> > BKL serialized all ioctl calls, unlocked_ioctl relies on the driver to serialize
> > where necessary.
> >
> > There are two ways of doing the conversion: one is to do all the locking within
> > the driver, the other is to use core-assisted locking. How to do the core-assisted
> > locking is described in Documentation/video4linux/v4l2-framework.txt, but I'll
> > repeat the relevant part here:
> >
> > v4l2_file_operations and locking
> > --------------------------------
> >
> > You can set a pointer to a mutex_lock in struct video_device. Usually this
> > will be either a top-level mutex or a mutex per device node. If you want
> > finer-grained locking then you have to set it to NULL and do you own locking.
> >
> > If a lock is specified then all file operations will be serialized on that
> > lock. If you use videobuf then you must pass the same lock to the videobuf
> > queue initialize function: if videobuf has to wait for a frame to arrive, then
> > it will temporarily unlock the lock and relock it afterwards. If your driver
> > also waits in the code, then you should do the same to allow other processes
> > to access the device node while the first process is waiting for something.
> >
> > The implementation of a hotplug disconnect should also take the lock before
> > calling v4l2_device_disconnect.
> >
> >> +     .open = fm_v4l2_fops_open,
> >> +     .release = fm_v4l2_fops_release,
> >> +};
> 
> Hans,
> 
> I did this in my driver,
> --- a/drivers/media/radio/wl128x/fmdrv_v4l2.c
> +++ b/drivers/media/radio/wl128x/fmdrv_v4l2.c
> @@ -477,7 +477,7 @@ static const struct v4l2_file_operations fm_drv_fops = {
>         .read = fm_v4l2_fops_read,
>         .write = fm_v4l2_fops_write,
>         .poll = fm_v4l2_fops_poll,
> -       .ioctl = video_ioctl2,
> +       .unlocked_ioctl = video_ioctl2,
>         .open = fm_v4l2_fops_open,
>         .release = fm_v4l2_fops_release,
> 
> and apparently didn't face any issues during regression.. (related to
> concurrency...)
> and more-over all of my ioctls from the application being called in
> process context are all synchronous, i.e
> application calls and waits for it to finish before calling another ioctl.
> 
> So is this approach alright?
> Is there a reason to opt for the .ioctl ? The locked approach?
> Or have mutex locks inside the unlocked handlers?
> 
> If not I will go ahead and submit v8 using the unlocked_ioctl....

The old use of .ioctl would serialize all ioctl calls. So if multiple processes
opened the video device node and made ioctl calls, then the Big Kernel Lock would
serialize those ioctls. Switching to .unlocked_ioctl will no longer serialize
those calls and so you will have to do something to prevent race conditions.

Either identify the critical sections and lock them manually, or use the core
assisted locking scheme that V4L2 provides to serialize all file operations.

I recommend the latter since it is very simple to implement and it does the
job. Since there is no locking whatsoever in the driver I think that manually
adding locking is too much work (and too hard to verify correctness).

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
