Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932473Ab1IPWQd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 18:16:33 -0400
Received: from smtp-out.google.com ([74.125.121.67]:11169 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932447Ab1IPWQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 18:16:30 -0400
From: Vincent Palatin <vpalatin@chromium.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
        Linux PCI <linux-pci@vger.kernel.org>
Cc: Olof Johansson <olofj@chromium.org>, Sameer Nanda <snanda@chromium.org>,
        Ming Lei <tom.leiming@gmail.com>, linux-kernel@vger.kernel.org,
        Vincent Palatin <vpalatin@chromium.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH 2/2] PM / Runtime: make PCI traces quieter
Date: Fri, 16 Sep 2011 15:15:55 -0700
Message-Id: <1316211355-2888-3-git-send-email-vpalatin@chromium.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1316211355-2888-1-git-send-email-vpalatin@chromium.org>
References: <1316211355-2888-1-git-send-email-vpalatin@chromium.org>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the runtime PM is activated on PCI, if a device switches state
frequently (e.g. an EHCI controller with autosuspending USB devices
connected) the PCI configuration traces might be very verbose in the
kernel log. Let's desactivate them in such a situation.

Signed-off-by: Vincent Palatin <vpalatin@chromium.org>
---
 arch/x86/pci/i386.c     |    4 +++-
 drivers/acpi/pci_irq.c  |   15 ++++++++++-----
 drivers/pci/pci.c       |   11 ++++++-----
 drivers/pci/setup-res.c |    8 +++++---
 4 files changed, 24 insertions(+), 14 deletions(-)

diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index 494f2e7..2bb0e1e 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -31,6 +31,7 @@
 #include <linux/ioport.h>
 #include <linux/errno.h>
 #include <linux/bootmem.h>
+#include <linux/pm_runtime.h>
 
 #include <asm/pat.h>
 #include <asm/e820.h>
@@ -269,7 +270,8 @@ void pcibios_set_master(struct pci_dev *dev)
 		lat = pcibios_max_latency;
 	else
 		return;
-	dev_printk(KERN_DEBUG, &dev->dev, "setting latency timer to %d\n", lat);
+	dev_printk_norpm(KERN_DEBUG, &dev->dev,
+			 "setting latency timer to %d\n", lat);
 	pci_write_config_byte(dev, PCI_LATENCY_TIMER, lat);
 }
 
diff --git a/drivers/acpi/pci_irq.c b/drivers/acpi/pci_irq.c
index 7f9eba9..8cc1194 100644
--- a/drivers/acpi/pci_irq.c
+++ b/drivers/acpi/pci_irq.c
@@ -34,6 +34,7 @@
 #include <linux/types.h>
 #include <linux/spinlock.h>
 #include <linux/pm.h>
+#include <linux/pm_runtime.h>
 #include <linux/pci.h>
 #include <linux/acpi.h>
 #include <linux/slab.h>
@@ -487,10 +488,13 @@ int acpi_pci_irq_enable(struct pci_dev *dev)
 	else
 		link_desc[0] = '\0';
 
-	dev_info(&dev->dev, "PCI INT %c%s -> GSI %u (%s, %s) -> IRQ %d\n",
-		 pin_name(pin), link_desc, gsi,
-		 (triggering == ACPI_LEVEL_SENSITIVE) ? "level" : "edge",
-		 (polarity == ACPI_ACTIVE_LOW) ? "low" : "high", dev->irq);
+	dev_printk_norpm(KERN_INFO, &dev->dev, "PCI INT %c%s -> "
+			 "GSI %u (%s, %s) -> IRQ %d\n",
+			 pin_name(pin), link_desc, gsi,
+			 (triggering == ACPI_LEVEL_SENSITIVE) ?
+			 "level" : "edge",
+			 (polarity == ACPI_ACTIVE_LOW) ?
+			 "low" : "high", dev->irq);
 
 	return 0;
 }
@@ -524,6 +528,7 @@ void acpi_pci_irq_disable(struct pci_dev *dev)
 	 * (e.g. PCI_UNDEFINED_IRQ).
 	 */
 
-	dev_info(&dev->dev, "PCI INT %c disabled\n", pin_name(pin));
+	dev_printk_norpm(KERN_INFO, &dev->dev, "PCI INT %c disabled\n",
+			 pin_name(pin));
 	acpi_unregister_gsi(gsi);
 }
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 0ce6742..9f6b48c 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -964,9 +964,10 @@ void pci_restore_state(struct pci_dev *dev)
 	for (i = 15; i >= 0; i--) {
 		pci_read_config_dword(dev, i * 4, &val);
 		if (val != dev->saved_config_space[i]) {
-			dev_printk(KERN_DEBUG, &dev->dev, "restoring config "
-				"space at offset %#x (was %#x, writing %#x)\n",
-				i, val, (int)dev->saved_config_space[i]);
+			dev_printk_norpm(KERN_DEBUG, &dev->dev,
+					 "restoring space at offset %#x "
+					 "(was %#x, writing %#x)\n", i, val,
+					 (int)dev->saved_config_space[i]);
 			pci_write_config_dword(dev,i * 4,
 				dev->saved_config_space[i]);
 		}
@@ -1531,8 +1532,8 @@ void pci_pme_active(struct pci_dev *dev, bool enable)
 	}
 
 out:
-	dev_printk(KERN_DEBUG, &dev->dev, "PME# %s\n",
-			enable ? "enabled" : "disabled");
+	dev_printk_norpm(KERN_DEBUG, &dev->dev, "PME# %s\n",
+			 enable ? "enabled" : "disabled");
 }
 
 /**
diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
index 51a9095..942399c 100644
--- a/drivers/pci/setup-res.c
+++ b/drivers/pci/setup-res.c
@@ -23,6 +23,7 @@
 #include <linux/ioport.h>
 #include <linux/cache.h>
 #include <linux/slab.h>
+#include <linux/pm_runtime.h>
 #include "pci.h"
 
 
@@ -84,9 +85,10 @@ void pci_update_resource(struct pci_dev *dev, int resno)
 		}
 	}
 	res->flags &= ~IORESOURCE_UNSET;
-	dev_info(&dev->dev, "BAR %d: set to %pR (PCI address [%#llx-%#llx])\n",
-		 resno, res, (unsigned long long)region.start,
-		 (unsigned long long)region.end);
+	dev_printk_norpm(KERN_INFO, &dev->dev,
+			 "BAR %d: set to %pR (PCI address [%#llx-%#llx])\n",
+			 resno, res, (unsigned long long)region.start,
+			 (unsigned long long)region.end);
 }
 
 int pci_claim_resource(struct pci_dev *dev, int resource)
-- 
1.7.3.1

