Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932896Ab2GCSvw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 14:51:52 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:51407 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932269Ab2GCSvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 14:51:50 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH] mg_disk: Use struct dev_pm_ops for power management
Date: Tue, 3 Jul 2012 20:57:22 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201207032057.22943.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Make the mg_disk driver define its PM callbacks through
a struct dev_pm_ops object rather than by using legacy PM hooks
in struct platform_driver.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/block/mg_disk.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

Index: linux/drivers/block/mg_disk.c
===================================================================
--- linux.orig/drivers/block/mg_disk.c
+++ linux/drivers/block/mg_disk.c
@@ -780,9 +780,9 @@ static const struct block_device_operati
 	.getgeo = mg_getgeo
 };
 
-static int mg_suspend(struct platform_device *plat_dev, pm_message_t state)
+static int mg_suspend(struct device *dev)
 {
-	struct mg_drv_data *prv_data = plat_dev->dev.platform_data;
+	struct mg_drv_data *prv_data = dev->platform_data;
 	struct mg_host *host = prv_data->host;
 
 	if (mg_wait(host, MG_STAT_READY, MG_TMAX_CONF_TO_CMD))
@@ -804,9 +804,9 @@ static int mg_suspend(struct platform_de
 	return 0;
 }
 
-static int mg_resume(struct platform_device *plat_dev)
+static int mg_resume(struct device *dev)
 {
-	struct mg_drv_data *prv_data = plat_dev->dev.platform_data;
+	struct mg_drv_data *prv_data = dev->platform_data;
 	struct mg_host *host = prv_data->host;
 
 	if (mg_wait(host, MG_STAT_READY, MG_TMAX_CONF_TO_CMD))
@@ -825,6 +825,8 @@ static int mg_resume(struct platform_dev
 	return 0;
 }
 
+static SIMPLE_DEV_PM_OPS(mg_pm, mg_suspend, mg_resume);
+
 static int mg_probe(struct platform_device *plat_dev)
 {
 	struct mg_host *host;
@@ -1074,11 +1076,10 @@ static int mg_remove(struct platform_dev
 static struct platform_driver mg_disk_driver = {
 	.probe = mg_probe,
 	.remove = mg_remove,
-	.suspend = mg_suspend,
-	.resume = mg_resume,
 	.driver = {
 		.name = MG_DEV_NAME,
 		.owner = THIS_MODULE,
+		.pm = &mg_pm,
 	}
 };
 
