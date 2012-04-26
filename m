Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757851Ab2DZRnB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 13:43:01 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:50120 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757225Ab2DZRlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 13:41:37 -0400
From: Keerthy <j-keerthy@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <khilman@ti.com>, <rjw@sisk.pl>, <linux-kernel@vger.kernel.org>,
        <linux-pm@lists.linux-foundation.org>
CC: <j-pihet@ti.com>, <j-keerthy@ti.com>
Subject: [PATCH V3 03/10] ARM: OMAP2+: smartreflex: Use the names from hwmod data instead of voltage domains.
Date: Thu, 26 Apr 2012 23:10:34 +0530
Message-ID: <1335462041-4949-4-git-send-email-j-keerthy@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1335462041-4949-1-git-send-email-j-keerthy@ti.com>
References: <1335462041-4949-1-git-send-email-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
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
Signed-off-by: J Keerthy <j-keerthy@ti.com>
---
 arch/arm/mach-omap2/smartreflex-class3.c |    4 +-
 arch/arm/mach-omap2/smartreflex.c        |   65 ++++++++++++------------------
 arch/arm/mach-omap2/sr_device.c          |    1 +
 include/linux/power/smartreflex.h        |    3 +
 4 files changed, 32 insertions(+), 41 deletions(-)

diff --git a/arch/arm/mach-omap2/smartreflex-class3.c b/arch/arm/mach-omap2/smartreflex-class3.c
index 9381654..1da8f03 100644
--- a/arch/arm/mach-omap2/smartreflex-class3.c
+++ b/arch/arm/mach-omap2/smartreflex-class3.c
@@ -19,8 +19,8 @@ static int sr_class3_enable(struct omap_sr *sr)
 	unsigned long volt = voltdm_get_voltage(sr->voltdm);
 
 	if (!volt) {
-		pr_warning("%s: Curr voltage unknown. Cannot enable sr_%s\n",
-				__func__, sr->voltdm->name);
+		pr_warning("%s: Curr voltage unknown. Cannot enable %s\n",
+				__func__, sr->name);
 		return -ENODATA;
 	}
 
diff --git a/arch/arm/mach-omap2/smartreflex.c b/arch/arm/mach-omap2/smartreflex.c
index 82bdd28..2edd1e2 100644
--- a/arch/arm/mach-omap2/smartreflex.c
+++ b/arch/arm/mach-omap2/smartreflex.c
@@ -183,7 +183,7 @@ static void sr_set_regfields(struct omap_sr *sr)
 		sr->err_weight = OMAP3430_SR_ERRWEIGHT;
 		sr->err_maxlimit = OMAP3430_SR_ERRMAXLIMIT;
 		sr->accum_data = OMAP3430_SR_ACCUMDATA;
