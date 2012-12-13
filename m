Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947Ab2LMP0Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 10:26:25 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:36035 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754660Ab2LMPWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 10:22:00 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: cbou@mail.ru, Jonas Aaberg <jonas.aberg@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 03/18] power: ab8500_charger: Detect removed charger
Date: Thu, 13 Dec 2012 15:21:26 +0000
Message-Id: <1355412102-14265-4-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355412102-14265-1-git-send-email-lee.jones@linaro.org>
References: <1355412102-14265-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonas Aaberg <jonas.aberg@stericsson.com>

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
---
 drivers/power/ab8500_charger.c |  145 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 144 insertions(+), 1 deletion(-)

diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
index d6e1792..8c09444 100644
--- a/drivers/power/ab8500_charger.c
+++ b/drivers/power/ab8500_charger.c
@@ -31,6 +31,7 @@
 #include <linux/mfd/abx500/ab8500-gpadc.h>
 #include <linux/mfd/abx500/ux500_chargalg.h>
 #include <linux/usb/otg.h>
+#include <linux/mutex.h>
 
 /* Charger constants */
 #define NO_PW_CONN			0
@@ -68,6 +69,11 @@
 #define MAIN_CH_NOK			0x01
 #define VBUS_DET			0x80
 
+#define MAIN_CH_STATUS2_MAINCHGDROP		0x80
+#define MAIN_CH_STATUS2_MAINCHARGERDETDBNC	0x40
+#define USB_CH_VBUSDROP				0x40
+#define USB_CH_VBUSDETDBNC			0x01
+
 /* UsbLineStatus register bit masks */
 #define AB8500_USB_LINK_STATUS		0x78
 #define AB8500_STD_HOST_SUSP		0x18
@@ -82,6 +88,8 @@
 /* Step up/down delay in us */
 #define STEP_UDELAY			1000
 
