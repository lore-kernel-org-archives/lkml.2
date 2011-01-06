Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751565Ab1AFIAH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 03:00:07 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:50149 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241Ab1AFIAD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 03:00:03 -0500
From: "Guan Xuetao" <guanxuetao@mprc.pku.edu.cn>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <01de01cbad77$3dbed0a0$b93c71e0$@mprc.pku.edu.cn>
In-Reply-To: <01de01cbad77$3dbed0a0$b93c71e0$@mprc.pku.edu.cn>
Subject: RE: [PATCHv1 0/8] unicore32 machine related files: summary
Date: Thu, 6 Jan 2011 16:00:03 +0800
Message-ID: <01e001cbad77$b9afc9d0$2d0f5d70$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQD5q7uzdbzaRxzFKhxkjRMpQze/MJVnl4MQ
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCHv1 1/8] unicore32 machine related files: core files
From: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>

Patch 1 adds machine related  core files, also including build infrastructure.

Signed-off-by: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>
---
 arch/unicore32/kernel/puv3-core.c    |  266 ++++++++++++++++++++++++++++++++++
 arch/unicore32/kernel/puv3-nb0916.c  |  183 +++++++++++++++++++++++
 arch/unicore32/kernel/puv3-smw0919.c |  120 +++++++++++++++
 drivers/staging/puv3/Kconfig         |  142 ++++++++++++++++++
 drivers/staging/puv3/Makefile        |   27 ++++
 drivers/staging/puv3/TODO            |    7 +
 6 files changed, 745 insertions(+), 0 deletions(-)

