Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465Ab2GSBlY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 21:41:24 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:25419 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755091Ab2GSBlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 21:41:20 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-6.tower-160.messagelabs.com!1342662079!10092035!1
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 36/90] staging: comedi: amplc_pci224: store the pci_dev in the comedi_device
Date: Wed, 18 Jul 2012 18:41:09 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207181841.09424.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the hw_dev pointer in the comedi_device struct to hold the
pci_dev instead of carrying it in the private data.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/amplc_pci224.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci224.c b/drivers/staging/comedi/drivers/amplc_pci224.c
index d489367..4e17f13 100644
--- a/drivers/staging/comedi/drivers/amplc_pci224.c
+++ b/drivers/staging/comedi/drivers/amplc_pci224.c
@@ -378,7 +378,6 @@ static const struct pci224_board pci224_boards[] = {
    several hardware drivers keep similar information in this structure,
    feel free to suggest moving the variable to the struct comedi_device struct.  */
 struct pci224_private {
-	struct pci_dev *pci_dev;	/* PCI device */
 	const unsigned short *hwrange;
 	unsigned long iobase1;
 	unsigned long state;
@@ -1297,7 +1296,7 @@ static struct pci_dev *pci224_find_pci_dev(struct comedi_device *dev,
 
 static void pci224_report_attach(struct comedi_device *dev, unsigned int irq)
 {
-	struct pci224_private *devpriv = dev->private;
+	struct pci_dev *pcidev = comedi_to_pci_dev(dev);
 	char tmpbuf[30];
 
 	if (irq)
@@ -1306,7 +1305,7 @@ static void pci224_report_attach(struct comedi_device *dev, unsigned int irq)
 	else
 		snprintf(tmpbuf, sizeof(tmpbuf), "no irq");
 	dev_info(dev->class_dev, "%s (pci %s) (%s) attached\n",
-		 dev->board_name, pci_name(devpriv->pci_dev), tmpbuf);
+		 dev->board_name, pci_name(pcidev), tmpbuf);
 }
 
 /*
@@ -1322,7 +1321,8 @@ static int pci224_attach_common(struct comedi_device *dev,
 	unsigned n;
 	int ret;
 
-	devpriv->pci_dev = pci_dev;
+	comedi_set_hw_dev(dev, &pci_dev->dev);
+
 	ret = comedi_pci_enable(pci_dev, DRIVER_NAME);
 	if (ret < 0) {
 		dev_err(dev->class_dev,
@@ -1509,6 +1509,7 @@ pci224_attach_pci(struct comedi_device *dev, struct pci_dev *pci_dev)
 static void pci224_detach(struct comedi_device *dev)
 {
 	struct pci224_private *devpriv = dev->private;
+	struct pci_dev *pcidev = comedi_to_pci_dev(dev);
 
 	if (dev->irq)
 		free_irq(dev->irq, dev);
@@ -1523,11 +1524,11 @@ static void pci224_detach(struct comedi_device *dev)
 		kfree(devpriv->ao_readback);
 		kfree(devpriv->ao_scan_vals);
 		kfree(devpriv->ao_scan_order);
-		if (devpriv->pci_dev) {
-			if (dev->iobase)
-				comedi_pci_disable(devpriv->pci_dev);
-			pci_dev_put(devpriv->pci_dev);
-		}
+	}
+	if (pcidev) {
+		if (dev->iobase)
+			comedi_pci_disable(pcidev);
+		pci_dev_put(pcidev);
 	}
 }
 
-- 
1.7.11

