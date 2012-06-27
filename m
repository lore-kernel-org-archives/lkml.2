Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932302Ab2F0V6P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 17:58:15 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:28000 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932172Ab2F0V6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 17:58:12 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-5.tower-209.messagelabs.com!1340834291!7120655!1
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 06/19] staging: comedi: adl_pci6208: remove pci6208_pci_setup()
Date: Wed, 27 Jun 2012 14:58:03 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206271458.04182.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refactor pci6208_pci_setup() into the attach function. This
function simply enables the pci device and gets the PCI iobase
address used by the driver. There's no need for a separate
function to handle this.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/adl_pci6208.c | 34 ++++++----------------------
 1 file changed, 7 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci6208.c b/drivers/staging/comedi/drivers/adl_pci6208.c
index a96fac4..e2ca685 100644
--- a/drivers/staging/comedi/drivers/adl_pci6208.c
+++ b/drivers/staging/comedi/drivers/adl_pci6208.c
@@ -225,28 +225,6 @@ static struct pci_dev *pci6208_find_device(struct comedi_device *dev,
 	return NULL;
 }
 
-static int
-pci6208_pci_setup(struct pci_dev *pci_dev, unsigned long *io_base_ptr,
-		  int dev_minor)
-{
-	unsigned long io_base;
-
-	/*  Enable PCI device and request regions */
-	if (comedi_pci_enable(pci_dev, "adl_pci6208") < 0) {
-		printk(KERN_ERR "comedi%d: Failed to enable PCI device "
-			"and request regions\n",
-			dev_minor);
-		return -EIO;
-	}
-
-	/*  Read PCI6208 register base address [PCI_BASE_ADDRESS #2]. */
-	io_base = pci_resource_start(pci_dev, 2);
-
-	*io_base_ptr = io_base;
-
-	return 0;
-}
-
 static int pci6208_attach(struct comedi_device *dev,
 			  struct comedi_devconfig *it)
 {
@@ -254,7 +232,6 @@ static int pci6208_attach(struct comedi_device *dev,
 	struct pci6208_private *devpriv;
 	struct comedi_subdevice *s;
 	int retval;
-	unsigned long io_base;
 
 	printk(KERN_INFO "comedi%d: pci6208: ", dev->minor);
 
@@ -268,11 +245,14 @@ static int pci6208_attach(struct comedi_device *dev,
 		return -EIO;
 	thisboard = comedi_board(dev);
 
-	retval = pci6208_pci_setup(devpriv->pci_dev, &io_base, dev->minor);
-	if (retval < 0)
-		return retval;
+	if (comedi_pci_enable(devpriv->pci_dev, "adl_pci6208") < 0) {
+		dev_err(dev->class_dev,
+			"Failed to enable PCI device and request regions\n");
+		return -EIO;
+	}
+
+	dev->iobase = pci_resource_start(devpriv->pci_dev, 2);
 
-	dev->iobase = io_base;
 	dev->board_name = thisboard->name;
 
 	retval = comedi_alloc_subdevices(dev, 2);
-- 
1.7.11

