Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757723Ab1GAS5t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 14:57:49 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:52304 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757626Ab1GAS5O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 14:57:14 -0400
From: Keshava Munegowda <keshava_mgowda@ti.com>
To: <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Keshava Munegowda <keshava_mgowda@ti.com>, <balbi@ti.com>,
        <gadiyar@ti.com>, <sameo@linux.intel.com>, <parthab@india.ti.com>,
        <tony@atomide.com>, <khilman@ti.com>, <b-cousson@ti.com>,
        <paul@pwsan.com>, <johnstul@us.ibm.com>, <vishwanath.bs@ti.com>,
        Keshava Munegowda <Keshava_mgowda@ti.com>
Subject: [PATCH 6/6 v2] arm: omap: usb: global Suspend and resume support of ehci and ohci
Date: Sat, 2 Jul 2011 00:24:34 +0530
Message-ID: <1309546474-15363-7-git-send-email-keshava_mgowda@ti.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1309546474-15363-6-git-send-email-keshava_mgowda@ti.com>
References: <1309546474-15363-1-git-send-email-keshava_mgowda@ti.com>
 <1309546474-15363-2-git-send-email-keshava_mgowda@ti.com>
 <1309546474-15363-3-git-send-email-keshava_mgowda@ti.com>
 <1309546474-15363-4-git-send-email-keshava_mgowda@ti.com>
 <1309546474-15363-5-git-send-email-keshava_mgowda@ti.com>
 <1309546474-15363-6-git-send-email-keshava_mgowda@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Keshava Munegowda <Keshava_mgowda@ti.com>

The global suspend and resume functions for ehci and ohci
drivers are implemented; these functions does the
pm_runtime_get_sync and pm_runtime_put_sync of the
parent device usbhs core driver respectively.

Signed-off-by: Keshava Munegowda <keshava_mgowda@ti.com>
---
 drivers/usb/host/ehci-omap.c  |   22 ++++++++++++++++++++--
 drivers/usb/host/ohci-omap3.c |   21 +++++++++++++++++++++
 2 files changed, 41 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/ehci-omap.c b/drivers/usb/host/ehci-omap.c
index 178f63e..a02a684 100644
--- a/drivers/usb/host/ehci-omap.c
+++ b/drivers/usb/host/ehci-omap.c
@@ -259,14 +259,32 @@ static void ehci_hcd_omap_shutdown(struct platform_device *pdev)
 		hcd->driver->shutdown(hcd);
 }
 
+static int omap_ehci_resume(struct device *dev)
+{
+	if (dev->parent)
+		pm_runtime_get_sync(dev->parent);
+	return 0;
+}
+
+static int omap_ehci_suspend(struct device *dev)
+{
+	if (dev->parent)
+		pm_runtime_put_sync(dev->parent);
+	return 0;
+}
+
+static const struct dev_pm_ops omap_ehci_dev_pm_ops = {
+	.suspend	= omap_ehci_suspend,
+	.resume		= omap_ehci_resume,
+};
+
 static struct platform_driver ehci_hcd_omap_driver = {
 	.probe			= ehci_hcd_omap_probe,
 	.remove			= ehci_hcd_omap_remove,
 	.shutdown		= ehci_hcd_omap_shutdown,
-	/*.suspend		= ehci_hcd_omap_suspend, */
-	/*.resume		= ehci_hcd_omap_resume, */
 	.driver = {
 		.name		= "ehci-omap",
+		.pm		= &omap_ehci_dev_pm_ops,
 	}
 };
 
diff --git a/drivers/usb/host/ohci-omap3.c b/drivers/usb/host/ohci-omap3.c
index 6ce50de..a1a7981 100644
--- a/drivers/usb/host/ohci-omap3.c
+++ b/drivers/usb/host/ohci-omap3.c
@@ -230,12 +230,33 @@ static void ohci_hcd_omap3_shutdown(struct platform_device *pdev)
 		hcd->driver->shutdown(hcd);
 }
 
+
+static int omap_ohci_resume(struct device *dev)
+{
+	if (dev->parent)
+		pm_runtime_get_sync(dev->parent);
+	return 0;
+}
+
+static int omap_ohci_suspend(struct device *dev)
+{
+	if (dev->parent)
+		pm_runtime_put_sync(dev->parent);
+	return 0;
+}
+
+static const struct dev_pm_ops omap_ohci_dev_pm_ops = {
+	.suspend	= omap_ohci_suspend,
+	.resume		= omap_ohci_resume,
+};
+
 static struct platform_driver ohci_hcd_omap3_driver = {
 	.probe		= ohci_hcd_omap3_probe,
 	.remove		= __devexit_p(ohci_hcd_omap3_remove),
 	.shutdown	= ohci_hcd_omap3_shutdown,
 	.driver		= {
 		.name	= "ohci-omap3",
+		.pm		= &omap_ohci_dev_pm_ops,
 	},
 };
 
-- 
1.6.0.4

