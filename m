Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932545Ab1CINRv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 08:17:51 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:36063 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932349Ab1CINRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 08:17:49 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH, RESEND #2] x86,
 mrst: Intel Medfield over-current detection patch
To: linux-kernel@vger.kernel.org, mjg@srcf.ucam.org
Date: Wed, 09 Mar 2011 12:56:56 +0000
Message-ID: <20110309125605.21421.2837.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After the last discussion in which Guenter clarified this wasn't hwmon it all
went silent, so resending it again.



From: Durgadoss R <durgadoss.r@intel.com>

This patch enables over current detection on the Intel Medfield
Platform. This driver provides sysfs interfaces to configure current
thresholds. When the current being drawn on the platform exceeds
the configured threshold, an interrupt is generated. This interrupt
can be used to bring the current consumption down by taking necessary
hardware or software actions.

Note that while we use hwmon style helpers and interface this is not an hwmon
device and hwmon has no common API with this hardware. After discussion with
the hwmon maintainers it was decided to make this an x86 platform driver.

Signed-off-by: Durgadoss R <durgadoss.r@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 Documentation/x86/intel_mid/intel_mid_ocd.txt |   86 +++
 drivers/platform/x86/Kconfig                  |    7 
 drivers/platform/x86/Makefile                 |    3 
 drivers/platform/x86/intel_mid_ocd.c          |  640 +++++++++++++++++++++++++
 4 files changed, 735 insertions(+), 1 deletions(-)
 create mode 100644 Documentation/x86/intel_mid/intel_mid_ocd.txt
 create mode 100644 drivers/platform/x86/intel_mid_ocd.c


diff --git a/Documentation/x86/intel_mid/intel_mid_ocd.txt b/Documentation/x86/intel_mid/intel_mid_ocd.txt
new file mode 100644
index 0000000..d9483b0
--- /dev/null
+++ b/Documentation/x86/intel_mid/intel_mid_ocd.txt
@@ -0,0 +1,86 @@
+Kernel driver over current detection driver
+===========================================
+
+Supported systems:
+  * Intel Medfield Platform
+
+Author: Durgadoss R
+
+Description
+-----------
+
+This driver monitors the current drawn by the platform, and detects the
+peak current conditions. When the current drawn is more than the
+configured limit for a period of time (which is specified by a timer), an
+interrupt is generated. The current limit and the timer value can be
+configured at run time.
+
+The current thresholds aka BATTCURRENTLIMITS(BC) are of two types:
+	1.warning threshold(BC1)
+		at which the system should take actions to bring the
+		current consumption down.
+	2.shutdown threshold(BC2)
+		at which the hardware does a COLDOFF.
+
+The timer thresholds are of three types:
+	1.warning threshold(T1)
+		This corresponds to the first flag for time that the battery
+		current has been above BC1. An interrupt is generated to allow
+		software to correct the situation based on use-case.
+	2.hardware action threshold(T2)
+		This corresponds to the second flag for time that the battery
+		current has been above BC1. It signifies that the system
+		should control high current subsystems through hardware.
+		Besides a general interrupt, audio_volume_crush, vibra_disable
+		signals are sent.
+	3.shutdown threshold(T3)
+		This final flag signifies that when the system current exceeds
+		the threshold for more than T3, system should shutdown.
+
+Following table summarizes the exported sysfs files:
+
+bcu_status(RW)	     -  To enable/disable burst control unit.
+			0 - enables bcu, 1 - disables bcu.
+accumulation_time(RW)-  Time since last clearing/overflow of warning_count
+			in milli seconds. Writing 0 resets the acc_time and
+			also clears both the warning counters.
+warning_count(RO)    -  Two space seperated values that indicate the number
+			of times the current thresholds have been crossed.
+action_mask(RW)	     -  A hex value to enable/disable specific
+			actions taken when current violation happens.
+			bits [b4 b3 b2 b1 b0] control [a4 a3 a2 a1 a0] actions
+			respectively. a4 - camera output, a3 - sys burst,
+			a2 - SOC burst enable, a1 - vibra, a0 - audio output.
+			bits [b7 b6 b5] - Reserved.
+			Default value:08 (sys burst output is enabled).
+action_status(RO)    -  A hex value showing the status of actions taken
+			since the __last__ interrupt.
+			b7 - T3 violation
+			b6 - T2 violation
+			b5 - T1 violation
+			b4 - camera action taken status
+			b3 - sys burst disable action taken status
+			b2 - SOC burst disable action taken status
+			b1 - vibra disable
+			b0 - audio volume crush
+			A '1' in a bit position indicates that particular
+			action has been taken.
+current_warning(RW)  -  This gives the current(in mA) at which a warning is
+			generated. Range: 1400 to 4800. Default:3000
+current_shutdown(RW) -  This gives the current(in mA) at which system shutdown
+			is initiated. Range:1800 to 5800. Default:3800
+timer_warning(RW)    -  Time above current_warning limit at which interrupts
+			are trigerred(so that software can bring the current
+			consumption down). Values are in micro seconds.
+			Range:200 to 7700 in steps of 500
+timer_hw_action(RW)  -  Time above current_warning limit at which the system
+			is trigerred into hardware control to bring down the
+			current consumption. Values are in micro seconds.
+			Range:200 to 7700 in steps of 500
+timer_shutdown(RW)   -  Time above current_warning limit at which a hardware
+			shutdown event is trigerred. The timer values are in
+			micro seconds.
+			Range:1000 to 15000 in steps of 1000
+For all timer interfaces, tolerance shall be 5% maximum.
+All timers start running concurrently once current_warning/current_shutdown
+is crossed.
diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 080ab72..caaec19 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -613,6 +613,13 @@ config INTEL_MID_POWER_BUTTON
 
 	  If unsure, say N.
 
