Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099Ab2B1HBX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 02:01:23 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:60733 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053Ab2B1HBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 02:01:22 -0500
MIME-Version: 1.0
In-Reply-To: <001801ccf5e3$69d79860$3d86c920$%cho@samsung.com>
References: <001801ccf5e3$69d79860$3d86c920$%cho@samsung.com>
Date: Tue, 28 Feb 2012 16:01:21 +0900
X-Google-Sender-Auth: otSG6pmkyumd3c7L5SxRSBckPEE
Message-ID: <CAH9JG2Vg8o_mm0gM042T0-kjMUoAdLzF+DeGErD7R86H0xqXZQ@mail.gmail.com>
Subject: Re: [PATCH v9 0/2] iommu/exynos: Add IOMMU/System MMU driver for
 Samsung Exynos
From: Kyungmin Park <kyungmin.park@samsung.com>
To: pullip.cho@samsung.com
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Joerg Roedel <joro@8bytes.org>,
        Sanghyun Lee <sanghyun75.lee@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Younglak Kim <younglak1004.kim@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Subash Patel <subash.ramaswamy@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Some comments.
1. It's not same patch series. since it has additional feature,
exynos5 series support which don't covered at previous time.
2. It assumes that name conversion is based on exynos5 as default. now
you use gsc at exynos4 even though there's no gsc block. It should be
fimc.

So I suggest to send exynos4 series patch as before and send
additional exynos5 patch series next.

Thank you,
Kyungmin Park

On 2/28/12, KyongHo Cho <pullip.cho@samsung.com> wrote:
> Changes since v8:
> - exynos_iommu_map/unmap() just works for the page sizes
>    that System MMU supports. (Joerg's comment)
> - 1 platform device for 1 H/W though a multimedia accelerator
>    with several System MMUs attached.
>    This make controlling System MMU simpler.
> - Information between System MMU and the accelerators:
>    Shifted to accelerator's device structure from System MMU's
>
> Changes since v7:
> - Rebased with the recent commits of the following git branches
>   * git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git/next
>   * git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git/for-next
> - Changed magic numbers into macros
> - Setting owner of a System MMU in 'iommu' field of dev_archdata
> - Verbose message in the default fault handler
> - Some bug fixes.
>
> Changes since v6:
> - Totally rewrite exynos_iommu_map() and exynos_iommu_unmap() according
>   to the change in iommu_map() and iommu_unmap().
> - Change special slab for Lv2 page table to kmalloc().
>
> Changes since v5:
> - Relation between device and a domain become n:1 (Joerg's comment)
> - Implements iommu_commit(). --> Removed
>
> Changes since v4:
> - exynos_iommu_unmap()returns unmapped size in page order
>   (Ohad Ben-Cohen's comment)
> - Fixed typo error of resource names
> - Fixed missing #include<mach/sysmmu.h>
>   in arch/arm/mach-exynos4/mach-armlex4210.c
>
> Changes since v3:
> - Used DEFINE_RES_MEM and DEFINE_RES_IRQ macros
>   to define resources of System MMU (Russell King's comment)
> - Fixed removal of CONFIG_S5P_SLEEP definition
>  (Sylwester Nawrocki's comment)
>
> Changes since v2:
> - Add lock for System MMU private data.
>   And fixes the following problems pointed by Joerg Rodel:
> - Fix wrong argument to kmalloc() and get_free_pages()
> - Merged patches into 2 due to bisectability
>
> Changes since v1:
> Fixes of the following problems pointed by Russell King.:
>  - Missing unlocking a spinlock in exynos_iommu_attach_dev().
>  - atomic_t -> int in sysmmu_drvdata.activations
>  - sysmmu_platdata -> sysmmu_drvdata
>  - Change in error messages in irq handler
>  - Removed casting in format of error message
>  - omap_iommu_ops -> exynos_iommu_ops in the last patch
>
> Patch Summary:
> [PATCH v8 1/2] ARM: EXYNOS: Change System MMU platform device definitions
> [PATCH v8 2/2] iommu/exynos: Add iommu driver for Exynos Platforms
>
> The first patche enhances System MMU platform device definition:
>  - Removed System MMU for MDMA0 in TOP block because it is not
>    used. Use MDMA2 in LCD block.
>  - Removed System MMU ID. Instead, a System MMU is bound to a device
>    that the System MMU is dedicated during machin initialization.
>    If a device driver wants to handle System MMU, it must bind its
>    device with System MMU with sysmmu_set_owner().
>  - clkdev
>
> The last patch implements IOMMU API:
>  - System MMU device driver is removed from arch/arm/plat-s5p
>     to move it to driver/iommu directory.
>  - Implements IOMMU API and System MMU driver that is moved from
>     arch/arm/plat-s5p.
>
> Diffstats:
> arch/arm/mach-exynos/Kconfig                    |   11 +-
>  arch/arm/mach-exynos/Makefile                   |    2 +-
>  arch/arm/mach-exynos/clock-exynos4.c            |   74 +-
>  arch/arm/mach-exynos/clock-exynos4.h            |    2 +
>  arch/arm/mach-exynos/clock-exynos4210.c         |   11 +
>  arch/arm/mach-exynos/clock-exynos4212.c         |   28 +-
>  arch/arm/mach-exynos/clock-exynos5.c            |   85 ++
>  arch/arm/mach-exynos/dev-sysmmu.c               |  454 ++++++-----
>  arch/arm/mach-exynos/include/mach/irqs.h        |  179 ++--
>  arch/arm/mach-exynos/include/mach/map.h         |   38 +
>  arch/arm/mach-exynos/include/mach/memory.h      |    1 +
>  arch/arm/mach-exynos/include/mach/regs-clock.h  |    5 +
>  arch/arm/mach-exynos/include/mach/regs-sysmmu.h |   28 -
>  arch/arm/mach-exynos/include/mach/sysmmu.h      |   83 +-
>  arch/arm/mach-exynos/mach-armlex4210.c          |    1 -
>  arch/arm/mach-exynos/mach-smdkv310.c            |    1 -
>  arch/arm/plat-s5p/Kconfig                       |    8 -
>  arch/arm/plat-s5p/Makefile                      |    1 -
>  arch/arm/plat-s5p/sysmmu.c                      |  313 -------
>  arch/arm/plat-samsung/include/plat/devs.h       |    1 -
>  arch/arm/plat-samsung/include/plat/sysmmu.h     |   95 --
>  drivers/iommu/Kconfig                           |   22 +
>  drivers/iommu/Makefile                          |    1 +
>  drivers/iommu/exynos-iommu.c                    | 1076
> +++++++++++++++++++++++
>  24 files changed, 1698 insertions(+), 822 deletions(-)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
