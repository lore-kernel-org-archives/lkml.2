Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758713Ab2CFIbX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 03:31:23 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:51077 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757934Ab2CFIbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 03:31:21 -0500
X-AuditID: cbfee61a-b7b78ae000001ceb-c7-4f55cb4c1d3c
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
Subject: [PATCH v10 0/3] iommu/exynos: Add IOMMU/System MMU driver for Samsung
 Exynos
Date: Tue, 06 Mar 2012 17:31:24 +0900
Organization: Samsung Electronics Co., Ltd
Message-id: <001f01ccfb73$84a2bbd0$8de83370$%cho@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Content-language: ko
Thread-index: Acz7c4RZYMpGoGtvSUu/MImSC51f0w==
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches are successfully compiled
in linux-samsung.git/for-next branch
You can find  the git repo. In
http://git.kernel.org/?p=linux/kernel/git/kgene/linux-samsung.git;a=summary

Changes since v9:
- Split the first patch into 2 patches.
   One removes System MMU driver from arch/arm/plat- tree and
   the other modifies and adds platform device definitions in
   arch/arm/mach tree
- Some bug fixes
- Change "gsc" for Exynos4 to "fimc"

Changes since v8:
- exynos_iommu_map/unmap() just works for the page sizes
   that System MMU supports. (Joerg's comment)
- 1 platform device for 1 H/W though a multimedia accelerator
   with several System MMUs attached.
   This make controlling System MMU simpler.
- Information between System MMU and the accelerators:
   Shifted to accelerator's device structure from System MMU's

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
[PATCH v10 1/3] S5P: SYSMMU: Remove System MMU device driver definitions
[PATCH v10 2/3] ARM: EXYNOS: Change System MMU platform device definitions
[PATCH v10 3/3] iommu/exynos: Add iommu driver for Exynos Platforms

The first patch removes the existing System MMU device driver
which does not conform to IOMMU API set prepared in the kernel.
 
The second patch enhances System MMU platform device definition:
 - Removed System MMU for MDMA0 in TOP block because it is not
   used. Use MDMA2 in LCD block.
 - Removed System MMU ID. Instead, a System MMU is bound to a device
   that the System MMU is dedicated during machin initialization.
   If a device driver wants to handle System MMU, it must bind its
   device with System MMU with sysmmu_set_owner().
 - clkdev
 - Added support for Exynos5

The last patch implements IOMMU API:
- New System MMU device driver that fully implements IOMMU API.

Thanks to Kyungmin Park and Marek Szyprowski for kind review.

Diffstats:
 arch/arm/mach-exynos/Kconfig                    |   11 +-
 arch/arm/mach-exynos/Makefile                   |    2 +-
 arch/arm/mach-exynos/clock-exynos4.c            |   87 +-
 arch/arm/mach-exynos/clock-exynos4.h            |    2 +
 arch/arm/mach-exynos/clock-exynos4210.c         |   11 +
 arch/arm/mach-exynos/clock-exynos4212.c         |   28 +-
 arch/arm/mach-exynos/clock-exynos5.c            |   90 ++
 arch/arm/mach-exynos/dev-sysmmu.c               |  457 ++++++-----
 arch/arm/mach-exynos/include/mach/irqs.h        |  179 ++--
 arch/arm/mach-exynos/include/mach/map.h         |   38 +
 arch/arm/mach-exynos/include/mach/regs-clock.h  |    5 +
 arch/arm/mach-exynos/include/mach/regs-sysmmu.h |   28 -
 arch/arm/mach-exynos/include/mach/sysmmu.h      |   84 +-
 arch/arm/mach-exynos/mach-armlex4210.c          |    1 -
 arch/arm/mach-exynos/mach-smdkv310.c            |    1 -
 arch/arm/plat-s5p/Kconfig                       |    8 -
 arch/arm/plat-s5p/Makefile                      |    1 -
 arch/arm/plat-s5p/sysmmu.c                      |  313 -------
 arch/arm/plat-samsung/include/plat/devs.h       |    1 -
 arch/arm/plat-samsung/include/plat/sysmmu.h     |   95 --
 drivers/iommu/Kconfig                           |   21 +
 drivers/iommu/Makefile                          |    1 +
 drivers/iommu/exynos-iommu.c                    | 1088 +++++++++++++++++++++++
 23 files changed, 1726 insertions(+), 826 deletions(-)

