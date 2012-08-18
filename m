Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620Ab2HRBTw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 21:19:52 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:34765 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754020Ab2HRBTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 21:19:43 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-7.tower-209.messagelabs.com!1345252780!7767508!10
X-Originating-IP: [216.166.12.69]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 14/20] staging: comedi: adv_pci_dio: remove devpriv and this_board macros
Date: Fri, 17 Aug 2012 18:19:18 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208171819.18689.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These macros rely on a local variable having a specific name. Remove
them and use the comedi_board() helper to get the this_board pointer.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/adv_pci_dio.c | 33 ++++++++++++++++++----------
 1 file changed, 21 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adv_pci_dio.c b/drivers/staging/comedi/drivers/adv_pci_dio.c
index 69508c8..97fc6b8 100644
--- a/drivers/staging/comedi/drivers/adv_pci_dio.c
+++ b/drivers/staging/comedi/drivers/adv_pci_dio.c
@@ -392,9 +392,6 @@ struct pci_dio_private {
 	unsigned short IDIFiltrHigh[8];	/*  IDI's filter value high signal */
 };
 
-#define devpriv ((struct pci_dio_private *)dev->private)
-#define this_board ((const struct dio_boardtype *)dev->board_ptr)
-
 /*
 ==============================================================================
 */
@@ -685,6 +682,7 @@ static int pci1760_insn_cnt_write(struct comedi_device *dev,
 				  struct comedi_subdevice *s,
 				  struct comedi_insn *insn, unsigned int *data)
 {
+	struct pci_dio_private *devpriv = dev->private;
 	int ret;
 	unsigned char chan = CR_CHAN(insn->chanspec) & 0x07;
 	unsigned char bitmask = 1 << chan;
@@ -727,6 +725,7 @@ static int pci1760_insn_cnt_write(struct comedi_device *dev,
 */
 static int pci1760_reset(struct comedi_device *dev)
 {
+	struct pci_dio_private *devpriv = dev->private;
 	int i;
 	unsigned char omb[4] = { 0x00, 0x00, 0x00, 0x00 };
 	unsigned char imb[4];
@@ -807,6 +806,8 @@ static int pci1760_reset(struct comedi_device *dev)
 */
 static int pci_dio_reset(struct comedi_device *dev)
 {
+	const struct dio_boardtype *this_board = comedi_board(dev);
+
 	switch (this_board->cardtype) {
 	case TYPE_PCI1730:
 		outb(0, dev->iobase + PCI1730_DO);	/*  clear outputs */
@@ -968,6 +969,8 @@ static int pci1760_attach(struct comedi_device *dev,
 static int pci_dio_add_di(struct comedi_device *dev, struct comedi_subdevice *s,
 			  const struct diosubd_data *d, int subdev)
 {
+	const struct dio_boardtype *this_board = comedi_board(dev);
+
 	s->type = COMEDI_SUBD_DI;
 	s->subdev_flags = SDF_READABLE | SDF_GROUND | SDF_COMMON | d->specflags;
 	if (d->chans > 16)
@@ -995,6 +998,8 @@ static int pci_dio_add_di(struct comedi_device *dev, struct comedi_subdevice *s,
 static int pci_dio_add_do(struct comedi_device *dev, struct comedi_subdevice *s,
 			  const struct diosubd_data *d, int subdev)
 {
+	const struct dio_boardtype *this_board = comedi_board(dev);
+
 	s->type = COMEDI_SUBD_DO;
 	s->subdev_flags = SDF_WRITABLE | SDF_GROUND | SDF_COMMON;
 	if (d->chans > 16)
@@ -1069,27 +1074,29 @@ static struct pci_dev *pci_dio_find_pci_dev(struct comedi_device *dev,
 static int pci_dio_attach(struct comedi_device *dev,
 			  struct comedi_devconfig *it)
 {
+	const struct dio_boardtype *this_board;
+	struct pci_dio_private *devpriv;
 	struct pci_dev *pcidev;
 	struct comedi_subdevice *s;
 	int ret, subdev, n_subdevices, i, j;
 
-	ret = alloc_private(dev, sizeof(struct pci_dio_private));
+	ret = alloc_private(dev, sizeof(*devpriv));
 	if (ret < 0)
-		return -ENOMEM;
+		return ret;
+	devpriv = dev->private;
 
 	pcidev = pci_dio_find_pci_dev(dev, it);
 	if (!pcidev)
 		return -EIO;
 	comedi_set_hw_dev(dev, &pcidev->dev);
+	this_board = comedi_board(dev);
+	dev->board_name = this_board->name;
 
-	if (comedi_pci_enable(pcidev, dev->driver->driver_name)) {
-		dev_err(dev->class_dev,
-			"Error: Can't enable PCI device and request regions!\n");
-		return -EIO;
-	}
+	ret = comedi_pci_enable(pcidev, dev->board_name);
+	if (ret)
+		return ret;
 
 	dev->iobase = pci_resource_start(pcidev, this_board->main_pci_region);
-	dev->board_name = this_board->name;
 
 	if (this_board->cardtype == TYPE_PCI1760) {
 		n_subdevices = 4;	/*  8 IDI, 8 IDO, 2 PWM, 8 CNT */
@@ -1165,12 +1172,14 @@ static int pci_dio_attach(struct comedi_device *dev,
 
 static void pci_dio_detach(struct comedi_device *dev)
 {
+	const struct dio_boardtype *this_board = comedi_board(dev);
+	struct pci_dio_private *devpriv = dev->private;
 	struct pci_dev *pcidev = comedi_to_pci_dev(dev);
 	int i, j;
 	struct comedi_subdevice *s;
 	int subdev;
 
-	if (dev->private) {
+	if (devpriv) {
 		if (devpriv->valid)
 			pci_dio_reset(dev);
 		subdev = 0;
-- 
1.7.11

