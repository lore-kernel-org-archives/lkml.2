Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932120Ab0HQIvt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 04:51:49 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:57025 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757107Ab0HQIs4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 04:48:56 -0400
From: hvaibhav@ti.com
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, byron.bbradley@gmail.com,
        linux-omap@vger.kernel.org, Vaibhav Hiremath <hvaibhav@ti.com>
Subject: [PATCH 3/3] RTC:s35390a: Add update_irq (per Min interrupt) support
Date: Tue, 17 Aug 2010 14:18:41 +0530
Message-Id: <1282034921-22167-4-git-send-email-hvaibhav@ti.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <hvaibhav@ti.com>
References: <hvaibhav@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vaibhav Hiremath <hvaibhav@ti.com>


Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
---
 drivers/rtc/rtc-s35390a.c |   30 ++++++++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/drivers/rtc/rtc-s35390a.c b/drivers/rtc/rtc-s35390a.c
index d456b70..a6b0412 100644
--- a/drivers/rtc/rtc-s35390a.c
+++ b/drivers/rtc/rtc-s35390a.c
@@ -391,6 +391,35 @@ static int s35390a_rtc_set_irq_freq(struct device *dev, int freq)
 	return s35390a_set_irq_freq(to_i2c_client(dev), freq);
 }
 
+static int s35390a_update_irq_enable(struct i2c_client *client,
+						unsigned enabled)
+{
+	struct s35390a *s35390a = i2c_get_clientdata(client);
+	char buf[1];
+
+	if (s35390a_get_reg(s35390a, S35390A_CMD_STATUS2, buf, sizeof(buf)) < 0)
+		return -EIO;
+
+	/* This chip returns the bits of each byte in reverse order */
+	buf[0] = bitrev8(buf[0]);
+
+	buf[0] &= ~S35390A_INT1_MODE_MASK;
+	if (enabled)
+		buf[0] |= S35390A_INT1_MODE_PMIN_EDG;
+	else
+		buf[0] |= S35390A_INT1_MODE_NOINTR;
+
+	/* This chip expects the bits of each byte in reverse order */
+	buf[0] = bitrev8(buf[0]);
+
+	return s35390a_set_reg(s35390a, S35390A_CMD_STATUS2, buf, sizeof(buf));
+}
+
+static int s35390a_rtc_update_irq_enable(struct device *dev, unsigned enabled)
+{
+	return s35390a_update_irq_enable(to_i2c_client(dev), enabled);
+}
+
 static void s35390a_work(struct work_struct *work)
 {
 	struct s35390a *s35390a;
@@ -445,6 +474,7 @@ static const struct rtc_class_ops s35390a_rtc_ops = {
 	.read_alarm		= s35390a_rtc_read_alarm,
 	.irq_set_freq		= s35390a_rtc_set_irq_freq,
 	.irq_set_state		= s35390a_rtc_freq_irq_enable,
+	.update_irq_enable	= s35390a_rtc_update_irq_enable,
 };
 
 static struct i2c_driver s35390a_driver;
-- 
1.6.2.4

