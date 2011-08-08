Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557Ab1HHXcQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 19:32:16 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:46029 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752279Ab1HHXcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 19:32:14 -0400
Date: Mon, 8 Aug 2011 16:32:12 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de,
        driverdevel <devel@driverdev.osuosl.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] staging: fix comedi build errors
Message-Id: <20110808163212.6fb9c484.rdunlap@xenotime.net>
In-Reply-To: <20110808145651.56b9c907d21c5c3ced373701@canb.auug.org.au>
References: <20110808145651.56b9c907d21c5c3ced373701@canb.auug.org.au>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix build errors when CONFIG_COMEDI_PCI_DRIVERS is not enabled
and CONFIG_COMEDI_PCI_DRIVERS was used where CONFIG_ISA_DMA_API
should have been used.

drivers/staging/comedi/drivers/ni_labpc.c: In function 'labpc_ai_cmd':
drivers/staging/comedi/drivers/ni_labpc.c:1351: error: implicit declaration of function 'labpc_suggest_transfer_size'
drivers/staging/comedi/drivers/ni_labpc.c: At top level:
drivers/staging/comedi/drivers/ni_labpc.c:1802: error: conflicting types for 'labpc_suggest_transfer_size'
drivers/staging/comedi/drivers/ni_labpc.c:1351: note: previous implicit declaration of 'labpc_suggest_transfer_size' was here

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 drivers/staging/comedi/drivers/ni_labpc.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

--- linux-next-20110808.orig/drivers/staging/comedi/drivers/ni_labpc.c
+++ linux-next-20110808/drivers/staging/comedi/drivers/ni_labpc.c
@@ -241,8 +241,10 @@ static int labpc_eeprom_write_insn(struc
 				   struct comedi_insn *insn,
 				   unsigned int *data);
 static void labpc_adc_timing(struct comedi_device *dev, struct comedi_cmd *cmd);
-#ifdef CONFIG_COMEDI_PCI
+#ifdef CONFIG_ISA_DMA_API
 static unsigned int labpc_suggest_transfer_size(struct comedi_cmd cmd);
+#endif
+#ifdef CONFIG_COMEDI_PCI_DRIVERS
 static int labpc_find_device(struct comedi_device *dev, int bus, int slot);
 #endif
 static int labpc_dio_mem_callback(int dir, int port, int data,
@@ -459,7 +461,7 @@ static const struct labpc_board_struct l
 	 .ai_scan_up = 0,
 	 .memory_mapped_io = 0,
 	 },
-#ifdef CONFIG_COMEDI_PCI
+#ifdef CONFIG_COMEDI_PCI_DRIVERS
 	{
 	 .name = "pci-1200",
 	 .device_id = 0x161,
@@ -503,14 +505,14 @@ static struct comedi_driver driver_labpc
 	.offset = sizeof(struct labpc_board_struct),
 };
 
-#ifdef CONFIG_COMEDI_PCI
+#ifdef CONFIG_COMEDI_PCI_DRIVERS
 static DEFINE_PCI_DEVICE_TABLE(labpc_pci_table) = {
 	{PCI_DEVICE(PCI_VENDOR_ID_NI, 0x161)},
 	{0}
 };
 
 MODULE_DEVICE_TABLE(pci, labpc_pci_table);
-#endif /* CONFIG_COMEDI_PCI */
+#endif /* CONFIG_COMEDI_PCI_DRIVERS */
 
 static inline int labpc_counter_load(struct comedi_device *dev,
 				     unsigned long base_address,
@@ -720,7 +722,7 @@ static int labpc_attach(struct comedi_de
 	unsigned long iobase = 0;
 	unsigned int irq = 0;
 	unsigned int dma_chan = 0;
-#ifdef CONFIG_COMEDI_PCI
+#ifdef CONFIG_COMEDI_PCI_DRIVERS
 	int retval;
 #endif
 
@@ -742,7 +744,7 @@ static int labpc_attach(struct comedi_de
 #endif
 		break;
 	case pci_bustype:
-#ifdef CONFIG_COMEDI_PCI
+#ifdef CONFIG_COMEDI_PCI_DRIVERS
 		retval = labpc_find_device(dev, it->options[0], it->options[1]);
 		if (retval < 0)
 			return retval;
@@ -772,7 +774,7 @@ static int labpc_attach(struct comedi_de
 }
 
 /* adapted from ni_pcimio for finding mite based boards (pc-1200) */
-#ifdef CONFIG_COMEDI_PCI
+#ifdef CONFIG_COMEDI_PCI_DRIVERS
 static int labpc_find_device(struct comedi_device *dev, int bus, int slot)
 {
 	struct mite_struct *mite;
@@ -820,7 +822,7 @@ int labpc_common_detach(struct comedi_de
 		free_irq(dev->irq, dev);
 	if (thisboard->bustype == isa_bustype && dev->iobase)
 		release_region(dev->iobase, LABPC_SIZE);
-#ifdef CONFIG_COMEDI_PCI
+#ifdef CONFIG_COMEDI_PCI_DRIVERS
 	if (devpriv->mite)
 		mite_unsetup(devpriv->mite);
 #endif
@@ -2135,7 +2137,7 @@ static void write_caldac(struct comedi_d
 	devpriv->write_byte(devpriv->command5_bits, dev->iobase + COMMAND5_REG);
 }
 
-#ifdef CONFIG_COMEDI_PCI
+#ifdef CONFIG_COMEDI_PCI_DRIVERS
 static int __devinit driver_labpc_pci_probe(struct pci_dev *dev,
 					    const struct pci_device_id *ent)
 {
