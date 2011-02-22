Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751535Ab1BVMZb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 07:25:31 -0500
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:57182 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750784Ab1BVMZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 07:25:29 -0500
From: Daniel Willerud <daniel.willerud@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: <linux-kernel@vger.kernel.org>,
        Daniel Willerud <daniel.willerud@stericsson.com>
Subject: [PATCH] MFD: ab8500: New ab8500_gpadc APIs and reentrance
Date: Tue, 22 Feb 2011 13:24:00 +0100
Message-ID: <1298377440-13032-1-git-send-email-daniel.willerud@stericsson.com>
X-Mailer: git-send-email 1.7.3.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added ab8500_gpadc_get() API: A client do not need to be a ab8500 sub-device
Added ab8500_gpadc_convert() API
Added support for multiple ab8500-gpadc instances, driver is now reentrant

Corrected regulator naming according to ste-next

Signed-off-by: Daniel Willerud <daniel.willerud@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@stericsson.com>
Acked-by: Mattias Wallin <mattias.wallin@stericsson.com>
---
 drivers/mfd/ab8500-gpadc.c              |  401 +++++++++++++++++++++++++++----
 include/linux/mfd/ab8500/ab8500-gpadc.h |   32 +++
 2 files changed, 382 insertions(+), 51 deletions(-)
 create mode 100644 include/linux/mfd/ab8500/ab8500-gpadc.h

diff --git a/drivers/mfd/ab8500-gpadc.c b/drivers/mfd/ab8500-gpadc.c
index 19339bc..4cf400f 100644
--- a/drivers/mfd/ab8500-gpadc.c
+++ b/drivers/mfd/ab8500-gpadc.c
@@ -3,6 +3,8 @@
  *
  * License Terms: GNU General Public License v2
  * Author: Arun R Murthy <arun.murthy@stericsson.com>
+ * Author: Daniel Willerud <daniel.willerud@stericsson.com>
+ * Author: Johan Palsson <johan.palsson@stericsson.com>
  */
 #include <linux/init.h>
 #include <linux/module.h>
@@ -15,9 +17,10 @@
 #include <linux/regulator/consumer.h>
 #include <linux/err.h>
 #include <linux/slab.h>
+#include <linux/list.h>
 #include <linux/mfd/ab8500.h>
 #include <linux/mfd/abx500.h>
-#include <linux/mfd/ab8500-gpadc.h>
+#include <linux/mfd/ab8500/ab8500-gpadc.h>
 
 /*
  * GPADC register offsets
@@ -34,6 +37,18 @@
 #define AB8500_GPADC_AUTODATAH_REG	0x08
 #define AB8500_GPADC_MUX_CTRL_REG	0x09
 
+/*
+ * OTP register offsets
+ * Bank : 0x15
+ */
+#define AB8500_GPADC_CAL_1		0x0F
+#define AB8500_GPADC_CAL_2		0x10
+#define AB8500_GPADC_CAL_3		0x11
+#define AB8500_GPADC_CAL_4		0x12
+#define AB8500_GPADC_CAL_5		0x13
+#define AB8500_GPADC_CAL_6		0x14
+#define AB8500_GPADC_CAL_7		0x15
+
 /* gpadc constants */
 #define EN_VINTCORE12			0x04
 #define EN_VTVOUT			0x02
@@ -45,51 +60,196 @@
 #define DIS_ZERO			0x00
 #define GPADC_BUSY			0x01
 
