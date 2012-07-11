Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932300Ab2GKAX5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 20:23:57 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:41140 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932196Ab2GKAXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 20:23:55 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-4.tower-131.messagelabs.com!1341966233!22998106!2
X-Originating-IP: [216.166.12.178]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 78/83] staging: comedi: rtd520: remove devpriv macro
Date: Tue, 10 Jul 2012 17:23:40 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207101723.42267.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The macro 'devpriv' relies on a local variable having a specific
name and yeilds a pointer derived from that local variable. Replace
the macro with a local variable where used.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/rtd520.c | 29 ++++++++++++++++++++++-------
 1 file changed, 22 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/comedi/drivers/rtd520.c
index a524039..8ea0db1 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -399,12 +399,6 @@ struct rtdPrivate {
 	(((array)[(index)/8] &= ~(1 << ((index) & 0x7))))
 
 /*
- * most drivers define the following macro to make it easy to
- * access the private structure.
- */
-#define devpriv ((struct rtdPrivate *)dev->private)
-
-/*
   Given a desired period and the clock period (both in ns),
   return the proper counter value (divider-1).
   Sets the original period to be the true value.
@@ -453,6 +447,7 @@ static int rtd_ns_to_timer(unsigned int *ns, int round_mode)
 static unsigned short rtdConvertChanGain(struct comedi_device *dev,
 					 unsigned int comediChan, int chanIndex)
 {				/* index in channel list */
+	struct rtdPrivate *devpriv = dev->private;
 	unsigned int chan, range, aref;
 	unsigned short r = 0;
 
@@ -505,6 +500,8 @@ static unsigned short rtdConvertChanGain(struct comedi_device *dev,
 static void rtd_load_channelgain_list(struct comedi_device *dev,
 				      unsigned int n_chan, unsigned int *list)
 {
+	struct rtdPrivate *devpriv = dev->private;
+
 	if (n_chan > 1) {	/* setup channel gain table */
 		int ii;
 
@@ -525,6 +522,7 @@ static void rtd_load_channelgain_list(struct comedi_device *dev,
 empty status flag clears */
 static int rtd520_probe_fifo_depth(struct comedi_device *dev)
 {
+	struct rtdPrivate *devpriv = dev->private;
 	unsigned int chanspec = CR_PACK(0, 0, AREF_GROUND);
 	unsigned i;
 	static const unsigned limit = 0x2000;
@@ -572,6 +570,7 @@ static int rtd_ai_rinsn(struct comedi_device *dev,
 			struct comedi_subdevice *s, struct comedi_insn *insn,
 			unsigned int *data)
 {
+	struct rtdPrivate *devpriv = dev->private;
 	int n, ii;
 	int stat;
 
@@ -627,6 +626,7 @@ static int rtd_ai_rinsn(struct comedi_device *dev,
 static int ai_read_n(struct comedi_device *dev, struct comedi_subdevice *s,
 		     int count)
 {
+	struct rtdPrivate *devpriv = dev->private;
 	int ii;
 
 	for (ii = 0; ii < count; ii++) {
@@ -667,6 +667,8 @@ static int ai_read_n(struct comedi_device *dev, struct comedi_subdevice *s,
 */
 static int ai_read_dregs(struct comedi_device *dev, struct comedi_subdevice *s)
 {
+	struct rtdPrivate *devpriv = dev->private;
+
 	while (readl(devpriv->las0 + LAS0_ADC) & FS_ADC_NOT_EMPTY) {
 		short sample;
 		s16 d = readw(devpriv->las1 + LAS1_ADC_FIFO);
@@ -697,6 +699,7 @@ static int ai_read_dregs(struct comedi_device *dev, struct comedi_subdevice *s)
 */
 void abort_dma(struct comedi_device *dev, unsigned int channel)
 {				/* DMA channel 0, 1 */
+	struct rtdPrivate *devpriv = dev->private;
 	unsigned long dma_cs_addr;	/* the control/status register */
 	uint8_t status;
 	unsigned int ii;
@@ -755,6 +758,7 @@ abortDmaExit:
 */
 static int ai_process_dma(struct comedi_device *dev, struct comedi_subdevice *s)
 {
+	struct rtdPrivate *devpriv = dev->private;
 	int ii, n;
 	s16 *dp;
 
@@ -817,8 +821,9 @@ static int ai_process_dma(struct comedi_device *dev, struct comedi_subdevice *s)
 static irqreturn_t rtd_interrupt(int irq,	/* interrupt number (ignored) */
 				 void *d)
 {				/* our data *//* cpu context (ignored) */
-	struct comedi_device *dev = d;	/* must be called "dev" for devpriv */
+	struct comedi_device *dev = d;
 	struct comedi_subdevice *s = dev->subdevices + 0;	/* analog in subdevice */
+	struct rtdPrivate *devpriv = dev->private;
 	u32 overrun;
 	u16 status;
 	u16 fifoStatus;
@@ -1206,6 +1211,7 @@ static int rtd_ai_cmdtest(struct comedi_device *dev,
 */
 static int rtd_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 {
+	struct rtdPrivate *devpriv = dev->private;
 	struct comedi_cmd *cmd = &s->async->cmd;
 	int timer;
 
@@ -1417,6 +1423,7 @@ static int rtd_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 */
 static int rtd_ai_cancel(struct comedi_device *dev, struct comedi_subdevice *s)
 {
+	struct rtdPrivate *devpriv = dev->private;
 	u32 overrun;
 	u16 status;
 
@@ -1449,6 +1456,7 @@ static int rtd_ao_winsn(struct comedi_device *dev,
 			struct comedi_subdevice *s, struct comedi_insn *insn,
 			unsigned int *data)
 {
+	struct rtdPrivate *devpriv = dev->private;
 	int i;
 	int chan = CR_CHAN(insn->chanspec);
 	int range = CR_RANGE(insn->chanspec);
@@ -1511,6 +1519,7 @@ static int rtd_ao_rinsn(struct comedi_device *dev,
 			struct comedi_subdevice *s, struct comedi_insn *insn,
 			unsigned int *data)
 {
+	struct rtdPrivate *devpriv = dev->private;
 	int i;
 	int chan = CR_CHAN(insn->chanspec);
 
@@ -1535,6 +1544,8 @@ static int rtd_dio_insn_bits(struct comedi_device *dev,
 			     struct comedi_subdevice *s,
 			     struct comedi_insn *insn, unsigned int *data)
 {
+	struct rtdPrivate *devpriv = dev->private;
+
 	/* The insn data is a mask in data[0] and the new data
 	 * in data[1], each channel cooresponding to a bit. */
 	if (data[0]) {
@@ -1560,6 +1571,7 @@ static int rtd_dio_insn_config(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
 			       struct comedi_insn *insn, unsigned int *data)
 {
+	struct rtdPrivate *devpriv = dev->private;
 	int chan = CR_CHAN(insn->chanspec);
 
 	/* The input or output configuration of each digital line is
@@ -1599,6 +1611,7 @@ static int rtd_dio_insn_config(struct comedi_device *dev,
 
 static int rtd_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {				/* board name and options flags */
+	struct rtdPrivate *devpriv;
 	struct comedi_subdevice *s;
 	struct pci_dev *pcidev;
 	int ret;
@@ -1623,6 +1636,7 @@ static int rtd_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	 */
 	if (alloc_private(dev, sizeof(struct rtdPrivate)) < 0)
 		return -ENOMEM;
+	devpriv = dev->private;
 
 	/*
 	 * Probe the device to determine what device in the series it is.
@@ -1949,6 +1963,7 @@ static int rtd_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 static void rtd_detach(struct comedi_device *dev)
 {
+	struct rtdPrivate *devpriv = dev->private;
 #ifdef USE_DMA
 	int index;
 #endif
-- 
1.7.11

