Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068Ab0HUMay (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 08:30:54 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:33178 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355Ab0HUMau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 08:30:50 -0400
From: hvaibhav@ti.com
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, byron.bbradley@gmail.com,
        linux-omap@vger.kernel.org, felipe.balbi@nokia.com,
        Vaibhav Hiremath <hvaibhav@ti.com>
Subject: [PATCH-V2 1/3] RTC:s35390a: Add Alarm interrupt support
Date: Sat, 21 Aug 2010 18:00:27 +0530
Message-Id: <1282393829-7326-2-git-send-email-hvaibhav@ti.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <hvaibhav@ti.com>
References: <hvaibhav@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vaibhav Hiremath <hvaibhav@ti.com>

Add Alarm related RTC APi's
	- alarm_irq_enable,
	- set_alarm,
	- read_alarm

Also create a threaded irq to service alarm interrupt from RTC S35390A.

Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
---
 drivers/rtc/rtc-s35390a.c |  185 ++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 182 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-s35390a.c b/drivers/rtc/rtc-s35390a.c
index f789e00..6010fc6 100644
--- a/drivers/rtc/rtc-s35390a.c
+++ b/drivers/rtc/rtc-s35390a.c
@@ -19,6 +19,8 @@
 #define S35390A_CMD_STATUS1	0
 #define S35390A_CMD_STATUS2	1
 #define S35390A_CMD_TIME1	2
+#define S35390A_CMD_TIME2	3
+#define S35390A_CMD_INT1_REG1	4

 #define S35390A_BYTE_YEAR	0
 #define S35390A_BYTE_MONTH	1
@@ -28,12 +30,24 @@
 #define S35390A_BYTE_MINS	5
 #define S35390A_BYTE_SECS	6

+#define S35390A_ALRM_BYTE_WDAY	0
+#define S35390A_ALRM_BYTE_HOURS	1
+#define S35390A_ALRM_BYTE_MINS	2
+
 #define S35390A_FLAG_POC	0x01
 #define S35390A_FLAG_BLD	0x02
 #define S35390A_FLAG_24H	0x40
 #define S35390A_FLAG_RESET	0x80
 #define S35390A_FLAG_TEST	0x01

+#define S35390A_INT1_MODE_MASK		0xF
+
+#define S35390A_INT1_MODE_NOINTR	0x0
+#define S35390A_INT1_MODE_FREQ		0x1
+#define S35390A_INT1_MODE_PMIN_EDG	0x2
+#define S35390A_INT1_MODE_PMIN_STDY	0x3
+#define S35390A_INT1_MODE_ALARM		0x4
+
 static const struct i2c_device_id s35390a_id[] = {
 	{ "s35390a", 0 },
 	{ }
@@ -44,6 +58,7 @@ struct s35390a {
 	struct i2c_client *client[8];
 	struct rtc_device *rtc;
 	int twentyfourhour;
+	struct rtc_wkalrm alarm;
 };

 static int s35390a_set_reg(struct s35390a *s35390a, int reg, char *buf, int len)
@@ -194,9 +209,157 @@ static int s35390a_rtc_set_time(struct device *dev, struct rtc_time *tm)
 	return s35390a_set_datetime(to_i2c_client(dev), tm);
 }

+static int s35390a_alarm_irq_enable(struct i2c_client *client, unsigned enabled)
+{
+	struct s35390a *s35390a = i2c_get_clientdata(client);
+	struct rtc_wkalrm *alm;
+	char buf[3], sts;
+	int err, i;
+
+	err = s35390a_get_reg(s35390a, S35390A_CMD_STATUS2, &sts, sizeof(sts));
+	if (err) {
+		dev_err(&client->dev, "%s: failed to read STS2 reg\n",
+								__func__);
+		return err;
+	}
+
+	/* This chip returns the bits of each byte in reverse order */
+	sts = bitrev8(sts);
+
+	sts &= ~S35390A_INT1_MODE_MASK;
+
+	if (enabled)
+		sts |= S35390A_INT1_MODE_ALARM;
+	else
+		sts |= S35390A_INT1_MODE_NOINTR;
+
+	/* This chip expects the bits of each byte in reverse order */
+	sts = bitrev8(sts);
+
+	err = s35390a_set_reg(s35390a, S35390A_CMD_STATUS2, &sts, sizeof(sts));
+	if (err) {
+		dev_err(&client->dev, "%s: failed to set STS2 reg\n", __func__);
+		return err;
+	}
+
+	alm = &s35390a->alarm;
+
+	if (alm->time.tm_wday != -1)
+		buf[S35390A_ALRM_BYTE_WDAY] = bin2bcd(alm->time.tm_wday) | 0x80;
+
+	buf[S35390A_ALRM_BYTE_HOURS] = s35390a_hr2reg(s35390a,
+			alm->time.tm_hour) | 0x80;
+	buf[S35390A_ALRM_BYTE_MINS] = bin2bcd(alm->time.tm_min) | 0x80;
+
+	if (alm->time.tm_hour >= 12)
+		buf[S35390A_ALRM_BYTE_HOURS] |= 0x40;
+
+	/* This chip expects the bits of each byte to be in reverse order */
+	for (i = 0; i < 3; ++i)
+		buf[i] = bitrev8(buf[i]);
+
+	return s35390a_set_reg(s35390a, S35390A_CMD_INT1_REG1, buf,
+								sizeof(buf));
+}
+
+static int s35390a_rtc_alarm_irq_enable(struct device *dev, unsigned enabled)
+{
+	return s35390a_alarm_irq_enable(to_i2c_client(dev), enabled);
+}
+
+static int s35390a_set_alarm(struct i2c_client *client, struct rtc_wkalrm *alm)
+{
+	struct s35390a *s35390a = i2c_get_clientdata(client);
+
+	dev_dbg(&client->dev, "%s: alm is secs=%d, mins=%d, hours=%d mday=%d, "
+		"mon=%d, year=%d, wday=%d\n", __func__, alm->time.tm_sec,
+		alm->time.tm_min, alm->time.tm_hour, alm->time.tm_mday,
+		alm->time.tm_mon, alm->time.tm_year, alm->time.tm_wday);
+
+	/* Copy Alarm time */
+	memcpy(&s35390a->alarm, alm, sizeof(s35390a->alarm));
+
+	return 0;
+}
+
+static int s35390a_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alm)
+{
+	return s35390a_set_alarm(to_i2c_client(dev), alm);
+}
+
+static int s35390a_read_alarm(struct i2c_client *client, struct rtc_wkalrm *alm)
+{
+	struct s35390a *s35390a = i2c_get_clientdata(client);
+	char buf[3], sts;
+	int i, err;
+
+	if (s35390a_get_reg(s35390a, S35390A_CMD_STATUS2, &sts,
+							sizeof(sts)) < 0)
+		return -EIO;
+
+	/* This chip returns the bits of each byte in reverse order */
+	sts = bitrev8(sts);
+
+	s35390a_alarm_irq_enable(client, 1);
+	err = s35390a_get_reg(s35390a, S35390A_CMD_INT1_REG1, buf, sizeof(buf));
+	if (err < 0)
+		return err;
+
+	/* This chip returns the bits of each byte in reverse order */
+	for (i = 0; i < 3; ++i) {
+		buf[i] = bitrev8(buf[i]);
+		buf[i] &= ~0x80;
+	}
+
+	alm->time.tm_wday = bcd2bin(buf[S35390A_ALRM_BYTE_WDAY]);
+	alm->time.tm_hour = s35390a_reg2hr(s35390a,
+					buf[S35390A_ALRM_BYTE_HOURS]);
+	alm->time.tm_min = bcd2bin(buf[S35390A_ALRM_BYTE_MINS]);
+
+	dev_dbg(&client->dev, "%s: alm is mins=%d, hours=%d, wday=%d\n",
+			__func__, alm->time.tm_min, alm->time.tm_hour,
+			alm->time.tm_wday);
+
+	if (!(sts & BIT(2)))
+		s35390a_alarm_irq_enable(client, 0);
+
+	return 0;
+}
+
+static int s35390a_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alm)
+{
+	return s35390a_read_alarm(to_i2c_client(dev), alm);
+}
+
+static irqreturn_t s35390a_irq_thread(int irq, void *handle)
+{
+	char buf[1];
+	struct s35390a *s35390a = handle;
+	struct i2c_client *client = s35390a->client[0];
+
+	if (s35390a_get_reg(s35390a, S35390A_CMD_STATUS2, buf, sizeof(buf)) < 0)
+		goto out;
+
+	/* This chip returns the bits of each byte in reverse order */
+	buf[0] = bitrev8(buf[0]);
+
+	/* Notify RTC core on event if any */
+	if (buf[0] & BIT(2)) {
+		rtc_update_irq(s35390a->rtc, 1, RTC_IRQF | RTC_AF);
+		s35390a_alarm_irq_enable(client, 0);
+	}
+
+out:
+	return IRQ_HANDLED;
+}
+
 static const struct rtc_class_ops s35390a_rtc_ops = {
-	.read_time	= s35390a_rtc_read_time,
-	.set_time	= s35390a_rtc_set_time,
+	.read_time		= s35390a_rtc_read_time,
+	.set_time		= s35390a_rtc_set_time,
+	.alarm_irq_enable	= s35390a_rtc_alarm_irq_enable,
+	.set_alarm		= s35390a_rtc_set_alarm,
+	.read_alarm		= s35390a_rtc_read_alarm,
+
 };

 static struct i2c_driver s35390a_driver;
