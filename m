Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758103Ab2IYQRT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 12:17:19 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41451 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758050Ab2IYQOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 12:14:12 -0400
From: mathieu.poirier@linaro.org
To: linux-kernel@vger.kernel.org, cbou@mail.ru, dwmw2@infradead.org
Cc: mathieu.poirier@linaro.org
Subject: [PATCH 47/57] power: Harmonising platform data declaration/handling
Date: Tue, 25 Sep 2012 10:12:44 -0600
Message-Id: <1348589574-25655-48-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Mathieu J. Poirier" <mathieu.poirier@linaro.org>

Making platform data declaration and handling similar accross all
ab8500_xyc.c battery management files.  Also adding gards against
NULL platform data.

Signed-off-by: Philippe Langlais <philippe.langlais@stericsson.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 drivers/power/ab8500_btemp.c    |   17 +++++++++--------
 drivers/power/ab8500_charger.c  |   18 +++++++++---------
 drivers/power/ab8500_fg.c       |   17 +++++++++--------
 drivers/power/abx500_chargalg.c |   25 ++++++++++++++++++++-----
 4 files changed, 47 insertions(+), 30 deletions(-)

diff --git a/drivers/power/ab8500_btemp.c b/drivers/power/ab8500_btemp.c
index 1f33122..cf4b653 100644
--- a/drivers/power/ab8500_btemp.c
+++ b/drivers/power/ab8500_btemp.c
@@ -1028,10 +1028,10 @@ static int __devinit ab8500_btemp_probe(struct platform_device *pdev)
 {
 	int irq, i, ret = 0;
 	u8 val;
-	struct ab8500_platform_data *plat_data;
-	struct ab8500_btemp *di;
+	struct ab8500_platform_data *plat;
 
-	di = kzalloc(sizeof(*di), GFP_KERNEL);
+	struct ab8500_btemp *di =
+		kzalloc(sizeof(struct ab8500_btemp), GFP_KERNEL);
 	if (!di)
 		return -ENOMEM;
 
@@ -1042,22 +1042,23 @@ static int __devinit ab8500_btemp_probe(struct platform_device *pdev)
 
 	di->initialized = false;
 
+	plat = dev_get_platdata(di->parent->dev);
+
 	/* get btemp specific platform data */
-	plat_data = dev_get_platdata(di->parent->dev);
-	di->pdata = plat_data->btemp;
-	if (!di->pdata) {
+	if (!plat || !plat->btemp) {
 		dev_err(di->dev, "no btemp platform data supplied\n");
 		ret = -EINVAL;
 		goto free_device_info;
 	}
+	di->pdata = plat->btemp;
 
 	/* get battery specific platform data */
-	di->bat = plat_data->battery;
-	if (!di->bat) {
+	if (!plat->battery) {
 		dev_err(di->dev, "no battery platform data supplied\n");
 		ret = -EINVAL;
 		goto free_device_info;
 	}
+	di->bat = plat->battery;
 
 	/* BTEMP supply */
 	di->btemp_psy.name = "ab8500_btemp";
diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
index 68a4128..1290470 100644
--- a/drivers/power/ab8500_charger.c
+++ b/drivers/power/ab8500_charger.c
@@ -3319,10 +3319,10 @@ static int __devexit ab8500_charger_remove(struct platform_device *pdev)
 static int __devinit ab8500_charger_probe(struct platform_device *pdev)
 {
 	int irq, i, charger_status, ret = 0, ch_stat;
-	struct ab8500_platform_data *plat_data;
-	struct ab8500_charger *di;
+	struct ab8500_platform_data *plat;
 
-	di = kzalloc(sizeof(*di), GFP_KERNEL);
+	struct ab8500_charger *di =
+		kzalloc(sizeof(struct ab8500_charger), GFP_KERNEL);
 	if (!di)
 		return -ENOMEM;
 
@@ -3335,24 +3335,24 @@ static int __devinit ab8500_charger_probe(struct platform_device *pdev)
 	spin_lock_init(&di->usb_state.usb_lock);
 	mutex_init(&di->usb_ipt_crnt_lock);
 
-	/* get charger specific platform data */
-	plat_data = dev_get_platdata(di->parent->dev);
+	plat = dev_get_platdata(di->parent->dev);
 
-	di->pdata = plat_data->charger;
-	if (!di->pdata) {
+	/* get charger specific platform data */
+	if (!plat || !plat->charger) {
 		dev_err(di->dev, "no charger platform data supplied\n");
 		ret = -EINVAL;
 		goto free_device_info;
 	}
+	di->pdata = plat->charger;
 
 	/* get battery specific platform data */
-	di->bat = plat_data->battery;
-	if (!di->bat) {
+	if (!plat->battery) {
 		dev_err(di->dev, "no battery platform data supplied\n");
 		ret = -EINVAL;
 		goto free_device_info;
 	}
 
+	di->bat = plat->battery;
 	di->autopower = false;
 	di->invalid_charger_detect_state = 0;
 
diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
index cf6d2b5..5b5c7ea 100644
--- a/drivers/power/ab8500_fg.c
+++ b/drivers/power/ab8500_fg.c
@@ -3158,10 +3158,10 @@ static int __devinit ab8500_fg_probe(struct platform_device *pdev)
 {
 	int i, irq;
 	int ret = 0;
-	struct ab8500_platform_data *plat_data;
-	struct ab8500_fg *di;
+	struct ab8500_platform_data *plat;
 
-	di = kzalloc(sizeof(*di), GFP_KERNEL);
+	struct ab8500_fg *di =
+		kzalloc(sizeof(struct ab8500_fg), GFP_KERNEL);
 	if (!di)
 		return -ENOMEM;
 
@@ -3172,22 +3172,23 @@ static int __devinit ab8500_fg_probe(struct platform_device *pdev)
 	di->parent = dev_get_drvdata(pdev->dev.parent);
 	di->gpadc = ab8500_gpadc_get("ab8500-gpadc.0");
 
+	plat = dev_get_platdata(di->parent->dev);
+
 	/* get fg specific platform data */
-	plat_data = dev_get_platdata(di->parent->dev);
-	di->pdata = plat_data->fg;
-	if (!di->pdata) {
+	if (!plat || !plat->fg) {
 		dev_err(di->dev, "no fg platform data supplied\n");
 		ret = -EINVAL;
 		goto free_device_info;
 	}
+	di->pdata = plat->fg;
 
 	/* get battery specific platform data */
-	di->bat = plat_data->battery;
-	if (!di->bat) {
+	if (!plat->battery) {
 		dev_err(di->dev, "no battery platform data supplied\n");
 		ret = -EINVAL;
 		goto free_device_info;
 	}
+	di->bat = plat->battery;
 
 	di->fg_psy.name = "ab8500_fg";
 	di->fg_psy.type = POWER_SUPPLY_TYPE_BATTERY;
diff --git a/drivers/power/abx500_chargalg.c b/drivers/power/abx500_chargalg.c
index 3ca00dd..180deab 100644
--- a/drivers/power/abx500_chargalg.c
+++ b/drivers/power/abx500_chargalg.c
@@ -1918,7 +1918,7 @@ static int __devexit abx500_chargalg_remove(struct platform_device *pdev)
 
 static int __devinit abx500_chargalg_probe(struct platform_device *pdev)
 {
-	struct ab8500_platform_data *plat_data;
+	struct ab8500_platform_data *plat;
 	int ret = 0;
 
 	struct abx500_chargalg *di =
@@ -1926,12 +1926,27 @@ static int __devinit abx500_chargalg_probe(struct platform_device *pdev)
 	if (!di)
 		return -ENOMEM;
 
-	/* get device struct */
+	/* get parent data */
 	di->dev = &pdev->dev;
 	di->parent = dev_get_drvdata(pdev->dev.parent);
-	plat_data = dev_get_platdata(di->parent->dev);
-	di->pdata = plat_data->chargalg;
-	di->bat = plat_data->battery;
+
+	plat = dev_get_platdata(di->parent->dev);
+
+	/* get chargalg specific platform data */
+	if (!plat || !plat->chargalg) {
+		dev_err(di->dev, "no chargalg platform data supplied\n");
+		ret = -EINVAL;
+		goto free_device_info;
+	}
+	di->pdata = plat->chargalg;
+
+	/* get battery specific platform data */
+	if (!plat->battery) {
+		dev_err(di->dev, "no battery platform data supplied\n");
+		ret = -EINVAL;
+		goto free_device_info;
+	}
+	di->bat = plat->battery;
 
 	/* chargalg supply */
 	di->chargalg_psy.name = "abx500_chargalg";
-- 
1.7.5.4

