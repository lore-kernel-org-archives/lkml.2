Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948Ab2D0WKN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 18:10:13 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:44808 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755255Ab2D0WKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 18:10:11 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-8.tower-132.messagelabs.com!1335564588!7054826!15
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: partial refactor of the rtd520 driver to remove forward declarations
Date: Fri, 27 Apr 2012 15:09:49 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201204271509.50233.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the struct comedi_driver MODULE_DEVICE_TABLE to the end
of the source. The attach and detach functions are not moved yet
because patch is pretty messy and not reviewable. This is more
typical of how other drivers are written and removes the need for
the forward declarations.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/comedi/drivers/rtd520.c
index 0b7ff76..1559d57 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -328,14 +328,6 @@ static const struct rtdBoard rtd520Boards[] = {
 	 },
 };
 
-static DEFINE_PCI_DEVICE_TABLE(rtd520_pci_table) = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_RTD, 0x7520) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_RTD, 0x4520) },
-	{ 0 }
-};
-
-MODULE_DEVICE_TABLE(pci, rtd520_pci_table);
-
 /*
  * Useful for shorthand access to the particular board structure
  */
@@ -705,22 +697,6 @@ struct rtdPrivate {
 #define RtdDma1Status(dev) \
 	readb(devpriv->lcfg+LCFG_DMACSR1)
 
-/*
- * The struct comedi_driver structure tells the Comedi core module
- * which functions to call to configure/deconfigure (attac/detach)
- * the board, and also about the kernel module that contains
- * the device code.
- */
-static int rtd_attach(struct comedi_device *dev, struct comedi_devconfig *it);
-static int rtd_detach(struct comedi_device *dev);
-
-static struct comedi_driver rtd520Driver = {
-	.driver_name = DRV_NAME,
-	.module = THIS_MODULE,
-	.attach = rtd_attach,
-	.detach = rtd_detach,
-};
-
 static int rtd_ai_rinsn(struct comedi_device *dev, struct comedi_subdevice *s,
 			struct comedi_insn *insn, unsigned int *data);
 static int rtd_ao_winsn(struct comedi_device *dev, struct comedi_subdevice *s,
@@ -2348,10 +2324,13 @@ static int rtd_dio_insn_config(struct comedi_device *dev,
 	return 1;
 }
 
-/*
- * A convenient macro that defines init_module() and cleanup_module(),
- * as necessary.
- */
+static struct comedi_driver rtd520Driver = {
+	.driver_name	= DRV_NAME,
+	.module		= THIS_MODULE,
+	.attach		= rtd_attach,
+	.detach		= rtd_detach,
+};
+
 static int __devinit rtd520Driver_pci_probe(struct pci_dev *dev,
 					    const struct pci_device_id *ent)
 {
@@ -2363,10 +2342,17 @@ static void __devexit rtd520Driver_pci_remove(struct pci_dev *dev)
 	comedi_pci_auto_unconfig(dev);
 }
 
+static DEFINE_PCI_DEVICE_TABLE(rtd520_pci_table) = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_RTD, 0x7520) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_RTD, 0x4520) },
+	{ 0 }
+};
+MODULE_DEVICE_TABLE(pci, rtd520_pci_table);
+
 static struct pci_driver rtd520Driver_pci_driver = {
-	.id_table = rtd520_pci_table,
-	.probe = &rtd520Driver_pci_probe,
-	.remove = __devexit_p(&rtd520Driver_pci_remove)
+	.id_table	= rtd520_pci_table,
+	.probe		= &rtd520Driver_pci_probe,
+	.remove		= __devexit_p(&rtd520Driver_pci_remove)
 };
 
 static int __init rtd520Driver_init_module(void)
@@ -2380,14 +2366,13 @@ static int __init rtd520Driver_init_module(void)
 	rtd520Driver_pci_driver.name = (char *)rtd520Driver.driver_name;
 	return pci_register_driver(&rtd520Driver_pci_driver);
 }
+module_init(rtd520Driver_init_module);
 
 static void __exit rtd520Driver_cleanup_module(void)
 {
 	pci_unregister_driver(&rtd520Driver_pci_driver);
 	comedi_driver_unregister(&rtd520Driver);
 }
-
-module_init(rtd520Driver_init_module);
 module_exit(rtd520Driver_cleanup_module);
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