@@ -261,15 +424,30 @@ static int s35390a_probe(struct i2c_client *client,
 	if (s35390a_get_datetime(client, &tm) < 0)
 		dev_warn(&client->dev, "clock needs to be set\n");

+	if (client->irq >= 0) {
+		err = request_threaded_irq(client->irq, NULL,
+				s35390a_irq_thread,
+				IRQF_TRIGGER_LOW | IRQF_ONESHOT,
+				client->name, s35390a);
+		if (err) {
+			dev_err(&client->dev, "unable to request IRQ\n");
+			goto exit_dummy;
+		}
+	}
+
 	s35390a->rtc = rtc_device_register(s35390a_driver.driver.name,
 				&client->dev, &s35390a_rtc_ops, THIS_MODULE);

 	if (IS_ERR(s35390a->rtc)) {
 		err = PTR_ERR(s35390a->rtc);
-		goto exit_dummy;
+		goto exit_intr;
 	}
+
 	return 0;

+exit_intr:
+	free_irq(client->irq, client);
+
 exit_dummy:
 	for (i = 1; i < 8; ++i)
 		if (s35390a->client[i])
@@ -290,6 +468,7 @@ static int s35390a_remove(struct i2c_client *client)
 			i2c_unregister_device(s35390a->client[i]);

 	rtc_device_unregister(s35390a->rtc);
+	free_irq(client->irq, client);
 	kfree(s35390a);

 	return 0;
--
1.6.2.4

