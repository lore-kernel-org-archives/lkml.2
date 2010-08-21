Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998Ab0HUMas (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 08:30:48 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:47019 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355Ab0HUMar (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 08:30:47 -0400
From: hvaibhav@ti.com
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, byron.bbradley@gmail.com,
        linux-omap@vger.kernel.org, felipe.balbi@nokia.com,
        Vaibhav Hiremath <hvaibhav@ti.com>
Subject: [PATCH-V2 2/3] RTC:s35390a: Add Periodic interrupt support
Date: Sat, 21 Aug 2010 18:00:28 +0530
Message-Id: <1282393829-7326-3-git-send-email-hvaibhav@ti.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <hvaibhav@ti.com>
References: <hvaibhav@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vaibhav Hiremath <hvaibhav@ti.com>

S35390A RTC supports 1, 2, 4, 8, 16 Hz periodic frequency.

So add Periodic frequency/interrupt related RTC APi's
	- irq_set_freq,
	- irq_set_state

Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
---
 drivers/rtc/rtc-s35390a.c |   66 ++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 65 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-s35390a.c b/drivers/rtc/rtc-s35390a.c
index 6010fc6..d8d59d7 100644
--- a/drivers/rtc/rtc-s35390a.c
+++ b/drivers/rtc/rtc-s35390a.c
@@ -331,6 +331,65 @@ static int s35390a_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alm)
 	return s35390a_read_alarm(to_i2c_client(dev), alm);
 }

+static int s35390a_freq_irq_enable(struct i2c_client *client, unsigned enabled)
+{
+	struct s35390a *s35390a = i2c_get_clientdata(client);
+	char buf[1];
+	int err;
+
+	err = s35390a_get_reg(s35390a, S35390A_CMD_STATUS2, buf, sizeof(buf));
+	if (err) {
+		dev_err(&client->dev, "%s: failed to read STS2 reg\n",
+								__func__);
+		return err;
+	}
+
+	/* This chip returns the bits of each byte in reverse order */
+	buf[0] = bitrev8(buf[0]);
+
+	buf[0] &= ~S35390A_INT1_MODE_MASK;
+	if (enabled)
+		buf[0] |= S35390A_INT1_MODE_FREQ;
+	else
+		buf[0] |= S35390A_INT1_MODE_NOINTR;
+
+	/* This chip expects the bits of each byte in reverse order */
+	buf[0] = bitrev8(buf[0]);
+
+	err = s35390a_set_reg(s35390a, S35390A_CMD_STATUS2, buf, sizeof(buf));
+	if (err) {
+		dev_err(&client->dev, "%s: failed to set STS2 reg\n", __func__);
+		return err;
+	}
+
+	if (enabled) {
+		buf[0] = s35390a->rtc->irq_freq;
+		buf[0] = bitrev8(buf[0]);
+		err = s35390a_set_reg(s35390a, S35390A_CMD_INT1_REG1, buf,
+								sizeof(buf));
+	}
+
+	return err;
+}
+
+static int s35390a_rtc_freq_irq_enable(struct device *dev, int enabled)
+{
+	return s35390a_freq_irq_enable(to_i2c_client(dev), enabled);
+}
+
+static int s35390a_set_irq_freq(struct i2c_client *client, int freq)
+{
+	if (!is_power_of_2(freq) || (freq > 16))
+		return -EINVAL;
+
+	return 0;
+}
+
+static int s35390a_rtc_set_irq_freq(struct device *dev, int freq)
+{
+	return s35390a_set_irq_freq(to_i2c_client(dev), freq);
+}
+
 static irqreturn_t s35390a_irq_thread(int irq, void *handle)
 {
 	char buf[1];
@@ -347,6 +406,8 @@ static irqreturn_t s35390a_irq_thread(int irq, void *handle)
 	if (buf[0] & BIT(2)) {
 		rtc_update_irq(s35390a->rtc, 1, RTC_IRQF | RTC_AF);
 		s35390a_alarm_irq_enable(client, 0);
+	} else if (buf[0] & BIT(0)) {
+		rtc_update_irq(s35390a->rtc, 1, RTC_IRQF | RTC_PF);
 	}

 out:
@@ -359,7 +420,8 @@ static const struct rtc_class_ops s35390a_rtc_ops = {
 	.alarm_irq_enable	= s35390a_rtc_alarm_irq_enable,
 	.set_alarm		= s35390a_rtc_set_alarm,
 	.read_alarm		= s35390a_rtc_read_alarm,
-
+	.irq_set_freq		= s35390a_rtc_set_irq_freq,
+	.irq_set_state		= s35390a_rtc_freq_irq_enable,
 };

 static struct i2c_driver s35390a_driver;
@@ -442,6 +504,8 @@ static int s35390a_probe(struct i2c_client *client,
 		err = PTR_ERR(s35390a->rtc);
 		goto exit_intr;
 	}
+	s35390a->rtc->irq_freq = 0;
+	s35390a->rtc->max_user_freq = 16;

 	return 0;

--
1.6.2.4

