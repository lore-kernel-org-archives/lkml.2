Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379Ab2HRBHG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 21:07:06 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:44696 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755706Ab2HRBGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 21:06:48 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-7.tower-209.messagelabs.com!1345252006!7766860!2
X-Originating-IP: [216.166.12.31]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 05/20] staging: comedi: adv_pci1710: remove forward declarations
Date: Fri, 17 Aug 2012 18:06:41 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208171806.41850.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move some of the functions to remove the need for the forward
declarations.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/adv_pci1710.c | 297 +++++++++++++--------------
 1 file changed, 140 insertions(+), 157 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adv_pci1710.c b/drivers/staging/comedi/drivers/adv_pci1710.c
index 5bea385..66bd3858 100644
--- a/drivers/staging/comedi/drivers/adv_pci1710.c
+++ b/drivers/staging/comedi/drivers/adv_pci1710.c
@@ -330,30 +330,108 @@ struct pci1710_private {
 					 * internal state */
 };
 
+/*  used for gain list programming */
+static const unsigned int muxonechan[] = {
+	0x0000, 0x0101, 0x0202, 0x0303, 0x0404, 0x0505, 0x0606, 0x0707,
+	0x0808, 0x0909, 0x0a0a, 0x0b0b, 0x0c0c, 0x0d0d, 0x0e0e, 0x0f0f,
+	0x1010, 0x1111, 0x1212, 0x1313, 0x1414, 0x1515, 0x1616, 0x1717,
+	0x1818, 0x1919, 0x1a1a, 0x1b1b, 0x1c1c, 0x1d1d, 0x1e1e, 0x1f1f
+};
+
 /*
 ==============================================================================
+ Check if channel list from user is builded correctly
+ If it's ok, then program scan/gain logic.
+ This works for all cards.
 */
