Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718Ab1EDUEr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 16:04:47 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:14683 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755660Ab1EDUEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 16:04:46 -0400
Message-Id: <201105042004.p44K4hh5011720@farm-0032.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Wed, 4 May 2011 15:52:21 -0400
Subject: [PATCH] tile: add an RTC driver for the Tilera hypervisor
To: linux-kernel@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com
X-OriginalArrivalTime: 04 May 2011 20:04:44.0980 (UTC) FILETIME=[83389F40:01CC0A96]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a simple RTC driver that lets Tilera hardware boot up and
set the clock correctly.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/configs/tile_defconfig   |    1 +
 arch/tile/configs/tilegx_defconfig |   63 ++++++++++++++-
 arch/tile/drivers/Makefile         |    1 +
 drivers/rtc/Kconfig                |    7 ++
 drivers/rtc/Makefile               |    1 +
 drivers/rtc/rtc-tile.c             |  157 ++++++++++++++++++++++++++++++++++++
 6 files changed, 227 insertions(+), 3 deletions(-)
 create mode 100644 drivers/rtc/rtc-tile.c

diff --git a/arch/tile/configs/tile_defconfig b/arch/tile/configs/tile_defconfig
index 041c456..6f7ed60 100644
--- a/arch/tile/configs/tile_defconfig
+++ b/arch/tile/configs/tile_defconfig
@@ -797,6 +797,7 @@ CONFIG_RTC_INTF_DEV=y
 #
 # on-CPU RTC drivers
 #
+CONFIG_RTC_DRV_TILE=y
 # CONFIG_DMADEVICES is not set
 # CONFIG_AUXDISPLAY is not set
 # CONFIG_UIO is not set
diff --git a/arch/tile/configs/tilegx_defconfig b/arch/tile/configs/tilegx_defconfig
index 6343962..88613d4 100644
--- a/arch/tile/configs/tilegx_defconfig
+++ b/arch/tile/configs/tilegx_defconfig
@@ -1136,8 +1136,6 @@ CONFIG_HVC_DRIVER=y
 # CONFIG_IPMI_HANDLER is not set
 CONFIG_HW_RANDOM=y
 CONFIG_HW_RANDOM_TIMERIOMEM=m
-# CONFIG_RTC is not set
-# CONFIG_GEN_RTC is not set
 # CONFIG_R3964 is not set
 # CONFIG_APPLICOM is not set
 
@@ -1278,7 +1276,66 @@ CONFIG_MFD_SUPPORT=y
 # CONFIG_ACCESSIBILITY is not set
 # CONFIG_INFINIBAND is not set
 # CONFIG_EDAC is not set
