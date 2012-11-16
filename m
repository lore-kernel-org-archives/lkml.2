Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508Ab2KPJpf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 04:45:35 -0500
Received: from mail.free-electrons.com ([88.190.12.23]:39836 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166Ab2KPJpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 04:45:32 -0500
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>, Russell King <linux@arm.linux.org.uk>,
        Rob Herring <rob.herring@calxeda.com>, Ben Dooks <ben-linux@fluff.org>,
        Ian Molton <ian.molton@codethink.co.uk>,
        Nicolas Pitre <nico@fluxnic.net>, Lior Amsalem <alior@marvell.com>,
        Maen Suleiman <maen@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        Shadi Ammouri <shadi@marvell.com>, Eran Ben-Avi <benavi@marvell.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>, Ike Pan <ike.pan@canonical.com>,
        Jani Monoses <jani.monoses@canonical.com>,
        Chris Van Hoof <vanhoof@canonical.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Leif Lindholm <leif.lindholm@arm.com>, Jon Masters <jcm@redhat.com>,
        David Marlin <dmarlin@redhat.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH V2 3/3] arm: mvebu: Add hardware I/O Coherency support
Date: Fri, 16 Nov 2012 10:45:00 +0100
Message-Id: <1353059100-24022-4-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353059100-24022-1-git-send-email-gregory.clement@free-electrons.com>
References: <1353059100-24022-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Armada 370 and XP come with an unit called coherency fabric. This unit
allows to use the Armada 370/XP as a nearly coherent architecture. The
coherency mechanism uses snoop filters to ensure the coherency between
caches, DRAM and devices. This mechanism needs a synchronization
barrier which guarantees that all the memory writes initiated by the
devices have reached their target and do not reside in intermediate
write buffers. That's why the architecture is not totally coherent and
we need to provide our own functions for some DMA operations.

Beside the use of the coherency fabric, the device units will have to
set the attribute flag of the decoding address window to select the
accurate coherency process for the memory transaction. This is done
each device driver programs the DRAM address windows. The value of the
attribute set by the driver is retrieved through the
orion_addr_map_cfg struct filled during the early initialization of
the platform.

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
Reviewed-by: Yehuda Yitschak <yehuday@marvell.com>
---
 .../devicetree/bindings/arm/coherency-fabric.txt   |    9 ++-
 arch/arm/boot/dts/armada-370-xp.dtsi               |    3 +-
 arch/arm/mach-mvebu/addr-map.c                     |    3 +
 arch/arm/mach-mvebu/coherency.c                    |   73 ++++++++++++++++++++
 4 files changed, 85 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/arm/coherency-fabric.txt b/Documentation/devicetree/bindings/arm/coherency-fabric.txt
index 2bfbf67..17d8cd1 100644
--- a/Documentation/devicetree/bindings/arm/coherency-fabric.txt
+++ b/Documentation/devicetree/bindings/arm/coherency-fabric.txt
@@ -5,12 +5,17 @@ Available on Marvell SOCs: Armada 370 and Armada XP
 Required properties:
 
 - compatible: "marvell,coherency-fabric"
-- reg: Should contain,coherency fabric registers location and length.
+
+- reg: Should contain coherency fabric registers location and
+  length. First pair for the coherency fabric registers, second pair
+  for the per-CPU fabric registers registers.
 
 Example:
 
 coherency-fabric@d0020200 {
 	compatible = "marvell,coherency-fabric";
-	reg = <0xd0020200 0xb0>;
+	reg = <0xd0020200 0xb0>,
+		<0xd0021810 0x1c>;
+
 };
 
