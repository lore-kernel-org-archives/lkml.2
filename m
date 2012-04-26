Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757148Ab2DZRle (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 13:41:34 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:50109 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756893Ab2DZRlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 13:41:31 -0400
From: Keerthy <j-keerthy@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <khilman@ti.com>, <rjw@sisk.pl>, <linux-kernel@vger.kernel.org>,
        <linux-pm@lists.linux-foundation.org>
CC: <j-pihet@ti.com>, <j-keerthy@ti.com>, Paul Walmsley <paul@pwsan.com>,
        Thara Gopinath <thara@ti.com>, Nishanth Menon <nm@ti.com>
Subject: [PATCH V3 02/10] ARM: OMAP3+: SmartReflex: class drivers should use struct omap_sr *
Date: Thu, 26 Apr 2012 23:10:33 +0530
Message-ID: <1335462041-4949-3-git-send-email-j-keerthy@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1335462041-4949-1-git-send-email-j-keerthy@ti.com>
References: <1335462041-4949-1-git-send-email-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean Pihet <j-pihet@ti.com>

Convert SmartReflex "class" functions to take a struct omap_sr *, rather than
a struct voltagedomain *.  SmartReflex code should be driver code and not
tightly coupled to OMAP subarchitecture-specific structures.

Based on Paul's original code for the SmartReflex driver conversion.

Signed-off-by: Jean Pihet <j-pihet@ti.com>
Signed-off-by: J Keerthy <j-keerthy@ti.com>
Cc: Paul Walmsley <paul@pwsan.com>
Cc: Thara Gopinath <thara@ti.com>
Cc: Nishanth Menon <nm@ti.com>
Cc: Kevin Hilman <khilman@ti.com>
---
 arch/arm/mach-omap2/smartreflex-class3.c |   24 +++++++++---------
 arch/arm/mach-omap2/smartreflex.c        |   37 +++++------------------------
 include/linux/power/smartreflex.h        |   31 +++++++++++++++++++++---
 3 files changed, 46 insertions(+), 46 deletions(-)

diff --git a/arch/arm/mach-omap2/smartreflex-class3.c b/arch/arm/mach-omap2/smartreflex-class3.c
index ab8cf83..9381654 100644
--- a/arch/arm/mach-omap2/smartreflex-class3.c
+++ b/arch/arm/mach-omap2/smartreflex-class3.c
@@ -14,34 +14,34 @@
 #include <linux/power/smartreflex.h>
 #include "voltage.h"
 
-static int sr_class3_enable(struct voltagedomain *voltdm)
+static int sr_class3_enable(struct omap_sr *sr)
 {
-	unsigned long volt = voltdm_get_voltage(voltdm);
+	unsigned long volt = voltdm_get_voltage(sr->voltdm);
 
 	if (!volt) {
 		pr_warning("%s: Curr voltage unknown. Cannot enable sr_%s\n",
-				__func__, voltdm->name);
+				__func__, sr->voltdm->name);
 		return -ENODATA;
 	}
 
-	omap_vp_enable(voltdm);
-	return sr_enable(voltdm, volt);
+	omap_vp_enable(sr->voltdm);
+	return sr_enable(sr->voltdm, volt);
 }
 
-static int sr_class3_disable(struct voltagedomain *voltdm, int is_volt_reset)
+static int sr_class3_disable(struct omap_sr *sr, int is_volt_reset)
 {
-	sr_disable_errgen(voltdm);
-	omap_vp_disable(voltdm);
-	sr_disable(voltdm);
+	sr_disable_errgen(sr->voltdm);
+	omap_vp_disable(sr->voltdm);
+	sr_disable(sr->voltdm);
 	if (is_volt_reset)
-		voltdm_reset(voltdm);
+		voltdm_reset(sr->voltdm);
 
 	return 0;
 }
 
-static int sr_class3_configure(struct voltagedomain *voltdm)
+static int sr_class3_configure(struct omap_sr *sr)
 {
-	return sr_configure_errgen(voltdm);
+	return sr_configure_errgen(sr->voltdm);
 }
 
 /* SR class3 structure */
diff --git a/arch/arm/mach-omap2/smartreflex.c b/arch/arm/mach-omap2/smartreflex.c
index 98309d3..82bdd28 100644
--- a/arch/arm/mach-omap2/smartreflex.c
+++ b/arch/arm/mach-omap2/smartreflex.c
@@ -34,29 +34,6 @@
 #define NVALUE_NAME_LEN		40
 #define SR_DISABLE_TIMEOUT	200
 
