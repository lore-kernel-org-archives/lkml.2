Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758190Ab2D0M0e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 08:26:34 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:47811 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757379Ab2D0MYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 08:24:48 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: <linux-kernel@vger.kernel.org>
CC: <greg@kroah.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, Aneesh V <aneesh@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [PATCH v5 3/7] memory: emif: add basic infrastructure for EMIF driver
Date: Fri, 27 Apr 2012 17:54:05 +0530
Message-ID: <1335529449-28046-4-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1335529449-28046-1-git-send-email-santosh.shilimkar@ti.com>
References: <y>
 <1335529449-28046-1-git-send-email-santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aneesh V <aneesh@ti.com>

EMIF is an SDRAM controller used in various Texas Instruments
SoCs. EMIF supports, based on its revision, one or more of
LPDDR2/DDR2/DDR3 protocols.

Add the basic infrastructure for EMIF driver that includes
driver registration, probe, parsing of platform data etc.

Signed-off-by: Aneesh V <aneesh@ti.com>
Reviewed-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Reviewed-by: Benoit Cousson <b-cousson@ti.com>
[santosh.shilimkar@ti.com: Moved to drivers/memory from drivers/misc]
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Tested-by: Lokesh Vutla <lokeshvutla@ti.com>
Cc: Greg KH <greg@kroah.com>
---
 Documentation/memory-devices/ti-emif.txt |   57 ++++++
 drivers/Kconfig                          |    4 +
 drivers/Makefile                         |    3 +
 drivers/memory/Kconfig                   |   22 +++
 drivers/memory/Makefile                  |    5 +
 drivers/memory/emif.c                    |  289 ++++++++++++++++++++++++++++++
 drivers/memory/emif.h                    |    7 +
 include/linux/platform_data/emif_plat.h  |  128 +++++++++++++
 8 files changed, 515 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/memory-devices/ti-emif.txt
 create mode 100644 drivers/memory/Kconfig
 create mode 100644 drivers/memory/Makefile
 create mode 100644 drivers/memory/emif.c
 create mode 100644 include/linux/platform_data/emif_plat.h

diff --git a/Documentation/memory-devices/ti-emif.txt b/Documentation/memory-devices/ti-emif.txt
new file mode 100644
index 0000000..f4ad9a7
--- /dev/null
+++ b/Documentation/memory-devices/ti-emif.txt
@@ -0,0 +1,57 @@
+TI EMIF SDRAM Controller Driver:
+
+Author
+========
+Aneesh V <aneesh@ti.com>
+
+Location
+============
+driver/memory/emif.c
+
+Supported SoCs:
+===================
+TI OMAP44xx
+TI OMAP54xx
+
+Menuconfig option:
+==========================
+Device Drivers
+	Memory devices
+		Texas Instruments EMIF driver
+
+Description
+===========
+This driver is for the EMIF module available in Texas Instruments
+SoCs. EMIF is an SDRAM controller that, based on its revision,
+supports one or more of DDR2, DDR3, and LPDDR2 SDRAM protocols.
+This driver takes care of only LPDDR2 memories presently. The
+functions of the driver includes re-configuring AC timing
+parameters and other settings during frequency, voltage and
+temperature changes
+
+Platform Data (see include/linux/platform_data/emif_plat.h):
+=====================================================================
+DDR device details and other board dependent and SoC dependent
+information can be passed through platform data (struct emif_platform_data)
+- DDR device details: 'struct ddr_device_info'
+- Device AC timings: 'struct lpddr2_timings' and 'struct lpddr2_min_tck'
+- Custom configurations: customizable policy options through
+  'struct emif_custom_configs'
+- IP revision
+- PHY type
+
+Interface to the external world:
+================================
+EMIF driver registers notifiers for voltage and frequency changes
+affecting EMIF and takes appropriate actions when these are invoked.
+- freq_pre_notify_handling()
+- freq_post_notify_handling()
+- volt_notify_handling()
+
+Debugfs
+========
+The driver creates two debugfs entries per device.
+- regcache_dump : dump of register values calculated and saved for all
+  frequencies used so far.
+- mr4 : last polled value of MR4 register in the LPDDR2 device. MR4
+  indicates the current temperature level of the device.
diff --git a/drivers/Kconfig b/drivers/Kconfig
index d236aef..b0e0629 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -140,4 +140,8 @@ source "drivers/virt/Kconfig"
 
 source "drivers/devfreq/Kconfig"
 
+# memory
+
+source "drivers/memory/Kconfig"
+
 endmenu
