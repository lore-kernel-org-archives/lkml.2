Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759438Ab2JYLQR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 07:16:17 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:56290 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759416Ab2JYLQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 07:16:03 -0400
From: "hongbo.zhang" <hongbo.zhang@linaro.org>
To: linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: patches@linaro.org, linaro-kernel@lists.linaro.org,
        STEricsson_nomadik_linux@list.st.com, kernel@igloocommunity.org,
        "hongbo.zhang" <hongbo.zhang@linaro.com>
Subject: [PATCH V2 6/6] Thermal: Add ST-Ericsson DB8500 thermal properties and platform data.
Date: Thu, 25 Oct 2012 19:15:52 +0800
Message-Id: <1351163752-29389-1-git-send-email-hongbo.zhang@linaro.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1351079900-32236-7-git-send-email-hongbo.zhang@linaro.com>
References: <1351079900-32236-7-git-send-email-hongbo.zhang@linaro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "hongbo.zhang" <hongbo.zhang@linaro.com>

This patch adds device tree properties for ST-Ericsson DB8500 thermal driver,
also adds the platform data to support the old fashion.

Signed-off-by: hongbo.zhang <hongbo.zhang@linaro.com>
---
 arch/arm/boot/dts/dbx5x0.dtsi      | 14 +++++++++
 arch/arm/boot/dts/snowball.dts     | 31 ++++++++++++++++++
 arch/arm/configs/u8500_defconfig   |  4 +++
 arch/arm/mach-ux500/board-mop500.c | 64 ++++++++++++++++++++++++++++++++++++++
 4 files changed, 113 insertions(+)

diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
index 748ba7a..949edc2 100644
--- a/arch/arm/boot/dts/dbx5x0.dtsi
+++ b/arch/arm/boot/dts/dbx5x0.dtsi
@@ -203,6 +203,14 @@
 				reg = <0x80157450 0xC>;
 			};
 
+			thermal@801573c0 {
+				compatible = "stericsson,db8500-thermal";
+				reg = <0x801573c0 0x40>;
+				interrupts = <21 0x4>, <22 0x4>;
+				interrupt-names = "IRQ_HOTMON_LOW", "IRQ_HOTMON_HIGH";
+				status = "disabled";
+			 };
+
 			db8500-prcmu-regulators {
 				compatible = "stericsson,db8500-prcmu-regulator";
 
@@ -645,5 +653,11 @@
 			ranges = <0 0x50000000 0x4000000>;
 			status = "disabled";
 		};
+
+		cpufreq-cooling {
+			compatible = "stericsson,db8500-cpufreq-cooling";
+			status = "disabled";
+		 };
+
 	};
 };
diff --git a/arch/arm/boot/dts/snowball.dts b/arch/arm/boot/dts/snowball.dts
index fce4a00..787d992 100644
--- a/arch/arm/boot/dts/snowball.dts
+++ b/arch/arm/boot/dts/snowball.dts
@@ -91,6 +91,33 @@
 			status = "okay";
 		};
 
+		prcmu@80157000 {
+			thermal@801573c0 {
+				num-trips = <4>;
+
+				trip0-temp = <70000>;
+				trip0-type = "active";
+				trip0-cdev-num = <1>;
+				trip0-cdev-name0 = "thermal-cpufreq-0";
+
+				trip1-temp = <75000>;
+				trip1-type = "active";
+				trip1-cdev-num = <1>;
+				trip1-cdev-name0 = "thermal-cpufreq-0";
+
+				trip2-temp = <80000>;
+				trip2-type = "active";
+				trip2-cdev-num = <1>;
+				trip2-cdev-name0 = "thermal-cpufreq-0";
+
+				trip3-temp = <85000>;
+				trip3-type = "critical";
+				trip3-cdev-num = <0>;
+
+				status = "okay";
+			 };
+		};
+
 		external-bus@50000000 {
 			status = "okay";
 
@@ -176,5 +203,9 @@
 				reg = <0x33>;
 			};
 		};
+
+		cpufreq-cooling {
+			status = "okay";
+		};
 	};
 };
diff --git a/arch/arm/configs/u8500_defconfig b/arch/arm/configs/u8500_defconfig
index cc5e7a8..34918c4 100644
--- a/arch/arm/configs/u8500_defconfig
+++ b/arch/arm/configs/u8500_defconfig
@@ -118,3 +118,7 @@ CONFIG_DEBUG_KERNEL=y
 CONFIG_DEBUG_INFO=y
 # CONFIG_FTRACE is not set
 CONFIG_DEBUG_USER=y
+CONFIG_THERMAL=y
+CONFIG_CPU_THERMAL=y
+CONFIG_DB8500_THERMAL=y
+CONFIG_DB8500_CPUFREQ_COOLING=y
diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index a534d88..71f2a9c 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -16,6 +16,7 @@
 #include <linux/io.h>
 #include <linux/i2c.h>
 #include <linux/platform_data/i2c-nomadik.h>
+#include <linux/platform_data/db8500_thermal.h>
 #include <linux/gpio.h>
 #include <linux/amba/bus.h>
 #include <linux/amba/pl022.h>
@@ -212,6 +213,67 @@ static struct ab8500_platform_data ab8500_platdata = {
 };
 
 /*
+ * Thermal Sensor
+ */
+
+static struct resource db8500_thsens_resources[] = {
+	{
+		.name = "IRQ_HOTMON_LOW",
+		.start  = IRQ_PRCMU_HOTMON_LOW,
+		.end    = IRQ_PRCMU_HOTMON_LOW,
+		.flags  = IORESOURCE_IRQ,
+	},
+	{
+		.name = "IRQ_HOTMON_HIGH",
+		.start  = IRQ_PRCMU_HOTMON_HIGH,
+		.end    = IRQ_PRCMU_HOTMON_HIGH,
+		.flags  = IORESOURCE_IRQ,
+	},
+};
+
+static struct db8500_thsens_platform_data db8500_thsens_data = {
+	.trip_points[0] = {
+		.temp = 70000,
+		.type = THERMAL_TRIP_ACTIVE,
+		.cdev_name = {
+			[0] = "thermal-cpufreq-0",
+		},
+	},
+	.trip_points[1] = {
+		.temp = 75000,
+		.type = THERMAL_TRIP_ACTIVE,
+		.cdev_name = {
+			[0] = "thermal-cpufreq-0",
+		},
+	},
+	.trip_points[2] = {
+		.temp = 80000,
+		.type = THERMAL_TRIP_ACTIVE,
+		.cdev_name = {
+			[0] = "thermal-cpufreq-0",
+		},
+	},
+	.trip_points[3] = {
+		.temp = 85000,
+		.type = THERMAL_TRIP_CRITICAL,
+	},
+	.num_trips = 4,
+};
+
+static struct platform_device u8500_thsens_device = {
+	.name           = "db8500-thermal",
+	.resource       = db8500_thsens_resources,
+	.num_resources  = ARRAY_SIZE(db8500_thsens_resources),
+	.dev	= {
+		.platform_data	= &db8500_thsens_data,
+	},
+};
+
+static struct platform_device u8500_cpufreq_cooling_device = {
+	.name           = "db8500-cpufreq-cooling",
+};
+
+/*
  * TPS61052
  */
 
@@ -586,6 +648,8 @@ static struct platform_device *snowball_platform_devs[] __initdata = {
 	&snowball_led_dev,
 	&snowball_key_dev,
 	&snowball_sbnet_dev,
+	&u8500_thsens_device,
+	&u8500_cpufreq_cooling_device,
 };
 
 static void __init mop500_init_machine(void)
-- 
1.7.11.3

