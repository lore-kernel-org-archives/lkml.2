Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821Ab0DWBKb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 21:10:31 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:48107 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754796Ab0DWBKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 21:10:23 -0400
From: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
To: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
       Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
       Daniel Mack <daniel@caiaq.de>,
       Andres Salomon <dilinger@collabora.co.uk>,
       Len Brown <len.brown@intel.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 9/9] power_supply: Block suspend while power supply change notifications are pending
Date: Thu, 22 Apr 2010 18:08:58 -0700
Message-Id: <1271984938-13920-10-git-send-email-arve@android.com>
X-Mailer: git-send-email 1.6.5.1
In-Reply-To: <1271984938-13920-9-git-send-email-arve@android.com>
References: <1271984938-13920-1-git-send-email-arve@android.com>
 <1271984938-13920-2-git-send-email-arve@android.com>
 <1271984938-13920-3-git-send-email-arve@android.com>
 <1271984938-13920-4-git-send-email-arve@android.com>
 <1271984938-13920-5-git-send-email-arve@android.com>
 <1271984938-13920-6-git-send-email-arve@android.com>
 <1271984938-13920-7-git-send-email-arve@android.com>
 <1271984938-13920-8-git-send-email-arve@android.com>
 <1271984938-13920-9-git-send-email-arve@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When connecting usb or the charger the device would often go back to sleep
before the charge led and screen turned on.

Signed-off-by: Arve Hjønnevåg <arve@android.com>
---
 drivers/power/power_supply_core.c |    9 ++++++---
 include/linux/power_supply.h      |    2 +-
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/power/power_supply_core.c b/drivers/power/power_supply_core.c
index cce75b4..fdf30ba 100644
--- a/drivers/power/power_supply_core.c
+++ b/drivers/power/power_supply_core.c
@@ -39,7 +39,7 @@ static int __power_supply_changed_work(struct device *dev, void *data)
 static void power_supply_changed_work(struct work_struct *work)
 {
 	struct power_supply *psy = container_of(work, struct power_supply,
-						changed_work);
+						changed_work.work);
 
 	dev_dbg(psy->dev, "%s\n", __func__);
 
@@ -55,7 +55,7 @@ void power_supply_changed(struct power_supply *psy)
 {
 	dev_dbg(psy->dev, "%s\n", __func__);
 
-	schedule_work(&psy->changed_work);
+	schedule_work(&psy->changed_work.work);
 }
 EXPORT_SYMBOL_GPL(power_supply_changed);
 
@@ -155,7 +155,8 @@ int power_supply_register(struct device *parent, struct power_supply *psy)
 		goto dev_create_failed;
 	}
 
-	INIT_WORK(&psy->changed_work, power_supply_changed_work);
+	suspend_blocking_work_init(&psy->changed_work,
+				power_supply_changed_work, "power-supply");
 
 	rc = power_supply_create_attrs(psy);
 	if (rc)
@@ -172,6 +173,7 @@ int power_supply_register(struct device *parent, struct power_supply *psy)
 create_triggers_failed:
 	power_supply_remove_attrs(psy);
 create_attrs_failed:
+	suspend_blocking_work_destroy(&psy->changed_work);
 	device_unregister(psy->dev);
 dev_create_failed:
 success:
@@ -184,6 +186,7 @@ void power_supply_unregister(struct power_supply *psy)
 	flush_scheduled_work();
 	power_supply_remove_triggers(psy);
 	power_supply_remove_attrs(psy);
+	suspend_blocking_work_destroy(&psy->changed_work);
 	device_unregister(psy->dev);
 }
 EXPORT_SYMBOL_GPL(power_supply_unregister);
diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index ebd2b8f..2232a9d 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -152,7 +152,7 @@ struct power_supply {
 
 	/* private */
 	struct device *dev;
-	struct work_struct changed_work;
+	struct suspend_blocking_work changed_work;
 
 #ifdef CONFIG_LEDS_TRIGGERS
 	struct led_trigger *charging_full_trig;
-- 
1.6.5.1

