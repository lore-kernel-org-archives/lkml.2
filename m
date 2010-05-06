Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520Ab0EFGQ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 02:16:28 -0400
Received: from smtp.nokia.com ([192.100.122.230]:47374 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100Ab0EFGQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 02:16:27 -0400
Subject: Re: [PATCH V2] ubi: init even if mtd device cannot be attached, if
 built into kernel
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: David Woodhouse <dwmw2@infradead.org>, Andi Kleen <ak@linux.intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Dmitry Pervushin <dpervushin@embeddedalley.com>,
       Kevin Cernekee <kpc.mtd@gmail.com>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1273047445-23411-1-git-send-email-mkl@pengutronix.de>
References: <1273047445-23411-1-git-send-email-mkl@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 06 May 2010 09:15:25 +0300
Message-ID: <1273126525.3702.196.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 06 May 2010 06:15:59.0904 (UTC) FILETIME=[98D0EA00:01CAECE3]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-05 at 10:17 +0200, Marc Kleine-Budde wrote:
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
> V2: integrated comments from Artem Bityutskiy:
>     use defines instead of static inline functions
> 
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> ---
>  drivers/mtd/ubi/build.c |   12 ++++++++++--
>  1 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
> index fad40aa..d0447a5 100644
> --- a/drivers/mtd/ubi/build.c
> +++ b/drivers/mtd/ubi/build.c
> @@ -49,6 +49,12 @@
>  /* Maximum length of the 'mtd=' parameter */
>  #define MTD_PARAM_LEN_MAX 64
>  
> +#ifdef CONFIG_MTD_UBI_MODULE
> +#define ubi_is_module() 1
> +#else
> +#define ubi_is_module() 0
> +#endif
> +
>  /**
>   * struct mtd_dev_param - MTD device parameter description data structure.
>   * @name: MTD character device node path, MTD device name, or MTD device number
> @@ -1240,9 +1246,11 @@ static int __init ubi_init(void)
>  					 p->vid_hdr_offs);
>  		mutex_unlock(&ubi_devices_mutex);
>  		if (err < 0) {
> -			put_mtd_device(mtd);
>  			ubi_err("cannot attach mtd%d", mtd->index);
> -			goto out_detach;
> +			if (ubi_is_module()) {
> +				put_mtd_device(mtd);
We should put the MTD device even if we continue, because we did not
attach it.
> +				goto out_detach;
> +			}
>  		}
>  	}
>  

I've added a comment and fixed your patch, and pushed to ubi-2.6.git.
Please, check it.

>From af7ad7a0a6c0c1d8497a25b6b8b3b2ce9f52ff04 Mon Sep 17 00:00:00 2001
From: Marc Kleine-Budde <mkl@pengutronix.de>
Date: Wed, 5 May 2010 10:17:25 +0200
Subject: [PATCH] UBI: init even if MTD device cannot be attached, if built into kernel

UBI can be built into the kernel or be compiled as a kernel module.
Further on the command line one can specify MTD devices to be attach to
UBI while loading. In the current implementation the UBI driver refuses
to load if one of the MTD devices cannot be attached.

Consider:
1) UBI compiled into the kernel and
2) a MTD device specified on the command line and
3) this MTD device contains bogus data (for whatever reason).

During init UBI tries to attach the MTD device is this fails the whole
UBI subsystem isn't initialized. Later the userspace cannot attach any
MTD to UBI because UBI isn't loaded.

This patch keeps the current behaviour: if UBI is compiled as a module
and a MTD device cannot be attached the UBI module cannot be loaded,
but changes it for the UBI-is-built-into-the-kernel usecase.

If UBI is builtin, a not attachable MTD device doen't stop UBI from
initializing. This slightly modifies the behaviour if multiple MTD
devices are specified on the command line. Now every MTD device is
probed and, if possible, attached, i.e. a faulty MTD device doesn't
stop the others from being attached.

Artem: tweaked the patch

Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 drivers/mtd/ubi/build.c |   25 +++++++++++++++++++++++--
 1 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
index 3a59a1d..13b05cb 100644
--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -49,6 +49,12 @@
 /* Maximum length of the 'mtd=' parameter */
 #define MTD_PARAM_LEN_MAX 64
 
+#ifdef CONFIG_MTD_UBI_MODULE
+#define ubi_is_module() 1
+#else
+#define ubi_is_module() 0
+#endif
+
 /**
  * struct mtd_dev_param - MTD device parameter description data structure.
  * @name: MTD character device node path, MTD device name, or MTD device number
@@ -1206,9 +1212,24 @@ static int __init ubi_init(void)
 					 p->vid_hdr_offs);
 		mutex_unlock(&ubi_devices_mutex);
 		if (err < 0) {
-			put_mtd_device(mtd);
 			ubi_err("cannot attach mtd%d", mtd->index);
-			goto out_detach;
+			put_mtd_device(mtd);
+
+			/*
+			 * Originally UBI stopped initializing on any error.
+			 * However, later on it was found out that this
+			 * behavior is not very good when UBI is compiled into
+			 * the kernel and the MTD devices to attach are passed
+			 * through the command line. Indeed, UBI failure
+			 * stopped whole boot sequence.
+			 *
+			 * To fix this, we changed the behavior for the
+			 * non-module case, but preserved the old behavior for
+			 * the module case, just for compatibility. This is a
+			 * little inconsistent, though.
+			 */
+			if (ubi_is_module())
+				goto out_detach;
 		}
 	}
 
-- 
1.6.6.1


-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

