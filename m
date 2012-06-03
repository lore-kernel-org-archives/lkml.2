Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203Ab2FCSZo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 14:25:44 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:59721 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754081Ab2FCSZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 14:25:42 -0400
From: Roland Stigge <stigge@antcom.de>
To: stern@rowland.harvard.edu, gregkh@linuxfoundation.org,
        grant.likely@secretlab.ca, rob.herring@calxeda.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH] ohci-nxp: Use ohci_finish_controller_resume()
Date: Sun,  3 Jun 2012 20:24:52 +0200
Message-Id: <1338747893-29338-1-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OHCI drivers are supposed to use ohci_finish_controller_resume(). This patch
adds respective suspend and resume code to ohci-nxp. The following compiler
warning is fixed this way:

drivers/usb/host/ohci-hub.c:321: warning: 'ohci_finish_controller_resume'
defined but not used

Signed-off-by: Roland Stigge <stigge@antcom.de>

---
Applies to v3.5-rc1

 drivers/usb/host/ohci-nxp.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

--- linux-2.6.orig/drivers/usb/host/ohci-nxp.c
+++ linux-2.6/drivers/usb/host/ohci-nxp.c
@@ -432,6 +432,23 @@ static int usb_hcd_nxp_remove(struct pla
 	return 0;
 }
 
+#ifdef CONFIG_PM
+static int usb_hcd_suspend(struct platform_device *pdev, pm_message_t message)
+{
+	clk_disable(usb_clk);
+	return 0;
+}
+
+static int usb_hcd_resume(struct platform_device *pdev)
+{
+	struct usb_hcd *hcd = platform_get_drvdata(pdev);
+
+	clk_enable(usb_clk);
+	ohci_finish_controller_resume(hcd);
+	return 0;
+}
+#endif
+
 /* work with hotplug and coldplug */
 MODULE_ALIAS("platform:usb-ohci");
 
@@ -451,5 +468,9 @@ static struct platform_driver usb_hcd_nx
 	},
 	.probe = usb_hcd_nxp_probe,
 	.remove = usb_hcd_nxp_remove,
+#ifdef CONFIG_PM
+	.suspend = usb_hcd_suspend,
+	.resume = usb_hcd_resume,
+#endif
 };
 
