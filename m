Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933472Ab2JDQ7i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 12:59:38 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:53682 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932821Ab2JDQ7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 12:59:36 -0400
From: Philippe De Swert <philippedeswert@gmail.com>
To: Philippe De Swert <philippe.deswert@jollamobile.com>
Cc: Praveena Nadahally <praveen.nadahally@stericsson.com>,
        Tony lindgren <tony@atomide.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: [PATCH 1/1] musb : remove generic_interrupt and have all drivers define the isr on their own. Remove some unneeded CONFIG_SOC_OMAP_3430 instances
Date: Thu,  4 Oct 2012 19:59:12 +0300
Message-Id: <1349369952-7036-1-git-send-email-philippe.deswert@jollamobile.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is based on the discussion of a previous patch to fix an issue
where the omap2430 musb driver is not working for N9/N950.

Moving all the interrupt handling to the devices. Avoids inclusion of generic
interrupt and breakage due to sometimes misleading CONFIG options. This makes 
sure usb always works if on of the subdrivers is chosen. Tested on Nokia N9/N950. 

Partially clean up CONFIG_SOC_OMAP3430 which is not necessary in the cases
where I removed it. Also helps with the removal work of those options that 
Tony Lindgren predicted would happen at some point.

Signed-off-by: Philippe De Swert <philippe.deswert@jollamobile.com>
---
 drivers/usb/musb/musb_core.c |   31 ++-----------------------------
 drivers/usb/musb/musbhsdma.h |    4 ----
 drivers/usb/musb/omap2430.c  |   22 ++++++++++++++++++++++
 drivers/usb/musb/ux500.c     |   22 ++++++++++++++++++++++
 4 files changed, 46 insertions(+), 33 deletions(-)

diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
index 26f1bef..37c770e 100644
--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -1498,33 +1498,6 @@ static int __devinit musb_core_init(u16 musb_type, struct musb *musb)
 
 /*-------------------------------------------------------------------------*/
 
-#if defined(CONFIG_SOC_OMAP2430) || defined(CONFIG_SOC_OMAP3430) || \
-	defined(CONFIG_ARCH_OMAP4) || defined(CONFIG_ARCH_U8500)
-
-static irqreturn_t generic_interrupt(int irq, void *__hci)
-{
-	unsigned long	flags;
-	irqreturn_t	retval = IRQ_NONE;
-	struct musb	*musb = __hci;
-
-	spin_lock_irqsave(&musb->lock, flags);
-
-	musb->int_usb = musb_readb(musb->mregs, MUSB_INTRUSB);
-	musb->int_tx = musb_readw(musb->mregs, MUSB_INTRTX);
-	musb->int_rx = musb_readw(musb->mregs, MUSB_INTRRX);
-
-	if (musb->int_usb || musb->int_tx || musb->int_rx)
-		retval = musb_interrupt(musb);
-
-	spin_unlock_irqrestore(&musb->lock, flags);
-
-	return retval;
-}
-
-#else
-#define generic_interrupt	NULL
-#endif
-
 /*
  * handle all the irqs defined by the HDRC core. for now we expect:  other
  * irq sources (phy, dma, etc) will be handled first, musb->int_* values
@@ -1907,7 +1880,8 @@ musb_init_controller(struct device *dev, int nIrq, void __iomem *ctrl)
 	musb->ops = plat->platform_ops;
 
 	/* The musb_platform_init() call:
-	 *   - adjusts musb->mregs and musb->isr if needed,
+	 *   - adjusts musb->mregs
+	 *   - sets the musb->isr
 	 *   - may initialize an integrated tranceiver
 	 *   - initializes musb->xceiv, usually by otg_get_phy()
 	 *   - stops powering VBUS
@@ -1917,7 +1891,6 @@ musb_init_controller(struct device *dev, int nIrq, void __iomem *ctrl)
 	 * external/discrete ones in various flavors (twl4030 family,
 	 * isp1504, non-OTG, etc) mostly hooking up through ULPI.
 	 */
