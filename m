Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757593Ab1KRKIk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 05:08:40 -0500
Received: from ganesha.gnumonks.org ([213.95.27.120]:40921 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757204Ab1KRKIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 05:08:37 -0500
From: KyongHo Cho <pullip.cho@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Younglak Kim <younglak1004.kim@samsung.com>
Cc: Joerg Roedel <joro@8bytes.org>, Sanghyun Lee <sanghyun75.lee@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH v7 0/2] iommu/exynos: Add IOMMU/System MMU driver for Samsung Exynos
Date: Fri, 18 Nov 2011 18:47:28 +0900
Message-Id: <1321609650-1329-1-git-send-email-pullip.cho@samsung.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since v6:
- Totally rewrite exynos_iommu_map() and exynos_iommu_unmap() according
  to the change in iommu_map() and iommu_unmap().
- Change special slab for Lv2 page table to kmalloc().

Changes since v5:
- Relation between device and a domain become n:1 (Joerg's comment)
- Implements iommu_commit().

Changes since v4:
- exynos_iommu_unmap()returns unmapped size in page order
 (Ohad Ben-Cohen's comment)
- Fixed typo error of resource names
- Fixed missing #include<mach/sysmmu.h>
 in arch/arm/mach-exynos4/mach-armlex4210.c

Changes since v3:
- Used DEFINE_RES_MEM and DEFINE_RES_IRQ macros
 to define resources of System MMU (Russell King's comment)
- Fixed removal of CONFIG_S5P_SLEEP definition
 (Sylwester Nawrocki's comment)

Changes since v2:
- Add lock for System MMU private data.
 And fixes the following problems pointed by Joerg Rodel:
- Fix wrong argument to kmalloc() and get_free_pages()
- Merged patches into 2 due to bisectability

Changes since v1:
Fixes of the following problems pointed by Russell King.:
 - Missing unlocking a spinlock in exynos_iommu_attach_dev().
 - atomic_t -> int in sysmmu_drvdata.activations
 - sysmmu_platdata -> sysmmu_drvdata
 - Change in error messages in irq handler
 - Removed casting in format of error message
 - omap_iommu_ops -> exynos_iommu_ops in the last patch

Patch Summary:
[PATCH v7 1/2] ARM: EXYNOS: Change System MMU platform device definitions
[PATCH v7 2/2] iommu/exynos: Add iommu driver for Exynos Platforms

The first patche enhances System MMU platform device definition:
 - Removed System MMU for MDMA0 in TOP block because it is not
  used. Use MDMA2 in LCD block.
 - Removed System MMU ID. Instead, a System MMU is bound to a device
  that the System MMU is dedicated during machin initialization.
  If a device driver wants to handle System MMU, it must bind its
  device with System MMU with sysmmu_set_owner().
 - clkdev

The last patch implements IOMMU API:
 - System MMU device driver is removed from arch/arm/plat-s5p
  to move it to driver/iommu directory.
 - Implements IOMMU API and System MMU driver that is moved from
  arch/arm/plat-s5p.
 - Implements fault handling that is suggested by Ohad.
 - Used bus_set_iommu instead of register_iommu that is suggested
  by Joerg.
 - Implements iommu_commit().

Diffstat:
 arch/arm/mach-exynos/Kconfig                      |    2 +
 arch/arm/mach-exynos/clock-exynos4210.c           |   16 +
 arch/arm/mach-exynos/clock.c                      |   55 +-
 arch/arm/mach-exynos/dev-sysmmu.c                 |  272 ++-----
 arch/arm/mach-exynos/include/mach/dev-sysmmu.h    |   61 ++
 arch/arm/mach-exynos/include/mach/exynos4-clock.h |    1 +
 arch/arm/mach-exynos/include/mach/map.h           |    3 +-
 arch/arm/mach-exynos/include/mach/regs-sysmmu.h   |   26 +-
 arch/arm/mach-exynos/include/mach/sysmmu.h        |   46 -
 arch/arm/mach-exynos/mach-armlex4210.c            |    1 -
 arch/arm/mach-exynos/mach-nuri.c                  |   40 +
 arch/arm/mach-exynos/mach-origen.c                |   42 +
 arch/arm/mach-exynos/mach-smdk4x12.c              |    9 +
 arch/arm/mach-exynos/mach-smdkv310.c              |   43 +-
 arch/arm/mach-exynos/mach-universal_c210.c        |   42 +
 arch/arm/plat-s5p/Kconfig                         |    8 -
 arch/arm/plat-s5p/Makefile                        |    1 -
 arch/arm/plat-s5p/sysmmu.c                        |  312 -------
 arch/arm/plat-samsung/include/plat/devs.h         |    1 -
 arch/arm/plat-samsung/include/plat/sysmmu.h       |   95 --
 drivers/iommu/Kconfig                             |   12 +
 drivers/iommu/Makefile                            |    1 +
 drivers/iommu/exynos-iommu.c                      |  958 +++++++++++++++++++++
 23 files changed, 1327 insertions(+), 720 deletions(-)