-
 static int check_channel_list(struct comedi_device *dev,
 			      struct comedi_subdevice *s,
-			      unsigned int *chanlist, unsigned int n_chan);
+			      unsigned int *chanlist, unsigned int n_chan)
+{
+	unsigned int chansegment[32];
+	unsigned int i, nowmustbechan, seglen, segpos;
+
+	/* correct channel and range number check itself comedi/range.c */
+	if (n_chan < 1) {
+		comedi_error(dev, "range/channel list is empty!");
+		return 0;
+	}
+
+	if (n_chan == 1)
+		return 1; /* seglen=1 */
+
+	chansegment[0] = chanlist[0]; /*  first channel is every time ok */
+	for (i = 1, seglen = 1; i < n_chan; i++, seglen++) {
+		if (chanlist[0] == chanlist[i])
+			break;	/*  we detected a loop, stop */
+		if ((CR_CHAN(chanlist[i]) & 1) &&
+		    (CR_AREF(chanlist[i]) == AREF_DIFF)) {
+			comedi_error(dev, "Odd channel cannot be differential input!\n");
+			return 0;
+		}
+		nowmustbechan = (CR_CHAN(chansegment[i - 1]) + 1) % s->n_chan;
+		if (CR_AREF(chansegment[i - 1]) == AREF_DIFF)
+			nowmustbechan = (nowmustbechan + 1) % s->n_chan;
+		if (nowmustbechan != CR_CHAN(chanlist[i])) {
+			printk("channel list must be continuous! chanlist[%i]=%d but must be %d or %d!\n",
+			       i, CR_CHAN(chanlist[i]), nowmustbechan,
+			       CR_CHAN(chanlist[0]));
+			return 0;
+		}
+		chansegment[i] = chanlist[i]; /* next correct channel in list */
+	}
+
+	for (i = 0, segpos = 0; i < n_chan; i++) {
+		if (chanlist[i] != chansegment[i % seglen]) {
+			printk("bad channel, reference or range number! chanlist[%i]=%d,%d,%d and not %d,%d,%d!\n",
+			       i, CR_CHAN(chansegment[i]),
+			       CR_RANGE(chansegment[i]),
+			       CR_AREF(chansegment[i]),
+			       CR_CHAN(chanlist[i % seglen]),
+			       CR_RANGE(chanlist[i % seglen]),
+			       CR_AREF(chansegment[i % seglen]));
+			return 0;
+		}
+	}
+	return seglen;
+}
+
 static void setup_channel_list(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
 			       unsigned int *chanlist, unsigned int n_chan,
-			       unsigned int seglen);
-static void start_pacer(struct comedi_device *dev, int mode,
-			unsigned int divisor1, unsigned int divisor2);
-static int pci1710_reset(struct comedi_device *dev);
-static int pci171x_ai_cancel(struct comedi_device *dev,
-			     struct comedi_subdevice *s);
+			       unsigned int seglen)
+{
+	const struct boardtype *this_board = comedi_board(dev);
+	struct pci1710_private *devpriv = dev->private;
+	unsigned int i, range, chanprog;
 
-/*  used for gain list programming */
-static const unsigned int muxonechan[] = {
-	0x0000, 0x0101, 0x0202, 0x0303, 0x0404, 0x0505, 0x0606, 0x0707,
-	0x0808, 0x0909, 0x0a0a, 0x0b0b, 0x0c0c, 0x0d0d, 0x0e0e, 0x0f0f,
-	0x1010, 0x1111, 0x1212, 0x1313, 0x1414, 0x1515, 0x1616, 0x1717,
-	0x1818, 0x1919, 0x1a1a, 0x1b1b, 0x1c1c, 0x1d1d, 0x1e1e, 0x1f1f
-};
+	devpriv->act_chanlist_len = seglen;
+	devpriv->act_chanlist_pos = 0;
+
+	for (i = 0; i < seglen; i++) {	/*  store range list to card */
+		chanprog = muxonechan[CR_CHAN(chanlist[i])];
+		outw(chanprog, dev->iobase + PCI171x_MUX); /* select channel */
+		range = this_board->rangecode_ai[CR_RANGE(chanlist[i])];
+		if (CR_AREF(chanlist[i]) == AREF_DIFF)
+			range |= 0x0020;
+		outw(range, dev->iobase + PCI171x_RANGE); /* select gain */
+#ifdef PCI171x_PARANOIDCHECK
+		devpriv->act_chanlist[i] =
+			(CR_CHAN(chanlist[i]) << 12) & 0xf000;
+#endif
+	}
+#ifdef PCI171x_PARANOIDCHECK
+	for ( ; i < n_chan; i++) { /* store remainder of channel list */
+		devpriv->act_chanlist[i] =
+			(CR_CHAN(chanlist[i]) << 12) & 0xf000;
+	}
+#endif
+
+	devpriv->ai_et_MuxVal =
+		CR_CHAN(chanlist[0]) | (CR_CHAN(chanlist[seglen - 1]) << 8);
+	/* select channel interval to scan */
+	outw(devpriv->ai_et_MuxVal, dev->iobase + PCI171x_MUX);
+}
 
 /*
 ==============================================================================
@@ -494,6 +572,23 @@ static int pci171x_insn_bits_do(struct comedi_device *dev,
 /*
 ==============================================================================
 */
