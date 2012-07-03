Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933258Ab2GCBOk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 21:14:40 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:20596 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756219Ab2GCBOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 21:14:38 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-12.tower-209.messagelabs.com!1341278077!7586421!1
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 7/8] staging: comedi: dmm32at: remove devpriv macro
Date: Mon, 2 Jul 2012 18:14:27 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207021814.27700.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'devpriv' macro relies on a local variable having a specific
name and yields a pointer derived from that local variable. Replace
the macro with a local variable where used.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/dmm32at.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/comedi/drivers/dmm32at.c b/drivers/staging/comedi/drivers/dmm32at.c
index 1d21e22..f0221e9 100644
--- a/drivers/staging/comedi/drivers/dmm32at.c
+++ b/drivers/staging/comedi/drivers/dmm32at.c
@@ -177,12 +177,6 @@ struct dmm32at_private {
 };
 
 /*
- * most drivers define the following macro to make it easy to
- * access the private structure.
- */
-#define devpriv ((struct dmm32at_private *)dev->private)
-
-/*
  * "instructions" read/write data in "one-shot" or "software-triggered"
  * mode.
  */
@@ -494,6 +488,7 @@ static void dmm32at_setaitimer(struct comedi_device *dev, unsigned int nansec)
 
 static int dmm32at_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 {
+	struct dmm32at_private *devpriv = dev->private;
 	struct comedi_cmd *cmd = &s->async->cmd;
 	int i, range;
 	unsigned char chanlo, chanhi, status;
@@ -566,17 +561,20 @@ static int dmm32at_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 static int dmm32at_ai_cancel(struct comedi_device *dev,
 			     struct comedi_subdevice *s)
 {
+	struct dmm32at_private *devpriv = dev->private;
+
 	devpriv->ai_scans_left = 1;
 	return 0;
 }
 
 static irqreturn_t dmm32at_isr(int irq, void *d)
 {
+	struct comedi_device *dev = d;
+	struct dmm32at_private *devpriv = dev->private;
 	unsigned char intstat;
 	unsigned int samp;
 	unsigned short msb, lsb;
 	int i;
-	struct comedi_device *dev = d;
 
 	if (!dev->attached) {
 		comedi_error(dev, "spurious interrupt");
@@ -622,6 +620,7 @@ static int dmm32at_ao_winsn(struct comedi_device *dev,
 			    struct comedi_subdevice *s,
 			    struct comedi_insn *insn, unsigned int *data)
 {
+	struct dmm32at_private *devpriv = dev->private;
 	int i;
 	int chan = CR_CHAN(insn->chanspec);
 	unsigned char hi, lo, status;
@@ -666,6 +665,7 @@ static int dmm32at_ao_rinsn(struct comedi_device *dev,
 			    struct comedi_subdevice *s,
 			    struct comedi_insn *insn, unsigned int *data)
 {
+	struct dmm32at_private *devpriv = dev->private;
 	int i;
 	int chan = CR_CHAN(insn->chanspec);
 
@@ -684,6 +684,7 @@ static int dmm32at_dio_insn_bits(struct comedi_device *dev,
 				 struct comedi_subdevice *s,
 				 struct comedi_insn *insn, unsigned int *data)
 {
+	struct dmm32at_private *devpriv = dev->private;
 	unsigned char diobits;
 
 	/* The insn data is a mask in data[0] and the new data
@@ -735,6 +736,7 @@ static int dmm32at_dio_insn_config(struct comedi_device *dev,
 				   struct comedi_subdevice *s,
 				   struct comedi_insn *insn, unsigned int *data)
 {
+	struct dmm32at_private *devpriv = dev->private;
 	unsigned char chanbit;
 	int chan = CR_CHAN(insn->chanspec);
 
@@ -772,6 +774,7 @@ static int dmm32at_attach(struct comedi_device *dev,
 			  struct comedi_devconfig *it)
 {
 	const struct dmm32at_board *board = comedi_board(dev);
+	struct dmm32at_private *devpriv;
 	int ret;
 	struct comedi_subdevice *s;
 	unsigned char aihi, ailo, fifostat, aistat, intstat, airback;
@@ -854,8 +857,9 @@ static int dmm32at_attach(struct comedi_device *dev,
  * Allocate the private structure area.  alloc_private() is a
  * convenient macro defined in comedidev.h.
  */
-	if (alloc_private(dev, sizeof(struct dmm32at_private)) < 0)
+	if (alloc_private(dev, sizeof(*devpriv)) < 0)
 		return -ENOMEM;
+	devpriv = dev->private;
 
 	ret = comedi_alloc_subdevices(dev, 3);
 	if (ret)
-- 
1.7.11

