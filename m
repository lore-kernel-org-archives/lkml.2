Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880Ab2F0BMd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 21:12:33 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:38549 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159Ab2F0BMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 21:12:32 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-3.tower-131.messagelabs.com!1340759520!21472059!16
X-Originating-IP: [216.166.12.178]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 36/36] staging: comedi: cb_pcidas: cleanup dac08_write()
Date: Tue, 26 Jun 2012 18:12:15 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206261812.16108.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reverse the logic of the test against the cached value so that
the function only has one exit point.

Make the logic of the dac write a bit clearer by create a local
variable for the address used in the outw() calls and masking the
value to write and setting the enable bits before doing the outw()
calls. Add a comment just to make sure it's clear.

Also, add a comment about the 'return 1;'.  This should be
insn->n which is the number of data parameters used to do the
dac08_write_insn() but the insn is not a parameter to this
function.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_pcidas.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas.c b/drivers/staging/comedi/drivers/cb_pcidas.c
index 1479325..3ba75af 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas.c
@@ -662,23 +662,25 @@ static int caldac_read_insn(struct comedi_device *dev,
 static int dac08_write(struct comedi_device *dev, unsigned int value)
 {
 	struct cb_pcidas_private *devpriv = dev->private;
+	unsigned long cal_reg;
 
-	if (devpriv->dac08_value == value)
-		return 1;
+	if (devpriv->dac08_value != value) {
+		devpriv->dac08_value = value;
 
-	devpriv->dac08_value = value;
+		cal_reg = devpriv->control_status + CALIBRATION_REG;
 
-	outw(cal_enable_bits(dev) | (value & 0xff),
-	     devpriv->control_status + CALIBRATION_REG);
-	udelay(1);
-	outw(cal_enable_bits(dev) | SELECT_DAC08_BIT | (value & 0xff),
-	     devpriv->control_status + CALIBRATION_REG);
-	udelay(1);
-	outw(cal_enable_bits(dev) | (value & 0xff),
-	     devpriv->control_status + CALIBRATION_REG);
-	udelay(1);
+		value &= 0xff;
+		value |= cal_enable_bits(dev);
 
-	return 1;
+		/* latch the new value into the caldac */
+		outw(value, cal_reg);
+		udelay(1);
+		outw(value | SELECT_DAC08_BIT, cal_reg);
+		udelay(1);
+		outw(value, cal_reg);
+		udelay(1);
+	}
+	return 1;	/* insn->n */
 }
 
 static int dac08_write_insn(struct comedi_device *dev,
-- 
1.7.11

