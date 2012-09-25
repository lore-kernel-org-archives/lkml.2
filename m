Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757619Ab2IYQNa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 12:13:30 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:57024 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757598Ab2IYQN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 12:13:27 -0400
From: mathieu.poirier@linaro.org
To: linux-kernel@vger.kernel.org, cbou@mail.ru, dwmw2@infradead.org
Cc: mathieu.poirier@linaro.org
Subject: [PATCH 14/57] power: Adds support for Car/Travel Adapters
Date: Tue, 25 Sep 2012 10:12:11 -0600
Message-Id: <1348589574-25655-15-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hakan Berg <hakan.berg@stericsson.com>

The Travel and Carkit adapter should be handled directly by
the charger driver.

Signed-off-by: Marcus Cooper <marcus.xm.cooper@stericsson.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
---
 drivers/power/ab8500_charger.c       |   94 +++++++++++++++++++++++++---------
 include/linux/mfd/abx500/ab8500-bm.h |    1 +
 2 files changed, 70 insertions(+), 25 deletions(-)

diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
index 06a7c8b..09edd9c 100644
--- a/drivers/power/ab8500_charger.c
+++ b/drivers/power/ab8500_charger.c
@@ -105,6 +105,18 @@ enum ab8500_charger_link_status {
 	USB_STAT_HM_IDGND,
 	USB_STAT_RESERVED,
 	USB_STAT_NOT_VALID_LINK,
+	USB_STAT_PHY_EN,
+	USB_STAT_SUP_NO_IDGND_VBUS,
+	USB_STAT_SUP_IDGND_VBUS,
+	USB_STAT_CHARGER_LINE_1,
+	USB_STAT_CARKIT_1,
+	USB_STAT_CARKIT_2,
+	USB_STAT_ACA_DOCK_CHARGER,
+	USB_STAT_SAMSUNG_USB_PHY_DIS,
+	USB_STAT_SAMSUNG_USB_PHY_ENA,
+	USB_STAT_SAMSUNG_UART_PHY_DIS,
+	USB_STAT_SAMSUNG_UART_PHY_ENA,
+	USB_STAT_MOTOROLA_USB_PHY_ENA,
 };
 
 enum ab8500_usb_state {
@@ -577,7 +589,7 @@ static int ab8500_charger_detect_chargers(struct ab8500_charger *di)
  * Returns error code in case of failure else 0 on success
  */
 static int ab8500_charger_max_usb_curr(struct ab8500_charger *di,
-	enum ab8500_charger_link_status link_status)
+		enum ab8500_charger_link_status link_status)
 {
 	int ret = 0;
 
@@ -585,16 +597,20 @@ static int ab8500_charger_max_usb_curr(struct ab8500_charger *di,
 	case USB_STAT_STD_HOST_NC:
 	case USB_STAT_STD_HOST_C_NS:
 	case USB_STAT_STD_HOST_C_S:
-		dev_dbg(di->dev, "USB Type - Standard host is "
-			"detected through USB driver\n");
+		dev_dbg(di->dev, "USB Type - Standard host is ");
+		dev_dbg(di->dev, "detected through USB driver\n");
 		di->max_usb_in_curr = USB_CH_IP_CUR_LVL_0P09;
 		break;
 	case USB_STAT_HOST_CHG_HS_CHIRP:
 		di->max_usb_in_curr = USB_CH_IP_CUR_LVL_0P5;
+		dev_dbg(di->dev, "USB Type - 0x%02x MaxCurr: %d", link_status,
+				di->max_usb_in_curr);
 		break;
 	case USB_STAT_HOST_CHG_HS:
 	case USB_STAT_ACA_RID_C_HS:
 		di->max_usb_in_curr = USB_CH_IP_CUR_LVL_0P9;
+		dev_dbg(di->dev, "USB Type - 0x%02x MaxCurr: %d", link_status,
+				di->max_usb_in_curr);
 		break;
 	case USB_STAT_ACA_RID_A:
 		/*
@@ -602,6 +618,8 @@ static int ab8500_charger_max_usb_curr(struct ab8500_charger *di,
 		 * can consume (300mA). Closest level is 1100mA
 		 */
 		di->max_usb_in_curr = USB_CH_IP_CUR_LVL_1P1;
+		dev_dbg(di->dev, "USB Type - 0x%02x MaxCurr: %d", link_status,
+				di->max_usb_in_curr);
 		break;
 	case USB_STAT_ACA_RID_B:
 		/*
@@ -609,34 +627,50 @@ static int ab8500_charger_max_usb_curr(struct ab8500_charger *di,
 		 * 100mA for potential accessory). Closest level is 1300mA
 		 */
 		di->max_usb_in_curr = USB_CH_IP_CUR_LVL_1P3;
+		dev_dbg(di->dev, "USB Type - 0x%02x MaxCurr: %d", link_status,
+				di->max_usb_in_curr);
 		break;
-	case USB_STAT_DEDICATED_CHG:
 	case USB_STAT_HOST_CHG_NM:
-	case USB_STAT_ACA_RID_C_HS_CHIRP:
+	case USB_STAT_DEDICATED_CHG:
 	case USB_STAT_ACA_RID_C_NM:
+	case USB_STAT_ACA_RID_C_HS_CHIRP:
 		di->max_usb_in_curr = USB_CH_IP_CUR_LVL_1P5;
-		break;
-	case USB_STAT_RESERVED:
-		/*
-		 * This state is used to indicate that VBUS has dropped below
-		 * the detection level 4 times in a row. This is due to the
-		 * charger output current is set to high making the charger
-		 * voltage collapse. This have to be propagated through to
-		 * chargalg. This is done using the property
-		 * POWER_SUPPLY_PROP_CURRENT_AVG = 1
-		 */
-		di->flags.vbus_collapse = true;
-		dev_dbg(di->dev, "USB Type - USB_STAT_RESERVED "
-			"VBUS has collapsed\n");
-		ret = -1;
+		dev_dbg(di->dev, "USB Type - 0x%02x MaxCurr: %d", link_status,
+				di->max_usb_in_curr);
 		break;
 	case USB_STAT_HM_IDGND:
-	case USB_STAT_NOT_CONFIGURED:
 	case USB_STAT_NOT_VALID_LINK:
+	case USB_STAT_NOT_CONFIGURED:
 		dev_err(di->dev, "USB Type - Charging not allowed\n");
 		di->max_usb_in_curr = USB_CH_IP_CUR_LVL_0P05;
 		ret = -ENXIO;
 		break;
+	case USB_STAT_RESERVED:
+		if (is_ab8500(di->parent)) {
+			di->flags.vbus_collapse = true;
+			dev_err(di->dev, "USB Type - USB_STAT_RESERVED ");
+			dev_err(di->dev, "VBUS has collapsed\n");
+			ret = -ENXIO;
+			break;
+		}
+		if (is_ab9540(di->parent) || is_ab8505(di->parent)) {
+			dev_dbg(di->dev, "USB Type - Charging not allowed\n");
+			di->max_usb_in_curr = USB_CH_IP_CUR_LVL_0P05;
+			dev_dbg(di->dev, "USB Type - 0x%02x MaxCurr: %d",
+					link_status, di->max_usb_in_curr);
+			ret = -ENXIO;
+			break;
+		}
+		break;
+	case USB_STAT_CARKIT_1:
+	case USB_STAT_CARKIT_2:
+	case USB_STAT_ACA_DOCK_CHARGER:
+	case USB_STAT_CHARGER_LINE_1:
+		di->max_usb_in_curr = USB_CH_IP_CUR_LVL_0P5;
+		dev_dbg(di->dev, "USB Type - 0x%02x MaxCurr: %d", link_status,
+				di->max_usb_in_curr);
+		break;
+
 	default:
 		dev_err(di->dev, "USB Type - Unknown\n");
 		di->max_usb_in_curr = USB_CH_IP_CUR_LVL_0P05;
@@ -668,8 +702,14 @@ static int ab8500_charger_read_usb_type(struct ab8500_charger *di)
 		dev_err(di->dev, "%s ab8500 read failed\n", __func__);
 		return ret;
 	}
-	ret = abx500_get_register_interruptible(di->dev, AB8500_USB,
-		AB8500_USB_LINE_STAT_REG, &val);
+	if (is_ab8500(di->parent)) {
+		ret = abx500_get_register_interruptible(di->dev, AB8500_USB,
+				AB8500_USB_LINE_STAT_REG, &val);
+	} else {
+		if (is_ab9540(di->parent) || is_ab8505(di->parent))
+			ret = abx500_get_register_interruptible(di->dev,
+				AB8500_USB, AB8500_USB_LINK1_STAT_REG, &val);
+	}
 	if (ret < 0) {
 		dev_err(di->dev, "%s ab8500 read failed\n", __func__);
 		return ret;
@@ -709,8 +749,13 @@ static int ab8500_charger_detect_usb_type(struct ab8500_charger *di)
 			dev_err(di->dev, "%s ab8500 read failed\n", __func__);
 			return ret;
 		}
-		ret = abx500_get_register_interruptible(di->dev, AB8500_USB,
-			AB8500_USB_LINE_STAT_REG, &val);
+
+		if (is_ab8500(di->parent))
+			ret = abx500_get_register_interruptible(di->dev,
+				AB8500_USB, AB8500_USB_LINE_STAT_REG, &val);
+		else
+			ret = abx500_get_register_interruptible(di->dev,
+				AB8500_USB, AB8500_USB_LINK1_STAT_REG, &val);
 		if (ret < 0) {
 			dev_err(di->dev, "%s ab8500 read failed\n", __func__);
 			return ret;
@@ -2922,7 +2967,6 @@ static int __devinit ab8500_charger_probe(struct platform_device *pdev)
 	}
 
 	if (charger_status & USB_PW_CONN) {
-		dev_dbg(di->dev, "VBUS Detect during startup\n");
 		di->vbus_detected = true;
 		di->vbus_detected_start = true;
 		queue_work(di->charger_wq,
diff --git a/include/linux/mfd/abx500/ab8500-bm.h b/include/linux/mfd/abx500/ab8500-bm.h
index 73479f0..25af2c1 100644
--- a/include/linux/mfd/abx500/ab8500-bm.h
+++ b/include/linux/mfd/abx500/ab8500-bm.h
@@ -23,6 +23,7 @@
  * Bank : 0x5
  */
 #define AB8500_USB_LINE_STAT_REG	0x80
+#define AB8500_USB_LINK1_STAT_REG	0x94
 
 /*
  * Charger / status register offfsets
-- 
1.7.5.4

