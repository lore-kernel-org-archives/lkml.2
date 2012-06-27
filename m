Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757907Ab2F0WBM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 18:01:12 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:39317 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754309Ab2F0WBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 18:01:11 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-15.tower-131.messagelabs.com!1340834468!23483966!6
X-Originating-IP: [216.166.12.69]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 09/19] staging: comedi: adl_pci6208: fix the digital i/o subdevice
Date: Wed, 27 Jun 2012 15:00:50 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206271500.50780.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PCI-6208 board has 4 digital outputs and 4 digital inputs.

The support for the digital i/o subdevice was commented out and
the code was just cut-and-paste from the skel driver. Enable
the digital i/o subdevice by uncommenting the code and fixing
the insn_bits and insn_config functions.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/adl_pci6208.c | 106 +++++++++++++--------------
 1 file changed, 50 insertions(+), 56 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci6208.c b/drivers/staging/comedi/drivers/adl_pci6208.c
index 13cdbcc..e3f459b 100644
--- a/drivers/staging/comedi/drivers/adl_pci6208.c
+++ b/drivers/staging/comedi/drivers/adl_pci6208.c
@@ -137,54 +137,45 @@ static int pci6208_ao_rinsn(struct comedi_device *dev,
 	return i;
 }
 
-/* DIO devices are slightly special.  Although it is possible to
- * implement the insn_read/insn_write interface, it is much more
- * useful to applications if you implement the insn_bits interface.
- * This allows packed reading/writing of the DIO channels.  The
- * comedi core can convert between insn_bits and insn_read/write */
-/* static int pci6208_dio_insn_bits(struct comedi_device *dev,
- *					struct comedi_subdevice *s, */
-/* struct comedi_insn *insn,unsigned int *data) */
-/* { */
-	/* The insn data is a mask in data[0] and the new data
-	 * in data[1], each channel cooresponding to a bit. */
-/* if(data[0]){ */
-/* s->state &= ~data[0]; */
-/* s->state |= data[0]&data[1]; */
-		/* Write out the new digital output lines */
-		/* outw(s->state,dev->iobase + SKEL_DIO); */
-/* } */
-
-	/* on return, data[1] contains the value of the digital
-	 * input and output lines. */
-	/* data[1]=inw(dev->iobase + SKEL_DIO); */
-	/* or we could just return the software copy of the output values if
-	 * it was a purely digital output subdevice */
-	/* data[1]=s->state; */
-
-/* return insn->n; */
-/* } */
-
-/* static int pci6208_dio_insn_config(struct comedi_device *dev,
- *					struct comedi_subdevice *s, */
-/* struct comedi_insn *insn,unsigned int *data) */
-/* { */
-/* int chan=CR_CHAN(insn->chanspec); */
-
-	/* The input or output configuration of each digital line is
-	 * configured by a special insn_config instruction.  chanspec
-	 * contains the channel to be changed, and data[0] contains the
-	 * value COMEDI_INPUT or COMEDI_OUTPUT. */
-
-/* if(data[0]==COMEDI_OUTPUT){ */
-/* s->io_bits |= 1<<chan; */
-/* }else{ */
-/* s->io_bits &= ~(1<<chan); */
-/* } */
-	/* outw(s->io_bits,dev->iobase + SKEL_DIO_CONFIG); */
-
-/* return 1; */
-/* } */
+static int pci6208_dio_insn_bits(struct comedi_device *dev,
+				 struct comedi_subdevice *s,
+				 struct comedi_insn *insn,
+				 unsigned int *data)
+{
+	unsigned int mask = data[0] & PCI6208_DIO_DO_MASK;
+	unsigned int bits = data[1];
+
+	if (mask) {
+		s->state &= ~mask;
+		s->state |= bits & mask;
+
+		outw(s->state, dev->iobase + PCI6208_DIO);
+	}
+
+	s->state = inw(dev->iobase + PCI6208_DIO);
+	data[1] = s->state;
+
+	return insn->n;
+}
+
+static int pci6208_dio_insn_config(struct comedi_device *dev,
+				   struct comedi_subdevice *s,
+				   struct comedi_insn *insn,
+				   unsigned int *data)
+{
+	int chan = CR_CHAN(insn->chanspec);
+	unsigned int mask = 1 << chan;
+
+	switch (data[0]) {
+	case INSN_CONFIG_DIO_QUERY:
+		data[1] = (s->io_bits & mask) ? COMEDI_OUTPUT : COMEDI_INPUT;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return insn->n;
+}
 
 static struct pci_dev *pci6208_find_device(struct comedi_device *dev,
 					   struct comedi_devconfig *it)
@@ -268,15 +259,18 @@ static int pci6208_attach(struct comedi_device *dev,
 	s->insn_write = pci6208_ao_winsn;
 	s->insn_read = pci6208_ao_rinsn;
 
-	/* s=dev->subdevices+1; */
+	s = dev->subdevices + 1;
 	/* digital i/o subdevice */
-	/* s->type=COMEDI_SUBD_DIO; */
-	/* s->subdev_flags=SDF_READABLE|SDF_WRITABLE; */
-	/* s->n_chan=16; */
-	/* s->maxdata=1; */
-	/* s->range_table=&range_digital; */
-	/* s->insn_bits = pci6208_dio_insn_bits; */
-	/* s->insn_config = pci6208_dio_insn_config; */
+	s->type = COMEDI_SUBD_DIO;
+	s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
+	s->n_chan = 8;
+	s->maxdata = 1;
+	s->range_table = &range_digital;
+	s->insn_bits = pci6208_dio_insn_bits;
+	s->insn_config = pci6208_dio_insn_config;
+
+	s->io_bits = 0x0f;
+	s->state = inw(dev->iobase + PCI6208_DIO);
 
 	dev_info(dev->class_dev, "%s: %s, I/O base=0x%04lx\n",
 		dev->driver->driver_name, dev->board_name, dev->iobase);
-- 
1.7.11

