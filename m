Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154Ab2LMPW2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 10:22:28 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:38134 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756084Ab2LMPWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 10:22:24 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: cbou@mail.ru, Marcus Cooper <marcus.xm.cooper@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 17/18] power: ab8500_charger: Adds support for legacy USB chargers
Date: Thu, 13 Dec 2012 15:21:40 +0000
Message-Id: <1355412102-14265-18-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355412102-14265-1-git-send-email-lee.jones@linaro.org>
References: <1355412102-14265-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcus Cooper <marcus.xm.cooper@stericsson.com>

A Legacy USB charger should be handled directly by the charger
driver.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Marcus Cooper <marcus.xm.cooper@stericsson.com>
Reviewed-by: Karl KOMIEROWSKI <karl.komierowski@stericsson.com>
Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
---
 drivers/power/ab8500_charger.c |   65 ++++++++++++++++++++++++++++++++++------
 1 file changed, 56 insertions(+), 9 deletions(-)

diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
index 0ada459..6e4ed4f 100644
--- a/drivers/power/ab8500_charger.c
+++ b/drivers/power/ab8500_charger.c
@@ -88,6 +88,9 @@
 /* Step up/down delay in us */
 #define STEP_UDELAY			1000
 
+/* Wait for enumeration before charging in ms */
+#define WAIT_FOR_USB_ENUMERATION	5 * 1000
+
 #define CHARGER_STATUS_POLL 10 /* in ms */
 
 /* UsbLineStatus register - usb types */
@@ -201,6 +204,7 @@ struct ab8500_charger_usb_state {
  *			charger is enabled
  * @vbat		Battery voltage
  * @old_vbat		Previously measured battery voltage
+ * @usb_device_is_unrecognised	USB device is unrecognised by the hardware
  * @autopower		Indicate if we should have automatic pwron after pwrloss
  * @autopower_cfg	platform specific power config support for "pwron after pwrloss"
  * @parent:		Pointer to the struct ab8500
@@ -219,6 +223,7 @@ struct ab8500_charger_usb_state {
  * @check_usbchgnotok_work:	Work for checking USB charger not ok status
  * @kick_wd_work:		Work for kicking the charger watchdog in case
  *				of ABB rev 1.* due to the watchog logic bug
+ * @attach_work:		Work for checking the usb enumeration
  * @ac_charger_attached_work:	Work for checking if AC charger is still
  *				connected
  * @usb_charger_attached_work:	Work for checking if USB charger is still
@@ -243,6 +248,7 @@ struct ab8500_charger {
 	bool vddadc_en_usb;
 	int vbat;
 	int old_vbat;
+	bool usb_device_is_unrecognised;
 	bool autopower;
 	bool autopower_cfg;
 	struct ab8500 *parent;
@@ -260,6 +266,7 @@ struct ab8500_charger {
 	struct delayed_work check_hw_failure_work;
 	struct delayed_work check_usbchgnotok_work;
 	struct delayed_work kick_wd_work;
+	struct delayed_work attach_work;
 	struct delayed_work ac_charger_attached_work;
 	struct delayed_work usb_charger_attached_work;
 	struct work_struct ac_work;
@@ -597,6 +604,8 @@ static int ab8500_charger_max_usb_curr(struct ab8500_charger *di,
 {
 	int ret = 0;
 
+	di->usb_device_is_unrecognised = false;
+
 	switch (link_status) {
 	case USB_STAT_STD_HOST_NC:
 	case USB_STAT_STD_HOST_C_NS:
@@ -642,9 +651,15 @@ static int ab8500_charger_max_usb_curr(struct ab8500_charger *di,
 		dev_dbg(di->dev, "USB Type - 0x%02x MaxCurr: %d", link_status,
 				di->max_usb_in_curr);
 		break;
+	case USB_STAT_NOT_CONFIGURED:
+		if (di->vbus_detected) {
+			di->usb_device_is_unrecognised = true;
+			dev_dbg(di->dev, "USB Type - Legacy charger.\n");
+			di->max_usb_in_curr = USB_CH_IP_CUR_LVL_1P5;
+			break;
+		}
 	case USB_STAT_HM_IDGND:
 	case USB_STAT_NOT_VALID_LINK:
-	case USB_STAT_NOT_CONFIGURED:
 		dev_err(di->dev, "USB Type - Charging not allowed\n");
 		di->max_usb_in_curr = USB_CH_IP_CUR_LVL_0P05;
 		ret = -ENXIO;
@@ -1915,6 +1930,30 @@ static void ab8500_charger_detect_usb_type_work(struct work_struct *work)
 }
 
 /**
+ * ab8500_charger_usb_link_attach_work() - delayd work to detect USB type
+ * @work:	pointer to the work_struct structure
+ *
+ * Detect the type of USB plugged
+ */
+static void ab8500_charger_usb_link_attach_work(struct work_struct *work)
+{
+	int ret;
+
+	struct ab8500_charger *di = container_of(work,
+		struct ab8500_charger, attach_work.work);
+
+	/* Update maximum input current if USB enumeration is not detected */
+	if (!di->usb.charger_online) {
+		ret = ab8500_charger_set_vbus_in_curr(di, di->max_usb_in_curr);
+		if (ret)
+			return;
+	}
+
+	ab8500_charger_set_usb_connected(di, true);
+	ab8500_power_supply_changed(di, &di->usb_chg.psy);
+}
+
+/**
  * ab8500_charger_usb_link_status_work() - work to detect USB type
  * @work:	pointer to the work_struct structure
  *
@@ -1944,14 +1983,19 @@ static void ab8500_charger_usb_link_status_work(struct work_struct *work)
 		di->vbus_detected = 1;
 		ret = ab8500_charger_read_usb_type(di);
 		if (!ret) {
-			/* Update maximum input current */
-			ret = ab8500_charger_set_vbus_in_curr(di,
-					di->max_usb_in_curr);
-			if (ret)
-				return;
-
-			ab8500_charger_set_usb_connected(di, true);
-			ab8500_power_supply_changed(di, &di->usb_chg.psy);
+			if (di->usb_device_is_unrecognised) {
+				dev_dbg(di->dev,
+					"Potential Legacy Charger device. "
+					"Delay work for %d msec for USB enum "
+					"to finish",
+					WAIT_FOR_USB_ENUMERATION);
+				queue_delayed_work(di->charger_wq,
+					&di->attach_work,
+					msecs_to_jiffies(WAIT_FOR_USB_ENUMERATION));
+			} else {
+				queue_delayed_work(di->charger_wq,
+							&di->attach_work, 0);
+			}
 		} else if (ret == -ENXIO) {
 			/* No valid charger type detected */
 			ab8500_charger_set_usb_connected(di, false);
@@ -2919,6 +2963,9 @@ static int __devinit ab8500_charger_probe(struct platform_device *pdev)
 	INIT_DEFERRABLE_WORK(&di->check_vbat_work,
 		ab8500_charger_check_vbat_work);
 
+	INIT_DELAYED_WORK(&di->attach_work,
+		ab8500_charger_usb_link_attach_work);
+
 	/* Init work for charger detection */
 	INIT_WORK(&di->usb_link_status_work,
 		ab8500_charger_usb_link_status_work);
-- 
1.7.9.5

