Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758247Ab2IYQRx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 12:17:53 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41451 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758031Ab2IYQOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 12:14:06 -0400
From: mathieu.poirier@linaro.org
To: linux-kernel@vger.kernel.org, cbou@mail.ru, dwmw2@infradead.org
Cc: mathieu.poirier@linaro.org
Subject: [PATCH 43/57] power: charging: Add AB8505_USB_LINK_STATUS
Date: Tue, 25 Sep 2012 10:12:40 -0600
Message-Id: <1348589574-25655-44-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hakan Berg <hakan.berg@stericsson.com>

The ab8505 does not have the same address for USB link-status
as has ab8500. Add AB8505_USB_LINK_STATUS and code to switch
to correct constant.

Signed-off-by: Hakan Berg <hakan.berg@stericsson.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Reviewed-by: Mian Yousaf KAUKAB <mian.yousaf.kaukab@stericsson.com>
Reviewed-by: Marcus COOPER <marcus.xm.cooper@stericsson.com>
Reviewed-by: Rabin VINCENT <rabin.vincent@stericsson.com>
---
 drivers/power/ab8500_charger.c |   46 ++++++++++++++++++++++++++++++++-------
 1 files changed, 37 insertions(+), 9 deletions(-)

diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
index 18931e4..9449a33 100644
--- a/drivers/power/ab8500_charger.c
+++ b/drivers/power/ab8500_charger.c
@@ -77,6 +77,7 @@
 
 /* UsbLineStatus register bit masks */
 #define AB8500_USB_LINK_STATUS		0x78
+#define AB8505_USB_LINK_STATUS		0xF8
 #define AB8500_STD_HOST_SUSP		0x18
 
 /* Watchdog timeout constant */
@@ -801,10 +802,12 @@ static int ab8500_charger_read_usb_type(struct ab8500_charger *di)
 	if (is_ab8500(di->parent)) {
 		ret = abx500_get_register_interruptible(di->dev, AB8500_USB,
 				AB8500_USB_LINE_STAT_REG, &val);
-	} else {
-		if (is_ab9540(di->parent) || is_ab8505(di->parent))
+	} else if (is_ab9540(di->parent) || is_ab8505(di->parent)) {
 			ret = abx500_get_register_interruptible(di->dev,
 				AB8500_USB, AB8500_USB_LINK1_STAT_REG, &val);
+	} else {
+		dev_err(di->dev, "%s unsupported analog baseband\n", __func__);
+		return -ENXIO;
 	}
 	if (ret < 0) {
 		dev_err(di->dev, "%s ab8500 read failed\n", __func__);
@@ -812,7 +815,14 @@ static int ab8500_charger_read_usb_type(struct ab8500_charger *di)
 	}
 
 	/* get the USB type */
-	val = (val & AB8500_USB_LINK_STATUS) >> 3;
+	if (is_ab8500(di->parent)) {
+		val = (val & AB8500_USB_LINK_STATUS) >> 3;
+	} else if (is_ab9540(di->parent) || is_ab8505(di->parent)) {
+		val = (val & AB8505_USB_LINK_STATUS) >> 3;
+	} else {
+		dev_err(di->dev, "%s unsupported analog baseband\n", __func__);
+		return -ENXIO;
+	}
 	ret = ab8500_charger_max_usb_curr(di,
 		(enum ab8500_charger_link_status) val);
 
@@ -848,12 +858,17 @@ static int ab8500_charger_detect_usb_type(struct ab8500_charger *di)
 			return ret;
 		}
 
-		if (is_ab8500(di->parent))
+		if (is_ab8500(di->parent)) {
 			ret = abx500_get_register_interruptible(di->dev,
 				AB8500_USB, AB8500_USB_LINE_STAT_REG, &val);
-		else
+		} else if (is_ab9540(di->parent) || is_ab8505(di->parent)) {
 			ret = abx500_get_register_interruptible(di->dev,
 				AB8500_USB, AB8500_USB_LINK1_STAT_REG, &val);
+		} else {
+			dev_err(di->dev,
+				 "%s unsupported analog baseband\n", __func__);
+			return -ENXIO;
+		}
 		if (ret < 0) {
 			dev_err(di->dev, "%s ab8500 read failed\n", __func__);
 			return ret;
@@ -867,7 +882,15 @@ static int ab8500_charger_detect_usb_type(struct ab8500_charger *di)
 		 */
 
 		/* get the USB type */
-		val = (val & AB8500_USB_LINK_STATUS) >> 3;
+		if (is_ab8500(di->parent)) {
+			val = (val & AB8500_USB_LINK_STATUS) >> 3;
+		} else if (is_ab9540(di->parent) || is_ab8505(di->parent)) {
+			val = (val & AB8505_USB_LINK_STATUS) >> 3;
+		} else {
+			dev_err(di->dev,
+				 "%s unsupported analog baseband\n", __func__);
+			return -ENXIO;
+		}
 		if (val)
 			break;
 	}
@@ -2277,6 +2300,7 @@ static void ab8500_charger_usb_link_status_work(struct work_struct *work)
 	int detected_chargers;
 	int ret;
 	u8 val;
+	u8 link_status;
 
 	struct ab8500_charger *di = container_of(work,
 		struct ab8500_charger, usb_link_status_work);
@@ -2303,9 +2327,13 @@ static void ab8500_charger_usb_link_status_work(struct work_struct *work)
 	else
 		dev_dbg(di->dev, "Error reading USB link status\n");
 
+	if (is_ab9540(di->parent) || is_ab8505(di->parent))
+		link_status = AB8505_USB_LINK_STATUS;
+	else
+		link_status = AB8500_USB_LINK_STATUS;
+
 	if (detected_chargers & USB_PW_CONN) {
-		if (((val & AB8500_USB_LINK_STATUS) >> 3) ==
-						USB_STAT_NOT_VALID_LINK &&
+		if (((val & link_status) >> 3) == USB_STAT_NOT_VALID_LINK &&
 				di->invalid_charger_detect_state == 0) {
 			dev_dbg(di->dev,
 				 "Invalid charger detected, state= 0\n");
@@ -2338,7 +2366,7 @@ static void ab8500_charger_usb_link_status_work(struct work_struct *work)
 						AB8500_USB_LINE_STAT_REG,
 						&val);
 			dev_dbg(di->dev, "USB link status= 0x%02x\n",
-					(val & AB8500_USB_LINK_STATUS) >> 3);
+					(val & link_status) >> 3);
 			di->invalid_charger_detect_state = 2;
 		}
 	} else {
-- 
1.7.5.4

