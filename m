Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934556Ab2C3Puv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 11:50:51 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:54448 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934401Ab2C3PuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 11:50:17 -0400
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <linux-i2c@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [PATCHv3 04/16] OMAP: I2C: I2C register restore only if context is lost
Date: Fri, 30 Mar 2012 21:19:59 +0530
Message-ID: <1333122611-29953-5-git-send-email-shubhrajyoti@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1333122611-29953-1-git-send-email-shubhrajyoti@ti.com>
References: <1333122611-29953-1-git-send-email-shubhrajyoti@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Currently i2c register restore is done always.
 Adding conditional restore.
 The i2c register restore is done only if the context is lost.
 Also remove the definition of SYSS_RESETDONE_MASK and use the
 one in omap_hwmod.h.

Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
---
 arch/arm/plat-omap/i2c.c      |    3 ++
 drivers/i2c/busses/i2c-omap.c |   52 ++++++++++++++++++++++++++--------------
 include/linux/i2c-omap.h      |    1 +
 3 files changed, 38 insertions(+), 18 deletions(-)

diff --git a/arch/arm/plat-omap/i2c.c b/arch/arm/plat-omap/i2c.c
index db071bc..4ccab07 100644
--- a/arch/arm/plat-omap/i2c.c
+++ b/arch/arm/plat-omap/i2c.c
@@ -179,6 +179,9 @@ static inline int omap2_i2c_add_bus(int bus_id)
 	 */
 	if (cpu_is_omap34xx())
 		pdata->set_mpu_wkup_lat = omap_pm_set_max_mpu_wakeup_lat_compat;
+
+	pdata->get_context_loss_count = omap_pm_get_dev_context_loss_count;
+
 	pdev = omap_device_build(name, bus_id, oh, pdata,
 			sizeof(struct omap_i2c_bus_platform_data),
 			NULL, 0, 0);
diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
index f19bb7e..f39d591 100644
--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -43,6 +43,7 @@
 #include <linux/slab.h>
 #include <linux/i2c-omap.h>
 #include <linux/pm_runtime.h>
+#include <plat/omap_device.h>
 
 /* I2C controller revisions */
 #define OMAP_I2C_OMAP1_REV_2		0x20
