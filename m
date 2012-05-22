Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757708Ab2EVWli (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 18:41:38 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:45003 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360Ab2EVWlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 18:41:36 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-2.tower-131.messagelabs.com!1337726494!24257584!4
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: remove thisboard macro in the adq12b driver
Date: Tue, 22 May 2012 15:41:29 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205221541.29400.hartleys@visionengravers.com>
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

diff --git a/drivers/staging/comedi/drivers/adq12b.c b/drivers/staging/comedi/drivers/adq12b.c
index 7d585a1..1da2989 100644
--- a/drivers/staging/comedi/drivers/adq12b.c
+++ b/drivers/staging/comedi/drivers/adq12b.c
@@ -125,8 +125,6 @@ struct adq12b_board {
 	int do_chans;
 };
 
-#define thisboard ((const struct adq12b_board *)dev->board_ptr)
-
 struct adq12b_private {
 	int unipolar;		/* option 2 of comedi_config (1 is iobase) */
 	int differential;	/* option 3 of comedi_config */
@@ -222,6 +220,7 @@ static int adq12b_do_insn_bits(struct comedi_device *dev,
 
 static int adq12b_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
+	const struct adq12b_board *board = comedi_board(dev);
 	struct comedi_subdevice *s;
 	unsigned long iobase;
 	int unipolar, differential;
@@ -250,11 +249,7 @@ static int adq12b_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	}
 	dev->iobase = iobase;
 
-/*
- * Initialize dev->board_name.  Note that we can use the "thisboard"
- * macro now, since we just initialized it in the last line.
- */
-	dev->board_name = thisboard->name;
+	dev->board_name = board->name;
 
 /*
  * Allocate the private structure area.  alloc_private() is a
@@ -284,10 +279,10 @@ static int adq12b_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	s->type = COMEDI_SUBD_AI;
 	if (differential) {
 		s->subdev_flags = SDF_READABLE | SDF_GROUND | SDF_DIFF;
-		s->n_chan = thisboard->ai_diff_chans;
+		s->n_chan = board->ai_diff_chans;
 	} else {
 		s->subdev_flags = SDF_READABLE | SDF_GROUND;
-		s->n_chan = thisboard->ai_se_chans;
+		s->n_chan = board->ai_se_chans;
 	}
 
 	if (unipolar)
@@ -295,7 +290,7 @@ static int adq12b_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	else
 		s->range_table = &range_adq12b_ai_bipolar;
 
-	s->maxdata = (1 << thisboard->ai_bits) - 1;
+	s->maxdata = (1 << board->ai_bits) - 1;
 
 	s->len_chanlist = 4;	/* This is the maximum chanlist length that
 				   the board can handle */
@@ -305,7 +300,7 @@ static int adq12b_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	/* digital input subdevice */
 	s->type = COMEDI_SUBD_DI;
 	s->subdev_flags = SDF_READABLE;
-	s->n_chan = thisboard->di_chans;
+	s->n_chan = board->di_chans;
 	s->maxdata = 1;
 	s->range_table = &range_digital;
 	s->insn_bits = adq12b_di_insn_bits;
@@ -314,7 +309,7 @@ static int adq12b_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	/* digital output subdevice */
 	s->type = COMEDI_SUBD_DO;
 	s->subdev_flags = SDF_WRITABLE;
-	s->n_chan = thisboard->do_chans;
+	s->n_chan = board->do_chans;
 	s->maxdata = 1;
 	s->range_table = &range_digital;
 	s->insn_bits = adq12b_do_insn_bits;
