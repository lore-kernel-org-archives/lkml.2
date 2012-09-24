Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866Ab2IXJE6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 05:04:58 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19008 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105Ab2IXJEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 05:04:52 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 24 Sep 2012 02:02:52 -0700
Date: Mon, 24 Sep 2012 12:04:15 +0300
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Joerg Roedel <joerg.roedel@amd.com>, Arnd Bergmann <arnd@arndb.de>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        Krishna Reddy <vdumpa@nvidia.com>
CC: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "minchan@kernel.org" <minchan@kernel.org>,
        "chunsang.jeong@linaro.org" <chunsang.jeong@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "subashrp@gmail.com" <subashrp@gmail.com>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
        "pullip.cho@samsung.com" <pullip.cho@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: How to specify IOMMU'able devices in DT (was: [RFC 0/5] ARM:
 dma-mapping: New dma_map_ops to control IOVA more precisely)
Message-ID: <20120924120415.8e6929a34c422185a98d3f82@nvidia.com>
In-Reply-To: <401E54CE964CD94BAE1EB4A729C7087E379FDC2372@HQMAIL04.nvidia.com>
References: <1346223335-31455-1-git-send-email-hdoyu@nvidia.com>
	<20120918124918.GK2505@amd.com>
	<20120919095843.d1db155e0f085f4fcf64ea32@nvidia.com>
	<201209190759.46174.arnd@arndb.de>
	<20120919125020.GQ2505@amd.com>
	<401E54CE964CD94BAE1EB4A729C7087E379FDC1EEB@HQMAIL04.nvidia.com>
	<505A7DB4.4090902@wwwdotorg.org>
	<401E54CE964CD94BAE1EB4A729C7087E379FDC1F2D@HQMAIL04.nvidia.com>
	<505B35F7.2080201@wwwdotorg.org>
	<401E54CE964CD94BAE1EB4A729C7087E379FDC2372@HQMAIL04.nvidia.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Sep 2012 20:16:00 +0200
Krishna Reddy <vdumpa@nvidia.com> wrote:

> > > The device(H/W controller) need to access few special memory
> > > blocks(IOVA==PA) and DRAM as well.
> >
> > OK, so only /some/ of the VA space is VA==PA, and some is remapped; that's a
> > little different that what you originally implied above.
> >
> > BTW, which HW module is this; AVP/COP or something else. This sounds like an
> > odd requirement.
>
> This is not specific to ARM7. There are protected memory regions on Tegra that
> can be accessed by some controllers like display, 2D, 3D, VDE, HDA. These are
> DRAM regions configured as protected by BootRom. These memory regions
> are not exposed to and not managed by OS page allocator. The H/W controller
>  accesses to these regions still to go through IOMMU.
> The IOMMU view for all the H/W controllers is not uniform on Tegra.
> Some Controllers see entire 4GB IOVA space. i.e all accesses go though IOMMU.
> Some controllers see the IOVA Space that don't overlap with MMIO space.  i.e
> The MMIO address access bypass IOMMU and directly go to MMIO space.
> Tegra IOMMU can support multiple address spaces as well. To hide controller
> Specific behavior, the drivers should take care of one to one mapping and
> remove inaccessible iova spaces in their address space's based platform device info.

The above is also related to another issue,
    how to specify IOMMU'able devices in DT.

As mentioned above, some IOVA mapping may be unique to some devices,
and the number of IOMMU'able device are quite many nowadays, a few
dozen in Tegra30 now. Basically they are seen as just normal platform
devices from CPU even if they belong to different busses in H/W. IOW, their
IOMMU'ability just depend on a platfrom bus from _S/W_ POV. Doing each
registration(create a map & attach device) in board files isn't so
nice. Currently we register them at "platform_device_add()" at once
with just a HACK(*1), but this could/should be done based on the info
passed from DT. For tegra, those parameter could be, "ASID" and
"address range"(start, size, alignment). For example in DT:

deviceA {
                      "start"     "size"   "align"
          iommu = <0x12340000 0x00400000 0x0000000>;   # exclusively specify "start" or "align"
          iommu = <0x00000000 0x00400000 0x0010000>;
          iommu = <0x12340000 0x00040000 0x12380000 0x00040000>; # "start", "size" could be repeated...
	  asid = 3; # if needed

or
          dma_range = <0x12340000 0x00400000 0x0000000>; # if iommu is considered as one implementation of dma.....
};

