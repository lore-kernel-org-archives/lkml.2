Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987Ab2FMWlz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 18:41:55 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:33603 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754949Ab2FMWlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 18:41:52 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-15.tower-209.messagelabs.com!1339627308!8450008!3
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 04/15] staging: comedi: 8255: remove the s->private access macros
Date: Wed, 13 Jun 2012 15:41:45 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206131541.45981.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The macros CALLBACK_ARG, CALLBACK_FUNC, and subdevpriv all rely
on a a local variable having a specific name. Replace the macros
with local variables wherever they occur.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartmen <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/8255.c |   59 ++++++++++++++++++---------------
 1 files changed, 32 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/comedi/drivers/8255.c b/drivers/staging/comedi/drivers/8255.c
index 446dfc5..5e0e8ff 100644
--- a/drivers/staging/comedi/drivers/8255.c
+++ b/drivers/staging/comedi/drivers/8255.c
@@ -103,17 +103,14 @@ struct subdev_8255_private {
 	int have_irq;
 };
 
-#define CALLBACK_ARG	(((struct subdev_8255_private *)s->private)->cb_arg)
-#define CALLBACK_FUNC	(((struct subdev_8255_private *)s->private)->cb_func)
-#define subdevpriv	((struct subdev_8255_private *)s->private)
-
 void subdev_8255_interrupt(struct comedi_device *dev,
 			   struct comedi_subdevice *s)
 {
+	struct subdev_8255_private *spriv = s->private;
 	short d;
 
-	d = CALLBACK_FUNC(0, _8255_DATA, 0, CALLBACK_ARG);
-	d |= (CALLBACK_FUNC(0, _8255_DATA + 1, 0, CALLBACK_ARG) << 8);
+	d = spriv->cb_func(0, _8255_DATA, 0, spriv->cb_arg);
+	d |= (spriv->cb_func(0, _8255_DATA + 1, 0, spriv->cb_arg) << 8);
 
 	comedi_buf_put(s->async, d);
 	s->async->events |= COMEDI_CB_EOS;
@@ -138,30 +135,33 @@ static int subdev_8255_insn(struct comedi_device *dev,
 			    struct comedi_subdevice *s,
 			    struct comedi_insn *insn, unsigned int *data)
 {
+	struct subdev_8255_private *spriv = s->private;
+
 	if (data[0]) {
 		s->state &= ~data[0];
 		s->state |= (data[0] & data[1]);
 
 		if (data[0] & 0xff)
-			CALLBACK_FUNC(1, _8255_DATA, s->state & 0xff,
-				      CALLBACK_ARG);
+			spriv->cb_func(1, _8255_DATA, s->state & 0xff,
+				       spriv->cb_arg);
 		if (data[0] & 0xff00)
-			CALLBACK_FUNC(1, _8255_DATA + 1, (s->state >> 8) & 0xff,
-				      CALLBACK_ARG);
+			spriv->cb_func(1, _8255_DATA + 1,
+				       (s->state >> 8) & 0xff, spriv->cb_arg);
 		if (data[0] & 0xff0000)
-			CALLBACK_FUNC(1, _8255_DATA + 2,
-				      (s->state >> 16) & 0xff, CALLBACK_ARG);
+			spriv->cb_func(1, _8255_DATA + 2,
+				       (s->state >> 16) & 0xff, spriv->cb_arg);
 	}
 
-	data[1] = CALLBACK_FUNC(0, _8255_DATA, 0, CALLBACK_ARG);
-	data[1] |= (CALLBACK_FUNC(0, _8255_DATA + 1, 0, CALLBACK_ARG) << 8);
-	data[1] |= (CALLBACK_FUNC(0, _8255_DATA + 2, 0, CALLBACK_ARG) << 16);
+	data[1] = spriv->cb_func(0, _8255_DATA, 0, spriv->cb_arg);
+	data[1] |= (spriv->cb_func(0, _8255_DATA + 1, 0, spriv->cb_arg) << 8);
+	data[1] |= (spriv->cb_func(0, _8255_DATA + 2, 0, spriv->cb_arg) << 16);
 
 	return 2;
 }
 
 static void do_config(struct comedi_device *dev, struct comedi_subdevice *s)
 {
+	struct subdev_8255_private *spriv = s->private;
 	int config;
 
 	config = CR_CW;
@@ -174,7 +174,7 @@ static void do_config(struct comedi_device *dev, struct comedi_subdevice *s)
 		config |= CR_C_LO_IO;
 	if (!(s->io_bits & 0xf00000))
 		config |= CR_C_HI_IO;
-	CALLBACK_FUNC(1, _8255_CR, config, CALLBACK_ARG);
+	spriv->cb_func(1, _8255_CR, config, spriv->cb_arg);
 }
 
 static int subdev_8255_insn_config(struct comedi_device *dev,
@@ -310,21 +310,24 @@ int subdev_8255_init(struct comedi_device *dev, struct comedi_subdevice *s,
 		     int (*cb) (int, int, int, unsigned long),
 		     unsigned long arg)
 {
+	struct subdev_8255_private *spriv;
+
 	s->type = COMEDI_SUBD_DIO;
 	s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
 	s->n_chan = 24;
 	s->range_table = &range_digital;
 	s->maxdata = 1;
 
-	s->private = kmalloc(sizeof(struct subdev_8255_private), GFP_KERNEL);
-	if (!s->private)
+	spriv = kmalloc(sizeof(*spriv), GFP_KERNEL);
+	if (!spriv)
 		return -ENOMEM;
+	s->private = spriv;
 
-	CALLBACK_ARG = arg;
+	spriv->cb_arg = arg;
 	if (cb == NULL)
-		CALLBACK_FUNC = subdev_8255_cb;
+		spriv->cb_func = subdev_8255_cb;
 	else
-		CALLBACK_FUNC = cb;
+		spriv->cb_func = cb;
 	s->insn_bits = subdev_8255_insn;
 	s->insn_config = subdev_8255_insn_config;
 
@@ -340,18 +343,20 @@ int subdev_8255_init_irq(struct comedi_device *dev, struct comedi_subdevice *s,
 			 int (*cb) (int, int, int, unsigned long),
 			 unsigned long arg)
 {
+	struct subdev_8255_private *spriv;
 	int ret;
 
 	ret = subdev_8255_init(dev, s, cb, arg);
 	if (ret < 0)
 		return ret;
+	spriv = s->private;
+
+	spriv->have_irq = 1;
 
 	s->do_cmdtest = subdev_8255_cmdtest;
 	s->do_cmd = subdev_8255_cmd;
 	s->cancel = subdev_8255_cancel;
 
-	subdevpriv->have_irq = 1;
-
 	return 0;
 }
 EXPORT_SYMBOL(subdev_8255_init_irq);
@@ -412,15 +417,15 @@ static int dev_8255_attach(struct comedi_device *dev,
 
 static void dev_8255_detach(struct comedi_device *dev)
 {
-	int i;
-	unsigned long iobase;
 	struct comedi_subdevice *s;
+	struct subdev_8255_private *spriv;
+	int i;
 
 	for (i = 0; i < dev->n_subdevices; i++) {
 		s = dev->subdevices + i;
 		if (s->type != COMEDI_SUBD_UNUSED) {
-			iobase = CALLBACK_ARG;
-			release_region(iobase, _8255_SIZE);
+			spriv = s->private;
+			release_region(spriv->cb_arg, _8255_SIZE);
 		}
 		subdev_8255_cleanup(dev, s);
 	}
-- 
1.7.7

