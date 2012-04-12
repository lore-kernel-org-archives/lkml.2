Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934624Ab2DLStX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 14:49:23 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:44852 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762221Ab2DLSpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 14:45:20 -0400
Date: Thu, 12 Apr 2012 20:45:24 +0200
From: Karol Lewandowski <k.lewandowsk@samsung.com>
Subject: [PATCH 05/13] i2c: Dynamically assign adapter id if it wasn't
 explictly specified
In-reply-to: <1334256332-29867-1-git-send-email-k.lewandowsk@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org, thomas.abraham@linaro.org,
        m.szyprowski@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, olof@lixom.net, kgene.kim@samsung.com,
        Karol Lewandowski <k.lewandowsk@samsung.com>,
        Wolfram Sang <w.sang@pengutronix.de>
Message-id: <1334256332-29867-6-git-send-email-k.lewandowsk@samsung.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.9.1
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1334256332-29867-1-git-send-email-k.lewandowsk@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 488bf314b ("i2c: Allow i2c_add_numbered_adapter() to assign a
bus id") reworked i2c_add_numbered_adapter() to call i2c_add_adapter()
if requested bus was -1.

This allows to simplify driver's initialization procedure by using
just one function for static and dynamic adapter id registration.

This patch updates few more drivers (missed out in original patch)
to use this functionality.

Signed-off-by: Karol Lewandowski <k.lewandowsk@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Wolfram Sang <w.sang@pengutronix.de>
---
 drivers/i2c/busses/i2c-gpio.c         |    7 +------
 drivers/i2c/busses/i2c-pca-platform.c |    2 +-
 drivers/i2c/busses/i2c-versatile.c    |    9 ++-------
 3 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/drivers/i2c/busses/i2c-gpio.c b/drivers/i2c/busses/i2c-gpio.c
index c0330a4..e62d2d9 100644
--- a/drivers/i2c/busses/i2c-gpio.c
+++ b/drivers/i2c/busses/i2c-gpio.c
@@ -190,12 +190,7 @@ static int __devinit i2c_gpio_probe(struct platform_device *pdev)
 	adap->dev.parent = &pdev->dev;
 	adap->dev.of_node = pdev->dev.of_node;
 
-	/*
-	 * If "dev->id" is negative we consider it as zero.
-	 * The reason to do so is to avoid sysfs names that only make
-	 * sense when there are multiple adapters.
-	 */
-	adap->nr = (pdev->id != -1) ? pdev->id : 0;
+	adap->nr = pdev->id;
 	ret = i2c_bit_add_numbered_bus(adap);
 	if (ret)
 		goto err_add_bus;
diff --git a/drivers/i2c/busses/i2c-pca-platform.c b/drivers/i2c/busses/i2c-pca-platform.c
index 2adbf1a..675878f 100644
--- a/drivers/i2c/busses/i2c-pca-platform.c
+++ b/drivers/i2c/busses/i2c-pca-platform.c
@@ -171,7 +171,7 @@ static int __devinit i2c_pca_pf_probe(struct platform_device *pdev)
 	i2c->io_size = resource_size(res);
 	i2c->irq = irq;
 
-	i2c->adap.nr = pdev->id >= 0 ? pdev->id : 0;
+	i2c->adap.nr = pdev->id;
 	i2c->adap.owner = THIS_MODULE;
 	snprintf(i2c->adap.name, sizeof(i2c->adap.name),
 		 "PCA9564/PCA9665 at 0x%08lx",
diff --git a/drivers/i2c/busses/i2c-versatile.c b/drivers/i2c/busses/i2c-versatile.c
index f585aea..eec20db 100644
--- a/drivers/i2c/busses/i2c-versatile.c
+++ b/drivers/i2c/busses/i2c-versatile.c
@@ -104,13 +104,8 @@ static int i2c_versatile_probe(struct platform_device *dev)
 	i2c->algo = i2c_versatile_algo;
 	i2c->algo.data = i2c;
 
-	if (dev->id >= 0) {
-		/* static bus numbering */
-		i2c->adap.nr = dev->id;
-		ret = i2c_bit_add_numbered_bus(&i2c->adap);
-	} else
-		/* dynamic bus numbering */
-		ret = i2c_bit_add_bus(&i2c->adap);
+	i2c->adap.nr = dev->id;
+	ret = i2c_bit_add_numbered_bus(&i2c->adap);
 	if (ret >= 0) {
 		platform_set_drvdata(dev, i2c);
 		of_i2c_register_devices(&i2c->adap);
-- 
1.7.9.1

