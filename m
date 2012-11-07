Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197Ab2KGKYa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 05:24:30 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46122 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499Ab2KGKY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 05:24:27 -0500
From: "hongbo.zhang" <hongbo.zhang@linaro.org>
To: linux-acpi@vger.kernel.org, rui.zhang@intel.com
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        amit.kachhap@linaro.org, patches@linaro.org,
        linaro-dev@lists.linaro.org, linaro-kernel@lists.linaro.org,
        STEricsson_nomadik_linux@list.st.com, kernel@igloocommunity.org,
        "hongbo.zhang" <hongbo.zhang@linaro.com>
Subject: [PATCH V4 2/2] Thermal: Add ST-Ericsson DB8500 thermal properties and platform data.
Date: Wed,  7 Nov 2012 18:23:02 +0800
Message-Id: <1352283782-16489-3-git-send-email-hongbo.zhang@linaro.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1352283782-16489-1-git-send-email-hongbo.zhang@linaro.com>
References: <1352283782-16489-1-git-send-email-hongbo.zhang@linaro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "hongbo.zhang" <hongbo.zhang@linaro.com>

This patch adds device tree properties for ST-Ericsson DB8500 thermal driver,
also adds the platform data to support the old fashion.

Signed-off-by: hongbo.zhang <hongbo.zhang@linaro.com>
Reviewed-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm/boot/dts/dbx5x0.dtsi      | 14 +++++++++
 arch/arm/boot/dts/snowball.dts     | 31 ++++++++++++++++++
 arch/arm/configs/u8500_defconfig   |  2 ++
 arch/arm/mach-ux500/board-mop500.c | 64 ++++++++++++++++++++++++++++++++++++++
 4 files changed, 111 insertions(+)

diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
index 4b0e0ca..731086b 100644
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
 
@@ -660,5 +668,11 @@
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
index 702c0ba..c6f85f0 100644
--- a/arch/arm/boot/dts/snowball.dts
+++ b/arch/arm/boot/dts/snowball.dts
@@ -99,6 +99,33 @@
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
 
@@ -183,5 +210,9 @@
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
index da68454..250625d 100644
--- a/arch/arm/configs/u8500_defconfig
+++ b/arch/arm/configs/u8500_defconfig
@@ -69,6 +69,8 @@ CONFIG_GPIO_TC3589X=y
 CONFIG_POWER_SUPPLY=y
 CONFIG_AB8500_BM=y
 CONFIG_AB8500_BATTERY_THERM_ON_BATCTRL=y
+CONFIG_THERMAL=y
+CONFIG_CPU_THERMAL=y
 CONFIG_MFD_STMPE=y
 CONFIG_MFD_TC3589X=y
 CONFIG_AB5500_CORE=y
diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index 416d436..b03216b 100644
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
@@ -229,6 +230,67 @@ static struct ab8500_platform_data ab8500_platdata = {
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
 
@@ -583,6 +645,8 @@ static struct platform_device *snowball_platform_devs[] __initdata = {
 	&snowball_key_dev,
 	&snowball_sbnet_dev,
 	&snowball_gpio_en_3v3_regulator_dev,
+	&u8500_thsens_device,
+	&u8500_cpufreq_cooling_device,
 };
 
 static void __init mop500_init_machine(void)
-- 
1.7.11.3

