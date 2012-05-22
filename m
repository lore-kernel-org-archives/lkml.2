Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760372Ab2EVXeL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 19:34:11 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:47214 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755575Ab2EVXeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 19:34:09 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-14.tower-160.messagelabs.com!1337729632!7239704!12
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: remove this_board macro in the dt282x driver
Date: Tue, 22 May 2012 16:33:51 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205221633.52239.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'this_board' macro depends on having a local variable with
a magic name. The CodingStyle document suggests not doing this
to avoid confusion. Remove the macro and use the comedi_board()
inline helper to get the dev->board_ptr information.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

diff --git a/drivers/staging/comedi/drivers/dt282x.c b/drivers/staging/comedi/drivers/dt282x.c
index 736d8fa..eefda3c 100644
--- a/drivers/staging/comedi/drivers/dt282x.c
+++ b/drivers/staging/comedi/drivers/dt282x.c
@@ -221,8 +221,6 @@ struct dt282x_board {
 	int dabits;
 };
 
-#define this_board ((const struct dt282x_board *)dev->board_ptr)
-
 struct dt282x_private {
 	int ad_2scomp;		/* we have 2's comp jumper set  */
 	int da0_2scomp;		/* same, for DAC0               */
@@ -580,6 +578,7 @@ static int dt282x_ai_insn_read(struct comedi_device *dev,
 static int dt282x_ai_cmdtest(struct comedi_device *dev,
 			     struct comedi_subdevice *s, struct comedi_cmd *cmd)
 {
+	const struct dt282x_board *board = comedi_board(dev);
 	int err = 0;
 	int tmp;
 
@@ -658,8 +657,8 @@ static int dt282x_ai_cmdtest(struct comedi_device *dev,
 		cmd->convert_arg = SLOWEST_TIMER;
 		err++;
 	}
-	if (cmd->convert_arg < this_board->ai_speed) {
-		cmd->convert_arg = this_board->ai_speed;
+	if (cmd->convert_arg < board->ai_speed) {
+		cmd->convert_arg = board->ai_speed;
 		err++;
 	}
 	if (cmd->scan_end_arg != cmd->chanlist_len) {
@@ -694,6 +693,7 @@ static int dt282x_ai_cmdtest(struct comedi_device *dev,
 
 static int dt282x_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 {
+	const struct dt282x_board *board = comedi_board(dev);
 	struct comedi_cmd *cmd = &s->async->cmd;
 	int timer;
 
@@ -706,8 +706,8 @@ static int dt282x_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 
 	dt282x_disable_dma(dev);
 
-	if (cmd->convert_arg < this_board->ai_speed)
-		cmd->convert_arg = this_board->ai_speed;
+	if (cmd->convert_arg < board->ai_speed)
+		cmd->convert_arg = board->ai_speed;
 	timer = dt282x_ns_to_timer(&cmd->convert_arg, TRIG_ROUND_NEAREST);
 	outw(timer, dev->iobase + DT2821_TMRCTR);
 
@@ -1176,12 +1176,13 @@ static int dt282x_grab_dma(struct comedi_device *dev, int dma1, int dma2)
  */
 static int dt282x_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
+	const struct dt282x_board *board = comedi_board(dev);
 	int i, irq;
 	int ret;
 	struct comedi_subdevice *s;
 	unsigned long iobase;
 
-	dev->board_name = this_board->name;
+	dev->board_name = board->name;
 
 	iobase = it->options[opt_iobase];
 	if (!iobase)