+static void start_pacer(struct comedi_device *dev, int mode,
+			unsigned int divisor1, unsigned int divisor2)
+{
+	outw(0xb4, dev->iobase + PCI171x_CNTCTRL);
+	outw(0x74, dev->iobase + PCI171x_CNTCTRL);
+
+	if (mode == 1) {
+		outw(divisor2 & 0xff, dev->iobase + PCI171x_CNT2);
+		outw((divisor2 >> 8) & 0xff, dev->iobase + PCI171x_CNT2);
+		outw(divisor1 & 0xff, dev->iobase + PCI171x_CNT1);
+		outw((divisor1 >> 8) & 0xff, dev->iobase + PCI171x_CNT1);
+	}
+}
+
+/*
+==============================================================================
+*/
 static int pci171x_insn_counter_read(struct comedi_device *dev,
 				     struct comedi_subdevice *s,
 				     struct comedi_insn *insn,
@@ -615,6 +710,36 @@ static int pci1720_insn_write_ao(struct comedi_device *dev,
 /*
 ==============================================================================
 */
+static int pci171x_ai_cancel(struct comedi_device *dev,
+			     struct comedi_subdevice *s)
+{
+	const struct boardtype *this_board = comedi_board(dev);
+	struct pci1710_private *devpriv = dev->private;
+
+	switch (this_board->cardtype) {
+	default:
+		devpriv->CntrlReg &= Control_CNT0;
+		devpriv->CntrlReg |= Control_SW;
+
+		outw(devpriv->CntrlReg, dev->iobase + PCI171x_CONTROL);	/*  reset any operations */
+		start_pacer(dev, -1, 0, 0);
+		outb(0, dev->iobase + PCI171x_CLRFIFO);
+		outb(0, dev->iobase + PCI171x_CLRINT);
+		break;
+	}
+
+	devpriv->ai_do = 0;
+	devpriv->ai_act_scan = 0;
+	s->async->cur_chan = 0;
+	devpriv->ai_buf_ptr = 0;
+	devpriv->neverending_ai = 0;
+
+	return 0;
+}
+
+/*
+==============================================================================
+*/
 static void interrupt_pci1710_every_sample(void *d)
 {
 	struct comedi_device *dev = d;
@@ -1091,148 +1216,6 @@ static int pci171x_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 
 /*
 ==============================================================================
- Check if channel list from user is builded correctly
- If it's ok, then program scan/gain logic.
- This works for all cards.
-*/
-static int check_channel_list(struct comedi_device *dev,
-			      struct comedi_subdevice *s,
-			      unsigned int *chanlist, unsigned int n_chan)
-{
-	unsigned int chansegment[32];
-	unsigned int i, nowmustbechan, seglen, segpos;
-
-	/* correct channel and range number check itself comedi/range.c */
-	if (n_chan < 1) {
-		comedi_error(dev, "range/channel list is empty!");
-		return 0;
-	}
-
-	if (n_chan == 1)
-		return 1; /* seglen=1 */
-
-	chansegment[0] = chanlist[0]; /*  first channel is every time ok */
-	for (i = 1, seglen = 1; i < n_chan; i++, seglen++) {
-		if (chanlist[0] == chanlist[i])
-			break;	/*  we detected a loop, stop */
-		if ((CR_CHAN(chanlist[i]) & 1) &&
-		    (CR_AREF(chanlist[i]) == AREF_DIFF)) {
-			comedi_error(dev, "Odd channel cannot be differential input!\n");
-			return 0;
-		}
-		nowmustbechan = (CR_CHAN(chansegment[i - 1]) + 1) % s->n_chan;
-		if (CR_AREF(chansegment[i - 1]) == AREF_DIFF)
-			nowmustbechan = (nowmustbechan + 1) % s->n_chan;
-		if (nowmustbechan != CR_CHAN(chanlist[i])) {
-			printk("channel list must be continuous! chanlist[%i]=%d but must be %d or %d!\n",
-			       i, CR_CHAN(chanlist[i]), nowmustbechan,
-			       CR_CHAN(chanlist[0]));
-			return 0;
-		}
-		chansegment[i] = chanlist[i]; /* next correct channel in list */
-	}
-
-	for (i = 0, segpos = 0; i < n_chan; i++) {
-		if (chanlist[i] != chansegment[i % seglen]) {
-			printk("bad channel, reference or range number! chanlist[%i]=%d,%d,%d and not %d,%d,%d!\n",
-			       i, CR_CHAN(chansegment[i]),
-			       CR_RANGE(chansegment[i]),
-			       CR_AREF(chansegment[i]),
-			       CR_CHAN(chanlist[i % seglen]),
-			       CR_RANGE(chanlist[i % seglen]),
-			       CR_AREF(chansegment[i % seglen]));
-			return 0;
-		}
-	}
-	return seglen;
-}
-
-static void setup_channel_list(struct comedi_device *dev,
-			       struct comedi_subdevice *s,
-			       unsigned int *chanlist, unsigned int n_chan,
-			       unsigned int seglen)
-{
-	const struct boardtype *this_board = comedi_board(dev);
-	struct pci1710_private *devpriv = dev->private;
-	unsigned int i, range, chanprog;
-
-	devpriv->act_chanlist_len = seglen;
-	devpriv->act_chanlist_pos = 0;
-
-	for (i = 0; i < seglen; i++) {	/*  store range list to card */
-		chanprog = muxonechan[CR_CHAN(chanlist[i])];
-		outw(chanprog, dev->iobase + PCI171x_MUX); /* select channel */
-		range = this_board->rangecode_ai[CR_RANGE(chanlist[i])];
-		if (CR_AREF(chanlist[i]) == AREF_DIFF)
-			range |= 0x0020;
-		outw(range, dev->iobase + PCI171x_RANGE); /* select gain */
-#ifdef PCI171x_PARANOIDCHECK
-		devpriv->act_chanlist[i] =
-			(CR_CHAN(chanlist[i]) << 12) & 0xf000;
-#endif
-	}
-#ifdef PCI171x_PARANOIDCHECK
-	for ( ; i < n_chan; i++) { /* store remainder of channel list */
-		devpriv->act_chanlist[i] =
-			(CR_CHAN(chanlist[i]) << 12) & 0xf000;
-	}
-#endif
-
-	devpriv->ai_et_MuxVal =
-		CR_CHAN(chanlist[0]) | (CR_CHAN(chanlist[seglen - 1]) << 8);
-	/* select channel interval to scan */
-	outw(devpriv->ai_et_MuxVal, dev->iobase + PCI171x_MUX);
-}
-
-/*
-==============================================================================
-*/
-static void start_pacer(struct comedi_device *dev, int mode,
-			unsigned int divisor1, unsigned int divisor2)
-{
-	outw(0xb4, dev->iobase + PCI171x_CNTCTRL);
-	outw(0x74, dev->iobase + PCI171x_CNTCTRL);
-
-	if (mode == 1) {
-		outw(divisor2 & 0xff, dev->iobase + PCI171x_CNT2);
-		outw((divisor2 >> 8) & 0xff, dev->iobase + PCI171x_CNT2);
-		outw(divisor1 & 0xff, dev->iobase + PCI171x_CNT1);
-		outw((divisor1 >> 8) & 0xff, dev->iobase + PCI171x_CNT1);
-	}
-}
-
-/*
-==============================================================================
-*/
-static int pci171x_ai_cancel(struct comedi_device *dev,
-			     struct comedi_subdevice *s)
-{
-	const struct boardtype *this_board = comedi_board(dev);
-	struct pci1710_private *devpriv = dev->private;
-
-	switch (this_board->cardtype) {
-	default:
-		devpriv->CntrlReg &= Control_CNT0;
-		devpriv->CntrlReg |= Control_SW;
-
-		outw(devpriv->CntrlReg, dev->iobase + PCI171x_CONTROL);	/*  reset any operations */
-		start_pacer(dev, -1, 0, 0);
-		outb(0, dev->iobase + PCI171x_CLRFIFO);
-		outb(0, dev->iobase + PCI171x_CLRINT);
-		break;
-	}
-
-	devpriv->ai_do = 0;
-	devpriv->ai_act_scan = 0;
-	s->async->cur_chan = 0;
-	devpriv->ai_buf_ptr = 0;
-	devpriv->neverending_ai = 0;
-
-	return 0;
-}
-
-/*
-==============================================================================
 */
 static int pci171x_reset(struct comedi_device *dev)
 {
-- 
1.7.11

