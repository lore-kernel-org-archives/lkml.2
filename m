Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030494Ab2HQCs1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 22:48:27 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:46635 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030317Ab2HQCs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 22:48:26 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-6.tower-209.messagelabs.com!1345171704!7666534!1
X-Originating-IP: [216.166.12.97]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 16/35] staging: comedi: cb_pcimdda: remove forward declarations
Date: Thu, 16 Aug 2012 19:48:14 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208161948.14666.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move a couple of the functions in order to remove the need for
the forward declarations.

Also, remove the unnecessary comments.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_pcimdda.c | 241 +++++++++++-----------------
 1 file changed, 94 insertions(+), 147 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcimdda.c b/drivers/staging/comedi/drivers/cb_pcimdda.c
index 04b9995..75e803a 100644
--- a/drivers/staging/comedi/drivers/cb_pcimdda.c
+++ b/drivers/staging/comedi/drivers/cb_pcimdda.c
@@ -149,141 +149,12 @@ struct board_private_struct {
 
 };
 
-static int ao_winsn(struct comedi_device *dev, struct comedi_subdevice *s,
-		    struct comedi_insn *insn, unsigned int *data);
-static int ao_rinsn(struct comedi_device *dev, struct comedi_subdevice *s,
-		    struct comedi_insn *insn, unsigned int *data);
-
-/*---------------------------------------------------------------------------
-  HELPER FUNCTION DECLARATIONS
------------------------------------------------------------------------------*/
-
 /* returns a maxdata value for a given n_bits */
 static inline unsigned int figure_out_maxdata(int bits)
 {
 	return ((unsigned int)1 << bits) - 1;
 }
 
