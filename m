Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757373Ab0G2TEq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 15:04:46 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:48722 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757238Ab0G2TEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 15:04:43 -0400
Subject: [PATCH] of/address: Clean up function declarations
To: sfr@canb.auug.org.au, monstr@monstr.eu, microblaze-uclinux@itee.uq.edu.au,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, benh@kernel.crashing.org,
        sparclinux@vger.kernel.org, davem@davemloft.net
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 29 Jul 2010 13:04:40 -0600
Message-ID: <20100729190429.28739.21521.stgit@angua>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves the declaration of of_get_address(), of_get_pci_address(),
and of_pci_address_to_resource() out of arch code and into the common
linux/of_address header file.

This patch also fixes some of the asm/prom.h ordering issues.  It still
includes some header files that it ideally shouldn't be, but at least the
ordering is consistent now so that of_* overrides work.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 arch/microblaze/include/asm/prom.h        |   33 +++++++-------------
 arch/powerpc/include/asm/prom.h           |   49 +++++++----------------------
 arch/powerpc/kernel/legacy_serial.c       |    1 +
 arch/powerpc/kernel/pci-common.c          |    1 +
 arch/powerpc/platforms/52xx/lite5200.c    |    1 +
 arch/powerpc/platforms/amigaone/setup.c   |    3 +-
 arch/powerpc/platforms/iseries/mf.c       |    1 +
 arch/powerpc/platforms/powermac/feature.c |    2 +
 drivers/char/bsr.c                        |    1 +
 drivers/net/fsl_pq_mdio.c                 |    1 +
 drivers/net/xilinx_emaclite.c             |    2 +
 drivers/serial/uartlite.c                 |    1 +
 drivers/spi/mpc512x_psc_spi.c             |    1 +
 drivers/spi/mpc52xx_psc_spi.c             |    1 +
 drivers/spi/xilinx_spi_of.c               |    1 +
 drivers/usb/gadget/fsl_qe_udc.c           |    1 +
 drivers/video/controlfb.c                 |    2 +
 drivers/video/offb.c                      |    3 +-
 include/linux/of_address.h                |   32 +++++++++++++++++++
 19 files changed, 74 insertions(+), 63 deletions(-)

diff --git a/arch/microblaze/include/asm/prom.h b/arch/microblaze/include/asm/prom.h
index cb9c3dd..101fa09 100644
--- a/arch/microblaze/include/asm/prom.h
+++ b/arch/microblaze/include/asm/prom.h
@@ -20,11 +20,6 @@
 #ifndef __ASSEMBLY__
 
 #include <linux/types.h>
-#include <linux/of_address.h>
-#include <linux/of_irq.h>
-#include <linux/of_fdt.h>
-#include <linux/proc_fs.h>
-#include <linux/platform_device.h>
 #include <asm/irq.h>
 #include <asm/atomic.h>
 
@@ -52,25 +47,9 @@ extern void pci_create_OF_bus_map(void);
  * OF address retreival & translation
  */
 
-/* Extract an address from a device, returns the region size and
- * the address space flags too. The PCI version uses a BAR number
- * instead of an absolute index
- */
-extern const u32 *of_get_address(struct device_node *dev, int index,
-			u64 *size, unsigned int *flags);
-extern const u32 *of_get_pci_address(struct device_node *dev, int bar_no,
-			u64 *size, unsigned int *flags);
-
-extern int of_pci_address_to_resource(struct device_node *dev, int bar,
-				struct resource *r);
-
 #ifdef CONFIG_PCI
 extern unsigned long pci_address_to_pio(phys_addr_t address);
-#else
-static inline unsigned long pci_address_to_pio(phys_addr_t address)
-{
-	return (unsigned long)-1;
-}
+#define pci_address_to_pio pci_address_to_pio
 #endif	/* CONFIG_PCI */
 
 /* Parse the ibm,dma-window property of an OF node into the busno, phys and
@@ -99,8 +78,18 @@ extern const void *of_get_mac_address(struct device_node *np);
  * resolving using the OF tree walking.
  */
 struct pci_dev;
+struct of_irq;
 extern int of_irq_map_pci(struct pci_dev *pdev, struct of_irq *out_irq);
 
 #endif /* __ASSEMBLY__ */
 #endif /* __KERNEL__ */
+
+/* These includes are put at the bottom because they may contain things
+ * that are overridden by this file.  Ideally they shouldn't be included
+ * by this file, but there are a bunch of .c files that currently depend
+ * on it.  Eventually they will be cleaned up. */
+#include <linux/of_fdt.h>
+#include <linux/of_irq.h>
+#include <linux/platform_device.h>
+
 #endif /* _ASM_MICROBLAZE_PROM_H */
