Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755734Ab2F0Az3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 20:55:29 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:62006 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754960Ab2F0Az2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 20:55:28 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-16.tower-132.messagelabs.com!1340758527!12612420!1
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 14/36] staging: comedi: cb_pcidas: remove CB_PCIDAS_DEBUG define
Date: Tue, 26 Jun 2012 17:55:21 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206261755.22054.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This define enables some debug code that output a number
of dev_dbg() messages. These might be useful for development
but should not be in the final driver.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_pcidas.c | 34 +++---------------------------
 1 file changed, 3 insertions(+), 31 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas.c b/drivers/staging/comedi/drivers/cb_pcidas.c
index 4e5f1ba..e790ab0 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas.c
@@ -79,9 +79,6 @@ analog triggering on 1602 series
 #include "amcc_s5933.h"
 #include "comedi_fc.h"
 
-#undef CB_PCIDAS_DEBUG		/*  disable debugging code */
-/* #define CB_PCIDAS_DEBUG         enable debugging code */
-
 /* PCI vendor number of ComputerBoards/MeasurementComputing */
 #define PCI_VENDOR_ID_CB	0x1307
 #define TIMER_BASE 100		/*  10MHz master clock */
@@ -1092,10 +1089,6 @@ static int cb_pcidas_ai_cmd(struct comedi_device *dev,
 		bits |= PACER_INT;
 	outw(bits, devpriv->control_status + ADCMUX_CONT);
 
-#ifdef CB_PCIDAS_DEBUG
-	dev_dbg(dev->class_dev, "sent 0x%x to adcmux control\n", bits);
-#endif
-
 	/*  load counters */
 	if (cmd->convert_src == TRIG_TIMER)
 		cb_pcidas_load_counters(dev, &cmd->convert_arg,
@@ -1119,10 +1112,7 @@ static int cb_pcidas_ai_cmd(struct comedi_device *dev,
 	} else {
 		devpriv->adc_fifo_bits |= INT_FHF;	/* interrupt fifo half full */
 	}
-#ifdef CB_PCIDAS_DEBUG
-	dev_dbg(dev->class_dev, "adc_fifo_bits are 0x%x\n",
-		devpriv->adc_fifo_bits);
-#endif
+
 	/*  enable (and clear) interrupts */
 	outw(devpriv->adc_fifo_bits | EOAI | INT | LADFUL,
 	     devpriv->control_status + INT_ADCFIFO);
@@ -1146,9 +1136,6 @@ static int cb_pcidas_ai_cmd(struct comedi_device *dev,
 	if (cmd->convert_src == TRIG_NOW && cmd->chanlist_len > 1)
 		bits |= BURSTE;
 	outw(bits, devpriv->control_status + TRIG_CONTSTAT);
-#ifdef CB_PCIDAS_DEBUG
-	dev_dbg(dev->class_dev, "sent 0x%x to trig control\n", bits);
-#endif
 
 	return 0;
 }
@@ -1322,10 +1309,7 @@ static int cb_pcidas_ao_inttrig(struct comedi_device *dev,
 	/*  enable dac half-full and empty interrupts */
 	spin_lock_irqsave(&dev->spinlock, flags);
 	devpriv->adc_fifo_bits |= DAEMIE | DAHFIE;
-#ifdef CB_PCIDAS_DEBUG
-	dev_dbg(dev->class_dev, "adc_fifo_bits are 0x%x\n",
-		devpriv->adc_fifo_bits);
-#endif
+
 	/*  enable and clear interrupts */
 	outw(devpriv->adc_fifo_bits | DAEMI | DAHFI,
 	     devpriv->control_status + INT_ADCFIFO);
@@ -1333,10 +1317,7 @@ static int cb_pcidas_ao_inttrig(struct comedi_device *dev,
 	/*  start dac */
 	devpriv->ao_control_bits |= DAC_START | DACEN | DAC_EMPTY;
 	outw(devpriv->ao_control_bits, devpriv->control_status + DAC_CSR);
-#ifdef CB_PCIDAS_DEBUG
-	dev_dbg(dev->class_dev, "sent 0x%x to dac control\n",
-		devpriv->ao_control_bits);
-#endif
+
 	spin_unlock_irqrestore(&dev->spinlock, flags);
 
 	async->inttrig = NULL;
@@ -1508,11 +1489,6 @@ static irqreturn_t cb_pcidas_interrupt(int irq, void *d)
 	async->events = 0;
 
 	s5933_status = inl(devpriv->s5933_config + AMCC_OP_REG_INTCSR);
-#ifdef CB_PCIDAS_DEBUG
-	dev_dbg(dev->class_dev, "intcsr 0x%x\n", s5933_status);
-	dev_dbg(dev->class_dev, "mbef 0x%x\n",
-		inl(devpriv->s5933_config + AMCC_OP_REG_MBEF));
-#endif
 
 	if ((INTCSR_INTR_ASSERTED & s5933_status) == 0)
 		return IRQ_NONE;
@@ -1524,10 +1500,6 @@ static irqreturn_t cb_pcidas_interrupt(int irq, void *d)
 	     devpriv->s5933_config + AMCC_OP_REG_INTCSR);
 
 	status = inw(devpriv->control_status + INT_ADCFIFO);
-#ifdef CB_PCIDAS_DEBUG
-	if ((status & (INT | EOAI | LADFUL | DAHFI | DAEMI)) == 0)
-		comedi_error(dev, "spurious interrupt");
-#endif
 
 	/*  check for analog output interrupt */
 	if (status & (DAHFI | DAEMI))
-- 
1.7.11

