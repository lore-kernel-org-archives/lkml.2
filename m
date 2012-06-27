Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012Ab2F0BKd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 21:10:33 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:36412 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755438Ab2F0BKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 21:10:32 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-13.tower-160.messagelabs.com!1340759430!7903484!2
X-Originating-IP: [216.166.12.72]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 33/36] staging: comedi: cb_pcidas: cleanup cb_pcidas_ao_fifo_winsn()
Date: Tue, 26 Jun 2012 18:10:22 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206261810.22694.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create local variables for the channel and range in order to
cleanup to mask/set of the ao_control_bits.

Remove the extra space in all the comments.

Return the number of data parameters used (insn->n) to indicate
success instead of the open coded '1'.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_pcidas.c | 29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas.c b/drivers/staging/comedi/drivers/cb_pcidas.c
index 2a282d3..bbbb9e4 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas.c
@@ -498,32 +498,29 @@ static int cb_pcidas_ao_fifo_winsn(struct comedi_device *dev,
 				   struct comedi_insn *insn, unsigned int *data)
 {
 	struct cb_pcidas_private *devpriv = dev->private;
-	int channel;
+	unsigned int chan = CR_CHAN(insn->chanspec);
+	unsigned int range = CR_RANGE(insn->chanspec);
 	unsigned long flags;
 
-	/*  clear dac fifo */
+	/* clear dac fifo */
 	outw(0, devpriv->ao_registers + DACFIFOCLR);
 
-	/*  set channel and range */
-	channel = CR_CHAN(insn->chanspec);
+	/* set channel and range */
 	spin_lock_irqsave(&dev->spinlock, flags);
-	devpriv->ao_control_bits &=
-	    ~DAC_CHAN_EN(0) & ~DAC_CHAN_EN(1) & ~DAC_RANGE_MASK(channel) &
-	    ~DAC_PACER_MASK;
-	devpriv->ao_control_bits |=
-	    DACEN | DAC_RANGE(channel,
-			      CR_RANGE(insn->
-				       chanspec)) | DAC_CHAN_EN(channel) |
-	    DAC_START;
+	devpriv->ao_control_bits &= (~DAC_CHAN_EN(0) & ~DAC_CHAN_EN(1) &
+				     ~DAC_RANGE_MASK(chan) & ~DAC_PACER_MASK);
+	devpriv->ao_control_bits |= (DACEN | DAC_RANGE(chan, range) |
+				     DAC_CHAN_EN(chan) | DAC_START);
 	outw(devpriv->ao_control_bits, devpriv->control_status + DAC_CSR);
 	spin_unlock_irqrestore(&dev->spinlock, flags);
 
-	/*  remember value for readback */
-	devpriv->ao_value[channel] = data[0];
-	/*  send data */
+	/* remember value for readback */
+	devpriv->ao_value[chan] = data[0];
+
+	/* send data */
 	outw(data[0], devpriv->ao_registers + DACDATA);
 
-	return 1;
+	return insn->n;
 }
 
 static int cb_pcidas_ao_readback_insn(struct comedi_device *dev,
-- 
1.7.11

