Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885Ab2GSBoy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 21:44:54 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:5804 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754963Ab2GSBov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 21:44:51 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-8.tower-127.messagelabs.com!1342662287!4457678!5
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 44/90] staging: comedi: cb_pcidda: store the pci_dev in the comedi_device
Date: Wed, 18 Jul 2012 18:44:43 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207181844.43629.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the hw_dev pointer in the comedi_device struct to hold the
pci_dev instead of carrying it in the private data.

Save the pci bar in dev->iobase so the detach is consistent with
the other comedi pci drivers.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_pcidda.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidda.c b/drivers/staging/comedi/drivers/cb_pcidda.c
index 3567f4a..12660a3 100644
--- a/drivers/staging/comedi/drivers/cb_pcidda.c
+++ b/drivers/staging/comedi/drivers/cb_pcidda.c
@@ -216,9 +216,6 @@ static const struct cb_pcidda_board cb_pcidda_boards[] = {
 struct cb_pcidda_private {
 	int data;
 
-	/* would be useful for a PCI device */
-	struct pci_dev *pci_dev;
-
 	unsigned long digitalio;
 	unsigned long dac;
 
@@ -306,7 +303,7 @@ static int cb_pcidda_attach(struct comedi_device *dev,
 	pcidev = cb_pcidda_find_pci_dev(dev, it);
 	if (!pcidev)
 		return -EIO;
-	devpriv->pci_dev = pcidev;
+	comedi_set_hw_dev(dev, &pcidev->dev);
 
 	/*
 	 * Enable PCI device and request regions.
@@ -320,9 +317,9 @@ static int cb_pcidda_attach(struct comedi_device *dev,
 /*
  * Allocate the I/O ports.
  */
-	devpriv->digitalio =
-	    pci_resource_start(devpriv->pci_dev, DIGITALIO_BADRINDEX);
-	devpriv->dac = pci_resource_start(devpriv->pci_dev, DAC_BADRINDEX);
+	devpriv->digitalio = pci_resource_start(pcidev, DIGITALIO_BADRINDEX);
+	devpriv->dac = pci_resource_start(pcidev, DAC_BADRINDEX);
+	dev->iobase = devpriv->dac;
 
 /*
  * Warn about the status of the driver.
@@ -377,12 +374,12 @@ static int cb_pcidda_attach(struct comedi_device *dev,
 
 static void cb_pcidda_detach(struct comedi_device *dev)
 {
-	if (devpriv) {
-		if (devpriv->pci_dev) {
-			if (devpriv->dac)
-				comedi_pci_disable(devpriv->pci_dev);
-			pci_dev_put(devpriv->pci_dev);
-		}
+	struct pci_dev *pcidev = comedi_to_pci_dev(dev);
+
+	if (pcidev) {
+		if (dev->iobase)
+			comedi_pci_disable(pcidev);
+		pci_dev_put(pcidev);
 	}
 	if (dev->subdevices) {
 		subdev_8255_cleanup(dev, dev->subdevices + 1);
-- 
1.7.11

