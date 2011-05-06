Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165Ab1EFWLl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 18:11:41 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:58681 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751395Ab1EFWLj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 18:11:39 -0400
From: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: [RTC] TWL: RTC: Allow rtc driver to be used by tps65910
Date: Fri, 6 May 2011 17:11:32 -0500
Message-Id: <44D3DAB6-0DFE-4F9C-B921-2A9C1EFDCB0D@slimlogic.co.uk>
Cc: lrg@ti.com, Graeme Gregory <gg@slimlogic.co.uk>, a.zummo@towertech.it
To: linux-kernel@vger.kernel.org
Mime-Version: 1.0 (Apple Message framework v1084)
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TPS65910 PMIC contains an RTC module. This module is identical to
the one found on TWL chips.

The twl-rtc code should allow other PMICs to use the driver,
avoiding the need to create new drivers for the same modules.

Signed-off-by: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
---
 drivers/mfd/tps65910.c       |   23 ++++-
 drivers/rtc/rtc-twl.c        |  199 ++++++++++++++++++++++++++++++++---------
 include/linux/mfd/tps65910.h |    5 +
 3 files changed, 180 insertions(+), 47 deletions(-)

diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
index 2cf05bb..6206389 100644
--- a/drivers/mfd/tps65910.c
+++ b/drivers/mfd/tps65910.c
@@ -22,6 +22,9 @@
 #include <linux/mfd/core.h>
 #include <linux/mfd/tps65910.h>
 
