Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324Ab1CGPz4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 10:55:56 -0500
Received: from dakia2.marvell.com ([65.219.4.35]:33397 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754530Ab1CGPzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 10:55:22 -0500
X-ASG-Debug-ID: 1299512697-082e751f0001-xx1T2L
X-Barracuda-Envelope-From: haojian.zhuang@marvell.com
From: Haojian Zhuang <haojian.zhuang@marvell.com>
To: johnpol@2ka.mipt.ru, sameo@linux.intel.com, a.zummo@towertech.it,
        lrg@slimlogic.co.uk, broonie@opensource.wolfsonmicro.com,
        dmitry.torokhov@gmail.com, dtor@mail.ru, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>
X-ASG-Orig-Subj: [PATCH] rtc: add 88pm860x rtc
Subject: [PATCH] rtc: add 88pm860x rtc
Date: Mon,  7 Mar 2011 23:43:17 +0800
X-ASG-Orig-Subj: [PATCH] rtc: add 88pm860x rtc
Message-Id: <1299512600-29047-9-git-send-email-haojian.zhuang@marvell.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1299512600-29047-8-git-send-email-haojian.zhuang@marvell.com>
References: <1299512600-29047-1-git-send-email-haojian.zhuang@marvell.com>
 <1299512600-29047-2-git-send-email-haojian.zhuang@marvell.com>
 <1299512600-29047-3-git-send-email-haojian.zhuang@marvell.com>
 <1299512600-29047-4-git-send-email-haojian.zhuang@marvell.com>
 <1299512600-29047-5-git-send-email-haojian.zhuang@marvell.com>
 <1299512600-29047-6-git-send-email-haojian.zhuang@marvell.com>
 <1299512600-29047-7-git-send-email-haojian.zhuang@marvell.com>
 <1299512600-29047-8-git-send-email-haojian.zhuang@marvell.com>
X-Barracuda-Connect: maili.marvell.com[10.68.76.51]
X-Barracuda-Start-Time: 1299512697
X-Barracuda-URL: http://10.68.76.222:80/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: -1002.00
X-Barracuda-Spam-Status: No, SCORE=-1002.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=1000.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support RTC component in 88PM860x. Also support synchronize time
88PM860x RTC to another RTC device. It should be implemented in
sync callback API.

While 88PM860x RTC is enabled, it can do RTC calibration to gurantee
enough power is supplied on VRTC domain of 88PM860x.

Signed-off-by: Haojian Zhuang <haojian.zhuang@marvell.com>
---
 drivers/mfd/88pm860x-core.c  |   30 ++++++++++++++++++++++++++++++
 drivers/rtc/Kconfig          |   10 ++++++++++
 drivers/rtc/Makefile         |    1 +
 include/linux/mfd/88pm860x.h |    6 ++++++
 4 files changed, 47 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/88pm860x-core.c b/drivers/mfd/88pm860x-core.c
index 7879569..864e6a3 100644
--- a/drivers/mfd/88pm860x-core.c
+++ b/drivers/mfd/88pm860x-core.c
@@ -57,6 +57,10 @@ static struct resource regulator_resources[] __initdata = {
 	{PM8607_ID_LDO15, PM8607_ID_LDO15, "ldo-15", IORESOURCE_IO,},
 };
 
+static struct resource rtc_resources[] __initdata = {
+	{PM8607_IRQ_RTC, PM8607_IRQ_RTC, "rtc", IORESOURCE_IRQ,},
+};
+
 static struct resource touch_resources[] __initdata = {
 	{PM8607_IRQ_PEN, PM8607_IRQ_PEN, "touch", IORESOURCE_IRQ,},
 };
@@ -126,6 +130,10 @@ static struct mfd_cell regulator_devs[] __initdata = {
 	{"88pm860x-regulator", 17,},
 };
 
+static struct mfd_cell rtc_devs[] __initdata = {
+	{"88pm860x-rtc", -1,},
+};
+
 static struct mfd_cell touch_devs[] __initdata = {
 	{"88pm860x-touch", -1,},
 };
@@ -148,6 +156,7 @@ static struct pm860x_led_pdata led_pdata[ARRAY_SIZE(led_devs)];
 static struct regulator_init_data regulator_pdata[ARRAY_SIZE(regulator_devs)];
 static struct pm860x_touch_pdata touch_pdata;
 static struct pm860x_power_pdata power_pdata;
+static struct pm860x_rtc_pdata rtc_pdata;
 
 struct pm860x_irq_data {
 	int	reg;
@@ -588,6 +597,26 @@ out:
 	return;
 }
 
+static void __devinit device_rtc_init(struct pm860x_chip *chip,
+				      struct i2c_client *i2c,
+				      struct pm860x_platform_data *pdata)
+{
+	int ret;
+
+	if ((pdata == NULL) || (pdata->rtc == NULL))
+		return;
+
+	memcpy(&rtc_pdata, pdata->rtc, sizeof(struct pm860x_rtc_pdata));
+	rtc_devs[0].mfd_data = &rtc_pdata;
+	rtc_devs[0].num_resources = ARRAY_SIZE(rtc_resources);
+	rtc_devs[0].resources = &rtc_resources[0];
+	ret = mfd_add_devices(chip->dev, 0, &rtc_devs[0],
+			      ARRAY_SIZE(rtc_devs), &rtc_resources[0],
+			      chip->irq_base);
+	if (ret < 0)
+		dev_err(chip->dev, "Failed to add rtc subdev\n");
+}
+
 static void __devinit device_touch_init(struct pm860x_chip *chip,
 					struct i2c_client *i2c,
 					struct pm860x_platform_data *pdata)
@@ -722,6 +751,7 @@ static void __devinit device_8607_init(struct pm860x_chip *chip,
 	}
 
 	device_regulator_init(chip, i2c, pdata);
+	device_rtc_init(chip, i2c, pdata);
 	device_onkey_init(chip, i2c, pdata);
 	device_touch_init(chip, i2c, pdata);
 	device_power_init(chip, i2c, pdata);
diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index 4941cad..4f7b9f4 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -128,6 +128,16 @@ comment "I2C RTC drivers"
 
 if I2C
 
+config RTC_DRV_88PM860X
+	tristate "Marvell 88PM860x"
+	depends on RTC_CLASS && I2C && MFD_88PM860X
+	help
+	  If you say yes here you get support for RTC function in Marvell
+	  88PM860x chips.
+
+	  This driver can also be built as a module. If so, the module
+	  will be called rtc-88pm860x.
+
 config RTC_DRV_DS1307
 	tristate "Dallas/Maxim DS1307/37/38/39/40, ST M41T00, EPSON RX-8025"
 	help
diff --git a/drivers/rtc/Makefile b/drivers/rtc/Makefile
index 2afdaf3..edc9325 100644
--- a/drivers/rtc/Makefile
+++ b/drivers/rtc/Makefile
@@ -17,6 +17,7 @@ rtc-core-$(CONFIG_RTC_INTF_SYSFS) += rtc-sysfs.o
 
 # Keep the list ordered.
 
+obj-$(CONFIG_RTC_DRV_88PM860X)  += rtc-88pm860x.o
 obj-$(CONFIG_RTC_DRV_AB3100)	+= rtc-ab3100.o
 obj-$(CONFIG_RTC_DRV_AB8500)	+= rtc-ab8500.o
 obj-$(CONFIG_RTC_DRV_AT32AP700X)+= rtc-at32ap700x.o
diff --git a/include/linux/mfd/88pm860x.h b/include/linux/mfd/88pm860x.h
index 05f8677..318aba8 100644
--- a/include/linux/mfd/88pm860x.h
+++ b/include/linux/mfd/88pm860x.h
@@ -331,6 +331,11 @@ struct pm860x_led_pdata {
 	unsigned long	flags;
 };
 
+struct pm860x_rtc_pdata {
+	int		(*sync)(unsigned int ticks);
+	int		vrtc;
+};
+
 struct pm860x_touch_pdata {
 	int		gpadc_prebias;
 	int		slot_cycle;
@@ -350,6 +355,7 @@ struct pm860x_power_pdata {
 struct pm860x_platform_data {
 	struct pm860x_backlight_pdata	*backlight;
 	struct pm860x_led_pdata		*led;
+	struct pm860x_rtc_pdata		*rtc;
 	struct pm860x_touch_pdata	*touch;
 	struct pm860x_power_pdata	*power;
 	struct regulator_init_data	*regulator;
-- 
1.5.6.5

