Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976Ab1BTVMf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 16:12:35 -0500
Received: from mail.bluewatersys.com ([202.124.120.130]:52621 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754480Ab1BTVMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 16:12:34 -0500
Message-ID: <4D6183E6.1030706@bluewatersys.com>
Date: Mon, 21 Feb 2011 10:13:10 +1300
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: a.zummo@towertech.it
CC: rtc-linux@googlegroups.com, linux kernel <linux-kernel@vger.kernel.org>,
        hvr@gnu.org
Subject: [REPOST PATCH] rtc-isl1208: Add alarm support
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add alarm/wakeup support to rtc isl1208 driver

Signed-off-by: Ryan Mallon <ryan@bluewatersys.com>
---

diff --git a/drivers/rtc/rtc-isl1208.c b/drivers/rtc/rtc-isl1208.c
index 468200c..94aa4f5 100644
--- a/drivers/rtc/rtc-isl1208.c
+++ b/drivers/rtc/rtc-isl1208.c
@@ -39,6 +39,8 @@
 #define ISL1208_REG_SR_BAT     (1<<1)	/* battery */
 #define ISL1208_REG_SR_RTCF    (1<<0)	/* rtc fail */
 #define ISL1208_REG_INT 0x08
+#define ISL1208_REG_INT_ALME   (1<<6)   /* alarm enable */
+#define ISL1208_REG_INT_IM     (1<<7)   /* interrupt/alarm mode */
 #define ISL1208_REG_09  0x09	/* reserved */
 #define ISL1208_REG_ATR 0x0a
 #define ISL1208_REG_DTR 0x0b
@@ -202,6 +204,31 @@ isl1208_i2c_set_usr(struct i2c_client *client, u16 usr)
 }
 
 static int
+isl1208_rtc_toggle_alarm(struct i2c_client *client, int enable)
+{
+	int icr;
+
+	icr = i2c_smbus_read_byte_data(client, ISL1208_REG_INT);
+	if (icr < 0) {
+		dev_err(&client->dev, "%s: reading INT failed\n", __func__);
+		return icr;
+	}
+
+	if (enable)
+		icr |= ISL1208_REG_INT_ALME | ISL1208_REG_INT_IM;
+	else
+		icr &= ~(ISL1208_REG_INT_ALME | ISL1208_REG_INT_IM);
+
+	icr = i2c_smbus_write_byte_data(client, ISL1208_REG_INT, icr);
+	if (icr < 0) {
+		dev_err(&client->dev, "%s: writing INT failed\n", __func__);
+		return icr;
+	}
+
+	return 0;
+}
+
+static int
 isl1208_rtc_proc(struct device *dev, struct seq_file *seq)
 {
 	struct i2c_client *const client = to_i2c_client(dev);
@@ -288,7 +315,7 @@ isl1208_i2c_read_alarm(struct i2c_client *client, struct rtc_wkalrm *alarm)
 {
 	struct rtc_time *const tm = &alarm->time;
 	u8 regs[ISL1208_ALARM_SECTION_LEN] = { 0, };
-	int sr;
+	int icr, yr, sr;
 
 	sr = isl1208_i2c_get_sr(client);
 	if (sr < 0) {
@@ -313,6 +340,73 @@ isl1208_i2c_read_alarm(struct i2c_client *client, struct rtc_wkalrm *alarm)
 		bcd2bin(regs[ISL1208_REG_MOA - ISL1208_REG_SCA] & 0x1f) - 1;
 	tm->tm_wday = bcd2bin(regs[ISL1208_REG_DWA - ISL1208_REG_SCA] & 0x03);
 
+	/* The alarm doesn't store the year so get it from the rtc section */
+	yr = i2c_smbus_read_byte_data(client, ISL1208_REG_YR);
+	if (yr < 0) {
+		dev_err(&client->dev, "%s: reading RTC YR failed\n", __func__);
+		return yr;
+	}
+	tm->tm_year = bcd2bin(yr) + 100;
+
+	icr = i2c_smbus_read_byte_data(client, ISL1208_REG_INT);
+	if (icr < 0) {
+		dev_err(&client->dev, "%s: reading INT failed\n", __func__);
+		return icr;
+	}
+	alarm->enabled = !!(icr & ISL1208_REG_INT_ALME);
+
+	return 0;
+}
+
+static int
+isl1208_i2c_set_alarm(struct i2c_client *client, struct rtc_wkalrm *alarm)
+{
+	struct rtc_time *alarm_tm = &alarm->time;
+	u8 regs[ISL1208_ALARM_SECTION_LEN] = { 0, };
+	const int offs = ISL1208_REG_SCA;
+	unsigned long rtc_secs, alarm_secs;
+	struct rtc_time rtc_tm;
+	int err, enable;
+
+	err = isl1208_i2c_read_time(client, &rtc_tm);
+	if (err)
+		return err;
+	err = rtc_tm_to_time(&rtc_tm, &rtc_secs);
+	if (err)
+		return err;
+	err = rtc_tm_to_time(alarm_tm, &alarm_secs);
+	if (err)
+		return err;
+
+	/* If the alarm time is before the current time disable the alarm */
+	if (!alarm->enabled || alarm_secs <= rtc_secs)
+		enable = 0x00;
+	else
+		enable = 0x80;
+
+	/* Program the alarm and enable it for each setting */
+	regs[ISL1208_REG_SCA - offs] = bin2bcd(alarm_tm->tm_sec) | enable;
+	regs[ISL1208_REG_MNA - offs] = bin2bcd(alarm_tm->tm_min) | enable;
+	regs[ISL1208_REG_HRA - offs] = bin2bcd(alarm_tm->tm_hour) |
+		ISL1208_REG_HR_MIL | enable;
+
+	regs[ISL1208_REG_DTA - offs] = bin2bcd(alarm_tm->tm_mday) | enable;
+	regs[ISL1208_REG_MOA - offs] = bin2bcd(alarm_tm->tm_mon + 1) | enable;
+	regs[ISL1208_REG_DWA - offs] = bin2bcd(alarm_tm->tm_wday & 7) | enable;
+
+	/* write ALARM registers */
+	err = isl1208_i2c_set_regs(client, offs, regs,
+				  ISL1208_ALARM_SECTION_LEN);
+	if (err < 0) {
+		dev_err(&client->dev, "%s: writing ALARM section failed\n",
+			__func__);
+		return err;
+	}
+
+	err = isl1208_rtc_toggle_alarm(client, enable);
+	if (err)
+		return err;
+
 	return 0;
 }
 
@@ -391,12 +485,63 @@ isl1208_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 	return isl1208_i2c_read_alarm(to_i2c_client(dev), alarm);
 }
 
+static int
+isl1208_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alarm)
+{
+	return isl1208_i2c_set_alarm(to_i2c_client(dev), alarm);
+}
+
+static irqreturn_t
+isl1208_rtc_interrupt(int irq, void *data)
+{
+	unsigned long timeout = jiffies + msecs_to_jiffies(1000);
+	struct i2c_client *client = data;
+	int handled = 0, sr, err;
+
+	/*
+	 * I2C reads get NAK'ed if we read straight away after an interrupt?
+	 * Using a mdelay/msleep didn't seem to help either, so we work around
+	 * this by continually trying to read the register for a short time.
+	 */
+	while (1) {
+		sr = isl1208_i2c_get_sr(client);
+		if (sr >= 0)
+			break;
+
+		if (time_after(jiffies, timeout)) {
+			dev_dbg(&client->dev, "%s: reading SR failed\n",
+				__func__);
+			return sr;
+		}
+	}
+
+	if (sr & ISL1208_REG_SR_ALM) {
+		dev_dbg(&client->dev, "alarm!\n");
+
+		/* Clear the alarm */
+		sr &= ~ISL1208_REG_SR_ALM;
+		sr = i2c_smbus_write_byte_data(client, ISL1208_REG_SR, sr);
+		if (sr < 0)
+			dev_err(&client->dev, "%s: writing SR failed\n",
+				__func__);
+		else
+			handled = 1;
+
+		/* Disable the alarm */
+		err = isl1208_rtc_toggle_alarm(client, 0);
+		if (err)
+			return err;
+	}
+
+	return handled ? IRQ_HANDLED : IRQ_NONE;
+}
+
 static const struct rtc_class_ops isl1208_rtc_ops = {
 	.proc = isl1208_rtc_proc,
 	.read_time = isl1208_rtc_read_time,
 	.set_time = isl1208_rtc_set_time,
 	.read_alarm = isl1208_rtc_read_alarm,
-	/*.set_alarm    = isl1208_rtc_set_alarm, */
+	.set_alarm = isl1208_rtc_set_alarm,
 };
 
 /* sysfs interface */
