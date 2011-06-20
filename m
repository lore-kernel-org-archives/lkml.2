Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232Ab1FTNhI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 09:37:08 -0400
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:7627
	"EHLO AM1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753358Ab1FTNhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 09:37:06 -0400
X-SpamScore: 7
X-BigFish: VPS7(zzzz1202h10d2nzz8275bhz32i2a8h668h839h66h)
X-Spam-TCS-SCL: 5:0
X-Forefront-Antispam-Report: CIP:203.197.93.240;KIP:(null);UIP:(null);IPVD:NLI;H:Kcinpunhjhc01.kpit.com;RD:Kcinpunhjhc01.kpit.com;EFVD:NLI
Subject: [PATCHv5 6/11] HWMON: moved DA9052 battery temperature lookup
 table to a common place
From: ashishj3 <ashish.jangam@kpitcummins.com>
To: <guenter.roeck@ericsson.com>
CC: <randy.dunlap@oracle.com>, <linux-kernel@vger.kernel.org>,
        <lm-sensors@lm-sensors.org>, <dchen@diasemi.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 20 Jun 2011 19:06:37 +0530
Message-ID: <1308576997.3180.130.camel@L-0532.kpit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Dajun Chen <dchen@diasemi.com>
Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
---
Changes since v4:
- DA9052 battery temperature lookup table tbat_lookup[] is moved to a
common MFD header file were both Battery and Hwmon module can access
it. 
- tbat_lookup[] table is now in mill degree celsius.
- removed couple of intermidate temporary variables.
- removed extra blank lines.
- used common path error handling.
- couple of code formatting errors. 
diff --git a/drivers/hwmon/da9052-hwmon.c b/drivers/hwmon/da9052-hwmon.c
index 0e54508..f7797dc 100755
--- a/drivers/hwmon/da9052-hwmon.c
+++ b/drivers/hwmon/da9052-hwmon.c
@@ -29,6 +29,7 @@ struct da9052_hwmon {
 	struct device	*class_device;
 	struct mutex	hwmon_lock;
 };
