Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971Ab2LMPWP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 10:22:15 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:57841 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755847Ab2LMPWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 10:22:11 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: cbou@mail.ru, Hakan Berg <hakan.berg@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Marcus Cooper <marcus.xm.cooper@stericsson.com>
Subject: [PATCH 10/18] power: ab8500_bm: Adds support for Car/Travel Adapters
Date: Thu, 13 Dec 2012 15:21:33 +0000
Message-Id: <1355412102-14265-11-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355412102-14265-1-git-send-email-lee.jones@linaro.org>
References: <1355412102-14265-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hakan Berg <hakan.berg@stericsson.com>

The Travel and Carkit adapter should be handled directly by
the charger driver.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Marcus Cooper <marcus.xm.cooper@stericsson.com>
Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
---
 drivers/power/ab8500_charger.c       |   92 +++++++++++++++++++++++++---------
 include/linux/mfd/abx500/ab8500-bm.h |    1 +
 2 files changed, 69 insertions(+), 24 deletions(-)

diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
index 6a78e31..7ecbd33 100644
--- a/drivers/power/ab8500_charger.c
+++ b/drivers/power/ab8500_charger.c
@@ -108,6 +108,18 @@ enum ab8500_charger_link_status {
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
@@ -586,7 +598,7 @@ static int ab8500_charger_detect_chargers(struct ab8500_charger *di)
  * Returns error code in case of failure else 0 on success
  */
 static int ab8500_charger_max_usb_curr(struct ab8500_charger *di,
-	enum ab8500_charger_link_status link_status)
+		enum ab8500_charger_link_status link_status)
 {
 	int ret = 0;
 
@@ -595,15 +607,19 @@ static int ab8500_charger_max_usb_curr(struct ab8500_charger *di,
 	case USB_STAT_STD_HOST_C_NS:
 	case USB_STAT_STD_HOST_C_S:
 		dev_dbg(di->dev, "USB Type - Standard host is "
-			"detected through USB driver\n");
+				"detected through USB driver\n");
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
@@ -611,6 +627,8 @@ static int ab8500_charger_max_usb_curr(struct ab8500_charger *di,
 		 * can consume (300mA). Closest level is 1100mA
 		 */
 		di->max_usb_in_curr = USB_CH_IP_CUR_LVL_1P1;
+		dev_dbg(di->dev, "USB Type - 0x%02x MaxCurr: %d", link_status,
+				di->max_usb_in_curr);
 		break;
 	case USB_STAT_ACA_RID_B:
 		/*
@@ -618,34 +636,50 @@ static int ab8500_charger_max_usb_curr(struct ab8500_charger *di,
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
+			dev_err(di->dev, "USB Type - USB_STAT_RESERVED "
+						"VBUS has collapsed\n");
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
@@ -677,8 +711,14 @@ static int ab8500_charger_read_usb_type(struct ab8500_charger *di)
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
@@ -718,8 +758,13 @@ static int ab8500_charger_detect_usb_type(struct ab8500_charger *di)
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
@@ -2950,7 +2995,6 @@ static int __devinit ab8500_charger_probe(struct platform_device *pdev)
 	}
 
 	if (charger_status & USB_PW_CONN) {
-		dev_dbg(di->dev, "VBUS Detect during startup\n");
 		di->vbus_detected = true;
 		di->vbus_detected_start = true;
 		queue_work(di->charger_wq,
diff --git a/include/linux/mfd/abx500/ab8500-bm.h b/include/linux/mfd/abx500/ab8500-bm.h
index fac684a..e2a1e6d 100644
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
1.7.9.5

