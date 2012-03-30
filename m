Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934529Ab2C3Pu2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 11:50:28 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:54443 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934311Ab2C3PuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 11:50:17 -0400
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <linux-i2c@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [PATCHv3 01/16] I2C : OMAP : make omap_i2c_unidle/idle functions depend on CONFIG_PM_RUNTIME
Date: Fri, 30 Mar 2012 21:19:56 +0530
Message-ID: <1333122611-29953-2-git-send-email-shubhrajyoti@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1333122611-29953-1-git-send-email-shubhrajyoti@ti.com>
References: <1333122611-29953-1-git-send-email-shubhrajyoti@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The functions omap_i2c_unidle/idle are called from omap_i2c_runtime_resume
and omap_i2c_runtime_suspend which is compiled for CONFIG_PM_RUNTIME.
This patch removes the omap_i2c_unidle/idle functions and folds them
into the runtime callbacks.

This fixes the below warn when CONFIG_PM_RUNTIME is not defined

 CC      arch/arm/mach-omap2/board-ti8168evm.o
drivers/i2c/busses/i2c-omap.c:272: warning: 'omap_i2c_unidle' defined but not used
drivers/i2c/busses/i2c-omap.c:293: warning: 'omap_i2c_idle' defined but not used
  CC      net/ipv4/ip_forward.o

Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
---
 drivers/i2c/busses/i2c-omap.c |   75 +++++++++++++++++-----------------------
 1 files changed, 32 insertions(+), 43 deletions(-)

diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
index 801df60..4f4188d 100644
--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -269,47 +269,6 @@ static inline u16 omap_i2c_read_reg(struct omap_i2c_dev *i2c_dev, int reg)
 				(i2c_dev->regs[reg] << i2c_dev->reg_shift));
 }
 
-static void omap_i2c_unidle(struct omap_i2c_dev *dev)
-{
-	if (dev->flags & OMAP_I2C_FLAG_RESET_REGS_POSTIDLE) {
-		omap_i2c_write_reg(dev, OMAP_I2C_CON_REG, 0);
-		omap_i2c_write_reg(dev, OMAP_I2C_PSC_REG, dev->pscstate);
-		omap_i2c_write_reg(dev, OMAP_I2C_SCLL_REG, dev->scllstate);
-		omap_i2c_write_reg(dev, OMAP_I2C_SCLH_REG, dev->sclhstate);
-		omap_i2c_write_reg(dev, OMAP_I2C_BUF_REG, dev->bufstate);
-		omap_i2c_write_reg(dev, OMAP_I2C_SYSC_REG, dev->syscstate);
-		omap_i2c_write_reg(dev, OMAP_I2C_WE_REG, dev->westate);
-		omap_i2c_write_reg(dev, OMAP_I2C_CON_REG, OMAP_I2C_CON_EN);
-	}
-
-	/*
-	 * Don't write to this register if the IE state is 0 as it can
-	 * cause deadlock.
-	 */
-	if (dev->iestate)
-		omap_i2c_write_reg(dev, OMAP_I2C_IE_REG, dev->iestate);
-}
-
-static void omap_i2c_idle(struct omap_i2c_dev *dev)
-{
-	u16 iv;
-
-	dev->iestate = omap_i2c_read_reg(dev, OMAP_I2C_IE_REG);
-	if (dev->dtrev == OMAP_I2C_IP_VERSION_2)
-		omap_i2c_write_reg(dev, OMAP_I2C_IP_V2_IRQENABLE_CLR, 1);
-	else
-		omap_i2c_write_reg(dev, OMAP_I2C_IE_REG, 0);
-
-	if (dev->rev < OMAP_I2C_OMAP1_REV_2) {
-		iv = omap_i2c_read_reg(dev, OMAP_I2C_IV_REG); /* Read clears */
-	} else {
-		omap_i2c_write_reg(dev, OMAP_I2C_STAT_REG, dev->iestate);
-
-		/* Flush posted write */
-		omap_i2c_read_reg(dev, OMAP_I2C_STAT_REG);
-	}
-}
-
 static int omap_i2c_init(struct omap_i2c_dev *dev)
 {
 	u16 psc = 0, scll = 0, sclh = 0, buf = 0;
@@ -1163,8 +1122,22 @@ static int omap_i2c_runtime_suspend(struct device *dev)
 {
 	struct platform_device *pdev = to_platform_device(dev);
 	struct omap_i2c_dev *_dev = platform_get_drvdata(pdev);
+	u16 iv;
+
+	_dev->iestate = omap_i2c_read_reg(_dev, OMAP_I2C_IE_REG);
+	if (_dev->dtrev == OMAP_I2C_IP_VERSION_2)
+		omap_i2c_write_reg(_dev, OMAP_I2C_IP_V2_IRQENABLE_CLR, 1);
+	else
+		omap_i2c_write_reg(_dev, OMAP_I2C_IE_REG, 0);
+
+	if (_dev->rev < OMAP_I2C_OMAP1_REV_2) {
+		iv = omap_i2c_read_reg(_dev, OMAP_I2C_IV_REG); /* Read clears */
+	} else {
+		omap_i2c_write_reg(_dev, OMAP_I2C_STAT_REG, _dev->iestate);
 
-	omap_i2c_idle(_dev);
+		/* Flush posted write */
+		omap_i2c_read_reg(_dev, OMAP_I2C_STAT_REG);
+	}
 
 	return 0;
 }
@@ -1174,7 +1147,23 @@ static int omap_i2c_runtime_resume(struct device *dev)
 	struct platform_device *pdev = to_platform_device(dev);
 	struct omap_i2c_dev *_dev = platform_get_drvdata(pdev);
 
-	omap_i2c_unidle(_dev);
+	if (_dev->flags & OMAP_I2C_FLAG_RESET_REGS_POSTIDLE) {
+		omap_i2c_write_reg(_dev, OMAP_I2C_CON_REG, 0);
+		omap_i2c_write_reg(_dev, OMAP_I2C_PSC_REG, _dev->pscstate);
+		omap_i2c_write_reg(_dev, OMAP_I2C_SCLL_REG, _dev->scllstate);
+		omap_i2c_write_reg(_dev, OMAP_I2C_SCLH_REG, _dev->sclhstate);
+		omap_i2c_write_reg(_dev, OMAP_I2C_BUF_REG, _dev->bufstate);
+		omap_i2c_write_reg(_dev, OMAP_I2C_SYSC_REG, _dev->syscstate);
+		omap_i2c_write_reg(_dev, OMAP_I2C_WE_REG, _dev->westate);
+		omap_i2c_write_reg(_dev, OMAP_I2C_CON_REG, OMAP_I2C_CON_EN);
+	}
+
+	/*
+	 * Don't write to this register if the IE state is 0 as it can
+	 * cause deadlock.
+	 */
+	if (_dev->iestate)
+		omap_i2c_write_reg(_dev, OMAP_I2C_IE_REG, _dev->iestate);
 
 	return 0;
 }
-- 
1.7.1

