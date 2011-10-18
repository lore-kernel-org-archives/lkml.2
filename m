Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757833Ab1JRNNK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 09:13:10 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:47511 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705Ab1JRNNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 09:13:07 -0400
From: Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 15/20] Staging: comedi: fix printk issue in contec_pci_dio.c
Date: Tue, 18 Oct 2011 18:42:10 +0530
Message-Id: <1318943535-8251-2-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1318943535-8251-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1318943535-8251-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the contec_pci_dio.c file that fixes up a printk
warning found by the checkpatch.pl tool
converted printks to dev_printk.
Removed unnecessary printk statements.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/contec_pci_dio.c |   24 ++++++++--------------
 1 files changed, 9 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/comedi/drivers/contec_pci_dio.c b/drivers/staging/comedi/drivers/contec_pci_dio.c
index 871f109..f2b4cc4 100644
--- a/drivers/staging/comedi/drivers/contec_pci_dio.c
+++ b/drivers/staging/comedi/drivers/contec_pci_dio.c
@@ -106,8 +106,6 @@ static int contec_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	struct pci_dev *pcidev = NULL;
 	struct comedi_subdevice *s;
 
-	printk("comedi%d: contec: ", dev->minor);
-
 	dev->board_name = thisboard->name;
 
 	if (alloc_private(dev, sizeof(struct contec_private)) < 0)
@@ -128,12 +126,11 @@ static int contec_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 			}
 			devpriv->pci_dev = pcidev;
 			if (comedi_pci_enable(pcidev, "contec_pci_dio")) {
-				printk
-				    ("error enabling PCI device and request regions!\n");
+				dev_err(dev->hw_dev, "error enabling PCI device and request regions!\n");
 				return -EIO;
 			}
 			dev->iobase = pci_resource_start(pcidev, 0);
-			printk(" base addr %lx ", dev->iobase);
+			dev_dbg(dev->hw_dev, "base addr %lx\n", dev->iobase);
 
 			dev->board_ptr = contec_boards + 0;
 
@@ -154,20 +151,17 @@ static int contec_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 			s->range_table = &range_digital;
 			s->insn_bits = contec_do_insn_bits;
 
-			printk("attached\n");
-
 			return 1;
 		}
 	}
 
-	printk("card not present!\n");
+	dev_err(dev->hw_dev, "card not present!\n");
 
 	return -EIO;
 }
 
 static int contec_detach(struct comedi_device *dev)
 {
-	printk("comedi%d: contec: remove\n", dev->minor);
 
 	if (devpriv && devpriv->pci_dev) {
 		if (dev->iobase)
@@ -197,8 +191,8 @@ static int contec_do_insn_bits(struct comedi_device *dev,
 			       struct comedi_insn *insn, unsigned int *data)
 {
 
-	printk("contec_do_insn_bits called\n");
-	printk(" data: %d %d\n", data[0], data[1]);
+	dev_dbg(dev->hw_dev, "contec_do_insn_bits called\n");
+	dev_dbg(dev->hw_dev, "data: %d %d\n", data[0], data[1]);
 
 	if (insn->n != 2)
 		return -EINVAL;
@@ -206,8 +200,8 @@ static int contec_do_insn_bits(struct comedi_device *dev,
 	if (data[0]) {
 		s->state &= ~data[0];
 		s->state |= data[0] & data[1];
-		printk("  out: %d on %lx\n", s->state,
-		       dev->iobase + thisboard->out_offs);
+		dev_dbg(dev->hw_dev, "out: %d on %lx\n", s->state,
+			dev->iobase + thisboard->out_offs);
 		outw(s->state, dev->iobase + thisboard->out_offs);
 	}
 	return 2;
@@ -218,8 +212,8 @@ static int contec_di_insn_bits(struct comedi_device *dev,
 			       struct comedi_insn *insn, unsigned int *data)
 {
 
-	printk("contec_di_insn_bits called\n");
-	printk(" data: %d %d\n", data[0], data[1]);
+	dev_dbg(dev->hw_dev, "contec_di_insn_bits called\n");
+	dev_dbg(dev->hw_dev, "data: %d %d\n", data[0], data[1]);
 
 	if (insn->n != 2)
 		return -EINVAL;
-- 
1.7.6.4

