Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673Ab1J1Mka (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 08:40:30 -0400
Received: from mga03.intel.com ([143.182.124.21]:25039 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932722Ab1J1Mfk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 08:35:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,418,1315206000"; 
   d="scan'208";a="68013551"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Felipe Balbi <balbi@ti.com>, Greg KH <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCHv6 04/19] usb: otg: ab8500: Start using struct usb_otg
Date: Fri, 28 Oct 2011 15:35:10 +0300
Message-Id: <1319805325-24689-5-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1319805325-24689-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1319805325-24689-1-git-send-email-heikki.krogerus@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use struct usb_otg members with OTG specific functions instead
of usb_phy members.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Acked-by: Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>
---
 drivers/usb/otg/ab8500-usb.c |   87 +++++++++++++++++++++++-------------------
 1 files changed, 48 insertions(+), 39 deletions(-)

diff --git a/drivers/usb/otg/ab8500-usb.c b/drivers/usb/otg/ab8500-usb.c
index 366c3af..3d659c3 100644
--- a/drivers/usb/otg/ab8500-usb.c
+++ b/drivers/usb/otg/ab8500-usb.c
@@ -68,7 +68,7 @@ enum ab8500_usb_link_status {
 };
 
 struct ab8500_usb {
-	struct usb_phy otg;
+	struct usb_phy xceiv;
 	struct device *dev;
 	int irq_num_id_rise;
 	int irq_num_id_fall;
@@ -84,7 +84,7 @@ struct ab8500_usb {
 
 static inline struct ab8500_usb *xceiv_to_ab(struct usb_phy *x)
 {
-	return container_of(x, struct ab8500_usb, otg);
+	return container_of(x, struct ab8500_usb, xceiv);
 }
 
 static void ab8500_usb_wd_workaround(struct ab8500_usb *ab)
@@ -169,8 +169,8 @@ static int ab8500_usb_link_status_update(struct ab8500_usb *ab)
 		/* TODO: Disable regulators. */
 		ab8500_usb_host_phy_dis(ab);
 		ab8500_usb_peri_phy_dis(ab);
-		ab->otg.state = USB_PHY_STATE_B_IDLE;
-		ab->otg.default_a = false;
+		ab->xceiv.state = USB_PHY_STATE_B_IDLE;
+		ab->xceiv.otg->default_a = false;
 		ab->vbus_draw = 0;
 		event = USB_EVENT_NONE;
 		break;
@@ -181,22 +181,22 @@ static int ab8500_usb_link_status_update(struct ab8500_usb *ab)
 	case USB_LINK_HOST_CHG_NM:
 	case USB_LINK_HOST_CHG_HS:
 	case USB_LINK_HOST_CHG_HS_CHIRP:
-		if (ab->otg.gadget) {
+		if (ab->xceiv.otg->gadget) {
 			/* TODO: Enable regulators. */
 			ab8500_usb_peri_phy_en(ab);
-			v = ab->otg.gadget;
+			v = ab->xceiv.otg->gadget;
 		}
 		event = USB_EVENT_VBUS;
 		break;
 
 	case USB_LINK_HM_IDGND:
-		if (ab->otg.host) {
+		if (ab->xceiv.otg->host) {
 			/* TODO: Enable regulators. */
 			ab8500_usb_host_phy_en(ab);
-			v = ab->otg.host;
+			v = ab->xceiv.otg->host;
 		}
-		ab->otg.state = USB_PHY_STATE_A_IDLE;
-		ab->otg.default_a = true;
+		ab->xceiv.state = USB_PHY_STATE_A_IDLE;
+		ab->xceiv.otg->default_a = true;
 		event = USB_EVENT_ID;
 		break;
 
@@ -212,7 +212,7 @@ static int ab8500_usb_link_status_update(struct ab8500_usb *ab)
 		break;
 	}
 
-	atomic_notifier_call_chain(&ab->otg.notifier, event, v);
+	atomic_notifier_call_chain(&ab->xceiv.notifier, event, v);
 
 	return 0;
 }
@@ -262,27 +262,27 @@ static void ab8500_usb_phy_disable_work(struct work_struct *work)
 	struct ab8500_usb *ab = container_of(work, struct ab8500_usb,
 						phy_dis_work);
 
-	if (!ab->otg.host)
+	if (!ab->xceiv.otg->host)
 		ab8500_usb_host_phy_dis(ab);
 
-	if (!ab->otg.gadget)
+	if (!ab->xceiv.otg->gadget)
 		ab8500_usb_peri_phy_dis(ab);
 }
 
-static int ab8500_usb_set_power(struct usb_phy *otg, unsigned mA)
+static int ab8500_usb_set_power(struct usb_phy *xceiv, unsigned mA)
 {
 	struct ab8500_usb *ab;
 
-	if (!otg)
+	if (!xceiv)
 		return -ENODEV;
 
-	ab = xceiv_to_ab(otg);
+	ab = xceiv_to_ab(xceiv);
 
 	ab->vbus_draw = mA;
 
 	if (mA)
-		atomic_notifier_call_chain(&ab->otg.notifier,
-				USB_EVENT_ENUMERATED, ab->otg.gadget);
+		atomic_notifier_call_chain(&ab->xceiv.notifier,
+				USB_EVENT_ENUMERATED, ab->xceiv.otg->gadget);
 	return 0;
 }
 
@@ -296,15 +296,15 @@ static int ab8500_usb_set_suspend(struct usb_phy *x, int suspend)
 	return 0;
 }
 
-static int ab8500_usb_set_peripheral(struct usb_phy *otg,
-		struct usb_gadget *gadget)
+static int ab8500_usb_set_peripheral(struct usb_otg *otg,
+					struct usb_gadget *gadget)
 {
 	struct ab8500_usb *ab;
 
 	if (!otg)
 		return -ENODEV;
 
-	ab = xceiv_to_ab(otg);
+	ab = xceiv_to_ab(otg->xceiv);
 
 	/* Some drivers call this function in atomic context.
 	 * Do not update ab8500 registers directly till this
@@ -313,11 +313,11 @@ static int ab8500_usb_set_peripheral(struct usb_phy *otg,
 
 	if (!gadget) {
 		/* TODO: Disable regulators. */
-		ab->otg.gadget = NULL;
+		otg->gadget = NULL;
 		schedule_work(&ab->phy_dis_work);
 	} else {
-		ab->otg.gadget = gadget;
-		ab->otg.state = USB_PHY_STATE_B_IDLE;
+		otg->gadget = gadget;
+		otg->xceiv->state = USB_PHY_STATE_B_IDLE;
 
 		/* Phy will not be enabled if cable is already
 		 * plugged-in. Schedule to enable phy.
@@ -329,15 +329,14 @@ static int ab8500_usb_set_peripheral(struct usb_phy *otg,
 	return 0;
 }
 
-static int ab8500_usb_set_host(struct usb_phy *otg,
-					struct usb_bus *host)
+static int ab8500_usb_set_host(struct usb_otg *otg, struct usb_bus *host)
 {
 	struct ab8500_usb *ab;
 
 	if (!otg)
 		return -ENODEV;
 
-	ab = xceiv_to_ab(otg);
+	ab = xceiv_to_ab(otg->xceiv);
 
 	/* Some drivers call this function in atomic context.
 	 * Do not update ab8500 registers directly till this
@@ -346,10 +345,10 @@ static int ab8500_usb_set_host(struct usb_phy *otg,
 
 	if (!host) {
 		/* TODO: Disable regulators. */
-		ab->otg.host = NULL;
+		otg->host = NULL;
 		schedule_work(&ab->phy_dis_work);
 	} else {
-		ab->otg.host = host;
+		otg->host = host;
 		/* Phy will not be enabled if cable is already
 		 * plugged-in. Schedule to enable phy.
 		 * Use same delay to avoid any race condition.
@@ -488,19 +487,27 @@ static int __devinit ab8500_usb_probe(struct platform_device *pdev)
 	if (!ab)
 		return -ENOMEM;
 
+	ab->xceiv.otg = kzalloc(sizeof *ab->xceiv.otg, GFP_KERNEL);
+	if (!ab->xceiv.otg) {
+		kfree(ab);
+		return -ENOMEM;
+	}
+
 	ab->dev			= &pdev->dev;
 	ab->rev			= rev;
-	ab->otg.dev		= ab->dev;
-	ab->otg.label		= "ab8500";
-	ab->otg.state		= USB_PHY_STATE_UNDEFINED;
-	ab->otg.set_host	= ab8500_usb_set_host;
-	ab->otg.set_peripheral	= ab8500_usb_set_peripheral;
-	ab->otg.set_suspend	= ab8500_usb_set_suspend;
-	ab->otg.set_power	= ab8500_usb_set_power;
+	ab->xceiv.dev		= ab->dev;
+	ab->xceiv.label		= "ab8500";
+	ab->xceiv.set_suspend	= ab8500_usb_set_suspend;
+	ab->xceiv.set_power	= ab8500_usb_set_power;
+	ab->xceiv.state		= USB_PHY_STATE_UNDEFINED;
+
+	ab->xceiv.otg->xceiv		= &ab->xceiv;
+	ab->xceiv.otg->set_host		= ab8500_usb_set_host;
+	ab->xceiv.otg->set_peripheral	= ab8500_usb_set_peripheral;
 
 	platform_set_drvdata(pdev, ab);
 
-	ATOMIC_INIT_NOTIFIER_HEAD(&ab->otg.notifier);
+	ATOMIC_INIT_NOTIFIER_HEAD(&ab->xceiv.notifier);
 
 	/* v1: Wait for link status to become stable.
 	 * all: Updates form set_host and set_peripheral as they are atomic.
@@ -520,7 +527,7 @@ static int __devinit ab8500_usb_probe(struct platform_device *pdev)
 	if (err < 0)
 		goto fail0;
 
-	err = otg_set_transceiver(&ab->otg);
+	err = usb_set_transceiver(&ab->xceiv);
 	if (err) {
 		dev_err(&pdev->dev, "Can't register transceiver\n");
 		goto fail1;
@@ -532,6 +539,7 @@ static int __devinit ab8500_usb_probe(struct platform_device *pdev)
 fail1:
 	ab8500_usb_irq_free(ab);
 fail0:
+	kfree(ab->xceiv.otg);
 	kfree(ab);
 	return err;
 }
@@ -546,13 +554,14 @@ static int __devexit ab8500_usb_remove(struct platform_device *pdev)
 
 	cancel_work_sync(&ab->phy_dis_work);
 
-	otg_set_transceiver(NULL);
+	usb_set_transceiver(NULL);
 
 	ab8500_usb_host_phy_dis(ab);
 	ab8500_usb_peri_phy_dis(ab);
 
 	platform_set_drvdata(pdev, NULL);
 
+	kfree(ab->xceiv.otg);
 	kfree(ab);
 
 	return 0;
-- 
1.7.4.1

