Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030424Ab2GKW2g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 18:28:36 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:14931 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755664Ab2GKW2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 18:28:34 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-9.tower-160.messagelabs.com!1342045672!9323105!26
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 17/30] staging: comedi: cb_pcidio: use comedi_device iobase
Date: Wed, 11 Jul 2012 15:28:11 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207111528.12247.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the iobase in the comedi_device struct instead of carrying it
in the private data.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_pcidio.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidio.c b/drivers/staging/comedi/drivers/cb_pcidio.c
index a21ae2b..cab96b0 100644
--- a/drivers/staging/comedi/drivers/cb_pcidio.c
+++ b/drivers/staging/comedi/drivers/cb_pcidio.c
@@ -98,8 +98,6 @@ struct pcidio_private {
 
 	/* used for DO readback, currently unused */
 	unsigned int do_readback[4];	/* up to 4 unsigned int suffice to hold 96 bits for PCI-DIO96 */
-
-	unsigned long dio_reg_base;	/*  address of port A of the first 8255 chip on board */
 };
 
 /*
@@ -162,10 +160,8 @@ static int pcidio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (comedi_pci_enable(dev->pcidev, thisboard->name))
 		return -EIO;
 
-	devpriv->dio_reg_base
-	    =
-	    pci_resource_start(dev->pcidev,
-			       thisboard->dioregs_badrindex);
+	dev->iobase = pci_resource_start(dev->pcidev,
+					 thisboard->dioregs_badrindex);
 
 	ret = comedi_alloc_subdevices(dev, thisboard->n_8255);
 	if (ret)
@@ -173,9 +169,9 @@ static int pcidio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	for (i = 0; i < thisboard->n_8255; i++) {
 		subdev_8255_init(dev, dev->subdevices + i,
-				 NULL, devpriv->dio_reg_base + i * 4);
+				 NULL, dev->iobase + i * 4);
 		dev_dbg(dev->class_dev, "subdev %d: base = 0x%lx\n", i,
-			devpriv->dio_reg_base + i * 4);
+			dev->iobase + i * 4);
 	}
 
 	return 1;
@@ -184,7 +180,7 @@ static int pcidio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 static void pcidio_detach(struct comedi_device *dev)
 {
 	if (dev->pcidev) {
-		if (devpriv && devpriv->dio_reg_base)
+		if (dev->iobase)
 			comedi_pci_disable(dev->pcidev);
 		pci_dev_put(dev->pcidev);
 	}
-- 
1.7.11

