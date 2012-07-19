Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313Ab2GSBh7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 21:37:59 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:21844 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652Ab2GSBh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 21:37:56 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-2.tower-209.messagelabs.com!1342661875!9070776!1
X-Originating-IP: [216.166.12.99]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 30/90] staging: comedi: amplc_dio200: store the pci_dev in the comedi_device
Date: Wed, 18 Jul 2012 18:37:50 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207181837.50650.hartleys@visionengravers.com>
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
 drivers/staging/comedi/drivers/amplc_dio200.c | 31 +++++++++++----------------
 1 file changed, 12 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_dio200.c b/drivers/staging/comedi/drivers/amplc_dio200.c
index ca9d4f2..6c81e377 100644
--- a/drivers/staging/comedi/drivers/amplc_dio200.c
+++ b/drivers/staging/comedi/drivers/amplc_dio200.c
@@ -424,7 +424,6 @@ static const struct dio200_layout_struct dio200_layouts[] = {
    feel free to suggest moving the variable to the struct comedi_device struct.
  */
 struct dio200_private {
-	struct pci_dev *pci_dev;	/* PCI device */
 	int intr_sd;
 };
 
@@ -1225,7 +1224,7 @@ dio200_subdev_8254_cleanup(struct comedi_device *dev,
 static void dio200_report_attach(struct comedi_device *dev, unsigned int irq)
 {
 	const struct dio200_board *thisboard = comedi_board(dev);
-	struct dio200_private *devpriv = dev->private;
+	struct pci_dev *pcidev = comedi_to_pci_dev(dev);
 	char tmpbuf[60];
 	int tmplen;
 
@@ -1236,7 +1235,7 @@ static void dio200_report_attach(struct comedi_device *dev, unsigned int irq)
 	else if (IS_ENABLED(CONFIG_COMEDI_AMPLC_DIO200_PCI) &&
 		 thisboard->bustype == pci_bustype)
 		tmplen = scnprintf(tmpbuf, sizeof(tmpbuf),
-				   "(pci %s) ", pci_name(devpriv->pci_dev));
+				   "(pci %s) ", pci_name(pcidev));
 	else
 		tmplen = 0;
 	if (irq)
@@ -1327,11 +1326,11 @@ static int dio200_common_attach(struct comedi_device *dev, unsigned long iobase,
 static int dio200_pci_common_attach(struct comedi_device *dev,
 				    struct pci_dev *pci_dev)
 {
-	struct dio200_private *devpriv = dev->private;
 	unsigned long iobase;
 	int ret;
 
-	devpriv->pci_dev = pci_dev;
+	comedi_set_hw_dev(dev, &pci_dev->dev);
+
 	ret = comedi_pci_enable(pci_dev, DIO200_DRIVER_NAME);
 	if (ret < 0) {
 		dev_err(dev->class_dev,
@@ -1419,7 +1418,7 @@ static int __devinit dio200_attach_pci(struct comedi_device *dev,
 static void dio200_detach(struct comedi_device *dev)
 {
 	const struct dio200_board *thisboard = comedi_board(dev);
-	struct dio200_private *devpriv = dev->private;
+	struct pci_dev *pcidev = comedi_to_pci_dev(dev);
 	const struct dio200_layout_struct *layout;
 	unsigned n;
 
@@ -1444,19 +1443,13 @@ static void dio200_detach(struct comedi_device *dev)
 			}
 		}
 	}
-	if (devpriv) {
-		if (IS_ENABLED(CONFIG_COMEDI_AMPLC_DIO200_PCI) &&
-		    thisboard->bustype == pci_bustype) {
-			if (devpriv->pci_dev) {
-				if (dev->iobase)
-					comedi_pci_disable(devpriv->pci_dev);
-				pci_dev_put(devpriv->pci_dev);
-			}
-		} else if (IS_ENABLED(CONFIG_COMEDI_AMPLC_DIO200_ISA) &&
-			   thisboard->bustype == isa_bustype) {
-			if (dev->iobase)
-				release_region(dev->iobase, DIO200_IO_SIZE);
-		}
+	if (pcidev) {
+		if (dev->iobase)
+			comedi_pci_disable(pcidev);
+		pci_dev_put(pcidev);
+	} else {
+		if (dev->iobase)
+			release_region(dev->iobase, DIO200_IO_SIZE);
 	}
 }
 
-- 
1.7.11

