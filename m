Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933255Ab2GCBND (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 21:13:03 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:21592 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932639Ab2GCBNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 21:13:01 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-13.tower-132.messagelabs.com!1341277940!12218313!17
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/8] staging: comedi: dmm32at: remove dmm_inb macro
Date: Mon, 2 Jul 2012 18:12:35 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207021812.36311.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The macro is just a wrapper for inb(). Just use the inb() directly.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/dmm32at.c | 39 ++++++++++++++++----------------
 1 file changed, 19 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/comedi/drivers/dmm32at.c b/drivers/staging/comedi/drivers/dmm32at.c
index c139eff..ee4e8ab 100644
--- a/drivers/staging/comedi/drivers/dmm32at.c
+++ b/drivers/staging/comedi/drivers/dmm32at.c
@@ -78,7 +78,6 @@ Configuration Options:
 #define DMM32AT_DIOC 0x0e
 #define DMM32AT_DIOCONF 0x0f
 
-#define dmm_inb(cdev, reg) inb((cdev->iobase)+reg)
 #define dmm_outb(cdev, reg, valu) outb(valu, (cdev->iobase)+reg)
 
 /* Board register values. */
@@ -232,7 +231,7 @@ static int dmm32at_ai_rinsn(struct comedi_device *dev,
 
 	/* wait for circuit to settle */
 	for (i = 0; i < 40000; i++) {
-		status = dmm_inb(dev, DMM32AT_AIRBACK);
+		status = inb(dev->iobase + DMM32AT_AIRBACK);
 		if ((status & DMM32AT_STATUS) == 0)
 			break;
 	}
@@ -247,7 +246,7 @@ static int dmm32at_ai_rinsn(struct comedi_device *dev,
 		dmm_outb(dev, DMM32AT_CONV, 0xff);
 		/* wait for conversion to end */
 		for (i = 0; i < 40000; i++) {
-			status = dmm_inb(dev, DMM32AT_AISTAT);
+			status = inb(dev->iobase + DMM32AT_AISTAT);
 			if ((status & DMM32AT_STATUS) == 0)
 				break;
 		}
@@ -257,8 +256,8 @@ static int dmm32at_ai_rinsn(struct comedi_device *dev,
 		}
 
 		/* read data */
-		lsb = dmm_inb(dev, DMM32AT_AILSB);
-		msb = dmm_inb(dev, DMM32AT_AIMSB);
+		lsb = inb(dev->iobase + DMM32AT_AILSB);
+		msb = inb(dev->iobase + DMM32AT_AIMSB);
 
 		/* invert sign bit to make range unsigned, this is an
 		   idiosyncrasy of the diamond board, it return
@@ -550,7 +549,7 @@ static int dmm32at_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 
 	/* wait for circuit to settle */
 	for (i = 0; i < 40000; i++) {
-		status = dmm_inb(dev, DMM32AT_AIRBACK);
+		status = inb(dev->iobase + DMM32AT_AIRBACK);
 		if ((status & DMM32AT_STATUS) == 0)
 			break;
 	}
@@ -600,7 +599,7 @@ static irqreturn_t dmm32at_isr(int irq, void *d)
 		return IRQ_HANDLED;
 	}
 
-	intstat = dmm_inb(dev, DMM32AT_INTCLOCK);
+	intstat = inb(dev->iobase + DMM32AT_INTCLOCK);
 
 	if (intstat & DMM32AT_ADINT) {
 		struct comedi_subdevice *s = dev->read_subdev;
@@ -608,8 +607,8 @@ static irqreturn_t dmm32at_isr(int irq, void *d)
 
 		for (i = 0; i < cmd->chanlist_len; i++) {
 			/* read data */
-			lsb = dmm_inb(dev, DMM32AT_AILSB);
-			msb = dmm_inb(dev, DMM32AT_AIMSB);
+			lsb = inb(dev->iobase + DMM32AT_AILSB);
+			msb = inb(dev->iobase + DMM32AT_AIMSB);
 
 			/* invert sign bit to make range unsigned */
 			samp = ((msb ^ 0x0080) << 8) + lsb;
@@ -660,7 +659,7 @@ static int dmm32at_ao_winsn(struct comedi_device *dev,
 
 		/* wait for circuit to settle */
 		for (i = 0; i < 40000; i++) {
-			status = dmm_inb(dev, DMM32AT_DACSTAT);
+			status = inb(dev->iobase + DMM32AT_DACSTAT);
 			if ((status & DMM32AT_DACBUSY) == 0)
 				break;
 		}
@@ -669,7 +668,7 @@ static int dmm32at_ao_winsn(struct comedi_device *dev,
 			return -ETIMEDOUT;
 		}
 		/* dummy read to update trigger the output */
-		status = dmm_inb(dev, DMM32AT_DACMSB);
+		status = inb(dev->iobase + DMM32AT_DACMSB);
 
 	}
 
@@ -731,11 +730,11 @@ static int dmm32at_dio_insn_bits(struct comedi_device *dev,
 	}
 
 	/* now read the state back in */
-	s->state = dmm_inb(dev, DMM32AT_DIOC);
+	s->state = inb(dev->iobase + DMM32AT_DIOC);
 	s->state <<= 8;
-	s->state |= dmm_inb(dev, DMM32AT_DIOB);
+	s->state |= inb(dev->iobase + DMM32AT_DIOB);
 	s->state <<= 8;
-	s->state |= dmm_inb(dev, DMM32AT_DIOA);
+	s->state |= inb(dev->iobase + DMM32AT_DIOA);
 	data[1] = s->state;
 
 	/* on return, data[1] contains the value of the digital
@@ -836,12 +835,12 @@ static int dmm32at_attach(struct comedi_device *dev,
 	udelay(100);
 
 	/* read back the values */
-	ailo = dmm_inb(dev, DMM32AT_AILOW);
-	aihi = dmm_inb(dev, DMM32AT_AIHIGH);
-	fifostat = dmm_inb(dev, DMM32AT_FIFOSTAT);
-	aistat = dmm_inb(dev, DMM32AT_AISTAT);
-	intstat = dmm_inb(dev, DMM32AT_INTCLOCK);
-	airback = dmm_inb(dev, DMM32AT_AIRBACK);
+	ailo = inb(dev->iobase + DMM32AT_AILOW);
+	aihi = inb(dev->iobase + DMM32AT_AIHIGH);
+	fifostat = inb(dev->iobase + DMM32AT_FIFOSTAT);
+	aistat = inb(dev->iobase + DMM32AT_AISTAT);
+	intstat = inb(dev->iobase + DMM32AT_INTCLOCK);
+	airback = inb(dev->iobase + DMM32AT_AIRBACK);
 
 	printk(KERN_DEBUG "dmm32at: lo=0x%02x hi=0x%02x fifostat=0x%02x\n",
 	       ailo, aihi, fifostat);
-- 
1.7.11