+/* GPADC constants from AB8500 spec, UM0836 */
+#define ADC_RESOLUTION			1024
+#define ADC_CH_BTEMP_MIN		0
+#define ADC_CH_BTEMP_MAX		1350
+#define ADC_CH_DIETEMP_MIN		0
+#define ADC_CH_DIETEMP_MAX		1350
+#define ADC_CH_CHG_V_MIN		0
+#define ADC_CH_CHG_V_MAX		20030
+#define ADC_CH_ACCDET2_MIN		0
+#define ADC_CH_ACCDET2_MAX		2500
+#define ADC_CH_VBAT_MIN			2300
+#define ADC_CH_VBAT_MAX			4800
+#define ADC_CH_CHG_I_MIN		0
+#define ADC_CH_CHG_I_MAX		1500
+#define ADC_CH_BKBAT_MIN		0
+#define ADC_CH_BKBAT_MAX		3200
+
+/* This is used to not lose precision when dividing to get gain and offset */
+#define CALIB_SCALE			1000
+
+enum cal_channels {
+	ADC_INPUT_VMAIN = 0,
+	ADC_INPUT_BTEMP,
+	ADC_INPUT_VBAT,
+	NBR_CAL_INPUTS,
+};
+
 /**
- * struct ab8500_gpadc - ab8500 GPADC device information
+ * struct adc_cal_data - Table for storing gain and offset for the calibrated
+ * ADC channels
+ * @gain:		Gain of the ADC channel
+ * @offset:		Offset of the ADC channel
+ */
+struct adc_cal_data {
+	u64 gain;
+	u64 offset;
+};
+
+/**
+ * struct ab8500_gpadc - AB8500 GPADC device information
  * @dev:			pointer to the struct device
- * @parent:			pointer to the parent device structure ab8500
+ * @node:			a list of AB8500 GPADCs, hence prepared for
+				reentrance
  * @ab8500_gpadc_complete:	pointer to the struct completion, to indicate
  *				the completion of gpadc conversion
  * @ab8500_gpadc_lock:		structure of type mutex
  * @regu:			pointer to the struct regulator
  * @irq:			interrupt number that is used by gpadc
+ * @cal_data			array of ADC calibration data structs
  */
-static struct ab8500_gpadc {
+struct ab8500_gpadc {
 	struct device *dev;
-	struct ab8500 *parent;
+	struct list_head node;
 	struct completion ab8500_gpadc_complete;
 	struct mutex ab8500_gpadc_lock;
 	struct regulator *regu;
 	int irq;
-} *di;
+	struct adc_cal_data cal_data[NBR_CAL_INPUTS];
+};
+
+static LIST_HEAD(ab8500_gpadc_list);
+
+/**
+ * ab8500_gpadc_get() - returns a reference to the primary AB8500 GPADC
+ * (i.e. the first GPADC in the instance list)
+ */
+struct ab8500_gpadc *ab8500_gpadc_get(void)
+{
+	struct ab8500_gpadc *gpadc;
+	gpadc = list_first_entry(&ab8500_gpadc_list, struct ab8500_gpadc, node);
+
+	return gpadc;
+}
+EXPORT_SYMBOL(ab8500_gpadc_get);
+
+static int ab8500_gpadc_ad_to_voltage(struct ab8500_gpadc *gpadc, u8 input,
+	int ad_value)
+{
+	int res;
+
+	switch (input) {
+	case MAIN_CHARGER_V:
+		/* For some reason we don't have calibrated data */
+		if (!gpadc->cal_data[ADC_INPUT_VMAIN].gain) {
+			res = ADC_CH_CHG_V_MIN + (ADC_CH_CHG_V_MAX -
+				ADC_CH_CHG_V_MIN) * ad_value /
+				ADC_RESOLUTION;
+			break;
+		}
+		/* Here we can use the calibrated data */
+		res = (int) (ad_value * gpadc->cal_data[ADC_INPUT_VMAIN].gain +
+			gpadc->cal_data[ADC_INPUT_VMAIN].offset) / CALIB_SCALE;
+		break;
+
+	case BAT_CTRL:
+	case BTEMP_BALL:
+	case ACC_DETECT1:
+	case ADC_AUX1:
+	case ADC_AUX2:
+		/* For some reason we don't have calibrated data */
+		if (!gpadc->cal_data[ADC_INPUT_BTEMP].gain) {
+			res = ADC_CH_BTEMP_MIN + (ADC_CH_BTEMP_MAX -
+				ADC_CH_BTEMP_MIN) * ad_value /
+				ADC_RESOLUTION;
+			break;
+		}
+		/* Here we can use the calibrated data */
+		res = (int) (ad_value * gpadc->cal_data[ADC_INPUT_BTEMP].gain +
+			gpadc->cal_data[ADC_INPUT_BTEMP].offset) / CALIB_SCALE;
+		break;
+
+	case MAIN_BAT_V:
+		/* For some reason we don't have calibrated data */
+		if (!gpadc->cal_data[ADC_INPUT_VBAT].gain) {
+			res = ADC_CH_VBAT_MIN + (ADC_CH_VBAT_MAX -
+				ADC_CH_VBAT_MIN) * ad_value /
+				ADC_RESOLUTION;
+			break;
+		}
+		/* Here we can use the calibrated data */
+		res = (int) (ad_value * gpadc->cal_data[ADC_INPUT_VBAT].gain +
+			gpadc->cal_data[ADC_INPUT_VBAT].offset) / CALIB_SCALE;
+		break;
+
+	case DIE_TEMP:
+		res = ADC_CH_DIETEMP_MIN +
+			(ADC_CH_DIETEMP_MAX - ADC_CH_DIETEMP_MIN) * ad_value /
+			ADC_RESOLUTION;
+		break;
+
+	case ACC_DETECT2:
+		res = ADC_CH_ACCDET2_MIN +
+			(ADC_CH_ACCDET2_MAX - ADC_CH_ACCDET2_MIN) * ad_value /
+			ADC_RESOLUTION;
+		break;
+
+	case VBUS_V:
+		res = ADC_CH_CHG_V_MIN +
+			(ADC_CH_CHG_V_MAX - ADC_CH_CHG_V_MIN) * ad_value /
+			ADC_RESOLUTION;
+		break;
+
+	case MAIN_CHARGER_C:
+	case USB_CHARGER_C:
+		res = ADC_CH_CHG_I_MIN +
+			(ADC_CH_CHG_I_MAX - ADC_CH_CHG_I_MIN) * ad_value /
+			ADC_RESOLUTION;
+		break;
+
+	case BK_BAT_V:
+		res = ADC_CH_BKBAT_MIN +
+			(ADC_CH_BKBAT_MAX - ADC_CH_BKBAT_MIN) * ad_value /
+			ADC_RESOLUTION;
+		break;
+
+	default:
+		dev_err(gpadc->dev,
+			"unknown channel, not possible to convert\n");
+		res = -EINVAL;
+		break;
+
+	}
+	return res;
+}
 
 /**
  * ab8500_gpadc_convert() - gpadc conversion
  * @input:	analog input to be converted to digital data
  *
  * This function converts the selected analog i/p to digital
- * data. Thereafter calibration has to be made to obtain the
- * data in the required quantity measurement.
+ * data.
  */