diff --git a/arch/powerpc/include/asm/prom.h b/arch/powerpc/include/asm/prom.h
index 55bccc0..ae26f2e 100644
--- a/arch/powerpc/include/asm/prom.h
+++ b/arch/powerpc/include/asm/prom.h
@@ -17,11 +17,6 @@
  * 2 of the License, or (at your option) any later version.
  */
 #include <linux/types.h>
-#include <linux/of_fdt.h>
-#include <linux/of_address.h>
-#include <linux/of_irq.h>
-#include <linux/proc_fs.h>
-#include <linux/platform_device.h>
 #include <asm/irq.h>
 #include <asm/atomic.h>
 
@@ -49,41 +44,9 @@ extern void pci_create_OF_bus_map(void);
 extern u64 of_translate_dma_address(struct device_node *dev,
 				    const u32 *in_addr);
 
-/* Extract an address from a device, returns the region size and
- * the address space flags too. The PCI version uses a BAR number
- * instead of an absolute index
- */
-extern const u32 *of_get_address(struct device_node *dev, int index,
-			   u64 *size, unsigned int *flags);
-#ifdef CONFIG_PCI
-extern const u32 *of_get_pci_address(struct device_node *dev, int bar_no,
-			       u64 *size, unsigned int *flags);
-#else
-static inline const u32 *of_get_pci_address(struct device_node *dev,
-		int bar_no, u64 *size, unsigned int *flags)
-{
-	return NULL;
-}
-#endif /* CONFIG_PCI */
-
-#ifdef CONFIG_PCI
-extern int of_pci_address_to_resource(struct device_node *dev, int bar,
-				      struct resource *r);
-#else
-static inline int of_pci_address_to_resource(struct device_node *dev, int bar,
-		struct resource *r)
-{
-	return -ENOSYS;
-}
-#endif /* CONFIG_PCI */
-
 #ifdef CONFIG_PCI
 extern unsigned long pci_address_to_pio(phys_addr_t address);
-#else
-static inline unsigned long pci_address_to_pio(phys_addr_t address)
-{
-	return (unsigned long)-1;
-}
+#define pci_address_to_pio pci_address_to_pio
 #endif	/* CONFIG_PCI */
 
 /* Parse the ibm,dma-window property of an OF node into the busno, phys and
@@ -122,9 +85,19 @@ static inline int of_node_to_nid(struct device_node *device) { return 0; }
  * resolving using the OF tree walking.
  */
 struct pci_dev;
+struct of_irq;
 extern int of_irq_map_pci(struct pci_dev *pdev, struct of_irq *out_irq);
 
 extern void of_instantiate_rtc(void);
 
+/* These includes are put at the bottom because they may contain things
+ * that are overridden by this file.  Ideally they shouldn't be included
+ * by this file, but there are a bunch of .c files that currently depend
+ * on it.  Eventually they will be cleaned up. */
+#include <linux/of_fdt.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <linux/platform_device.h>
+
 #endif /* __KERNEL__ */
 #endif /* _POWERPC_PROM_H */
diff --git a/arch/powerpc/kernel/legacy_serial.c b/arch/powerpc/kernel/legacy_serial.c
index 035ada5..c1fd0f9 100644
--- a/arch/powerpc/kernel/legacy_serial.c
+++ b/arch/powerpc/kernel/legacy_serial.c
@@ -4,6 +4,7 @@
 #include <linux/serial_core.h>
 #include <linux/console.h>
 #include <linux/pci.h>
+#include <linux/of_address.h>
 #include <linux/of_device.h>
 #include <asm/io.h>
 #include <asm/mmu.h>
diff --git a/arch/powerpc/kernel/pci-common.c b/arch/powerpc/kernel/pci-common.c
index 5b38f6a..9021c4a 100644
--- a/arch/powerpc/kernel/pci-common.c
+++ b/arch/powerpc/kernel/pci-common.c
@@ -21,6 +21,7 @@
 #include <linux/string.h>
 #include <linux/init.h>
 #include <linux/bootmem.h>
+#include <linux/of_address.h>
 #include <linux/mm.h>
 #include <linux/list.h>
 #include <linux/syscalls.h>
diff --git a/arch/powerpc/platforms/52xx/lite5200.c b/arch/powerpc/platforms/52xx/lite5200.c
index 6d584f4..de55bc0 100644
--- a/arch/powerpc/platforms/52xx/lite5200.c
+++ b/arch/powerpc/platforms/52xx/lite5200.c
@@ -18,6 +18,7 @@
 #include <linux/init.h>
 #include <linux/pci.h>
 #include <linux/of.h>
