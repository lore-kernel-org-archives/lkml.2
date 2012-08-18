Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368Ab2HRBFb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 21:05:31 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:52276 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282Ab2HRBFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 21:05:22 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-6.tower-127.messagelabs.com!1345251912!7862001!4
X-Originating-IP: [216.166.12.99]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 01/20] staging: comedi: adv_pci1710: remove function trace messages
Date: Fri, 17 Aug 2012 18:05:01 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208171805.02328.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The macros PCI171X_EXTDEBUG and DPRINTK enable a number of function
trace messages. These trace messages should not be in the final
driver. Remove them.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/adv_pci1710.c | 132 +--------------------------
 1 file changed, 5 insertions(+), 127 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adv_pci1710.c b/drivers/staging/comedi/drivers/adv_pci1710.c
index 6b4d0d6..7c4f0de 100644
--- a/drivers/staging/comedi/drivers/adv_pci1710.c
+++ b/drivers/staging/comedi/drivers/adv_pci1710.c
@@ -52,17 +52,8 @@ Configuration options:
 				 * correct channel number on every 12 bit
 				 * sample */
 
-#undef PCI171X_EXTDEBUG
-
 #define DRV_NAME "adv_pci1710"
 
-#undef DPRINTK
-#ifdef PCI171X_EXTDEBUG
-#define DPRINTK(fmt, args...) printk(fmt, ## args)
-#else
-#define DPRINTK(fmt, args...)
-#endif
-
 #define PCI_VENDOR_ID_ADVANTECH		0x13fe
 
 /* hardware types of the cards */
