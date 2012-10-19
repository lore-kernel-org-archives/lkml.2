Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934Ab2JSAeN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 20:34:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54396 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674Ab2JSAeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 20:34:11 -0400
From: Daniel J Blueman <daniel@numascale-asia.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel J Blueman <daniel@numascale-asia.com>
Subject: [PATCH] Fix printing when no interrupt is allocated
Date: Fri, 19 Oct 2012 08:33:41 +0800
Message-Id: <1350606821-29813-1-git-send-email-daniel@numascale-asia.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously a new line is implicitly added in the no GSI case:

[    7.185182] pci 0001:00:12.0: can't derive routing for PCI INT A
[    7.191352] pci 0001:00:12.0: PCI INT A: no GSI
[    7.195956]  - using ISA IRQ 10

The code thus prints a blank line where no legacy IRQ is available:

[    1.650124] pci 0000:00:14.0: can't derive routing for PCI INT A
[    1.650126] pci 0000:00:14.0: PCI INT A: no GSI
[    1.650126] 
[    1.650180] pci 0000:00:14.0: can't derive routing for PCI INT A

Fix this by making the newline explicit and removing the superfluous
one.

Signed-off-by: Daniel J Blueman <daniel@numascale-asia.com>
---
 drivers/acpi/pci_irq.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/pci_irq.c b/drivers/acpi/pci_irq.c
index 0eefa12..2c37996 100644
--- a/drivers/acpi/pci_irq.c
+++ b/drivers/acpi/pci_irq.c
@@ -459,7 +459,7 @@ int acpi_pci_irq_enable(struct pci_dev *dev)
 	 */
 	if (gsi < 0) {
 		u32 dev_gsi;
-		dev_warn(&dev->dev, "PCI INT %c: no GSI", pin_name(pin));
+		dev_warn(&dev->dev, "PCI INT %c: no GSI\n", pin_name(pin));
 		/* Interrupt Line values above 0xF are forbidden */
 		if (dev->irq > 0 && (dev->irq <= 0xF) &&
 		    (acpi_isa_irq_to_gsi(dev->irq, &dev_gsi) == 0)) {
@@ -467,11 +467,9 @@ int acpi_pci_irq_enable(struct pci_dev *dev)
 			acpi_register_gsi(&dev->dev, dev_gsi,
 					  ACPI_LEVEL_SENSITIVE,
 					  ACPI_ACTIVE_LOW);
-			return 0;
-		} else {
-			printk("\n");
-			return 0;
 		}
+
+		return 0;
 	}
 
 	rc = acpi_register_gsi(&dev->dev, gsi, triggering, polarity);
-- 
1.7.9.5

