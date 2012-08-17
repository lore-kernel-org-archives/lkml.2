Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030459Ab2HQCqA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 22:46:00 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:52560 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933175Ab2HQCp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 22:45:58 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-16.tower-132.messagelabs.com!1345171531!13459104!2
X-Originating-IP: [216.166.12.98]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 09/35] staging: comedi: cb_pcidda: remove forward declarations
Date: Thu, 16 Aug 2012 19:45:30 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208161945.30701.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move a couple of the functions in order to remove the need for
the forward declarations.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_pcidda.c | 389 ++++++++++++++---------------
 1 file changed, 184 insertions(+), 205 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidda.c b/drivers/staging/comedi/drivers/cb_pcidda.c
index 63f5d70..8a66e1a 100644
--- a/drivers/staging/comedi/drivers/cb_pcidda.c
+++ b/drivers/staging/comedi/drivers/cb_pcidda.c
@@ -224,160 +224,6 @@ struct cb_pcidda_private {
 	u16 eeprom_data[EEPROM_SIZE];	/*  software copy of board's eeprom */
 };
 
-/* static int cb_pcidda_ai_rinsn(struct comedi_device *dev,struct comedi_subdevice *s,struct comedi_insn *insn,unsigned int *data); */
-static int cb_pcidda_ao_winsn(struct comedi_device *dev,
-			      struct comedi_subdevice *s,
-			      struct comedi_insn *insn, unsigned int *data);
-
-/* static int cb_pcidda_ai_cmd(struct comedi_device *dev, struct *comedi_subdevice *s);*/
-/* static int cb_pcidda_ai_cmdtest(struct comedi_device *dev, struct comedi_subdevice *s, struct comedi_cmd *cmd); */
-/* static int cb_pcidda_ns_to_timer(unsigned int *ns,int *round); */
-
-static unsigned int cb_pcidda_serial_in(struct comedi_device *dev);
-static void cb_pcidda_serial_out(struct comedi_device *dev, unsigned int value,
-				 unsigned int num_bits);
-static unsigned int cb_pcidda_read_eeprom(struct comedi_device *dev,
-					  unsigned int address);
-static void cb_pcidda_calibrate(struct comedi_device *dev, unsigned int channel,
-				unsigned int range);
-
-static struct pci_dev *cb_pcidda_find_pci_dev(struct comedi_device *dev,
-					      struct comedi_devconfig *it)
-{
-	struct pci_dev *pcidev = NULL;
-	int bus = it->options[0];
-	int slot = it->options[1];
-	int i;
-
-	for_each_pci_dev(pcidev) {
-		if (bus || slot) {
-			if (bus != pcidev->bus->number ||
-			    slot != PCI_SLOT(pcidev->devfn))
-				continue;
-		}
-		if (pcidev->vendor != PCI_VENDOR_ID_CB)
-			continue;
-
-		for (i = 0; i < ARRAY_SIZE(cb_pcidda_boards); i++) {
-			if (cb_pcidda_boards[i].device_id != pcidev->device)
-				continue;
-			dev->board_ptr = cb_pcidda_boards + i;
-			return pcidev;
-		}
-	}
-	dev_err(dev->class_dev,
-		"No supported board found! (req. bus %d, slot %d)\n",
-		bus, slot);
-	return NULL;
-}
-
-/*
- * Attach is called by the Comedi core to configure the driver
- * for a particular board.
- */
-static int cb_pcidda_attach(struct comedi_device *dev,
-			    struct comedi_devconfig *it)
-{
-	const struct cb_pcidda_board *thisboard;
-	struct cb_pcidda_private *devpriv;
-	struct pci_dev *pcidev;
-	struct comedi_subdevice *s;
-	int index;
-	int ret;
-
-	ret = alloc_private(dev, sizeof(*devpriv));
-	if (ret)
-		return ret;
-	devpriv = dev->private;
-
-	pcidev = cb_pcidda_find_pci_dev(dev, it);
-	if (!pcidev)
-		return -EIO;
-	comedi_set_hw_dev(dev, &pcidev->dev);
-	thisboard = comedi_board(dev);
-
-	/*
-	 * Enable PCI device and request regions.
-	 */
-	if (comedi_pci_enable(pcidev, thisboard->name)) {
-		dev_err(dev->class_dev,
-			"cb_pcidda: failed to enable PCI device and request regions\n");
-		return -EIO;
-	}
-
-/*
- * Allocate the I/O ports.
- */
-	devpriv->digitalio = pci_resource_start(pcidev, DIGITALIO_BADRINDEX);
-	devpriv->dac = pci_resource_start(pcidev, DAC_BADRINDEX);
-	dev->iobase = devpriv->dac;
-
-/*
- * Warn about the status of the driver.
- */
-	if (thisboard->status == 2)
-		printk
-		    ("WARNING: DRIVER FOR THIS BOARD NOT CHECKED WITH MANUAL. "
-		     "WORKS ASSUMING FULL COMPATIBILITY WITH PCI-DDA08/12. "
-		     "PLEASE REPORT USAGE TO <ivanmr@altavista.com>.\n");
-
-/*
- * Initialize dev->board_name.
- */
-	dev->board_name = thisboard->name;
-
-	ret = comedi_alloc_subdevices(dev, 3);
-	if (ret)
-		return ret;
-
-	s = dev->subdevices + 0;
-	/* analog output subdevice */
-	s->type = COMEDI_SUBD_AO;
-	s->subdev_flags = SDF_WRITABLE;
-	s->n_chan = thisboard->ao_chans;
-	s->maxdata = (1 << thisboard->ao_bits) - 1;
-	s->range_table = thisboard->ranges;
-	s->insn_write = cb_pcidda_ao_winsn;
-
-	/* s->subdev_flags |= SDF_CMD_READ; */
-	/* s->do_cmd = cb_pcidda_ai_cmd; */
-	/* s->do_cmdtest = cb_pcidda_ai_cmdtest; */
-
-	/*  two 8255 digital io subdevices */
-	s = dev->subdevices + 1;
-	subdev_8255_init(dev, s, NULL, devpriv->digitalio);
-	s = dev->subdevices + 2;
-	subdev_8255_init(dev, s, NULL, devpriv->digitalio + PORT2A);
-
-	dev_dbg(dev->class_dev, "eeprom:\n");
-	for (index = 0; index < EEPROM_SIZE; index++) {
-		devpriv->eeprom_data[index] = cb_pcidda_read_eeprom(dev, index);
-		dev_dbg(dev->class_dev, "%i:0x%x\n", index,
-			devpriv->eeprom_data[index]);
-	}
-
-	/*  set calibrations dacs */
-	for (index = 0; index < thisboard->ao_chans; index++)
-		cb_pcidda_calibrate(dev, index, devpriv->ao_range[index]);
-
-	return 1;
-}
-
-static void cb_pcidda_detach(struct comedi_device *dev)
-{
-	struct pci_dev *pcidev = comedi_to_pci_dev(dev);
-
-	if (pcidev) {
-		if (dev->iobase)
-			comedi_pci_disable(pcidev);
-		pci_dev_put(pcidev);
-	}
-	if (dev->subdevices) {
-		subdev_8255_cleanup(dev, dev->subdevices + 1);
-		subdev_8255_cleanup(dev, dev->subdevices + 2);
-	}
-}
-
 /*
  * I will program this later... ;-)
  */
