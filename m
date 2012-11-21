Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102Ab2KUNqG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 08:46:06 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:59164 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752260Ab2KUNqE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 08:46:04 -0500
Message-ID: <1353505564.24807.12.camel@joe-AO722>
Subject: Re: [PATCH RESEND] acpi: Fix logging when no pci_irq is allocated
From: Joe Perches <joe@perches.com>
To: Daniel J Blueman <daniel@numascale-asia.com>
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 21 Nov 2012 05:46:04 -0800
In-Reply-To: <1353487401-10279-1-git-send-email-daniel@numascale-asia.com>
References: <1353487401-10279-1-git-send-email-daniel@numascale-asia.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-11-21 at 16:43 +0800, Daniel J Blueman wrote:
> Previously a new line is implicitly added in the no GSI case:
> 
> [    7.185182] pci 0001:00:12.0: can't derive routing for PCI INT A
> [    7.191352] pci 0001:00:12.0: PCI INT A: no GSI
> [    7.195956]  - using ISA IRQ 10
> 
> The code thus prints a blank line where no legacy IRQ is available:
> 
> [    1.650124] pci 0000:00:14.0: can't derive routing for PCI INT A
> [    1.650126] pci 0000:00:14.0: PCI INT A: no GSI
> [    1.650126] 
> [    1.650180] pci 0000:00:14.0: can't derive routing for PCI INT A
> 
> Fix this by making the newline explicit and removing the superfluous
> one.

This breaks the logging code below it when there is an ISA irq.

The below works, but is a workaround for a defect in the printk
subsystem introduced by a logging change that will be fixed in
a near future release.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/acpi/pci_irq.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/pci_irq.c b/drivers/acpi/pci_irq.c
index f288e00..68a921d 100644
--- a/drivers/acpi/pci_irq.c
+++ b/drivers/acpi/pci_irq.c
@@ -458,19 +458,19 @@ int acpi_pci_irq_enable(struct pci_dev *dev)
 	 */
 	if (gsi < 0) {
 		u32 dev_gsi;
-		dev_warn(&dev->dev, "PCI INT %c: no GSI", pin_name(pin));
 		/* Interrupt Line values above 0xF are forbidden */
 		if (dev->irq > 0 && (dev->irq <= 0xF) &&
 		    (acpi_isa_irq_to_gsi(dev->irq, &dev_gsi) == 0)) {
-			printk(" - using ISA IRQ %d\n", dev->irq);
+			dev_warn(&dev->dev, "PCI INT %c: no GSI - using ISA IRQ %d\n",
+				 pin_name(pin), dev->irq);
 			acpi_register_gsi(&dev->dev, dev_gsi,
 					  ACPI_LEVEL_SENSITIVE,
 					  ACPI_ACTIVE_LOW);
-			return 0;
 		} else {
-			printk("\n");
-			return 0;
+			dev_warn(&dev->dev, "PCI INT %c: no GSI\n",
+				 pin_name(pin));
 		}
+		return 0;
 	}
 
 	rc = acpi_register_gsi(&dev->dev, gsi, triggering, polarity);