-		if (!(strcmp(sr->voltdm->name, "mpu"))) {
+		if (!(strcmp(sr->name, "sr1"))) {
 			sr->senn_avgweight = OMAP3430_SR1_SENNAVGWEIGHT;
 			sr->senp_avgweight = OMAP3430_SR1_SENPAVGWEIGHT;
 		} else {
@@ -234,19 +234,13 @@ static void sr_stop_vddautocomp(struct omap_sr *sr)
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
@@ -265,7 +259,6 @@ error:
 	dev_err(&sr_info->pdev->dev, "%s: ERROR in registering"
 		"interrupt handler. Smartreflex will"
 		"not function as desired\n", __func__);
-	kfree(name);
 	kfree(sr_info);
 
 	return ret;
@@ -395,8 +388,7 @@ int sr_configure_errgen(struct voltagedomain *voltdm)
 	struct omap_sr *sr = _sr_lookup(voltdm);
 
 	if (IS_ERR(sr)) {
-		pr_warning("%s: omap_sr struct for sr_%s not found\n",
-			__func__, voltdm->name);
+		pr_warning("%s: omap_sr struct for voltdm not found\n",	__func__);
 		return PTR_ERR(sr);
 	}
 
@@ -463,8 +455,7 @@ int sr_disable_errgen(struct voltagedomain *voltdm)
 	struct omap_sr *sr = _sr_lookup(voltdm);
 
 	if (IS_ERR(sr)) {
-		pr_warning("%s: omap_sr struct for sr_%s not found\n",
-			__func__, voltdm->name);
+		pr_warning("%s: omap_sr struct for voltdm not found\n",	__func__);
 		return PTR_ERR(sr);
 	}
 
@@ -514,8 +505,7 @@ int sr_configure_minmax(struct voltagedomain *voltdm)
 	struct omap_sr *sr = _sr_lookup(voltdm);
 
 	if (IS_ERR(sr)) {
-		pr_warning("%s: omap_sr struct for sr_%s not found\n",
-			__func__, voltdm->name);
+		pr_warning("%s: omap_sr struct for voltdm not found\n",	__func__);
 		return PTR_ERR(sr);
 	}
 
@@ -600,8 +590,7 @@ int sr_enable(struct voltagedomain *voltdm, unsigned long volt)
 	int ret;
 
 	if (IS_ERR(sr)) {
-		pr_warning("%s: omap_sr struct for sr_%s not found\n",
-			__func__, voltdm->name);
+		pr_warning("%s: omap_sr struct for voltdm not found\n",	__func__);
 		return PTR_ERR(sr);
 	}
 
@@ -654,8 +643,7 @@ void sr_disable(struct voltagedomain *voltdm)
 	struct omap_sr *sr = _sr_lookup(voltdm);
 
 	if (IS_ERR(sr)) {
-		pr_warning("%s: omap_sr struct for sr_%s not found\n",
-			__func__, voltdm->name);
+		pr_warning("%s: omap_sr struct for voltdm not found\n",	__func__);
 		return;
 	}
 
@@ -735,8 +723,7 @@ void omap_sr_enable(struct voltagedomain *voltdm)
 	struct omap_sr *sr = _sr_lookup(voltdm);
 
 	if (IS_ERR(sr)) {
-		pr_warning("%s: omap_sr struct for sr_%s not found\n",
-			__func__, voltdm->name);
+		pr_warning("%s: omap_sr struct for voltdm not found\n",	__func__);
 		return;
 	}
 
@@ -768,8 +755,7 @@ void omap_sr_disable(struct voltagedomain *voltdm)
 	struct omap_sr *sr = _sr_lookup(voltdm);
 
 	if (IS_ERR(sr)) {
-		pr_warning("%s: omap_sr struct for sr_%s not found\n",
-			__func__, voltdm->name);
+		pr_warning("%s: omap_sr struct for voltdm not found\n",	__func__);
 		return;
 	}
 
@@ -801,8 +787,7 @@ void omap_sr_disable_reset_volt(struct voltagedomain *voltdm)
 	struct omap_sr *sr = _sr_lookup(voltdm);
 
 	if (IS_ERR(sr)) {
-		pr_warning("%s: omap_sr struct for sr_%s not found\n",
-			__func__, voltdm->name);
+		pr_warning("%s: omap_sr struct for voltdm not found\n",	__func__);
 		return;
 	}
 
@@ -889,7 +874,6 @@ static int __init omap_sr_probe(struct platform_device *pdev)
 	struct dentry *nvalue_dir;
 	struct omap_volt_data *volt_data;
 	int i, ret = 0;
-	char *name;
 
 	sr_info = kzalloc(sizeof(struct omap_sr), GFP_KERNEL);
 	if (!sr_info) {
@@ -926,6 +910,14 @@ static int __init omap_sr_probe(struct platform_device *pdev)
 	pm_runtime_enable(&pdev->dev);
 	pm_runtime_irq_safe(&pdev->dev);
 
+	sr_info->name = kasprintf(GFP_KERNEL, "%s", pdata->name);
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
@@ -973,20 +965,12 @@ static int __init omap_sr_probe(struct platform_device *pdev)
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
@@ -1008,10 +992,10 @@ static int __init omap_sr_probe(struct platform_device *pdev)
 
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
@@ -1029,6 +1013,8 @@ static int __init omap_sr_probe(struct platform_device *pdev)
 
 err_debugfs:
 	debugfs_remove_recursive(sr_info->dbg_dir);
+err_free_name:
+	kfree(sr_info->name);
 err_iounmap:
 	list_del(&sr_info->node);
 	iounmap(sr_info->base);
@@ -1065,6 +1051,7 @@ static int __devexit omap_sr_remove(struct platform_device *pdev)
 
 	list_del(&sr_info->node);
 	iounmap(sr_info->base);
+	kfree(sr_info->name);
 	kfree(sr_info);
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	release_mem_region(mem->start, resource_size(mem));
diff --git a/arch/arm/mach-omap2/sr_device.c b/arch/arm/mach-omap2/sr_device.c
index 86e438e..e081174 100644
--- a/arch/arm/mach-omap2/sr_device.c
+++ b/arch/arm/mach-omap2/sr_device.c
@@ -93,6 +93,7 @@ static int __init sr_dev_init(struct omap_hwmod *oh, void *user)
 		goto exit;
 	}
 
+	sr_data->name = oh->name;
 	sr_data->ip_type = oh->class->rev;
 	sr_data->senn_mod = 0x1;
 	sr_data->senp_mod = 0x1;
diff --git a/include/linux/power/smartreflex.h b/include/linux/power/smartreflex.h
index 4224698..884eaee 100644
--- a/include/linux/power/smartreflex.h
+++ b/include/linux/power/smartreflex.h
@@ -144,6 +144,7 @@
 #define OMAP3430_SR_ERRMAXLIMIT		0x02
 
 struct omap_sr {
+	char				*name;
 	struct list_head		node;
 	struct platform_device		*pdev;
 	struct omap_sr_nvalue_table	*nvalue_table;
@@ -232,6 +233,7 @@ struct omap_sr_nvalue_table {
 /**
  * struct omap_sr_data - Smartreflex platform data.
  *
+ * @name:		instance name
  * @ip_type:		Smartreflex IP type.
  * @senp_mod:		SENPENABLE value for the sr
  * @senn_mod:		SENNENABLE value for sr
@@ -243,6 +245,7 @@ struct omap_sr_nvalue_table {
  * @voltdm:		Pointer to the voltage domain associated with the SR
  */
 struct omap_sr_data {
+	const char			*name;
 	int				ip_type;
 	u32				senp_mod;
 	u32				senn_mod;
-- 
1.7.5.4

