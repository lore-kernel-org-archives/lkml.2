Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756643Ab2GYMCh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 08:02:37 -0400
Received: from svenfoo.org ([82.94.215.22]:55569 "EHLO mail.zonque.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756558Ab2GYMCU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 08:02:20 -0400
From: Daniel Mack <zonque@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: eric.piel@tremplin-utc.net, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, Daniel Mack <zonque@gmail.com>
Subject: [PATCH 2/2] lis3-spi: add DT matching table passthru code
Date: Wed, 25 Jul 2012 14:02:14 +0200
Message-Id: <1343217734-10438-2-git-send-email-zonque@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1343217734-10438-1-git-send-email-zonque@gmail.com>
References: <1343217734-10438-1-git-send-email-zonque@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If probed from a device tree, this driver now passes the node
information to the generic part, so the runtime information can be
derived.

Successfully tested on a PXA3xx board.

Signed-off-by: Daniel Mack <zonque@gmail.com>
---
 drivers/misc/lis3lv02d/lis3lv02d_spi.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/misc/lis3lv02d/lis3lv02d_spi.c b/drivers/misc/lis3lv02d/lis3lv02d_spi.c
index 80880e9..8616054 100644
--- a/drivers/misc/lis3lv02d/lis3lv02d_spi.c
+++ b/drivers/misc/lis3lv02d/lis3lv02d_spi.c
@@ -17,6 +17,7 @@
 #include <linux/workqueue.h>
 #include <linux/spi/spi.h>
 #include <linux/pm.h>
+#include <linux/of_platform.h>
 
 #include "lis3lv02d.h"
 
@@ -58,6 +59,12 @@ static int lis3_spi_init(struct lis3lv02d *lis3)
 static union axis_conversion lis3lv02d_axis_normal =
 	{ .as_array = { 1, 2, 3 } };
 
+static struct of_device_id lis302dl_spi_dt_ids[] = {
+	{ .compatible = "st,lis302dl-spi" },
+	{}
+};
+MODULE_DEVICE_TABLE(of, lis302dl_spi_dt_ids);
+
 static int __devinit lis302dl_spi_probe(struct spi_device *spi)
 {
 	int ret;
@@ -75,6 +82,12 @@ static int __devinit lis302dl_spi_probe(struct spi_device *spi)
 	lis3_dev.irq		= spi->irq;
 	lis3_dev.ac		= lis3lv02d_axis_normal;
 	lis3_dev.pdata		= spi->dev.platform_data;
+
+#ifdef CONFIG_OF
+	if (of_match_device(lis302dl_spi_dt_ids, &spi->dev))
+		lis3_dev.of_node = spi->dev.of_node;
+#endif
+
 	spi_set_drvdata(spi, &lis3_dev);
 
 	return lis3lv02d_init_device(&lis3_dev);
@@ -121,6 +134,7 @@ static struct spi_driver lis302dl_spi_driver = {
 		.name   = DRV_NAME,
 		.owner  = THIS_MODULE,
 		.pm	= &lis3lv02d_spi_pm,
+		.of_match_table = of_match_ptr(lis302dl_spi_dt_ids),
 	},
 	.probe	= lis302dl_spi_probe,
 	.remove	= __devexit_p(lis302dl_spi_remove),
-- 
1.7.10.4

