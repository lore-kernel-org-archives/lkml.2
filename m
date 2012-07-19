Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562Ab2GSBpN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 21:45:13 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:8942 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526Ab2GSBpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 21:45:09 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-5.tower-127.messagelabs.com!1342662306!9016822!2
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 45/90] staging: comedi: cb_pcidio: store the iobase in the comedi_device
Date: Wed, 18 Jul 2012 18:45:04 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207181845.04482.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Save the pci bar in dev->iobase instead of carrying it in the
private data.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_pcidio.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidio.c b/drivers/staging/comedi/drivers/cb_pcidio.c
index 11c7502..f30f6da 100644
--- a/drivers/staging/comedi/drivers/cb_pcidio.c
+++ b/drivers/staging/comedi/drivers/cb_pcidio.c
@@ -99,7 +99,6 @@ struct pcidio_private {
 	/* used for DO readback, currently unused */
 	unsigned int do_readback[4];	/* up to 4 unsigned int suffice to hold 96 bits for PCI-DIO96 */
 
-	unsigned long dio_reg_base;	/*  address of port A of the first 8255 chip on board */
 };
 
 /*
@@ -165,9 +164,7 @@ static int pcidio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (comedi_pci_enable(pcidev, thisboard->name))
 		return -EIO;
 
-	devpriv->dio_reg_base
-	    =
-	    pci_resource_start(pcidev, thisboard->dioregs_badrindex);
+	dev->iobase = pci_resource_start(pcidev, thisboard->dioregs_badrindex);
 
 	ret = comedi_alloc_subdevices(dev, thisboard->n_8255);
 	if (ret)
@@ -175,9 +172,9 @@ static int pcidio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	for (i = 0; i < thisboard->n_8255; i++) {
 		subdev_8255_init(dev, dev->subdevices + i,
-				 NULL, devpriv->dio_reg_base + i * 4);
+				 NULL, dev->iobase + i * 4);
 		dev_dbg(dev->class_dev, "subdev %d: base = 0x%lx\n", i,
-			devpriv->dio_reg_base + i * 4);
+			dev->iobase + i * 4);
 	}
 
 	return 1;
@@ -188,7 +185,7 @@ static void pcidio_detach(struct comedi_device *dev)
 	struct pci_dev *pcidev = comedi_to_pci_dev(dev);
 
 	if (pcidev) {
-		if (devpriv->dio_reg_base)
+		if (dev->iobase)
 			comedi_pci_disable(pcidev);
 		pci_dev_put(pcidev);
 	}
-- 
1.7.11