+config INTEL_MID_OCD
+	tristate "Intel MID platform over-current detector"
+	depends on INTEL_SCU_IPC
+	---help---
+	  Say Y here to support over-current detection and handling on
+	  Intel Medfield MID platforms.
+
 config RAR_REGISTER
 	bool "Restricted Access Region Register Driver"
 	depends on PCI && X86_MRST
diff --git a/drivers/platform/x86/Makefile b/drivers/platform/x86/Makefile
index 62650cc..83d40c3 100644
--- a/drivers/platform/x86/Makefile
+++ b/drivers/platform/x86/Makefile
@@ -29,6 +29,7 @@ obj-$(CONFIG_ACPI_TOSHIBA)	+= toshiba_acpi.o
 obj-$(CONFIG_TOSHIBA_BT_RFKILL)	+= toshiba_bluetooth.o
 obj-$(CONFIG_INTEL_SCU_IPC)	+= intel_scu_ipc.o
 obj-$(CONFIG_INTEL_SCU_IPC_UTIL)+= intel_scu_ipcutil.o
+obj-$(CONFIG_INTEL_MID_OCD)	+= intel_mid_ocd.o
 obj-$(CONFIG_RAR_REGISTER)	+= intel_rar_register.o
 obj-$(CONFIG_INTEL_IPS)		+= intel_ips.o
 obj-$(CONFIG_GPIO_INTEL_PMIC)	+= intel_pmic_gpio.o
@@ -36,4 +37,4 @@ obj-$(CONFIG_XO1_RFKILL)	+= xo1-rfkill.o
 obj-$(CONFIG_XO15_EBOOK)	+= xo15-ebook.o
 obj-$(CONFIG_IBM_RTL)		+= ibm_rtl.o
 obj-$(CONFIG_INTEL_MID_POWER_BUTTON)	+= intel_mid_powerbtn.o
