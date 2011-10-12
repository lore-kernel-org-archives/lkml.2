Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744Ab1JLIHm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 04:07:42 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:21513 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264Ab1JLIHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 04:07:39 -0400
X-AuditID: cbfee61b-b7b7fae000005864-cb-4e954ac9a751
Reply-to: pullip.cho@samsung.com
From: KyongHo Cho <pullip.cho@samsung.com>
To: "'Linux ARM Kernel'" <linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: "'Russell King'" <rmk+kernel@arm.linux.org.uk>, joerg.roedel@amd.com,
        "'Ohad Ben-Cohen'" <ohad@wizery.com>,
        "'Sanghyun Lee'" <sanghyun75.lee@samsung.com>,
        younglak1004.kim@samsung.com, "'Kukjin Kim'" <kgene.kim@samsung.com>
Subject: [PATCH v4 0/2] iommu/exynos: Add IOMMU and Enhance System MMU driver
 for Exynos4
Date: Wed, 12 Oct 2011 17:07:37 +0900
Organization: Samsung Electronics Co., Ltd
Message-id: <000101cc88b6$013d1ef0$03b75cd0$%cho@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AcyItgEUOkjVbj2YTG2oCax9k74Udw==
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

This is the firth try of submitting patches about IOMMU/System MMU

Patch Summary:
[PATCH v4 1/2] ARM: EXYNOS4: Change System MMU device definition
[PATCH v4 2/2] iommu/exynos: Add iommu driver for Exynos Platforms

The first patche enhances System MMU platform device definition:
 - Removed System MMU for MDMA0 in LCD block because it is not
   used. Use MDMA2 in TOP block.
 - Removed System MMU ID. Instead a System MMU is bound to a device
   That the System MMU is dedicated during machin initialization.
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
 - omap_iommu_ops -> exynos_iommu_ops in the last patch.

Diffstat:

 arch/arm/mach-exynos4/Kconfig               |    2 -
 arch/arm/mach-exynos4/clock.c               |   43 +-
 arch/arm/mach-exynos4/dev-sysmmu.c          |  260 ++------
 arch/arm/mach-exynos4/include/mach/irqs.h   |    1 -
 arch/arm/mach-exynos4/include/mach/map.h    |    1 -
 arch/arm/mach-exynos4/include/mach/sysmmu.h |   85 ++-
 arch/arm/mach-exynos4/mach-armlex4210.c     |   24 +-
 arch/arm/mach-exynos4/mach-smdkv310.c       |   28 +-
 arch/arm/plat-s5p/Kconfig                   |    8 -
 arch/arm/plat-s5p/Makefile                  |    1 -
 arch/arm/plat-s5p/sysmmu.c                  |  312 ---------
 arch/arm/plat-samsung/include/plat/sysmmu.h |   95 ---
 drivers/iommu/Kconfig                       |   14 +
 drivers/iommu/Makefile                      |    1 +
 drivers/iommu/exynos_iommu.c                |  962
+++++++++++++++++++++++++++
 15 files changed, 1153 insertions(+), 684 deletions(-)

