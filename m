Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756310Ab1G2LHD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 07:07:03 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:36390 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755619Ab1G2LHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 07:07:01 -0400
From: Ravishankar <ravishankarkm32@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>,
        Ravishankar <ravishankarkm32@gmail.com>
Subject: [PATCH v2] Staging: comedi: fix printk issue in adv_pci_dio.c
Date: Fri, 29 Jul 2011 16:36:44 +0530
Message-Id: <1311937604-4468-1-git-send-email-ravishankarkm32@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <[PATCH]Staging: Comedi: fix printk issue in adv_pci_dio.c>
References: <[PATCH]Staging: Comedi: fix printk issue in adv_pci_dio.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravishankar <ravi.shankar@greenturtles.in>

This is a patch to the adv_pci_dio.c file that fixes up a printk warning found by the checkpatch.pl tool

Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
---
 drivers/staging/comedi/drivers/adv_pci_dio.c |   26 +++++++++++++++-----------
 1 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adv_pci_dio.c b/drivers/staging/comedi/drivers/adv_pci_dio.c
index d23799b..fe66d5f 100644
--- a/drivers/staging/comedi/drivers/adv_pci_dio.c
+++ b/drivers/staging/comedi/drivers/adv_pci_dio.c
@@ -422,7 +422,7 @@ struct pci_dio_private {
 	unsigned short IDIFiltrHigh[8];	/*  IDI's filter value high signal */
 };
 
-static struct pci_dio_private *pci_priv = NULL;	/* list of allocated cards */
+static struct pci_dio_private *pci_priv;	/* list of allocated cards */
 
 #define devpriv ((struct pci_dio_private *)dev->private)
 #define this_board ((const struct dio_boardtype *)dev->board_ptr)
@@ -1106,14 +1106,15 @@ static int pci_dio_attach(struct comedi_device *dev,
 	unsigned long iobase;
 	struct pci_dev *pcidev = NULL;
 
-	printk("comedi%d: adv_pci_dio: ", dev->minor);
+	printk(KERN_INFO "comedi%d: adv_pci_dio: ", dev->minor);
 
 	ret = alloc_private(dev, sizeof(struct pci_dio_private));
 	if (ret < 0) {
-		printk(", Error: Cann't allocate private memory!\n");
+		printk(KERN_WARNING "Error: Can't allocate private memory!\n");
 		return -ENOMEM;
 	}
 
+	printk(KERN_CONT ", Successfully allocated private memory\n");
 	for_each_pci_dev(pcidev) {
 		/*  loop through cards supported by this driver */
 		for (i = 0; i < n_boardtypes; ++i) {
@@ -1140,19 +1141,21 @@ static int pci_dio_attach(struct comedi_device *dev,
 	}
 
 	if (!dev->board_ptr) {
-		printk(", Error: Requested type of the card was not found!\n");
+		printk(KERN_WARNING "Error: Requested type of the card was not found!\n");
 		return -EIO;
 	}
 
+	printk(KERN_CONT ", Requested type of card was found\n");
 	if (comedi_pci_enable(pcidev, driver_pci_dio.driver_name)) {
-		printk
-		    (", Error: Can't enable PCI device and request regions!\n");
+		printk(KERN_WARNING
+		"Error: Can't enable PCI device and request regions!\n");
 		return -EIO;
 	}
+	printk(KERN_CONT "Enabled PCI device and request reqions\n");
 	iobase = pci_resource_start(pcidev, this_board->main_pci_region);
-	printk(", b:s:f=%d:%d:%d, io=0x%4lx",
-	       pcidev->bus->number, PCI_SLOT(pcidev->devfn),
-	       PCI_FUNC(pcidev->devfn), iobase);
+	printk(KERN_CONT ", b:s:f=%d:%d:%d, io=0x%4lx",
+		pcidev->bus->number, PCI_SLOT(pcidev->devfn),
+		PCI_FUNC(pcidev->devfn), iobase);
 
 	dev->iobase = iobase;
 	dev->board_name = this_board->name;
@@ -1178,11 +1181,12 @@ static int pci_dio_attach(struct comedi_device *dev,
 
 	ret = alloc_subdevices(dev, n_subdevices);
 	if (ret < 0) {
-		printk(", Error: Cann't allocate subdevice memory!\n");
+		printk(KERN_WARNING "Error: Can't allocate subdevice memory!\n");
 		return ret;
 	}
 
-	printk(".\n");
+	printk(KERN_CONT ", Successfully allocated subdevice memory\n");
+	printk(KERN_CONT ".\n");
 
 	subdev = 0;
 
-- 
1.6.5.2

