Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933624Ab2HWHiY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 03:38:24 -0400
Received: from mta05.xtra.co.nz ([210.54.141.250]:16596 "EHLO mta02.xtra.co.nz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933613Ab2HWHgG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 03:36:06 -0400
From: Tony Prisk <linux@prisktech.co.nz>
To: vt8500-wm8505-linux-kernel@googlegroups.com
Cc: Tony Prisk <linux@prisktech.co.nz>, Russell King <linux@arm.linux.org.uk>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mike Turquette <mturquette@ti.com>,
        Stephen Warren <swarren@nvidia.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-serial@vger.kernel.org, rtc-linux@googlegroups.com,
        devicetree-discuss@lists.ozlabs.org
Subject: [PATCHv4 6/9] arm: vt8500: Update arch-vt8500 to devicetree support.
Date: Thu, 23 Aug 2012 19:35:42 +1200
Message-Id: <1345707346-9035-7-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1345707346-9035-1-git-send-email-linux@prisktech.co.nz>
References: <1345707346-9035-1-git-send-email-linux@prisktech.co.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Merged existing board files to a single dt-capable file.
Converted irq and timer code to devicetree.
Removed existing device files that are no longer required with
devicetree support.
All existing platform devices are converted to devicetree nodes
except PWM.

Removed restart.c and moved code into vt8500.c to remove
duplicate PMC code.

Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
---
 arch/arm/Kconfig                                |    5 +
 arch/arm/mach-vt8500/Kconfig                    |   72 +-----
 arch/arm/mach-vt8500/Makefile                   |    9 +-
 arch/arm/mach-vt8500/bv07.c                     |   80 -------
 arch/arm/mach-vt8500/common.h                   |   28 +++
 arch/arm/mach-vt8500/devices-vt8500.c           |   91 --------
 arch/arm/mach-vt8500/devices-wm8505.c           |   99 ---------
 arch/arm/mach-vt8500/devices.c                  |  270 -----------------------
 arch/arm/mach-vt8500/devices.h                  |   88 --------
 arch/arm/mach-vt8500/gpio.c                     |  240 --------------------
 arch/arm/mach-vt8500/include/mach/restart.h     |    4 +-
 arch/arm/mach-vt8500/include/mach/vt8500_irqs.h |   88 --------
 arch/arm/mach-vt8500/include/mach/vt8500_regs.h |   79 -------
 arch/arm/mach-vt8500/include/mach/wm8505_irqs.h |  115 ----------
 arch/arm/mach-vt8500/include/mach/wm8505_regs.h |   78 -------
 arch/arm/mach-vt8500/irq.c                      |  209 +++++++++++-------
 arch/arm/mach-vt8500/restart.c                  |   54 -----
 arch/arm/mach-vt8500/timer.c                    |   67 ++++--
 arch/arm/mach-vt8500/vt8500.c                   |  196 ++++++++++++++++
 arch/arm/mach-vt8500/wm8505_7in.c               |   79 -------
 20 files changed, 413 insertions(+), 1538 deletions(-)
 delete mode 100644 arch/arm/mach-vt8500/bv07.c
 create mode 100644 arch/arm/mach-vt8500/common.h
 delete mode 100644 arch/arm/mach-vt8500/devices-vt8500.c
 delete mode 100644 arch/arm/mach-vt8500/devices-wm8505.c
 delete mode 100644 arch/arm/mach-vt8500/devices.c
 delete mode 100644 arch/arm/mach-vt8500/devices.h
 delete mode 100644 arch/arm/mach-vt8500/gpio.c
 delete mode 100644 arch/arm/mach-vt8500/include/mach/vt8500_irqs.h
 delete mode 100644 arch/arm/mach-vt8500/include/mach/vt8500_regs.h
 delete mode 100644 arch/arm/mach-vt8500/include/mach/wm8505_irqs.h
 delete mode 100644 arch/arm/mach-vt8500/include/mach/wm8505_regs.h
 delete mode 100644 arch/arm/mach-vt8500/restart.c
 create mode 100644 arch/arm/mach-vt8500/vt8500.c
 delete mode 100644 arch/arm/mach-vt8500/wm8505_7in.c

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 6774c80..ea8ec75 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -996,6 +996,10 @@ config ARCH_VT8500
 	select GENERIC_CLOCKEVENTS
 	select ARCH_REQUIRE_GPIOLIB
 	select HAVE_PWM
+	select USE_OF
+	select COMMON_CLK
+	select HAVE_CLK
+	select CLKDEV_LOOKUP
 	help
 	  Support for VIA/WonderMedia VT8500/WM85xx System-on-Chip.
 
@@ -1613,6 +1617,7 @@ config ARCH_NR_GPIO
 	default 355 if ARCH_U8500
 	default 264 if MACH_H4700
 	default 512 if SOC_OMAP5
+	default 288 if ARCH_VT8500
 	default 0
 	help
 	  Maximum number of GPIOs in the system.
diff --git a/arch/arm/mach-vt8500/Kconfig b/arch/arm/mach-vt8500/Kconfig
index 2c20a34..44f9f9d 100644
--- a/arch/arm/mach-vt8500/Kconfig
+++ b/arch/arm/mach-vt8500/Kconfig
@@ -1,73 +1,15 @@
 if ARCH_VT8500
 
-config VTWM_VERSION_VT8500
+config VTWM_VERSION_WMT_DT
 	bool
 
-config VTWM_VERSION_WM8505
-	bool
-
-config MACH_BV07
-	bool "Benign BV07-8500 Mini Netbook"
-	depends on ARCH_VT8500
-	select VTWM_VERSION_VT8500
-	help
-	  Add support for the inexpensive 7-inch netbooks sold by many
-	  Chinese distributors under various names. Note that there are
-	  many hardware implementations in identical exterior, make sure
-	  that yours is indeed based on a VIA VT8500 chip.
-
-config MACH_WM8505_7IN_NETBOOK
-	bool "WM8505 7-inch generic netbook"
+config MACH_WMT_DT
+	bool "VIA/Wondermedia SoC based boards (Device Tree Support)"
 	depends on ARCH_VT8500
-	select VTWM_VERSION_WM8505
-	help
-	  Add support for the inexpensive 7-inch netbooks sold by many
-	  Chinese distributors under various names. Note that there are
-	  many hardware implementations in identical exterior, make sure
-	  that yours is indeed based on a WonderMedia WM8505 chip.
-
-comment "LCD panel size"
-
-config WMT_PANEL_800X480
-	bool "7-inch with 800x480 resolution"
-	depends on (FB_VT8500 || FB_WM8505)
-	default y
-	help
-	  These are found in most of the netbooks in generic cases, as
-	  well as in Eken M001 tablets and possibly elsewhere.
-
-	  To select this panel at runtime, say y here and append
-	  'panel=800x480' to your kernel command line. Otherwise, the
-	  largest one available will be used.
-
-config WMT_PANEL_800X600
-	bool "8-inch with 800x600 resolution"
-	depends on (FB_VT8500 || FB_WM8505)
-	help
-	  These are found in Eken M003 tablets and possibly elsewhere.
-
-	  To select this panel at runtime, say y here and append
-	  'panel=800x600' to your kernel command line. Otherwise, the
-	  largest one available will be used.
-
-config WMT_PANEL_1024X576
-	bool "10-inch with 1024x576 resolution"
-	depends on (FB_VT8500 || FB_WM8505)
+	select VTWM_VERSION_WMT_DT
 	help
-	  These are found in CherryPal netbooks and possibly elsewhere.
-
-	  To select this panel at runtime, say y here and append
-	  'panel=1024x576' to your kernel command line. Otherwise, the
-	  largest one available will be used.
-
-config WMT_PANEL_1024X600
-	bool "10-inch with 1024x600 resolution"
-	depends on (FB_VT8500 || FB_WM8505)
-	help
-	  These are found in Eken M006 tablets and possibly elsewhere.
-
-	  To select this panel at runtime, say y here and append
-	  'panel=1024x600' to your kernel command line. Otherwise, the
-	  largest one available will be used.
+	  Add support for netbooks, tablets and other devices based on
+	  the reference board design as produced by VIA/WonderMedia, using
+	  VT8500/WM8505/WM8650 System-on-Chip.
 
 endif
diff --git a/arch/arm/mach-vt8500/Makefile b/arch/arm/mach-vt8500/Makefile
index 54e6997..1966183 100644
--- a/arch/arm/mach-vt8500/Makefile
+++ b/arch/arm/mach-vt8500/Makefile
@@ -1,9 +1,4 @@
-obj-y += devices.o gpio.o irq.o timer.o restart.o
-
-obj-$(CONFIG_VTWM_VERSION_VT8500) += devices-vt8500.o
-obj-$(CONFIG_VTWM_VERSION_WM8505) += devices-wm8505.o
-
-obj-$(CONFIG_MACH_BV07) += bv07.o
-obj-$(CONFIG_MACH_WM8505_7IN_NETBOOK) += wm8505_7in.o
+obj-$(CONFIG_VTWM_VERSION_WMT_DT) += irq.o timer.o
+obj-$(CONFIG_MACH_WMT_DT) += vt8500.o
 
 obj-$(CONFIG_HAVE_PWM) += pwm.o
diff --git a/arch/arm/mach-vt8500/bv07.c b/arch/arm/mach-vt8500/bv07.c
deleted file mode 100644
index f9fbeb2..0000000
--- a/arch/arm/mach-vt8500/bv07.c
+++ /dev/null
@@ -1,80 +0,0 @@
-/*
- *  arch/arm/mach-vt8500/bv07.c
- *
- *  Copyright (C) 2010 Alexey Charkov <alchark@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- */
-
-#include <linux/io.h>
-#include <linux/pm.h>
-
-#include <asm/mach-types.h>
-#include <asm/mach/arch.h>
-#include <mach/restart.h>
-
-#include "devices.h"
-
-static void __iomem *pmc_hiber;
-
-static struct platform_device *devices[] __initdata = {
-	&vt8500_device_uart0,
-	&vt8500_device_lcdc,
-	&vt8500_device_ehci,
-	&vt8500_device_ge_rops,
-	&vt8500_device_pwm,
-	&vt8500_device_pwmbl,
-	&vt8500_device_rtc,
-};
-
-static void vt8500_power_off(void)
-{
-	local_irq_disable();
-	writew(5, pmc_hiber);
-	asm("mcr%? p15, 0, %0, c7, c0, 4" : : "r" (0));
-}
-
-void __init bv07_init(void)
-{
-#ifdef CONFIG_FB_VT8500
-	void __iomem *gpio_mux_reg = ioremap(wmt_gpio_base + 0x200, 4);
-	if (gpio_mux_reg) {
-		writel(readl(gpio_mux_reg) | 1, gpio_mux_reg);
-		iounmap(gpio_mux_reg);
-	} else {
-		printk(KERN_ERR "Could not remap the GPIO mux register, display may not work properly!\n");
-	}
-#endif
-	pmc_hiber = ioremap(wmt_pmc_base + 0x12, 2);
-	if (pmc_hiber)
-		pm_power_off = &vt8500_power_off;
-	else
-		printk(KERN_ERR "PMC Hibernation register could not be remapped, not enabling power off!\n");
-
-	wmt_setup_restart();
-	vt8500_set_resources();
-	platform_add_devices(devices, ARRAY_SIZE(devices));
-	vt8500_gpio_init();
-}
-
-MACHINE_START(BV07, "Benign BV07 Mini Netbook")
-	.atag_offset	= 0x100,
-	.restart	= wmt_restart,
-	.reserve	= vt8500_reserve_mem,
-	.map_io		= vt8500_map_io,
-	.init_irq	= vt8500_init_irq,
-	.timer		= &vt8500_timer,
-	.init_machine	= bv07_init,
-MACHINE_END
diff --git a/arch/arm/mach-vt8500/common.h b/arch/arm/mach-vt8500/common.h
new file mode 100644
index 0000000..2b24196
--- /dev/null
+++ b/arch/arm/mach-vt8500/common.h
@@ -0,0 +1,28 @@
+/* linux/arch/arm/mach-vt8500/dt_common.h
+ *
+ * Copyright (C) 2012 Tony Prisk <linux@prisktech.co.nz>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef __ARCH_ARM_MACH_VT8500_DT_COMMON_H
+#define __ARCH_ARM_MACH_VT8500_DT_COMMON_H
+
+#include <linux/of.h>
+
+void __init vt8500_timer_init(void);
+int __init vt8500_irq_init(struct device_node *node,
+				struct device_node *parent);
+
+/* defined in drivers/clk/clk-vt8500.c */
+void __init vtwm_clk_init(void __iomem *pmc_base);
+
+#endif
diff --git a/arch/arm/mach-vt8500/devices-vt8500.c b/arch/arm/mach-vt8500/devices-vt8500.c
deleted file mode 100644
index 19519ae..0000000
--- a/arch/arm/mach-vt8500/devices-vt8500.c
+++ /dev/null
@@ -1,91 +0,0 @@
-/* linux/arch/arm/mach-vt8500/devices-vt8500.c
- *
- * Copyright (C) 2010 Alexey Charkov <alchark@gmail.com>
- *
- * This software is licensed under the terms of the GNU General Public
- * License version 2, as published by the Free Software Foundation, and
- * may be copied, distributed, and modified under those terms.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- */
-
-#include <linux/platform_device.h>
-
-#include <mach/vt8500_regs.h>
-#include <mach/vt8500_irqs.h>
-#include <mach/i8042.h>
-#include "devices.h"
-
-void __init vt8500_set_resources(void)
-{
-	struct resource tmp[3];
-
-	tmp[0] = wmt_mmio_res(VT8500_LCDC_BASE, SZ_1K);
-	tmp[1] = wmt_irq_res(IRQ_LCDC);
-	wmt_res_add(&vt8500_device_lcdc, tmp, 2);
-
-	tmp[0] = wmt_mmio_res(VT8500_UART0_BASE, 0x1040);
-	tmp[1] = wmt_irq_res(IRQ_UART0);
-	wmt_res_add(&vt8500_device_uart0, tmp, 2);
-
-	tmp[0] = wmt_mmio_res(VT8500_UART1_BASE, 0x1040);
-	tmp[1] = wmt_irq_res(IRQ_UART1);
-	wmt_res_add(&vt8500_device_uart1, tmp, 2);
-
-	tmp[0] = wmt_mmio_res(VT8500_UART2_BASE, 0x1040);
-	tmp[1] = wmt_irq_res(IRQ_UART2);
-	wmt_res_add(&vt8500_device_uart2, tmp, 2);
-
-	tmp[0] = wmt_mmio_res(VT8500_UART3_BASE, 0x1040);
-	tmp[1] = wmt_irq_res(IRQ_UART3);
-	wmt_res_add(&vt8500_device_uart3, tmp, 2);
-
-	tmp[0] = wmt_mmio_res(VT8500_EHCI_BASE, SZ_512);
-	tmp[1] = wmt_irq_res(IRQ_EHCI);
-	wmt_res_add(&vt8500_device_ehci, tmp, 2);
-
-	tmp[0] = wmt_mmio_res(VT8500_GEGEA_BASE, SZ_256);
-	wmt_res_add(&vt8500_device_ge_rops, tmp, 1);
-
-	tmp[0] = wmt_mmio_res(VT8500_PWM_BASE, 0x44);
-	wmt_res_add(&vt8500_device_pwm, tmp, 1);
-
-	tmp[0] = wmt_mmio_res(VT8500_RTC_BASE, 0x2c);
-	tmp[1] = wmt_irq_res(IRQ_RTC);
-	tmp[2] = wmt_irq_res(IRQ_RTCSM);
-	wmt_res_add(&vt8500_device_rtc, tmp, 3);
-}
-
-static void __init vt8500_set_externs(void)
-{
-	/* Non-resource-aware stuff */
-	wmt_ic_base = VT8500_IC_BASE;
-	wmt_gpio_base = VT8500_GPIO_BASE;
-	wmt_pmc_base = VT8500_PMC_BASE;
-	wmt_i8042_base = VT8500_PS2_BASE;
-
-	wmt_nr_irqs = VT8500_NR_IRQS;
-	wmt_timer_irq = IRQ_PMCOS0;
-	wmt_gpio_ext_irq[0] = IRQ_EXT0;
-	wmt_gpio_ext_irq[1] = IRQ_EXT1;
-	wmt_gpio_ext_irq[2] = IRQ_EXT2;
-	wmt_gpio_ext_irq[3] = IRQ_EXT3;
-	wmt_gpio_ext_irq[4] = IRQ_EXT4;
-	wmt_gpio_ext_irq[5] = IRQ_EXT5;
-	wmt_gpio_ext_irq[6] = IRQ_EXT6;
-	wmt_gpio_ext_irq[7] = IRQ_EXT7;
-	wmt_i8042_kbd_irq = IRQ_PS2KBD;
-	wmt_i8042_aux_irq = IRQ_PS2MOUSE;
-}
-
-void __init vt8500_map_io(void)
-{
-	iotable_init(wmt_io_desc, ARRAY_SIZE(wmt_io_desc));
-
-	/* Should be done before interrupts and timers are initialized */
-	vt8500_set_externs();
-}
diff --git a/arch/arm/mach-vt8500/devices-wm8505.c b/arch/arm/mach-vt8500/devices-wm8505.c
deleted file mode 100644
index db4594e..0000000
--- a/arch/arm/mach-vt8500/devices-wm8505.c
+++ /dev/null
@@ -1,99 +0,0 @@
-/* linux/arch/arm/mach-vt8500/devices-wm8505.c
- *
- * Copyright (C) 2010 Alexey Charkov <alchark@gmail.com>
- *
- * This software is licensed under the terms of the GNU General Public
- * License version 2, as published by the Free Software Foundation, and
- * may be copied, distributed, and modified under those terms.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- */
-
-#include <linux/platform_device.h>
-
-#include <mach/wm8505_regs.h>
-#include <mach/wm8505_irqs.h>
-#include <mach/i8042.h>
-#include "devices.h"
-
-void __init wm8505_set_resources(void)
-{
-	struct resource tmp[3];
-
-	tmp[0] = wmt_mmio_res(WM8505_GOVR_BASE, SZ_512);
-	wmt_res_add(&vt8500_device_wm8505_fb, tmp, 1);
-
-	tmp[0] = wmt_mmio_res(WM8505_UART0_BASE, 0x1040);
-	tmp[1] = wmt_irq_res(IRQ_UART0);
-	wmt_res_add(&vt8500_device_uart0, tmp, 2);
-
-	tmp[0] = wmt_mmio_res(WM8505_UART1_BASE, 0x1040);
-	tmp[1] = wmt_irq_res(IRQ_UART1);
-	wmt_res_add(&vt8500_device_uart1, tmp, 2);
-
-	tmp[0] = wmt_mmio_res(WM8505_UART2_BASE, 0x1040);
-	tmp[1] = wmt_irq_res(IRQ_UART2);
-	wmt_res_add(&vt8500_device_uart2, tmp, 2);
-
-	tmp[0] = wmt_mmio_res(WM8505_UART3_BASE, 0x1040);
-	tmp[1] = wmt_irq_res(IRQ_UART3);
-	wmt_res_add(&vt8500_device_uart3, tmp, 2);
-
-	tmp[0] = wmt_mmio_res(WM8505_UART4_BASE, 0x1040);
-	tmp[1] = wmt_irq_res(IRQ_UART4);
-	wmt_res_add(&vt8500_device_uart4, tmp, 2);
-
-	tmp[0] = wmt_mmio_res(WM8505_UART5_BASE, 0x1040);
-	tmp[1] = wmt_irq_res(IRQ_UART5);
-	wmt_res_add(&vt8500_device_uart5, tmp, 2);
-
-	tmp[0] = wmt_mmio_res(WM8505_EHCI_BASE, SZ_512);
-	tmp[1] = wmt_irq_res(IRQ_EHCI);
-	wmt_res_add(&vt8500_device_ehci, tmp, 2);
-
-	tmp[0] = wmt_mmio_res(WM8505_GEGEA_BASE, SZ_256);
-	wmt_res_add(&vt8500_device_ge_rops, tmp, 1);
-
-	tmp[0] = wmt_mmio_res(WM8505_PWM_BASE, 0x44);
-	wmt_res_add(&vt8500_device_pwm, tmp, 1);
-
-	tmp[0] = wmt_mmio_res(WM8505_RTC_BASE, 0x2c);
-	tmp[1] = wmt_irq_res(IRQ_RTC);
-	tmp[2] = wmt_irq_res(IRQ_RTCSM);
-	wmt_res_add(&vt8500_device_rtc, tmp, 3);
-}
-
-static void __init wm8505_set_externs(void)
-{
-	/* Non-resource-aware stuff */
-	wmt_ic_base = WM8505_IC_BASE;
-	wmt_sic_base = WM8505_SIC_BASE;
-	wmt_gpio_base = WM8505_GPIO_BASE;
-	wmt_pmc_base = WM8505_PMC_BASE;
-	wmt_i8042_base = WM8505_PS2_BASE;
-
-	wmt_nr_irqs = WM8505_NR_IRQS;
-	wmt_timer_irq = IRQ_PMCOS0;
-	wmt_gpio_ext_irq[0] = IRQ_EXT0;
-	wmt_gpio_ext_irq[1] = IRQ_EXT1;
-	wmt_gpio_ext_irq[2] = IRQ_EXT2;
-	wmt_gpio_ext_irq[3] = IRQ_EXT3;
-	wmt_gpio_ext_irq[4] = IRQ_EXT4;
-	wmt_gpio_ext_irq[5] = IRQ_EXT5;
-	wmt_gpio_ext_irq[6] = IRQ_EXT6;
-	wmt_gpio_ext_irq[7] = IRQ_EXT7;
-	wmt_i8042_kbd_irq = IRQ_PS2KBD;
-	wmt_i8042_aux_irq = IRQ_PS2MOUSE;
-}
-
-void __init wm8505_map_io(void)
-{
-	iotable_init(wmt_io_desc, ARRAY_SIZE(wmt_io_desc));
-
-	/* Should be done before interrupts and timers are initialized */
-	wm8505_set_externs();
-}
diff --git a/arch/arm/mach-vt8500/devices.c b/arch/arm/mach-vt8500/devices.c
deleted file mode 100644
index 1fcdc36..0000000
--- a/arch/arm/mach-vt8500/devices.c
+++ /dev/null
@@ -1,270 +0,0 @@
-/* linux/arch/arm/mach-vt8500/devices.c
- *
- * Copyright (C) 2010 Alexey Charkov <alchark@gmail.com>
- *
- * This software is licensed under the terms of the GNU General Public
- * License version 2, as published by the Free Software Foundation, and
- * may be copied, distributed, and modified under those terms.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- */
-
-#include <linux/kernel.h>
-#include <linux/io.h>
-#include <linux/device.h>
-#include <linux/dma-mapping.h>
-#include <linux/platform_device.h>
-#include <linux/pwm_backlight.h>
-#include <linux/memblock.h>
-
-#include <asm/mach/arch.h>
-
-#include <mach/vt8500fb.h>
-#include <mach/i8042.h>
-#include "devices.h"
-
-/* These can't use resources currently */
-unsigned long wmt_ic_base __initdata;
-unsigned long wmt_sic_base __initdata;
-unsigned long wmt_gpio_base __initdata;
-unsigned long wmt_pmc_base __initdata;
-unsigned long wmt_i8042_base __initdata;
-
-int wmt_nr_irqs __initdata;
-int wmt_timer_irq __initdata;
-int wmt_gpio_ext_irq[8] __initdata;
-
-/* Should remain accessible after init.
- * i8042 driver desperately calls for attention...
- */
-int wmt_i8042_kbd_irq;
-int wmt_i8042_aux_irq;
-
-static u64 fb_dma_mask = DMA_BIT_MASK(32);
-
-struct platform_device vt8500_device_lcdc = {
-	.name           = "vt8500-lcd",
-	.id             = 0,
-	.dev		= {
-		.dma_mask	= &fb_dma_mask,
-		.coherent_dma_mask = DMA_BIT_MASK(32),
-	},
-};
-
-struct platform_device vt8500_device_wm8505_fb = {
-	.name           = "wm8505-fb",
-	.id             = 0,
-};
-
-/* Smallest to largest */
-static struct vt8500fb_platform_data panels[] = {
-#ifdef CONFIG_WMT_PANEL_800X480
-{
-	.xres_virtual	= 800,
-	.yres_virtual	= 480 * 2,
-	.mode		= {
-		.name		= "800x480",
-		.xres		= 800,
-		.yres		= 480,
-		.left_margin	= 88,
-		.right_margin	= 40,
-		.upper_margin	= 32,
-		.lower_margin	= 11,
-		.hsync_len	= 0,
-		.vsync_len	= 1,
-		.vmode		= FB_VMODE_NONINTERLACED,
-	},
-},
-#endif
-#ifdef CONFIG_WMT_PANEL_800X600
-{
-	.xres_virtual	= 800,
-	.yres_virtual	= 600 * 2,
-	.mode		= {
-		.name		= "800x600",
-		.xres		= 800,
-		.yres		= 600,
-		.left_margin	= 88,
-		.right_margin	= 40,
-		.upper_margin	= 32,
-		.lower_margin	= 11,
-		.hsync_len	= 0,
-		.vsync_len	= 1,
-		.vmode		= FB_VMODE_NONINTERLACED,
-	},
-},
-#endif
-#ifdef CONFIG_WMT_PANEL_1024X576
-{
-	.xres_virtual	= 1024,
-	.yres_virtual	= 576 * 2,
-	.mode		= {
-		.name		= "1024x576",
-		.xres		= 1024,
-		.yres		= 576,
-		.left_margin	= 40,
-		.right_margin	= 24,
-		.upper_margin	= 32,
-		.lower_margin	= 11,
-		.hsync_len	= 96,
-		.vsync_len	= 2,
-		.vmode		= FB_VMODE_NONINTERLACED,
-	},
-},
-#endif
-#ifdef CONFIG_WMT_PANEL_1024X600
-{
-	.xres_virtual	= 1024,
-	.yres_virtual	= 600 * 2,
-	.mode		= {
-		.name		= "1024x600",
-		.xres		= 1024,
-		.yres		= 600,
-		.left_margin	= 66,
-		.right_margin	= 2,
-		.upper_margin	= 19,
-		.lower_margin	= 1,
-		.hsync_len	= 23,
-		.vsync_len	= 8,
-		.vmode		= FB_VMODE_NONINTERLACED,
-	},
-},
-#endif
-};
-
-static int current_panel_idx __initdata = ARRAY_SIZE(panels) - 1;
-
-static int __init panel_setup(char *str)
-{
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(panels); i++) {
-		if (strcmp(panels[i].mode.name, str) == 0) {
-			current_panel_idx = i;
-			break;
-		}
-	}
-	return 0;
-}
-
-early_param("panel", panel_setup);
-
-static inline void preallocate_fb(struct vt8500fb_platform_data *p,
-				  unsigned long align) {
-	p->video_mem_len = (p->xres_virtual * p->yres_virtual * 4) >>
-			(p->bpp > 16 ? 0 : (p->bpp > 8 ? 1 :
-					(8 / p->bpp) + 1));
-	p->video_mem_phys = (unsigned long)memblock_alloc(p->video_mem_len,
-							  align);
-	p->video_mem_virt = phys_to_virt(p->video_mem_phys);
-}
-
-struct platform_device vt8500_device_uart0 = {
-	.name		= "vt8500_serial",
-	.id		= 0,
-};
-
-struct platform_device vt8500_device_uart1 = {
-	.name		= "vt8500_serial",
-	.id		= 1,
-};
-
-struct platform_device vt8500_device_uart2 = {
-	.name		= "vt8500_serial",
-	.id		= 2,
-};
-
-struct platform_device vt8500_device_uart3 = {
-	.name		= "vt8500_serial",
-	.id		= 3,
-};
-
-struct platform_device vt8500_device_uart4 = {
-	.name		= "vt8500_serial",
-	.id		= 4,
-};
-
-struct platform_device vt8500_device_uart5 = {
-	.name		= "vt8500_serial",
-	.id		= 5,
-};
-
-static u64 ehci_dma_mask = DMA_BIT_MASK(32);
-
-struct platform_device vt8500_device_ehci = {
-	.name		= "vt8500-ehci",
-	.id		= 0,
-	.dev		= {
-		.dma_mask	= &ehci_dma_mask,
-		.coherent_dma_mask = DMA_BIT_MASK(32),
-	},
-};
-
-struct platform_device vt8500_device_ge_rops = {
-	.name		= "wmt_ge_rops",
-	.id		= -1,
-};
-
-struct platform_device vt8500_device_pwm = {
-	.name		= "vt8500-pwm",
-	.id		= 0,
-};
-
-static struct platform_pwm_backlight_data vt8500_pwmbl_data = {
-	.pwm_id		= 0,
-	.max_brightness	= 128,
-	.dft_brightness = 70,
-	.pwm_period_ns	= 250000, /* revisit when clocks are implemented */
-};
-
-struct platform_device vt8500_device_pwmbl = {
-	.name		= "pwm-backlight",
-	.id		= 0,
-	.dev		= {
-		.platform_data = &vt8500_pwmbl_data,
-	},
-};
-
-struct platform_device vt8500_device_rtc = {
-	.name		= "vt8500-rtc",
-	.id		= 0,
-};
-
-struct map_desc wmt_io_desc[] __initdata = {
-	/* SoC MMIO registers */
-	[0] = {
-		.virtual	= 0xf8000000,
-		.pfn		= __phys_to_pfn(0xd8000000),
-		.length		= 0x00390000, /* max of all chip variants */
-		.type		= MT_DEVICE
-	},
-	/* PCI I/O space, numbers tied to those in <mach/io.h> */
-	[1] = {
-		.virtual	= 0xf0000000,
-		.pfn		= __phys_to_pfn(0xc0000000),
-		.length		= SZ_64K,
-		.type		= MT_DEVICE
-	},
-};
-
-void __init vt8500_reserve_mem(void)
-{
-#ifdef CONFIG_FB_VT8500
-	panels[current_panel_idx].bpp = 16; /* Always use RGB565 */
-	preallocate_fb(&panels[current_panel_idx], SZ_4M);
-	vt8500_device_lcdc.dev.platform_data = &panels[current_panel_idx];
-#endif
-}
-
-void __init wm8505_reserve_mem(void)
-{
-#if defined CONFIG_FB_WM8505
-	panels[current_panel_idx].bpp = 32; /* Always use RGB888 */
-	preallocate_fb(&panels[current_panel_idx], 32);
-	vt8500_device_wm8505_fb.dev.platform_data = &panels[current_panel_idx];
-#endif
-}
diff --git a/arch/arm/mach-vt8500/devices.h b/arch/arm/mach-vt8500/devices.h
deleted file mode 100644
index 188d4e1..0000000
--- a/arch/arm/mach-vt8500/devices.h
+++ /dev/null
@@ -1,88 +0,0 @@
-/* linux/arch/arm/mach-vt8500/devices.h
- *
- * Copyright (C) 2010 Alexey Charkov <alchark@gmail.com>
- *
- * This software is licensed under the terms of the GNU General Public
- * License version 2, as published by the Free Software Foundation, and
- * may be copied, distributed, and modified under those terms.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- */
-
-#ifndef __ARCH_ARM_MACH_VT8500_DEVICES_H
-#define __ARCH_ARM_MACH_VT8500_DEVICES_H
-
-#include <linux/platform_device.h>
-#include <asm/mach/map.h>
-
-void __init vt8500_init_irq(void);
-void __init wm8505_init_irq(void);
-void __init vt8500_map_io(void);
-void __init wm8505_map_io(void);
-void __init vt8500_reserve_mem(void);
-void __init wm8505_reserve_mem(void);
-void __init vt8500_gpio_init(void);
-void __init vt8500_set_resources(void);
-void __init wm8505_set_resources(void);
-
-extern unsigned long wmt_ic_base __initdata;
-extern unsigned long wmt_sic_base __initdata;
-extern unsigned long wmt_gpio_base __initdata;
-extern unsigned long wmt_pmc_base __initdata;
-
-extern int wmt_nr_irqs __initdata;
-extern int wmt_timer_irq __initdata;
-extern int wmt_gpio_ext_irq[8] __initdata;
-
-extern struct map_desc wmt_io_desc[2] __initdata;
-
-static inline struct resource wmt_mmio_res(u32 start, u32 size)
-{
-	struct resource tmp = {
-		.flags = IORESOURCE_MEM,
-		.start = start,
-		.end = start + size - 1,
-	};
-
-	return tmp;
-}
-
-static inline struct resource wmt_irq_res(int irq)
-{
-	struct resource tmp = {
-		.flags = IORESOURCE_IRQ,
-		.start = irq,
-		.end = irq,
-	};
-
-	return tmp;
-}
-
-static inline void wmt_res_add(struct platform_device *pdev,
-			       const struct resource *res, unsigned int num)
-{
-	if (unlikely(platform_device_add_resources(pdev, res, num)))
-		pr_err("Failed to assign resources\n");
-}
-
-extern struct sys_timer vt8500_timer;
-
-extern struct platform_device vt8500_device_uart0;
-extern struct platform_device vt8500_device_uart1;
-extern struct platform_device vt8500_device_uart2;
-extern struct platform_device vt8500_device_uart3;
-extern struct platform_device vt8500_device_uart4;
-extern struct platform_device vt8500_device_uart5;
-
-extern struct platform_device vt8500_device_lcdc;
-extern struct platform_device vt8500_device_wm8505_fb;
-extern struct platform_device vt8500_device_ehci;
-extern struct platform_device vt8500_device_ge_rops;
-extern struct platform_device vt8500_device_pwm;
-extern struct platform_device vt8500_device_pwmbl;
-extern struct platform_device vt8500_device_rtc;
-#endif
diff --git a/arch/arm/mach-vt8500/gpio.c b/arch/arm/mach-vt8500/gpio.c
deleted file mode 100644
index 2bcc0ec..0000000
--- a/arch/arm/mach-vt8500/gpio.c
+++ /dev/null
@@ -1,240 +0,0 @@
-/* linux/arch/arm/mach-vt8500/gpio.c
- *
- * Copyright (C) 2010 Alexey Charkov <alchark@gmail.com>
- *
- * This software is licensed under the terms of the GNU General Public
- * License version 2, as published by the Free Software Foundation, and
- * may be copied, distributed, and modified under those terms.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- */
-
-#include <linux/gpio.h>
-#include <linux/init.h>
-#include <linux/irq.h>
-#include <linux/io.h>
-
-#include "devices.h"
-
-#define to_vt8500(__chip) container_of(__chip, struct vt8500_gpio_chip, chip)
-
-#define ENABLE_REGS	0x0
-#define DIRECTION_REGS	0x20
-#define OUTVALUE_REGS	0x40
-#define INVALUE_REGS	0x60
-
-#define EXT_REGOFF	0x1c
-
-static void __iomem *regbase;
-
-struct vt8500_gpio_chip {
-	struct gpio_chip	chip;
-	unsigned int		shift;
-	unsigned int		regoff;
-};
-
-static int gpio_to_irq_map[8];
-
-static int vt8500_muxed_gpio_request(struct gpio_chip *chip,
-				     unsigned offset)
-{
-	struct vt8500_gpio_chip *vt8500_chip = to_vt8500(chip);
-	unsigned val = readl(regbase + ENABLE_REGS + vt8500_chip->regoff);
-
-	val |= (1 << vt8500_chip->shift << offset);
-	writel(val, regbase + ENABLE_REGS + vt8500_chip->regoff);
-
-	return 0;
-}
-
-static void vt8500_muxed_gpio_free(struct gpio_chip *chip,
-				   unsigned offset)
-{
-	struct vt8500_gpio_chip *vt8500_chip = to_vt8500(chip);
-	unsigned val = readl(regbase + ENABLE_REGS + vt8500_chip->regoff);
-
-	val &= ~(1 << vt8500_chip->shift << offset);
-	writel(val, regbase + ENABLE_REGS + vt8500_chip->regoff);
-}
-
-static int vt8500_muxed_gpio_direction_input(struct gpio_chip *chip,
-				       unsigned offset)
-{
-	struct vt8500_gpio_chip *vt8500_chip = to_vt8500(chip);
-	unsigned val = readl(regbase + DIRECTION_REGS + vt8500_chip->regoff);
-
-	val &= ~(1 << vt8500_chip->shift << offset);
-	writel(val, regbase + DIRECTION_REGS + vt8500_chip->regoff);
-
-	return 0;
-}
-
-static int vt8500_muxed_gpio_direction_output(struct gpio_chip *chip,
-					unsigned offset, int value)
-{
-	struct vt8500_gpio_chip *vt8500_chip = to_vt8500(chip);
-	unsigned val = readl(regbase + DIRECTION_REGS + vt8500_chip->regoff);
-
-	val |= (1 << vt8500_chip->shift << offset);
-	writel(val, regbase + DIRECTION_REGS + vt8500_chip->regoff);
-
-	if (value) {
-		val = readl(regbase + OUTVALUE_REGS + vt8500_chip->regoff);
-		val |= (1 << vt8500_chip->shift << offset);
-		writel(val, regbase + OUTVALUE_REGS + vt8500_chip->regoff);
-	}
-	return 0;
-}
-
-static int vt8500_muxed_gpio_get_value(struct gpio_chip *chip,
-				       unsigned offset)
-{
-	struct vt8500_gpio_chip *vt8500_chip = to_vt8500(chip);
-
-	return (readl(regbase + INVALUE_REGS + vt8500_chip->regoff)
-		>> vt8500_chip->shift >> offset) & 1;
-}
-
-static void vt8500_muxed_gpio_set_value(struct gpio_chip *chip,
-					unsigned offset, int value)
-{
-	struct vt8500_gpio_chip *vt8500_chip = to_vt8500(chip);
-	unsigned val = readl(regbase + INVALUE_REGS + vt8500_chip->regoff);
-
-	if (value)
-		val |= (1 << vt8500_chip->shift << offset);
-	else
-		val &= ~(1 << vt8500_chip->shift << offset);
-
-	writel(val, regbase + INVALUE_REGS + vt8500_chip->regoff);
-}
-
-#define VT8500_GPIO_BANK(__name, __shift, __off, __base, __num)		\
-{									\
-	.chip = {							\
-		.label			= __name,			\
-		.request		= vt8500_muxed_gpio_request,	\
-		.free			= vt8500_muxed_gpio_free,	\
-		.direction_input  = vt8500_muxed_gpio_direction_input,	\
-		.direction_output = vt8500_muxed_gpio_direction_output,	\
-		.get			= vt8500_muxed_gpio_get_value,	\
-		.set			= vt8500_muxed_gpio_set_value,	\
-		.can_sleep		= 0,				\
-		.base			= __base,			\
-		.ngpio			= __num,			\
-	},								\
-	.shift		= __shift,					\
-	.regoff		= __off,					\
-}
-
-static struct vt8500_gpio_chip vt8500_muxed_gpios[] = {
-	VT8500_GPIO_BANK("uart0",	0,	0x0,	8,	4),
-	VT8500_GPIO_BANK("uart1",	4,	0x0,	12,	4),
-	VT8500_GPIO_BANK("spi0",	8,	0x0,	16,	4),
-	VT8500_GPIO_BANK("spi1",	12,	0x0,	20,	4),
-	VT8500_GPIO_BANK("spi2",	16,	0x0,	24,	4),
-	VT8500_GPIO_BANK("pwmout",	24,	0x0,	28,	2),
-
-	VT8500_GPIO_BANK("sdmmc",	0,	0x4,	30,	11),
-	VT8500_GPIO_BANK("ms",		16,	0x4,	41,	7),
-	VT8500_GPIO_BANK("i2c0",	24,	0x4,	48,	2),
-	VT8500_GPIO_BANK("i2c1",	26,	0x4,	50,	2),
-
-	VT8500_GPIO_BANK("mii",		0,	0x8,	52,	20),
-	VT8500_GPIO_BANK("see",		20,	0x8,	72,	4),
-	VT8500_GPIO_BANK("ide",		24,	0x8,	76,	7),
-
-	VT8500_GPIO_BANK("ccir",	0,	0xc,	83,	19),
-
-	VT8500_GPIO_BANK("ts",		8,	0x10,	102,	11),
-
-	VT8500_GPIO_BANK("lcd",		0,	0x14,	113,	23),
-};
-
-static int vt8500_gpio_direction_input(struct gpio_chip *chip,
-				       unsigned offset)
-{
-	unsigned val = readl(regbase + DIRECTION_REGS + EXT_REGOFF);
-
-	val &= ~(1 << offset);
-	writel(val, regbase + DIRECTION_REGS + EXT_REGOFF);
-	return 0;
-}
-
-static int vt8500_gpio_direction_output(struct gpio_chip *chip,
-					unsigned offset, int value)
-{
-	unsigned val = readl(regbase + DIRECTION_REGS + EXT_REGOFF);
-
-	val |= (1 << offset);
-	writel(val, regbase + DIRECTION_REGS + EXT_REGOFF);
-
-	if (value) {
-		val = readl(regbase + OUTVALUE_REGS + EXT_REGOFF);
-		val |= (1 << offset);
-		writel(val, regbase + OUTVALUE_REGS + EXT_REGOFF);
-	}
-	return 0;
-}
-
-static int vt8500_gpio_get_value(struct gpio_chip *chip,
-				       unsigned offset)
-{
-	return (readl(regbase + INVALUE_REGS + EXT_REGOFF) >> offset) & 1;
-}
-
-static void vt8500_gpio_set_value(struct gpio_chip *chip,
-					unsigned offset, int value)
-{
-	unsigned val = readl(regbase + OUTVALUE_REGS + EXT_REGOFF);
-
-	if (value)
-		val |= (1 << offset);
-	else
-		val &= ~(1 << offset);
-
-	writel(val, regbase + OUTVALUE_REGS + EXT_REGOFF);
-}
-
-static int vt8500_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
-{
-	if (offset > 7)
-		return -EINVAL;
-
-	return gpio_to_irq_map[offset];
-}
-
-static struct gpio_chip vt8500_external_gpios = {
-	.label			= "extgpio",
-	.direction_input	= vt8500_gpio_direction_input,
-	.direction_output	= vt8500_gpio_direction_output,
-	.get			= vt8500_gpio_get_value,
-	.set			= vt8500_gpio_set_value,
-	.to_irq			= vt8500_gpio_to_irq,
-	.can_sleep		= 0,
-	.base			= 0,
-	.ngpio			= 8,
-};
-
-void __init vt8500_gpio_init(void)
-{
-	int i;
-
-	for (i = 0; i < 8; i++)
-		gpio_to_irq_map[i] = wmt_gpio_ext_irq[i];
-
-	regbase = ioremap(wmt_gpio_base, SZ_64K);
-	if (!regbase) {
-		printk(KERN_ERR "Failed to map MMIO registers for GPIO\n");
-		return;
-	}
-
-	gpiochip_add(&vt8500_external_gpios);
-
-	for (i = 0; i < ARRAY_SIZE(vt8500_muxed_gpios); i++)
-		gpiochip_add(&vt8500_muxed_gpios[i].chip);
-}
diff --git a/arch/arm/mach-vt8500/include/mach/restart.h b/arch/arm/mach-vt8500/include/mach/restart.h
index 89f9b78..7389795 100644
--- a/arch/arm/mach-vt8500/include/mach/restart.h
+++ b/arch/arm/mach-vt8500/include/mach/restart.h
@@ -13,5 +13,5 @@
  *
  */
 
