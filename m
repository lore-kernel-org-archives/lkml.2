Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697Ab1GZPzv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 11:55:51 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43095 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752561Ab1GZPzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 11:55:43 -0400
Date: Tue, 26 Jul 2011 17:54:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Daniel Drake <dsd@laptop.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andres Salomon <dilinger@queued.net>
Subject: [GIT PULL] x86/olpc changes for v3.1
Message-ID: <20110726155443.GA30110@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-olpc-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-olpc-for-linus


out-of-topic modifications in x86-olpc-for-linus:
-------------------------------------------------
include/linux/cs5535.h             # cfee959: x86, olpc: Add XO-1 RTC driver
                                   # 2cf2bae: x86, olpc-xo1-sci: Add lid switch
                                   # 7bc74b3: x86, olpc-xo1-sci: Add GPE handle
                                   # 7feda8e: x86, olpc: Add XO-1 SCI driver an
                                   # 97c4cb7: x86, olpc: Add XO-1 suspend/resum
                                   # 7a0d4fc: x86, olpc: Move CS5536-related co

 Thanks,

	Ingo

------------------>
Daniel Drake (13):
      x86, olpc: Add missing elements to device tree
      x86, olpc: Move CS5536-related constants to cs5535.h
      x86, olpc: Rename olpc-xo1 to olpc-xo1-pm
      x86, olpc: Add XO-1 suspend/resume support
      x86, olpc: Add XO-1 SCI driver and power button control
      x86, olpc: EC SCI wakeup mask functionality
      x86, olpc-xo1-sci: Add GPE handler and ebook switch functionality
      x86, olpc-xo1-sci: Add lid switch functionality
      x86, olpc-xo1-sci: Propagate power supply/battery events
      x86, olpc: Add XO-1 RTC driver
      x86, olpc: Add XO-1.5 SCI driver
      x86, olpc: Fix dependency on POWER_SUPPLY
      x86, olpc-xo15-sci: Enable EC wakeup capability


 .../devicetree/bindings/rtc/olpc-xo1-rtc.txt       |    5 +
 arch/x86/Kconfig                                   |   43 ++-
 arch/x86/include/asm/olpc.h                        |   51 ++-
 arch/x86/platform/olpc/Makefile                    |    5 +-
 arch/x86/platform/olpc/olpc-xo1-pm.c               |  215 +++++++
 arch/x86/platform/olpc/olpc-xo1-rtc.c              |   81 +++
 arch/x86/platform/olpc/olpc-xo1-sci.c              |  614 ++++++++++++++++++++
 arch/x86/platform/olpc/olpc-xo1.c                  |  146 -----
 arch/x86/platform/olpc/olpc-xo15-sci.c             |  168 ++++++
 arch/x86/platform/olpc/olpc.c                      |   95 +++
 arch/x86/platform/olpc/olpc_dt.c                   |  103 ++++
 arch/x86/platform/olpc/xo1-wakeup.S                |  124 ++++
 include/linux/cs5535.h                             |   60 ++
 13 files changed, 1547 insertions(+), 163 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/rtc/olpc-xo1-rtc.txt
 create mode 100644 arch/x86/platform/olpc/olpc-xo1-pm.c
 create mode 100644 arch/x86/platform/olpc/olpc-xo1-rtc.c
 create mode 100644 arch/x86/platform/olpc/olpc-xo1-sci.c
 delete mode 100644 arch/x86/platform/olpc/olpc-xo1.c
 create mode 100644 arch/x86/platform/olpc/olpc-xo15-sci.c
 create mode 100644 arch/x86/platform/olpc/xo1-wakeup.S

diff --git a/Documentation/devicetree/bindings/rtc/olpc-xo1-rtc.txt b/Documentation/devicetree/bindings/rtc/olpc-xo1-rtc.txt
new file mode 100644
index 0000000..a2891ce
--- /dev/null
+++ b/Documentation/devicetree/bindings/rtc/olpc-xo1-rtc.txt
@@ -0,0 +1,5 @@
+OLPC XO-1 RTC
+~~~~~~~~~~~~~
+
+Required properties:
+ - compatible : "olpc,xo1-rtc"
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index da34972..b198c01 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2073,11 +2073,44 @@ config OLPC
 	  Add support for detecting the unique features of the OLPC
 	  XO hardware.
 
-config OLPC_XO1
-	tristate "OLPC XO-1 support"
-	depends on OLPC && MFD_CS5535
-	---help---
-	  Add support for non-essential features of the OLPC XO-1 laptop.
+config OLPC_XO1_PM
+	bool "OLPC XO-1 Power Management"
+	depends on OLPC && MFD_CS5535 && PM_SLEEP
+	select MFD_CORE
+	---help---
+	  Add support for poweroff and suspend of the OLPC XO-1 laptop.
+
+config OLPC_XO1_RTC
+	bool "OLPC XO-1 Real Time Clock"
+	depends on OLPC_XO1_PM && RTC_DRV_CMOS
+	---help---
+	  Add support for the XO-1 real time clock, which can be used as a
+	  programmable wakeup source.
+
+config OLPC_XO1_SCI
+	bool "OLPC XO-1 SCI extras"
+	depends on OLPC && OLPC_XO1_PM
+	select POWER_SUPPLY
+	select GPIO_CS5535
+	select MFD_CORE
+	---help---
+	  Add support for SCI-based features of the OLPC XO-1 laptop:
+	   - EC-driven system wakeups
+	   - Power button
+	   - Ebook switch
+	   - Lid switch
+	   - AC adapter status updates
+	   - Battery status updates
+
+config OLPC_XO15_SCI
+	bool "OLPC XO-1.5 SCI extras"
+	depends on OLPC && ACPI
+	select POWER_SUPPLY
+	---help---
+	  Add support for SCI-based features of the OLPC XO-1.5 laptop:
+	   - EC-driven system wakeups
+	   - AC adapter status updates
+	   - Battery status updates
 
 endif # X86_32
 
diff --git a/arch/x86/include/asm/olpc.h b/arch/x86/include/asm/olpc.h
index 5ca6801..87bdbca 100644
--- a/arch/x86/include/asm/olpc.h
+++ b/arch/x86/include/asm/olpc.h
@@ -13,6 +13,7 @@ struct olpc_platform_t {
 
 #define OLPC_F_PRESENT		0x01
 #define OLPC_F_DCON		0x02
+#define OLPC_F_EC_WIDE_SCI	0x04
 
 #ifdef CONFIG_OLPC
 
@@ -62,6 +63,13 @@ static inline int olpc_board_at_least(uint32_t rev)
 	return olpc_platform_info.boardrev >= rev;
 }
 
+extern void olpc_ec_wakeup_set(u16 value);
+extern void olpc_ec_wakeup_clear(u16 value);
+extern bool olpc_ec_wakeup_available(void);
+
+extern int olpc_ec_mask_write(u16 bits);
+extern int olpc_ec_sci_query(u16 *sci_value);
+
 #else
 
 static inline int machine_is_olpc(void)
@@ -74,6 +82,20 @@ static inline int olpc_has_dcon(void)
 	return 0;
 }
 
+static inline void olpc_ec_wakeup_set(u16 value) { }
+static inline void olpc_ec_wakeup_clear(u16 value) { }
+
+static inline bool olpc_ec_wakeup_available(void)
+{
+	return false;
+}
+
+#endif
+
+#ifdef CONFIG_OLPC_XO1_PM
+extern void do_olpc_suspend_lowlevel(void);
+extern void olpc_xo1_pm_wakeup_set(u16 value);
+extern void olpc_xo1_pm_wakeup_clear(u16 value);
 #endif
 
 extern int pci_olpc_init(void);
@@ -83,14 +105,19 @@ extern int pci_olpc_init(void);
 extern int olpc_ec_cmd(unsigned char cmd, unsigned char *inbuf, size_t inlen,
 		unsigned char *outbuf, size_t outlen);
 
-extern int olpc_ec_mask_set(uint8_t bits);
-extern int olpc_ec_mask_unset(uint8_t bits);
-
 /* EC commands */
 
-#define EC_FIRMWARE_REV		0x08
-#define EC_WLAN_ENTER_RESET	0x35
-#define EC_WLAN_LEAVE_RESET	0x25
+#define EC_FIRMWARE_REV			0x08
+#define EC_WRITE_SCI_MASK		0x1b
+#define EC_WAKE_UP_WLAN			0x24
+#define EC_WLAN_LEAVE_RESET		0x25
+#define EC_READ_EB_MODE			0x2a
+#define EC_SET_SCI_INHIBIT		0x32
+#define EC_SET_SCI_INHIBIT_RELEASE	0x34
+#define EC_WLAN_ENTER_RESET		0x35
+#define EC_WRITE_EXT_SCI_MASK		0x38
+#define EC_SCI_QUERY			0x84
+#define EC_EXT_SCI_QUERY		0x85
 
 /* SCI source values */
 
