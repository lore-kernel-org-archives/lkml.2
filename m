Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286Ab1JKRjL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 13:39:11 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:60147 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755148Ab1JKRjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 13:39:06 -0400
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: David Miller <davem@davemloft.net>
Subject: [PATCH] cy82c693: fix PCI device selection
Date: Tue, 11 Oct 2011 19:37:32 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.7-desktop-dirty; KDE/4.6.0; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201110111937.32501.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] cy82c693: fix PCI device selection

Wrong PCI device may be selected by cy82c693_set_pio_mode() if modular
IDE host drivers are used and there are additional IDE PCI devices
installed in the system.  Fix it.

While at it remove redundant pci_get_slot() call as cy82c693_init_one()
already takes care of keeping the reference on the second port's PCI
device.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---

 drivers/ide/cy82c693.c |   15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

Index: b/drivers/ide/cy82c693.c
===================================================================
--- a/drivers/ide/cy82c693.c
+++ b/drivers/ide/cy82c693.c
@@ -82,24 +82,13 @@ static void cy82c693_set_dma_mode(ide_hw
 
 static void cy82c693_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
-	struct pci_dev *dev = to_pci_dev(hwif->dev);
+	struct pci_dev *dev = to_pci_dev(hwif->host->dev[drive->dn / 2]);
 	int bus_speed = ide_pci_clk ? ide_pci_clk : 33;
 	const unsigned long T = 1000000 / bus_speed;
 	unsigned int addrCtrl;
 	struct ide_timing t;
 	u8 time_16, time_8;
 
-	/* select primary or secondary channel */
-	if (hwif->index > 0) {  /* drive is on the secondary channel */
-		dev = pci_get_slot(dev->bus, dev->devfn+1);
-		if (!dev) {
-			printk(KERN_ERR "%s: tune_drive: "
-				"Cannot find secondary interface!\n",
-				drive->name);
-			return;
-		}
-	}
-
 	ide_timing_compute(drive, drive->pio_mode, &t, T, 1);
 
 	time_16 = clamp_val(t.recover - 1, 0, 15) |
@@ -141,8 +130,6 @@ static void cy82c693_set_pio_mode(ide_hw
 		pci_write_config_byte(dev, CY82_IDE_SLAVE_IOW, time_16);
 		pci_write_config_byte(dev, CY82_IDE_SLAVE_8BIT, time_8);
 	}
-	if (hwif->index > 0)
-		pci_dev_put(dev);
 }
 
 static void __devinit init_iops_cy82c693(ide_hwif_t *hwif)