-void wmt_setup_restart(void);
-void wmt_restart(char mode, const char *cmd);
+void vt8500_setup_restart(void);
+void vt8500_restart(char mode, const char *cmd);
diff --git a/arch/arm/mach-vt8500/include/mach/vt8500_irqs.h b/arch/arm/mach-vt8500/include/mach/vt8500_irqs.h
deleted file mode 100644
index ecfee91..0000000
--- a/arch/arm/mach-vt8500/include/mach/vt8500_irqs.h
+++ /dev/null
@@ -1,88 +0,0 @@
-/*
- *  arch/arm/mach-vt8500/include/mach/vt8500_irqs.h
- *
- *  Copyright (C) 2010 Alexey Charkov <alchark@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- */
-
-/* VT8500 Interrupt Sources */
-
-#define IRQ_JPEGENC	0	/* JPEG Encoder */
-#define IRQ_JPEGDEC	1	/* JPEG Decoder */
-				/* Reserved */
-#define IRQ_PATA	3	/* PATA Controller */
-				/* Reserved */
-#define IRQ_DMA		5	/* DMA Controller */
-#define IRQ_EXT0	6	/* External Interrupt 0 */
-#define IRQ_EXT1	7	/* External Interrupt 1 */
-#define IRQ_GE		8	/* Graphic Engine */
-#define IRQ_GOV		9	/* Graphic Overlay Engine */
-#define IRQ_ETHER	10	/* Ethernet MAC */
-#define IRQ_MPEGTS	11	/* Transport Stream Interface */
-#define IRQ_LCDC	12	/* LCD Controller */
-#define IRQ_EXT2	13	/* External Interrupt 2 */
-#define IRQ_EXT3	14	/* External Interrupt 3 */
-#define IRQ_EXT4	15	/* External Interrupt 4 */
-#define IRQ_CIPHER	16	/* Cipher */
-#define IRQ_VPP		17	/* Video Post-Processor */
-#define IRQ_I2C1	18	/* I2C 1 */
-#define IRQ_I2C0	19	/* I2C 0 */
-#define IRQ_SDMMC	20	/* SD/MMC Controller */
-#define IRQ_SDMMC_DMA	21	/* SD/MMC Controller DMA */
-#define IRQ_PMC_WU	22	/* Power Management Controller Wakeup */
-				/* Reserved */
-#define IRQ_SPI0	24	/* SPI 0 */
-#define IRQ_SPI1	25	/* SPI 1 */
-#define IRQ_SPI2	26	/* SPI 2 */
-#define IRQ_LCDDF	27	/* LCD Data Formatter */
-#define IRQ_NAND	28	/* NAND Flash Controller */
-#define IRQ_NAND_DMA	29	/* NAND Flash Controller DMA */
-#define IRQ_MS		30	/* MemoryStick Controller */
-#define IRQ_MS_DMA	31	/* MemoryStick Controller DMA */
-#define IRQ_UART0	32	/* UART 0 */
-#define IRQ_UART1	33	/* UART 1 */
-#define IRQ_I2S		34	/* I2S */
-#define IRQ_PCM		35	/* PCM */
-#define IRQ_PMCOS0	36	/* PMC OS Timer 0 */
-#define IRQ_PMCOS1	37	/* PMC OS Timer 1 */
-#define IRQ_PMCOS2	38	/* PMC OS Timer 2 */
-#define IRQ_PMCOS3	39	/* PMC OS Timer 3 */
-#define IRQ_VPU		40	/* Video Processing Unit */
-#define IRQ_VID		41	/* Video Digital Input Interface */
-#define IRQ_AC97	42	/* AC97 Interface */
-#define IRQ_EHCI	43	/* USB */
-#define IRQ_NOR		44	/* NOR Flash Controller */
-#define IRQ_PS2MOUSE	45	/* PS/2 Mouse */
-#define IRQ_PS2KBD	46	/* PS/2 Keyboard */
-#define IRQ_UART2	47	/* UART 2 */
-#define IRQ_RTC		48	/* RTC Interrupt */
-#define IRQ_RTCSM	49	/* RTC Second/Minute Update Interrupt */
-#define IRQ_UART3	50	/* UART 3 */
-#define IRQ_ADC		51	/* ADC */
-#define IRQ_EXT5	52	/* External Interrupt 5 */
-#define IRQ_EXT6	53	/* External Interrupt 6 */
-#define IRQ_EXT7	54	/* External Interrupt 7 */
-#define IRQ_CIR		55	/* CIR */
-#define IRQ_DMA0	56	/* DMA Channel 0 */
-#define IRQ_DMA1	57	/* DMA Channel 1 */
-#define IRQ_DMA2	58	/* DMA Channel 2 */
-#define IRQ_DMA3	59	/* DMA Channel 3 */
-#define IRQ_DMA4	60	/* DMA Channel 4 */
-#define IRQ_DMA5	61	/* DMA Channel 5 */
-#define IRQ_DMA6	62	/* DMA Channel 6 */
-#define IRQ_DMA7	63	/* DMA Channel 7 */
-
-#define VT8500_NR_IRQS		64
diff --git a/arch/arm/mach-vt8500/include/mach/vt8500_regs.h b/arch/arm/mach-vt8500/include/mach/vt8500_regs.h
deleted file mode 100644
index 29c63ec..0000000
--- a/arch/arm/mach-vt8500/include/mach/vt8500_regs.h
+++ /dev/null
@@ -1,79 +0,0 @@
-/*
- *  arch/arm/mach-vt8500/include/mach/vt8500_regs.h
- *
- *  Copyright (C) 2010 Alexey Charkov <alchark@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- */
-#ifndef __ASM_ARM_ARCH_VT8500_REGS_H
-#define __ASM_ARM_ARCH_VT8500_REGS_H
-
-/* VT8500 Registers Map */
-
-#define VT8500_REGS_START_PHYS	0xd8000000	/* Start of MMIO registers */
-#define VT8500_REGS_START_VIRT	0xf8000000	/* Virtual mapping start */
-
-#define VT8500_DDR_BASE		0xd8000000	/* 1k	DDR/DDR2 Memory
-							Controller */
-#define VT8500_DMA_BASE		0xd8001000	/* 1k	DMA Controller */
-#define VT8500_SFLASH_BASE	0xd8002000	/* 1k	Serial Flash Memory
-							Controller */
-#define VT8500_ETHER_BASE	0xd8004000	/* 1k	Ethernet MAC 0 */
-#define VT8500_CIPHER_BASE	0xd8006000	/* 4k	Cipher */
-#define VT8500_USB_BASE		0xd8007800	/* 2k	USB OTG */
-# define VT8500_EHCI_BASE	0xd8007900	/*	EHCI */
-# define VT8500_UHCI_BASE	0xd8007b01	/*	UHCI */
-#define VT8500_PATA_BASE	0xd8008000	/* 512	PATA */
-#define VT8500_PS2_BASE		0xd8008800	/* 1k	PS/2 */
-#define VT8500_NAND_BASE	0xd8009000	/* 1k	NAND Controller */
-#define VT8500_NOR_BASE		0xd8009400	/* 1k	NOR Controller */
-#define VT8500_SDMMC_BASE	0xd800a000	/* 1k	SD/MMC Controller */
-#define VT8500_MS_BASE		0xd800b000	/* 1k	MS/MSPRO Controller */
-#define VT8500_LCDC_BASE	0xd800e400	/* 1k	LCD Controller */
-#define VT8500_VPU_BASE		0xd8050000	/* 256	VPU */
-#define VT8500_GOV_BASE		0xd8050300	/* 256	GOV */
-#define VT8500_GEGEA_BASE	0xd8050400	/* 768	GE/GE Alpha Mixing */
-#define VT8500_LCDF_BASE	0xd8050900	/* 256	LCD Formatter */
-#define VT8500_VID_BASE		0xd8050a00	/* 256	VID */
-#define VT8500_VPP_BASE		0xd8050b00	/* 256	VPP */
-#define VT8500_TSBK_BASE	0xd80f4000	/* 4k	TSBK */
-#define VT8500_JPEGDEC_BASE	0xd80fe000	/* 4k	JPEG Decoder */
-#define VT8500_JPEGENC_BASE	0xd80ff000	/* 4k	JPEG Encoder */
-#define VT8500_RTC_BASE		0xd8100000	/* 64k	RTC */
-#define VT8500_GPIO_BASE	0xd8110000	/* 64k	GPIO Configuration */
-#define VT8500_SCC_BASE		0xd8120000	/* 64k	System Configuration*/
-#define VT8500_PMC_BASE		0xd8130000	/* 64k	PMC Configuration */
-#define VT8500_IC_BASE		0xd8140000	/* 64k	Interrupt Controller*/
-#define VT8500_UART0_BASE	0xd8200000	/* 64k	UART 0 */
-#define VT8500_UART2_BASE	0xd8210000	/* 64k	UART 2 */
-#define VT8500_PWM_BASE		0xd8220000	/* 64k	PWM Configuration */
-#define VT8500_SPI0_BASE	0xd8240000	/* 64k	SPI 0 */
-#define VT8500_SPI1_BASE	0xd8250000	/* 64k	SPI 1 */
-#define VT8500_CIR_BASE		0xd8270000	/* 64k	CIR */
-#define VT8500_I2C0_BASE	0xd8280000	/* 64k	I2C 0 */
-#define VT8500_AC97_BASE	0xd8290000	/* 64k	AC97 */
-#define VT8500_SPI2_BASE	0xd82a0000	/* 64k	SPI 2 */
-#define VT8500_UART1_BASE	0xd82b0000	/* 64k	UART 1 */
-#define VT8500_UART3_BASE	0xd82c0000	/* 64k	UART 3 */
-#define VT8500_PCM_BASE		0xd82d0000	/* 64k	PCM */
-#define VT8500_I2C1_BASE	0xd8320000	/* 64k	I2C 1 */
-#define VT8500_I2S_BASE		0xd8330000	/* 64k	I2S */
-#define VT8500_ADC_BASE		0xd8340000	/* 64k	ADC */
-
-#define VT8500_REGS_END_PHYS	0xd834ffff	/* End of MMIO registers */
-#define VT8500_REGS_LENGTH	(VT8500_REGS_END_PHYS \
-				- VT8500_REGS_START_PHYS + 1)
-
-#endif
diff --git a/arch/arm/mach-vt8500/include/mach/wm8505_irqs.h b/arch/arm/mach-vt8500/include/mach/wm8505_irqs.h
deleted file mode 100644
index 6128627..0000000
--- a/arch/arm/mach-vt8500/include/mach/wm8505_irqs.h
+++ /dev/null
@@ -1,115 +0,0 @@
-/*
- *  arch/arm/mach-vt8500/include/mach/wm8505_irqs.h
- *
- *  Copyright (C) 2010 Alexey Charkov <alchark@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- */
-
-/* WM8505 Interrupt Sources */
-
-#define IRQ_UHCI	0	/* UHC FS (UHCI?) */
-#define IRQ_EHCI	1	/* UHC HS */
-#define IRQ_UDCDMA	2	/* UDC DMA */
-				/* Reserved */
-#define IRQ_PS2MOUSE	4	/* PS/2 Mouse */
-#define IRQ_UDC		5	/* UDC */
-#define IRQ_EXT0	6	/* External Interrupt 0 */
-#define IRQ_EXT1	7	/* External Interrupt 1 */
-#define IRQ_KEYPAD	8	/* Keypad */
-#define IRQ_DMA		9	/* DMA Controller */
-#define IRQ_ETHER	10	/* Ethernet MAC */
-				/* Reserved */
-				/* Reserved */
-#define IRQ_EXT2	13	/* External Interrupt 2 */
-#define IRQ_EXT3	14	/* External Interrupt 3 */
-#define IRQ_EXT4	15	/* External Interrupt 4 */
-#define IRQ_APB		16	/* APB Bridge */
-#define IRQ_DMA0	17	/* DMA Channel 0 */
-#define IRQ_I2C1	18	/* I2C 1 */
-#define IRQ_I2C0	19	/* I2C 0 */
-#define IRQ_SDMMC	20	/* SD/MMC Controller */
-#define IRQ_SDMMC_DMA	21	/* SD/MMC Controller DMA */
-#define IRQ_PMC_WU	22	/* Power Management Controller Wakeup */
-#define IRQ_PS2KBD	23	/* PS/2 Keyboard */
-#define IRQ_SPI0	24	/* SPI 0 */
-#define IRQ_SPI1	25	/* SPI 1 */
-#define IRQ_SPI2	26	/* SPI 2 */
-#define IRQ_DMA1	27	/* DMA Channel 1 */
-#define IRQ_NAND	28	/* NAND Flash Controller */
-#define IRQ_NAND_DMA	29	/* NAND Flash Controller DMA */
-#define IRQ_UART5	30	/* UART 5 */
-#define IRQ_UART4	31	/* UART 4 */
-#define IRQ_UART0	32	/* UART 0 */
-#define IRQ_UART1	33	/* UART 1 */
-#define IRQ_DMA2	34	/* DMA Channel 2 */
-#define IRQ_I2S		35	/* I2S */
-#define IRQ_PMCOS0	36	/* PMC OS Timer 0 */
-#define IRQ_PMCOS1	37	/* PMC OS Timer 1 */
-#define IRQ_PMCOS2	38	/* PMC OS Timer 2 */
-#define IRQ_PMCOS3	39	/* PMC OS Timer 3 */
-#define IRQ_DMA3	40	/* DMA Channel 3 */
-#define IRQ_DMA4	41	/* DMA Channel 4 */
-#define IRQ_AC97	42	/* AC97 Interface */
-				/* Reserved */
-#define IRQ_NOR		44	/* NOR Flash Controller */
-#define IRQ_DMA5	45	/* DMA Channel 5 */
-#define IRQ_DMA6	46	/* DMA Channel 6 */
-#define IRQ_UART2	47	/* UART 2 */
-#define IRQ_RTC		48	/* RTC Interrupt */
-#define IRQ_RTCSM	49	/* RTC Second/Minute Update Interrupt */
-#define IRQ_UART3	50	/* UART 3 */
-#define IRQ_DMA7	51	/* DMA Channel 7 */
-#define IRQ_EXT5	52	/* External Interrupt 5 */
-#define IRQ_EXT6	53	/* External Interrupt 6 */
-#define IRQ_EXT7	54	/* External Interrupt 7 */
-#define IRQ_CIR		55	/* CIR */
-#define IRQ_SIC0	56	/* SIC IRQ0 */
-#define IRQ_SIC1	57	/* SIC IRQ1 */
-#define IRQ_SIC2	58	/* SIC IRQ2 */
-#define IRQ_SIC3	59	/* SIC IRQ3 */
-#define IRQ_SIC4	60	/* SIC IRQ4 */
-#define IRQ_SIC5	61	/* SIC IRQ5 */
-#define IRQ_SIC6	62	/* SIC IRQ6 */
-#define IRQ_SIC7	63	/* SIC IRQ7 */
-				/* Reserved */
-#define IRQ_JPEGDEC	65	/* JPEG Decoder */
-#define IRQ_SAE		66	/* SAE (?) */
-				/* Reserved */
-#define IRQ_VPU		79	/* Video Processing Unit */
-#define IRQ_VPP		80	/* Video Post-Processor */
-#define IRQ_VID		81	/* Video Digital Input Interface */
-#define IRQ_SPU		82	/* SPU (?) */
-#define IRQ_PIP		83	/* PIP Error */
-#define IRQ_GE		84	/* Graphic Engine */
-#define IRQ_GOV		85	/* Graphic Overlay Engine */
-#define IRQ_DVO		86	/* Digital Video Output */
-				/* Reserved */
-#define IRQ_DMA8	92	/* DMA Channel 8 */
-#define IRQ_DMA9	93	/* DMA Channel 9 */
-#define IRQ_DMA10	94	/* DMA Channel 10 */
-#define IRQ_DMA11	95	/* DMA Channel 11 */
-#define IRQ_DMA12	96	/* DMA Channel 12 */
-#define IRQ_DMA13	97	/* DMA Channel 13 */
-#define IRQ_DMA14	98	/* DMA Channel 14 */
-#define IRQ_DMA15	99	/* DMA Channel 15 */
-				/* Reserved */
-#define IRQ_GOVW	111	/* GOVW (?) */
-#define IRQ_GOVRSDSCD	112	/* GOVR SDSCD (?) */
-#define IRQ_GOVRSDMIF	113	/* GOVR SDMIF (?) */
-#define IRQ_GOVRHDSCD	114	/* GOVR HDSCD (?) */
-#define IRQ_GOVRHDMIF	115	/* GOVR HDMIF (?) */
-
-#define WM8505_NR_IRQS		116
diff --git a/arch/arm/mach-vt8500/include/mach/wm8505_regs.h b/arch/arm/mach-vt8500/include/mach/wm8505_regs.h
deleted file mode 100644
index df15509..0000000
--- a/arch/arm/mach-vt8500/include/mach/wm8505_regs.h
+++ /dev/null
@@ -1,78 +0,0 @@
-/*
- *  arch/arm/mach-vt8500/include/mach/wm8505_regs.h
- *
- *  Copyright (C) 2010 Alexey Charkov <alchark@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- */
-#ifndef __ASM_ARM_ARCH_WM8505_REGS_H
-#define __ASM_ARM_ARCH_WM8505_REGS_H
-
-/* WM8505 Registers Map */
-
-#define WM8505_REGS_START_PHYS	0xd8000000	/* Start of MMIO registers */
-#define WM8505_REGS_START_VIRT	0xf8000000	/* Virtual mapping start */
-
-#define WM8505_DDR_BASE		0xd8000400	/* 1k	DDR/DDR2 Memory
-							Controller */
-#define WM8505_DMA_BASE		0xd8001800	/* 1k	DMA Controller */
-#define WM8505_VDMA_BASE	0xd8001c00	/* 1k	VDMA */
-#define WM8505_SFLASH_BASE	0xd8002000	/* 1k	Serial Flash Memory
-							Controller */
-#define WM8505_ETHER_BASE	0xd8004000	/* 1k	Ethernet MAC 0 */
-#define WM8505_CIPHER_BASE	0xd8006000	/* 4k	Cipher */
-#define WM8505_USB_BASE		0xd8007000	/* 2k	USB 2.0 Host */
-# define WM8505_EHCI_BASE	0xd8007100	/*	EHCI */
-# define WM8505_UHCI_BASE	0xd8007301	/*	UHCI */
-#define WM8505_PS2_BASE		0xd8008800	/* 1k	PS/2 */
-#define WM8505_NAND_BASE	0xd8009000	/* 1k	NAND Controller */
-#define WM8505_NOR_BASE		0xd8009400	/* 1k	NOR Controller */
-#define WM8505_SDMMC_BASE	0xd800a000	/* 1k	SD/MMC Controller */
-#define WM8505_VPU_BASE		0xd8050000	/* 256	VPU */
-#define WM8505_GOV_BASE		0xd8050300	/* 256	GOV */
-#define WM8505_GEGEA_BASE	0xd8050400	/* 768	GE/GE Alpha Mixing */
-#define WM8505_GOVR_BASE	0xd8050800	/* 512	GOVR (frambuffer) */
-#define WM8505_VID_BASE		0xd8050a00	/* 256	VID */
-#define WM8505_SCL_BASE		0xd8050d00	/* 256	SCL */
-#define WM8505_VPP_BASE		0xd8050f00	/* 256	VPP */
-#define WM8505_JPEGDEC_BASE	0xd80fe000	/* 4k	JPEG Decoder */
-#define WM8505_RTC_BASE		0xd8100000	/* 64k	RTC */
-#define WM8505_GPIO_BASE	0xd8110000	/* 64k	GPIO Configuration */
-#define WM8505_SCC_BASE		0xd8120000	/* 64k	System Configuration*/
-#define WM8505_PMC_BASE		0xd8130000	/* 64k	PMC Configuration */
-#define WM8505_IC_BASE		0xd8140000	/* 64k	Interrupt Controller*/
-#define WM8505_SIC_BASE		0xd8150000	/* 64k	Secondary IC */
-#define WM8505_UART0_BASE	0xd8200000	/* 64k	UART 0 */
-#define WM8505_UART2_BASE	0xd8210000	/* 64k	UART 2 */
-#define WM8505_PWM_BASE		0xd8220000	/* 64k	PWM Configuration */
-#define WM8505_SPI0_BASE	0xd8240000	/* 64k	SPI 0 */
-#define WM8505_SPI1_BASE	0xd8250000	/* 64k	SPI 1 */
-#define WM8505_KEYPAD_BASE	0xd8260000	/* 64k	Keypad control */
-#define WM8505_CIR_BASE		0xd8270000	/* 64k	CIR */
-#define WM8505_I2C0_BASE	0xd8280000	/* 64k	I2C 0 */
-#define WM8505_AC97_BASE	0xd8290000	/* 64k	AC97 */
-#define WM8505_SPI2_BASE	0xd82a0000	/* 64k	SPI 2 */
-#define WM8505_UART1_BASE	0xd82b0000	/* 64k	UART 1 */
-#define WM8505_UART3_BASE	0xd82c0000	/* 64k	UART 3 */
-#define WM8505_I2C1_BASE	0xd8320000	/* 64k	I2C 1 */
-#define WM8505_I2S_BASE		0xd8330000	/* 64k	I2S */
-#define WM8505_UART4_BASE	0xd8370000	/* 64k	UART 4 */
-#define WM8505_UART5_BASE	0xd8380000	/* 64k	UART 5 */
-
-#define WM8505_REGS_END_PHYS	0xd838ffff	/* End of MMIO registers */
-#define WM8505_REGS_LENGTH	(WM8505_REGS_END_PHYS \
-				- WM8505_REGS_START_PHYS + 1)
-
-#endif
diff --git a/arch/arm/mach-vt8500/irq.c b/arch/arm/mach-vt8500/irq.c
index 642de04..f8f9ab9 100644
--- a/arch/arm/mach-vt8500/irq.c
+++ b/arch/arm/mach-vt8500/irq.c
@@ -1,6 +1,7 @@
 /*
  *  arch/arm/mach-vt8500/irq.c
  *
+ *  Copyright (C) 2012 Tony Prisk <linux@prisktech.co.nz>
  *  Copyright (C) 2010 Alexey Charkov <alchark@gmail.com>
  *
  * This program is free software; you can redistribute it and/or modify
@@ -18,81 +19,102 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
+/*
+ * This file is copied and modified from the original irq.c provided by
+ * Alexey Charkov. Minor changes have been made for Device Tree Support.
+ */
+
+#include <linux/slab.h>
 #include <linux/io.h>
 #include <linux/irq.h>
