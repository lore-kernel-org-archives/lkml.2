Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518Ab1FZR57 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 13:57:59 -0400
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:3940 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462Ab1FZRzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 13:55:40 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 00/14] Remove linux/version.h from most drivers/media
Date: Sun, 26 Jun 2011 19:55:24 +0200
User-Agent: KMail/1.13.5 (Linux/3.0.0-rc1-tschai; KDE/4.6.2; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Laurent Pincart <laurent.pinchart@ideasonboard.com>,
        Mike Isely <isely@isely.net>
References: <20110626130620.4b5ed679@pedra>
In-Reply-To: <20110626130620.4b5ed679@pedra>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106261955.25003.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, June 26, 2011 18:06:20 Mauro Carvalho Chehab wrote:
> At the V4L2 API, one of the fields of VIDIOC_QUERYCAP requires the usage
> of KERNEL_VERSION macro, in order to provide the driver version. However,
> this is not handled consistently across subsystems. There are very few
> drivers that take it seriously.
> 
> So, instead of the current way, let's replace it by a subsystem version.
> Removing the driver-specific version reported via V4L2 API is a good
> thing, due to several reasons:
> 	1) every time include/linux/version.h changes, all media drivers
> 	   need to be recompiled;
> 	2) eventually, this macro will be changed at Kernel 3.x;
> 	3) developers are lazy on updating it at a per-driver basis; 
> 	   The information  there is not consistent;
> 	4) a check for the V4L2 API, incremented as new changes are added
> 	   means that the changes will happen on a consistent way, being 
> 	   incremented when new features are added at the Kernel;
> 	5) From time to time, people do the wrong thing, including version.h
> 	   where it is not needed, and spending Kernel Janitor's time to 
> 	   cleanup the mess.
> 
> There's one additional reason for the change: before this patch series,
> a call to an unsupported ioctl would be returning -EINVAL. So, userspace
> applications can't detect if the error were due to invalid parameters,
> or to unsupported ioctl. This series changes the behavior to return
> -ENOIOCTLCMD for non-supported ioctl's.
> 
> So, after this patch series, if VIDIOC_QUERYCAP returns version 3.x.y,
> userspace applications can rely on -ENOIOCTLCMD in order to detect that
> an ioctl is not supported by a given driver.
> 
> After this patch series, the only places at drivers/media that will keep 
> linux/version.h are:
> 	drivers/media/video/et61x251/et61x251_core.c
> 	drivers/media/video/pvrusb2/pvrusb2-v4l2.c
> 	drivers/media/video/sn9c102/sn9c102_core.c
> 	drivers/media/video/uvc/uvc_driver.c
> 	drivers/media/video/uvc/uvc_v4l2.c
> And, of course: drivers/media/video/v4l2-ioctl.c
> 
> The rationale is that et61x251, pvrusb2, sn9c102 and uvc uses the
> legacy way of handling ioctl's. Two of those drivers are obsoleted by
> gspca. The other two drivers (pvrusb2 and uvc) needs porting.

Except for the ENOIOCTLCMD changes:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

I suggest that the ENOIOCTLCMD changes are in a separate patch series due to
the uncertainty of what the right return code is.

Also, while it would be great to have a different ioctl than EINVAL for unsupported
ioctls, I am afraid of breaking existing applications. Some may rely on this.

Regards,

	Hans

