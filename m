Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454Ab2JAK0q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 06:26:46 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:35803 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753185Ab2JAKZb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 06:25:31 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <balbi@ti.com>, <gregkh@linuxfoundation.org>, <kishon@ti.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: [PATCH v2 1/7] usb: dwc3-omap: use device_for_each_child to handle child removal
Date: Mon, 1 Oct 2012 15:55:01 +0530
Message-ID: <1349087107-18229-2-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349087107-18229-1-git-send-email-kishon@ti.com>
References: <1349087107-18229-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Used device_for_each_child() to handle child device (dwc3 core) removal
during devexit of dwc3 omap.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/usb/dwc3/dwc3-omap.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/dwc3/dwc3-omap.c b/drivers/usb/dwc3/dwc3-omap.c
index 479dc04..e335da3 100644
--- a/drivers/usb/dwc3/dwc3-omap.c
+++ b/drivers/usb/dwc3/dwc3-omap.c
@@ -204,6 +204,15 @@ static irqreturn_t dwc3_omap_interrupt(int irq, void *_omap)
 	return IRQ_HANDLED;
 }
 
+static int dwc3_omap_remove_core(struct device *dev, void *c)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+
+	platform_device_unregister(pdev);
+
+	return 0;
+}
+
 static int __devinit dwc3_omap_probe(struct platform_device *pdev)
 {
 	struct dwc3_omap_data	*pdata = pdev->dev.platform_data;
@@ -370,9 +379,8 @@ static int __devexit dwc3_omap_remove(struct platform_device *pdev)
 {
 	struct dwc3_omap	*omap = platform_get_drvdata(pdev);
 
-	platform_device_unregister(omap->dwc3);
-
 	dwc3_put_device_id(omap->dwc3->id);
+	device_for_each_child(&pdev->dev, NULL, dwc3_omap_remove_core);
 
 	return 0;
 }
-- 
1.7.9.5

