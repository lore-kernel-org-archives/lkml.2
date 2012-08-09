Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759755Ab2HIVvi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 17:51:38 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:30748 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759775Ab2HIVvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 17:51:36 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-13.tower-160.messagelabs.com!1344549076!7888270!16
X-Originating-IP: [216.166.12.97]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/4] staging: comedi: adl_pci6208: split the digital i/o subdevice
Date: Thu, 9 Aug 2012 14:51:26 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208091451.26918.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PCI-6208/6216 cards have 4 digital inputs and 4 digital outputs.
These are currently being handled by an 8 channel COMEDI_SUBD_DIO
subdevice in this driver. This causes the 4 digital outputs to
appear as channels 0 thru 3 and the 4 digital inputs to appear as
channels 4 thru 7. Userspace can only work out part thisby doing the
COMEDI_INSNLIST ioctl with the INSN_CONFIG_DIO_QUERY instruction
for each channel to determine the io direction.

Make things a bit cleaner for userspace by creating two subdevices
instead. One for the 4 digital inputs and one for the 4 digital
outputs. For both subdevices the channel number indicates the
actual digital input/output signal.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/adl_pci6208.c | 78 ++++++++++++++++------------
 1 file changed, 44 insertions(+), 34 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci6208.c b/drivers/staging/comedi/drivers/adl_pci6208.c
index 43e23e1..74695bb 100644
--- a/drivers/staging/comedi/drivers/adl_pci6208.c
+++ b/drivers/staging/comedi/drivers/adl_pci6208.c
@@ -125,46 +125,41 @@ static int pci6208_ao_rinsn(struct comedi_device *dev,
 	return insn->n;
 }
 
-static int pci6208_dio_insn_bits(struct comedi_device *dev,
-				 struct comedi_subdevice *s,
-				 struct comedi_insn *insn,
-				 unsigned int *data)
+static int pci6208_di_insn_bits(struct comedi_device *dev,
+				struct comedi_subdevice *s,
+				struct comedi_insn *insn,
+				unsigned int *data)
 {
-	unsigned int mask = data[0] & PCI6208_DIO_DO_MASK;
+	unsigned int val;
+
+	val = inw(dev->iobase + PCI6208_DIO);
+	val = (val & PCI6208_DIO_DI_MASK) >> PCI6208_DIO_DI_SHIFT;
+
+	data[1] = val;
+
+	return insn->n;
+}
+
+static int pci6208_do_insn_bits(struct comedi_device *dev,
+				struct comedi_subdevice *s,
+				struct comedi_insn *insn,
+				unsigned int *data)
+{
+	unsigned int mask = data[0];
 	unsigned int bits = data[1];
 
 	if (mask) {
 		s->state &= ~mask;
-		s->state |= bits & mask;
+		s->state |= (bits & mask);
 
 		outw(s->state, dev->iobase + PCI6208_DIO);
 	}
 
-	s->state = inw(dev->iobase + PCI6208_DIO);
 	data[1] = s->state;
 
 	return insn->n;
 }
 
-static int pci6208_dio_insn_config(struct comedi_device *dev,
-				   struct comedi_subdevice *s,
-				   struct comedi_insn *insn,
-				   unsigned int *data)
-{
-	int chan = CR_CHAN(insn->chanspec);
-	unsigned int mask = 1 << chan;
-
-	switch (data[0]) {
-	case INSN_CONFIG_DIO_QUERY:
-		data[1] = (s->io_bits & mask) ? COMEDI_OUTPUT : COMEDI_INPUT;
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	return insn->n;
-}
-
 static const void *pci6208_find_boardinfo(struct comedi_device *dev,
 					  struct pci_dev *pcidev)
 {
@@ -185,6 +180,7 @@ static int pci6208_attach_pci(struct comedi_device *dev,
 	const struct pci6208_board *boardinfo;
 	struct pci6208_private *devpriv;
 	struct comedi_subdevice *s;
+	unsigned int val;
 	int ret;
 
 	comedi_set_hw_dev(dev, &pcidev->dev);
@@ -208,7 +204,7 @@ static int pci6208_attach_pci(struct comedi_device *dev,
 	}
 	dev->iobase = pci_resource_start(pcidev, 2);
 
-	ret = comedi_alloc_subdevices(dev, 2);
+	ret = comedi_alloc_subdevices(dev, 3);
 	if (ret)
 		return ret;
 
@@ -223,17 +219,31 @@ static int pci6208_attach_pci(struct comedi_device *dev,
 	s->insn_read	= pci6208_ao_rinsn;
 
 	s = dev->subdevices + 1;
-	/* digital i/o subdevice */
-	s->type		= COMEDI_SUBD_DIO;
-	s->subdev_flags	= SDF_READABLE | SDF_WRITABLE;
-	s->n_chan	= 8;
+	/* digital input subdevice */
+	s->type		= COMEDI_SUBD_DI;
+	s->subdev_flags	= SDF_READABLE;
+	s->n_chan	= 4;
 	s->maxdata	= 1;
 	s->range_table	= &range_digital;
-	s->insn_bits	= pci6208_dio_insn_bits;
-	s->insn_config	= pci6208_dio_insn_config;
+	s->insn_bits	= pci6208_di_insn_bits;
 
+	s = dev->subdevices + 2;
+	/* digital output subdevice */
+	s->type		= COMEDI_SUBD_DO;
+	s->subdev_flags	= SDF_WRITABLE;
+	s->n_chan	= 4;
+	s->maxdata	= 1;
+	s->range_table	= &range_digital;
+	s->insn_bits	= pci6208_do_insn_bits;
+
+	/*
+	 * Get the read back signals from the digital outputs
+	 * and save it as the initial state for the subdevice.
+	 */
+	val = inw(dev->iobase + PCI6208_DIO);
+	val = (val & PCI6208_DIO_DO_MASK) >> PCI6208_DIO_DO_SHIFT;
+	s->state	= val;
 	s->io_bits	= 0x0f;
-	s->state	= inw(dev->iobase + PCI6208_DIO);
 
 	dev_info(dev->class_dev, "%s: %s, I/O base=0x%04lx\n",
 		dev->driver->driver_name, dev->board_name, dev->iobase);
-- 
1.7.11

