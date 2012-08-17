Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933711Ab2HQIf3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 04:35:29 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:44458 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932241Ab2HQIfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 04:35:23 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Aneesh V <aneesh@ti.com>, Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [PATCH v5] memory: emif: add device tree support to emif driver
Date: Fri, 17 Aug 2012 14:05:15 +0530
Message-ID: <1345192515-4158-1-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aneesh V <aneesh@ti.com>

Device tree support for the EMIF driver. LPDDR2 generic timings
extraction from device is managed using couple of helper
functions which can be used by other memory controller
drivers.

Reviewed-by: Benoit Cousson <b-cousson@ti.com>
Reviewed-by: Grant Likely <grant.likely@secretlab.ca>
Tested-by: Lokesh Vutla <lokeshvutla@ti.com>
Signed-off-by: Aneesh V <aneesh@ti.com>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
v5:
Updated the patch as per Greg's comment for moving
the lpddr2 dt timings generic functions to separate
file(of_memory.c)  and building it only for CONFIG_OF.

 drivers/memory/Makefile    |    1 +
 drivers/memory/emif.c      |  182 +++++++++++++++++++++++++++++++++++++++++++-
 drivers/memory/of_memory.c |  153 +++++++++++++++++++++++++++++++++++++
 drivers/memory/of_memory.h |   36 +++++++++
 4 files changed, 371 insertions(+), 1 deletion(-)
 create mode 100644 drivers/memory/of_memory.c
 create mode 100644 drivers/memory/of_memory.h

diff --git a/drivers/memory/Makefile b/drivers/memory/Makefile
index 42b3ce9..cd8486b 100644
--- a/drivers/memory/Makefile
+++ b/drivers/memory/Makefile
@@ -2,6 +2,7 @@
 # Makefile for memory devices
 #
 
+obj-$(CONFIG_OF)		+= of_memory.o
 obj-$(CONFIG_TI_EMIF)		+= emif.o
 obj-$(CONFIG_TEGRA20_MC)	+= tegra20-mc.o
 obj-$(CONFIG_TEGRA30_MC)	+= tegra30-mc.o
diff --git a/drivers/memory/emif.c b/drivers/memory/emif.c
index 33a4396..1424ae3 100644
--- a/drivers/memory/emif.c
+++ b/drivers/memory/emif.c
@@ -18,6 +18,7 @@
 #include <linux/platform_device.h>
 #include <linux/interrupt.h>
 #include <linux/slab.h>
+#include <linux/of.h>
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
 #include <linux/module.h>
@@ -25,6 +26,7 @@
 #include <linux/spinlock.h>
 #include <memory/jedec_ddr.h>
 #include "emif.h"
