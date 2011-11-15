Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369Ab1KOIrS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 03:47:18 -0500
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:48443 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754117Ab1KOIqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 03:46:22 -0500
From: Felipe Balbi <balbi@ti.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH/RESEND #3 5/7] arm: omap: smartreflex: clean ups all over
Date: Tue, 15 Nov 2011 10:46:03 +0200
Message-Id: <1321346765-16633-6-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.8.rc0
In-Reply-To: <1321346765-16633-1-git-send-email-balbi@ti.com>
References: <1321346765-16633-1-git-send-email-balbi@ti.com>
Organization: Texas Instruments\n
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are no functional changes here, only
misc cleanups in general: tabifying variable
declarations, converting if {} else if {} else {}
into switch statements, etc.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 arch/arm/mach-omap2/smartreflex.c |  218 +++++++++++++++++++++++--------------
 1 files changed, 134 insertions(+), 84 deletions(-)

diff --git a/arch/arm/mach-omap2/smartreflex.c b/arch/arm/mach-omap2/smartreflex.c
index 97375d2..eb88b36 100644
--- a/arch/arm/mach-omap2/smartreflex.c
+++ b/arch/arm/mach-omap2/smartreflex.c
@@ -37,26 +37,32 @@
 #define SR_DISABLE_TIMEOUT	200
 
 struct omap_sr {
-	int				srid;
-	int				ip_type;
+	struct list_head		node;
+	struct platform_device		*pdev;
+	struct omap_sr_nvalue_table	*nvalue_table;
+	struct voltagedomain		*voltdm;
+
+	unsigned int			irq;
+
 	int				nvalue_count;
-	bool				autocomp_active;
-	bool				is_suspended;
-	u32				clk_length;
-	u32				err_weight;
+	int				ip_type;
+	int				srid;
+
+	u32				senn_avgweight;
+	u32				senp_avgweight;
 	u32				err_minlimit;
 	u32				err_maxlimit;
+	u32				clk_length;
+	u32				err_weight;
 	u32				accum_data;
-	u32				senn_avgweight;
-	u32				senp_avgweight;
 	u32				senp_mod;
 	u32				senn_mod;
-	unsigned int			irq;
+
+	bool				autocomp_active;
+	bool				is_suspended;
+
 	void __iomem			*base;
-	struct platform_device		*pdev;
-	struct list_head		node;
-	struct omap_sr_nvalue_table	*nvalue_table;
-	struct voltagedomain		*voltdm;
+
 	struct dentry			*dbg_dir;
 };
 
