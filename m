Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416Ab2HRBSN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 21:18:13 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:26865 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685Ab2HRBSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 21:18:02 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-10.tower-209.messagelabs.com!1345252680!7773875!2
X-Originating-IP: [216.166.12.32]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 10/20] staging: comedi: adv_pci1723: remove boardinfo
Date: Fri, 17 Aug 2012 18:17:57 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208171817.57915.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver only supports one board type. Remove the boardinfo and
associated code.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/adv_pci1723.c | 139 ++++++++-------------------
 1 file changed, 42 insertions(+), 97 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adv_pci1723.c b/drivers/staging/comedi/drivers/adv_pci1723.c
index 68ca075..21dfde2 100644
--- a/drivers/staging/comedi/drivers/adv_pci1723.c
+++ b/drivers/staging/comedi/drivers/adv_pci1723.c
@@ -52,11 +52,6 @@ TODO:
 
 #define PCI_VENDOR_ID_ADVANTECH		0x13fe	/* Advantech PCI vendor ID */
 
-/* hardware types of the cards */
-#define TYPE_PCI1723 0
-
-#define IORANGE_1723  0x2A
-
 /* all the registers for the pci1723 board */
 #define PCI1723_DA(N)   ((N)<<1)	/* W: D/A register N (0 to 7) */
 
@@ -112,37 +107,6 @@ TODO:
 
 #define PCI1723_SELECT_CALIBRATION 0x28	/* Select the calibration Ref_V */
 
