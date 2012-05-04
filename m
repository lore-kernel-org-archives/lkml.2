Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760413Ab2EDWd3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 18:33:29 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:62178 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755319Ab2EDWd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 18:33:28 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-4.tower-132.messagelabs.com!1336170806!10610820!1
X-Originating-IP: [216.166.12.69]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: refactor mpc624 driver and use module_comedi_driver
Date: Fri, 4 May 2012 15:33:17 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205041533.17755.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the struct comedi_driver and associated attach/detach
routines to the end of the source. This is more typical of how
other drivers are written and removes the need for the forward
declarations.

Convert the driver to use the module_comedi_driver() macro which
makes the code smaller and a bit simpler.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

diff --git a/drivers/staging/comedi/drivers/mpc624.c b/drivers/staging/comedi/drivers/mpc624.c
index dd09a6d..25d8553 100644
--- a/drivers/staging/comedi/drivers/mpc624.c
+++ b/drivers/staging/comedi/drivers/mpc624.c
@@ -148,131 +148,6 @@ static const struct comedi_lrange range_mpc624_bipolar10 = {
 	 }
 };
 
-/* -------------------------------------------------------------------------- */
-static int mpc624_attach(struct comedi_device *dev,
-			 struct comedi_devconfig *it);
-static int mpc624_detach(struct comedi_device *dev);
-/* -------------------------------------------------------------------------- */
-static struct comedi_driver driver_mpc624 = {
-	.driver_name = "mpc624",
-	.module = THIS_MODULE,
-	.attach = mpc624_attach,
-	.detach = mpc624_detach
-};
-
-/* -------------------------------------------------------------------------- */
-static int mpc624_ai_rinsn(struct comedi_device *dev,
-			   struct comedi_subdevice *s, struct comedi_insn *insn,
-			   unsigned int *data);
-/* -------------------------------------------------------------------------- */
-static int mpc624_attach(struct comedi_device *dev, struct comedi_devconfig *it)
-{
-	struct comedi_subdevice *s;
-	unsigned long iobase;
-
-	iobase = it->options[0];
-	printk(KERN_INFO "comedi%d: mpc624 [0x%04lx, ", dev->minor, iobase);
-	if (request_region(iobase, MPC624_SIZE, "mpc624") == NULL) {
-		printk(KERN_ERR "I/O port(s) in use\n");
-		return -EIO;
-	}
-
-	dev->iobase = iobase;
-	dev->board_name = "mpc624";
-
-	/*  Private structure initialization */
-	if (alloc_private(dev, sizeof(struct skel_private)) < 0)
-		return -ENOMEM;
-
-	switch (it->options[1]) {
-	case 0:
-		devpriv->ulConvertionRate = MPC624_SPEED_3_52_kHz;
-		printk(KERN_INFO "3.52 kHz, ");
-		break;
-	case 1:
-		devpriv->ulConvertionRate = MPC624_SPEED_1_76_kHz;
-		printk(KERN_INFO "1.76 kHz, ");
-		break;
-	case 2:
-		devpriv->ulConvertionRate = MPC624_SPEED_880_Hz;
-		printk(KERN_INFO "880 Hz, ");
-		break;
-	case 3:
-		devpriv->ulConvertionRate = MPC624_SPEED_440_Hz;
-		printk(KERN_INFO "440 Hz, ");
-		break;
-	case 4:
-		devpriv->ulConvertionRate = MPC624_SPEED_220_Hz;
-		printk(KERN_INFO "220 Hz, ");
-		break;
-	case 5:
-		devpriv->ulConvertionRate = MPC624_SPEED_110_Hz;
-		printk(KERN_INFO "110 Hz, ");
-		break;
-	case 6:
-		devpriv->ulConvertionRate = MPC624_SPEED_55_Hz;
-		printk(KERN_INFO "55 Hz, ");
-		break;
-	case 7:
-		devpriv->ulConvertionRate = MPC624_SPEED_27_5_Hz;
-		printk(KERN_INFO "27.5 Hz, ");
-		break;
-	case 8:
-		devpriv->ulConvertionRate = MPC624_SPEED_13_75_Hz;
-		printk(KERN_INFO "13.75 Hz, ");
-		break;
-	case 9:
-		devpriv->ulConvertionRate = MPC624_SPEED_6_875_Hz;
-		printk(KERN_INFO "6.875 Hz, ");
-		break;
-	default:
-		printk
-		    (KERN_ERR "illegal conversion rate setting!"
-			" Valid numbers are 0..9. Using 9 => 6.875 Hz, ");
-		devpriv->ulConvertionRate = MPC624_SPEED_3_52_kHz;
-	}
-
-	/*  Subdevices structures */
-	if (alloc_subdevices(dev, 1) < 0)
-		return -ENOMEM;
-
-	s = dev->subdevices + 0;
-	s->type = COMEDI_SUBD_AI;
-	s->subdev_flags = SDF_READABLE | SDF_DIFF;
-	s->n_chan = 8;
-	switch (it->options[1]) {
-	default:
-		s->maxdata = 0x3FFFFFFF;
-		printk(KERN_INFO "30 bit, ");
-	}
-
-	switch (it->options[1]) {
-	case 0:
-		s->range_table = &range_mpc624_bipolar1;
-		printk(KERN_INFO "1.01V]: ");
-		break;
-	default:
-		s->range_table = &range_mpc624_bipolar10;
-		printk(KERN_INFO "10.1V]: ");
-	}
-	s->len_chanlist = 1;
-	s->insn_read = mpc624_ai_rinsn;
-
-	printk(KERN_INFO "attached\n");
-
-	return 1;
-}
-
-static int mpc624_detach(struct comedi_device *dev)
-{
-	printk(KERN_INFO "comedi%d: mpc624: remove\n", dev->minor);
-
-	if (dev->iobase)
-		release_region(dev->iobase, MPC624_SIZE);
-
-	return 0;
-}
-
 /* Timeout 200ms */
 #define TIMEOUT 200
 
