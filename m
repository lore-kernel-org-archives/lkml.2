Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798Ab2FHSjT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 14:39:19 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:43816 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817Ab2FHSjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 14:39:17 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        Frank Mori Hess <fmhess@users.sourceforge.net>,
        Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH] staging: comedi: das08: Reduce conditional compilation
Date: Fri, 8 Jun 2012 19:38:58 +0100
Message-ID: <1339180738-4507-1-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <4FD24467.5030202@mev.co.uk>
References: <4FD24467.5030202@mev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This code is used by some combination of the CONFIG_COMEDI_DAS08_CS,
CONFIG_COMEDI_DAS08_ISA, and CONFIG_COMEDI_DAS08_PCI and contains a lot
of conditional compilation.

Remove most of the conditional compilation, relying on the compiler to
optimize out unused static functions and data.  Use the '__maybe_unused'
tag for those functions that cause compiler warnings as a result of
this.

Also change the DO_COMEDI_DRIVER_REGISTER macro from a conditionally
defined macro to a manifest constant macro to allow it to be tested
outside the preprocessor (although this is not currently needed).

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
v2: Add test to top of das08_attach_pci() to allow compiler to optimize
most of it out if CONFIG_COMEDI_DAS08_PCI is not enabled.
---
 drivers/staging/comedi/drivers/das08.c |   74 +++++++++++++-------------------
 1 files changed, 30 insertions(+), 44 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das08.c b/drivers/staging/comedi/drivers/das08.c
index fa2784d..f99f72b 100644
--- a/drivers/staging/comedi/drivers/das08.c
+++ b/drivers/staging/comedi/drivers/das08.c
@@ -60,9 +60,9 @@
 
 #define DRV_NAME "das08"
 
-#if IS_ENABLED(CONFIG_COMEDI_DAS08_ISA) || IS_ENABLED(CONFIG_COMEDI_DAS08_PCI)
-#define DO_COMEDI_DRIVER_REGISTER
-#endif
+#define DO_COMEDI_DRIVER_REGISTER \
+	(IS_ENABLED(CONFIG_COMEDI_DAS08_ISA) || \
+	 IS_ENABLED(CONFIG_COMEDI_DAS08_PCI))
 
 #define PCI_VENDOR_ID_COMPUTERBOARDS 0x1307
 #define PCI_DEVICE_ID_PCIDAS08 0x29
@@ -341,22 +341,19 @@ static int das08_do_wbits(struct comedi_device *dev, struct comedi_subdevice *s,
 	return 2;
 }
 
-#if IS_ENABLED(CONFIG_COMEDI_DAS08_ISA)
-static int das08jr_di_rbits(struct comedi_device *dev,
-			    struct comedi_subdevice *s,
-			    struct comedi_insn *insn, unsigned int *data)
+static int __maybe_unused
+das08jr_di_rbits(struct comedi_device *dev, struct comedi_subdevice *s,
+		 struct comedi_insn *insn, unsigned int *data)
 {
 	data[0] = 0;
 	data[1] = inb(dev->iobase + DAS08JR_DIO);
 
 	return 2;
 }
-#endif
 
