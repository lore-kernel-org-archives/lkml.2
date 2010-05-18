Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819Ab0ERGqL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 02:46:11 -0400
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:1197 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754579Ab0ERGqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 02:46:08 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 3/4] v4l: Pushdown bkl to drivers that implement their own ioctl
Date: Tue, 18 May 2010 08:47:33 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.33-tschai; KDE/4.3.5; x86_64; ; )
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
       Arnd Bergmann <arnd@arndb.de>, John Kacur <jkacur@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jan Blunck <jblunck@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <1274079052-23611-1-git-send-regression-fweisbec@gmail.com> <1274079052-23611-4-git-send-regression-fweisbec@gmail.com>
In-Reply-To: <1274079052-23611-4-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201005180847.33097.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 May 2010 08:50:51 Frederic Weisbecker wrote:
> These are the last remaining v4l drivers that implement the ioctl
> callback.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  drivers/media/radio/radio-mr800.c            |    5 +++-
>  drivers/media/video/bw-qcam.c                |   11 ++++++++-
>  drivers/media/video/c-qcam.c                 |   11 ++++++++-
>  drivers/media/video/cpia.c                   |   11 ++++++++-
>  drivers/media/video/cpia2/cpia2_v4l.c        |   11 ++++++++-
>  drivers/media/video/cx18/cx18-ioctl.c        |    4 +++
>  drivers/media/video/cx18/cx18-streams.c      |   12 +++++-----
>  drivers/media/video/et61x251/et61x251_core.c |   27 +++++++++++++++++++------
>  drivers/media/video/ov511.c                  |   15 ++++++++-----
>  drivers/media/video/pvrusb2/pvrusb2-v4l2.c   |   20 ++++++++++++------
>  drivers/media/video/pwc/pwc-if.c             |   19 ++++++++++-------
>  drivers/media/video/saa5246a.c               |   11 ++++++---
>  drivers/media/video/saa5249.c                |    6 ++++-
>  drivers/media/video/se401.c                  |   20 ++++++++++++------
>  drivers/media/video/sn9c102/sn9c102_core.c   |   27 +++++++++++++++++++------
>  drivers/media/video/stradis.c                |   26 ++++++++++++++++++------
>  drivers/media/video/stv680.c                 |   20 ++++++++++++------
>  drivers/media/video/usbvideo/usbvideo.c      |   21 +++++++++++++------
>  drivers/media/video/usbvideo/vicam.c         |   14 ++++++++++++-
>  drivers/media/video/uvc/uvc_v4l2.c           |   11 ++++++++-
>  drivers/media/video/vivi.c                   |    2 +-
>  drivers/media/video/w9968cf.c                |   25 ++++++++++++++++++-----
>  drivers/media/video/zc0301/zc0301_core.c     |   27 +++++++++++++++++++------
>  drivers/staging/cx25821/cx25821-audups11.c   |   18 ++++++++++------
>  drivers/staging/cx25821/cx25821-videoioctl.c |   27 +++++++++++++++++++------
>  drivers/staging/cx25821/cx25821-vidups10.c   |   19 +++++++++++------
>  drivers/staging/cx25821/cx25821-vidups9.c    |   18 ++++++++++------
>  drivers/staging/dream/camera/msm_v4l2.c      |   27 ++++++++++++++++++-------
>  28 files changed, 329 insertions(+), 136 deletions(-)
> 

<cut>

> diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
> index e17b6fe..b5e4855 100644
> --- a/drivers/media/video/vivi.c
> +++ b/drivers/media/video/vivi.c
> @@ -1086,7 +1086,7 @@ static const struct v4l2_file_operations vivi_fops = {
>  	.release        = vivi_close,
>  	.read           = vivi_read,
>  	.poll		= vivi_poll,
> -	.ioctl          = video_ioctl2, /* V4L2 ioctl handler */
> +	.unlocked_ioctl	= video_ioctl2, /* V4L2 ioctl handler */
>  	.mmap           = vivi_mmap,
>  };

