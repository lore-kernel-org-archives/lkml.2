Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561Ab2HOB0S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 21:26:18 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:44120 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755426Ab2HOB0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 21:26:05 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-14.tower-131.messagelabs.com!1344993963!14311839!3
X-Originating-IP: [216.166.12.99]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/7] staging: comedi: dnya_pci10xx: move boardinfo values into subdevice setup
Date: Tue, 14 Aug 2012 18:25:09 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208141825.09992.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is only one "boardtype" actually supported by this driver.
The second entry in the boardinfo is a dummy entry that would
result in an unusable device.

Remove the boardinfo fields and just use the open coded values
in the subdevice setup.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/dyna_pci10xx.c | 32 ++++++++-------------------
 1 file changed, 9 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/comedi/drivers/dyna_pci10xx.c b/drivers/staging/comedi/drivers/dyna_pci10xx.c
index 80bfae5..a23969e 100644
--- a/drivers/staging/comedi/drivers/dyna_pci10xx.c
+++ b/drivers/staging/comedi/drivers/dyna_pci10xx.c
@@ -57,24 +57,12 @@ static const char range_codes_pci1050_ai[] = { 0x00, 0x10, 0x30 };
 struct boardtype {
 	const char *name;
 	int device_id;
-	int ai_chans;
-	int ao_chans;
-	int di_chans;
-	int do_chans;
-	const struct comedi_lrange *range_ai;
-	const char *range_codes_ai;
 };
 
 static const struct boardtype boardtypes[] = {
 	{
 	.name = "dyna_pci1050",
 	.device_id = 0x1050,
-	.ai_chans = 16,
-	.ao_chans = 16,
-	.di_chans = 16,
-	.do_chans = 16,
-	.range_ai = &range_pci1050_ai,
-	.range_codes_ai = range_codes_pci1050_ai,
 	},
 	/*  dummy entry corresponding to driver name */
 	{.name = DRV_NAME},
@@ -94,7 +82,6 @@ static int dyna_pci10xx_insn_read_ai(struct comedi_device *dev,
 			struct comedi_subdevice *s,
 			struct comedi_insn *insn, unsigned int *data)
 {
-	const struct boardtype *thisboard = comedi_board(dev);
 	struct dyna_pci10xx_private *devpriv = dev->private;
 	int n, counter;
 	u16 d = 0;
@@ -102,7 +89,7 @@ static int dyna_pci10xx_insn_read_ai(struct comedi_device *dev,
 
 	/* get the channel number and range */
 	chan = CR_CHAN(insn->chanspec);
-	range = thisboard->range_codes_ai[CR_RANGE((insn->chanspec))];
+	range = range_codes_pci1050_ai[CR_RANGE((insn->chanspec))];
 
 	mutex_lock(&devpriv->mutex);
 	/* convert n samples */
@@ -139,13 +126,12 @@ static int dyna_pci10xx_insn_write_ao(struct comedi_device *dev,
 				 struct comedi_subdevice *s,
 				 struct comedi_insn *insn, unsigned int *data)
 {
-	const struct boardtype *thisboard = comedi_board(dev);
 	struct dyna_pci10xx_private *devpriv = dev->private;
 	int n;
 	unsigned int chan, range;
 
 	chan = CR_CHAN(insn->chanspec);
-	range = thisboard->range_codes_ai[CR_RANGE((insn->chanspec))];
+	range = range_codes_pci1050_ai[CR_RANGE((insn->chanspec))];
 
 	mutex_lock(&devpriv->mutex);
 	for (n = 0; n < insn->n; n++) {
@@ -259,9 +245,9 @@ static int dyna_pci10xx_attach_pci(struct comedi_device *dev,
 	s = dev->subdevices + 0;
 	s->type = COMEDI_SUBD_AI;
 	s->subdev_flags = SDF_READABLE | SDF_GROUND | SDF_DIFF;
-	s->n_chan = thisboard->ai_chans;
+	s->n_chan = 16;
 	s->maxdata = 0x0FFF;
-	s->range_table = thisboard->range_ai;
+	s->range_table = &range_pci1050_ai;
 	s->len_chanlist = 16;
 	s->insn_read = dyna_pci10xx_insn_read_ai;
 
@@ -269,7 +255,7 @@ static int dyna_pci10xx_attach_pci(struct comedi_device *dev,
 	s = dev->subdevices + 1;
 	s->type = COMEDI_SUBD_AO;
 	s->subdev_flags = SDF_WRITABLE;
-	s->n_chan = thisboard->ao_chans;
+	s->n_chan = 16;
 	s->maxdata = 0x0FFF;
 	s->range_table = &range_unipolar10;
 	s->len_chanlist = 16;
@@ -279,20 +265,20 @@ static int dyna_pci10xx_attach_pci(struct comedi_device *dev,
 	s = dev->subdevices + 2;
 	s->type = COMEDI_SUBD_DI;
 	s->subdev_flags = SDF_READABLE | SDF_GROUND;
-	s->n_chan = thisboard->di_chans;
+	s->n_chan = 16;
 	s->maxdata = 1;
 	s->range_table = &range_digital;
-	s->len_chanlist = thisboard->di_chans;
+	s->len_chanlist = 16;
 	s->insn_bits = dyna_pci10xx_di_insn_bits;
 
 	/* digital output */
 	s = dev->subdevices + 3;
 	s->type = COMEDI_SUBD_DO;
 	s->subdev_flags = SDF_WRITABLE | SDF_GROUND;
-	s->n_chan = thisboard->do_chans;
+	s->n_chan = 16;
 	s->maxdata = 1;
 	s->range_table = &range_digital;
-	s->len_chanlist = thisboard->do_chans;
+	s->len_chanlist = 16;
 	s->state = 0;
 	s->insn_bits = dyna_pci10xx_do_insn_bits;
 
-- 
1.7.11

