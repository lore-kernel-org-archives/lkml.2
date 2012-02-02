Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932619Ab2BBRbK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 12:31:10 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:47512 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932249Ab2BBRbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 12:31:07 -0500
From: Tarun Kanti DebBarma <tarun.kanti@ti.com>
To: <linux-omap@vger.kernel.org>
CC: <grant.likely@secretlab.ca>, <khilman@ti.com>, <tony@atomide.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Charulatha V <charu@ti.com>
Subject: [PATCH v9 02/25] gpio/omap: use flag to identify wakeup domain
Date: Thu, 2 Feb 2012 23:00:28 +0530
Message-ID: <1328203851-20435-3-git-send-email-tarun.kanti@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1328203851-20435-1-git-send-email-tarun.kanti@ti.com>
References: <1328203851-20435-1-git-send-email-tarun.kanti@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Charulatha V <charu@ti.com>

In omap3, save/restore context is implemented for GPIO banks 2-6 as GPIO bank1
is in wakeup domain. Instead of identifying bank's power domain by bank id,
use 'loses_context' flag which is filled by pwrdm_can_ever_lose_context()
during dev_init.

For getting the powerdomain pointer, omap_hwmod_get_pwrdm() is used.
omap_device_get_pwrdm() could not be used as the pwrdm information needs to be
filled in pdata, whereas omap_device_get_pwrdm() could be used only after
omap_device_build() call.

Signed-off-by: Charulatha V <charu@ti.com>
Reviewed-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 arch/arm/mach-omap2/gpio.c             |    6 ++++++
 arch/arm/plat-omap/include/plat/gpio.h |    1 +
 drivers/gpio/gpio-omap.c               |   13 ++++++-------
 3 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mach-omap2/gpio.c b/arch/arm/mach-omap2/gpio.c
index 07ac648..076be34 100644
--- a/arch/arm/mach-omap2/gpio.c
+++ b/arch/arm/mach-omap2/gpio.c
@@ -24,6 +24,8 @@
 #include <plat/omap_hwmod.h>
 #include <plat/omap_device.h>
 
+#include "powerdomain.h"
+
 static int omap2_gpio_dev_init(struct omap_hwmod *oh, void *unused)
 {
 	struct platform_device *pdev;
@@ -31,6 +33,7 @@ static int omap2_gpio_dev_init(struct omap_hwmod *oh, void *unused)
 	struct omap_gpio_dev_attr *dev_attr;
 	char *name = "omap_gpio";
 	int id;
+	struct powerdomain *pwrdm;
 
 	/*
 	 * extract the device id from name field available in the
@@ -99,6 +102,9 @@ static int omap2_gpio_dev_init(struct omap_hwmod *oh, void *unused)
 		return -EINVAL;
 	}
 
+	pwrdm = omap_hwmod_get_pwrdm(oh);
+	pdata->loses_context = pwrdm_can_ever_lose_context(pwrdm);
+
 	pdev = omap_device_build(name, id - 1, oh, pdata,
 				sizeof(*pdata),	NULL, 0, false);
 	kfree(pdata);
diff --git a/arch/arm/plat-omap/include/plat/gpio.h b/arch/arm/plat-omap/include/plat/gpio.h
index acf1c77..6eb035c 100644
--- a/arch/arm/plat-omap/include/plat/gpio.h
+++ b/arch/arm/plat-omap/include/plat/gpio.h
@@ -198,6 +198,7 @@ struct omap_gpio_platform_data {
 	int bank_width;		/* GPIO bank width */
 	int bank_stride;	/* Only needed for omap1 MPUIO */
 	bool dbck_flag;		/* dbck required or not - True for OMAP3&4 */
+	bool loses_context;	/* whether the bank would ever lose context */
 
 	struct omap_gpio_reg_offs *regs;
 };
diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
index 6ea7390..07efa15 100644
--- a/drivers/gpio/gpio-omap.c
+++ b/drivers/gpio/gpio-omap.c
@@ -56,6 +56,7 @@ struct gpio_bank {
 	u32 dbck_enable_mask;
 	struct device *dev;
 	bool dbck_flag;
+	bool loses_context;
 	int stride;
 	u32 width;
 	u16 id;
@@ -1181,7 +1182,7 @@ static int __devinit omap_gpio_probe(struct platform_device *pdev)
 	bank->dbck_flag = pdata->dbck_flag;
 	bank->stride = pdata->bank_stride;
 	bank->width = pdata->bank_width;
-
+	bank->loses_context = pdata->loses_context;
 	bank->regs = pdata->regs;
 
 	if (bank->regs->set_dataout && bank->regs->clr_dataout)
@@ -1337,8 +1338,7 @@ void omap2_gpio_prepare_for_idle(int off_mode)
 		u32 l1 = 0, l2 = 0;
 		int j;
 
-		/* TODO: Do not use cpu_is_omap34xx */
-		if ((cpu_is_omap34xx()) && (bank->id == 0))
+		if (!bank->loses_context)
 			continue;
 
 		for (j = 0; j < hweight_long(bank->dbck_enable_mask); j++)
@@ -1405,8 +1405,7 @@ void omap2_gpio_resume_after_idle(void)
 		u32 l = 0, gen, gen0, gen1;
 		int j;
 
-		/* TODO: Do not use cpu_is_omap34xx */
-		if ((cpu_is_omap34xx()) && (bank->id == 0))
+		if (!bank->loses_context)
 			continue;
 
 		for (j = 0; j < hweight_long(bank->dbck_enable_mask); j++)
@@ -1505,7 +1504,7 @@ void omap_gpio_save_context(void)
 	list_for_each_entry(bank, &omap_gpio_list, node) {
 		i++;
 
-		if (bank->id == 0)
+		if (!bank->loses_context)
 			continue;
 
 		gpio_context[i].irqenable1 =
@@ -1539,7 +1538,7 @@ void omap_gpio_restore_context(void)
 	list_for_each_entry(bank, &omap_gpio_list, node) {
 		i++;
 
-		if (bank->id == 0)
+		if (!bank->loses_context)
 			continue;
 
 		__raw_writel(gpio_context[i].irqenable1,
-- 
1.7.0.4

