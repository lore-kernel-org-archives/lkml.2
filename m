Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757866Ab1I3NTp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 09:19:45 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:48584 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757806Ab1I3NTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 09:19:40 -0400
From: Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 8/9] Staging: comedi: fix printk  issue in cb_pcidas.c
Date: Fri, 30 Sep 2011 18:48:26 +0530
Message-Id: <1317388707-1980-8-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.6.2
In-Reply-To: <1317388707-1980-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1317388707-1980-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the cb_pcidas.c file that fixes up a printk warning found by the checkpatch.pl tool

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/cb_pcidas.c |   40 +++++++++++----------------
 1 files changed, 16 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas.c b/drivers/staging/comedi/drivers/cb_pcidas.c
index 9d16c6c..617d3a6 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas.c
@@ -780,10 +780,8 @@ static int cb_pcidas_detach(struct comedi_device *dev)
 			/*  disable and clear interrupts on amcc s5933 */
 			outl(INTCSR_INBOX_INTR_STATUS,
 			     devpriv->s5933_config + AMCC_OP_REG_INTCSR);
-#ifdef CB_PCIDAS_DEBUG
-			printk("detaching, incsr is 0x%x\n",
-			       inl(devpriv->s5933_config + AMCC_OP_REG_INTCSR));
-#endif
+			dev_dbg(&pcidev->dev, "detaching, incsr is 0x%x\n",
+				inl(devpriv->s5933_config + AMCC_OP_REG_INTCSR));
 		}
 	}
 	if (dev->irq)
@@ -863,7 +861,7 @@ static int ai_config_calibration_source(struct comedi_device *dev,
 	unsigned int source = data[1];
 
 	if (source >= num_calibration_sources) {
-		printk("invalid calibration source: %i\n", source);
+		printk(KERN_WARNING "invalid calibration source: %i\n", source);
 		return -EINVAL;
 	}
 
@@ -1283,9 +1281,8 @@ static int cb_pcidas_ai_cmd(struct comedi_device *dev,
 		bits |= PACER_INT;
 	outw(bits, devpriv->control_status + ADCMUX_CONT);
 
-#ifdef CB_PCIDAS_DEBUG
-	printk("comedi: sent 0x%x to adcmux control\n", bits);
-#endif
+	dev_dbg(&pcidev->dev, "comedi: sent 0x%x to adcmux control\n",
+		bits);
 
 	/*  load counters */
 	if (cmd->convert_src == TRIG_TIMER)
@@ -1310,9 +1307,8 @@ static int cb_pcidas_ai_cmd(struct comedi_device *dev,
 	} else {
 		devpriv->adc_fifo_bits |= INT_FHF;	/* interrupt fifo half full */
 	}
-#ifdef CB_PCIDAS_DEBUG
-	printk("comedi: adc_fifo_bits are 0x%x\n", devpriv->adc_fifo_bits);
-#endif
+	dev_dbg(&pcidev->dev, "comedi: adc_fifo_bits are 0x%x\n",
+		devpriv->adc_fifo_bits);
 	/*  enable (and clear) interrupts */
 	outw(devpriv->adc_fifo_bits | EOAI | INT | LADFUL,
 	     devpriv->control_status + INT_ADCFIFO);
@@ -1336,9 +1332,8 @@ static int cb_pcidas_ai_cmd(struct comedi_device *dev,
 	if (cmd->convert_src == TRIG_NOW && cmd->chanlist_len > 1)
 		bits |= BURSTE;
 	outw(bits, devpriv->control_status + TRIG_CONTSTAT);
-#ifdef CB_PCIDAS_DEBUG
-	printk("comedi: sent 0x%x to trig control\n", bits);
-#endif
+	dev_dbg(&pcidev->dev, "comedi: sent 0x%x to trig control\n",
+		bits);
 
 	return 0;
 }
@@ -1553,9 +1548,8 @@ static int cb_pcidas_ao_inttrig(struct comedi_device *dev,
 	/*  enable dac half-full and empty interrupts */
 	spin_lock_irqsave(&dev->spinlock, flags);
 	devpriv->adc_fifo_bits |= DAEMIE | DAHFIE;
-#ifdef CB_PCIDAS_DEBUG
-	printk("comedi: adc_fifo_bits are 0x%x\n", devpriv->adc_fifo_bits);
-#endif
+	dev_dbg(&pcidev->dev, "comedi: adc_fifo_bits are 0x%x\n",
+		devpriv->adc_fifo_bits);
 	/*  enable and clear interrupts */
 	outw(devpriv->adc_fifo_bits | DAEMI | DAHFI,
 	     devpriv->control_status + INT_ADCFIFO);
@@ -1563,9 +1557,8 @@ static int cb_pcidas_ao_inttrig(struct comedi_device *dev,
 	/*  start dac */
 	devpriv->ao_control_bits |= DAC_START | DACEN | DAC_EMPTY;
 	outw(devpriv->ao_control_bits, devpriv->control_status + DAC_CSR);
-#ifdef CB_PCIDAS_DEBUG
-	printk("comedi: sent 0x%x to dac control\n", devpriv->ao_control_bits);
-#endif
+	dev_dbg(&pcidev->dev, "comedi: sent 0x%x to dac control\n",
+		devpriv->ao_control_bits);
 	spin_unlock_irqrestore(&dev->spinlock, flags);
 
 	async->inttrig = NULL;
@@ -1591,10 +1584,9 @@ static irqreturn_t cb_pcidas_interrupt(int irq, void *d)
 	async->events = 0;
 
 	s5933_status = inl(devpriv->s5933_config + AMCC_OP_REG_INTCSR);
-#ifdef CB_PCIDAS_DEBUG
-	printk("intcsr 0x%x\n", s5933_status);
-	printk("mbef 0x%x\n", inl(devpriv->s5933_config + AMCC_OP_REG_MBEF));
-#endif
+	dev_dbg(&pcidev->dev, "intcsr 0x%x\n", s5933_status);
+	dev_dbg(&pcidev->dev, "mbef 0x%x\n",
+		inl(devpriv->s5933_config + AMCC_OP_REG_MBEF));
 
 	if ((INTCSR_INTR_ASSERTED & s5933_status) == 0)
 		return IRQ_NONE;
-- 
1.7.6.2

