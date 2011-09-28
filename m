Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061Ab1I1XB5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 19:01:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54737 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933191Ab1I1Wrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:47:55 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:42 2011
Message-Id: <20110928220142.691413193@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:02:09 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Anisse Astier <anisse@astier.eu>
Subject: [165/244] ehci: refactor pci quirk to use standard dmi_check_system method
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Anisse Astier <anisse@astier.eu>

commit 03c75362181b0b1d6a330e7cf8def10ba988dfbe upstream.

In commit 3610ea5397b80822e417aaa0e706fd803fb05680 (ehci: workaround for pci
quirk timeout on ExoPC), a workaround was added to skip the negociation for
the handoff of the EHCI controller.

Refactor the DMI detection code to use standard dmi_check_system function.

Signed-off-by: Anisse Astier <anisse@astier.eu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/pci-quirks.c |   21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

--- a/drivers/usb/host/pci-quirks.c
+++ b/drivers/usb/host/pci-quirks.c
@@ -535,20 +535,27 @@ static void __devinit quirk_usb_handoff_
 	iounmap(base);
 }
 
+static const struct dmi_system_id __initconst ehci_dmi_nohandoff_table[] = {
+	{
+		/*  Pegatron Lucid (ExoPC) */
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "EXOPG06411"),
+			DMI_MATCH(DMI_BIOS_VERSION, "Lucid-CE-133"),
+		},
+	},
+	{ }
+};
+
 static void __devinit ehci_bios_handoff(struct pci_dev *pdev,
 					void __iomem *op_reg_base,
 					u32 cap, u8 offset)
 {
 	int try_handoff = 1, tried_handoff = 0;
 
-	/* The Pegatron Lucid (ExoPC) tablet sporadically waits for 90
-	 * seconds trying the handoff on its unused controller.  Skip
-	 * it. */
+	/* The Pegatron Lucid tablet sporadically waits for 98 seconds trying
+	 * the handoff on its unused controller.  Skip it. */
 	if (pdev->vendor == 0x8086 && pdev->device == 0x283a) {
-		const char *dmi_bn = dmi_get_system_info(DMI_BOARD_NAME);
-		const char *dmi_bv = dmi_get_system_info(DMI_BIOS_VERSION);
-		if (dmi_bn && !strcmp(dmi_bn, "EXOPG06411") &&
-		    dmi_bv && !strcmp(dmi_bv, "Lucid-CE-133"))
+		if (dmi_check_system(ehci_dmi_nohandoff_table))
 			try_handoff = 0;
 	}
 


