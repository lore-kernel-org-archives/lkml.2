Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582Ab2F0Awj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 20:52:39 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:46814 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755403Ab2F0Awh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 20:52:37 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-9.tower-160.messagelabs.com!1340758355!7874300!1
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 10/36] staging: comedi: cb_pcidas: remove thisboard and devpriv macros
Date: Tue, 26 Jun 2012 17:52:29 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206261752.30032.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'thisboard' and 'devpriv' macros rely on a local variable having
a specific name and yield pointers derived from that local variable.
Replace the macros with local variables where used. use the
comedi_board() helper to get the 'thisboard' pointer.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_pcidas.c | 58 +++++++++++++++++++++++-------
 1 file changed, 46 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas.c b/drivers/staging/comedi/drivers/cb_pcidas.c
index 5c3758c..146d078 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas.c
@@ -404,11 +404,6 @@ static const struct cb_pcidas_board cb_pcidas_boards[] = {
 	 },
 };
 
-/*
- * Useful for shorthand access to the particular board structure
- */
-#define thisboard ((const struct cb_pcidas_board *)dev->board_ptr)
-
 /* this structure is for data unique to this hardware driver.  If
    several hardware drivers keep similar information in this structure,
    feel free to suggest moving the variable to the struct comedi_device struct.  */
@@ -441,14 +436,10 @@ struct cb_pcidas_private {
 	unsigned int calibration_source;
 };
 
-/*
- * most drivers define the following macro to make it easy to
- * access the private structure.
- */
-#define devpriv ((struct cb_pcidas_private *)dev->private)
-
 static inline unsigned int cal_enable_bits(struct comedi_device *dev)
 {
+	struct cb_pcidas_private *devpriv = dev->private;
+
 	return CAL_EN_BIT | CAL_SRC_BITS(devpriv->calibration_source);
 }
 
