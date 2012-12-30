Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230Ab2L3WrY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2012 17:47:24 -0500
Received: from server.prisktech.co.nz ([115.188.14.127]:52898 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755160Ab2L3WrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2012 17:47:14 -0500
From: Tony Prisk <linux@prisktech.co.nz>
To: Input Mailing List <linux-input@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        Tony Prisk <linux@prisktech.co.nz>
Subject: [RFC PATCH] input: i8042: Add support for devicetree to i8042 serio driver
Date: Mon, 31 Dec 2012 11:47:09 +1300
Message-Id: <1356907629-25459-2-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1356907629-25459-1-git-send-email-linux@prisktech.co.nz>
References: <1356907629-25459-1-git-send-email-linux@prisktech.co.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds basic devicetree support for the i8042 controller
driver.

Simple properties to specify the register offsets.
Optional properties to specify the linux device descriptions.

Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
---
 .../devicetree/bindings/input/intel-8042.txt       |   29 +++++
 drivers/input/serio/Kconfig                        |   10 +-
 drivers/input/serio/i8042-dt.h                     |  127 ++++++++++++++++++++
 drivers/input/serio/i8042.c                        |   15 ++-
 drivers/input/serio/i8042.h                        |    4 +-
 5 files changed, 181 insertions(+), 4 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/input/intel-8042.txt
 create mode 100644 drivers/input/serio/i8042-dt.h

diff --git a/Documentation/devicetree/bindings/input/intel-8042.txt b/Documentation/devicetree/bindings/input/intel-8042.txt
new file mode 100644
index 0000000..68f6fa2
--- /dev/null
+++ b/Documentation/devicetree/bindings/input/intel-8042.txt
@@ -0,0 +1,29 @@
+* Intel 8042 Keyboard controller
+
+Required properties:
+- compatible: should be "intel,8042"
+- regs: memory for keyboard controller
+- interrupts: two interrupts should be specified (keyboard and aux).
+- command-reg: offset in memory for command register
+- status-reg: offset in memory for status register
+- data-reg: offset in memory for data register
+
+Optional properties:
+- init-reset: Controller should be reset on init and cleanup
+
+Optional linux specific properties:
+- linux,kbd_phys_desc: defaults to i8042/serio0
+- linux,aux_phys_desc: defaults to i8042/serio1
+- linux,mux_phys_desc: defaults to i8042/serio%d
+
+
+Example:
+	keyboard@d8008800 {
+		compatible = "intel,8042";
+		reg = <0xD8008800 0x100>;
+		interrupts = <23 4>;
+		command-reg = <0x04>;
+		status-reg = <0x04>;
+		data-reg = <0x00>;
+		mux-ports = <2>;
+	};
diff --git a/drivers/input/serio/Kconfig b/drivers/input/serio/Kconfig
index 4a4e182..26e97a3 100644
--- a/drivers/input/serio/Kconfig
+++ b/drivers/input/serio/Kconfig
@@ -21,8 +21,9 @@ if SERIO
 config SERIO_I8042
 	tristate "i8042 PC Keyboard controller" if EXPERT || !X86
 	default y
-	depends on !PARISC && (!ARM || ARCH_SHARK || FOOTBRIDGE_HOST) && \
-		   (!SUPERH || SH_CAYMAN) && !M68K && !BLACKFIN
+	depends on (!PARISC && (!ARM || ARCH_SHARK || FOOTBRIDGE_HOST) && \
+		   (!SUPERH || SH_CAYMAN) && !M68K && !BLACKFIN) || \
+		   (SERIO_I8042_DT)
 	help
 	  i8042 is the chip over which the standard AT keyboard and PS/2
 	  mouse are connected to the computer. If you use these devices,
@@ -33,6 +34,11 @@ config SERIO_I8042
 	  To compile this driver as a module, choose M here: the
 	  module will be called i8042.
 
+config SERIO_I8042_DT
+	tristate "i8042 Keyboard controller DT support" if EXPERT || !X86
+	depends on USE_OF
+	select SERIO_I8042
+
 config SERIO_SERPORT
 	tristate "Serial port line discipline"
 	default y
diff --git a/drivers/input/serio/i8042-dt.h b/drivers/input/serio/i8042-dt.h
new file mode 100644
index 0000000..3875c90
--- /dev/null
+++ b/drivers/input/serio/i8042-dt.h
@@ -0,0 +1,127 @@
+#ifndef _I8042_DT_H
+#define _I8042_DT_H
+
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+
+/*
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ */
+
+static void __iomem *dt_base;
+static const char *dt_kbd_phys_desc;
+static const char *dt_aux_phys_desc;
+static const char *dt_mux_phys_desc;
+static int dt_kbd_irq;
+static int dt_aux_irq;
+static unsigned int dt_command_reg;
+static unsigned int dt_status_reg;
+static unsigned int dt_data_reg;
+
+#define I8042_KBD_PHYS_DESC	dt_kbd_phys_desc
+#define I8042_AUX_PHYS_DESC	dt_aux_phys_desc
+#define I8042_MUX_PHYS_DESC	dt_mux_phys_desc
+
+#define I8042_KBD_IRQ		(dt_kbd_irq)
+#define I8042_AUX_IRQ		(dt_aux_irq)
+
+#define I8042_COMMAND_REG	(dt_command_reg)
+#define I8042_STATUS_REG	(dt_status_reg)
+#define I8042_DATA_REG		(dt_data_reg)
+
+
+static inline int i8042_read_data(void)
+{
+	return readb(dt_base + dt_data_reg);
+}
+
+static inline int i8042_read_status(void)
+{
+	return readb(dt_base + dt_status_reg);
+}
+
+static inline void i8042_write_data(int val)
+{
+	writeb(val, dt_base + dt_data_reg);
+}
+
+static inline void i8042_write_command(int val)
+{
+	writeb(val, dt_base + dt_command_reg);
+}
+
+static inline int dt_parse_node(struct device_node *np)
+{
+	int ret;
+
+	dt_base = of_iomap(np, 0);
+	if (!dt_base)
+		return -ENOMEM;
+
+	ret = of_property_read_u32(np, "command-reg", &dt_command_reg);
+	if (ret) {
+		pr_err("i8042-dt: command-reg missing or invalid\n");
+		return ret;
+	}
+
+	ret = of_property_read_u32(np, "status-reg", &dt_status_reg);
+	if (ret) {
+		pr_err("i8042-dt: status-reg missing or invalid\n");
+		return ret;
+	}
+
+	ret = of_property_read_u32(np, "data-reg", &dt_data_reg);
+	if (ret) {
+		pr_err("i8042-dt: data-reg missing or invalid\n");
+		return ret;
+	}
+
+	dt_kbd_irq = irq_of_parse_and_map(np, 0);
+	dt_aux_irq = irq_of_parse_and_map(np, 1);
+
+	ret = of_property_read_string(np, "linux,kbd_phys_desc",
+					&dt_kbd_phys_desc);
+	if (ret)
+		dt_kbd_phys_desc = "i8042/serio0";
+
+	ret = of_property_read_string(np, "linux,aux_phys_desc",
+					&dt_aux_phys_desc);
+	if (ret)
+		dt_aux_phys_desc = "i8042/serio1";
+
+	ret = of_property_read_string(np, "linux,mux_phys_desc",
+					&dt_mux_phys_desc);
+	if (ret)
+		dt_mux_phys_desc = "i8042/serio%d";
+
+	if (of_get_property(np, "init-reset", NULL))
+		i8042_reset = true;
+
+	return 0;
+}
+
+static inline int i8042_platform_init(void)
+{
+	struct device_node *np;
+
+	np = of_find_compatible_node(NULL, NULL, "intel,8042");
+	if (!np) {
+		pr_err("%s: no devicetree node found\n", __func__);
+		return -ENODEV;
+	}
+
+	dt_parse_node(np);
+
+	return 0;
+}
+
+static inline void i8042_platform_exit(void)
+{
+	if (dt_base)
+		iounmap(dt_base);
+}
+
+#endif
diff --git a/drivers/input/serio/i8042.c b/drivers/input/serio/i8042.c
index 78e4de4..c4cb1c4 100644
--- a/drivers/input/serio/i8042.c
+++ b/drivers/input/serio/i8042.c
@@ -1447,6 +1447,11 @@ static int i8042_remove(struct platform_device *dev)
 	return 0;
 }
 
