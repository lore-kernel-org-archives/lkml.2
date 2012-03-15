Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031852Ab2COQol (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 12:44:41 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:52403 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031795Ab2COQo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 12:44:27 -0400
From: jean.pihet@newoldbits.com
To: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Kevin Hilman <khilman@ti.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        LKML <linux-kernel@vger.kernel.org>
Cc: Jean Pihet <j-pihet@ti.com>
Subject: [PATCH 04/10] ARM: OMAP2+: smartreflex: Use the names from hwmod data instead of voltage domains.
Date: Thu, 15 Mar 2012 17:43:59 +0100
Message-Id: <1331829845-9526-5-git-send-email-j-pihet@ti.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1331829845-9526-1-git-send-email-j-pihet@ti.com>
References: <1331829845-9526-1-git-send-email-j-pihet@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean Pihet <j-pihet@ti.com>

Associate a name with each SmartReflex instance from the hwmod data,
rather than attempting to reuse the name of a voltage domain. The name
from hwmod better reflects the smartreflex integration in the system.

Also have the name passed to the drivers using pdata, which helps to remove
any dependencies on SoC-specific structures.

Signed-off-by: Jean Pihet <j-pihet@ti.com>
---
 arch/arm/mach-omap2/smartreflex-class3.c      |    4 +-
 arch/arm/mach-omap2/smartreflex.c             |   65 ++++++++++---------------
 arch/arm/mach-omap2/sr_device.c               |    1 +
 arch/arm/plat-omap/include/plat/smartreflex.h |    3 +
 4 files changed, 32 insertions(+), 41 deletions(-)

diff --git a/arch/arm/mach-omap2/smartreflex-class3.c b/arch/arm/mach-omap2/smartreflex-class3.c
index a105077..9a19ce7 100644
--- a/arch/arm/mach-omap2/smartreflex-class3.c
+++ b/arch/arm/mach-omap2/smartreflex-class3.c
@@ -18,8 +18,8 @@ static int sr_class3_enable(struct omap_sr *sr)
 	unsigned long volt = voltdm_get_voltage(sr->voltdm);
 
 	if (!volt) {
-		pr_warning("%s: Curr voltage unknown. Cannot enable sr_%s\n",
-				__func__, sr->voltdm->name);
+		pr_warning("%s: Curr voltage unknown. Cannot enable %s\n",
+				__func__, sr->name);
 		return -ENODATA;
 	}
 
diff --git a/arch/arm/mach-omap2/smartreflex.c b/arch/arm/mach-omap2/smartreflex.c
index 57a484d..8e3ef66 100644
--- a/arch/arm/mach-omap2/smartreflex.c
+++ b/arch/arm/mach-omap2/smartreflex.c
@@ -184,7 +184,7 @@ static void sr_set_regfields(struct omap_sr *sr)
 		sr->err_weight = OMAP3430_SR_ERRWEIGHT;
 		sr->err_maxlimit = OMAP3430_SR_ERRMAXLIMIT;
 		sr->accum_data = OMAP3430_SR_ACCUMDATA;
-		if (!(strcmp(sr->voltdm->name, "mpu"))) {
+		if (!(strcmp(sr->name, "sr1"))) {
 			sr->senn_avgweight = OMAP3430_SR1_SENNAVGWEIGHT;
 			sr->senp_avgweight = OMAP3430_SR1_SENPAVGWEIGHT;
 		} else {
@@ -235,19 +235,13 @@ static void sr_stop_vddautocomp(struct omap_sr *sr)
  */
 static int sr_late_init(struct omap_sr *sr_info)
 {
-	char *name;
 	struct omap_sr_data *pdata = sr_info->pdev->dev.platform_data;
 	struct resource *mem;
 	int ret = 0;
 
 	if (sr_class->notify && sr_class->notify_flags && sr_info->irq) {
-		name = kasprintf(GFP_KERNEL, "sr_%s", sr_info->voltdm->name);
-		if (name == NULL) {
-			ret = -ENOMEM;
-			goto error;
-		}
 		ret = request_irq(sr_info->irq, sr_interrupt,
-				0, name, sr_info);
+				  0, sr_info->name, sr_info);
 		if (ret)
 			goto error;
 		disable_irq(sr_info->irq);
@@ -266,7 +260,6 @@ error:
 	dev_err(&sr_info->pdev->dev, "%s: ERROR in registering"
 		"interrupt handler. Smartreflex will"
 		"not function as desired\n", __func__);
-	kfree(name);
 	kfree(sr_info);
 
 	return ret;
@@ -396,8 +389,7 @@ int sr_configure_errgen(struct voltagedomain *voltdm)
 	struct omap_sr *sr = _sr_lookup(voltdm);
 
 	if (IS_ERR(sr)) {
-		pr_warning("%s: omap_sr struct for sr_%s not found\n",
-			__func__, voltdm->name);
+		pr_warning("%s: omap_sr struct for voltdm not found\n",	__func__);
 		return PTR_ERR(sr);
 	}
 
@@ -464,8 +456,7 @@ int sr_disable_errgen(struct voltagedomain *voltdm)
 	struct omap_sr *sr = _sr_lookup(voltdm);
 
 	if (IS_ERR(sr)) {
-		pr_warning("%s: omap_sr struct for sr_%s not found\n",
-			__func__, voltdm->name);
+		pr_warning("%s: omap_sr struct for voltdm not found\n",	__func__);
 		return PTR_ERR(sr);
 	}
 
@@ -515,8 +506,7 @@ int sr_configure_minmax(struct voltagedomain *voltdm)
 	struct omap_sr *sr = _sr_lookup(voltdm);
 
 	if (IS_ERR(sr)) {
-		pr_warning("%s: omap_sr struct for sr_%s not found\n",
-			__func__, voltdm->name);
+		pr_warning("%s: omap_sr struct for voltdm not found\n",	__func__);
 		return PTR_ERR(sr);
 	}
 
@@ -601,8 +591,7 @@ int sr_enable(struct voltagedomain *voltdm, unsigned long volt)
 	int ret;
 
 	if (IS_ERR(sr)) {
-		pr_warning("%s: omap_sr struct for sr_%s not found\n",
-			__func__, voltdm->name);
+		pr_warning("%s: omap_sr struct for voltdm not found\n",	__func__);
 		return PTR_ERR(sr);
 	}
 
@@ -655,8 +644,7 @@ void sr_disable(struct voltagedomain *voltdm)
 	struct omap_sr *sr = _sr_lookup(voltdm);
 
 	if (IS_ERR(sr)) {
-		pr_warning("%s: omap_sr struct for sr_%s not found\n",
-			__func__, voltdm->name);
+		pr_warning("%s: omap_sr struct for voltdm not found\n",	__func__);
 		return;
 	}
 
@@ -736,8 +724,7 @@ void omap_sr_enable(struct voltagedomain *voltdm)
 	struct omap_sr *sr = _sr_lookup(voltdm);
 
 	if (IS_ERR(sr)) {
-		pr_warning("%s: omap_sr struct for sr_%s not found\n",
-			__func__, voltdm->name);
+		pr_warning("%s: omap_sr struct for voltdm not found\n",	__func__);
 		return;
 	}
 
@@ -769,8 +756,7 @@ void omap_sr_disable(struct voltagedomain *voltdm)
 	struct omap_sr *sr = _sr_lookup(voltdm);
 
 	if (IS_ERR(sr)) {
-		pr_warning("%s: omap_sr struct for sr_%s not found\n",
-			__func__, voltdm->name);
+		pr_warning("%s: omap_sr struct for voltdm not found\n",	__func__);
 		return;
 	}
 
@@ -802,8 +788,7 @@ void omap_sr_disable_reset_volt(struct voltagedomain *voltdm)
 	struct omap_sr *sr = _sr_lookup(voltdm);
 
 	if (IS_ERR(sr)) {
-		pr_warning("%s: omap_sr struct for sr_%s not found\n",
-			__func__, voltdm->name);
+		pr_warning("%s: omap_sr struct for voltdm not found\n",	__func__);
 		return;
 	}
 
@@ -890,7 +875,6 @@ static int __init omap_sr_probe(struct platform_device *pdev)
 	struct dentry *nvalue_dir;
 	struct omap_volt_data *volt_data;
 	int i, ret = 0;
-	char *name;
 
 	sr_info = kzalloc(sizeof(struct omap_sr), GFP_KERNEL);
 	if (!sr_info) {
@@ -927,6 +911,14 @@ static int __init omap_sr_probe(struct platform_device *pdev)
 	pm_runtime_enable(&pdev->dev);
 	pm_runtime_irq_safe(&pdev->dev);
 
+	sr_info->name = kasprintf(GFP_KERNEL, "sr_%s", pdata->name);
+	if (!sr_info->name) {
+		dev_err(&pdev->dev, "%s: Unable to alloc SR instance name\n",
+			__func__);
+		ret = -ENOMEM;
+		goto err_release_region;
+	}
+
 	sr_info->pdev = pdev;
 	sr_info->srid = pdev->id;
 	sr_info->voltdm = pdata->voltdm;
@@ -974,20 +966,12 @@ static int __init omap_sr_probe(struct platform_device *pdev)
 		}
 	}
 
-	name = kasprintf(GFP_KERNEL, "sr_%s", sr_info->voltdm->name);
-	if (!name) {
-		dev_err(&pdev->dev, "%s: Unable to alloc debugfs name\n",
-			__func__);
-		ret = -ENOMEM;
-		goto err_iounmap;
-	}
-	sr_info->dbg_dir = debugfs_create_dir(name, sr_dbg_dir);
-	kfree(name);
+	sr_info->dbg_dir = debugfs_create_dir(sr_info->name, sr_dbg_dir);
 	if (IS_ERR_OR_NULL(sr_info->dbg_dir)) {
 		dev_err(&pdev->dev, "%s: Unable to create debugfs directory\n",
 			__func__);
 		ret = PTR_ERR(sr_info->dbg_dir);
-		goto err_iounmap;
+		goto err_free_name;
 	}
 
 	(void) debugfs_create_file("autocomp", S_IRUGO | S_IWUSR,
@@ -1009,10 +993,10 @@ static int __init omap_sr_probe(struct platform_device *pdev)
 
 	omap_voltage_get_volttable(sr_info->voltdm, &volt_data);
 	if (!volt_data) {
-		dev_warn(&pdev->dev, "%s: No Voltage table for the"
-			" corresponding vdd vdd_%s. Cannot create debugfs"
+		dev_warn(&pdev->dev, "%s: %s: No Voltage table for the"
+			" corresponding vdd. Cannot create debugfs"
 			"entries for n-values\n",
-			__func__, sr_info->voltdm->name);
+			__func__, sr_info->name);
 		ret = -ENODATA;
 		goto err_debugfs;
 	}
@@ -1030,6 +1014,8 @@ static int __init omap_sr_probe(struct platform_device *pdev)
 
 err_debugfs:
 	debugfs_remove_recursive(sr_info->dbg_dir);
+err_free_name:
+	kfree(sr_info->name);
 err_iounmap:
 	list_del(&sr_info->node);
 	iounmap(sr_info->base);
@@ -1066,6 +1052,7 @@ static int __devexit omap_sr_remove(struct platform_device *pdev)
 
 	list_del(&sr_info->node);
 	iounmap(sr_info->base);
+	kfree(sr_info->name);
 	kfree(sr_info);
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	release_mem_region(mem->start, resource_size(mem));
diff --git a/arch/arm/mach-omap2/sr_device.c b/arch/arm/mach-omap2/sr_device.c
index dad1473..2c74ebc 100644
--- a/arch/arm/mach-omap2/sr_device.c
+++ b/arch/arm/mach-omap2/sr_device.c
@@ -93,6 +93,7 @@ static int __init sr_dev_init(struct omap_hwmod *oh, void *user)
 		goto exit;
 	}
 
+	sr_data->name = oh->name;
 	sr_data->ip_type = oh->class->rev;
 	sr_data->senn_mod = 0x1;
 	sr_data->senp_mod = 0x1;
diff --git a/arch/arm/plat-omap/include/plat/smartreflex.h b/arch/arm/plat-omap/include/plat/smartreflex.h
index 3f46706..7bfc91a 100644
--- a/arch/arm/plat-omap/include/plat/smartreflex.h
+++ b/arch/arm/plat-omap/include/plat/smartreflex.h
@@ -20,6 +20,7 @@
 #include "voltage.h"
 
 struct omap_sr {
+	char				*name;
 	struct list_head		node;
 	struct platform_device		*pdev;
 	struct omap_sr_nvalue_table	*nvalue_table;
@@ -56,6 +57,7 @@ struct omap_sr_nvalue_table {
 /**
  * struct omap_sr_data - Smartreflex platform data.
  *
+ * @name:		instance name
  * @ip_type:		Smartreflex IP type.
  * @senp_mod:		SENPENABLE value for the sr
  * @senn_mod:		SENNENABLE value for sr
@@ -67,6 +69,7 @@ struct omap_sr_nvalue_table {
  * @voltdm:		Pointer to the voltage domain associated with the SR
  */
 struct omap_sr_data {
+	const char			*name;
 	int				ip_type;
 	u32				senp_mod;
 	u32				senn_mod;
-- 
1.7.5.4

