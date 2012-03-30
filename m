Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934586Ab2C3PwK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 11:52:10 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:54454 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934496Ab2C3PuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 11:50:19 -0400
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <linux-i2c@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [PATCHv3 13/16] OMAP: I2C: Handle error check for pm runtime
Date: Fri, 30 Mar 2012 21:20:08 +0530
Message-ID: <1333122611-29953-14-git-send-email-shubhrajyoti@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1333122611-29953-1-git-send-email-shubhrajyoti@ti.com>
References: <1333122611-29953-1-git-send-email-shubhrajyoti@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If PM runtime get_sync fails return with the error
so that no further reads/writes goes through the interface.
This will avoid possible abort.

Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
---
 drivers/i2c/busses/i2c-omap.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
index 1ea7b74..b098650 100644
--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -616,7 +616,9 @@ omap_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[], int num)
 	int i;
 	int r;
 
-	pm_runtime_get_sync(dev->dev);
+	r = pm_runtime_get_sync(dev->dev);
+	if (r < 0)
+		return r;
 
 	r = omap_i2c_wait_for_bb(dev);
 	if (r < 0)
@@ -1044,7 +1046,9 @@ omap_i2c_probe(struct platform_device *pdev)
 		dev->regs = (u8 *)reg_map_ip_v1;
 
 	pm_runtime_enable(dev->dev);
-	pm_runtime_get_sync(dev->dev);
+	r = pm_runtime_get_sync(dev->dev);
+	if (r < 0)
+		return r;
 
 	dev->rev = omap_i2c_read_reg(dev, OMAP_I2C_REV_REG) & 0xff;
 
@@ -1129,12 +1133,15 @@ err_unuse_clocks:
 static int __devexit omap_i2c_remove(struct platform_device *pdev)
 {
 	struct omap_i2c_dev	*dev = platform_get_drvdata(pdev);
+	int ret;
 
 	platform_set_drvdata(pdev, NULL);
 
 	free_irq(dev->irq, dev);
 	i2c_del_adapter(&dev->adapter);
-	pm_runtime_get_sync(&pdev->dev);
+	ret = pm_runtime_get_sync(&pdev->dev);
+	if (ret < 0)
+		return ret;
 	omap_i2c_write_reg(dev, OMAP_I2C_CON_REG, 0);
 	pm_runtime_put(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
-- 
1.7.1