> 
> Mauro Carvalho Chehab (14):
>   [media] v4l2 core: return -ENOIOCTLCMD if an ioctl doesn't exist
>   [media] return -ENOIOCTLCMD for unsupported ioctl's at legacy drivers
>   [media] v4l2-ioctl: Add a default value for kernel version
>   [media] drxd, siano: Remove unused include linux/version.h
>   [media] Stop using linux/version.h on most video drivers
>   [media] pwc: Use the default version for VIDIOC_QUERYCAP
>   [media] ivtv,cx18: Use default version control for VIDIOC_QUERYCAP
>   [media] et61x251: Use LINUX_VERSION_CODE for VIDIOC_QUERYCAP
>   [media] pvrusb2: Use LINUX_VERSION_CODE for VIDIOC_QUERYCAP
>   [media] sn9c102: Use LINUX_VERSION_CODE for VIDIOC_QUERYCAP
>   [media] uvcvideo: Use LINUX_VERSION_CODE for VIDIOC_QUERYCAP
>   [media] Stop using linux/version.h the remaining video drivers
>   [media] radio: Use the subsystem version control for VIDIOC_QUERYCAP
>   [media] DocBook/v4l: Document the new system-wide version behavior
> 
>  Documentation/DocBook/media/Makefile               |    1 +
>  Documentation/DocBook/media/v4l/common.xml         |   10 ++++++++-
>  Documentation/DocBook/media/v4l/func-ioctl.xml     |   17 ++++++++-------
>  Documentation/DocBook/media/v4l/v4l2.xml           |    7 ++++++
>  .../DocBook/media/v4l/vidioc-querycap.xml          |   15 ++++++++-----
>  drivers/media/dvb/frontends/drxd_hard.c            |    1 -
>  drivers/media/dvb/siano/smscoreapi.h               |    1 -
>  drivers/media/radio/dsbr100.c                      |    7 +----
>  drivers/media/radio/radio-aimslab.c                |    5 +---
>  drivers/media/radio/radio-aztech.c                 |    5 +---
>  drivers/media/radio/radio-cadet.c                  |    5 +---
>  drivers/media/radio/radio-gemtek.c                 |    7 +----
>  drivers/media/radio/radio-maxiradio.c              |   10 +++-----
>  drivers/media/radio/radio-mr800.c                  |    6 +---
>  drivers/media/radio/radio-rtrack2.c                |    5 +---
>  drivers/media/radio/radio-sf16fmi.c                |    5 +---
>  drivers/media/radio/radio-tea5764.c                |    6 +---
>  drivers/media/radio/radio-terratec.c               |    5 +---
>  drivers/media/radio/radio-timb.c                   |    3 +-
>  drivers/media/radio/radio-trust.c                  |    5 +---
>  drivers/media/radio/radio-typhoon.c                |    9 +++----
>  drivers/media/radio/radio-zoltrix.c                |    5 +---
>  drivers/media/radio/si470x/radio-si470x-i2c.c      |    4 +--
>  drivers/media/radio/si470x/radio-si470x-usb.c      |    2 -
>  drivers/media/radio/si470x/radio-si470x.h          |    1 -
>  drivers/media/radio/wl128x/fmdrv.h                 |    5 +---
>  drivers/media/radio/wl128x/fmdrv_v4l2.c            |    1 -
>  drivers/media/video/arv.c                          |    5 +--
>  drivers/media/video/au0828/au0828-core.c           |    1 +
>  drivers/media/video/au0828/au0828-video.c          |    5 ----
>  drivers/media/video/bt8xx/bttv-driver.c            |   14 +++---------
>  drivers/media/video/bt8xx/bttvp.h                  |    3 --
>  drivers/media/video/bw-qcam.c                      |    3 +-
>  drivers/media/video/c-qcam.c                       |    3 +-
>  drivers/media/video/cpia2/cpia2.h                  |    5 ----
>  drivers/media/video/cpia2/cpia2_v4l.c              |   12 +++-------
>  drivers/media/video/cx18/cx18-driver.h             |    1 -
>  drivers/media/video/cx18/cx18-ioctl.c              |    1 -
>  drivers/media/video/cx18/cx18-version.h            |    8 +------
>  drivers/media/video/cx231xx/cx231xx-video.c        |   14 +++---------
>  drivers/media/video/cx231xx/cx231xx.h              |    1 -
>  drivers/media/video/cx23885/altera-ci.c            |    1 -
>  drivers/media/video/cx23885/cx23885-417.c          |    1 -
>  drivers/media/video/cx23885/cx23885-core.c         |   13 ++---------
>  drivers/media/video/cx23885/cx23885-video.c        |    1 -
>  drivers/media/video/cx23885/cx23885.h              |    3 +-
>  drivers/media/video/cx88/cx88-alsa.c               |   19 +++--------------
>  drivers/media/video/cx88/cx88-blackbird.c          |   20 ++----------------
>  drivers/media/video/cx88/cx88-dvb.c                |   18 ++--------------
>  drivers/media/video/cx88/cx88-mpeg.c               |   11 ++-------
>  drivers/media/video/cx88/cx88-video.c              |   21 ++-----------------
>  drivers/media/video/cx88/cx88.h                    |    4 +-
>  drivers/media/video/davinci/vpif_capture.c         |    9 ++-----
>  drivers/media/video/davinci/vpif_capture.h         |    7 +-----
>  drivers/media/video/davinci/vpif_display.c         |    9 ++-----
>  drivers/media/video/davinci/vpif_display.h         |    8 +------
>  drivers/media/video/em28xx/em28xx-video.c          |   14 ++++--------
>  drivers/media/video/et61x251/et61x251.h            |    1 -
>  drivers/media/video/et61x251/et61x251_core.c       |   16 +++-----------
>  drivers/media/video/fsl-viu.c                      |   10 +-------
>  drivers/media/video/gspca/gl860/gl860.h            |    1 -
>  drivers/media/video/gspca/gspca.c                  |   12 +++-------
>  drivers/media/video/hdpvr/hdpvr-core.c             |    1 +
>  drivers/media/video/hdpvr/hdpvr-video.c            |    2 -
>  drivers/media/video/hdpvr/hdpvr.h                  |    6 -----
>  drivers/media/video/ivtv/ivtv-driver.h             |    1 -
>  drivers/media/video/ivtv/ivtv-ioctl.c              |    1 -
>  drivers/media/video/ivtv/ivtv-version.h            |    7 +-----
>  drivers/media/video/m5mols/m5mols_capture.c        |    2 -
>  drivers/media/video/m5mols/m5mols_core.c           |    1 -
>  drivers/media/video/mem2mem_testdev.c              |    4 +--
>  drivers/media/video/mx1_camera.c                   |    5 +--
>  drivers/media/video/mx2_camera.c                   |    5 +--
>  drivers/media/video/mx3_camera.c                   |    3 +-
>  drivers/media/video/omap1_camera.c                 |    5 +--
>  drivers/media/video/omap24xxcam.c                  |    5 +--
>  drivers/media/video/omap3isp/isp.c                 |    1 +
>  drivers/media/video/omap3isp/ispvideo.c            |    1 -
>  drivers/media/video/omap3isp/ispvideo.h            |    3 +-
>  drivers/media/video/pms.c                          |    4 +--
>  drivers/media/video/pvrusb2/pvrusb2-main.c         |    1 +
>  drivers/media/video/pvrusb2/pvrusb2-v4l2.c         |    9 +------
>  drivers/media/video/pwc/pwc-ioctl.h                |    1 -
>  drivers/media/video/pwc/pwc-v4l.c                  |    1 -
>  drivers/media/video/pwc/pwc.h                      |    7 +-----
>  drivers/media/video/pxa_camera.c                   |    5 +--
>  drivers/media/video/s2255drv.c                     |   15 +++----------
>  drivers/media/video/s5p-fimc/fimc-capture.c        |    2 -
>  drivers/media/video/s5p-fimc/fimc-core.c           |    3 +-
>  drivers/media/video/saa7134/saa7134-core.c         |   12 +++-------
>  drivers/media/video/saa7134/saa7134-empress.c      |    1 -
>  drivers/media/video/saa7134/saa7134-video.c        |    2 -
>  drivers/media/video/saa7134/saa7134.h              |    3 +-
>  drivers/media/video/saa7164/saa7164.h              |    1 -
>  drivers/media/video/sh_mobile_ceu_camera.c         |    3 +-
>  drivers/media/video/sh_vou.c                       |    3 +-
>  drivers/media/video/sn9c102/sn9c102.h              |    1 -
>  drivers/media/video/sn9c102/sn9c102_core.c         |   16 +++-----------
>  drivers/media/video/timblogiw.c                    |    1 -
>  drivers/media/video/tlg2300/pd-common.h            |    1 -
>  drivers/media/video/tlg2300/pd-main.c              |    1 +
>  drivers/media/video/tlg2300/pd-radio.c             |    2 -
>  drivers/media/video/usbvision/usbvision-video.c    |   12 +----------
>  drivers/media/video/uvc/uvc_driver.c               |    3 +-
>  drivers/media/video/uvc/uvc_v4l2.c                 |    4 +-
>  drivers/media/video/uvc/uvcvideo.h                 |    3 +-
>  drivers/media/video/v4l2-ioctl.c                   |    6 +++-
>  drivers/media/video/vino.c                         |    5 +---
>  drivers/media/video/vivi.c                         |   14 +++---------
>  drivers/media/video/w9966.c                        |    4 +--
>  drivers/media/video/zoran/zoran.h                  |    4 ---
>  drivers/media/video/zoran/zoran_card.c             |    7 ++++-
>  drivers/media/video/zoran/zoran_driver.c           |    3 --
>  drivers/media/video/zr364xx.c                      |    6 +---
>  114 files changed, 186 insertions(+), 461 deletions(-)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