diff --git a/drivers/Makefile b/drivers/Makefile
index 95952c8..9cc81ee 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -134,3 +134,6 @@ obj-$(CONFIG_VIRT_DRIVERS)	+= virt/
 obj-$(CONFIG_HYPERV)		+= hv/
 
 obj-$(CONFIG_PM_DEVFREQ)	+= devfreq/
+
+# Memory drivers
+obj-$(CONFIG_MEMORY)		+= memory/
diff --git a/drivers/memory/Kconfig b/drivers/memory/Kconfig
new file mode 100644
index 0000000..b08327c
--- /dev/null
+++ b/drivers/memory/Kconfig
@@ -0,0 +1,22 @@
+#
+# Memory devices
+#
+
+menuconfig MEMORY
+	bool "Memory Controller drivers"
+
+if MEMORY
+
+config TI_EMIF
+	tristate "Texas Instruments EMIF driver"
+	select DDR
+	help
+	  This driver is for the EMIF module available in Texas Instruments
+	  SoCs. EMIF is an SDRAM controller that, based on its revision,
+	  supports one or more of DDR2, DDR3, and LPDDR2 SDRAM protocols.
+	  This driver takes care of only LPDDR2 memories presently. The
+	  functions of the driver includes re-configuring AC timing
+	  parameters and other settings during frequency, voltage and
+	  temperature changes
+
+endif
diff --git a/drivers/memory/Makefile b/drivers/memory/Makefile
new file mode 100644
index 0000000..e27f80b
--- /dev/null
+++ b/drivers/memory/Makefile
@@ -0,0 +1,5 @@
+#
+# Makefile for memory devices
+#
+
+obj-$(CONFIG_TI_EMIF)		+= emif.o
diff --git a/drivers/memory/emif.c b/drivers/memory/emif.c
new file mode 100644
index 0000000..7486d7e
--- /dev/null
+++ b/drivers/memory/emif.c
@@ -0,0 +1,289 @@
+/*
+ * EMIF driver
+ *
+ * Copyright (C) 2012 Texas Instruments, Inc.
+ *
+ * Aneesh V <aneesh@ti.com>
+ * Santosh Shilimkar <santosh.shilimkar@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/kernel.h>
+#include <linux/reboot.h>
+#include <linux/platform_data/emif_plat.h>
+#include <linux/io.h>
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include <linux/slab.h>
+#include <linux/seq_file.h>
+#include <linux/module.h>
+#include <linux/list.h>
+#include <memory/jedec_ddr.h>
+#include "emif.h"
+
+/**
+ * struct emif_data - Per device static data for driver's use
+ * @duplicate:			Whether the DDR devices attached to this EMIF
+ *				instance are exactly same as that on EMIF1. In
+ *				this case we can save some memory and processing
+ * @temperature_level:		Maximum temperature of LPDDR2 devices attached
+ *				to this EMIF - read from MR4 register. If there
+ *				are two devices attached to this EMIF, this
+ *				value is the maximum of the two temperature
+ *				levels.
+ * @node:			node in the device list
+ * @base:			base address of memory-mapped IO registers.
+ * @dev:			device pointer.
+ * @plat_data:			Pointer to saved platform data.
+ */
+struct emif_data {
+	u8				duplicate;
+	u8				temperature_level;
+	struct list_head		node;
+	void __iomem			*base;
+	struct device			*dev;
+	struct emif_platform_data	*plat_data;
+};
+
+static struct emif_data *emif1;
+static LIST_HEAD(device_list);
+
+static void get_default_timings(struct emif_data *emif)
+{
+	struct emif_platform_data *pd = emif->plat_data;
+
+	pd->timings		= lpddr2_jedec_timings;
+	pd->timings_arr_size	= ARRAY_SIZE(lpddr2_jedec_timings);
+
+	dev_warn(emif->dev, "%s: using default timings\n", __func__);
+}
+
+static int is_dev_data_valid(u32 type, u32 density, u32 io_width, u32 phy_type,
+		u32 ip_rev, struct device *dev)
+{
+	int valid;
+
+	valid = (type == DDR_TYPE_LPDDR2_S4 ||
+			type == DDR_TYPE_LPDDR2_S2)
+		&& (density >= DDR_DENSITY_64Mb
+			&& density <= DDR_DENSITY_8Gb)
+		&& (io_width >= DDR_IO_WIDTH_8
+			&& io_width <= DDR_IO_WIDTH_32);
+
+	/* Combinations of EMIF and PHY revisions that we support today */
+	switch (ip_rev) {
+	case EMIF_4D:
+		valid = valid && (phy_type == EMIF_PHY_TYPE_ATTILAPHY);
+		break;
+	case EMIF_4D5:
+		valid = valid && (phy_type == EMIF_PHY_TYPE_INTELLIPHY);
+		break;
+	default:
+		valid = 0;
+	}
+
+	if (!valid)
+		dev_err(dev, "%s: invalid DDR details\n", __func__);
+	return valid;
+}
+
+static int is_custom_config_valid(struct emif_custom_configs *cust_cfgs,
+		struct device *dev)
+{
+	int valid = 1;
+
+	if ((cust_cfgs->mask & EMIF_CUSTOM_CONFIG_LPMODE) &&
+		(cust_cfgs->lpmode != EMIF_LP_MODE_DISABLE))
+		valid = cust_cfgs->lpmode_freq_threshold &&
+			cust_cfgs->lpmode_timeout_performance &&
+			cust_cfgs->lpmode_timeout_power;
+
+	if (cust_cfgs->mask & EMIF_CUSTOM_CONFIG_TEMP_ALERT_POLL_INTERVAL)
+		valid = valid && cust_cfgs->temp_alert_poll_interval_ms;
+
+	if (!valid)
+		dev_warn(dev, "%s: invalid custom configs\n", __func__);
+
+	return valid;
+}
+
+static struct emif_data *__init_or_module get_device_details(
+		struct platform_device *pdev)
+{
+	u32				size;
+	struct emif_data		*emif = NULL;
+	struct ddr_device_info		*dev_info;
+	struct emif_custom_configs	*cust_cfgs;
+	struct emif_platform_data	*pd;
+	struct device			*dev;
+	void				*temp;
+
+	pd = pdev->dev.platform_data;
+	dev = &pdev->dev;
+
+	if (!(pd && pd->device_info && is_dev_data_valid(pd->device_info->type,
+			pd->device_info->density, pd->device_info->io_width,
+			pd->phy_type, pd->ip_rev, dev))) {
+		dev_err(dev, "%s: invalid device data\n", __func__);
+		goto error;
+	}
+
+	emif	= devm_kzalloc(dev, sizeof(*emif), GFP_KERNEL);
+	temp	= devm_kzalloc(dev, sizeof(*pd), GFP_KERNEL);
+	dev_info = devm_kzalloc(dev, sizeof(*dev_info), GFP_KERNEL);
+
+	if (!emif || !pd || !dev_info) {
+		dev_err(dev, "%s:%d: allocation error\n", __func__, __LINE__);
+		goto error;
+	}
+
+	memcpy(temp, pd, sizeof(*pd));
+	pd = temp;
+	memcpy(dev_info, pd->device_info, sizeof(*dev_info));
+
+	pd->device_info		= dev_info;
+	emif->plat_data		= pd;
+	emif->dev		= dev;
+	emif->temperature_level	= SDRAM_TEMP_NOMINAL;
+
+	/*
+	 * For EMIF instances other than EMIF1 see if the devices connected
+	 * are exactly same as on EMIF1(which is typically the case). If so,
+	 * mark it as a duplicate of EMIF1 and skip copying timings data.
+	 * This will save some memory and some computation later.
+	 */
+	emif->duplicate = emif1 && (memcmp(dev_info,
+		emif1->plat_data->device_info,
+		sizeof(struct ddr_device_info)) == 0);
+
+	if (emif->duplicate) {
+		pd->timings = NULL;
+		pd->min_tck = NULL;
+		goto out;
+	} else if (emif1) {
+		dev_warn(emif->dev, "%s: Non-symmetric DDR geometry\n",
+			__func__);
+	}
+
+	/*
+	 * Copy custom configs - ignore allocation error, if any, as
+	 * custom_configs is not very critical
+	 */
+	cust_cfgs = pd->custom_configs;
+	if (cust_cfgs && is_custom_config_valid(cust_cfgs, dev)) {
+		temp = devm_kzalloc(dev, sizeof(*cust_cfgs), GFP_KERNEL);
+		if (temp)
+			memcpy(temp, cust_cfgs, sizeof(*cust_cfgs));
+		else
+			dev_warn(dev, "%s:%d: allocation error\n", __func__,
+				__LINE__);
+		pd->custom_configs = temp;
+	}
+
+	/*
+	 * Copy timings and min-tck values from platform data. If it is not
+	 * available or if memory allocation fails, use JEDEC defaults
+	 */
+	size = sizeof(struct lpddr2_timings) * pd->timings_arr_size;
+	if (pd->timings) {
+		temp = devm_kzalloc(dev, size, GFP_KERNEL);
+		if (temp) {
+			memcpy(temp, pd->timings, sizeof(*pd->timings));
+			pd->timings = temp;
+		} else {
+			dev_warn(dev, "%s:%d: allocation error\n", __func__,
+				__LINE__);
+			get_default_timings(emif);
+		}
+	} else {
+		get_default_timings(emif);
+	}
+
+	if (pd->min_tck) {
+		temp = devm_kzalloc(dev, sizeof(*pd->min_tck), GFP_KERNEL);
+		if (temp) {
+			memcpy(temp, pd->min_tck, sizeof(*pd->min_tck));
+			pd->min_tck = temp;
+		} else {
+			dev_warn(dev, "%s:%d: allocation error\n", __func__,
+				__LINE__);
+			pd->min_tck = &lpddr2_jedec_min_tck;
+		}
+	} else {
+		pd->min_tck = &lpddr2_jedec_min_tck;
+	}
+
+out:
+	return emif;
+
+error:
+	return NULL;
+}
+
+static int __init_or_module emif_probe(struct platform_device *pdev)
+{
+	struct emif_data	*emif;
+	struct resource		*res;
+
+	emif = get_device_details(pdev);
+	if (!emif) {
+		pr_err("%s: error getting device data\n", __func__);
+		goto error;
+	}
+
+	if (!emif1)
+		emif1 = emif;
+
+	list_add(&emif->node, &device_list);
+
+	/* Save pointers to each other in emif and device structures */
+	emif->dev = &pdev->dev;
+	platform_set_drvdata(pdev, emif);
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(emif->dev, "%s: error getting memory resource\n",
+			__func__);
+		goto error;
+	}
+
+	emif->base = devm_request_and_ioremap(emif->dev, res);
+	if (!emif->base) {
+		dev_err(emif->dev, "%s: devm_request_and_ioremap() failed\n",
+			__func__);
+		goto error;
+	}
+
+	dev_info(&pdev->dev, "%s: device configured with addr = %p\n",
+		__func__, emif->base);
+
+	return 0;
+error:
+	return -ENODEV;
+}
+
+static struct platform_driver emif_driver = {
+	.driver = {
+		.name = "emif",
+	},
+};
+
+static int __init_or_module emif_register(void)
+{
+	return platform_driver_probe(&emif_driver, emif_probe);
+}
+
+static void __exit emif_unregister(void)
+{
+	platform_driver_unregister(&emif_driver);
+}
+
+module_init(emif_register);
+module_exit(emif_unregister);
+MODULE_DESCRIPTION("TI EMIF SDRAM Controller Driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:emif");
+MODULE_AUTHOR("Texas Instruments Inc");
diff --git a/drivers/memory/emif.h b/drivers/memory/emif.h
index 44b97df..692b2a8 100644
--- a/drivers/memory/emif.h
+++ b/drivers/memory/emif.h
@@ -12,6 +12,13 @@
 #ifndef __EMIF_H
 #define __EMIF_H
 
