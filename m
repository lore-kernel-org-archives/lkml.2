Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757067Ab2AXR1k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 12:27:40 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:38650 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757022Ab2AXR1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 12:27:36 -0500
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org
Cc: cbouatmailru@gmail.com, dg77.kim@samsung.com, kyungmin.park@samsung.com,
        myungjoo.ham@samsung.com, Jason.Wortham@maxim-ic.com,
        bruce.e.robertson@intel.com, Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: [PATCH 2/5] max17042: Add POR init procedure from Maxim appnote
Date: Tue, 24 Jan 2012 09:26:05 -0800
Message-Id: <1327425968-21195-3-git-send-email-dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.7.5
In-Reply-To: <1327425968-21195-1-git-send-email-dirk.brandewie@gmail.com>
References: <1327425968-21195-1-git-send-email-dirk.brandewie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.brandewie@gmail.com>

Add power on reset (POR) init procedure defined by the maxim
appnote. Using this procedure ensures that the part is
configured/initialized correctly at POR and improves early accuracy of
the fuel gauge and informs the fuel gauge with the battery
characterization parameters.  The battery characterization parameters
come from the maxim characterization procedure.

Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
---
 drivers/power/max17042_battery.c       |  389 +++++++++++++++++++++++++++++++-
 include/linux/power/max17042_battery.h |   56 +++++
 2 files changed, 434 insertions(+), 11 deletions(-)

diff --git a/drivers/power/max17042_battery.c b/drivers/power/max17042_battery.c
index 9f0183c..fce502c 100644
--- a/drivers/power/max17042_battery.c
+++ b/drivers/power/max17042_battery.c
@@ -26,14 +26,40 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
+#include <linux/delay.h>
 #include <linux/mod_devicetable.h>
 #include <linux/power_supply.h>
 #include <linux/power/max17042_battery.h>
 
+/* Status register bits */
+#define STATUS_POR_BIT         (1 << 1)
+#define STATUS_BST_BIT         (1 << 3)
+#define STATUS_VMN_BIT         (1 << 8)
+#define STATUS_TMN_BIT         (1 << 9)
+#define STATUS_SMN_BIT         (1 << 10)
+#define STATUS_BI_BIT          (1 << 11)
+#define STATUS_VMX_BIT         (1 << 12)
+#define STATUS_TMX_BIT         (1 << 13)
+#define STATUS_SMX_BIT         (1 << 14)
+#define STATUS_BR_BIT          (1 << 15)
+
+#define VFSOC0_LOCK		0x0000
+#define VFSOC0_UNLOCK		0x0080
+#define MODEL_UNLOCK1	0X0059
+#define MODEL_UNLOCK2	0X00C4
+#define MODEL_LOCK1		0X0000
+#define MODEL_LOCK2		0X0000
+
+#define dQ_ACC_DIV	0x4
+#define dP_ACC_100	0x1900
+#define dP_ACC_200	0x3200
+
 struct max17042_chip {
 	struct i2c_client *client;
 	struct power_supply battery;
 	struct max17042_platform_data *pdata;
+	struct work_struct work;
+	int    init_complete;
 };
 
 static int max17042_write_reg(struct i2c_client *client, u8 reg, u16 value)
