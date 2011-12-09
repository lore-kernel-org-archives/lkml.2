Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221Ab1LIOTi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 09:19:38 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:33743 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443Ab1LIOTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 09:19:37 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh2a8h668h839h93fh66h)
X-Spam-TCS-SCL: 5:0
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPV:NLI;H:Outbound.kpitcummins.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
Subject: [PATCH 02/06] MFD: DA9052/53 MFD core module v9 Added ADC support
From: Ashish Jangam <ashish.jangam@kpitcummins.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: <linux-kernel@vger.kernel.org>, Dajun <dajun.chen@diasemi.com>,
        <arnd@arndb.de>, <linaro-dev@lists.linaro.org>, <eric.miao@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 9 Dec 2011 19:46:06 +0530
Message-ID: <1323440166.23171.70.camel@dhruva>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.38.47]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DA9052/53 is a highly integrated PMIC subsystem with supply domain
flexibility to support wide range of high performance application.

It provides voltage regulators, GPIO controller, Touch Screen, RTC, Battery
control and other functionality.

This patch is functionally tested on Samsung SMDKV6410.

Signed-off-by: David Dajun Chen <dchen@diasemi.com>
Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
---
 drivers/mfd/da9052-core.c         |  187 +++++++++++++++++++++++++++++++++++++
 include/linux/mfd/da9052/da9052.h |   22 +++++
 2 files changed, 209 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/da9052-core.c b/drivers/mfd/da9052-core.c
