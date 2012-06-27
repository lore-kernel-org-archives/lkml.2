Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043Ab2F0BLq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 21:11:46 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:33434 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755839Ab2F0BLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 21:11:45 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-13.tower-131.messagelabs.com!1340759503!12635389!1
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 35/36] staging: comedi: cb_pcidas: cleanup cb_pcidas_ai_rinsn()
Date: Tue, 26 Jun 2012 18:11:38 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206261811.38328.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create local variables for the channel, range, and aref in order
to make the remaining code a bit cleaner.

Remove the extra space in all the comments.

Remove the 'static const int timeout' and just use the open
coded value in the loop.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_pcidas.c | 35 ++++++++++++++----------------
 1 file changed, 16 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas.c b/drivers/staging/comedi/drivers/cb_pcidas.c
index b00ccad..1479325 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas.c
@@ -382,36 +382,33 @@ static inline unsigned int cal_enable_bits(struct comedi_device *dev)
 	return CAL_EN_BIT | CAL_SRC_BITS(devpriv->calibration_source);
 }
 
-/*
- * "instructions" read/write data in "one-shot" or "software-triggered"
- * mode.
- */
 static int cb_pcidas_ai_rinsn(struct comedi_device *dev,
 			      struct comedi_subdevice *s,
 			      struct comedi_insn *insn, unsigned int *data)
 {
 	struct cb_pcidas_private *devpriv = dev->private;
-	int n, i;
+	unsigned int chan = CR_CHAN(insn->chanspec);
+	unsigned int range = CR_RANGE(insn->chanspec);
+	unsigned int aref = CR_AREF(insn->chanspec);
 	unsigned int bits;
-	static const int timeout = 10000;
-	int channel;
-	/*  enable calibration input if appropriate */
+	int n, i;
+
+	/* enable calibration input if appropriate */
 	if (insn->chanspec & CR_ALT_SOURCE) {
 		outw(cal_enable_bits(dev),
 		     devpriv->control_status + CALIBRATION_REG);
-		channel = 0;
+		chan = 0;
 	} else {
 		outw(0, devpriv->control_status + CALIBRATION_REG);
-		channel = CR_CHAN(insn->chanspec);
 	}
-	/*  set mux limits and gain */
-	bits = BEGIN_SCAN(channel) |
-	    END_SCAN(channel) | GAIN_BITS(CR_RANGE(insn->chanspec));
-	/*  set unipolar/bipolar */
-	if (CR_RANGE(insn->chanspec) & IS_UNIPOLAR)
+
+	/* set mux limits and gain */
+	bits = BEGIN_SCAN(chan) | END_SCAN(chan) | GAIN_BITS(range);
+	/* set unipolar/bipolar */
+	if (range & IS_UNIPOLAR)
 		bits |= UNIP;
-	/*  set singleended/differential */
-	if (CR_AREF(insn->chanspec) != AREF_DIFF)
+	/* set single-ended/differential */
+	if (aref != AREF_DIFF)
 		bits |= SE;
 	outw(bits, devpriv->control_status + ADCMUX_CONT);
 
@@ -425,11 +422,11 @@ static int cb_pcidas_ai_rinsn(struct comedi_device *dev,
 
 		/* wait for conversion to end */
 		/* return -ETIMEDOUT if there is a timeout */
-		for (i = 0; i < timeout; i++) {
+		for (i = 0; i < 10000; i++) {
 			if (inw(devpriv->control_status + ADCMUX_CONT) & EOC)
 				break;
 		}
-		if (i == timeout)
+		if (i == 10000)
 			return -ETIMEDOUT;
 
 		/* read data */
-- 
1.7.11

