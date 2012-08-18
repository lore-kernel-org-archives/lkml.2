Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755739Ab2HRBFv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 21:05:51 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:20152 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752907Ab2HRBFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 21:05:43 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-13.tower-132.messagelabs.com!1345251889!13561938!44
X-Originating-IP: [216.166.12.178]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 02/20] staging: comedi: adv_pci1710: remove devpriv and this_board macros
Date: Fri, 17 Aug 2012 18:05:22 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208171805.23353.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These macros rely on a local variable having a specific name. Remove
them and use the comedi_board() helper to get the this_board pointer.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/adv_pci1710.c | 44 ++++++++++++++++++++++++----
 1 file changed, 39 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adv_pci1710.c b/drivers/staging/comedi/drivers/adv_pci1710.c
index 7c4f0de..7f27c59 100644
--- a/drivers/staging/comedi/drivers/adv_pci1710.c
+++ b/drivers/staging/comedi/drivers/adv_pci1710.c
@@ -269,9 +269,6 @@ struct pci1710_private {
 					 * internal state */
 };
 
-#define devpriv ((struct pci1710_private *)dev->private)
-#define this_board ((const struct boardtype *)dev->board_ptr)
-
 /*
 ==============================================================================
 */
@@ -304,8 +301,10 @@ static int pci171x_insn_read_ai(struct comedi_device *dev,
 				struct comedi_subdevice *s,
 				struct comedi_insn *insn, unsigned int *data)
 {
+	struct pci1710_private *devpriv = dev->private;
 	int n, timeout;
 #ifdef PCI171x_PARANOIDCHECK
+	const struct boardtype *this_board = comedi_board(dev);
 	unsigned int idata;
 #endif
 
@@ -359,6 +358,7 @@ static int pci171x_insn_write_ao(struct comedi_device *dev,
 				 struct comedi_subdevice *s,
 				 struct comedi_insn *insn, unsigned int *data)
 {
+	struct pci1710_private *devpriv = dev->private;
 	int n, chan, range, ofs;
 
 	chan = CR_CHAN(insn->chanspec);
@@ -391,6 +391,7 @@ static int pci171x_insn_read_ao(struct comedi_device *dev,
 				struct comedi_subdevice *s,
 				struct comedi_insn *insn, unsigned int *data)
 {
+	struct pci1710_private *devpriv = dev->private;
 	int n, chan;
 
 	chan = CR_CHAN(insn->chanspec);
@@ -461,6 +462,7 @@ static int pci171x_insn_counter_write(struct comedi_device *dev,
 				      struct comedi_insn *insn,
 				      unsigned int *data)
 {
+	struct pci1710_private *devpriv = dev->private;
 	uint msb, lsb, ccntrl, status;
 
 	lsb = data[0] & 0x00FF;
@@ -492,6 +494,7 @@ static int pci171x_insn_counter_config(struct comedi_device *dev,
 {
 #ifdef unused
 	/* This doesn't work like a normal Comedi counter config */
+	struct pci1710_private *devpriv = dev->private;
 	uint ccntrl = 0;
 
 	devpriv->cnt0_write_wait = data[0] & 0x20;
@@ -527,6 +530,7 @@ static int pci1720_insn_write_ao(struct comedi_device *dev,
 				 struct comedi_subdevice *s,
 				 struct comedi_insn *insn, unsigned int *data)
 {
+	struct pci1710_private *devpriv = dev->private;
 	int n, rangereg, chan;
 
 	chan = CR_CHAN(insn->chanspec);
@@ -553,9 +557,11 @@ static int pci1720_insn_write_ao(struct comedi_device *dev,
 static void interrupt_pci1710_every_sample(void *d)
 {
 	struct comedi_device *dev = d;
+	struct pci1710_private *devpriv = dev->private;
 	struct comedi_subdevice *s = dev->subdevices + 0;
 	int m;
 #ifdef PCI171x_PARANOIDCHECK
+	const struct boardtype *this_board = comedi_board(dev);
 	short sampl;
 #endif
 
@@ -633,8 +639,10 @@ static void interrupt_pci1710_every_sample(void *d)
 static int move_block_from_fifo(struct comedi_device *dev,
 				struct comedi_subdevice *s, int n, int turn)
 {
+	struct pci1710_private *devpriv = dev->private;
 	int i, j;
 #ifdef PCI171x_PARANOIDCHECK
+	const struct boardtype *this_board = comedi_board(dev);
 	int sampl;
 #endif
 
@@ -677,6 +685,8 @@ static int move_block_from_fifo(struct comedi_device *dev,
 static void interrupt_pci1710_half_fifo(void *d)
 {
 	struct comedi_device *dev = d;
+	const struct boardtype *this_board = comedi_board(dev);
+	struct pci1710_private *devpriv = dev->private;
 	struct comedi_subdevice *s = dev->subdevices + 0;
 	int m, samplesinbuf;
 
@@ -731,6 +741,7 @@ static void interrupt_pci1710_half_fifo(void *d)
 static irqreturn_t interrupt_service_pci1710(int irq, void *d)
 {
 	struct comedi_device *dev = d;
+	struct pci1710_private *devpriv = dev->private;
 
 	if (!dev->attached)	/*  is device attached? */
 		return IRQ_NONE;	/*  no, exit */
@@ -766,6 +777,8 @@ static irqreturn_t interrupt_service_pci1710(int irq, void *d)
 static int pci171x_ai_docmd_and_mode(int mode, struct comedi_device *dev,
 				     struct comedi_subdevice *s)
 {
+	const struct boardtype *this_board = comedi_board(dev);
+	struct pci1710_private *devpriv = dev->private;
 	unsigned int divisor1 = 0, divisor2 = 0;
 	unsigned int seglen;
 
@@ -846,6 +859,8 @@ static int pci171x_ai_cmdtest(struct comedi_device *dev,
 			      struct comedi_subdevice *s,
 			      struct comedi_cmd *cmd)
 {
+	const struct boardtype *this_board = comedi_board(dev);
+	struct pci1710_private *devpriv = dev->private;
 	int err = 0;
 	int tmp;
 	unsigned int divisor1 = 0, divisor2 = 0;
@@ -981,6 +996,7 @@ static int pci171x_ai_cmdtest(struct comedi_device *dev,
 */
 static int pci171x_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 {
+	struct pci1710_private *devpriv = dev->private;
 	struct comedi_cmd *cmd = &s->async->cmd;
 
 	devpriv->ai_n_chan = cmd->chanlist_len;
@@ -1075,6 +1091,8 @@ static void setup_channel_list(struct comedi_device *dev,
 			       unsigned int *chanlist, unsigned int n_chan,
 			       unsigned int seglen)
 {
+	const struct boardtype *this_board = comedi_board(dev);
+	struct pci1710_private *devpriv = dev->private;
 	unsigned int i, range, chanprog;
 
 	devpriv->act_chanlist_len = seglen;
@@ -1128,6 +1146,9 @@ static void start_pacer(struct comedi_device *dev, int mode,
 static int pci171x_ai_cancel(struct comedi_device *dev,
 			     struct comedi_subdevice *s)
 {
+	const struct boardtype *this_board = comedi_board(dev);
+	struct pci1710_private *devpriv = dev->private;
+
 	switch (this_board->cardtype) {
 	default:
 		devpriv->CntrlReg &= Control_CNT0;
@@ -1154,6 +1175,9 @@ static int pci171x_ai_cancel(struct comedi_device *dev,
 */
 static int pci171x_reset(struct comedi_device *dev)
 {
+	const struct boardtype *this_board = comedi_board(dev);
+	struct pci1710_private *devpriv = dev->private;
+
 	outw(0x30, dev->iobase + PCI171x_CNTCTRL);
 	devpriv->CntrlReg = Control_SW | Control_CNT0;	/*  Software trigger, CNT0=external */
 	outw(devpriv->CntrlReg, dev->iobase + PCI171x_CONTROL);	/*  reset any operations */
@@ -1182,6 +1206,8 @@ static int pci171x_reset(struct comedi_device *dev)
 */
 static int pci1720_reset(struct comedi_device *dev)
 {
+	struct pci1710_private *devpriv = dev->private;
+
 	outb(Syncont_SC0, dev->iobase + PCI1720_SYNCONT);	/*  set synchronous output mode */
 	devpriv->da_ranges = 0xAA;
 	outb(devpriv->da_ranges, dev->iobase + PCI1720_RANGE);	/*  set all ranges to +/-5V */
@@ -1202,6 +1228,8 @@ static int pci1720_reset(struct comedi_device *dev)
 */
 static int pci1710_reset(struct comedi_device *dev)
 {
+	const struct boardtype *this_board = comedi_board(dev);
+
 	switch (this_board->cardtype) {
 	case TYPE_PCI1720:
 		return pci1720_reset(dev);
@@ -1213,6 +1241,7 @@ static int pci1710_reset(struct comedi_device *dev)
 static struct pci_dev *pci1710_find_pci_dev(struct comedi_device *dev,
 					    struct comedi_devconfig *it)
 {
+	const struct boardtype *this_board = comedi_board(dev);
 	struct pci_dev *pcidev = NULL;
 	int bus = it->options[0];
 	int slot = it->options[1];
@@ -1252,6 +1281,8 @@ static struct pci_dev *pci1710_find_pci_dev(struct comedi_device *dev,
 static int pci1710_attach(struct comedi_device *dev,
 			  struct comedi_devconfig *it)
 {
+	const struct boardtype *this_board;
+	struct pci1710_private *devpriv;
 	struct pci_dev *pcidev;
 	struct comedi_subdevice *s;
 	int ret, subdev, n_subdevices;
@@ -1259,14 +1290,16 @@ static int pci1710_attach(struct comedi_device *dev,
 
 	dev_info(dev->class_dev, DRV_NAME ": attach\n");
 
-	ret = alloc_private(dev, sizeof(struct pci1710_private));
+	ret = alloc_private(dev, sizeof(*devpriv));
 	if (ret < 0)
 		return -ENOMEM;
+	devpriv = dev->private;
 
 	pcidev = pci1710_find_pci_dev(dev, it);
 	if (!pcidev)
 		return -EIO;
 	comedi_set_hw_dev(dev, &pcidev->dev);
+	this_board = comedi_board(dev);
 
 	ret = comedi_pci_enable(pcidev, DRV_NAME);
 	if (ret)
@@ -1408,9 +1441,10 @@ static int pci1710_attach(struct comedi_device *dev,
 
 static void pci1710_detach(struct comedi_device *dev)
 {
+	struct pci1710_private *devpriv = dev->private;
 	struct pci_dev *pcidev = comedi_to_pci_dev(dev);
 
-	if (dev->private) {
+	if (devpriv) {
 		if (devpriv->valid)
 			pci1710_reset(dev);
 		if (dev->irq)
-- 
1.7.11

