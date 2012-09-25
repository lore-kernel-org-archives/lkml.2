Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758364Ab2IYQUT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 12:20:19 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41451 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757851Ab2IYQNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 12:13:51 -0400
From: mathieu.poirier@linaro.org
To: linux-kernel@vger.kernel.org, cbou@mail.ru, dwmw2@infradead.org
Cc: mathieu.poirier@linaro.org
Subject: [PATCH 32/57] power: ab8500_charger: Do not touch VBUSOVV bits
Date: Tue, 25 Sep 2012 10:12:29 -0600
Message-Id: <1348589574-25655-33-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonas Aaberg <jonas.aberg@stericsson.com>

Do not touch the VBUSOVV in USBCHTRL2 when running on AB8505.

Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Reviewed-by: Marcus COOPER <marcus.xm.cooper@stericsson.com>
---
 drivers/power/ab8500_charger.c    |   22 ++++++++++++++++------
 include/linux/mfd/abx500/ab8500.h |   10 ++++++++++
 2 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
index 071c7c2..2a323cf 100644
--- a/drivers/power/ab8500_charger.c
+++ b/drivers/power/ab8500_charger.c
@@ -2667,13 +2667,23 @@ static int ab8500_charger_init_hw_registers(struct ab8500_charger *di)
 		}
 	}
 
-	/* VBUS OVV set to 6.3V and enable automatic current limitiation */
-	ret = abx500_set_register_interruptible(di->dev,
-		AB8500_CHARGER,
-		AB8500_USBCH_CTRL2_REG,
-		VBUS_OVV_SELECT_6P3V | VBUS_AUTO_IN_CURR_LIM_ENA);
+	if (is_ab9540_2p0(di->parent) || is_ab8505_2p0(di->parent))
+		ret = abx500_mask_and_set_register_interruptible(di->dev,
+			AB8500_CHARGER,
+			AB8500_USBCH_CTRL2_REG,
+			VBUS_AUTO_IN_CURR_LIM_ENA,
+			VBUS_AUTO_IN_CURR_LIM_ENA);
+	else
+		/*
+		 * VBUS OVV set to 6.3V and enable automatic current limitation
+		 */
+		ret = abx500_set_register_interruptible(di->dev,
+			AB8500_CHARGER,
+			AB8500_USBCH_CTRL2_REG,
+			VBUS_OVV_SELECT_6P3V | VBUS_AUTO_IN_CURR_LIM_ENA);
 	if (ret) {
-		dev_err(di->dev, "failed to set VBUS OVV\n");
+		dev_err(di->dev,
+			"failed to set automatic current limitation\n");
 		goto out;
 	}
 
diff --git a/include/linux/mfd/abx500/ab8500.h b/include/linux/mfd/abx500/ab8500.h
index 087b445..5a4b186 100644
--- a/include/linux/mfd/abx500/ab8500.h
+++ b/include/linux/mfd/abx500/ab8500.h
@@ -351,6 +351,16 @@ static inline int is_ab8500_2p0(struct ab8500 *ab)
 	return (is_ab8500(ab) && (ab->chip_id == AB8500_CUT2P0));
 }
 
+static inline int is_ab8505_2p0(struct ab8500 *ab)
+{
+	return (is_ab8505(ab) && (ab->chip_id == AB8500_CUT2P0));
+}
+
+static inline int is_ab9540_2p0(struct ab8500 *ab)
+{
+	return (is_ab9540(ab) && (ab->chip_id == AB8500_CUT2P0));
+}
+
 int ab8500_irq_get_virq(struct ab8500 *ab8500, int irq);
 
 #endif /* MFD_AB8500_H */
-- 
1.7.5.4

