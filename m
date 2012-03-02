Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030193Ab2CBOiD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 09:38:03 -0500
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:10258
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757783Ab2CBOiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 09:38:00 -0500
X-SpamScore: 11
X-BigFish: VPS11(zzzz1202hzz8275bh11f642sz2dh2a8h668h839h93fh)
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPV:NLI;H:Outbound.kpitcummins.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
Subject: [PATCH 01/03] MFD: add ADC support to DA9052/53 MFD  core v2
From: Ashish Jangam <ashish.jangam@kpitcummins.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: <linux-kernel@vger.kernel.org>, Dajun <dajun.chen@diasemi.com>,
        <arnd@arndb.de>, <sameo@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 2 Mar 2012 19:58:53 +0530
Message-ID: <1330698533.21817.30.camel@dhruva>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.38.47]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add ADC support for DA9052/53 MFD core so that its dependent
components like Battery & HWMON can read required values from ADC
channel.

This patch is functionally tested on Samsung SMDKV6410.

Signed-off-by: David Dajun Chen <dchen@diasemi.com>
Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
---
Changes since v1
- Move global variable in to struct da9052
- Pass da9052 pointer instead of NULL in request_threaded_irq call
--- 
drivers/mfd/da9052-core.c         |  136 +++++++++++++++++++++++++++++++++++++
 include/linux/mfd/da9052/da9052.h |   20 ++++++
 2 files changed, 156 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/da9052-core.c b/drivers/mfd/da9052-core.c
index 7ff313f..a2b5b32 100644
--- a/drivers/mfd/da9052-core.c
+++ b/drivers/mfd/da9052-core.c
@@ -318,6 +318,130 @@ static bool da9052_reg_volatile(struct device *dev, unsigned int reg)
 	}
 }
 