+#include <linux/irqdomain.h>
 #include <linux/interrupt.h>
+#include <linux/bitops.h>
+
+#include <linux/of.h>
+#include <linux/of_irq.h>
+#include <linux/of_address.h>
 
 #include <asm/irq.h>
 
-#include "devices.h"
 
-#define VT8500_IC_DCTR		0x40		/* Destination control
-						register, 64*u8 */
-#define VT8500_INT_ENABLE	(1 << 3)
-#define VT8500_TRIGGER_HIGH	(0 << 4)
-#define VT8500_TRIGGER_RISING	(1 << 4)
-#define VT8500_TRIGGER_FALLING	(2 << 4)
+#define VT8500_ICPC_IRQ		0x20
+#define VT8500_ICPC_FIQ		0x24
+#define VT8500_ICDC		0x40		/* Destination Control 64*u32 */
+#define VT8500_ICIS		0x80		/* Interrupt status, 16*u32 */
+
+/* ICPC */
+#define ICPC_MASK		0x3F
+#define ICPC_ROTATE		BIT(6)
+
+/* IC_DCTR */
+#define ICDC_IRQ		0x00
+#define ICDC_FIQ		0x01
+#define ICDC_DSS0		0x02
+#define ICDC_DSS1		0x03
+#define ICDC_DSS2		0x04
+#define ICDC_DSS3		0x05
+#define ICDC_DSS4		0x06
+#define ICDC_DSS5		0x07
+
+#define VT8500_INT_DISABLE	0
+#define VT8500_INT_ENABLE	BIT(3)
+
+#define VT8500_TRIGGER_HIGH	0
+#define VT8500_TRIGGER_RISING	BIT(5)
+#define VT8500_TRIGGER_FALLING	BIT(6)
 #define VT8500_EDGE		( VT8500_TRIGGER_RISING \
 				| VT8500_TRIGGER_FALLING)