-int ab8500_gpadc_convert(u8 input)
+int ab8500_gpadc_convert(struct ab8500_gpadc *gpadc, u8 input)
 {
 	int ret;
 	u16 data = 0;
 	int looplimit = 0;
 	u8 val, low_data, high_data;
 
-	if (!di)
+	if (!gpadc)
 		return -ENODEV;
 
-	mutex_lock(&di->ab8500_gpadc_lock);
+	mutex_lock(&gpadc->ab8500_gpadc_lock);
 	/* Enable VTVout LDO this is required for GPADC */
-	regulator_enable(di->regu);
+	regulator_enable(gpadc->regu);
 
 	/* Check if ADC is not busy, lock and proceed */
 	do {
-		ret = abx500_get_register_interruptible(di->dev, AB8500_GPADC,
-			AB8500_GPADC_STAT_REG, &val);
+		ret = abx500_get_register_interruptible(gpadc->dev,
+			AB8500_GPADC, AB8500_GPADC_STAT_REG, &val);
 		if (ret < 0)
 			goto out;
 		if (!(val & GPADC_BUSY))
@@ -97,76 +257,78 @@ int ab8500_gpadc_convert(u8 input)
 		msleep(10);
 	} while (++looplimit < 10);
 	if (looplimit >= 10 && (val & GPADC_BUSY)) {
-		dev_err(di->dev, "gpadc_conversion: GPADC busy");
+		dev_err(gpadc->dev, "gpadc_conversion: GPADC busy");
 		ret = -EINVAL;
 		goto out;
 	}
 
 	/* Enable GPADC */
-	ret = abx500_mask_and_set_register_interruptible(di->dev, AB8500_GPADC,
-		AB8500_GPADC_CTRL1_REG, EN_GPADC, EN_GPADC);
+	ret = abx500_mask_and_set_register_interruptible(gpadc->dev,
+		AB8500_GPADC, AB8500_GPADC_CTRL1_REG, EN_GPADC, EN_GPADC);
 	if (ret < 0) {
-		dev_err(di->dev, "gpadc_conversion: enable gpadc failed\n");
+		dev_err(gpadc->dev, "gpadc_conversion: enable gpadc failed\n");
 		goto out;
 	}
 	/* Select the input source and set average samples to 16 */
-	ret = abx500_set_register_interruptible(di->dev, AB8500_GPADC,
+	ret = abx500_set_register_interruptible(gpadc->dev, AB8500_GPADC,
 		AB8500_GPADC_CTRL2_REG, (input | SW_AVG_16));
 	if (ret < 0) {
-		dev_err(di->dev,
+		dev_err(gpadc->dev,
 			"gpadc_conversion: set avg samples failed\n");
 		goto out;
 	}
 	/* Enable ADC, Buffering and select rising edge, start Conversion */
-	ret = abx500_mask_and_set_register_interruptible(di->dev, AB8500_GPADC,
-		AB8500_GPADC_CTRL1_REG, EN_BUF, EN_BUF);
+	ret = abx500_mask_and_set_register_interruptible(gpadc->dev,
+		AB8500_GPADC, AB8500_GPADC_CTRL1_REG, EN_BUF, EN_BUF);
 	if (ret < 0) {
-		dev_err(di->dev,
+		dev_err(gpadc->dev,
 			"gpadc_conversion: select falling edge failed\n");
 		goto out;
 	}
-	ret = abx500_mask_and_set_register_interruptible(di->dev, AB8500_GPADC,
-		AB8500_GPADC_CTRL1_REG, ADC_SW_CONV, ADC_SW_CONV);
+	ret = abx500_mask_and_set_register_interruptible(gpadc->dev,
+		AB8500_GPADC, AB8500_GPADC_CTRL1_REG, ADC_SW_CONV, ADC_SW_CONV);
 	if (ret < 0) {
-		dev_err(di->dev,
+		dev_err(gpadc->dev,
 			"gpadc_conversion: start s/w conversion failed\n");
 		goto out;
 	}
 	/* wait for completion of conversion */
-	if (!wait_for_completion_timeout(&di->ab8500_gpadc_complete, 2*HZ)) {
-		dev_err(di->dev,
+	if (!wait_for_completion_timeout(&gpadc->ab8500_gpadc_complete, 2*HZ)) {
+		dev_err(gpadc->dev,
 			"timeout: didnt recieve GPADC conversion interrupt\n");
 		ret = -EINVAL;
 		goto out;
 	}
 
 	/* Read the converted RAW data */
-	ret = abx500_get_register_interruptible(di->dev, AB8500_GPADC,
+	ret = abx500_get_register_interruptible(gpadc->dev, AB8500_GPADC,
 		AB8500_GPADC_MANDATAL_REG, &low_data);
 	if (ret < 0) {
-		dev_err(di->dev, "gpadc_conversion: read low data failed\n");
+		dev_err(gpadc->dev, "gpadc_conversion: read low data failed\n");
 		goto out;
 	}
 
-	ret = abx500_get_register_interruptible(di->dev, AB8500_GPADC,
+	ret = abx500_get_register_interruptible(gpadc->dev, AB8500_GPADC,
 		AB8500_GPADC_MANDATAH_REG, &high_data);
 	if (ret < 0) {
-		dev_err(di->dev, "gpadc_conversion: read high data failed\n");
+		dev_err(gpadc->dev,
+			"gpadc_conversion: read high data failed\n");
 		goto out;
 	}
 
 	data = (high_data << 8) | low_data;
 	/* Disable GPADC */
-	ret = abx500_set_register_interruptible(di->dev, AB8500_GPADC,
+	ret = abx500_set_register_interruptible(gpadc->dev, AB8500_GPADC,
 		AB8500_GPADC_CTRL1_REG, DIS_GPADC);
 	if (ret < 0) {
-		dev_err(di->dev, "gpadc_conversion: disable gpadc failed\n");
+		dev_err(gpadc->dev, "gpadc_conversion: disable gpadc failed\n");
 		goto out;
 	}
 	/* Disable VTVout LDO this is required for GPADC */
-	regulator_disable(di->regu);
-	mutex_unlock(&di->ab8500_gpadc_lock);
-	return data;
+	regulator_disable(gpadc->regu);
+	mutex_unlock(&gpadc->ab8500_gpadc_lock);
+	ret = ab8500_gpadc_ad_to_voltage(gpadc, input, data);
+	return ret;
 
 out:
 	/*
@@ -175,12 +337,12 @@ out:
 	 * GPADC status register to go low. In V1.1 there wait_for_completion
 	 * seems to timeout when waiting for an interrupt.. Not seen in V2.0
 	 */
-	(void) abx500_set_register_interruptible(di->dev, AB8500_GPADC,
+	(void) abx500_set_register_interruptible(gpadc->dev, AB8500_GPADC,
 		AB8500_GPADC_CTRL1_REG, DIS_GPADC);
-	regulator_disable(di->regu);
-	mutex_unlock(&di->ab8500_gpadc_lock);
-	dev_err(di->dev, "gpadc_conversion: Failed to AD convert channel %d\n",
-		input);
+	regulator_disable(gpadc->regu);
+	mutex_unlock(&gpadc->ab8500_gpadc_lock);
+	dev_err(gpadc->dev,
+		"gpadc_conversion: Failed to AD convert channel %d\n", input);
 	return ret;
 }
 EXPORT_SYMBOL(ab8500_gpadc_convert);
@@ -195,15 +357,147 @@ EXPORT_SYMBOL(ab8500_gpadc_convert);
  * can be read from the registers.
  * Returns IRQ status(IRQ_HANDLED)
  */
-static irqreturn_t ab8500_bm_gpswadcconvend_handler(int irq, void *_di)
+static irqreturn_t ab8500_bm_gpswadcconvend_handler(int irq, void *_gpadc)
 {
-	struct ab8500_gpadc *gpadc = _di;
+	struct ab8500_gpadc *gpadc = _gpadc;
 
 	complete(&gpadc->ab8500_gpadc_complete);
 
 	return IRQ_HANDLED;
 }
 
+static int otp_cal_regs[] = {
+	AB8500_GPADC_CAL_1,
+	AB8500_GPADC_CAL_2,
+	AB8500_GPADC_CAL_3,
+	AB8500_GPADC_CAL_4,
+	AB8500_GPADC_CAL_5,
+	AB8500_GPADC_CAL_6,
+	AB8500_GPADC_CAL_7,
+};
+
+static void ab8500_gpadc_read_calibration_data(struct ab8500_gpadc *gpadc)
+{
+	int i;
+	int ret[ARRAY_SIZE(otp_cal_regs)];
+	u8 gpadc_cal[ARRAY_SIZE(otp_cal_regs)];
+
+	int vmain_high, vmain_low;
+	int btemp_high, btemp_low;
+	int vbat_high, vbat_low;
+
+	/* First we read all OTP registers and store the error code */
+	for (i = 0; i < ARRAY_SIZE(otp_cal_regs); i++) {
+		ret[i] = abx500_get_register_interruptible(gpadc->dev,
+			AB8500_OTP_EMUL, otp_cal_regs[i],  &gpadc_cal[i]);
+		if (ret[i] < 0)
+			dev_err(gpadc->dev, "%s: read otp reg 0x%02x failed\n",
+				__func__, otp_cal_regs[i]);
+	}
+
+	/*
+	 * The ADC calibration data is stored in OTP registers.
+	 * The layout of the calibration data is outlined below and a more
+	 * detailed description can be found in UM0836
+	 *
+	 * vm_h/l = vmain_high/low
+	 * bt_h/l = btemp_high/low
+	 * vb_h/l = vbat_high/low
+	 *
+	 * Data bits:
+	 * | 7	   | 6	   | 5	   | 4	   | 3	   | 2	   | 1	   | 0
+	 * |.......|.......|.......|.......|.......|.......|.......|.......
+	 * |						   | vm_h9 | vm_h8
+	 * |.......|.......|.......|.......|.......|.......|.......|.......
+	 * |		   | vm_h7 | vm_h6 | vm_h5 | vm_h4 | vm_h3 | vm_h2
+	 * |.......|.......|.......|.......|.......|.......|.......|.......
+	 * | vm_h1 | vm_h0 | vm_l4 | vm_l3 | vm_l2 | vm_l1 | vm_l0 | bt_h9
+	 * |.......|.......|.......|.......|.......|.......|.......|.......
+	 * | bt_h8 | bt_h7 | bt_h6 | bt_h5 | bt_h4 | bt_h3 | bt_h2 | bt_h1
+	 * |.......|.......|.......|.......|.......|.......|.......|.......
+	 * | bt_h0 | bt_l4 | bt_l3 | bt_l2 | bt_l1 | bt_l0 | vb_h9 | vb_h8
+	 * |.......|.......|.......|.......|.......|.......|.......|.......
+	 * | vb_h7 | vb_h6 | vb_h5 | vb_h4 | vb_h3 | vb_h2 | vb_h1 | vb_h0
+	 * |.......|.......|.......|.......|.......|.......|.......|.......
+	 * | vb_l5 | vb_l4 | vb_l3 | vb_l2 | vb_l1 | vb_l0 |
+	 * |.......|.......|.......|.......|.......|.......|.......|.......
+	 *
+	 *
+	 * Ideal output ADC codes corresponding to injected input voltages
+	 * during manufacturing is:
+	 *
+	 * vmain_high: Vin = 19500mV / ADC ideal code = 997
+	 * vmain_low:  Vin = 315mV   / ADC ideal code = 16
+	 * btemp_high: Vin = 1300mV  / ADC ideal code = 985
+	 * btemp_low:  Vin = 21mV    / ADC ideal code = 16
+	 * vbat_high:  Vin = 4700mV  / ADC ideal code = 982
+	 * vbat_low:   Vin = 2380mV  / ADC ideal code = 33
+	 */
+
+	/* Calculate gain and offset for VMAIN if all reads succeeded */
+	if (!(ret[0] < 0 || ret[1] < 0 || ret[2] < 0)) {
+		vmain_high = (((gpadc_cal[0] & 0x03) << 8) |
+			((gpadc_cal[1] & 0x3F) << 2) |
+			((gpadc_cal[2] & 0xC0) >> 6));
+
+		vmain_low = ((gpadc_cal[2] & 0x3E) >> 1);
+
+		gpadc->cal_data[ADC_INPUT_VMAIN].gain = CALIB_SCALE *
+			(19500 - 315) /	(vmain_high - vmain_low);
+
+		gpadc->cal_data[ADC_INPUT_VMAIN].offset = CALIB_SCALE * 19500 -
+			(CALIB_SCALE * (19500 - 315) /
+			 (vmain_high - vmain_low)) * vmain_high;
+	} else {
+		gpadc->cal_data[ADC_INPUT_VMAIN].gain = 0;
+	}
+
+	/* Calculate gain and offset for BTEMP if all reads succeeded */
+	if (!(ret[2] < 0 || ret[3] < 0 || ret[4] < 0)) {
+		btemp_high = (((gpadc_cal[2] & 0x01) << 9) |
+			(gpadc_cal[3] << 1) |
+			((gpadc_cal[4] & 0x80) >> 7));
+
+		btemp_low = ((gpadc_cal[4] & 0x7C) >> 2);
+
+		gpadc->cal_data[ADC_INPUT_BTEMP].gain =
+			CALIB_SCALE * (1300 - 21) / (btemp_high - btemp_low);
+
+		gpadc->cal_data[ADC_INPUT_BTEMP].offset = CALIB_SCALE * 1300 -
+			(CALIB_SCALE * (1300 - 21) /
+			(btemp_high - btemp_low)) * btemp_high;
+	} else {
+		gpadc->cal_data[ADC_INPUT_BTEMP].gain = 0;
+	}
+
+	/* Calculate gain and offset for VBAT if all reads succeeded */
+	if (!(ret[4] < 0 || ret[5] < 0 || ret[6] < 0)) {
+		vbat_high = (((gpadc_cal[4] & 0x03) << 8) | gpadc_cal[5]);
+		vbat_low = ((gpadc_cal[6] & 0xFC) >> 2);
+
+		gpadc->cal_data[ADC_INPUT_VBAT].gain = CALIB_SCALE *
+			(4700 - 2380) /	(vbat_high - vbat_low);
+
+		gpadc->cal_data[ADC_INPUT_VBAT].offset = CALIB_SCALE * 4700 -
+			(CALIB_SCALE * (4700 - 2380) /
+			(vbat_high - vbat_low)) * vbat_high;
+	} else {
+		gpadc->cal_data[ADC_INPUT_VBAT].gain = 0;
+	}
+
+	dev_dbg(gpadc->dev, "VMAIN gain %llu offset %llu\n",
+		gpadc->cal_data[ADC_INPUT_VMAIN].gain,
+		gpadc->cal_data[ADC_INPUT_VMAIN].offset);
+
+	dev_dbg(gpadc->dev, "BTEMP gain %llu offset %llu\n",
+		gpadc->cal_data[ADC_INPUT_BTEMP].gain,
+		gpadc->cal_data[ADC_INPUT_BTEMP].offset);
+
+	dev_dbg(gpadc->dev, "VBAT gain %llu offset %llu\n",
+		gpadc->cal_data[ADC_INPUT_VBAT].gain,
+		gpadc->cal_data[ADC_INPUT_VBAT].offset);
+}
+
 static int __devinit ab8500_gpadc_probe(struct platform_device *pdev)
 {
 	int ret = 0;
@@ -215,16 +509,16 @@ static int __devinit ab8500_gpadc_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
-	gpadc->parent = dev_get_drvdata(pdev->dev.parent);
 	gpadc->irq = platform_get_irq_byname(pdev, "SW_CONV_END");
 	if (gpadc->irq < 0) {
-		dev_err(gpadc->dev, "failed to get platform irq-%d\n", di->irq);
+		dev_err(gpadc->dev, "failed to get platform irq-%d\n",
+			gpadc->irq);
 		ret = gpadc->irq;
 		goto fail;
 	}
 
 	gpadc->dev = &pdev->dev;
-	mutex_init(&di->ab8500_gpadc_lock);
+	mutex_init(&gpadc->ab8500_gpadc_lock);
 
 	/* Initialize completion used to notify completion of conversion */
 	init_completion(&gpadc->ab8500_gpadc_complete);
@@ -244,11 +538,14 @@ static int __devinit ab8500_gpadc_probe(struct platform_device *pdev)
 	if (IS_ERR(gpadc->regu)) {
 		ret = PTR_ERR(gpadc->regu);
 		dev_err(gpadc->dev, "failed to get vtvout LDO\n");
-		goto fail;
+		goto fail_irq;
 	}
-	di = gpadc;
+	ab8500_gpadc_read_calibration_data(gpadc);
+	list_add_tail(&gpadc->node, &ab8500_gpadc_list);
 	dev_dbg(gpadc->dev, "probe success\n");
 	return 0;
+fail_irq:
+	free_irq(gpadc->irq, gpadc);
 fail:
 	kfree(gpadc);
 	gpadc = NULL;
@@ -259,8 +556,10 @@ static int __devexit ab8500_gpadc_remove(struct platform_device *pdev)
 {
 	struct ab8500_gpadc *gpadc = platform_get_drvdata(pdev);
 
+	/* remove this gpadc entry from the list */
+	list_del(&gpadc->node);
 	/* remove interrupt  - completion of Sw ADC conversion */
-	free_irq(gpadc->irq, di);
+	free_irq(gpadc->irq, gpadc);
 	/* disable VTVout LDO that is being used by GPADC */
 	regulator_put(gpadc->regu);
 	kfree(gpadc);
@@ -291,6 +590,6 @@ subsys_initcall_sync(ab8500_gpadc_init);
 module_exit(ab8500_gpadc_exit);
 
 MODULE_LICENSE("GPL v2");
-MODULE_AUTHOR("Arun R Murthy");
+MODULE_AUTHOR("Arun R Murthy, Daniel Willerud, Johan Palsson");
 MODULE_ALIAS("platform:ab8500_gpadc");
 MODULE_DESCRIPTION("AB8500 GPADC driver");
diff --git a/include/linux/mfd/ab8500/ab8500-gpadc.h b/include/linux/mfd/ab8500/ab8500-gpadc.h
new file mode 100644
index 0000000..57c6b59
--- /dev/null
+++ b/include/linux/mfd/ab8500/ab8500-gpadc.h
@@ -0,0 +1,32 @@
+/*
+ * Copyright (C) 2010 ST-Ericsson SA
+ * Licensed under GPLv2.
+ *
+ * Author: Arun R Murthy <arun.murthy@stericsson.com>
+ * Author: Daniel Willerud <daniel.willerud@stericsson.com>
+ */
+
+#ifndef	_AB8500_GPADC_H
+#define _AB8500_GPADC_H
+
+/* GPADC source: From datasheet(ADCSwSel[4:0] in GPADCCtrl2) */
+#define BAT_CTRL	0x01
+#define BTEMP_BALL	0x02
+#define MAIN_CHARGER_V	0x03
+#define ACC_DETECT1	0x04
+#define ACC_DETECT2	0x05
+#define ADC_AUX1	0x06
+#define ADC_AUX2	0x07
+#define MAIN_BAT_V	0x08
+#define VBUS_V		0x09
+#define MAIN_CHARGER_C	0x0A
+#define USB_CHARGER_C	0x0B
+#define BK_BAT_V	0x0C
+#define DIE_TEMP	0x0D
+
+struct ab8500_gpadc;
+
+struct ab8500_gpadc *ab8500_gpadc_get(void);
+int ab8500_gpadc_convert(struct ab8500_gpadc *gpadc, u8 input);
+
+#endif /* _AB8500_GPADC_H */
-- 
1.7.3.5