+#include <linux/of_address.h>
 #include <linux/root_dev.h>
 #include <linux/initrd.h>
 #include <asm/time.h>
diff --git a/arch/powerpc/platforms/amigaone/setup.c b/arch/powerpc/platforms/amigaone/setup.c
index fb4eb0d..03aabc0 100644
--- a/arch/powerpc/platforms/amigaone/setup.c
+++ b/arch/powerpc/platforms/amigaone/setup.c
@@ -13,12 +13,13 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
 #include <linux/seq_file.h>
 #include <generated/utsrelease.h>
 
 #include <asm/machdep.h>
 #include <asm/cputable.h>
-#include <asm/prom.h>
 #include <asm/pci-bridge.h>
 #include <asm/i8259.h>
 #include <asm/time.h>
diff --git a/arch/powerpc/platforms/iseries/mf.c b/arch/powerpc/platforms/iseries/mf.c
index d2c1d49..33e5fc7 100644
--- a/arch/powerpc/platforms/iseries/mf.c
+++ b/arch/powerpc/platforms/iseries/mf.c
@@ -30,6 +30,7 @@
 #include <linux/init.h>
 #include <linux/completion.h>
 #include <linux/delay.h>
+#include <linux/proc_fs.h>
 #include <linux/dma-mapping.h>
 #include <linux/bcd.h>
 #include <linux/rtc.h>
diff --git a/arch/powerpc/platforms/powermac/feature.c b/arch/powerpc/platforms/powermac/feature.c
index 9e1b9fd..75eec03 100644
--- a/arch/powerpc/platforms/powermac/feature.c
+++ b/arch/powerpc/platforms/powermac/feature.c
@@ -21,6 +21,8 @@
 #include <linux/delay.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
 #include <linux/spinlock.h>
 #include <linux/adb.h>
 #include <linux/pmu.h>
diff --git a/drivers/char/bsr.c b/drivers/char/bsr.c
index 89d871e..9191713 100644
--- a/drivers/char/bsr.c
+++ b/drivers/char/bsr.c
@@ -23,6 +23,7 @@
 #include <linux/of.h>
 #include <linux/of_device.h>
 #include <linux/of_platform.h>
+#include <linux/fs.h>
 #include <linux/module.h>
 #include <linux/cdev.h>
 #include <linux/list.h>
diff --git a/drivers/net/fsl_pq_mdio.c b/drivers/net/fsl_pq_mdio.c
index b4c41d7..f53f850 100644
--- a/drivers/net/fsl_pq_mdio.c
+++ b/drivers/net/fsl_pq_mdio.c
@@ -35,6 +35,7 @@
 #include <linux/mii.h>
 #include <linux/phy.h>
 #include <linux/of.h>
+#include <linux/of_address.h>
 #include <linux/of_mdio.h>
 #include <linux/of_platform.h>
 
diff --git a/drivers/net/xilinx_emaclite.c b/drivers/net/xilinx_emaclite.c
index d04c5b2..b2c2f39 100644
--- a/drivers/net/xilinx_emaclite.c
+++ b/drivers/net/xilinx_emaclite.c
@@ -20,7 +20,7 @@
 #include <linux/skbuff.h>
 #include <linux/io.h>
 #include <linux/slab.h>
-
+#include <linux/of_address.h>
 #include <linux/of_device.h>
 #include <linux/of_platform.h>
 #include <linux/of_mdio.h>
diff --git a/drivers/serial/uartlite.c b/drivers/serial/uartlite.c
index 8acccd5..caf085d 100644
--- a/drivers/serial/uartlite.c
+++ b/drivers/serial/uartlite.c
@@ -21,6 +21,7 @@
 #include <asm/io.h>
 #if defined(CONFIG_OF) && (defined(CONFIG_PPC32) || defined(CONFIG_MICROBLAZE))
 #include <linux/of.h>
+#include <linux/of_address.h>
 #include <linux/of_device.h>
 #include <linux/of_platform.h>
 
diff --git a/drivers/spi/mpc512x_psc_spi.c b/drivers/spi/mpc512x_psc_spi.c
index 1bb4315..10baac3 100644
--- a/drivers/spi/mpc512x_psc_spi.c
+++ b/drivers/spi/mpc512x_psc_spi.c
@@ -19,6 +19,7 @@
 #include <linux/init.h>
 #include <linux/errno.h>
 #include <linux/interrupt.h>
