Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757160Ab2EPBfI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 21:35:08 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:51743 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253Ab2EPBfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 21:35:05 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-4.tower-132.messagelabs.com!1337132103!11719799!1
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: refactor das1800 driver and use module_comedi_driver
Date: Tue, 15 May 2012 18:34:49 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205151834.50050.hartleys@visionengravers.com>
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

More refactoring needs to be done to remove the remaining
forward declarations. Doing that is this patch makes it
difficult to review.

 drivers/staging/comedi/drivers/das1800.c |   55 ++++++++++--------------------
 1 files changed, 18 insertions(+), 37 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das1800.c b/drivers/staging/comedi/drivers/das1800.c
index 99ada5a..0b1f499 100644
--- a/drivers/staging/comedi/drivers/das1800.c
+++ b/drivers/staging/comedi/drivers/das1800.c
@@ -183,9 +183,6 @@ enum {
 	das1802hr, das1802hr_da, das1801hc, das1802hc, das1801ao, das1802ao
 };
 
-static int das1800_attach(struct comedi_device *dev,
-			  struct comedi_devconfig *it);
-static int das1800_detach(struct comedi_device *dev);
 static int das1800_probe(struct comedi_device *dev);
 static int das1800_cancel(struct comedi_device *dev,
 			  struct comedi_subdevice *s);
@@ -518,33 +515,6 @@ static const struct comedi_lrange range_ao_2 = {
 };
 */
 
-static struct comedi_driver driver_das1800 = {
-	.driver_name = "das1800",
-	.module = THIS_MODULE,
-	.attach = das1800_attach,
-	.detach = das1800_detach,
-	.num_names = ARRAY_SIZE(das1800_boards),
-	.board_name = &das1800_boards[0].name,
-	.offset = sizeof(struct das1800_board),
-};
-
-/*
- * A convenient macro that defines init_module() and cleanup_module(),
- * as necessary.
- */
-static int __init driver_das1800_init_module(void)
-{
-	return comedi_driver_register(&driver_das1800);
-}
-
-static void __exit driver_das1800_cleanup_module(void)
-{
-	comedi_driver_unregister(&driver_das1800);
-}
-
-module_init(driver_das1800_init_module);
-module_exit(driver_das1800_cleanup_module);
-
 static int das1800_init_dma(struct comedi_device *dev, unsigned int dma0,
 			    unsigned int dma1)
 {
@@ -579,7 +549,7 @@ static int das1800_init_dma(struct comedi_device *dev, unsigned int dma0,
 			return -EINVAL;
 			break;
 		}
-		if (request_dma(dma0, driver_das1800.driver_name)) {
+		if (request_dma(dma0, dev->driver->driver_name)) {
 			dev_err(dev->hw_dev, "failed to allocate dma channel %i\n",
 				dma0);
 			return -EINVAL;
@@ -587,7 +557,7 @@ static int das1800_init_dma(struct comedi_device *dev, unsigned int dma0,
 		devpriv->dma0 = dma0;
 		devpriv->dma_current = dma0;
 		if (dma1) {
-			if (request_dma(dma1, driver_das1800.driver_name)) {
+			if (request_dma(dma1, dev->driver->driver_name)) {
 				dev_err(dev->hw_dev, "failed to allocate dma channel %i\n",
 					dma1);
 				return -EINVAL;
@@ -633,7 +603,7 @@ static int das1800_attach(struct comedi_device *dev,
 		return -ENOMEM;
 
 	printk(KERN_DEBUG "comedi%d: %s: io 0x%lx", dev->minor,
-	       driver_das1800.driver_name, iobase);
+	       dev->driver->driver_name, iobase);
 	if (irq) {
 		printk(KERN_CONT ", irq %u", irq);
 		if (dma0) {
@@ -650,7 +620,7 @@ static int das1800_attach(struct comedi_device *dev,
 	}
 
 	/* check if io addresses are available */
-	if (!request_region(iobase, DAS1800_SIZE, driver_das1800.driver_name)) {
+	if (!request_region(iobase, DAS1800_SIZE, dev->driver->driver_name)) {
 		printk
 		    (" I/O port conflict: failed to allocate ports 0x%lx to 0x%lx\n",
 		     iobase, iobase + DAS1800_SIZE - 1);
@@ -671,7 +641,7 @@ static int das1800_attach(struct comedi_device *dev,
 	if (thisboard->ao_ability == 2) {
 		iobase2 = iobase + IOBASE2;
 		if (!request_region(iobase2, DAS1800_SIZE,
-				    driver_das1800.driver_name)) {
+				    dev->driver->driver_name)) {
 			printk
 			    (" I/O port conflict: failed to allocate ports 0x%lx to 0x%lx\n",
 			     iobase2, iobase2 + DAS1800_SIZE - 1);
@@ -683,7 +653,7 @@ static int das1800_attach(struct comedi_device *dev,
 	/* grab our IRQ */
 	if (irq) {
 		if (request_irq(irq, das1800_interrupt, 0,
-				driver_das1800.driver_name, dev)) {
+				dev->driver->driver_name, dev)) {
 			dev_dbg(dev->hw_dev, "unable to allocate irq %u\n",
 				irq);
 			return -EINVAL;
@@ -816,7 +786,7 @@ static int das1800_detach(struct comedi_device *dev)
 	}
 
 	dev_dbg(dev->hw_dev, "comedi%d: %s: remove\n", dev->minor,
-		driver_das1800.driver_name);
+		dev->driver->driver_name);
 
 	return 0;
 };
@@ -1811,6 +1781,17 @@ static unsigned int suggest_transfer_size(struct comedi_cmd *cmd)
 	return size;
 }
 
+static struct comedi_driver das1800_driver = {
+	.driver_name	= "das1800",
+	.module		= THIS_MODULE,
+	.attach		= das1800_attach,
+	.detach		= das1800_detach,
+	.num_names	= ARRAY_SIZE(das1800_boards),
+	.board_name	= &das1800_boards[0].name,
+	.offset		= sizeof(struct das1800_board),
+};
+module_comedi_driver(das1800_driver);
+
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
 MODULE_LICENSE("GPL");
