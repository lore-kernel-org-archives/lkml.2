Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932134Ab2IYQ0Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 12:26:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41451 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757207Ab2IYQNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 12:13:14 -0400
From: mathieu.poirier@linaro.org
To: linux-kernel@vger.kernel.org, cbou@mail.ru, dwmw2@infradead.org
Cc: mathieu.poirier@linaro.org
Subject: [PATCH 05/57] power: ab8500_bm: Rename the power_loss function
Date: Tue, 25 Sep 2012 10:12:02 -0600
Message-Id: <1348589574-25655-6-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paer-Olof Haakansson <par-olof.hakansson@stericsson.com>

Rename the ab8500_power_loss_handling function
to a more describing name ab8500_enable_disable_sw_fallback

Signed-off-by: Robert Marklund <robert.marklund@stericsson.com>
Signed-off-by: Paer-Olof Haakansson <par-olof.hakansson@stericsson.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Reviewed-by: Par-Olof HAKANSSON <par-olof.hakansson@stericsson.com>
Reviewed-by: Karl KOMIEROWSKI <karl.komierowski@stericsson.com>
---
 drivers/power/ab8500_charger.c |   23 +++++++++++------------
 1 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
index 22076f5..a7d0c3a 100644
--- a/drivers/power/ab8500_charger.c
+++ b/drivers/power/ab8500_charger.c
@@ -268,20 +268,19 @@ static enum power_supply_property ab8500_charger_usb_props[] = {
 	POWER_SUPPLY_PROP_CURRENT_NOW,
 };
 
-/**
- * ab8500_power_loss_handling - set how we handle powerloss.
- * @di:		pointer to the ab8500_charger structure
- *
- * Magic nummbers are from STE HW department.
+/*
+ * Function for enabling and disabling sw fallback mode
+ * should always be disabled when no charger is connected.
  */
-static void ab8500_power_loss_handling(struct ab8500_charger *di)
+static void ab8500_enable_disable_sw_fallback(struct ab8500_charger *di,
+		bool fallback)
 {
 	u8 reg;
 	int ret;
 
-	dev_dbg(di->dev, "Autopower : %d\n", di->autopower);
+	dev_dbg(di->dev, "SW Fallback: %d\n", fallback);
 
-	/* read the autopower register */
+	/* read the register containing fallback bit */
 	ret = abx500_get_register_interruptible(di->dev, 0x15, 0x00, &reg);
 	if (ret) {
 		dev_err(di->dev, "%d write failed\n", __LINE__);
@@ -295,12 +294,12 @@ static void ab8500_power_loss_handling(struct ab8500_charger *di)
 		return;
 	}
 
-	if (di->autopower)
+	if (fallback)
 		reg |= 0x8;
 	else
 		reg &= ~0x8;
 
-	/* write back the changed value to autopower reg */
+	/* write back the changed fallback bit value to register */
 	ret = abx500_set_register_interruptible(di->dev, 0x15, 0x00, reg);
 	if (ret) {
 		dev_err(di->dev, "%d write failed\n", __LINE__);
@@ -330,12 +329,12 @@ static void ab8500_power_supply_changed(struct ab8500_charger *di,
 		    !di->ac.charger_connected &&
 		    di->autopower) {
 			di->autopower = false;
-			ab8500_power_loss_handling(di);
+			ab8500_enable_disable_sw_fallback(di, false);
 		} else if (!di->autopower &&
 			   (di->ac.charger_connected ||
 			    di->usb.charger_connected)) {
 			di->autopower = true;
-			ab8500_power_loss_handling(di);
+			ab8500_enable_disable_sw_fallback(di, true);
 		}
 	}
 	power_supply_changed(psy);
-- 
1.7.5.4

