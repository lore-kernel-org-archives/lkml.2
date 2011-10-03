Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756339Ab1JCOut (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 10:50:49 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:63889 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756292Ab1JCOuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 10:50:39 -0400
From: Jon Mason <mason@myri.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [PATCH 1/3] PCI: enable MPS "performance" setting to properly handle bridge MPS
Date: Mon,  3 Oct 2011 09:50:18 -0500
Message-Id: <1317653420-21404-2-git-send-email-mason@myri.com>
X-Mailer: git-send-email 1.7.6.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rework the "performance" MPS option to configure the device MPS with the
smaller of the device MPSS or the bridge MPS (which is assumed to be
properly configured at this point to the largest allowable MPS based on
its parent bus).

Also, rework the MRRS setting to report an inability to set the MRRS to
a valid setting.

Signed-off-by: Jon Mason <mason@myri.com>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 drivers/pci/probe.c |   55 ++++++++++++++++++++++----------------------------
 1 files changed, 24 insertions(+), 31 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index f3f94a5..a919db2 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1363,31 +1363,25 @@ static int pcie_find_smpss(struct pci_dev *dev, void *data)
 
 static void pcie_write_mps(struct pci_dev *dev, int mps)
 {
-	int rc, dev_mpss;
-
-	dev_mpss = 128 << dev->pcie_mpss;
+	int rc;
 
 	if (pcie_bus_config == PCIE_BUS_PERFORMANCE) {
-		if (dev->bus->self) {
-			dev_dbg(&dev->bus->dev, "Bus MPSS %d\n",
-				128 << dev->bus->self->pcie_mpss);
+		mps = 128 << dev->pcie_mpss;
 
-			/* For "MPS Force Max", the assumption is made that
+		if (dev->pcie_type != PCI_EXP_TYPE_ROOT_PORT && dev->bus->self)
+			/* For "Performance", the assumption is made that
 			 * downstream communication will never be larger than
 			 * the MRRS.  So, the MPS only needs to be configured
 			 * for the upstream communication.  This being the case,
 			 * walk from the top down and set the MPS of the child
 			 * to that of the parent bus.
+			 *
+			 * Configure the device MPS with the smaller of the
+			 * device MPSS or the bridge MPS (which is assumed to be
+			 * properly configured at this point to the largest
+			 * allowable MPS based on its parent bus).
 			 */
-			mps = 128 << dev->bus->self->pcie_mpss;
-			if (mps > dev_mpss)
-				dev_warn(&dev->dev, "MPS configured higher than"
-					 " maximum supported by the device.  If"
-					 " a bus issue occurs, try running with"
-					 " pci=pcie_bus_safe.\n");
-		}
-
-		dev->pcie_mpss = ffs(mps) - 8;
+			mps = min(mps, pcie_get_mps(dev->bus->self));
 	}
 
 	rc = pcie_set_mps(dev, mps);
@@ -1395,25 +1389,22 @@ static void pcie_write_mps(struct pci_dev *dev, int mps)
 		dev_err(&dev->dev, "Failed attempting to set the MPS\n");
 }
 
-static void pcie_write_mrrs(struct pci_dev *dev, int mps)
+static void pcie_write_mrrs(struct pci_dev *dev)
 {
-	int rc, mrrs, dev_mpss;
+	int rc, mrrs;
 
 	/* In the "safe" case, do not configure the MRRS.  There appear to be
 	 * issues with setting MRRS to 0 on a number of devices.
 	 */
-
 	if (pcie_bus_config != PCIE_BUS_PERFORMANCE)
 		return;
 
-	dev_mpss = 128 << dev->pcie_mpss;
-
 	/* For Max performance, the MRRS must be set to the largest supported
 	 * value.  However, it cannot be configured larger than the MPS the
-	 * device or the bus can support.  This assumes that the largest MRRS
-	 * available on the device cannot be smaller than the device MPSS.
+	 * device or the bus can support.  This should already be properly
+	 * configured by a prior call to pcie_write_mps.
 	 */
-	mrrs = min(mps, dev_mpss);
+	mrrs = pcie_get_mps(dev);
 
 	/* MRRS is a R/W register.  Invalid values can be written, but a
 	 * subsequent read will verify if the value is acceptable or not.
@@ -1421,16 +1412,18 @@ static void pcie_write_mrrs(struct pci_dev *dev, int mps)
 	 * shrink the value until it is acceptable to the HW.
  	 */
 	while (mrrs != pcie_get_readrq(dev) && mrrs >= 128) {
-		dev_warn(&dev->dev, "Attempting to modify the PCI-E MRRS value"
-			 " to %d.  If any issues are encountered, please try "
-			 "running with pci=pcie_bus_safe\n", mrrs);
 		rc = pcie_set_readrq(dev, mrrs);
-		if (rc)
-			dev_err(&dev->dev,
-				"Failed attempting to set the MRRS\n");
+		if (!rc)
+			break;
 
+		dev_warn(&dev->dev, "Failed attempting to set the MRRS\n");
 		mrrs /= 2;
 	}
+
+	if (mrrs < 128)
+		dev_err(&dev->dev, "MRRS was unable to be configured with a "
+			"safe value.  If problems are experienced, try running "
+			"with pci=pcie_bus_safe.\n");
 }
 
 static int pcie_bus_configure_set(struct pci_dev *dev, void *data)
@@ -1444,7 +1437,7 @@ static int pcie_bus_configure_set(struct pci_dev *dev, void *data)
 		 pcie_get_mps(dev), 128<<dev->pcie_mpss, pcie_get_readrq(dev));
 
 	pcie_write_mps(dev, mps);
-	pcie_write_mrrs(dev, mps);
+	pcie_write_mrrs(dev);
 
 	dev_dbg(&dev->dev, "Dev MPS %d MPSS %d MRRS %d\n",
 		 pcie_get_mps(dev), 128<<dev->pcie_mpss, pcie_get_readrq(dev));
-- 
1.7.6.2

