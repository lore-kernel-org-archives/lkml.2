Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671Ab1GAC0s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 22:26:48 -0400
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:46543 "HELO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754479Ab1GAC0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 22:26:47 -0400
X-Greylist: delayed 438 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Jun 2011 22:26:46 EDT
From: Nathan Royer <nroyer@invensense.com>
To: Nathan Royer <nroyer@invensense.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Jonathan Cameron <jic23@cam.ac.uk>, Jiri Kosina <jkosina@suse.cz>,
        Alan Cox <alan@linux.intel.com>, Jean Delvare <khali@linux-fr.org>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: [PATCH 08/11] misc: Kconfig and Makefile changes for inv_mpu driver
Date: Thu, 30 Jun 2011 19:18:24 -0700
Message-Id: <1309486707-1658-8-git-send-email-nroyer@invensense.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1309486707-1658-1-git-send-email-nroyer@invensense.com>
References: <1309486707-1658-1-git-send-email-nroyer@invensense.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nathan Royer <nroyer@invensense.com>
---
 drivers/misc/Kconfig          |    1 +
 drivers/misc/Makefile         |    1 +
 drivers/misc/inv_mpu/Kconfig  |   58 +++++++++++++++++++++++++++++++++++++++++
 drivers/misc/inv_mpu/Makefile |   17 ++++++++++++
 4 files changed, 77 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/inv_mpu/Kconfig
 create mode 100644 drivers/misc/inv_mpu/Makefile

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 4e349cd..2dc231d 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -493,6 +493,7 @@ config PCH_PHUB
 source "drivers/misc/c2port/Kconfig"
 source "drivers/misc/eeprom/Kconfig"
 source "drivers/misc/cb710/Kconfig"
+source "drivers/misc/inv_mpu/Kconfig"
 source "drivers/misc/iwmc3200top/Kconfig"
 source "drivers/misc/ti-st/Kconfig"
 source "drivers/misc/lis3lv02d/Kconfig"
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index 5f03172..3b371cf 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -35,6 +35,7 @@ obj-$(CONFIG_DS1682)		+= ds1682.o
 obj-$(CONFIG_TI_DAC7512)	+= ti_dac7512.o
 obj-$(CONFIG_C2PORT)		+= c2port/
 obj-$(CONFIG_IWMC3200TOP)      += iwmc3200top/
+obj-y				+= inv_mpu/
 obj-$(CONFIG_HMC6352)		+= hmc6352.o
 obj-y				+= eeprom/
 obj-y				+= cb710/
diff --git a/drivers/misc/inv_mpu/Kconfig b/drivers/misc/inv_mpu/Kconfig
new file mode 100644
index 0000000..fdfa7a6
--- /dev/null
+++ b/drivers/misc/inv_mpu/Kconfig
@@ -0,0 +1,58 @@
+
+menuconfig: INV_SENSORS
+	tristate "Motion Processing Unit"
+	depends on I2C
+	default y
+
+if INV_SENSORS
+
+choice
+	prompt "MPU Master"
+	depends on I2C && INV_SENSORS
+	default MPU_SENSORS_MPU3050
+
+config MPU_SENSORS_MPU3050
+	bool "MPU3050"
+	depends on I2C
+	select MPU_SENSORS_MPU3050_GYRO
+	help
+	  If you say yes here you get support for the MPU3050 Gyroscope driver
+	  This driver can also be built as a module.  If so, the module
+	  will be called mpu3050.
+
+config MPU_SENSORS_MPU6050A2
+	bool "MPU6050A2"
+	depends on I2C
+	select MPU_SENSORS_MPU6050_GYRO
+	help
+	  If you say yes here you get support for the MPU6050A2 Gyroscope driver
+	  This driver can also be built as a module.  If so, the module
+	  will be called mpu6050a2.
+
+config MPU_SENSORS_MPU6050B1
+	bool "MPU6050B1"
+	select MPU_SENSORS_MPU6050_GYRO
+	depends on I2C
+	help
+	  If you say yes here you get support for the MPU6050 Gyroscope driver
+	  This driver can also be built as a module.  If so, the module
+	  will be called mpu6050b1.
+
+endchoice
+
+choice
+	prompt "Gyroscope Type"
+	depends on I2C && INV_SENSORS
+	default MPU_SENSORS_MPU3050_GYRO
+
+config MPU_SENSORS_MPU3050_GYRO
+	bool "MPU3050 built in gyroscope"
+	depends on MPU_SENSORS_MPU3050
+
+config MPU_SENSORS_MPU6050_GYRO
+	bool "MPU6050 built in gyroscope"
+	depends on MPU_SENSORS_MPU6050B1 || MPU_SENSORS_MPU6050A2
+
+endchoice
+
+endif #INV_SENSORS
diff --git a/drivers/misc/inv_mpu/Makefile b/drivers/misc/inv_mpu/Makefile
new file mode 100644
index 0000000..48fc55a
--- /dev/null
+++ b/drivers/misc/inv_mpu/Makefile
@@ -0,0 +1,17 @@
+
+# Kernel makefile for motions sensors
+#
+#
+
+# MPU
+
+obj-$(CONFIG_INV_SENSORS)	+= mpu3050.o
+
+mpu3050-objs += mpuirq.o
+mpu3050-objs += slaveirq.o
+mpu3050-objs += mpu-dev.o
+mpu3050-objs += mlsl.o
+mpu3050-objs += mldl_cfg.o
+mpu3050-objs += mldl_print_cfg.o
+
+EXTRA_CFLAGS += -Idrivers/misc/inv_mpu
-- 
1.7.4.1

