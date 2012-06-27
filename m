Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616Ab2F0Arh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 20:47:37 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:47454 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310Ab2F0Arf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 20:47:35 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-14.tower-209.messagelabs.com!1340758054!7010144!1
X-Originating-IP: [216.166.12.99]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 02/36] staging: comedi: cb_pcidas: remove forward declarations 2
Date: Tue, 26 Jun 2012 17:47:28 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206261747.28904.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the cb_pcidas_ao_inttrig function to remove the need for
the forward declaration.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_pcidas.c | 103 ++++++++++++++---------------
 1 file changed, 50 insertions(+), 53 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas.c b/drivers/staging/comedi/drivers/cb_pcidas.c
index 5460410..e94a6b1 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas.c
@@ -447,9 +447,6 @@ struct cb_pcidas_private {
  */
 #define devpriv ((struct cb_pcidas_private *)dev->private)
 
-static int cb_pcidas_ao_inttrig(struct comedi_device *dev,
-				struct comedi_subdevice *subdev,
-				unsigned int trig_num);
 static void handle_ao_interrupt(struct comedi_device *dev, unsigned int status);
 static int cb_pcidas_cancel(struct comedi_device *dev,
 			    struct comedi_subdevice *s);
@@ -1132,6 +1129,56 @@ static int cb_pcidas_ao_cmdtest(struct comedi_device *dev,
 	return 0;
 }
 
+static int cb_pcidas_ao_inttrig(struct comedi_device *dev,
+				struct comedi_subdevice *s,
+				unsigned int trig_num)
+{
+	unsigned int num_bytes, num_points = thisboard->fifo_size;
+	struct comedi_async *async = s->async;
+	struct comedi_cmd *cmd = &s->async->cmd;
+	unsigned long flags;
+
+	if (trig_num != 0)
+		return -EINVAL;
+
+	/*  load up fifo */
+	if (cmd->stop_src == TRIG_COUNT && devpriv->ao_count < num_points)
+		num_points = devpriv->ao_count;
+
+	num_bytes = cfc_read_array_from_buffer(s, devpriv->ao_buffer,
+					       num_points * sizeof(short));
+	num_points = num_bytes / sizeof(short);
+
+	if (cmd->stop_src == TRIG_COUNT)
+		devpriv->ao_count -= num_points;
+	/*  write data to board's fifo */
+	outsw(devpriv->ao_registers + DACDATA, devpriv->ao_buffer, num_bytes);
+
+	/*  enable dac half-full and empty interrupts */
+	spin_lock_irqsave(&dev->spinlock, flags);
+	devpriv->adc_fifo_bits |= DAEMIE | DAHFIE;
+#ifdef CB_PCIDAS_DEBUG
+	dev_dbg(dev->class_dev, "adc_fifo_bits are 0x%x\n",
+		devpriv->adc_fifo_bits);
+#endif
+	/*  enable and clear interrupts */
+	outw(devpriv->adc_fifo_bits | DAEMI | DAHFI,
+	     devpriv->control_status + INT_ADCFIFO);
+
+	/*  start dac */
+	devpriv->ao_control_bits |= DAC_START | DACEN | DAC_EMPTY;
+	outw(devpriv->ao_control_bits, devpriv->control_status + DAC_CSR);
+#ifdef CB_PCIDAS_DEBUG
+	dev_dbg(dev->class_dev, "sent 0x%x to dac control\n",
+		devpriv->ao_control_bits);
+#endif
+	spin_unlock_irqrestore(&dev->spinlock, flags);
+
+	async->inttrig = NULL;
+
+	return 0;
+}
+
 static int cb_pcidas_ao_cmd(struct comedi_device *dev,
 			    struct comedi_subdevice *s)
 {
@@ -1198,56 +1245,6 @@ static int cb_pcidas_ao_cmd(struct comedi_device *dev,
 	return 0;
 }
 
-static int cb_pcidas_ao_inttrig(struct comedi_device *dev,
-				struct comedi_subdevice *s,
-				unsigned int trig_num)
-{
-	unsigned int num_bytes, num_points = thisboard->fifo_size;
-	struct comedi_async *async = s->async;
-	struct comedi_cmd *cmd = &s->async->cmd;
-	unsigned long flags;
-
-	if (trig_num != 0)
-		return -EINVAL;
-
-	/*  load up fifo */
-	if (cmd->stop_src == TRIG_COUNT && devpriv->ao_count < num_points)
-		num_points = devpriv->ao_count;
-
-	num_bytes = cfc_read_array_from_buffer(s, devpriv->ao_buffer,
-					       num_points * sizeof(short));
-	num_points = num_bytes / sizeof(short);
-
-	if (cmd->stop_src == TRIG_COUNT)
-		devpriv->ao_count -= num_points;
-	/*  write data to board's fifo */
-	outsw(devpriv->ao_registers + DACDATA, devpriv->ao_buffer, num_bytes);
-
-	/*  enable dac half-full and empty interrupts */
-	spin_lock_irqsave(&dev->spinlock, flags);
-	devpriv->adc_fifo_bits |= DAEMIE | DAHFIE;
-#ifdef CB_PCIDAS_DEBUG
-	dev_dbg(dev->class_dev, "adc_fifo_bits are 0x%x\n",
-		devpriv->adc_fifo_bits);
-#endif
-	/*  enable and clear interrupts */
-	outw(devpriv->adc_fifo_bits | DAEMI | DAHFI,
-	     devpriv->control_status + INT_ADCFIFO);
-
-	/*  start dac */
-	devpriv->ao_control_bits |= DAC_START | DACEN | DAC_EMPTY;
-	outw(devpriv->ao_control_bits, devpriv->control_status + DAC_CSR);
-#ifdef CB_PCIDAS_DEBUG
-	dev_dbg(dev->class_dev, "sent 0x%x to dac control\n",
-		devpriv->ao_control_bits);
-#endif
-	spin_unlock_irqrestore(&dev->spinlock, flags);
-
-	async->inttrig = NULL;
-
-	return 0;
-}
-
 static irqreturn_t cb_pcidas_interrupt(int irq, void *d)
 {
 	struct comedi_device *dev = (struct comedi_device *)d;
-- 
1.7.11

