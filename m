Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865Ab0D1Edg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 00:33:36 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:37211 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab0D1Ecj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 00:32:39 -0400
From: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
To: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
       Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
       Daniel Mack <daniel@caiaq.de>,
       Andres Salomon <dilinger@collabora.co.uk>,
       Len Brown <len.brown@intel.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 8/8] power_supply: Block suspend while power supply change notifications are pending
Date: Tue, 27 Apr 2010 21:31:59 -0700
Message-Id: <1272429119-12103-9-git-send-email-arve@android.com>
X-Mailer: git-send-email 1.6.5.1
In-Reply-To: <1272429119-12103-8-git-send-email-arve@android.com>
References: <1272429119-12103-1-git-send-email-arve@android.com>
 <1272429119-12103-2-git-send-email-arve@android.com>
 <1272429119-12103-3-git-send-email-arve@android.com>
 <1272429119-12103-4-git-send-email-arve@android.com>
 <1272429119-12103-5-git-send-email-arve@android.com>
 <1272429119-12103-6-git-send-email-arve@android.com>
 <1272429119-12103-7-git-send-email-arve@android.com>
 <1272429119-12103-8-git-send-email-arve@android.com>
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
 include/linux/power_supply.h      |    3 ++-
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/power/power_supply_core.c b/drivers/power/power_supply_core.c
index cce75b4..577a131 100644
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
+	schedule_suspend_blocking_work(&psy->changed_work);
 }
 EXPORT_SYMBOL_GPL(power_supply_changed);
 
@@ -155,7 +155,8 @@ int power_supply_register(struct device *parent, struct power_supply *psy)
 		goto dev_create_failed;
 	}
 
-	INIT_WORK(&psy->changed_work, power_supply_changed_work);
+	suspend_blocking_work_init(&psy->changed_work,
+				   power_supply_changed_work, "power-supply");
 
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
index ebd2b8f..8a12d50 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -14,6 +14,7 @@
 #define __LINUX_POWER_SUPPLY_H__
 
 #include <linux/device.h>
+#include <linux/suspend_blocker.h>
 #include <linux/workqueue.h>
 #include <linux/leds.h>
 
@@ -152,7 +153,7 @@ struct power_supply {
 
 	/* private */
 	struct device *dev;
-	struct work_struct changed_work;
+	struct suspend_blocking_work changed_work;
 
 #ifdef CONFIG_LEDS_TRIGGERS
 	struct led_trigger *charging_full_trig;
-- 
1.6.5.1

