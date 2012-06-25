Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757961Ab2FYX4p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 19:56:45 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:3257 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755767Ab2FYX4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 19:56:43 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-9.tower-209.messagelabs.com!1340668602!6916273!1
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 15/33] staging: comedi: cb_das16_cs: remove thisboard and devpriv macros
Date: Mon, 25 Jun 2012 16:37:10 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206251637.10363.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'thisboard' and 'devpriv' macros rely on a local variable having
a specific name and yield pointers derived from that local variable.
Replace the macro with local variables where used. Use the
comedi_board() helper to get the 'thisboard' pointer.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_das16_cs.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_das16_cs.c b/drivers/staging/comedi/drivers/cb_das16_cs.c
index e0821b9..496c331 100644
--- a/drivers/staging/comedi/drivers/cb_das16_cs.c
+++ b/drivers/staging/comedi/drivers/cb_das16_cs.c
@@ -85,7 +85,6 @@ static const struct das16cs_board das16cs_boards[] = {
 };
 
 #define n_boards ARRAY_SIZE(das16cs_boards)
-#define thisboard ((const struct das16cs_board *)dev->board_ptr)
 
 struct das16cs_private {
 	struct pcmcia_device *link;
@@ -94,7 +93,6 @@ struct das16cs_private {
 	unsigned short status1;
 	unsigned short status2;
 };
-#define devpriv ((struct das16cs_private *)dev->private)
 
 static struct pcmcia_device *cur_dev;
 
@@ -120,6 +118,7 @@ static int das16cs_ai_rinsn(struct comedi_device *dev,
 			    struct comedi_subdevice *s,
 			    struct comedi_insn *insn, unsigned int *data)
 {
+	struct das16cs_private *devpriv = dev->private;
 	int i;
 	int to;
 	int aref;
@@ -328,6 +327,7 @@ static int das16cs_ao_winsn(struct comedi_device *dev,
 			    struct comedi_subdevice *s,
 			    struct comedi_insn *insn, unsigned int *data)
 {
+	struct das16cs_private *devpriv = dev->private;
 	int i;
 	int chan = CR_CHAN(insn->chanspec);
 	unsigned short status1;
@@ -375,6 +375,7 @@ static int das16cs_ao_rinsn(struct comedi_device *dev,
 			    struct comedi_subdevice *s,
 			    struct comedi_insn *insn, unsigned int *data)
 {
+	struct das16cs_private *devpriv = dev->private;
 	int i;
 	int chan = CR_CHAN(insn->chanspec);
 
@@ -411,6 +412,7 @@ static int das16cs_dio_insn_config(struct comedi_device *dev,
 				   struct comedi_subdevice *s,
 				   struct comedi_insn *insn, unsigned int *data)
 {
+	struct das16cs_private *devpriv = dev->private;
 	int chan = CR_CHAN(insn->chanspec);
 	int bits;
 
@@ -478,6 +480,7 @@ static const struct das16cs_board *das16cs_probe(struct comedi_device *dev,
 static int das16cs_attach(struct comedi_device *dev,
 			  struct comedi_devconfig *it)
 {
+	const struct das16cs_board *thisboard;
 	struct pcmcia_device *link;
 	struct comedi_subdevice *s;
 	int ret;
@@ -509,6 +512,7 @@ static int das16cs_attach(struct comedi_device *dev,
 	dev->board_ptr = das16cs_probe(dev, link);
 	if (!dev->board_ptr)
 		return -EIO;
+	thisboard = comedi_board(dev);
 
 	dev->board_name = thisboard->name;
 
-- 
1.7.11

