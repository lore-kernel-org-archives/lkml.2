Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759354Ab2EDSvN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 14:51:13 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:22445 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407Ab2EDSvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 14:51:12 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-13.tower-131.messagelabs.com!1336157468!10637536!5
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: refactor unioxx5 driver and use module_comedi_driver
Date: Fri, 4 May 2012 11:50:57 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205041150.58016.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the module_init/module_exit routines and the associated
struct comedi_drive to the end of the source. This is more typical
of how other drivers are written and removes the need for the
forward declarations.

Convert the driver to use the module_comedi_driver() macro which
makes the code smaller and a bit simpler.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

diff --git a/drivers/staging/comedi/drivers/unioxx5.c b/drivers/staging/comedi/drivers/unioxx5.c
index f45824f..0eaca68 100644
--- a/drivers/staging/comedi/drivers/unioxx5.c
+++ b/drivers/staging/comedi/drivers/unioxx5.c
@@ -83,8 +83,6 @@ struct unioxx5_subd_priv {
 	unsigned char usp_prev_cn_val[3];	/* previous channel value */
 };
 
-static int unioxx5_attach(struct comedi_device *dev,
-			  struct comedi_devconfig *it);
 static int unioxx5_subdev_write(struct comedi_device *dev,
 				struct comedi_subdevice *subdev,
 				struct comedi_insn *insn, unsigned int *data);