@@ -86,6 +112,9 @@ static int max17042_get_property(struct power_supply *psy,
 	struct max17042_chip *chip = container_of(psy,
 				struct max17042_chip, battery);
 
+	if (!chip->init_complete)
+		return -EAGAIN;
+
 	switch (psp) {
 	case POWER_SUPPLY_PROP_PRESENT:
 		val->intval = max17042_read_reg(chip->client,
@@ -180,12 +209,343 @@ static int max17042_get_property(struct power_supply *psy,
 	return 0;
 }
 
+static int max17042_write_verify_reg(struct i2c_client *client,
+				u8 reg, u16 value)
+{
+	int retries = 8;
+	int ret;
+	u16 read_value;
+
+	do {
+		ret = i2c_smbus_write_word_data(client, reg, value);
+		read_value =  max17042_read_reg(client, reg);
+		if (read_value != value) {
+			ret = -EIO;
+			retries--;
+		}
+	} while (retries && read_value != value);
+
+	if (ret < 0)
+		dev_err(&client->dev, "%s: err %d\n", __func__, ret);
+
+	return ret;
+}
+
+static inline void max17042_override_por(
+	struct i2c_client *client, u8 reg, u16 value)
+{
+	if (value)
+		max17042_write_reg(client, reg, value);
+}
+
+static inline void max10742_unlock_model(struct max17042_chip *chip)
+{
+	struct i2c_client *client = chip->client;
+	max17042_write_reg(client, MAX17042_MLOCKReg1, MODEL_UNLOCK1);
+	max17042_write_reg(client, MAX17042_MLOCKReg2, MODEL_UNLOCK2);
+}
+
+static inline void max10742_lock_model(struct max17042_chip *chip)
+{
+	struct i2c_client *client = chip->client;
+	max17042_write_reg(client, MAX17042_MLOCKReg1, MODEL_LOCK1);
+	max17042_write_reg(client, MAX17042_MLOCKReg2, MODEL_LOCK2);
+}
+
+static inline void max17042_write_model_data(struct max17042_chip *chip,
+					u8 addr, int size)
+{
+	struct i2c_client *client = chip->client;
+	int i;
+	for (i = 0; i < size; i++)
+		max17042_write_reg(client, addr + i,
+				chip->pdata->config_data->cell_char_tbl[i]);
+}
+
+static inline void max17042_read_model_data(struct max17042_chip *chip,
+					u8 addr, u16 *data, int size)
+{
+	struct i2c_client *client = chip->client;
+	int i;
+
+	for (i = 0; i < size; i++)
+		data[i] = max17042_read_reg(client, addr + i);
+}
+
+static inline int max17042_model_data_compare(struct max17042_chip *chip,
+					u16 *data1, u16 *data2, int size)
+{
+	int i;
+
+	if (memcmp(data1, data2, size)) {
+		dev_err(&chip->client->dev, "%s compare failed\n", __func__);
+		for (i = 0; i < size; i++)
+			dev_info(&chip->client->dev, "0x%x, 0x%x",
+				data1[i], data2[i]);
+		dev_info(&chip->client->dev, "\n");
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int max17042_init_model(struct max17042_chip *chip)
+{
+	int ret;
+	int table_size =
+		sizeof(chip->pdata->config_data->cell_char_tbl)/sizeof(u16);
+	u16 *temp_data;
+
+	temp_data = kzalloc(table_size, GFP_KERNEL);
+	if (!temp_data)
+		return -ENOMEM;
+
+	max10742_unlock_model(chip);
+	max17042_write_model_data(chip, MAX17042_MODELChrTbl,
+				table_size);
+	max17042_read_model_data(chip, MAX17042_MODELChrTbl, temp_data,
+				table_size);
+
+	ret = max17042_model_data_compare(
+		chip,
+		chip->pdata->config_data->cell_char_tbl,
+		temp_data,
+		table_size);
+
+	max10742_lock_model(chip);
+	kfree(temp_data);
+
+	return ret;
+}
+
+static int max17042_verify_model_lock(struct max17042_chip *chip)
+{
+	int i;
+	int table_size =
+		sizeof(chip->pdata->config_data->cell_char_tbl);
+	u16 *temp_data;
+	int ret = 0;
+
+	temp_data = kzalloc(table_size, GFP_KERNEL);
+	if (!temp_data)
+		return -ENOMEM;
+
+	max17042_read_model_data(chip, MAX17042_MODELChrTbl, temp_data,
+				table_size);
+	for (i = 0; i < table_size; i++)
+		if (temp_data[i])
+			ret = -EINVAL;
+
+	kfree(temp_data);
+	return ret;
+}
+
+static void max17042_write_config_regs(struct max17042_chip *chip)
+{
+	struct max17042_config_data *config = chip->pdata->config_data;
+
+	max17042_write_reg(chip->client, MAX17042_CONFIG, config->config);
+	max17042_write_reg(chip->client, MAX17042_LearnCFG, config->learn_cfg);
+	max17042_write_reg(chip->client, MAX17042_FilterCFG,
+			config->filter_cfg);
+	max17042_write_reg(chip->client, MAX17042_RelaxCFG, config->relax_cfg);
+}
+
+static void  max17042_write_custom_regs(struct max17042_chip *chip)
+{
+	struct max17042_config_data *config = chip->pdata->config_data;
+
+	max17042_write_verify_reg(chip->client, MAX17042_RCOMP0,
+				config->rcomp0);
+	max17042_write_verify_reg(chip->client, MAX17042_TempCo,
+				config->tcompc0);
+	max17042_write_reg(chip->client, MAX17042_EmptyTempCo,
+			config->empty_tempco);
+	max17042_write_verify_reg(chip->client, MAX17042_K_empty0,
+				config->kempty0);
+	max17042_write_verify_reg(chip->client, MAX17042_ICHGTerm,
+				config->ichgt_term);
+}
+
+static void max17042_update_capacity_regs(struct max17042_chip *chip)
+{
+	struct max17042_config_data *config = chip->pdata->config_data;
+
+	max17042_write_verify_reg(chip->client, MAX17042_FullCAP,
+				config->fullcap);
+	max17042_write_reg(chip->client, MAX17042_DesignCap,
+			config->design_cap);
+	max17042_write_verify_reg(chip->client, MAX17042_FullCAPNom,
+				config->fullcapnom);
+}
+
+static void max17042_reset_vfsoc0_reg(struct max17042_chip *chip)
+{
+	u16 vfSoc;
+
+	vfSoc = max17042_read_reg(chip->client, MAX17042_VFSOC);
+	max17042_write_reg(chip->client, MAX17042_VFSOC0Enable, VFSOC0_UNLOCK);
+	max17042_write_verify_reg(chip->client, MAX17042_VFSOC0, vfSoc);
+	max17042_write_reg(chip->client, MAX17042_VFSOC0Enable, VFSOC0_LOCK);
+}
+
+static void max17042_load_new_capacity_params(struct max17042_chip *chip)
+{
+	u16 full_cap0, rep_cap, dq_acc, vfSoc;
+	u32 rem_cap;
+
+	struct max17042_config_data *config = chip->pdata->config_data;
+
+	full_cap0 = max17042_read_reg(chip->client, MAX17042_FullCAP0);
+	vfSoc = max17042_read_reg(chip->client, MAX17042_VFSOC);
+
+	/* fg_vfSoc needs to shifted by 8 bits to get the
+	 * perc in 1% accuracy, to get the right rem_cap multiply
+	 * full_cap0, fg_vfSoc and devide by 100
+	 */
+	rem_cap = ((vfSoc >> 8) * full_cap0) / 100;
+	max17042_write_verify_reg(chip->client, MAX17042_RemCap, (u16)rem_cap);
+
+	rep_cap = (u16)rem_cap;
+	max17042_write_verify_reg(chip->client, MAX17042_RepCap, rep_cap);
+
+	/* Write dQ_acc to 200% of Capacity and dP_acc to 200% */
+	dq_acc = config->fullcap / dQ_ACC_DIV;
+	max17042_write_verify_reg(chip->client, MAX17042_dQacc, dq_acc);
+	max17042_write_verify_reg(chip->client, MAX17042_dPacc, dP_ACC_200);
+
+	max17042_write_verify_reg(chip->client, MAX17042_FullCAP,
+			config->fullcap);
+	max17042_write_reg(chip->client, MAX17042_DesignCap,
+			config->design_cap);
+	max17042_write_verify_reg(chip->client, MAX17042_FullCAPNom,
+			config->fullcapnom);
+}
+
+/*
+ * Block write all the override values coming from platform data.
+ * This function MUST be called before the POR initialization proceedure
+ * specified by maxim.
+ */
+static inline void max17042_override_por_values(struct max17042_chip *chip)
+{
+	struct i2c_client *client = chip->client;
+	struct max17042_config_data *config = chip->pdata->config_data;
+
+	max17042_override_por(client, MAX17042_TGAIN, config->tgain);
+	max17042_override_por(client, MAx17042_TOFF, config->toff);
+	max17042_override_por(client, MAX17042_CGAIN, config->cgain);
+	max17042_override_por(client, MAX17042_COFF, config->coff);
+
+	max17042_override_por(client, MAX17042_VALRT_Th, config->valrt_thresh);
+	max17042_override_por(client, MAX17042_TALRT_Th, config->talrt_thresh);
+	max17042_override_por(client, MAX17042_SALRT_Th,
+			config->soc_alrt_thresh);
+	max17042_override_por(client, MAX17042_CONFIG, config->config);
+	max17042_override_por(client, MAX17042_SHDNTIMER, config->shdntimer);
+
+	max17042_override_por(client, MAX17042_DesignCap, config->design_cap);
+	max17042_override_por(client, MAX17042_ICHGTerm, config->ichgt_term);
+
+	max17042_override_por(client, MAX17042_AtRate, config->at_rate);
+	max17042_override_por(client, MAX17042_LearnCFG, config->learn_cfg);
+	max17042_override_por(client, MAX17042_FilterCFG, config->filter_cfg);
+	max17042_override_por(client, MAX17042_RelaxCFG, config->relax_cfg);
+	max17042_override_por(client, MAX17042_MiscCFG, config->misc_cfg);
+	max17042_override_por(client, MAX17042_MaskSOC, config->masksoc);
+
+	max17042_override_por(client, MAX17042_FullCAP, config->fullcap);
+	max17042_override_por(client, MAX17042_FullCAPNom, config->fullcapnom);
+	max17042_override_por(client, MAX17042_SOC_empty, config->socempty);
+	max17042_override_por(client, MAX17042_LAvg_empty, config->lavg_empty);
+	max17042_override_por(client, MAX17042_dQacc, config->dqacc);
+	max17042_override_por(client, MAX17042_dPacc, config->dpacc);
+
+	max17042_override_por(client, MAX17042_V_empty, config->vempty);
+	max17042_override_por(client, MAX17042_TempNom, config->temp_nom);
+	max17042_override_por(client, MAX17042_TempLim, config->temp_lim);
+	max17042_override_por(client, MAX17042_FCTC, config->fctc);
+	max17042_override_por(client, MAX17042_RCOMP0, config->rcomp0);
+	max17042_override_por(client, MAX17042_TempCo, config->tcompc0);
+	max17042_override_por(client, MAX17042_EmptyTempCo,
+			config->empty_tempco);
+	max17042_override_por(client, MAX17042_K_empty0, config->kempty0);
+}
+
+static int max17042_init_chip(struct max17042_chip *chip)
+{
+	int ret;
+	int val;
+
+	max17042_override_por_values(chip);
+	/* After Power up, the MAX17042 requires 500mS in order
+	 * to perform signal debouncing and initial SOC reporting
+	 */
+	msleep(500);
+
+	/* Initialize configaration */
+	max17042_write_config_regs(chip);
+
+	/* write cell characterization data */
+	ret = max17042_init_model(chip);
+	if (ret) {
+		dev_err(&chip->client->dev, "%s init failed\n",
+			__func__);
+		return -EIO;
+	}
+	max17042_verify_model_lock(chip);
+	if (ret) {
+		dev_err(&chip->client->dev, "%s lock verify failed\n",
+			__func__);
+		return -EIO;
+	}
+	/* write custom parameters */
+	max17042_write_custom_regs(chip);
+
+	/* update capacity params */
+	max17042_update_capacity_regs(chip);
+
+	/* delay must be atleast 350mS to allow VFSOC
+	 * to be calculated from the new configuration
+	 */
+	msleep(350);
+
+	/* reset vfsoc0 reg */
+	max17042_reset_vfsoc0_reg(chip);
+
+	/* load new capacity params */
+	max17042_load_new_capacity_params(chip);
+
+	/* Init complete, Clear the POR bit */
+	val = max17042_read_reg(chip->client, MAX17042_STATUS);
+	max17042_write_reg(chip->client, MAX17042_STATUS,
+			val & (~STATUS_POR_BIT));
+	return 0;
+}
+
+
+static void max17042_init_worker(struct work_struct *work)
+{
+	struct max17042_chip *chip = container_of(work,
+				struct max17042_chip, work);
+	int ret;
+
+	/* Initialize registers according to values from the platform data */
+	if (chip->pdata->enable_por_init && chip->pdata->config_data) {
+		ret = max17042_init_chip(chip);
+		if (ret)
+			return;
+	}
+
+	chip->init_complete = 1;
+}
+
 static int __devinit max17042_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
 	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
 	struct max17042_chip *chip;
 	int ret;
+	int reg;
 
 	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_WORD_DATA))
 		return -EIO;
@@ -210,17 +570,9 @@ static int __devinit max17042_probe(struct i2c_client *client,
 	if (!chip->pdata->enable_current_sense)
 		chip->battery.num_properties -= 2;
 
-	ret = power_supply_register(&client->dev, &chip->battery);
-	if (ret) {
-		dev_err(&client->dev, "failed: power supply register\n");
-		kfree(chip);
-		return ret;
-	}
-
-	/* Initialize registers according to values from the platform data */
 	if (chip->pdata->init_data)
 		max17042_set_reg(client, chip->pdata->init_data,
-				 chip->pdata->num_init_data);
+				chip->pdata->num_init_data);
 
 	if (!chip->pdata->enable_current_sense) {
 		max17042_write_reg(client, MAX17042_CGAIN, 0x0000);
@@ -228,10 +580,25 @@ static int __devinit max17042_probe(struct i2c_client *client,
 		max17042_write_reg(client, MAX17042_LearnCFG, 0x0007);
 	} else {
 		if (chip->pdata->r_sns == 0)
-			chip->pdata->r_sns = MAX17042_DEFAULT_SNS_RESISTOR;
+			chip->pdata->r_sns =
+				MAX17042_DEFAULT_SNS_RESISTOR;
 	}
 
-	return 0;
+	reg = max17042_read_reg(chip->client, MAX17042_STATUS);
+
+	if (reg & STATUS_POR_BIT) {
+		INIT_WORK(&chip->work, max17042_init_worker);
+		schedule_work(&chip->work);
+	} else {
+		chip->init_complete = 1;
+	}
+
+	ret = power_supply_register(&client->dev, &chip->battery);
+	if (ret) {
+		dev_err(&client->dev, "failed: power supply register\n");
+		kfree(chip);
+	}
+	return ret;
 }
 
 static int __devexit max17042_remove(struct i2c_client *client)
diff --git a/include/linux/power/max17042_battery.h b/include/linux/power/max17042_battery.h
index 67eeada..e01b167 100644
--- a/include/linux/power/max17042_battery.h
+++ b/include/linux/power/max17042_battery.h
@@ -27,6 +27,8 @@
 #define MAX17042_BATTERY_FULL	(100)
 #define MAX17042_DEFAULT_SNS_RESISTOR	(10000)
 
+#define MAX17042_CHARACTERIZATION_DATA_SIZE 48
+
 enum max17042_register {
 	MAX17042_STATUS		= 0x00,
 	MAX17042_VALRT_Th	= 0x01,
@@ -124,10 +126,64 @@ struct max17042_reg_data {
 	u16 data;
 };
 
+struct max17042_config_data {
+	/* External current sense resistor value in milli-ohms */
+	u32	cur_sense_val;
+
+	/* A/D measurement */
+	u16	tgain;		/* 0x2C */
+	u16	toff;		/* 0x2D */
+	u16	cgain;		/* 0x2E */
+	u16	coff;		/* 0x2F */
+
+	/* Alert / Status */
+	u16	valrt_thresh;	/* 0x01 */
+	u16	talrt_thresh;	/* 0x02 */
+	u16	soc_alrt_thresh;	/* 0x03 */
+	u16	config;		/* 0x01D */
+	u16	shdntimer;	/* 0x03F */
+
+	/* App data */
+	u16	design_cap;	/* 0x18 */
+	u16	ichgt_term;	/* 0x1E */
+
+	/* MG3 config */
+	u16	at_rate;	/* 0x04 */
+	u16	learn_cfg;	/* 0x28 */
+	u16	filter_cfg;	/* 0x29 */
+	u16	relax_cfg;	/* 0x2A */
+	u16	misc_cfg;	/* 0x2B */
+	u16	masksoc;	/* 0x32 */
+
+	/* MG3 save and restore */
+	u16	fullcap;	/* 0x10 */
+	u16	fullcapnom;	/* 0x23 */
+	u16	socempty;	/* 0x33 */
+	u16	lavg_empty;	/* 0x36 */
+	u16	dqacc;		/* 0x45 */
+	u16	dpacc;		/* 0x46 */
+
+	/* Cell technology from power_supply.h */
+	u16	cell_technology;
+
+	/* Cell Data */
+	u16	vempty;		/* 0x12 */
+	u16	temp_nom;	/* 0x24 */
+	u16	temp_lim;	/* 0x25 */
+	u16	fctc;		/* 0x37 */
+	u16	rcomp0;		/* 0x38 */
+	u16	tcompc0;	/* 0x39 */
+	u16	empty_tempco;	/* 0x3A */
+	u16	kempty0;	/* 0x3B */
+	u16	cell_char_tbl[MAX17042_CHARACTERIZATION_DATA_SIZE];
+} __packed;
+
 struct max17042_platform_data {
 	struct max17042_reg_data *init_data;
+	struct max17042_config_data *config_data;
 	int num_init_data; /* Number of enties in init_data array */
 	bool enable_current_sense;
+	bool enable_por_init; /* Use POR init from Maxim appnote */
 
 	/*
 	 * R_sns in micro-ohms.
-- 
1.7.7.5

