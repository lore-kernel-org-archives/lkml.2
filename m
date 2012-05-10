Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758314Ab2EJRTI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 13:19:08 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:47838 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758627Ab2EJRSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 13:18:49 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Richard Purdie <rpurdie@rpsys.net>, Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 2/2] mfd: lm3533: use SI-units for max-current interface
Date: Thu, 10 May 2012 19:18:29 +0200
Message-Id: <1336670309-20858-3-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.7.8.5
In-Reply-To: <1336670309-20858-1-git-send-email-jhovold@gmail.com>
References: <20120510120742.GA29437@localhost>
 <1336670309-20858-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use SI-units (uA) for max-current interface (5000 - 29800 uA).

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/mfd/lm3533-ctrlbank.c |   43 +++++++++++++++++++++++++++-------------
 include/linux/mfd/lm3533.h    |    7 +++--
 2 files changed, 33 insertions(+), 17 deletions(-)

diff --git a/drivers/mfd/lm3533-ctrlbank.c b/drivers/mfd/lm3533-ctrlbank.c
index adf4c1a..a4cb7a5 100644
--- a/drivers/mfd/lm3533-ctrlbank.c
+++ b/drivers/mfd/lm3533-ctrlbank.c
@@ -17,8 +17,11 @@
 #include <linux/mfd/lm3533.h>
 
 
+#define LM3533_MAX_CURRENT_MIN		5000
+#define LM3533_MAX_CURRENT_MAX		29800
+#define LM3533_MAX_CURRENT_STEP		800
+
 #define LM3533_BRIGHTNESS_MAX		255
-#define LM3533_MAX_CURRENT_MAX		31
 #define LM3533_PWM_MAX			0x3f
 
 #define LM3533_REG_PWM_BASE		0x14
@@ -65,6 +68,31 @@ int lm3533_ctrlbank_disable(struct lm3533_ctrlbank *cb)
 }
 EXPORT_SYMBOL_GPL(lm3533_ctrlbank_disable);
 
+/*
+ * Full-scale current.
+ *
+ * imax		5000 - 29800 uA (800 uA step)
+ */
+int lm3533_ctrlbank_set_max_current(struct lm3533_ctrlbank *cb, u16 imax)
+{
+	u8 reg;
+	u8 val;
+	int ret;
+
+	if (imax < LM3533_MAX_CURRENT_MIN || imax > LM3533_MAX_CURRENT_MAX)
+		return -EINVAL;
+
+	val = (imax - LM3533_MAX_CURRENT_MIN) / LM3533_MAX_CURRENT_STEP;
+
+	reg = lm3533_ctrlbank_get_reg(cb, LM3533_REG_MAX_CURRENT_BASE);
+	ret = lm3533_write(cb->lm3533, reg, val);
+	if (ret)
+		dev_err(cb->dev, "failed to set max current\n");
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(lm3533_ctrlbank_set_max_current);
+
 #define lm3533_ctrlbank_set(_name, _NAME)				\
 int lm3533_ctrlbank_set_##_name(struct lm3533_ctrlbank *cb, u8 val)	\
 {									\
@@ -102,19 +130,6 @@ lm3533_ctrlbank_set(brightness, BRIGHTNESS);
 lm3533_ctrlbank_get(brightness, BRIGHTNESS);
 
 /*
- * Full scale current.
- *
- * Imax = 5 + val * 0.8 mA, e.g.:
- *
- *    0 - 5 mA
- *     ...
- *   19 - 20.2 mA (default)
- *     ...
- *   31 - 29.8 mA
- */
-lm3533_ctrlbank_set(max_current, MAX_CURRENT);
-
-/*
  * PWM-input control mask:
  *
  *   bit 5 - PWM-input enabled in Zone 4
diff --git a/include/linux/mfd/lm3533.h b/include/linux/mfd/lm3533.h
index 7cfef9e..9660feb 100644
--- a/include/linux/mfd/lm3533.h
+++ b/include/linux/mfd/lm3533.h
@@ -47,15 +47,15 @@ struct lm3533_als_platform_data {
 
 struct lm3533_bl_platform_data {
 	char *name;
+	u16 max_current;		/* 5000 - 29800 uA (800 uA step) */
 	u8 default_brightness;		/* 0 - 255 */
-	u8 max_current;			/* 0 - 31 */
 	u8 pwm;				/* 0 - 0x3f */
 };
 
 struct lm3533_led_platform_data {
 	char *name;
 	const char *default_trigger;
-	u8 max_current;			/* 0 - 31 */
+	u16 max_current;		/* 5000 - 29800 uA (800 uA step) */
 	u8 pwm;				/* 0 - 0x3f */
 };
 
@@ -91,7 +91,8 @@ extern int lm3533_ctrlbank_disable(struct lm3533_ctrlbank *cb);
 
 extern int lm3533_ctrlbank_set_brightness(struct lm3533_ctrlbank *cb, u8 val);
 extern int lm3533_ctrlbank_get_brightness(struct lm3533_ctrlbank *cb, u8 *val);
-extern int lm3533_ctrlbank_set_max_current(struct lm3533_ctrlbank *cb, u8 val);
+extern int lm3533_ctrlbank_set_max_current(struct lm3533_ctrlbank *cb,
+								u16 imax);
 extern int lm3533_ctrlbank_set_pwm(struct lm3533_ctrlbank *cb, u8 val);
 extern int lm3533_ctrlbank_get_pwm(struct lm3533_ctrlbank *cb, u8 *val);
 
-- 
1.7.8.5