-obj-$(CONFIG_INTEL_MFLD_THERMAL)	+= intel_mid_thermal.o
\ No newline at end of file
+obj-$(CONFIG_INTEL_MFLD_THERMAL)	+= intel_mid_thermal.o
diff --git a/drivers/platform/x86/intel_mid_ocd.c b/drivers/platform/x86/intel_mid_ocd.c
new file mode 100644
index 0000000..a1284a0
--- /dev/null
+++ b/drivers/platform/x86/intel_mid_ocd.c
@@ -0,0 +1,640 @@
+/*
+ * intel_mid_ocd.c - Intel Medfield Platform Over Current Detection Driver
+ *
+ *
+ * Copyright (C) 2010 Intel Corporation
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ * Author: Durgadoss R <durgadoss.r@intel.com>
+ */
+
+#define pr_fmt(fmt)  "intel_mid_ocd: " fmt
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/pm.h>
+#include <linux/slab.h>
+#include <linux/hwmon-sysfs.h>
+#include <linux/interrupt.h>
+#include <linux/gpio.h>
+
+#include <asm/intel_scu_ipc.h>
+
+#define DRIVER_NAME "intel_mid_ocd"
+#define FIRMWARE_NAME "msic_cmd"
+
+/* Registers that govern current monitoring */
+#define BATTCURRENTLIMIT12	0x102
+#define BATTTIMELIMIT12		0x103
+#define BATTTIMELIMIT3		0x104
+#define BRSTCONFIGOUTPUTS	0x106
+#define BRSTCONFIGACTIONS	0x107
+#define BRSTCONTROLSTATUS	0x108
+
+#define BCUSTATUS		(1 << 7)
+
+/* Bits that enable sys burst input & output */
+#define SYSACTEN		(1 << 3)
+#define SYSOUTEN		(1 << 3)
+
+/* Status register */
+#define CAMSTAT			(1 << 4)
+#define SYSSTAT			(0x0F << 0)
+#define OVER_TIMER1		(1 << 5)
+#define OVER_TIMER2		(1 << 6)
+
+#define NUM_CURR_LIMITS		8
+#define NUM_TIME_LIMITS		15
+
+/* Base and offset for every time limit */
+#define TIME_LIMIT12_BASE	200
+#define TIME_LIMIT12_OFFSET	500
+#define TIME_LIMIT12_MAX	(TIME_LIMIT12_BASE + \
+				(TIME_LIMIT12_OFFSET * NUM_TIME_LIMITS))
+
+#define TIME_LIMIT3_BASE	200
+#define TIME_LIMIT3_OFFSET	1000
+#define TIME_LIMIT3_MAX		(TIME_LIMIT3_OFFSET * NUM_TIME_LIMITS)
+
+#define MAX_COUNT		0xFFFFFFFF
+
+static DEFINE_MUTEX(ocd_update_lock);
+
+/* stores the current thresholds(in mA) at which
+ * row 0: warning is generated
+ * row 1: system shut down is initiated
+ */
+static const int curr_thresholds[][NUM_CURR_LIMITS] = {
+			{1400, 1800, 2200, 2800, 3000, 3400, 3800, 4800},
+			{1800, 2200, 2800, 3000, 3800, 4800, 5800, 5800} };
+
+struct ocd_info {
+	unsigned long timer1_count;
+	unsigned long timer2_count;
+	unsigned long acc_time;
+	unsigned int irq;
+	uint8_t intrpt_status;
+	struct device *dev;
+	struct platform_device *pdev;
+};
+
+static int configure_bcu(int flag)
+{
+	int ret;
+	uint8_t data;
+
+	mutex_lock(&ocd_update_lock);
+
+	ret = intel_scu_ipc_ioread8(BRSTCONFIGACTIONS, &data);
+	if (ret)
+		goto ipc_fail;
+
+	/* Zero enables BCU and non-zero disables BCU */
+	if (!flag)
+		data &= (~BCUSTATUS);	/* enable bcu */
+	else
+		data |= BCUSTATUS;	/* disable bcu */
+
+	ret = intel_scu_ipc_iowrite8(BRSTCONFIGACTIONS, data);
+
+ipc_fail:
+	mutex_unlock(&ocd_update_lock);
+	return ret;
+}
+
+static ssize_t store_bcu_status(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	unsigned long val;
+
+	if (strict_strtoul(buf, 10, &val))
+		return -EINVAL;
+
+	if (val != 0 && val != 1)
+		return -EINVAL;
+
+	return configure_bcu(val) ? -EINVAL : count;
+}
+
+static ssize_t show_bcu_status(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	int ret;
+	uint8_t data;
+
+	ret = intel_scu_ipc_ioread8(BRSTCONFIGACTIONS, &data);
+	if (ret)
+		return ret;
+
+	ret = (data & BCUSTATUS) ? 1 : 0;
+
+	return sprintf(buf, "%d\n", ret);
+}
+
+static ssize_t store_action_mask(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	int ret;
+	unsigned long data;
+
+	if (strict_strtoul(buf, 16, &data))
+		return -EINVAL;
+
+	ret = intel_scu_ipc_iowrite8(BRSTCONFIGOUTPUTS, (uint8_t)data);
+	if (ret)
+		return ret;
+
+	return count;
+}
+
+static ssize_t show_action_mask(struct device *dev,
+			struct device_attribute *attr, char *buf)
+{
+	int ret;
+	uint8_t data;
+
+	ret = intel_scu_ipc_ioread8(BRSTCONFIGOUTPUTS, &data);
+	if (ret)
+		return ret;
+
+	return sprintf(buf, "%.2x\n", data);
+}
+
+static ssize_t show_action_status(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct ocd_info *cinfo = dev_get_drvdata(dev);
+
+	/* This shows the status of actions taken since the last interrupt */
+	return sprintf(buf, "%.2x\n", cinfo->intrpt_status);
+}
+
+static int get_current_value(int index, int value)
+{
+	int pos = 0;
+
+	if (index != 0 && index != 1)
+		return -EINVAL;
+
+	if (value < curr_thresholds[index][0] ||
+			value > curr_thresholds[index][NUM_CURR_LIMITS-1])
+		return -EINVAL;
+
+	/* Find the index of 'value' in the thresholds array */
+	while (pos < NUM_CURR_LIMITS && value >= curr_thresholds[index][pos])
+		++pos;
+
+	return pos - 1;
+}
+
+static ssize_t store_curr_thres(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	int ret;
+	uint8_t data;
+	long curnt;
+	int pos;
+	struct sensor_device_attribute_2 *s_attr =
+					to_sensor_dev_attr_2(attr);
+
+	if (strict_strtol(buf, 10, &curnt))
+		return -EINVAL;
+
+	mutex_lock(&ocd_update_lock);
+
+	pos = get_current_value(s_attr->nr, (int)curnt);
+	if (pos < 0) {
+		ret = pos;
+		goto ipc_fail;
+	}
+
+	ret = intel_scu_ipc_ioread8(BATTCURRENTLIMIT12, &data);
+	if (ret)
+		goto ipc_fail;
+
+	if (s_attr->nr == 0)
+		/* set bits [0-2] to value of pos */
+		data = (data & 0xF8) | pos;
+	else
+		/* set bits [3-5] to value of pos */
+		data = (data & 0xC7) | (pos << 3);
+
+	ret = intel_scu_ipc_iowrite8(BATTCURRENTLIMIT12, data);
+	if (ret)
+		goto ipc_fail;
+
+	ret = count;
+
+ipc_fail:
+	mutex_unlock(&ocd_update_lock);
+	return ret;
+}
+
+static ssize_t show_curr_thres(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	int ret, indx;
+	uint8_t data;
+	struct sensor_device_attribute_2 *s_attr =
+					to_sensor_dev_attr_2(attr);
+
+	WARN_ON(s_attr->nr != 0 && s_attr->nr != 1);
+
+	ret = intel_scu_ipc_ioread8(BATTCURRENTLIMIT12, &data);
+	if (ret)
+		return ret;
+
+	/* read bits [0-2] or [3-5] of data */
+	indx = (data >> (3 * s_attr->nr)) & 0x07;
+
+	return sprintf(buf, "%d\n", curr_thresholds[s_attr->nr][indx]);
+}
+
+static int get_timer_threshold(unsigned long time, int index)
+{
+	if (index == 0 || index == 1) {
+		if (time < TIME_LIMIT12_BASE || time > TIME_LIMIT12_MAX)
+			return -EINVAL;
+		return (time - TIME_LIMIT12_BASE) / TIME_LIMIT12_OFFSET;
+	} else {
+		if (time < TIME_LIMIT3_BASE || time > TIME_LIMIT3_MAX)
+			return -EINVAL;
+		return time / TIME_LIMIT3_OFFSET;
+	}
+}
+
+static ssize_t store_timer_thres(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	unsigned long time;
+	uint8_t data;
+	int ret, val;
+	struct sensor_device_attribute_2 *s_attr =
+					to_sensor_dev_attr_2(attr);
+
+	if (strict_strtoul(buf, 10, &time))
+		return -EINVAL;
+
+	val = get_timer_threshold(time, s_attr->nr);
+	if (val < 0)
+		return -EINVAL;
+
+	mutex_lock(&ocd_update_lock);
+
+	if (s_attr->nr == 2) {
+		ret = intel_scu_ipc_ioread8(BATTTIMELIMIT3, &data);
+		if (ret)
+			goto ipc_fail;
+		/* set bits [0-3] to val */
+		data = (data & 0xF0) | val;
+
+		ret = intel_scu_ipc_iowrite8(BATTTIMELIMIT3, data);
+		if (ret)
+			goto ipc_fail;
+	} else {
+		ret = intel_scu_ipc_ioread8(BATTTIMELIMIT12, &data);
+		if (ret)
+			goto ipc_fail;
+
+		if (s_attr->nr == 0)
+			/* set bits [0-3] to val */
+			data = (data & 0xF0) | val;
+		else
+			/* set bits [4-7] to val */
+			data = (data & 0x0F) | (val << 4);
+
+		ret = intel_scu_ipc_iowrite8(BATTTIMELIMIT12, data);
+		if (ret)
+			goto ipc_fail;
+	}
+	ret = count;
+
+ipc_fail:
+	mutex_unlock(&ocd_update_lock);
+	return ret;
+}
+
+static ssize_t show_timer_thres(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	int ret, val;
+	uint8_t data;
+	int time;
+	struct sensor_device_attribute_2 *s_attr =
+					to_sensor_dev_attr_2(attr);
+
+	if (s_attr->nr == 0 || s_attr->nr == 1) {
+		ret = intel_scu_ipc_ioread8(BATTTIMELIMIT12, &data);
+		if (ret)
+			return ret;
+
+		val = s_attr->nr ? ((data >> 4) & 0x0F) : (data & 0x0F);
+		time = TIME_LIMIT12_BASE + val * TIME_LIMIT12_OFFSET;
+
+	} else if (s_attr->nr == 2) {
+		ret = intel_scu_ipc_ioread8(BATTTIMELIMIT3, &data);
+		if (ret)
+			return ret;
+
+		val = data & 0x0F;
+		time = (val) ? (val * TIME_LIMIT3_OFFSET) : TIME_LIMIT3_BASE;
+	} else
+		return -EINVAL;
+
+	return sprintf(buf, "%d\n", time);
+}
+
+static ssize_t show_warn_count(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct ocd_info *cinfo = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%ld %ld\n", cinfo->timer1_count,
+							cinfo->timer2_count);
+}
+
+static ssize_t store_acc_time(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct ocd_info *cinfo = dev_get_drvdata(dev);
+	unsigned long time;
+
+	if (strict_strtoul(buf, 10, &time))
+		return -EINVAL;
+
+	/* Only 0 can be written to clear, otherwise return*/
+	if (time)
+		return -EINVAL;
+
+	/* Set the acc_time to 'now' */
+	cinfo->acc_time = jiffies;
+
+	/* Clear warning counters */
+	cinfo->timer1_count = cinfo->timer2_count = 0;
+
+	return count;
+}
+static ssize_t show_acc_time(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct ocd_info *cinfo = dev_get_drvdata(dev);
+	long time_gap;
+
+	if (cinfo->acc_time == 0)
+		return sprintf(buf, "0\n");
+
+	/* Calculate the time gap in jiffies */
+	time_gap = jiffies - cinfo->acc_time;
+
+	/* Convert to milli secs and print */
+	return sprintf(buf, "%u\n", jiffies_to_msecs(time_gap));
+}
+
+static irqreturn_t ocd_handle_intrpt(int irq, void *dev_data)
+{
+	int ret;
+	uint8_t data;
+	struct ocd_info *cinfo = (struct ocd_info *)dev_data;
+
+	if (!cinfo)
+		return IRQ_NONE;
+
+	mutex_lock(&ocd_update_lock);
+
+	/* Interrupt came now */
+	cinfo->acc_time = jiffies;
+
+	/* Read the interrupt status register */
+	ret = intel_scu_ipc_ioread8(BRSTCONTROLSTATUS, &data);
+	if (ret)
+		goto ipc_fail;
+
+	/* Cache the interrupt status register */
+	cinfo->intrpt_status = data;
+
+	/* It's a timer1 interrupt. Increment the counter.
+	 * Reset timer1 and camera status bits */
+	if (data & OVER_TIMER1) {
+		cinfo->timer1_count++;
+		data &= (~(OVER_TIMER1 | CAMSTAT));
+	}
+
+	/* It's a timer2 interrupt. Increment the counter.
+	 * Reset timer2 and sys burst status bits */
+	if (data & OVER_TIMER2) {
+		cinfo->timer2_count++;
+		data &= (~(OVER_TIMER2 | SYSSTAT));
+	}
+
+	if (cinfo->timer1_count == MAX_COUNT ||
+				cinfo->timer2_count == MAX_COUNT) {
+		cinfo->timer1_count = cinfo->timer2_count = 0;
+		cinfo->acc_time = jiffies;
+	}
+
+	/* Write the masked data */
+	ret = intel_scu_ipc_iowrite8(BRSTCONTROLSTATUS, data);
+	if (ret)
+		goto ipc_fail;
+
+	mutex_unlock(&ocd_update_lock);
+	return IRQ_HANDLED;
+
+ipc_fail:
+	mutex_unlock(&ocd_update_lock);
+	dev_err(cinfo->dev, "ipc read/write failed");
+	return ret;
+}
+
+static int initialize_hw(struct ocd_info *cinfo)
+{
+	int ret;
+	uint8_t data;
+
+	ret = intel_scu_ipc_ioread8(BRSTCONFIGOUTPUTS, &data);
+	if (ret)
+		return ret;
+
+	/* Enable sys burst output signal */
+	ret = intel_scu_ipc_iowrite8(BRSTCONFIGOUTPUTS, (data | SYSOUTEN));
+	if (ret)
+		return ret;
+
+	ret = intel_scu_ipc_ioread8(BRSTCONFIGACTIONS, &data);
+	if (ret)
+		return ret;
+
+	/* Enable sys burst action signal*/
+	return intel_scu_ipc_iowrite8(BRSTCONFIGACTIONS, (data | SYSACTEN));
+}
+
+static SENSOR_DEVICE_ATTR_2(bcu_status, S_IRUGO | S_IWUSR,
+				show_bcu_status, store_bcu_status, 0, 0);
+
+static SENSOR_DEVICE_ATTR_2(action_mask, S_IRUGO | S_IWUSR,
+				show_action_mask, store_action_mask, 0, 0);
+
+static SENSOR_DEVICE_ATTR_2(current_warning, S_IRUGO | S_IWUSR,
+				show_curr_thres, store_curr_thres, 0, 0);
+static SENSOR_DEVICE_ATTR_2(current_shutdown, S_IRUGO | S_IWUSR,
+				show_curr_thres, store_curr_thres, 1, 0);
+
+static SENSOR_DEVICE_ATTR_2(timer_warning, S_IRUGO | S_IWUSR,
+				show_timer_thres, store_timer_thres, 0, 0);
+static SENSOR_DEVICE_ATTR_2(timer_hw_action, S_IRUGO | S_IWUSR,
+				show_timer_thres, store_timer_thres, 1, 0);
+static SENSOR_DEVICE_ATTR_2(timer_shutdown, S_IRUGO | S_IWUSR,
+				show_timer_thres, store_timer_thres, 2, 0);
+
+static SENSOR_DEVICE_ATTR_2(accumulation_time, S_IRUGO | S_IWUSR,
+					show_acc_time, store_acc_time, 0, 0);
+
+static SENSOR_DEVICE_ATTR_2(warning_count, S_IRUGO, show_warn_count,
+								NULL, 0, 0);
+static SENSOR_DEVICE_ATTR_2(action_status, S_IRUGO, show_action_status,
+								NULL, 0, 0);
+
+static struct attribute *mid_ocd_attrs[] = {
+	&sensor_dev_attr_bcu_status.dev_attr.attr,
+	&sensor_dev_attr_action_mask.dev_attr.attr,
+	&sensor_dev_attr_current_warning.dev_attr.attr,
+	&sensor_dev_attr_current_shutdown.dev_attr.attr,
+	&sensor_dev_attr_timer_warning.dev_attr.attr,
+	&sensor_dev_attr_timer_hw_action.dev_attr.attr,
+	&sensor_dev_attr_timer_shutdown.dev_attr.attr,
+	&sensor_dev_attr_warning_count.dev_attr.attr,
+	&sensor_dev_attr_accumulation_time.dev_attr.attr,
+	&sensor_dev_attr_action_status.dev_attr.attr,
+	NULL
+};
+
+static struct attribute_group mid_ocd_gr = {
+	.name = "msic_current",
+	.attrs = mid_ocd_attrs
+};
+
+static int mid_ocd_probe(struct platform_device *pdev)
+{
+	int ret;
+	struct ocd_info *cinfo = kzalloc(sizeof(struct ocd_info), GFP_KERNEL);
+
+	if (!cinfo) {
+		dev_err(&pdev->dev, "kzalloc failed\n");
+		return -ENOMEM;
+	}
+
+	cinfo->pdev = pdev;
+	cinfo->irq = platform_get_irq(pdev, 0);
+	platform_set_drvdata(pdev, cinfo);
+
+	/* Creating a sysfs group with mid_ocd_gr attributes */
+	ret = sysfs_create_group(&pdev->dev.kobj, &mid_ocd_gr);
+	if (ret) {
+		dev_err(&pdev->dev, "sysfs create group failed\n");
+		goto ocd_error1;
+	}
+
+	/* Enable interrupt */
+	ret = request_threaded_irq(cinfo->irq, NULL, ocd_handle_intrpt,
+						0, DRIVER_NAME, cinfo);
+	if (ret) {
+		dev_err(cinfo->dev, "request_threaded_irq failed:%d\n", ret);
+		goto ocd_error2;
+	}
+
+	ret = initialize_hw(cinfo);
+	if (ret)
+		goto ocd_error2;
+
+	ret = configure_bcu(1);
+	if (ret)
+		goto ocd_error2;
+
+	return 0;
+
+ocd_error2:
+	sysfs_remove_group(&pdev->dev.kobj, &mid_ocd_gr);
+ocd_error1:
+	kfree(cinfo);
+	return ret;
+}
+
+static int mid_ocd_resume(struct platform_device *pdev)
+{
+	int ret;
+	struct ocd_info *cinfo = platform_get_drvdata(pdev);
+
+	ret = initialize_hw(cinfo);
+	if (ret)
+		return ret;
+
+	return configure_bcu(0);
+}
+
+static int mid_ocd_suspend(struct platform_device *pdev, pm_message_t mesg)
+{
+	return configure_bcu(1);
+}
+
+static int mid_ocd_remove(struct platform_device *pdev)
+{
+	struct ocd_info *cinfo = platform_get_drvdata(pdev);
+
+	if (cinfo) {
+		sysfs_remove_group(&pdev->dev.kobj, &mid_ocd_gr);
+		kfree(cinfo);
+	}
+	return 0;
+}
+
+/*********************************************************************
+ *		Driver initialisation and finalization
+ *********************************************************************/
+static const struct platform_device_id ocd_id_table[] = {
+	{ FIRMWARE_NAME, 1 },
+};
+
+static struct platform_driver mid_over_curr_detect_driver = {
+	.driver = {
+		.name = DRIVER_NAME,
+		.owner = THIS_MODULE,
+	},
+	.probe = mid_ocd_probe,
+	.suspend = mid_ocd_suspend,
+	.resume = mid_ocd_resume,
+	.remove = __devexit_p(mid_ocd_remove),
+	.id_table = ocd_id_table,
+};
+
+static int __init mid_ocd_module_init(void)
+{
+	return platform_driver_register(&mid_over_curr_detect_driver);
+}
+
+static void __exit mid_ocd_module_exit(void)
+{
+	platform_driver_unregister(&mid_over_curr_detect_driver);
+}
+
+module_init(mid_ocd_module_init);
+module_exit(mid_ocd_module_exit);
+
+MODULE_AUTHOR("Durgadoss R <durgadoss.r@intel.com>");
+MODULE_DESCRIPTION("Intel Medfield Over Current Detection Driver");
+MODULE_LICENSE("GPL");

