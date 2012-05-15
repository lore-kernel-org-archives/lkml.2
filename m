Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933358Ab2EOUmf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 16:42:35 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:42681 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933325Ab2EOUme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 16:42:34 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-7.tower-209.messagelabs.com!1337114539!5715923!23
X-Originating-IP: [216.166.12.72]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: refactor adl_pci9118 driver and use module_comedi_pci_driver
Date: Tue, 15 May 2012 13:42:04 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205151342.04700.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the module_init/module_exit routines and the associated
struct comedi_drive and struct pci_driver to the end of the
source. This is more typical of how other drivers are written
and removes the need for the forward declarations.

Convert the driver to use the module_comedi_pci_driver() macro
which makes the code smaller and a bit simpler.

While moving the struct boardtype, convert it to C99 initializers
to improve code readability. This results is a slight increase in
the total lines of code.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

 drivers/staging/comedi/drivers/adl_pci9118.c |  178 +++++++++++++-------------
 1 files changed, 92 insertions(+), 86 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci9118.c b/drivers/staging/comedi/drivers/adl_pci9118.c
index 5b84573..dd9dfec 100644
--- a/drivers/staging/comedi/drivers/adl_pci9118.c
+++ b/drivers/staging/comedi/drivers/adl_pci9118.c
@@ -221,10 +221,6 @@ static const struct comedi_lrange range_pci9118hg = { 8, {
 					 * of BIP/UNI ranges
 					 */
 
-static int pci9118_attach(struct comedi_device *dev,
-			  struct comedi_devconfig *it);
-static int pci9118_detach(struct comedi_device *dev);
-
 struct boardtype {
 	const char *name;		/* board name */
 	int vendor_id;			/* PCI vendor a device ID of card */
@@ -252,79 +248,6 @@ struct boardtype {
 
 };
 
-static DEFINE_PCI_DEVICE_TABLE(pci9118_pci_table) = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_AMCC, 0x80d9) },
-	{ 0 }
-};
-
-MODULE_DEVICE_TABLE(pci, pci9118_pci_table);
-
-static const struct boardtype boardtypes[] = {
-	{"pci9118dg", PCI_VENDOR_ID_AMCC, 0x80d9,
-	 AMCC_OP_REG_SIZE, IORANGE_9118,
-	 16, 8, 256, PCI9118_CHANLEN, 2, 0x0fff, 0x0fff,
-	 &range_pci9118dg_hr, &range_bipolar10,
-	 3000, 12, 512},
-	{"pci9118hg", PCI_VENDOR_ID_AMCC, 0x80d9,
-	 AMCC_OP_REG_SIZE, IORANGE_9118,
-	 16, 8, 256, PCI9118_CHANLEN, 2, 0x0fff, 0x0fff,
-	 &range_pci9118hg, &range_bipolar10,
-	 3000, 12, 512},
-	{"pci9118hr", PCI_VENDOR_ID_AMCC, 0x80d9,
-	 AMCC_OP_REG_SIZE, IORANGE_9118,
-	 16, 8, 256, PCI9118_CHANLEN, 2, 0xffff, 0x0fff,
-	 &range_pci9118dg_hr, &range_bipolar10,
-	 10000, 40, 512},
-};
-
-static struct comedi_driver driver_pci9118 = {
-	.driver_name = "adl_pci9118",
-	.module = THIS_MODULE,
-	.attach = pci9118_attach,
-	.detach = pci9118_detach,
-	.num_names = ARRAY_SIZE(boardtypes),
-	.board_name = &boardtypes[0].name,
-	.offset = sizeof(struct boardtype),
-};
-
-static int __devinit driver_pci9118_pci_probe(struct pci_dev *dev,
-					      const struct pci_device_id *ent)
-{
-	return comedi_pci_auto_config(dev, &driver_pci9118);
-}
-
-static void __devexit driver_pci9118_pci_remove(struct pci_dev *dev)
-{
-	comedi_pci_auto_unconfig(dev);
-}
-
-static struct pci_driver driver_pci9118_pci_driver = {
-	.id_table = pci9118_pci_table,
-	.probe = &driver_pci9118_pci_probe,
-	.remove = __devexit_p(&driver_pci9118_pci_remove)
-};
-
-static int __init driver_pci9118_init_module(void)
-{
-	int retval;
-
-	retval = comedi_driver_register(&driver_pci9118);
-	if (retval < 0)
-		return retval;
-
-	driver_pci9118_pci_driver.name = (char *)driver_pci9118.driver_name;
-	return pci_register_driver(&driver_pci9118_pci_driver);
-}
-
-static void __exit driver_pci9118_cleanup_module(void)
-{
-	pci_unregister_driver(&driver_pci9118_pci_driver);
-	comedi_driver_unregister(&driver_pci9118);
-}
-
-module_init(driver_pci9118_init_module);
-module_exit(driver_pci9118_cleanup_module);
-
 struct pci9118_private {
 	unsigned long iobase_a;	/* base+size for AMCC chip */
 	unsigned int master;	/* master capable */
@@ -2188,9 +2111,6 @@ static int pci9118_reset(struct comedi_device *dev)
 	return 0;
 }
 
