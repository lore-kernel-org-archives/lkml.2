Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760510Ab0JIVyV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 17:54:21 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:53733 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859Ab0JIVyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 17:54:20 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 9 Oct 2010 23:54:05 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 1/2] ieee1394: move init_ohci1394_dma to drivers/firewire/
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.a80c49c9cfb3380e@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

because drivers/ieee1394/ will be deleted.

Additional changes:
  - add some #include directives
  - adjust to use firewire/ohci.h instead of ieee1394/ohci1394.h,
    replace struct ti_ohci by a minimal struct ohci,
    replace quadlet_t from ieee1394_types.h by u32
  - two or three trivial stylistic changes
  - __iomem annotation

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/Makefile                          |    1 +
 drivers/{ieee1394 => firewire}/init_ohci1394_dma.c |   77 +++++++++++++-------
 drivers/ieee1394/Makefile                          |    2 -
 3 files changed, 52 insertions(+), 28 deletions(-)
 rename drivers/{ieee1394 => firewire}/init_ohci1394_dma.c (84%)

diff --git a/drivers/firewire/Makefile b/drivers/firewire/Makefile
index 3c6a7fb..e3870d5 100644
--- a/drivers/firewire/Makefile
+++ b/drivers/firewire/Makefile
@@ -13,3 +13,4 @@ obj-$(CONFIG_FIREWIRE_OHCI) += firewire-ohci.o
 obj-$(CONFIG_FIREWIRE_SBP2) += firewire-sbp2.o
 obj-$(CONFIG_FIREWIRE_NET)  += firewire-net.o
 obj-$(CONFIG_FIREWIRE_NOSY) += nosy.o
+obj-$(CONFIG_PROVIDE_OHCI1394_DMA_INIT) += init_ohci1394_dma.o
diff --git a/drivers/ieee1394/init_ohci1394_dma.c b/drivers/firewire/init_ohci1394_dma.c
similarity index 84%
rename from drivers/ieee1394/init_ohci1394_dma.c
rename to drivers/firewire/init_ohci1394_dma.c
index ddaab6e..09157a0 100644
--- a/drivers/ieee1394/init_ohci1394_dma.c
+++ b/drivers/firewire/init_ohci1394_dma.c
@@ -32,23 +32,42 @@
  * Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
 
-#include <linux/interrupt.h>	/* for ohci1394.h */
 #include <linux/delay.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
 #include <linux/pci.h>		/* for PCI defines */
-#include <linux/init_ohci1394_dma.h>
+#include <linux/string.h>
+
 #include <asm/pci-direct.h>	/* for direct PCI config space access */
 #include <asm/fixmap.h>
 
-#include "ieee1394_types.h"
-#include "ohci1394.h"
+#include <linux/init_ohci1394_dma.h>
+#include "ohci.h"
 
 int __initdata init_ohci1394_dma_early;
 
+struct ohci {
+	struct pci_dev *dev;
+	void __iomem *registers;
+};
+
+static inline void reg_write(const struct ohci *ohci, int offset, u32 data)
+{
+	writel(data, ohci->registers + offset);
+}
+
+static inline u32 reg_read(const struct ohci *ohci, int offset)
+{
+	return readl(ohci->registers + offset);
+}
+
+#define OHCI_LOOP_COUNT		100	/* Number of loops for reg read waits */
+
 /* Reads a PHY register of an OHCI-1394 controller */
-static inline u8 __init get_phy_reg(struct ti_ohci *ohci, u8 addr)
+static inline u8 __init get_phy_reg(struct ohci *ohci, u8 addr)
 {
 	int i;
-	quadlet_t r;
+	u32 r;
 
 	reg_write(ohci, OHCI1394_PhyControl, (addr << 8) | 0x00008000);
 
@@ -63,22 +82,22 @@ static inline u8 __init get_phy_reg(struct ti_ohci *ohci, u8 addr)
 }
 
 /* Writes to a PHY register of an OHCI-1394 controller */