diff --git a/arch/unicore32/kernel/puv3-core.c b/arch/unicore32/kernel/puv3-core.c
new file mode 100644
index 0000000..c5cc2f2
--- /dev/null
+++ b/arch/unicore32/kernel/puv3-core.c
@@ -0,0 +1,266 @@
+/*
+ *  linux/arch/unicore32/kernel/puv3-core.c
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ *	Maintained by GUAN Xue-tao <gxt@mprc.pku.edu.cn>
+ *	Copyright (C) 2001-2010 Guan Xuetao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Contributors & Additions/Fixes:
+ *	2009-04: First version by GUAN Xue-tao
+ *	2009-07-21: add uart resources definitions by HU Dong-liang
+ *
+ * TODO:
+ */
+
+#include <linux/init.h>
+#include <linux/device.h>
+#include <linux/sysdev.h>
+#include <linux/amba/bus.h>
+#include <linux/platform_device.h>
+#include <linux/io.h>
+
+#include <asm/mach/hardware.h>
+#include <asm/irq.h>
+#include <linux/cnt32_to_63.h>
+#include <linux/usb/musb.h>
+#include <asm/mach/pm.h>
+
+/*
+ * This is the PKUnity sched_clock implementation.  This has
+ * a resolution of 271ns, and a maximum value of 32025597s (370 days).
+ *
+ * The return value is guaranteed to be monotonic in that range as
+ * long as there is always less than 582 seconds between successive
+ * calls to this function.
+ *
+ *  ( * 1E9 / CLOCK_TICK_RATE ) -> about 2235/32
+ */
+unsigned long long sched_clock(void)
+{
+	unsigned long long v = cnt32_to_63(OST_OSCR);
+
+	/* original conservative method, but overflow frequently
+	 * v *= NSEC_PER_SEC >> 12;
+	 * do_div(v, CLOCK_TICK_RATE >> 12);
+	 */
+	v = ((v & 0x7fffffffffffffffULL) * 2235) >> 5;
+
+	return v;
+}
+
+static struct resource puv3_usb_resources[] = {
+	/* order is significant! */
+	{
+		.start		= PKUNITY_USB_BASE,
+		.end		= PKUNITY_USB_BASE + 0x3ff,
+		.flags		= IORESOURCE_MEM,
+	}, {
+		.start		= IRQ_USB,
+		.flags		= IORESOURCE_IRQ,
+	}, {
+		.start		= IRQ_USB,
+		.flags		= IORESOURCE_IRQ,
+	},
+};
+
+static struct musb_hdrc_config	puv3_usb_config[] = {
+	{
+		.num_eps = 16,
+		.multipoint = 1,
+#ifdef CONFIG_USB_INVENTRA_DMA
+		.dma = 1,
+		.dma_channels = 8,
+#endif
+	},
+};
+
+static struct musb_hdrc_platform_data puv3_usb_plat = {
+	.mode		= MUSB_HOST,
+	.min_power	= 100,
+	.clock		= 0,
+	.config		= puv3_usb_config,
+};
+
+static struct resource puv3_mmc_resources[] = {
+	[0] = {
+		.start	= PKUNITY_SDC_BASE,
+		.end	= PKUNITY_SDC_BASE + 0xfff,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.start	= IRQ_SDC,
+		.end	= IRQ_SDC,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct resource puv3_rtc_resources[] = {
+	[0] = {
+		.start = PKUNITY_RTC_BASE,
+		.end   = PKUNITY_RTC_BASE + 0xff,
+		.flags = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start = IRQ_RTCAlarm,
+		.end   = IRQ_RTCAlarm,
+		.flags = IORESOURCE_IRQ,
+	},
+	[2] = {
+		.start = IRQ_RTC,
+		.end   = IRQ_RTC,
+		.flags = IORESOURCE_IRQ
+	}
+};
+
+static struct resource puv3_pwm_resources[] = {
+	[0] = {
+		.start	= PKUNITY_OST_BASE + 0x80,
+		.end	= PKUNITY_OST_BASE + 0xff,
+		.flags	= IORESOURCE_MEM,
+	},
+};
+
+static struct resource puv3_uart0_resources[] = {
+	[0] = {
+		.start = PKUNITY_UART0_BASE,
+		.end   = PKUNITY_UART0_BASE + 0xff,
+		.flags = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start = IRQ_UART0,
+		.end   = IRQ_UART0,
+		.flags = IORESOURCE_IRQ
+	}
+};
+
+static struct resource puv3_uart1_resources[] = {
+	[0] = {
+		.start = PKUNITY_UART1_BASE,
+		.end   = PKUNITY_UART1_BASE + 0xff,
+		.flags = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start = IRQ_UART1,
+		.end   = IRQ_UART1,
+		.flags = IORESOURCE_IRQ
+	}
+};
+
+static struct resource puv3_umal_resources[] = {
+	[0] = {
+		.start = PKUNITY_UMAL_BASE,
+		.end   = PKUNITY_UMAL_BASE + 0x1fff,
+		.flags = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start = IRQ_UMAL,
+		.end   = IRQ_UMAL,
+		.flags = IORESOURCE_IRQ
+	}
+};
+
+#ifdef CONFIG_PUV3_PM
+
+#define SAVE(x)		sleep_save[SLEEP_SAVE_##x] = x
+#define RESTORE(x)	x = sleep_save[SLEEP_SAVE_##x]
+
+/*
+ * List of global PXA peripheral registers to preserve.
+ * More ones like CP and general purpose register values are preserved
+ * with the stack pointer in sleep.S.
+ */
+enum {
+	SLEEP_SAVE_PM_PLLDDRCFG,
+	SLEEP_SAVE_COUNT
+};
+
+
+static void puv3_cpu_pm_save(unsigned long *sleep_save)
+{
+/*	SAVE(PM_PLLDDRCFG); */
+}
+
+static void puv3_cpu_pm_restore(unsigned long *sleep_save)
+{
+/*	RESTORE(PM_PLLDDRCFG); */
+}
+
+static int puv3_cpu_pm_prepare(void)
+{
+	/* set resume return address */
+	PM_DIVCFG = virt_to_phys(puv3_cpu_resume);
+	return 0;
+}
+
+static void puv3_cpu_pm_enter(suspend_state_t state)
+{
+	/* Clear reset status */
+	RESETC_RSSR = RESETC_RSSR_HWR | RESETC_RSSR_WDR
+			| RESETC_RSSR_SMR | RESETC_RSSR_SWR;
+
+	switch (state) {
+/*	case PM_SUSPEND_ON:
+		puv3_cpu_idle();
+		break; */
+	case PM_SUSPEND_MEM:
+		puv3_cpu_pm_prepare();
+		puv3_cpu_suspend(PM_PMCR_SFB);
+		break;
+	}
+}
+
+static int puv3_cpu_pm_valid(suspend_state_t state)
+{
+	return state == PM_SUSPEND_MEM;
+}
+
+static void puv3_cpu_pm_finish(void)
+{
+	/* ensure not to come back here if it wasn't intended */
+	/* PSPR = 0; */
+}
+
+static struct puv3_cpu_pm_fns puv3_cpu_pm_fnss = {
+	.save_count	= SLEEP_SAVE_COUNT,
+	.valid		= puv3_cpu_pm_valid,
+	.save		= puv3_cpu_pm_save,
+	.restore	= puv3_cpu_pm_restore,
+	.enter		= puv3_cpu_pm_enter,
+	.prepare	= puv3_cpu_pm_prepare,
+	.finish		= puv3_cpu_pm_finish,
+};
+
+static void __init puv3_init_pm(void)
+{
+	puv3_cpu_pm_fns = &puv3_cpu_pm_fnss;
+}
+#else
+static inline void puv3_init_pm(void) {}
+#endif
+
+void __init puv3_core_init(void)
+{
+	puv3_init_pm();
+	platform_device_register_simple("PKUnity-v3-RTC", -1,
+			puv3_rtc_resources, ARRAY_SIZE(puv3_rtc_resources));
+	platform_device_register_simple("PKUnity-v3-UMAL", -1,
+			puv3_umal_resources, ARRAY_SIZE(puv3_umal_resources));
+	platform_device_register_simple("PKUnity-v3-MMC", -1,
+			puv3_mmc_resources, ARRAY_SIZE(puv3_mmc_resources));
+	platform_device_register_simple("PKUnity-v3-PWM", -1,
+			puv3_pwm_resources, ARRAY_SIZE(puv3_pwm_resources));
+	platform_device_register_simple("PKUnity-v3-UART", 0,
+			puv3_uart0_resources, ARRAY_SIZE(puv3_uart0_resources));
+	platform_device_register_simple("PKUnity-v3-UART", 1,
+			puv3_uart1_resources, ARRAY_SIZE(puv3_uart1_resources));
+	platform_device_register_simple("PKUnity-v3-AC97", -1, NULL, 0);
+	platform_device_register_resndata(&platform_bus, "musb_hdrc", -1,
+			puv3_usb_resources, ARRAY_SIZE(puv3_usb_resources),
+			&puv3_usb_plat, sizeof(puv3_usb_plat));
+}
+
diff --git a/arch/unicore32/kernel/puv3-nb0916.c b/arch/unicore32/kernel/puv3-nb0916.c
new file mode 100644
index 0000000..b5e48d4
--- /dev/null
+++ b/arch/unicore32/kernel/puv3-nb0916.c
@@ -0,0 +1,183 @@
+/*
+ * linux/arch/unicore32/kernel/puv3-nb0916.c
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ *	Maintained by GUAN Xue-tao <gxt@mprc.pku.edu.cn>
+ *	Copyright (C) 2001-2010 Guan Xuetao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Contributors & Additions/Fixes:
+ *	2009-07-02: add gpio key support by HUANG Tao
+ *	2009-05-14: add i2c board info support by ZHONG Qi
+ *	2009-05-10: First version by GUAN Xue-tao
+ *
+ * TODO:
+ */
+
+#include <linux/init.h>
+#include <linux/device.h>
+#include <linux/sysdev.h>
+#include <linux/platform_device.h>
+#include <linux/mtd/physmap.h>
+#include <linux/io.h>
+#include <linux/reboot.h>
+#include <linux/interrupt.h>
+#include <linux/i2c.h>
+#include <linux/pwm_backlight.h>
+#include <linux/gpio.h>
+
+#include <asm/mach/hardware.h>
+
+#include <linux/gpio_keys.h>
+#include <linux/input.h>
+
+static struct physmap_flash_data physmap_flash_data = {
+	.width		= 1,
+};
+
+static struct resource physmap_flash_resource = {
+	.start		= 0xFFF80000,
+	.end		= 0xFFFFFFFF,
+	.flags		= IORESOURCE_MEM,
+};
+
+static struct platform_device physmap_flash = {
+	.name		= "physmap-flash",
+	.id		= 0,
+	.dev		= {
+		.platform_data	= &physmap_flash_data,
+	},
+	.num_resources	= 1,
+	.resource	= &physmap_flash_resource,
+};
+
+static struct resource puv3_i2c_resources[] = {
+	[0] = {
+		.start = PKUNITY_I2C_BASE,
+		.end   = PKUNITY_I2C_BASE + 0xff,
+		.flags = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start = IRQ_I2C,
+		.end   = IRQ_I2C,
+		.flags = IORESOURCE_IRQ,
+	}
+};
+
+static struct platform_device puv3_device_i2c = {
+	.name	= "PKUnity-v3-I2C",
+	.id	= -1,
+	.num_resources	  = ARRAY_SIZE(puv3_i2c_resources),
+	.resource	  = puv3_i2c_resources,
+};
+
+static struct platform_pwm_backlight_data nb0916_backlight_data = {
+	.pwm_id		= 0,
+	.max_brightness	= 100,
+	.dft_brightness	= 100,
+	.pwm_period_ns	= 70 * 1024,
+};
+
+static struct platform_device nb0916_device_backlight = {
+	.name   = "pwm-backlight",
+	.id     = 0,
+	.dev    = {
+		.platform_data	= &nb0916_backlight_data,
+	},
+};
+
+static struct gpio_keys_button nb0916_gpio_keys[] = {
+	{
+		.type	= EV_KEY,
+		.code	= KEY_POWER,
+		.gpio	= GPI_SOFF_REQ,
+		.desc	= "Power Button",
+		.wakeup = 1,
+		.active_low = 1,
+	},
+	{
+		.type	= EV_KEY,
+		.code	= BTN_TOUCH,
+		.gpio	= GPI_BTN_TOUCH,
+		.desc	= "Touchpad Button",
+		.wakeup = 1,
+		.active_low = 1,
+	},
+};
+
+static struct gpio_keys_platform_data nb0916_gpio_button_data = {
+	.buttons	= nb0916_gpio_keys,
+	.nbuttons	= ARRAY_SIZE(nb0916_gpio_keys),
+};
+
+static struct platform_device nb0916_device_gpio_button = {
+	.name	= "gpio-keys",
+	.id	= -1,
+	.dev	= {
+		.platform_data = &nb0916_gpio_button_data,
+	},
+};
+
+static struct platform_device *mach_nb0916_devices[] __initdata = {
+	&puv3_device_i2c,
+	&physmap_flash,
+	&nb0916_device_backlight,
+	&nb0916_device_gpio_button,
+};
+
+static irqreturn_t nb0916_lcdcaseoff_handler(int irq, void *dev_id)
+{
+	if (gpio_get_value(GPI_LCD_CASE_OFF))
+		gpio_set_value(GPO_LCD_EN, 1);
+	else
+		gpio_set_value(GPO_LCD_EN, 0);
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t nb0916_overheat_handler(int irq, void *dev_id)
+{
+	machine_halt();
+	/* SYSTEM HALT, NO RETURN */
+	return IRQ_HANDLED;
+}
+
+static struct i2c_board_info __initdata puv3_i2c_devices[] = {
+	{	I2C_BOARD_INFO("lm75",		I2C_TAR_THERMAL),	},
+	{	I2C_BOARD_INFO("bq27200",	I2C_TAR_PWIC),		},
+	{	I2C_BOARD_INFO("24c02",		I2C_TAR_EEPROM),	},
+};
+
+int __init mach_nb0916_init(void)
+{
+	i2c_register_board_info(0, puv3_i2c_devices,
+			ARRAY_SIZE(puv3_i2c_devices));
+
+	platform_add_devices(mach_nb0916_devices,
+			ARRAY_SIZE(mach_nb0916_devices));
+
+	if (request_irq(gpio_to_irq(GPI_LCD_CASE_OFF),
+		&nb0916_lcdcaseoff_handler,
+		IRQF_DISABLED | IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
+		"NB0916 lcd case off", NULL) < 0) {
+
+		printk(KERN_DEBUG "LCD-Case-OFF IRQ %d not available\n",
+			gpio_to_irq(GPI_LCD_CASE_OFF));
+	}
+
+	if (request_irq(gpio_to_irq(GPI_OTP_INT), &nb0916_overheat_handler,
+		IRQF_DISABLED | IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
+		"NB0916 overheating protection", NULL) < 0) {
+
+		printk(KERN_DEBUG "Overheating Protection IRQ %d not available\n",
+			gpio_to_irq(GPI_OTP_INT));
+	}
+
+	return 0;
+}
+
+subsys_initcall_sync(mach_nb0916_init);
diff --git a/arch/unicore32/kernel/puv3-smw0919.c b/arch/unicore32/kernel/puv3-smw0919.c
new file mode 100644
index 0000000..bdf7ae2
--- /dev/null
+++ b/arch/unicore32/kernel/puv3-smw0919.c
@@ -0,0 +1,120 @@
+/*
+ * linux/arch/unicore32/kernel/puv3-smw0919.c
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ *	Maintained by GUAN Xue-tao <gxt@mprc.pku.edu.cn>
+ *	Copyright (C) 2001-2010 Guan Xuetao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Contributors & Additions/Fixes:
+ *	2009-07-23: First version by SU Yong-gang
+ *
+ * TODO:
+ */
+
+#include <linux/init.h>
+#include <linux/device.h>
+#include <linux/sysdev.h>
+#include <linux/platform_device.h>
+#include <linux/mtd/physmap.h>
+#include <linux/io.h>
+#include <linux/reboot.h>
+#include <linux/interrupt.h>
+#include <linux/i2c.h>
+#include <linux/gpio.h>
+#include <linux/gpio_keys.h>
+#include <linux/input.h>
+
+#include <mach/hardware.h>
+
+static struct physmap_flash_data physmap_flash_data = {
+	.width		= 1,
+};
+
+static struct resource physmap_flash_resource = {
+	.start		= 0xFFF80000,
+	.end		= 0xFFFFFFFF,
+	.flags		= IORESOURCE_MEM,
+};
+
+static struct platform_device physmap_flash = {
+	.name		= "physmap-flash",
+	.id		= 0,
+	.dev		= {
+		.platform_data	= &physmap_flash_data,
+	},
+	.num_resources	= 1,
+	.resource	= &physmap_flash_resource,
+};
+
+static struct resource puv3_i2c_resources[] = {
+	[0] = {
+		.start = PKUNITY_I2C_BASE,
+		.end   = PKUNITY_I2C_BASE + 0xff,
+		.flags = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start = IRQ_I2C,
+		.end   = IRQ_I2C,
+		.flags = IORESOURCE_IRQ,
+	}
+};
+
+static struct platform_device puv3_device_i2c = {
+	.name	= "PKUnity-v3-I2C",
+	.id	= -1,
+	.num_resources	  = ARRAY_SIZE(puv3_i2c_resources),
+	.resource	  = puv3_i2c_resources,
+};
+
+static struct gpio_keys_button smw0919_gpio_keys[] = {
+	{
+		.type	= EV_KEY,
+		.code	= KEY_POWER,
+		.gpio	= GPI_SOFF_REQ,
+		.desc	= "Power Button",
+		.wakeup = 1,
+		.active_low = 1,
+	},
+};
+
+static struct gpio_keys_platform_data smw0919_power_button_data = {
+	.buttons	= smw0919_gpio_keys,
+	.nbuttons	= ARRAY_SIZE(smw0919_gpio_keys),
+};
+
+static struct platform_device smw0919_device_power_button = {
+	.name	= "gpio-keys",
+	.id	= -1,
+	.dev	= {
+		.platform_data = &smw0919_power_button_data,
+	},
+};
+
+static struct platform_device *mach_smw0919_devices[] __initdata = {
+	&puv3_device_i2c,
+	&physmap_flash,
+	&smw0919_device_power_button,
+};
+
+static struct i2c_board_info __initdata puv3_i2c_devices[] = {
+	{	I2C_BOARD_INFO("lm75",		I2C_TAR_THERMAL),	},
+	{	I2C_BOARD_INFO("24c02",		I2C_TAR_EEPROM),	},
+};
+
+int __init mach_smw0919_init(void)
+{
+	i2c_register_board_info(0, puv3_i2c_devices,
+			ARRAY_SIZE(puv3_i2c_devices));
+
+	platform_add_devices(mach_smw0919_devices,
+			ARRAY_SIZE(mach_smw0919_devices));
+
+	return 0;
+}
+
+subsys_initcall_sync(mach_smw0919_init);
diff --git a/drivers/staging/puv3/Kconfig b/drivers/staging/puv3/Kconfig
new file mode 100644
index 0000000..54c876b
--- /dev/null
+++ b/drivers/staging/puv3/Kconfig
@@ -0,0 +1,142 @@
+#
+# PKUnity v3 Kconfig
+#
+
+if ARCH_PUV3
+
+menu "PKUnity v3 SoC Features"
+
+config PUV3_GPIO
+	bool
+	depends on !ARCH_FPGA
+	select GENERIC_GPIO
+	select GPIO_SYSFS if EXPERIMENTAL
+	default y
+
+config PUV3_PWM
+	tristate
+	default BACKLIGHT_PWM
+	help
+	  Enable support for NB0916 PWM controllers
+
+config PUV3_RTC
+	tristate "PKUnity v3 RTC Support"
+	depends on !ARCH_FPGA
+
+config PUV3_I2C
+	bool "PKUnity v3 I2C bus support"
+#	default y
+	select I2C
+	select I2C_CHARDEV
+	select I2C_ALGOBIT
+
+config PUV3_UMAL
+	tristate "PKUnity v3 UMAL Gigabit Network Adapter support"
+	select MII
+	select PHYLIB
+
+config PUV3_UNIGFX
+	tristate "PKUnity v3 Unigfx display support"
+	select FB
+	select FB_SYS_FILLRECT
+	select FB_SYS_COPYAREA
+	select FB_SYS_IMAGEBLIT
+	select FB_SYS_FOPS
+	help
+	  Choose this option if you want to use the Unigfx device as a
+	  framebuffer device. Without the support of PCI & AGP.
+
+config PUV3_UNIGFX_HWACCEL
+	bool "PKUnity v3 Unigfx hardware accelerator support"
+	depends on PUV3_UNIGFX
+
+config PUV3_AC97
+	tristate "PKUnity v3 AC97 driver support"
+	select SND_PCM
+	select SND_AC97_CODEC
+	help
+	  Say Y or M if you want to support any AC97 codec attached to
+	  the PKUnity AC97 interface.
+
+#config PUV3_MUSB
+#	bool "PKUnity v3 USB MUSBMHDRC Support"
+#	select USB_MUSB_HDRC_HCD
+#	select USB_MUSB_HOST
+#	select MUSB_PIO_ONLY
+#	select USB_INVENTRA_DMA
+
+#config PUV3_MMC
+#	tristate "PKUnity v3 MMC/SD Card support"
+#	select MMC
+
+#config PUV3_NAND
+#	tristate "PKUnity v3 NAND Flash support"
+#	select MTD
+#	select MTD_PARTITIONS
+#	select MTD_NAND
+#	select MTD_CHAR
+#	select MTD_BLOCK
+
+#config PUV3_NAND_CHIPNR
+#	int "PKUnity v3 NAND Flash Chip number (1-4)"
+#	range 1 4
+#	depends on PUV3_NAND
+#	default "1"
+
+#config PUV3_UART
+#	bool "PKUnity v3 serial port support"
+#	select SERIAL_CORE
+
+#config PUV3_UART_CONSOLE
+#	bool "Console on PKUnity serial port"
+#	depends on PUV3_UART
+#	select SERIAL_CORE_CONSOLE
+#	help
+#	  Even if you say Y here, the currently visible virtual console
+#	  (/dev/tty0) will still be used as the system console by default, but
+#	  you can alter that using a kernel command line option such as
+#	  "console=ttySA0". (Try "man bootparam" or see the documentation of
+#	  your boot loader (lilo or loadlin) about how to pass options to the
+#	  kernel at boot time.)
+
+#config PUV3_SPI
+#	bool "PKUnity v3 SPI controller support"
+#	select SPI
+#	select SPI_MASTER
+
+endmenu
+
+if PUV3_NB0916
+
+menu "PKUnity NetBook-0916 Features"
+
+config I2C_BATTERY_BQ27200
+	tristate "I2C Battery BQ27200 Support"
+	select PUV3_I2C
+	select POWER_SUPPLY
+	select BATTERY_BQ27x00
+
+config I2C_EEPROM_AT24
+	tristate "I2C EEPROMs AT24 support"
+	select PUV3_I2C
+	select MISC_DEVICES
+	select EEPROM_AT24
+
+config LCD_BACKLIGHT
+	tristate "LCD Backlight support"
+	select BACKLIGHT_LCD_SUPPORT
+	select BACKLIGHT_PWM
+
+#config USB_WLAN_HED_AQ3
+#	tristate "HED Wireless Interface Card"
+#	select WIRELESS_EXT
+#	select WIRELESS_EXT_SYSFS
+
+#config USB_CMMB_INNOFIDEI
+#	tristate "Innofidei cmmb dongle"
+
+endmenu
+
+endif
+
+endif
diff --git a/drivers/staging/puv3/Makefile b/drivers/staging/puv3/Makefile
new file mode 100644
index 0000000..e14fc95
--- /dev/null
+++ b/drivers/staging/puv3/Makefile
@@ -0,0 +1,27 @@
+#
+# Makefile for the Linux-uc PKUnity v3 Platform
+#
+# 2008~2010, Epip.Guan
+#
+
+obj-y	:= puv3_dma.o
+
+obj-$(CONFIG_PUV3_GPIO)		+= puv3_gpio.o
+obj-$(CONFIG_PUV3_RTC)		+= puv3_rtc.o
+obj-$(CONFIG_PUV3_I2C)		+= puv3_i2c.o
+obj-$(CONFIG_PUV3_UMAL)		+= puv3_umal.o
+obj-$(CONFIG_PUV3_UNIGFX)	+= puv3_unifb.o
+obj-$(CONFIG_PUV3_PWM)		+= puv3_pwm.o
+obj-$(CONFIG_PUV3_AC97)		+= puv3_sound.o
+puv3_sound-objs			:= puv3_ac97.o puv3_pcm.o
+
+# drivers need upgrade and review
+#obj-$(CONFIG_PUV3_MMC)		+= puv3_mmc.o
+#obj-$(CONFIG_PUV3_NAND)	+= puv3_nand.o
+#obj-$(CONFIG_PUV3_UART)	+= puv3_uart.o
+#obj-$(CONFIG_PUV3_SPI)		+= puv3_spi.o
+
+# drivers from partners
+#obj-$(CONFIG_USB_WLAN_HED_AQ3)		+= hed-aq3/
+#obj-$(CONFIG_USB_CMMB_INNOFIDEI)	+= usb-innofidei.o
+
diff --git a/drivers/staging/puv3/TODO b/drivers/staging/puv3/TODO
new file mode 100644
index 0000000..f89d034
--- /dev/null
+++ b/drivers/staging/puv3/TODO
@@ -0,0 +1,7 @@
+- The driver in this directory has been tested on Netbook 0916 with latest linux version.
+- Following drivers are not included for not testing with latest linux version, but only in 2.6.32.
+	- UART, SPI, NAND, SDC
+- Please use the following link to get information about the SoC's details.
+	http://www.pkunity.com/english%20version/engindex.htm
+- Please send any patches or advice to
+	- Guan Xuetao <guanxuetao@mprc.pku.edu.cn>

> -----Original Message-----
> From: linux-arch-owner@vger.kernel.org [mailto:linux-arch-owner@vger.kernel.org] On Behalf Of Guan Xuetao
> Sent: Thursday, January 06, 2011 3:57 PM
> To: linux-arch@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [PATCHv1 0/8] unicore32 machine related files: summary
> 
> From: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>
> 
> The whole patch could be fetched from:
>   git://git.kernel.org/pub/scm/linux/kernel/git/epip/unicore32.git
>   with branch name: unicore32.
> And it is divided into  three patch sets: core architecture files,
>   additional architecture files, and machine related files.
> 
> This patch set adds the machine related files for UniCore32 ISA and PKUnity SoC.
> 
> Patch 1 adds machine related  core files, also including build infrastructure.
> 
> Patch 2 add all hardware registers definitions, which are not split and inserted into
>  different drivers.
> 
> Patch 3 implements arch-specific pci bus driver.
> 
> Patch 4 implements arch-specific ps2 dirver.
> 
> Patch 5 implements frame buffer driver.
> 
> Patch 6 implements ac97 driver.
> 
> Patch 7 implements arch-specific i2c bus driver.
> 
> Patch 8 implements network driver.
> 
> Signed-off-by: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>
> ---
>  arch/unicore32/include/asm/mach/PKUnity.h     |  104 ++
>  arch/unicore32/include/asm/mach/bitfield.h    |   24 +
>  arch/unicore32/include/asm/mach/hardware.h    |   45 +
>  arch/unicore32/include/asm/mach/regs-ac97.h   |   32 +
>  arch/unicore32/include/asm/mach/regs-dmac.h   |   81 +
>  arch/unicore32/include/asm/mach/regs-gpio.h   |   70 +
>  arch/unicore32/include/asm/mach/regs-i2c.h    |   63 +
>  arch/unicore32/include/asm/mach/regs-intc.h   |   28 +
>  arch/unicore32/include/asm/mach/regs-nand.h   |   79 +
>  arch/unicore32/include/asm/mach/regs-ost.h    |   92 ++
>  arch/unicore32/include/asm/mach/regs-pci.h    |   94 ++
>  arch/unicore32/include/asm/mach/regs-pm.h     |  126 ++
>  arch/unicore32/include/asm/mach/regs-ps2.h    |   20 +
>  arch/unicore32/include/asm/mach/regs-resetc.h |   34 +
>  arch/unicore32/include/asm/mach/regs-rtc.h    |   37 +
>  arch/unicore32/include/asm/mach/regs-sdc.h    |  156 ++
>  arch/unicore32/include/asm/mach/regs-spi.h    |   98 ++
>  arch/unicore32/include/asm/mach/regs-uart.h   |    3 +
>  arch/unicore32/include/asm/mach/regs-umal.h   |  229 +++
>  arch/unicore32/include/asm/mach/regs-unigfx.h |  200 +++
>  arch/unicore32/include/asm/pci.h              |   46 +
>  arch/unicore32/kernel/pci.c                   |  404 +++++
>  arch/unicore32/kernel/puv3-core.c             |  266 ++++
>  arch/unicore32/kernel/puv3-nb0916.c           |  183 +++
>  arch/unicore32/kernel/puv3-smw0919.c          |  120 ++
>  drivers/input/keyboard/Kconfig                |   11 +
>  drivers/input/keyboard/atkbd.c                |    4 +
>  drivers/input/mouse/psmouse-base.c            |   41 +
>  drivers/input/serio/i8042.h                   |    2 +
>  drivers/pci/Makefile                          |    1 +
>  drivers/staging/puv3/Kconfig                  |  142 ++
>  drivers/staging/puv3/Makefile                 |   27 +
>  drivers/staging/puv3/TODO                     |    7 +
>  drivers/staging/puv3/i8042-ucio.h             |   96 ++
>  drivers/staging/puv3/nb0916-atkbd.h           |   43 +
>  drivers/staging/puv3/puv3_ac97.c              |  383 +++++
>  drivers/staging/puv3/puv3_i2c.c               |  325 ++++
>  drivers/staging/puv3/puv3_pcm.c               |  449 ++++++
>  drivers/staging/puv3/puv3_pcm.h               |   33 +
>  drivers/staging/puv3/puv3_umal.c              | 2082 +++++++++++++++++++++++++
>  drivers/staging/puv3/puv3_unifb.c             |  972 ++++++++++++
>  include/linux/fb.h                            |    2 +
>  42 files changed, 7254 insertions(+), 0 deletions(-)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arch" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

