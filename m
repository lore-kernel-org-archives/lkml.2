Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939Ab0D0LSd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 07:18:33 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:59901 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754821Ab0D0LSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 07:18:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: John Kacur <jkacur@redhat.com>
Subject: Re: [PATCH 10/10] bkl: Fix-up compile problems as a result of the bkl-pushdown.
Date: Tue, 27 Apr 2010 13:17:45 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: lkml <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jan Blunck <jblunck@gmail.com>, Thomas Gleixner <tglx@linutronix.de>
References: <1272359898-32020-1-git-send-email-jkacur@redhat.com> <1272359898-32020-11-git-send-email-jkacur@redhat.com>
In-Reply-To: <1272359898-32020-11-git-send-email-jkacur@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201004271317.45503.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+QPkr9bD2S9iIrfAguP8ZgFJmJfA0d2rJsvOx
 iukUJmMcOLz8NGaDiuIjcBtbPctmOh5EetWrLIeefYuaK7Qtib
 7lvce6dCHznPzt8THUK4g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 April 2010, John Kacur wrote:
> Fix-up compile problems as a result of the bkl-pushdown.
> In particular,  the v4l2_ioctl should call an unlocked_ioctl
> 
> Signed-off-by: John Kacur <jkacur@redhat.com>
> ---
>  drivers/media/video/v4l2-dev.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
> index 3606694..8fbfa61 100644
> --- a/drivers/media/video/v4l2-dev.c
> +++ b/drivers/media/video/v4l2-dev.c
> @@ -222,12 +222,12 @@ static long v4l2_ioctl(struct file *filp,
>         struct video_device *vdev = video_devdata(filp);
>         int ret;
>  
> -       if (!vdev->fops->ioctl)
> +       if (!vdev->fops->unlocked_ioctl)
>                 return -ENOTTY;
>         /* Allow ioctl to continue even if the device was unregistered.
>            Things like dequeueing buffers might still be useful. */
>         lock_kernel();
> -       ret = vdev->fops->ioctl(filp->f_path.dentry->d_inode, filp, cmd, arg);
> +       ret = vdev->fops->unlocked_ioctl(filp, cmd, arg);
>         unlock_kernel();
>  
>         return ret;

No, this is what I thought as well, at first, but the version I posted is
actually correct.

vdev->fops is not struct file_operations but struct v4l2_file_operations,
and the v4l2_ioctl function is used only when fops->ioctl is set, see
__video_register_device.

The v4l2 ioctl stuff probably can use a lot of cleanup itself, but so
far I think we're not making it worse with my patch.

	Arnd