+/*
+ * TBAT look-up table is computed from the R90 reg (8 bit register)
+ * reading as below. The battery temperature is in milliCentigrade
+ * TBAT = (1/(t1+1/298) - 273) * 1000 mC
+ * where t1 = (1/B)* ln(( ADCval * 2.5)/(R25*ITBAT*255))
+ * Default values are R25 = 10e3, B = 3380, ITBAT = 50e-6
+ * Example:
+ * R25=10E3, B=3380, ITBAT=50e-6, ADCVAL=62d calculates
+ * TBAT = 20015 mili degrees Centrigrade
+ *
+*/
+static const int32_t tbat_lookup[255] = {
+	183258, 144221, 124334, 111336, 101826, 94397, 88343, 83257,
+	78889, 75071, 71688, 68656, 65914, 63414, 61120, 59001,
+	570366, 55204, 53490, 51881, 50364, 48931, 47574, 46285,
+	45059, 43889, 42772, 41703, 40678, 39694, 38748, 37838,
+	36961, 36115, 35297, 34507, 33743, 33002, 32284, 31588,
+	30911, 30254, 29615, 28994, 28389, 27799, 27225, 26664,
+	26117, 25584, 25062, 24553, 24054, 23567, 23091, 22624,
+	22167, 21719, 21281, 20851, 20429, 20015, 19610, 19211,
+	18820, 18436, 18058, 17688, 17323, 16965, 16612, 16266,
+	15925, 15589, 15259, 14933, 14613, 14298, 13987, 13681,
+	13379, 13082, 12788, 12499, 12214, 11933, 11655, 11382,
+	11112, 10845, 10582, 10322, 10066, 9812, 9562, 9315,
+	9071, 8830, 8591, 8356, 8123, 7893, 7665, 7440,
+	7218, 6998, 6780, 6565, 6352, 6141, 5933, 5726,
+	5522, 5320, 5120, 4922, 4726, 4532, 4340, 4149,
+	3961, 3774, 3589, 3406, 3225, 3045, 2867, 2690,
+	2516, 2342, 2170, 2000, 1831, 1664, 1498, 1334,
+	1171, 1009, 849, 690, 532, 376, 221, 67,
+	-84, -236, -386, -535, -683, -830, -975, -1119,
+	-1263, -1405, -1546, -1686, -1825, -1964, -2101, -2237,
+	-2372, -2506, -2639, -2771, -2902, -3033, -3162, -3291,
+	-3418, -3545, -3671, -3796, -3920, -4044, -4166, -4288,
+	-4409, -4529, -4649, -4767, -4885, -5002, -5119, -5235,
+	-5349, -5464, -5577, -5690, -5802, -5913, -6024, -6134,
+	-6244, -6352, -6461, -6568, -6675, -6781, -6887, -6992,
+	-7096, -7200, -7303, -7406, -7508, -7609, -7710, -7810,
+	-7910, -8009, -8108, -8206, -8304, -8401, -8497, -8593,
+	-8689, -8784, -8878, -8972, -9066, -9159, -9251, -9343,
+	-9435, -9526, -9617, -9707, -9796, -9886, -9975, -10063,
+	-10151, -10238, -10325, -10412, -10839, -10923, -11007, -11090,
+	-11173, -11256, -11338, -11420, -11501, -11583, -11663, -11744,
+	-11823, -11903, -11982
+};
+
+static const u8 chan_mux[DA9052_ADC_VBBAT + 1] = {
+	[DA9052_ADC_VDDOUT]	= DA9052_ADC_MAN_MUXSEL_VDDOUT,
+	[DA9052_ADC_ICH]	= DA9052_ADC_MAN_MUXSEL_ICH,
+	[DA9052_ADC_TBAT]	= DA9052_ADC_MAN_MUXSEL_TBAT,
+	[DA9052_ADC_VBAT]	= DA9052_ADC_MAN_MUXSEL_VBAT,
+	[DA9052_ADC_IN4]	= DA9052_ADC_MAN_MUXSEL_AD4,
+	[DA9052_ADC_IN5]	= DA9052_ADC_MAN_MUXSEL_AD5,
+	[DA9052_ADC_IN6]	= DA9052_ADC_MAN_MUXSEL_AD6,
+	[DA9052_ADC_VBBAT]	= DA9052_ADC_MAN_MUXSEL_VBBAT
+};
+
+int da9052_adc_manual_read(struct da9052 *da9052, unsigned char channel)
+{
+	int ret;
+	unsigned short calc_data;
+	unsigned short data;
+	unsigned char mux_sel;
+
+	if (channel > DA9052_ADC_VBBAT)
+		return -EINVAL;
+
+	mutex_lock(&da9052->auxadc_lock);
+
+	/* Channel gets activated on enabling the Conversion bit */
+	mux_sel = chan_mux[channel] | DA9052_ADC_MAN_MAN_CONV;
+
+	ret = da9052_reg_write(da9052, DA9052_ADC_MAN_REG, mux_sel);
+	if (ret < 0)
+		goto err;
+
+	/* Wait for an interrupt */
+	wait_for_completion_timeout(&da9052->done, msecs_to_jiffies(500));
+
+	ret = da9052_reg_read(da9052, DA9052_ADC_RES_H_REG);
+	if (ret < 0)
+		goto err;
+
+	calc_data = (unsigned short)ret;
+	data = calc_data << 2;
+
+	ret = da9052_reg_read(da9052, DA9052_ADC_RES_L_REG);
+	if (ret < 0)
+		goto err;
+
+	calc_data = (unsigned short)(ret & DA9052_ADC_RES_LSB);
+	data |= calc_data;
+
+	ret = data;
+
+err:
+	mutex_unlock(&da9052->auxadc_lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(da9052_adc_manual_read);
+
+static irqreturn_t da9052_auxadc_irq(int irq, void *irq_data)
+{
+	struct da9052 *da9052 = irq_data;
+
+	complete(&da9052->done);
+
+	return IRQ_HANDLED;
+}
+
+int da9052_adc_read_temp(struct da9052 *da9052)
+{
+	int tbat;
+
+	tbat = da9052_reg_read(da9052, DA9052_TBAT_RES_REG);
+
+	if (tbat < 0)
+		return tbat;
+
+	/* ARRAY_SIZE check is not needed since TBAT is a 8-bit register */
+	return tbat_lookup[tbat - 1];
+}
+EXPORT_SYMBOL_GPL(da9052_adc_read_temp);
+
 static struct resource da9052_rtc_resource = {
 	.name = "ALM",
 	.start = DA9052_IRQ_ALARM,
@@ -646,6 +770,10 @@ int __devinit da9052_device_init(struct da9052 *da9052, u8 chip_id)
 	struct irq_desc *desc;
 	int ret;
 
+	mutex_init(&da9052->io_lock);
+	mutex_init(&da9052->auxadc_lock);
+	init_completion(&da9052->done);
+
 	if (pdata && pdata->init != NULL)
 		pdata->init(da9052);
 
@@ -666,6 +794,12 @@ int __devinit da9052_device_init(struct da9052 *da9052, u8 chip_id)
 	desc = irq_to_desc(da9052->chip_irq);
 	da9052->irq_base = regmap_irq_chip_get_base(desc->action->dev_id);
 
+	ret = request_threaded_irq(DA9052_IRQ_ADC_EOM, NULL, da9052_auxadc_irq,
+				   IRQF_TRIGGER_LOW | IRQF_ONESHOT,
+				   "adc irq", da9052);
+	if (ret != 0)
+		dev_err(da9052->dev, "DA9052 ADC IRQ failed ret=%d\n", ret);
+
 	ret = mfd_add_devices(da9052->dev, -1, da9052_subdev_info,
 			      ARRAY_SIZE(da9052_subdev_info), NULL, 0);
 	if (ret)
@@ -674,6 +808,7 @@ int __devinit da9052_device_init(struct da9052 *da9052, u8 chip_id)
 	return 0;
 
 err:
+	free_irq(DA9052_IRQ_ADC_EOM, da9052);
 	mfd_remove_devices(da9052->dev);
 regmap_err:
 	return ret;
@@ -681,6 +816,7 @@ regmap_err:
 
 void da9052_device_exit(struct da9052 *da9052)
 {
+	free_irq(DA9052_IRQ_ADC_EOM, da9052);
 	regmap_del_irq_chip(da9052->chip_irq,
 			    irq_get_irq_data(da9052->irq_base)->chip_data);
 	mfd_remove_devices(da9052->dev);
diff --git a/include/linux/mfd/da9052/da9052.h b/include/linux/mfd/da9052/da9052.h
index 7ffbd6e..5dd26a7 100644
--- a/include/linux/mfd/da9052/da9052.h
+++ b/include/linux/mfd/da9052/da9052.h
@@ -33,6 +33,18 @@
 
 #include <linux/mfd/da9052/reg.h>
 
+/* HWMON Channel Definations */
+#define DA9052_ADC_VDDOUT	0
+#define DA9052_ADC_ICH		1
+#define DA9052_ADC_TBAT	2
+#define DA9052_ADC_VBAT	3
+#define DA9052_ADC_IN4		4
+#define DA9052_ADC_IN5		5
+#define DA9052_ADC_IN6		6
+#define DA9052_ADC_TSI		7
+#define DA9052_ADC_TJUNC	8
+#define DA9052_ADC_VBBAT	9
+
 #define DA9052_IRQ_DCIN	0
 #define DA9052_IRQ_VBUS	1
 #define DA9052_IRQ_DCINREM	2
@@ -76,8 +88,12 @@ enum da9052_chip_id {
 struct da9052_pdata;
 
 struct da9052 {
+	struct mutex io_lock;
+	struct mutex auxadc_lock;
+
 	struct device *dev;
 	struct regmap *regmap;
+	struct completion done;
 
 	int irq_base;
 	u8 chip_id;
@@ -85,6 +101,10 @@ struct da9052 {
 	int chip_irq;
 };
 
+/* ADC API */
+int da9052_adc_manual_read(struct da9052 *da9052, unsigned char channel);
+int da9052_adc_read_temp(struct da9052 *da9052);
+
 /* Device I/O API */
 static inline int da9052_reg_read(struct da9052 *da9052, unsigned char reg)
 {





This message contains information that may be privileged or confidential and is the property of the KPIT Cummins Infosystems Ltd. It is intended only for the person to whom it is addressed. If you are not the intended recipient, you are not authorized to read, print, retain copy, disseminate, distribute, or use this message or any part thereof. If you receive this message in error, please notify the sender immediately and delete all copies of this message. KPIT Cummins Infosystems Ltd. does not accept any liability for virus infected mails.