+#include "of_memory.h"
 
 /**
  * struct emif_data - Per device static data for driver's use
@@ -49,6 +51,7 @@
  *				frequency in effect at the moment)
  * @plat_data:			Pointer to saved platform data.
  * @debugfs_root:		dentry to the root folder for EMIF in debugfs
+ * @np_ddr:			Pointer to ddr device tree node
  */
 struct emif_data {
 	u8				duplicate;
@@ -63,6 +66,7 @@ struct emif_data {
 	struct emif_regs		*curr_regs;
 	struct emif_platform_data	*plat_data;
 	struct dentry			*debugfs_root;
+	struct device_node		*np_ddr;
 };
 
 static struct emif_data *emif1;
@@ -1148,6 +1152,168 @@ static int is_custom_config_valid(struct emif_custom_configs *cust_cfgs,
 	return valid;
 }
 
+#if defined(CONFIG_OF)
+static void __init_or_module of_get_custom_configs(struct device_node *np_emif,
+		struct emif_data *emif)
+{
+	struct emif_custom_configs	*cust_cfgs = NULL;
+	int				len;
+	const int			*lpmode, *poll_intvl;
+
+	lpmode = of_get_property(np_emif, "low-power-mode", &len);
+	poll_intvl = of_get_property(np_emif, "temp-alert-poll-interval", &len);
+
+	if (lpmode || poll_intvl)
+		cust_cfgs = devm_kzalloc(emif->dev, sizeof(*cust_cfgs),
+			GFP_KERNEL);
+
+	if (!cust_cfgs)
+		return;
+
+	if (lpmode) {
+		cust_cfgs->mask |= EMIF_CUSTOM_CONFIG_LPMODE;
+		cust_cfgs->lpmode = *lpmode;
+		of_property_read_u32(np_emif,
+				"low-power-mode-timeout-performance",
+				&cust_cfgs->lpmode_timeout_performance);
+		of_property_read_u32(np_emif,
+				"low-power-mode-timeout-power",
+				&cust_cfgs->lpmode_timeout_power);
+		of_property_read_u32(np_emif,
+				"low-power-mode-freq-threshold",
+				&cust_cfgs->lpmode_freq_threshold);
+	}
+
+	if (poll_intvl) {
+		cust_cfgs->mask |=
+				EMIF_CUSTOM_CONFIG_TEMP_ALERT_POLL_INTERVAL;
+		cust_cfgs->temp_alert_poll_interval_ms = *poll_intvl;
+	}
+
+	if (!is_custom_config_valid(cust_cfgs, emif->dev)) {
+		devm_kfree(emif->dev, cust_cfgs);
+		return;
+	}
+
+	emif->plat_data->custom_configs = cust_cfgs;
+}
+
+static void __init_or_module of_get_ddr_info(struct device_node *np_emif,
+		struct device_node *np_ddr,
+		struct ddr_device_info *dev_info)
+{
+	u32 density = 0, io_width = 0;
+	int len;
+
+	if (of_find_property(np_emif, "cs1-used", &len))
+		dev_info->cs1_used = true;
+
+	if (of_find_property(np_emif, "cal-resistor-per-cs", &len))
+		dev_info->cal_resistors_per_cs = true;
+
+	if (of_device_is_compatible(np_ddr , "jedec,lpddr2-s4"))
+		dev_info->type = DDR_TYPE_LPDDR2_S4;
+	else if (of_device_is_compatible(np_ddr , "jedec,lpddr2-s2"))
+		dev_info->type = DDR_TYPE_LPDDR2_S2;
+
+	of_property_read_u32(np_ddr, "density", &density);
+	of_property_read_u32(np_ddr, "io-width", &io_width);
+
+	/* Convert from density in Mb to the density encoding in jedc_ddr.h */
+	if (density & (density - 1))
+		dev_info->density = 0;
+	else
+		dev_info->density = __fls(density) - 5;
+
+	/* Convert from io_width in bits to io_width encoding in jedc_ddr.h */
+	if (io_width & (io_width - 1))
+		dev_info->io_width = 0;
+	else
+		dev_info->io_width = __fls(io_width) - 1;
+}
+
+static struct emif_data * __init_or_module of_get_memory_device_details(
+		struct device_node *np_emif, struct device *dev)
+{
+	struct emif_data		*emif = NULL;
+	struct ddr_device_info		*dev_info = NULL;
+	struct emif_platform_data	*pd = NULL;
+	struct device_node		*np_ddr;
+	int				len;
+
+	np_ddr = of_parse_phandle(np_emif, "device-handle", 0);
+	if (!np_ddr)
+		goto error;
+	emif	= devm_kzalloc(dev, sizeof(struct emif_data), GFP_KERNEL);
+	pd	= devm_kzalloc(dev, sizeof(*pd), GFP_KERNEL);
+	dev_info = devm_kzalloc(dev, sizeof(*dev_info), GFP_KERNEL);
+
+	if (!emif || !pd || !dev_info) {
+		dev_err(dev, "%s: Out of memory!!\n",
+			__func__);
+		goto error;
+	}
+
+	emif->plat_data		= pd;
+	pd->device_info		= dev_info;
+	emif->dev		= dev;
+	emif->np_ddr		= np_ddr;
+	emif->temperature_level	= SDRAM_TEMP_NOMINAL;
+
+	if (of_device_is_compatible(np_emif, "ti,emif-4d"))
+		emif->plat_data->ip_rev = EMIF_4D;
+	else if (of_device_is_compatible(np_emif, "ti,emif-4d5"))
+		emif->plat_data->ip_rev = EMIF_4D5;
+
+	of_property_read_u32(np_emif, "phy-type", &pd->phy_type);
+
+	if (of_find_property(np_emif, "hw-caps-ll-interface", &len))
+		pd->hw_caps |= EMIF_HW_CAPS_LL_INTERFACE;
+
+	of_get_ddr_info(np_emif, np_ddr, dev_info);
+	if (!is_dev_data_valid(pd->device_info->type, pd->device_info->density,
+			pd->device_info->io_width, pd->phy_type, pd->ip_rev,
+			emif->dev)) {
+		dev_err(dev, "%s: invalid device data!!\n", __func__);
+		goto error;
+	}
+	/*
+	 * For EMIF instances other than EMIF1 see if the devices connected
+	 * are exactly same as on EMIF1(which is typically the case). If so,
+	 * mark it as a duplicate of EMIF1. This will save some memory and
+	 * computation.
+	 */
+	if (emif1 && emif1->np_ddr == np_ddr) {
+		emif->duplicate = true;
+		goto out;
+	} else if (emif1) {
+		dev_warn(emif->dev, "%s: Non-symmetric DDR geometry\n",
+			__func__);
+	}
+
+	of_get_custom_configs(np_emif, emif);
+	emif->plat_data->timings = of_get_ddr_timings(np_ddr, emif->dev,
+					emif->plat_data->device_info->type,
+					&emif->plat_data->timings_arr_size);
+
+	emif->plat_data->min_tck = of_get_min_tck(np_ddr, emif->dev);
+	goto out;
+
+error:
+	return NULL;
+out:
+	return emif;
+}
+
+#else
+
+static struct emif_data * __init_or_module of_get_memory_device_details(
+		struct device_node *np_emif, struct device *dev)
+{
+	return NULL;
+}
+#endif
+
 static struct emif_data *__init_or_module get_device_details(
 		struct platform_device *pdev)
 {
@@ -1267,7 +1433,11 @@ static int __init_or_module emif_probe(struct platform_device *pdev)
 	struct resource		*res;
 	int			irq;
 
-	emif = get_device_details(pdev);
+	if (pdev->dev.of_node)
+		emif = of_get_memory_device_details(pdev->dev.of_node, &pdev->dev);
+	else
+		emif = get_device_details(pdev);
+
 	if (!emif) {
 		pr_err("%s: error getting device data\n", __func__);
 		goto error;
@@ -1644,11 +1814,21 @@ static void __attribute__((unused)) freq_post_notify_handling(void)
 	spin_unlock_irqrestore(&emif_lock, irq_state);
 }
 
+#if defined(CONFIG_OF)
+static const struct of_device_id emif_of_match[] = {
+		{ .compatible = "ti,emif-4d" },
+		{ .compatible = "ti,emif-4d5" },
+		{},
+};
+MODULE_DEVICE_TABLE(of, emif_of_match);
+#endif
+
 static struct platform_driver emif_driver = {
 	.remove		= __exit_p(emif_remove),
 	.shutdown	= emif_shutdown,
 	.driver = {
 		.name = "emif",
+		.of_match_table = of_match_ptr(emif_of_match),
 	},
 };
 
diff --git a/drivers/memory/of_memory.c b/drivers/memory/of_memory.c
new file mode 100644
index 0000000..6007435
--- /dev/null
+++ b/drivers/memory/of_memory.c
@@ -0,0 +1,153 @@
+/*
+ * OpenFirmware helpers for memory drivers
+ *
+ * Copyright (C) 2012 Texas Instruments, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <linux/list.h>
+#include <linux/of.h>
+#include <linux/gfp.h>
+#include <memory/jedec_ddr.h>
+#include <linux/export.h>
+
+/**
+ * of_get_min_tck() - extract min timing values for ddr
+ * @np: pointer to ddr device tree node
+ * @device: device requesting for min timing values
+ *
+ * Populates the lpddr2_min_tck structure by extracting data
+ * from device tree node. Returns a pointer to the populated
+ * structure. If any error in populating the structure, returns
+ * default min timings provided by JEDEC.
+ */
+const struct lpddr2_min_tck *of_get_min_tck(struct device_node *np,
+		struct device *dev)
+{
+	int			ret = 0;
+	struct lpddr2_min_tck	*min;
+
+	min = devm_kzalloc(dev, sizeof(*min), GFP_KERNEL);
+	if (!min)
+		goto default_min_tck;
+
+	ret |= of_property_read_u32(np, "tRPab-min-tck", &min->tRPab);
+	ret |= of_property_read_u32(np, "tRCD-min-tck", &min->tRCD);
+	ret |= of_property_read_u32(np, "tWR-min-tck", &min->tWR);
+	ret |= of_property_read_u32(np, "tRASmin-min-tck", &min->tRASmin);
+	ret |= of_property_read_u32(np, "tRRD-min-tck", &min->tRRD);
+	ret |= of_property_read_u32(np, "tWTR-min-tck", &min->tWTR);
+	ret |= of_property_read_u32(np, "tXP-min-tck", &min->tXP);
+	ret |= of_property_read_u32(np, "tRTP-min-tck", &min->tRTP);
+	ret |= of_property_read_u32(np, "tCKE-min-tck", &min->tCKE);
+	ret |= of_property_read_u32(np, "tCKESR-min-tck", &min->tCKESR);
+	ret |= of_property_read_u32(np, "tFAW-min-tck", &min->tFAW);
+
+	if (ret) {
+		devm_kfree(dev, min);
+		goto default_min_tck;
+	}
+
+	return min;
+
+default_min_tck:
+	dev_warn(dev, "%s: using default min-tck values\n", __func__);
+	return &lpddr2_jedec_min_tck;
+}
+EXPORT_SYMBOL(of_get_min_tck);
+
+static int of_do_get_timings(struct device_node *np,
+		struct lpddr2_timings *tim)
+{
+	int ret;
+
+	ret = of_property_read_u32(np, "max-freq", &tim->max_freq);
+	ret |= of_property_read_u32(np, "min-freq", &tim->min_freq);
+	ret |= of_property_read_u32(np, "tRPab", &tim->tRPab);
+	ret |= of_property_read_u32(np, "tRCD", &tim->tRCD);
+	ret |= of_property_read_u32(np, "tWR", &tim->tWR);
+	ret |= of_property_read_u32(np, "tRAS-min", &tim->tRAS_min);
+	ret |= of_property_read_u32(np, "tRRD", &tim->tRRD);
+	ret |= of_property_read_u32(np, "tWTR", &tim->tWTR);
+	ret |= of_property_read_u32(np, "tXP", &tim->tXP);
+	ret |= of_property_read_u32(np, "tRTP", &tim->tRTP);
+	ret |= of_property_read_u32(np, "tCKESR", &tim->tCKESR);
+	ret |= of_property_read_u32(np, "tDQSCK-max", &tim->tDQSCK_max);
+	ret |= of_property_read_u32(np, "tFAW", &tim->tFAW);
+	ret |= of_property_read_u32(np, "tZQCS", &tim->tZQCS);
+	ret |= of_property_read_u32(np, "tZQCL", &tim->tZQCL);
+	ret |= of_property_read_u32(np, "tZQinit", &tim->tZQinit);
+	ret |= of_property_read_u32(np, "tRAS-max-ns", &tim->tRAS_max_ns);
+	ret |= of_property_read_u32(np, "tDQSCK-max-derated",
+		&tim->tDQSCK_max_derated);
+
+	return ret;
+}
+
+/**
+ * of_get_ddr_timings() - extracts the ddr timings and updates no of
+ * frequencies available.
+ * @np_ddr: Pointer to ddr device tree node
+ * @dev: Device requesting for ddr timings
+ * @device_type: Type of ddr(LPDDR2 S2/S4)
+ * @nr_frequencies: No of frequencies available for ddr
+ * (updated by this function)
+ *
+ * Populates lpddr2_timings structure by extracting data from device
+ * tree node. Returns pointer to populated structure. If any error
+ * while populating, returns default timings provided by JEDEC.
+ */
+const struct lpddr2_timings *of_get_ddr_timings(struct device_node *np_ddr,
+		struct device *dev, u32 device_type, u32 *nr_frequencies)
+{
+	struct lpddr2_timings	*timings = NULL;
+	u32			arr_sz = 0, i = 0;
+	struct device_node	*np_tim;
+	char			*tim_compat;
+
+	switch (device_type) {
+	case DDR_TYPE_LPDDR2_S2:
+	case DDR_TYPE_LPDDR2_S4:
+		tim_compat = "jedec,lpddr2-timings";
+		break;
+	default:
+		dev_warn(dev, "%s: un-supported memory type\n", __func__);
+	}
+
+	for_each_child_of_node(np_ddr, np_tim)
+		if (of_device_is_compatible(np_tim, tim_compat))
+			arr_sz++;
+
+	if (arr_sz)
+		timings = devm_kzalloc(dev, sizeof(*timings) * arr_sz,
+			GFP_KERNEL);
+
+	if (!timings)
+		goto default_timings;
+
+	for_each_child_of_node(np_ddr, np_tim) {
+		if (of_device_is_compatible(np_tim, tim_compat)) {
+			if (of_do_get_timings(np_tim, &timings[i])) {
+				devm_kfree(dev, timings);
+				goto default_timings;
+			}
+			i++;
+		}
+	}
+
+	*nr_frequencies = arr_sz;
+
+	return timings;
+
+default_timings:
+	dev_warn(dev, "%s: using default timings\n", __func__);
+	*nr_frequencies = ARRAY_SIZE(lpddr2_jedec_timings);
+	return lpddr2_jedec_timings;
+}
+EXPORT_SYMBOL(of_get_ddr_timings);
diff --git a/drivers/memory/of_memory.h b/drivers/memory/of_memory.h
new file mode 100644
index 0000000..20b496e
--- /dev/null
+++ b/drivers/memory/of_memory.h
@@ -0,0 +1,36 @@
+/*
+ * OpenFirmware helpers for memory drivers
+ *
+ * Copyright (C) 2012 Texas Instruments, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __LINUX_MEMORY_OF_REG_H
+#define __LINUX_MEMORY_OF_REG_H
+
+#ifdef CONFIG_OF
+extern const struct lpddr2_min_tck *of_get_min_tck(struct device_node *np,
+		struct device *dev);
+extern const struct lpddr2_timings
+	*of_get_ddr_timings(struct device_node *np_ddr, struct device *dev,
+	u32 device_type, u32 *nr_frequencies);
+#else
+static inline const struct lpddr2_min_tck
+	*of_get_min_tck(struct device_node *np, struct device *dev)
+{
+	return NULL;
+}
+
+static inline const struct lpddr2_timings
+	*of_get_ddr_timings(struct device_node *np_ddr, struct device *dev,
+	u32 device_type, u32 *nr_frequencies)
+{
+	return NULL;
+}
+#endif /* CONFIG_OF */
+
+#endif /* __LINUX_MEMORY_OF_REG_ */
-- 
1.7.9.5

