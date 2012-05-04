Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760548Ab2EDWvp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 18:51:45 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:23268 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755999Ab2EDWvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 18:51:44 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-6.tower-132.messagelabs.com!1336171871!10618789!12
X-Originating-IP: [216.166.12.69]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: refactor me4000 driver to remove forward declarations
Date: Fri, 4 May 2012 15:51:25 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205041551.25700.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the struct comedi_driver, attach/detach functions, and
associated variables to the end of the source. This is more
typical of how other drivers are written and removes the need
for most of the forward declarations.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

diff --git a/drivers/staging/comedi/drivers/me4000.c b/drivers/staging/comedi/drivers/me4000.c
index 54bcacc..c54c071 100644
--- a/drivers/staging/comedi/drivers/me4000.c
+++ b/drivers/staging/comedi/drivers/me4000.c
@@ -65,30 +65,6 @@ broken.
 #include "me4000_fw.h"
 #endif
 
-/*=============================================================================
-  PCI device table.
-  This is used by modprobe to translate PCI IDs to drivers.
-  ===========================================================================*/
-
-static DEFINE_PCI_DEVICE_TABLE(me4000_pci_table) = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_MEILHAUS, 0x4650) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_MEILHAUS, 0x4660) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_MEILHAUS, 0x4661) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_MEILHAUS, 0x4662) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_MEILHAUS, 0x4663) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_MEILHAUS, 0x4670) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_MEILHAUS, 0x4671) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_MEILHAUS, 0x4672) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_MEILHAUS, 0x4673) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_MEILHAUS, 0x4680) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_MEILHAUS, 0x4681) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_MEILHAUS, 0x4682) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_MEILHAUS, 0x4683) },
-	{ 0 }
-};
-
-MODULE_DEVICE_TABLE(pci, me4000_pci_table);
-
 static const struct me4000_board me4000_boards[] = {
 	{"ME-4650", 0x4650, {0, 0}, {16, 0, 0, 0}, {4}, {0} },
 
@@ -113,22 +89,8 @@ static const struct me4000_board me4000_boards[] = {
 #define ME4000_BOARD_VERSIONS (ARRAY_SIZE(me4000_boards) - 1)
 
 /*-----------------------------------------------------------------------------
-  Comedi function prototypes
-  ---------------------------------------------------------------------------*/
-static int me4000_attach(struct comedi_device *dev,
-			 struct comedi_devconfig *it);
-static int me4000_detach(struct comedi_device *dev);
-static struct comedi_driver driver_me4000 = {
-	.driver_name = "me4000",
-	.module = THIS_MODULE,
-	.attach = me4000_attach,
-	.detach = me4000_detach,
-};
-
-/*-----------------------------------------------------------------------------
   Meilhaus function prototypes
   ---------------------------------------------------------------------------*/
-static int me4000_probe(struct comedi_device *dev, struct comedi_devconfig *it);
 static int get_registers(struct comedi_device *dev, struct pci_dev *pci_dev_p);
 static int init_board_info(struct comedi_device *dev,
 			   struct pci_dev *pci_dev_p);
@@ -139,76 +101,10 @@ static int init_cnt_context(struct comedi_device *dev);
 static int xilinx_download(struct comedi_device *dev);
 static int reset_board(struct comedi_device *dev);
 
-static int me4000_dio_insn_bits(struct comedi_device *dev,
-				struct comedi_subdevice *s,
-				struct comedi_insn *insn, unsigned int *data);
-
-static int me4000_dio_insn_config(struct comedi_device *dev,
-				  struct comedi_subdevice *s,
-				  struct comedi_insn *insn, unsigned int *data);
-
-static int cnt_reset(struct comedi_device *dev, unsigned int channel);
-
-static int cnt_config(struct comedi_device *dev,
-		      unsigned int channel, unsigned int mode);
-
-static int me4000_cnt_insn_config(struct comedi_device *dev,
-				  struct comedi_subdevice *s,
-				  struct comedi_insn *insn, unsigned int *data);
-
-static int me4000_cnt_insn_write(struct comedi_device *dev,
-				 struct comedi_subdevice *s,
-				 struct comedi_insn *insn, unsigned int *data);
-
-static int me4000_cnt_insn_read(struct comedi_device *dev,
-				struct comedi_subdevice *s,
-				struct comedi_insn *insn, unsigned int *data);
-
-static int me4000_ai_insn_read(struct comedi_device *dev,
-			       struct comedi_subdevice *subdevice,
-			       struct comedi_insn *insn, unsigned int *data);
-
-static int me4000_ai_cancel(struct comedi_device *dev,
-			    struct comedi_subdevice *s);
-
-static int ai_check_chanlist(struct comedi_device *dev,
-			     struct comedi_subdevice *s,
-			     struct comedi_cmd *cmd);
-
-static int ai_round_cmd_args(struct comedi_device *dev,
-			     struct comedi_subdevice *s,
-			     struct comedi_cmd *cmd,
-			     unsigned int *init_ticks,
-			     unsigned int *scan_ticks,
-			     unsigned int *chan_ticks);
-
-static int ai_prepare(struct comedi_device *dev,
-		      struct comedi_subdevice *s,
-		      struct comedi_cmd *cmd,
-		      unsigned int init_ticks,
-		      unsigned int scan_ticks, unsigned int chan_ticks);
-
 static int ai_write_chanlist(struct comedi_device *dev,
 			     struct comedi_subdevice *s,
 			     struct comedi_cmd *cmd);
 
-static irqreturn_t me4000_ai_isr(int irq, void *dev_id);
-
-static int me4000_ai_do_cmd_test(struct comedi_device *dev,
-				 struct comedi_subdevice *s,
-				 struct comedi_cmd *cmd);
-
-static int me4000_ai_do_cmd(struct comedi_device *dev,
-			    struct comedi_subdevice *s);
-
-static int me4000_ao_insn_write(struct comedi_device *dev,
-				struct comedi_subdevice *s,
-				struct comedi_insn *insn, unsigned int *data);
-
-static int me4000_ao_insn_read(struct comedi_device *dev,
-			       struct comedi_subdevice *s,
-			       struct comedi_insn *insn, unsigned int *data);
-
 /*-----------------------------------------------------------------------------
   Meilhaus inline functions
   ---------------------------------------------------------------------------*/
@@ -262,130 +158,6 @@ static const struct comedi_lrange me4000_ao_range = {
 	 }
 };
 
-static int me4000_attach(struct comedi_device *dev, struct comedi_devconfig *it)
-{
-	struct comedi_subdevice *s;
-	int result;
-
-	CALL_PDEBUG("In me4000_attach()\n");
-
-	result = me4000_probe(dev, it);
-	if (result)
-		return result;
-
-	/*
-	 * Allocate the subdevice structures.  alloc_subdevice() is a
-	 * convenient macro defined in comedidev.h.  It relies on
-	 * n_subdevices being set correctly.
-	 */
-	if (alloc_subdevices(dev, 4) < 0)
-		return -ENOMEM;
-
-    /*=========================================================================
-      Analog input subdevice
-      ========================================================================*/
-
-	s = dev->subdevices + 0;
-
-	if (thisboard->ai.count) {
-		s->type = COMEDI_SUBD_AI;
-		s->subdev_flags =
-		    SDF_READABLE | SDF_COMMON | SDF_GROUND | SDF_DIFF;
-		s->n_chan = thisboard->ai.count;
-		s->maxdata = 0xFFFF;	/*  16 bit ADC */
-		s->len_chanlist = ME4000_AI_CHANNEL_LIST_COUNT;
-		s->range_table = &me4000_ai_range;
-		s->insn_read = me4000_ai_insn_read;
-
-		if (info->irq > 0) {
-			if (request_irq(info->irq, me4000_ai_isr,
-					IRQF_SHARED, "ME-4000", dev)) {
-				printk
-				    ("comedi%d: me4000: me4000_attach(): "
-				     "Unable to allocate irq\n", dev->minor);
-			} else {
-				dev->read_subdev = s;
-				s->subdev_flags |= SDF_CMD_READ;
-				s->cancel = me4000_ai_cancel;
-				s->do_cmdtest = me4000_ai_do_cmd_test;
-				s->do_cmd = me4000_ai_do_cmd;
-			}
-		} else {
-			printk(KERN_WARNING
-			       "comedi%d: me4000: me4000_attach(): "
-			       "No interrupt available\n", dev->minor);
-		}
-	} else {
-		s->type = COMEDI_SUBD_UNUSED;
-	}
-
-    /*=========================================================================
-      Analog output subdevice
-      ========================================================================*/
-
-	s = dev->subdevices + 1;
-
-	if (thisboard->ao.count) {
-		s->type = COMEDI_SUBD_AO;
-		s->subdev_flags = SDF_WRITEABLE | SDF_COMMON | SDF_GROUND;
-		s->n_chan = thisboard->ao.count;
-		s->maxdata = 0xFFFF;	/*  16 bit DAC */
-		s->range_table = &me4000_ao_range;
-		s->insn_write = me4000_ao_insn_write;
-		s->insn_read = me4000_ao_insn_read;
-	} else {
-		s->type = COMEDI_SUBD_UNUSED;
-	}
-
-    /*=========================================================================
-      Digital I/O subdevice
-      ========================================================================*/
-
-	s = dev->subdevices + 2;
-
-	if (thisboard->dio.count) {
-		s->type = COMEDI_SUBD_DIO;
-		s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
-		s->n_chan = thisboard->dio.count * 8;
-		s->maxdata = 1;
-		s->range_table = &range_digital;
-		s->insn_bits = me4000_dio_insn_bits;
-		s->insn_config = me4000_dio_insn_config;
-	} else {
-		s->type = COMEDI_SUBD_UNUSED;
-	}
-
-	/*
-	 * Check for optoisolated ME-4000 version. If one the first
-	 * port is a fixed output port and the second is a fixed input port.
-	 */
-	if (!me4000_inl(dev, info->dio_context.dir_reg)) {
-		s->io_bits |= 0xFF;
-		me4000_outl(dev, ME4000_DIO_CTRL_BIT_MODE_0,
-			    info->dio_context.dir_reg);
-	}
-
-    /*=========================================================================
-      Counter subdevice
-      ========================================================================*/
-
-	s = dev->subdevices + 3;
-
-	if (thisboard->cnt.count) {
-		s->type = COMEDI_SUBD_COUNTER;
-		s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
-		s->n_chan = thisboard->cnt.count;
-		s->maxdata = 0xFFFF;	/*  16 bit counters */
-		s->insn_read = me4000_cnt_insn_read;
-		s->insn_write = me4000_cnt_insn_write;
-		s->insn_config = me4000_cnt_insn_config;
-	} else {
-		s->type = COMEDI_SUBD_UNUSED;
-	}
-
-	return 0;
-}
-
 static int me4000_probe(struct comedi_device *dev, struct comedi_devconfig *it)
 {
 	struct pci_dev *pci_device = NULL;
@@ -920,22 +692,6 @@ static int reset_board(struct comedi_device *dev)
 	return 0;
 }
 
-static int me4000_detach(struct comedi_device *dev)
-{
-	CALL_PDEBUG("In me4000_detach()\n");
-
-	if (info) {
-		if (info->pci_dev_p) {
-			reset_board(dev);
-			if (info->plx_regbase)
-				comedi_pci_disable(info->pci_dev_p);
-			pci_dev_put(info->pci_dev_p);
-		}
-	}
-
-	return 0;
-}
-
 /*=============================================================================
   Analog input section
   ===========================================================================*/
@@ -2424,6 +2180,153 @@ static int me4000_cnt_insn_write(struct comedi_device *dev,
 	return 1;
 }
 
+static int me4000_attach(struct comedi_device *dev, struct comedi_devconfig *it)
+{
+	struct comedi_subdevice *s;
+	int result;
+
+	CALL_PDEBUG("In me4000_attach()\n");
+
+	result = me4000_probe(dev, it);
+	if (result)
+		return result;
+
+	/*
+	 * Allocate the subdevice structures.  alloc_subdevice() is a
+	 * convenient macro defined in comedidev.h.  It relies on
+	 * n_subdevices being set correctly.
+	 */
+	if (alloc_subdevices(dev, 4) < 0)
+		return -ENOMEM;
+
+    /*=========================================================================
+      Analog input subdevice
+      ========================================================================*/
+
+	s = dev->subdevices + 0;
+
+	if (thisboard->ai.count) {
+		s->type = COMEDI_SUBD_AI;
+		s->subdev_flags =
+		    SDF_READABLE | SDF_COMMON | SDF_GROUND | SDF_DIFF;
+		s->n_chan = thisboard->ai.count;
+		s->maxdata = 0xFFFF;	/*  16 bit ADC */
+		s->len_chanlist = ME4000_AI_CHANNEL_LIST_COUNT;
+		s->range_table = &me4000_ai_range;
+		s->insn_read = me4000_ai_insn_read;
+
+		if (info->irq > 0) {
+			if (request_irq(info->irq, me4000_ai_isr,
+					IRQF_SHARED, "ME-4000", dev)) {
+				printk
+				    ("comedi%d: me4000: me4000_attach(): "
+				     "Unable to allocate irq\n", dev->minor);
+			} else {
+				dev->read_subdev = s;
+				s->subdev_flags |= SDF_CMD_READ;
+				s->cancel = me4000_ai_cancel;
+				s->do_cmdtest = me4000_ai_do_cmd_test;
+				s->do_cmd = me4000_ai_do_cmd;
+			}
+		} else {
+			printk(KERN_WARNING
+			       "comedi%d: me4000: me4000_attach(): "
+			       "No interrupt available\n", dev->minor);
+		}
+	} else {
+		s->type = COMEDI_SUBD_UNUSED;
+	}
+
+    /*=========================================================================
+      Analog output subdevice
+      ========================================================================*/
+
+	s = dev->subdevices + 1;
+
+	if (thisboard->ao.count) {
+		s->type = COMEDI_SUBD_AO;
+		s->subdev_flags = SDF_WRITEABLE | SDF_COMMON | SDF_GROUND;
+		s->n_chan = thisboard->ao.count;
+		s->maxdata = 0xFFFF;	/*  16 bit DAC */
+		s->range_table = &me4000_ao_range;
+		s->insn_write = me4000_ao_insn_write;
+		s->insn_read = me4000_ao_insn_read;
+	} else {
+		s->type = COMEDI_SUBD_UNUSED;
+	}
+
+    /*=========================================================================
+      Digital I/O subdevice
+      ========================================================================*/
+
+	s = dev->subdevices + 2;
+
+	if (thisboard->dio.count) {
+		s->type = COMEDI_SUBD_DIO;
+		s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
+		s->n_chan = thisboard->dio.count * 8;
+		s->maxdata = 1;
+		s->range_table = &range_digital;
+		s->insn_bits = me4000_dio_insn_bits;
+		s->insn_config = me4000_dio_insn_config;
+	} else {
+		s->type = COMEDI_SUBD_UNUSED;
+	}
+
+	/*
+	 * Check for optoisolated ME-4000 version. If one the first
+	 * port is a fixed output port and the second is a fixed input port.
+	 */
+	if (!me4000_inl(dev, info->dio_context.dir_reg)) {
+		s->io_bits |= 0xFF;
+		me4000_outl(dev, ME4000_DIO_CTRL_BIT_MODE_0,
+			    info->dio_context.dir_reg);
+	}
+
+    /*=========================================================================
+      Counter subdevice
+      ========================================================================*/
+
+	s = dev->subdevices + 3;
+
+	if (thisboard->cnt.count) {
+		s->type = COMEDI_SUBD_COUNTER;
+		s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
+		s->n_chan = thisboard->cnt.count;
+		s->maxdata = 0xFFFF;	/*  16 bit counters */
+		s->insn_read = me4000_cnt_insn_read;
+		s->insn_write = me4000_cnt_insn_write;
+		s->insn_config = me4000_cnt_insn_config;
+	} else {
+		s->type = COMEDI_SUBD_UNUSED;
+	}
+
+	return 0;
+}
+
+static int me4000_detach(struct comedi_device *dev)
+{
+	CALL_PDEBUG("In me4000_detach()\n");
+
+	if (info) {
+		if (info->pci_dev_p) {
+			reset_board(dev);
+			if (info->plx_regbase)
+				comedi_pci_disable(info->pci_dev_p);
+			pci_dev_put(info->pci_dev_p);
+		}
+	}
+
+	return 0;
+}
+
+static struct comedi_driver driver_me4000 = {
+	.driver_name	= "me4000",
+	.module		= THIS_MODULE,
+	.attach		= me4000_attach,
+	.detach		= me4000_detach,
+};
+
 static int __devinit driver_me4000_pci_probe(struct pci_dev *dev,
 					     const struct pci_device_id *ent)
 {
@@ -2435,10 +2338,28 @@ static void __devexit driver_me4000_pci_remove(struct pci_dev *dev)
 	comedi_pci_auto_unconfig(dev);
 }
 
+static DEFINE_PCI_DEVICE_TABLE(me4000_pci_table) = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_MEILHAUS, 0x4650) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_MEILHAUS, 0x4660) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_MEILHAUS, 0x4661) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_MEILHAUS, 0x4662) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_MEILHAUS, 0x4663) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_MEILHAUS, 0x4670) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_MEILHAUS, 0x4671) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_MEILHAUS, 0x4672) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_MEILHAUS, 0x4673) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_MEILHAUS, 0x4680) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_MEILHAUS, 0x4681) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_MEILHAUS, 0x4682) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_MEILHAUS, 0x4683) },
+	{ 0 }
+};
+MODULE_DEVICE_TABLE(pci, me4000_pci_table);
+
 static struct pci_driver driver_me4000_pci_driver = {
-	.id_table = me4000_pci_table,
-	.probe = &driver_me4000_pci_probe,
-	.remove = __devexit_p(&driver_me4000_pci_remove)
+	.id_table	= me4000_pci_table,
+	.probe		= driver_me4000_pci_probe,
+	.remove		= __devexit_p(driver_me4000_pci_remove),
 };
 
 static int __init driver_me4000_init_module(void)
@@ -2452,14 +2373,13 @@ static int __init driver_me4000_init_module(void)
 	driver_me4000_pci_driver.name = (char *)driver_me4000.driver_name;
 	return pci_register_driver(&driver_me4000_pci_driver);
 }
+module_init(driver_me4000_init_module);
 
 static void __exit driver_me4000_cleanup_module(void)
 {
 	pci_unregister_driver(&driver_me4000_pci_driver);
 	comedi_driver_unregister(&driver_me4000);
 }
-
-module_init(driver_me4000_init_module);
 module_exit(driver_me4000_cleanup_module);
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
