Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759177Ab0HEPoB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 11:44:01 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:52580 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754695Ab0HEPn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 11:43:59 -0400
Date: Fri, 6 Aug 2010 01:43:51 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: gregkh@suse.de, linuxppc-dev@ozlabs.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] driver core: Add ability for arch code to setup
 pdev_archdata
Message-Id: <20100806014351.a3bddf08.sfr@canb.auug.org.au>
In-Reply-To: <1281021347-1278-2-git-send-email-galak@kernel.crashing.org>
References: <1281021347-1278-1-git-send-email-galak@kernel.crashing.org>
	<1281021347-1278-2-git-send-email-galak@kernel.crashing.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__6_Aug_2010_01_43_51_+1000_Y=T8TFo=AAd+3kG2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__6_Aug_2010_01_43_51_+1000_Y=T8TFo=AAd+3kG2
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kumar,

On Thu,  5 Aug 2010 10:15:45 -0500 Kumar Gala <galak@kernel.crashing.org> w=
rote:
>
> --- a/drivers/base/platform.c
> +++ b/drivers/base/platform.c
> @@ -19,6 +19,7 @@
>  #include <linux/err.h>
>  #include <linux/slab.h>
>  #include <linux/pm_runtime.h>
> +#include <asm/platform_device.h>
> =20
>  #include "base.h"
> =20
> @@ -170,6 +171,9 @@ struct platform_device *platform_device_alloc(const c=
har *name, int id)
>  		pa->pdev.id =3D id;
>  		device_initialize(&pa->pdev.dev);
>  		pa->pdev.dev.release =3D platform_device_release;
> +#ifdef ARCH_HAS_PDEV_ARCHDATA_SETUP
> +		arch_setup_pdev_archdata(&pa->pdev);
> +#endif
>  	}
> =20
>  	return pa ? &pa->pdev : NULL;
> diff --git a/include/asm-generic/platform_device.h b/include/asm-generic/=
platform_device.h
> new file mode 100644
> index 0000000..64806dc
> --- /dev/null
> +++ b/include/asm-generic/platform_device.h
> @@ -0,0 +1,7 @@
> +#ifndef __ASM_GENERIC_PLATFORM_DEVICE_H_
> +#define __ASM_GENERIC_PLATFORM_DEVICE_H_
> +/*
> + * an architecture can override to define arch_setup_pdev_archdata
> + */
> +
> +#endif /* __ASM_GENERIC_PLATFORM_DEVICE_H_ */

Why not do:

#include <linux/platform_device.h>

#ifndef arch_setup_pdev_archdata
static inline void arch_setup_pdev_archdata(struct platform_device *pdev) {=
 }
#endif

in asm-generic/platform-device.h

and the the call in platform_device_alloc() can be unconditional.  If the a=
rch wants to override arch_setup_pdev_archdata, it defines the function and=
 then does

#define arch_setup_pdev_archdata arch_setup_pdev_archdata

before still including asm-generic/platform_device.h

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__6_Aug_2010_01_43_51_+1000_Y=T8TFo=AAd+3kG2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMWtw3AAoJEDMEi1NhKgbsjS4H/j+eNtfSG4/GTchZ2DCqdebQ
sM0U2lHijJXRaz1RPkZxDnb0/DmZDP+GqubAUILbbdZy57OceCEz/YHIqGqsKsAN
noIWtk2AYdC/u37iGmxSn8deHyNIhagZ2Ybf2dewaiumB9ednwoPq/sDDqKOEW9E
AZPeukKS9np3IMhfpZAsDOb0VY1uTm09d5Wwj3VVx6a2vm7T05DmZccD2cNkzjsf
COAt42ExNCaQaBDM9Rlm/QkZgLgPIGHp5NBbAcSZ/xY/YkEDfzoOGDXlSBXXhPtW
grzUOxEbIb5plcVjYb7m+lghZxjiNwDuUQ0lIA2VLHJRnnNQA9fcYuoArfKuxhQ=
=WSMj
-----END PGP SIGNATURE-----

--Signature=_Fri__6_Aug_2010_01_43_51_+1000_Y=T8TFo=AAd+3kG2--