-/*
-==============================================================================
-*/
 static int pci9118_attach(struct comedi_device *dev,
 			  struct comedi_devconfig *it)
 {
@@ -2433,9 +2353,6 @@ static int pci9118_attach(struct comedi_device *dev,
 	return 0;
 }
 
-/*
-==============================================================================
-*/
 static int pci9118_detach(struct comedi_device *dev)
 {
 	if (dev->private) {
@@ -2460,9 +2377,98 @@ static int pci9118_detach(struct comedi_device *dev)
 	return 0;
 }
 
-/*
-==============================================================================
-*/
+static const struct boardtype boardtypes[] = {
+	{
+		.name		= "pci9118dg",
+		.vendor_id	= PCI_VENDOR_ID_AMCC,
+		.device_id	= 0x80d9,
+		.iorange_amcc	= AMCC_OP_REG_SIZE,
+		.iorange_9118	= IORANGE_9118,
+		.n_aichan	= 16,
+		.n_aichand	= 8,
+		.mux_aichan	= 256,
+		.n_aichanlist	= PCI9118_CHANLEN,
+		.n_aochan	= 2,
+		.ai_maxdata	= 0x0fff,
+		.ao_maxdata	= 0x0fff,
+		.rangelist_ai	= &range_pci9118dg_hr,
+		.rangelist_ao	= &range_bipolar10,
+		.ai_ns_min	= 3000,
+		.ai_pacer_min	= 12,
+		.half_fifo_size	= 512,
+	}, {
+		.name		= "pci9118hg",
+		.vendor_id	= PCI_VENDOR_ID_AMCC,
+		.device_id	= 0x80d9,
+		.iorange_amcc	= AMCC_OP_REG_SIZE,
+		.iorange_9118	= IORANGE_9118,
+		.n_aichan	= 16,
+		.n_aichand	= 8,
+		.mux_aichan	= 256,
+		.n_aichanlist	= PCI9118_CHANLEN,
+		.n_aochan	= 2,
+		.ai_maxdata	= 0x0fff,
+		.ao_maxdata	= 0x0fff,
+		.rangelist_ai	= &range_pci9118hg,
+		.rangelist_ao	= &range_bipolar10,
+		.ai_ns_min	= 3000,
+		.ai_pacer_min	= 12,
+		.half_fifo_size	= 512,
+	}, {
+		.name		= "pci9118hr",
+		.vendor_id	= PCI_VENDOR_ID_AMCC,
+		.device_id	= 0x80d9,
+		.iorange_amcc	= AMCC_OP_REG_SIZE,
+		.iorange_9118	= IORANGE_9118,
+		.n_aichan	= 16,
+		.n_aichand	= 8,
+		.mux_aichan	= 256,
+		.n_aichanlist	= PCI9118_CHANLEN,
+		.n_aochan	= 2,
+		.ai_maxdata	= 0xffff,
+		.ao_maxdata	= 0x0fff,
+		.rangelist_ai	= &range_pci9118dg_hr,
+		.rangelist_ao	= &range_bipolar10,
+		.ai_ns_min	= 10000,
+		.ai_pacer_min	= 40,
+		.half_fifo_size	= 512,
+	},
+};
+
+static struct comedi_driver adl_pci9118_driver = {
+	.driver_name	= "adl_pci9118",
+	.module		= THIS_MODULE,
+	.attach		= pci9118_attach,
+	.detach		= pci9118_detach,
+	.num_names	= ARRAY_SIZE(boardtypes),
+	.board_name	= &boardtypes[0].name,
+	.offset		= sizeof(struct boardtype),
+};
+
+static int __devinit adl_pci9118_pci_probe(struct pci_dev *dev,
+					   const struct pci_device_id *ent)
+{
+	return comedi_pci_auto_config(dev, &adl_pci9118_driver);
+}
+
+static void __devexit adl_pci9118_pci_remove(struct pci_dev *dev)
+{
+	comedi_pci_auto_unconfig(dev);
+}
+
+static DEFINE_PCI_DEVICE_TABLE(adl_pci9118_pci_table) = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMCC, 0x80d9) },
+	{ 0 }
+};
+MODULE_DEVICE_TABLE(pci, adl_pci9118_pci_table);
+
+static struct pci_driver adl_pci9118_pci_driver = {
+	.name		= "adl_pci9118",
+	.id_table	= adl_pci9118_pci_table,
+	.probe		= adl_pci9118_pci_probe,
+	.remove		= __devexit_p(adl_pci9118_pci_remove),
+};
+module_comedi_pci_driver(adl_pci9118_driver, adl_pci9118_pci_driver);
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
