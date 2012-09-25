Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758527Ab2IYQWl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 12:22:41 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41451 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757718Ab2IYQNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 12:13:35 -0400
From: mathieu.poirier@linaro.org
To: linux-kernel@vger.kernel.org, cbou@mail.ru, dwmw2@infradead.org
Cc: mathieu.poirier@linaro.org
Subject: [PATCH 20/57] power: Adds support for legacy USB chargers
Date: Tue, 25 Sep 2012 10:12:17 -0600
Message-Id: <1348589574-25655-21-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcus Cooper <marcus.xm.cooper@stericsson.com>

A Legacy USB charger should be handled directly by the charger
driver.

Signed-off-by: Marcus Cooper <marcus.xm.cooper@stericsson.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Reviewed-by: Karl KOMIEROWSKI <karl.komierowski@stericsson.com>
Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
---
 drivers/power/ab8500_charger.c |   66 ++++++++++++++++++++++++++++++++++-----
 1 files changed, 57 insertions(+), 9 deletions(-)

diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
index 4155feb..7cd4165 100644
--- a/drivers/power/ab8500_charger.c
+++ b/drivers/power/ab8500_charger.c
@@ -85,6 +85,9 @@
 /* Step up/down delay in us */
 #define STEP_UDELAY			1000
 
+/* Wait for enumeration before charging in ms */
+#define WAIT_FOR_USB_ENUMERATION	(5 * 1000)
+
 #define CHARGER_STATUS_POLL 10 /* in ms */
 
 /* UsbLineStatus register - usb types */
@@ -198,6 +201,7 @@ struct ab8500_charger_usb_state {
  *			charger is enabled
  * @vbat		Battery voltage
  * @old_vbat		Previously measured battery voltage
+ * @usb_device_is_unrecognised	USB device is unrecognised by the hardware
  * @autopower		Indicate if we should have automatic pwron after pwrloss
  * @parent:		Pointer to the struct ab8500
  * @gpadc:		Pointer to the struct gpadc
@@ -216,6 +220,7 @@ struct ab8500_charger_usb_state {
  * @check_usbchgnotok_work:	Work for checking USB charger not ok status
  * @kick_wd_work:		Work for kicking the charger watchdog in case
  *				of ABB rev 1.* due to the watchog logic bug
+ * @attach_work:		Work for checking the usb enumeration
  * @ac_charger_attached_work:	Work for checking if AC charger is still
  *				connected
  * @usb_charger_attached_work:	Work for checking if USB charger is still
@@ -239,6 +244,7 @@ struct ab8500_charger {
 	bool vddadc_en_usb;
 	int vbat;
 	int old_vbat;
+	bool usb_device_is_unrecognised;
 	bool autopower;
 	struct ab8500 *parent;
 	struct ab8500_gpadc *gpadc;
@@ -256,6 +262,7 @@ struct ab8500_charger {
 	struct delayed_work check_hw_failure_work;
 	struct delayed_work check_usbchgnotok_work;
 	struct delayed_work kick_wd_work;
+	struct delayed_work attach_work;
 	struct delayed_work ac_charger_attached_work;
 	struct delayed_work usb_charger_attached_work;
 	struct work_struct ac_work;
@@ -588,6 +595,8 @@ static int ab8500_charger_max_usb_curr(struct ab8500_charger *di,
 {
 	int ret = 0;
 
+	di->usb_device_is_unrecognised = false;
+
 	switch (link_status) {
 	case USB_STAT_STD_HOST_NC:
 	case USB_STAT_STD_HOST_C_NS:
@@ -633,9 +642,15 @@ static int ab8500_charger_max_usb_curr(struct ab8500_charger *di,
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
@@ -1899,6 +1914,30 @@ static void ab8500_charger_detect_usb_type_work(struct work_struct *work)
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
@@ -1928,14 +1967,20 @@ static void ab8500_charger_usb_link_status_work(struct work_struct *work)
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
+					msecs_to_jiffies
+						(WAIT_FOR_USB_ENUMERATION));
+			} else {
+				queue_delayed_work(di->charger_wq,
+							&di->attach_work, 0);
+			}
 		} else if (ret == -ENXIO) {
 			/* No valid charger type detected */
 			ab8500_charger_set_usb_connected(di, false);
@@ -2886,6 +2931,9 @@ static int __devinit ab8500_charger_probe(struct platform_device *pdev)
 	INIT_DELAYED_WORK_DEFERRABLE(&di->kick_wd_work,
 		ab8500_charger_kick_watchdog_work);
 
+	INIT_DELAYED_WORK(&di->attach_work,
+		ab8500_charger_usb_link_attach_work);
+
 	INIT_DELAYED_WORK_DEFERRABLE(&di->check_vbat_work,
 		ab8500_charger_check_vbat_work);
 
-- 
1.7.5.4

