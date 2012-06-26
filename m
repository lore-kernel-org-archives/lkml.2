Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758117Ab2FZASH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 20:18:07 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:2209 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757903Ab2FZASE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 20:18:04 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-10.tower-209.messagelabs.com!1340669873!6932158!9
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 28/33] staging: comedi: cb_das16_cs: cleanup das16cs_ai_rinsn()
Date: Mon, 25 Jun 2012 17:17:52 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206251717.53025.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup to analog input read function.

1) Initialize the chan, range, and aref locale variables when
   they are declared.
2) Remove need for the static local variable.
3) Remove the unnecessary cast of inw()'s return value.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_das16_cs.c | 30 ++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_das16_cs.c b/drivers/staging/comedi/drivers/cb_das16_cs.c
index 11dc9b1..80e3540 100644
--- a/drivers/staging/comedi/drivers/cb_das16_cs.c
+++ b/drivers/staging/comedi/drivers/cb_das16_cs.c
@@ -111,16 +111,11 @@ static int das16cs_ai_rinsn(struct comedi_device *dev,
 			    struct comedi_insn *insn, unsigned int *data)
 {
 	struct das16cs_private *devpriv = dev->private;
+	int chan = CR_CHAN(insn->chanspec);
+	int range = CR_RANGE(insn->chanspec);
+	int aref = CR_AREF(insn->chanspec);
 	int i;
 	int to;
-	int aref;
-	int range;
-	int chan;
-	static int range_bits[] = { 0x800, 0x000, 0x100, 0x200 };
-
-	chan = CR_CHAN(insn->chanspec);
-	aref = CR_AREF(insn->chanspec);
-	range = CR_RANGE(insn->chanspec);
 
 	outw(chan, dev->iobase + 2);
 
@@ -129,7 +124,22 @@ static int das16cs_ai_rinsn(struct comedi_device *dev,
 	outw(devpriv->status1, dev->iobase + 4);
 
 	devpriv->status2 &= ~0xff00;
-	devpriv->status2 |= range_bits[range];
+	switch (range) {
+	case 0:
+		devpriv->status2 |= 0x800;
+		break;
+	case 1:
+		devpriv->status2 |= 0x000;
+		break;
+	case 2:
+		devpriv->status2 |= 0x100;
+		break;
+	case 3:
+		devpriv->status2 |= 0x200;
+		break;
+	default:
+		return -EINVAL;
+	}
 	outw(devpriv->status2, dev->iobase + 6);
 
 	for (i = 0; i < insn->n; i++) {
@@ -144,7 +154,7 @@ static int das16cs_ai_rinsn(struct comedi_device *dev,
 			dev_dbg(dev->class_dev, "cb_das16_cs: ai timeout\n");
 			return -ETIME;
 		}
-		data[i] = (unsigned short)inw(dev->iobase + 0);
+		data[i] = inw(dev->iobase + 0);
 	}
 
 	return i;
-- 
1.7.11

