Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933266Ab2GCBNU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 21:13:20 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:22067 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932639Ab2GCBNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 21:13:18 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-10.tower-132.messagelabs.com!1341277997!13233042!1
X-Originating-IP: [216.166.12.99]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/8] staging: comedi: dmm32at: remove dmm_outb macro
Date: Mon, 2 Jul 2012 18:13:11 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207021813.12324.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The macro is just a wrapper for outb(). Just use the outb() directly.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/dmm32at.c | 81 +++++++++++++++-----------------
 1 file changed, 39 insertions(+), 42 deletions(-)

diff --git a/drivers/staging/comedi/drivers/dmm32at.c b/drivers/staging/comedi/drivers/dmm32at.c
index ee4e8ab..2ae31e8 100644
--- a/drivers/staging/comedi/drivers/dmm32at.c
+++ b/drivers/staging/comedi/drivers/dmm32at.c
@@ -78,8 +78,6 @@ Configuration Options:
 #define DMM32AT_DIOC 0x0e
 #define DMM32AT_DIOCONF 0x0f
 
-#define dmm_outb(cdev, reg, valu) outb(valu, (cdev->iobase)+reg)
-
 /* Board register values. */
 
 /* DMM32AT_DACSTAT 0x04 */
@@ -221,13 +219,13 @@ static int dmm32at_ai_rinsn(struct comedi_device *dev,
 	/* printk("channel=0x%02x, range=%d\n",chan,range); */
 
 	/* zero scan and fifo control and reset fifo */
-	dmm_outb(dev, DMM32AT_FIFOCNTRL, DMM32AT_FIFORESET);
+	outb(DMM32AT_FIFORESET, dev->iobase + DMM32AT_FIFOCNTRL);
 
 	/* write the ai channel range regs */
-	dmm_outb(dev, DMM32AT_AILOW, chan);
-	dmm_outb(dev, DMM32AT_AIHIGH, chan);
+	outb(chan, dev->iobase + DMM32AT_AILOW);
+	outb(chan, dev->iobase + DMM32AT_AIHIGH);
 	/* set the range bits */
-	dmm_outb(dev, DMM32AT_AICONF, dmm32at_rangebits[range]);
+	outb(dmm32at_rangebits[range], dev->iobase + DMM32AT_AICONF);
 
 	/* wait for circuit to settle */
 	for (i = 0; i < 40000; i++) {
@@ -243,7 +241,7 @@ static int dmm32at_ai_rinsn(struct comedi_device *dev,
 	/* convert n samples */
 	for (n = 0; n < insn->n; n++) {
 		/* trigger conversion */
-		dmm_outb(dev, DMM32AT_CONV, 0xff);
+		outb(0xff, dev->iobase + DMM32AT_CONV);
 		/* wait for conversion to end */
 		for (i = 0; i < 40000; i++) {
 			status = inb(dev->iobase + DMM32AT_AISTAT);
@@ -489,23 +487,22 @@ static void dmm32at_setaitimer(struct comedi_device *dev, unsigned int nansec)
 	lo2 = both2 & 0x00ff;
 
 	/* set the counter frequency to 10mhz */
-	dmm_outb(dev, DMM32AT_CNTRDIO, 0);
+	outb(0, dev->iobase + DMM32AT_CNTRDIO);
 
 	/* get access to the clock regs */
-	dmm_outb(dev, DMM32AT_CNTRL, DMM32AT_CLKACC);
+	outb(DMM32AT_CLKACC, dev->iobase + DMM32AT_CNTRL);
 
 	/* write the counter 1 control word and low byte to counter */
-	dmm_outb(dev, DMM32AT_CLKCT, DMM32AT_CLKCT1);
-	dmm_outb(dev, DMM32AT_CLK1, lo1);
+	outb(DMM32AT_CLKCT1, dev->iobase + DMM32AT_CLKCT);
+	outb(lo1, dev->iobase + DMM32AT_CLK1);
 
 	/* write the counter 2 control word and low byte then to counter */
-	dmm_outb(dev, DMM32AT_CLKCT, DMM32AT_CLKCT2);
-	dmm_outb(dev, DMM32AT_CLK2, lo2);
-	dmm_outb(dev, DMM32AT_CLK2, hi2);
+	outb(DMM32AT_CLKCT2, dev->iobase + DMM32AT_CLKCT);
+	outb(lo2, dev->iobase + DMM32AT_CLK2);
+	outb(hi2, dev->iobase + DMM32AT_CLK2);
 
 	/* enable the ai conversion interrupt and the clock to start scans */
-	dmm_outb(dev, DMM32AT_INTCLOCK, DMM32AT_ADINT | DMM32AT_CLKSEL);
-
+	outb(DMM32AT_ADINT | DMM32AT_CLKSEL, dev->iobase + DMM32AT_INTCLOCK);
 }
 
 static int dmm32at_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
@@ -525,20 +522,20 @@ static int dmm32at_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	range = CR_RANGE(cmd->chanlist[0]);
 
 	/* reset fifo */
-	dmm_outb(dev, DMM32AT_FIFOCNTRL, DMM32AT_FIFORESET);
+	outb(DMM32AT_FIFORESET, dev->iobase + DMM32AT_FIFOCNTRL);
 
 	/* set scan enable */
-	dmm_outb(dev, DMM32AT_FIFOCNTRL, DMM32AT_SCANENABLE);
+	outb(DMM32AT_SCANENABLE, dev->iobase + DMM32AT_FIFOCNTRL);
 
 	/* write the ai channel range regs */
-	dmm_outb(dev, DMM32AT_AILOW, chanlo);
-	dmm_outb(dev, DMM32AT_AIHIGH, chanhi);
+	outb(chanlo, dev->iobase + DMM32AT_AILOW);
+	outb(chanhi, dev->iobase + DMM32AT_AIHIGH);
 
 	/* set the range bits */
-	dmm_outb(dev, DMM32AT_AICONF, dmm32at_rangebits[range]);
+	outb(dmm32at_rangebits[range], dev->iobase + DMM32AT_AICONF);
 
 	/* reset the interrupt just in case */
-	dmm_outb(dev, DMM32AT_CNTRL, DMM32AT_INTRESET);
+	outb(DMM32AT_INTRESET, dev->iobase + DMM32AT_CNTRL);
 
 	if (cmd->stop_src == TRIG_COUNT)
 		devpriv->ai_scans_left = cmd->stop_arg;
@@ -563,8 +560,8 @@ static int dmm32at_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 		dmm32at_setaitimer(dev, cmd->scan_begin_arg);
 	} else {
 		/* start the interrups and initiate a single scan */
-		dmm_outb(dev, DMM32AT_INTCLOCK, DMM32AT_ADINT);
-		dmm_outb(dev, DMM32AT_CONV, 0xff);
+		outb(DMM32AT_ADINT, dev->iobase + DMM32AT_INTCLOCK);
+		outb(0xff, dev->iobase + DMM32AT_CONV);
 	}
 
 /*	printk("dmmat32 in command\n"); */
@@ -619,7 +616,7 @@ static irqreturn_t dmm32at_isr(int irq, void *d)
 			devpriv->ai_scans_left--;
 			if (devpriv->ai_scans_left == 0) {
 				/* disable further interrupts and clocks */
-				dmm_outb(dev, DMM32AT_INTCLOCK, 0x0);
+				outb(0x0, dev->iobase + DMM32AT_INTCLOCK);
 				/* set the buffer to be flushed with an EOF */
 				s->async->events |= COMEDI_CB_EOA;
 			}
@@ -630,7 +627,7 @@ static irqreturn_t dmm32at_isr(int irq, void *d)
 	}
 
 	/* reset the interrupt */
-	dmm_outb(dev, DMM32AT_CNTRL, DMM32AT_INTRESET);
+	outb(DMM32AT_INTRESET, dev->iobase + DMM32AT_CNTRL);
 	return IRQ_HANDLED;
 }
 
@@ -654,8 +651,8 @@ static int dmm32at_ao_winsn(struct comedi_device *dev,
 		hi = (data[i] >> 8) + chan * (1 << 6);
 		/* printk("writing 0x%02x  0x%02x\n",hi,lo); */
 		/* write the low and high values to the board */
-		dmm_outb(dev, DMM32AT_DACLSB, lo);
-		dmm_outb(dev, DMM32AT_DACMSB, hi);
+		outb(lo, dev->iobase + DMM32AT_DACLSB);
+		outb(hi, dev->iobase + DMM32AT_DACMSB);
 
 		/* wait for circuit to settle */
 		for (i = 0; i < 40000; i++) {
@@ -712,21 +709,21 @@ static int dmm32at_dio_insn_bits(struct comedi_device *dev,
 	}
 
 	/* get access to the DIO regs */
-	dmm_outb(dev, DMM32AT_CNTRL, DMM32AT_DIOACC);
+	outb(DMM32AT_DIOACC, dev->iobase + DMM32AT_CNTRL);
 
 	/* if either part of dio is set for output */
 	if (((devpriv->dio_config & DMM32AT_DIRCL) == 0) ||
 	    ((devpriv->dio_config & DMM32AT_DIRCH) == 0)) {
 		diobits = (s->state & 0x00ff0000) >> 16;
-		dmm_outb(dev, DMM32AT_DIOC, diobits);
+		outb(diobits, dev->iobase + DMM32AT_DIOC);
 	}
 	if ((devpriv->dio_config & DMM32AT_DIRB) == 0) {
 		diobits = (s->state & 0x0000ff00) >> 8;
-		dmm_outb(dev, DMM32AT_DIOB, diobits);
+		outb(diobits, dev->iobase + DMM32AT_DIOB);
 	}
 	if ((devpriv->dio_config & DMM32AT_DIRA) == 0) {
 		diobits = (s->state & 0x000000ff);
-		dmm_outb(dev, DMM32AT_DIOA, diobits);
+		outb(diobits, dev->iobase + DMM32AT_DIOA);
 	}
 
 	/* now read the state back in */
@@ -777,9 +774,9 @@ static int dmm32at_dio_insn_config(struct comedi_device *dev,
 	else
 		devpriv->dio_config |= chanbit;
 	/* get access to the DIO regs */
-	dmm_outb(dev, DMM32AT_CNTRL, DMM32AT_DIOACC);
+	outb(DMM32AT_DIOACC, dev->iobase + DMM32AT_CNTRL);
 	/* set the DIO's to the new configuration setting */
-	dmm_outb(dev, DMM32AT_DIOCONF, devpriv->dio_config);
+	outb(devpriv->dio_config, dev->iobase + DMM32AT_DIOCONF);
 
 	return 1;
 }
@@ -813,23 +810,23 @@ static int dmm32at_attach(struct comedi_device *dev,
 	   it to a known state */
 
 	/* reset the board */
-	dmm_outb(dev, DMM32AT_CNTRL, DMM32AT_RESET);
+	outb(DMM32AT_RESET, dev->iobase + DMM32AT_CNTRL);
 
 	/* allow a millisecond to reset */
 	udelay(1000);
 
 	/* zero scan and fifo control */
-	dmm_outb(dev, DMM32AT_FIFOCNTRL, 0x0);
+	outb(0x0, dev->iobase + DMM32AT_FIFOCNTRL);
 
 	/* zero interrupt and clock control */
-	dmm_outb(dev, DMM32AT_INTCLOCK, 0x0);
+	outb(0x0, dev->iobase + DMM32AT_INTCLOCK);
 
 	/* write a test channel range, the high 3 bits should drop */
-	dmm_outb(dev, DMM32AT_AILOW, 0x80);
-	dmm_outb(dev, DMM32AT_AIHIGH, 0xff);
+	outb(0x80, dev->iobase + DMM32AT_AILOW);
+	outb(0xff, dev->iobase + DMM32AT_AIHIGH);
 
 	/* set the range at 10v unipolar */
-	dmm_outb(dev, DMM32AT_AICONF, DMM32AT_RANGE_U10);
+	outb(DMM32AT_RANGE_U10, dev->iobase + DMM32AT_AICONF);
 
 	/* should take 10 us to settle, here's a hundred */
 	udelay(100);
@@ -908,11 +905,11 @@ static int dmm32at_attach(struct comedi_device *dev,
 	if (board->have_dio) {
 
 		/* get access to the DIO regs */
-		dmm_outb(dev, DMM32AT_CNTRL, DMM32AT_DIOACC);
+		outb(DMM32AT_DIOACC, dev->iobase + DMM32AT_CNTRL);
 		/* set the DIO's to the defualt input setting */
 		devpriv->dio_config = DMM32AT_DIRA | DMM32AT_DIRB |
 		    DMM32AT_DIRCL | DMM32AT_DIRCH | DMM32AT_DIENABLE;
-		dmm_outb(dev, DMM32AT_DIOCONF, devpriv->dio_config);
+		outb(devpriv->dio_config, dev->iobase + DMM32AT_DIOCONF);
 
 		/* set up the subdevice */
 		s->type = COMEDI_SUBD_DIO;
-- 
1.7.11

