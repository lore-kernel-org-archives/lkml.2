Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758221Ab2EWAjf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 20:39:35 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:5621 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235Ab2EWAje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 20:39:34 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-6.tower-131.messagelabs.com!1337733573!13412355!2
X-Originating-IP: [216.166.12.72]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: remove this_board macro in the pcmad driver
Date: Tue, 22 May 2012 17:39:22 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205221739.22746.hartleys@visionengravers.com>
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

diff --git a/drivers/staging/comedi/drivers/pcmad.c b/drivers/staging/comedi/drivers/pcmad.c
index 1ec7d5c..2ec0b2e 100644
--- a/drivers/staging/comedi/drivers/pcmad.c
+++ b/drivers/staging/comedi/drivers/pcmad.c
@@ -58,8 +58,6 @@ struct pcmad_board_struct {
 	int n_ai_bits;
 };
 
-#define this_board ((const struct pcmad_board_struct *)(dev->board_ptr))
-
 struct pcmad_priv_struct {
 	int differential;
 	int twos_comp;
@@ -72,6 +70,7 @@ static int pcmad_ai_insn_read(struct comedi_device *dev,
 			      struct comedi_subdevice *s,
 			      struct comedi_insn *insn, unsigned int *data)
 {
+	const struct pcmad_board_struct *board = comedi_board(dev);
 	int i;
 	int chan;
 	int n;
@@ -89,7 +88,7 @@ static int pcmad_ai_insn_read(struct comedi_device *dev,
 		data[n] |= (inb(dev->iobase + PCMAD_MSB) << 8);
 
 		if (devpriv->twos_comp)
-			data[n] ^= (1 << (this_board->n_ai_bits - 1));
+			data[n] ^= (1 << (board->n_ai_bits - 1));
 	}
 
 	return n;
@@ -104,6 +103,7 @@ static int pcmad_ai_insn_read(struct comedi_device *dev,
  */
 static int pcmad_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
+	const struct pcmad_board_struct *board = comedi_board(dev);
 	int ret;
 	struct comedi_subdevice *s;
 	unsigned long iobase;
@@ -125,7 +125,7 @@ static int pcmad_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (ret < 0)
 		return ret;
 
-	dev->board_name = this_board->name;
+	dev->board_name = board->name;
 
 	s = dev->subdevices + 0;
 	s->type = COMEDI_SUBD_AI;
@@ -133,7 +133,7 @@ static int pcmad_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	s->n_chan = 16;		/* XXX */
 	s->len_chanlist = 1;
 	s->insn_read = pcmad_ai_insn_read;
-	s->maxdata = (1 << this_board->n_ai_bits) - 1;
+	s->maxdata = (1 << board->n_ai_bits) - 1;
 	s->range_table = &range_unknown;
 
 	return 0;