@@ -318,7 +309,6 @@ static int pci171x_insn_read_ai(struct comedi_device *dev,
 	unsigned int idata;
 #endif
 
-	DPRINTK("adv_pci1710 EDBG: BGN: pci171x_insn_read_ai(...)\n");
 	devpriv->CntrlReg &= Control_CNT0;
 	devpriv->CntrlReg |= Control_SW;	/*  set software trigger */
 	outw(devpriv->CntrlReg, dev->iobase + PCI171x_CONTROL);
@@ -327,32 +317,18 @@ static int pci171x_insn_read_ai(struct comedi_device *dev,
 
 	setup_channel_list(dev, s, &insn->chanspec, 1, 1);
 
-	DPRINTK("adv_pci1710 A ST=%4x IO=%x\n",
-		inw(dev->iobase + PCI171x_STATUS),
-		dev->iobase + PCI171x_STATUS);
 	for (n = 0; n < insn->n; n++) {
 		outw(0, dev->iobase + PCI171x_SOFTTRG);	/* start conversion */
-		DPRINTK("adv_pci1710 B n=%d ST=%4x\n", n,
-			inw(dev->iobase + PCI171x_STATUS));
 		/* udelay(1); */
-		DPRINTK("adv_pci1710 C n=%d ST=%4x\n", n,
-			inw(dev->iobase + PCI171x_STATUS));
 		timeout = 100;
 		while (timeout--) {
 			if (!(inw(dev->iobase + PCI171x_STATUS) & Status_FE))
 				goto conv_finish;
-			if (!(timeout % 10))
-				DPRINTK("adv_pci1710 D n=%d tm=%d ST=%4x\n", n,
-					timeout,
-					inw(dev->iobase + PCI171x_STATUS));
 		}
 		comedi_error(dev, "A/D insn timeout");
 		outb(0, dev->iobase + PCI171x_CLRFIFO);
 		outb(0, dev->iobase + PCI171x_CLRINT);
 		data[n] = 0;
-		DPRINTK
-		    ("adv_pci1710 EDBG: END: pci171x_insn_read_ai(...) n=%d\n",
-		     n);
 		return -ETIME;
 
 conv_finish:
@@ -373,7 +349,6 @@ conv_finish:
 	outb(0, dev->iobase + PCI171x_CLRFIFO);
 	outb(0, dev->iobase + PCI171x_CLRINT);
 
-	DPRINTK("adv_pci1710 EDBG: END: pci171x_insn_read_ai(...) n=%d\n", n);
 	return n;
 }
 
@@ -584,7 +559,6 @@ static void interrupt_pci1710_every_sample(void *d)
 	short sampl;
 #endif
 
-	DPRINTK("adv_pci1710 EDBG: BGN: interrupt_pci1710_every_sample(...)\n");
 	m = inw(dev->iobase + PCI171x_STATUS);
 	if (m & Status_FE) {
 		printk("comedi%d: A/D FIFO empty (%4x)\n", dev->minor, m);
@@ -605,11 +579,9 @@ static void interrupt_pci1710_every_sample(void *d)
 
 	outb(0, dev->iobase + PCI171x_CLRINT);	/*  clear our INT request */
 
-	DPRINTK("FOR ");
 	for (; !(inw(dev->iobase + PCI171x_STATUS) & Status_FE);) {
 #ifdef PCI171x_PARANOIDCHECK
 		sampl = inw(dev->iobase + PCI171x_AD_DATA);
-		DPRINTK("%04x:", sampl);
 		if (this_board->cardtype != TYPE_PCI1713)
 			if ((sampl & 0xf000) !=
 			    devpriv->act_chanlist[s->async->cur_chan]) {
@@ -626,8 +598,6 @@ static void interrupt_pci1710_every_sample(void *d)
 				comedi_event(dev, s);
 				return;
 			}
-		DPRINTK("%8d %2d %8d~", s->async->buf_int_ptr,
-			s->async->cur_chan, s->async->buf_int_count);
 		comedi_buf_put(s->async, sampl & 0x0fff);
 #else
 		comedi_buf_put(s->async,
@@ -641,11 +611,6 @@ static void interrupt_pci1710_every_sample(void *d)
 
 		if (s->async->cur_chan == 0) {	/*  one scan done */
 			devpriv->ai_act_scan++;
-			DPRINTK
-			    ("adv_pci1710 EDBG: EOS1 bic %d bip %d buc %d bup %d\n",
-			     s->async->buf_int_count, s->async->buf_int_ptr,
-			     s->async->buf_user_count, s->async->buf_user_ptr);
-			DPRINTK("adv_pci1710 EDBG: EOS2\n");
 			if ((!devpriv->neverending_ai) &&
 			    (devpriv->ai_act_scan >= devpriv->ai_scans)) {
 				/*  all data sampled */
@@ -658,7 +623,6 @@ static void interrupt_pci1710_every_sample(void *d)
 	}
 
 	outb(0, dev->iobase + PCI171x_CLRINT);	/*  clear our INT request */
-	DPRINTK("adv_pci1710 EDBG: END: interrupt_pci1710_every_sample(...)\n");
 
 	comedi_event(dev, s);
 }
@@ -673,8 +637,7 @@ static int move_block_from_fifo(struct comedi_device *dev,
 #ifdef PCI171x_PARANOIDCHECK
 	int sampl;
 #endif
-	DPRINTK("adv_pci1710 EDBG: BGN: move_block_from_fifo(...,%d,%d)\n", n,
-		turn);
+
 	j = s->async->cur_chan;
 	for (i = 0; i < n; i++) {
 #ifdef PCI171x_PARANOIDCHECK
@@ -705,7 +668,6 @@ static int move_block_from_fifo(struct comedi_device *dev,
 		}
 	}
 	s->async->cur_chan = j;
-	DPRINTK("adv_pci1710 EDBG: END: move_block_from_fifo(...)\n");
 	return 0;
 }
 
@@ -718,7 +680,6 @@ static void interrupt_pci1710_half_fifo(void *d)
 	struct comedi_subdevice *s = dev->subdevices + 0;
 	int m, samplesinbuf;
 
-	DPRINTK("adv_pci1710 EDBG: BGN: interrupt_pci1710_half_fifo(...)\n");
 	m = inw(dev->iobase + PCI171x_STATUS);
 	if (!(m & Status_FH)) {
 		printk("comedi%d: A/D FIFO not half full! (%4x)\n",
@@ -760,7 +721,6 @@ static void interrupt_pci1710_half_fifo(void *d)
 			return;
 		}
 	outb(0, dev->iobase + PCI171x_CLRINT);	/*  clear our INT request */
-	DPRINTK("adv_pci1710 EDBG: END: interrupt_pci1710_half_fifo(...)\n");
 
 	comedi_event(dev, s);
 }
@@ -772,17 +732,12 @@ static irqreturn_t interrupt_service_pci1710(int irq, void *d)
 {
 	struct comedi_device *dev = d;
 
-	DPRINTK("adv_pci1710 EDBG: BGN: interrupt_service_pci1710(%d,...)\n",
-		irq);
 	if (!dev->attached)	/*  is device attached? */
 		return IRQ_NONE;	/*  no, exit */
 	/*  is this interrupt from our board? */
 	if (!(inw(dev->iobase + PCI171x_STATUS) & Status_IRQ))
 		return IRQ_NONE;	/*  no, exit */
 
-	DPRINTK("adv_pci1710 EDBG: interrupt_service_pci1710() ST: %4x\n",
-		inw(dev->iobase + PCI171x_STATUS));
-
 	if (devpriv->ai_et) {	/*  Switch from initial TRIG_EXT to TRIG_xxx. */
 		devpriv->ai_et = 0;
 		devpriv->CntrlReg &= Control_CNT0;
@@ -802,7 +757,6 @@ static irqreturn_t interrupt_service_pci1710(int irq, void *d)
 	} else {
 		interrupt_pci1710_half_fifo(d);
 	}
-	DPRINTK("adv_pci1710 EDBG: END: interrupt_service_pci1710(...)\n");
 	return IRQ_HANDLED;
 }
 
@@ -815,8 +769,6 @@ static int pci171x_ai_docmd_and_mode(int mode, struct comedi_device *dev,
 	unsigned int divisor1 = 0, divisor2 = 0;
 	unsigned int seglen;
 
-	DPRINTK("adv_pci1710 EDBG: BGN: pci171x_ai_docmd_and_mode(%d,...)\n",
-		mode);
 	start_pacer(dev, -1, 0, 0);	/*  stop pacer */
 
 	seglen = check_channel_list(dev, s, devpriv->ai_chanlist,
@@ -869,10 +821,6 @@ static int pci171x_ai_docmd_and_mode(int mode, struct comedi_device *dev,
 		i8253_cascade_ns_to_timer(devpriv->i8254_osc_base, &divisor1,
 					  &divisor2, &devpriv->ai_timer1,
 					  devpriv->ai_flags & TRIG_ROUND_MASK);
-		DPRINTK
-		    ("adv_pci1710 EDBG: OSC base=%u div1=%u div2=%u timer=%u\n",
-		     devpriv->i8254_osc_base, divisor1, divisor2,
-		     devpriv->ai_timer1);
 		outw(devpriv->CntrlReg, dev->iobase + PCI171x_CONTROL);
 		if (mode != 2) {
 			/*  start pacer */
@@ -888,27 +836,9 @@ static int pci171x_ai_docmd_and_mode(int mode, struct comedi_device *dev,
 		break;
 	}
 
-	DPRINTK("adv_pci1710 EDBG: END: pci171x_ai_docmd_and_mode(...)\n");
 	return 0;
 }
 
-#ifdef PCI171X_EXTDEBUG
-/*
-==============================================================================
-*/
-static void pci171x_cmdtest_out(int e, struct comedi_cmd *cmd)
-{
-	printk("adv_pci1710 e=%d startsrc=%x scansrc=%x convsrc=%x\n", e,
-	       cmd->start_src, cmd->scan_begin_src, cmd->convert_src);
-	printk("adv_pci1710 e=%d startarg=%d scanarg=%d convarg=%d\n", e,
-	       cmd->start_arg, cmd->scan_begin_arg, cmd->convert_arg);
-	printk("adv_pci1710 e=%d stopsrc=%x scanend=%x\n", e, cmd->stop_src,
-	       cmd->scan_end_src);
-	printk("adv_pci1710 e=%d stoparg=%d scanendarg=%d chanlistlen=%d\n",
-	       e, cmd->stop_arg, cmd->scan_end_arg, cmd->chanlist_len);
-}
-#endif
-
 /*
 ==============================================================================
 */
@@ -920,10 +850,6 @@ static int pci171x_ai_cmdtest(struct comedi_device *dev,
 	int tmp;
 	unsigned int divisor1 = 0, divisor2 = 0;
 
-	DPRINTK("adv_pci1710 EDBG: BGN: pci171x_ai_cmdtest(...)\n");
-#ifdef PCI171X_EXTDEBUG
-	pci171x_cmdtest_out(-1, cmd);
-#endif
 	/* step 1: make sure trigger sources are trivially valid */
 
 	tmp = cmd->start_src;
@@ -951,15 +877,8 @@ static int pci171x_ai_cmdtest(struct comedi_device *dev,
 	if (!cmd->stop_src || tmp != cmd->stop_src)
 		err++;
 
-	if (err) {
-#ifdef PCI171X_EXTDEBUG
-		pci171x_cmdtest_out(1, cmd);
-#endif
-		DPRINTK(
-		"adv_pci1710 EDBG: BGN: pci171x_ai_cmdtest(...) err=%d ret=1\n",
-		err);
+	if (err)
 		return 1;
-	}
 
 	/* step2: make sure trigger srcs are unique and mutually compatible */
 
@@ -984,15 +903,8 @@ static int pci171x_ai_cmdtest(struct comedi_device *dev,
 	if (cmd->stop_src != TRIG_NONE && cmd->stop_src != TRIG_COUNT)
 		err++;
 
-	if (err) {
-#ifdef PCI171X_EXTDEBUG
-		pci171x_cmdtest_out(2, cmd);
-#endif
-		DPRINTK(
-		"adv_pci1710 EDBG: BGN: pci171x_ai_cmdtest(...) err=%d ret=2\n",
-		err);
+	if (err)
 		return 2;
-	}
 
 	/* step 3: make sure arguments are trivially compatible */
 
@@ -1034,15 +946,8 @@ static int pci171x_ai_cmdtest(struct comedi_device *dev,
 		}
 	}
 
-	if (err) {
-#ifdef PCI171X_EXTDEBUG
-		pci171x_cmdtest_out(3, cmd);
-#endif
-		DPRINTK(
-		"adv_pci1710 EDBG: BGN: pci171x_ai_cmdtest(...) err=%d ret=3\n",
-		err);
+	if (err)
 		return 3;
-	}
 
 	/* step 4: fix up any arguments */
 
@@ -1057,12 +962,8 @@ static int pci171x_ai_cmdtest(struct comedi_device *dev,
 			err++;
 	}
 
-	if (err) {
-		DPRINTK
-		    ("adv_pci1710 EDBG: BGN: pci171x_ai_cmdtest(...) err=%d ret=4\n",
-		     err);
+	if (err)
 		return 4;
-	}
 
 	/* step 5: complain about special chanlist considerations */
 
@@ -1072,7 +973,6 @@ static int pci171x_ai_cmdtest(struct comedi_device *dev,
 			return 5;	/*  incorrect channels list */
 	}
 
-	DPRINTK("adv_pci1710 EDBG: BGN: pci171x_ai_cmdtest(...) ret=0\n");
 	return 0;
 }
 
@@ -1083,7 +983,6 @@ static int pci171x_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 {
 	struct comedi_cmd *cmd = &s->async->cmd;
 
-	DPRINTK("adv_pci1710 EDBG: BGN: pci171x_ai_cmd(...)\n");
 	devpriv->ai_n_chan = cmd->chanlist_len;
 	devpriv->ai_chanlist = cmd->chanlist;
 	devpriv->ai_flags = cmd->flags;
@@ -1126,7 +1025,6 @@ static int check_channel_list(struct comedi_device *dev,
 	unsigned int chansegment[32];
 	unsigned int i, nowmustbechan, seglen, segpos;
 
-	DPRINTK("adv_pci1710 EDBG:  check_channel_list(...,%d)\n", n_chan);
 	/* correct channel and range number check itself comedi/range.c */
 	if (n_chan < 1) {
 		comedi_error(dev, "range/channel list is empty!");
@@ -1179,12 +1077,9 @@ static void setup_channel_list(struct comedi_device *dev,
 {
 	unsigned int i, range, chanprog;
 
-	DPRINTK("adv_pci1710 EDBG:  setup_channel_list(...,%d,%d)\n", n_chan,
-		seglen);
 	devpriv->act_chanlist_len = seglen;
 	devpriv->act_chanlist_pos = 0;
 
-	DPRINTK("SegLen: %d\n", seglen);
 	for (i = 0; i < seglen; i++) {	/*  store range list to card */
 		chanprog = muxonechan[CR_CHAN(chanlist[i])];
 		outw(chanprog, dev->iobase + PCI171x_MUX); /* select channel */
@@ -1196,8 +1091,6 @@ static void setup_channel_list(struct comedi_device *dev,
 		devpriv->act_chanlist[i] =
 			(CR_CHAN(chanlist[i]) << 12) & 0xf000;
 #endif
-		DPRINTK("GS: %2d. [%4x]=%4x %4x\n", i, chanprog, range,
-			devpriv->act_chanlist[i]);
 	}
 #ifdef PCI171x_PARANOIDCHECK
 	for ( ; i < n_chan; i++) { /* store remainder of channel list */
@@ -1210,9 +1103,6 @@ static void setup_channel_list(struct comedi_device *dev,
 		CR_CHAN(chanlist[0]) | (CR_CHAN(chanlist[seglen - 1]) << 8);
 	/* select channel interval to scan */
 	outw(devpriv->ai_et_MuxVal, dev->iobase + PCI171x_MUX);
-	DPRINTK("MUX: %4x L%4x.H%4x\n",
-		CR_CHAN(chanlist[0]) | (CR_CHAN(chanlist[seglen - 1]) << 8),
-		CR_CHAN(chanlist[0]), CR_CHAN(chanlist[seglen - 1]));
 }
 
 /*
@@ -1221,8 +1111,6 @@ static void setup_channel_list(struct comedi_device *dev,
 static void start_pacer(struct comedi_device *dev, int mode,
 			unsigned int divisor1, unsigned int divisor2)
 {
-	DPRINTK("adv_pci1710 EDBG: BGN: start_pacer(%d,%u,%u)\n", mode,
-		divisor1, divisor2);
 	outw(0xb4, dev->iobase + PCI171x_CNTCTRL);
 	outw(0x74, dev->iobase + PCI171x_CNTCTRL);
 
@@ -1232,7 +1120,6 @@ static void start_pacer(struct comedi_device *dev, int mode,
 		outw(divisor1 & 0xff, dev->iobase + PCI171x_CNT1);
 		outw((divisor1 >> 8) & 0xff, dev->iobase + PCI171x_CNT1);
 	}
-	DPRINTK("adv_pci1710 EDBG: END: start_pacer(...)\n");
 }
 
 /*
@@ -1241,8 +1128,6 @@ static void start_pacer(struct comedi_device *dev, int mode,
 static int pci171x_ai_cancel(struct comedi_device *dev,
 			     struct comedi_subdevice *s)
 {
-	DPRINTK("adv_pci1710 EDBG: BGN: pci171x_ai_cancel(...)\n");
-
 	switch (this_board->cardtype) {
 	default:
 		devpriv->CntrlReg &= Control_CNT0;
@@ -1261,7 +1146,6 @@ static int pci171x_ai_cancel(struct comedi_device *dev,
 	devpriv->ai_buf_ptr = 0;
 	devpriv->neverending_ai = 0;
 
-	DPRINTK("adv_pci1710 EDBG: END: pci171x_ai_cancel(...)\n");
 	return 0;
 }
 
@@ -1270,7 +1154,6 @@ static int pci171x_ai_cancel(struct comedi_device *dev,
 */
 static int pci171x_reset(struct comedi_device *dev)
 {
-	DPRINTK("adv_pci1710 EDBG: BGN: pci171x_reset(...)\n");
 	outw(0x30, dev->iobase + PCI171x_CNTCTRL);
 	devpriv->CntrlReg = Control_SW | Control_CNT0;	/*  Software trigger, CNT0=external */
 	outw(devpriv->CntrlReg, dev->iobase + PCI171x_CONTROL);	/*  reset any operations */
@@ -1291,7 +1174,6 @@ static int pci171x_reset(struct comedi_device *dev)
 	outb(0, dev->iobase + PCI171x_CLRFIFO);	/*  clear FIFO */
 	outb(0, dev->iobase + PCI171x_CLRINT);	/*  clear INT request */
 
-	DPRINTK("adv_pci1710 EDBG: END: pci171x_reset(...)\n");
 	return 0;
 }
 
@@ -1300,7 +1182,6 @@ static int pci171x_reset(struct comedi_device *dev)
 */
 static int pci1720_reset(struct comedi_device *dev)
 {
-	DPRINTK("adv_pci1710 EDBG: BGN: pci1720_reset(...)\n");
 	outb(Syncont_SC0, dev->iobase + PCI1720_SYNCONT);	/*  set synchronous output mode */
 	devpriv->da_ranges = 0xAA;
 	outb(devpriv->da_ranges, dev->iobase + PCI1720_RANGE);	/*  set all ranges to +/-5V */
@@ -1313,7 +1194,6 @@ static int pci1720_reset(struct comedi_device *dev)
 	devpriv->ao_data[1] = 0x0800;
 	devpriv->ao_data[2] = 0x0800;
 	devpriv->ao_data[3] = 0x0800;
-	DPRINTK("adv_pci1710 EDBG: END: pci1720_reset(...)\n");
 	return 0;
 }
 
@@ -1322,14 +1202,12 @@ static int pci1720_reset(struct comedi_device *dev)
 */
 static int pci1710_reset(struct comedi_device *dev)
 {
-	DPRINTK("adv_pci1710 EDBG: BGN: pci1710_reset(...)\n");
 	switch (this_board->cardtype) {
 	case TYPE_PCI1720:
 		return pci1720_reset(dev);
 	default:
 		return pci171x_reset(dev);
 	}
-	DPRINTK("adv_pci1710 EDBG: END: pci1710_reset(...)\n");
 }
 
 static struct pci_dev *pci1710_find_pci_dev(struct comedi_device *dev,
-- 
1.7.11

