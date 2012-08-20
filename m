Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158Ab2HTWEd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 18:04:33 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:39367 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755400Ab2HTWEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 18:04:30 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-10.tower-131.messagelabs.com!1345500254!24765814!18
X-Originating-IP: [216.166.12.69]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] staging: comedi: comedi_test: remove devpriv macro
Date: Mon, 20 Aug 2012 15:04:24 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208201504.24690.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This macro relies on a local variable having a specific name. Remove it.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/comedi_test.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/comedi_test.c b/drivers/staging/comedi/drivers/comedi_test.c
index 523a809..c77ce75 100644
--- a/drivers/staging/comedi/drivers/comedi_test.c
+++ b/drivers/staging/comedi/drivers/comedi_test.c
@@ -81,7 +81,6 @@ struct waveform_private {
 	unsigned timer_running:1;
 	unsigned int ao_loopbacks[N_CHANS];
 };
-#define devpriv ((struct waveform_private *)dev->private)
 
 /* 1000 nanosec in a microsec */
 static const int nano_per_micro = 1000;
@@ -98,6 +97,7 @@ static const struct comedi_lrange waveform_ai_ranges = {
 static short fake_sawtooth(struct comedi_device *dev, unsigned int range_index,
 			   unsigned long current_time)
 {
+	struct waveform_private *devpriv = dev->private;
 	struct comedi_subdevice *s = dev->read_subdev;
 	unsigned int offset = s->maxdata / 2;
 	u64 value;
@@ -122,6 +122,7 @@ static short fake_squarewave(struct comedi_device *dev,
 			     unsigned int range_index,
 			     unsigned long current_time)
 {
+	struct waveform_private *devpriv = dev->private;
 	struct comedi_subdevice *s = dev->read_subdev;
 	unsigned int offset = s->maxdata / 2;
 	u64 value;
@@ -175,6 +176,7 @@ static short fake_waveform(struct comedi_device *dev, unsigned int channel,
 static void waveform_ai_interrupt(unsigned long arg)
 {
 	struct comedi_device *dev = (struct comedi_device *)arg;
+	struct waveform_private *devpriv = dev->private;
 	struct comedi_async *async = dev->read_subdev->async;
 	struct comedi_cmd *cmd = &async->cmd;
 	unsigned int i, j;
@@ -362,6 +364,7 @@ static int waveform_ai_cmdtest(struct comedi_device *dev,
 static int waveform_ai_cmd(struct comedi_device *dev,
 			   struct comedi_subdevice *s)
 {
+	struct waveform_private *devpriv = dev->private;
 	struct comedi_cmd *cmd = &s->async->cmd;
 
 	if (cmd->flags & TRIG_RT) {
@@ -395,6 +398,8 @@ static int waveform_ai_cmd(struct comedi_device *dev,
 static int waveform_ai_cancel(struct comedi_device *dev,
 			      struct comedi_subdevice *s)
 {
+	struct waveform_private *devpriv = dev->private;
+
 	devpriv->timer_running = 0;
 	del_timer(&devpriv->timer);
 	return 0;
@@ -404,6 +409,7 @@ static int waveform_ai_insn_read(struct comedi_device *dev,
 				 struct comedi_subdevice *s,
 				 struct comedi_insn *insn, unsigned int *data)
 {
+	struct waveform_private *devpriv = dev->private;
 	int i, chan = CR_CHAN(insn->chanspec);
 
 	for (i = 0; i < insn->n; i++)
@@ -416,6 +422,7 @@ static int waveform_ao_insn_write(struct comedi_device *dev,
 				  struct comedi_subdevice *s,
 				  struct comedi_insn *insn, unsigned int *data)
 {
+	struct waveform_private *devpriv = dev->private;
 	int i, chan = CR_CHAN(insn->chanspec);
 
 	for (i = 0; i < insn->n; i++)
@@ -428,6 +435,7 @@ static int waveform_attach(struct comedi_device *dev,
 			   struct comedi_devconfig *it)
 {
 	const struct waveform_board *board = comedi_board(dev);
+	struct waveform_private *devpriv;
 	struct comedi_subdevice *s;
 	int amplitude = it->options[0];
 	int period = it->options[1];
@@ -436,8 +444,10 @@ static int waveform_attach(struct comedi_device *dev,
 
 	dev->board_name = board->name;
 
-	if (alloc_private(dev, sizeof(struct waveform_private)) < 0)
-		return -ENOMEM;
+	ret = alloc_private(dev, sizeof(*devpriv));
+	if (ret < 0)
+		return ret;
+	devpriv = dev->private;
 
 	/* set default amplitude and period */
 	if (amplitude <= 0)
@@ -496,7 +506,9 @@ static int waveform_attach(struct comedi_device *dev,
 
 static void waveform_detach(struct comedi_device *dev)
 {
-	if (dev->private)
+	struct waveform_private *devpriv = dev->private;
+
+	if (devpriv)
 		waveform_ai_cancel(dev, dev->read_subdev);
 }
 
-- 
1.7.11