+
 static const char * const input_names[] = {
 	[DA9052_ADC_VDDOUT]	=	"VDDOUT",
 	[DA9052_ADC_ICH]	=	"CHARGING CURRENT",
@@ -41,40 +42,6 @@ static const char * const input_names[] = {
 	[DA9052_ADC_VBBAT]	=	"BACK-UP BATTERY VOLTAGE",
 };
 
-/*
- * TBAT look-up table is computed from the R90 reg (8 bit register)
- * reading as below.
- * TBAT = 1/(t1+1/298) - 273
- * where t1 = (1/B)* ln(( ADCval * 2.5)/(R25*ITBAT*255))
- * Default values are R25 = 10e3, B = 3380, ITBAT = 50e-6
- * Example:
- * R25=10E3, B=3380, ITBAT=50e-6, ADCVAL=62d calculates
- * TBAT = 20 degrees Centrigrade
- * For R90 reading of 0, a value of -1 is returned, as log of 0
- * is undefined.
-*/
-static const int8_t tbat_lookup[] = {
-	-1, 183, 144, 124, 111, 102, 94,  88,  83,  79,  75,  72,  69,  66,  63,
-	61,  59,  57,  55,  53,  52,  50,  49,  48,  46,  45,  44,  43,  42,
-	41,  40,  39,  38,  37,  36,  35,  35,  34,  33,  32,  32,  31,  30,
-	30,  29,  28,  28,  27,  27,  26,  26,  25,  25,  24,  24,  23,  23,
-	22,  22,  21,  21,  20,  20,  20,  19,  19,  18,  18,  18,  17,  17,
-	17,  16,  16,  16,  15,  15,  15,  14,  14,  14,  13,  13,  13,  12,
-	12,  12,  12,  11,  11,  11,  11,  10,  10,  10,  10,  9,   9,   9,
-	9,   8,   8,   8,   8,   7,   7,   7,   7,   7,   6,   6,   6,   6,
-	6,   5,   5,   5,   5,   5,   4,   4,   4,   4,   4,   3,   3,   3,
-	3,   3,   3,   2,   2,   2,   2,   2,   1,   1,   1,   1,   1,   1,
-	1,   0,   0,   0,   0,   0,   0,   -1,  -1,  -1,  -1,  -1,  -1,  -1,
-	-2,  -2,  -2,  -2,  -2,  -2,  -2,  -3,  -3,  -3,  -3,  -3,  -3,  -3,
-	-3,  -4,  -4,  -4,  -4,  -4,  -4,  -4,   -4, -5,  -5,  -5,  -5,  -5,
-	-5,  -5,  -5,  -5,  -6,  -6,  -6,  -6,  -6,  -6,  -6,  -6,  -6,  -7,
-	-7,  -7,  -7,  -7,  -7,  -7,  -7,  -7,  -8,  -8,  -8,  -8,  -8,  -8,
-	-8,  -8,  -8,  -8,  -8,  -9,  -9,  -9,  -9,  -9,  -9,  -9,  -9,  -9,
-	-9,  -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -11,
-	-11, -11, -11, -11, -11, -11, -11, -11, -11, -11, -12, -12, -12, -12,
-	-12, -12, -12
-};
-
 static int da9052_enable_vddout_channel(struct da9052 *da9052)
 {
 	int ret;
@@ -84,6 +51,7 @@ static int da9052_enable_vddout_channel(struct da9052 *da9052)
 		return ret;
 
 	ret |= DA9052_ADCCONT_AUTOVDDEN;
+
 	return da9052_reg_write(da9052, DA9052_ADC_CONT_REG, ret);
 }
 
@@ -96,12 +64,12 @@ static int da9052_disable_vddout_channel(struct da9052 *da9052)
 		return ret;
 
 	ret &= ~DA9052_ADCCONT_AUTOVDDEN;
-	return da9052_reg_write(da9052, DA9052_ADC_CONT_REG, ret);
 
+	return da9052_reg_write(da9052, DA9052_ADC_CONT_REG, ret);
 }
 
 static ssize_t da9052_read_vddout(struct device *dev,
-	struct device_attribute *devattr, char *buf)
+				   struct device_attribute *devattr, char *buf)
 {
 	struct da9052_hwmon *hwmon = dev_get_drvdata(dev);
 	int ret, vdd = -1;
@@ -126,13 +94,14 @@ static ssize_t da9052_read_vddout(struct device *dev,
 		mutex_unlock(&hwmon->hwmon_lock);
 		return sprintf(buf, "%d\n", vdd);
 	}
+
 hwmon_err:
 	mutex_unlock(&hwmon->hwmon_lock);
 	return ret;
 }
 
 static ssize_t da9052_read_ich(struct device *dev,
-	struct device_attribute *devattr, char *buf)
+				struct device_attribute *devattr, char *buf)
 {
 	struct da9052_hwmon *hwmon = dev_get_drvdata(dev);
 	int ret;
@@ -142,21 +111,15 @@ static ssize_t da9052_read_ich(struct device *dev,
 		return ret;
 
 	/* Equivalent to 3.9mA/bit in register ICHG_AV */
-	ret = DIV_ROUND_CLOSEST(ret * 39, 10);
-	return sprintf(buf, "%d\n", ret);
+	return sprintf(buf, "%d\n", DIV_ROUND_CLOSEST(ret * 39, 10));
 }
 
 static ssize_t da9052_read_tbat(struct device *dev,
-			struct device_attribute *devattr, char *buf)
+				 struct device_attribute *devattr, char *buf)
 {
 	struct da9052_hwmon *hwmon = dev_get_drvdata(dev);
-	int ret, tbat;
 
-	ret = da9052_reg_read(hwmon->da9052, DA9052_TBAT_RES_REG);
-	if (ret < 0)
-		return ret;
-	tbat = tbat_lookup[ret];
-	return sprintf(buf, "%d\n", (tbat*1000));
+	return sprintf(buf, "%d\n", da9052_adc_temperature_read(hwmon->da9052));
 }
 
 static ssize_t da9052_read_vbat(struct device *dev,
@@ -173,7 +136,8 @@ static ssize_t da9052_read_vbat(struct device *dev,
 }
 
 static ssize_t da9052_read_misc_channel(struct device *dev,
-	struct device_attribute *devattr, char *buf)
+					 struct device_attribute *devattr,
+					 char *buf)
 {
 	struct da9052_hwmon *hwmon = dev_get_drvdata(dev);
 	int channel = to_sensor_dev_attr(devattr)->index;
@@ -187,29 +151,25 @@ static ssize_t da9052_read_misc_channel(struct device *dev,
 }
 
 static ssize_t da9052_read_tjunc(struct device *dev,
-	struct device_attribute *devattr, char *buf)
+				  struct device_attribute *devattr, char *buf)
 {
 	struct da9052_hwmon *hwmon = dev_get_drvdata(dev);
-	int temp;
-	int ret;
+	int tjunc, toffset;
 
-	ret = da9052_reg_read(hwmon->da9052, DA9052_TJUNC_RES_REG);
-	if (ret < 0)
-		return ret;
+	tjunc = da9052_reg_read(hwmon->da9052, DA9052_TJUNC_RES_REG);
+	if (tjunc < 0)
+		return tjunc;
 
-	temp = ret;
-
-	ret = da9052_reg_read(hwmon->da9052, DA9052_T_OFFSET_REG);
-	if (ret < 0)
-		return ret;
+	toffset = da9052_reg_read(hwmon->da9052, DA9052_T_OFFSET_REG);
+	if (toffset < 0)
+		return toffset;
 
 	/* Degrees celsius = 1.708 * (TJUNC_RES - T_OFFSET) - 108.8 */
-	ret = 1708 * (temp - ret) - 108800;
-	return sprintf(buf, "%d\n", ret);
+	return sprintf(buf, "%d\n", 1708 * (tjunc - toffset) - 108800);
 }
 
 static ssize_t da9052_read_vbbat(struct device *dev,
-	struct device_attribute *devattr, char *buf)
+				  struct device_attribute *devattr, char *buf)
 {
 	struct da9052_hwmon *hwmon = dev_get_drvdata(dev);
 	int ret;
@@ -223,7 +183,8 @@ static ssize_t da9052_read_vbbat(struct device *dev,
 }
 
 static ssize_t da9052_hwmon_show_name(struct device *dev,
-		struct device_attribute *devattr, char *buf)
+				       struct device_attribute *devattr,
+				       char *buf)
 {
 	return sprintf(buf, "da9052-hwmon\n");
 }
