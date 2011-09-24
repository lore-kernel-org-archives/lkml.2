Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977Ab1IXH7E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Sep 2011 03:59:04 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:46074 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161Ab1IXH7D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Sep 2011 03:59:03 -0400
MIME-Version: 1.0
In-Reply-To: <CAHQjnOOnE4x5F01wvovwJ6ZJcbs7d1fkT4xWpGv+ci=yonszFQ@mail.gmail.com>
References: <5525949.50001316849744994.JavaMail.weblogic@epml24>
	<CAHQjnOOnE4x5F01wvovwJ6ZJcbs7d1fkT4xWpGv+ci=yonszFQ@mail.gmail.com>
Date: Sat, 24 Sep 2011 15:59:01 +0800
Message-ID: <CABjrhvro3VOM770ce4Ju5pfOEUgzZ6L_LY8HPKnSzE1evX_deQ@mail.gmail.com>
Subject: Re: [PATCH 3/4] iommu/exynos: Add iommu driver for Exynos4 Platforms
From: jiaweiwei <jiaweiwei.xiyou@gmail.com>
To: KyongHo Cho <pullip.cho@samsung.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "joerg.roedel@amd.com" <joerg.roedel@amd.com>,
        =?EUC-KR?B?wMy788f2?= <sanghyun75.lee@samsung.com>,
        =?EUC-KR?B?seixucH4?= <kgene.kim@samsung.com>,
        =?EUC-KR?B?sei/tbb0?= <younglak1004.kim@samsung.com>,
        "ohad@wizery.com" <ohad@wizery.com>
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/9/24 KyongHo Cho <pullip.cho@samsung.com>
>
> I am very sorry about the duplicate emails
> and the second email of this patch is incorrect.
> My email system may have some problem :(
>
> Regards,
>
> Cho KyongHo
>
> 2011/9/24 ¡∂∞Ê»£ <pullip.cho@samsung.com>:
> > This is the System MMU driver and IOMMU API implementation for
> > Exynos4 SOC platforms. Exynos4 platforms has more than 10 System
> > MMUs dedicated for each multimedia accellerators.
> >
> > Signed-off-by: KyongHo Cho
> > ---
> > drivers/iommu/Kconfig        |   14 +
> > drivers/iommu/Makefile       |    1 +
> > drivers/iommu/exynos_iommu.c |  859 ++++++++++++++++++++++++++++++++++++++++++
> > 3 files changed, 874 insertions(+), 0 deletions(-)
> > create mode 100644 drivers/iommu/exynos_iommu.c
> >
> > diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
> > index b57b3fa..1c754cd 100644
> > --- a/drivers/iommu/Kconfig
> > +++ b/drivers/iommu/Kconfig
> > @@ -107,4 +107,18 @@ config INTR_REMAP
> >  To use x2apic mode in the CPU's which support x2APIC enhancements or
> >  to support platforms with CPU's having > 8 bit APIC ID, say Y.
> >
> > +# EXYNOS IOMMU support
> > +config EXYNOS_IOMMU
> > + bool "Exynos IOMMU Support"
> > + depends on ARCH_EXYNOS4
> > + select IOMMU_API
> > + select EXYNOS4_DEV_SYSMMU
> > + help
> > +   Support for the IOMMUs (System MMUs) Samsung Exynos application
> > +   processor family. This enables H/W multimedia accellerators to view
> > +   non-linear physical memory chunks as a linear memory in their virtual
> > +   address spaces.
> > +
> > +   If unsure, say N here.
> > +
> > endif # IOMMU_SUPPORT
> > diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
> > index 4d4d77d..1eb924f 100644
> > --- a/drivers/iommu/Makefile
> > +++ b/drivers/iommu/Makefile
> > @@ -3,3 +3,4 @@ obj-$(CONFIG_MSM_IOMMU) += msm_iommu.o msm_iommu_dev.o
> > obj-$(CONFIG_AMD_IOMMU) += amd_iommu.o amd_iommu_init.o
> > obj-$(CONFIG_DMAR) += dmar.o iova.o intel-iommu.o
> > obj-$(CONFIG_INTR_REMAP) += dmar.o intr_remapping.o
> > +obj-$(CONFIG_EXYNOS_IOMMU) += exynos_iommu.o
> > diff --git a/drivers/iommu/exynos_iommu.c b/drivers/iommu/exynos_iommu.c
> > new file mode 100644
> > index 0000000..fe5b5d8
> > --- /dev/null
> > +++ b/drivers/iommu/exynos_iommu.c
> > @@ -0,0 +1,859 @@
> > +/* linux/drivers/iommu/exynos_iommu.c
> > + *
> > + * Copyright (c) 2011 Samsung Electronics Co., Ltd.
> > + * http://www.samsung.com
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + */
> > +
> > +#include
> > +#include
> > +#include
> > +#include

Hi KyongHo,
You have lost the header file. I can just see "#include". Please check your
patch again.

Thanks
Harry Wei