Is there any way to specify each IOMMU'able _platform device_ and
specify its map in DT?

The above ASID may be specific to Tegra, though. If we can specify the
above info in DT and the info is passed to kernel, some platform
common code would register them as IOMMU'able device automatically. It
would be really covenient if this is done in platform_device/IOMMU
common code. If the above attribute is implemented specific to
Tegra/platform, we have to call attach_device quite many times
somewhere in device initializations.

Any comment would be really appreciated.

*1:
>From dd4dd6532d705c7bba0914b54c819d8d735c2fad Mon Sep 17 00:00:00 2001
From: Hiroshi Doyu <hdoyu@nvidia.com>
Date: Thu, 22 Mar 2012 16:06:27 +0200
Subject: [RFC 1/1] platform: IOMMU'able platform_device w/
 PLATFORM_ENABLE_IOMMU

Introduced a new kernel config option, PLATFORM_ENABLE_IOMMU. With
this, all platform devices can be converted to be IOMMU'able if
platform_bus has non-null dma_iommu_map, where H/Ws always see its IO
virtual address and virt_to_phys() doesn't work from H/W POV.

Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
---
 arch/arm/mm/dma-mapping.c |    7 +++++++
 drivers/base/Kconfig      |    4 ++++
 drivers/base/platform.c   |   17 +++++++++++++++--
 drivers/iommu/Kconfig     |    2 +-
 include/linux/device.h    |    5 ++++-
 5 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index 242289f..28ca7c2 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -1899,6 +1899,13 @@ arm_iommu_create_mapping(struct bus_type *bus, dma_addr_t base, size_t size,
 	mapping->order = order;
 	spin_lock_init(&mapping->lock);

+#ifdef CONFIG_PLATFORM_ENABLE_IOMMU
+	if (WARN_ON(bus->map))
+		goto err3;
+
+	bus->map = mapping;
+#endif
+
 	mapping->domain = iommu_domain_alloc(bus);
 	if (!mapping->domain)
 		goto err3;
diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
index 3df339c..0f45311 100644
--- a/drivers/base/Kconfig
+++ b/drivers/base/Kconfig
@@ -308,4 +308,8 @@ config CMA_AREAS

 endif

+config PLATFORM_ENABLE_IOMMU
+        bool "Make platform devices iommuable"
+	depends on IOMMU_API
+
 endmenu
diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index a1a7225..9eae3be 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -21,6 +21,8 @@
 #include <linux/slab.h>
 #include <linux/pm_runtime.h>

+#include <asm/dma-iommu.h>
+
 #include "base.h"

 #define to_platform_driver(drv)	(container_of((drv), struct platform_driver, \
@@ -305,8 +307,19 @@ int platform_device_add(struct platform_device *pdev)
 		 dev_name(&pdev->dev), dev_name(pdev->dev.parent));

 	ret = device_add(&pdev->dev);
-	if (ret == 0)
-		return ret;
+	if (ret)
+		goto failed;
+
+#ifdef CONFIG_PLATFORM_ENABLE_IOMMU
+	if (platform_bus_type.map && !pdev->dev.archdata.mapping) {
+		ret = arm_iommu_attach_device(&pdev->dev,
+					      platform_bus_type.map);
+		if (ret)
+			goto failed;
+	}
+#endif
+
+	return 0;

  failed:
 	while (--i >= 0) {
diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index b736809..8b7eca1 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -164,7 +164,7 @@ config TEGRA_IOMMU_SMMU

 config TEGRA_IOMMU_SMMU_LINEAR
 	bool "Physical RAM IOVA Liner Mapping Support"
-	depends on TEGRA_IOMMU_SMMU
+	depends on TEGRA_IOMMU_SMMU && !PLATFORM_ENABLE_IOMMU
 	default y
 	help
 	  Enables support for linear mapping between physical address
diff --git a/include/linux/device.h b/include/linux/device.h
index e339929..3dcb501 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -35,6 +35,7 @@ struct subsys_private;
 struct bus_type;
 struct device_node;
 struct iommu_ops;
+struct dma_iommu_mapping;

 struct bus_attribute {
 	struct attribute	attr;
@@ -106,7 +107,9 @@ struct bus_type {
 	const struct dev_pm_ops *pm;

 	struct iommu_ops *iommu_ops;
-
+#ifdef CONFIG_PLATFORM_ENABLE_IOMMU
+	struct dma_iommu_mapping *map;
+#endif
 	struct subsys_private *p;
 };
