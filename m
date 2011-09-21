Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822Ab1IUSFi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 14:05:38 -0400
Received: from smtp-out.google.com ([74.125.121.67]:2670 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753771Ab1IUSFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 14:05:36 -0400
From: Vincent Palatin <vpalatin@chromium.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
        Linux PCI <linux-pci@vger.kernel.org>
Cc: Olof Johansson <olofj@chromium.org>, Sameer Nanda <snanda@chromium.org>,
        Ming Lei <tom.leiming@gmail.com>, linux-kernel@vger.kernel.org,
        Vincent Palatin <vpalatin@chromium.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH] PM / Runtime: make PCI traces quieter
Date: Wed, 21 Sep 2011 11:05:08 -0700
Message-Id: <1316628308-32580-1-git-send-email-vpalatin@chromium.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <CAP_ceTyXLO=mv1Ott=g3mG0y+Q+VUM3N8CA-Fqa-_=uj7LTbmw@mail.gmail.com>
References: <CAP_ceTyXLO=mv1Ott=g3mG0y+Q+VUM3N8CA-Fqa-_=uj7LTbmw@mail.gmail.com>
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
index 494f2e7..eb5d20b 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -269,7 +269,7 @@ void pcibios_set_master(struct pci_dev *dev)
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
index 0ce6742..d339c30 100644
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
@@ -1531,8 +1531,7 @@ void pci_pme_active(struct pci_dev *dev, bool enable)
 	}
 
 out:
-	dev_printk(KERN_DEBUG, &dev->dev, "PME# %s\n",
-			enable ? "enabled" : "disabled");
+	dev_dbg(&dev->dev, "PME# %s\n", enable ? "enabled" : "disabled");
 }
 
 /**
diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
index 51a9095..3878fe9 100644
--- a/drivers/pci/setup-res.c
+++ b/drivers/pci/setup-res.c
@@ -84,9 +84,9 @@ void pci_update_resource(struct pci_dev *dev, int resno)
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

