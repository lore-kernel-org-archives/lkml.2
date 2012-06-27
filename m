Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757979Ab2F0QRh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 12:17:37 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:43089 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246Ab2F0QRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 12:17:35 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-3.tower-209.messagelabs.com!1340813843!6641669!16
X-Originating-IP: [216.166.12.99]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: cb_pcidas: fix dac08_write_insn()
Date: Wed, 27 Jun 2012 09:17:17 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206270917.19036.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As pointed out by Ian Abbott, the comedi INSN_WRITE instructions
are meant to iterate over, and write, all the data[] passed from
the comedi core. Modify dac08_write_insn() to work as intended.

Since doc08_write_insn() now returns the proper response to the
core, make the dac08_write() helper return void.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Reported-by: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---

This is an incremental patch based on the previous series to
cleanup the cb_pcidas driver.

 drivers/staging/comedi/drivers/cb_pcidas.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas.c b/drivers/staging/comedi/drivers/cb_pcidas.c
index 3ba75af..301444e 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas.c
@@ -659,7 +659,7 @@ static int caldac_read_insn(struct comedi_device *dev,
 }
 
 /* 1602/16 pregain offset */
-static int dac08_write(struct comedi_device *dev, unsigned int value)
+static void dac08_write(struct comedi_device *dev, unsigned int value)
 {
 	struct cb_pcidas_private *devpriv = dev->private;
 	unsigned long cal_reg;
@@ -680,14 +680,18 @@ static int dac08_write(struct comedi_device *dev, unsigned int value)
 		outw(value, cal_reg);
 		udelay(1);
 	}
-	return 1;	/* insn->n */
 }
 
 static int dac08_write_insn(struct comedi_device *dev,
 			    struct comedi_subdevice *s,
 			    struct comedi_insn *insn, unsigned int *data)
 {
-	return dac08_write(dev, data[0]);
+	int i;
+
+	for (i = 0; i < insn->n; i++)
+		dac08_write(dev, data[i]);
+
+	return insn->n;
 }
 
 static int dac08_read_insn(struct comedi_device *dev,
-- 
1.7.11