-#define VT8500_IC_STATUS	0x80		/* Interrupt status, 2*u32 */
 
-static void __iomem *ic_regbase;
-static void __iomem *sic_regbase;
+static int irq_cnt;
+
+struct vt8500_irq_priv {
+	void __iomem *base;
+};
 
 static void vt8500_irq_mask(struct irq_data *d)
 {
-	void __iomem *base = ic_regbase;
-	unsigned irq = d->irq;
+	struct vt8500_irq_priv *priv =
+			(struct vt8500_irq_priv *)(d->domain->host_data);
+	void __iomem *base = priv->base;
 	u8 edge;
 
-	if (irq >= 64) {
-		base = sic_regbase;
-		irq -= 64;
-	}
-	edge = readb(base + VT8500_IC_DCTR + irq) & VT8500_EDGE;
+	edge = readb(base + VT8500_ICDC + d->hwirq) & VT8500_EDGE;
 	if (edge) {
-		void __iomem *stat_reg = base + VT8500_IC_STATUS
-						+ (irq < 32 ? 0 : 4);
+		void __iomem *stat_reg = base + VT8500_ICIS
+						+ (d->hwirq < 32 ? 0 : 4);
 		unsigned status = readl(stat_reg);
 
-		status |= (1 << (irq & 0x1f));
+		status |= (1 << (d->hwirq & 0x1f));
 		writel(status, stat_reg);
 	} else {
-		u8 dctr = readb(base + VT8500_IC_DCTR + irq);
+		u8 dctr = readb(base + VT8500_ICDC + d->hwirq);
 
 		dctr &= ~VT8500_INT_ENABLE;
-		writeb(dctr, base + VT8500_IC_DCTR + irq);
+		writeb(dctr, base + VT8500_ICDC + d->hwirq);
 	}
 }
 
 static void vt8500_irq_unmask(struct irq_data *d)
 {
-	void __iomem *base = ic_regbase;
-	unsigned irq = d->irq;
+	struct vt8500_irq_priv *priv =
+			(struct vt8500_irq_priv *)(d->domain->host_data);
+	void __iomem *base = priv->base;
 	u8 dctr;
 
-	if (irq >= 64) {
-		base = sic_regbase;
-		irq -= 64;
-	}
-	dctr = readb(base + VT8500_IC_DCTR + irq);
+	dctr = readb(base + VT8500_ICDC + d->hwirq);
 	dctr |= VT8500_INT_ENABLE;
-	writeb(dctr, base + VT8500_IC_DCTR + irq);
+	writeb(dctr, base + VT8500_ICDC + d->hwirq);
 }
 
 static int vt8500_irq_set_type(struct irq_data *d, unsigned int flow_type)
 {
-	void __iomem *base = ic_regbase;
-	unsigned irq = d->irq;
-	unsigned orig_irq = irq;
+	struct vt8500_irq_priv *priv =
+			(struct vt8500_irq_priv *)(d->domain->host_data);
+	void __iomem *base = priv->base;
 	u8 dctr;
 
-	if (irq >= 64) {
-		base = sic_regbase;
-		irq -= 64;
-	}
-
-	dctr = readb(base + VT8500_IC_DCTR + irq);
+	dctr = readb(base + VT8500_ICDC + d->hwirq);
 	dctr &= ~VT8500_EDGE;
 
 	switch (flow_type) {
@@ -100,18 +122,18 @@ static int vt8500_irq_set_type(struct irq_data *d, unsigned int flow_type)
 		return -EINVAL;
 	case IRQF_TRIGGER_HIGH:
 		dctr |= VT8500_TRIGGER_HIGH;
-		__irq_set_handler_locked(orig_irq, handle_level_irq);
+		__irq_set_handler_locked(d->irq, handle_level_irq);
 		break;
 	case IRQF_TRIGGER_FALLING:
 		dctr |= VT8500_TRIGGER_FALLING;
-		__irq_set_handler_locked(orig_irq, handle_edge_irq);
+		__irq_set_handler_locked(d->irq, handle_edge_irq);
 		break;
 	case IRQF_TRIGGER_RISING:
 		dctr |= VT8500_TRIGGER_RISING;
-		__irq_set_handler_locked(orig_irq, handle_edge_irq);
+		__irq_set_handler_locked(d->irq, handle_edge_irq);
 		break;
 	}
-	writeb(dctr, base + VT8500_IC_DCTR + irq);
+	writeb(dctr, base + VT8500_ICDC + d->hwirq);
 
 	return 0;
 }
