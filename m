Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932489Ab1LETvl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 14:51:41 -0500
Received: from mail-yw0-f74.google.com ([209.85.213.74]:35046 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932325Ab1LETvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 14:51:39 -0500
From: Vincent Palatin <vpalatin@chromium.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Olof Johansson <olofj@chromium.org>,
        Sameer Nanda <snanda@chromium.org>, Ming Lei <tom.leiming@gmail.com>,
        linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Vincent Palatin <vpalatin@chromium.org>
Subject: [PATCH] PM / Runtime: make PCI traces quieter
Date: Mon,  5 Dec 2011 11:51:18 -0800
Message-Id: <1323114678-28750-1-git-send-email-vpalatin@chromium.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <20111205111906.7cae2946@jbarnes-desktop>
References: <20111205111906.7cae2946@jbarnes-desktop>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the runtime PM is activated on PCI, if a device switches state frequently
(e.g. an EHCI controller with autosuspending USB devices connected)
the PCI configuration traces might be very verbose in the kernel log.
Let's guard those traces with DEBUG condition.

Signed-off-by: Vincent Palatin <vpalatin@chromium.org>
---
 arch/x86/pci/i386.c     |    2 +-
 drivers/acpi/pci_irq.c  |   10 +++++-----
 drivers/pci/pci.c       |    5 ++---
 drivers/pci/setup-res.c |    6 +++---
 4 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index 794b092..e215a9b 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -270,7 +270,7 @@ void pcibios_set_master(struct pci_dev *dev)
 		lat = pcibios_max_latency;
 	else
 		return;
-	dev_printk(KERN_DEBUG, &dev->dev, "setting latency timer to %d\n", lat);
+	dev_dbg(&dev->dev, "setting latency timer to %d\n", lat);
 	pci_write_config_byte(dev, PCI_LATENCY_TIMER, lat);
 }
 
diff --git a/drivers/acpi/pci_irq.c b/drivers/acpi/pci_irq.c
index 7f9eba9..0eefa12 100644
--- a/drivers/acpi/pci_irq.c
+++ b/drivers/acpi/pci_irq.c
@@ -487,10 +487,10 @@ int acpi_pci_irq_enable(struct pci_dev *dev)
 	else
 		link_desc[0] = '\0';
 
-	dev_info(&dev->dev, "PCI INT %c%s -> GSI %u (%s, %s) -> IRQ %d\n",
-		 pin_name(pin), link_desc, gsi,
-		 (triggering == ACPI_LEVEL_SENSITIVE) ? "level" : "edge",
-		 (polarity == ACPI_ACTIVE_LOW) ? "low" : "high", dev->irq);
+	dev_dbg(&dev->dev, "PCI INT %c%s -> GSI %u (%s, %s) -> IRQ %d\n",
+		pin_name(pin), link_desc, gsi,
+		(triggering == ACPI_LEVEL_SENSITIVE) ? "level" : "edge",
+		(polarity == ACPI_ACTIVE_LOW) ? "low" : "high", dev->irq);
 
 	return 0;
 }
@@ -524,6 +524,6 @@ void acpi_pci_irq_disable(struct pci_dev *dev)
 	 * (e.g. PCI_UNDEFINED_IRQ).
 	 */
 
-	dev_info(&dev->dev, "PCI INT %c disabled\n", pin_name(pin));
+	dev_dbg(&dev->dev, "PCI INT %c disabled\n", pin_name(pin));
 	acpi_unregister_gsi(gsi);
 }
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 6f45a73..8119757 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -964,7 +964,7 @@ void pci_restore_state(struct pci_dev *dev)
 	for (i = 15; i >= 0; i--) {
 		pci_read_config_dword(dev, i * 4, &val);
 		if (val != dev->saved_config_space[i]) {
-			dev_printk(KERN_DEBUG, &dev->dev, "restoring config "
+			dev_dbg(&dev->dev, "restoring config "
 				"space at offset %#x (was %#x, writing %#x)\n",
 				i, val, (int)dev->saved_config_space[i]);
 			pci_write_config_dword(dev,i * 4,
@@ -1529,8 +1529,7 @@ void pci_pme_active(struct pci_dev *dev, bool enable)
 	}
 
 out:
-	dev_printk(KERN_DEBUG, &dev->dev, "PME# %s\n",
-			enable ? "enabled" : "disabled");
+	dev_dbg(&dev->dev, "PME# %s\n", enable ? "enabled" : "disabled");
 }
 
 /**
diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
index 5717509b..b66bfdb 100644
--- a/drivers/pci/setup-res.c
+++ b/drivers/pci/setup-res.c
@@ -85,9 +85,9 @@ void pci_update_resource(struct pci_dev *dev, int resno)
 		}
 	}
 	res->flags &= ~IORESOURCE_UNSET;
-	dev_info(&dev->dev, "BAR %d: set to %pR (PCI address [%#llx-%#llx])\n",
-		 resno, res, (unsigned long long)region.start,
-		 (unsigned long long)region.end);
+	dev_dbg(&dev->dev, "BAR %d: set to %pR (PCI address [%#llx-%#llx])\n",
+		resno, res, (unsigned long long)region.start,
+		(unsigned long long)region.end);
 }
 
 int pci_claim_resource(struct pci_dev *dev, int resource)
-- 
1.7.3.1

