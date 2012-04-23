Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167Ab2DWQrJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 12:47:09 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:21456 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900Ab2DWQrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 12:47:07 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-209.messagelabs.com!1335199611!3890515!22
X-Originating-IP: [216.166.12.72]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: refactor 8255 driver to remove forward declarations
Date: Mon, 23 Apr 2012 09:38:24 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201204230938.25701.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the module_init/module_exit routines and the associated
struct comedi_driver variable to the end of the source. This is
more typical of how other drivers are written and removes the
need for the forward declarations.

Also, move the do_config function to remove needing to have
a forward declaration for that routine.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

diff --git a/drivers/staging/comedi/drivers/8255.c b/drivers/staging/comedi/drivers/8255.c
index 6c26ac8..ed80397 100644
--- a/drivers/staging/comedi/drivers/8255.c
+++ b/drivers/staging/comedi/drivers/8255.c
@@ -107,31 +107,6 @@ struct subdev_8255_struct {
 #define CALLBACK_FUNC	(((struct subdev_8255_struct *)s->private)->cb_func)
 #define subdevpriv	((struct subdev_8255_struct *)s->private)
 
-static int dev_8255_attach(struct comedi_device *dev,
-			   struct comedi_devconfig *it);
-static int dev_8255_detach(struct comedi_device *dev);
-static struct comedi_driver driver_8255 = {
-	.driver_name = "8255",
-	.module = THIS_MODULE,
-	.attach = dev_8255_attach,
-	.detach = dev_8255_detach,
-};
-
-static int __init driver_8255_init_module(void)
-{
-	return comedi_driver_register(&driver_8255);
-}
-
-static void __exit driver_8255_cleanup_module(void)
-{
-	comedi_driver_unregister(&driver_8255);
-}
-
-module_init(driver_8255_init_module);
-module_exit(driver_8255_cleanup_module);
-
-static void do_config(struct comedi_device *dev, struct comedi_subdevice *s);
-
 void subdev_8255_interrupt(struct comedi_device *dev,
 			   struct comedi_subdevice *s)
 {
@@ -185,6 +160,23 @@ static int subdev_8255_insn(struct comedi_device *dev,
 	return 2;
 }
 
+static void do_config(struct comedi_device *dev, struct comedi_subdevice *s)
+{
+	int config;
+
+	config = CR_CW;
+	/* 1 in io_bits indicates output, 1 in config indicates input */
+	if (!(s->io_bits & 0x0000ff))
+		config |= CR_A_IO;
+	if (!(s->io_bits & 0x00ff00))
+		config |= CR_B_IO;
+	if (!(s->io_bits & 0x0f0000))
+		config |= CR_C_LO_IO;
+	if (!(s->io_bits & 0xf00000))
+		config |= CR_C_HI_IO;
+	CALLBACK_FUNC(1, _8255_CR, config, CALLBACK_ARG);
+}
+
 static int subdev_8255_insn_config(struct comedi_device *dev,
 				   struct comedi_subdevice *s,
 				   struct comedi_insn *insn, unsigned int *data)
@@ -222,23 +214,6 @@ static int subdev_8255_insn_config(struct comedi_device *dev,
 	return 1;
 }
 
-static void do_config(struct comedi_device *dev, struct comedi_subdevice *s)
-{
-	int config;
-
-	config = CR_CW;
-	/* 1 in io_bits indicates output, 1 in config indicates input */
-	if (!(s->io_bits & 0x0000ff))
-		config |= CR_A_IO;
-	if (!(s->io_bits & 0x00ff00))
-		config |= CR_B_IO;
-	if (!(s->io_bits & 0x0f0000))
-		config |= CR_C_LO_IO;
-	if (!(s->io_bits & 0xf00000))
-		config |= CR_C_HI_IO;
-	CALLBACK_FUNC(1, _8255_CR, config, CALLBACK_ARG);
-}
-
 static int subdev_8255_cmdtest(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
 			       struct comedi_cmd *cmd)
@@ -462,6 +437,25 @@ static int dev_8255_detach(struct comedi_device *dev)
 	return 0;
 }
 
+static struct comedi_driver driver_8255 = {
+	.driver_name	= "8255",
+	.module		= THIS_MODULE,
+	.attach		= dev_8255_attach,
+	.detach		= dev_8255_detach,
+};
+
+static int __init driver_8255_init_module(void)
+{
+	return comedi_driver_register(&driver_8255);
+}
+module_init(driver_8255_init_module);
+
+static void __exit driver_8255_cleanup_module(void)
+{
+	comedi_driver_unregister(&driver_8255);
+}
+module_exit(driver_8255_cleanup_module);
+
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
 MODULE_LICENSE("GPL");
