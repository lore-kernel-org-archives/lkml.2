Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758399Ab2IYQVM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 12:21:12 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:57024 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757826Ab2IYQNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 12:13:46 -0400
From: mathieu.poirier@linaro.org
To: linux-kernel@vger.kernel.org, cbou@mail.ru, dwmw2@infradead.org
Cc: mathieu.poirier@linaro.org
Subject: [PATCH 28/57] power: ab8500 - Accessing Autopower register fails
Date: Tue, 25 Sep 2012 10:12:25 -0600
Message-Id: <1348589574-25655-29-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicolas Guion <nicolas.guion@stericsson.com>

The fallback software control register has moved in the ab8505
and ab9540.

Signed-off-by: Marcus Cooper <marcus.xm.cooper@stericsson.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Reviewed-by: Mattias WALLIN <mattias.wallin@stericsson.com>
Reviewed-by: Nicolas GUION <nicolas.guion@stericsson.com>
Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
---
 drivers/power/ab8500_charger.c |   53 +++++++++++++++++++++++++++-------------
 1 files changed, 36 insertions(+), 17 deletions(-)

diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
index 0a781a0..ee5ad7b 100644
--- a/drivers/power/ab8500_charger.c
+++ b/drivers/power/ab8500_charger.c
@@ -92,6 +92,8 @@
 
 #define CHG_WD_INTERVAL			(60 * HZ)
 
+#define AB8500_SW_CONTROL_FALLBACK	0x03
+
 /* UsbLineStatus register - usb types */
 enum ab8500_charger_link_status {
 	USB_STAT_NOT_CONFIGURED,
@@ -307,42 +309,59 @@ static enum power_supply_property ab8500_charger_usb_props[] = {
 static void ab8500_enable_disable_sw_fallback(struct ab8500_charger *di,
 		bool fallback)
 {
+	u8 val;
 	u8 reg;
+	u8 bank;
+	u8 bit;
 	int ret;
 
 	dev_dbg(di->dev, "SW Fallback: %d\n", fallback);
 
+	if (is_ab8500(di->parent)) {
+		bank = 0x15;
+		reg = 0x0;
+		bit = 3;
+	} else {
+		bank = AB8500_SYS_CTRL1_BLOCK;
+		reg = AB8500_SW_CONTROL_FALLBACK;
+		bit = 0;
+	}
+
 	/* read the register containing fallback bit */
-	ret = abx500_get_register_interruptible(di->dev, 0x15, 0x00, &reg);
-	if (ret) {
-		dev_err(di->dev, "%d write failed\n", __LINE__);
+	ret = abx500_get_register_interruptible(di->dev, bank, reg, &val);
+	if (ret < 0) {
+		dev_err(di->dev, "%d read failed\n", __LINE__);
 		return;
 	}
 
-	/* enable the OPT emulation registers */
-	ret = abx500_set_register_interruptible(di->dev, 0x11, 0x00, 0x2);
-	if (ret) {
-		dev_err(di->dev, "%d write failed\n", __LINE__);
-		return;
+	if (is_ab8500(di->parent)) {
+		/* enable the OPT emulation registers */
+		ret = abx500_set_register_interruptible(di->dev,
+							 0x11, 0x00, 0x2);
+		if (ret) {
+			dev_err(di->dev, "%d write failed\n", __LINE__);
+			goto disable_otp;
+		}
 	}
 
 	if (fallback)
-		reg |= 0x8;
+		val |= (1 << bit);
 	else
-		reg &= ~0x8;
+		val &= ~(1 << bit);
 
 	/* write back the changed fallback bit value to register */
-	ret = abx500_set_register_interruptible(di->dev, 0x15, 0x00, reg);
+	ret = abx500_set_register_interruptible(di->dev, bank, reg, val);
 	if (ret) {
 		dev_err(di->dev, "%d write failed\n", __LINE__);
-		return;
 	}
 
-	/* disable the set OTP registers again */
-	ret = abx500_set_register_interruptible(di->dev, 0x11, 0x00, 0x0);
-	if (ret) {
-		dev_err(di->dev, "%d write failed\n", __LINE__);
-		return;
+disable_otp:
+	if (is_ab8500(di->parent)) {
+		/* disable the set OTP registers again */
+		ret = abx500_set_register_interruptible(di->dev,
+							 0x11, 0x00, 0x0);
+		if (ret)
+			dev_err(di->dev, "%d write failed\n", __LINE__);
 	}
 }
 
-- 
1.7.5.4

