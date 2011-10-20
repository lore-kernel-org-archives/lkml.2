Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932460Ab1JTGVv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 02:21:51 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:64400 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932243Ab1JTGVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 02:21:49 -0400
From: Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 17/24] Staging: comedi: fix printk issue in adv_pci_dio.c
Date: Thu, 20 Oct 2011 11:49:03 +0530
Message-Id: <1319091550-2558-17-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1319091550-2558-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1319091550-2558-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the contec_pci_dio.c file that fixes up a printk
warning found by the checkpatch.pl tool
converted printks to dev_printk.
Removed unnecessary printk statements.
Fixed NULL initialization issue.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/adv_pci_dio.c |   22 +++++-----------------
 1 files changed, 5 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adv_pci_dio.c b/drivers/staging/comedi/drivers/adv_pci_dio.c
index d23799b..ec3abc8 100644
--- a/drivers/staging/comedi/drivers/adv_pci_dio.c
+++ b/drivers/staging/comedi/drivers/adv_pci_dio.c
@@ -422,7 +422,7 @@ struct pci_dio_private {
 	unsigned short IDIFiltrHigh[8];	/*  IDI's filter value high signal */
 };
 
-static struct pci_dio_private *pci_priv = NULL;	/* list of allocated cards */
+static struct pci_dio_private *pci_priv;	/* list of allocated cards */
 
 #define devpriv ((struct pci_dio_private *)dev->private)
 #define this_board ((const struct dio_boardtype *)dev->board_ptr)
@@ -1106,13 +1106,9 @@ static int pci_dio_attach(struct comedi_device *dev,
 	unsigned long iobase;
 	struct pci_dev *pcidev = NULL;
 
-	printk("comedi%d: adv_pci_dio: ", dev->minor);
-
 	ret = alloc_private(dev, sizeof(struct pci_dio_private));
-	if (ret < 0) {
-		printk(", Error: Cann't allocate private memory!\n");
+	if (ret < 0)
 		return -ENOMEM;
-	}
 
 	for_each_pci_dev(pcidev) {
 		/*  loop through cards supported by this driver */
@@ -1140,19 +1136,15 @@ static int pci_dio_attach(struct comedi_device *dev,
 	}
 
 	if (!dev->board_ptr) {
-		printk(", Error: Requested type of the card was not found!\n");
+		dev_err(dev->hw_dev, "Error: Requested type of the card was not found!\n");
 		return -EIO;
 	}
 
 	if (comedi_pci_enable(pcidev, driver_pci_dio.driver_name)) {
-		printk
-		    (", Error: Can't enable PCI device and request regions!\n");
+		dev_err(dev->hw_dev, "Error: Can't enable PCI device and request regions!\n");
 		return -EIO;
 	}
 	iobase = pci_resource_start(pcidev, this_board->main_pci_region);
-	printk(", b:s:f=%d:%d:%d, io=0x%4lx",
-	       pcidev->bus->number, PCI_SLOT(pcidev->devfn),
-	       PCI_FUNC(pcidev->devfn), iobase);
 
 	dev->iobase = iobase;
 	dev->board_name = this_board->name;
@@ -1177,12 +1169,8 @@ static int pci_dio_attach(struct comedi_device *dev,
 	}
 
 	ret = alloc_subdevices(dev, n_subdevices);
-	if (ret < 0) {
-		printk(", Error: Cann't allocate subdevice memory!\n");
+	if (ret < 0)
 		return ret;
-	}
-
-	printk(".\n");
 
 	subdev = 0;
 
-- 
1.7.6.4