@@ -75,11 +81,9 @@ static inline void sr_write_reg(struct omap_sr *sr, unsigned offset, u32 value)
 static inline void sr_modify_reg(struct omap_sr *sr, unsigned offset, u32 mask,
 					u32 value)
 {
-	u32 reg_val;
-	u32 errconfig_offs = 0, errconfig_mask = 0;
-
-	reg_val = __raw_readl(sr->base + offset);
-	reg_val &= ~mask;
+	u32		reg_val;
+	u32		errconfig_offs = 0;
+	u32		errconfig_mask = 0;
 
 	/*
 	 * Smartreflex error config register is special as it contains
@@ -90,14 +94,23 @@ static inline void sr_modify_reg(struct omap_sr *sr, unsigned offset, u32 mask,
 	 * if they are currently set, but does allow the caller to write
 	 * those bits.
 	 */
-	if (sr->ip_type == SR_TYPE_V1) {
+	switch (sr->ip_type) {
+	case SR_TYPE_V1:
 		errconfig_offs = ERRCONFIG_V1;
 		errconfig_mask = ERRCONFIG_STATUS_V1_MASK;
-	} else if (sr->ip_type == SR_TYPE_V2) {
+		break;
+	case SR_TYPE_V2:
 		errconfig_offs = ERRCONFIG_V2;
 		errconfig_mask = ERRCONFIG_VPBOUNDINTST_V2;
+		break;
+	default: /* should never happen */
+		dev_err(&sr->pdev->dev, "UNKNOWN IP type %d\n", sr->ip_type);
+		return;
 	}
 
+	reg_val = __raw_readl(sr->base + offset);
+	reg_val &= ~mask;
+
 	if (offset == errconfig_offs)
 		reg_val &= ~errconfig_mask;
 
@@ -113,7 +126,7 @@ static inline u32 sr_read_reg(struct omap_sr *sr, unsigned offset)
 
 static struct omap_sr *_sr_lookup(struct voltagedomain *voltdm)
 {
-	struct omap_sr *sr_info;
+	struct omap_sr	*sr_info;
 
 	if (!voltdm) {
 		pr_err("%s: Null voltage domain passed!\n", __func__);
@@ -130,33 +143,39 @@ static struct omap_sr *_sr_lookup(struct voltagedomain *voltdm)
 
 static irqreturn_t sr_interrupt(int irq, void *data)
 {
-	struct omap_sr *sr_info = (struct omap_sr *)data;
-	u32 status = 0;
+	struct omap_sr	*sr_info = data;
+	u32		status = 0;
 
-	if (sr_info->ip_type == SR_TYPE_V1) {
+	switch (sr_info->ip_type) {
+	case SR_TYPE_V1:
 		/* Read the status bits */
 		status = sr_read_reg(sr_info, ERRCONFIG_V1);
 
 		/* Clear them by writing back */
 		sr_write_reg(sr_info, ERRCONFIG_V1, status);
-	} else if (sr_info->ip_type == SR_TYPE_V2) {
+		break;
+	case SR_TYPE_V2:
 		/* Read the status bits */
 		sr_read_reg(sr_info, IRQSTATUS);
 
 		/* Clear them by writing back */
 		sr_write_reg(sr_info, IRQSTATUS, status);
-	}
 
-	if (sr_class->notify)
-		sr_class->notify(sr_info->voltdm, status);
+		if (sr_class->notify)
+			sr_class->notify(sr_info->voltdm, status);
+		break;
+	default: /* should never happen */
+		dev_err(&sr_info->pdev->dev, "UNKNOWN IP type %d\n", sr_info->ip_type);
+		return IRQ_NONE;
+	}
 
 	return IRQ_HANDLED;
 }
 
 static void sr_set_clk_length(struct omap_sr *sr)
 {
-	struct clk *sys_ck;
-	u32 sys_clk_speed;
+	struct clk	*sys_ck;
+	u32		sys_clk_speed;
 
 	if (cpu_is_omap34xx())
 		sys_ck = clk_get(NULL, "sys_ck");
@@ -168,6 +187,7 @@ static void sr_set_clk_length(struct omap_sr *sr)
 			__func__);
 		return;
 	}
+
 	sys_clk_speed = clk_get_rate(sys_ck);
 	clk_put(sys_ck);
 
@@ -257,10 +277,10 @@ static void sr_stop_vddautocomp(struct omap_sr *sr)
  */
 static int sr_late_init(struct omap_sr *sr_info)
 {
-	char *name;
-	struct omap_sr_data *pdata = sr_info->pdev->dev.platform_data;
-	struct resource *mem;
-	int ret = 0;
+	struct omap_sr_data	*pdata = sr_info->pdev->dev.platform_data;
+	struct			resource *mem;
+	int			ret = 0;
+	char			*name;
 
 	if (sr_class->notify && sr_class->notify_flags && sr_info->irq) {
 		name = kasprintf(GFP_KERNEL, "sr_%s", sr_info->voltdm->name);
@@ -269,7 +289,7 @@ static int sr_late_init(struct omap_sr *sr_info)
 			goto error;
 		}
 		ret = request_irq(sr_info->irq, sr_interrupt,
-				0, name, (void *)sr_info);
+				0, name, sr_info);
 		if (ret)
 			goto error;
 		disable_irq(sr_info->irq);
@@ -290,12 +310,13 @@ error:
 		"not function as desired\n", __func__);
 	kfree(name);
 	kfree(sr_info);
+
 	return ret;
 }
 
 static void sr_v1_disable(struct omap_sr *sr)
 {
-	int timeout = 0;
+	int		timeout = 0;
 
 	/* Enable MCUDisableAcknowledge interrupt */
 	sr_modify_reg(sr, ERRCONFIG_V1,
@@ -331,7 +352,7 @@ static void sr_v1_disable(struct omap_sr *sr)
 
 static void sr_v2_disable(struct omap_sr *sr)
 {
-	int timeout = 0;
+	int		timeout = 0;
 
 	/* Enable MCUDisableAcknowledge interrupt */
 	sr_write_reg(sr, IRQENABLE_SET, IRQENABLE_MCUDISABLEACKINT);
@@ -368,7 +389,7 @@ static void sr_v2_disable(struct omap_sr *sr)
 
 static u32 sr_retrieve_nvalue(struct omap_sr *sr, u32 efuse_offs)
 {
-	int i;
+	int		i;
 
 	if (!sr->nvalue_table) {
 		dev_warn(&sr->pdev->dev, "%s: Missing ntarget value table\n",
@@ -400,10 +421,16 @@ static u32 sr_retrieve_nvalue(struct omap_sr *sr, u32 efuse_offs)
  */
 int sr_configure_errgen(struct voltagedomain *voltdm)
 {
-	u32 sr_config, sr_errconfig, errconfig_offs, vpboundint_en;
-	u32 vpboundint_st, senp_en = 0, senn_en = 0;
-	u8 senp_shift, senn_shift;
-	struct omap_sr *sr = _sr_lookup(voltdm);
+	struct omap_sr		*sr = _sr_lookup(voltdm);
+	u32			sr_config;
+	u32			sr_errconfig;
+	u32			errconfig_offs;
+	u32			vpboundint_en;
+	u32			vpboundint_st;
+	u32			senp_en = 0;
+	u32			senn_en = 0;
+	u8			senp_shift;
+	u8			senn_shift;
 
 	if (IS_ERR(sr)) {
 		pr_warning("%s: omap_sr struct for sr_%s not found\n",
@@ -420,22 +447,24 @@ int sr_configure_errgen(struct voltagedomain *voltdm)
 	sr_config = (sr->clk_length << SRCONFIG_SRCLKLENGTH_SHIFT) |
 		SRCONFIG_SENENABLE | SRCONFIG_ERRGEN_EN;
 
-	if (sr->ip_type == SR_TYPE_V1) {
+	switch (sr->ip_type) {
+	case SR_TYPE_V1:
 		sr_config |= SRCONFIG_DELAYCTRL;
 		senn_shift = SRCONFIG_SENNENABLE_V1_SHIFT;
 		senp_shift = SRCONFIG_SENPENABLE_V1_SHIFT;
 		errconfig_offs = ERRCONFIG_V1;
 		vpboundint_en = ERRCONFIG_VPBOUNDINTEN_V1;
 		vpboundint_st = ERRCONFIG_VPBOUNDINTST_V1;
-	} else if (sr->ip_type == SR_TYPE_V2) {
+		break;
+	case SR_TYPE_V2:
 		senn_shift = SRCONFIG_SENNENABLE_V2_SHIFT;
 		senp_shift = SRCONFIG_SENPENABLE_V2_SHIFT;
 		errconfig_offs = ERRCONFIG_V2;
 		vpboundint_en = ERRCONFIG_VPBOUNDINTEN_V2;
 		vpboundint_st = ERRCONFIG_VPBOUNDINTST_V2;
-	} else {
-		dev_err(&sr->pdev->dev, "%s: Trying to Configure smartreflex"
-			"module without specifying the ip\n", __func__);
+		break;
+	default:
+		dev_err(&sr->pdev->dev, "UNKNOWN IP type %d\n", sr->ip_type);
 		return -EINVAL;
 	}
 
@@ -469,10 +498,13 @@ int sr_configure_errgen(struct voltagedomain *voltdm)
  */
 int sr_configure_minmax(struct voltagedomain *voltdm)
 {
-	u32 sr_config, sr_avgwt;
-	u32 senp_en = 0, senn_en = 0;
-	u8 senp_shift, senn_shift;
-	struct omap_sr *sr = _sr_lookup(voltdm);
+	struct omap_sr		*sr = _sr_lookup(voltdm);
+	u32			sr_config;
+	u32			sr_avgwt;
+	u32			senp_en = 0;
+	u32			senn_en = 0;
+	u8			senp_shift;
+	u8			senn_shift;
 
 	if (IS_ERR(sr)) {
 		pr_warning("%s: omap_sr struct for sr_%s not found\n",
@@ -490,16 +522,18 @@ int sr_configure_minmax(struct voltagedomain *voltdm)
 		SRCONFIG_SENENABLE |
 		(sr->accum_data << SRCONFIG_ACCUMDATA_SHIFT);
 
-	if (sr->ip_type == SR_TYPE_V1) {
+	switch (sr->ip_type) {
+	case SR_TYPE_V1:
 		sr_config |= SRCONFIG_DELAYCTRL;
 		senn_shift = SRCONFIG_SENNENABLE_V1_SHIFT;
 		senp_shift = SRCONFIG_SENPENABLE_V1_SHIFT;
-	} else if (sr->ip_type == SR_TYPE_V2) {
+		break;
+	case SR_TYPE_V2:
 		senn_shift = SRCONFIG_SENNENABLE_V2_SHIFT;
 		senp_shift = SRCONFIG_SENPENABLE_V2_SHIFT;
-	} else {
-		dev_err(&sr->pdev->dev, "%s: Trying to Configure smartreflex"
-			"module without specifying the ip\n", __func__);
+		break;
+	default:
+		dev_err(&sr->pdev->dev, "UNKNOWN IP type %d\n", sr->ip_type);
 		return -EINVAL;
 	}
 
@@ -513,20 +547,26 @@ int sr_configure_minmax(struct voltagedomain *voltdm)
 	 * Enabling the interrupts if MINMAXAVG module is used.
 	 * TODO: check if all the interrupts are mandatory
 	 */
-	if (sr->ip_type == SR_TYPE_V1) {
+	switch (sr->ip_type) {
+	case SR_TYPE_V1:
 		sr_modify_reg(sr, ERRCONFIG_V1,
 			(ERRCONFIG_MCUACCUMINTEN | ERRCONFIG_MCUVALIDINTEN |
 			ERRCONFIG_MCUBOUNDINTEN),
 			(ERRCONFIG_MCUACCUMINTEN | ERRCONFIG_MCUACCUMINTST |
 			 ERRCONFIG_MCUVALIDINTEN | ERRCONFIG_MCUVALIDINTST |
 			 ERRCONFIG_MCUBOUNDINTEN | ERRCONFIG_MCUBOUNDINTST));
-	} else if (sr->ip_type == SR_TYPE_V2) {
+		break;
+	case SR_TYPE_V2:
 		sr_write_reg(sr, IRQSTATUS,
 			IRQSTATUS_MCUACCUMINT | IRQSTATUS_MCVALIDINT |
 			IRQSTATUS_MCBOUNDSINT | IRQSTATUS_MCUDISABLEACKINT);
 		sr_write_reg(sr, IRQENABLE_SET,
 			IRQENABLE_MCUACCUMINT | IRQENABLE_MCUVALIDINT |
 			IRQENABLE_MCUBOUNDSINT | IRQENABLE_MCUDISABLEACKINT);
+		break;
+	default:
+		dev_err(&sr->pdev->dev, "UNKNOWN IP type %d\n", sr->ip_type);
+		return -EINVAL;
 	}
 
 	return 0;
@@ -545,10 +585,10 @@ int sr_configure_minmax(struct voltagedomain *voltdm)
  */
 int sr_enable(struct voltagedomain *voltdm, unsigned long volt)
 {
-	u32 nvalue_reciprocal;
-	struct omap_volt_data *volt_data;
-	struct omap_sr *sr = _sr_lookup(voltdm);
-	int ret;
+	struct omap_sr		*sr = _sr_lookup(voltdm);
+	struct omap_volt_data	*volt_data;
+	u32			nvalue_reciprocal;
+	int			ret;
 
 	if (IS_ERR(sr)) {
 		pr_warning("%s: omap_sr struct for sr_%s not found\n",
@@ -602,7 +642,7 @@ int sr_enable(struct voltagedomain *voltdm, unsigned long volt)
  */
 void sr_disable(struct voltagedomain *voltdm)
 {
-	struct omap_sr *sr = _sr_lookup(voltdm);
+	struct omap_sr		*sr = _sr_lookup(voltdm);
 
 	if (IS_ERR(sr)) {
 		pr_warning("%s: omap_sr struct for sr_%s not found\n",
@@ -619,10 +659,17 @@ void sr_disable(struct voltagedomain *voltdm)
 	 * disable the clocks.
 	 */
 	if (sr_read_reg(sr, SRCONFIG) & SRCONFIG_SRENABLE) {
-		if (sr->ip_type == SR_TYPE_V1)
+		switch (sr->ip_type) {
+		case SR_TYPE_V1:
 			sr_v1_disable(sr);
-		else if (sr->ip_type == SR_TYPE_V2)
+			break;
+		case SR_TYPE_V2:
 			sr_v2_disable(sr);
+			break;
+		default:
+			dev_err(&sr->pdev->dev, "UNKNOWN IP type %d\n",
+					sr->ip_type);
+		}
 	}
 
 	pm_runtime_put_sync_suspend(&sr->pdev->dev);
@@ -638,7 +685,7 @@ void sr_disable(struct voltagedomain *voltdm)
  */
 int sr_register_class(struct omap_sr_class_data *class_data)
 {
-	struct omap_sr *sr_info;
+	struct omap_sr		*sr_info;
 
 	if (!class_data) {
 		pr_warning("%s:, Smartreflex class data passed is NULL\n",
@@ -676,7 +723,7 @@ int sr_register_class(struct omap_sr_class_data *class_data)
  */
 void omap_sr_enable(struct voltagedomain *voltdm)
 {
-	struct omap_sr *sr = _sr_lookup(voltdm);
+	struct omap_sr		*sr = _sr_lookup(voltdm);
 
 	if (IS_ERR(sr)) {
 		pr_warning("%s: omap_sr struct for sr_%s not found\n",
@@ -714,7 +761,7 @@ void omap_sr_enable(struct voltagedomain *voltdm)
  */
 void omap_sr_disable(struct voltagedomain *voltdm)
 {
-	struct omap_sr *sr = _sr_lookup(voltdm);
+	struct omap_sr		*sr = _sr_lookup(voltdm);
 
 	if (IS_ERR(sr)) {
 		pr_warning("%s: omap_sr struct for sr_%s not found\n",
@@ -752,7 +799,7 @@ void omap_sr_disable(struct voltagedomain *voltdm)
  */
 void omap_sr_disable_reset_volt(struct voltagedomain *voltdm)
 {
-	struct omap_sr *sr = _sr_lookup(voltdm);
+	struct omap_sr		*sr = _sr_lookup(voltdm);
 
 	if (IS_ERR(sr)) {
 		pr_warning("%s: omap_sr struct for sr_%s not found\n",
@@ -796,10 +843,10 @@ void omap_sr_register_pmic(struct omap_sr_pmic_data *pmic_data)
 	sr_pmic_data = pmic_data;
 }
 
-/* PM Debug Fs enteries to enable disable smartreflex. */
+/* PM Debug Fs entries to enable disable smartreflex. */
 static int omap_sr_autocomp_show(void *data, u64 *val)
 {
-	struct omap_sr *sr_info = (struct omap_sr *) data;
+	struct omap_sr		*sr_info = data;
 
 	if (!sr_info) {
 		pr_warning("%s: omap_sr struct not found\n", __func__);
@@ -813,7 +860,7 @@ static int omap_sr_autocomp_show(void *data, u64 *val)
 
 static int omap_sr_autocomp_store(void *data, u64 val)
 {
-	struct omap_sr *sr_info = (struct omap_sr *) data;
+	struct omap_sr		*sr_info = data;
 
 	if (!sr_info) {
 		pr_warning("%s: omap_sr struct not found\n", __func__);
@@ -844,14 +891,17 @@ DEFINE_SIMPLE_ATTRIBUTE(pm_sr_fops, omap_sr_autocomp_show,
 
 static int __init omap_sr_probe(struct platform_device *pdev)
 {
-	struct omap_sr *sr_info = kzalloc(sizeof(struct omap_sr), GFP_KERNEL);
-	struct omap_sr_data *pdata = pdev->dev.platform_data;
-	struct resource *mem, *irq;
-	struct dentry *nvalue_dir;
-	struct omap_volt_data *volt_data;
-	int i, ret = 0;
-	char *name;
-
+	struct omap_sr		*sr_info;
+	struct omap_sr_data	*pdata = pdev->dev.platform_data;
+	struct resource		*mem;
+	struct resource		*irq;
+	struct dentry		*nvalue_dir;
+	struct omap_volt_data	*volt_data;
+	int			ret = 0;
+	int			i;
+	char			*name;
+
+	sr_info = kzalloc(sizeof(*sr_info), GFP_KERNEL);
 	if (!sr_info) {
 		dev_err(&pdev->dev, "%s: unable to allocate sr_info\n",
 			__func__);
@@ -1002,8 +1052,8 @@ err_free_devinfo:
 
 static int __devexit omap_sr_remove(struct platform_device *pdev)
 {
-	struct omap_sr *sr_info = platform_get_drvdata(pdev);
-	struct resource *mem;
+	struct omap_sr		*sr_info = platform_get_drvdata(pdev);
+	struct resource		*mem;
 
 	if (sr_info->autocomp_active)
 		sr_stop_vddautocomp(sr_info);
@@ -1021,7 +1071,7 @@ static int __devexit omap_sr_remove(struct platform_device *pdev)
 
 static int omap_sr_suspend(struct device *dev)
 {
-	struct omap_sr *sr_info = dev_get_drvdata(dev);
+	struct omap_sr		*sr_info = dev_get_drvdata(dev);
 
 	if (!sr_info)
 		return 0;
@@ -1042,7 +1092,7 @@ static int omap_sr_suspend(struct device *dev)
 
 static int omap_sr_resume(struct device *dev)
 {
-	struct omap_sr *sr_info = dev_get_drvdata(dev);
+	struct omap_sr		*sr_info = dev_get_drvdata(dev);
 
 	if (!sr_info)
 		return 0;
-- 
1.7.8.rc0