index 0e12055..99240fa 100644
--- a/drivers/mfd/da9052-core.c
+++ b/drivers/mfd/da9052-core.c
@@ -35,6 +35,161 @@
 #define DA9052_IRQ_MASK_POS_7		0x40
 #define DA9052_IRQ_MASK_POS_8		0x80
 
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
+enum da9052_auxadc {
+	VDDOUT = DA9052_ADC_VDDOUT,
+	ICH = DA9052_ADC_ICH,
+	TBAT = DA9052_ADC_TBAT,
+	VBAT = DA9052_ADC_VBAT,
+	IN4 = DA9052_ADC_IN4,
+	IN5 = DA9052_ADC_IN5,
+	IN6 = DA9052_ADC_IN6,
+	VBBAT = DA9052_ADC_VBBAT,
+};
+
+struct da9052_auxadc_req {
+	struct list_head list;
+	enum da9052_auxadc input;
+	struct completion done;
+};
+
+int da9052_adc_manual_read(struct da9052 *da9052, unsigned char channel)
+{
+	struct da9052_auxadc_req *req;
+	int ret;
+	unsigned short calc_data;
+	unsigned short data;
+	unsigned char mux_sel;
+
+	req = kzalloc(sizeof(*req), GFP_KERNEL);
+	if (!req)
+		return -ENOMEM;
+
+	init_completion(&req->done);
+	req->input = channel;
+
+	if (channel > DA9052_ADC_VBBAT)
+		return -EINVAL;
+
+	mutex_lock(&da9052->auxadc_lock);
+
+	/* Channel gets activated on enabling the Conversion bit */
+	mux_sel = chan_mux[channel] | DA9052_ADC_MAN_MAN_CONV;
+
+	if (da9052->auxadc_active) {
+		ret = -EBUSY;
+		goto err;
+	}
+
+	/* Enqueue the request */
+	list_add(&req->list, &da9052->auxadc_pending);
+
+	ret = da9052_reg_write(da9052, DA9052_ADC_MAN_REG, mux_sel);
+	if (ret < 0)
+		goto err;
+
+	da9052->auxadc_active = channel;
+
+	mutex_unlock(&da9052->auxadc_lock);
+
+	/* Wait for an interrupt */
+	wait_for_completion_timeout(&req->done, msecs_to_jiffies(500));
+
+	mutex_lock(&da9052->auxadc_lock);
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
+	list_del(&req->list);
+err:
+	mutex_unlock(&da9052->auxadc_lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(da9052_adc_manual_read);
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
@@ -309,6 +464,25 @@ static struct regmap_irq_chip da9052_regmap_irq_chip = {
 	.num_irqs = ARRAY_SIZE(da9052_irqs),
 };
 
+static irqreturn_t da9052_auxadc_irq(int irq, void *irq_data)
+{
+	struct da9052 *da9052 = irq_data;
+	struct da9052_auxadc_req *req;
+
+	mutex_lock(&da9052->auxadc_lock);
+
+	/* Wake up any threads waiting for this request */
+	list_for_each_entry(req, &da9052->auxadc_pending, list) {
+		if (req->input == da9052->auxadc_active)
+			complete(&req->done);
+	}
+	da9052->auxadc_active  = 0;
+
+	mutex_unlock(&da9052->auxadc_lock);
+
+	return IRQ_HANDLED;
+}
+
 int da9052_device_init(struct da9052 *da9052, u8 chip_id)
 {
 	struct da9052_pdata *pdata = da9052->dev->platform_data;
@@ -316,11 +490,15 @@ int da9052_device_init(struct da9052 *da9052, u8 chip_id)
 	int ret;
 
 	mutex_init(&da9052->io_lock);
+	mutex_init(&da9052->auxadc_lock);
+
+	INIT_LIST_HEAD(&da9052->auxadc_pending);
 
 	if (pdata && pdata->init != NULL)
 		pdata->init(da9052);
 
 	da9052->chip_id = chip_id;
+	da9052->auxadc_active = 0;
 
 	if (!pdata && !pdata->irq_base)
 		da9052->irq_base = -1;
@@ -341,6 +519,15 @@ int da9052_device_init(struct da9052 *da9052, u8 chip_id)
 	desc = irq_to_desc(da9052->chip_irq);
 	da9052->irq_base = regmap_irq_chip_get_base(desc->action->dev_id);
 
+	ret = request_threaded_irq(da9052->irq_base + DA9052_IRQ_ADC_EOM,
+				   NULL, da9052_auxadc_irq,
+				   IRQF_TRIGGER_LOW | IRQF_ONESHOT,
+				   "adc irq", da9052);
+	if (ret != 0) {
+		dev_err(da9052->dev, "DA9052 ADC IRQ failed ret=%d\n", ret);
+		da9052->auxadc_active = -1;
+	}
+
 	ret = mfd_add_devices(da9052->dev, -1, da9052_subdev_info,
 			      ARRAY_SIZE(da9052_subdev_info), NULL, 0);
 	if (ret)
diff --git a/include/linux/mfd/da9052/da9052.h b/include/linux/mfd/da9052/da9052.h
index f53b77a..a4db9b8 100644
--- a/include/linux/mfd/da9052/da9052.h
+++ b/include/linux/mfd/da9052/da9052.h
@@ -33,6 +33,20 @@
 
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
+#define DA9052_MASK_ADC_EOM	0x2000
+
 #define DA9052_IRQ_DCIN	0
 #define DA9052_IRQ_VBUS	1
 #define DA9052_IRQ_DCINREM	2
@@ -77,17 +91,25 @@ struct da9052_pdata;
 
 struct da9052 {
 	struct mutex io_lock;
+	struct mutex auxadc_lock;
 
 	struct device *dev;
 	struct i2c_client *i2c_client;
 	struct regmap *regmap;
 
+	struct list_head auxadc_pending;
+	u8 auxadc_active;
+
 	int irq_base;
 	u8 chip_id;
 
 	int chip_irq;
 };
 
+/* ADC API */
+int da9052_adc_manual_read(struct da9052 *da9052, unsigned char channel);
+int da9052_adc_read_temp(struct da9052 *da9052);
+
 /* Device I/O API */
 static inline int da9052_reg_read(struct da9052 *da9052, unsigned char reg)
 {
-- 
1.7.1


