Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149Ab2HTWFK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 18:05:10 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:54342 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755601Ab2HTWFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 18:05:07 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-3.tower-132.messagelabs.com!1345500305!13800611!3
X-Originating-IP: [216.166.12.99]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] staging: comedi: comedi_test: remove boardinfo
Date: Mon, 20 Aug 2012 15:05:02 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208201505.02671.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This boardinfo for this driver is unneccesary. This driver is only
for testing the comedi subsystem. It defines two dummy subdevices,
an 8 channel analog input subdevice and an 8 channel analog output
subdevice. There is no "board" associated with it.

Remove the boardinfo to keep the driver simple.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/comedi_test.c | 31 +++++-----------------------
 1 file changed, 5 insertions(+), 26 deletions(-)

diff --git a/drivers/staging/comedi/drivers/comedi_test.c b/drivers/staging/comedi/drivers/comedi_test.c
index c77ce75..6864716 100644
--- a/drivers/staging/comedi/drivers/comedi_test.c
+++ b/drivers/staging/comedi/drivers/comedi_test.c
@@ -57,14 +57,6 @@ zero volts).
 #include "comedi_fc.h"
 #include <linux/timer.h>
 
-/* Board descriptions */
-struct waveform_board {
-	const char *name;
-	int ai_chans;
-	int ai_bits;
-	int have_dio;
-};
-
 #define N_CHANS 8
 
 /* Data unique to this driver */
@@ -434,7 +426,6 @@ static int waveform_ao_insn_write(struct comedi_device *dev,
 static int waveform_attach(struct comedi_device *dev,
 			   struct comedi_devconfig *it)
 {
-	const struct waveform_board *board = comedi_board(dev);
 	struct waveform_private *devpriv;
 	struct comedi_subdevice *s;
 	int amplitude = it->options[0];
@@ -442,7 +433,7 @@ static int waveform_attach(struct comedi_device *dev,
 	int i;
 	int ret;
 
-	dev->board_name = board->name;
+	dev->board_name = dev->driver->driver_name;
 
 	ret = alloc_private(dev, sizeof(*devpriv));
 	if (ret < 0)
@@ -467,8 +458,8 @@ static int waveform_attach(struct comedi_device *dev,
 	/* analog input subdevice */
 	s->type = COMEDI_SUBD_AI;
 	s->subdev_flags = SDF_READABLE | SDF_GROUND | SDF_CMD_READ;
-	s->n_chan = board->ai_chans;
-	s->maxdata = (1 << board->ai_bits) - 1;
+	s->n_chan = N_CHANS;
+	s->maxdata = 0xffff;
 	s->range_table = &waveform_ai_ranges;
 	s->len_chanlist = s->n_chan * 2;
 	s->insn_read = waveform_ai_insn_read;
@@ -481,8 +472,8 @@ static int waveform_attach(struct comedi_device *dev,
 	/* analog output subdevice (loopback) */
 	s->type = COMEDI_SUBD_AO;
 	s->subdev_flags = SDF_WRITEABLE | SDF_GROUND;
-	s->n_chan = board->ai_chans;
-	s->maxdata = (1 << board->ai_bits) - 1;
+	s->n_chan = N_CHANS;
+	s->maxdata = 0xffff;
 	s->range_table = &waveform_ai_ranges;
 	s->len_chanlist = s->n_chan * 2;
 	s->insn_write = waveform_ao_insn_write;
@@ -512,23 +503,11 @@ static void waveform_detach(struct comedi_device *dev)
 		waveform_ai_cancel(dev, dev->read_subdev);
 }
 
-static const struct waveform_board waveform_boards[] = {
-	{
-		.name		= "comedi_test",
-		.ai_chans	= N_CHANS,
-		.ai_bits	= 16,
-		.have_dio	= 0,
-	},
-};
-
 static struct comedi_driver waveform_driver = {
 	.driver_name	= "comedi_test",
 	.module		= THIS_MODULE,
 	.attach		= waveform_attach,
 	.detach		= waveform_detach,
-	.board_name	= &waveform_boards[0].name,
-	.offset		= sizeof(struct waveform_board),
-	.num_names	= ARRAY_SIZE(waveform_boards),
 };
 module_comedi_driver(waveform_driver);
 
-- 
1.7.11