@@ -232,47 +193,47 @@ static ssize_t show_label(struct device *dev,
 			  struct device_attribute *devattr, char *buf)
 {
 	return sprintf(buf, "%s\n",
-			input_names[to_sensor_dev_attr(devattr)->index]);
+		       input_names[to_sensor_dev_attr(devattr)->index]);
 }
 
 static SENSOR_DEVICE_ATTR(in0_input, S_IRUGO, da9052_read_vddout, NULL,
-				DA9052_ADC_ICH);
+			   DA9052_ADC_ICH);
 static SENSOR_DEVICE_ATTR(in0_label, S_IRUGO, show_label, NULL,
-				DA9052_ADC_ICH);
+			   DA9052_ADC_ICH);
 static SENSOR_DEVICE_ATTR(in3_input, S_IRUGO, da9052_read_vbat, NULL,
-				DA9052_ADC_VBAT);
+			   DA9052_ADC_VBAT);
 static SENSOR_DEVICE_ATTR(in3_label, S_IRUGO, show_label, NULL,
-				DA9052_ADC_VBAT);
+			   DA9052_ADC_VBAT);
 static SENSOR_DEVICE_ATTR(in4_input, S_IRUGO, da9052_read_misc_channel, NULL,
-				DA9052_ADC_IN4);
+			   DA9052_ADC_IN4);
 static SENSOR_DEVICE_ATTR(in4_label, S_IRUGO, show_label, NULL,
-				DA9052_ADC_IN4);
+			   DA9052_ADC_IN4);
 static SENSOR_DEVICE_ATTR(in5_input, S_IRUGO, da9052_read_misc_channel, NULL,
-				DA9052_ADC_IN5);
+			   DA9052_ADC_IN5);
 static SENSOR_DEVICE_ATTR(in5_label, S_IRUGO, show_label, NULL,
-				DA9052_ADC_IN5);
+			   DA9052_ADC_IN5);
 static SENSOR_DEVICE_ATTR(in6_input, S_IRUGO, da9052_read_misc_channel, NULL,
-				DA9052_ADC_IN6);
+			   DA9052_ADC_IN6);
 static SENSOR_DEVICE_ATTR(in6_label, S_IRUGO, show_label, NULL,
-				DA9052_ADC_IN6);
+			   DA9052_ADC_IN6);
 static SENSOR_DEVICE_ATTR(in9_input, S_IRUGO, da9052_read_vbbat, NULL,
-				DA9052_ADC_VBBAT);
+			   DA9052_ADC_VBBAT);
 static SENSOR_DEVICE_ATTR(in9_label, S_IRUGO, show_label, NULL,
-				DA9052_ADC_VBBAT);
+			   DA9052_ADC_VBBAT);
+
 static SENSOR_DEVICE_ATTR(curr1_input, S_IRUGO, da9052_read_ich, NULL,
-				DA9052_ADC_ICH);
+			   DA9052_ADC_ICH);
 static SENSOR_DEVICE_ATTR(curr1_label, S_IRUGO, show_label, NULL,
-				DA9052_ADC_ICH);
+			   DA9052_ADC_ICH);
 
 static SENSOR_DEVICE_ATTR(temp1_input, S_IRUGO, da9052_read_tbat, NULL,
-				DA9052_ADC_TBAT);
+			   DA9052_ADC_TBAT);
 static SENSOR_DEVICE_ATTR(temp1_label, S_IRUGO, show_label, NULL,
-				DA9052_ADC_TBAT);
-
+			   DA9052_ADC_TBAT);
 static SENSOR_DEVICE_ATTR(temp2_input, S_IRUGO, da9052_read_tjunc, NULL,
-				DA9052_ADC_TJUNC);
+			   DA9052_ADC_TJUNC);
 static SENSOR_DEVICE_ATTR(temp2_label, S_IRUGO, show_label, NULL,
-				DA9052_ADC_TJUNC);
+			   DA9052_ADC_TJUNC);
 
 static DEVICE_ATTR(name, S_IRUGO, da9052_hwmon_show_name, NULL);
 
