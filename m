Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553Ab1I3Hej (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 03:34:39 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:44723 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753502Ab1I3Heh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 03:34:37 -0400
X-AuditID: cbfee61a-b7cf1ae00000208e-8c-4e85701aba6e
From: Kukjin Kim <kgene.kim@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: "'Russell King'" <rmk+kernel@arm.linux.org.uk>, joerg.roedel@amd.com,
        "'Ohad Ben-Cohen'" <ohad@wizery.com>,
        "'Sanghyun Lee'" <sanghyun75.lee@samsung.com>,
        younglak1004.kim@samsung.com, "'Kukjin Kim'" <kgene.kim@samsung.com>
Subject: [PATCH v2 0/5] iommu/exynos: Add IOMMU and Enhance System MMU driver
 for Exynos4
Date: Fri, 30 Sep 2011 16:30:33 +0900
Message-id: <016b01cc7f42$d72420e0$856c62a0$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Acx/QtbEYaiyoRTxSla6v1tdfTQXZw==
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This is the second try of submitting patches about IOMMU/System MMU
driver for Exynos4 SoCs with the fixes of the following problems
pointed by Russell King.:

 - Missing unlocking a spinlock in exynos_iommu_attach_dev().
 - atomic_t -> int in sysmmu_drvdata.activations
 - sysmmu_platdata -> sysmmu_drvdata
 - Change in error messages in irq handler 
 - Removed casting in format of error message
 - omap_iommu_ops -> exynos_iommu_ops in the last patch.

First 2 patches enhance System MMU platform device definition:
 - Removed System MMU for MDMA0 in LCD block because it is not used.
  Use MDMA2 in TOP block. 
 - Removed System MMU ID. Instead a System MMU is bound to a device that
  the System MMU is dedicated during machin initialization. If a device
  driver wants to handle System MMU, it must bind its device with System
  MMU with sysmmu_set_owner().
 - clkdev
 - System MMU device driver is removed from arch/arm/plat-s5p to move it
  to driver/iommu directory.

Last 3 patches implements IOMMU API:
 - Implements IOMMU API and System MMU driver that is moved from
  arch/arm/plat-s5p.
 - Implements fault handling that is suggested by Ohad.
 - Used bus_set_iommu instead of register_iommu that is suggested by Joerg.


[PATCH v2 1/5] ARM: EXYNOS4: Change System MMU device definition


arch/arm/mach-exynos4/Kconfig               |    2 -
arch/arm/mach-exynos4/clock.c               |   43 +-
arch/arm/mach-exynos4/dev-sysmmu.c          |  270 ++------
arch/arm/mach-exynos4/include/mach/irqs.h   |    1 -
arch/arm/mach-exynos4/include/mach/map.h    |    1 -
arch/arm/mach-exynos4/include/mach/sysmmu.h |   85 ++-
arch/arm/mach-exynos4/mach-armlex4210.c     |   24 +-
arch/arm/mach-exynos4/mach-smdkv310.c       |   28 +-
arch/arm/plat-s5p/Kconfig                   |    8 -
arch/arm/plat-s5p/Makefile                  |    1 -
arch/arm/plat-s5p/include/plat/sysmmu.h     |   95 ---
arch/arm/plat-s5p/sysmmu.c                  |  312 ---------
drivers/iommu/Kconfig                       |   14 +
drivers/iommu/Makefile                      |    1 +
drivers/iommu/exynos_iommu.c                |  919 +++++++++++++++++++++++++++
15 files changed, 1120 insertions(+), 684 deletions(-)


