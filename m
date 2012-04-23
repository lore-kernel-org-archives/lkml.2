Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737Ab2DWXNz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 19:13:55 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:20044 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753996Ab2DWXNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 19:13:54 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-127.messagelabs.com!1335222829!3820725!9
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: refactor aio_iiro_16 driver to remove forward declarations
Date: Mon, 23 Apr 2012 16:13:43 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201204231613.43681.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the struct comedi_driver variable and the associated
attach/detach routines to remove the need for the forward
declarations.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

diff --git a/drivers/staging/comedi/drivers/aio_iiro_16.c b/drivers/staging/comedi/drivers/aio_iiro_16.c
index 160b0a0..763461a 100644
--- a/drivers/staging/comedi/drivers/aio_iiro_16.c
+++ b/drivers/staging/comedi/drivers/aio_iiro_16.c
@@ -67,30 +67,41 @@ struct aio_iiro_16_private {
 
 #define	devpriv	((struct aio_iiro_16_private *) dev->private)
 
-static int aio_iiro_16_attach(struct comedi_device *dev,
-			      struct comedi_devconfig *it);
+static int aio_iiro_16_dio_insn_bits_write(struct comedi_device *dev,
+					   struct comedi_subdevice *s,
+					   struct comedi_insn *insn,
+					   unsigned int *data)
+{
+	if (insn->n != 2)
+		return -EINVAL;
 
-static int aio_iiro_16_detach(struct comedi_device *dev);
+	if (data[0]) {
+		s->state &= ~data[0];
+		s->state |= data[0] & data[1];
+		outb(s->state & 0xff, dev->iobase + AIO_IIRO_16_RELAY_0_7);
+		outb((s->state >> 8) & 0xff,
+		     dev->iobase + AIO_IIRO_16_RELAY_8_15);
+	}
 
-static struct comedi_driver driver_aio_iiro_16 = {
-	.driver_name = "aio_iiro_16",
-	.module = THIS_MODULE,
-	.attach = aio_iiro_16_attach,
-	.detach = aio_iiro_16_detach,
-	.board_name = &aio_iiro_16_boards[0].name,
-	.offset = sizeof(struct aio_iiro_16_board),
-	.num_names = ARRAY_SIZE(aio_iiro_16_boards),
-};
+	data[1] = s->state;
+
+	return 2;
+}
 
 static int aio_iiro_16_dio_insn_bits_read(struct comedi_device *dev,
 					  struct comedi_subdevice *s,
 					  struct comedi_insn *insn,
-					  unsigned int *data);
+					  unsigned int *data)
+{
+	if (insn->n != 2)
+		return -EINVAL;
 
-static int aio_iiro_16_dio_insn_bits_write(struct comedi_device *dev,
-					   struct comedi_subdevice *s,
-					   struct comedi_insn *insn,
-					   unsigned int *data);
+	data[1] = 0;
+	data[1] |= inb(dev->iobase + AIO_IIRO_16_INPUT_0_7);
+	data[1] |= inb(dev->iobase + AIO_IIRO_16_INPUT_8_15) << 8;
+
+	return 2;
+}
 
 static int aio_iiro_16_attach(struct comedi_device *dev,
 			      struct comedi_devconfig *it)
@@ -148,53 +159,26 @@ static int aio_iiro_16_detach(struct comedi_device *dev)
 	return 0;
 }
 
-static int aio_iiro_16_dio_insn_bits_write(struct comedi_device *dev,
-					   struct comedi_subdevice *s,
-					   struct comedi_insn *insn,
-					   unsigned int *data)
-{
-	if (insn->n != 2)
-		return -EINVAL;
-
-	if (data[0]) {
-		s->state &= ~data[0];
-		s->state |= data[0] & data[1];
-		outb(s->state & 0xff, dev->iobase + AIO_IIRO_16_RELAY_0_7);
-		outb((s->state >> 8) & 0xff,
-		     dev->iobase + AIO_IIRO_16_RELAY_8_15);
-	}
-
-	data[1] = s->state;
-
-	return 2;
-}
-
-static int aio_iiro_16_dio_insn_bits_read(struct comedi_device *dev,
-					  struct comedi_subdevice *s,
-					  struct comedi_insn *insn,
-					  unsigned int *data)
-{
-	if (insn->n != 2)
-		return -EINVAL;
-
-	data[1] = 0;
-	data[1] |= inb(dev->iobase + AIO_IIRO_16_INPUT_0_7);
-	data[1] |= inb(dev->iobase + AIO_IIRO_16_INPUT_8_15) << 8;
-
-	return 2;
-}
+static struct comedi_driver driver_aio_iiro_16 = {
+	.driver_name	= "aio_iiro_16",
+	.module		= THIS_MODULE,
+	.attach		= aio_iiro_16_attach,
+	.detach		= aio_iiro_16_detach,
+	.board_name	= &aio_iiro_16_boards[0].name,
+	.offset		= sizeof(struct aio_iiro_16_board),
+	.num_names	= ARRAY_SIZE(aio_iiro_16_boards),
+};
 
 static int __init driver_aio_iiro_16_init_module(void)
 {
 	return comedi_driver_register(&driver_aio_iiro_16);
 }
+module_init(driver_aio_iiro_16_init_module);
 
 static void __exit driver_aio_iiro_16_cleanup_module(void)
 {
 	comedi_driver_unregister(&driver_aio_iiro_16);
 }
-
-module_init(driver_aio_iiro_16_init_module);
 module_exit(driver_aio_iiro_16_cleanup_module);
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
