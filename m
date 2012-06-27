Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755726Ab2F0AuM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 20:50:12 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:43149 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755274Ab2F0AuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 20:50:10 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-14.tower-209.messagelabs.com!1340758207!7010316!4
X-Originating-IP: [216.166.12.180]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 06/36] staging: comedi: cb_pcidas: remove forward declarations 6
Date: Tue, 26 Jun 2012 17:49:58 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206261749.59101.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the cb_pcidas_load_counters function to remove the need for
the forward declaration.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_pcidas.c | 30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas.c b/drivers/staging/comedi/drivers/cb_pcidas.c
index 2457408..1e5616e 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas.c
@@ -447,8 +447,6 @@ struct cb_pcidas_private {
  */
 #define devpriv ((struct cb_pcidas_private *)dev->private)
 
-static void cb_pcidas_load_counters(struct comedi_device *dev, unsigned int *ns,
-				    int round_flags);
 static int caldac_8800_write(struct comedi_device *dev, unsigned int address,
 			     uint8_t value);
 static int trimpot_7376_write(struct comedi_device *dev, uint8_t value);
@@ -915,6 +913,20 @@ static int cb_pcidas_ai_cmdtest(struct comedi_device *dev,
 	return 0;
 }
 
+static void cb_pcidas_load_counters(struct comedi_device *dev, unsigned int *ns,
+				    int rounding_flags)
+{
+	i8253_cascade_ns_to_timer_2div(TIMER_BASE, &(devpriv->divisor1),
+				       &(devpriv->divisor2), ns,
+				       rounding_flags & TRIG_ROUND_MASK);
+
+	/* Write the values of ctr1 and ctr2 into counters 1 and 2 */
+	i8254_load(devpriv->pacer_counter_dio + ADC8254, 0, 1,
+		   devpriv->divisor1, 2);
+	i8254_load(devpriv->pacer_counter_dio + ADC8254, 0, 2,
+		   devpriv->divisor2, 2);
+}
+
 static int cb_pcidas_ai_cmd(struct comedi_device *dev,
 			    struct comedi_subdevice *s)
 {
@@ -1444,20 +1456,6 @@ static irqreturn_t cb_pcidas_interrupt(int irq, void *d)
 	return IRQ_HANDLED;
 }
 
-static void cb_pcidas_load_counters(struct comedi_device *dev, unsigned int *ns,
-				    int rounding_flags)
-{
-	i8253_cascade_ns_to_timer_2div(TIMER_BASE, &(devpriv->divisor1),
-				       &(devpriv->divisor2), ns,
-				       rounding_flags & TRIG_ROUND_MASK);
-
-	/* Write the values of ctr1 and ctr2 into counters 1 and 2 */
-	i8254_load(devpriv->pacer_counter_dio + ADC8254, 0, 1,
-		   devpriv->divisor1, 2);
-	i8254_load(devpriv->pacer_counter_dio + ADC8254, 0, 2,
-		   devpriv->divisor2, 2);
-}
-
 static void write_calibration_bitstream(struct comedi_device *dev,
 					unsigned int register_bits,
 					unsigned int bitstream,
-- 
1.7.11

