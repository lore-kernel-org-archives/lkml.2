Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200Ab0EEFTP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 01:19:15 -0400
Received: from smtp.nokia.com ([192.100.122.230]:25137 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423Ab0EEFTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 01:19:13 -0400
Subject: Re: [PATCH] ubi: init even if mtd device cannot be attached, if
 built into kernel
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
       Kevin Cernekee <kpc.mtd@gmail.com>,
       Adrian Hunter <adrian.hunter@nokia.com>,
       Dmitry Pervushin <dpervushin@embeddedalley.com>,
       Roel Kluin <roel.kluin@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1272537664-21603-1-git-send-email-mkl@pengutronix.de>
References: <1272537664-21603-1-git-send-email-mkl@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 May 2010 08:12:39 +0300
Message-ID: <1273036359.3702.35.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 05 May 2010 05:18:51.0618 (UTC) FILETIME=[72FC3C20:01CAEC12]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-29 at 12:41 +0200, Marc Kleine-Budde wrote:
> Ubi can be built into the kernel or be compiled as a kernel module.
> Further on the command line one can specify mtd devices to be attach to
> ubi while loading. In the current implementation the ubi driver refuses
> to load if one of the mtd devices cannot be attached.
> 
> Consider:
> 1) ubi compiled into the kernel and
> 2) a mtd device specified on the command line and
> 3) this mtd device contains bogus data (for whatever reason).
> 
> During init ubi tries to attach the mtd device is this fails the whole
> ubi subsystem isn't initialized. Later the userspace cannot attach any
> mtd to ubi because ubi isn't loaded.
> 
> This patch keeps the current behaviour: if ubi is compiled as a module
> and a mtd device cannot be attached the ubi module cannot be loaded,
> but changes it for the ubi-is-built-into-the-kernel usecase.
> 
> If ubi is builtin, a not attachable mtd device doen't stop ubi from
> initializing. This slightly modifies the behaviour if multiple mtd
> devices are specified on the command line. Now every mtd device is
> probed and, if possible, attached, i.e. a faulty mtd device doesn't
> stop the others from being attached.
> 
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> ---
>  drivers/mtd/ubi/build.c |   12 ++++++++++--
>  1 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
> index 14cec04..2f6f09f 100644
> --- a/drivers/mtd/ubi/build.c
> +++ b/drivers/mtd/ubi/build.c
> @@ -123,6 +123,12 @@ static struct device_attribute dev_bgt_enabled =
>  static struct device_attribute dev_mtd_num =
>  	__ATTR(mtd_num, S_IRUGO, dev_attribute_show, NULL);
>  
> +#ifdef CONFIG_MTD_UBI_MODULE
> +static inline int ubi_is_module(void) { return 1; }
> +#else
> +static inline int ubi_is_module(void) { return 0; }
> +#endif

I really hate these ifdefs. Dunno why, but they feel disgusting.

I understand your issue and agree that is should be fixed. And I cannot
really see a better solution. So if no-one complains, I'll accept your
patch.

However, for consistency with other UBI code (see debug.h), please, do
this like

#ifdef CONFIG_MTD_UBI_MODULE
#define ubi_is_module() 1
#else
#define ubi_is_module() 1
#endif

Not a big deal, just to be consistent and have uniform code style.

Thanks... :-(

> +
>  /**
>   * ubi_volume_notify - send a volume change notification.
>   * @ubi: UBI device description object
> @@ -1200,9 +1206,11 @@ static int __init ubi_init(void)
>  					 p->vid_hdr_offs);
>  		mutex_unlock(&ubi_devices_mutex);
>  		if (err < 0) {
> -			put_mtd_device(mtd);
>  			ubi_err("cannot attach mtd%d", mtd->index);
> -			goto out_detach;
> +			if (ubi_is_module()) {
> +				put_mtd_device(mtd);
> +				goto out_detach;
> +			}
>  		}
>  	}
>  

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