diff --git a/arch/arm/boot/dts/armada-370-xp.dtsi b/arch/arm/boot/dts/armada-370-xp.dtsi
index b0d075b..98a6b26 100644
--- a/arch/arm/boot/dts/armada-370-xp.dtsi
+++ b/arch/arm/boot/dts/armada-370-xp.dtsi
@@ -38,7 +38,8 @@
 
 	coherency-fabric@d0020200 {
 		compatible = "marvell,coherency-fabric";
-		reg = <0xd0020200 0xb0>;
+		reg = <0xd0020200 0xb0>,
+		      <0xd0021810 0x1c>;
 	};
 
 	soc {
diff --git a/arch/arm/mach-mvebu/addr-map.c b/arch/arm/mach-mvebu/addr-map.c
index fe454a4..595f6b7 100644
--- a/arch/arm/mach-mvebu/addr-map.c
+++ b/arch/arm/mach-mvebu/addr-map.c
@@ -108,6 +108,9 @@ static int __init armada_setup_cpu_mbus(void)
 
 	addr_map_cfg.bridge_virt_base = mbus_unit_addr_decoding_base;
 
+	if (of_find_compatible_node(NULL, NULL, "marvell,coherency-fabric"))
+		addr_map_cfg.hw_io_coherency = 1;
+
 	/*
 	 * Disable, clear and configure windows.
 	 */
diff --git a/arch/arm/mach-mvebu/coherency.c b/arch/arm/mach-mvebu/coherency.c
index 20a0ccc..153fcfa 100644
--- a/arch/arm/mach-mvebu/coherency.c
+++ b/arch/arm/mach-mvebu/coherency.c
@@ -22,6 +22,8 @@
 #include <linux/of_address.h>
 #include <linux/io.h>
 #include <linux/smp.h>
+#include <linux/dma-mapping.h>
+#include <linux/platform_device.h>
 #include <asm/smp_plat.h>
 #include "armada-370-xp.h"
 
@@ -32,11 +34,14 @@
  * value matching its virtual mapping
  */
 static void __iomem *coherency_base = ARMADA_370_XP_REGS_VIRT_BASE + 0x20200;
+static void __iomem *coherency_cpu_base;
 
 /* Coherency fabric registers */
 #define COHERENCY_FABRIC_CTL_OFFSET		   0x0
 #define COHERENCY_FABRIC_CFG_OFFSET		   0x4
 
+#define IO_SYNC_BARRIER_CTL_OFFSET		   0x0
+
 static struct of_device_id of_coherency_table[] = {
 	{.compatible = "marvell,coherency-fabric"},
 	{ /* end of list */ },
@@ -75,6 +80,70 @@ int set_cpu_coherent(unsigned int hw_cpu_id, int smp_group_id)
 	return 0;
 }
 
+static inline void mvebu_hwcc_sync_io_barrier(void)
+{
+	writel(0x1, coherency_cpu_base + IO_SYNC_BARRIER_CTL_OFFSET);
+	while (readl(coherency_cpu_base + IO_SYNC_BARRIER_CTL_OFFSET) & 0x1);
+}
+
+static dma_addr_t mvebu_hwcc_dma_map_page(struct device *dev, struct page *page,
+				  unsigned long offset, size_t size,
+				  enum dma_data_direction dir,
+				  struct dma_attrs *attrs)
+{
+	if (dir != DMA_TO_DEVICE)
+		mvebu_hwcc_sync_io_barrier();
+	return pfn_to_dma(dev, page_to_pfn(page)) + offset;
+}
+
+
+static void mvebu_hwcc_dma_unmap_page(struct device *dev, dma_addr_t dma_handle,
+			      size_t size, enum dma_data_direction dir,
+			      struct dma_attrs *attrs)
+{
+	if (dir != DMA_TO_DEVICE)
+		mvebu_hwcc_sync_io_barrier();
+}
+
+static void mvebu_hwcc_dma_sync(struct device *dev, dma_addr_t dma_handle,
+			size_t size, enum dma_data_direction dir)
+{
+	if (dir != DMA_TO_DEVICE)
+		mvebu_hwcc_sync_io_barrier();
+}
+
+static struct dma_map_ops mvebu_hwcc_dma_ops = {
+	.alloc			= arm_coherent_dma_alloc,
+	.free			= arm_coherent_dma_free,
+	.mmap			= arm_dma_mmap,
+	.unmap_page		= mvebu_hwcc_dma_unmap_page,
+	.get_sgtable		= arm_dma_get_sgtable,
+	.map_page		= mvebu_hwcc_dma_map_page,
+	.map_sg			= arm_dma_map_sg,
+	.unmap_sg		= arm_dma_unmap_sg,
+	.sync_single_for_cpu	= mvebu_hwcc_dma_sync,
+	.sync_single_for_device	= mvebu_hwcc_dma_sync,
+	.sync_sg_for_cpu	= arm_dma_sync_sg_for_cpu,
+	.sync_sg_for_device	= arm_dma_sync_sg_for_device,
+	.set_dma_mask		= arm_dma_set_mask,
+};
+
+static int mvebu_hwcc_platform_notifier(struct notifier_block *nb,
+				       unsigned long event, void *__dev)
+{
+	struct device *dev = __dev;
+
+	if (event != BUS_NOTIFY_ADD_DEVICE)
+		return NOTIFY_DONE;
+	set_dma_ops(dev, &mvebu_hwcc_dma_ops);
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block mvebu_hwcc_platform_nb = {
+	.notifier_call = mvebu_hwcc_platform_notifier,
+};
+
 int __init coherency_init(void)
 {
 	struct device_node *np;
@@ -83,6 +152,10 @@ int __init coherency_init(void)
 	if (np) {
 		pr_info("Initializing Coherency fabric\n");
 		coherency_base = of_iomap(np, 0);
+		coherency_cpu_base = of_iomap(np, 1);
+		set_cpu_coherent(cpu_logical_map(smp_processor_id()), 0);
+		bus_register_notifier(&platform_bus_type,
+					&mvebu_hwcc_platform_nb);
 	}
 
 	return 0;
-- 
1.7.9.5

