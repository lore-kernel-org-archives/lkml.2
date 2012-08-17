Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933612Ab2HQCq3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 22:46:29 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:3493 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933239Ab2HQCq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 22:46:26 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-127.messagelabs.com!1345171585!7757393!1
X-Originating-IP: [216.166.12.97]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 11/35] staging: comedi: cb_pcimdas: remove thisboard and devpriv macros
Date: Thu, 16 Aug 2012 19:46:20 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208161946.20716.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These macros rely on a local variable having a specific name.
Remove them and use the comedi_board() helper to get the thisboard
pointer.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_pcimdas.c | 27 +++++++++++----------------
 1 file changed, 11 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcimdas.c b/drivers/staging/comedi/drivers/cb_pcimdas.c
index c632a89..124478d 100644
--- a/drivers/staging/comedi/drivers/cb_pcimdas.c
+++ b/drivers/staging/comedi/drivers/cb_pcimdas.c
@@ -119,11 +119,6 @@ static const struct cb_pcimdas_board cb_pcimdas_boards[] = {
 };
 
 /*
- * Useful for shorthand access to the particular board structure
- */
-#define thisboard ((const struct cb_pcimdas_board *)dev->board_ptr)
-
-/*
  * this structure is for data unique to this hardware driver.  If
  * several hardware drivers keep similar information in this structure,
  * feel free to suggest moving the variable to the struct comedi_device
@@ -137,12 +132,6 @@ struct cb_pcimdas_private {
 	unsigned int ao_readback[2];
 };
 
-/*
- * most drivers define the following macro to make it easy to
- * access the private structure.
- */
-#define devpriv ((struct cb_pcimdas_private *)dev->private)
-
 static int cb_pcimdas_ai_rinsn(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
 			       struct comedi_insn *insn, unsigned int *data);
@@ -193,21 +182,23 @@ static struct pci_dev *cb_pcimdas_find_pci_dev(struct comedi_device *dev,
 static int cb_pcimdas_attach(struct comedi_device *dev,
 			     struct comedi_devconfig *it)
 {
+	const struct cb_pcimdas_board *thisboard;
+	struct cb_pcimdas_private *devpriv;
 	struct pci_dev *pcidev;
 	struct comedi_subdevice *s;
 	unsigned long iobase_8255;
 	int ret;
 
-/*
- * Allocate the private structure area.
- */
-	if (alloc_private(dev, sizeof(struct cb_pcimdas_private)) < 0)
-		return -ENOMEM;
+	ret = alloc_private(dev, sizeof(*devpriv));
+	if (ret)
+		return ret;
+	devpriv = dev->private;
 
 	pcidev = cb_pcimdas_find_pci_dev(dev, it);
 	if (!pcidev)
 		return -EIO;
 	comedi_set_hw_dev(dev, &pcidev->dev);
+	thisboard = comedi_board(dev);
 
 	/*  Warn about non-tested features */
 	switch (thisboard->device_id) {
@@ -299,6 +290,8 @@ static int cb_pcimdas_ai_rinsn(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
 			       struct comedi_insn *insn, unsigned int *data)
 {
+	const struct cb_pcimdas_board *thisboard = comedi_board(dev);
+	struct cb_pcimdas_private *devpriv = dev->private;
 	int n, i;
 	unsigned int d;
 	unsigned int busy;
@@ -368,6 +361,7 @@ static int cb_pcimdas_ao_winsn(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
 			       struct comedi_insn *insn, unsigned int *data)
 {
+	struct cb_pcimdas_private *devpriv = dev->private;
 	int i;
 	int chan = CR_CHAN(insn->chanspec);
 
@@ -397,6 +391,7 @@ static int cb_pcimdas_ao_rinsn(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
 			       struct comedi_insn *insn, unsigned int *data)
 {
+	struct cb_pcimdas_private *devpriv = dev->private;
 	int i;
 	int chan = CR_CHAN(insn->chanspec);
 
-- 
1.7.11