-static inline void __init set_phy_reg(struct ti_ohci *ohci, u8 addr, u8 data)
+static inline void __init set_phy_reg(struct ohci *ohci, u8 addr, u8 data)
 {
 	int i;
 
 	reg_write(ohci, OHCI1394_PhyControl, (addr << 8) | data | 0x00004000);
 
 	for (i = 0; i < OHCI_LOOP_COUNT; i++) {
-		u32 r = reg_read(ohci, OHCI1394_PhyControl);
-		if (!(r & 0x00004000))
+		if (!(reg_read(ohci, OHCI1394_PhyControl) & 0x00004000))
 			break;
 		mdelay(1);
 	}
 }
 
 /* Resets an OHCI-1394 controller (for sane state before initialization) */
-static inline void __init init_ohci1394_soft_reset(struct ti_ohci *ohci) {
+static inline void __init init_ohci1394_soft_reset(struct ohci *ohci)
+{
 	int i;
 
 	reg_write(ohci, OHCI1394_HCControlSet, OHCI1394_HCControl_softReset);
@@ -91,10 +110,14 @@ static inline void __init init_ohci1394_soft_reset(struct ti_ohci *ohci) {
 	}
 }
 
+#define OHCI1394_MAX_AT_REQ_RETRIES	0xf
+#define OHCI1394_MAX_AT_RESP_RETRIES	0x2
+#define OHCI1394_MAX_PHYS_RESP_RETRIES	0x8
+
 /* Basic OHCI-1394 register and port inititalization */
-static inline void __init init_ohci1394_initialize(struct ti_ohci *ohci)
+static inline void __init init_ohci1394_initialize(struct ohci *ohci)
 {
-	quadlet_t bus_options;
+	u32 bus_options;
 	int num_ports, i;
 
 	/* Put some defaults to these undefined bus options */
@@ -116,7 +139,7 @@ static inline void __init init_ohci1394_initialize(struct ti_ohci *ohci)
 
 	/* enable phys */
 	reg_write(ohci, OHCI1394_LinkControlSet,
-			OHCI1394_LinkControl_RcvPhyPkt);
+			OHCI1394_LinkControl_rcvPhyPkt);
 
 	/* Don't accept phy packets into AR request context */
 	reg_write(ohci, OHCI1394_LinkControlClear, 0x00000400);
@@ -128,7 +151,7 @@ static inline void __init init_ohci1394_initialize(struct ti_ohci *ohci)
 	reg_write(ohci, OHCI1394_IsoXmitIntEventClear, 0xffffffff);
 
 	/* Accept asyncronous transfer requests from all nodes for now */
-	reg_write(ohci,OHCI1394_AsReqFilterHiSet, 0x80000000);
+	reg_write(ohci, OHCI1394_AsReqFilterHiSet, 0x80000000);
 
 	/* Specify asyncronous transfer retries */
 	reg_write(ohci, OHCI1394_ATRetries,
@@ -137,7 +160,8 @@ static inline void __init init_ohci1394_initialize(struct ti_ohci *ohci)
 		  (OHCI1394_MAX_PHYS_RESP_RETRIES<<8));
 
 	/* We don't want hardware swapping */
-	reg_write(ohci, OHCI1394_HCControlClear, OHCI1394_HCControl_noByteSwap);
+	reg_write(ohci, OHCI1394_HCControlClear,
+		  OHCI1394_HCControl_noByteSwapData);
 
 	/* Enable link */
 	reg_write(ohci, OHCI1394_HCControlSet, OHCI1394_HCControl_linkEnable);
@@ -164,11 +188,11 @@ static inline void __init init_ohci1394_initialize(struct ti_ohci *ohci)
  * has to be enabled after each bus reset when needed. We resort
  * to polling here because on early boot, we have no interrupts.
  */
-static inline void __init init_ohci1394_wait_for_busresets(struct ti_ohci *ohci)
+static inline void __init init_ohci1394_wait_for_busresets(struct ohci *ohci)
 {
 	int i, events;
 
-	for (i=0; i < 9; i++) {
+	for (i = 0; i < 9; i++) {
 		mdelay(200);
 		events = reg_read(ohci, OHCI1394_IntEventSet);
 		if (events & OHCI1394_busReset)
@@ -182,18 +206,18 @@ static inline void __init init_ohci1394_wait_for_busresets(struct ti_ohci *ohci)
  * This enables remote DMA access over IEEE1394 from every host for the low
  * 4GB of address space. DMA accesses above 4GB are not available currently.
  */
-static inline void __init init_ohci1394_enable_physical_dma(struct ti_ohci *hci)
+static inline void __init init_ohci1394_enable_physical_dma(struct ohci *ohci)
 {
-	reg_write(hci, OHCI1394_PhyReqFilterHiSet, 0xffffffff);
-	reg_write(hci, OHCI1394_PhyReqFilterLoSet, 0xffffffff);
-	reg_write(hci, OHCI1394_PhyUpperBound, 0xffff0000);
+	reg_write(ohci, OHCI1394_PhyReqFilterHiSet, 0xffffffff);
+	reg_write(ohci, OHCI1394_PhyReqFilterLoSet, 0xffffffff);
+	reg_write(ohci, OHCI1394_PhyUpperBound, 0xffff0000);
 }
 
 /**
  * init_ohci1394_reset_and_init_dma - init controller and enable DMA
  * This initializes the given controller and enables physical DMA engine in it.
  */
-static inline void __init init_ohci1394_reset_and_init_dma(struct ti_ohci *ohci)
+static inline void __init init_ohci1394_reset_and_init_dma(struct ohci *ohci)
 {
 	/* Start off with a soft reset, clears everything to a sane state. */
 	init_ohci1394_soft_reset(ohci);
@@ -225,7 +249,7 @@ static inline void __init init_ohci1394_reset_and_init_dma(struct ti_ohci *ohci)
 static inline void __init init_ohci1394_controller(int num, int slot, int func)
 {
 	unsigned long ohci_base;
-	struct ti_ohci ohci;
+	struct ohci ohci;
 
 	printk(KERN_INFO "init_ohci1394_dma: initializing OHCI-1394"
 			 " at %02x:%02x.%x\n", num, slot, func);
@@ -235,7 +259,7 @@ static inline void __init init_ohci1394_controller(int num, int slot, int func)
 
 	set_fixmap_nocache(FIX_OHCI1394_BASE, ohci_base);
 
-	ohci.registers = (void *)fix_to_virt(FIX_OHCI1394_BASE);
+	ohci.registers = (void __iomem *)fix_to_virt(FIX_OHCI1394_BASE);
 
 	init_ohci1394_reset_and_init_dma(&ohci);
 }
@@ -247,6 +271,7 @@ static inline void __init init_ohci1394_controller(int num, int slot, int func)
 void __init init_ohci1394_dma_on_all_controllers(void)
 {
 	int num, slot, func;
+	u32 class;
 
 	if (!early_pci_allowed())
 		return;
@@ -255,9 +280,9 @@ void __init init_ohci1394_dma_on_all_controllers(void)
 	for (num = 0; num < 32; num++) {
 		for (slot = 0; slot < 32; slot++) {
 			for (func = 0; func < 8; func++) {
-				u32 class = read_pci_config(num,slot,func,
+				class = read_pci_config(num, slot, func,
 							PCI_CLASS_REVISION);
-				if ((class == 0xffffffff))
+				if (class == 0xffffffff)
 					continue; /* No device at this func */
 
 				if (class>>8 != PCI_CLASS_SERIAL_FIREWIRE_OHCI)
diff --git a/drivers/ieee1394/Makefile b/drivers/ieee1394/Makefile
index 1f8153b..427b86b 100644
--- a/drivers/ieee1394/Makefile
+++ b/drivers/ieee1394/Makefile
@@ -14,5 +14,3 @@ obj-$(CONFIG_IEEE1394_RAWIO) += raw1394.o
 obj-$(CONFIG_IEEE1394_SBP2) += sbp2.o
 obj-$(CONFIG_IEEE1394_DV1394) += dv1394.o
 obj-$(CONFIG_IEEE1394_ETH1394) += eth1394.o
-
-obj-$(CONFIG_PROVIDE_OHCI1394_DMA_INIT) += init_ohci1394_dma.o
-- 
1.7.2.2


-- 
Stefan Richter
-=====-==-=- =-=- -=--=
http://arcgraph.de/sr/