+#include <linux/of_address.h>
 #include <linux/of_platform.h>
 #include <linux/workqueue.h>
 #include <linux/completion.h>
diff --git a/drivers/spi/mpc52xx_psc_spi.c b/drivers/spi/mpc52xx_psc_spi.c
index bd81ff9..66d1701 100644
--- a/drivers/spi/mpc52xx_psc_spi.c
+++ b/drivers/spi/mpc52xx_psc_spi.c
@@ -16,6 +16,7 @@
 #include <linux/types.h>
 #include <linux/errno.h>
 #include <linux/interrupt.h>
+#include <linux/of_address.h>
 #include <linux/of_platform.h>
 #include <linux/workqueue.h>
 #include <linux/completion.h>
diff --git a/drivers/spi/xilinx_spi_of.c b/drivers/spi/xilinx_spi_of.c
index 87cda09..f53d3f6 100644
--- a/drivers/spi/xilinx_spi_of.c
+++ b/drivers/spi/xilinx_spi_of.c
@@ -29,6 +29,7 @@
 #include <linux/io.h>
 #include <linux/slab.h>
 
+#include <linux/of_address.h>
 #include <linux/of_platform.h>
 #include <linux/of_device.h>
 #include <linux/of_spi.h>
diff --git a/drivers/usb/gadget/fsl_qe_udc.c b/drivers/usb/gadget/fsl_qe_udc.c
index 82506ca..9648b75 100644
--- a/drivers/usb/gadget/fsl_qe_udc.c
+++ b/drivers/usb/gadget/fsl_qe_udc.c
@@ -32,6 +32,7 @@
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/moduleparam.h>
+#include <linux/of_address.h>
 #include <linux/of_platform.h>
 #include <linux/dma-mapping.h>
 #include <linux/usb/ch9.h>
diff --git a/drivers/video/controlfb.c b/drivers/video/controlfb.c
index 49fcbe8..c225dcc 100644
--- a/drivers/video/controlfb.c
+++ b/drivers/video/controlfb.c
@@ -40,6 +40,8 @@
 #include <linux/vmalloc.h>
 #include <linux/delay.h>
 #include <linux/interrupt.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
 #include <linux/fb.h>
 #include <linux/init.h>
 #include <linux/pci.h>
diff --git a/drivers/video/offb.c b/drivers/video/offb.c
index 46dda7d..cb163a5 100644
--- a/drivers/video/offb.c
+++ b/drivers/video/offb.c
@@ -19,13 +19,14 @@
 #include <linux/mm.h>
 #include <linux/vmalloc.h>
 #include <linux/delay.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
 #include <linux/interrupt.h>
 #include <linux/fb.h>
 #include <linux/init.h>
 #include <linux/ioport.h>
 #include <linux/pci.h>
 #include <asm/io.h>
-#include <asm/prom.h>
 
 #ifdef CONFIG_PPC64
 #include <asm/pci-bridge.h>
diff --git a/include/linux/of_address.h b/include/linux/of_address.h
index cc567df..8aea06f 100644
--- a/include/linux/of_address.h
+++ b/include/linux/of_address.h
@@ -8,5 +8,37 @@ extern int of_address_to_resource(struct device_node *dev, int index,
 				  struct resource *r);
 extern void __iomem *of_iomap(struct device_node *device, int index);
 
+/* Extract an address from a device, returns the region size and
+ * the address space flags too. The PCI version uses a BAR number
+ * instead of an absolute index
+ */
+extern const u32 *of_get_address(struct device_node *dev, int index,
+			   u64 *size, unsigned int *flags);
+
+#ifndef pci_address_to_pio
+static inline unsigned long pci_address_to_pio(phys_addr_t addr) { return -1; }
+#define pci_address_to_pio pci_address_to_pio
+#endif
+
+#ifdef CONFIG_PCI
+extern const u32 *of_get_pci_address(struct device_node *dev, int bar_no,
+			       u64 *size, unsigned int *flags);
+extern int of_pci_address_to_resource(struct device_node *dev, int bar,
+				      struct resource *r);
+#else /* CONFIG_PCI */
+static inline int of_pci_address_to_resource(struct device_node *dev, int bar,
+				             struct resource *r)
+{
+	return -ENOSYS;
+}
+
+static inline const u32 *of_get_pci_address(struct device_node *dev,
+		int bar_no, u64 *size, unsigned int *flags)
+{
+	return NULL;
+}
+#endif /* CONFIG_PCI */
+
+
 #endif /* __OF_ADDRESS_H */
 