@@ -488,11 +633,29 @@ isl1208_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	dev_info(&client->dev,
 		 "chip found, driver version " DRV_VERSION "\n");
 
+	if (client->irq > 0) {
+		rc = request_threaded_irq(client->irq, NULL,
+					  isl1208_rtc_interrupt,
+					  IRQF_SHARED,
+					  isl1208_driver.driver.name, client);
+		if (!rc) {
+			device_init_wakeup(&client->dev, 1);
+			enable_irq_wake(client->irq);
+		} else {
+			dev_err(&client->dev,
+				"Unable to request irq %d, no alarm support\n",
+				client->irq);
+			client->irq = 0;
+		}
+	}
+
 	rtc = rtc_device_register(isl1208_driver.driver.name,
 				  &client->dev, &isl1208_rtc_ops,
 				  THIS_MODULE);
-	if (IS_ERR(rtc))
-		return PTR_ERR(rtc);
+	if (IS_ERR(rtc)) {
+		rc = PTR_ERR(rtc);
+		goto exit_free_irq;
+	}
 
 	i2c_set_clientdata(client, rtc);
 
@@ -514,6 +677,9 @@ isl1208_probe(struct i2c_client *client, const struct i2c_device_id *id)
 
 exit_unregister:
 	rtc_device_unregister(rtc);
+exit_free_irq:
+	if (client->irq)
+		free_irq(client->irq, client);
 
 	return rc;
 }
@@ -525,6 +691,8 @@ isl1208_remove(struct i2c_client *client)
 
 	sysfs_remove_group(&client->dev.kobj, &isl1208_rtc_sysfs_files);
 	rtc_device_unregister(rtc);
+	if (client->irq)
+		free_irq(client->irq, client);
 
 	return 0;
 }

