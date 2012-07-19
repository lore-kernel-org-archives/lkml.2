Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817Ab2GSB3X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 21:29:23 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:56134 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543Ab2GSB3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 21:29:22 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-16.tower-209.messagelabs.com!1342661361!9085685!1
X-Originating-IP: [216.166.12.99]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 12/90] staging: comedi: adl_pci9118: store the pci_dev in the comedi_device
Date: Wed, 18 Jul 2012 18:29:15 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207181829.15771.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the hw_dev pointer in the comedi_device struct to hold the
pci_dev instead of carrying it in the private data.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/adl_pci9118.c | 33 +++++++++++++++-------------
 1 file changed, 18 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci9118.c b/drivers/staging/comedi/drivers/adl_pci9118.c
index 4482aab..a1f74c2 100644
--- a/drivers/staging/comedi/drivers/adl_pci9118.c
+++ b/drivers/staging/comedi/drivers/adl_pci9118.c
@@ -250,7 +250,6 @@ struct boardtype {
 struct pci9118_private {
 	unsigned long iobase_a;	/* base+size for AMCC chip */
 	unsigned int master;	/* master capable */
-	struct pci_dev *pcidev;	/* ptr to actual pcidev */
 	unsigned int usemux;	/* we want to use external multiplexor! */
 #ifdef PCI9118_PARANOIDCHECK
 	unsigned short chanlist[PCI9118_CHANLEN + 1];	/*
@@ -2151,6 +2150,7 @@ static struct pci_dev *pci9118_find_pci(struct comedi_device *dev,
 static int pci9118_attach(struct comedi_device *dev,
 			  struct comedi_devconfig *it)
 {
+	struct pci_dev *pcidev;
 	struct comedi_subdevice *s;
 	int ret, pages, i;
 	unsigned short master;
@@ -2170,16 +2170,17 @@ static int pci9118_attach(struct comedi_device *dev,
 		return -ENOMEM;
 	}
 
-	devpriv->pcidev = pci9118_find_pci(dev, it);
-	if (!devpriv->pcidev)
+	pcidev = pci9118_find_pci(dev, it);
+	if (!pcidev)
 		return -EIO;
+	comedi_set_hw_dev(dev, &pcidev->dev);
 
 	if (master)
-		pci_set_master(devpriv->pcidev);
+		pci_set_master(pcidev);
 
-	irq = devpriv->pcidev->irq;
-	devpriv->iobase_a = pci_resource_start(devpriv->pcidev, 0);
-	dev->iobase = pci_resource_start(devpriv->pcidev, 2);
+	irq = pcidev->irq;
+	devpriv->iobase_a = pci_resource_start(pcidev, 0);
+	dev->iobase = pci_resource_start(pcidev, 2);
 
 	dev->board_name = this_board->name;
 
@@ -2264,8 +2265,8 @@ static int pci9118_attach(struct comedi_device *dev,
 
 	printk(".\n");
 
-	pci_read_config_word(devpriv->pcidev, PCI_COMMAND, &u16w);
-	pci_write_config_word(devpriv->pcidev, PCI_COMMAND, u16w | 64);
+	pci_read_config_word(pcidev, PCI_COMMAND, &u16w);
+	pci_write_config_word(pcidev, PCI_COMMAND, u16w | 64);
 				/* Enable parity check for parity error */
 
 	ret = comedi_alloc_subdevices(dev, 4);
@@ -2343,17 +2344,13 @@ static int pci9118_attach(struct comedi_device *dev,
 
 static void pci9118_detach(struct comedi_device *dev)
 {
+	struct pci_dev *pcidev = comedi_to_pci_dev(dev);
+
 	if (dev->private) {
 		if (devpriv->valid)
 			pci9118_reset(dev);
 		if (dev->irq)
 			free_irq(dev->irq, dev);
-		if (devpriv->pcidev) {
-			if (dev->iobase)
-				comedi_pci_disable(devpriv->pcidev);
-
-			pci_dev_put(devpriv->pcidev);
-		}
 		if (devpriv->dmabuf_virt[0])
 			free_pages((unsigned long)devpriv->dmabuf_virt[0],
 				   devpriv->dmabuf_pages[0]);
@@ -2361,6 +2358,12 @@ static void pci9118_detach(struct comedi_device *dev)
 			free_pages((unsigned long)devpriv->dmabuf_virt[1],
 				   devpriv->dmabuf_pages[1]);
 	}
+	if (pcidev) {
+		if (dev->iobase)
+			comedi_pci_disable(pcidev);
+
+		pci_dev_put(pcidev);
+	}
 }
 
 static const struct boardtype boardtypes[] = {
-- 
1.7.11

