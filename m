Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967029Ab2EOXIY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 19:08:24 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:28512 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967008Ab2EOXIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 19:08:22 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-16.tower-127.messagelabs.com!1337123285!5620491!18
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: refactor das6402 driver and use module_comedi_driver
Date: Tue, 15 May 2012 16:08:04 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205151608.04642.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the module_init/module_exit routines and the associated
struct comedi_drive to the end of the source. This is more
typical of how other drivers are written and removes the need
for the forward declarations.

Convert the driver to use the module_comedi_driver() macro
which makes the code smaller and a bit simpler.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

 drivers/staging/comedi/drivers/das6402.c |   70 +++++++++++-------------------
 1 files changed, 26 insertions(+), 44 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das6402.c b/drivers/staging/comedi/drivers/das6402.c
index f256841..889527d 100644
--- a/drivers/staging/comedi/drivers/das6402.c
+++ b/drivers/staging/comedi/drivers/das6402.c
@@ -99,29 +99,6 @@ This driver has suffered bitrot.
 #define	C2 0x80
 #define	RWLH 0x30
 
-static int das6402_attach(struct comedi_device *dev,
-			  struct comedi_devconfig *it);
-static int das6402_detach(struct comedi_device *dev);
-static struct comedi_driver driver_das6402 = {
-	.driver_name = "das6402",
-	.module = THIS_MODULE,
-	.attach = das6402_attach,
-	.detach = das6402_detach,
-};
-
-static int __init driver_das6402_init_module(void)
-{
-	return comedi_driver_register(&driver_das6402);
-}
-
-static void __exit driver_das6402_cleanup_module(void)
-{
-	comedi_driver_unregister(&driver_das6402);
-}
-
-module_init(driver_das6402_init_module);
-module_exit(driver_das6402_cleanup_module);
-
 struct das6402_private {
 	int ai_bytes_to_read;
 
@@ -130,7 +107,14 @@ struct das6402_private {
 #define devpriv ((struct das6402_private *)dev->private)
 
 static void das6402_ai_fifo_dregs(struct comedi_device *dev,
-				  struct comedi_subdevice *s);
+				  struct comedi_subdevice *s)
+{
+	while (1) {
+		if (!(inb(dev->iobase + 8) & 0x01))
+			return;
+		comedi_buf_put(s->async, inw(dev->iobase));
+	}
+}
 
 static void das6402_setcounter(struct comedi_device *dev)
 {
@@ -209,16 +193,6 @@ static void das6402_ai_fifo_read(struct comedi_device *dev, short *data, int n)
 }
 #endif
 
-static void das6402_ai_fifo_dregs(struct comedi_device *dev,
-				  struct comedi_subdevice *s)
-{
-	while (1) {
-		if (!(inb(dev->iobase + 8) & 0x01))
-			return;
-		comedi_buf_put(s->async, inw(dev->iobase));
-	}
-}
-
 static int das6402_ai_cancel(struct comedi_device *dev,
 			     struct comedi_subdevice *s)
 {
@@ -300,16 +274,6 @@ static int board_init(struct comedi_device *dev)
 	return 0;
 }
 
-static int das6402_detach(struct comedi_device *dev)
-{
-	if (dev->irq)
-		free_irq(dev->irq, dev);
-	if (dev->iobase)
-		release_region(dev->iobase, DAS6402_SIZE);
-
-	return 0;
-}
-
 static int das6402_attach(struct comedi_device *dev,
 			  struct comedi_devconfig *it)
 {
@@ -363,6 +327,24 @@ static int das6402_attach(struct comedi_device *dev,
 	return 0;
 }
 
+static int das6402_detach(struct comedi_device *dev)
+{
+	if (dev->irq)
+		free_irq(dev->irq, dev);
+	if (dev->iobase)
+		release_region(dev->iobase, DAS6402_SIZE);
+
+	return 0;
+}
+
+static struct comedi_driver das6402_driver = {
+	.driver_name	= "das6402",
+	.module		= THIS_MODULE,
+	.attach		= das6402_attach,
+	.detach		= das6402_detach,
+};
+module_comedi_driver(das6402_driver)
+
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
 MODULE_LICENSE("GPL");