@@ -99,10 +126,12 @@ extern int olpc_ec_mask_unset(uint8_t bits);
 #define EC_SCI_SRC_BATTERY	0x02
 #define EC_SCI_SRC_BATSOC	0x04
 #define EC_SCI_SRC_BATERR	0x08
-#define EC_SCI_SRC_EBOOK	0x10
-#define EC_SCI_SRC_WLAN		0x20
+#define EC_SCI_SRC_EBOOK	0x10	/* XO-1 only */
+#define EC_SCI_SRC_WLAN		0x20	/* XO-1 only */
 #define EC_SCI_SRC_ACPWR	0x40
-#define EC_SCI_SRC_ALL		0x7F
+#define EC_SCI_SRC_BATCRIT	0x80
+#define EC_SCI_SRC_GPWAKE	0x100	/* XO-1.5 only */
+#define EC_SCI_SRC_ALL		0x1FF
 
 /* GPIO assignments */
 
@@ -116,7 +145,7 @@ extern int olpc_ec_mask_unset(uint8_t bits);
 #define OLPC_GPIO_SMB_CLK      14
 #define OLPC_GPIO_SMB_DATA     15
 #define OLPC_GPIO_WORKAUX	geode_gpio(24)
-#define OLPC_GPIO_LID		geode_gpio(26)
-#define OLPC_GPIO_ECSCI		geode_gpio(27)
+#define OLPC_GPIO_LID		26
+#define OLPC_GPIO_ECSCI		27
 
 #endif /* _ASM_X86_OLPC_H */
diff --git a/arch/x86/platform/olpc/Makefile b/arch/x86/platform/olpc/Makefile
index 81c5e21..fd332c5 100644
--- a/arch/x86/platform/olpc/Makefile
+++ b/arch/x86/platform/olpc/Makefile
@@ -1,2 +1,5 @@
 obj-$(CONFIG_OLPC)		+= olpc.o olpc_ofw.o olpc_dt.o
