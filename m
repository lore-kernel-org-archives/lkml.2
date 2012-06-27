Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025Ab2F0BLI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 21:11:08 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:64067 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755438Ab2F0BLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 21:11:06 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-5.tower-132.messagelabs.com!1340759465!12605001!1
X-Originating-IP: [216.166.12.72]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 34/36] staging: comedi: cb_pcidas: cleanup cb_pcidas_ao_nofifo_winsn()
Date: Tue, 26 Jun 2012 18:10:59 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206261811.00126.hartleys@visionengravers.com>
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
 drivers/staging/comedi/drivers/cb_pcidas.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas.c b/drivers/staging/comedi/drivers/cb_pcidas.c
index bbbb9e4..b00ccad 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas.c
@@ -471,25 +471,25 @@ static int cb_pcidas_ao_nofifo_winsn(struct comedi_device *dev,
 				     unsigned int *data)
 {
 	struct cb_pcidas_private *devpriv = dev->private;
-	int channel;
+	unsigned int chan = CR_CHAN(insn->chanspec);
+	unsigned int range = CR_RANGE(insn->chanspec);
 	unsigned long flags;
 
-	/*  set channel and range */
-	channel = CR_CHAN(insn->chanspec);
+	/* set channel and range */
 	spin_lock_irqsave(&dev->spinlock, flags);
-	devpriv->ao_control_bits &=
-	    ~DAC_MODE_UPDATE_BOTH & ~DAC_RANGE_MASK(channel);
-	devpriv->ao_control_bits |=
-	    DACEN | DAC_RANGE(channel, CR_RANGE(insn->chanspec));
+	devpriv->ao_control_bits &= (~DAC_MODE_UPDATE_BOTH &
+				     ~DAC_RANGE_MASK(chan));
+	devpriv->ao_control_bits |= (DACEN | DAC_RANGE(chan, range));
 	outw(devpriv->ao_control_bits, devpriv->control_status + DAC_CSR);
 	spin_unlock_irqrestore(&dev->spinlock, flags);
 
-	/*  remember value for readback */
-	devpriv->ao_value[channel] = data[0];
-	/*  send data */
-	outw(data[0], devpriv->ao_registers + DAC_DATA_REG(channel));
+	/* remember value for readback */
+	devpriv->ao_value[chan] = data[0];
+
+	/* send data */
+	outw(data[0], devpriv->ao_registers + DAC_DATA_REG(chan));
 
-	return 1;
+	return insn->n;
 }
 
 /* analog output insn for pcidas-1602 series */
-- 
1.7.11

