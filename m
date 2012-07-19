Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343Ab2GSBaG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 21:30:06 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:5172 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab2GSBaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 21:30:01 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-9.tower-160.messagelabs.com!1342661400!10003346!2
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 13/90] staging: comedi: adv_pci1723: factor out the "find pci device" code
Date: Wed, 18 Jul 2012 18:29:54 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207181829.54661.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor the "find pci device" code out of the attach function.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/adv_pci1723.c | 42 +++++++++++++++++-----------
 1 file changed, 26 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adv_pci1723.c b/drivers/staging/comedi/drivers/adv_pci1723.c
index 5c99c74..4803a8c 100644
--- a/drivers/staging/comedi/drivers/adv_pci1723.c
+++ b/drivers/staging/comedi/drivers/adv_pci1723.c
@@ -287,29 +287,18 @@ static int pci1723_dio_insn_bits(struct comedi_device *dev,
 	return insn->n;
 }
 
-static int pci1723_attach(struct comedi_device *dev,
-			  struct comedi_devconfig *it)
+static struct pci_dev *pci1723_find_pci_dev(struct comedi_device *dev,
+					    struct comedi_devconfig *it)
 {
-	struct comedi_subdevice *s;
-	int ret, subdev, n_subdevices;
 	struct pci_dev *pcidev;
 	unsigned int iobase;
 	unsigned char pci_bus, pci_slot, pci_func;
 	int opt_bus, opt_slot;
 	const char *errstr;
 
-	printk(KERN_ERR "comedi%d: adv_pci1723: board=%s",
-						dev->minor, this_board->name);
-
 	opt_bus = it->options[0];
 	opt_slot = it->options[1];
 
-	ret = alloc_private(dev, sizeof(struct pci1723_private));
-	if (ret < 0) {
-		printk(" - Allocation failed!\n");
-		return -ENOMEM;
-	}
-
 	/* Look for matching PCI device */
 	errstr = "not found!";
 	pcidev = NULL;
@@ -342,7 +331,7 @@ static int pci1723_attach(struct comedi_device *dev,
 		} else {
 			printk(KERN_ERR " - Card %s\n", errstr);
 		}
-		return -EIO;
+		return NULL;
 	}
 
 	pci_bus = pcidev->bus->number;
@@ -353,10 +342,31 @@ static int pci1723_attach(struct comedi_device *dev,
 	printk(KERN_ERR ", b:s:f=%d:%d:%d, io=0x%4x",
 					   pci_bus, pci_slot, pci_func, iobase);
 
-	dev->iobase = iobase;
+	return pcidev;
+}
+
+static int pci1723_attach(struct comedi_device *dev,
+			  struct comedi_devconfig *it)
+{
+	struct comedi_subdevice *s;
+	int ret, subdev, n_subdevices;
+
+	printk(KERN_ERR "comedi%d: adv_pci1723: board=%s",
+						dev->minor, this_board->name);
+
+	ret = alloc_private(dev, sizeof(struct pci1723_private));
+	if (ret < 0) {
+		printk(" - Allocation failed!\n");
+		return -ENOMEM;
+	}
+
+	devpriv->pcidev = pci1723_find_pci_dev(dev, it);
+	if (!devpriv->pcidev)
+		return -EIO;
+
+	dev->iobase = pci_resource_start(devpriv->pcidev, 2);
 
 	dev->board_name = this_board->name;
-	devpriv->pcidev = pcidev;
 
 	n_subdevices = 0;
 
-- 
1.7.11

