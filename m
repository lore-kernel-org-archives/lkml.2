Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030219Ab2I1TBx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:01:53 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63006 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030226Ab2I1TBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:01:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Ruchika Kharwar <ruchika@ti.com>, Moiz Sonasath <m-sonasath@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: [ 159/262] usb: dwc3: core: fix incorrect usage of resource pointer
Date: Fri, 28 Sep 2012 11:51:28 -0700
Message-Id: <20120928183016.755859225@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kishon Vijay Abraham I <kishon@ti.com>

commit 066618bc350cc6035c3a0fc559a8ac02f55785a9 upstream.

Populate the resources for xhci afresh instead of directly using the
*struct resource* of core. *resource* structure has parent, sibling,
child pointers which should be filled only by resource API's. By
directly using the *resource* pointer of core in xhci, these parent,
sibling, child pointers are already populated even before
*platform_device_add* causing side effects.

Reported-by: Ruchika Kharwar <ruchika@ti.com>
Tested-by: Moiz Sonasath <m-sonasath@ti.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/dwc3/core.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -429,16 +429,21 @@ static int __devinit dwc3_probe(struct p
 		dev_err(dev, "missing IRQ\n");
 		return -ENODEV;
 	}
-	dwc->xhci_resources[1] = *res;
+	dwc->xhci_resources[1].start = res->start;
+	dwc->xhci_resources[1].end = res->end;
+	dwc->xhci_resources[1].flags = res->flags;
+	dwc->xhci_resources[1].name = res->name;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res) {
 		dev_err(dev, "missing memory resource\n");
 		return -ENODEV;
 	}
-	dwc->xhci_resources[0] = *res;
+	dwc->xhci_resources[0].start = res->start;
 	dwc->xhci_resources[0].end = dwc->xhci_resources[0].start +
 					DWC3_XHCI_REGS_END;
+	dwc->xhci_resources[0].flags = res->flags;
+	dwc->xhci_resources[0].name = res->name;
 
 	 /*
 	  * Request memory region but exclude xHCI regs,


