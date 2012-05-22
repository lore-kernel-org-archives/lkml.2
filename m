Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933407Ab2EVXyK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 19:54:10 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:36852 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760409Ab2EVXls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 19:41:48 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-2.tower-132.messagelabs.com!1337730105!12407678!2
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: remove thisboard macro in the ni_at_ao driver
Date: Tue, 22 May 2012 16:41:39 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205221641.39521.hartleys@visionengravers.com>
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

diff --git a/drivers/staging/comedi/drivers/ni_at_ao.c b/drivers/staging/comedi/drivers/ni_at_ao.c
index c43dd8a..bfe7fb7 100644
--- a/drivers/staging/comedi/drivers/ni_at_ao.c
+++ b/drivers/staging/comedi/drivers/ni_at_ao.c
@@ -157,8 +157,6 @@ struct atao_board {
 	int n_ao_chans;
 };
 
-#define thisboard ((struct atao_board *)dev->board_ptr)
-
 struct atao_private {
 
 	unsigned short cfg1;
@@ -335,6 +333,7 @@ static int atao_calib_insn_write(struct comedi_device *dev,
 
 static int atao_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
+	const struct atao_board *board = comedi_board(dev);
 	struct comedi_subdevice *s;
 	unsigned long iobase;
 	int ao_unipolar;
@@ -352,9 +351,7 @@ static int atao_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	}
 	dev->iobase = iobase;
 
-	/* dev->board_ptr = atao_probe(dev); */
-
-	dev->board_name = thisboard->name;
+	dev->board_name = board->name;
 
 	if (alloc_private(dev, sizeof(struct atao_private)) < 0)
 		return -ENOMEM;
@@ -366,7 +363,7 @@ static int atao_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	/* analog output subdevice */
 	s->type = COMEDI_SUBD_AO;
 	s->subdev_flags = SDF_WRITABLE;
-	s->n_chan = thisboard->n_ao_chans;
+	s->n_chan = board->n_ao_chans;
 	s->maxdata = (1 << 12) - 1;
 	if (ao_unipolar)
 		s->range_table = &range_unipolar10;
