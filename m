Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757091Ab2D0XRj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 19:17:39 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:21832 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565Ab2D0XRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 19:17:38 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-9.tower-127.messagelabs.com!1335568644!4200029!10
X-Originating-IP: [216.166.12.180]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: refactor pcl812 driver to remove forward declarations
Date: Fri, 27 Apr 2012 16:17:22 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201204271617.22739.hartleys@visionengravers.com>
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

diff --git a/drivers/staging/comedi/drivers/pcl812.c b/drivers/staging/comedi/drivers/pcl812.c
index 555d0df..85463e2 100644
--- a/drivers/staging/comedi/drivers/pcl812.c
+++ b/drivers/staging/comedi/drivers/pcl812.c
@@ -316,10 +316,6 @@ static const struct comedi_lrange range_a821pgh_ai = { 4, {
 							   }
 };
 
-static int pcl812_attach(struct comedi_device *dev,
-			 struct comedi_devconfig *it);
-static int pcl812_detach(struct comedi_device *dev);
-
 struct pcl812_board {
 
 	const char *name;	/*  board name */
@@ -340,88 +336,8 @@ struct pcl812_board {
 	unsigned char haveMPC508;	/*  1=board use MPC508A multiplexor */
 };
 
-static const struct pcl812_board boardtypes[] = {
-	{"pcl812", boardPCL812, 16, 0, 2, 16, 16, 0x0fff,
-	 33000, 500, &range_bipolar10, &range_unipolar5,
-	 0xdcfc, 0x0a, PCLx1x_IORANGE, 0},
-	{"pcl812pg", boardPCL812PG, 16, 0, 2, 16, 16, 0x0fff,
-	 33000, 500, &range_pcl812pg_ai, &range_unipolar5,
-	 0xdcfc, 0x0a, PCLx1x_IORANGE, 0},
-	{"acl8112pg", boardPCL812PG, 16, 0, 2, 16, 16, 0x0fff,
-	 10000, 500, &range_pcl812pg_ai, &range_unipolar5,
-	 0xdcfc, 0x0a, PCLx1x_IORANGE, 0},
-	{"acl8112dg", boardACL8112, 16, 8, 2, 16, 16, 0x0fff,
-	 10000, 500, &range_acl8112dg_ai, &range_unipolar5,
-	 0xdcfc, 0x0a, PCLx1x_IORANGE, 1},
-	{"acl8112hg", boardACL8112, 16, 8, 2, 16, 16, 0x0fff,
-	 10000, 500, &range_acl8112hg_ai, &range_unipolar5,
-	 0xdcfc, 0x0a, PCLx1x_IORANGE, 1},
-	{"a821pgl", boardA821, 16, 8, 1, 16, 16, 0x0fff,
-	 10000, 500, &range_pcl813b_ai, &range_unipolar5,
-	 0x000c, 0x00, PCLx1x_IORANGE, 0},
-	{"a821pglnda", boardA821, 16, 8, 0, 0, 0, 0x0fff,
-	 10000, 500, &range_pcl813b_ai, NULL,
-	 0x000c, 0x00, PCLx1x_IORANGE, 0},
-	{"a821pgh", boardA821, 16, 8, 1, 16, 16, 0x0fff,
-	 10000, 500, &range_a821pgh_ai, &range_unipolar5,
-	 0x000c, 0x00, PCLx1x_IORANGE, 0},
-	{"a822pgl", boardACL8112, 16, 8, 2, 16, 16, 0x0fff,
-	 10000, 500, &range_acl8112dg_ai, &range_unipolar5,
-	 0xdcfc, 0x0a, PCLx1x_IORANGE, 0},
-	{"a822pgh", boardACL8112, 16, 8, 2, 16, 16, 0x0fff,
-	 10000, 500, &range_acl8112hg_ai, &range_unipolar5,
-	 0xdcfc, 0x0a, PCLx1x_IORANGE, 0},
-	{"a823pgl", boardACL8112, 16, 8, 2, 16, 16, 0x0fff,
-	 8000, 500, &range_acl8112dg_ai, &range_unipolar5,
-	 0xdcfc, 0x0a, PCLx1x_IORANGE, 0},
-	{"a823pgh", boardACL8112, 16, 8, 2, 16, 16, 0x0fff,
-	 8000, 500, &range_acl8112hg_ai, &range_unipolar5,
-	 0xdcfc, 0x0a, PCLx1x_IORANGE, 0},
-	{"pcl813", boardPCL813, 32, 0, 0, 0, 0, 0x0fff,
-	 0, 0, &range_pcl813b_ai, NULL,
-	 0x0000, 0x00, PCLx1x_IORANGE, 0},
-	{"pcl813b", boardPCL813B, 32, 0, 0, 0, 0, 0x0fff,
-	 0, 0, &range_pcl813b_ai, NULL,
-	 0x0000, 0x00, PCLx1x_IORANGE, 0},
-	{"acl8113", boardACL8113, 32, 0, 0, 0, 0, 0x0fff,
-	 0, 0, &range_acl8113_1_ai, NULL,
-	 0x0000, 0x00, PCLx1x_IORANGE, 0},
-	{"iso813", boardISO813, 32, 0, 0, 0, 0, 0x0fff,
-	 0, 0, &range_iso813_1_ai, NULL,
-	 0x0000, 0x00, PCLx1x_IORANGE, 0},
-	{"acl8216", boardACL8216, 16, 8, 2, 16, 16, 0xffff,
-	 10000, 500, &range_pcl813b2_ai, &range_unipolar5,
-	 0xdcfc, 0x0a, PCLx1x_IORANGE, 1},
-	{"a826pg", boardACL8216, 16, 8, 2, 16, 16, 0xffff,
-	 10000, 500, &range_pcl813b2_ai, &range_unipolar5,
-	 0xdcfc, 0x0a, PCLx1x_IORANGE, 0},
-};
-
 #define this_board ((const struct pcl812_board *)dev->board_ptr)
 
-static struct comedi_driver driver_pcl812 = {
-	.driver_name = "pcl812",
-	.module = THIS_MODULE,
-	.attach = pcl812_attach,
-	.detach = pcl812_detach,
-	.board_name = &boardtypes[0].name,
-	.num_names = ARRAY_SIZE(boardtypes),
-	.offset = sizeof(struct pcl812_board),
-};
-
-static int __init driver_pcl812_init_module(void)
-{
-	return comedi_driver_register(&driver_pcl812);
-}
-
-static void __exit driver_pcl812_cleanup_module(void)
-{
-	comedi_driver_unregister(&driver_pcl812);
-}
-
-module_init(driver_pcl812_init_module);
-module_exit(driver_pcl812_cleanup_module);
-
 struct pcl812_private {
 
 	unsigned char valid;	/*  =1 device is OK */
@@ -1355,9 +1271,6 @@ static void pcl812_reset(struct comedi_device *dev)
 #endif
 }
 
-/*
-==============================================================================
-*/
 static int pcl812_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
 	int ret, subdev;
@@ -1701,9 +1614,6 @@ no_dma:
 	return 0;
 }
 