-obj-$(CONFIG_OLPC_XO1)		+= olpc-xo1.o
+obj-$(CONFIG_OLPC_XO1_PM)		+= olpc-xo1-pm.o xo1-wakeup.o
+obj-$(CONFIG_OLPC_XO1_RTC)	+= olpc-xo1-rtc.o
+obj-$(CONFIG_OLPC_XO1_SCI)	+= olpc-xo1-sci.o
+obj-$(CONFIG_OLPC_XO15_SCI)	+= olpc-xo15-sci.o
diff --git a/arch/x86/platform/olpc/olpc-xo1-pm.c b/arch/x86/platform/olpc/olpc-xo1-pm.c
new file mode 100644
index 0000000..6f3855a
--- /dev/null
+++ b/arch/x86/platform/olpc/olpc-xo1-pm.c
@@ -0,0 +1,215 @@
+/*
+ * Support for power management features of the OLPC XO-1 laptop
+ *
+ * Copyright (C) 2010 Andres Salomon <dilinger@queued.net>
+ * Copyright (C) 2010 One Laptop per Child
+ * Copyright (C) 2006 Red Hat, Inc.
+ * Copyright (C) 2006 Advanced Micro Devices, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/cs5535.h>
+#include <linux/platform_device.h>
+#include <linux/pm.h>
+#include <linux/mfd/core.h>
+#include <linux/suspend.h>
+
+#include <asm/io.h>
+#include <asm/olpc.h>
+
+#define DRV_NAME "olpc-xo1-pm"
+
+static unsigned long acpi_base;
+static unsigned long pms_base;
+
+static u16 wakeup_mask = CS5536_PM_PWRBTN;
+
+static struct {
+	unsigned long address;
+	unsigned short segment;
+} ofw_bios_entry = { 0xF0000 + PAGE_OFFSET, __KERNEL_CS };
+
+/* Set bits in the wakeup mask */
+void olpc_xo1_pm_wakeup_set(u16 value)
+{
+	wakeup_mask |= value;
+}
+EXPORT_SYMBOL_GPL(olpc_xo1_pm_wakeup_set);
+
+/* Clear bits in the wakeup mask */
+void olpc_xo1_pm_wakeup_clear(u16 value)
+{
+	wakeup_mask &= ~value;
+}
+EXPORT_SYMBOL_GPL(olpc_xo1_pm_wakeup_clear);
+
+static int xo1_power_state_enter(suspend_state_t pm_state)
+{
+	unsigned long saved_sci_mask;
+	int r;
+
+	/* Only STR is supported */
+	if (pm_state != PM_SUSPEND_MEM)
+		return -EINVAL;
+
+	r = olpc_ec_cmd(EC_SET_SCI_INHIBIT, NULL, 0, NULL, 0);
+	if (r)
+		return r;
+
+	/*
+	 * Save SCI mask (this gets lost since PM1_EN is used as a mask for
+	 * wakeup events, which is not necessarily the same event set)
+	 */
+	saved_sci_mask = inl(acpi_base + CS5536_PM1_STS);
+	saved_sci_mask &= 0xffff0000;
+
+	/* Save CPU state */
+	do_olpc_suspend_lowlevel();
+
+	/* Resume path starts here */
+
+	/* Restore SCI mask (using dword access to CS5536_PM1_EN) */
+	outl(saved_sci_mask, acpi_base + CS5536_PM1_STS);
+
+	/* Tell the EC to stop inhibiting SCIs */
+	olpc_ec_cmd(EC_SET_SCI_INHIBIT_RELEASE, NULL, 0, NULL, 0);
+
+	/*
+	 * Tell the wireless module to restart USB communication.
+	 * Must be done twice.
+	 */
+	olpc_ec_cmd(EC_WAKE_UP_WLAN, NULL, 0, NULL, 0);
+	olpc_ec_cmd(EC_WAKE_UP_WLAN, NULL, 0, NULL, 0);
+
+	return 0;
+}
+
+asmlinkage int xo1_do_sleep(u8 sleep_state)
+{
+	void *pgd_addr = __va(read_cr3());
+
+	/* Program wakeup mask (using dword access to CS5536_PM1_EN) */
+	outl(wakeup_mask << 16, acpi_base + CS5536_PM1_STS);
+
+	__asm__("movl %0,%%eax" : : "r" (pgd_addr));
+	__asm__("call *(%%edi); cld"
+		: : "D" (&ofw_bios_entry));
+	__asm__("movb $0x34, %al\n\t"
+		"outb %al, $0x70\n\t"
+		"movb $0x30, %al\n\t"
+		"outb %al, $0x71\n\t");
+	return 0;
+}
+
+static void xo1_power_off(void)
+{
+	printk(KERN_INFO "OLPC XO-1 power off sequence...\n");
+
+	/* Enable all of these controls with 0 delay */
+	outl(0x40000000, pms_base + CS5536_PM_SCLK);
+	outl(0x40000000, pms_base + CS5536_PM_IN_SLPCTL);
+	outl(0x40000000, pms_base + CS5536_PM_WKXD);
+	outl(0x40000000, pms_base + CS5536_PM_WKD);
+
+	/* Clear status bits (possibly unnecessary) */
+	outl(0x0002ffff, pms_base  + CS5536_PM_SSC);
+	outl(0xffffffff, acpi_base + CS5536_PM_GPE0_STS);
+
+	/* Write SLP_EN bit to start the machinery */
+	outl(0x00002000, acpi_base + CS5536_PM1_CNT);
+}
+
+static int xo1_power_state_valid(suspend_state_t pm_state)
+{
+	/* suspend-to-RAM only */
+	return pm_state == PM_SUSPEND_MEM;
+}
+
+static const struct platform_suspend_ops xo1_suspend_ops = {
+	.valid = xo1_power_state_valid,
+	.enter = xo1_power_state_enter,
+};
+
+static int __devinit xo1_pm_probe(struct platform_device *pdev)
+{
+	struct resource *res;
+	int err;
+
+	/* don't run on non-XOs */
+	if (!machine_is_olpc())
+		return -ENODEV;
+
+	err = mfd_cell_enable(pdev);
+	if (err)
+		return err;
+
+	res = platform_get_resource(pdev, IORESOURCE_IO, 0);
+	if (!res) {
+		dev_err(&pdev->dev, "can't fetch device resource info\n");
+		return -EIO;
+	}
+	if (strcmp(pdev->name, "cs5535-pms") == 0)
+		pms_base = res->start;
+	else if (strcmp(pdev->name, "olpc-xo1-pm-acpi") == 0)
+		acpi_base = res->start;
+
+	/* If we have both addresses, we can override the poweroff hook */
+	if (pms_base && acpi_base) {
+		suspend_set_ops(&xo1_suspend_ops);
+		pm_power_off = xo1_power_off;
+		printk(KERN_INFO "OLPC XO-1 support registered\n");
+	}
+
+	return 0;
+}
+
+static int __devexit xo1_pm_remove(struct platform_device *pdev)
+{
+	mfd_cell_disable(pdev);
+
+	if (strcmp(pdev->name, "cs5535-pms") == 0)
+		pms_base = 0;
+	else if (strcmp(pdev->name, "olpc-xo1-pm-acpi") == 0)
+		acpi_base = 0;
+
+	pm_power_off = NULL;
+	return 0;
+}
+
+static struct platform_driver cs5535_pms_driver = {
+	.driver = {
+		.name = "cs5535-pms",
+		.owner = THIS_MODULE,
+	},
+	.probe = xo1_pm_probe,
+	.remove = __devexit_p(xo1_pm_remove),
+};
+
+static struct platform_driver cs5535_acpi_driver = {
+	.driver = {
+		.name = "olpc-xo1-pm-acpi",
+		.owner = THIS_MODULE,
+	},
+	.probe = xo1_pm_probe,
+	.remove = __devexit_p(xo1_pm_remove),
+};
+
+static int __init xo1_pm_init(void)
+{
+	int r;
+
+	r = platform_driver_register(&cs5535_pms_driver);
+	if (r)
+		return r;
+
+	r = platform_driver_register(&cs5535_acpi_driver);
+	if (r)
+		platform_driver_unregister(&cs5535_pms_driver);
+
+	return r;
+}
+arch_initcall(xo1_pm_init);
diff --git a/arch/x86/platform/olpc/olpc-xo1-rtc.c b/arch/x86/platform/olpc/olpc-xo1-rtc.c
new file mode 100644
index 0000000..a2b4efd
--- /dev/null
+++ b/arch/x86/platform/olpc/olpc-xo1-rtc.c
@@ -0,0 +1,81 @@
+/*
+ * Support for OLPC XO-1 Real Time Clock (RTC)
+ *
+ * Copyright (C) 2011 One Laptop per Child
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/mc146818rtc.h>
+#include <linux/platform_device.h>
+#include <linux/rtc.h>
+#include <linux/of.h>
+
+#include <asm/msr.h>
+#include <asm/olpc.h>
+
+static void rtc_wake_on(struct device *dev)
+{
+	olpc_xo1_pm_wakeup_set(CS5536_PM_RTC);
+}
+
+static void rtc_wake_off(struct device *dev)
+{
+	olpc_xo1_pm_wakeup_clear(CS5536_PM_RTC);
+}
+
+static struct resource rtc_platform_resource[] = {
+	[0] = {
+		.start	= RTC_PORT(0),
+		.end	= RTC_PORT(1),
+		.flags	= IORESOURCE_IO,
+	},
+	[1] = {
+		.start	= RTC_IRQ,
+		.end	= RTC_IRQ,
+		.flags	= IORESOURCE_IRQ,
+	}
+};
+
+static struct cmos_rtc_board_info rtc_info = {
+	.rtc_day_alarm = 0,
+	.rtc_mon_alarm = 0,
+	.rtc_century = 0,
+	.wake_on = rtc_wake_on,
+	.wake_off = rtc_wake_off,
+};
+
+static struct platform_device xo1_rtc_device = {
+	.name = "rtc_cmos",
+	.id = -1,
+	.num_resources = ARRAY_SIZE(rtc_platform_resource),
+	.dev.platform_data = &rtc_info,
+	.resource = rtc_platform_resource,
+};
+
+static int __init xo1_rtc_init(void)
+{
+	int r;
+	struct device_node *node;
+
+	node = of_find_compatible_node(NULL, NULL, "olpc,xo1-rtc");
+	if (!node)
+		return 0;
+	of_node_put(node);
+
+	pr_info("olpc-xo1-rtc: Initializing OLPC XO-1 RTC\n");
+	rdmsrl(MSR_RTC_DOMA_OFFSET, rtc_info.rtc_day_alarm);
+	rdmsrl(MSR_RTC_MONA_OFFSET, rtc_info.rtc_mon_alarm);
+	rdmsrl(MSR_RTC_CEN_OFFSET, rtc_info.rtc_century);
+
+	r = platform_device_register(&xo1_rtc_device);
+	if (r)
+		return r;
+
+	device_init_wakeup(&xo1_rtc_device.dev, 1);
+	return 0;
+}
+arch_initcall(xo1_rtc_init);
diff --git a/arch/x86/platform/olpc/olpc-xo1-sci.c b/arch/x86/platform/olpc/olpc-xo1-sci.c
new file mode 100644
index 0000000..1d4c783
--- /dev/null
+++ b/arch/x86/platform/olpc/olpc-xo1-sci.c
@@ -0,0 +1,614 @@
+/*
+ * Support for OLPC XO-1 System Control Interrupts (SCI)
+ *
+ * Copyright (C) 2010 One Laptop per Child
+ * Copyright (C) 2006 Red Hat, Inc.
+ * Copyright (C) 2006 Advanced Micro Devices, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/cs5535.h>
+#include <linux/device.h>
+#include <linux/gpio.h>
+#include <linux/input.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/pm.h>
+#include <linux/mfd/core.h>
+#include <linux/power_supply.h>
+#include <linux/suspend.h>
+#include <linux/workqueue.h>
+
+#include <asm/io.h>
+#include <asm/msr.h>
+#include <asm/olpc.h>
+
+#define DRV_NAME	"olpc-xo1-sci"
+#define PFX		DRV_NAME ": "
+
+static unsigned long acpi_base;
+static struct input_dev *power_button_idev;
+static struct input_dev *ebook_switch_idev;
+static struct input_dev *lid_switch_idev;
+
+static int sci_irq;
+
+static bool lid_open;
+static bool lid_inverted;
+static int lid_wake_mode;
+
+enum lid_wake_modes {
+	LID_WAKE_ALWAYS,
+	LID_WAKE_OPEN,
+	LID_WAKE_CLOSE,
+};
+
+static const char * const lid_wake_mode_names[] = {
+	[LID_WAKE_ALWAYS] = "always",
+	[LID_WAKE_OPEN] = "open",
+	[LID_WAKE_CLOSE] = "close",
+};
+
+static void battery_status_changed(void)
+{
+	struct power_supply *psy = power_supply_get_by_name("olpc-battery");
+
+	if (psy) {
+		power_supply_changed(psy);
+		put_device(psy->dev);
+	}
+}
+
+static void ac_status_changed(void)
+{
+	struct power_supply *psy = power_supply_get_by_name("olpc-ac");
+
+	if (psy) {
+		power_supply_changed(psy);
+		put_device(psy->dev);
+	}
+}
+
+/* Report current ebook switch state through input layer */
+static void send_ebook_state(void)
+{
+	unsigned char state;
+
+	if (olpc_ec_cmd(EC_READ_EB_MODE, NULL, 0, &state, 1)) {
+		pr_err(PFX "failed to get ebook state\n");
+		return;
+	}
+
+	input_report_switch(ebook_switch_idev, SW_TABLET_MODE, state);
+	input_sync(ebook_switch_idev);
+}
+
+static void flip_lid_inverter(void)
+{
+	/* gpio is high; invert so we'll get l->h event interrupt */
+	if (lid_inverted)
+		cs5535_gpio_clear(OLPC_GPIO_LID, GPIO_INPUT_INVERT);
+	else
+		cs5535_gpio_set(OLPC_GPIO_LID, GPIO_INPUT_INVERT);
+	lid_inverted = !lid_inverted;
+}
+
+static void detect_lid_state(void)
+{
+	/*
+	 * the edge detector hookup on the gpio inputs on the geode is
+	 * odd, to say the least.  See http://dev.laptop.org/ticket/5703
+	 * for details, but in a nutshell:  we don't use the edge
+	 * detectors.  instead, we make use of an anomoly:  with the both
+	 * edge detectors turned off, we still get an edge event on a
+	 * positive edge transition.  to take advantage of this, we use the
+	 * front-end inverter to ensure that that's the edge we're always
+	 * going to see next.
+	 */
+
+	int state;
+
+	state = cs5535_gpio_isset(OLPC_GPIO_LID, GPIO_READ_BACK);
+	lid_open = !state ^ !lid_inverted; /* x ^^ y */
+	if (!state)
+		return;
+
+	flip_lid_inverter();
+}
+
+/* Report current lid switch state through input layer */
+static void send_lid_state(void)
+{
+	input_report_switch(lid_switch_idev, SW_LID, !lid_open);
+	input_sync(lid_switch_idev);
+}
+
+static ssize_t lid_wake_mode_show(struct device *dev,
+				  struct device_attribute *attr, char *buf)
+{
+	const char *mode = lid_wake_mode_names[lid_wake_mode];
+	return sprintf(buf, "%s\n", mode);
+}
+static ssize_t lid_wake_mode_set(struct device *dev,
+				 struct device_attribute *attr,
+				 const char *buf, size_t count)
+{
+	int i;
+	for (i = 0; i < ARRAY_SIZE(lid_wake_mode_names); i++) {
+		const char *mode = lid_wake_mode_names[i];
+		if (strlen(mode) != count || strncasecmp(mode, buf, count))
+			continue;
+
+		lid_wake_mode = i;
+		return count;
+	}
+	return -EINVAL;
+}
+static DEVICE_ATTR(lid_wake_mode, S_IWUSR | S_IRUGO, lid_wake_mode_show,
+		   lid_wake_mode_set);
+
+/*
+ * Process all items in the EC's SCI queue.
+ *
+ * This is handled in a workqueue because olpc_ec_cmd can be slow (and
+ * can even timeout).
+ *
+ * If propagate_events is false, the queue is drained without events being
+ * generated for the interrupts.
+ */
+static void process_sci_queue(bool propagate_events)
+{
+	int r;
+	u16 data;
+
+	do {
+		r = olpc_ec_sci_query(&data);
+		if (r || !data)
+			break;
+
+		pr_debug(PFX "SCI 0x%x received\n", data);
+
+		switch (data) {
+		case EC_SCI_SRC_BATERR:
+		case EC_SCI_SRC_BATSOC:
+		case EC_SCI_SRC_BATTERY:
+		case EC_SCI_SRC_BATCRIT:
+			battery_status_changed();
+			break;
+		case EC_SCI_SRC_ACPWR:
+			ac_status_changed();
+			break;
+		}
+
+		if (data == EC_SCI_SRC_EBOOK && propagate_events)
+			send_ebook_state();
+	} while (data);
+
+	if (r)
+		pr_err(PFX "Failed to clear SCI queue");
+}
+
+static void process_sci_queue_work(struct work_struct *work)
+{
+	process_sci_queue(true);
+}
+
+static DECLARE_WORK(sci_work, process_sci_queue_work);
+
+static irqreturn_t xo1_sci_intr(int irq, void *dev_id)
+{
+	struct platform_device *pdev = dev_id;
+	u32 sts;
+	u32 gpe;
+
+	sts = inl(acpi_base + CS5536_PM1_STS);
+	outl(sts | 0xffff, acpi_base + CS5536_PM1_STS);
+
+	gpe = inl(acpi_base + CS5536_PM_GPE0_STS);
+	outl(0xffffffff, acpi_base + CS5536_PM_GPE0_STS);
+
+	dev_dbg(&pdev->dev, "sts %x gpe %x\n", sts, gpe);
+
+	if (sts & CS5536_PWRBTN_FLAG && !(sts & CS5536_WAK_FLAG)) {
+		input_report_key(power_button_idev, KEY_POWER, 1);
+		input_sync(power_button_idev);
+		input_report_key(power_button_idev, KEY_POWER, 0);
+		input_sync(power_button_idev);
+	}
+
+	if (gpe & CS5536_GPIOM7_PME_FLAG) { /* EC GPIO */
+		cs5535_gpio_set(OLPC_GPIO_ECSCI, GPIO_NEGATIVE_EDGE_STS);
+		schedule_work(&sci_work);
+	}
+
+	cs5535_gpio_set(OLPC_GPIO_LID, GPIO_NEGATIVE_EDGE_STS);
+	cs5535_gpio_set(OLPC_GPIO_LID, GPIO_POSITIVE_EDGE_STS);
+	detect_lid_state();
+	send_lid_state();
+
+	return IRQ_HANDLED;
+}
+
+static int xo1_sci_suspend(struct platform_device *pdev, pm_message_t state)
+{
+	if (device_may_wakeup(&power_button_idev->dev))
+		olpc_xo1_pm_wakeup_set(CS5536_PM_PWRBTN);
+	else
+		olpc_xo1_pm_wakeup_clear(CS5536_PM_PWRBTN);
+
+	if (device_may_wakeup(&ebook_switch_idev->dev))
+		olpc_ec_wakeup_set(EC_SCI_SRC_EBOOK);
+	else
+		olpc_ec_wakeup_clear(EC_SCI_SRC_EBOOK);
+
+	if (!device_may_wakeup(&lid_switch_idev->dev)) {
+		cs5535_gpio_clear(OLPC_GPIO_LID, GPIO_EVENTS_ENABLE);
+	} else if ((lid_open && lid_wake_mode == LID_WAKE_OPEN) ||
+		   (!lid_open && lid_wake_mode == LID_WAKE_CLOSE)) {
+		flip_lid_inverter();
+
+		/* we may have just caused an event */
+		cs5535_gpio_set(OLPC_GPIO_LID, GPIO_NEGATIVE_EDGE_STS);
+		cs5535_gpio_set(OLPC_GPIO_LID, GPIO_POSITIVE_EDGE_STS);
+
+		cs5535_gpio_set(OLPC_GPIO_LID, GPIO_EVENTS_ENABLE);
+	}
+
+	return 0;
+}
+
+static int xo1_sci_resume(struct platform_device *pdev)
+{
+	/*
+	 * We don't know what may have happened while we were asleep.
+	 * Reestablish our lid setup so we're sure to catch all transitions.
+	 */
+	detect_lid_state();
+	send_lid_state();
+	cs5535_gpio_set(OLPC_GPIO_LID, GPIO_EVENTS_ENABLE);
+
+	/* Enable all EC events */
+	olpc_ec_mask_write(EC_SCI_SRC_ALL);
+
+	/* Power/battery status might have changed too */
+	battery_status_changed();
+	ac_status_changed();
+	return 0;
+}
+
+static int __devinit setup_sci_interrupt(struct platform_device *pdev)
+{
+	u32 lo, hi;
+	u32 sts;
+	int r;
+
+	rdmsr(0x51400020, lo, hi);
+	sci_irq = (lo >> 20) & 15;
+
+	if (sci_irq) {
+		dev_info(&pdev->dev, "SCI is mapped to IRQ %d\n", sci_irq);
+	} else {
+		/* Zero means masked */
+		dev_info(&pdev->dev, "SCI unmapped. Mapping to IRQ 3\n");
+		sci_irq = 3;
+		lo |= 0x00300000;
+		wrmsrl(0x51400020, lo);
+	}
+
+	/* Select level triggered in PIC */
+	if (sci_irq < 8) {
+		lo = inb(CS5536_PIC_INT_SEL1);
+		lo |= 1 << sci_irq;
+		outb(lo, CS5536_PIC_INT_SEL1);
+	} else {
+		lo = inb(CS5536_PIC_INT_SEL2);
+		lo |= 1 << (sci_irq - 8);
+		outb(lo, CS5536_PIC_INT_SEL2);
+	}
+
+	/* Enable SCI from power button, and clear pending interrupts */
+	sts = inl(acpi_base + CS5536_PM1_STS);
+	outl((CS5536_PM_PWRBTN << 16) | 0xffff, acpi_base + CS5536_PM1_STS);
+
+	r = request_irq(sci_irq, xo1_sci_intr, 0, DRV_NAME, pdev);
+	if (r)
+		dev_err(&pdev->dev, "can't request interrupt\n");
+
+	return r;
+}
+
+static int __devinit setup_ec_sci(void)
+{
+	int r;
+
+	r = gpio_request(OLPC_GPIO_ECSCI, "OLPC-ECSCI");
+	if (r)
+		return r;
+
+	gpio_direction_input(OLPC_GPIO_ECSCI);
+
+	/* Clear pending EC SCI events */
+	cs5535_gpio_set(OLPC_GPIO_ECSCI, GPIO_NEGATIVE_EDGE_STS);
+	cs5535_gpio_set(OLPC_GPIO_ECSCI, GPIO_POSITIVE_EDGE_STS);
+
+	/*
+	 * Enable EC SCI events, and map them to both a PME and the SCI
+	 * interrupt.
+	 *
+	 * Ordinarily, in addition to functioning as GPIOs, Geode GPIOs can
+	 * be mapped to regular interrupts *or* Geode-specific Power
+	 * Management Events (PMEs) - events that bring the system out of
+	 * suspend. In this case, we want both of those things - the system
+	 * wakeup, *and* the ability to get an interrupt when an event occurs.
+	 *
+	 * To achieve this, we map the GPIO to a PME, and then we use one
+	 * of the many generic knobs on the CS5535 PIC to additionally map the
+	 * PME to the regular SCI interrupt line.
+	 */
+	cs5535_gpio_set(OLPC_GPIO_ECSCI, GPIO_EVENTS_ENABLE);
+
+	/* Set the SCI to cause a PME event on group 7 */
+	cs5535_gpio_setup_event(OLPC_GPIO_ECSCI, 7, 1);
+
+	/* And have group 7 also fire the SCI interrupt */
+	cs5535_pic_unreqz_select_high(7, sci_irq);
+
+	return 0;
+}
+
+static void free_ec_sci(void)
+{
+	gpio_free(OLPC_GPIO_ECSCI);
+}
+
+static int __devinit setup_lid_events(void)
+{
+	int r;
+
+	r = gpio_request(OLPC_GPIO_LID, "OLPC-LID");
+	if (r)
+		return r;
+
+	gpio_direction_input(OLPC_GPIO_LID);
+
+	cs5535_gpio_clear(OLPC_GPIO_LID, GPIO_INPUT_INVERT);
+	lid_inverted = 0;
+
+	/* Clear edge detection and event enable for now */
+	cs5535_gpio_clear(OLPC_GPIO_LID, GPIO_EVENTS_ENABLE);
+	cs5535_gpio_clear(OLPC_GPIO_LID, GPIO_NEGATIVE_EDGE_EN);
+	cs5535_gpio_clear(OLPC_GPIO_LID, GPIO_POSITIVE_EDGE_EN);
+	cs5535_gpio_set(OLPC_GPIO_LID, GPIO_NEGATIVE_EDGE_STS);
+	cs5535_gpio_set(OLPC_GPIO_LID, GPIO_POSITIVE_EDGE_STS);
+
+	/* Set the LID to cause an PME event on group 6 */
+	cs5535_gpio_setup_event(OLPC_GPIO_LID, 6, 1);
+
+	/* Set PME group 6 to fire the SCI interrupt */
+	cs5535_gpio_set_irq(6, sci_irq);
+
+	/* Enable the event */
+	cs5535_gpio_set(OLPC_GPIO_LID, GPIO_EVENTS_ENABLE);
+
+	return 0;
+}
+
+static void free_lid_events(void)
+{
+	gpio_free(OLPC_GPIO_LID);
+}
+
+static int __devinit setup_power_button(struct platform_device *pdev)
+{
+	int r;
+
+	power_button_idev = input_allocate_device();
+	if (!power_button_idev)
+		return -ENOMEM;
+
+	power_button_idev->name = "Power Button";
+	power_button_idev->phys = DRV_NAME "/input0";
+	set_bit(EV_KEY, power_button_idev->evbit);
+	set_bit(KEY_POWER, power_button_idev->keybit);
+
+	power_button_idev->dev.parent = &pdev->dev;
+	device_init_wakeup(&power_button_idev->dev, 1);
+
+	r = input_register_device(power_button_idev);
+	if (r) {
+		dev_err(&pdev->dev, "failed to register power button: %d\n", r);
+		input_free_device(power_button_idev);
+	}
+
+	return r;
+}
+
+static void free_power_button(void)
+{
+	input_unregister_device(power_button_idev);
+	input_free_device(power_button_idev);
+}
+
+static int __devinit setup_ebook_switch(struct platform_device *pdev)
+{
+	int r;
+
+	ebook_switch_idev = input_allocate_device();
+	if (!ebook_switch_idev)
+		return -ENOMEM;
+
+	ebook_switch_idev->name = "EBook Switch";
+	ebook_switch_idev->phys = DRV_NAME "/input1";
+	set_bit(EV_SW, ebook_switch_idev->evbit);
+	set_bit(SW_TABLET_MODE, ebook_switch_idev->swbit);
+
+	ebook_switch_idev->dev.parent = &pdev->dev;
+	device_set_wakeup_capable(&ebook_switch_idev->dev, true);
+
+	r = input_register_device(ebook_switch_idev);
+	if (r) {
+		dev_err(&pdev->dev, "failed to register ebook switch: %d\n", r);
+		input_free_device(ebook_switch_idev);
+	}
+
+	return r;
+}
+
+static void free_ebook_switch(void)
+{
+	input_unregister_device(ebook_switch_idev);
+	input_free_device(ebook_switch_idev);
+}
+
+static int __devinit setup_lid_switch(struct platform_device *pdev)
+{
+	int r;
+
+	lid_switch_idev = input_allocate_device();
+	if (!lid_switch_idev)
+		return -ENOMEM;
+
+	lid_switch_idev->name = "Lid Switch";
+	lid_switch_idev->phys = DRV_NAME "/input2";
+	set_bit(EV_SW, lid_switch_idev->evbit);
+	set_bit(SW_LID, lid_switch_idev->swbit);
+
+	lid_switch_idev->dev.parent = &pdev->dev;
+	device_set_wakeup_capable(&lid_switch_idev->dev, true);
+
+	r = input_register_device(lid_switch_idev);
+	if (r) {
+		dev_err(&pdev->dev, "failed to register lid switch: %d\n", r);
+		goto err_register;
+	}
+
+	r = device_create_file(&lid_switch_idev->dev, &dev_attr_lid_wake_mode);
+	if (r) {
+		dev_err(&pdev->dev, "failed to create wake mode attr: %d\n", r);
+		goto err_create_attr;
+	}
+
+	return 0;
+
+err_create_attr:
+	input_unregister_device(lid_switch_idev);
+err_register:
+	input_free_device(lid_switch_idev);
+	return r;
+}
+
+static void free_lid_switch(void)
+{
+	device_remove_file(&lid_switch_idev->dev, &dev_attr_lid_wake_mode);
+	input_unregister_device(lid_switch_idev);
+	input_free_device(lid_switch_idev);
+}
+
+static int __devinit xo1_sci_probe(struct platform_device *pdev)
+{
+	struct resource *res;
+	int r;
+
+	/* don't run on non-XOs */
+	if (!machine_is_olpc())
+		return -ENODEV;
+
+	r = mfd_cell_enable(pdev);
+	if (r)
+		return r;
+
+	res = platform_get_resource(pdev, IORESOURCE_IO, 0);
+	if (!res) {
+		dev_err(&pdev->dev, "can't fetch device resource info\n");
+		return -EIO;
+	}
+	acpi_base = res->start;
+
+	r = setup_power_button(pdev);
+	if (r)
+		return r;
+
+	r = setup_ebook_switch(pdev);
+	if (r)
+		goto err_ebook;
+
+	r = setup_lid_switch(pdev);
+	if (r)
+		goto err_lid;
+
+	r = setup_lid_events();
+	if (r)
+		goto err_lidevt;
+
+	r = setup_ec_sci();
+	if (r)
+		goto err_ecsci;
+
+	/* Enable PME generation for EC-generated events */
+	outl(CS5536_GPIOM6_PME_EN | CS5536_GPIOM7_PME_EN,
+		acpi_base + CS5536_PM_GPE0_EN);
+
+	/* Clear pending events */
+	outl(0xffffffff, acpi_base + CS5536_PM_GPE0_STS);
+	process_sci_queue(false);
+
+	/* Initial sync */
+	send_ebook_state();
+	detect_lid_state();
+	send_lid_state();
+
+	r = setup_sci_interrupt(pdev);
+	if (r)
+		goto err_sci;
+
+	/* Enable all EC events */
+	olpc_ec_mask_write(EC_SCI_SRC_ALL);
+
+	return r;
+
+err_sci:
+	free_ec_sci();
+err_ecsci:
+	free_lid_events();
+err_lidevt:
+	free_lid_switch();
+err_lid:
+	free_ebook_switch();
+err_ebook:
+	free_power_button();
+	return r;
+}
+
+static int __devexit xo1_sci_remove(struct platform_device *pdev)
+{
+	mfd_cell_disable(pdev);
+	free_irq(sci_irq, pdev);
+	cancel_work_sync(&sci_work);
+	free_ec_sci();
+	free_lid_events();
+	free_lid_switch();
+	free_ebook_switch();
+	free_power_button();
+	acpi_base = 0;
+	return 0;
+}
+
+static struct platform_driver xo1_sci_driver = {
+	.driver = {
+		.name = "olpc-xo1-sci-acpi",
+	},
+	.probe = xo1_sci_probe,
+	.remove = __devexit_p(xo1_sci_remove),
+	.suspend = xo1_sci_suspend,
+	.resume = xo1_sci_resume,
+};
+
+static int __init xo1_sci_init(void)
+{
+	return platform_driver_register(&xo1_sci_driver);
+}
+arch_initcall(xo1_sci_init);
diff --git a/arch/x86/platform/olpc/olpc-xo1.c b/arch/x86/platform/olpc/olpc-xo1.c
deleted file mode 100644
index ab81fb2..0000000
--- a/arch/x86/platform/olpc/olpc-xo1.c
+++ /dev/null
@@ -1,146 +0,0 @@
-/*
- * Support for features of the OLPC XO-1 laptop
- *
- * Copyright (C) 2010 Andres Salomon <dilinger@queued.net>
- * Copyright (C) 2010 One Laptop per Child
- * Copyright (C) 2006 Red Hat, Inc.
- * Copyright (C) 2006 Advanced Micro Devices, Inc.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#include <linux/module.h>
-#include <linux/platform_device.h>
-#include <linux/pm.h>
-#include <linux/mfd/core.h>
-
-#include <asm/io.h>
-#include <asm/olpc.h>
-
-#define DRV_NAME "olpc-xo1"
-
-/* PMC registers (PMS block) */
-#define PM_SCLK		0x10
-#define PM_IN_SLPCTL	0x20
-#define PM_WKXD		0x34
-#define PM_WKD		0x30
-#define PM_SSC		0x54
-
-/* PM registers (ACPI block) */
-#define PM1_CNT		0x08
-#define PM_GPE0_STS	0x18
-
-static unsigned long acpi_base;
-static unsigned long pms_base;
-
-static void xo1_power_off(void)
-{
-	printk(KERN_INFO "OLPC XO-1 power off sequence...\n");
-
-	/* Enable all of these controls with 0 delay */
-	outl(0x40000000, pms_base + PM_SCLK);
-	outl(0x40000000, pms_base + PM_IN_SLPCTL);
-	outl(0x40000000, pms_base + PM_WKXD);
-	outl(0x40000000, pms_base + PM_WKD);
-
-	/* Clear status bits (possibly unnecessary) */
-	outl(0x0002ffff, pms_base  + PM_SSC);
-	outl(0xffffffff, acpi_base + PM_GPE0_STS);
-
-	/* Write SLP_EN bit to start the machinery */
-	outl(0x00002000, acpi_base + PM1_CNT);
-}
-
-static int __devinit olpc_xo1_probe(struct platform_device *pdev)
-{
-	struct resource *res;
-	int err;
-
-	/* don't run on non-XOs */
-	if (!machine_is_olpc())
-		return -ENODEV;
-
-	err = mfd_cell_enable(pdev);
-	if (err)
-		return err;
-
-	res = platform_get_resource(pdev, IORESOURCE_IO, 0);
-	if (!res) {
-		dev_err(&pdev->dev, "can't fetch device resource info\n");
-		return -EIO;
-	}
-	if (strcmp(pdev->name, "cs5535-pms") == 0)
-		pms_base = res->start;
-	else if (strcmp(pdev->name, "olpc-xo1-pm-acpi") == 0)
-		acpi_base = res->start;
-
-	/* If we have both addresses, we can override the poweroff hook */
-	if (pms_base && acpi_base) {
-		pm_power_off = xo1_power_off;
-		printk(KERN_INFO "OLPC XO-1 support registered\n");
-	}
-
-	return 0;
-}
-
-static int __devexit olpc_xo1_remove(struct platform_device *pdev)
-{
-	mfd_cell_disable(pdev);
-
-	if (strcmp(pdev->name, "cs5535-pms") == 0)
-		pms_base = 0;
-	else if (strcmp(pdev->name, "olpc-xo1-pm-acpi") == 0)
-		acpi_base = 0;
-
-	pm_power_off = NULL;
-	return 0;
-}
-
-static struct platform_driver cs5535_pms_drv = {
-	.driver = {
-		.name = "cs5535-pms",
-		.owner = THIS_MODULE,
-	},
-	.probe = olpc_xo1_probe,
-	.remove = __devexit_p(olpc_xo1_remove),
-};
-
-static struct platform_driver cs5535_acpi_drv = {
-	.driver = {
-		.name = "olpc-xo1-pm-acpi",
-		.owner = THIS_MODULE,
-	},
-	.probe = olpc_xo1_probe,
-	.remove = __devexit_p(olpc_xo1_remove),
-};
-
-static int __init olpc_xo1_init(void)
-{
-	int r;
-
-	r = platform_driver_register(&cs5535_pms_drv);
-	if (r)
-		return r;
-
-	r = platform_driver_register(&cs5535_acpi_drv);
-	if (r)
-		platform_driver_unregister(&cs5535_pms_drv);
-
-	return r;
-}
-
-static void __exit olpc_xo1_exit(void)
-{
-	platform_driver_unregister(&cs5535_acpi_drv);
-	platform_driver_unregister(&cs5535_pms_drv);
-}
-
-MODULE_AUTHOR("Daniel Drake <dsd@laptop.org>");
-MODULE_LICENSE("GPL");
-MODULE_ALIAS("platform:cs5535-pms");
-
-module_init(olpc_xo1_init);
-module_exit(olpc_xo1_exit);
diff --git a/arch/x86/platform/olpc/olpc-xo15-sci.c b/arch/x86/platform/olpc/olpc-xo15-sci.c
new file mode 100644
index 0000000..2b235b7
--- /dev/null
+++ b/arch/x86/platform/olpc/olpc-xo15-sci.c
@@ -0,0 +1,168 @@
+/*
+ * Support for OLPC XO-1.5 System Control Interrupts (SCI)
+ *
+ * Copyright (C) 2009-2010 One Laptop per Child
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/device.h>
+#include <linux/slab.h>
+#include <linux/workqueue.h>
+#include <linux/power_supply.h>
+
+#include <acpi/acpi_bus.h>
+#include <acpi/acpi_drivers.h>
+#include <asm/olpc.h>
+
+#define DRV_NAME			"olpc-xo15-sci"
+#define PFX				DRV_NAME ": "
+#define XO15_SCI_CLASS			DRV_NAME
+#define XO15_SCI_DEVICE_NAME		"OLPC XO-1.5 SCI"
+
+static unsigned long xo15_sci_gpe;
+
+static void battery_status_changed(void)
+{
+	struct power_supply *psy = power_supply_get_by_name("olpc-battery");
+
+	if (psy) {
+		power_supply_changed(psy);
+		put_device(psy->dev);
+	}
+}
+
+static void ac_status_changed(void)
+{
+	struct power_supply *psy = power_supply_get_by_name("olpc-ac");
+
+	if (psy) {
+		power_supply_changed(psy);
+		put_device(psy->dev);
+	}
+}
+
+static void process_sci_queue(void)
+{
+	u16 data;
+	int r;
+
+	do {
+		r = olpc_ec_sci_query(&data);
+		if (r || !data)
+			break;
+
+		pr_debug(PFX "SCI 0x%x received\n", data);
+
+		switch (data) {
+		case EC_SCI_SRC_BATERR:
+		case EC_SCI_SRC_BATSOC:
+		case EC_SCI_SRC_BATTERY:
+		case EC_SCI_SRC_BATCRIT:
+			battery_status_changed();
+			break;
+		case EC_SCI_SRC_ACPWR:
+			ac_status_changed();
+			break;
+		}
+	} while (data);
+
+	if (r)
+		pr_err(PFX "Failed to clear SCI queue");
+}
+
+static void process_sci_queue_work(struct work_struct *work)
+{
+	process_sci_queue();
+}
+
+static DECLARE_WORK(sci_work, process_sci_queue_work);
+
+static u32 xo15_sci_gpe_handler(acpi_handle gpe_device, u32 gpe, void *context)
+{
+	schedule_work(&sci_work);
+	return ACPI_INTERRUPT_HANDLED | ACPI_REENABLE_GPE;
+}
+
+static int xo15_sci_add(struct acpi_device *device)
+{
+	unsigned long long tmp;
+	acpi_status status;
+
+	if (!device)
+		return -EINVAL;
+
+	strcpy(acpi_device_name(device), XO15_SCI_DEVICE_NAME);
+	strcpy(acpi_device_class(device), XO15_SCI_CLASS);
+
+	/* Get GPE bit assignment (EC events). */
+	status = acpi_evaluate_integer(device->handle, "_GPE", NULL, &tmp);
+	if (ACPI_FAILURE(status))
+		return -EINVAL;
+
+	xo15_sci_gpe = tmp;
+	status = acpi_install_gpe_handler(NULL, xo15_sci_gpe,
+					  ACPI_GPE_EDGE_TRIGGERED,
+					  xo15_sci_gpe_handler, device);
+	if (ACPI_FAILURE(status))
+		return -ENODEV;
+
+	dev_info(&device->dev, "Initialized, GPE = 0x%lx\n", xo15_sci_gpe);
+
+	/* Flush queue, and enable all SCI events */
+	process_sci_queue();
+	olpc_ec_mask_write(EC_SCI_SRC_ALL);
+
+	acpi_enable_gpe(NULL, xo15_sci_gpe);
+
+	/* Enable wake-on-EC */
+	if (device->wakeup.flags.valid)
+		device_init_wakeup(&device->dev, true);
+
+	return 0;
+}
+
+static int xo15_sci_remove(struct acpi_device *device, int type)
+{
+	acpi_disable_gpe(NULL, xo15_sci_gpe);
+	acpi_remove_gpe_handler(NULL, xo15_sci_gpe, xo15_sci_gpe_handler);
+	cancel_work_sync(&sci_work);
+	return 0;
+}
+
+static int xo15_sci_resume(struct acpi_device *device)
+{
+	/* Enable all EC events */
+	olpc_ec_mask_write(EC_SCI_SRC_ALL);
+
+	/* Power/battery status might have changed */
+	battery_status_changed();
+	ac_status_changed();
+
+	return 0;
+}
+
+static const struct acpi_device_id xo15_sci_device_ids[] = {
+	{"XO15EC", 0},
+	{"", 0},
+};
+
+static struct acpi_driver xo15_sci_drv = {
+	.name = DRV_NAME,
+	.class = XO15_SCI_CLASS,
+	.ids = xo15_sci_device_ids,
+	.ops = {
+		.add = xo15_sci_add,
+		.remove = xo15_sci_remove,
+		.resume = xo15_sci_resume,
+	},
+};
+
+static int __init xo15_sci_init(void)
+{
+	return acpi_bus_register_driver(&xo15_sci_drv);
+}
+device_initcall(xo15_sci_init);
diff --git a/arch/x86/platform/olpc/olpc.c b/arch/x86/platform/olpc/olpc.c
index 0060fd5..8b9940e 100644
--- a/arch/x86/platform/olpc/olpc.c
+++ b/arch/x86/platform/olpc/olpc.c
@@ -19,6 +19,7 @@
 #include <linux/string.h>
 #include <linux/platform_device.h>
 #include <linux/of.h>