@@ -124,57 +146,76 @@ static struct irq_chip vt8500_irq_chip = {
 	.irq_set_type = vt8500_irq_set_type,
 };
 
-void __init vt8500_init_irq(void)
+static void __init vt8500_init_irq_hw(void __iomem *base)
 {
 	unsigned int i;
 
-	ic_regbase = ioremap(wmt_ic_base, SZ_64K);
+	/* Enable rotating priority for IRQ */
+	writel(ICPC_ROTATE, base + VT8500_ICPC_IRQ);
+	writel(0x00, base + VT8500_ICPC_FIQ);
 
-	if (ic_regbase) {
-		/* Enable rotating priority for IRQ */
-		writel((1 << 6), ic_regbase + 0x20);
-		writel(0, ic_regbase + 0x24);
+	for (i = 0; i < 64; i++) {
+		/* Disable all interrupts and route them to IRQ */
+		writeb(VT8500_INT_DISABLE | ICDC_IRQ,
+						base + VT8500_ICDC + i);
+	}
+}
 
-		for (i = 0; i < wmt_nr_irqs; i++) {
-			/* Disable all interrupts and route them to IRQ */
-			writeb(0x00, ic_regbase + VT8500_IC_DCTR + i);
+static int vt8500_irq_map(struct irq_domain *h, unsigned int virq,
+							irq_hw_number_t hw)
+{
+	irq_set_chip_and_handler(virq, &vt8500_irq_chip, handle_level_irq);
+	set_irq_flags(virq, IRQF_VALID);
 
-			irq_set_chip_and_handler(i, &vt8500_irq_chip,
-						 handle_level_irq);
-			set_irq_flags(i, IRQF_VALID);
-		}
-	} else {
-		printk(KERN_ERR "Unable to remap the Interrupt Controller registers, not enabling IRQs!\n");
-	}
+	return 0;
 }
 
