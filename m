Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030565Ab2HQCuM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 22:50:12 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:3793 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030363Ab2HQCuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 22:50:09 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-5.tower-160.messagelabs.com!1345171807!8639659!1
X-Originating-IP: [216.166.12.180]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 21/35] staging: comedi: cb_pcimdda: cleanup the 8255 subdevice init
Date: Thu, 16 Aug 2012 19:50:01 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208161950.01649.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dio_registers variable in the private data is only used to
pass the base address to the 8255 subdevice. Remove the variable
from the private data and pass the value directly to the
subdev_8255_init() function.

Make sure to check the return from subdev_8255_init(). That
function can fail. For aesthetic reasons, rename the local
variable 'err' to 'ret'.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_pcimdda.c | 31 +++++++++++++----------------
 1 file changed, 14 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcimdda.c b/drivers/staging/comedi/drivers/cb_pcimdda.c
index 4127aa7..b4d1f8b 100644
--- a/drivers/staging/comedi/drivers/cb_pcimdda.c
+++ b/drivers/staging/comedi/drivers/cb_pcimdda.c
@@ -137,7 +137,6 @@ static const struct cb_pcimdda_board cb_pcimdda_boards[] = {
  * struct.
  */
 struct cb_pcimdda_private {
-	unsigned long dio_registers;
 	char attached_to_8255;	/* boolean */
 
 #define MAX_AO_READBACK_CHANNELS 6
@@ -243,11 +242,11 @@ static int cb_pcimdda_attach(struct comedi_device *dev,
 	struct cb_pcimdda_private *devpriv;
 	struct pci_dev *pcidev;
 	struct comedi_subdevice *s;
-	int err;
+	int ret;
 
-	err = alloc_private(dev, sizeof(*devpriv));
-	if (err)
-		return err;
+	ret = alloc_private(dev, sizeof(*devpriv));
+	if (ret)
+		return ret;
 	devpriv = dev->private;
 
 	pcidev = cb_pcimdda_probe(dev, it);
@@ -257,15 +256,14 @@ static int cb_pcimdda_attach(struct comedi_device *dev,
 	thisboard = comedi_board(dev);
 	dev->board_name = thisboard->name;
 
-	err = comedi_pci_enable(pcidev, dev->board_name);
-	if (err)
-		return err;
+	ret = comedi_pci_enable(pcidev, dev->board_name);
+	if (ret)
+		return ret;
 	dev->iobase = pci_resource_start(pcidev, thisboard->regs_badrindex);
-	devpriv->dio_registers = dev->iobase + thisboard->dio_offset;
 
-	err = comedi_alloc_subdevices(dev, 2);
-	if (err)
-		return err;
+	ret = comedi_alloc_subdevices(dev, 2);
+	if (ret)
+		return ret;
 
 	s = dev->subdevices + 0;
 
@@ -287,11 +285,10 @@ static int cb_pcimdda_attach(struct comedi_device *dev,
 	if (thisboard->dio_chans) {
 		switch (thisboard->dio_method) {
 		case DIO_8255:
-			/*
-			 * this is a straight 8255, so register us with
-			 * the 8255 driver
-			 */
-			subdev_8255_init(dev, s, NULL, devpriv->dio_registers);
+			ret = subdev_8255_init(dev, s, NULL,
+					dev->iobase + thisboard->dio_offset);
+			if (ret)
+				return ret;
 			devpriv->attached_to_8255 = 1;
 			break;
 		case DIO_INTERNAL:
-- 
1.7.11