-# CONFIG_RTC_CLASS is not set
+CONFIG_RTC_LIB=y
+CONFIG_RTC_CLASS=y
+CONFIG_RTC_HCTOSYS=y
+CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
+# CONFIG_RTC_DEBUG is not set
+
+#
+# RTC interfaces
+#
+CONFIG_RTC_INTF_SYSFS=y
+CONFIG_RTC_INTF_PROC=y
+CONFIG_RTC_INTF_DEV=y
+# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
+# CONFIG_RTC_DRV_TEST is not set
+
+#
+# I2C RTC drivers
+#
+# CONFIG_RTC_DRV_DS1307 is not set
+# CONFIG_RTC_DRV_DS1374 is not set
+# CONFIG_RTC_DRV_DS1672 is not set
+# CONFIG_RTC_DRV_DS3232 is not set
+# CONFIG_RTC_DRV_MAX6900 is not set
+# CONFIG_RTC_DRV_RS5C372 is not set
+# CONFIG_RTC_DRV_ISL1208 is not set
+# CONFIG_RTC_DRV_ISL12022 is not set
+# CONFIG_RTC_DRV_X1205 is not set
+# CONFIG_RTC_DRV_PCF8563 is not set
+# CONFIG_RTC_DRV_PCF8583 is not set
+# CONFIG_RTC_DRV_M41T80 is not set
+# CONFIG_RTC_DRV_BQ32K is not set
+# CONFIG_RTC_DRV_S35390A is not set
+# CONFIG_RTC_DRV_FM3130 is not set
+# CONFIG_RTC_DRV_RX8581 is not set
+# CONFIG_RTC_DRV_RX8025 is not set
+
+#
+# SPI RTC drivers
+#
+
+#
+# Platform RTC drivers
+#
+# CONFIG_RTC_DRV_DS1286 is not set
+# CONFIG_RTC_DRV_DS1511 is not set
+# CONFIG_RTC_DRV_DS1553 is not set
+# CONFIG_RTC_DRV_DS1742 is not set
+# CONFIG_RTC_DRV_STK17TA8 is not set
+# CONFIG_RTC_DRV_M48T86 is not set
+# CONFIG_RTC_DRV_M48T35 is not set
+# CONFIG_RTC_DRV_M48T59 is not set
+# CONFIG_RTC_DRV_MSM6242 is not set
+# CONFIG_RTC_DRV_BQ4802 is not set
+# CONFIG_RTC_DRV_RP5C01 is not set
+# CONFIG_RTC_DRV_V3020 is not set
+
+#
+# on-CPU RTC drivers
+#
+CONFIG_RTC_DRV_TILE=y
 # CONFIG_DMADEVICES is not set
 # CONFIG_AUXDISPLAY is not set
 # CONFIG_UIO is not set
diff --git a/arch/tile/drivers/Makefile b/arch/tile/drivers/Makefile
index 311e741..30c5de0 100644
--- a/arch/tile/drivers/Makefile
+++ b/arch/tile/drivers/Makefile
@@ -7,6 +7,7 @@
 #
 #  drivers/net/tile/			network
 #  drivers/tty/hvc/hvc_tile.c		hypervisor console
+#  drivers/rtc/rtc-tile.c		RTC driver
 #  drivers/edac/tile_edac.c		EDAC driver
 #
 
diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index e187887..d2c615f 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -995,4 +995,11 @@ config RTC_DRV_TEGRA
 	  This drive can also be built as a module. If so, the module
 	  will be called rtc-tegra.
 
+config RTC_DRV_TILE
+	tristate "Tilera hypervisor RTC support"
+	depends on TILE
+	help
+	  Enable support for the Linux driver side of the Tilera
+	  hypervisor's real-time clock interface.
+
 endif # RTC_CLASS
diff --git a/drivers/rtc/Makefile b/drivers/rtc/Makefile
index ca91c3c..9574748 100644
--- a/drivers/rtc/Makefile
+++ b/drivers/rtc/Makefile
@@ -93,6 +93,7 @@ obj-$(CONFIG_RTC_DRV_STMP)	+= rtc-stmp3xxx.o
 obj-$(CONFIG_RTC_DRV_SUN4V)	+= rtc-sun4v.o
 obj-$(CONFIG_RTC_DRV_TEGRA)	+= rtc-tegra.o
 obj-$(CONFIG_RTC_DRV_TEST)	+= rtc-test.o
+obj-$(CONFIG_RTC_DRV_TILE)	+= rtc-tile.o
 obj-$(CONFIG_RTC_DRV_TWL4030)	+= rtc-twl.o
 obj-$(CONFIG_RTC_DRV_TX4939)	+= rtc-tx4939.o
 obj-$(CONFIG_RTC_DRV_V3020)	+= rtc-v3020.o