-/*
- *  Probes for a supported device.
- *
- *  Prerequisite: private be allocated already inside dev
- *
- *  If the device is found, it returns 0 and has the following side effects:
- *
- *  o  assigns a struct pci_dev * to dev->private->pci_dev
- *  o  assigns a struct board * to dev->board_ptr
- *  o  sets dev->private->registers
- *  o  sets dev->private->dio_registers
- *
- *  Otherwise, returns a -errno on error
- */
-static int probe(struct comedi_device *dev, const struct comedi_devconfig *it);
-
-/*---------------------------------------------------------------------------
-  FUNCTION DEFINITIONS
------------------------------------------------------------------------------*/
-
-/*
- * Attach is called by the Comedi core to configure the driver
- * for a particular board.  If you specified a board_name array
- * in the driver structure, dev->board_ptr contains that
- * address.
- */
-static int attach(struct comedi_device *dev, struct comedi_devconfig *it)
-{
-	const struct board_struct *thisboard;
-	struct board_private_struct *devpriv;
-	struct comedi_subdevice *s;
-	int err;
-
-	err = alloc_private(dev, sizeof(*devpriv));
-	if (err)
-		return err;
-	devpriv = dev->private;
-
-/*
- * If you can probe the device to determine what device in a series
- * it is, this is the place to do it.  Otherwise, dev->board_ptr
- * should already be initialized.
- */
-	err = probe(dev, it);
-	if (err)
-		return err;
-	thisboard = comedi_board(dev);
-
-/* Output some info */
-	printk("comedi%d: %s: ", dev->minor, thisboard->name);
-
-/*
- * Initialize dev->board_name.  Note that we can use the "thisboard"
- * macro now, since we just initialized it in the last line.
- */
-	dev->board_name = thisboard->name;
-
-	err = comedi_alloc_subdevices(dev, 2);
-	if (err)
-		return err;
-
-	s = dev->subdevices + 0;
-
-	/* analog output subdevice */
-	s->type = COMEDI_SUBD_AO;
-	s->subdev_flags = SDF_WRITABLE | SDF_READABLE;
-	s->n_chan = thisboard->ao_chans;
-	s->maxdata = figure_out_maxdata(thisboard->ao_bits);
-	/* this is hard-coded here */
-	if (it->options[2])
-		s->range_table = &range_bipolar10;
-	else
-		s->range_table = &range_bipolar5;
-	s->insn_write = &ao_winsn;
-	s->insn_read = &ao_rinsn;
-
-	s = dev->subdevices + 1;
-	/* digital i/o subdevice */
-	if (thisboard->dio_chans) {
-		switch (thisboard->dio_method) {
-		case DIO_8255:
-			/*
-			 * this is a straight 8255, so register us with
-			 * the 8255 driver
-			 */
-			subdev_8255_init(dev, s, NULL, devpriv->dio_registers);
-			devpriv->attached_to_8255 = 1;
-			break;
-		case DIO_INTERNAL:
-		default:
-			printk("DIO_INTERNAL not implemented yet!\n");
-			return -ENXIO;
-			break;
-		}
-	} else {
-		s->type = COMEDI_SUBD_UNUSED;
-	}
-
-	printk("attached\n");
-
-	return 1;
-}
-
-static void detach(struct comedi_device *dev)
-{
-	struct board_private_struct *devpriv = dev->private;
-
-	if (devpriv) {
-		if (dev->subdevices && devpriv->attached_to_8255) {
-			subdev_8255_cleanup(dev, dev->subdevices + 2);
-			devpriv->attached_to_8255 = 0;
-		}
-		if (devpriv->pci_dev) {
-			if (devpriv->registers)
-				comedi_pci_disable(devpriv->pci_dev);
-			pci_dev_put(devpriv->pci_dev);
-		}
-	}
-}
-
 static int ao_winsn(struct comedi_device *dev, struct comedi_subdevice *s,
 		    struct comedi_insn *insn, unsigned int *data)
 {
@@ -344,24 +215,6 @@ static int ao_rinsn(struct comedi_device *dev, struct comedi_subdevice *s,
 	return i;
 }
 
-/*---------------------------------------------------------------------------
-  HELPER FUNCTION DEFINITIONS
------------------------------------------------------------------------------*/
-
-/*
- *  Probes for a supported device.
- *
- *  Prerequisite: private be allocated already inside dev
- *
- *  If the device is found, it returns 0 and has the following side effects:
- *
- *  o  assigns a struct pci_dev * to dev->private->pci_dev
- *  o  assigns a struct board * to dev->board_ptr
- *  o  sets dev->private->registers
- *  o  sets dev->private->dio_registers
- *
- *  Otherwise, returns a -errno on error
- */
 static int probe(struct comedi_device *dev, const struct comedi_devconfig *it)
 {
 	const struct board_struct *thisboard;
@@ -411,6 +264,100 @@ static int probe(struct comedi_device *dev, const struct comedi_devconfig *it)
 	return -ENODEV;
 }
 
+static int attach(struct comedi_device *dev, struct comedi_devconfig *it)
+{
+	const struct board_struct *thisboard;
+	struct board_private_struct *devpriv;
+	struct comedi_subdevice *s;
+	int err;
+
+	err = alloc_private(dev, sizeof(*devpriv));
+	if (err)
+		return err;
+	devpriv = dev->private;
+
+/*
+ * If you can probe the device to determine what device in a series
+ * it is, this is the place to do it.  Otherwise, dev->board_ptr
+ * should already be initialized.
+ */
+	err = probe(dev, it);
+	if (err)
+		return err;
+	thisboard = comedi_board(dev);
+
+/* Output some info */
+	printk("comedi%d: %s: ", dev->minor, thisboard->name);
+
+/*
+ * Initialize dev->board_name.  Note that we can use the "thisboard"
+ * macro now, since we just initialized it in the last line.
+ */
+	dev->board_name = thisboard->name;
+
+	err = comedi_alloc_subdevices(dev, 2);
+	if (err)
+		return err;
+
+	s = dev->subdevices + 0;
+
+	/* analog output subdevice */
+	s->type = COMEDI_SUBD_AO;
+	s->subdev_flags = SDF_WRITABLE | SDF_READABLE;
+	s->n_chan = thisboard->ao_chans;
+	s->maxdata = figure_out_maxdata(thisboard->ao_bits);
+	/* this is hard-coded here */
+	if (it->options[2])
+		s->range_table = &range_bipolar10;
+	else
+		s->range_table = &range_bipolar5;
+	s->insn_write = &ao_winsn;
+	s->insn_read = &ao_rinsn;
+
+	s = dev->subdevices + 1;
+	/* digital i/o subdevice */
+	if (thisboard->dio_chans) {
+		switch (thisboard->dio_method) {
+		case DIO_8255:
+			/*
+			 * this is a straight 8255, so register us with
+			 * the 8255 driver
+			 */
+			subdev_8255_init(dev, s, NULL, devpriv->dio_registers);
+			devpriv->attached_to_8255 = 1;
+			break;
+		case DIO_INTERNAL:
+		default:
+			printk("DIO_INTERNAL not implemented yet!\n");
+			return -ENXIO;
+			break;
+		}
+	} else {
+		s->type = COMEDI_SUBD_UNUSED;
+	}
+
+	printk("attached\n");
+
+	return 1;
+}
+
+static void detach(struct comedi_device *dev)
+{
+	struct board_private_struct *devpriv = dev->private;
+
+	if (devpriv) {
+		if (dev->subdevices && devpriv->attached_to_8255) {
+			subdev_8255_cleanup(dev, dev->subdevices + 2);
+			devpriv->attached_to_8255 = 0;
+		}
+		if (devpriv->pci_dev) {
+			if (devpriv->registers)
+				comedi_pci_disable(devpriv->pci_dev);
+			pci_dev_put(devpriv->pci_dev);
+		}
+	}
+}
+
 static struct comedi_driver cb_pcimdda_driver = {
 	.driver_name	= "cb_pcimdda",
 	.module		= THIS_MODULE,
-- 
1.7.11

