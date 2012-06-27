Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594Ab2F0Asv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 20:48:51 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:34657 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754743Ab2F0Asu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 20:48:50 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-10.tower-160.messagelabs.com!1340758129!5256807!2
X-Originating-IP: [216.166.12.99]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 04/36] staging: comedi: cb_pcidas: remove forward declarations 4
Date: Tue, 26 Jun 2012 17:48:43 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <fmhess@users.sourceforge.net>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206261748.44279.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the cb_pcida_cancel function to remove the need for
the forward declaration.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_pcidas.c | 42 ++++++++++++++----------------
 1 file changed, 20 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas.c b/drivers/staging/comedi/drivers/cb_pcidas.c
index 584f85b..fa3ed0e 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas.c
@@ -447,8 +447,6 @@ struct cb_pcidas_private {
  */
 #define devpriv ((struct cb_pcidas_private *)dev->private)
 
-static int cb_pcidas_cancel(struct comedi_device *dev,
-			    struct comedi_subdevice *s);
 static int cb_pcidas_ao_cancel(struct comedi_device *dev,
 			       struct comedi_subdevice *s);
 static void cb_pcidas_load_counters(struct comedi_device *dev, unsigned int *ns,
@@ -1128,6 +1126,26 @@ static int cb_pcidas_ao_cmdtest(struct comedi_device *dev,
 	return 0;
 }
 
+/* cancel analog input command */
+static int cb_pcidas_cancel(struct comedi_device *dev,
+			    struct comedi_subdevice *s)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->spinlock, flags);
+	/*  disable interrupts */
+	devpriv->adc_fifo_bits &= ~INTE & ~EOAIE;
+	outw(devpriv->adc_fifo_bits, devpriv->control_status + INT_ADCFIFO);
+	spin_unlock_irqrestore(&dev->spinlock, flags);
+
+	/*  disable start trigger source and burst mode */
+	outw(0, devpriv->control_status + TRIG_CONTSTAT);
+	/*  software pacer source */
+	outw(0, devpriv->control_status + ADCMUX_CONT);
+
+	return 0;
+}
+
 static int cb_pcidas_ao_inttrig(struct comedi_device *dev,
 				struct comedi_subdevice *s,
 				unsigned int trig_num)
@@ -1409,26 +1427,6 @@ static irqreturn_t cb_pcidas_interrupt(int irq, void *d)
 	return IRQ_HANDLED;
 }
 
-/* cancel analog input command */
-static int cb_pcidas_cancel(struct comedi_device *dev,
-			    struct comedi_subdevice *s)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&dev->spinlock, flags);
-	/*  disable interrupts */
-	devpriv->adc_fifo_bits &= ~INTE & ~EOAIE;
-	outw(devpriv->adc_fifo_bits, devpriv->control_status + INT_ADCFIFO);
-	spin_unlock_irqrestore(&dev->spinlock, flags);
-
-	/*  disable start trigger source and burst mode */
-	outw(0, devpriv->control_status + TRIG_CONTSTAT);
-	/*  software pacer source */
-	outw(0, devpriv->control_status + ADCMUX_CONT);
-
-	return 0;
-}
-
 /* cancel analog output command */
 static int cb_pcidas_ao_cancel(struct comedi_device *dev,
 			       struct comedi_subdevice *s)
-- 
1.7.11

