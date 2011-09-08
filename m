Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932824Ab1IHMr1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 08:47:27 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:55996 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932734Ab1IHMrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 08:47:23 -0400
From: Abhilash K V <abhilash.kv@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC: <tony@atomide.com>, <linux@arm.linux.org.uk>, <khilman@ti.com>,
        <sameo@linux.intel.com>, <santosh.shilimkar@ti.com>, <premi@ti.com>,
        <david.woodhouse@intel.com>, Abhilash K V <abhilash.kv@ti.com>
Subject: [PATCH v2 1/3] AM35x: voltage: Basic initialization
Date: Thu, 8 Sep 2011 18:17:11 +0530
Message-ID: <1315486031-513-1-git-send-email-abhilash.kv@ti.com>
X-Mailer: git-send-email 1.6.2.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sanjeev Premi <premi@ti.com>

This patch adds the basic initialization of voltage layer
for AM35x. Since AM35x doesn't support voltage scaling,
Many functions have been defined to plug into existing
voltage layer.

Signed-off-by: Sanjeev Premi <premi@ti.com>
Signed-off-by: Abhilash K V <abhilash.kv@ti.com>
---
 arch/arm/mach-omap2/omap_opp_data.h           |    1 +
 arch/arm/mach-omap2/opp3xxx_data.c            |   10 ++++++
 arch/arm/mach-omap2/pm.c                      |    3 +-
 arch/arm/mach-omap2/voltage.c                 |   18 +++++++++++
 arch/arm/mach-omap2/voltagedomains3xxx_data.c |   41 ++++++++++++++++++++++++-
 5 files changed, 71 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-omap2/omap_opp_data.h b/arch/arm/mach-omap2/omap_opp_data.h
index c784c12..c7cedf3 100644
--- a/arch/arm/mach-omap2/omap_opp_data.h
+++ b/arch/arm/mach-omap2/omap_opp_data.h
@@ -88,6 +88,7 @@ extern struct omap_volt_data omap34xx_vddmpu_volt_data[];
 extern struct omap_volt_data omap34xx_vddcore_volt_data[];
 extern struct omap_volt_data omap36xx_vddmpu_volt_data[];
 extern struct omap_volt_data omap36xx_vddcore_volt_data[];
+extern struct omap_volt_data am35xx_vdd_volt_data[];
 
 extern struct omap_volt_data omap44xx_vdd_mpu_volt_data[];
 extern struct omap_volt_data omap44xx_vdd_iva_volt_data[];
diff --git a/arch/arm/mach-omap2/opp3xxx_data.c b/arch/arm/mach-omap2/opp3xxx_data.c
index d95f3f9..2337d0f 100644
--- a/arch/arm/mach-omap2/opp3xxx_data.c
+++ b/arch/arm/mach-omap2/opp3xxx_data.c
@@ -150,6 +150,16 @@ static struct omap_opp_def __initdata omap36xx_opp_def_list[] = {
 	OPP_INITIALIZER("iva", false, 800000000, OMAP3630_VDD_MPU_OPP1G_UV),
 };
 
+/* AM35x
+ *
+ * Fields related to SmartReflex and Voltage Processor are set to 0.
+ */
+struct omap_volt_data am35xx_vdd_volt_data[] = {
+	VOLT_DATA_DEFINE(OMAP3430_VDD_MPU_OPP3_UV, 0x0, 0x0, 0x0),
+	VOLT_DATA_DEFINE(0, 0, 0, 0),
+};
+
+
 /**
  * omap3_opp_init() - initialize omap3 opp table
  */
diff --git a/arch/arm/mach-omap2/pm.c b/arch/arm/mach-omap2/pm.c
index 8929798..863b384 100644
--- a/arch/arm/mach-omap2/pm.c
+++ b/arch/arm/mach-omap2/pm.c
@@ -227,7 +227,8 @@ static void __init omap3_init_voltages(void)
 {
 	if (!cpu_is_omap34xx())
 		return;
-
+	if (cpu_is_omap3505() || cpu_is_omap3517())
+		return;
 	omap2_set_init_voltage("mpu", "dpll1_ck", mpu_dev);
 	omap2_set_init_voltage("core", "l3_ick", l3_dev);
 }
diff --git a/arch/arm/mach-omap2/voltage.c b/arch/arm/mach-omap2/voltage.c
index 9ef3789..3fa0652 100644
--- a/arch/arm/mach-omap2/voltage.c
+++ b/arch/arm/mach-omap2/voltage.c
@@ -60,6 +60,12 @@ static struct dentry *voltage_dir;
 static int vp_forceupdate_scale_voltage(struct omap_vdd_info *vdd,
 					unsigned long target_volt);
 
