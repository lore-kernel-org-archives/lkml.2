Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756878Ab2BAVGq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:06:46 -0500
Received: from mail.savoirfairelinux.com ([209.172.62.77]:44724 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932355Ab2BAVGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:06:36 -0500
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: x86@kernel.org
Cc: Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org, Guenter Roeck <guenter.roeck@ericsson.com>,
        Jean Delvare <khali@linux-fr.org>
Subject: [PATCH v5 5/5] x86/platform: (TS-5500) add ADC support
Date: Wed,  1 Feb 2012 16:05:44 -0500
Message-Id: <1328130344-18836-6-git-send-email-vivien.didelot@savoirfairelinux.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1328130344-18836-1-git-send-email-vivien.didelot@savoirfairelinux.com>
References: <1328130344-18836-1-git-send-email-vivien.didelot@savoirfairelinux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
---
 arch/x86/platform/ts5500/Kconfig      |    7 ++
 arch/x86/platform/ts5500/Makefile     |    1 +
 arch/x86/platform/ts5500/ts5500_adc.c |  104 +++++++++++++++++++++++++++++++++
 3 files changed, 112 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/platform/ts5500/ts5500_adc.c

diff --git a/arch/x86/platform/ts5500/Kconfig b/arch/x86/platform/ts5500/Kconfig
index 76f777f..d6f5a8a 100644
--- a/arch/x86/platform/ts5500/Kconfig
+++ b/arch/x86/platform/ts5500/Kconfig
@@ -20,3 +20,10 @@ config TS5500_LED
 	default y
 	help
 	  This option enables support for the on-chip LED.
+
+config TS5500_ADC
+	tristate "TS-5500 ADC"
+	depends on TS5500 && SENSORS_MAX197
+	default y
+	help
+      Support for the A/D converter on Technologic Systems TS-5500 SBCs.
diff --git a/arch/x86/platform/ts5500/Makefile b/arch/x86/platform/ts5500/Makefile
index 88eccc9..dcf46d8 100644
--- a/arch/x86/platform/ts5500/Makefile
+++ b/arch/x86/platform/ts5500/Makefile
@@ -1,3 +1,4 @@
 obj-$(CONFIG_TS5500)			+= ts5500.o
 obj-$(CONFIG_TS5500_GPIO)		+= ts5500_gpio.o
 obj-$(CONFIG_TS5500_LED)		+= ts5500_led.o
+obj-$(CONFIG_TS5500_ADC)		+= ts5500_adc.o
diff --git a/arch/x86/platform/ts5500/ts5500_adc.c b/arch/x86/platform/ts5500/ts5500_adc.c
new file mode 100644
index 0000000..c55a283
--- /dev/null
+++ b/arch/x86/platform/ts5500/ts5500_adc.c
@@ -0,0 +1,104 @@
+/*
+ * Technologic Systems TS-5500 boards - Mapped MAX197 ADC driver
+ *
+ * Copyright (c) 2010-2012 Savoir-faire Linux Inc.
+ *          Jonas Fonseca <jonas.fonseca@savoirfairelinux.com>
+ *          Vivien Didelot <vivien.didelot@savoirfairelinux.com>
+ *
+ * The TS-5500 uses a CPLD to abstract the interface to the MAX197.
+ * This driver should work unchanged with the MAX199 chip.
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
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/device.h>
+#include <linux/delay.h>
+#include <linux/platform_device.h>
+#include <linux/err.h>
+#include <linux/sysfs.h>
+#include <linux/hwmon.h>
+#include <linux/hwmon-sysfs.h>
+#include <linux/mutex.h>
+#include <linux/slab.h>
+#include <linux/io.h>
+#include <linux/max197.h>
+
+#define TS5500_ADC_CTRL_REG		0x195	/* Conversion state register */
+#define TS5500_ADC_INIT_LSB_REG		0x196	/* Init conv. / LSB register */
+#define TS5500_ADC_MSB_REG		0x197	/* MSB register */
+#define TS5500_ADC_READ_DELAY		12	/* usec */
+#define TS5500_ADC_READ_BUSY_MASK	0x01
+
+static int ts5500_adc_start(u8 ctrl)
+{
+	/* Ensure the 3 MSB are set to 0 */
+	outb(ctrl & 0x1F, TS5500_ADC_INIT_LSB_REG);
+
+	return 0;
+}
+
+static int ts5500_adc_read(u16 *raw)
+{
+	u8 lsb, msb;
+
+	udelay(TS5500_ADC_READ_DELAY);
+	lsb = inb(TS5500_ADC_CTRL_REG);
+
+	if (lsb & TS5500_ADC_READ_BUSY_MASK)
+		return -EBUSY;
+
+	lsb = inb(TS5500_ADC_INIT_LSB_REG);
+	msb = inb(TS5500_ADC_MSB_REG);
+	*raw = (msb << 8) | lsb;
+
+	return 0;
+}
+
+static struct max197_platform_data ts5500_adc_platform_data = {
+	.start = ts5500_adc_start,
+	.read = ts5500_adc_read
+};
+
+static void ts5500_adc_release(struct device *dev)
+{
+	/* noop */
+}
+
+static struct platform_device ts5500_adc_device = {
+	.name = "max197",
+	.id = -1,
+	.dev = {
+		.platform_data = &ts5500_adc_platform_data,
+		.release = ts5500_adc_release
+	}
+};
+
+static int __init ts5500_adc_init(void)
+{
+	return platform_device_register(&ts5500_adc_device);
+}
+module_init(ts5500_adc_init);
+
+static void __exit ts5500_adc_exit(void)
+{
+	platform_device_unregister(&ts5500_adc_device);
+}
+module_exit(ts5500_adc_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("TS-5500 mapped MAX197 ADC device driver");
-- 
1.7.6.5

