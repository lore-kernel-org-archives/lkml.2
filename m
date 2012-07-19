Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755134Ab2GSBcV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 21:32:21 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:63938 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975Ab2GSBcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 21:32:13 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-10.tower-209.messagelabs.com!1342661532!9100135!1
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 19/90] staging: comedi: adv_pci1710: move comedi_pci_enable() into the attach
Date: Wed, 18 Jul 2012 18:32:01 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207181832.02040.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use pci_is_enabled() in the "find pci device" function to determine if
the found pci device is not in use and move the comedi_pci_enable() call
into the attach.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/adv_pci1710.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adv_pci1710.c b/drivers/staging/comedi/drivers/adv_pci1710.c
index 5eecf6b..33dd1db 100644
--- a/drivers/staging/comedi/drivers/adv_pci1710.c
+++ b/drivers/staging/comedi/drivers/adv_pci1710.c
@@ -1350,6 +1350,8 @@ static struct pci_dev *pci1710_find_pci_dev(struct comedi_device *dev,
 		}
 		if (pcidev->vendor != PCI_VENDOR_ID_ADVANTECH)
 			continue;
+		if (pci_is_enabled(pcidev))
+			continue;
 
 		if (strcmp(this_board->name, DRV_NAME) == 0) {
 			for (i = 0; i < ARRAY_SIZE(boardtypes); ++i) {
@@ -1364,15 +1366,6 @@ static struct pci_dev *pci1710_find_pci_dev(struct comedi_device *dev,
 			if (pcidev->device != boardtypes[board_index].device_id)
 				continue;
 		}
-
-		/*
-		 * Look for device that isn't in use.
-		 * Enable PCI device and request regions.
-		 */
-		if (comedi_pci_enable(pcidev, DRV_NAME)) {
-			continue;
-		}
-		/*  fixup board_ptr in case we were using the dummy entry with the driver name */
 		dev->board_ptr = &boardtypes[board_index];
 		return pcidev;
 	}
@@ -1399,6 +1392,10 @@ static int pci1710_attach(struct comedi_device *dev,
 	if (!devpriv->pcidev)
 		return -EIO;
 
+	ret = comedi_pci_enable(devpriv->pcidev, DRV_NAME);
+	if (ret)
+		return ret;
+
 	dev->iobase = pci_resource_start(devpriv->pcidev, 2);
 	irq = devpriv->pcidev->irq;
 
-- 
1.7.11

