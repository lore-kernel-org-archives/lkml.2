Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444Ab2GSBkP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 21:40:15 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:24154 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772Ab2GSBkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 21:40:12 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-12.tower-160.messagelabs.com!1342662010!10060422!1
X-Originating-IP: [216.166.12.99]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 34/90] staging: comedi: amplc_pc263: store the pci_dev in the comedi_device
Date: Wed, 18 Jul 2012 18:40:01 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207181840.01906.hartleys@visionengravers.com>
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

Since the pci_dev was the only thing in the private data, remove
the struct, and it's allocation.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/amplc_pc263.c | 40 +++++++---------------------
 1 file changed, 9 insertions(+), 31 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pc263.c b/drivers/staging/comedi/drivers/amplc_pc263.c
index 8ed8601..40ec1ff 100644
--- a/drivers/staging/comedi/drivers/amplc_pc263.c
+++ b/drivers/staging/comedi/drivers/amplc_pc263.c
@@ -93,15 +93,6 @@ static const struct pc263_board pc263_boards[] = {
 #endif
 };
 
-/* this structure is for data unique to this hardware driver.  If
-   several hardware drivers keep similar information in this structure,
-   feel free to suggest moving the variable to the struct comedi_device struct.
-*/
-struct pc263_private {
-	/* PCI device. */
-	struct pci_dev *pci_dev;
-};
-
 /*
  * This function looks for a board matching the supplied PCI device.
  */
@@ -193,7 +184,7 @@ static int pc263_do_insn_bits(struct comedi_device *dev,
 static void pc263_report_attach(struct comedi_device *dev)
 {
 	const struct pc263_board *thisboard = comedi_board(dev);
-	struct pc263_private *devpriv = dev->private;
+	struct pci_dev *pcidev = comedi_to_pci_dev(dev);
 	char tmpbuf[40];
 
 	if (IS_ENABLED(CONFIG_COMEDI_AMPLC_PC263_ISA) &&
@@ -202,7 +193,7 @@ static void pc263_report_attach(struct comedi_device *dev)
 	else if (IS_ENABLED(CONFIG_COMEDI_AMPLC_PC263_PCI) &&
 		 thisboard->bustype == pci_bustype)
 		snprintf(tmpbuf, sizeof(tmpbuf), "(pci %s) ",
-			 pci_name(devpriv->pci_dev));
+			 pci_name(pcidev));
 	else
 		tmpbuf[0] = '\0';
 	dev_info(dev->class_dev, "%s %sattached\n", dev->board_name, tmpbuf);
@@ -239,11 +230,11 @@ static int pc263_common_attach(struct comedi_device *dev, unsigned long iobase)
 static int pc263_pci_common_attach(struct comedi_device *dev,
 				   struct pci_dev *pci_dev)
 {
-	struct pc263_private *devpriv = dev->private;
 	unsigned long iobase;
 	int ret;
 
-	devpriv->pci_dev = pci_dev;
+	comedi_set_hw_dev(dev, &pci_dev->dev);
+
 	ret = comedi_pci_enable(pci_dev, PC263_DRIVER_NAME);
 	if (ret < 0) {
 		dev_err(dev->class_dev,
@@ -279,11 +270,6 @@ static int pc263_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		   thisboard->bustype == pci_bustype) {
 		struct pci_dev *pci_dev;
 
-		ret = alloc_private(dev, sizeof(struct pc263_private));
-		if (ret < 0) {
-			dev_err(dev->class_dev, "error! out of memory!\n");
-			return ret;
-		}
 		pci_dev = pc263_find_pci_dev(dev, it);
 		if (!pci_dev)
 			return -EIO;
@@ -302,18 +288,11 @@ static int pc263_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 static int __devinit pc263_attach_pci(struct comedi_device *dev,
 				      struct pci_dev *pci_dev)
 {
-	int ret;
-
 	if (!IS_ENABLED(CONFIG_COMEDI_AMPLC_PC263_PCI))
 		return -EINVAL;
 
 	dev_info(dev->class_dev, PC263_DRIVER_NAME ": attach pci %s\n",
 		 pci_name(pci_dev));
-	ret = alloc_private(dev, sizeof(struct pc263_private));
-	if (ret < 0) {
-		dev_err(dev->class_dev, "error! out of memory!\n");
-		return ret;
-	}
 	dev->board_ptr = pc263_find_pci_board(pci_dev);
 	if (dev->board_ptr == NULL) {
 		dev_err(dev->class_dev, "BUG! cannot determine board type!\n");
@@ -324,14 +303,13 @@ static int __devinit pc263_attach_pci(struct comedi_device *dev,
 
 static void pc263_detach(struct comedi_device *dev)
 {
-	struct pc263_private *devpriv = dev->private;
+	struct pci_dev *pcidev = comedi_to_pci_dev(dev);
 
-	if (IS_ENABLED(CONFIG_COMEDI_AMPLC_PC263_PCI) && devpriv &&
-	    devpriv->pci_dev) {
+	if (pcidev) {
 		if (dev->iobase)
-			comedi_pci_disable(devpriv->pci_dev);
-		pci_dev_put(devpriv->pci_dev);
-	} else if (IS_ENABLED(CONFIG_COMEDI_AMPLC_PC263_ISA)) {
+			comedi_pci_disable(pcidev);
+		pci_dev_put(pcidev);
+	} else {
 		if (dev->iobase)
 			release_region(dev->iobase, PC263_IO_SIZE);
 	}
-- 
1.7.11

