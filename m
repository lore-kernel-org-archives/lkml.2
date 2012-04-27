Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757066Ab2D0XJr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 19:09:47 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:9807 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756991Ab2D0XJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 19:09:46 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-2.tower-160.messagelabs.com!1335568142!4978430!14
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: refactor pcl818 driver to remove forward declarations
Date: Fri, 27 Apr 2012 16:09:11 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201204271609.12161.hartleys@visionengravers.com>
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

There are still some forward declarations in this file but fixing them
in this patch makes in to messy for review.

diff --git a/drivers/staging/comedi/drivers/pcl818.c b/drivers/staging/comedi/drivers/pcl818.c
index 0272491..8dbefc5 100644
--- a/drivers/staging/comedi/drivers/pcl818.c
+++ b/drivers/staging/comedi/drivers/pcl818.c
@@ -247,10 +247,6 @@ static const struct comedi_lrange range718_bipolar0_5 =
 static const struct comedi_lrange range718_unipolar2 = { 1, {UNI_RANGE(2),} };
 static const struct comedi_lrange range718_unipolar1 = { 1, {BIP_RANGE(1),} };
 
-static int pcl818_attach(struct comedi_device *dev,
-			 struct comedi_devconfig *it);
-static int pcl818_detach(struct comedi_device *dev);
-
 #ifdef unused
 static int RTC_lock;	/* RTC lock */
 static int RTC_timer_lock;	/* RTC int lock */
@@ -277,54 +273,6 @@ struct pcl818_board {
 	int is_818;
 };
 
-static const struct pcl818_board boardtypes[] = {
-	{"pcl818l", 4, 16, 8, 25000, 1, 16, 16, &range_pcl818l_l_ai,
-	 &range_unipolar5, PCLx1x_RANGE, 0x00fc,
-	 0x0a, 0xfff, 0xfff, 0, 1},
-	{"pcl818h", 9, 16, 8, 10000, 1, 16, 16, &range_pcl818h_ai,
-	 &range_unipolar5, PCLx1x_RANGE, 0x00fc,
-	 0x0a, 0xfff, 0xfff, 0, 1},
-	{"pcl818hd", 9, 16, 8, 10000, 1, 16, 16, &range_pcl818h_ai,
-	 &range_unipolar5, PCLx1x_RANGE, 0x00fc,
-	 0x0a, 0xfff, 0xfff, 1, 1},
-	{"pcl818hg", 12, 16, 8, 10000, 1, 16, 16, &range_pcl818hg_ai,
-	 &range_unipolar5, PCLx1x_RANGE, 0x00fc,
-	 0x0a, 0xfff, 0xfff, 1, 1},
-	{"pcl818", 9, 16, 8, 10000, 2, 16, 16, &range_pcl818h_ai,
-	 &range_unipolar5, PCLx1x_RANGE, 0x00fc,
-	 0x0a, 0xfff, 0xfff, 0, 1},
-	{"pcl718", 1, 16, 8, 16000, 2, 16, 16, &range_unipolar5,
-	 &range_unipolar5, PCLx1x_RANGE, 0x00fc,
-	 0x0a, 0xfff, 0xfff, 0, 0},
-	/* pcm3718 */
-	{"pcm3718", 9, 16, 8, 10000, 0, 16, 16, &range_pcl818h_ai,
-	 &range_unipolar5, PCLx1x_RANGE, 0x00fc,
-	 0x0a, 0xfff, 0xfff, 0, 1 /* XXX ? */ },
-};
-
-static struct comedi_driver driver_pcl818 = {
-	.driver_name = "pcl818",
-	.module = THIS_MODULE,
-	.attach = pcl818_attach,
-	.detach = pcl818_detach,
-	.board_name = &boardtypes[0].name,
-	.num_names = ARRAY_SIZE(boardtypes),
-	.offset = sizeof(struct pcl818_board),
-};
-
-static int __init driver_pcl818_init_module(void)
-{
-	return comedi_driver_register(&driver_pcl818);
-}
-
-static void __exit driver_pcl818_cleanup_module(void)
-{
-	comedi_driver_unregister(&driver_pcl818);
-}
-
-module_init(driver_pcl818_init_module);
-module_exit(driver_pcl818_cleanup_module);
-
 struct pcl818_private {
 
 	unsigned int dma;	/*  used DMA, 0=don't use DMA */
@@ -1722,12 +1670,6 @@ static void free_resources(struct comedi_device *dev)
 	/* printk("free_resource() end\n"); */
 }
 
