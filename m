Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239Ab1FUMIx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 08:08:53 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37766 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752187Ab1FUMIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 08:08:51 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/3] power_supply: Support multiple wm831x_backup instances
Date: Tue, 21 Jun 2011 13:08:44 +0100
Message-Id: <1308658125-25013-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1308658125-25013-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1308658125-25013-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If there are multiple wm831x devices in the system we need to assign
different names to the power supply devices in order to ensure we can
create the sysfs entries for them.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/power/wm831x_backup.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/power/wm831x_backup.c b/drivers/power/wm831x_backup.c
index 0fd130d..e648cbe 100644
--- a/drivers/power/wm831x_backup.c
+++ b/drivers/power/wm831x_backup.c
@@ -22,6 +22,7 @@
 struct wm831x_backup {
 	struct wm831x *wm831x;
 	struct power_supply backup;
+	char name[20];
 };
 
 static int wm831x_backup_read_voltage(struct wm831x *wm831x,
@@ -163,6 +164,7 @@ static enum power_supply_property wm831x_backup_props[] = {
 static __devinit int wm831x_backup_probe(struct platform_device *pdev)
 {
 	struct wm831x *wm831x = dev_get_drvdata(pdev->dev.parent);
+	struct wm831x_pdata *wm831x_pdata = wm831x->dev->platform_data;
 	struct wm831x_backup *devdata;
 	struct power_supply *backup;
 	int ret;
@@ -182,7 +184,14 @@ static __devinit int wm831x_backup_probe(struct platform_device *pdev)
 	 */
 	wm831x_config_backup(wm831x);
 
-	backup->name = "wm831x-backup";
+	if (wm831x_pdata && wm831x_pdata->wm831x_num)
+		snprintf(devdata->name, sizeof(devdata->name),
+			 "wm831x-backup.%d", wm831x_pdata->wm831x_num);
+	else
+		snprintf(devdata->name, sizeof(devdata->name),
+			 "wm831x-backup");
+
+	backup->name = devdata->name;
 	backup->type = POWER_SUPPLY_TYPE_BATTERY;
 	backup->properties = wm831x_backup_props;
 	backup->num_properties = ARRAY_SIZE(wm831x_backup_props);
@@ -203,6 +212,7 @@ static __devexit int wm831x_backup_remove(struct platform_device *pdev)
 	struct wm831x_backup *devdata = platform_get_drvdata(pdev);
 
 	power_supply_unregister(&devdata->backup);
+	kfree(devdata->backup.name);
 	kfree(devdata);
 
 	return 0;
-- 
1.7.5.4