-/* static unsigned short pci_list_builded=0;      =1 list of card is know */
-
-/*
- * Board descriptions for pci1723 boards.
- */
-struct pci1723_board {
-	const char *name;
-	int vendor_id;		/* PCI vendor a device ID of card */
-	int device_id;
-	int iorange;
-	char cardtype;
-	int n_aochan;		/* num of D/A chans */
-	int n_diochan;		/* num of DIO chans */
-	int ao_maxdata;		/* resolution of D/A */
-	const struct comedi_lrange *rangelist_ao;	/* rangelist for D/A */
-};
-
-static const struct pci1723_board boardtypes[] = {
-	{
-	 .name = "pci1723",
-	 .vendor_id = PCI_VENDOR_ID_ADVANTECH,
-	 .device_id = 0x1723,
-	 .iorange = IORANGE_1723,
-	 .cardtype = TYPE_PCI1723,
-	 .n_aochan = 8,
-	 .n_diochan = 16,
-	 .ao_maxdata = 0xffff,
-	 .rangelist_ao = &range_bipolar10,
-	 },
-};
-
 /* This structure is for data unique to this hardware driver. */
 struct pci1723_private {
 	int valid;		/* card is usable; */
@@ -289,7 +253,8 @@ static struct pci_dev *pci1723_find_pci_dev(struct comedi_device *dev,
 		}
 		if (pcidev->vendor != PCI_VENDOR_ID_ADVANTECH)
 			continue;
-		dev->board_ptr = &boardtypes[0];
+		if (pcidev->device != 0x1723)
+			continue;
 		return pcidev;
 	}
 	dev_err(dev->class_dev,
@@ -301,11 +266,10 @@ static struct pci_dev *pci1723_find_pci_dev(struct comedi_device *dev,
 static int pci1723_attach(struct comedi_device *dev,
 			  struct comedi_devconfig *it)
 {
-	const struct pci1723_board *this_board;
 	struct pci1723_private *devpriv;
 	struct pci_dev *pcidev;
 	struct comedi_subdevice *s;
-	int ret, subdev, n_subdevices;
+	int ret;
 
 	ret = alloc_private(dev, sizeof(*devpriv));
 	if (ret < 0)
@@ -316,76 +280,57 @@ static int pci1723_attach(struct comedi_device *dev,
 	if (!pcidev)
 		return -EIO;
 	comedi_set_hw_dev(dev, &pcidev->dev);
-	this_board = comedi_board(dev);
-	dev->board_name = this_board->name;
+	dev->board_name = dev->driver->driver_name;
 
 	ret = comedi_pci_enable(pcidev, dev->board_name);
 	if (ret)
 		return ret;
 	dev->iobase = pci_resource_start(pcidev, 2);
 
-	n_subdevices = 0;
-
-	if (this_board->n_aochan)
-		n_subdevices++;
-	if (this_board->n_diochan)
-		n_subdevices++;
-
-	ret = comedi_alloc_subdevices(dev, n_subdevices);
+	ret = comedi_alloc_subdevices(dev, 2);
 	if (ret)
 		return ret;
 
 	pci1723_reset(dev);
-	subdev = 0;
-	if (this_board->n_aochan) {
-		s = dev->subdevices + subdev;
-		dev->write_subdev = s;
-		s->type = COMEDI_SUBD_AO;
-		s->subdev_flags = SDF_WRITEABLE | SDF_GROUND | SDF_COMMON;
-		s->n_chan = this_board->n_aochan;
-		s->maxdata = this_board->ao_maxdata;
-		s->len_chanlist = this_board->n_aochan;
-		s->range_table = this_board->rangelist_ao;
-
-		s->insn_write = pci1723_ao_write_winsn;
-		s->insn_read = pci1723_insn_read_ao;
-
-		subdev++;
-	}
-
-	if (this_board->n_diochan) {
-		s = dev->subdevices + subdev;
-		s->type = COMEDI_SUBD_DIO;
-		s->subdev_flags =
-		    SDF_READABLE | SDF_WRITABLE | SDF_GROUND | SDF_COMMON;
-		s->n_chan = this_board->n_diochan;
-		s->maxdata = 1;
-		s->len_chanlist = this_board->n_diochan;
-		s->range_table = &range_digital;
-		s->insn_config = pci1723_dio_insn_config;
-		s->insn_bits = pci1723_dio_insn_bits;
-
-		/* read DIO config */
-		switch (inw(dev->iobase + PCI1723_DIGITAL_IO_PORT_MODE)
-								       & 0x03) {
-		case 0x00:	/* low byte output, high byte output */
-			s->io_bits = 0xFFFF;
-			break;
-		case 0x01:	/* low byte input, high byte output */
-			s->io_bits = 0xFF00;
-			break;
-		case 0x02:	/* low byte output, high byte input */
-			s->io_bits = 0x00FF;
-			break;
-		case 0x03:	/* low byte input, high byte input */
-			s->io_bits = 0x0000;
-			break;
-		}
-		/* read DIO port state */
-		s->state = inw(dev->iobase + PCI1723_READ_DIGITAL_INPUT_DATA);
 
-		subdev++;
+	s = dev->subdevices + 0;
+	dev->write_subdev = s;
+	s->type		= COMEDI_SUBD_AO;
+	s->subdev_flags	= SDF_WRITEABLE | SDF_GROUND | SDF_COMMON;
+	s->n_chan	= 8;
+	s->maxdata	= 0xffff;
+	s->len_chanlist	= 8;
+	s->range_table	= &range_bipolar10;
+	s->insn_write	= pci1723_ao_write_winsn;
+	s->insn_read	= pci1723_insn_read_ao;
+
+	s = dev->subdevices + 1;
+	s->type		= COMEDI_SUBD_DIO;
+	s->subdev_flags	= SDF_READABLE | SDF_WRITABLE;
+	s->n_chan	= 16;
+	s->maxdata	= 1;
+	s->len_chanlist	= 16;
+	s->range_table	= &range_digital;
+	s->insn_config	= pci1723_dio_insn_config;
+	s->insn_bits	= pci1723_dio_insn_bits;
+
+	/* read DIO config */
+	switch (inw(dev->iobase + PCI1723_DIGITAL_IO_PORT_MODE) & 0x03) {
+	case 0x00:	/* low byte output, high byte output */
+		s->io_bits = 0xFFFF;
+		break;
+	case 0x01:	/* low byte input, high byte output */
+		s->io_bits = 0xFF00;
+		break;
+	case 0x02:	/* low byte output, high byte input */
+		s->io_bits = 0x00FF;
+		break;
+	case 0x03:	/* low byte input, high byte input */
+		s->io_bits = 0x0000;
+		break;
 	}
+	/* read DIO port state */
+	s->state = inw(dev->iobase + PCI1723_READ_DIGITAL_INPUT_DATA);
 
 	devpriv->valid = 1;
 
-- 
1.7.11

