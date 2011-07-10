Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794Ab1GJXB1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 19:01:27 -0400
Received: from smtp-out.google.com ([216.239.44.51]:56838 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756756Ab1GJXB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 19:01:26 -0400
From: Dima Zavin <dima@android.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Daniel Mack <daniel@caiaq.de>, linux-kernel@vger.kernel.org,
        Dima Zavin <dima@android.com>
Subject: [PATCH] pda_power: add support for using otg transceiver events
Date: Sun, 10 Jul 2011 16:01:15 -0700
Message-Id: <1310338875-24686-1-git-send-email-dima@android.com>
X-Mailer: git-send-email 1.7.3.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the platform data sets the use_otg_notifier flag,
the driver will now register an otg notifier callback and listen
to transceiver events for AC/USB plug-in events instead. This would
normally be used by not specifying is_xx_online callbacks and
not specifying any irqs so the state machine is completely driven
from OTG xceiver events.

Signed-off-by: Dima Zavin <dima@android.com>
---
 drivers/power/pda_power.c |   71 +++++++++++++++++++++++++++++++++++++-------
 include/linux/pda_power.h |    2 +
 2 files changed, 61 insertions(+), 12 deletions(-)

diff --git a/drivers/power/pda_power.c b/drivers/power/pda_power.c
index 69f8aa3..81b7201 100644
--- a/drivers/power/pda_power.c
+++ b/drivers/power/pda_power.c
@@ -14,6 +14,7 @@
 #include <linux/platform_device.h>
 #include <linux/err.h>
 #include <linux/interrupt.h>
+#include <linux/notifier.h>
 #include <linux/power_supply.h>
 #include <linux/pda_power.h>
 #include <linux/regulator/consumer.h>
@@ -38,9 +39,8 @@ static struct timer_list supply_timer;
 static struct timer_list polling_timer;
 static int polling;
 
-#ifdef CONFIG_USB_OTG_UTILS
 static struct otg_transceiver *transceiver;
-#endif
+static struct notifier_block otg_nb;
 static struct regulator *ac_draw;
 
 enum {
@@ -222,7 +222,42 @@ static void polling_timer_func(unsigned long unused)
 #ifdef CONFIG_USB_OTG_UTILS
 static int otg_is_usb_online(void)
 {
-	return (transceiver->state == OTG_STATE_B_PERIPHERAL);
+	return (transceiver->last_event == USB_EVENT_VBUS ||
+		transceiver->last_event == USB_EVENT_ENUMERATED);
+}
+
+static int otg_is_ac_online(void)
+{
+	return (transceiver->last_event == USB_EVENT_CHARGER);
+}
+
+static int otg_handle_notification(struct notifier_block *nb,
+		unsigned long event, void *unused)
+{
+	switch (event) {
+	case USB_EVENT_CHARGER:
+		ac_status = PDA_PSY_TO_CHANGE;
+		break;
+	case USB_EVENT_VBUS:
+	case USB_EVENT_ENUMERATED:
+		usb_status = PDA_PSY_TO_CHANGE;
+		break;
+	case USB_EVENT_NONE:
+		ac_status = PDA_PSY_TO_CHANGE;
+		usb_status = PDA_PSY_TO_CHANGE;
+		break;
+	default:
+		return NOTIFY_OK;
+	}
+
+	/*
+	 * Wait a bit before reading ac/usb line status and setting charger,
+	 * because ac/usb status readings may lag from irq.
+	 */
+	mod_timer(&charger_timer,
+		  jiffies + msecs_to_jiffies(pdata->wait_for_status));
+
+	return NOTIFY_OK;
 }
 #endif
 
@@ -282,6 +317,14 @@ static int pda_power_probe(struct platform_device *pdev)
 		ret = PTR_ERR(ac_draw);
 	}
 
+	transceiver = otg_get_transceiver();
+	if (transceiver && !pdata->is_usb_online) {
+		pdata->is_usb_online = otg_is_usb_online;
+	}
+	if (transceiver && !pdata->is_ac_online) {
+		pdata->is_ac_online = otg_is_ac_online;
+	}
+
 	if (pdata->is_ac_online) {
 		ret = power_supply_register(&pdev->dev, &pda_psy_ac);
 		if (ret) {
@@ -303,13 +346,6 @@ static int pda_power_probe(struct platform_device *pdev)
 		}
 	}
 
-#ifdef CONFIG_USB_OTG_UTILS
-	transceiver = otg_get_transceiver();
-	if (transceiver && !pdata->is_usb_online) {
-		pdata->is_usb_online = otg_is_usb_online;
-	}
-#endif
-
 	if (pdata->is_usb_online) {
 		ret = power_supply_register(&pdev->dev, &pda_psy_usb);
 		if (ret) {
@@ -331,6 +367,16 @@ static int pda_power_probe(struct platform_device *pdev)
 		}
 	}
 
+	if (transceiver && pdata->use_otg_notifier) {
+		otg_nb.notifier_call = otg_handle_notification;
+		ret = otg_register_notifier(transceiver, &otg_nb);
+		if (ret) {
+			dev_err(dev, "failure to register otg notifier\n");
+			goto otg_reg_notifier_failed;
+		}
+		polling = 0;
+	}
+
 	if (polling) {
 		dev_dbg(dev, "will poll for status\n");
 		setup_timer(&polling_timer, polling_timer_func, 0);
@@ -343,16 +389,17 @@ static int pda_power_probe(struct platform_device *pdev)
 
 	return 0;
 
+otg_reg_notifier_failed:
+	if (pdata->is_usb_online && usb_irq)
+		free_irq(usb_irq->start, &pda_psy_usb);
 usb_irq_failed:
 	if (pdata->is_usb_online)
 		power_supply_unregister(&pda_psy_usb);
 usb_supply_failed:
 	if (pdata->is_ac_online && ac_irq)
 		free_irq(ac_irq->start, &pda_psy_ac);
-#ifdef CONFIG_USB_OTG_UTILS
 	if (transceiver)
 		otg_put_transceiver(transceiver);
-#endif
 ac_irq_failed:
 	if (pdata->is_ac_online)
 		power_supply_unregister(&pda_psy_ac);
diff --git a/include/linux/pda_power.h b/include/linux/pda_power.h
index c9e4d81..2bb62bf 100644
--- a/include/linux/pda_power.h
+++ b/include/linux/pda_power.h
@@ -35,6 +35,8 @@ struct pda_power_pdata {
 	unsigned int polling_interval; /* msecs, default is 2000 */
 
 	unsigned long ac_max_uA; /* current to draw when on AC */
+
+	bool use_otg_notifier;
 };
 
 #endif /* __PDA_POWER_H__ */
-- 
1.7.3.1

