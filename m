Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966802Ab2EOXzp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 19:55:45 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:35398 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933214Ab2EOXzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 19:55:44 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-8.tower-131.messagelabs.com!1337126141!4940649!2
X-Originating-IP: [216.166.12.69]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: refactor ii_pci20kc driver and use module_comedi_driver
Date: Tue, 15 May 2012 16:55:37 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205151655.37740.hartleys@visionengravers.com>
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

 drivers/staging/comedi/drivers/ii_pci20kc.c |   30 ++++++--------------------
 1 files changed, 7 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ii_pci20kc.c b/drivers/staging/comedi/drivers/ii_pci20kc.c
index e4711ef..6b1b5c88 100644
--- a/drivers/staging/comedi/drivers/ii_pci20kc.c
+++ b/drivers/staging/comedi/drivers/ii_pci20kc.c
@@ -159,17 +159,6 @@ struct pci20xxx_private {
 #define devpriv ((struct pci20xxx_private *)dev->private)
 #define CHAN (CR_CHAN(it->chanlist[0]))
 
-static int pci20xxx_attach(struct comedi_device *dev,
-			   struct comedi_devconfig *it);
-static int pci20xxx_detach(struct comedi_device *dev);
-
-static struct comedi_driver driver_pci20xxx = {
-	.driver_name = "ii_pci20kc",
-	.module = THIS_MODULE,
-	.attach = pci20xxx_attach,
-	.detach = pci20xxx_detach,
-};
-
 static int pci20006_init(struct comedi_device *dev, struct comedi_subdevice *s,
 			 int opt0, int opt1);
 static int pci20341_init(struct comedi_device *dev, struct comedi_subdevice *s,
@@ -666,18 +655,13 @@ static unsigned int pci20xxx_di(struct comedi_device *dev,
 }
 #endif
 
-static int __init driver_pci20xxx_init_module(void)
-{
-	return comedi_driver_register(&driver_pci20xxx);
-}
-
-static void __exit driver_pci20xxx_cleanup_module(void)
-{
-	comedi_driver_unregister(&driver_pci20xxx);
-}
-
-module_init(driver_pci20xxx_init_module);
-module_exit(driver_pci20xxx_cleanup_module);
+static struct comedi_driver pci20xxx_driver = {
+	.driver_name	= "ii_pci20kc",
+	.module		= THIS_MODULE,
+	.attach		= pci20xxx_attach,
+	.detach		= pci20xxx_detach,
+};
+module_comedi_driver(pci20xxx_driver);
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
