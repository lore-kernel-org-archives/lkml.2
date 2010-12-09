Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055Ab0LIEYS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 23:24:18 -0500
Received: from denmail01-v4020.amcc.com ([192.195.68.30]:42630 "EHLO
	denmail01.apm.COM" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752168Ab0LIEYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 23:24:16 -0500
Date: Thu, 9 Dec 2010 09:54:01 +0530
From: Rupjyoti Sarmah <rsarmah@amcc.com>
Message-Id: <201012090424.oB94O1DV006463@amcc.com>
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5] ppc44x:PHY fixup for USB on canyonlands board
Cc: rsarmah@apm.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fix is a reset for USB PHY that requires some amount of time for power to be stable on Canyonlands.

Signed-off-by: Rupjyoti Sarmah <rsarmah@apm.com>
---
changes from previous version:
-- dts node correction, removed the address and size parameters
-- Kconfig file updated removing dependency on PPC44x_SIMPLE
-- 44x prefixes in the function names changed
-- Error paths updated in canyonlands.c

 arch/powerpc/boot/dts/canyonlands.dts      |   11 +++
 arch/powerpc/platforms/44x/44x.h           |    4 +
 arch/powerpc/platforms/44x/Kconfig         |    1 -
 arch/powerpc/platforms/44x/Makefile        |    1 +
 arch/powerpc/platforms/44x/canyonlands.c   |  125 ++++++++++++++++++++++++++++
 arch/powerpc/platforms/44x/ppc44x_simple.c |    1 -
 6 files changed, 141 insertions(+), 2 deletions(-)
 create mode 100644 arch/powerpc/platforms/44x/canyonlands.c

diff --git a/arch/powerpc/boot/dts/canyonlands.dts b/arch/powerpc/boot/dts/canyonlands.dts
index a303703..8ff1f3f 100644
--- a/arch/powerpc/boot/dts/canyonlands.dts
+++ b/arch/powerpc/boot/dts/canyonlands.dts
@@ -224,6 +224,11 @@
 					};
 				};
 
+				cpld@2,0 {
+					compatible = "amcc,ppc460ex-bcsr";
+					reg = <2 0x0 0x9>;
+				};
+
 				ndfc@3,0 {
 					compatible = "ibm,ndfc";
 					reg = <0x00000003 0x00000000 0x00002000>;
@@ -320,6 +325,12 @@
 				interrupts = <0x3 0x4>;
 			};
 
