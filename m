Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393Ab2GCBOI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 21:14:08 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:44092 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520Ab2GCBOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 21:14:06 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-4.tower-160.messagelabs.com!1341278043!7606323!4
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 6/8] staging: comedi: dmm32at: remove unneeded boardinfo variables
Date: Mon, 2 Jul 2012 18:13:53 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207021813.53876.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Like most of the comedi drivers, this one appears to have been started
based on the skel driver. Cut-and-paste from that driver has resulted
in an unnecessarily complex boardinfo struct.

Remove everything from the boardinfo struct, except the 'name', and
just use the open coded values in the attach function.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/dmm32at.c | 71 +++++++++++---------------------
 1 file changed, 23 insertions(+), 48 deletions(-)

diff --git a/drivers/staging/comedi/drivers/dmm32at.c b/drivers/staging/comedi/drivers/dmm32at.c
index 2ae31e8..1d21e22 100644
--- a/drivers/staging/comedi/drivers/dmm32at.c
+++ b/drivers/staging/comedi/drivers/dmm32at.c
@@ -156,21 +156,8 @@ static const struct comedi_lrange dmm32at_aoranges = {
 	 }
 };
 
-/*
- * Board descriptions for two imaginary boards.  Describing the
- * boards in this way is optional, and completely driver-dependent.
- * Some drivers use arrays such as this, other do not.
- */
 struct dmm32at_board {
 	const char *name;
-	int ai_chans;
-	int ai_bits;
-	const struct comedi_lrange *ai_ranges;
-	int ao_chans;
-	int ao_bits;
-	const struct comedi_lrange *ao_ranges;
-	int have_dio;
-	int dio_chans;
 };
 
 /* this structure is for data unique to this hardware driver.  If
@@ -880,9 +867,9 @@ static int dmm32at_attach(struct comedi_device *dev,
 	s->type = COMEDI_SUBD_AI;
 	/* we support single-ended (ground) and differential */
 	s->subdev_flags = SDF_READABLE | SDF_GROUND | SDF_DIFF | SDF_CMD_READ;
-	s->n_chan = board->ai_chans;
-	s->maxdata = (1 << board->ai_bits) - 1;
-	s->range_table = board->ai_ranges;
+	s->n_chan = 32;
+	s->maxdata = 0xffff;
+	s->range_table = &dmm32at_airanges;
 	s->len_chanlist = 32;	/* This is the maximum chanlist length that
 				   the board can handle */
 	s->insn_read = dmm32at_ai_rinsn;
@@ -894,35 +881,31 @@ static int dmm32at_attach(struct comedi_device *dev,
 	/* analog output subdevice */
 	s->type = COMEDI_SUBD_AO;
 	s->subdev_flags = SDF_WRITABLE;
-	s->n_chan = board->ao_chans;
-	s->maxdata = (1 << board->ao_bits) - 1;
-	s->range_table = board->ao_ranges;
+	s->n_chan = 4;
+	s->maxdata = 0x0fff;
+	s->range_table = &dmm32at_aoranges;
 	s->insn_write = dmm32at_ao_winsn;
 	s->insn_read = dmm32at_ao_rinsn;
 
 	s = dev->subdevices + 2;
 	/* digital i/o subdevice */
-	if (board->have_dio) {
-
-		/* get access to the DIO regs */
-		outb(DMM32AT_DIOACC, dev->iobase + DMM32AT_CNTRL);
-		/* set the DIO's to the defualt input setting */
-		devpriv->dio_config = DMM32AT_DIRA | DMM32AT_DIRB |
-		    DMM32AT_DIRCL | DMM32AT_DIRCH | DMM32AT_DIENABLE;
-		outb(devpriv->dio_config, dev->iobase + DMM32AT_DIOCONF);
-
-		/* set up the subdevice */
-		s->type = COMEDI_SUBD_DIO;
-		s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
-		s->n_chan = board->dio_chans;
-		s->maxdata = 1;
-		s->state = 0;
-		s->range_table = &range_digital;
-		s->insn_bits = dmm32at_dio_insn_bits;
-		s->insn_config = dmm32at_dio_insn_config;
-	} else {
-		s->type = COMEDI_SUBD_UNUSED;
-	}
+
+	/* get access to the DIO regs */
+	outb(DMM32AT_DIOACC, dev->iobase + DMM32AT_CNTRL);
+	/* set the DIO's to the defualt input setting */
+	devpriv->dio_config = DMM32AT_DIRA | DMM32AT_DIRB |
+		DMM32AT_DIRCL | DMM32AT_DIRCH | DMM32AT_DIENABLE;
+	outb(devpriv->dio_config, dev->iobase + DMM32AT_DIOCONF);
+
+	/* set up the subdevice */
+	s->type = COMEDI_SUBD_DIO;
+	s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
+	s->n_chan = 24;
+	s->maxdata = 1;
+	s->state = 0;
+	s->range_table = &range_digital;
+	s->insn_bits = dmm32at_dio_insn_bits;
+	s->insn_config = dmm32at_dio_insn_config;
 
 	/* success */
 	printk(KERN_INFO "comedi%d: dmm32at: attached\n", dev->minor);
@@ -942,14 +925,6 @@ static void dmm32at_detach(struct comedi_device *dev)
 static const struct dmm32at_board dmm32at_boards[] = {
 	{
 		.name		= "dmm32at",
-		.ai_chans	= 32,
-		.ai_bits	= 16,
-		.ai_ranges	= &dmm32at_airanges,
-		.ao_chans	= 4,
-		.ao_bits	= 12,
-		.ao_ranges	= &dmm32at_aoranges,
-		.have_dio	= 1,
-		.dio_chans	= 24,
 	},
 };
 
-- 
1.7.11

