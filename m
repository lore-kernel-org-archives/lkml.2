Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857Ab1DLIse (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 04:48:34 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:58251 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753857Ab1DLIsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 04:48:32 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: jirislaby@gmail.com
Cc: Robert Hancock <hancockrwd@gmail.com>, mjg59@srcf.ucam.org,
        lenb@kernel.org, linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
        jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>
Subject: [RFC 1/1] ACPI: pci_irq, add PRT_ quirk for IBM Bartolo
Date: Tue, 12 Apr 2011 10:48:06 +0200
Message-Id: <1302598086-3622-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <4C87A62E.30108@gmail.com>
References: <4C87A62E.30108@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On IBM Bartolo machines, cards in 00:09.0 are defunct (if use
interrupts). DSDT says that this slot (with function 0, i.e. pin A) is
routed to \_SB_.PCI0.PIB_.LNKB. But it's not, it's wired to LNKC, so
interrupts are misrouted. Add a quirk for this to workaround the
issue.

References: https://bugzilla.novell.com/show_bug.cgi?id=595683
References: https://bugzilla.kernel.org/show_bug.cgi?id=18092

---
Hi,

as Robert Hancock suggested at:
http://lkml.org/lkml/2010/9/7/206

I reported this in bugzilla (the link above). But I got only replies
requesting another infos which I provided. Could anybody look into
the bug and confirm whether this patch is correct or not. And if yes,
could you apply that?

---

Not-signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Len Brown <lenb@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 drivers/acpi/pci_irq.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/pci_irq.c b/drivers/acpi/pci_irq.c
index f907cfb..e8fb00d 100644
--- a/drivers/acpi/pci_irq.c
+++ b/drivers/acpi/pci_irq.c
@@ -124,6 +124,18 @@ static const struct dmi_system_id hp_t5710[] = {
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
@@ -151,6 +163,9 @@ static const struct prt_quirk prt_quirks[] = {
 	{ hp_t5710, 0, 0, 1, PCI_INTX_PIN('A'),
 		"\\_SB_.PCI0.LNK1",
 		"\\_SB_.PCI0.LNK3"},
+	{ ibm_bartolo, 0, 0, 9, PCI_INTX_PIN('A'),
+		"\\_SB_.PCI0.PIB_.LNKB",
+		"\\_SB_.PCI0.PIB_.LNKC"},
 };
 
 static void do_prt_fixups(struct acpi_prt_entry *entry,
-- 
1.7.4.2