+#include <linux/syscore_ops.h>
 
 #include <asm/geode.h>
 #include <asm/setup.h>
@@ -30,6 +31,9 @@ EXPORT_SYMBOL_GPL(olpc_platform_info);
 
 static DEFINE_SPINLOCK(ec_lock);
 
+/* EC event mask to be applied during suspend (defining wakeup sources). */
+static u16 ec_wakeup_mask;
+
 /* what the timeout *should* be (in ms) */
 #define EC_BASE_TIMEOUT 20
 
@@ -188,6 +192,88 @@ err:
 }
 EXPORT_SYMBOL_GPL(olpc_ec_cmd);
 
+void olpc_ec_wakeup_set(u16 value)
+{
+	ec_wakeup_mask |= value;
+}
+EXPORT_SYMBOL_GPL(olpc_ec_wakeup_set);
+
+void olpc_ec_wakeup_clear(u16 value)
+{
+	ec_wakeup_mask &= ~value;
+}
+EXPORT_SYMBOL_GPL(olpc_ec_wakeup_clear);
+
+/*
+ * Returns true if the compile and runtime configurations allow for EC events
+ * to wake the system.
+ */
+bool olpc_ec_wakeup_available(void)
+{
+	if (!machine_is_olpc())
+		return false;
+
+	/*
+	 * XO-1 EC wakeups are available when olpc-xo1-sci driver is
+	 * compiled in
+	 */
+#ifdef CONFIG_OLPC_XO1_SCI
+	if (olpc_platform_info.boardrev < olpc_board_pre(0xd0)) /* XO-1 */
+		return true;
+#endif
+
+	/*
+	 * XO-1.5 EC wakeups are available when olpc-xo15-sci driver is
+	 * compiled in
+	 */
+#ifdef CONFIG_OLPC_XO15_SCI
+	if (olpc_platform_info.boardrev >= olpc_board_pre(0xd0)) /* XO-1.5 */
+		return true;
+#endif
+
+	return false;
+}
+EXPORT_SYMBOL_GPL(olpc_ec_wakeup_available);
+
+int olpc_ec_mask_write(u16 bits)
+{
+	if (olpc_platform_info.flags & OLPC_F_EC_WIDE_SCI) {
+		__be16 ec_word = cpu_to_be16(bits);
+		return olpc_ec_cmd(EC_WRITE_EXT_SCI_MASK, (void *) &ec_word, 2,
+				   NULL, 0);
+	} else {
+		unsigned char ec_byte = bits & 0xff;
+		return olpc_ec_cmd(EC_WRITE_SCI_MASK, &ec_byte, 1, NULL, 0);
+	}
+}
+EXPORT_SYMBOL_GPL(olpc_ec_mask_write);
+
+int olpc_ec_sci_query(u16 *sci_value)
+{
+	int ret;
+
+	if (olpc_platform_info.flags & OLPC_F_EC_WIDE_SCI) {
+		__be16 ec_word;
+		ret = olpc_ec_cmd(EC_EXT_SCI_QUERY,
+			NULL, 0, (void *) &ec_word, 2);
+		if (ret == 0)
+			*sci_value = be16_to_cpu(ec_word);
+	} else {
+		unsigned char ec_byte;
+		ret = olpc_ec_cmd(EC_SCI_QUERY, NULL, 0, &ec_byte, 1);
+		if (ret == 0)
+			*sci_value = ec_byte;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(olpc_ec_sci_query);
+
+static int olpc_ec_suspend(void)
+{
+	return olpc_ec_mask_write(ec_wakeup_mask);
+}
+
 static bool __init check_ofw_architecture(struct device_node *root)
 {
 	const char *olpc_arch;
@@ -242,6 +328,10 @@ static int __init add_xo1_platform_devices(void)
 	return 0;
 }
 
+static struct syscore_ops olpc_syscore_ops = {
+	.suspend = olpc_ec_suspend,
+};
+
 static int __init olpc_init(void)
 {
 	int r = 0;
@@ -266,6 +356,9 @@ static int __init olpc_init(void)
 			!cs5535_has_vsa2())
 		x86_init.pci.arch_init = pci_olpc_init;
 #endif
+	/* EC version 0x5f adds support for wide SCI mask */
+	if (olpc_platform_info.ecver >= 0x5f)
+		olpc_platform_info.flags |= OLPC_F_EC_WIDE_SCI;
 
 	printk(KERN_INFO "OLPC board revision %s%X (EC=%x)\n",
 			((olpc_platform_info.boardrev & 0xf) < 8) ? "pre" : "",
@@ -278,6 +371,8 @@ static int __init olpc_init(void)
 			return r;
 	}
 
+	register_syscore_ops(&olpc_syscore_ops);
+
 	return 0;
 }
 
diff --git a/arch/x86/platform/olpc/olpc_dt.c b/arch/x86/platform/olpc/olpc_dt.c
index d39f63d..d6ee929 100644
--- a/arch/x86/platform/olpc/olpc_dt.c
+++ b/arch/x86/platform/olpc/olpc_dt.c
@@ -165,6 +165,107 @@ static struct of_pdt_ops prom_olpc_ops __initdata = {
 	.pkg2path = olpc_dt_pkg2path,
 };
 
+static phandle __init olpc_dt_finddevice(const char *path)
+{
+	phandle node;
+	const void *args[] = { path };
+	void *res[] = { &node };
+
+	if (olpc_ofw("finddevice", args, res)) {
+		pr_err("olpc_dt: finddevice failed!\n");
+		return 0;
+	}
+
+	if ((s32) node == -1)
+		return 0;
+
+	return node;
+}
+
+static int __init olpc_dt_interpret(const char *words)
+{
+	int result;
+	const void *args[] = { words };
+	void *res[] = { &result };
+
+	if (olpc_ofw("interpret", args, res)) {
+		pr_err("olpc_dt: interpret failed!\n");
+		return -1;
+	}
+
+	return result;
+}
+
+/*
+ * Extract board revision directly from OFW device tree.
+ * We can't use olpc_platform_info because that hasn't been set up yet.
+ */
+static u32 __init olpc_dt_get_board_revision(void)
+{
+	phandle node;
+	__be32 rev;
+	int r;
+
+	node = olpc_dt_finddevice("/");
+	if (!node)
+		return 0;
+
+	r = olpc_dt_getproperty(node, "board-revision-int",
+				(char *) &rev, sizeof(rev));
+	if (r < 0)
+		return 0;
+
+	return be32_to_cpu(rev);
+}
+
+void __init olpc_dt_fixup(void)
+{
+	int r;
+	char buf[64];
+	phandle node;
+	u32 board_rev;
+
+	node = olpc_dt_finddevice("/battery@0");
+	if (!node)
+		return;
+
+	/*
+	 * If the battery node has a compatible property, we are running a new
+	 * enough firmware and don't have fixups to make.
+	 */
+	r = olpc_dt_getproperty(node, "compatible", buf, sizeof(buf));
+	if (r > 0)
+		return;
+
+	pr_info("PROM DT: Old firmware detected, applying fixes\n");
+
+	/* Add olpc,xo1-battery compatible marker to battery node */
+	olpc_dt_interpret("\" /battery@0\" find-device"
+		" \" olpc,xo1-battery\" +compatible"
+		" device-end");
+
+	board_rev = olpc_dt_get_board_revision();
+	if (!board_rev)
+		return;
+
+	if (board_rev >= olpc_board_pre(0xd0)) {
+		/* XO-1.5: add dcon device */
+		olpc_dt_interpret("\" /pci/display@1\" find-device"
+			" new-device"
+			" \" dcon\" device-name \" olpc,xo1-dcon\" +compatible"
+			" finish-device device-end");
+	} else {
+		/* XO-1: add dcon device, mark RTC as olpc,xo1-rtc */
+		olpc_dt_interpret("\" /pci/display@1,1\" find-device"
+			" new-device"
+			" \" dcon\" device-name \" olpc,xo1-dcon\" +compatible"
+			" finish-device device-end"
+			" \" /rtc\" find-device"
+			" \" olpc,xo1-rtc\" +compatible"
+			" device-end");
+	}
+}
+
 void __init olpc_dt_build_devicetree(void)
 {
 	phandle root;
@@ -172,6 +273,8 @@ void __init olpc_dt_build_devicetree(void)
 	if (!olpc_ofw_is_installed())
 		return;
 
+	olpc_dt_fixup();
+
 	root = olpc_dt_getsibling(0);
 	if (!root) {
 		pr_err("PROM: unable to get root node from OFW!\n");
diff --git a/arch/x86/platform/olpc/xo1-wakeup.S b/arch/x86/platform/olpc/xo1-wakeup.S
new file mode 100644
index 0000000..948deb2
--- /dev/null
+++ b/arch/x86/platform/olpc/xo1-wakeup.S
@@ -0,0 +1,124 @@
+.text
+#include <linux/linkage.h>
+#include <asm/segment.h>
+#include <asm/page.h>
+#include <asm/pgtable_32.h>
+
+	.macro writepost,value
+		movb $0x34, %al
+		outb %al, $0x70
+		movb $\value, %al
+		outb %al, $0x71
+	.endm
+
+wakeup_start:
+	# OFW lands us here, running in protected mode, with a
+	# kernel-compatible GDT already setup.
+
+	# Clear any dangerous flags
+	pushl $0
+	popfl
+
+	writepost 0x31
+
+	# Set up %cr3
+	movl $initial_page_table - __PAGE_OFFSET, %eax
+	movl %eax, %cr3
+
+	movl saved_cr4, %eax
+	movl %eax, %cr4
+
+	movl saved_cr0, %eax
+	movl %eax, %cr0
+
+	# Control registers were modified, pipeline resync is needed
+	jmp 1f
+1:
+
+	movw    $__KERNEL_DS, %ax
+	movw    %ax, %ss
+	movw    %ax, %ds
+	movw    %ax, %es
+	movw    %ax, %fs
+	movw    %ax, %gs
+
+	lgdt    saved_gdt
+	lidt    saved_idt
+	lldt    saved_ldt
+	ljmp    $(__KERNEL_CS),$1f
+1:
+	movl    %cr3, %eax
+	movl    %eax, %cr3
+	wbinvd
+
+	# Go back to the return point
+	jmp ret_point
+
+save_registers:
+	sgdt  saved_gdt
+	sidt  saved_idt
+	sldt  saved_ldt
+
+	pushl %edx
+	movl %cr4, %edx
+	movl %edx, saved_cr4
+
+	movl %cr0, %edx
+	movl %edx, saved_cr0
+
+	popl %edx
+
+	movl %ebx, saved_context_ebx
+	movl %ebp, saved_context_ebp
+	movl %esi, saved_context_esi
+	movl %edi, saved_context_edi
+
+	pushfl
+	popl saved_context_eflags
+
+	ret
+
+restore_registers:
+	movl saved_context_ebp, %ebp
+	movl saved_context_ebx, %ebx
+	movl saved_context_esi, %esi
+	movl saved_context_edi, %edi
+
+	pushl saved_context_eflags
+	popfl
+
+	ret
+
+ENTRY(do_olpc_suspend_lowlevel)
+	call	save_processor_state
+	call	save_registers
+
+	# This is the stack context we want to remember
+	movl %esp, saved_context_esp
+
+	pushl	$3
+	call	xo1_do_sleep
+
+	jmp	wakeup_start
+	.p2align 4,,7
+ret_point:
+	movl    saved_context_esp, %esp
+
+	writepost 0x32
+
+	call	restore_registers
+	call	restore_processor_state
+	ret
+
+.data
+saved_gdt:             .long   0,0
+saved_idt:             .long   0,0
+saved_ldt:             .long   0
+saved_cr4:             .long   0
+saved_cr0:             .long   0
+saved_context_esp:     .long   0
+saved_context_edi:     .long   0
+saved_context_esi:     .long   0
+saved_context_ebx:     .long   0
+saved_context_ebp:     .long   0
+saved_context_eflags:  .long   0
diff --git a/include/linux/cs5535.h b/include/linux/cs5535.h
index 6fe2114..c077aec 100644
--- a/include/linux/cs5535.h
+++ b/include/linux/cs5535.h
@@ -11,6 +11,8 @@
 #ifndef _CS5535_H
 #define _CS5535_H
 
+#include <asm/msr.h>
+
 /* MSRs */
 #define MSR_GLIU_P2D_RO0	0x10000029
 
@@ -38,17 +40,75 @@
 #define MSR_MFGPT_NR		0x51400029
 #define MSR_MFGPT_SETUP		0x5140002B
 
+#define MSR_RTC_DOMA_OFFSET	0x51400055
+#define MSR_RTC_MONA_OFFSET	0x51400056
+#define MSR_RTC_CEN_OFFSET	0x51400057
+
 #define MSR_LX_SPARE_MSR	0x80000011	/* DC-specific */
 
 #define MSR_GX_GLD_MSR_CONFIG	0xC0002001
 #define MSR_GX_MSR_PADSEL	0xC0002011
 
+static inline int cs5535_pic_unreqz_select_high(unsigned int group,
+						unsigned int irq)
+{
+	uint32_t lo, hi;
+
+	rdmsr(MSR_PIC_ZSEL_HIGH, lo, hi);
+	lo &= ~(0xF << (group * 4));
+	lo |= (irq & 0xF) << (group * 4);
+	wrmsr(MSR_PIC_ZSEL_HIGH, lo, hi);
+	return 0;
+}
+
+/* PIC registers */
+#define CS5536_PIC_INT_SEL1	0x4d0
+#define CS5536_PIC_INT_SEL2	0x4d1
+
 /* resource sizes */
 #define LBAR_GPIO_SIZE		0xFF
 #define LBAR_MFGPT_SIZE		0x40
 #define LBAR_ACPI_SIZE		0x40
 #define LBAR_PMS_SIZE		0x80
 
+/*
+ * PMC registers (PMS block)
+ * It is only safe to access these registers as dword accesses.
+ * See CS5536 Specification Update erratas 17 & 18
+ */
+#define CS5536_PM_SCLK		0x10
+#define CS5536_PM_IN_SLPCTL	0x20
+#define CS5536_PM_WKXD		0x34
+#define CS5536_PM_WKD		0x30
+#define CS5536_PM_SSC		0x54
+
+/*
+ * PM registers (ACPI block)
+ * It is only safe to access these registers as dword accesses.
+ * See CS5536 Specification Update erratas 17 & 18
+ */
+#define CS5536_PM1_STS		0x00
+#define CS5536_PM1_EN		0x02
+#define CS5536_PM1_CNT		0x08
+#define CS5536_PM_GPE0_STS	0x18
+#define CS5536_PM_GPE0_EN	0x1c
+
+/* CS5536_PM1_STS bits */
+#define CS5536_WAK_FLAG		(1 << 15)
+#define CS5536_PWRBTN_FLAG	(1 << 8)
+
+/* CS5536_PM1_EN bits */
+#define CS5536_PM_PWRBTN	(1 << 8)
+#define CS5536_PM_RTC		(1 << 10)
+
+/* CS5536_PM_GPE0_STS bits */
+#define CS5536_GPIOM7_PME_FLAG	(1 << 31)
+#define CS5536_GPIOM6_PME_FLAG	(1 << 30)
+
+/* CS5536_PM_GPE0_EN bits */
+#define CS5536_GPIOM7_PME_EN	(1 << 31)
+#define CS5536_GPIOM6_PME_EN	(1 << 30)
+
 /* VSA2 magic values */
 #define VSA_VRC_INDEX		0xAC1C
 #define VSA_VRC_DATA		0xAC1E
