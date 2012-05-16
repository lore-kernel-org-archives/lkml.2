Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933369Ab2EPAgK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 20:36:10 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:11453 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757497Ab2EPAgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 20:36:07 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-6.tower-160.messagelabs.com!1337128566!6533898!1
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: refactor ni_atmio driver and use module_comedi_driver
Date: Tue, 15 May 2012 17:36:01 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205151736.02208.hartleys@visionengravers.com>
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

 drivers/staging/comedi/drivers/ni_atmio.c |   92 ++++++++++++-----------------
 1 files changed, 37 insertions(+), 55 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_atmio.c b/drivers/staging/comedi/drivers/ni_atmio.c
index 647c228..02cf44b 100644
--- a/drivers/staging/comedi/drivers/ni_atmio.c
+++ b/drivers/staging/comedi/drivers/ni_atmio.c
@@ -343,49 +343,8 @@ static struct pnp_device_id device_ids[] = {
 
 MODULE_DEVICE_TABLE(pnp, device_ids);
 
-static int ni_atmio_attach(struct comedi_device *dev,
-			   struct comedi_devconfig *it);
-static int ni_atmio_detach(struct comedi_device *dev);
-static struct comedi_driver driver_atmio = {
-	.driver_name = "ni_atmio",
-	.module = THIS_MODULE,
-	.attach = ni_atmio_attach,
-	.detach = ni_atmio_detach,
-};
-
-static int __init driver_atmio_init_module(void)
-{
-	return comedi_driver_register(&driver_atmio);
-}
-
-static void __exit driver_atmio_cleanup_module(void)
-{
-	comedi_driver_unregister(&driver_atmio);
-}
-
-module_init(driver_atmio_init_module);
-module_exit(driver_atmio_cleanup_module);
-
 #include "ni_mio_common.c"
 
-static int ni_getboardtype(struct comedi_device *dev);
-
-/* clean up allocated resources */
-static int ni_atmio_detach(struct comedi_device *dev)
-{
-	mio_common_detach(dev);
-
-	if (dev->iobase)
-		release_region(dev->iobase, NI_SIZE);
-	if (dev->irq)
-		free_irq(dev->irq, dev);
-
-	if (devpriv->isapnp_dev)
-		pnp_device_detach(devpriv->isapnp_dev);
-
-	return 0;
-}
-
 static int ni_isapnp_find_board(struct pnp_dev **dev)
 {
 	struct pnp_dev *isapnp_dev = NULL;
@@ -424,6 +383,26 @@ static int ni_isapnp_find_board(struct pnp_dev **dev)
 	return 0;
 }
 
+static int ni_getboardtype(struct comedi_device *dev)
+{
+	int device_id = ni_read_eeprom(dev, 511);
+	int i;
+
+	for (i = 0; i < n_ni_boards; i++) {
+		if (ni_boards[i].device_id == device_id)
+			return i;
+
+	}
+	if (device_id == 255)
+		printk(" can't find board\n");
+	 else if (device_id == 0)
+		printk(" EEPROM read error (?) or device not found\n");
+	 else
+		printk(" unknown device ID %d -- contact author\n", device_id);
+
+	return -1;
+}
+
 static int ni_atmio_attach(struct comedi_device *dev,
 			   struct comedi_devconfig *it)
 {
@@ -518,22 +497,25 @@ static int ni_atmio_attach(struct comedi_device *dev,
 	return 0;
 }
 
-static int ni_getboardtype(struct comedi_device *dev)
+static int ni_atmio_detach(struct comedi_device *dev)
 {
-	int device_id = ni_read_eeprom(dev, 511);
-	int i;
+	mio_common_detach(dev);
 
-	for (i = 0; i < n_ni_boards; i++) {
-		if (ni_boards[i].device_id == device_id)
-			return i;
+	if (dev->iobase)
+		release_region(dev->iobase, NI_SIZE);
+	if (dev->irq)
+		free_irq(dev->irq, dev);
 
-	}
-	if (device_id == 255)
-		printk(" can't find board\n");
-	 else if (device_id == 0)
-		printk(" EEPROM read error (?) or device not found\n");
-	 else
-		printk(" unknown device ID %d -- contact author\n", device_id);
+	if (devpriv->isapnp_dev)
+		pnp_device_detach(devpriv->isapnp_dev);
 
-	return -1;
+	return 0;
 }
+
+static struct comedi_driver ni_atmio_driver = {
+	.driver_name	= "ni_atmio",
+	.module		= THIS_MODULE,
+	.attach		= ni_atmio_attach,
+	.detach		= ni_atmio_detach,
+};
+module_comedi_driver(ni_atmio_driver);
