Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab2ISLbC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 07:31:02 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:34369 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753650Ab2ISLay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 07:30:54 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <linux@arm.linux.org.uk>, <kishon@ti.com>, <balbi@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
CC: Moiz Sonasath <m-sonasath@ti.com>
Subject: [PATCH 2/4] usb: dwc3: Fix gadget pullup in SS mode
Date: Wed, 19 Sep 2012 17:00:27 +0530
Message-ID: <1348054229-27362-3-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348054229-27362-1-git-send-email-kishon@ti.com>
References: <1348054229-27362-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Moiz Sonasath <m-sonasath@ti.com>

For the gadget pullup functionality to work in
SS mode it requires a particular sequence of
toggling the run-stop bit. Here is the required
sequence:

- Set DCTL[31]
- Clear DCTL[31]
- Clear OMAP5430_CONTROL_CORE__PHY_POWER_USB[14]
- Clear DCTL[8:5] = 0x00
- Set DCTL[8:5] = 0x05
- Wait 25 Ms
- Set DCTL[31]
- Set OMAP5430_CONTROL_CORE__PHY_POWER_USB[14]

Tested rigourously the gadget pull-up functionality
in bot HS and SS modes.

Signed-off-by: Moiz Sonasath <m-sonasath@ti.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/usb/dwc3/gadget.c   |   21 +++++++++++++++------
 drivers/usb/phy/omap-usb3.c |   16 ++++++++++++++++
 include/linux/usb/phy.h     |   10 +++++++++-
 3 files changed, 40 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 58fdfad..bcc0102 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -49,6 +49,7 @@
 
 #include <linux/usb/ch9.h>
 #include <linux/usb/gadget.h>
+#include <linux/usb/otg.h>
 
 #include "core.h"
 #include "gadget.h"
@@ -1417,19 +1418,27 @@ static int dwc3_gadget_run_stop(struct dwc3 *dwc, int is_on)
 	reg = dwc3_readl(dwc->regs, DWC3_DCTL);
 	if (is_on) {
 		if (dwc->revision <= DWC3_REVISION_187A) {
-			reg &= ~DWC3_DCTL_TRGTULST_MASK;
-			reg |= DWC3_DCTL_TRGTULST_RX_DET;
+			reg &= ~DWC3_DCTL_ULSTCHNGREQ_MASK;
+			dwc3_writel(dwc->regs, DWC3_DCTL, reg);
+			reg |= DWC3_DCTL_ULSTCHNG_RX_DETECT;
+			dwc3_writel(dwc->regs, DWC3_DCTL, reg);
+			mdelay(25);
+			reg |= DWC3_DCTL_RUN_STOP;
+			dwc3_writel(dwc->regs, DWC3_DCTL, reg);
+			usb_phy_poweron(dwc->usb3_phy);
 		}
 
-		if (dwc->revision >= DWC3_REVISION_194A)
+		if (dwc->revision >= DWC3_REVISION_194A) {
 			reg &= ~DWC3_DCTL_KEEP_CONNECT;
-		reg |= DWC3_DCTL_RUN_STOP;
+			reg |= DWC3_DCTL_RUN_STOP;
+			dwc3_writel(dwc->regs, DWC3_DCTL, reg);
+		}
 	} else {
 		reg &= ~DWC3_DCTL_RUN_STOP;
+		dwc3_writel(dwc->regs, DWC3_DCTL, reg);
+		usb_phy_shutdown(dwc->usb3_phy);
 	}
 
-	dwc3_writel(dwc->regs, DWC3_DCTL, reg);
-
 	do {
 		reg = dwc3_readl(dwc->regs, DWC3_DSTS);
 		if (is_on) {
diff --git a/drivers/usb/phy/omap-usb3.c b/drivers/usb/phy/omap-usb3.c
index 4dc84ca..26402d5 100644
--- a/drivers/usb/phy/omap-usb3.c
+++ b/drivers/usb/phy/omap-usb3.c
@@ -212,6 +212,20 @@ static int omap_usb3_init(struct usb_phy *x)
 	return 0;
 }
 
+static void omap_usb3_poweron(struct usb_phy *x)
+{
+	struct omap_usb *phy = phy_to_omapusb(x);
+
+	omap5_usb_phy_power(phy, 1);
+}
+
+static void omap_usb3_shutdown(struct usb_phy *x)
+{
+	struct omap_usb *phy = phy_to_omapusb(x);
+
+	omap5_usb_phy_power(phy, 0);
+}
+
 static int __devinit omap_usb3_probe(struct platform_device *pdev)
 {
 	struct omap_usb			*phy;
@@ -253,6 +267,8 @@ static int __devinit omap_usb3_probe(struct platform_device *pdev)
 	phy->phy.dev		= phy->dev;
 	phy->phy.label		= "omap-usb3";
 	phy->phy.init		= omap_usb3_init;
+	phy->phy.poweron	= omap_usb3_poweron;
+	phy->phy.shutdown	= omap_usb3_shutdown;
 	phy->phy.set_suspend	= omap_usb3_suspend;
 
 	phy->is_suspended	= 1;
diff --git a/include/linux/usb/phy.h b/include/linux/usb/phy.h
index 06b5bae..aaa8e16 100644
--- a/include/linux/usb/phy.h
+++ b/include/linux/usb/phy.h
@@ -86,8 +86,9 @@ struct usb_phy {
 	/* to support controllers that have multiple transceivers */
 	struct list_head	head;
 
-	/* initialize/shutdown the OTG controller */
+	/* initialize/poweron/shutdown the OTG controller */
 	int	(*init)(struct usb_phy *x);
+	void    (*poweron)(struct usb_phy *x);
 	void	(*shutdown)(struct usb_phy *x);
 
 	/* effective for B devices, ignored for A-peripheral */
@@ -135,6 +136,13 @@ usb_phy_init(struct usb_phy *x)
 }
 
 static inline void
+usb_phy_poweron(struct usb_phy *x)
+{
+	if (x->poweron)
+		x->poweron(x);
+}
+
+static inline void
 usb_phy_shutdown(struct usb_phy *x)
 {
 	if (x->shutdown)
-- 
1.7.9.5