@@ -460,6 +451,7 @@ static int cb_pcidas_ai_rinsn(struct comedi_device *dev,
 			      struct comedi_subdevice *s,
 			      struct comedi_insn *insn, unsigned int *data)
 {
+	struct cb_pcidas_private *devpriv = dev->private;
 	int n, i;
 	unsigned int bits;
 	static const int timeout = 10000;
@@ -512,6 +504,7 @@ static int cb_pcidas_ai_rinsn(struct comedi_device *dev,
 static int ai_config_calibration_source(struct comedi_device *dev,
 					unsigned int *data)
 {
+	struct cb_pcidas_private *devpriv = dev->private;
 	static const int num_calibration_sources = 8;
 	unsigned int source = data[1];
 
@@ -548,6 +541,7 @@ static int cb_pcidas_ao_nofifo_winsn(struct comedi_device *dev,
 				     struct comedi_insn *insn,
 				     unsigned int *data)
 {
+	struct cb_pcidas_private *devpriv = dev->private;
 	int channel;
 	unsigned long flags;
 
@@ -574,6 +568,7 @@ static int cb_pcidas_ao_fifo_winsn(struct comedi_device *dev,
 				   struct comedi_subdevice *s,
 				   struct comedi_insn *insn, unsigned int *data)
 {
+	struct cb_pcidas_private *devpriv = dev->private;
 	int channel;
 	unsigned long flags;
 
@@ -609,6 +604,8 @@ static int cb_pcidas_ao_readback_insn(struct comedi_device *dev,
 				      struct comedi_insn *insn,
 				      unsigned int *data)
 {
+	struct cb_pcidas_private *devpriv = dev->private;
+
 	data[0] = devpriv->ao_value[CR_CHAN(insn->chanspec)];
 
 	return 1;
@@ -632,6 +629,7 @@ static int wait_for_nvram_ready(unsigned long s5933_base_addr)
 static int nvram_read(struct comedi_device *dev, unsigned int address,
 			uint8_t *data)
 {
+	struct cb_pcidas_private *devpriv = dev->private;
 	unsigned long iobase = devpriv->s5933_config;
 
 	if (wait_for_nvram_ready(iobase) < 0)
@@ -674,6 +672,7 @@ static void write_calibration_bitstream(struct comedi_device *dev,
 					unsigned int bitstream,
 					unsigned int bitstream_length)
 {
+	struct cb_pcidas_private *devpriv = dev->private;
 	static const int write_delay = 1;
 	unsigned int bit;
 
@@ -690,6 +689,7 @@ static void write_calibration_bitstream(struct comedi_device *dev,
 static int caldac_8800_write(struct comedi_device *dev, unsigned int address,
 			     uint8_t value)
 {
+	struct cb_pcidas_private *devpriv = dev->private;
 	static const int num_caldac_channels = 8;
 	static const int bitstream_length = 11;
 	unsigned int bitstream = ((address & 0x7) << 8) | value;
@@ -730,6 +730,8 @@ static int caldac_read_insn(struct comedi_device *dev,
 			    struct comedi_subdevice *s,
 			    struct comedi_insn *insn, unsigned int *data)
 {
+	struct cb_pcidas_private *devpriv = dev->private;
+
 	data[0] = devpriv->caldac_value[CR_CHAN(insn->chanspec)];
 
 	return 1;
@@ -738,6 +740,8 @@ static int caldac_read_insn(struct comedi_device *dev,
 /* 1602/16 pregain offset */
 static int dac08_write(struct comedi_device *dev, unsigned int value)
 {
+	struct cb_pcidas_private *devpriv = dev->private;
+
 	if (devpriv->dac08_value == value)
 		return 1;
 
@@ -767,6 +771,8 @@ static int dac08_read_insn(struct comedi_device *dev,
 			   struct comedi_subdevice *s, struct comedi_insn *insn,
 			   unsigned int *data)
 {
+	struct cb_pcidas_private *devpriv = dev->private;
+
 	data[0] = devpriv->dac08_value;
 
 	return 1;
@@ -774,6 +780,7 @@ static int dac08_read_insn(struct comedi_device *dev,
 
 static int trimpot_7376_write(struct comedi_device *dev, uint8_t value)
 {
+	struct cb_pcidas_private *devpriv = dev->private;
 	static const int bitstream_length = 7;
 	unsigned int bitstream = value & 0x7f;
 	unsigned int register_bits;
@@ -798,6 +805,7 @@ static int trimpot_7376_write(struct comedi_device *dev, uint8_t value)
 static int trimpot_8402_write(struct comedi_device *dev, unsigned int channel,
 			      uint8_t value)
 {
+	struct cb_pcidas_private *devpriv = dev->private;
 	static const int bitstream_length = 10;
 	unsigned int bitstream = ((channel & 0x3) << 8) | (value & 0xff);
 	unsigned int register_bits;
@@ -819,6 +827,9 @@ static int trimpot_8402_write(struct comedi_device *dev, unsigned int channel,
 static int cb_pcidas_trimpot_write(struct comedi_device *dev,
 				   unsigned int channel, unsigned int value)
 {
+	const struct cb_pcidas_board *thisboard = comedi_board(dev);
+	struct cb_pcidas_private *devpriv = dev->private;
+
 	if (devpriv->trimpot_value[channel] == value)
 		return 1;
 
@@ -852,6 +863,7 @@ static int trimpot_read_insn(struct comedi_device *dev,
 			     struct comedi_subdevice *s,
 			     struct comedi_insn *insn, unsigned int *data)
 {
+	struct cb_pcidas_private *devpriv = dev->private;
 	unsigned int channel = CR_CHAN(insn->chanspec);
 
 	data[0] = devpriv->trimpot_value[channel];
@@ -863,6 +875,8 @@ static int cb_pcidas_ai_cmdtest(struct comedi_device *dev,
 				struct comedi_subdevice *s,
 				struct comedi_cmd *cmd)
 {
+	const struct cb_pcidas_board *thisboard = comedi_board(dev);
+	struct cb_pcidas_private *devpriv = dev->private;
 	int err = 0;
 	int tmp;
 	int i, gain, start_chan;
@@ -1039,6 +1053,8 @@ static int cb_pcidas_ai_cmdtest(struct comedi_device *dev,
 static void cb_pcidas_load_counters(struct comedi_device *dev, unsigned int *ns,
 				    int rounding_flags)
 {
+	struct cb_pcidas_private *devpriv = dev->private;
+
 	i8253_cascade_ns_to_timer_2div(TIMER_BASE, &(devpriv->divisor1),
 				       &(devpriv->divisor2), ns,
 				       rounding_flags & TRIG_ROUND_MASK);
@@ -1053,6 +1069,8 @@ static void cb_pcidas_load_counters(struct comedi_device *dev, unsigned int *ns,
 static int cb_pcidas_ai_cmd(struct comedi_device *dev,
 			    struct comedi_subdevice *s)
 {
+	const struct cb_pcidas_board *thisboard = comedi_board(dev);
+	struct cb_pcidas_private *devpriv = dev->private;
 	struct comedi_async *async = s->async;
 	struct comedi_cmd *cmd = &async->cmd;
 	unsigned int bits;
@@ -1147,6 +1165,8 @@ static int cb_pcidas_ao_cmdtest(struct comedi_device *dev,
 				struct comedi_subdevice *s,
 				struct comedi_cmd *cmd)
 {
+	const struct cb_pcidas_board *thisboard = comedi_board(dev);
+	struct cb_pcidas_private *devpriv = dev->private;
 	int err = 0;
 	int tmp;
 
@@ -1263,6 +1283,7 @@ static int cb_pcidas_ao_cmdtest(struct comedi_device *dev,
 static int cb_pcidas_cancel(struct comedi_device *dev,
 			    struct comedi_subdevice *s)
 {
+	struct cb_pcidas_private *devpriv = dev->private;
 	unsigned long flags;
 
 	spin_lock_irqsave(&dev->spinlock, flags);
@@ -1283,6 +1304,8 @@ static int cb_pcidas_ao_inttrig(struct comedi_device *dev,
 				struct comedi_subdevice *s,
 				unsigned int trig_num)
 {
+	const struct cb_pcidas_board *thisboard = comedi_board(dev);
+	struct cb_pcidas_private *devpriv = dev->private;
 	unsigned int num_bytes, num_points = thisboard->fifo_size;
 	struct comedi_async *async = s->async;
 	struct comedi_cmd *cmd = &s->async->cmd;
@@ -1332,6 +1355,7 @@ static int cb_pcidas_ao_inttrig(struct comedi_device *dev,
 static int cb_pcidas_ao_cmd(struct comedi_device *dev,
 			    struct comedi_subdevice *s)
 {
+	struct cb_pcidas_private *devpriv = dev->private;
 	struct comedi_async *async = s->async;
 	struct comedi_cmd *cmd = &async->cmd;
 	unsigned int i;
@@ -1399,6 +1423,7 @@ static int cb_pcidas_ao_cmd(struct comedi_device *dev,
 static int cb_pcidas_ao_cancel(struct comedi_device *dev,
 			       struct comedi_subdevice *s)
 {
+	struct cb_pcidas_private *devpriv = dev->private;
 	unsigned long flags;
 
 	spin_lock_irqsave(&dev->spinlock, flags);
@@ -1416,6 +1441,8 @@ static int cb_pcidas_ao_cancel(struct comedi_device *dev,
 
 static void handle_ao_interrupt(struct comedi_device *dev, unsigned int status)
 {
+	const struct cb_pcidas_board *thisboard = comedi_board(dev);
+	struct cb_pcidas_private *devpriv = dev->private;
 	struct comedi_subdevice *s = dev->write_subdev;
 	struct comedi_async *async = s->async;
 	struct comedi_cmd *cmd = &async->cmd;
@@ -1472,6 +1499,8 @@ static void handle_ao_interrupt(struct comedi_device *dev, unsigned int status)
 static irqreturn_t cb_pcidas_interrupt(int irq, void *d)
 {
 	struct comedi_device *dev = (struct comedi_device *)d;
+	const struct cb_pcidas_board *thisboard = comedi_board(dev);
+	struct cb_pcidas_private *devpriv = dev->private;
 	struct comedi_subdevice *s = dev->read_subdev;
 	struct comedi_async *async;
 	int status, s5933_status;
@@ -1582,6 +1611,8 @@ static irqreturn_t cb_pcidas_interrupt(int irq, void *d)
 static int cb_pcidas_attach(struct comedi_device *dev,
 			    struct comedi_devconfig *it)
 {
+	const struct cb_pcidas_board *thisboard;
+	struct cb_pcidas_private *devpriv;
 	struct comedi_subdevice *s;
 	struct pci_dev *pcidev = NULL;
 	int index;
@@ -1593,6 +1624,7 @@ static int cb_pcidas_attach(struct comedi_device *dev,
  */
 	if (alloc_private(dev, sizeof(struct cb_pcidas_private)) < 0)
 		return -ENOMEM;
+	devpriv = dev->private;
 
 /*
  * Probe the device to determine what device in the series it is.
@@ -1625,7 +1657,7 @@ static int cb_pcidas_attach(struct comedi_device *dev,
 	return -EIO;
 
 found:
-
+	thisboard = comedi_board(dev);
 	dev_dbg(dev->class_dev, "Found %s on bus %i, slot %i\n",
 		cb_pcidas_boards[index].name, pcidev->bus->number,
 		PCI_SLOT(pcidev->devfn));
@@ -1781,6 +1813,8 @@ found:
 
 static void cb_pcidas_detach(struct comedi_device *dev)
 {
+	struct cb_pcidas_private *devpriv = dev->private;
+
 	if (devpriv) {
 		if (devpriv->s5933_config) {
 			outl(INTCSR_INBOX_INTR_STATUS,
-- 
1.7.11

