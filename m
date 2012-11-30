Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932921Ab2K3MAd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 07:00:33 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:33263 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755399Ab2K3L5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 06:57:55 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linus.walleij@stericsson.com, arnd@arndb.de, cbou@mail.ru,
        dwmw2@infradead.org, rajanikanth.hv@linaro.org,
        Jonas Aaberg <jonas.aberg@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 03/12] ab8500_btemp: Detect battery type in workqueue
Date: Fri, 30 Nov 2012 11:57:25 +0000
Message-Id: <1354276654-590-4-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1354276654-590-1-git-send-email-lee.jones@linaro.org>
References: <1354276654-590-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonas Aaberg <jonas.aberg@stericsson.com>

Detect battery type in work queue instead of probe.

This reduces the system boot time with 1.5s.

Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Karl KOMIEROWSKI <karl.komierowski@stericsson.com>
---
 drivers/power/ab8500_btemp.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/power/ab8500_btemp.c b/drivers/power/ab8500_btemp.c
index 8135542..5d1bf0b 100644
--- a/drivers/power/ab8500_btemp.c
+++ b/drivers/power/ab8500_btemp.c
@@ -84,6 +84,7 @@ struct ab8500_btemp_ranges {
  * @btemp_ranges:	Battery temperature range structure
  * @btemp_wq:		Work queue for measuring the temperature periodically
  * @btemp_periodic_work:	Work for measuring the temperature periodically
+ * @initialized:	True if battery id read.
  */
 struct ab8500_btemp {
 	struct device *dev;
@@ -100,6 +101,7 @@ struct ab8500_btemp {
 	struct ab8500_btemp_ranges btemp_ranges;
 	struct workqueue_struct *btemp_wq;
 	struct delayed_work btemp_periodic_work;
+	bool initialized;
 };
 
 /* BTEMP power supply properties */
@@ -569,6 +571,13 @@ static void ab8500_btemp_periodic_work(struct work_struct *work)
 	struct ab8500_btemp *di = container_of(work,
 		struct ab8500_btemp, btemp_periodic_work.work);
 
+	if (!di->initialized) {
+		di->initialized = true;
+		/* Identify the battery */
+		if (ab8500_btemp_id(di) < 0)
+			dev_warn(di->dev, "failed to identify the battery\n");
+	}
+
 	di->bat_temp = ab8500_btemp_measure_temp(di);
 
 	if (di->bat_temp != di->prev_bat_temp) {
@@ -998,6 +1007,8 @@ static int __devinit ab8500_btemp_probe(struct platform_device *pdev)
 	di->parent = dev_get_drvdata(pdev->dev.parent);
 	di->gpadc = ab8500_gpadc_get("ab8500-gpadc.0");
 
+	di->initialized = false;
+
 	/* BTEMP supply */
 	di->btemp_psy.name = "ab8500_btemp";
 	di->btemp_psy.type = POWER_SUPPLY_TYPE_BATTERY;
@@ -1022,10 +1033,6 @@ static int __devinit ab8500_btemp_probe(struct platform_device *pdev)
 	INIT_DEFERRABLE_WORK(&di->btemp_periodic_work,
 		ab8500_btemp_periodic_work);
 
-	/* Identify the battery */
-	if (ab8500_btemp_id(di) < 0)
-		dev_warn(di->dev, "failed to identify the battery\n");
-
 	/* Set BTEMP thermal limits. Low and Med are fixed */
 	di->btemp_ranges.btemp_low_limit = BTEMP_THERMAL_LOW_LIMIT;
 	di->btemp_ranges.btemp_med_limit = BTEMP_THERMAL_MED_LIMIT;
-- 
1.7.9.5

