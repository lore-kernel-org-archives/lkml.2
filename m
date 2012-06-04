Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757032Ab2FDLkY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 07:40:24 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:44994 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754406Ab2FDLfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 07:35:44 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 01/24] TTY: cyclades, add local pointer for card
Date: Mon,  4 Jun 2012 13:35:15 +0200
Message-Id: <1338809738-18967-2-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.10.3
In-Reply-To: <1338809738-18967-1-git-send-email-jslaby@suse.cz>
References: <1338809738-18967-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cy_pci_probe and cy_detect_isa reference cy_card[card_no] many times.
It makes the code hard to read. Let us add a local variable holding a
pointer to the card indexed by card_no and use that.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/cyclades.c |   63 +++++++++++++++++++++++++-----------------------
 1 file changed, 33 insertions(+), 30 deletions(-)

diff --git a/drivers/tty/cyclades.c b/drivers/tty/cyclades.c
index e61cabd..cff5468 100644
--- a/drivers/tty/cyclades.c
+++ b/drivers/tty/cyclades.c
@@ -3289,6 +3289,7 @@ static unsigned short __devinit cyy_init_card(void __iomem *true_base_addr,
 static int __init cy_detect_isa(void)
 {
 #ifdef CONFIG_ISA
+	struct cyclades_card *card;
 	unsigned short cy_isa_irq, nboard;
 	void __iomem *cy_isa_address;
 	unsigned short i, j, cy_isa_nchan;
@@ -3349,7 +3350,8 @@ static int __init cy_detect_isa(void)
 		}
 		/* fill the next cy_card structure available */
 		for (j = 0; j < NR_CARDS; j++) {
-			if (cy_card[j].base_addr == NULL)
+			card = &cy_card[j];
+			if (card->base_addr == NULL)
 				break;
 		}
 		if (j == NR_CARDS) {	/* no more cy_cards available */
@@ -3363,7 +3365,7 @@ static int __init cy_detect_isa(void)
 
 		/* allocate IRQ */
 		if (request_irq(cy_isa_irq, cyy_interrupt,
-				0, "Cyclom-Y", &cy_card[j])) {
+				0, "Cyclom-Y", card)) {
 			printk(KERN_ERR "Cyclom-Y/ISA found at 0x%lx, but "
 				"could not allocate IRQ#%d.\n",
 				(unsigned long)cy_isa_address, cy_isa_irq);
@@ -3372,16 +3374,16 @@ static int __init cy_detect_isa(void)
 		}
 
 		/* set cy_card */
-		cy_card[j].base_addr = cy_isa_address;
-		cy_card[j].ctl_addr.p9050 = NULL;
-		cy_card[j].irq = (int)cy_isa_irq;
-		cy_card[j].bus_index = 0;
-		cy_card[j].first_line = cy_next_channel;
-		cy_card[j].num_chips = cy_isa_nchan / CyPORTS_PER_CHIP;
-		cy_card[j].nports = cy_isa_nchan;
-		if (cy_init_card(&cy_card[j])) {
-			cy_card[j].base_addr = NULL;
-			free_irq(cy_isa_irq, &cy_card[j]);
+		card->base_addr = cy_isa_address;
+		card->ctl_addr.p9050 = NULL;
+		card->irq = (int)cy_isa_irq;
+		card->bus_index = 0;
+		card->first_line = cy_next_channel;
+		card->num_chips = cy_isa_nchan / CyPORTS_PER_CHIP;
+		card->nports = cy_isa_nchan;
+		if (cy_init_card(card)) {
+			card->base_addr = NULL;
+			free_irq(cy_isa_irq, card);
 			iounmap(cy_isa_address);
 			continue;
 		}
@@ -3695,6 +3697,7 @@ err:
 static int __devinit cy_pci_probe(struct pci_dev *pdev,
 		const struct pci_device_id *ent)
 {
+	struct cyclades_card *card;
 	void __iomem *addr0 = NULL, *addr2 = NULL;
 	char *card_name = NULL;
 	u32 uninitialized_var(mailbox);
@@ -3829,7 +3832,8 @@ static int __devinit cy_pci_probe(struct pci_dev *pdev,
 	}
 	/* fill the next cy_card structure available */
 	for (card_no = 0; card_no < NR_CARDS; card_no++) {
-		if (cy_card[card_no].base_addr == NULL)
+		card = &cy_card[card_no];
+		if (card->base_addr == NULL)
 			break;
 	}
 	if (card_no == NR_CARDS) {	/* no more cy_cards available */
@@ -3843,27 +3847,26 @@ static int __devinit cy_pci_probe(struct pci_dev *pdev,
 			device_id == PCI_DEVICE_ID_CYCLOM_Y_Hi) {
 		/* allocate IRQ */
 		retval = request_irq(irq, cyy_interrupt,
-				IRQF_SHARED, "Cyclom-Y", &cy_card[card_no]);
+				IRQF_SHARED, "Cyclom-Y", card);
 		if (retval) {
 			dev_err(&pdev->dev, "could not allocate IRQ\n");
 			goto err_unmap;
 		}
-		cy_card[card_no].num_chips = nchan / CyPORTS_PER_CHIP;
+		card->num_chips = nchan / CyPORTS_PER_CHIP;
 	} else {
 		struct FIRM_ID __iomem *firm_id = addr2 + ID_ADDRESS;
 		struct ZFW_CTRL __iomem *zfw_ctrl;
 
 		zfw_ctrl = addr2 + (readl(&firm_id->zfwctrl_addr) & 0xfffff);
 
-		cy_card[card_no].hw_ver = mailbox;
-		cy_card[card_no].num_chips = (unsigned int)-1;
-		cy_card[card_no].board_ctrl = &zfw_ctrl->board_ctrl;
+		card->hw_ver = mailbox;
+		card->num_chips = (unsigned int)-1;
+		card->board_ctrl = &zfw_ctrl->board_ctrl;
 #ifdef CONFIG_CYZ_INTR
 		/* allocate IRQ only if board has an IRQ */
 		if (irq != 0 && irq != 255) {
 			retval = request_irq(irq, cyz_interrupt,
-					IRQF_SHARED, "Cyclades-Z",
-					&cy_card[card_no]);
+					IRQF_SHARED, "Cyclades-Z", card);
 			if (retval) {
 				dev_err(&pdev->dev, "could not allocate IRQ\n");
 				goto err_unmap;
@@ -3873,17 +3876,17 @@ static int __devinit cy_pci_probe(struct pci_dev *pdev,
 	}
 
 	/* set cy_card */
-	cy_card[card_no].base_addr = addr2;
-	cy_card[card_no].ctl_addr.p9050 = addr0;
-	cy_card[card_no].irq = irq;
-	cy_card[card_no].bus_index = 1;
-	cy_card[card_no].first_line = cy_next_channel;
-	cy_card[card_no].nports = nchan;
-	retval = cy_init_card(&cy_card[card_no]);
+	card->base_addr = addr2;
+	card->ctl_addr.p9050 = addr0;
+	card->irq = irq;
+	card->bus_index = 1;
+	card->first_line = cy_next_channel;
+	card->nports = nchan;
+	retval = cy_init_card(card);
 	if (retval)
 		goto err_null;
 
-	pci_set_drvdata(pdev, &cy_card[card_no]);
+	pci_set_drvdata(pdev, card);
 
 	if (device_id == PCI_DEVICE_ID_CYCLOM_Y_Lo ||
 			device_id == PCI_DEVICE_ID_CYCLOM_Y_Hi) {
@@ -3915,8 +3918,8 @@ static int __devinit cy_pci_probe(struct pci_dev *pdev,
 
 	return 0;
 err_null:
-	cy_card[card_no].base_addr = NULL;
-	free_irq(irq, &cy_card[card_no]);
+	card->base_addr = NULL;
+	free_irq(irq, card);
 err_unmap:
 	iounmap(addr0);
 	if (addr2)
-- 
1.7.10.3


