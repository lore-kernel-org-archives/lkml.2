Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983Ab0KWM5M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 07:57:12 -0500
Received: from denmail01-v4020.amcc.com ([192.195.68.30]:56712 "EHLO
	denmail01.apm.COM" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753931Ab0KWM5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 07:57:11 -0500
Date: Tue, 23 Nov 2010 18:26:53 +0530
From: Rupjyoti Sarmah <rsarmah@amcc.com>
Message-Id: <201011231256.oANCur3N016433@amcc.com>
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1] ppc44x:PHY fixup for USB on canyonlands board
Cc: rsarmah@apm.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fix is a reset for USB PHY that requires some amount of time for power to be stable on Canyonlands.

Signed-off-by: Rupjyoti Sarmah <rsarmah@apm.com>
---
 arch/powerpc/boot/dts/canyonlands.dts      |   13 +++
 arch/powerpc/platforms/44x/44x.h           |    5 +
 arch/powerpc/platforms/44x/Makefile        |    1 +
 arch/powerpc/platforms/44x/canyonlands.c   |  122 ++++++++++++++++++++++++++++
 arch/powerpc/platforms/44x/ppc44x_simple.c |    1 -
 5 files changed, 141 insertions(+), 1 deletions(-)
 create mode 100644 arch/powerpc/platforms/44x/canyonlands.c

diff --git a/arch/powerpc/boot/dts/canyonlands.dts b/arch/powerpc/boot/dts/canyonlands.dts
index a303703..a9f7538 100644
--- a/arch/powerpc/boot/dts/canyonlands.dts
+++ b/arch/powerpc/boot/dts/canyonlands.dts
@@ -224,6 +224,13 @@
 					};
 				};
 
+				cpld@2,0 {
+					#address-cells = <1>;
+					#size-cells = <1>;
+					compatible = "apm,ppc460ex-bcsr";
+					reg = <2 0x0 0x9>;
+				};
+
 				ndfc@3,0 {
 					compatible = "ibm,ndfc";
 					reg = <0x00000003 0x00000000 0x00002000>;
@@ -320,6 +327,12 @@
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
index dbc4d2b..bc2ab7a 100644
--- a/arch/powerpc/platforms/44x/44x.h
+++ b/arch/powerpc/platforms/44x/44x.h
@@ -4,4 +4,9 @@
 extern u8 as1_readb(volatile u8 __iomem  *addr);
 extern void as1_writeb(u8 data, volatile u8 __iomem *addr);
 
+#define BCSR_USB_EN	0x11
+#define GPIO0_OSRH	0xC
+#define GPIO0_TSRH	0x14
+#define GPIO0_ISR1H	0x34
+
 #endif /* __POWERPC_PLATFORMS_44X_44X_H */
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
index 0000000..f13b62f
--- /dev/null
+++ b/arch/powerpc/platforms/44x/canyonlands.c
@@ -0,0 +1,122 @@
+/*
+ * This contain platform specific code for Canyonalnds board based on
+ * APM ppc44x series of processors.
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
+#include "44x.h"
+
+static __initdata struct of_device_id ppc44x_of_bus[] = {
+	{ .compatible = "ibm,plb4", },
+	{ .compatible = "ibm,opb", },
+	{ .compatible = "ibm,ebc", },
+	{ .compatible = "simple-bus", },
+	{},
+};
+
+static int __init ppc44x_device_probe(void)
+{
+	of_platform_bus_probe(NULL, ppc44x_of_bus, NULL);
+
+	return 0;
+}
+machine_device_initcall(canyonlands, ppc44x_device_probe);
+
+/* Using this code only for the Canyonlands board.  */
+
+static int __init ppc44x_probe(void)
+{
+	unsigned long root = of_get_flat_dt_root();
+		if (of_flat_dt_is_compatible(root, "amcc,canyonlands")) {
+			ppc_pci_set_flags(PPC_PCI_REASSIGN_ALL_RSRC);
+			return 1;
+		}
+	return 0;
+}
+
+/* PHY fixup code on Canyonlands kit. */
+
+static int __init ppc460ex_canyonlands_fixup(void)
+{
+	u8 __iomem *bcsr ;
+	void __iomem  *vaddr;
+	struct device_node *np;
+	u32 val ;
+
+	np = of_find_compatible_node(NULL, NULL, "apm,ppc460ex-bcsr");
+	if (!np) {
+		printk(KERN_ERR "failed did not find apm, ppc460ex bcsr node\n");
+		return -ENODEV;
+	}
+
+	bcsr = of_iomap(np, 0);
+	of_node_put(np);
+
+	if (!bcsr) {
+		printk(KERN_CRIT "Could not remap bcsr\n");
+		return -ENODEV;
+	}
+
+	np = of_find_compatible_node(NULL, NULL, "ibm,ppc4xx-gpio");
+	vaddr = of_iomap(np, 0);
+	if (!vaddr) {
+		printk(KERN_CRIT "Could not get gpio node address\n");
+		return -ENODEV;
+	}
+
+	setbits8(&bcsr[7], BCSR_USB_EN);
+	udelay(100000);
+
+	clrbits8(&bcsr[7], BCSR_USB_EN);
+	udelay(100000);
+
+	/* configure gpio16 and gpio19 as alternate1 */
+
+	/* GPIO0_ISR1H for alternate 1 settings */
+	val = in_be32(vaddr + GPIO0_ISR1H);
+	out_be32((vaddr + GPIO0_ISR1H), val | 0x4200000);
+
+	/* GPIO0_OSRH for alternate 1 settings */
+	val = in_be32(vaddr + GPIO0_OSRH);
+	out_be32((vaddr + GPIO0_OSRH), val | 0x42000000);
+
+	/* GPIO0_TSRH for alternate 1 settings */
+	val = in_be32(vaddr + GPIO0_TSRH);
+	out_be32((vaddr + GPIO0_TSRH), val | 0x42000000);
+	of_node_put(np);
+	return 0;
+}
+machine_device_initcall(canyonlands, ppc460ex_canyonlands_fixup);
+define_machine(canyonlands) {
+	.name = "Canyonlands",
+	.probe = ppc44x_probe,
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