-/*
-==============================================================================
-
-   Initialization
-
-*/
 static int pcl818_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
 	int ret;
@@ -2018,10 +1960,6 @@ no_dma:
 	return 0;
 }
 
-/*
-==============================================================================
-  Removes device
- */
 static int pcl818_detach(struct comedi_device *dev)
 {
 	/*   printk("comedi%d: pcl818: remove\n", dev->minor); */
@@ -2029,6 +1967,53 @@ static int pcl818_detach(struct comedi_device *dev)
 	return 0;
 }
 
+static const struct pcl818_board boardtypes[] = {
+	{"pcl818l", 4, 16, 8, 25000, 1, 16, 16, &range_pcl818l_l_ai,
+	 &range_unipolar5, PCLx1x_RANGE, 0x00fc,
+	 0x0a, 0xfff, 0xfff, 0, 1},
+	{"pcl818h", 9, 16, 8, 10000, 1, 16, 16, &range_pcl818h_ai,
+	 &range_unipolar5, PCLx1x_RANGE, 0x00fc,
+	 0x0a, 0xfff, 0xfff, 0, 1},
+	{"pcl818hd", 9, 16, 8, 10000, 1, 16, 16, &range_pcl818h_ai,
+	 &range_unipolar5, PCLx1x_RANGE, 0x00fc,
+	 0x0a, 0xfff, 0xfff, 1, 1},
+	{"pcl818hg", 12, 16, 8, 10000, 1, 16, 16, &range_pcl818hg_ai,
+	 &range_unipolar5, PCLx1x_RANGE, 0x00fc,
+	 0x0a, 0xfff, 0xfff, 1, 1},
+	{"pcl818", 9, 16, 8, 10000, 2, 16, 16, &range_pcl818h_ai,
+	 &range_unipolar5, PCLx1x_RANGE, 0x00fc,
+	 0x0a, 0xfff, 0xfff, 0, 1},
+	{"pcl718", 1, 16, 8, 16000, 2, 16, 16, &range_unipolar5,
+	 &range_unipolar5, PCLx1x_RANGE, 0x00fc,
+	 0x0a, 0xfff, 0xfff, 0, 0},
+	/* pcm3718 */
+	{"pcm3718", 9, 16, 8, 10000, 0, 16, 16, &range_pcl818h_ai,
+	 &range_unipolar5, PCLx1x_RANGE, 0x00fc,
+	 0x0a, 0xfff, 0xfff, 0, 1 /* XXX ? */ },
+};
+
+static struct comedi_driver driver_pcl818 = {
+	.driver_name	= "pcl818",
+	.module		= THIS_MODULE,
+	.attach		= pcl818_attach,
+	.detach		= pcl818_detach,
+	.board_name	= &boardtypes[0].name,
+	.num_names	= ARRAY_SIZE(boardtypes),
+	.offset		= sizeof(struct pcl818_board),
+};
+
+static int __init driver_pcl818_init_module(void)
+{
+	return comedi_driver_register(&driver_pcl818);
+}
+module_init(driver_pcl818_init_module);
+
+static void __exit driver_pcl818_cleanup_module(void)
+{
+	comedi_driver_unregister(&driver_pcl818);
+}
+module_exit(driver_pcl818_cleanup_module);
+
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
 MODULE_LICENSE("GPL");
