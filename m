Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877Ab1LLFUy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 00:20:54 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59165 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837Ab1LLFUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 00:20:51 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 11/29] Staging: comedi: fix printk issue in daqboard2000.c
Date: Mon, 12 Dec 2011 10:49:23 +0530
Message-Id: <1323667181-17252-11-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323667181-17252-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1323667181-17252-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the daqboard2000.c file that fixes up a printk
warning found by the checkpatch.pl tool.

converted printks to dev_printk and Removed unnecessary
printk statements.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/daqboard2000.c |   18 +++++++-----------
 1 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/comedi/drivers/daqboard2000.c b/drivers/staging/comedi/drivers/daqboard2000.c
index 54145dc..0b498de 100644
--- a/drivers/staging/comedi/drivers/daqboard2000.c
+++ b/drivers/staging/comedi/drivers/daqboard2000.c
@@ -739,8 +739,6 @@ static int daqboard2000_attach(struct comedi_device *dev,
 	unsigned int aux_len;
 	int bus, slot;
 
-	printk("comedi%d: daqboard2000:", dev->minor);
-
 	bus = it->options[0];
 	slot = it->options[1];
 
@@ -761,10 +759,10 @@ static int daqboard2000_attach(struct comedi_device *dev,
 	}
 	if (!card) {
 		if (bus || slot)
-			printk(" no daqboard2000 found at bus/slot: %d/%d\n",
-			       bus, slot);
+			dev_err(dev->hw_dev, "no daqboard2000 found at bus/slot: %d/%d\n",
+				bus, slot);
 		else
-			printk(" no daqboard2000 found\n");
+			dev_err(dev->hw_dev, "no daqboard2000 found\n");
 		return -EIO;
 	} else {
 		u32 id;
@@ -774,7 +772,8 @@ static int daqboard2000_attach(struct comedi_device *dev,
 		      subsystem_device << 16) | card->subsystem_vendor;
 		for (i = 0; i < n_boardtypes; i++) {
 			if (boardtypes[i].id == id) {
-				printk(" %s", boardtypes[i].name);
+				dev_dbg(dev->hw_dev, "%s\n",
+					boardtypes[i].name);
 				dev->board_ptr = boardtypes + i;
 			}
 		}
@@ -788,7 +787,7 @@ static int daqboard2000_attach(struct comedi_device *dev,
 
 	result = comedi_pci_enable(card, "daqboard2000");
 	if (result < 0) {
-		printk(" failed to enable PCI device and request regions\n");
+		dev_err(dev->hw_dev, "failed to enable PCI device and request regions\n");
 		return -EIO;
 	}
 	devpriv->got_regions = 1;
@@ -818,7 +817,7 @@ static int daqboard2000_attach(struct comedi_device *dev,
 	if (aux_data && aux_len) {
 		result = initialize_daqboard2000(dev, aux_data, aux_len);
 	} else {
-		printk("no FPGA initialization code, aborting\n");
+		dev_dbg(dev->hw_dev, "no FPGA initialization code, aborting\n");
 		result = -EIO;
 	}
 	if (result < 0)
@@ -858,15 +857,12 @@ static int daqboard2000_attach(struct comedi_device *dev,
 	result = subdev_8255_init(dev, s, daqboard2000_8255_cb,
 				  (unsigned long)(dev->iobase + 0x40));
 
-	printk("\n");
 out:
 	return result;
 }
 
 static int daqboard2000_detach(struct comedi_device *dev)
 {
-	printk("comedi%d: daqboard2000: remove\n", dev->minor);
-
 	if (dev->subdevices)
 		subdev_8255_cleanup(dev, dev->subdevices + 2);
 
-- 
1.7.0.4