@@ -323,12 +284,13 @@ static int __init da9052_hwmon_probe(struct platform_device *pdev)
 	hwmon->class_device = hwmon_device_register(&pdev->dev);
 	if (IS_ERR(hwmon->class_device)) {
 		ret = PTR_ERR(hwmon->class_device);
-		sysfs_remove_group(&pdev->dev.kobj, &da9052_attr_group);
-		goto err_mem;
+		goto err_sysfs;
 	}
 
 	return 0;
 
+err_sysfs:
+	sysfs_remove_group(&pdev->dev.kobj, &da9052_attr_group);
 err_mem:
 	kfree(hwmon);
 	return ret;
@@ -340,24 +302,22 @@ static int __devexit da9052_hwmon_remove(struct platform_device *pdev)
 
 	hwmon_device_unregister(hwmon->class_device);
 	sysfs_remove_group(&pdev->dev.kobj, &da9052_attr_group);
-	mutex_destroy(&hwmon->hwmon_lock);
 	kfree(hwmon);
+
 	return 0;
 }
 
 static struct platform_driver da9052_hwmon_driver = {
+		.probe = da9052_hwmon_probe,
+		.remove = __devexit_p(da9052_hwmon_remove),
 	.driver = {
-		.name	= "da9052-hwmon",
-		.owner	= THIS_MODULE,
+		.name = "da9052-hwmon",
+		.owner = THIS_MODULE,
 	},
-	.probe		= da9052_hwmon_probe,
-	.remove		= __devexit_p(da9052_hwmon_remove),
-
 };
 
 static int __init da9052_hwmon_init(void)
 {
-
 	return platform_driver_register(&da9052_hwmon_driver);
 }
 module_init(da9052_hwmon_init);
@@ -370,7 +330,5 @@ module_exit(da9052_hwmon_exit);
 
 MODULE_AUTHOR("David Dajun Chen <dchen@diasemi.com>");
 MODULE_DESCRIPTION("DA9052 HWMON driver");
-MODULE_LICENSE("GPL v2");
+MODULE_LICENSE("GPL");
 MODULE_ALIAS("platform:da9052-hwmon");
-
-


