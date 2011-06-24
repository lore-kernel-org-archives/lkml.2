Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595Ab1FXLaV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 07:30:21 -0400
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:1436 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234Ab1FXLaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 07:30:19 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [RFC] Don't use linux/version.h anymore to indicate a per-driver version - Was: Re: [PATCH 03/37] Remove unneeded version.h includes from include/
Date: Fri, 24 Jun 2011 13:26:27 +0200
User-Agent: KMail/1.13.5 (Linux/3.0.0-rc1-tschai; KDE/4.6.2; x86_64; ; )
Cc: Jesper Juhl <jj@chaosbits.net>, LKML <linux-kernel@vger.kernel.org>,
        trivial@kernel.org, linux-media@vger.kernel.org,
        ceph-devel@vger.kernel.org, Sage Weil <sage@newdream.net>
References: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net> <alpine.LNX.2.00.1106232356530.17688@swampdragon.chaosbits.net> <4E04732A.3060305@infradead.org>
In-Reply-To: <4E04732A.3060305@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106241326.27593.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 24, 2011 13:21:14 Mauro Carvalho Chehab wrote:
> Em 23-06-2011 18:58, Jesper Juhl escreveu:
> > It was pointed out by 'make versioncheck' that some includes of
> > linux/version.h were not needed in include/.
> > This patch removes them.
> > 
> > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> > ---
> >  include/linux/ceph/messenger.h |    1 -
> >  include/media/pwc-ioctl.h      |    1 -
> >  2 files changed, 0 insertions(+), 2 deletions(-)
> > 
> > diff --git a/include/linux/ceph/messenger.h b/include/linux/ceph/messenger.h
> > index 31d91a6..291aa6e 100644
> > --- a/include/linux/ceph/messenger.h
> > +++ b/include/linux/ceph/messenger.h
> > @@ -6,7 +6,6 @@
> >  #include <linux/net.h>
> >  #include <linux/radix-tree.h>
> >  #include <linux/uio.h>
> > -#include <linux/version.h>
> >  #include <linux/workqueue.h>
> >  
> >  #include "types.h"
> > diff --git a/include/media/pwc-ioctl.h b/include/media/pwc-ioctl.h
> > index 0f19779..1ed1e61 100644
> > --- a/include/media/pwc-ioctl.h
> > +++ b/include/media/pwc-ioctl.h
> > @@ -53,7 +53,6 @@
> >   */
> >  
> >  #include <linux/types.h>
> > -#include <linux/version.h>
> >  
> >  /* Enumeration of image sizes */
> >  #define PSZ_SQCIF	0x00
> 
> 
> The usage of version.h at the Linux media kernel is due to a V4L2 API requirement[1],
> where an ioctl query of VIDIOC_QUERYCAP type would return the driver version formatted
> with KERNEL_VERSION() macro.
> 
> [1] http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-querycap.html
> 
> While a few driver maintainers are careful enough to increment it on every new
> kernel version where the driver was touched, others simply keep it outdated.
> 
> IMHO, it doesn't make much sense on having a per-driver version field: the V4L2 layer
> should be enough to abstract hardware differences, and to avoid userspace to have a per
> driver list of hacks. I don't think that the userspace applications are really using it.

Applications are certainly using it. I know this for a fact for the ivtv driver where
feature improvements are marked that way.

Without more research on how this is used I am not comfortable with this.

Regards,

	Hans

> Module versions should just use the MODULE_VERSION() macro.
> 
> So, IMO, the better would be to convert this field into a V4L2 API version field
> instead like the enclosed patch. Of course, this also means to change the V4L2 API
> Docbook. After that, we can cleanup all those linux/version.h code on all V4L drivers.
> 
> The idea is that, every time we add something new at the V4L2 API, we'll increment it
> to match the current kernel version.
> 
> On a quick look, all drivers, except by one uses versions <= KERNEL_VERSION(3, 0, 0).
> The only exception is the pwc driver, with version is KERNEL_VERSION(10, 0, 12). Due to
> a bug on it, it also reports its version as: "10.0.14" at module version. The version
> 10.0.12 is reported there since 2006, even having suffered a major change, due to the
> removal of the V4L1 API, on changeset 479567ce3af7b99d645a3c53b8ca2fc65e46efdc.
> So, I think it would be safe to change it to 3.0.0, as using the version here, in the favor
> of a greater good. We can keep the driver-specific version only at 
> 
> Comments?
> 
> If others are ok with that, I'll prepare the changesets.
> 
> Cheers,
> Mauro
> 
> 
> -
> 
> [media] v4l2 core: Use a per-API version instead of a per driver version
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
> index 213ba7d..d8fa571 100644
> --- a/drivers/media/video/v4l2-ioctl.c
> +++ b/drivers/media/video/v4l2-ioctl.c
> @@ -16,6 +16,7 @@
>  #include <linux/slab.h>
>  #include <linux/types.h>
>  #include <linux/kernel.h>diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
> index 213ba7d..b19ad56 100644
> --- a/drivers/media/video/v4l2-ioctl.c
> +++ b/drivers/media/video/v4l2-ioctl.c
> @@ -16,6 +16,7 @@
>  #include <linux/slab.h>
>  #include <linux/types.h>
>  #include <linux/kernel.h>
> +#include <linux/version.h>
>  
>  #include <linux/videodev2.h>
>  
> @@ -27,6 +28,8 @@
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-chip-ident.h>
>  
> +#define V4L2_API_VERSION KERNEL_VERSION(3, 0, 0)
> +
>  #define dbgarg(cmd, fmt, arg...) \
>  		do {							\
>  		    if (vfd->debug & V4L2_DEBUG_IOCTL_ARG) {		\
> @@ -606,13 +609,16 @@ static long __video_do_ioctl(struct file *file,
>  			break;
>  
>  		ret = ops->vidioc_querycap(file, fh, cap);
> -		if (!ret)
> +		if (!ret) {
> +			cap->version = V4L2_API_VERSION;
> +
>  			dbgarg(cmd, "driver=%s, card=%s, bus=%s, "
>  					"version=0x%08x, "
>  					"capabilities=0x%08x\n",
>  					cap->driver, cap->card, cap->bus_info,
>  					cap->version,
>  					cap->capabilities);
> +		}
>  		break;
>  	}
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
