Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179Ab2FMWmq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 18:42:46 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:5691 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755007Ab2FMWmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 18:42:44 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-4.tower-132.messagelabs.com!1339627362!11350076!2
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 11/15] staging: comedi: 8255: use a local variable for the iobase
Date: Wed, 13 Jun 2012 15:42:39 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206131542.40023.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To improve readability, use a locale variable to hold the 8255's
private iobase value.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/8255.c |   23 +++++++++++++----------
 1 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/comedi/drivers/8255.c b/drivers/staging/comedi/drivers/8255.c
index f6ea493..1f4b24c 100644
--- a/drivers/staging/comedi/drivers/8255.c
+++ b/drivers/staging/comedi/drivers/8255.c
@@ -106,10 +106,11 @@ void subdev_8255_interrupt(struct comedi_device *dev,
 			   struct comedi_subdevice *s)
 {
 	struct subdev_8255_private *spriv = s->private;
+	unsigned long iobase = spriv->iobase;
 	short d;
 
-	d = spriv->io(0, _8255_DATA, 0, spriv->iobase);
-	d |= (spriv->io(0, _8255_DATA + 1, 0, spriv->iobase) << 8);
+	d = spriv->io(0, _8255_DATA, 0, iobase);
+	d |= (spriv->io(0, _8255_DATA + 1, 0, iobase) << 8);
 
 	comedi_buf_put(s->async, d);
 	s->async->events |= COMEDI_CB_EOS;
@@ -133,25 +134,25 @@ static int subdev_8255_insn(struct comedi_device *dev,
 			    struct comedi_insn *insn, unsigned int *data)
 {
 	struct subdev_8255_private *spriv = s->private;
+	unsigned long iobase = spriv->iobase;
 
 	if (data[0]) {
 		s->state &= ~data[0];
 		s->state |= (data[0] & data[1]);
 
 		if (data[0] & 0xff)
-			spriv->io(1, _8255_DATA, s->state & 0xff,
-				  spriv->iobase);
+			spriv->io(1, _8255_DATA, s->state & 0xff, iobase);
 		if (data[0] & 0xff00)
 			spriv->io(1, _8255_DATA + 1,
-				  (s->state >> 8) & 0xff, spriv->iobase);
+				  (s->state >> 8) & 0xff, iobase);
 		if (data[0] & 0xff0000)
 			spriv->io(1, _8255_DATA + 2,
-				  (s->state >> 16) & 0xff, spriv->iobase);
+				  (s->state >> 16) & 0xff, iobase);
 	}
 
-	data[1] = spriv->io(0, _8255_DATA, 0, spriv->iobase);
-	data[1] |= (spriv->io(0, _8255_DATA + 1, 0, spriv->iobase) << 8);
-	data[1] |= (spriv->io(0, _8255_DATA + 2, 0, spriv->iobase) << 16);
+	data[1] = spriv->io(0, _8255_DATA, 0, iobase);
+	data[1] |= (spriv->io(0, _8255_DATA + 1, 0, iobase) << 8);
+	data[1] |= (spriv->io(0, _8255_DATA + 2, 0, iobase) << 16);
 
 	return 2;
 }
@@ -159,6 +160,7 @@ static int subdev_8255_insn(struct comedi_device *dev,
 static void do_config(struct comedi_device *dev, struct comedi_subdevice *s)
 {
 	struct subdev_8255_private *spriv = s->private;
+	unsigned long iobase = spriv->iobase;
 	int config;
 
 	config = CR_CW;
@@ -171,7 +173,8 @@ static void do_config(struct comedi_device *dev, struct comedi_subdevice *s)
 		config |= CR_C_LO_IO;
 	if (!(s->io_bits & 0xf00000))
 		config |= CR_C_HI_IO;
-	spriv->io(1, _8255_CR, config, spriv->iobase);
+
+	spriv->io(1, _8255_CR, config, iobase);
 }
 
 static int subdev_8255_insn_config(struct comedi_device *dev,
-- 
1.7.7