-struct omap_sr {
-	struct list_head		node;
-	struct platform_device		*pdev;
-	struct omap_sr_nvalue_table	*nvalue_table;
-	struct voltagedomain		*voltdm;
-	struct dentry			*dbg_dir;
-	unsigned int			irq;
-	int				srid;
-	int				ip_type;
-	int				nvalue_count;
-	bool				autocomp_active;
-	u32				clk_length;
-	u32				err_weight;
-	u32				err_minlimit;
-	u32				err_maxlimit;
-	u32				accum_data;
-	u32				senn_avgweight;
-	u32				senp_avgweight;
-	u32				senp_mod;
-	u32				senn_mod;
-	void __iomem			*base;
-};
-
 /* sr_list contains all the instances of smartreflex module */
 static LIST_HEAD(sr_list);
 
@@ -147,7 +124,7 @@ static irqreturn_t sr_interrupt(int irq, void *data)
 	}
 
 	if (sr_class->notify)
-		sr_class->notify(sr_info->voltdm, status);
+		sr_class->notify(sr_info, status);
 
 	return IRQ_HANDLED;
 }
@@ -225,7 +202,7 @@ static void sr_start_vddautocomp(struct omap_sr *sr)
 		return;
 	}
 
-	if (!sr_class->enable(sr->voltdm))
+	if (!sr_class->enable(sr))
 		sr->autocomp_active = true;
 }
 
@@ -239,7 +216,7 @@ static void sr_stop_vddautocomp(struct omap_sr *sr)
 	}
 
 	if (sr->autocomp_active) {
-		sr_class->disable(sr->voltdm, 1);
+		sr_class->disable(sr, 1);
 		sr->autocomp_active = false;
 	}
 }
@@ -654,7 +631,7 @@ int sr_enable(struct voltagedomain *voltdm, unsigned long volt)
 		return 0;
 
 	/* Configure SR */
-	ret = sr_class->configure(voltdm);
+	ret = sr_class->configure(sr);
 	if (ret)
 		return ret;
 
@@ -772,7 +749,7 @@ void omap_sr_enable(struct voltagedomain *voltdm)
 		return;
 	}
 
-	sr_class->enable(voltdm);
+	sr_class->enable(sr);
 }
 
 /**
@@ -805,7 +782,7 @@ void omap_sr_disable(struct voltagedomain *voltdm)
 		return;
 	}
 
-	sr_class->disable(voltdm, 0);
+	sr_class->disable(sr, 0);
 }
 
 /**
@@ -838,7 +815,7 @@ void omap_sr_disable_reset_volt(struct voltagedomain *voltdm)
 		return;
 	}
 
-	sr_class->disable(voltdm, 1);
+	sr_class->disable(sr, 1);
 }
 
 /**
diff --git a/include/linux/power/smartreflex.h b/include/linux/power/smartreflex.h
index 69eb270..4224698 100644
--- a/include/linux/power/smartreflex.h
+++ b/include/linux/power/smartreflex.h
@@ -143,6 +143,29 @@
 #define OMAP3430_SR_ERRWEIGHT		0x04
 #define OMAP3430_SR_ERRMAXLIMIT		0x02
 
+struct omap_sr {
+	struct list_head		node;
+	struct platform_device		*pdev;
+	struct omap_sr_nvalue_table	*nvalue_table;
+	struct voltagedomain		*voltdm;
+	struct dentry			*dbg_dir;
+	unsigned int			irq;
+	int				srid;
+	int				ip_type;
+	int				nvalue_count;
+	bool				autocomp_active;
+	u32				clk_length;
+	u32				err_weight;
+	u32				err_minlimit;
+	u32				err_maxlimit;
+	u32				accum_data;
+	u32				senn_avgweight;
+	u32				senp_avgweight;
+	u32				senp_mod;
+	u32				senn_mod;
+	void __iomem			*base;
+};
+
 /**
  * struct omap_sr_pmic_data - Strucutre to be populated by pmic code to pass
  *				pmic specific info to smartreflex driver
@@ -187,10 +210,10 @@ struct omap_smartreflex_dev_attr {
  *			based decisions.
  */
 struct omap_sr_class_data {
-	int (*enable)(struct voltagedomain *voltdm);
-	int (*disable)(struct voltagedomain *voltdm, int is_volt_reset);
-	int (*configure)(struct voltagedomain *voltdm);
-	int (*notify)(struct voltagedomain *voltdm, u32 status);
+	int (*enable)(struct omap_sr *sr);
+	int (*disable)(struct omap_sr *sr, int is_volt_reset);
+	int (*configure)(struct omap_sr *sr);
+	int (*notify)(struct omap_sr *sr, u32 status);
 	u8 notify_flags;
 	u8 class_type;
 };
-- 
1.7.5.4

