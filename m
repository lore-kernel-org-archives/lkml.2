Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934619Ab2C3PxR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 11:53:17 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:37466 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934411Ab2C3PuS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 11:50:18 -0400
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <linux-i2c@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, Shubhrajyoti D <shubhrajyoti@ti.com>,
        Kevin Hilman <khilman@ti.com>, Rajendra Nayak <rnayak@ti.com>
Subject: [PATCHv3 06/16] OMAP: I2C: Fix the mismatch of pm_runtime enable and disable
Date: Fri, 30 Mar 2012 21:20:01 +0530
Message-ID: <1333122611-29953-7-git-send-email-shubhrajyoti@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1333122611-29953-1-git-send-email-shubhrajyoti@ti.com>
References: <1333122611-29953-1-git-send-email-shubhrajyoti@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the i2c driver calls the pm_runtime_enable and never
the disable. This may cause a warning when pm_runtime_enable
checks for the count match.Attempting to fix the same by calling
pm_runtime_disable in the error and the remove path.

Cc: Kevin Hilman <khilman@ti.com>
Cc: Rajendra Nayak <rnayak@ti.com>
Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
---
 drivers/i2c/busses/i2c-omap.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
index 1c38572..7df1ea2 100644
--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -1124,6 +1124,7 @@ err_unuse_clocks:
 	omap_i2c_write_reg(dev, OMAP_I2C_CON_REG, 0);
 	pm_runtime_put(dev->dev);
 	iounmap(dev->base);
+	pm_runtime_disable(&pdev->dev);
 err_free_mem:
 	platform_set_drvdata(pdev, NULL);
 	kfree(dev);
@@ -1144,6 +1145,7 @@ omap_i2c_remove(struct platform_device *pdev)
 	free_irq(dev->irq, dev);
 	i2c_del_adapter(&dev->adapter);
 	omap_i2c_write_reg(dev, OMAP_I2C_CON_REG, 0);
+	pm_runtime_disable(&pdev->dev);
 	iounmap(dev->base);
 	kfree(dev);
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-- 
1.7.1

