Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760007Ab2EDW0x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 18:26:53 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:29160 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755445Ab2EDW0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 18:26:52 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-5.tower-209.messagelabs.com!1336170410!4818738!1
X-Originating-IP: [216.166.12.72]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: refactor mpc8260cpm driver and use module_comedi_driver
Date: Fri, 4 May 2012 15:26:44 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205041526.45033.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the module_init/module_exit routines and the associated
struct comedi_driver and other variables to the end of the source.
This is more typical of how other drivers are written and removes
the need for the forward declarations.

Convert the driver to use the module_comedi_driver() macro which
makes the code smaller and a bit simpler.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

diff --git a/drivers/staging/comedi/drivers/mpc8260cpm.c b/drivers/staging/comedi/drivers/mpc8260cpm.c
index 5f6816a..f468775 100644
--- a/drivers/staging/comedi/drivers/mpc8260cpm.c
+++ b/drivers/staging/comedi/drivers/mpc8260cpm.c
@@ -46,75 +46,6 @@ struct mpc8260cpm_private {
 
 #define devpriv ((struct mpc8260cpm_private *)dev->private)
 
-static int mpc8260cpm_attach(struct comedi_device *dev,
-			     struct comedi_devconfig *it);
-static int mpc8260cpm_detach(struct comedi_device *dev);
-static struct comedi_driver driver_mpc8260cpm = {
-	.driver_name = "mpc8260cpm",
-	.module = THIS_MODULE,
-	.attach = mpc8260cpm_attach,
-	.detach = mpc8260cpm_detach,
-};
-
-static int __init driver_mpc8260cpm_init_module(void)
-{
-	return comedi_driver_register(&driver_mpc8260cpm);
-}
-
-static void __exit driver_mpc8260cpm_cleanup_module(void)
-{
-	comedi_driver_unregister(&driver_mpc8260cpm);
-}
-
-module_init(driver_mpc8260cpm_init_module);
-module_exit(driver_mpc8260cpm_cleanup_module);
-
-static int mpc8260cpm_dio_config(struct comedi_device *dev,
-				 struct comedi_subdevice *s,
-				 struct comedi_insn *insn, unsigned int *data);
-static int mpc8260cpm_dio_bits(struct comedi_device *dev,
-			       struct comedi_subdevice *s,
-			       struct comedi_insn *insn, unsigned int *data);
-
-static int mpc8260cpm_attach(struct comedi_device *dev,
-			     struct comedi_devconfig *it)
-{
-	struct comedi_subdevice *s;
-	int i;
-
-	printk("comedi%d: mpc8260cpm: ", dev->minor);
-
-	dev->board_ptr = mpc8260cpm_boards + dev->board;
-
-	dev->board_name = thisboard->name;
-
-	if (alloc_private(dev, sizeof(struct mpc8260cpm_private)) < 0)
-		return -ENOMEM;
-
-	if (alloc_subdevices(dev, 4) < 0)
-		return -ENOMEM;
-
-	for (i = 0; i < 4; i++) {
-		s = dev->subdevices + i;
-		s->type = COMEDI_SUBD_DIO;
-		s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
-		s->n_chan = 32;
-		s->maxdata = 1;
-		s->range_table = &range_digital;
-		s->insn_config = mpc8260cpm_dio_config;
-		s->insn_bits = mpc8260cpm_dio_bits;
-	}
-
-	return 1;
-}
-
-static int mpc8260cpm_detach(struct comedi_device *dev)
-{
-	printk("comedi%d: mpc8260cpm: remove\n", dev->minor);
-
-	return 0;
-}
-
 static unsigned long *cpm_pdat(int port)
 {
 	switch (port) {
@@ -184,3 +115,50 @@ static int mpc8260cpm_dio_bits(struct comedi_device *dev,
 
 	return 2;
 }
+
+static int mpc8260cpm_attach(struct comedi_device *dev,
+			     struct comedi_devconfig *it)
+{
+	struct comedi_subdevice *s;
+	int i;
+
+	printk("comedi%d: mpc8260cpm: ", dev->minor);
+
+	dev->board_ptr = mpc8260cpm_boards + dev->board;
+
+	dev->board_name = thisboard->name;
+
+	if (alloc_private(dev, sizeof(struct mpc8260cpm_private)) < 0)
+		return -ENOMEM;
+
+	if (alloc_subdevices(dev, 4) < 0)
+		return -ENOMEM;
+
+	for (i = 0; i < 4; i++) {
+		s = dev->subdevices + i;
+		s->type = COMEDI_SUBD_DIO;
+		s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
+		s->n_chan = 32;
+		s->maxdata = 1;
+		s->range_table = &range_digital;
+		s->insn_config = mpc8260cpm_dio_config;
+		s->insn_bits = mpc8260cpm_dio_bits;
+	}
+
+	return 1;
+}
+
+static int mpc8260cpm_detach(struct comedi_device *dev)
+{
+	printk("comedi%d: mpc8260cpm: remove\n", dev->minor);
+
+	return 0;
+}
+
+static struct comedi_driver mpc8260cpm_driver = {
+	.driver_name	= "mpc8260cpm",
+	.module		= THIS_MODULE,
+	.attach		= mpc8260cpm_attach,
+	.detach		= mpc8260cpm_detach,
+};
+module_comedi_driver(mpc8260cpm_driver);