+#define PMIC_CELL		0
+#define RTC_CELL		1
+
 static struct mfd_cell tps65910s[] = {
 	{
 		.name = "tps65910-pmic",
@@ -39,6 +42,9 @@ static struct mfd_cell tps65911s[] = {
 		.name = "tps65910-pmic",
 	},
 	{
+		.name = "twl_rtc",
+	},
+	{
 		.name = "tps65911-comparator",
 	},
 };
@@ -145,6 +151,7 @@ static int tps65910_i2c_probe(struct i2c_client *i2c,
 	struct tps65910 *tps65910;
 	struct tps65910_board *pmic_plat_data;
 	struct tps65910_platform_data *init_data;
+	struct pmic_data *pmic_data;
 	int ret = 0;
 
 	tps65910->id = id->driver_data;
@@ -164,6 +171,10 @@ static int tps65910_i2c_probe(struct i2c_client *i2c,
 	if (tps65910 == NULL)
 		return -ENOMEM;
 
+	pmic_data = kzalloc(sizeof(struct pmic_data), GFP_KERNEL);
+	if (pmic_data == NULL)
+		return -ENOMEM;
+
 	i2c_set_clientdata(i2c, tps65910);
 	tps65910->dev = &i2c->dev;
 	tps65910->i2c_client = i2c;
@@ -171,14 +182,20 @@ static int tps65910_i2c_probe(struct i2c_client *i2c,
 	tps65910->write = tps65910_i2c_write;
 	mutex_init(&tps65910->io_mutex);
 
-	if (tps65910->id == TPS65910)
+	pmic_data->id = id->driver_data;
+	pmic_data->pmic = tps65910;
+
+	if (tps65910->id == TPS65910) {
+		tps65910s[RTC_CELL].mfd_data = pmic_data;
 		ret = mfd_add_devices(tps65910->dev, -1,
 			      tps65910s, ARRAY_SIZE(tps65910s),
 			      NULL, 0);
-	else if (tps65910->id == TPS65911)
+	} else if (tps65910->id == TPS65911) {
+		tps65911s[RTC_CELL].mfd_data = pmic_data;
 		ret = mfd_add_devices(tps65910->dev, -1,
 				tps65911s, ARRAY_SIZE(tps65911s),
-				NULL, 0);
+				NULL, init_data->irq_base);
+	}
 
 	if (ret < 0)
 		goto err;
diff --git a/drivers/rtc/rtc-twl.c b/drivers/rtc/rtc-twl.c
index f9a2799..8f0f023 100644
--- a/drivers/rtc/rtc-twl.c
+++ b/drivers/rtc/rtc-twl.c
@@ -27,8 +27,10 @@
 #include <linux/bcd.h>
 #include <linux/platform_device.h>
 #include <linux/interrupt.h>
+#include <linux/gpio.h>
 
 #include <linux/i2c/twl.h>
+#include <linux/mfd/tps65910.h>
 
 
 /*
@@ -103,6 +105,34 @@ static const u8 twl6030_rtc_reg_map[] = {
 	[REG_RTC_COMP_LSB_REG] = 0x13,
 	[REG_RTC_COMP_MSB_REG] = 0x14,
 };
+static const u8 tps65910_rtc_reg_map[] = {
+	[REG_SECONDS_REG] = 0x00,
+	[REG_MINUTES_REG] = 0x01,
+	[REG_HOURS_REG] = 0x02,
+	[REG_DAYS_REG] = 0x03,
+	[REG_MONTHS_REG] = 0x04,
+	[REG_YEARS_REG] = 0x05,
+	[REG_WEEKS_REG] = 0x06,
+
+	[REG_ALARM_SECONDS_REG] = 0x08,
+	[REG_ALARM_MINUTES_REG] = 0x09,
+	[REG_ALARM_HOURS_REG] = 0x0A,
+	[REG_ALARM_DAYS_REG] = 0x0B,
+	[REG_ALARM_MONTHS_REG] = 0x0C,
+	[REG_ALARM_YEARS_REG] = 0x0D,
+
+	[REG_RTC_CTRL_REG] = 0x10,
+	[REG_RTC_STATUS_REG] = 0x11,
+	[REG_RTC_INTERRUPTS_REG] = 0x12,
+
+	[REG_RTC_COMP_LSB_REG] = 0x13,
+	[REG_RTC_COMP_MSB_REG] = 0x14,
+
+	/* TODO: Add the following registers for tps 
+	[REG_RTC_RES_PROG_REG] = 0x15,
+	[REG_RTC_RESET_STATUS_REG] = 0x16,
+	*/
+};
 
 /* RTC_CTRL_REG bitfields */
 #define BIT_RTC_CTRL_REG_STOP_RTC_M              0x01
@@ -137,11 +167,18 @@ static u8  *rtc_reg_map;
 /*
  * Supports 1 byte read from TWL RTC register.
  */
-static int twl_rtc_read_u8(u8 *data, u8 reg)
+static int rtc_read_u8(struct pmic_data *pmic_data, u8 *data, u8 reg)
 {
+	struct tps65910 *tps65910;
+	int pmic_id = pmic_data->id;
 	int ret;
 
-	ret = twl_i2c_read_u8(TWL_MODULE_RTC, data, (rtc_reg_map[reg]));
+	if (pmic_id == tps65910_chip_id(tps65910)) {
+		tps65910 = (struct tps65910 *)pmic_data->pmic;
+		ret = tps65910->read(tps65910, (rtc_reg_map[reg]), 1, data);
+	} else {
+		ret = twl_i2c_read_u8(TWL_MODULE_RTC, data, (rtc_reg_map[reg]));
+	}
 	if (ret < 0)
 		pr_err("twl_rtc: Could not read TWL"
 		       "register %X - error %d\n", reg, ret);
@@ -151,15 +188,65 @@ static int twl_rtc_read_u8(u8 *data, u8 reg)
 /*
  * Supports 1 byte write to TWL RTC registers.
  */
-static int twl_rtc_write_u8(u8 data, u8 reg)
+static int rtc_write_u8(struct pmic_data *pmic_data, u8 data, u8 reg)
+{
+	struct tps65910 *tps65910;
+	int pmic_id = pmic_data->id;
+	int ret;
+
+	if (pmic_id == tps65910_chip_id(tps65910)) {
+		tps65910 = (struct tps65910 *)pmic_data->pmic;
+		ret = tps65910->write(tps65910, (rtc_reg_map[reg]), 1, &data);
+	} else {
+		ret = twl_i2c_write_u8(TWL_MODULE_RTC, data,
+					(rtc_reg_map[reg]));
+	}
+	if (ret < 0)
+		pr_err("twl_rtc: Could not write TWL"
+		       "register %X - error %d\n", reg, ret);
+	return ret;
+}
+
+static int rtc_read_array(struct pmic_data *pmic_data,
+				char *data, int size, u8 reg)
 {
+	struct tps65910 *tps65910;
+	int pmic_id = pmic_data->id;
 	int ret;
 
-	ret = twl_i2c_write_u8(TWL_MODULE_RTC, data, (rtc_reg_map[reg]));
+	if (pmic_id == tps65910_chip_id(tps65910)) {
+		tps65910 = (struct tps65910 *)pmic_data->pmic;
+		ret = tps65910->read(tps65910, reg, size, data);
+	} else {
+		ret = twl_i2c_read(TWL_MODULE_RTC, data,
+					(rtc_reg_map[reg]), size);
+	}
+	if (ret < 0)
+		pr_err("twl_rtc: Could not read TWL"
+		       "register %X - error %d\n", reg, ret);
+	return ret;
+
+}
+
+static int rtc_write_array(struct pmic_data *pmic_data,
+				char *data, int size, u8 reg)
+{
+	struct tps65910 *tps65910;
+	int pmic_id = pmic_data->id;
+	int ret;
+
+	if (pmic_id == tps65910_chip_id(tps65910)) {
+		tps65910 = (struct tps65910 *)pmic_data->pmic;
+		ret = tps65910->write(tps65910, reg, size, &data);
+	} else {
+		ret = twl_i2c_write(TWL_MODULE_RTC, data,
+				(rtc_reg_map[reg]), size);
+	}
 	if (ret < 0)
 		pr_err("twl_rtc: Could not write TWL"
 		       "register %X - error %d\n", reg, ret);
 	return ret;
+
 }
 
 /*
@@ -171,14 +258,14 @@ static unsigned char rtc_irq_bits;
 /*
  * Enable 1/second update and/or alarm interrupts.
  */
-static int set_rtc_irq_bit(unsigned char bit)
+static int set_rtc_irq_bit(struct pmic_data *pmic, unsigned char bit)
 {
 	unsigned char val;
 	int ret;
 
 	val = rtc_irq_bits | bit;
 	val &= ~BIT_RTC_INTERRUPTS_REG_EVERY_M;
-	ret = twl_rtc_write_u8(val, REG_RTC_INTERRUPTS_REG);
+	ret = rtc_write_u8(pmic, val, REG_RTC_INTERRUPTS_REG);
 	if (ret == 0)
 		rtc_irq_bits = val;
 
@@ -188,13 +275,13 @@ static int set_rtc_irq_bit(unsigned char bit)
 /*
  * Disable update and/or alarm interrupts.
  */
-static int mask_rtc_irq_bit(unsigned char bit)
+static int mask_rtc_irq_bit(struct pmic_data *pmic, unsigned char bit)
 {
 	unsigned char val;
 	int ret;
 
 	val = rtc_irq_bits & ~bit;
-	ret = twl_rtc_write_u8(val, REG_RTC_INTERRUPTS_REG);
+	ret = rtc_write_u8(pmic, val, REG_RTC_INTERRUPTS_REG);
 	if (ret == 0)
 		rtc_irq_bits = val;
 
@@ -203,12 +290,13 @@ static int mask_rtc_irq_bit(unsigned char bit)
 
 static int twl_rtc_alarm_irq_enable(struct device *dev, unsigned enabled)
 {
+	struct pmic_data *pmic = dev_get_platdata(dev);
 	int ret;
 
 	if (enabled)
-		ret = set_rtc_irq_bit(BIT_RTC_INTERRUPTS_REG_IT_ALARM_M);
+		ret = set_rtc_irq_bit(pmic, BIT_RTC_INTERRUPTS_REG_IT_ALARM_M);
 	else
-		ret = mask_rtc_irq_bit(BIT_RTC_INTERRUPTS_REG_IT_ALARM_M);
+		ret = mask_rtc_irq_bit(pmic, BIT_RTC_INTERRUPTS_REG_IT_ALARM_M);
 
 	return ret;
 }
@@ -224,22 +312,23 @@ static int twl_rtc_alarm_irq_enable(struct device *dev, unsigned enabled)
  */
 static int twl_rtc_read_time(struct device *dev, struct rtc_time *tm)
 {
+	struct pmic_data *pmic = dev_get_platdata(dev);
 	unsigned char rtc_data[ALL_TIME_REGS + 1];
 	int ret;
 	u8 save_control;
 
-	ret = twl_rtc_read_u8(&save_control, REG_RTC_CTRL_REG);
+	ret = rtc_read_u8(pmic, &save_control, REG_RTC_CTRL_REG);
 	if (ret < 0)
 		return ret;
 
 	save_control |= BIT_RTC_CTRL_REG_GET_TIME_M;
 
-	ret = twl_rtc_write_u8(save_control, REG_RTC_CTRL_REG);
+	ret = rtc_write_u8(pmic, save_control, REG_RTC_CTRL_REG);
 	if (ret < 0)
 		return ret;
 
-	ret = twl_i2c_read(TWL_MODULE_RTC, rtc_data,
-			(rtc_reg_map[REG_SECONDS_REG]), ALL_TIME_REGS);
+	ret = rtc_read_array(pmic, rtc_data, ALL_TIME_REGS,
+					rtc_reg_map[REG_SECONDS_REG]);
 
 	if (ret < 0) {
 		dev_err(dev, "rtc_read_time error %d\n", ret);
@@ -258,8 +347,9 @@ static int twl_rtc_read_time(struct device *dev, struct rtc_time *tm)
 
 static int twl_rtc_set_time(struct device *dev, struct rtc_time *tm)
 {
+	struct pmic_data *pmic = dev_get_platdata(dev);
 	unsigned char save_control;
-	unsigned char rtc_data[ALL_TIME_REGS + 1];
+	char rtc_data[ALL_TIME_REGS + 1];
 	int ret;
 
 	rtc_data[1] = bin2bcd(tm->tm_sec);
@@ -270,18 +360,18 @@ static int twl_rtc_set_time(struct device *dev, struct rtc_time *tm)
 	rtc_data[6] = bin2bcd(tm->tm_year - 100);
 
 	/* Stop RTC while updating the TC registers */
-	ret = twl_rtc_read_u8(&save_control, REG_RTC_CTRL_REG);
+	ret = rtc_read_u8(pmic, &save_control, REG_RTC_CTRL_REG);
 	if (ret < 0)
 		goto out;
 
 	save_control &= ~BIT_RTC_CTRL_REG_STOP_RTC_M;
-	twl_rtc_write_u8(save_control, REG_RTC_CTRL_REG);
+	ret = rtc_write_u8(pmic, save_control, REG_RTC_CTRL_REG);
 	if (ret < 0)
 		goto out;
 
 	/* update all the time registers in one shot */
-	ret = twl_i2c_write(TWL_MODULE_RTC, rtc_data,
-		(rtc_reg_map[REG_SECONDS_REG]), ALL_TIME_REGS);
+	ret = rtc_write_array(pmic, rtc_data, ALL_TIME_REGS,
+				rtc_reg_map[REG_SECONDS_REG]);
 	if (ret < 0) {
 		dev_err(dev, "rtc_set_time error %d\n", ret);
 		goto out;
@@ -289,7 +379,7 @@ static int twl_rtc_set_time(struct device *dev, struct rtc_time *tm)
 
 	/* Start back RTC */
 	save_control |= BIT_RTC_CTRL_REG_STOP_RTC_M;
-	ret = twl_rtc_write_u8(save_control, REG_RTC_CTRL_REG);
+	ret = rtc_write_u8(pmic, save_control, REG_RTC_CTRL_REG);
 
 out:
 	return ret;
@@ -300,11 +390,12 @@ out:
  */
 static int twl_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alm)
 {
+	struct pmic_data *pmic = dev_get_platdata(dev);
 	unsigned char rtc_data[ALL_TIME_REGS + 1];
 	int ret;
 
-	ret = twl_i2c_read(TWL_MODULE_RTC, rtc_data,
-			(rtc_reg_map[REG_ALARM_SECONDS_REG]), ALL_TIME_REGS);
+	ret = rtc_read_array(pmic, rtc_data, ALL_TIME_REGS,
+					rtc_reg_map[REG_ALARM_SECONDS_REG]);
 	if (ret < 0) {
 		dev_err(dev, "rtc_read_alarm error %d\n", ret);
 		return ret;
@@ -327,7 +418,8 @@ static int twl_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alm)
 
 static int twl_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alm)
 {
-	unsigned char alarm_data[ALL_TIME_REGS + 1];
+	struct pmic_data *pmic = dev_get_platdata(dev);
+	char alarm_data[ALL_TIME_REGS + 1];
 	int ret;
 
 	ret = twl_rtc_alarm_irq_enable(dev, 0);
@@ -342,8 +434,9 @@ static int twl_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alm)
 	alarm_data[6] = bin2bcd(alm->time.tm_year - 100);
 
 	/* update all the alarm registers in one shot */
-	ret = twl_i2c_write(TWL_MODULE_RTC, alarm_data,
-		(rtc_reg_map[REG_ALARM_SECONDS_REG]), ALL_TIME_REGS);
+	ret = rtc_write_array(pmic, alarm_data, ALL_TIME_REGS,
+				(rtc_reg_map[REG_ALARM_SECONDS_REG])); 
+	
 	if (ret) {
 		dev_err(dev, "rtc_set_alarm error %d\n", ret);
 		goto out;
@@ -355,8 +448,11 @@ out:
 	return ret;
 }
 
-static irqreturn_t twl_rtc_interrupt(int irq, void *rtc)
+static irqreturn_t twl_rtc_interrupt(int irq, void *data)
 {
+	struct rtc_device *rtc = data;
+	struct device *dev = &rtc->dev;
+	struct pmic_data *pmic = dev_get_platdata(dev);
 	unsigned long events = 0;
 	int ret = IRQ_NONE;
 	int res;
@@ -370,7 +466,7 @@ static irqreturn_t twl_rtc_interrupt(int irq, void *rtc)
 	local_irq_enable();
 #endif
 
-	res = twl_rtc_read_u8(&rd_reg, REG_RTC_STATUS_REG);
+	res = rtc_read_u8(pmic, &rd_reg, REG_RTC_STATUS_REG);
 	if (res)
 		goto out;
 	/*
@@ -384,8 +480,8 @@ static irqreturn_t twl_rtc_interrupt(int irq, void *rtc)
 	else
 		events |= RTC_IRQF | RTC_UF;
 
-	res = twl_rtc_write_u8(rd_reg | BIT_RTC_STATUS_REG_ALARM_M,
-				   REG_RTC_STATUS_REG);
+	res = rtc_write_u8(pmic,rd_reg | BIT_RTC_STATUS_REG_ALARM_M,
+						REG_RTC_STATUS_REG);
 	if (res)
 		goto out;
 
@@ -408,7 +504,7 @@ static irqreturn_t twl_rtc_interrupt(int irq, void *rtc)
 	}
 
 	/* Notify RTC core on event */
-	rtc_update_irq(rtc, 1, events);
+	rtc_update_irq(data, 1, events);
 
 	ret = IRQ_HANDLED;
 out:
@@ -428,10 +524,13 @@ static struct rtc_class_ops twl_rtc_ops = {
 static int __devinit twl_rtc_probe(struct platform_device *pdev)
 {
 	struct rtc_device *rtc;
+	struct pmic_data *pmic = dev_get_platdata(&pdev->dev);
 	int ret = 0;
 	int irq = platform_get_irq(pdev, 0);
 	u8 rd_reg;
 
+	dev_err(&pdev->dev, "%d\n", pmic->id);
+
 	if (irq <= 0)
 		return -EINVAL;
 
@@ -446,8 +545,8 @@ static int __devinit twl_rtc_probe(struct platform_device *pdev)
 	}
 
 	platform_set_drvdata(pdev, rtc);
-
-	ret = twl_rtc_read_u8(&rd_reg, REG_RTC_STATUS_REG);
+	
+	ret = rtc_read_u8(pmic, &rd_reg, REG_RTC_STATUS_REG);
 	if (ret < 0)
 		goto out1;
 
@@ -458,7 +557,7 @@ static int __devinit twl_rtc_probe(struct platform_device *pdev)
 		dev_warn(&pdev->dev, "Pending Alarm interrupt detected.\n");
 
 	/* Clear RTC Power up reset and pending alarm interrupts */
-	ret = twl_rtc_write_u8(rd_reg, REG_RTC_STATUS_REG);
+	ret = rtc_write_u8(pmic, rd_reg, REG_RTC_STATUS_REG);
 	if (ret < 0)
 		goto out1;
 
@@ -466,7 +565,7 @@ static int __devinit twl_rtc_probe(struct platform_device *pdev)
 				IRQF_TRIGGER_RISING,
 				dev_name(&rtc->dev), rtc);
 	if (ret < 0) {
-		dev_err(&pdev->dev, "IRQ is not free.\n");
+		dev_err(&pdev->dev, "IRQ %d is not free.\n", irq);
 		goto out1;
 	}
 
@@ -475,23 +574,23 @@ static int __devinit twl_rtc_probe(struct platform_device *pdev)
 			REG_INT_MSK_LINE_A);
 		twl6030_interrupt_unmask(TWL6030_RTC_INT_MASK,
 			REG_INT_MSK_STS_A);
-	}
+	} 
 
 	/* Check RTC module status, Enable if it is off */
-	ret = twl_rtc_read_u8(&rd_reg, REG_RTC_CTRL_REG);
+	ret = rtc_read_u8(pmic, &rd_reg, REG_RTC_CTRL_REG);
 	if (ret < 0)
 		goto out2;
 
 	if (!(rd_reg & BIT_RTC_CTRL_REG_STOP_RTC_M)) {
 		dev_info(&pdev->dev, "Enabling TWL-RTC.\n");
 		rd_reg = BIT_RTC_CTRL_REG_STOP_RTC_M;
-		ret = twl_rtc_write_u8(rd_reg, REG_RTC_CTRL_REG);
+		ret = rtc_write_u8(pmic, rd_reg, REG_RTC_CTRL_REG);
 		if (ret < 0)
 			goto out2;
 	}
 
 	/* init cached IRQ enable bits */
-	ret = twl_rtc_read_u8(&rtc_irq_bits, REG_RTC_INTERRUPTS_REG);
+	ret = rtc_read_u8(pmic, &rtc_irq_bits, REG_RTC_INTERRUPTS_REG);
 	if (ret < 0)
 		goto out2;
 
@@ -513,10 +612,12 @@ static int __devexit twl_rtc_remove(struct platform_device *pdev)
 {
 	/* leave rtc running, but disable irqs */
 	struct rtc_device *rtc = platform_get_drvdata(pdev);
+	struct device *dev = &pdev->dev;
+	struct pmic_data *pmic = dev_get_platdata(dev);
 	int irq = platform_get_irq(pdev, 0);
 
-	mask_rtc_irq_bit(BIT_RTC_INTERRUPTS_REG_IT_ALARM_M);
-	mask_rtc_irq_bit(BIT_RTC_INTERRUPTS_REG_IT_TIMER_M);
+	mask_rtc_irq_bit(pmic, BIT_RTC_INTERRUPTS_REG_IT_ALARM_M);
+	mask_rtc_irq_bit(pmic, BIT_RTC_INTERRUPTS_REG_IT_TIMER_M);
 	if (twl_class_is_6030()) {
 		twl6030_interrupt_mask(TWL6030_RTC_INT_MASK,
 			REG_INT_MSK_LINE_A);
@@ -534,9 +635,12 @@ static int __devexit twl_rtc_remove(struct platform_device *pdev)
 
 static void twl_rtc_shutdown(struct platform_device *pdev)
 {
+	struct device *dev = &pdev->dev;
+	struct pmic_data *pmic = dev_get_platdata(dev);
+
 	/* mask timer interrupts, but leave alarm interrupts on to enable
 	   power-on when alarm is triggered */
-	mask_rtc_irq_bit(BIT_RTC_INTERRUPTS_REG_IT_TIMER_M);
+	mask_rtc_irq_bit(pmic, BIT_RTC_INTERRUPTS_REG_IT_TIMER_M);
 }
 
 #ifdef CONFIG_PM
@@ -545,15 +649,19 @@ static unsigned char irqstat;
 
 static int twl_rtc_suspend(struct platform_device *pdev, pm_message_t state)
 {
+	struct device *dev = &pdev->dev;
+	struct pmic_data *pmic = dev_get_platdata(dev);
 	irqstat = rtc_irq_bits;
 
-	mask_rtc_irq_bit(BIT_RTC_INTERRUPTS_REG_IT_TIMER_M);
+	mask_rtc_irq_bit(pmic, BIT_RTC_INTERRUPTS_REG_IT_TIMER_M);
 	return 0;
 }
 
 static int twl_rtc_resume(struct platform_device *pdev)
 {
-	set_rtc_irq_bit(irqstat);
+	struct device *dev = &pdev->dev;
+	struct pmic_data *pmic = dev_get_platdata(dev);
+	set_rtc_irq_bit(pmic, irqstat);
 	return 0;
 }
 
@@ -580,8 +688,11 @@ static int __init twl_rtc_init(void)
 {
 	if (twl_class_is_4030())
 		rtc_reg_map = (u8 *) twl4030_rtc_reg_map;
-	else
+	else if (twl_class_is_6030())
 		rtc_reg_map = (u8 *) twl6030_rtc_reg_map;
+	/* TODO: Verify that rtc parent is tps65910 */
+	else
+		rtc_reg_map = (u8 *) tps65910_rtc_reg_map;
 
 	return platform_driver_register(&twl4030rtc_driver);
 }
diff --git a/include/linux/mfd/tps65910.h b/include/linux/mfd/tps65910.h
index 8bb85b9..520e7e2 100644
--- a/include/linux/mfd/tps65910.h
+++ b/include/linux/mfd/tps65910.h
@@ -786,6 +786,11 @@ struct tps65910_platform_data {
 	int irq_base;
 };
 
+struct pmic_data {
+	int id;
+	void * pmic;
+};
+
 int tps65910_set_bits(struct tps65910 *tps65910, u8 reg, u8 mask);
 int tps65910_clear_bits(struct tps65910 *tps65910, u8 reg, u8 mask);
 void tps65910_gpio_init(struct tps65910 *tps65910, int gpio_base);
-- 
1.7.1

