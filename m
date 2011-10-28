Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678Ab1J1Mhr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 08:37:47 -0400
Received: from mga03.intel.com ([143.182.124.21]:24307 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932661Ab1J1MgB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 08:36:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,418,1315206000"; 
   d="scan'208";a="68013645"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Felipe Balbi <balbi@ti.com>, Greg KH <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCHv6 14/19] arm: imx: Start using struct usb_otg
Date: Fri, 28 Oct 2011 15:35:20 +0300
Message-Id: <1319805325-24689-15-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1319805325-24689-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1319805325-24689-1-git-send-email-heikki.krogerus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use struct usb_otg members with OTG specific functions instead
of usb_phy members.

Includes fixes from Sascha Hauer.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Acked-by: Igor Grinberg <grinberg@compulab.co.il>
Tested-by: Philippe Rétornaz <philippe.retornaz@epfl.ch>
Tested-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 arch/arm/mach-imx/mx31moboard-devboard.c |   22 ++++++++++++++--------
 arch/arm/mach-imx/mx31moboard-marxbot.c  |   22 ++++++++++++++--------
 2 files changed, 28 insertions(+), 16 deletions(-)

diff --git a/arch/arm/mach-imx/mx31moboard-devboard.c b/arch/arm/mach-imx/mx31moboard-devboard.c
index 9cd4a97..cc285e5 100644
--- a/arch/arm/mach-imx/mx31moboard-devboard.c
+++ b/arch/arm/mach-imx/mx31moboard-devboard.c
@@ -177,7 +177,7 @@ static int devboard_isp1105_init(struct usb_phy *otg)
 }
 
 
-static int devboard_isp1105_set_vbus(struct usb_phy *otg, bool on)
+static int devboard_isp1105_set_vbus(struct usb_otg *otg, bool on)
 {
 	if (on)
 		gpio_set_value(USBH1_VBUSEN_B, 0);
@@ -194,18 +194,24 @@ static struct mxc_usbh_platform_data usbh1_pdata __initdata = {
 
 static int __init devboard_usbh1_init(void)
 {
-	struct usb_phy *otg;
+	struct usb_phy *phy;
 	struct platform_device *pdev;
 
-	otg = kzalloc(sizeof(*otg), GFP_KERNEL);
-	if (!otg)
+	phy = kzalloc(sizeof(*phy), GFP_KERNEL);
+	if (!phy)
 		return -ENOMEM;
 
-	otg->label	= "ISP1105";
-	otg->init	= devboard_isp1105_init;
-	otg->set_vbus	= devboard_isp1105_set_vbus;
+	phy->otg = kzalloc(sizeof(struct usb_otg), GFP_KERNEL);
+	if (!phy->otg) {
+		kfree(phy);
+		return -ENOMEM;
+	}
+
+	phy->label	= "ISP1105";
+	phy->init	= devboard_isp1105_init;
+	phy->otg->set_vbus	= devboard_isp1105_set_vbus;
 
-	usbh1_pdata.otg = otg;
+	usbh1_pdata.otg = phy;
 
 	pdev = imx31_add_mxc_ehci_hs(1, &usbh1_pdata);
 	if (IS_ERR(pdev))
diff --git a/arch/arm/mach-imx/mx31moboard-marxbot.c b/arch/arm/mach-imx/mx31moboard-marxbot.c
index 2be769b..135c90e 100644
--- a/arch/arm/mach-imx/mx31moboard-marxbot.c
+++ b/arch/arm/mach-imx/mx31moboard-marxbot.c
@@ -291,7 +291,7 @@ static int marxbot_isp1105_init(struct usb_phy *otg)
 }
 
 
-static int marxbot_isp1105_set_vbus(struct usb_phy *otg, bool on)
+static int marxbot_isp1105_set_vbus(struct usb_otg *otg, bool on)
 {
 	if (on)
 		gpio_set_value(USBH1_VBUSEN_B, 0);
@@ -308,18 +308,24 @@ static struct mxc_usbh_platform_data usbh1_pdata __initdata = {
 
 static int __init marxbot_usbh1_init(void)
 {
-	struct usb_phy *otg;
+	struct usb_phy *phy;
 	struct platform_device *pdev;
 
-	otg = kzalloc(sizeof(*otg), GFP_KERNEL);
-	if (!otg)
+	phy = kzalloc(sizeof(*phy), GFP_KERNEL);
+	if (!phy)
 		return -ENOMEM;
 
-	otg->label	= "ISP1105";
-	otg->init	= marxbot_isp1105_init;
-	otg->set_vbus	= marxbot_isp1105_set_vbus;
+	phy->otg = kzalloc(sizeof(struct usb_otg), GFP_KERNEL);
+	if (!phy->otg) {
+		kfree(phy);
+		return -ENOMEM;
+	}
+
+	phy->label	= "ISP1105";
+	phy->init	= marxbot_isp1105_init;
+	phy->otg->set_vbus	= marxbot_isp1105_set_vbus;
 
-	usbh1_pdata.otg = otg;
+	usbh1_pdata.otg = phy;
 
 	pdev = imx31_add_mxc_ehci_hs(1, &usbh1_pdata);
 	if (IS_ERR(pdev))
-- 
1.7.4.1

