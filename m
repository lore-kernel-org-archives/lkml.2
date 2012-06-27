Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690Ab2F0Atb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 20:49:31 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:29115 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755229Ab2F0Ata (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 20:49:30 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-127.messagelabs.com!1340758168!6915281!1
X-Originating-IP: [216.166.12.178]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 05/36] staging: comedi: cb_pcidas: remove forward declarations 5
Date: Tue, 26 Jun 2012 17:49:22 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206261749.23540.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the cb_pcida_ao_cancel function to remove the need for
the forward declaration.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_pcidas.c | 40 ++++++++++++++----------------
 1 file changed, 19 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas.c b/drivers/staging/comedi/drivers/cb_pcidas.c
index fa3ed0e..2457408 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas.c
@@ -447,8 +447,6 @@ struct cb_pcidas_private {
  */
 #define devpriv ((struct cb_pcidas_private *)dev->private)
 
-static int cb_pcidas_ao_cancel(struct comedi_device *dev,
-			       struct comedi_subdevice *s);
 static void cb_pcidas_load_counters(struct comedi_device *dev, unsigned int *ns,
 				    int round_flags);
 static int caldac_8800_write(struct comedi_device *dev, unsigned int address,
@@ -1262,6 +1260,25 @@ static int cb_pcidas_ao_cmd(struct comedi_device *dev,
 	return 0;
 }
 
+/* cancel analog output command */
+static int cb_pcidas_ao_cancel(struct comedi_device *dev,
+			       struct comedi_subdevice *s)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->spinlock, flags);
+	/*  disable interrupts */
+	devpriv->adc_fifo_bits &= ~DAHFIE & ~DAEMIE;
+	outw(devpriv->adc_fifo_bits, devpriv->control_status + INT_ADCFIFO);
+
+	/*  disable output */
+	devpriv->ao_control_bits &= ~DACEN & ~DAC_PACER_MASK;
+	outw(devpriv->ao_control_bits, devpriv->control_status + DAC_CSR);
+	spin_unlock_irqrestore(&dev->spinlock, flags);
+
+	return 0;
+}
+
 static void handle_ao_interrupt(struct comedi_device *dev, unsigned int status)
 {
 	struct comedi_subdevice *s = dev->write_subdev;
@@ -1427,25 +1444,6 @@ static irqreturn_t cb_pcidas_interrupt(int irq, void *d)
 	return IRQ_HANDLED;
 }
 
-/* cancel analog output command */
-static int cb_pcidas_ao_cancel(struct comedi_device *dev,
-			       struct comedi_subdevice *s)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&dev->spinlock, flags);
-	/*  disable interrupts */
-	devpriv->adc_fifo_bits &= ~DAHFIE & ~DAEMIE;
-	outw(devpriv->adc_fifo_bits, devpriv->control_status + INT_ADCFIFO);
-
-	/*  disable output */
-	devpriv->ao_control_bits &= ~DACEN & ~DAC_PACER_MASK;
-	outw(devpriv->ao_control_bits, devpriv->control_status + DAC_CSR);
-	spin_unlock_irqrestore(&dev->spinlock, flags);
-
-	return 0;
-}
-
 static void cb_pcidas_load_counters(struct comedi_device *dev, unsigned int *ns,
 				    int rounding_flags)
 {
-- 
1.7.11

