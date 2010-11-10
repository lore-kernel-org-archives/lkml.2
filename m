Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164Ab0KJOTa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 09:19:30 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:44645 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755816Ab0KJOT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 09:19:29 -0500
Date: Wed, 10 Nov 2010 09:19:14 -0500
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: Rupjyoti Sarmah <rsarmah@amcc.com>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, rsarmah@apm.com
Subject: Re: [PATCH] ppc44x:PHY fixup for USB on canyonlands board
Message-ID: <20101110141914.GC26193@zod.rchland.ibm.com>
References: <201011101137.oAABbFoc015547@amcc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201011101137.oAABbFoc015547@amcc.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 05:07:15PM +0530, Rupjyoti Sarmah wrote:
>This fix is a reset for USB PHY that requires some amount of time for power to be stable on Canyonlands.
>
>Signed-off-by: Rupjyoti Sarmah <rsarmah@apm.com>
>---
> arch/powerpc/boot/dts/canyonlands.dts     |   11 ++++
> arch/powerpc/platforms/44x/44x.h          |    5 ++
> arch/powerpc/platforms/44x/Kconfig        |    7 ++
> arch/powerpc/platforms/44x/Makefile       |    1 +
> arch/powerpc/platforms/44x/ppc44x_fixup.c |   90 +++++++++++++++++++++++++++++
> 5 files changed, 114 insertions(+), 0 deletions(-)
> create mode 100644 arch/powerpc/platforms/44x/ppc44x_fixup.c

Is this just for canyonlands?  If so, it's probably better off in a
caynonlands specific file, or a function that gets called in the common
platform file if the model matches canyonlands.  It seems a bit overkill
to introduce an entire new file and Kconfig option for this.

>
>diff --git a/arch/powerpc/boot/dts/canyonlands.dts b/arch/powerpc/boot/dts/canyonlands.dts
>index a303703..d6e9ba2 100644
>--- a/arch/powerpc/boot/dts/canyonlands.dts
>+++ b/arch/powerpc/boot/dts/canyonlands.dts
>@@ -171,6 +171,11 @@
> 				      0x5 0x4>;     /* AHBDMA */
> 		};
>
>+		CPLD: cpld@e1000000 {
>+			compatible = "apm, ppc460ex-bcsr";
>+			reg = <4 0xe1000000 0x9>;
>+		};

Normally we don't leave a space in compatible properties.

>+
> 		POB0: opb {
> 			compatible = "ibm,opb-460ex", "ibm,opb";
> 			#address-cells = <1>;
>@@ -320,6 +325,12 @@
> 				interrupts = <0x3 0x4>;
> 			};
>
>+			GPIO0: gpio@ef600b00 {
>+				compatible = "apm,ppc44x-gpio-base";
>+				reg = <0xef600b00 0x00000048>;
>+				gpio-controller;
>+			};

We already have "ibm,ppc4xx-gpio" as an established compatible field for
4xx GPIO.  As far as I know, this is not a different kind of GPIO
controller than what is found on the other boards, so we should stick
with the existing property.