@@ -572,57 +418,6 @@ static int cb_pcidda_ns_to_timer(unsigned int *ns, int round)
 }
 #endif
 
-static int cb_pcidda_ao_winsn(struct comedi_device *dev,
-			      struct comedi_subdevice *s,
-			      struct comedi_insn *insn, unsigned int *data)
-{
-	struct cb_pcidda_private *devpriv = dev->private;
-	unsigned int command;
-	unsigned int channel, range;
-
-	channel = CR_CHAN(insn->chanspec);
-	range = CR_RANGE(insn->chanspec);
-
-	/*  adjust calibration dacs if range has changed */
-	if (range != devpriv->ao_range[channel])
-		cb_pcidda_calibrate(dev, channel, range);
-
-	/* output channel configuration */
-	command = NOSU | ENABLEDAC;
-
-	/* output channel range */
-	switch (range) {
-	case 0:
-		command |= BIP | RANGE10V;
-		break;
-	case 1:
-		command |= BIP | RANGE5V;
-		break;
-	case 2:
-		command |= BIP | RANGE2V5;
-		break;
-	case 3:
-		command |= UNIP | RANGE10V;
-		break;
-	case 4:
-		command |= UNIP | RANGE5V;
-		break;
-	case 5:
-		command |= UNIP | RANGE2V5;
-		break;
-	}
-
-	/* output channel specification */
-	command |= channel << 2;
-	outw(command, devpriv->dac + DACONTROL);
-
-	/* write data */
-	outw(data[0], devpriv->dac + DADATA + channel * 2);
-
-	/* return the number of samples read/written */
-	return 1;
-}
-
 /* lowlevel read from eeprom */
 static unsigned int cb_pcidda_serial_in(struct comedi_device *dev)
 {
@@ -824,6 +619,190 @@ static void cb_pcidda_calibrate(struct comedi_device *dev, unsigned int channel,
 			       fine_gain_channel(channel), fine_gain);
 }
 
