Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030439Ab2GKW3f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 18:29:35 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:64579 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753638Ab2GKW3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 18:29:33 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-3.tower-160.messagelabs.com!1342045768!9397447!5
X-Originating-IP: [216.166.12.178]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 19/30] staging: comedi: contec_pci_dio: factor out the "find pci device" code
Date: Wed, 11 Jul 2012 15:29:25 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207111529.25773.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor the "find pci device" code out of the attach function.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/contec_pci_dio.c | 91 +++++++++++++------------
 1 file changed, 49 insertions(+), 42 deletions(-)

diff --git a/drivers/staging/comedi/drivers/contec_pci_dio.c b/drivers/staging/comedi/drivers/contec_pci_dio.c
index ee769e0..b7313be 100644
--- a/drivers/staging/comedi/drivers/contec_pci_dio.c
+++ b/drivers/staging/comedi/drivers/contec_pci_dio.c
@@ -97,22 +97,10 @@ static int contec_di_insn_bits(struct comedi_device *dev,
 	return insn->n;
 }
 
-static int contec_attach(struct comedi_device *dev, struct comedi_devconfig *it)
+static struct pci_dev *contec_find_pci_dev(struct comedi_device *dev,
+					   struct comedi_devconfig *it)
 {
 	struct pci_dev *pcidev = NULL;
-	struct comedi_subdevice *s;
-	int ret;
-
-	printk("comedi%d: contec: ", dev->minor);
-
-	dev->board_name = thisboard->name;
-
-	if (alloc_private(dev, sizeof(struct contec_private)) < 0)
-		return -ENOMEM;
-
-	ret = comedi_alloc_subdevices(dev, 2);
-	if (ret)
-		return ret;
 
 	for_each_pci_dev(pcidev) {
 		if (pcidev->vendor == PCI_VENDOR_ID_CONTEC &&
@@ -124,43 +112,62 @@ static int contec_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 					continue;
 				}
 			}
-			devpriv->pci_dev = pcidev;
-			if (comedi_pci_enable(pcidev, "contec_pci_dio")) {
-				printk
-				    ("error enabling PCI device and request regions!\n");
-				return -EIO;
-			}
-			dev->iobase = pci_resource_start(pcidev, 0);
-			printk(" base addr %lx ", dev->iobase);
-
 			dev->board_ptr = contec_boards + 0;
+			return pcidev;
+		}
+	}
+	printk("card not present!\n");
+	return NULL;
+}
 
-			s = dev->subdevices + 0;
+static int contec_attach(struct comedi_device *dev, struct comedi_devconfig *it)
+{
+	struct comedi_subdevice *s;
+	int ret;
 
-			s->type = COMEDI_SUBD_DI;
-			s->subdev_flags = SDF_READABLE;
-			s->n_chan = 16;
-			s->maxdata = 1;
-			s->range_table = &range_digital;
-			s->insn_bits = contec_di_insn_bits;
+	printk("comedi%d: contec: ", dev->minor);
 
-			s = dev->subdevices + 1;
-			s->type = COMEDI_SUBD_DO;
-			s->subdev_flags = SDF_WRITABLE;
-			s->n_chan = 16;
-			s->maxdata = 1;
-			s->range_table = &range_digital;
-			s->insn_bits = contec_do_insn_bits;
+	if (alloc_private(dev, sizeof(struct contec_private)) < 0)
+		return -ENOMEM;
 
-			printk("attached\n");
+	ret = comedi_alloc_subdevices(dev, 2);
+	if (ret)
+		return ret;
 
-			return 1;
-		}
+	devpriv->pci_dev = contec_find_pci_dev(dev, it);
+	if (!devpriv->pci_dev)
+		return -EIO;
+
+	dev->board_name = thisboard->name;
+
+	if (comedi_pci_enable(devpriv->pci_dev, "contec_pci_dio")) {
+		printk("error enabling PCI device and request regions!\n");
+		return -EIO;
 	}
 
-	printk("card not present!\n");
+	dev->iobase = pci_resource_start(devpriv->pci_dev, 0);
+	printk(" base addr %lx ", dev->iobase);
+
+	s = dev->subdevices + 0;
+
+	s->type = COMEDI_SUBD_DI;
+	s->subdev_flags = SDF_READABLE;
+	s->n_chan = 16;
+	s->maxdata = 1;
+	s->range_table = &range_digital;
+	s->insn_bits = contec_di_insn_bits;
+
+	s = dev->subdevices + 1;
+	s->type = COMEDI_SUBD_DO;
+	s->subdev_flags = SDF_WRITABLE;
+	s->n_chan = 16;
+	s->maxdata = 1;
+	s->range_table = &range_digital;
+	s->insn_bits = contec_do_insn_bits;
+
+	printk("attached\n");
 
-	return -EIO;
+	return 1;
 }
 
 static void contec_detach(struct comedi_device *dev)
-- 
1.7.11

