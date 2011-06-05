Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168Ab1FEU6o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 16:58:44 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:33839 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755816Ab1FEU6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 16:58:43 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: linux-acpi@vger.kernel.org
Cc: linux-pci@vger.kernel.org, jirislaby@gmail.com,
        linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: [RFC v2] ACPI: pci_link, use the lowest possible IRQ
Date: Sun,  5 Jun 2011 22:58:37 +0200
Message-Id: <1307307517-28365-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On IBM Bartolo machines, the serial board enumerated as 00:09.0 is
defunct (if uses interrupts). The board has probably incorrectly
set IRQ routing in BIOS. DSDT says that this slot (with function 0,
i.e. pin A) is routed to \_SB_.PCI0.PIB_.LNKB. But it doesn't look
like that. If a quirk is added to override this to LNKC, it works OK.

What's interesting is that Windows (with ACPI enabled) work with this
system without problems. So it does with ACPI routing disabled in
Linux. By investigating further we found out (there are two boards
with two ports each):
* acpi routing enabled (no kernel parameter) => ports 4+5 defunct.
  ports 4+5+6+7 are all on irq 11
* acpi routing disabled (acpi=noirq) => all ports working, 4+5 on irq
  10, 6+7 on irq 11
* with the quirk and acpi routing enabled => all ports working,
  ports 4+5 on irq 10, 6+7 on irq 11
* with this patch and acpi routing enabled => all ports working,
  ports 4+5 on irq 10, 6+7 on irq 11
* in windows (ACPI enabled) => 4+5+6+7 are all on irq 9 and the ports
  are all working.

As Windows seem to use the lowest possible IRQ, let's do the same
thing. However they perhaps enumerate the buses in a different order
so they end up with different IRQs.

References: https://bugzilla.kernel.org/show_bug.cgi?id=18092
References: https://bugzilla.novell.com/show_bug.cgi?id=595683
References: https://lkml.org/lkml/2011/4/12/323
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Len Brown <lenb@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
---
 drivers/acpi/pci_link.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/pci_link.c b/drivers/acpi/pci_link.c
index 4a29763..feac720 100644
--- a/drivers/acpi/pci_link.c
+++ b/drivers/acpi/pci_link.c
@@ -557,7 +557,7 @@ static int acpi_pci_link_allocate(struct acpi_pci_link *link)
 		 * the use of IRQs 9, 10, 11, and >15.
 		 */
 		for (i = (link->irq.possible_count - 1); i >= 0; i--) {
-			if (acpi_irq_penalty[irq] >
+			if (acpi_irq_penalty[irq] >=
 			    acpi_irq_penalty[link->irq.possible[i]])
 				irq = link->irq.possible[i];
 		}
-- 
1.7.5.3


