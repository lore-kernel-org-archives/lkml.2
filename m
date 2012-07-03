Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933245Ab2GCBKw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 21:10:52 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:34733 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932639Ab2GCBKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 21:10:50 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-10.tower-209.messagelabs.com!1341277849!7614425!1
X-Originating-IP: [216.166.12.99]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/8] staging: comedi: dmm32at: use module_comedi_driver
Date: Mon, 2 Jul 2012 18:10:46 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207021810.46457.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert driver to use the module_comedi_driver() macro to remove
some of the boilerplate.

Move the comedi_driver variable to the end of the file to keep it
with the module_comedi_driver() macro. This also removes the need
for some of the forward declarations. While moving the variable:

1) strip out the unnecessary cut-and-paste skel driver comments
2) add whitespace to improve the readability
3) rename the variable from driver* to *driver

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/dmm32at.c | 63 +++++---------------------------
 1 file changed, 10 insertions(+), 53 deletions(-)

diff --git a/drivers/staging/comedi/drivers/dmm32at.c b/drivers/staging/comedi/drivers/dmm32at.c
index af353167..ad7fef9 100644
--- a/drivers/staging/comedi/drivers/dmm32at.c
+++ b/drivers/staging/comedi/drivers/dmm32at.c
@@ -211,43 +211,6 @@ struct dmm32at_private {
  */
 #define devpriv ((struct dmm32at_private *)dev->private)
 
-/*
- * The struct comedi_driver structure tells the Comedi core module
- * which functions to call to configure/deconfigure (attach/detach)
- * the board, and also about the kernel module that contains
- * the device code.
- */
-static int dmm32at_attach(struct comedi_device *dev,
-			  struct comedi_devconfig *it);
-static void dmm32at_detach(struct comedi_device *dev);
-static struct comedi_driver driver_dmm32at = {
-	.driver_name = "dmm32at",
-	.module = THIS_MODULE,
-	.attach = dmm32at_attach,
-	.detach = dmm32at_detach,
-/* It is not necessary to implement the following members if you are
- * writing a driver for a ISA PnP or PCI card */
-/* Most drivers will support multiple types of boards by
- * having an array of board structures.  These were defined
- * in dmm32at_boards[] above.  Note that the element 'name'
- * was first in the structure -- Comedi uses this fact to
- * extract the name of the board without knowing any details
- * about the structure except for its length.
- * When a device is attached (by comedi_config), the name
- * of the device is given to Comedi, and Comedi tries to
- * match it by going through the list of board names.  If
- * there is a match, the address of the pointer is put
- * into dev->board_ptr and driver->attach() is called.
- *
- * Note that these are not necessary if you can determine
- * the type of board in software.  ISA PnP, PCI, and PCMCIA
- * devices are such boards.
- */
-	.board_name = &dmm32at_boards[0].name,
-	.offset = sizeof(struct dmm32at_board),
-	.num_names = ARRAY_SIZE(dmm32at_boards),
-};
-
 /* prototypes for driver functions below */
 static int dmm32at_ai_rinsn(struct comedi_device *dev,
 			    struct comedi_subdevice *s,
@@ -1027,22 +990,16 @@ void dmm32at_setaitimer(struct comedi_device *dev, unsigned int nansec)
 
 }
 
-/*
- * A convenient macro that defines init_module() and cleanup_module(),
- * as necessary.
- */
-static int __init driver_dmm32at_init_module(void)
-{
-	return comedi_driver_register(&driver_dmm32at);
-}
-
-static void __exit driver_dmm32at_cleanup_module(void)
-{
-	comedi_driver_unregister(&driver_dmm32at);
-}
-
-module_init(driver_dmm32at_init_module);
-module_exit(driver_dmm32at_cleanup_module);
+static struct comedi_driver dmm32at_driver = {
+	.driver_name	= "dmm32at",
+	.module		= THIS_MODULE,
+	.attach		= dmm32at_attach,
+	.detach		= dmm32at_detach,
+	.board_name	= &dmm32at_boards[0].name,
+	.offset		= sizeof(struct dmm32at_board),
+	.num_names	= ARRAY_SIZE(dmm32at_boards),
+};
+module_comedi_driver(dmm32at_driver);
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
-- 
1.7.11

