Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757758Ab2IGVWO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 17:22:14 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:42872 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756662Ab2IGVWM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 17:22:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bjorn Helgaas <bhelgaas@google.com>
Subject: [Resend][PATCH] pciehp: always implement resume
Date: Fri, 7 Sep 2012 23:28:30 +0200
User-Agent: KMail/1.13.6 (Linux/3.6.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Oliver Neukum <oliver@neukum.org>, linux-pci@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201209072328.30553.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oliver Neukum <oliver@neukum.org>
Subject: pciehp: always implement resume

The driver by default ignores resume. On some laptops
that means that interrupts are not delivered after S3.
So card removals and insertions will not be handled. Requiring
a forced load isn't right.

Signed-off-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
drivers/pci/hotplug/pciehp_core.c |   28 ++++++++++++++--------------
 drivers/pci/hotplug/pciehp_core.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

Index: linux/drivers/pci/hotplug/pciehp_core.c
===================================================================
--- linux.orig/drivers/pci/hotplug/pciehp_core.c
+++ linux/drivers/pci/hotplug/pciehp_core.c
@@ -300,24 +300,24 @@ static int pciehp_suspend (struct pcie_d
 
 static int pciehp_resume (struct pcie_device *dev)
 {
+	struct controller *ctrl;
+	struct slot *slot;
+	u8 status;
+
 	dev_info(&dev->device, "%s ENTRY\n", __func__);
-	if (pciehp_force) {
-		struct controller *ctrl = get_service_data(dev);
-		struct slot *slot;
-		u8 status;
+	ctrl = get_service_data(dev);
 
-		/* reinitialize the chipset's event detection logic */
-		pcie_enable_notification(ctrl);
+	/* reinitialize the chipset's event detection logic */
+	pcie_enable_notification(ctrl);
 
-		slot = ctrl->slot;
+	slot = ctrl->slot;
 
-		/* Check if slot is occupied */
-		pciehp_get_adapter_status(slot, &status);
-		if (status)
-			pciehp_enable_slot(slot);
-		else
-			pciehp_disable_slot(slot);
-	}
+	/* Check if slot is occupied */
+	pciehp_get_adapter_status(slot, &status);
+	if (status)
+		pciehp_enable_slot(slot);
+	else
+		pciehp_disable_slot(slot);
 	return 0;
 }
 #endif /* PM */