@@ -406,18 +281,121 @@ static int mpc624_ai_rinsn(struct comedi_device *dev,
 	return n;
 }
 
-static int __init driver_mpc624_init_module(void)
+static int mpc624_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
-	return comedi_driver_register(&driver_mpc624);
+	struct comedi_subdevice *s;
+	unsigned long iobase;
+
+	iobase = it->options[0];
+	printk(KERN_INFO "comedi%d: mpc624 [0x%04lx, ", dev->minor, iobase);
+	if (request_region(iobase, MPC624_SIZE, "mpc624") == NULL) {
+		printk(KERN_ERR "I/O port(s) in use\n");
+		return -EIO;
+	}
+
+	dev->iobase = iobase;
+	dev->board_name = "mpc624";
+
+	/*  Private structure initialization */
+	if (alloc_private(dev, sizeof(struct skel_private)) < 0)
+		return -ENOMEM;
+
+	switch (it->options[1]) {
+	case 0:
+		devpriv->ulConvertionRate = MPC624_SPEED_3_52_kHz;
+		printk(KERN_INFO "3.52 kHz, ");
+		break;
+	case 1:
+		devpriv->ulConvertionRate = MPC624_SPEED_1_76_kHz;
+		printk(KERN_INFO "1.76 kHz, ");
+		break;
+	case 2:
+		devpriv->ulConvertionRate = MPC624_SPEED_880_Hz;
+		printk(KERN_INFO "880 Hz, ");
+		break;
+	case 3:
+		devpriv->ulConvertionRate = MPC624_SPEED_440_Hz;
+		printk(KERN_INFO "440 Hz, ");
+		break;
+	case 4:
+		devpriv->ulConvertionRate = MPC624_SPEED_220_Hz;
+		printk(KERN_INFO "220 Hz, ");
+		break;
+	case 5:
+		devpriv->ulConvertionRate = MPC624_SPEED_110_Hz;
+		printk(KERN_INFO "110 Hz, ");
+		break;
+	case 6:
+		devpriv->ulConvertionRate = MPC624_SPEED_55_Hz;
+		printk(KERN_INFO "55 Hz, ");
+		break;
+	case 7:
+		devpriv->ulConvertionRate = MPC624_SPEED_27_5_Hz;
+		printk(KERN_INFO "27.5 Hz, ");
+		break;
+	case 8:
+		devpriv->ulConvertionRate = MPC624_SPEED_13_75_Hz;
+		printk(KERN_INFO "13.75 Hz, ");
+		break;
+	case 9:
+		devpriv->ulConvertionRate = MPC624_SPEED_6_875_Hz;
+		printk(KERN_INFO "6.875 Hz, ");
+		break;
+	default:
+		printk
+		    (KERN_ERR "illegal conversion rate setting!"
+			" Valid numbers are 0..9. Using 9 => 6.875 Hz, ");
+		devpriv->ulConvertionRate = MPC624_SPEED_3_52_kHz;
+	}
+
+	/*  Subdevices structures */
+	if (alloc_subdevices(dev, 1) < 0)
+		return -ENOMEM;
+
+	s = dev->subdevices + 0;
+	s->type = COMEDI_SUBD_AI;
+	s->subdev_flags = SDF_READABLE | SDF_DIFF;
+	s->n_chan = 8;
+	switch (it->options[1]) {
+	default:
+		s->maxdata = 0x3FFFFFFF;
+		printk(KERN_INFO "30 bit, ");
+	}
+
+	switch (it->options[1]) {
+	case 0:
+		s->range_table = &range_mpc624_bipolar1;
+		printk(KERN_INFO "1.01V]: ");
+		break;
+	default:
+		s->range_table = &range_mpc624_bipolar10;
+		printk(KERN_INFO "10.1V]: ");
+	}
+	s->len_chanlist = 1;
+	s->insn_read = mpc624_ai_rinsn;
+
+	printk(KERN_INFO "attached\n");
+
+	return 1;
 }
 
-static void __exit driver_mpc624_cleanup_module(void)
+static int mpc624_detach(struct comedi_device *dev)
 {
-	comedi_driver_unregister(&driver_mpc624);
+	printk(KERN_INFO "comedi%d: mpc624: remove\n", dev->minor);
+
+	if (dev->iobase)
+		release_region(dev->iobase, MPC624_SIZE);
+
+	return 0;
 }
 
-module_init(driver_mpc624_init_module);
-module_exit(driver_mpc624_cleanup_module);
+static struct comedi_driver mpc624_driver = {
+	.driver_name	= "mpc624",
+	.module		= THIS_MODULE,
+	.attach		= mpc624_attach,
+	.detach		= mpc624_detach
+};
+module_comedi_driver(mpc624_driver);
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
