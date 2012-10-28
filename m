Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152Ab2J1IJo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 04:09:44 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:60891 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756012Ab2J1IJc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 04:09:32 -0400
From: Joe Perches <joe@perches.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 11/16] pci: Convert dev_printk(KERN_<LEVEL> to dev_<level>(
Date: Sun, 28 Oct 2012 01:05:49 -0700
Message-Id: <58d59961e0f3287afeda402e123e5d760471b0d9.1351411048.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.112.g3fd21
In-Reply-To: <cover.1351411047.git.joe@perches.com>
References: <cover.1351411047.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dev_<level> calls take less code than dev_printk(KERN_<LEVEL>
and reducing object size is good.
Coalesce formats for easier grep.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/pci/irq.c       |   10 +++++-----
 drivers/pci/pci-stub.c  |    2 +-
 drivers/pci/pcie/aspm.c |    7 ++-----
 3 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/pci/irq.c b/drivers/pci/irq.c
index e5f69a4..b008cf8 100644
--- a/drivers/pci/irq.c
+++ b/drivers/pci/irq.c
@@ -14,11 +14,11 @@ static void pci_note_irq_problem(struct pci_dev *pdev, const char *reason)
 {
 	struct pci_dev *parent = to_pci_dev(pdev->dev.parent);
 
-	dev_printk(KERN_ERR, &pdev->dev,
-		   "Potentially misrouted IRQ (Bridge %s %04x:%04x)\n",
-		   dev_name(&parent->dev), parent->vendor, parent->device);
-	dev_printk(KERN_ERR, &pdev->dev, "%s\n", reason);
-	dev_printk(KERN_ERR, &pdev->dev, "Please report to linux-kernel@vger.kernel.org\n");
+	dev_err(&pdev->dev,
+		"Potentially misrouted IRQ (Bridge %s %04x:%04x)\n",
+		dev_name(&parent->dev), parent->vendor, parent->device);
+	dev_err(&pdev->dev, "%s\n", reason);
+	dev_err(&pdev->dev, "Please report to linux-kernel@vger.kernel.org\n");
 	WARN_ON(1);
 }
 
diff --git a/drivers/pci/pci-stub.c b/drivers/pci/pci-stub.c
index 775e933..6e47c51 100644
--- a/drivers/pci/pci-stub.c
+++ b/drivers/pci/pci-stub.c
@@ -28,7 +28,7 @@ MODULE_PARM_DESC(ids, "Initial PCI IDs to add to the stub driver, format is "
 
 static int pci_stub_probe(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	dev_printk(KERN_INFO, &dev->dev, "claimed by stub\n");
+	dev_info(&dev->dev, "claimed by stub\n");
 	return 0;
 }
 
diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
index 213753b..3da9ecc 100644
--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -242,8 +242,7 @@ static void pcie_aspm_configure_common_clock(struct pcie_link_state *link)
 		return;
 
 	/* Training failed. Restore common clock configurations */
-	dev_printk(KERN_ERR, &parent->dev,
-		   "ASPM: Could not configure common clock\n");
+	dev_err(&parent->dev, "ASPM: Could not configure common clock\n");
 	list_for_each_entry(child, &linkbus->devices, bus_list)
 		pcie_capability_write_word(child, PCI_EXP_LNKCTL,
 					   child_reg[PCI_FUNC(child->devfn)]);
@@ -507,9 +506,7 @@ static int pcie_aspm_sanity_check(struct pci_dev *pdev)
 		 */
 		pcie_capability_read_dword(child, PCI_EXP_DEVCAP, &reg32);
 		if (!(reg32 & PCI_EXP_DEVCAP_RBER) && !aspm_force) {
-			dev_printk(KERN_INFO, &child->dev, "disabling ASPM"
-				" on pre-1.1 PCIe device.  You can enable it"
-				" with 'pcie_aspm=force'\n");
+			dev_info(&child->dev, "disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'\n");
 			return -EINVAL;
 		}
 	}
-- 
1.7.8.112.g3fd21

