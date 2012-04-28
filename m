Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758154Ab2D1ANz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 20:13:55 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:4019 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895Ab2D1ANy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 20:13:54 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-4.tower-160.messagelabs.com!1335572033!4070234!1
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: refactor pcl711 driver to remove the forward declarations
Date: Fri, 27 Apr 2012 17:13:48 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201204271713.49303.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the module_init/module_exit routines and the associated
struct comedi_driver and other variables to the end of the source.
This is more typical of how other drivers are written and removes
the need for the forward declarations.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

diff --git a/drivers/staging/comedi/drivers/pcl711.c b/drivers/staging/comedi/drivers/pcl711.c
index ce6e514..fcb7cea 100644
--- a/drivers/staging/comedi/drivers/pcl711.c
+++ b/drivers/staging/comedi/drivers/pcl711.c
@@ -148,41 +148,8 @@ struct pcl711_board {
 	const struct comedi_lrange *ai_range_type;
 };
 
-static const struct pcl711_board boardtypes[] = {
-	{"pcl711", 0, 0, 0, 5, 8, 1, 0, &range_bipolar5},
-	{"pcl711b", 1, 0, 0, 5, 8, 1, 7, &range_pcl711b_ai},
-	{"acl8112hg", 0, 1, 0, 12, 16, 2, 15, &range_acl8112hg_ai},
-	{"acl8112dg", 0, 1, 1, 9, 16, 2, 15, &range_acl8112dg_ai},
-};
-
 #define this_board ((const struct pcl711_board *)dev->board_ptr)
 
-static int pcl711_attach(struct comedi_device *dev,
-			 struct comedi_devconfig *it);
-static int pcl711_detach(struct comedi_device *dev);
-static struct comedi_driver driver_pcl711 = {
-	.driver_name = "pcl711",
-	.module = THIS_MODULE,
-	.attach = pcl711_attach,
-	.detach = pcl711_detach,
-	.board_name = &boardtypes[0].name,
-	.num_names = ARRAY_SIZE(boardtypes),
-	.offset = sizeof(struct pcl711_board),
-};
-
-static int __init driver_pcl711_init_module(void)
-{
-	return comedi_driver_register(&driver_pcl711);
-}
-
-static void __exit driver_pcl711_cleanup_module(void)
-{
-	comedi_driver_unregister(&driver_pcl711);
-}
-
-module_init(driver_pcl711_init_module);
-module_exit(driver_pcl711_cleanup_module);
-
 struct pcl711_private {
 
 	int board;
@@ -512,21 +479,6 @@ static int pcl711_do_insn_bits(struct comedi_device *dev,
 	return 2;
 }
 
-/*  Free any resources that we have claimed  */
-static int pcl711_detach(struct comedi_device *dev)
-{
-	printk(KERN_INFO "comedi%d: pcl711: remove\n", dev->minor);
-
-	if (dev->irq)
-		free_irq(dev->irq, dev);
-
-	if (dev->iobase)
-		release_region(dev->iobase, PCL711_SIZE);
-
-	return 0;
-}
-
-/*  Initialization */
 static int pcl711_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
 	int ret;
@@ -639,6 +591,48 @@ static int pcl711_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	return 0;
 }
 
+static int pcl711_detach(struct comedi_device *dev)
+{
+	printk(KERN_INFO "comedi%d: pcl711: remove\n", dev->minor);
+
+	if (dev->irq)
+		free_irq(dev->irq, dev);
+
+	if (dev->iobase)
+		release_region(dev->iobase, PCL711_SIZE);
+
+	return 0;
+}
+
+static const struct pcl711_board boardtypes[] = {
+	{ "pcl711", 0, 0, 0, 5, 8, 1, 0, &range_bipolar5 },
+	{ "pcl711b", 1, 0, 0, 5, 8, 1, 7, &range_pcl711b_ai },
+	{ "acl8112hg", 0, 1, 0, 12, 16, 2, 15, &range_acl8112hg_ai },
+	{ "acl8112dg", 0, 1, 1, 9, 16, 2, 15, &range_acl8112dg_ai },
+};
+
+static struct comedi_driver driver_pcl711 = {
+	.driver_name	= "pcl711",
+	.module		= THIS_MODULE,
+	.attach		= pcl711_attach,
+	.detach		= pcl711_detach,
+	.board_name	= &boardtypes[0].name,
+	.num_names	= ARRAY_SIZE(boardtypes),
+	.offset		= sizeof(struct pcl711_board),
+};
+
+static int __init driver_pcl711_init_module(void)
+{
+	return comedi_driver_register(&driver_pcl711);
+}
+module_init(driver_pcl711_init_module);
+
+static void __exit driver_pcl711_cleanup_module(void)
+{
+	comedi_driver_unregister(&driver_pcl711);
+}
+module_exit(driver_pcl711_cleanup_module);
+
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
 MODULE_LICENSE("GPL");