@@ -94,9 +92,6 @@ static int unioxx5_subdev_read(struct comedi_device *dev,
 static int unioxx5_insn_config(struct comedi_device *dev,
 			       struct comedi_subdevice *subdev,
 			       struct comedi_insn *insn, unsigned int *data);
-static int unioxx5_detach(struct comedi_device *dev);
-static int __unioxx5_subdev_init(struct comedi_subdevice *subdev,
-				 int subdev_iobase, int minor);
 static int __unioxx5_digital_write(struct unioxx5_subd_priv *usp,
 				   unsigned int *data, int channel, int minor);
 static int __unioxx5_digital_read(struct unioxx5_subd_priv *usp,
@@ -109,72 +104,6 @@ static int __unioxx5_analog_read(struct unioxx5_subd_priv *usp,
 static int __unioxx5_define_chan_offset(int chan_num);
 static void __unioxx5_analog_config(struct unioxx5_subd_priv *usp, int channel);
 
-static struct comedi_driver unioxx5_driver = {
-	.driver_name = DRIVER_NAME,
-	.module = THIS_MODULE,
-	.attach = unioxx5_attach,
-	.detach = unioxx5_detach
-};
-
-static int __init unioxx5_driver_init_module(void)
-{
-	return comedi_driver_register(&unioxx5_driver);
-}
-
-static void __exit unioxx5_driver_cleanup_module(void)
-{
-	comedi_driver_unregister(&unioxx5_driver);
-}
-
-module_init(unioxx5_driver_init_module);
-module_exit(unioxx5_driver_cleanup_module);
-
-static int unioxx5_attach(struct comedi_device *dev,
-			  struct comedi_devconfig *it)
-{
-	int iobase, i, n_subd;
-	int id, num, ba;
-
-	iobase = it->options[0];
-
-	dev->board_name = DRIVER_NAME;
-	dev->iobase = iobase;
-	iobase += UNIOXX5_SUBDEV_BASE;
-
-	/* defining number of subdevices and getting they types (it must be 'g01')  */
-	for (i = n_subd = 0, ba = iobase; i < 4; i++, ba += UNIOXX5_SUBDEV_ODDS) {
-		id = inb(ba + 0xE);
-		num = inb(ba + 0xF);
-
-		if (id != 'g' || num != 1)
-			continue;
-
-		n_subd++;
-	}
-
-	/* unioxx5 can has from two to four subdevices */
-	if (n_subd < 2) {
-		printk(KERN_ERR
-		       "your card must has at least 2 'g01' subdevices\n");
-		return -1;
-	}
-
-	if (alloc_subdevices(dev, n_subd) < 0) {
-		printk(KERN_ERR "out of memory\n");
-		return -ENOMEM;
-	}
-
-	/* initializing each of for same subdevices */
-	for (i = 0; i < n_subd; i++, iobase += UNIOXX5_SUBDEV_ODDS) {
-		if (__unioxx5_subdev_init(&dev->subdevices[i], iobase,
-					  dev->minor) < 0)
-			return -1;
-	}
-
-	printk(KERN_INFO "attached\n");
-	return 0;
-}
-
 static int unioxx5_subdev_read(struct comedi_device *dev,
 			       struct comedi_subdevice *subdev,
 			       struct comedi_insn *insn, unsigned int *data)
@@ -275,22 +204,6 @@ static int unioxx5_insn_config(struct comedi_device *dev,
 	return 0;
 }
 
-static int unioxx5_detach(struct comedi_device *dev)
-{
-	int i;
-	struct comedi_subdevice *subdev;
-	struct unioxx5_subd_priv *usp;
-
-	for (i = 0; i < dev->n_subdevices; i++) {
-		subdev = &dev->subdevices[i];
-		usp = subdev->private;
-		release_region(usp->usp_iobase, UNIOXX5_SIZE);
-		kfree(subdev->private);
-	}
-
-	return 0;
-}
-
 /* initializing subdevice with given address */
 static int __unioxx5_subdev_init(struct comedi_subdevice *subdev,
 				 int subdev_iobase, int minor)
@@ -553,6 +466,76 @@ static int __unioxx5_define_chan_offset(int chan_num)
 	return (chan_num >> 3) + 1;
 }
 
+static int unioxx5_attach(struct comedi_device *dev,
+			  struct comedi_devconfig *it)
+{
+	int iobase, i, n_subd;
+	int id, num, ba;
+
+	iobase = it->options[0];
+
+	dev->board_name = DRIVER_NAME;
+	dev->iobase = iobase;
+	iobase += UNIOXX5_SUBDEV_BASE;
+
+	/* defining number of subdevices and getting they types (it must be 'g01')  */
+	for (i = n_subd = 0, ba = iobase; i < 4; i++, ba += UNIOXX5_SUBDEV_ODDS) {
+		id = inb(ba + 0xE);
+		num = inb(ba + 0xF);
+
+		if (id != 'g' || num != 1)
+			continue;
+
+		n_subd++;
+	}
+
+	/* unioxx5 can has from two to four subdevices */
+	if (n_subd < 2) {
+		printk(KERN_ERR
+		       "your card must has at least 2 'g01' subdevices\n");
+		return -1;
+	}
+
+	if (alloc_subdevices(dev, n_subd) < 0) {
+		printk(KERN_ERR "out of memory\n");
+		return -ENOMEM;
+	}
+
+	/* initializing each of for same subdevices */
+	for (i = 0; i < n_subd; i++, iobase += UNIOXX5_SUBDEV_ODDS) {
+		if (__unioxx5_subdev_init(&dev->subdevices[i], iobase,
+					  dev->minor) < 0)
+			return -1;
+	}
+
+	printk(KERN_INFO "attached\n");
+	return 0;
+}
+
+static int unioxx5_detach(struct comedi_device *dev)
+{
+	int i;
+	struct comedi_subdevice *subdev;
+	struct unioxx5_subd_priv *usp;
+
+	for (i = 0; i < dev->n_subdevices; i++) {
+		subdev = &dev->subdevices[i];
+		usp = subdev->private;
+		release_region(usp->usp_iobase, UNIOXX5_SIZE);
+		kfree(subdev->private);
+	}
+
+	return 0;
+}
+
+static struct comedi_driver unioxx5_driver = {
+	.driver_name	= DRIVER_NAME,
+	.module		= THIS_MODULE,
+	.attach		= unioxx5_attach,
+	.detach		= unioxx5_detach,
+};
+module_comedi_driver(unioxx5_driver);
+
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
 MODULE_LICENSE("GPL");
