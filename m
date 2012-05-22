Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964873Ab2EVXqX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 19:46:23 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:65287 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933887Ab2EVXqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 19:46:14 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-6.tower-127.messagelabs.com!1337730373!6297040!1
X-Originating-IP: [216.166.12.99]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: remove boardtype macro in the ni_atmio16d driver
Date: Tue, 22 May 2012 16:46:07 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205221646.07717.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'boardtype' macro depends on having a local variable with
a magic name. The CodingStyle document suggests not doing this
to avoid confusion. Remove the macro and use the comedi_board()
inline helper to get the dev->board_ptr information.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

diff --git a/drivers/staging/comedi/drivers/ni_atmio16d.c b/drivers/staging/comedi/drivers/ni_atmio16d.c
index 4f61453..a0890ee 100644
--- a/drivers/staging/comedi/drivers/ni_atmio16d.c
+++ b/drivers/staging/comedi/drivers/ni_atmio16d.c
@@ -110,8 +110,6 @@ struct atmio16_board_t {
 	int has_8255;
 };
 
-#define boardtype ((const struct atmio16_board_t *)dev->board_ptr)
-
 /* range structs */
 static const struct comedi_lrange range_atmio16d_ai_10_bipolar = { 4, {
 								       BIP_RANGE
@@ -693,6 +691,7 @@ static int atmio16d_dio_insn_config(struct comedi_device *dev,
 static int atmio16d_attach(struct comedi_device *dev,
 			   struct comedi_devconfig *it)
 {
+	const struct atmio16_board_t *board = comedi_board(dev);
 	unsigned int irq;
 	unsigned long iobase;
 	int ret;
@@ -708,8 +707,7 @@ static int atmio16d_attach(struct comedi_device *dev,
 	}
 	dev->iobase = iobase;
 
-	/* board name */
-	dev->board_name = boardtype->name;
+	dev->board_name = board->name;
 
 	ret = alloc_subdevices(dev, 4);
 	if (ret < 0)
@@ -811,7 +809,7 @@ static int atmio16d_attach(struct comedi_device *dev,
 
 	/* 8255 subdevice */
 	s++;
-	if (boardtype->has_8255)
+	if (board->has_8255)
 		subdev_8255_init(dev, s, NULL, dev->iobase);
 	else
 		s->type = COMEDI_SUBD_UNUSED;
@@ -831,7 +829,9 @@ static int atmio16d_attach(struct comedi_device *dev,
 
 static void atmio16d_detach(struct comedi_device *dev)
 {
-	if (dev->subdevices && boardtype->has_8255)
+	const struct atmio16_board_t *board = comedi_board(dev);
+
+	if (dev->subdevices && board->has_8255)
 		subdev_8255_cleanup(dev, dev->subdevices + 3);
 	if (dev->irq)
 		free_irq(dev->irq, dev);
