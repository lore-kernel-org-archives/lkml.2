Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932878Ab1J1MgI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 08:36:08 -0400
Received: from mga03.intel.com ([143.182.124.21]:24307 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932839Ab1J1MgF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 08:36:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,418,1315206000"; 
   d="scan'208";a="68013661"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Felipe Balbi <balbi@ti.com>, Greg KH <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCHv6 16/19] power_supply: Convert all users to new usb_phy
Date: Fri, 28 Oct 2011 15:35:22 +0300
Message-Id: <1319805325-24689-17-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1319805325-24689-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1319805325-24689-1-git-send-email-heikki.krogerus@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new usb_phy_* functions instead of the old
otg_* ones.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Acked-by: Anton Vorontsov <cbouatmailru@gmail.com>
---
 drivers/power/isp1704_charger.c |  106 +++++++++++++++++++++------------------
 drivers/power/pda_power.c       |    6 +-
 drivers/power/twl4030_charger.c |   18 +++---
 3 files changed, 70 insertions(+), 60 deletions(-)

diff --git a/drivers/power/isp1704_charger.c b/drivers/power/isp1704_charger.c
index 9230bdd..6440b29 100644
--- a/drivers/power/isp1704_charger.c
+++ b/drivers/power/isp1704_charger.c
@@ -56,7 +56,7 @@ static u16 isp170x_id[] = {
 struct isp1704_charger {
 	struct device		*dev;
 	struct power_supply	psy;
-	struct usb_phy		*otg;
+	struct usb_phy		*xceiv;
 	struct notifier_block	nb;
 	struct work_struct	work;
 
@@ -71,6 +71,16 @@ struct isp1704_charger {
 	unsigned		max_power;
 };
 
+static inline int isp1704_read(struct isp1704_charger *isp, u32 reg)
+{
+	return usb_phy_io_read(isp->xceiv, reg);
+}
+
+static inline int isp1704_write(struct isp1704_charger *isp, u32 val, u32 reg)
+{
+	return usb_phy_io_read(isp->xceiv, val, reg);
+}
+
 /*
  * Disable/enable the power from the isp1704 if a function for it
  * has been provided with platform data.
@@ -97,31 +107,31 @@ static inline int isp1704_charger_type(struct isp1704_charger *isp)
 	u8 otg_ctrl;
 	int type = POWER_SUPPLY_TYPE_USB_DCP;
 
-	func_ctrl = otg_io_read(isp->otg, ULPI_FUNC_CTRL);
-	otg_ctrl = otg_io_read(isp->otg, ULPI_OTG_CTRL);
+	func_ctrl = isp1704_read(isp, ULPI_FUNC_CTRL);
+	otg_ctrl = isp1704_read(isp, ULPI_OTG_CTRL);
 
 	/* disable pulldowns */
 	reg = ULPI_OTG_CTRL_DM_PULLDOWN | ULPI_OTG_CTRL_DP_PULLDOWN;
-	otg_io_write(isp->otg, ULPI_CLR(ULPI_OTG_CTRL), reg);
+	isp1704_write(isp, ULPI_CLR(ULPI_OTG_CTRL), reg);
 
 	/* full speed */
-	otg_io_write(isp->otg, ULPI_CLR(ULPI_FUNC_CTRL),
+	isp1704_write(isp, ULPI_CLR(ULPI_FUNC_CTRL),
 			ULPI_FUNC_CTRL_XCVRSEL_MASK);
-	otg_io_write(isp->otg, ULPI_SET(ULPI_FUNC_CTRL),
+	isp1704_write(isp, ULPI_SET(ULPI_FUNC_CTRL),
 			ULPI_FUNC_CTRL_FULL_SPEED);
 
 	/* Enable strong pull-up on DP (1.5K) and reset */
 	reg = ULPI_FUNC_CTRL_TERMSELECT | ULPI_FUNC_CTRL_RESET;
-	otg_io_write(isp->otg, ULPI_SET(ULPI_FUNC_CTRL), reg);
+	isp1704_write(isp, ULPI_SET(ULPI_FUNC_CTRL), reg);
 	usleep_range(1000, 2000);
 
-	reg = otg_io_read(isp->otg, ULPI_DEBUG);
+	reg = isp1704_read(isp, ULPI_DEBUG);
 	if ((reg & 3) != 3)
 		type = POWER_SUPPLY_TYPE_USB_CDP;
 
 	/* recover original state */
-	otg_io_write(isp->otg, ULPI_FUNC_CTRL, func_ctrl);
-	otg_io_write(isp->otg, ULPI_OTG_CTRL, otg_ctrl);
+	isp1704_write(isp, ULPI_FUNC_CTRL, func_ctrl);
+	isp1704_write(isp, ULPI_OTG_CTRL, otg_ctrl);
 
 	return type;
 }
@@ -136,28 +146,28 @@ static inline int isp1704_charger_verify(struct isp1704_charger *isp)
 	u8	r;
 
 	/* Reset the transceiver */
-	r = otg_io_read(isp->otg, ULPI_FUNC_CTRL);
+	r = isp1704_read(isp, ULPI_FUNC_CTRL);
 	r |= ULPI_FUNC_CTRL_RESET;
-	otg_io_write(isp->otg, ULPI_FUNC_CTRL, r);
+	isp1704_write(isp, ULPI_FUNC_CTRL, r);
 	usleep_range(1000, 2000);
 
 	/* Set normal mode */
 	r &= ~(ULPI_FUNC_CTRL_RESET | ULPI_FUNC_CTRL_OPMODE_MASK);
-	otg_io_write(isp->otg, ULPI_FUNC_CTRL, r);
+	isp1704_write(isp, ULPI_FUNC_CTRL, r);
 
 	/* Clear the DP and DM pull-down bits */
 	r = ULPI_OTG_CTRL_DP_PULLDOWN | ULPI_OTG_CTRL_DM_PULLDOWN;
-	otg_io_write(isp->otg, ULPI_CLR(ULPI_OTG_CTRL), r);
+	isp1704_write(isp, ULPI_CLR(ULPI_OTG_CTRL), r);
 
 	/* Enable strong pull-up on DP (1.5K) and reset */
 	r = ULPI_FUNC_CTRL_TERMSELECT | ULPI_FUNC_CTRL_RESET;
-	otg_io_write(isp->otg, ULPI_SET(ULPI_FUNC_CTRL), r);
+	isp1704_write(isp, ULPI_SET(ULPI_FUNC_CTRL), r);
 	usleep_range(1000, 2000);
 
 	/* Read the line state */
-	if (!otg_io_read(isp->otg, ULPI_DEBUG)) {
+	if (!isp1704_read(isp, ULPI_DEBUG)) {
 		/* Disable strong pull-up on DP (1.5K) */
-		otg_io_write(isp->otg, ULPI_CLR(ULPI_FUNC_CTRL),
+		isp1704_write(isp, ULPI_CLR(ULPI_FUNC_CTRL),
 				ULPI_FUNC_CTRL_TERMSELECT);
 		return 1;
 	}
@@ -165,23 +175,23 @@ static inline int isp1704_charger_verify(struct isp1704_charger *isp)
 	/* Is it a charger or PS/2 connection */
 
 	/* Enable weak pull-up resistor on DP */
-	otg_io_write(isp->otg, ULPI_SET(ISP1704_PWR_CTRL),
+	isp1704_write(isp, ULPI_SET(ISP1704_PWR_CTRL),
 			ISP1704_PWR_CTRL_DP_WKPU_EN);
 
 	/* Disable strong pull-up on DP (1.5K) */
-	otg_io_write(isp->otg, ULPI_CLR(ULPI_FUNC_CTRL),
+	isp1704_write(isp, ULPI_CLR(ULPI_FUNC_CTRL),
 			ULPI_FUNC_CTRL_TERMSELECT);
 
 	/* Enable weak pull-down resistor on DM */
-	otg_io_write(isp->otg, ULPI_SET(ULPI_OTG_CTRL),
+	isp1704_write(isp, ULPI_SET(ULPI_OTG_CTRL),
 			ULPI_OTG_CTRL_DM_PULLDOWN);
 
 	/* It's a charger if the line states are clear */
-	if (!(otg_io_read(isp->otg, ULPI_DEBUG)))
+	if (!(isp1704_read(isp, ULPI_DEBUG)))
 		ret = 1;
 
 	/* Disable weak pull-up resistor on DP */
-	otg_io_write(isp->otg, ULPI_CLR(ISP1704_PWR_CTRL),
+	isp1704_write(isp, ULPI_CLR(ISP1704_PWR_CTRL),
 			ISP1704_PWR_CTRL_DP_WKPU_EN);
 
 	return ret;
@@ -193,14 +203,14 @@ static inline int isp1704_charger_detect(struct isp1704_charger *isp)
 	u8		pwr_ctrl;
 	int		ret = 0;
 
-	pwr_ctrl = otg_io_read(isp->otg, ISP1704_PWR_CTRL);
+	pwr_ctrl = isp1704_read(isp, ISP1704_PWR_CTRL);
 
 	/* set SW control bit in PWR_CTRL register */
-	otg_io_write(isp->otg, ISP1704_PWR_CTRL,
+	isp1704_write(isp, ISP1704_PWR_CTRL,
 			ISP1704_PWR_CTRL_SWCTRL);
 
 	/* enable manual charger detection */
-	otg_io_write(isp->otg, ULPI_SET(ISP1704_PWR_CTRL),
+	isp1704_write(isp, ULPI_SET(ISP1704_PWR_CTRL),
 			ISP1704_PWR_CTRL_SWCTRL
 			| ISP1704_PWR_CTRL_DPVSRC_EN);
 	usleep_range(1000, 2000);
@@ -208,7 +218,7 @@ static inline int isp1704_charger_detect(struct isp1704_charger *isp)
 	timeout = jiffies + msecs_to_jiffies(300);
 	do {
 		/* Check if there is a charger */
-		if (otg_io_read(isp->otg, ISP1704_PWR_CTRL)
+		if (isp1704_read(isp, ISP1704_PWR_CTRL)
 				& ISP1704_PWR_CTRL_VDAT_DET) {
 			ret = isp1704_charger_verify(isp);
 			break;
@@ -216,7 +226,7 @@ static inline int isp1704_charger_detect(struct isp1704_charger *isp)
 	} while (!time_after(jiffies, timeout) && isp->online);
 
 	/* recover original state */
-	otg_io_write(isp->otg, ISP1704_PWR_CTRL, pwr_ctrl);
+	isp1704_write(isp, ISP1704_PWR_CTRL, pwr_ctrl);
 
 	return ret;
 }
@@ -264,8 +274,8 @@ static void isp1704_charger_work(struct work_struct *data)
 		case POWER_SUPPLY_TYPE_USB:
 		default:
 			/* enable data pullups */
-			if (isp->otg->gadget)
-				usb_gadget_connect(isp->otg->gadget);
+			if (isp->xceiv->gadget)
+				usb_gadget_connect(isp->xceiv->gadget);
 		}
 		break;
 	case USB_EVENT_NONE:
@@ -283,8 +293,8 @@ static void isp1704_charger_work(struct work_struct *data)
 		 * chargers. The pullups may be enabled elsewhere, so this can
 		 * not be the final solution.
 		 */
-		if (isp->otg->gadget)
-			usb_gadget_disconnect(isp->otg->gadget);
+		if (isp->xceiv->gadget)
+			usb_gadget_disconnect(isp->xceiv->gadget);
 
 		isp1704_charger_set_power(isp, 0);
 		break;
@@ -364,11 +374,11 @@ static inline int isp1704_test_ulpi(struct isp1704_charger *isp)
 	int ret = -ENODEV;
 
 	/* Test ULPI interface */
-	ret = otg_io_write(isp->otg, ULPI_SCRATCH, 0xaa);
+	ret = isp1704_write(isp, ULPI_SCRATCH, 0xaa);
 	if (ret < 0)
 		return ret;
 
-	ret = otg_io_read(isp->otg, ULPI_SCRATCH);
+	ret = isp1704_read(isp, ULPI_SCRATCH);
 	if (ret < 0)
 		return ret;
 
@@ -376,13 +386,13 @@ static inline int isp1704_test_ulpi(struct isp1704_charger *isp)
 		return -ENODEV;
 
 	/* Verify the product and vendor id matches */
-	vendor = otg_io_read(isp->otg, ULPI_VENDOR_ID_LOW);
-	vendor |= otg_io_read(isp->otg, ULPI_VENDOR_ID_HIGH) << 8;
+	vendor = isp1704_read(isp, ULPI_VENDOR_ID_LOW);
+	vendor |= isp1704_read(isp, ULPI_VENDOR_ID_HIGH) << 8;
 	if (vendor != NXP_VENDOR_ID)
 		return -ENODEV;
 
-	product = otg_io_read(isp->otg, ULPI_PRODUCT_ID_LOW);
-	product |= otg_io_read(isp->otg, ULPI_PRODUCT_ID_HIGH) << 8;
+	product = isp1704_read(isp, ULPI_PRODUCT_ID_LOW);
+	product |= isp1704_read(isp, ULPI_PRODUCT_ID_HIGH) << 8;
 
 	for (i = 0; i < ARRAY_SIZE(isp170x_id); i++) {
 		if (product == isp170x_id[i]) {
@@ -405,8 +415,8 @@ static int __devinit isp1704_charger_probe(struct platform_device *pdev)
 	if (!isp)
 		return -ENOMEM;
 
-	isp->otg = otg_get_transceiver();
-	if (!isp->otg)
+	isp->xceiv = usb_get_transceiver();
+	if (!isp->xceiv)
 		goto fail0;
 
 	isp->dev = &pdev->dev;
@@ -429,14 +439,14 @@ static int __devinit isp1704_charger_probe(struct platform_device *pdev)
 		goto fail1;
 
 	/*
-	 * REVISIT: using work in order to allow the otg notifications to be
+	 * REVISIT: using work in order to allow the usb notifications to be
 	 * made atomically in the future.
 	 */
 	INIT_WORK(&isp->work, isp1704_charger_work);
 
 	isp->nb.notifier_call = isp1704_notifier_call;
 
-	ret = otg_register_notifier(isp->otg, &isp->nb);
+	ret = usb_register_notifier(isp->xceiv, &isp->nb);
 	if (ret)
 		goto fail2;
 
@@ -449,13 +459,13 @@ static int __devinit isp1704_charger_probe(struct platform_device *pdev)
 	 * enumerated. The charger driver should be always loaded before any
 	 * gadget is loaded.
 	 */
-	if (isp->otg->gadget)
-		usb_gadget_disconnect(isp->otg->gadget);
+	if (isp->xceiv->gadget)
+		usb_gadget_disconnect(isp->xceiv->gadget);
 
 	/* Detect charger if VBUS is valid (the cable was already plugged). */
-	ret = otg_io_read(isp->otg, ULPI_USB_INT_STS);
+	ret = isp1704_read(isp, ULPI_USB_INT_STS);
 	isp1704_charger_set_power(isp, 0);
-	if ((ret & ULPI_INT_VBUS_VALID) && !isp->otg->default_a) {
+	if ((ret & ULPI_INT_VBUS_VALID) && !isp->xceiv->otg->default_a) {
 		isp->event = USB_EVENT_VBUS;
 		schedule_work(&isp->work);
 	}
@@ -464,7 +474,7 @@ static int __devinit isp1704_charger_probe(struct platform_device *pdev)
 fail2:
 	power_supply_unregister(&isp->psy);
 fail1:
-	otg_put_transceiver(isp->otg);
+	usb_put_transceiver(isp->xceiv);
 fail0:
 	kfree(isp);
 
@@ -477,9 +487,9 @@ static int __devexit isp1704_charger_remove(struct platform_device *pdev)
 {
 	struct isp1704_charger *isp = platform_get_drvdata(pdev);
 
-	otg_unregister_notifier(isp->otg, &isp->nb);
+	usb_unregister_notifier(isp->xceiv, &isp->nb);
 	power_supply_unregister(&isp->psy);
-	otg_put_transceiver(isp->otg);
+	usb_put_transceiver(isp->xceiv);
 	isp1704_charger_set_power(isp, 0);
 	kfree(isp);
 
diff --git a/drivers/power/pda_power.c b/drivers/power/pda_power.c
index 60433b7..69e3a86 100644
--- a/drivers/power/pda_power.c
+++ b/drivers/power/pda_power.c
@@ -304,7 +304,7 @@ static int pda_power_probe(struct platform_device *pdev)
 	}
 
 #ifdef CONFIG_USB_OTG_UTILS
-	transceiver = otg_get_transceiver();
+	transceiver = usb_get_transceiver();
 	if (transceiver && !pdata->is_usb_online) {
 		pdata->is_usb_online = otg_is_usb_online;
 	}
@@ -351,7 +351,7 @@ usb_supply_failed:
 		free_irq(ac_irq->start, &pda_psy_ac);
 #ifdef CONFIG_USB_OTG_UTILS
 	if (transceiver)
-		otg_put_transceiver(transceiver);
+		usb_put_transceiver(transceiver);
 #endif
 ac_irq_failed:
 	if (pdata->is_ac_online)
@@ -386,7 +386,7 @@ static int pda_power_remove(struct platform_device *pdev)
 		power_supply_unregister(&pda_psy_ac);
 #ifdef CONFIG_USB_OTG_UTILS
 	if (transceiver)
-		otg_put_transceiver(transceiver);
+		usb_put_transceiver(transceiver);
 #endif
 	if (ac_draw) {
 		regulator_put(ac_draw);
diff --git a/drivers/power/twl4030_charger.c b/drivers/power/twl4030_charger.c
index b3ead23..fdad850 100644
--- a/drivers/power/twl4030_charger.c
+++ b/drivers/power/twl4030_charger.c
@@ -70,7 +70,7 @@ struct twl4030_bci {
 	struct power_supply	ac;
 	struct power_supply	usb;
 	struct usb_phy		*transceiver;
-	struct notifier_block	otg_nb;
+	struct notifier_block	usb_nb;
 	struct work_struct	work;
 	int			irq_chg;
 	int			irq_bci;
@@ -279,7 +279,7 @@ static void twl4030_bci_usb_work(struct work_struct *data)
 static int twl4030_bci_usb_ncb(struct notifier_block *nb, unsigned long val,
 			       void *priv)
 {
-	struct twl4030_bci *bci = container_of(nb, struct twl4030_bci, otg_nb);
+	struct twl4030_bci *bci = container_of(nb, struct twl4030_bci, usb_nb);
 
 	dev_dbg(bci->dev, "OTG notify %lu\n", val);
 
@@ -479,10 +479,10 @@ static int __init twl4030_bci_probe(struct platform_device *pdev)
 
 	INIT_WORK(&bci->work, twl4030_bci_usb_work);
 
-	bci->transceiver = otg_get_transceiver();
+	bci->transceiver = usb_get_transceiver();
 	if (bci->transceiver != NULL) {
-		bci->otg_nb.notifier_call = twl4030_bci_usb_ncb;
-		otg_register_notifier(bci->transceiver, &bci->otg_nb);
+		bci->usb_nb.notifier_call = twl4030_bci_usb_ncb;
+		usb_register_notifier(bci->transceiver, &bci->usb_nb);
 	}
 
 	/* Enable interrupts now. */
@@ -508,8 +508,8 @@ static int __init twl4030_bci_probe(struct platform_device *pdev)
 
 fail_unmask_interrupts:
 	if (bci->transceiver != NULL) {
-		otg_unregister_notifier(bci->transceiver, &bci->otg_nb);
-		otg_put_transceiver(bci->transceiver);
+		usb_unregister_notifier(bci->transceiver, &bci->usb_nb);
+		usb_put_transceiver(bci->transceiver);
 	}
 	free_irq(bci->irq_bci, bci);
 fail_bci_irq:
@@ -539,8 +539,8 @@ static int __exit twl4030_bci_remove(struct platform_device *pdev)
 			 TWL4030_INTERRUPTS_BCIIMR2A);
 
 	if (bci->transceiver != NULL) {
-		otg_unregister_notifier(bci->transceiver, &bci->otg_nb);
-		otg_put_transceiver(bci->transceiver);
+		usb_unregister_notifier(bci->transceiver, &bci->usb_nb);
+		usb_put_transceiver(bci->transceiver);
 	}
 	free_irq(bci->irq_bci, bci);
 	free_irq(bci->irq_chg, bci);
-- 
1.7.4.1