+static int volt_scale_nop(struct omap_vdd_info *vdd,
+				unsigned long target_volt)
+{
+	return 0;
+}
+
 static u32 omap3_voltage_read_reg(u16 mod, u8 offset)
 {
 	return omap2_prm_read_mod_reg(mod, offset);
@@ -114,6 +120,12 @@ static int __init _config_common_vdd_data(struct omap_vdd_info *vdd)
 	sys_clk_speed /= 1000;
 
 	/* Generic voltage parameters */
+	if (cpu_is_omap3505() || cpu_is_omap3517()) {
+		vdd->volt_scale = volt_scale_nop;
+		vdd->vp_enabled = false;
+		return 0;
+	}
+
 	vdd->volt_scale = vp_forceupdate_scale_voltage;
 	vdd->vp_enabled = false;
 
@@ -217,6 +229,9 @@ static void __init vp_init(struct omap_vdd_info *vdd)
 {
 	u32 vp_val;
 
+	if (cpu_is_omap3505() || cpu_is_omap3517())
+		return ;
+
 	if (!vdd->read_reg || !vdd->write_reg) {
 		pr_err("%s: No read/write API for accessing vdd_%s regs\n",
 			__func__, vdd->voltdm.name);
@@ -598,6 +613,9 @@ static void __init omap_vc_init(struct omap_vdd_info *vdd)
 {
 	u32 vc_val;
 
+	if (cpu_is_omap3505() || cpu_is_omap3517())
+		return ;
+
 	if (!vdd->pmic_info || !vdd->pmic_info->uv_to_vsel) {
 		pr_err("%s: PMIC info requried to configure vc for"
 			"vdd_%s not populated.Hence cannot initialize vc\n",
diff --git a/arch/arm/mach-omap2/voltagedomains3xxx_data.c b/arch/arm/mach-omap2/voltagedomains3xxx_data.c
index def230f..7432a1b 100644
--- a/arch/arm/mach-omap2/voltagedomains3xxx_data.c
+++ b/arch/arm/mach-omap2/voltagedomains3xxx_data.c
@@ -67,6 +67,39 @@ static struct omap_vdd_info *omap3_vdd_info[] = {
 	&omap3_vdd2_info,
 };
 
+/*
+ * AM35x VDD structures
+ *
+ * In AM35x there neither scalable voltage domain nor any hook-up with
+ * voltage controller/processor. However, when trying to re-use the hwmod
+ * database for OMAP3, definition of "core" voltage domain is necessary.
+ * Else, changes in hwmod data structures grow spirally.
+ *
+ * As a workaround, "core" voltage domain is defined below. This is an ad hoc
+ * arrangement till code for SoCs without scalable voltage domains gets
+ * an overhaul.
+ */
+static struct omap_vdd_info am3517_vdd1_info = {
+	.vp_enabled     = false,
+
+	.voltdm = {
+		.name = "mpu",
+	},
+};
+
+static struct omap_vdd_info am3517_vdd2_info = {
+	.vp_enabled     = false,
+
+	.voltdm = {
+		.name = "core",
+	},
+};
+
+static struct omap_vdd_info *am3517_vdd_info[] = {
+	&am3517_vdd1_info,
+	&am3517_vdd2_info,
+};
+
 /* OMAP3 specific voltage init functions */
 static int __init omap3xxx_voltage_early_init(void)
 {
@@ -80,7 +113,13 @@ static int __init omap3xxx_voltage_early_init(void)
 	 * XXX Will depend on the process, validation, and binning
 	 * for the currently-running IC
 	 */
-	if (cpu_is_omap3630()) {
+	if (cpu_is_omap3505() || cpu_is_omap3517()) {
+		am3517_vdd1_info.volt_data = am35xx_vdd_volt_data;
+		am3517_vdd2_info.volt_data = am35xx_vdd_volt_data;
+		return omap_voltage_early_init(prm_mod, prm_irqst_ocp_mod,
+				       am3517_vdd_info,
+				       ARRAY_SIZE(am3517_vdd_info));
+	} else if (cpu_is_omap3630()) {
 		omap3_vdd1_info.volt_data = omap36xx_vddmpu_volt_data;
 		omap3_vdd2_info.volt_data = omap36xx_vddcore_volt_data;
 	} else {
-- 
1.7.1

