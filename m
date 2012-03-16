Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422785Ab2CPMTg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 08:19:36 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:41863 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422761Ab2CPMTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 08:19:19 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Fri, 16 Mar 2012 13:19:03 +0100
From: Karol Lewandowski <k.lewandowsk@samsung.com>
Subject: [PATCH 2/2] i2c: Dynamically assign adapter id if it wasn't explictly
 specified
In-reply-to: <1331900343-6743-1-git-send-email-k.lewandowsk@samsung.com>
To: w.sang@pengutronix.de
Cc: ben-linux@fluff.org, khali@linux-fr.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, hskinnemoen@gmail.com,
        dirk.brandewie@gmail.com, bigeasy@linutronix.de,
        m.szyprowski@samsung.com, grant.likely@secretlab.ca,
        kyungmin.park@samsung.com,
        Karol Lewandowski <k.lewandowsk@samsung.com>
Message-id: <1331900343-6743-3-git-send-email-k.lewandowsk@samsung.com>
X-Mailer: git-send-email 1.7.9
References: <1331900343-6743-1-git-send-email-k.lewandowsk@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 488bf314b ("i2c: Allow i2c_add_numbered_adapter() to assign a
bus id") reworked i2c_add_numbered_adapter() to call i2c_add_adapter()
if requested bus was -1.

This allows to simplify driver's initialization procedure as it allows
static and dynamic adapter id registration using one function.

This patch updates few more drivers (missed out in original patch) to
use this functionality.

Signed-off-by: Karol Lewandowski <k.lewandowsk@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/i2c/busses/i2c-gpio.c         |    7 +------
 drivers/i2c/busses/i2c-octeon.c       |    2 +-
 drivers/i2c/busses/i2c-pca-platform.c |    2 +-
 drivers/i2c/busses/i2c-versatile.c    |    9 ++-------
 4 files changed, 5 insertions(+), 15 deletions(-)

diff --git a/drivers/i2c/busses/i2c-gpio.c b/drivers/i2c/busses/i2c-gpio.c
index a651779..50a2a94 100644
--- a/drivers/i2c/busses/i2c-gpio.c
+++ b/drivers/i2c/busses/i2c-gpio.c
@@ -144,12 +144,7 @@ static int __devinit i2c_gpio_probe(struct platform_device *pdev)
 	adap->class = I2C_CLASS_HWMON | I2C_CLASS_SPD;
 	adap->dev.parent = &pdev->dev;
 
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
diff --git a/drivers/i2c/busses/i2c-octeon.c b/drivers/i2c/busses/i2c-octeon.c
index ee139a5..8470232 100644
--- a/drivers/i2c/busses/i2c-octeon.c
+++ b/drivers/i2c/busses/i2c-octeon.c
@@ -581,7 +581,7 @@ static int __devinit octeon_i2c_probe(struct platform_device *pdev)
 
 	i2c->adap = octeon_i2c_ops;
 	i2c->adap.dev.parent = &pdev->dev;
-	i2c->adap.nr = pdev->id >= 0 ? pdev->id : 0;
+	i2c->adap.nr = pdev->id;
 	i2c_set_adapdata(&i2c->adap, i2c);
 	platform_set_drvdata(pdev, i2c);
 
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
index 6055601..9458568 100644
--- a/drivers/i2c/busses/i2c-versatile.c
+++ b/drivers/i2c/busses/i2c-versatile.c
@@ -102,13 +102,8 @@ static int i2c_versatile_probe(struct platform_device *dev)
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
 		return 0;
-- 
1.7.9