+static int cb_pcidda_ao_winsn(struct comedi_device *dev,
+			      struct comedi_subdevice *s,
+			      struct comedi_insn *insn, unsigned int *data)
+{
+	struct cb_pcidda_private *devpriv = dev->private;
+	unsigned int command;
+	unsigned int channel, range;
+
+	channel = CR_CHAN(insn->chanspec);
+	range = CR_RANGE(insn->chanspec);
+
+	/*  adjust calibration dacs if range has changed */
+	if (range != devpriv->ao_range[channel])
+		cb_pcidda_calibrate(dev, channel, range);
+
+	/* output channel configuration */
+	command = NOSU | ENABLEDAC;
+
+	/* output channel range */
+	switch (range) {
+	case 0:
+		command |= BIP | RANGE10V;
+		break;
+	case 1:
+		command |= BIP | RANGE5V;
+		break;
+	case 2:
+		command |= BIP | RANGE2V5;
+		break;
+	case 3:
+		command |= UNIP | RANGE10V;
+		break;
+	case 4:
+		command |= UNIP | RANGE5V;
+		break;
+	case 5:
+		command |= UNIP | RANGE2V5;
+		break;
+	}
+
+	/* output channel specification */
+	command |= channel << 2;
+	outw(command, devpriv->dac + DACONTROL);
+
+	/* write data */
+	outw(data[0], devpriv->dac + DADATA + channel * 2);
+
+	/* return the number of samples read/written */
+	return 1;
+}
+
+static struct pci_dev *cb_pcidda_find_pci_dev(struct comedi_device *dev,
+					      struct comedi_devconfig *it)
+{
+	struct pci_dev *pcidev = NULL;
+	int bus = it->options[0];
+	int slot = it->options[1];
+	int i;
+
+	for_each_pci_dev(pcidev) {
+		if (bus || slot) {
+			if (bus != pcidev->bus->number ||
+			    slot != PCI_SLOT(pcidev->devfn))
+				continue;
+		}
+		if (pcidev->vendor != PCI_VENDOR_ID_CB)
+			continue;
+
+		for (i = 0; i < ARRAY_SIZE(cb_pcidda_boards); i++) {
+			if (cb_pcidda_boards[i].device_id != pcidev->device)
+				continue;
+			dev->board_ptr = cb_pcidda_boards + i;
+			return pcidev;
+		}
+	}
+	dev_err(dev->class_dev,
+		"No supported board found! (req. bus %d, slot %d)\n",
+		bus, slot);
+	return NULL;
+}
+
+static int cb_pcidda_attach(struct comedi_device *dev,
+			    struct comedi_devconfig *it)
+{
+	const struct cb_pcidda_board *thisboard;
+	struct cb_pcidda_private *devpriv;
+	struct pci_dev *pcidev;
+	struct comedi_subdevice *s;
+	int index;
+	int ret;
+
+	ret = alloc_private(dev, sizeof(*devpriv));
+	if (ret)
+		return ret;
+	devpriv = dev->private;
+
+	pcidev = cb_pcidda_find_pci_dev(dev, it);
+	if (!pcidev)
+		return -EIO;
+	comedi_set_hw_dev(dev, &pcidev->dev);
+	thisboard = comedi_board(dev);
+
+	/*
+	 * Enable PCI device and request regions.
+	 */
+	if (comedi_pci_enable(pcidev, thisboard->name)) {
+		dev_err(dev->class_dev,
+			"cb_pcidda: failed to enable PCI device and request regions\n");
+		return -EIO;
+	}
+
+/*
+ * Allocate the I/O ports.
+ */
+	devpriv->digitalio = pci_resource_start(pcidev, DIGITALIO_BADRINDEX);
+	devpriv->dac = pci_resource_start(pcidev, DAC_BADRINDEX);
+	dev->iobase = devpriv->dac;
+
+/*
+ * Warn about the status of the driver.
+ */
+	if (thisboard->status == 2)
+		printk
+		    ("WARNING: DRIVER FOR THIS BOARD NOT CHECKED WITH MANUAL. "
+		     "WORKS ASSUMING FULL COMPATIBILITY WITH PCI-DDA08/12. "
+		     "PLEASE REPORT USAGE TO <ivanmr@altavista.com>.\n");
+
+/*
+ * Initialize dev->board_name.
+ */
+	dev->board_name = thisboard->name;
+
+	ret = comedi_alloc_subdevices(dev, 3);
+	if (ret)
+		return ret;
+
+	s = dev->subdevices + 0;
+	/* analog output subdevice */
+	s->type = COMEDI_SUBD_AO;
+	s->subdev_flags = SDF_WRITABLE;
+	s->n_chan = thisboard->ao_chans;
+	s->maxdata = (1 << thisboard->ao_bits) - 1;
+	s->range_table = thisboard->ranges;
+	s->insn_write = cb_pcidda_ao_winsn;
+
+	/* s->subdev_flags |= SDF_CMD_READ; */
+	/* s->do_cmd = cb_pcidda_ai_cmd; */
+	/* s->do_cmdtest = cb_pcidda_ai_cmdtest; */
+
+	/*  two 8255 digital io subdevices */
+	s = dev->subdevices + 1;
+	subdev_8255_init(dev, s, NULL, devpriv->digitalio);
+	s = dev->subdevices + 2;
+	subdev_8255_init(dev, s, NULL, devpriv->digitalio + PORT2A);
+
+	dev_dbg(dev->class_dev, "eeprom:\n");
+	for (index = 0; index < EEPROM_SIZE; index++) {
+		devpriv->eeprom_data[index] = cb_pcidda_read_eeprom(dev, index);
+		dev_dbg(dev->class_dev, "%i:0x%x\n", index,
+			devpriv->eeprom_data[index]);
+	}
+
+	/*  set calibrations dacs */
+	for (index = 0; index < thisboard->ao_chans; index++)
+		cb_pcidda_calibrate(dev, index, devpriv->ao_range[index]);
+
+	return 1;
+}
+
+static void cb_pcidda_detach(struct comedi_device *dev)
+{
+	struct pci_dev *pcidev = comedi_to_pci_dev(dev);
+
+	if (pcidev) {
+		if (dev->iobase)
+			comedi_pci_disable(pcidev);
+		pci_dev_put(pcidev);
+	}
+	if (dev->subdevices) {
+		subdev_8255_cleanup(dev, dev->subdevices + 1);
+		subdev_8255_cleanup(dev, dev->subdevices + 2);
+	}
+}
+
 static struct comedi_driver cb_pcidda_driver = {
 	.driver_name	= "cb_pcidda",
 	.module		= THIS_MODULE,
-- 
1.7.11