>+
> 			ZMII0: emac-zmii@ef600d00 {
> 				compatible = "ibm,zmii-460ex", "ibm,zmii";
> 				reg = <0xef600d00 0x0000000c>;
>diff --git a/arch/powerpc/platforms/44x/44x.h b/arch/powerpc/platforms/44x/44x.h
>index dbc4d2b..bc2ab7a 100644
>--- a/arch/powerpc/platforms/44x/44x.h
>+++ b/arch/powerpc/platforms/44x/44x.h
>@@ -4,4 +4,9 @@
> extern u8 as1_readb(volatile u8 __iomem  *addr);
> extern void as1_writeb(u8 data, volatile u8 __iomem *addr);
>
>+#define BCSR_USB_EN	0x11
>+#define GPIO0_OSRH	0xC
>+#define GPIO0_TSRH	0x14
>+#define GPIO0_ISR1H	0x34
>+
> #endif /* __POWERPC_PLATFORMS_44X_44X_H */
>diff --git a/arch/powerpc/platforms/44x/Kconfig b/arch/powerpc/platforms/44x/Kconfig
>index 0f979c5..9ca4aaa 100644
>--- a/arch/powerpc/platforms/44x/Kconfig
>+++ b/arch/powerpc/platforms/44x/Kconfig
>@@ -117,12 +117,19 @@ config CANYONLANDS
> 	default n
> 	select PPC44x_SIMPLE
> 	select 460EX
>+	select 44X_FIXUP
> 	select PCI
> 	select PPC4xx_PCI_EXPRESS
> 	select IBM_NEW_EMAC_RGMII
> 	select IBM_NEW_EMAC_ZMII
> 	help
> 	  This option enables support for the AMCC PPC460EX evaluation board.
>+config 44X_FIXUP
>+	bool "4xx_fixup"
>+	depends on 44x
>+	default n
>+	help
>+	  This option enables supporting APM PPC4XX based evaluation board fixups.
>
> config GLACIER
> 	bool "Glacier"
>diff --git a/arch/powerpc/platforms/44x/Makefile b/arch/powerpc/platforms/44x/Makefile
>index 82ff326..d4bfb97 100644
>--- a/arch/powerpc/platforms/44x/Makefile
>+++ b/arch/powerpc/platforms/44x/Makefile
>@@ -1,6 +1,7 @@
> obj-$(CONFIG_44x)	:= misc_44x.o idle.o
> obj-$(CONFIG_PPC44x_SIMPLE) += ppc44x_simple.o
> obj-$(CONFIG_EBONY)	+= ebony.o
>+obj-$(CONFIG_44X_FIXUP) += ppc44x_fixup.o
> obj-$(CONFIG_SAM440EP) 	+= sam440ep.o
> obj-$(CONFIG_WARP)	+= warp.o
> obj-$(CONFIG_XILINX_VIRTEX_5_FXT) += virtex.o
>diff --git a/arch/powerpc/platforms/44x/ppc44x_fixup.c b/arch/powerpc/platforms/44x/ppc44x_fixup.c
>new file mode 100644
>index 0000000..4e254eb
>--- /dev/null
>+++ b/arch/powerpc/platforms/44x/ppc44x_fixup.c
>@@ -0,0 +1,90 @@
>+/*
>+ * This contain fixup code for Applied Micro ppc44x series of processors.
>+ *
>+ * Copyright (c) 2010, Applied Micro Circuits Corporation
>+ * Author: Rupjyoti Sarmah <rsarmah@apm.com>
>+ *
>+ * This program is free software; you can redistribute it and/or
>+ * modify it under the terms of the GNU General Public License as
>+ * published by the Free Software Foundation; either version 2 of
>+ * the License, or (at your option) any later version.
>+ *
>+ * This program is distributed in the hope that it will be useful,
>+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
>+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>+ * GNU General Public License for more details.
>+ *
>+ * You should have received a copy of the GNU General Public License
>+ * along with this program; if not, write to the Free Software
>+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
>+ * MA 02111-1307 USA
>+ *
>+ */
>+
>+#include <linux/kernel.h>
>+#include <linux/init.h>
>+#include <linux/io.h>
>+#include <linux/of.h>
>+#include "44x.h"
>+
>+/* PHY fixup code on Canyonlands kit. */
>+
>+static int __init ppc460ex_canyonlands_fixup(void)
>+{
>+	u8 __iomem *bcsr ;
>+	void __iomem  *vaddr;
>+	struct device_node *np;
>+	u32 val ;
>+
>+	np = of_find_compatible_node(NULL, NULL, "apm, ppc460ex-bcsr");
>+	if (!np) {
>+		printk(KERN_ERR "failed did not find apm, ppc460ex bcsr node\n");
>+		return -ENODEV;
>+		}

Nit: the indentation on that brace is off.

>+
>+	bcsr = of_iomap(np, 0);
>+	of_node_put(np);
>+
>+	if (!bcsr) {
>+		printk(KERN_CRIT "Could not remap bcsr\n");
>+		return -ENODEV;
>+	}
>+
>+	clrbits8(&bcsr[7], BCSR_USB_EN);
>+	udelay(100000);
>+
>+	setbits8(&bcsr[7], BCSR_USB_EN);
>+	udelay(100000);
>+
>+	clrbits8(&bcsr[7], BCSR_USB_EN);
>+	udelay(100000);
>+
>+	np = of_find_compatible_node(NULL, NULL, "apm,ppc44x-gpio-base");
>+
>+	/* configure multiplexed gpio16 and gpio19 */
>+
>+	vaddr = of_iomap(np, 0);
>+	if (!vaddr) {
>+		printk(KERN_CRIT "Could not get gpio node address\n");
>+		return -ENODEV;
>+	}

If this fails, but the bcsr search works, what happens?  Possibly
nothing, but I wonder if the search for both nodes should be done before
actually touching the hardware.

>+
>+	/* configure gpio16 and gpio19 as alternate1 */
>+
>+	/* GPIO0_ISR1H for alternate 1 settings */
>+	val = in_be32(vaddr + GPIO0_ISR1H);
>+	out_be32((vaddr + GPIO0_ISR1H), val | 0x4200000);
>+
>+	/* GPIO0_OSRH for alternate 1 settings */
>+	val = in_be32(vaddr + GPIO0_OSRH);
>+	out_be32((vaddr + GPIO0_OSRH), val | 0x42000000);
>+
>+	/* GPIO0_TSRH for alternate 1 settings */
>+	val = in_be32(vaddr + GPIO0_TSRH);
>+	out_be32((vaddr + GPIO0_TSRH), val | 0x42000000);
>+	of_node_put(np);
>+	return 0;
>+
>+}
>+arch_initcall(ppc460ex_canyonlands_fixup);

With this being an arch_initcall, it will get called for every kind of
platform in a multi-board kernel.  Another reason to only call it from a
board specific probe function if it really is canyonlands specific.

josh
