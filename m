Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374Ab2GSBjb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 21:39:31 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:62887 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754993Ab2GSBj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 21:39:28 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-5.tower-131.messagelabs.com!1342661967!25481163!1
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 32/90] staging: comedi: amplc_pc236: store the pci_dev in the comedi_device
Date: Wed, 18 Jul 2012 18:39:24 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207181839.24686.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the hw_dev pointer in the comedi_device struct to hold the
pci_dev instead of carrying it in the private data.

Since the pci_dev is no longer held in the provate data, we can
also cleanup the detach a bit. Remove the IS_ENABLED() tests in
the detach. If the pci_dev is non NULL it's a PCI device otherwise
it's an ISA device. Using IS_ENABLED() to omit the code paths
makes the code a bit confusing and doesn't save much.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/amplc_pc236.c | 28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pc236.c b/drivers/staging/comedi/drivers/amplc_pc236.c
index 3eee7f3..aabba98 100644
--- a/drivers/staging/comedi/drivers/amplc_pc236.c
+++ b/drivers/staging/comedi/drivers/amplc_pc236.c
@@ -131,8 +131,6 @@ static const struct pc236_board pc236_boards[] = {
    feel free to suggest moving the variable to the struct comedi_device struct.
  */
 struct pc236_private {
-	/* PCI device */
-	struct pci_dev *pci_dev;
 	unsigned long lcr_iobase; /* PLX PCI9052 config registers in PCIBAR1 */
 	int enable_irq;
 };
@@ -412,6 +410,7 @@ static irqreturn_t pc236_interrupt(int irq, void *d)
 static void pc236_report_attach(struct comedi_device *dev, unsigned int irq)
 {
 	const struct pc236_board *thisboard = comedi_board(dev);
+	struct pci_dev *pcidev = comedi_to_pci_dev(dev);
 	char tmpbuf[60];
 	int tmplen;
 
@@ -421,10 +420,8 @@ static void pc236_report_attach(struct comedi_device *dev, unsigned int irq)
 				   "(base %#lx) ", dev->iobase);
 	else if (IS_ENABLED(CONFIG_COMEDI_AMPLC_PC236_PCI) &&
 		 thisboard->bustype == pci_bustype) {
-		struct pc236_private *devpriv = dev->private;
-		struct pci_dev *pci_dev = devpriv->pci_dev;
 		tmplen = scnprintf(tmpbuf, sizeof(tmpbuf),
-				   "(pci %s) ", pci_name(pci_dev));
+				   "(pci %s) ", pci_name(pcidev));
 	} else
 		tmplen = 0;
 	if (irq)
@@ -489,7 +486,8 @@ static int pc236_pci_common_attach(struct comedi_device *dev,
 	unsigned long iobase;
 	int ret;
 
-	devpriv->pci_dev = pci_dev;
+	comedi_set_hw_dev(dev, &pci_dev->dev);
+
 	ret = comedi_pci_enable(pci_dev, PC236_DRIVER_NAME);
 	if (ret < 0) {
 		dev_err(dev->class_dev,
@@ -573,6 +571,7 @@ static int __devinit pc236_attach_pci(struct comedi_device *dev,
 static void pc236_detach(struct comedi_device *dev)
 {
 	struct pc236_private *devpriv = dev->private;
+	struct pci_dev *pcidev = comedi_to_pci_dev(dev);
 
 	if (devpriv)
 		pc236_intr_disable(dev);
@@ -580,16 +579,13 @@ static void pc236_detach(struct comedi_device *dev)
 		free_irq(dev->irq, dev);
 	if (dev->subdevices)
 		subdev_8255_cleanup(dev, dev->subdevices + 0);
-	if (devpriv) {
-		if (IS_ENABLED(CONFIG_COMEDI_AMPLC_PC236_PCI) &&
-		    devpriv->pci_dev) {
-			if (dev->iobase)
-				comedi_pci_disable(devpriv->pci_dev);
-			pci_dev_put(devpriv->pci_dev);
-		} else if (IS_ENABLED(CONFIG_COMEDI_AMPLC_PC236_ISA)) {
-			if (dev->iobase)
-				release_region(dev->iobase, PC236_IO_SIZE);
-		}
+	if (pcidev) {
+		if (dev->iobase)
+			comedi_pci_disable(pcidev);
+		pci_dev_put(pcidev);
+	} else {
+		if (dev->iobase)
+			release_region(dev->iobase, PC236_IO_SIZE);
 	}
 }
 
-- 
1.7.11

