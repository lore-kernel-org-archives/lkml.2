Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999Ab1LLFVF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 00:21:05 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59165 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883Ab1LLFVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 00:21:01 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 13/29] Staging: comedi: fix printk issue in jr3_pci.c
Date: Mon, 12 Dec 2011 10:49:25 +0530
Message-Id: <1323667181-17252-13-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323667181-17252-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1323667181-17252-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the jr3_pci.c file that fixes up a
printk warning found by the checkpatch.pl tool.

Converted printks to dev_<levels> and Removed unnecessary
printk statements.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/jr3_pci.c |   25 +++++++++++--------------
 1 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/comedi/drivers/jr3_pci.c b/drivers/staging/comedi/drivers/jr3_pci.c
index 2d3d1b2..2a97894 100644
--- a/drivers/staging/comedi/drivers/jr3_pci.c
+++ b/drivers/staging/comedi/drivers/jr3_pci.c
@@ -773,14 +773,12 @@ static int jr3_pci_attach(struct comedi_device *dev,
 	int opt_bus, opt_slot, i;
 	struct jr3_pci_dev_private *devpriv;
 
-	printk("comedi%d: jr3_pci\n", dev->minor);
-
 	opt_bus = it->options[0];
 	opt_slot = it->options[1];
 
 	if (sizeof(struct jr3_channel) != 0xc00) {
-		printk("sizeof(struct jr3_channel) = %x [expected %x]\n",
-		       (unsigned)sizeof(struct jr3_channel), 0xc00);
+		dev_err(dev->hw_dev, "sizeof(struct jr3_channel) = %x [expected %x]\n",
+			(unsigned)sizeof(struct jr3_channel), 0xc00);
 		return -EINVAL;
 	}
 
@@ -834,7 +832,7 @@ static int jr3_pci_attach(struct comedi_device *dev,
 		}
 	}
 	if (!card) {
-		printk(" no jr3_pci found\n");
+		dev_err(dev->hw_dev, "no jr3_pci found\n");
 		return -EIO;
 	} else {
 		devpriv->pci_dev = card;
@@ -869,10 +867,10 @@ static int jr3_pci_attach(struct comedi_device *dev,
 
 			p = dev->subdevices[i].private;
 			p->channel = &devpriv->iobase->channel[i].data;
-			printk("p->channel %p %p (%tx)\n",
-			       p->channel, devpriv->iobase,
-			       ((char *)(p->channel) -
-				(char *)(devpriv->iobase)));
+			dev_dbg(dev->hw_dev, "p->channel %p %p (%tx)\n",
+				p->channel, devpriv->iobase,
+				((char *)(p->channel) -
+				 (char *)(devpriv->iobase)));
 			p->channel_no = i;
 			for (j = 0; j < 8; j++) {
 				int k;
@@ -910,7 +908,7 @@ static int jr3_pci_attach(struct comedi_device *dev,
 	devpriv->iobase->channel[0].reset = 0;
 
 	result = comedi_load_firmware(dev, "jr3pci.idm", jr3_download_firmware);
-	printk("Firmare load %d\n", result);
+	dev_dbg(dev->hw_dev, "Firmare load %d\n", result);
 
 	if (result < 0)
 		goto out;
@@ -928,9 +926,9 @@ static int jr3_pci_attach(struct comedi_device *dev,
  */
 	msleep_interruptible(25);
 	for (i = 0; i < 0x18; i++) {
-		printk("%c",
-		       get_u16(&devpriv->iobase->channel[0].
-			       data.copyright[i]) >> 8);
+		dev_dbg(dev->hw_dev, "%c\n",
+			get_u16(&devpriv->iobase->channel[0].
+				data.copyright[i]) >> 8);
 	}
 
 	/*  Start card timer */
@@ -957,7 +955,6 @@ static int jr3_pci_detach(struct comedi_device *dev)
 	int i;
 	struct jr3_pci_dev_private *devpriv = dev->private;
 
-	printk("comedi%d: jr3_pci: remove\n", dev->minor);
 	if (devpriv) {
 		del_timer_sync(&devpriv->timer);
 
-- 
1.7.0.4