diff --git a/drivers/rtc/rtc-tile.c b/drivers/rtc/rtc-tile.c
new file mode 100644
index 0000000..27c205e
--- /dev/null
+++ b/drivers/rtc/rtc-tile.c
@@ -0,0 +1,157 @@
+/*
+ * Copyright 2011 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ *
+ * Tilera-specific RTC driver.
+ */
+
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/rtc.h>
+#include <linux/platform_device.h>
+
+/* Platform device pointer. */
+static struct platform_device *tile_rtc_platform_device;
+
+/*
+ * RTC read routine.  Gets time info from RTC chip via hypervisor syscall.
+ */
+static int read_rtc_time(struct device *dev, struct rtc_time *tm)
+{
+	HV_RTCTime hvtm = hv_get_rtc();
+
+	tm->tm_sec = hvtm.tm_sec;
+	tm->tm_min = hvtm.tm_min;
+	tm->tm_hour = hvtm.tm_hour;
+	tm->tm_mday = hvtm.tm_mday;
+	tm->tm_mon = hvtm.tm_mon;
+	tm->tm_year = hvtm.tm_year;
+	tm->tm_wday = 0;
+	tm->tm_yday = 0;
+	tm->tm_isdst = 0;
+
+	if (rtc_valid_tm(tm) < 0)
+		dev_warn(dev, "Read invalid date/time from RTC\n");
+
+	return 0;
+}
+
+/*
+ * RTC write routine.  Sends time info to hypervisor via syscall, to be
+ * written to RTC chip.
+ */
+static int set_rtc_time(struct device *dev, struct rtc_time *tm)
+{
+	HV_RTCTime hvtm;
+
+	hvtm.tm_sec = tm->tm_sec;
+	hvtm.tm_min = tm->tm_min;
+	hvtm.tm_hour = tm->tm_hour;
+	hvtm.tm_mday = tm->tm_mday;
+	hvtm.tm_mon = tm->tm_mon;
+	hvtm.tm_year = tm->tm_year;
+
+	hv_set_rtc(hvtm);
+
+	return 0;
+}
+
+/*
+ * RTC read/write ops.
+ */
+static const struct rtc_class_ops tile_rtc_ops = {
+	.read_time	= read_rtc_time,
+	.set_time	= set_rtc_time,
+};
+
+/*
+ * Device probe routine.
+ */
+static int __devinit tile_rtc_probe(struct platform_device *dev)
+{
+	struct rtc_device *rtc;
+
+	rtc = rtc_device_register("tile",
+				  &dev->dev, &tile_rtc_ops, THIS_MODULE);
+
+	if (IS_ERR(rtc))
+		return PTR_ERR(rtc);
+
+	platform_set_drvdata(dev, rtc);
+
+	return 0;
+}
+
+/*
+ * Device cleanup routine.
+ */
+static int __devexit tile_rtc_remove(struct platform_device *dev)
+{
+	struct rtc_device *rtc = platform_get_drvdata(dev);
+
+	if (rtc)
+		rtc_device_unregister(rtc);
+
+	platform_set_drvdata(dev, NULL);
+
+	return 0;
+}
+
+static struct platform_driver tile_rtc_platform_driver = {
+	.driver		= {
+		.name	= "rtc-tile",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= tile_rtc_probe,
+	.remove		= __devexit_p(tile_rtc_remove),
+};
+
+/*
+ * Driver init routine.
+ */
+static int __init tile_rtc_driver_init(void)
+{
+	int err;
+
+	err = platform_driver_register(&tile_rtc_platform_driver);
+	if (err)
+		return err;
+
+	tile_rtc_platform_device = platform_device_alloc("rtc-tile", 0);
+	if (tile_rtc_platform_device == NULL) {
+		platform_driver_unregister(&tile_rtc_platform_driver);
+		return -ENOMEM;
+	}
+
+	err = platform_device_add(tile_rtc_platform_device);
+	if (err) {
+		platform_device_put(tile_rtc_platform_device);
+		return err;
+	}
+
+	return 0;
+}
+
+/*
+ * Driver cleanup routine.
+ */
+static void __exit tile_rtc_driver_exit(void)
+{
+	platform_driver_unregister(&tile_rtc_platform_driver);
+}
+
+module_init(tile_rtc_driver_init);
+module_exit(tile_rtc_driver_exit);
+
+MODULE_DESCRIPTION("Tilera-specific Real Time Clock Driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:rtc-tile");
-- 
1.6.5.2