+static struct of_device_id i8042_dt_ids[] = {
+	{ .compatible = "intel,8042" },
+	{ /* Sentinel */ },
+};
+
 static struct platform_driver i8042_driver = {
 	.driver		= {
 		.name	= "i8042",
@@ -1454,6 +1459,7 @@ static struct platform_driver i8042_driver = {
 #ifdef CONFIG_PM
 		.pm	= &i8042_pm_ops,
 #endif
+		.of_match_table = i8042_dt_ids,
 	},
 	.remove		= i8042_remove,
 	.shutdown	= i8042_shutdown,
@@ -1461,7 +1467,9 @@ static struct platform_driver i8042_driver = {
 
 static int __init i8042_init(void)
 {
+#ifndef CONFIG_SERIO_I8042_DT
 	struct platform_device *pdev;
+#endif
 	int err;
 
 	dbg_init();
@@ -1474,12 +1482,17 @@ static int __init i8042_init(void)
 	if (err)
 		goto err_platform_exit;
 
+#ifdef CONFIG_SERIO_I8042_DT
+	err = platform_driver_probe(&i8042_driver, i8042_probe);
+	if (err)
+		goto err_platform_exit;
+#else
 	pdev = platform_create_bundle(&i8042_driver, i8042_probe, NULL, 0, NULL, 0);
 	if (IS_ERR(pdev)) {
 		err = PTR_ERR(pdev);
 		goto err_platform_exit;
 	}
-
+#endif
 	panic_blink = i8042_panic_blink;
 
 	return 0;
diff --git a/drivers/input/serio/i8042.h b/drivers/input/serio/i8042.h
index 3452708..c8d70d9 100644
--- a/drivers/input/serio/i8042.h
+++ b/drivers/input/serio/i8042.h
@@ -14,7 +14,9 @@
  * Arch-dependent inline functions and defines.
  */
 
-#if defined(CONFIG_MACH_JAZZ)
+#if defined(CONFIG_SERIO_I8042_DT)
+#include "i8042-dt.h"
+#elif defined(CONFIG_MACH_JAZZ)
 #include "i8042-jazzio.h"
 #elif defined(CONFIG_SGI_HAS_I8042)
 #include "i8042-ip22io.h"
-- 
1.7.9.5