@@ -157,9 +158,6 @@ enum {
 #define OMAP_I2C_SYSTEST_SDA_I		(1 << 1)	/* SDA line sense in */
 #define OMAP_I2C_SYSTEST_SDA_O		(1 << 0)	/* SDA line drive out */
 
-/* OCP_SYSSTATUS bit definitions */
-#define SYSS_RESETDONE_MASK		(1 << 0)
-
 /* OCP_SYSCONFIG bit definitions */
 #define SYSC_CLOCKACTIVITY_MASK		(0x3 << 8)
 #define SYSC_SIDLEMODE_MASK		(0x3 << 3)
@@ -184,6 +182,7 @@ struct omap_i2c_dev {
 	u32			latency;	/* maximum mpu wkup latency */
 	void			(*set_mpu_wkup_lat)(struct device *dev,
 						    long latency);
+	int			(*get_context_loss_count)(struct device *dev);
 	u32			speed;		/* Speed of bus in kHz */
 	u32			dtrev;		/* extra revision from DT */
 	u32			flags;
@@ -206,6 +205,7 @@ struct omap_i2c_dev {
 	u16			syscstate;
 	u16			westate;
 	u16			errata;
+	int			dev_lost_count;
 };
 
 static const u8 reg_map_ip_v1[] = {
@@ -1025,6 +1025,7 @@ omap_i2c_probe(struct platform_device *pdev)
 		dev->speed = pdata->clkrate;
 		dev->flags = pdata->flags;
 		dev->set_mpu_wkup_lat = pdata->set_mpu_wkup_lat;
+		dev->get_context_loss_count = pdata->get_context_loss_count;
 		dev->dtrev = pdata->rev;
 	}
 
@@ -1151,12 +1152,32 @@ omap_i2c_remove(struct platform_device *pdev)
 }
 
 #ifdef CONFIG_PM_RUNTIME
+static void omap_i2c_restore(struct omap_i2c_dev *dev)
+{
+	omap_i2c_write_reg(dev, OMAP_I2C_CON_REG, 0);
+	omap_i2c_write_reg(dev, OMAP_I2C_PSC_REG, dev->pscstate);
+	omap_i2c_write_reg(dev, OMAP_I2C_SCLL_REG, dev->scllstate);
+	omap_i2c_write_reg(dev, OMAP_I2C_SCLH_REG, dev->sclhstate);
+	omap_i2c_write_reg(dev, OMAP_I2C_BUF_REG, dev->bufstate);
+	omap_i2c_write_reg(dev, OMAP_I2C_WE_REG, dev->westate);
+	omap_i2c_write_reg(dev, OMAP_I2C_CON_REG, OMAP_I2C_CON_EN);
+	/*
+	 * Don't write to this register if the IE state is 0 as it can
+	 * cause deadlock.
+	 */
+	if (dev->iestate)
+		omap_i2c_write_reg(dev, OMAP_I2C_IE_REG, dev->iestate);
+
+}
 static int omap_i2c_runtime_suspend(struct device *dev)
 {
 	struct platform_device *pdev = to_platform_device(dev);
 	struct omap_i2c_dev *_dev = platform_get_drvdata(pdev);
 	u16 iv;
 
+	if (_dev->get_context_loss_count)
+		_dev->dev_lost_count = _dev->get_context_loss_count(dev);
+
 	_dev->iestate = omap_i2c_read_reg(_dev, OMAP_I2C_IE_REG);
 	if (_dev->dtrev == OMAP_I2C_IP_VERSION_2)
 		omap_i2c_write_reg(_dev, OMAP_I2C_IP_V2_IRQENABLE_CLR, 1);
@@ -1179,24 +1200,19 @@ static int omap_i2c_runtime_resume(struct device *dev)
 {
 	struct platform_device *pdev = to_platform_device(dev);
 	struct omap_i2c_dev *_dev = platform_get_drvdata(pdev);
+	int loss_cnt;
 
-	if (_dev->flags & OMAP_I2C_FLAG_RESET_REGS_POSTIDLE) {
-		omap_i2c_write_reg(_dev, OMAP_I2C_CON_REG, 0);
-		omap_i2c_write_reg(_dev, OMAP_I2C_PSC_REG, _dev->pscstate);
-		omap_i2c_write_reg(_dev, OMAP_I2C_SCLL_REG, _dev->scllstate);
-		omap_i2c_write_reg(_dev, OMAP_I2C_SCLH_REG, _dev->sclhstate);
-		omap_i2c_write_reg(_dev, OMAP_I2C_BUF_REG, _dev->bufstate);
-		omap_i2c_write_reg(_dev, OMAP_I2C_SYSC_REG, _dev->syscstate);
-		omap_i2c_write_reg(_dev, OMAP_I2C_WE_REG, _dev->westate);
-		omap_i2c_write_reg(_dev, OMAP_I2C_CON_REG, OMAP_I2C_CON_EN);
+	if (_dev->get_context_loss_count) {
+		loss_cnt = _dev->get_context_loss_count(dev);
+		if (loss_cnt < 0)
+			return loss_cnt;
+
+		if (_dev->dev_lost_count == loss_cnt && _dev->dev_lost_count)
+			return 0;
 	}
 
-	/*
-	 * Don't write to this register if the IE state is 0 as it can
-	 * cause deadlock.
-	 */
-	if (_dev->iestate)
-		omap_i2c_write_reg(_dev, OMAP_I2C_IE_REG, _dev->iestate);
+	if (_dev->flags & OMAP_I2C_FLAG_RESET_REGS_POSTIDLE)
+		omap_i2c_restore(_dev);
 
 	return 0;
 }
diff --git a/include/linux/i2c-omap.h b/include/linux/i2c-omap.h
index 92a0dc7..c76cbc0 100644
--- a/include/linux/i2c-omap.h
+++ b/include/linux/i2c-omap.h
@@ -35,6 +35,7 @@ struct omap_i2c_bus_platform_data {
 	u32		rev;
 	u32		flags;
 	void		(*set_mpu_wkup_lat)(struct device *dev, long set);
+	int		(*get_context_loss_count)(struct device *dev);
 };
 
 #endif
-- 
1.7.1

