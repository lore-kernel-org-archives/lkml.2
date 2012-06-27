Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614Ab2F0AsS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 20:48:18 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:25582 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753821Ab2F0AsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 20:48:17 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-9.tower-160.messagelabs.com!1340758095!7874008!1
X-Originating-IP: [216.166.12.180]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 03/36] staging: comedi: cb_pcidas: remove forward declarations 3
Date: Tue, 26 Jun 2012 17:48:05 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206261748.05758.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the handle_ao_interrupt function to remove the need for
the forward declaration.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_pcidas.c | 111 ++++++++++++++---------------
 1 file changed, 55 insertions(+), 56 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas.c b/drivers/staging/comedi/drivers/cb_pcidas.c
index e94a6b1..584f85b 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas.c
@@ -447,7 +447,6 @@ struct cb_pcidas_private {
  */
 #define devpriv ((struct cb_pcidas_private *)dev->private)
 
-static void handle_ao_interrupt(struct comedi_device *dev, unsigned int status);
 static int cb_pcidas_cancel(struct comedi_device *dev,
 			    struct comedi_subdevice *s);
 static int cb_pcidas_ao_cancel(struct comedi_device *dev,
@@ -1245,6 +1244,61 @@ static int cb_pcidas_ao_cmd(struct comedi_device *dev,
 	return 0;
 }
 
+static void handle_ao_interrupt(struct comedi_device *dev, unsigned int status)
+{
+	struct comedi_subdevice *s = dev->write_subdev;
+	struct comedi_async *async = s->async;
+	struct comedi_cmd *cmd = &async->cmd;
+	unsigned int half_fifo = thisboard->fifo_size / 2;
+	unsigned int num_points;
+	unsigned long flags;
+
+	async->events = 0;
+
+	if (status & DAEMI) {
+		/*  clear dac empty interrupt latch */
+		spin_lock_irqsave(&dev->spinlock, flags);
+		outw(devpriv->adc_fifo_bits | DAEMI,
+		     devpriv->control_status + INT_ADCFIFO);
+		spin_unlock_irqrestore(&dev->spinlock, flags);
+		if (inw(devpriv->ao_registers + DAC_CSR) & DAC_EMPTY) {
+			if (cmd->stop_src == TRIG_NONE ||
+			    (cmd->stop_src == TRIG_COUNT
+			     && devpriv->ao_count)) {
+				comedi_error(dev, "dac fifo underflow");
+				cb_pcidas_ao_cancel(dev, s);
+				async->events |= COMEDI_CB_ERROR;
+			}
+			async->events |= COMEDI_CB_EOA;
+		}
+	} else if (status & DAHFI) {
+		unsigned int num_bytes;
+
+		/*  figure out how many points we are writing to fifo */
+		num_points = half_fifo;
+		if (cmd->stop_src == TRIG_COUNT &&
+		    devpriv->ao_count < num_points)
+			num_points = devpriv->ao_count;
+		num_bytes =
+		    cfc_read_array_from_buffer(s, devpriv->ao_buffer,
+					       num_points * sizeof(short));
+		num_points = num_bytes / sizeof(short);
+
+		if (async->cmd.stop_src == TRIG_COUNT)
+			devpriv->ao_count -= num_points;
+		/*  write data to board's fifo */
+		outsw(devpriv->ao_registers + DACDATA, devpriv->ao_buffer,
+		      num_points);
+		/*  clear half-full interrupt latch */
+		spin_lock_irqsave(&dev->spinlock, flags);
+		outw(devpriv->adc_fifo_bits | DAHFI,
+		     devpriv->control_status + INT_ADCFIFO);
+		spin_unlock_irqrestore(&dev->spinlock, flags);
+	}
+
+	comedi_event(dev, s);
+}
+
 static irqreturn_t cb_pcidas_interrupt(int irq, void *d)
 {
 	struct comedi_device *dev = (struct comedi_device *)d;
@@ -1355,61 +1409,6 @@ static irqreturn_t cb_pcidas_interrupt(int irq, void *d)
 	return IRQ_HANDLED;
 }
 
-static void handle_ao_interrupt(struct comedi_device *dev, unsigned int status)
-{
-	struct comedi_subdevice *s = dev->write_subdev;
-	struct comedi_async *async = s->async;
-	struct comedi_cmd *cmd = &async->cmd;
-	unsigned int half_fifo = thisboard->fifo_size / 2;
-	unsigned int num_points;
-	unsigned long flags;
-
-	async->events = 0;
-
-	if (status & DAEMI) {
-		/*  clear dac empty interrupt latch */
-		spin_lock_irqsave(&dev->spinlock, flags);
-		outw(devpriv->adc_fifo_bits | DAEMI,
-		     devpriv->control_status + INT_ADCFIFO);
-		spin_unlock_irqrestore(&dev->spinlock, flags);
-		if (inw(devpriv->ao_registers + DAC_CSR) & DAC_EMPTY) {
-			if (cmd->stop_src == TRIG_NONE ||
-			    (cmd->stop_src == TRIG_COUNT
-			     && devpriv->ao_count)) {
-				comedi_error(dev, "dac fifo underflow");
-				cb_pcidas_ao_cancel(dev, s);
-				async->events |= COMEDI_CB_ERROR;
-			}
-			async->events |= COMEDI_CB_EOA;
-		}
-	} else if (status & DAHFI) {
-		unsigned int num_bytes;
-
-		/*  figure out how many points we are writing to fifo */
-		num_points = half_fifo;
-		if (cmd->stop_src == TRIG_COUNT &&
-		    devpriv->ao_count < num_points)
-			num_points = devpriv->ao_count;
-		num_bytes =
-		    cfc_read_array_from_buffer(s, devpriv->ao_buffer,
-					       num_points * sizeof(short));
-		num_points = num_bytes / sizeof(short);
-
-		if (async->cmd.stop_src == TRIG_COUNT)
-			devpriv->ao_count -= num_points;
-		/*  write data to board's fifo */
-		outsw(devpriv->ao_registers + DACDATA, devpriv->ao_buffer,
-		      num_points);
-		/*  clear half-full interrupt latch */
-		spin_lock_irqsave(&dev->spinlock, flags);
-		outw(devpriv->adc_fifo_bits | DAHFI,
-		     devpriv->control_status + INT_ADCFIFO);
-		spin_unlock_irqrestore(&dev->spinlock, flags);
-	}
-
-	comedi_event(dev, s);
-}
-
 /* cancel analog input command */
 static int cb_pcidas_cancel(struct comedi_device *dev,
 			    struct comedi_subdevice *s)
-- 
1.7.11

