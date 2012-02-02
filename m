Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933024Ab2BBRga (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 12:36:30 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:47549 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932716Ab2BBRbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 12:31:19 -0500
From: Tarun Kanti DebBarma <tarun.kanti@ti.com>
To: <linux-omap@vger.kernel.org>
CC: <grant.likely@secretlab.ca>, <khilman@ti.com>, <tony@atomide.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Tarun Kanti DebBarma <tarun.kanti@ti.com>, Charulatha V <charu@ti.com>
Subject: [PATCH v9 09/25] gpio/omap: remove hardcoded offsets in context save/restore
Date: Thu, 2 Feb 2012 23:00:35 +0530
Message-ID: <1328203851-20435-10-git-send-email-tarun.kanti@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1328203851-20435-1-git-send-email-tarun.kanti@ti.com>
References: <1328203851-20435-1-git-send-email-tarun.kanti@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is not required to use hard-coded offsets any more in context save and
restore functions and instead use the generic offsets which have been correctly
initialized during device registration.

Signed-off-by: Tarun Kanti DebBarma <tarun.kanti@ti.com>
Signed-off-by: Charulatha V <charu@ti.com>
Reviewed-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Acked-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/gpio.c             |    2 +
 arch/arm/plat-omap/include/plat/gpio.h |    1 +
 drivers/gpio/gpio-omap.c               |   42 +++++++++++++++----------------
 3 files changed, 23 insertions(+), 22 deletions(-)

diff --git a/arch/arm/mach-omap2/gpio.c b/arch/arm/mach-omap2/gpio.c
index ae5043e..f4c45ca 100644
--- a/arch/arm/mach-omap2/gpio.c
+++ b/arch/arm/mach-omap2/gpio.c
@@ -84,6 +84,7 @@ static int omap2_gpio_dev_init(struct omap_hwmod *oh, void *unused)
 		pdata->regs->irqstatus = OMAP24XX_GPIO_IRQSTATUS1;
 		pdata->regs->irqstatus2 = OMAP24XX_GPIO_IRQSTATUS2;
 		pdata->regs->irqenable = OMAP24XX_GPIO_IRQENABLE1;
+		pdata->regs->irqenable2 = OMAP24XX_GPIO_IRQENABLE2;
 		pdata->regs->set_irqenable = OMAP24XX_GPIO_SETIRQENABLE1;
 		pdata->regs->clr_irqenable = OMAP24XX_GPIO_CLEARIRQENABLE1;
 		pdata->regs->debounce = OMAP24XX_GPIO_DEBOUNCE_VAL;
@@ -106,6 +107,7 @@ static int omap2_gpio_dev_init(struct omap_hwmod *oh, void *unused)
 		pdata->regs->irqstatus = OMAP4_GPIO_IRQSTATUS0;
 		pdata->regs->irqstatus2 = OMAP4_GPIO_IRQSTATUS1;
 		pdata->regs->irqenable = OMAP4_GPIO_IRQSTATUSSET0;
+		pdata->regs->irqenable2 = OMAP4_GPIO_IRQSTATUSSET1;
 		pdata->regs->set_irqenable = OMAP4_GPIO_IRQSTATUSSET0;
 		pdata->regs->clr_irqenable = OMAP4_GPIO_IRQSTATUSCLR0;
 		pdata->regs->debounce = OMAP4_GPIO_DEBOUNCINGTIME;
diff --git a/arch/arm/plat-omap/include/plat/gpio.h b/arch/arm/plat-omap/include/plat/gpio.h
index 395b3c1..914c976 100644
--- a/arch/arm/plat-omap/include/plat/gpio.h
+++ b/arch/arm/plat-omap/include/plat/gpio.h
@@ -184,6 +184,7 @@ struct omap_gpio_reg_offs {
 	u16 irqstatus;
 	u16 irqstatus2;
 	u16 irqenable;
+	u16 irqenable2;
 	u16 set_irqenable;
 	u16 clr_irqenable;
 	u16 debounce;
diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
index 991dd39..ceb9edf 100644
--- a/drivers/gpio/gpio-omap.c
+++ b/drivers/gpio/gpio-omap.c
@@ -1369,45 +1369,43 @@ void omap2_gpio_resume_after_idle(void)
 static void omap_gpio_save_context(struct gpio_bank *bank)
 {
 	bank->context.irqenable1 =
-		__raw_readl(bank->base + OMAP24XX_GPIO_IRQENABLE1);
+			__raw_readl(bank->base + bank->regs->irqenable);
 	bank->context.irqenable2 =
-		__raw_readl(bank->base + OMAP24XX_GPIO_IRQENABLE2);
+			__raw_readl(bank->base + bank->regs->irqenable2);
 	bank->context.wake_en =
-		__raw_readl(bank->base + OMAP24XX_GPIO_WAKE_EN);
-	bank->context.ctrl = __raw_readl(bank->base + OMAP24XX_GPIO_CTRL);
-	bank->context.oe = __raw_readl(bank->base + OMAP24XX_GPIO_OE);
+			__raw_readl(bank->base + bank->regs->wkup_en);
+	bank->context.ctrl = __raw_readl(bank->base + bank->regs->ctrl);
+	bank->context.oe = __raw_readl(bank->base + bank->regs->direction);
 	bank->context.leveldetect0 =
-		__raw_readl(bank->base + OMAP24XX_GPIO_LEVELDETECT0);
+			__raw_readl(bank->base + bank->regs->leveldetect0);
 	bank->context.leveldetect1 =
-		__raw_readl(bank->base + OMAP24XX_GPIO_LEVELDETECT1);
+			__raw_readl(bank->base + bank->regs->leveldetect1);
 	bank->context.risingdetect =
-		__raw_readl(bank->base + OMAP24XX_GPIO_RISINGDETECT);
+			__raw_readl(bank->base + bank->regs->risingdetect);
 	bank->context.fallingdetect =
-		__raw_readl(bank->base + OMAP24XX_GPIO_FALLINGDETECT);
-	bank->context.dataout =
-		__raw_readl(bank->base + OMAP24XX_GPIO_DATAOUT);
+			__raw_readl(bank->base + bank->regs->fallingdetect);
+	bank->context.dataout = __raw_readl(bank->base + bank->regs->dataout);
 }
 
 static void omap_gpio_restore_context(struct gpio_bank *bank)
 {
 	__raw_writel(bank->context.irqenable1,
-			bank->base + OMAP24XX_GPIO_IRQENABLE1);
+				bank->base + bank->regs->irqenable);
 	__raw_writel(bank->context.irqenable2,
-			bank->base + OMAP24XX_GPIO_IRQENABLE2);
+				bank->base + bank->regs->irqenable2);
 	__raw_writel(bank->context.wake_en,
-			bank->base + OMAP24XX_GPIO_WAKE_EN);
-	__raw_writel(bank->context.ctrl, bank->base + OMAP24XX_GPIO_CTRL);
-	__raw_writel(bank->context.oe, bank->base + OMAP24XX_GPIO_OE);
+				bank->base + bank->regs->wkup_en);
+	__raw_writel(bank->context.ctrl, bank->base + bank->regs->ctrl);
+	__raw_writel(bank->context.oe, bank->base + bank->regs->direction);
 	__raw_writel(bank->context.leveldetect0,
-			bank->base + OMAP24XX_GPIO_LEVELDETECT0);
+				bank->base + bank->regs->leveldetect0);
 	__raw_writel(bank->context.leveldetect1,
-			bank->base + OMAP24XX_GPIO_LEVELDETECT1);
+				bank->base + bank->regs->leveldetect1);
 	__raw_writel(bank->context.risingdetect,
-			bank->base + OMAP24XX_GPIO_RISINGDETECT);
+				bank->base + bank->regs->risingdetect);
 	__raw_writel(bank->context.fallingdetect,
-			bank->base + OMAP24XX_GPIO_FALLINGDETECT);
-	__raw_writel(bank->context.dataout,
-			bank->base + OMAP24XX_GPIO_DATAOUT);
+				bank->base + bank->regs->fallingdetect);
+	__raw_writel(bank->context.dataout, bank->base + bank->regs->dataout);
 }
 #endif
 
-- 
1.7.0.4