+#define CHARGER_STATUS_POLL 10 /* in ms */
+
 /* UsbLineStatus register - usb types */
 enum ab8500_charger_link_status {
 	USB_STAT_NOT_CONFIGURED,
@@ -203,6 +211,10 @@ struct ab8500_charger_usb_state {
  * @check_usbchgnotok_work:	Work for checking USB charger not ok status
  * @kick_wd_work:		Work for kicking the charger watchdog in case
  *				of ABB rev 1.* due to the watchog logic bug
+ * @ac_charger_attached_work:	Work for checking if AC charger is still
+ *				connected
+ * @usb_charger_attached_work:	Work for checking if USB charger is still
+ *				connected
  * @ac_work:			Work for checking AC charger connection
  * @detect_usb_type_work:	Work for detecting the USB type connected
  * @usb_link_status_work:	Work for checking the new USB link status
@@ -211,6 +223,7 @@ struct ab8500_charger_usb_state {
  *				Work for checking Main thermal status
  * @check_usb_thermal_prot_work:
  *				Work for checking USB thermal status
+ * @charger_attached_mutex:	For controlling the wakelock
  */
 struct ab8500_charger {
 	struct device *dev;
@@ -239,6 +252,8 @@ struct ab8500_charger {
 	struct delayed_work check_hw_failure_work;
 	struct delayed_work check_usbchgnotok_work;
 	struct delayed_work kick_wd_work;
+	struct delayed_work ac_charger_attached_work;
+	struct delayed_work usb_charger_attached_work;
 	struct work_struct ac_work;
 	struct work_struct detect_usb_type_work;
 	struct work_struct usb_link_status_work;
@@ -247,6 +262,7 @@ struct ab8500_charger {
 	struct work_struct check_usb_thermal_prot_work;
 	struct usb_phy *usb_phy;
 	struct notifier_block nb;
+	struct mutex charger_attached_mutex;
 };
 
 /* AC properties */
@@ -349,6 +365,19 @@ static void ab8500_charger_set_usb_connected(struct ab8500_charger *di,
 		dev_dbg(di->dev, "USB connected:%i\n", connected);
 		di->usb.charger_connected = connected;
 		sysfs_notify(&di->usb_chg.psy.dev->kobj, NULL, "present");
+
+		if (connected) {
+			mutex_lock(&di->charger_attached_mutex);
+			mutex_unlock(&di->charger_attached_mutex);
+
+			queue_delayed_work(di->charger_wq,
+					   &di->usb_charger_attached_work,
+					   HZ);
+		} else {
+			cancel_delayed_work_sync(&di->usb_charger_attached_work);
+			mutex_lock(&di->charger_attached_mutex);
+			mutex_unlock(&di->charger_attached_mutex);
+		}
 	}
 }
 
@@ -1706,6 +1735,87 @@ static void ab8500_charger_ac_work(struct work_struct *work)
 	sysfs_notify(&di->ac_chg.psy.dev->kobj, NULL, "present");
 }
 
+static void ab8500_charger_usb_attached_work(struct work_struct *work)
+{
+	int i;
+	int ret;
+	u8 statval;
+	struct ab8500_charger *di = container_of(work,
+					 struct ab8500_charger,
+					 usb_charger_attached_work.work);
+
+	for (i = 0 ; i < 10; i++) {
+		ret = abx500_get_register_interruptible(di->dev,
+							AB8500_CHARGER,
+							AB8500_CH_USBCH_STAT1_REG,
+							&statval);
+		if (ret < 0) {
+			dev_err(di->dev, "ab8500 read failed %d\n",
+				__LINE__);
+			goto reschedule;
+		}
+		if ((statval & (USB_CH_VBUSDROP |
+				USB_CH_VBUSDETDBNC)) !=
+		    (USB_CH_VBUSDROP | USB_CH_VBUSDETDBNC))
+			goto reschedule;
+
+		msleep(CHARGER_STATUS_POLL);
+	}
+
+	(void) ab8500_charger_usb_en(&di->usb_chg, 0, 0, 0);
+
+	mutex_lock(&di->charger_attached_mutex);
+	mutex_unlock(&di->charger_attached_mutex);
+
+	return;
+reschedule:
+	queue_delayed_work(di->charger_wq,
+			   &di->usb_charger_attached_work,
+			   HZ);
+}
+
+static void ab8500_charger_ac_attached_work(struct work_struct *work)
+{
+
+	int i;
+	int ret;
+	u8 statval;
+	struct ab8500_charger *di = container_of(work,
+					 struct ab8500_charger,
+					 ac_charger_attached_work.work);
+
+	for (i = 0 ; i < 10; i++) {
+		ret = abx500_get_register_interruptible(di->dev,
+							AB8500_CHARGER,
+							AB8500_CH_STATUS2_REG,
+							&statval);
+		if (ret < 0) {
+			dev_err(di->dev, "ab8500 read failed %d\n",
+				__LINE__);
+			goto reschedule;
+		}
+		if ((statval & (MAIN_CH_STATUS2_MAINCHGDROP |
+				MAIN_CH_STATUS2_MAINCHARGERDETDBNC)) !=
+		     (MAIN_CH_STATUS2_MAINCHGDROP |
+		      MAIN_CH_STATUS2_MAINCHARGERDETDBNC))
+			goto reschedule;
+
+		msleep(CHARGER_STATUS_POLL);
+	}
+
+	(void) ab8500_charger_ac_en(&di->ac_chg, 0, 0, 0);
+	queue_work(di->charger_wq, &di->ac_work);
+
+	mutex_lock(&di->charger_attached_mutex);
+	mutex_unlock(&di->charger_attached_mutex);
+
+	return;
+reschedule:
+	queue_delayed_work(di->charger_wq,
+			   &di->ac_charger_attached_work,
+			   HZ);
+}
+
 /**
  * ab8500_charger_detect_usb_type_work() - work to detect USB type
  * @work:	Pointer to the work_struct structure
@@ -1986,6 +2096,10 @@ static irqreturn_t ab8500_charger_mainchunplugdet_handler(int irq, void *_di)
 	dev_dbg(di->dev, "Main charger unplugged\n");
 	queue_work(di->charger_wq, &di->ac_work);
 
+	cancel_delayed_work_sync(&di->ac_charger_attached_work);
+	mutex_lock(&di->charger_attached_mutex);
+	mutex_unlock(&di->charger_attached_mutex);
+
 	return IRQ_HANDLED;
 }
 
@@ -2003,6 +2117,11 @@ static irqreturn_t ab8500_charger_mainchplugdet_handler(int irq, void *_di)
 	dev_dbg(di->dev, "Main charger plugged\n");
 	queue_work(di->charger_wq, &di->ac_work);
 
+	mutex_lock(&di->charger_attached_mutex);
+	mutex_unlock(&di->charger_attached_mutex);
+	queue_delayed_work(di->charger_wq,
+			   &di->ac_charger_attached_work,
+			   HZ);
 	return IRQ_HANDLED;
 }
 
@@ -2637,7 +2756,7 @@ static int __devinit ab8500_charger_probe(struct platform_device *pdev)
 	struct device_node *np = pdev->dev.of_node;
 	struct abx500_bm_data *plat = pdev->dev.platform_data;
 	struct ab8500_charger *di;
-	int irq, i, charger_status, ret = 0;
+	int irq, i, charger_status, ret = 0, ch_stat;
 
 	di = devm_kzalloc(&pdev->dev, sizeof(*di), GFP_KERNEL);
 	if (!di) {
@@ -2716,12 +2835,19 @@ static int __devinit ab8500_charger_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
+	mutex_init(&di->charger_attached_mutex);
+
 	/* Init work for HW failure check */
 	INIT_DEFERRABLE_WORK(&di->check_hw_failure_work,
 		ab8500_charger_check_hw_failure_work);
 	INIT_DEFERRABLE_WORK(&di->check_usbchgnotok_work,
 		ab8500_charger_check_usbchargernotok_work);
 
+	INIT_DELAYED_WORK(&di->ac_charger_attached_work,
+			  ab8500_charger_ac_attached_work);
+	INIT_DELAYED_WORK(&di->usb_charger_attached_work,
+			  ab8500_charger_usb_attached_work);
+
 	/*
 	 * For ABB revision 1.0 and 1.1 there is a bug in the watchdog
 	 * logic. That means we have to continously kick the charger
@@ -2835,6 +2961,23 @@ static int __devinit ab8500_charger_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, di);
 
+	mutex_lock(&di->charger_attached_mutex);
+
+	ch_stat = ab8500_charger_detect_chargers(di);
+
+	if ((ch_stat & AC_PW_CONN) == AC_PW_CONN) {
+		queue_delayed_work(di->charger_wq,
+				   &di->ac_charger_attached_work,
+				   HZ);
+	}
+	if ((ch_stat & USB_PW_CONN) == USB_PW_CONN) {
+		queue_delayed_work(di->charger_wq,
+				   &di->usb_charger_attached_work,
+				   HZ);
+	}
+
+	mutex_unlock(&di->charger_attached_mutex);
+
 	return ret;
 
 free_irq:
-- 
1.7.9.5

