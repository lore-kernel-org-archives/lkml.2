Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758129Ab2FZAS6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 20:18:58 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:60300 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757982Ab2FZAS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 20:18:57 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-12.tower-160.messagelabs.com!1340669912!7755231!12
X-Originating-IP: [216.166.12.178]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 29/33] staging: comedi: cb_das16_cs: use #define'd io reg offsets
Date: Mon, 25 Jun 2012 17:18:43 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206251718.44092.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of open coding the 'dev->iobase + n' for each io register
in the device, use the provided #define's for the offsets.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_das16_cs.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_das16_cs.c b/drivers/staging/comedi/drivers/cb_das16_cs.c
index 80e3540..f717840 100644
--- a/drivers/staging/comedi/drivers/cb_das16_cs.c
+++ b/drivers/staging/comedi/drivers/cb_das16_cs.c
@@ -117,11 +117,11 @@ static int das16cs_ai_rinsn(struct comedi_device *dev,
 	int i;
 	int to;
 
-	outw(chan, dev->iobase + 2);
+	outw(chan, dev->iobase + DAS16CS_DIO_MUX);
 
 	devpriv->status1 &= ~0xf320;
 	devpriv->status1 |= (aref == AREF_DIFF) ? 0 : 0x0020;
-	outw(devpriv->status1, dev->iobase + 4);
+	outw(devpriv->status1, dev->iobase + DAS16CS_MISC1);
 
 	devpriv->status2 &= ~0xff00;
 	switch (range) {
@@ -140,21 +140,21 @@ static int das16cs_ai_rinsn(struct comedi_device *dev,
 	default:
 		return -EINVAL;
 	}
-	outw(devpriv->status2, dev->iobase + 6);
+	outw(devpriv->status2, dev->iobase + DAS16CS_MISC2);
 
 	for (i = 0; i < insn->n; i++) {
-		outw(0, dev->iobase);
+		outw(0, dev->iobase + DAS16CS_ADC_DATA);
 
 #define TIMEOUT 1000
 		for (to = 0; to < TIMEOUT; to++) {
-			if (inw(dev->iobase + 4) & 0x0080)
+			if (inw(dev->iobase + DAS16CS_MISC1) & 0x0080)
 				break;
 		}
 		if (to == TIMEOUT) {
 			dev_dbg(dev->class_dev, "cb_das16_cs: ai timeout\n");
 			return -ETIME;
 		}
-		data[i] = inw(dev->iobase + 0);
+		data[i] = inw(dev->iobase + DAS16CS_ADC_DATA);
 	}
 
 	return i;
@@ -333,7 +333,7 @@ static int das16cs_ao_winsn(struct comedi_device *dev,
 		devpriv->ao_readback[chan] = data[i];
 		d = data[i];
 
-		outw(devpriv->status1, dev->iobase + 4);
+		outw(devpriv->status1, dev->iobase + DAS16CS_MISC1);
 		udelay(1);
 
 		status1 = devpriv->status1 & ~0xf;
@@ -343,22 +343,22 @@ static int das16cs_ao_winsn(struct comedi_device *dev,
 			status1 |= 0x0008;
 
 /*		printk("0x%04x\n",status1);*/
-		outw(status1, dev->iobase + 4);
+		outw(status1, dev->iobase + DAS16CS_MISC1);
 		udelay(1);
 
 		for (bit = 15; bit >= 0; bit--) {
 			int b = (d >> bit) & 0x1;
 			b <<= 1;
 /*			printk("0x%04x\n",status1 | b | 0x0000);*/
-			outw(status1 | b | 0x0000, dev->iobase + 4);
+			outw(status1 | b | 0x0000, dev->iobase + DAS16CS_MISC1);
 			udelay(1);
 /*			printk("0x%04x\n",status1 | b | 0x0004);*/
-			outw(status1 | b | 0x0004, dev->iobase + 4);
+			outw(status1 | b | 0x0004, dev->iobase + DAS16CS_MISC1);
 			udelay(1);
 		}
 /*		make high both DAC0CS and DAC1CS to load
 		new data and update analog output*/
-		outw(status1 | 0x9, dev->iobase + 4);
+		outw(status1 | 0x9, dev->iobase + DAS16CS_MISC1);
 	}
 
 	return i;
@@ -386,10 +386,10 @@ static int das16cs_dio_insn_bits(struct comedi_device *dev,
 		s->state &= ~data[0];
 		s->state |= data[0] & data[1];
 
-		outw(s->state, dev->iobase + 16);
+		outw(s->state, dev->iobase + DAS16CS_DIO);
 	}
 
-	data[1] = inw(dev->iobase + 16);
+	data[1] = inw(dev->iobase + DAS16CS_DIO);
 
 	return insn->n;
 }
@@ -428,7 +428,7 @@ static int das16cs_dio_insn_config(struct comedi_device *dev,
 	devpriv->status2 |= (s->io_bits & 0xf0) ? 0x0080 : 0;
 	devpriv->status2 |= (s->io_bits & 0x0f) ? 0x0040 : 0;
 
-	outw(devpriv->status2, dev->iobase + 6);
+	outw(devpriv->status2, dev->iobase + DAS16CS_MISC2);
 
 	return insn->n;
 }
-- 
1.7.11

