Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421Ab1IGQ7t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:59:49 -0400
Received: from mga02.intel.com ([134.134.136.20]:14777 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754302Ab1IGQ7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:59:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="45953828"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Felipe Balbi <balbi@ti.com>, Greg KH <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Chen <peter.chen@freescale.com>,
        Lin Tony-B19295 <B19295@freescale.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [PATCHv4 10/19] usb: otg: nop: Start using struct usb_otg
Date: Wed,  7 Sep 2011 10:16:03 +0300
Message-Id: <1315379772-8830-11-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315379772-8830-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1315379772-8830-1-git-send-email-heikki.krogerus@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use struct usb_otg members with OTG specific functions instead
of usb_phy members.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 drivers/usb/otg/nop-usb-xceiv.c |   64 ++++++++++++++++++--------------------
 1 files changed, 30 insertions(+), 34 deletions(-)

diff --git a/drivers/usb/otg/nop-usb-xceiv.c b/drivers/usb/otg/nop-usb-xceiv.c
index 6a0c102..37ce4d3 100644
--- a/drivers/usb/otg/nop-usb-xceiv.c
+++ b/drivers/usb/otg/nop-usb-xceiv.c
@@ -33,7 +33,7 @@
 #include <linux/slab.h>
 
 struct nop_usb_xceiv {
-	struct usb_phy		otg;
+	struct usb_phy		xceiv;
 	struct device		*dev;
 };
 
@@ -58,51 +58,37 @@ void usb_nop_xceiv_unregister(void)
 }
 EXPORT_SYMBOL(usb_nop_xceiv_unregister);
 
-static inline struct nop_usb_xceiv *xceiv_to_nop(struct usb_phy *x)
-{
-	return container_of(x, struct nop_usb_xceiv, otg);
-}
-
 static int nop_set_suspend(struct usb_phy *x, int suspend)
 {
 	return 0;
 }
 
-static int nop_set_peripheral(struct usb_phy *x,
-		struct usb_gadget *gadget)
+static int nop_set_peripheral(struct usb_otg *otg, struct usb_gadget *gadget)
 {
-	struct nop_usb_xceiv *nop;
-
-	if (!x)
+	if (!otg)
 		return -ENODEV;
 
-	nop = xceiv_to_nop(x);
-
 	if (!gadget) {
-		nop->otg.gadget = NULL;
+		otg->gadget = NULL;
 		return -ENODEV;
 	}
 
-	nop->otg.gadget = gadget;
-	nop->otg.state = USB_PHY_STATE_B_IDLE;
+	otg->gadget = gadget;
+	otg->xceiv->state = USB_PHY_STATE_B_IDLE;
 	return 0;
 }
 
-static int nop_set_host(struct usb_phy *x, struct usb_bus *host)
+static int nop_set_host(struct usb_otg *otg, struct usb_bus *host)
 {
-	struct nop_usb_xceiv *nop;
-
-	if (!x)
+	if (!otg)
 		return -ENODEV;
 
-	nop = xceiv_to_nop(x);
-
 	if (!host) {
-		nop->otg.host = NULL;
+		otg->host = NULL;
 		return -ENODEV;
 	}
 
-	nop->otg.host = host;
+	otg->host = host;
 	return 0;
 }
 
@@ -115,15 +101,23 @@ static int __devinit nop_usb_xceiv_probe(struct platform_device *pdev)
 	if (!nop)
 		return -ENOMEM;
 
+	nop->xceiv.otg = kzalloc(sizeof *nop->xceiv.otg, GFP_KERNEL);
+	if (!nop->xceiv.otg) {
+		kfree(nop);
+		return -ENOMEM;
+	}
+
 	nop->dev		= &pdev->dev;
-	nop->otg.dev		= nop->dev;
-	nop->otg.label		= "nop-xceiv";
-	nop->otg.state		= USB_PHY_STATE_UNDEFINED;
-	nop->otg.set_host	= nop_set_host;
-	nop->otg.set_peripheral	= nop_set_peripheral;
-	nop->otg.set_suspend	= nop_set_suspend;
-
-	err = otg_set_transceiver(&nop->otg);
+	nop->xceiv.dev		= nop->dev;
+	nop->xceiv.label	= "nop-xceiv";
+	nop->xceiv.set_suspend	= nop_set_suspend;
+	nop->xceiv.state	= USB_PHY_STATE_UNDEFINED;
+
+	nop->xceiv.otg->xceiv		= &nop->xceiv;
+	nop->xceiv.otg->set_host	= nop_set_host;
+	nop->xceiv.otg->set_peripheral	= nop_set_peripheral;
+
+	err = usb_set_transceiver(&nop->xceiv);
 	if (err) {
 		dev_err(&pdev->dev, "can't register transceiver, err: %d\n",
 			err);
@@ -132,10 +126,11 @@ static int __devinit nop_usb_xceiv_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, nop);
 
-	ATOMIC_INIT_NOTIFIER_HEAD(&nop->otg.notifier);
+	ATOMIC_INIT_NOTIFIER_HEAD(&nop->xceiv.notifier);
 
 	return 0;
 exit:
+	kfree(nop->xceiv.otg);
 	kfree(nop);
 	return err;
 }
@@ -144,9 +139,10 @@ static int __devexit nop_usb_xceiv_remove(struct platform_device *pdev)
 {
 	struct nop_usb_xceiv *nop = platform_get_drvdata(pdev);
 
-	otg_set_transceiver(NULL);
+	usb_set_transceiver(NULL);
 
 	platform_set_drvdata(pdev, NULL);
+	kfree(nop->xceiv.otg);
 	kfree(nop);
 
 	return 0;
-- 
1.7.4.1

