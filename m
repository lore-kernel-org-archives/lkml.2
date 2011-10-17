Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753038Ab1JQMdv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 08:33:51 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:40720 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750Ab1JQMdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 08:33:50 -0400
From: Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 11/11] Staging: comedi: fix printk issue in cb_pcidda.c
Date: Mon, 17 Oct 2011 18:03:39 +0530
Message-Id: <1318854819-6835-1-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt.
converted printks to dev_printk level.
Removed unnecessary printk statements.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/cb_pcidda.c |   22 ++++++++++------------
 1 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidda.c b/drivers/staging/comedi/drivers/cb_pcidda.c
index 49102b3..68bea4d 100644
--- a/drivers/staging/comedi/drivers/cb_pcidda.c
+++ b/drivers/staging/comedi/drivers/cb_pcidda.c
@@ -46,11 +46,14 @@ Please report success/failure with other different cards to
 <comedi@comedi.org>.
 */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include "../comedidev.h"
 
 #include "comedi_pci.h"
 #include "8255.h"
 
+
 #define PCI_VENDOR_ID_CB	0x1307	/*  PCI vendor number of ComputerBoards */
 #define EEPROM_SIZE	128	/*  number of entries in eeprom */
 #define MAX_AO_CHANNELS 8	/*  maximum number of ao channels for supported boards */
@@ -282,7 +285,6 @@ static int cb_pcidda_attach(struct comedi_device *dev,
 	struct pci_dev *pcidev = NULL;
 	int index;
 
-	printk("comedi%d: cb_pcidda: ", dev->minor);
 
 /*
  * Allocate the private structure area.
@@ -293,7 +295,6 @@ static int cb_pcidda_attach(struct comedi_device *dev,
 /*
  * Probe the device to determine what device in the series it is.
  */
-	printk("\n");
 
 	for_each_pci_dev(pcidev) {
 		if (pcidev->vendor == PCI_VENDOR_ID_CB) {
@@ -312,22 +313,22 @@ static int cb_pcidda_attach(struct comedi_device *dev,
 		}
 	}
 	if (!pcidev) {
-		printk
-		    ("Not a ComputerBoards/MeasurementComputing card on requested position\n");
+		dev_err(dev->hw_dev,
+			"Not a ComputerBoards/MeasurementComputing card on requested position\n");
 		return -EIO;
 	}
 found:
 	devpriv->pci_dev = pcidev;
 	dev->board_ptr = cb_pcidda_boards + index;
 	/*  "thisboard" macro can be used from here. */
-	printk("Found %s at requested position\n", thisboard->name);
+	dev_dbg(dev->hw_dev, "Found %s at requested position\n",
+		thisboard->name);
 
 	/*
 	 * Enable PCI device and request regions.
 	 */
 	if (comedi_pci_enable(pcidev, thisboard->name)) {
-		printk
-		    ("cb_pcidda: failed to enable PCI device and request regions\n");
+		dev_err(dev->hw_dev, "failed to enable PCI device and request regions\n");
 		return -EIO;
 	}
 
@@ -377,12 +378,11 @@ found:
 	s = dev->subdevices + 2;
 	subdev_8255_init(dev, s, NULL, devpriv->digitalio + PORT2A);
 
-	printk(" eeprom:");
+	dev_dbg(dev->hw_dev, "eeprom:\n");
 	for (index = 0; index < EEPROM_SIZE; index++) {
 		devpriv->eeprom_data[index] = cb_pcidda_read_eeprom(dev, index);
-		printk(" %i:0x%x ", index, devpriv->eeprom_data[index]);
+		dev_dbg(dev->hw_dev, "%i:0x%x\n", index,
+			devpriv->eeprom_data[index]);
 	}
-	printk("\n");
 
 	/*  set calibrations dacs */
 	for (index = 0; index < thisboard->ao_chans; index++)
@@ -417,8 +417,6 @@ static int cb_pcidda_detach(struct comedi_device *dev)
 		subdev_8255_cleanup(dev, dev->subdevices + 2);
 	}
 
-	printk("comedi%d: cb_pcidda: remove\n", dev->minor);
-
 	return 0;
 }
 
-- 
1.7.6.4

