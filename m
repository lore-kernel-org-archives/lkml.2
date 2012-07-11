Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933430Ab2GKWZY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 18:25:24 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:30739 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932159Ab2GKWZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 18:25:21 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-5.tower-127.messagelabs.com!1342045520!8353389!1
X-Originating-IP: [216.166.12.69]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 12/30] staging: comedi: adl_pci9118: use comedi_device pci_dev pointer
Date: Wed, 11 Jul 2012 15:25:07 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207111525.07656.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the pci_dev pointer in the comedi_device struct instead of
carrying it in the private data.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/adl_pci9118.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci9118.c b/drivers/staging/comedi/drivers/adl_pci9118.c
index 4482aab..deda411 100644
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
@@ -2170,16 +2169,16 @@ static int pci9118_attach(struct comedi_device *dev,
 		return -ENOMEM;
 	}
 
-	devpriv->pcidev = pci9118_find_pci(dev, it);
-	if (!devpriv->pcidev)
+	dev->pcidev = pci9118_find_pci(dev, it);
+	if (!dev->pcidev)
 		return -EIO;
 
 	if (master)
-		pci_set_master(devpriv->pcidev);
+		pci_set_master(dev->pcidev);
 
-	irq = devpriv->pcidev->irq;
-	devpriv->iobase_a = pci_resource_start(devpriv->pcidev, 0);
-	dev->iobase = pci_resource_start(devpriv->pcidev, 2);
+	irq = dev->pcidev->irq;
+	devpriv->iobase_a = pci_resource_start(dev->pcidev, 0);
+	dev->iobase = pci_resource_start(dev->pcidev, 2);
 
 	dev->board_name = this_board->name;
 
@@ -2264,8 +2263,8 @@ static int pci9118_attach(struct comedi_device *dev,
 
 	printk(".\n");
 
-	pci_read_config_word(devpriv->pcidev, PCI_COMMAND, &u16w);
-	pci_write_config_word(devpriv->pcidev, PCI_COMMAND, u16w | 64);
+	pci_read_config_word(dev->pcidev, PCI_COMMAND, &u16w);
+	pci_write_config_word(dev->pcidev, PCI_COMMAND, u16w | 64);
 				/* Enable parity check for parity error */
 
 	ret = comedi_alloc_subdevices(dev, 4);
@@ -2348,11 +2347,11 @@ static void pci9118_detach(struct comedi_device *dev)
 			pci9118_reset(dev);
 		if (dev->irq)
 			free_irq(dev->irq, dev);
-		if (devpriv->pcidev) {
+		if (dev->pcidev) {
 			if (dev->iobase)
-				comedi_pci_disable(devpriv->pcidev);
+				comedi_pci_disable(dev->pcidev);
 
-			pci_dev_put(devpriv->pcidev);
+			pci_dev_put(dev->pcidev);
 		}
 		if (devpriv->dmabuf_virt[0])
 			free_pages((unsigned long)devpriv->dmabuf_virt[0],
-- 
1.7.11