-	musb->isr = generic_interrupt;
 	status = musb_platform_init(musb);
 	if (status < 0)
 		goto fail1;
diff --git a/drivers/usb/musb/musbhsdma.h b/drivers/usb/musb/musbhsdma.h
index 320fd4a..f7b13fd2 100644
--- a/drivers/usb/musb/musbhsdma.h
+++ b/drivers/usb/musb/musbhsdma.h
@@ -31,10 +31,6 @@
  *
  */
 
-#if defined(CONFIG_SOC_OMAP2430) || defined(CONFIG_SOC_OMAP3430)
-#include "omap2430.h"
-#endif
-
 #ifndef CONFIG_BLACKFIN
 
 #define MUSB_HSDMA_BASE		0x200
diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
index 5fdb9da..c63aea8 100644
--- a/drivers/usb/musb/omap2430.c
+++ b/drivers/usb/musb/omap2430.c
@@ -306,6 +306,26 @@ static void omap_musb_mailbox_work(struct work_struct *mailbox_work)
 	omap_musb_set_mailbox(glue);
 }
 
+static irqreturn_t omap2430_musb_interrupt(int irq, void *__hci)
+{
+	unsigned long   flags;
+	irqreturn_t     retval = IRQ_NONE;
+	struct musb     *musb = __hci;
+
+	spin_lock_irqsave(&musb->lock, flags);
+
+	musb->int_usb = musb_readb(musb->mregs, MUSB_INTRUSB);
+	musb->int_tx = musb_readw(musb->mregs, MUSB_INTRTX);
+	musb->int_rx = musb_readw(musb->mregs, MUSB_INTRRX);
+
+	if (musb->int_usb || musb->int_tx || musb->int_rx)
+		retval = musb_interrupt(musb);
+
+	spin_unlock_irqrestore(&musb->lock, flags);
+
+	return retval;
+}
+
 static int omap2430_musb_init(struct musb *musb)
 {
 	u32 l;
@@ -325,6 +345,8 @@ static int omap2430_musb_init(struct musb *musb)
 		return -ENODEV;
 	}
 
+	musb->isr = omap2430_musb_interrupt;
+
 	status = pm_runtime_get_sync(dev);
 	if (status < 0) {
 		dev_err(dev, "pm_runtime_get_sync FAILED %d\n", status);
diff --git a/drivers/usb/musb/ux500.c b/drivers/usb/musb/ux500.c
index a8c0fad..bce5574 100644
--- a/drivers/usb/musb/ux500.c
+++ b/drivers/usb/musb/ux500.c
@@ -36,6 +36,26 @@ struct ux500_glue {
 };
 #define glue_to_musb(g)	platform_get_drvdata(g->musb)
 
+static irqreturn_t ux500_musb_interrupt(int irq, void *__hci)
+{
+	unsigned long   flags;
+	irqreturn_t     retval = IRQ_NONE;
+	struct musb     *musb = __hci;
+
+	spin_lock_irqsave(&musb->lock, flags);
+
+	musb->int_usb = musb_readb(musb->mregs, MUSB_INTRUSB);
+	musb->int_tx = musb_readw(musb->mregs, MUSB_INTRTX);
+	musb->int_rx = musb_readw(musb->mregs, MUSB_INTRRX);
+
+	if (musb->int_usb || musb->int_tx || musb->int_rx)
+		retval = musb_interrupt(musb);
+
+	spin_unlock_irqrestore(&musb->lock, flags);
+
+	return retval;
+}
+
 static int ux500_musb_init(struct musb *musb)
 {
 	musb->xceiv = usb_get_phy(USB_PHY_TYPE_USB2);
@@ -44,6 +64,8 @@ static int ux500_musb_init(struct musb *musb)
 		return -ENODEV;
 	}
 
+	musb->isr = ux500_musb_interrupt;
+
 	return 0;
 }
 
-- 
1.7.9.5

