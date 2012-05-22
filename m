Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756368Ab2EVW6h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 18:58:37 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:12078 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499Ab2EVW6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 18:58:36 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-3.tower-131.messagelabs.com!1337727513!21301591!6
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: remove thisboard macro in the comedi_test driver
Date: Tue, 22 May 2012 15:58:28 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205221558.28768.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'thisboard' macro depends on having a local variable with
a magic name. The CodingStyle document suggests not doing this
to avoid confusion. Remove the macro and use the comedi_board()
inline helper to get the dev->board_ptr information.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

diff --git a/drivers/staging/comedi/drivers/comedi_test.c b/drivers/staging/comedi/drivers/comedi_test.c
index 873e374..9f3c3d5 100644
--- a/drivers/staging/comedi/drivers/comedi_test.c
+++ b/drivers/staging/comedi/drivers/comedi_test.c
@@ -67,8 +67,6 @@ struct waveform_board {
 
 #define N_CHANS 8
 
-#define thisboard ((const struct waveform_board *)dev->board_ptr)
-
 /* Data unique to this driver */
 struct waveform_private {
 	struct timer_list timer;
@@ -429,12 +427,13 @@ static int waveform_ao_insn_write(struct comedi_device *dev,
 static int waveform_attach(struct comedi_device *dev,
 			   struct comedi_devconfig *it)
 {
+	const struct waveform_board *board = comedi_board(dev);
 	struct comedi_subdevice *s;
 	int amplitude = it->options[0];
 	int period = it->options[1];
 	int i;
 
-	dev->board_name = thisboard->name;
+	dev->board_name = board->name;
 
 	if (alloc_private(dev, sizeof(struct waveform_private)) < 0)
 		return -ENOMEM;
@@ -457,8 +456,8 @@ static int waveform_attach(struct comedi_device *dev,
 	/* analog input subdevice */
 	s->type = COMEDI_SUBD_AI;
 	s->subdev_flags = SDF_READABLE | SDF_GROUND | SDF_CMD_READ;
-	s->n_chan = thisboard->ai_chans;
-	s->maxdata = (1 << thisboard->ai_bits) - 1;
+	s->n_chan = board->ai_chans;
+	s->maxdata = (1 << board->ai_bits) - 1;
 	s->range_table = &waveform_ai_ranges;
 	s->len_chanlist = s->n_chan * 2;
 	s->insn_read = waveform_ai_insn_read;
@@ -471,8 +470,8 @@ static int waveform_attach(struct comedi_device *dev,
 	/* analog output subdevice (loopback) */
 	s->type = COMEDI_SUBD_AO;
 	s->subdev_flags = SDF_WRITEABLE | SDF_GROUND;
-	s->n_chan = thisboard->ai_chans;
-	s->maxdata = (1 << thisboard->ai_bits) - 1;
+	s->n_chan = board->ai_chans;
+	s->maxdata = (1 << board->ai_bits) - 1;
 	s->range_table = &waveform_ai_ranges;
 	s->len_chanlist = s->n_chan * 2;
 	s->insn_write = waveform_ao_insn_write;
