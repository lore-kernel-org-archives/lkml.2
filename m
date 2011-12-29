Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044Ab1L2MYV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 07:24:21 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:11797 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753965Ab1L2MYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 07:24:20 -0500
X-AuditID: cbfee61a-b7b89ae000001a15-b1-4efc5bf2fd90
Reply-to: pullip.cho@samsung.com
From: KyongHo Cho <pullip.cho@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: "'Joerg Roedel'" <joro@8bytes.org>,
        "'Sanghyun Lee'" <sanghyun75.lee@samsung.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Younglak Kim'" <younglak1004.kim@samsung.com>,
        "'Marek Szyprowski'" <m.szyprowski@samsung.com>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Subash Patel'" <subash.ramaswamy@linaro.org>
Subject: [PATCH v8 0/2] ommu/exynos: Add IOMMU/System MMU driver for Samsung
 Exynos
Date: Thu, 29 Dec 2011 21:24:18 +0900
Organization: Samsung Electronics Co., Ltd
Message-id: <000e01ccc624$c9349310$5b9db930$%cho@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AczGJMkQSC3xCF3PRT6v7FM7y8tKXg==
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since v7:
- Rebased with the recent commits of the following git branches
  * git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git/next
  * git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git/for-next
- Changed magic numbers into macros
- Setting owner of a System MMU in 'iommu' field of dev_archdata
- Verbose message in the default fault handler
- Some bug fixes.

Changes since v6:
- Totally rewrite exynos_iommu_map() and exynos_iommu_unmap() according
  to the change in iommu_map() and iommu_unmap().
- Change special slab for Lv2 page table to kmalloc().

Changes since v5:
- Relation between device and a domain become n:1 (Joerg's comment)
- Implements iommu_commit(). --> Removed

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
[PATCH v8 1/2] ARM: EXYNOS: Change System MMU platform device definitions
[PATCH v8 2/2] iommu/exynos: Add iommu driver for Exynos Platforms

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

Diffstats:
 arch/arm/mach-exynos/Kconfig                      |    5 +
 arch/arm/mach-exynos/clock-exynos4210.c           |   16 +
 arch/arm/mach-exynos/clock-exynos4212.c           |    1 +
 arch/arm/mach-exynos/clock.c                      |   55 +-
 arch/arm/mach-exynos/dev-sysmmu.c                 |  277 ++-----
 arch/arm/mach-exynos/include/mach/dev-sysmmu.h    |   64 ++
 arch/arm/mach-exynos/include/mach/exynos4-clock.h |    1 +
 arch/arm/mach-exynos/include/mach/map.h           |    3 +-
 arch/arm/mach-exynos/include/mach/regs-sysmmu.h   |   26 +-
 arch/arm/mach-exynos/include/mach/sysmmu.h        |   46 -
 arch/arm/mach-exynos/mach-armlex4210.c            |    1 -
 arch/arm/mach-exynos/mach-nuri.c                  |   40 +
 arch/arm/mach-exynos/mach-origen.c                |   42 +
 arch/arm/mach-exynos/mach-smdk4x12.c              |   22 +
 arch/arm/mach-exynos/mach-smdkv310.c              |   43 +-
 arch/arm/mach-exynos/mach-universal_c210.c        |   42 +
 arch/arm/plat-s5p/Kconfig                         |    8 -
 arch/arm/plat-s5p/Makefile                        |    1 -
 arch/arm/plat-s5p/sysmmu.c                        |  313 -------
 arch/arm/plat-samsung/include/plat/devs.h         |    1 -
 arch/arm/plat-samsung/include/plat/sysmmu.h       |   95 --
 drivers/iommu/Kconfig                             |   12 +
 drivers/iommu/Makefile                            |    1 +
 drivers/iommu/exynos-iommu.c                      | 1008 +++++++++++++++++++++
 24 files changed, 1399 insertions(+), 724 deletions(-)

