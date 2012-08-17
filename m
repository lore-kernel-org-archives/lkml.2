Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933633Ab2HQCt2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 22:49:28 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:15199 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933175Ab2HQCt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 22:49:26 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-3.tower-160.messagelabs.com!1345171765!8636691!1
X-Originating-IP: [216.166.12.32]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 19/35] staging: comedi: cb_pcimdda: use dev->iobase
Date: Thu, 16 Aug 2012 19:49:15 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208161949.15648.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use dev->iobase for the pci i/o address instead of carrying it
in the private data.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_pcimdda.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcimdda.c b/drivers/staging/comedi/drivers/cb_pcimdda.c
index 0c6d941..dc53f7e 100644
--- a/drivers/staging/comedi/drivers/cb_pcimdda.c
+++ b/drivers/staging/comedi/drivers/cb_pcimdda.c
@@ -137,7 +137,6 @@ static const struct cb_pcimdda_board cb_pcimdda_boards[] = {
  * struct.
  */
 struct cb_pcimdda_private {
-	unsigned long registers;	/* set by probe */
 	unsigned long dio_registers;
 	char attached_to_8255;	/* boolean */
 	/* would be useful for a PCI device */
@@ -157,7 +156,7 @@ static int cb_pcimdda_ao_winsn(struct comedi_device *dev,
 	struct cb_pcimdda_private *devpriv = dev->private;
 	int i;
 	int chan = CR_CHAN(insn->chanspec);
-	unsigned long offset = devpriv->registers + chan * 2;
+	unsigned long offset = dev->iobase + chan * 2;
 
 	/* Writing a list of values to an AO channel is probably not
 	 * very useful, but that's how the interface is defined. */
@@ -201,7 +200,7 @@ static int cb_pcimdda_ao_rinsn(struct comedi_device *dev,
 	int chan = CR_CHAN(insn->chanspec);
 
 	for (i = 0; i < insn->n; i++) {
-		inw(devpriv->registers + chan * 2);
+		inw(dev->iobase + chan * 2);
 		/*
 		 * should I set data[i] to the result of the actual read
 		 * on the register or the cached unsigned int in
@@ -263,9 +262,9 @@ static int cb_pcimdda_attach(struct comedi_device *dev,
 	err = comedi_pci_enable(pcidev, dev->board_name);
 	if (err)
 		return err;
-	devpriv->registers = pci_resource_start(devpriv->pci_dev,
+	dev->iobase = pci_resource_start(devpriv->pci_dev,
 						thisboard->regs_badrindex);
-	devpriv->dio_registers = devpriv->registers + thisboard->dio_offset;
+	devpriv->dio_registers = dev->iobase + thisboard->dio_offset;
 
 	err = comedi_alloc_subdevices(dev, 2);
 	if (err)
@@ -323,7 +322,7 @@ static void cb_pcimdda_detach(struct comedi_device *dev)
 			devpriv->attached_to_8255 = 0;
 		}
 		if (devpriv->pci_dev) {
-			if (devpriv->registers)
+			if (dev->iobase)
 				comedi_pci_disable(devpriv->pci_dev);
 			pci_dev_put(devpriv->pci_dev);
 		}
-- 
1.7.11