-void __init wm8505_init_irq(void)
+static struct irq_domain_ops vt8500_irq_domain_ops = {
+	.map = vt8500_irq_map,
+	.xlate = irq_domain_xlate_onecell,
+};
+
+int __init vt8500_irq_init(struct device_node *node, struct device_node *parent)
 {
-	unsigned int i;
+	struct irq_domain *vt8500_irq_domain;
+	struct vt8500_irq_priv *priv;
+	int irq, i;
+	struct device_node *np = node;
+
+	priv = kzalloc(sizeof(struct vt8500_irq_priv), GFP_KERNEL);
+	priv->base = of_iomap(np, 0);
+
+	vt8500_irq_domain = irq_domain_add_legacy(node, 64, irq_cnt, 0,
+				&vt8500_irq_domain_ops, priv);
+	if (!vt8500_irq_domain)
+		pr_err("%s: Unable to add wmt irq domain!\n", __func__);
+
+	irq_set_default_host(vt8500_irq_domain);
+
+	vt8500_init_irq_hw(priv->base);
 
-	ic_regbase = ioremap(wmt_ic_base, SZ_64K);
-	sic_regbase = ioremap(wmt_sic_base, SZ_64K);
-
-	if (ic_regbase && sic_regbase) {
-		/* Enable rotating priority for IRQ */
-		writel((1 << 6), ic_regbase + 0x20);
-		writel(0, ic_regbase + 0x24);
-		writel((1 << 6), sic_regbase + 0x20);
-		writel(0, sic_regbase + 0x24);
-
-		for (i = 0; i < wmt_nr_irqs; i++) {
-			/* Disable all interrupts and route them to IRQ */
-			if (i < 64)
-				writeb(0x00, ic_regbase + VT8500_IC_DCTR + i);
-			else
-				writeb(0x00, sic_regbase + VT8500_IC_DCTR
-								+ i - 64);
-
-			irq_set_chip_and_handler(i, &vt8500_irq_chip,
-						 handle_level_irq);
-			set_irq_flags(i, IRQF_VALID);
+	pr_info("Added IRQ Controller @ %x [virq_base = %d]\n",
+						(u32)(priv->base), irq_cnt);
+
+	/* check if this is a slaved controller */
+	if (of_irq_count(np) != 0) {
+		/* check that we have the correct number of interrupts */
+		if (of_irq_count(np) != 8) {
+			pr_err("%s: Incorrect IRQ map for slave controller\n",
+					__func__);
+			return -EINVAL;
 		}
-	} else {
-		printk(KERN_ERR "Unable to remap the Interrupt Controller registers, not enabling IRQs!\n");
+
+		for (i = 0; i < 8; i++) {
+			irq = irq_of_parse_and_map(np, i);
+			enable_irq(irq);
+		}
+
+		pr_info("vt8500-irq: Enabled slave->parent interrupts\n");
 	}
+
+	irq_cnt += 64;
+
+	return 0;
 }
+
diff --git a/arch/arm/mach-vt8500/restart.c b/arch/arm/mach-vt8500/restart.c
deleted file mode 100644
index 497e89a..0000000
--- a/arch/arm/mach-vt8500/restart.c
+++ /dev/null
@@ -1,54 +0,0 @@
-/* linux/arch/arm/mach-vt8500/restart.c
- *
- * Copyright (C) 2012 Tony Prisk <linux@prisktech.co.nz>
- *
- * This software is licensed under the terms of the GNU General Public
- * License version 2, as published by the Free Software Foundation, and
- * may be copied, distributed, and modified under those terms.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- */
-#include <asm/io.h>
-#include <linux/of.h>
-#include <linux/of_address.h>
-
-#define LEGACY_PMC_BASE		0xD8130000
-#define WMT_PRIZM_PMSR_REG	0x60
-
-static void __iomem *pmc_base;
-
-void wmt_setup_restart(void)
-{
-	struct device_node *np;
-
-	/*
-	 * Check if Power Mgmt Controller node is present in device tree. If no
-	 * device tree node, use the legacy PMSR value (valid for all current
-	 * SoCs).
-	 */
-	np = of_find_compatible_node(NULL, NULL, "wmt,prizm-pmc");
-	if (np) {
-		pmc_base = of_iomap(np, 0);
-
-		if (!pmc_base)
-			pr_err("%s:of_iomap(pmc) failed\n", __func__);
-
-		of_node_put(np);
-	} else {
-		pmc_base = ioremap(LEGACY_PMC_BASE, 0x1000);
-		if (!pmc_base) {
-			pr_err("%s:ioremap(rstc) failed\n", __func__);
-			return;
-		}
-	}
-}
-
-void wmt_restart(char mode, const char *cmd)
-{
-	if (pmc_base)
-		writel(1, pmc_base + WMT_PRIZM_PMSR_REG);
-}
diff --git a/arch/arm/mach-vt8500/timer.c b/arch/arm/mach-vt8500/timer.c
index d5376c5..050e183 100644
--- a/arch/arm/mach-vt8500/timer.c
+++ b/arch/arm/mach-vt8500/timer.c
@@ -1,6 +1,7 @@
 /*
- *  arch/arm/mach-vt8500/timer.c
+ *  arch/arm/mach-vt8500/timer_dt.c
  *
+ *  Copyright (C) 2012 Tony Prisk <linux@prisktech.co.nz>
  *  Copyright (C) 2010 Alexey Charkov <alchark@gmail.com>
  *
  * This program is free software; you can redistribute it and/or modify
@@ -18,18 +19,25 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
+/*
+ * This file is copied and modified from the original timer.c provided by
+ * Alexey Charkov. Minor changes have been made for Device Tree Support.
+ */
+
 #include <linux/io.h>
 #include <linux/irq.h>
 #include <linux/interrupt.h>
 #include <linux/clocksource.h>
 #include <linux/clockchips.h>
 #include <linux/delay.h>
-
 #include <asm/mach/time.h>
 
-#include "devices.h"
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
 
 #define VT8500_TIMER_OFFSET	0x0100
+#define VT8500_TIMER_HZ		3000000
 #define TIMER_MATCH_VAL		0x0000
 #define TIMER_COUNT_VAL		0x0010
 #define TIMER_STATUS_VAL	0x0014
@@ -39,7 +47,6 @@
 #define TIMER_COUNT_R_ACTIVE	(1 << 5)	/* not ready for read */
 #define TIMER_COUNT_W_ACTIVE	(1 << 4)	/* not ready for write */
 #define TIMER_MATCH_W_ACTIVE	(1 << 0)	/* not ready for write */
-#define VT8500_TIMER_HZ		3000000
 
 #define msecs_to_loops(t) (loops_per_jiffy / 1000 * HZ * t)
 
@@ -55,7 +62,7 @@ static cycle_t vt8500_timer_read(struct clocksource *cs)
 	return readl(regbase + TIMER_COUNT_VAL);
 }
 
-struct clocksource clocksource = {
+static struct clocksource clocksource = {
 	.name           = "vt8500_timer",
 	.rating         = 200,
 	.read           = vt8500_timer_read,
@@ -98,7 +105,7 @@ static void vt8500_timer_set_mode(enum clock_event_mode mode,
 	}
 }
 
-struct clock_event_device clockevent = {
+static struct clock_event_device clockevent = {
 	.name           = "vt8500_timer",
 	.features       = CLOCK_EVT_FEAT_ONESHOT,
 	.rating         = 200,
@@ -115,26 +122,51 @@ static irqreturn_t vt8500_timer_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-struct irqaction irq = {
+static struct irqaction irq = {
 	.name    = "vt8500_timer",
 	.flags   = IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
 	.handler = vt8500_timer_interrupt,
 	.dev_id  = &clockevent,
 };
 
-static void __init vt8500_timer_init(void)
+static struct of_device_id vt8500_timer_ids[] = {
+	{ .compatible = "via,vt8500-timer" },
+	{ }
+};
+
+void __init vt8500_timer_init(void)
 {
-	regbase = ioremap(wmt_pmc_base + VT8500_TIMER_OFFSET, 0x28);
-	if (!regbase)
-		printk(KERN_ERR "vt8500_timer_init: failed to map MMIO registers\n");
+	struct device_node *np;
+	int timer_irq;
+
+	np = of_find_matching_node(NULL, vt8500_timer_ids);
+	if (!np) {
+		pr_err("%s: Timer description missing from Device Tree\n",
+								__func__);
+		return;
+	}
+	regbase = of_iomap(np, 0);
+	if (!regbase) {
+		pr_err("%s: Missing iobase description in Device Tree\n",
+								__func__);
+		of_node_put(np);
+		return;
+	}
+	timer_irq = irq_of_parse_and_map(np, 0);
+	if (!timer_irq) {
+		pr_err("%s: Missing irq description in Device Tree\n",
+								__func__);
+		of_node_put(np);
+		return;
+	}
 
 	writel(1, regbase + TIMER_CTRL_VAL);
 	writel(0xf, regbase + TIMER_STATUS_VAL);
 	writel(~0, regbase + TIMER_MATCH_VAL);
 
 	if (clocksource_register_hz(&clocksource, VT8500_TIMER_HZ))
-		printk(KERN_ERR "vt8500_timer_init: clocksource_register failed for %s\n",
-					clocksource.name);
+		pr_err("%s: vt8500_timer_init: clocksource_register failed for %s\n",
+					__func__, clocksource.name);
 
 	clockevents_calc_mult_shift(&clockevent, VT8500_TIMER_HZ, 4);
 
@@ -144,12 +176,9 @@ static void __init vt8500_timer_init(void)
 	clockevent.min_delta_ns = clockevent_delta2ns(4, &clockevent);
 	clockevent.cpumask = cpumask_of(0);
 
-	if (setup_irq(wmt_timer_irq, &irq))
-		printk(KERN_ERR "vt8500_timer_init: setup_irq failed for %s\n",
-					clockevent.name);
+	if (setup_irq(timer_irq, &irq))
+		pr_err("%s: setup_irq failed for %s\n", __func__,
+							clockevent.name);
 	clockevents_register_device(&clockevent);
 }
 
-struct sys_timer vt8500_timer = {
-	.init = vt8500_timer_init
-};
diff --git a/arch/arm/mach-vt8500/vt8500.c b/arch/arm/mach-vt8500/vt8500.c
new file mode 100644
index 0000000..4494993
--- /dev/null
+++ b/arch/arm/mach-vt8500/vt8500.c
@@ -0,0 +1,196 @@
+/*
+ *  arch/arm/mach-vt8500/vt8500.c
+ *
+ *  Copyright (C) 2012 Tony Prisk <linux@prisktech.co.nz>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <linux/io.h>
+#include <linux/pm.h>
+
+#include <asm/mach-types.h>
+#include <asm/mach/arch.h>
+#include <asm/mach/time.h>
+#include <asm/mach/map.h>
+
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <linux/of_platform.h>
+
+#include <mach/restart.h>
+#include <mach/gpio.h>
+
+#include "common.h"
+
+#define LEGACY_GPIO_BASE	0xD8110000
+#define LEGACY_PMC_BASE		0xD8130000
+
+/* Registers in GPIO Controller */
+#define VT8500_GPIO_MUX_REG	0x200
+
+/* Registers in Power Management Controller */
+#define VT8500_HCR_REG		0x12
+#define VT8500_PMSR_REG		0x60
+
+static void __iomem *pmc_base;
+
+void vt8500_restart(char mode, const char *cmd)
+{
+	if (pmc_base)
+		writel(1, pmc_base + VT8500_PMSR_REG);
+}
+
+static struct map_desc vt8500_io_desc[] __initdata = {
+	/* SoC MMIO registers */
+	[0] = {
+		.virtual	= 0xf8000000,
+		.pfn		= __phys_to_pfn(0xd8000000),
+		.length		= 0x00390000, /* max of all chip variants */
+		.type		= MT_DEVICE
+	},
+};
+
+void __init vt8500_map_io(void)
+{
+	iotable_init(vt8500_io_desc, ARRAY_SIZE(vt8500_io_desc));
+}
+
+static void vt8500_power_off(void)
+{
+	local_irq_disable();
+	writew(5, pmc_base + VT8500_HCR_REG);
+	asm("mcr%? p15, 0, %0, c7, c0, 4" : : "r" (0));
+}
+
+void __init vt8500_init(void)
+{
+	struct device_node *np, *fb;
+	void __iomem *gpio_base;
+
+#ifdef CONFIG_FB_VT8500
+	fb = of_find_compatible_node(NULL, NULL, "via,vt8500-fb");
+	if (fb) {
+		np = of_find_compatible_node(NULL, NULL, "via,vt8500-gpio");
+		if (np) {
+			gpio_base = of_iomap(np, 0);
+
+			if (!gpio_base)
+				pr_err("%s: of_iomap(gpio_mux) failed\n",
+								__func__);
+
+			of_node_put(np);
+		} else {
+			gpio_base = ioremap(LEGACY_GPIO_BASE, 0x1000);
+			if (!gpio_base)
+				pr_err("%s: ioremap(legacy_gpio_mux) failed\n",
+								__func__);
+		}
+		if (gpio_base) {
+			writel(readl(gpio_base + VT8500_GPIO_MUX_REG) | 1,
+				gpio_base + VT8500_GPIO_MUX_REG);
+			iounmap(gpio_base);
+		} else
+			pr_err("%s: Could not remap GPIO mux\n", __func__);
+
+		of_node_put(fb);
+	}
+#endif
+
+#ifdef CONFIG_FB_WM8505
+	fb = of_find_compatible_node(NULL, NULL, "wm,wm8505-fb");
+	if (fb) {
+		np = of_find_compatible_node(NULL, NULL, "wm,wm8505-gpio");
+		if (!np)
+			np = of_find_compatible_node(NULL, NULL,
+							"wm,wm8650-gpio");
+		if (np) {
+			gpio_base = of_iomap(np, 0);
+
+			if (!gpio_base)
+				pr_err("%s: of_iomap(gpio_mux) failed\n",
+								__func__);
+
+			of_node_put(np);
+		} else {
+			gpio_base = ioremap(LEGACY_GPIO_BASE, 0x1000);
+			if (!gpio_base)
+				pr_err("%s: ioremap(legacy_gpio_mux) failed\n",
+								__func__);
+		}
+		if (gpio_base) {
+			writel(readl(gpio_base + VT8500_GPIO_MUX_REG) |
+				0x80000000, gpio_base + VT8500_GPIO_MUX_REG);
+			iounmap(gpio_base);
+		} else
+			pr_err("%s: Could not remap GPIO mux\n", __func__);
+
+		of_node_put(fb);
+	}
+#endif
+
+	np = of_find_compatible_node(NULL, NULL, "via,vt8500-pmc");
+	if (np) {
+		pmc_base = of_iomap(np, 0);
+
+		if (!pmc_base)
+			pr_err("%s:of_iomap(pmc) failed\n", __func__);
+
+		of_node_put(np);
+	} else {
+		pmc_base = ioremap(LEGACY_PMC_BASE, 0x1000);
+		if (!pmc_base)
+			pr_err("%s:ioremap(power_off) failed\n", __func__);
+	}
+	if (pmc_base)
+		pm_power_off = &vt8500_power_off;
+	else
+		pr_err("%s: PMC Hibernation register could not be remapped, not enabling power off!\n", __func__);
+
+	vtwm_clk_init(pmc_base);
+
+	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
+}
+
+static const struct of_device_id vt8500_irq_match[] __initconst = {
+	{ .compatible = "via,vt8500-intc", .data = vt8500_irq_init, },
+	{ /* sentinel */ },
+};
+
+static void __init vt8500_init_irq(void)
+{
+	of_irq_init(vt8500_irq_match);
+};
+
+static struct sys_timer vt8500_timer = {
+	.init = vt8500_timer_init,
+};
+
+static const char * const vt8500_dt_compat[] = {
+	"via,vt8500",
+	"wm,wm8650",
+	"wm,wm8505",
+};
+
+DT_MACHINE_START(WMT_DT, "VIA/Wondermedia SoC (Device Tree Support)")
+	.dt_compat	= vt8500_dt_compat,
+	.map_io		= vt8500_map_io,
+	.init_irq	= vt8500_init_irq,
+	.timer		= &vt8500_timer,
+	.init_machine	= vt8500_init,
+	.restart	= vt8500_restart,
+MACHINE_END
+
diff --git a/arch/arm/mach-vt8500/wm8505_7in.c b/arch/arm/mach-vt8500/wm8505_7in.c
deleted file mode 100644
index db19886..0000000
--- a/arch/arm/mach-vt8500/wm8505_7in.c
+++ /dev/null
@@ -1,79 +0,0 @@
-/*
- *  arch/arm/mach-vt8500/wm8505_7in.c
- *
- *  Copyright (C) 2010 Alexey Charkov <alchark@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- */
-
-#include <linux/io.h>
-#include <linux/pm.h>
-
-#include <asm/mach-types.h>
-#include <asm/mach/arch.h>
-#include <mach/restart.h>
-
-#include "devices.h"
-
-static void __iomem *pmc_hiber;
-
-static struct platform_device *devices[] __initdata = {
-	&vt8500_device_uart0,
-	&vt8500_device_ehci,
-	&vt8500_device_wm8505_fb,
-	&vt8500_device_ge_rops,
-	&vt8500_device_pwm,
-	&vt8500_device_pwmbl,
-	&vt8500_device_rtc,
-};
-
-static void vt8500_power_off(void)
-{
-	local_irq_disable();
-	writew(5, pmc_hiber);
-	asm("mcr%? p15, 0, %0, c7, c0, 4" : : "r" (0));
-}
-
-void __init wm8505_7in_init(void)
-{
-#ifdef CONFIG_FB_WM8505
-	void __iomem *gpio_mux_reg = ioremap(wmt_gpio_base + 0x200, 4);
-	if (gpio_mux_reg) {
-		writel(readl(gpio_mux_reg) | 0x80000000, gpio_mux_reg);
-		iounmap(gpio_mux_reg);
-	} else {
-		printk(KERN_ERR "Could not remap the GPIO mux register, display may not work properly!\n");
-	}
-#endif
-	pmc_hiber = ioremap(wmt_pmc_base + 0x12, 2);
-	if (pmc_hiber)
-		pm_power_off = &vt8500_power_off;
-	else
-		printk(KERN_ERR "PMC Hibernation register could not be remapped, not enabling power off!\n");
-	wmt_setup_restart();
-	wm8505_set_resources();
-	platform_add_devices(devices, ARRAY_SIZE(devices));
-	vt8500_gpio_init();
-}
-
-MACHINE_START(WM8505_7IN_NETBOOK, "WM8505 7-inch generic netbook")
-	.atag_offset	= 0x100,
-	.restart	= wmt_restart,
-	.reserve	= wm8505_reserve_mem,
-	.map_io		= wm8505_map_io,
-	.init_irq	= wm8505_init_irq,
-	.timer		= &vt8500_timer,
-	.init_machine	= wm8505_7in_init,
-MACHINE_END
-- 
1.7.9.5