-#if IS_ENABLED(CONFIG_COMEDI_DAS08_ISA)
-static int das08jr_do_wbits(struct comedi_device *dev,
-			    struct comedi_subdevice *s,
-			    struct comedi_insn *insn, unsigned int *data)
+static int __maybe_unused
+das08jr_do_wbits(struct comedi_device *dev, struct comedi_subdevice *s,
+		 struct comedi_insn *insn, unsigned int *data)
 {
 	struct das08_private_struct *devpriv = dev->private;
 
@@ -370,12 +367,10 @@ static int das08jr_do_wbits(struct comedi_device *dev,
 
 	return 2;
 }
-#endif
 
-#if IS_ENABLED(CONFIG_COMEDI_DAS08_ISA)
-static int das08jr_ao_winsn(struct comedi_device *dev,
-			    struct comedi_subdevice *s,
-			    struct comedi_insn *insn, unsigned int *data)
+static int __maybe_unused
+das08jr_ao_winsn(struct comedi_device *dev, struct comedi_subdevice *s,
+		 struct comedi_insn *insn, unsigned int *data)
 {
 	int n;
 	int lsb, msb;
@@ -401,7 +396,6 @@ static int das08jr_ao_winsn(struct comedi_device *dev,
 
 	return n;
 }
-#endif
 
 /*
  *
@@ -409,10 +403,9 @@ static int das08jr_ao_winsn(struct comedi_device *dev,
  * a different method to force an update.
  *
  */
-#if IS_ENABLED(CONFIG_COMEDI_DAS08_ISA)
-static int das08ao_ao_winsn(struct comedi_device *dev,
-			    struct comedi_subdevice *s,
-			    struct comedi_insn *insn, unsigned int *data)
+static int __maybe_unused
+das08ao_ao_winsn(struct comedi_device *dev, struct comedi_subdevice *s,
+		 struct comedi_insn *insn, unsigned int *data)
 {
 	int n;
 	int lsb, msb;
@@ -438,7 +431,6 @@ static int das08ao_ao_winsn(struct comedi_device *dev,
 
 	return n;
 }
-#endif
 
 static unsigned int i8254_read_channel_low(unsigned int base, int chan)
 {
@@ -570,7 +562,7 @@ static int das08_counter_config(struct comedi_device *dev,
 	return 2;
 }
 
-#ifdef DO_COMEDI_DRIVER_REGISTER
+#if DO_COMEDI_DRIVER_REGISTER
 static const struct das08_board_struct das08_boards[] = {
 #if IS_ENABLED(CONFIG_COMEDI_DAS08_ISA)
 	{
@@ -943,7 +935,6 @@ int das08_common_attach(struct comedi_device *dev, unsigned long iobase)
 }
 EXPORT_SYMBOL_GPL(das08_common_attach);
 
-#if IS_ENABLED(CONFIG_COMEDI_DAS08_PCI)
 static int das08_pci_attach_common(struct comedi_device *dev,
 				   struct pci_dev *pdev)
 {
@@ -951,6 +942,9 @@ static int das08_pci_attach_common(struct comedi_device *dev,
 	unsigned long pci_iobase;
 	struct das08_private_struct *devpriv = dev->private;
 
+	if (!IS_ENABLED(CONFIG_COMEDI_DAS08_PCI))
+		return -EINVAL;
+
 	devpriv->pdev = pdev;
 	/*  enable PCI device and reserve I/O spaces */
 	if (comedi_pci_enable(pdev, dev->driver->driver_name)) {
@@ -977,28 +971,28 @@ static int das08_pci_attach_common(struct comedi_device *dev,
 #endif
 	return das08_common_attach(dev, iobase);
 }
-#endif
 
-#if IS_ENABLED(CONFIG_COMEDI_DAS08_PCI)
 static const struct das08_board_struct *
 das08_find_pci_board(struct pci_dev *pdev)
 {
+#if DO_COMEDI_DRIVER_REGISTER
 	unsigned int i;
 	for (i = 0; i < ARRAY_SIZE(das08_boards); i++)
 		if (das08_boards[i].bustype == pci &&
 		    pdev->device == das08_boards[i].id)
 			return &das08_boards[i];
+#endif
 	return NULL;
 }
-#endif
 
-#if IS_ENABLED(CONFIG_COMEDI_DAS08_PCI)
 /* only called in the PCI probe path, via comedi_pci_auto_config() */
-static int __devinit das08_attach_pci(struct comedi_device *dev,
-				   struct pci_dev *pdev)
+static int __devinit __maybe_unused
+das08_attach_pci(struct comedi_device *dev, struct pci_dev *pdev)
 {
 	int ret;
 
+	if (!IS_ENABLED(CONFIG_COMEDI_DAS08_PCI))
+		return -EINVAL;
 	ret = alloc_private(dev, sizeof(struct das08_private_struct));
 	if (ret < 0)
 		return ret;
@@ -1010,9 +1004,7 @@ static int __devinit das08_attach_pci(struct comedi_device *dev,
 	}
 	return das08_pci_attach_common(dev, pdev);
 }
-#endif
 
-#if IS_ENABLED(CONFIG_COMEDI_DAS08_PCI)
 static struct pci_dev *das08_find_pci(struct comedi_device *dev,
 				      int bus, int slot)
 {
@@ -1063,10 +1055,9 @@ static struct pci_dev *das08_find_pci(struct comedi_device *dev,
 			thisboard->name);
 	return NULL;
 }
-#endif
 
-#ifdef DO_COMEDI_DRIVER_REGISTER
-static int das08_attach(struct comedi_device *dev, struct comedi_devconfig *it)
+static int __maybe_unused
+das08_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
 	const struct das08_board_struct *thisboard = comedi_board(dev);
 	struct das08_private_struct *devpriv;
@@ -1097,7 +1088,6 @@ static int das08_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	} else
 		return -EIO;
 }
-#endif /* DO_COMEDI_DRIVER_REGISTER */
 
 void das08_common_detach(struct comedi_device *dev)
 {
@@ -1106,8 +1096,7 @@ void das08_common_detach(struct comedi_device *dev)
 }
 EXPORT_SYMBOL_GPL(das08_common_detach);
 
-#ifdef DO_COMEDI_DRIVER_REGISTER
-static void das08_detach(struct comedi_device *dev)
+static void __maybe_unused das08_detach(struct comedi_device *dev)
 {
 	const struct das08_board_struct *thisboard = comedi_board(dev);
 	struct das08_private_struct *devpriv = dev->private;
@@ -1126,16 +1115,13 @@ static void das08_detach(struct comedi_device *dev)
 		}
 	}
 }
-#endif /* DO_COMEDI_DRIVER_REGISTER */
 
-#ifdef DO_COMEDI_DRIVER_REGISTER
+#if DO_COMEDI_DRIVER_REGISTER
 static struct comedi_driver das08_driver = {
 	.driver_name = DRV_NAME,
 	.module = THIS_MODULE,
 	.attach = das08_attach,
-#if IS_ENABLED(CONFIG_COMEDI_DAS08_PCI)
 	.attach_pci = das08_attach_pci,
-#endif
 	.detach = das08_detach,
 	.board_name = &das08_boards[0].name,
 	.num_names = sizeof(das08_boards) / sizeof(struct das08_board_struct),
@@ -1170,7 +1156,7 @@ static struct pci_driver das08_pci_driver = {
 };
 #endif /* CONFIG_COMEDI_DAS08_PCI */
 
-#ifdef DO_COMEDI_DRIVER_REGISTER
+#if DO_COMEDI_DRIVER_REGISTER
 #if IS_ENABLED(CONFIG_COMEDI_DAS08_PCI)
 module_comedi_pci_driver(das08_driver, das08_pci_driver);
 #else
-- 
1.7.8.6

