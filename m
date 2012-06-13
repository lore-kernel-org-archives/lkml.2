Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755039Ab2FMWmG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 18:42:06 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:38010 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688Ab2FMWmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 18:42:04 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-9.tower-209.messagelabs.com!1339627322!8436509!4
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 05/15] staging: comedi: 8255: rename cb_arg and cb_func
Date: Wed, 13 Jun 2012 15:41:54 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206131541.54863.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 8255's private data variables cb_arg and cb_func are actually
the iobase for the 8255 device and the pointer to the io function
to access the device. Rename them as such to improve the readability
of the driver.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/8255.c |   36 ++++++++++++++++----------------
 1 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/comedi/drivers/8255.c b/drivers/staging/comedi/drivers/8255.c
index 5e0e8ff..7b7768b 100644
--- a/drivers/staging/comedi/drivers/8255.c
+++ b/drivers/staging/comedi/drivers/8255.c
@@ -98,8 +98,8 @@ I/O port base address can be found in the output of 'lspci -v'.
 #define CR_CW		0x80
 
 struct subdev_8255_private {
-	unsigned long cb_arg;
-	int (*cb_func) (int, int, int, unsigned long);
+	unsigned long iobase;
+	int (*io) (int, int, int, unsigned long);
 	int have_irq;
 };
 
@@ -109,8 +109,8 @@ void subdev_8255_interrupt(struct comedi_device *dev,
 	struct subdev_8255_private *spriv = s->private;
 	short d;
 
-	d = spriv->cb_func(0, _8255_DATA, 0, spriv->cb_arg);
-	d |= (spriv->cb_func(0, _8255_DATA + 1, 0, spriv->cb_arg) << 8);
+	d = spriv->io(0, _8255_DATA, 0, spriv->iobase);
+	d |= (spriv->io(0, _8255_DATA + 1, 0, spriv->iobase) << 8);
 
 	comedi_buf_put(s->async, d);
 	s->async->events |= COMEDI_CB_EOS;
@@ -142,19 +142,19 @@ static int subdev_8255_insn(struct comedi_device *dev,
 		s->state |= (data[0] & data[1]);
 
 		if (data[0] & 0xff)
-			spriv->cb_func(1, _8255_DATA, s->state & 0xff,
-				       spriv->cb_arg);
+			spriv->io(1, _8255_DATA, s->state & 0xff,
+				  spriv->iobase);
 		if (data[0] & 0xff00)
-			spriv->cb_func(1, _8255_DATA + 1,
-				       (s->state >> 8) & 0xff, spriv->cb_arg);
+			spriv->io(1, _8255_DATA + 1,
+				  (s->state >> 8) & 0xff, spriv->iobase);
 		if (data[0] & 0xff0000)
-			spriv->cb_func(1, _8255_DATA + 2,
-				       (s->state >> 16) & 0xff, spriv->cb_arg);
+			spriv->io(1, _8255_DATA + 2,
+				  (s->state >> 16) & 0xff, spriv->iobase);
 	}
 
-	data[1] = spriv->cb_func(0, _8255_DATA, 0, spriv->cb_arg);
-	data[1] |= (spriv->cb_func(0, _8255_DATA + 1, 0, spriv->cb_arg) << 8);
-	data[1] |= (spriv->cb_func(0, _8255_DATA + 2, 0, spriv->cb_arg) << 16);
+	data[1] = spriv->io(0, _8255_DATA, 0, spriv->iobase);
+	data[1] |= (spriv->io(0, _8255_DATA + 1, 0, spriv->iobase) << 8);
+	data[1] |= (spriv->io(0, _8255_DATA + 2, 0, spriv->iobase) << 16);
 
 	return 2;
 }
@@ -174,7 +174,7 @@ static void do_config(struct comedi_device *dev, struct comedi_subdevice *s)
 		config |= CR_C_LO_IO;
 	if (!(s->io_bits & 0xf00000))
 		config |= CR_C_HI_IO;
-	spriv->cb_func(1, _8255_CR, config, spriv->cb_arg);
+	spriv->io(1, _8255_CR, config, spriv->iobase);
 }
 
 static int subdev_8255_insn_config(struct comedi_device *dev,
@@ -323,11 +323,11 @@ int subdev_8255_init(struct comedi_device *dev, struct comedi_subdevice *s,
 		return -ENOMEM;
 	s->private = spriv;
 
-	spriv->cb_arg = arg;
+	spriv->iobase = arg;
 	if (cb == NULL)
-		spriv->cb_func = subdev_8255_cb;
+		spriv->io = subdev_8255_cb;
 	else
-		spriv->cb_func = cb;
+		spriv->io = cb;
 	s->insn_bits = subdev_8255_insn;
 	s->insn_config = subdev_8255_insn_config;
 
@@ -425,7 +425,7 @@ static void dev_8255_detach(struct comedi_device *dev)
 		s = dev->subdevices + i;
 		if (s->type != COMEDI_SUBD_UNUSED) {
 			spriv = s->private;
-			release_region(spriv->cb_arg, _8255_SIZE);
+			release_region(spriv->iobase, _8255_SIZE);
 		}
 		subdev_8255_cleanup(dev, s);
 	}
-- 
1.7.7

