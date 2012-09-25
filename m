Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758036Ab2IYQOH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 12:14:07 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60753 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757947Ab2IYQN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 12:13:57 -0400
From: mathieu.poirier@linaro.org
To: linux-kernel@vger.kernel.org, cbou@mail.ru, dwmw2@infradead.org
Cc: mathieu.poirier@linaro.org
Subject: [PATCH 36/57] power: add backup battery charge voltages.
Date: Tue, 25 Sep 2012 10:12:33 -0600
Message-Id: <1348589574-25655-37-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yang QU <yang.qu@stericsson.com>

Add 2.7v, 2.9v, 3.0v, 3.2v and 3.3v charging voltage
for backup battery. Before that only 2.5v, 2.6v, 2.8v,
3.1v are available.

Signed-off-by: Yang QU <yang.qu@stericsson.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Reviewed-by: Maxime COQUELIN <maxime.coquelin@stericsson.com>
Reviewed-by: Marcus COOPER <marcus.xm.cooper@stericsson.com>
Reviewed-by: Xiao Mei ZHANG <xiaomei.zhang@stericsson.com>
---
 drivers/power/ab8500_charger.c       |    9 +++++++--
 include/linux/mfd/abx500/ab8500-bm.h |   24 ++++++++++++++++++++----
 2 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
index b3b8f77..8137ea5 100644
--- a/drivers/power/ab8500_charger.c
+++ b/drivers/power/ab8500_charger.c
@@ -2834,6 +2834,7 @@ static int ab8500_charger_usb_get_property(struct power_supply *psy,
 static int ab8500_charger_init_hw_registers(struct ab8500_charger *di)
 {
 	int ret = 0;
+	u8 bup_vch_range = 0, vbup33_vrtcn = 0;
 
 	/* Setup maximum charger current and voltage for ABB cut2.0 */
 	if (!is_ab8500_1p1_or_earlier(di->parent)) {
@@ -2935,11 +2936,15 @@ static int ab8500_charger_init_hw_registers(struct ab8500_charger *di)
 	}
 
 	/* Backup battery voltage and current */
+	if (di->bat->bkup_bat_v > BUP_VCH_SEL_3P1V)
+		bup_vch_range = BUP_VCH_RANGE;
+	if (di->bat->bkup_bat_v == BUP_VCH_SEL_3P3V)
+		vbup33_vrtcn = VBUP33_VRTCN;
+
 	ret = abx500_set_register_interruptible(di->dev,
 		AB8500_RTC,
 		AB8500_RTC_BACKUP_CHG_REG,
-		di->bat->bkup_bat_v |
-		di->bat->bkup_bat_i);
+		(di->bat->bkup_bat_v & 0x3) | di->bat->bkup_bat_i);
 	if (ret) {
 		dev_err(di->dev, "failed to setup backup battery charging\n");
 		goto out;
diff --git a/include/linux/mfd/abx500/ab8500-bm.h b/include/linux/mfd/abx500/ab8500-bm.h
index cd15ea3..5ae8a6f 100644
--- a/include/linux/mfd/abx500/ab8500-bm.h
+++ b/include/linux/mfd/abx500/ab8500-bm.h
@@ -105,6 +105,7 @@
 #define AB8500_RTC_BACKUP_CHG_REG	0x0C
 #define AB8500_RTC_CC_CONF_REG		0x01
 #define AB8500_RTC_CTRL_REG		0x0B
+#define AB8500_RTC_CTRL1_REG		0x11
 
 /*
  * OTP register offsets
@@ -179,10 +180,25 @@
 #define BUP_ICH_SEL_300UA		0x08
 #define BUP_ICH_SEL_700UA		0x0C
 
-#define BUP_VCH_SEL_2P5V		0x00
-#define BUP_VCH_SEL_2P6V		0x01
-#define BUP_VCH_SEL_2P8V		0x02
-#define BUP_VCH_SEL_3P1V		0x03
+enum bup_vch_sel {
+	BUP_VCH_SEL_2P5V,
+	BUP_VCH_SEL_2P6V,
+	BUP_VCH_SEL_2P8V,
+	BUP_VCH_SEL_3P1V,
+	/*
+	 * Note that the following 5 values 2.7v, 2.9v, 3.0v, 3.2v, 3.3v
+	 * are only available on ab8540. You can't choose these 5
+	 * voltage on ab8500/ab8505/ab9540.
+	 */
+	BUP_VCH_SEL_2P7V,
+	BUP_VCH_SEL_2P9V,
+	BUP_VCH_SEL_3P0V,
+	BUP_VCH_SEL_3P2V,
+	BUP_VCH_SEL_3P3V,
+};
+
+#define BUP_VCH_RANGE		0x02
+#define VBUP33_VRTCN		0x01
 
 /* Battery OVV constants */
 #define BATT_OVV_ENA			0x02
-- 
1.7.5.4