+/*
+ * Maximum number of different frequencies supported by EMIF driver
+ * Determines the number of entries in the pointer array for register
+ * cache
+ */
+#define EMIF_MAX_NUM_FREQUENCIES			6
+
 /* Registers offset */
 #define EMIF_MODULE_ID_AND_REVISION			0x0000
 #define EMIF_STATUS					0x0004
diff --git a/include/linux/platform_data/emif_plat.h b/include/linux/platform_data/emif_plat.h
new file mode 100644
index 0000000..03378ca
--- /dev/null
+++ b/include/linux/platform_data/emif_plat.h
@@ -0,0 +1,128 @@
+/*
+ * Definitions for TI EMIF device platform data
+ *
+ * Copyright (C) 2012 Texas Instruments, Inc.
+ *
+ * Aneesh V <aneesh@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __EMIF_PLAT_H
+#define __EMIF_PLAT_H
+
+/* Low power modes - EMIF_PWR_MGMT_CTRL */
+#define EMIF_LP_MODE_DISABLE				0
+#define EMIF_LP_MODE_CLOCK_STOP				1
+#define EMIF_LP_MODE_SELF_REFRESH			2
+#define EMIF_LP_MODE_PWR_DN				4
+
+/* Hardware capabilities */
+#define	EMIF_HW_CAPS_LL_INTERFACE			0x00000001
+
+/*
+ * EMIF IP Revisions
+ *	EMIF4D  - Used in OMAP4
+ *	EMIF4D5 - Used in OMAP5
+ */
+#define	EMIF_4D						1
+#define	EMIF_4D5					2
+
+/*
+ * PHY types
+ *	ATTILAPHY  - Used in OMAP4
+ *	INTELLIPHY - Used in OMAP5
+ */
+#define	EMIF_PHY_TYPE_ATTILAPHY				1
+#define	EMIF_PHY_TYPE_INTELLIPHY			2
+
+/* Custom config requests */
+#define EMIF_CUSTOM_CONFIG_LPMODE			0x00000001
+#define EMIF_CUSTOM_CONFIG_TEMP_ALERT_POLL_INTERVAL	0x00000002
+
+#ifndef __ASSEMBLY__
+/**
+ * struct ddr_device_info - All information about the DDR device except AC
+ *		timing parameters
+ * @type:	Device type (LPDDR2-S4, LPDDR2-S2 etc)
+ * @density:	Device density
+ * @io_width:	Bus width
+ * @cs1_used:	Whether there is a DDR device attached to the second
+ *		chip-select(CS1) of this EMIF instance
+ * @cal_resistors_per_cs: Whether there is one calibration resistor per
+ *		chip-select or whether it's a single one for both
+ * @manufacturer: Manufacturer name string
+ */
+struct ddr_device_info {
+	u32	type;
+	u32	density;
+	u32	io_width;
+	u32	cs1_used;
+	u32	cal_resistors_per_cs;
+	char	manufacturer[10];
+};
+
+/**
+ * struct emif_custom_configs - Custom configuration parameters/policies
+ *		passed from the platform layer
+ * @mask:	Mask to indicate which configs are requested
+ * @lpmode:	LPMODE to be used in PWR_MGMT_CTRL register
+ * @lpmode_timeout_performance: Timeout before LPMODE entry when higher
+ *		performance is desired at the cost of power (typically
+ *		at higher OPPs)
+ * @lpmode_timeout_power: Timeout before LPMODE entry when better power
+ *		savings is desired and performance is not important
+ *		(typically at lower loads indicated by lower OPPs)
+ * @lpmode_freq_threshold: The DDR frequency threshold to identify between
+ *		the above two cases:
+ *		timeout = (freq >= lpmode_freq_threshold) ?
+ *			lpmode_timeout_performance :
+ *			lpmode_timeout_power;
+ * @temp_alert_poll_interval_ms: LPDDR2 MR4 polling interval at nominal
+ *		temperature(in milliseconds). When temperature is high
+ *		polling is done 4 times as frequently.
+ */
+struct emif_custom_configs {
+	u32 mask;
+	u32 lpmode;
+	u32 lpmode_timeout_performance;
+	u32 lpmode_timeout_power;
+	u32 lpmode_freq_threshold;
+	u32 temp_alert_poll_interval_ms;
+};
+
+/**
+ * struct emif_platform_data - Platform data passed on EMIF platform
+ *				device creation. Used by the driver.
+ * @hw_caps:		Hw capabilities of the EMIF IP in the respective SoC
+ * @device_info:	Device info structure containing information such
+ *			as type, bus width, density etc
+ * @timings:		Timings information from device datasheet passed
+ *			as an array of 'struct lpddr2_timings'. Can be NULL
+ *			if if default timings are ok
+ * @timings_arr_size:	Size of the timings array. Depends on the number
+ *			of different frequencies for which timings data
+ *			is provided
+ * @min_tck:		Minimum value of some timing parameters in terms
+ *			of number of cycles. Can be NULL if default values
+ *			are ok
+ * @custom_configs:	Custom configurations requested by SoC or board
+ *			code and the data for them. Can be NULL if default
+ *			configurations done by the driver are ok. See
+ *			documentation for 'struct emif_custom_configs' for
+ *			more details
+ */
+struct emif_platform_data {
+	u32 hw_caps;
+	struct ddr_device_info *device_info;
+	const struct lpddr2_timings *timings;
+	u32 timings_arr_size;
+	const struct lpddr2_min_tck *min_tck;
+	struct emif_custom_configs *custom_configs;
+	u32 ip_rev;
+	u32 phy_type;
+};
+#endif /* __ASSEMBLY__ */
+
+#endif /* __LINUX_EMIF_H */
-- 
1.7.5.4

