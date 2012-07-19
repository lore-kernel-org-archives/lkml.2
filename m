Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755051Ab2GSBfr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 21:35:47 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:31571 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754738Ab2GSBfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 21:35:44 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-3.tower-127.messagelabs.com!1342661743!9008717!1
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 25/90] staging: comedi: cb_pcidas: store the pci_dev in the comedi_device
Date: Wed, 18 Jul 2012 18:35:38 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207181835.38606.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the hw_dev pointer in the comedi_device struct to hold the
pci_dev instead of carrying it in the private data.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_pcidas.c | 32 ++++++++++++++++--------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas.c b/drivers/staging/comedi/drivers/cb_pcidas.c
index 301444e..2b6a637 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas.c
@@ -343,7 +343,6 @@ static const struct cb_pcidas_board cb_pcidas_boards[] = {
 };
 
 struct cb_pcidas_private {
-	struct pci_dev *pci_dev;
 	/* base addresses */
 	unsigned long s5933_config;
 	unsigned long control_status;
@@ -1545,6 +1544,7 @@ static int cb_pcidas_attach(struct comedi_device *dev,
 {
 	const struct cb_pcidas_board *thisboard;
 	struct cb_pcidas_private *devpriv;
+	struct pci_dev *pcidev;
 	struct comedi_subdevice *s;
 	int i;
 	int ret;
@@ -1553,35 +1553,36 @@ static int cb_pcidas_attach(struct comedi_device *dev,
 		return -ENOMEM;
 	devpriv = dev->private;
 
-	devpriv->pci_dev = cb_pcidas_find_pci_device(dev, it);
-	if (!devpriv->pci_dev)
+	pcidev = cb_pcidas_find_pci_device(dev, it);
+	if (!pcidev)
 		return -EIO;
+	comedi_set_hw_dev(dev, &pcidev->dev);
 	thisboard = comedi_board(dev);
 
-	if (comedi_pci_enable(devpriv->pci_dev, dev->driver->driver_name)) {
+	if (comedi_pci_enable(pcidev, dev->driver->driver_name)) {
 		dev_err(dev->class_dev,
 			"Failed to enable PCI device and request regions\n");
 		return -EIO;
 	}
 
-	devpriv->s5933_config = pci_resource_start(devpriv->pci_dev, 0);
-	devpriv->control_status = pci_resource_start(devpriv->pci_dev, 1);
-	devpriv->adc_fifo = pci_resource_start(devpriv->pci_dev, 2);
-	devpriv->pacer_counter_dio = pci_resource_start(devpriv->pci_dev, 3);
+	devpriv->s5933_config = pci_resource_start(pcidev, 0);
+	devpriv->control_status = pci_resource_start(pcidev, 1);
+	devpriv->adc_fifo = pci_resource_start(pcidev, 2);
+	devpriv->pacer_counter_dio = pci_resource_start(pcidev, 3);
 	if (thisboard->ao_nchan)
-		devpriv->ao_registers = pci_resource_start(devpriv->pci_dev, 4);
+		devpriv->ao_registers = pci_resource_start(pcidev, 4);
 
 	/*  disable and clear interrupts on amcc s5933 */
 	outl(INTCSR_INBOX_INTR_STATUS,
 	     devpriv->s5933_config + AMCC_OP_REG_INTCSR);
 
-	if (request_irq(devpriv->pci_dev->irq, cb_pcidas_interrupt,
+	if (request_irq(pcidev->irq, cb_pcidas_interrupt,
 			IRQF_SHARED, dev->driver->driver_name, dev)) {
 		dev_dbg(dev->class_dev, "unable to allocate irq %d\n",
-			devpriv->pci_dev->irq);
+			pcidev->irq);
 		return -EINVAL;
 	}
-	dev->irq = devpriv->pci_dev->irq;
+	dev->irq = pcidev->irq;
 
 	dev->board_name = thisboard->name;
 
@@ -1703,6 +1704,7 @@ static int cb_pcidas_attach(struct comedi_device *dev,
 static void cb_pcidas_detach(struct comedi_device *dev)
 {
 	struct cb_pcidas_private *devpriv = dev->private;
+	struct pci_dev *pcidev = comedi_to_pci_dev(dev);
 
 	if (devpriv) {
 		if (devpriv->s5933_config) {
@@ -1714,10 +1716,10 @@ static void cb_pcidas_detach(struct comedi_device *dev)
 		free_irq(dev->irq, dev);
 	if (dev->subdevices)
 		subdev_8255_cleanup(dev, dev->subdevices + 2);
-	if (devpriv && devpriv->pci_dev) {
+	if (pcidev) {
 		if (devpriv->s5933_config)
-			comedi_pci_disable(devpriv->pci_dev);
-		pci_dev_put(devpriv->pci_dev);
+			comedi_pci_disable(pcidev);
+		pci_dev_put(pcidev);
 	}
 }
 
-- 
1.7.11