Huh? Shouldn't this be in patch 2/4 replacing video_ioctl2 with video_ioctl2_bkl?

> diff --git a/drivers/staging/dream/camera/msm_v4l2.c b/drivers/staging/dream/camera/msm_v4l2.c

Interesting. A new v4l2 driver in staging. That one seems to have bypassed
the linux-media list completely as I can't remember seeing this driver there.

It would be nice if linux-media was CC-ed on drivers like this...

Regards,

	Hans

> index c276f2f..7744287 100644
> --- a/drivers/staging/dream/camera/msm_v4l2.c
> +++ b/drivers/staging/dream/camera/msm_v4l2.c
> @@ -12,6 +12,7 @@
>  #include <linux/spinlock.h>
>  #include <linux/videodev2.h>
>  #include <linux/proc_fs.h>
> +#include <linux/smp_lock.h>
>  #include <linux/slab.h>
>  #include <media/v4l2-dev.h>
>  #include <media/msm_camera.h>
> @@ -99,6 +100,7 @@ static unsigned int msm_v4l2_poll(struct file *f, struct poll_table_struct *w)
>  static long msm_v4l2_ioctl(struct file *filep,
>  			   unsigned int cmd, unsigned long arg)
>  {
> +	long ret;
>  	struct msm_ctrl_cmd *ctrlcmd;
>  
>  	D("msm_v4l2_ioctl, cmd = %d, %d\n", cmd, __LINE__);
> @@ -119,18 +121,27 @@ static long msm_v4l2_ioctl(struct file *filep,
>  		D("msm_v4l2_ioctl,  MSM_V4L2_START_SNAPSHOT v4l2 ioctl %d\n",
>  		cmd);
>  		ctrlcmd->type = MSM_V4L2_SNAPSHOT;
> -		return g_pmsm_v4l2_dev->drv->ctrl(g_pmsm_v4l2_dev->drv->sync,
> +		lock_kernel();
> +		ret = g_pmsm_v4l2_dev->drv->ctrl(g_pmsm_v4l2_dev->drv->sync,
>  							ctrlcmd);
> +		unlock_kernel();
> +		return ret;
>  
>  	case MSM_V4L2_GET_PICTURE:
>  		D("msm_v4l2_ioctl,  MSM_V4L2_GET_PICTURE v4l2 ioctl %d\n", cmd);
>  		ctrlcmd = (struct msm_ctrl_cmd *)arg;
> -		return g_pmsm_v4l2_dev->drv->get_pict(
> +		lock_kernel();
> +		ret = g_pmsm_v4l2_dev->drv->get_pict(
>  				g_pmsm_v4l2_dev->drv->sync, ctrlcmd);
> +		unlock_kernel();
> +		return ret;
>  
>  	default:
>  		D("msm_v4l2_ioctl, standard v4l2 ioctl %d\n", cmd);
> -		return video_ioctl2(filep, cmd, arg);
> +		lock_kernel();
> +		ret = video_ioctl2(filep, cmd, arg);
> +		unlock_kernel();
> +		return ret;
>  	}
>  }
>  
> @@ -640,11 +651,11 @@ int msm_v4l2_read_proc(char *pbuf, char **start, off_t offset,
>  #endif
>  
>  static const struct v4l2_file_operations msm_v4l2_fops = {
> -	.owner = THIS_MODULE,
> -	.open = msm_v4l2_open,
> -	.poll = msm_v4l2_poll,
> -	.release = msm_v4l2_release,
> -	.ioctl = msm_v4l2_ioctl,
> +	.owner		= THIS_MODULE,
> +	.open		= msm_v4l2_open,
> +	.poll		= msm_v4l2_poll,
> +	.release	= msm_v4l2_release,
> +	.unlocked_ioctl = msm_v4l2_ioctl,
>  };
>  
>  static void msm_v4l2_dev_init(struct msm_v4l2_device *pmsm_v4l2_dev)
> 
