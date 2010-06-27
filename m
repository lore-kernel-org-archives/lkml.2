Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856Ab0F0VVn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jun 2010 17:21:43 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:60898 "EHLO
	mail.pripojeni.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753265Ab0F0VVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jun 2010 17:21:42 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: lenb@kernel.org
Cc: linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH 1/1] ACPI: pci_irq, add PRT_ quirk for IBM Bartolo
Date: Sun, 27 Jun 2010 23:21:19 +0200
Message-Id: <1277673679-21458-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On IBM Bartolo machines, cards in 00:09.0 are defunct (if use
interrupts). DSDT says that this slot (with function 0, i.e. pin A) is
routed to \_SB_.PCI0.PIB_.LNKB. But it's not, it's wired to LNKC, so
interrupts are misrouted. Add a quirk for this to workaround the
issue.

This error was reported in suse bugzilla at:
https://bugzilla.novell.com/show_bug.cgi?id=595683

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Len Brown <lenb@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 drivers/acpi/pci_irq.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/pci_irq.c b/drivers/acpi/pci_irq.c
index e4804fb..8e054a4 100644
--- a/drivers/acpi/pci_irq.c
+++ b/drivers/acpi/pci_irq.c
@@ -125,6 +125,18 @@ static const struct dmi_system_id hp_t5710[] = {
 	{ }
 };
 
+/* https://bugzilla.novell.com/show_bug.cgi?id=595683 */
+static const struct dmi_system_id ibm_bartolo[] = {
+	{
+		.ident = "IBM Bartolo",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "IBM CORPORATION"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "4810320"),
+		},
+	},
+	{ }
+};
+
 struct prt_quirk {
 	const struct dmi_system_id *system;
 	unsigned int		segment;
@@ -152,6 +164,9 @@ static const struct prt_quirk prt_quirks[] = {
 	{ hp_t5710, 0, 0, 1, PCI_INTX_PIN('A'),
 		"\\_SB_.PCI0.LNK1",
 		"\\_SB_.PCI0.LNK3"},
+	{ ibm_bartolo, 0, 0, 9, PCI_INTX_PIN('A'),
+		"\\_SB_.PCI0.PIB_.LNKB",
+		"\\_SB_.PCI0.PIB_.LNKC"},
 };
 
 static void do_prt_fixups(struct acpi_prt_entry *entry,
-- 
1.7.1


