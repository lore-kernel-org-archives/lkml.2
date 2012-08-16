Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320Ab2HPAaf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 20:30:35 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:58150 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617Ab2HPAad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 20:30:33 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-15.tower-131.messagelabs.com!1345077026!24118108!16
X-Originating-IP: [216.166.12.97]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/7] staging: comedi: contec_pci_dio: remove thisboard macro
Date: Wed, 15 Aug 2012 17:30:26 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208151730.27005.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This macro relies on a local variable of a specific name. Remove the
macro and use the comedi_board() helper to get the thisboard pointer.

Move the 'dev->board_name = thisboard->name;' in contec_attach().
The contec_find_pci_dev() function modifies the dev->board_ptr.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/contec_pci_dio.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/contec_pci_dio.c b/drivers/staging/comedi/drivers/contec_pci_dio.c
index 944cfee..71b7266 100644
--- a/drivers/staging/comedi/drivers/contec_pci_dio.c
+++ b/drivers/staging/comedi/drivers/contec_pci_dio.c
@@ -55,12 +55,11 @@ static const struct contec_board contec_boards[] = {
 
 #define PCI_DEVICE_ID_PIO1616L 0x8172
 
-#define thisboard ((const struct contec_board *)dev->board_ptr)
-
 static int contec_do_insn_bits(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
 			       struct comedi_insn *insn, unsigned int *data)
 {
+	const struct contec_board *thisboard = comedi_board(dev);
 
 	dev_dbg(dev->class_dev, "contec_do_insn_bits called\n");
 	dev_dbg(dev->class_dev, "data: %d %d\n", data[0], data[1]);
@@ -79,6 +78,7 @@ static int contec_di_insn_bits(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
 			       struct comedi_insn *insn, unsigned int *data)
 {
+	const struct contec_board *thisboard = comedi_board(dev);
 
 	dev_dbg(dev->class_dev, "contec_di_insn_bits called\n");
 	dev_dbg(dev->class_dev, "data: %d %d\n", data[0], data[1]);
@@ -116,14 +116,13 @@ static struct pci_dev *contec_find_pci_dev(struct comedi_device *dev,
 
 static int contec_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
+	const struct contec_board *thisboard;
 	struct pci_dev *pcidev;
 	struct comedi_subdevice *s;
 	int ret;
 
 	printk("comedi%d: contec: ", dev->minor);
 
-	dev->board_name = thisboard->name;
-
 	ret = comedi_alloc_subdevices(dev, 2);
 	if (ret)
 		return ret;
@@ -132,6 +131,8 @@ static int contec_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (!pcidev)
 		return -EIO;
 	comedi_set_hw_dev(dev, &pcidev->dev);
+	thisboard = comedi_board(dev);
+	dev->board_name = thisboard->name;
 
 	if (comedi_pci_enable(pcidev, "contec_pci_dio")) {
 		printk("error enabling PCI device and request regions!\n");
-- 
1.7.11

