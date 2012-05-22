Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932811Ab2EVXNy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 19:13:54 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:29531 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529Ab2EVXNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 19:13:53 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-15.tower-132.messagelabs.com!1337728428!12434646!4
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: remove thisboard macro in the das16m1 driver
Date: Tue, 22 May 2012 16:13:38 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205221613.38508.hartleys@visionengravers.com>
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

diff --git a/drivers/staging/comedi/drivers/das16m1.c b/drivers/staging/comedi/drivers/das16m1.c
index d2e1490..e468ff1 100644
--- a/drivers/staging/comedi/drivers/das16m1.c
+++ b/drivers/staging/comedi/drivers/das16m1.c
@@ -150,7 +150,6 @@ struct das16m1_private_struct {
 	unsigned int divisor2;	/*  divides master clock to obtain conversion speed */
 };
 #define devpriv ((struct das16m1_private_struct *)(dev->private))
-#define thisboard ((const struct das16m1_board *)(dev->board_ptr))
 
 static inline short munge_sample(short data)
 {
@@ -168,6 +167,7 @@ static void munge_sample_array(short *array, unsigned int num_elements)
 static int das16m1_cmd_test(struct comedi_device *dev,
 			    struct comedi_subdevice *s, struct comedi_cmd *cmd)
 {
+	const struct das16m1_board *board = comedi_board(dev);
 	unsigned int err = 0, tmp, i;
 
 	/* make sure triggers are valid */
@@ -225,8 +225,8 @@ static int das16m1_cmd_test(struct comedi_device *dev,
 	}
 
 	if (cmd->convert_src == TRIG_TIMER) {
-		if (cmd->convert_arg < thisboard->ai_speed) {
-			cmd->convert_arg = thisboard->ai_speed;
+		if (cmd->convert_arg < board->ai_speed) {
+			cmd->convert_arg = board->ai_speed;
 			err++;
 		}
 	}
@@ -600,6 +600,7 @@ static int das16m1_irq_bits(unsigned int irq)
 static int das16m1_attach(struct comedi_device *dev,
 			  struct comedi_devconfig *it)
 {
+	const struct das16m1_board *board = comedi_board(dev);
 	struct comedi_subdevice *s;
 	int ret;
 	unsigned int irq;
@@ -611,7 +612,7 @@ static int das16m1_attach(struct comedi_device *dev,
 	if (ret < 0)
 		return ret;
 
-	dev->board_name = thisboard->name;
+	dev->board_name = board->name;
 
 	if (!request_region(iobase, DAS16M1_SIZE, dev->driver->driver_name)) {
 		comedi_error(dev, "I/O port conflict\n");
