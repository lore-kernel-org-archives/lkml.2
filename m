Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757524Ab2IYQNZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 12:13:25 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:48198 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756968Ab2IYQNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 12:13:17 -0400
From: mathieu.poirier@linaro.org
To: linux-kernel@vger.kernel.org, cbou@mail.ru, dwmw2@infradead.org
Cc: mathieu.poirier@linaro.org
Subject: [PATCH 07/57] power: ab8500_bm: Detect removed charger
Date: Tue, 25 Sep 2012 10:12:04 -0600
Message-Id: <1348589574-25655-8-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonas Aaberg <jonas.aberg@stericsson.com>

Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 drivers/power/ab8500_charger.c |  122 +++++++++++++++++++++++++++++++++++++++-
 1 files changed, 121 insertions(+), 1 deletions(-)

diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
index a7d0c3a..f7bba07 100644
--- a/drivers/power/ab8500_charger.c
+++ b/drivers/power/ab8500_charger.c
@@ -66,6 +66,11 @@
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
@@ -80,6 +85,8 @@
 /* Step up/down delay in us */
 #define STEP_UDELAY			1000
 
+#define CHARGER_STATUS_POLL 10 /* in ms */
+
 /* UsbLineStatus register - usb types */
 enum ab8500_charger_link_status {
 	USB_STAT_NOT_CONFIGURED,
@@ -201,6 +208,10 @@ struct ab8500_charger_usb_state {
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
@@ -237,6 +248,8 @@ struct ab8500_charger {
 	struct delayed_work check_hw_failure_work;
 	struct delayed_work check_usbchgnotok_work;
 	struct delayed_work kick_wd_work;
+	struct delayed_work ac_charger_attached_work;
+	struct delayed_work usb_charger_attached_work;
 	struct work_struct ac_work;
 	struct work_struct detect_usb_type_work;
 	struct work_struct usb_link_status_work;
@@ -347,6 +360,15 @@ static void ab8500_charger_set_usb_connected(struct ab8500_charger *di,
 		dev_dbg(di->dev, "USB connected:%i\n", connected);
 		di->usb.charger_connected = connected;
 		sysfs_notify(&di->usb_chg.psy.dev->kobj, NULL, "present");
+
+		if (connected) {
+			queue_delayed_work(di->charger_wq,
+					   &di->usb_charger_attached_work,
+					   HZ);
+		} else {
+			cancel_delayed_work_sync
+					(&di->usb_charger_attached_work);
+		}
 	}
 }
 
@@ -1703,6 +1725,81 @@ static void ab8500_charger_ac_work(struct work_struct *work)
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
+						AB8500_CHARGER,
+						AB8500_CH_USBCH_STAT1_REG,
+						&statval);
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
@@ -1983,6 +2080,8 @@ static irqreturn_t ab8500_charger_mainchunplugdet_handler(int irq, void *_di)
 	dev_dbg(di->dev, "Main charger unplugged\n");
 	queue_work(di->charger_wq, &di->ac_work);
 
+	cancel_delayed_work_sync(&di->ac_charger_attached_work);
+
 	return IRQ_HANDLED;
 }
 
@@ -2000,6 +2099,9 @@ static irqreturn_t ab8500_charger_mainchplugdet_handler(int irq, void *_di)
 	dev_dbg(di->dev, "Main charger plugged\n");
 	queue_work(di->charger_wq, &di->ac_work);
 
+	queue_delayed_work(di->charger_wq,
+			   &di->ac_charger_attached_work,
+			   HZ);
 	return IRQ_HANDLED;
 }
 
@@ -2626,7 +2728,7 @@ static int __devexit ab8500_charger_remove(struct platform_device *pdev)
 
 static int __devinit ab8500_charger_probe(struct platform_device *pdev)
 {
-	int irq, i, charger_status, ret = 0;
+	int irq, i, charger_status, ret = 0, ch_stat;
 	struct ab8500_platform_data *plat_data;
 	struct ab8500_charger *di;
 
@@ -2713,6 +2815,11 @@ static int __devinit ab8500_charger_probe(struct platform_device *pdev)
 	INIT_DELAYED_WORK_DEFERRABLE(&di->check_usbchgnotok_work,
 		ab8500_charger_check_usbchargernotok_work);
 
+	INIT_DELAYED_WORK(&di->ac_charger_attached_work,
+			  ab8500_charger_ac_attached_work);
+	INIT_DELAYED_WORK(&di->usb_charger_attached_work,
+			  ab8500_charger_usb_attached_work);
+
 	/*
 	 * For ABB revision 1.0 and 1.1 there is a bug in the watchdog
 	 * logic. That means we have to continously kick the charger
@@ -2826,6 +2933,19 @@ static int __devinit ab8500_charger_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, di);
 
+	ch_stat = ab8500_charger_detect_chargers(di);
+
+	if ((ch_stat & AC_PW_CONN) == AC_PW_CONN) {
+		queue_delayed_work(di->charger_wq,
+					   &di->ac_charger_attached_work,
+					   HZ);
+	}
+	if ((ch_stat & USB_PW_CONN) == USB_PW_CONN) {
+		queue_delayed_work(di->charger_wq,
+					   &di->usb_charger_attached_work,
+					   HZ);
+	}
+
 	return ret;
 
 free_irq:
-- 
1.7.5.4