+			GPIO0: gpio@ef600b00 {
+				compatible = "ibm,ppc4xx-gpio";
+				reg = <0xef600b00 0x00000048>;
+				gpio-controller;
+			};
+
 			ZMII0: emac-zmii@ef600d00 {
 				compatible = "ibm,zmii-460ex", "ibm,zmii";
 				reg = <0xef600d00 0x0000000c>;
diff --git a/arch/powerpc/platforms/44x/44x.h b/arch/powerpc/platforms/44x/44x.h
index dbc4d2b..63f703e 100644
--- a/arch/powerpc/platforms/44x/44x.h
+++ b/arch/powerpc/platforms/44x/44x.h
@@ -4,4 +4,8 @@
 extern u8 as1_readb(volatile u8 __iomem  *addr);
 extern void as1_writeb(u8 data, volatile u8 __iomem *addr);
 
+#define GPIO0_OSRH	0xC
+#define GPIO0_TSRH	0x14
+#define GPIO0_ISR1H	0x34
+
 #endif /* __POWERPC_PLATFORMS_44X_44X_H */
diff --git a/arch/powerpc/platforms/44x/Kconfig b/arch/powerpc/platforms/44x/Kconfig
index 0f979c5..f485fc5 100644
--- a/arch/powerpc/platforms/44x/Kconfig
+++ b/arch/powerpc/platforms/44x/Kconfig
@@ -115,7 +115,6 @@ config CANYONLANDS
 	bool "Canyonlands"
 	depends on 44x
 	default n
-	select PPC44x_SIMPLE
 	select 460EX
 	select PCI
 	select PPC4xx_PCI_EXPRESS
diff --git a/arch/powerpc/platforms/44x/Makefile b/arch/powerpc/platforms/44x/Makefile
index 82ff326..6854e73 100644
--- a/arch/powerpc/platforms/44x/Makefile
+++ b/arch/powerpc/platforms/44x/Makefile
@@ -6,3 +6,4 @@ obj-$(CONFIG_WARP)	+= warp.o
 obj-$(CONFIG_XILINX_VIRTEX_5_FXT) += virtex.o
 obj-$(CONFIG_XILINX_ML510) += virtex_ml510.o
 obj-$(CONFIG_ISS4xx)	+= iss4xx.o
+obj-$(CONFIG_CANYONLANDS)+= canyonlands.o
diff --git a/arch/powerpc/platforms/44x/canyonlands.c b/arch/powerpc/platforms/44x/canyonlands.c
new file mode 100644
index 0000000..9639709
--- /dev/null
+++ b/arch/powerpc/platforms/44x/canyonlands.c
@@ -0,0 +1,125 @@
+/*
+ * This contain platform specific code for APM PPC460EX based Canyonlands
+ * board.
+ *
+ * Copyright (c) 2010, Applied Micro Circuits Corporation
+ * Author: Rupjyoti Sarmah <rsarmah@apm.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of
+ * the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
+ * MA 02111-1307 USA
+ *
+ */
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <asm/pci-bridge.h>
+#include <asm/ppc4xx.h>
+#include <asm/udbg.h>
+#include <asm/uic.h>
+#include <linux/of_platform.h>
+#include <linux/delay.h>
+#include "44x.h"
+
+#define BCSR_USB_EN	0x11
+
+static __initdata struct of_device_id ppc460ex_of_bus[] = {
+	{ .compatible = "ibm,plb4", },
+	{ .compatible = "ibm,opb", },
+	{ .compatible = "ibm,ebc", },
+	{ .compatible = "simple-bus", },
+	{},
+};
+
+static int __init ppc460ex_device_probe(void)
+{
+	of_platform_bus_probe(NULL, ppc460ex_of_bus, NULL);
+
+	return 0;
+}
+machine_device_initcall(canyonlands, ppc460ex_device_probe);
+
+/* Using this code only for the Canyonlands board.  */
+
+static int __init ppc460ex_probe(void)
+{
+	unsigned long root = of_get_flat_dt_root();
+	if (of_flat_dt_is_compatible(root, "amcc,canyonlands")) {
+		ppc_pci_set_flags(PPC_PCI_REASSIGN_ALL_RSRC);
+		return 1;
+		}
+	return 0;
+}
+
+/* USB PHY fixup code on Canyonlands kit. */
+
+static int __init ppc460ex_canyonlands_fixup(void)
+{
+	u8 __iomem *bcsr ;
+	void __iomem *vaddr;
+	struct device_node *np;
+	int ret = 0;
+
+	np = of_find_compatible_node(NULL, NULL, "amcc,ppc460ex-bcsr");
+	if (!np) {
+		printk(KERN_ERR "failed did not find amcc, ppc460ex bcsr node\n");
+		return -ENODEV;
+	}
+
+	bcsr = of_iomap(np, 0);
+	of_node_put(np);
+
+	if (!bcsr) {
+		printk(KERN_CRIT "Could not remap bcsr\n");
+		ret = -ENODEV;
+	}
+
+	np = of_find_compatible_node(NULL, NULL, "ibm,ppc4xx-gpio");
+	vaddr = of_iomap(np, 0);
+	if (!vaddr) {
+		printk(KERN_CRIT "Could not get gpio node address\n");
+		ret = -ENODEV;
+		goto err_bcsr;
+	}
+	/* Disable USB, through the BCSR7 bits */
+	setbits8(&bcsr[7], BCSR_USB_EN);
+
+	/* Wait for a while after reset */
+	msleep(100);
+
+	/* Enable USB here */
+	clrbits8(&bcsr[7], BCSR_USB_EN);
+
+	/*
+	 * Configure multiplexed gpio16 and gpio19 as alternate1 output
+	 * source after USB reset. In this configuration gpio16 will be
+	 * USB2HStop and gpio19 will be USB2DStop. For more details refer to
+	 * table 34-7 of PPC460EX user manual.
+	 */
+	setbits32((vaddr + GPIO0_OSRH), 0x42000000);
+	setbits32((vaddr + GPIO0_TSRH), 0x42000000);
+	of_node_put(np);
+err_bcsr:
+	iounmap(bcsr);
+	return ret;
+}
+machine_device_initcall(canyonlands, ppc460ex_canyonlands_fixup);
+define_machine(canyonlands) {
+	.name = "Canyonlands",
+	.probe = ppc460ex_probe,
+	.progress = udbg_progress,
+	.init_IRQ = uic_init_tree,
+	.get_irq = uic_get_irq,
+	.restart = ppc4xx_reset_system,
+	.calibrate_decr = generic_calibrate_decr,
+};
diff --git a/arch/powerpc/platforms/44x/ppc44x_simple.c b/arch/powerpc/platforms/44x/ppc44x_simple.c
index 7ddcba3..c81c19c 100644
--- a/arch/powerpc/platforms/44x/ppc44x_simple.c
+++ b/arch/powerpc/platforms/44x/ppc44x_simple.c
@@ -53,7 +53,6 @@ static char *board[] __initdata = {
 	"amcc,arches",
 	"amcc,bamboo",
 	"amcc,bluestone",
-	"amcc,canyonlands",
 	"amcc,glacier",
 	"ibm,ebony",
 	"amcc,eiger",
-- 
1.5.6.3

