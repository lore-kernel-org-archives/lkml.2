Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932656Ab2EJMLt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 08:11:49 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:35649 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756730Ab2EJMLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 08:11:46 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Rob Landley <rob@landley.net>, Richard Purdie <rpurdie@rpsys.net>,
        Jonathan Cameron <jic23@cam.ac.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 1/2] mfd: lm3533: add boost frequency and ovp to platform data
Date: Thu, 10 May 2012 14:11:28 +0200
Message-Id: <1336651889-6425-1-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.7.8.5
In-Reply-To: <20120510120742.GA29437@localhost>
References: <20120510120742.GA29437@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add boost-frequency and over-voltage-protection settings to platform
data.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/mfd/lm3533-core.c  |   50 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/lm3533.h |   15 +++++++++++++
 2 files changed, 65 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/lm3533-core.c b/drivers/mfd/lm3533-core.c
index 75f4b7f..053438c 100644
--- a/drivers/mfd/lm3533-core.c
+++ b/drivers/mfd/lm3533-core.c
@@ -138,6 +138,35 @@ int lm3533_update(struct lm3533 *lm3533, u8 reg, u8 val, u8 mask)
 }
 EXPORT_SYMBOL_GPL(lm3533_update);
 
+static int lm3533_set_boost_freq(struct lm3533 *lm3533,
+						enum lm3533_boost_freq freq)
+{
+	int ret;
+
+	ret = lm3533_update(lm3533, LM3533_REG_BOOST_PWM,
+					freq << LM3533_BOOST_FREQ_SHIFT,
+					LM3533_BOOST_FREQ_MASK);
+	if (ret)
+		dev_err(lm3533->dev, "failed to set boost frequency\n");
+
+	return ret;
+}
+
+
+static int lm3533_set_boost_ovp(struct lm3533 *lm3533,
+						enum lm3533_boost_ovp ovp)
+{
+	int ret;
+
+	ret = lm3533_update(lm3533, LM3533_REG_BOOST_PWM,
+					ovp << LM3533_BOOST_OVP_SHIFT,
+					LM3533_BOOST_OVP_MASK);
+	if (ret)
+		dev_err(lm3533->dev, "failed to set boost ovp\n");
+
+	return ret;
+}
+
 /*
  * HVLED output config -- output hvled controlled by backlight bl
  */
@@ -521,6 +550,22 @@ static int __devinit lm3533_device_led_init(struct lm3533 *lm3533)
 	return 0;
 }
 
+static int __devinit lm3533_device_setup(struct lm3533 *lm3533,
+					struct lm3533_platform_data *pdata)
+{
+	int ret;
+
+	ret = lm3533_set_boost_freq(lm3533, pdata->boost_freq);
+	if (ret)
+		return ret;
+
+	ret = lm3533_set_boost_ovp(lm3533, pdata->boost_ovp);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
 static int __devinit lm3533_device_init(struct lm3533 *lm3533)
 {
 	struct lm3533_platform_data *pdata = lm3533->dev->platform_data;
@@ -550,6 +595,10 @@ static int __devinit lm3533_device_init(struct lm3533 *lm3533)
 
 	lm3533_enable(lm3533);
 
+	ret = lm3533_device_setup(lm3533, pdata);
+	if (ret)
+		goto err_disable;
+
 	lm3533_device_als_init(lm3533);
 	lm3533_device_bl_init(lm3533);
 	lm3533_device_led_init(lm3533);
@@ -564,6 +613,7 @@ static int __devinit lm3533_device_init(struct lm3533 *lm3533)
 
 err_unregister:
 	mfd_remove_devices(lm3533->dev);
+err_disable:
 	lm3533_disable(lm3533);
 	if (gpio_is_valid(lm3533->gpio_hwen))
 		gpio_free(lm3533->gpio_hwen);
diff --git a/include/linux/mfd/lm3533.h b/include/linux/mfd/lm3533.h
index 75f85f3..3361137 100644
--- a/include/linux/mfd/lm3533.h
+++ b/include/linux/mfd/lm3533.h
@@ -59,9 +59,24 @@ struct lm3533_led_platform_data {
 	u8 pwm;				/* 0 - 0x3f */
 };
 
+enum lm3533_boost_freq {
+	LM3533_BOOST_FREQ_500KHZ,
+	LM3533_BOOST_FREQ_1000KHZ,
+};
+
+enum lm3533_boost_ovp {
+	LM3533_BOOST_OVP_16V,
+	LM3533_BOOST_OVP_24V,
+	LM3533_BOOST_OVP_32V,
+	LM3533_BOOST_OVP_40V,
+};
+
 struct lm3533_platform_data {
 	int gpio_hwen;
 
+	enum lm3533_boost_ovp boost_ovp;
+	enum lm3533_boost_freq boost_freq;
+
 	struct lm3533_als_platform_data *als;
 
 	struct lm3533_bl_platform_data *backlights;
-- 
1.7.8.5

