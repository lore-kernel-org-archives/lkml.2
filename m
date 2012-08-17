Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933662Ab2HQCxU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 22:53:20 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:5877 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933197Ab2HQCxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 22:53:18 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-16.tower-131.messagelabs.com!1345171993!24209541!10
X-Originating-IP: [216.166.12.178]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 28/35] staging: comedi: cb_pcimdda: remove boardinfo
Date: Thu, 16 Aug 2012 19:52:52 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208161952.52945.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The boardinfo struct and associated code is no longer needed
by this driver. Remove it.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_pcimdda.c | 38 ++++++-----------------------
 1 file changed, 8 insertions(+), 30 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcimdda.c b/drivers/staging/comedi/drivers/cb_pcimdda.c
index 82fb5f6..e9f0a68 100644
--- a/drivers/staging/comedi/drivers/cb_pcimdda.c
+++ b/drivers/staging/comedi/drivers/cb_pcimdda.c
@@ -99,22 +99,6 @@ Configuration Options:
 #define PCIMDDA_8255_BASE_REG		0x0c
 
 /*
- * This is straight from skel.c -- I did this in case this source file
- * will someday support more than 1 board...
- */
-struct cb_pcimdda_board {
-	const char *name;
-	unsigned short device_id;
-};
-
-static const struct cb_pcimdda_board cb_pcimdda_boards[] = {
-	{
-	 .name = "cb_pcimdda06-16",
-	 .device_id = PCI_ID_PCIM_DDA06_16,
-	 }
-};
-
-/*
  * this structure is for data unique to this hardware driver.  If
  * several hardware drivers keep similar information in this structure,
  * feel free to suggest moving the variable to the struct comedi_device
@@ -197,24 +181,20 @@ static struct pci_dev *cb_pcimdda_probe(struct comedi_device *dev,
 					struct comedi_devconfig *it)
 {
 	struct pci_dev *pcidev = NULL;
-	int index;
 
 	for_each_pci_dev(pcidev) {
 		if (pcidev->vendor != PCI_VENDOR_ID_COMPUTERBOARDS)
 			continue;
-		for (index = 0; index < ARRAY_SIZE(cb_pcimdda_boards); index++) {
-			if (cb_pcimdda_boards[index].device_id != pcidev->device)
+		if (pcidev->device != PCI_ID_PCIM_DDA06_16)
+			continue;
+		if (it->options[0] || it->options[1]) {
+			if (pcidev->bus->number != it->options[0] ||
+				PCI_SLOT(pcidev->devfn) != it->options[1]) {
 				continue;
-			if (it->options[0] || it->options[1]) {
-				if (pcidev->bus->number != it->options[0] ||
-				    PCI_SLOT(pcidev->devfn) != it->options[1]) {
-					continue;
-				}
 			}
-
-			dev->board_ptr = cb_pcimdda_boards + index;
-			return pcidev;
 		}
+
+		return pcidev;
 	}
 	return NULL;
 }
@@ -222,7 +202,6 @@ static struct pci_dev *cb_pcimdda_probe(struct comedi_device *dev,
 static int cb_pcimdda_attach(struct comedi_device *dev,
 			     struct comedi_devconfig *it)
 {
-	const struct cb_pcimdda_board *thisboard;
 	struct cb_pcimdda_private *devpriv;
 	struct pci_dev *pcidev;
 	struct comedi_subdevice *s;
@@ -237,8 +216,7 @@ static int cb_pcimdda_attach(struct comedi_device *dev,
 	if (!pcidev)
 		return -EIO;
 	comedi_set_hw_dev(dev, &pcidev->dev);
-	thisboard = comedi_board(dev);
-	dev->board_name = thisboard->name;
+	dev->board_name = dev->driver->driver_name;
 
 	ret = comedi_pci_enable(pcidev, dev->board_name);
 	if (ret)
-- 
1.7.11