-/*
-==============================================================================
- */
 static int pcl812_detach(struct comedi_device *dev)
 {
 
@@ -1714,6 +1624,85 @@ static int pcl812_detach(struct comedi_device *dev)
 	return 0;
 }
 
+static const struct pcl812_board boardtypes[] = {
+	{"pcl812", boardPCL812, 16, 0, 2, 16, 16, 0x0fff,
+	 33000, 500, &range_bipolar10, &range_unipolar5,
+	 0xdcfc, 0x0a, PCLx1x_IORANGE, 0},
+	{"pcl812pg", boardPCL812PG, 16, 0, 2, 16, 16, 0x0fff,
+	 33000, 500, &range_pcl812pg_ai, &range_unipolar5,
+	 0xdcfc, 0x0a, PCLx1x_IORANGE, 0},
+	{"acl8112pg", boardPCL812PG, 16, 0, 2, 16, 16, 0x0fff,
+	 10000, 500, &range_pcl812pg_ai, &range_unipolar5,
+	 0xdcfc, 0x0a, PCLx1x_IORANGE, 0},
+	{"acl8112dg", boardACL8112, 16, 8, 2, 16, 16, 0x0fff,
+	 10000, 500, &range_acl8112dg_ai, &range_unipolar5,
+	 0xdcfc, 0x0a, PCLx1x_IORANGE, 1},
+	{"acl8112hg", boardACL8112, 16, 8, 2, 16, 16, 0x0fff,
+	 10000, 500, &range_acl8112hg_ai, &range_unipolar5,
+	 0xdcfc, 0x0a, PCLx1x_IORANGE, 1},
+	{"a821pgl", boardA821, 16, 8, 1, 16, 16, 0x0fff,
+	 10000, 500, &range_pcl813b_ai, &range_unipolar5,
+	 0x000c, 0x00, PCLx1x_IORANGE, 0},
+	{"a821pglnda", boardA821, 16, 8, 0, 0, 0, 0x0fff,
+	 10000, 500, &range_pcl813b_ai, NULL,
+	 0x000c, 0x00, PCLx1x_IORANGE, 0},
+	{"a821pgh", boardA821, 16, 8, 1, 16, 16, 0x0fff,
+	 10000, 500, &range_a821pgh_ai, &range_unipolar5,
+	 0x000c, 0x00, PCLx1x_IORANGE, 0},
+	{"a822pgl", boardACL8112, 16, 8, 2, 16, 16, 0x0fff,
+	 10000, 500, &range_acl8112dg_ai, &range_unipolar5,
+	 0xdcfc, 0x0a, PCLx1x_IORANGE, 0},
+	{"a822pgh", boardACL8112, 16, 8, 2, 16, 16, 0x0fff,
+	 10000, 500, &range_acl8112hg_ai, &range_unipolar5,
+	 0xdcfc, 0x0a, PCLx1x_IORANGE, 0},
+	{"a823pgl", boardACL8112, 16, 8, 2, 16, 16, 0x0fff,
+	 8000, 500, &range_acl8112dg_ai, &range_unipolar5,
+	 0xdcfc, 0x0a, PCLx1x_IORANGE, 0},
+	{"a823pgh", boardACL8112, 16, 8, 2, 16, 16, 0x0fff,
+	 8000, 500, &range_acl8112hg_ai, &range_unipolar5,
+	 0xdcfc, 0x0a, PCLx1x_IORANGE, 0},
+	{"pcl813", boardPCL813, 32, 0, 0, 0, 0, 0x0fff,
+	 0, 0, &range_pcl813b_ai, NULL,
+	 0x0000, 0x00, PCLx1x_IORANGE, 0},
+	{"pcl813b", boardPCL813B, 32, 0, 0, 0, 0, 0x0fff,
+	 0, 0, &range_pcl813b_ai, NULL,
+	 0x0000, 0x00, PCLx1x_IORANGE, 0},
+	{"acl8113", boardACL8113, 32, 0, 0, 0, 0, 0x0fff,
+	 0, 0, &range_acl8113_1_ai, NULL,
+	 0x0000, 0x00, PCLx1x_IORANGE, 0},
+	{"iso813", boardISO813, 32, 0, 0, 0, 0, 0x0fff,
+	 0, 0, &range_iso813_1_ai, NULL,
+	 0x0000, 0x00, PCLx1x_IORANGE, 0},
+	{"acl8216", boardACL8216, 16, 8, 2, 16, 16, 0xffff,
+	 10000, 500, &range_pcl813b2_ai, &range_unipolar5,
+	 0xdcfc, 0x0a, PCLx1x_IORANGE, 1},
+	{"a826pg", boardACL8216, 16, 8, 2, 16, 16, 0xffff,
+	 10000, 500, &range_pcl813b2_ai, &range_unipolar5,
+	 0xdcfc, 0x0a, PCLx1x_IORANGE, 0},
+};
+
+static struct comedi_driver driver_pcl812 = {
+	.driver_name	= "pcl812",
+	.module		= THIS_MODULE,
+	.attach		= pcl812_attach,
+	.detach		= pcl812_detach,
+	.board_name	= &boardtypes[0].name,
+	.num_names	= ARRAY_SIZE(boardtypes),
+	.offset		= sizeof(struct pcl812_board),
+};
+
+static int __init driver_pcl812_init_module(void)
+{
+	return comedi_driver_register(&driver_pcl812);
+}
+module_init(driver_pcl812_init_module);
+
+static void __exit driver_pcl812_cleanup_module(void)
+{
+	comedi_driver_unregister(&driver_pcl812);
+}
+module_exit(driver_pcl812_cleanup_module);
+
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
 MODULE_LICENSE("GPL");
