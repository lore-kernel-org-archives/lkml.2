Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201Ab2H1Lvg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 07:51:36 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:36803 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752503Ab2H1LsL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 07:48:11 -0400
From: Graeme Gregory <gg@slimlogic.co.uk>
To: linux-kernel@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, lrg@ti.com, sameo@linux.intel.com,
        peter.ujfalusi@ti.com, s-guiriec@ti.com,
        Graeme Gregory <gg@slimlogic.co.uk>
Subject: [PATCH 3/6] mfd: palmas add pdata/data for rest of children
Date: Tue, 28 Aug 2012 13:47:37 +0200
Message-Id: <1346154460-20031-4-git-send-email-gg@slimlogic.co.uk>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1346154460-20031-1-git-send-email-gg@slimlogic.co.uk>
References: <1346154460-20031-1-git-send-email-gg@slimlogic.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the platform data and data structures for children that shall be
added by a future set of commits.

Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
---
 drivers/mfd/palmas.c       |   13 ++++
 include/linux/mfd/palmas.h |  172 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 185 insertions(+)

diff --git a/drivers/mfd/palmas.c b/drivers/mfd/palmas.c
index 3d33623..c4b99f4 100644
--- a/drivers/mfd/palmas.c
+++ b/drivers/mfd/palmas.c
@@ -389,6 +389,19 @@ static int __devinit palmas_i2c_probe(struct i2c_client *i2c,
 	children[PALMAS_PMIC_ID].platform_data = pdata->pmic_pdata;
 	children[PALMAS_PMIC_ID].pdata_size = sizeof(*pdata->pmic_pdata);
 
+	children[PALMAS_GPADC_ID].platform_data = pdata->gpadc_pdata;
+	children[PALMAS_GPADC_ID].pdata_size = sizeof(*pdata->gpadc_pdata);
+
+	children[PALMAS_RESOURCE_ID].platform_data = pdata->resource_pdata;
+	children[PALMAS_RESOURCE_ID].pdata_size =
+			sizeof(*pdata->resource_pdata);
+
+	children[PALMAS_USB_ID].platform_data = pdata->usb_pdata;
+	children[PALMAS_USB_ID].pdata_size = sizeof(*pdata->usb_pdata);
+
+	children[PALMAS_CLK_ID].platform_data = pdata->clk_pdata;
+	children[PALMAS_CLK_ID].pdata_size = sizeof(*pdata->clk_pdata);
+
 	ret = mfd_add_devices(palmas->dev, -1,
 			      children, ARRAY_SIZE(palmas_children),
 			      NULL, regmap_irq_chip_get_base(palmas->irq_data));
diff --git a/include/linux/mfd/palmas.h b/include/linux/mfd/palmas.h
index 9cbc642..cfbf794 100644
--- a/include/linux/mfd/palmas.h
+++ b/include/linux/mfd/palmas.h
@@ -23,6 +23,9 @@
 #define PALMAS_NUM_CLIENTS		3
 
 struct palmas_pmic;
+struct palmas_gpadc;
+struct palmas_resource;
+struct palmas_usb;
 
 struct palmas {
 	struct device *dev;
@@ -41,6 +44,9 @@ struct palmas {
 
 	/* Child Devices */
 	struct palmas_pmic *pmic;
+	struct palmas_gpadc *gpadc;
+	struct palmas_resource *resource;
+	struct palmas_usb *usb;
 
 	/* GPIO MUXing */
 	u8 gpio_muxed;
@@ -48,6 +54,23 @@ struct palmas {
 	u8 pwm_muxed;
 };
 
+struct palmas_gpadc_platform_data {
+	/* Channel 3 current source is only enabled during conversion */
+	int ch3_current;
+
+	/* Channel 0 current source can be used for battery detection.
+	 * If used for battery detection this will cause a permanent current
+	 * consumption depending on current level set here.
+	 */
+	int ch0_current;
+
+	/* default BAT_REMOVAL_DAT setting on device probe */
+	int bat_removal;
+
+	/* Sets the START_POLARITY bit in the RT_CTRL register */
+	int start_polarity;
+};
+
 struct palmas_reg_init {
 	/* warm_rest controls the voltage levels after a warm reset
 	 *
@@ -120,8 +143,53 @@ struct palmas_pmic_platform_data {
 
 	/* use LDO6 for vibrator control */
 	int ldo6_vibrator;
+};
+
+struct palmas_usb_platform_data {
+	/* Set this if platform wishes its own vbus control */
+	int no_control_vbus;
 
+	/* Do we enable the wakeup comparator on probe */
+	int wakeup;
+};
+
+struct palmas_resource_platform_data {
+	int regen1_mode_sleep;
+	int regen2_mode_sleep;
+	int sysen1_mode_sleep;
+	int sysen2_mode_sleep;
+
+	/* bitfield to be loaded to NSLEEP_RES_ASSIGN */
+	u8 nsleep_res;
+	/* bitfield to be loaded to NSLEEP_SMPS_ASSIGN */
+	u8 nsleep_smps;
+	/* bitfield to be loaded to NSLEEP_LDO_ASSIGN1 */
+	u8 nsleep_ldo1;
+	/* bitfield to be loaded to NSLEEP_LDO_ASSIGN2 */
+	u8 nsleep_ldo2;
+
+	/* bitfield to be loaded to ENABLE1_RES_ASSIGN */
+	u8 enable1_res;
+	/* bitfield to be loaded to ENABLE1_SMPS_ASSIGN */
+	u8 enable1_smps;
+	/* bitfield to be loaded to ENABLE1_LDO_ASSIGN1 */
+	u8 enable1_ldo1;
+	/* bitfield to be loaded to ENABLE1_LDO_ASSIGN2 */
+	u8 enable1_ldo2;
+
+	/* bitfield to be loaded to ENABLE2_RES_ASSIGN */
+	u8 enable2_res;
+	/* bitfield to be loaded to ENABLE2_SMPS_ASSIGN */
+	u8 enable2_smps;
+	/* bitfield to be loaded to ENABLE2_LDO_ASSIGN1 */
+	u8 enable2_ldo1;
+	/* bitfield to be loaded to ENABLE2_LDO_ASSIGN2 */
+	u8 enable2_ldo2;
+};
 
+struct palmas_clk_platform_data {
+	int clk32kg_mode_sleep;
+	int clk32kgaudio_mode_sleep;
 };
 
 struct palmas_platform_data {
@@ -138,8 +206,49 @@ struct palmas_platform_data {
 	u8 pad1, pad2;
 
 	struct palmas_pmic_platform_data *pmic_pdata;
+	struct palmas_gpadc_platform_data *gpadc_pdata;
+	struct palmas_usb_platform_data *usb_pdata;
+	struct palmas_resource_platform_data *resource_pdata;
+	struct palmas_clk_platform_data *clk_pdata;
 };
 
+struct palmas_gpadc_calibration {
+	s32 gain;
+	s32 gain_error;
+	s32 offset_error;
+};
+
+struct palmas_gpadc {
+	struct device *dev;
+	struct palmas *palmas;
+
+	int ch3_current;
+	int ch0_current;
+
+	int gpadc_force;
+
+	int bat_removal;
+
+	struct mutex reading_lock;
+	struct completion irq_complete;
+
+	int eoc_sw_irq;
+
+	struct palmas_gpadc_calibration *palmas_cal_tbl;
+
+	int conv0_channel;
+	int conv1_channel;
+	int rt_channel;
+};
+
+struct palmas_gpadc_result {
+	s32 raw_code;
+	s32 corrected_code;
+	s32 result;
+};
+
+#define PALMAS_MAX_CHANNELS 16
+
 /* Define the palmas IRQ numbers */
 enum palmas_irqs {
 	/* INT1 registers */
@@ -223,6 +332,69 @@ struct palmas_pmic {
 	int range[PALMAS_REG_SMPS10];
 };
 
+struct palmas_resource {
+	struct palmas *palmas;
+	struct device *dev;
+};
+
+struct palmas_usb {
+	struct palmas *palmas;
+	struct device *dev;
+
+	/* for vbus reporting with irqs disabled */
+	spinlock_t lock;
+
+	struct regulator *vbus_reg;
+
+	/* used to set vbus, in atomic path */
+	struct work_struct set_vbus_work;
+
+	int irq1;
+	int irq2;
+	int irq3;
+	int irq4;
+
+	int vbus_enable;
+
+	u8 linkstat;
+};
+
+#define comparator_to_palmas(x) container_of((x), struct palmas_usb, comparator)
+
+enum usb_irq_events {
+	/* Wakeup events from INT3 */
+	PALMAS_USB_ID_WAKEPUP,
+	PALMAS_USB_VBUS_WAKEUP,
+
+	/* ID_OTG_EVENTS */
+	PALMAS_USB_ID_GND,
+	N_PALMAS_USB_ID_GND,
+	PALMAS_USB_ID_C,
+	N_PALMAS_USB_ID_C,
+	PALMAS_USB_ID_B,
+	N_PALMAS_USB_ID_B,
+	PALMAS_USB_ID_A,
+	N_PALMAS_USB_ID_A,
+	PALMAS_USB_ID_FLOAT,
+	N_PALMAS_USB_ID_FLOAT,
+
+	/* VBUS_OTG_EVENTS */
+	PALMAS_USB_VB_SESS_END,
+	N_PALMAS_USB_VB_SESS_END,
+	PALMAS_USB_VB_SESS_VLD,
+	N_PALMAS_USB_VB_SESS_VLD,
+	PALMAS_USB_VA_SESS_VLD,
+	N_PALMAS_USB_VA_SESS_VLD,
+	PALMAS_USB_VA_VBUS_VLD,
+	N_PALMAS_USB_VA_VBUS_VLD,
+	PALMAS_USB_VADP_SNS,
+	N_PALMAS_USB_VADP_SNS,
+	PALMAS_USB_VADP_PRB,
+	N_PALMAS_USB_VADP_PRB,
+	PALMAS_USB_VOTG_SESS_VLD,
+	N_PALMAS_USB_VOTG_SESS_VLD,
+};
+
 /* defines so we can store the mux settings */
 #define PALMAS_GPIO_0_MUXED					(1 << 0)
 #define PALMAS_GPIO_1_MUXED					(1 << 1)
-- 
1.7.9.5

