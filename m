Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085Ab1HWMeq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 08:34:46 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:39984 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752636Ab1HWMel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 08:34:41 -0400
Subject: [PATCH] pda_power: fix build error if !CONFIG_USB_OTG_UTILS
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Anton Vorontsov <cbouatmailru@gmail.com>, Dima Zavin <dima@android.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Aug 2011 20:34:33 +0800
Message-ID: <1314102873.16518.2.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 9ad63986c606c60e2e916b1b96f22991f966d9cc
"pda_power: Add support for using otg transceiver events"
introduces below build error if !CONFIG_USB_OTG_UTILS.

  CC      drivers/power/pda_power.o
drivers/power/pda_power.c: In function 'pda_power_probe':
drivers/power/pda_power.c:322: error: 'otg_is_usb_online' undeclared (first use in this function)
drivers/power/pda_power.c:322: error: (Each undeclared identifier is reported only once
drivers/power/pda_power.c:322: error: for each function it appears in.)
drivers/power/pda_power.c:325: error: 'otg_is_ac_online' undeclared (first use in this function)
drivers/power/pda_power.c:371: error: 'otg_handle_notification' undeclared (first use in this function)
make[2]: *** [drivers/power/pda_power.o] Error 1
make[1]: *** [drivers/power] Error 2
make: *** [drivers] Error 2

This patch adds #ifdef CONFIG_USB_OTG_UTILS guards at necessary places to fix
build errors.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/power/pda_power.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/power/pda_power.c b/drivers/power/pda_power.c
index 81b7201..87be679 100644
--- a/drivers/power/pda_power.c
+++ b/drivers/power/pda_power.c
@@ -39,8 +39,11 @@ static struct timer_list supply_timer;
 static struct timer_list polling_timer;
 static int polling;
 
+#ifdef CONFIG_USB_OTG_UTILS
 static struct otg_transceiver *transceiver;
 static struct notifier_block otg_nb;
+#endif
+
 static struct regulator *ac_draw;
 
 enum {
@@ -317,6 +320,7 @@ static int pda_power_probe(struct platform_device *pdev)
 		ret = PTR_ERR(ac_draw);
 	}
 
+#ifdef CONFIG_USB_OTG_UTILS
 	transceiver = otg_get_transceiver();
 	if (transceiver && !pdata->is_usb_online) {
 		pdata->is_usb_online = otg_is_usb_online;
@@ -324,6 +328,7 @@ static int pda_power_probe(struct platform_device *pdev)
 	if (transceiver && !pdata->is_ac_online) {
 		pdata->is_ac_online = otg_is_ac_online;
 	}
+#endif
 
 	if (pdata->is_ac_online) {
 		ret = power_supply_register(&pdev->dev, &pda_psy_ac);
@@ -367,6 +372,7 @@ static int pda_power_probe(struct platform_device *pdev)
 		}
 	}
 
+#ifdef CONFIG_USB_OTG_UTILS
 	if (transceiver && pdata->use_otg_notifier) {
 		otg_nb.notifier_call = otg_handle_notification;
 		ret = otg_register_notifier(transceiver, &otg_nb);
@@ -376,6 +382,7 @@ static int pda_power_probe(struct platform_device *pdev)
 		}
 		polling = 0;
 	}
+#endif
 
 	if (polling) {
 		dev_dbg(dev, "will poll for status\n");
@@ -389,17 +396,21 @@ static int pda_power_probe(struct platform_device *pdev)
 
 	return 0;
 
+#ifdef CONFIG_USB_OTG_UTILS
 otg_reg_notifier_failed:
 	if (pdata->is_usb_online && usb_irq)
 		free_irq(usb_irq->start, &pda_psy_usb);
+#endif
 usb_irq_failed:
 	if (pdata->is_usb_online)
 		power_supply_unregister(&pda_psy_usb);
 usb_supply_failed:
 	if (pdata->is_ac_online && ac_irq)
 		free_irq(ac_irq->start, &pda_psy_ac);
+#ifdef CONFIG_USB_OTG_UTILS
 	if (transceiver)
 		otg_put_transceiver(transceiver);
+#endif
 ac_irq_failed:
 	if (pdata->is_ac_online)
 		power_supply_unregister(&pda_psy_ac);
-- 
1.7.4.1



