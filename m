Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485Ab2ENKxA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 06:53:00 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:56977 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755303Ab2ENKw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 06:52:58 -0400
X-Greylist: delayed 656 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 May 2012 06:52:58 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAB3hsE9bdWOb/2dsb2JhbABEs3CBB4IWAQUnUhBRVwYTiBK6NpEiBJV9kECCaw
X-IronPort-AV: E=Sophos;i="4.75,585,1330902000"; 
   d="scan'208";a="990372069"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] Staging ipack: fix a few sparse warnings
Date: Mon, 14 May 2012 12:41:25 +0200
Message-Id: <1336992089-2733-2-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1336992089-2733-1-git-send-email-siglesias@igalia.com>
References: <1336992089-2733-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/ipack/bridges/tpci200.c |   51 ++++++++++++++++++-------------
 drivers/staging/ipack/bridges/tpci200.h |    6 ++--
 drivers/staging/ipack/devices/ipoctal.c |    4 +--
 drivers/staging/ipack/ipack.h           |    2 +-
 4 files changed, 35 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/ipack/bridges/tpci200.c b/drivers/staging/ipack/bridges/tpci200.c
index 80cdd9e..4e812a7 100644
--- a/drivers/staging/ipack/bridges/tpci200.c
+++ b/drivers/staging/ipack/bridges/tpci200.c
@@ -16,7 +16,7 @@
 #include <linux/module.h>
 #include "tpci200.h"
 
-struct ipack_bus_ops tpci200_bus_ops;
+static struct ipack_bus_ops tpci200_bus_ops;
 
 /* TPCI200 controls registers */
 static int control_reg[] = {
@@ -70,35 +70,39 @@ static struct tpci200_board *check_slot(struct ipack_device *dev)
 	return tpci200;
 }
 
-static inline unsigned char __tpci200_read8(void *address, unsigned long offset)
+static inline unsigned char __tpci200_read8(void __iomem *address,
+					    unsigned long offset)
 {
 	return ioread8(address + (offset^1));
 }
 
-static inline unsigned short __tpci200_read16(void *address,
+static inline unsigned short __tpci200_read16(void __iomem *address,
 					      unsigned long offset)
 {
 	return ioread16(address + offset);
 }
 
-static inline unsigned int __tpci200_read32(void *address, unsigned long offset)
+static inline unsigned int __tpci200_read32(void __iomem *address,
+					    unsigned long offset)
 {
 	return swahw32(ioread32(address + offset));
 }
 
 static inline void __tpci200_write8(unsigned char value,
-				    void *address, unsigned long offset)
+				    void __iomem *address, unsigned long offset)
 {
 	iowrite8(value, address+(offset^1));
 }
 
-static inline void __tpci200_write16(unsigned short value, void *address,
+static inline void __tpci200_write16(unsigned short value,
+				     void __iomem *address,
 				     unsigned long offset)
 {
 	iowrite16(value, address+offset);
 }
 
-static inline void __tpci200_write32(unsigned int value, void *address,
+static inline void __tpci200_write32(unsigned int value,
+				     void __iomem *address,
 				     unsigned long offset)
 {
 	iowrite32(swahw32(value), address+offset);
@@ -318,7 +322,7 @@ static irqreturn_t tpci200_interrupt(int irq, void *dev_id)
 	spin_lock_irqsave(&tpci200->info->access_lock, flags);
 
 	/* Read status register */
-	status_reg = readw((unsigned short *) (tpci200->info->interface_regs +
+	status_reg = readw((void __iomem *) (tpci200->info->interface_regs +
 					       TPCI200_STATUS_REG));
 
 	if (status_reg & TPCI200_SLOT_INT_MASK) {
@@ -331,10 +335,10 @@ static irqreturn_t tpci200_interrupt(int irq, void *dev_id)
 				ret = tpci200->slots[i].irq->handler(tpci200->slots[i].irq->arg);
 
 				/* Dummy reads */
-				readw((unsigned short *)
+				readw((void __iomem *)
 				      (tpci200->slots[i].dev->io_space.address +
 				       0xC0));
-				readw((unsigned short *)
+				readw((void __iomem *)
 				      (tpci200->slots[i].dev->io_space.address +
 				       0xC2));
 
@@ -349,12 +353,14 @@ static irqreturn_t tpci200_interrupt(int irq, void *dev_id)
 				pr_info("No registered ISR for slot [%s %d:%d]!. IRQ will be disabled.\n",
 					TPCI200_SHORTNAME,
 					tpci200->number, i);
-				reg_value = readw((unsigned short *)(tpci200->info->interface_regs +
+				reg_value = readw(
+					(void __iomem *)(tpci200->info->interface_regs +
 								     control_reg[i]));
 				reg_value &=
 					~(TPCI200_INT0_EN | TPCI200_INT1_EN);
-				writew(reg_value, (unsigned short *)(tpci200->info->interface_regs +
-								     control_reg[i]));
+				writew(reg_value,
+				       (void __iomem *)(tpci200->info->interface_regs +
+							control_reg[i]));
 			}
 		}
 	}
@@ -675,21 +681,21 @@ static int tpci200_register(struct tpci200_board *tpci200)
 	/* Set all slot physical address space */
 	for (i = 0; i < TPCI200_NB_SLOT; i++) {
 		tpci200->slots[i].io_phys.address =
-			(void *)ioidint_base +
+			(void __iomem *)ioidint_base +
 			TPCI200_IO_SPACE_OFF + TPCI200_IO_SPACE_GAP*i;
 		tpci200->slots[i].io_phys.size = TPCI200_IO_SPACE_SIZE;
 
 		tpci200->slots[i].id_phys.address =
-			(void *)ioidint_base +
+			(void __iomem *)ioidint_base +
 			TPCI200_ID_SPACE_OFF + TPCI200_ID_SPACE_GAP*i;
 		tpci200->slots[i].id_phys.size = TPCI200_ID_SPACE_SIZE;
 
 		tpci200->slots[i].mem_phys.address =
-			(void *)mem_base + TPCI200_MEM8_GAP*i;
+			(void __iomem *)mem_base + TPCI200_MEM8_GAP*i;
 		tpci200->slots[i].mem_phys.size = TPCI200_MEM8_SIZE;
 
 		writew(slot_ctrl,
-		       (unsigned short *)(tpci200->info->interface_regs +
+		       (void __iomem *)(tpci200->info->interface_regs +
 					  control_reg[i]));
 	}
 
@@ -732,7 +738,7 @@ static int __tpci200_request_irq(struct tpci200_board *tpci200,
 	 * clock rate 8 MHz
 	 */
 	slot_ctrl = TPCI200_INT0_EN | TPCI200_INT1_EN;
-	writew(slot_ctrl, (unsigned short *)(tpci200->info->interface_regs +
+	writew(slot_ctrl, (void __iomem *)(tpci200->info->interface_regs +
 					     control_reg[dev->slot]));
 
 	return 0;
@@ -752,8 +758,9 @@ static void __tpci200_free_irq(struct tpci200_board *tpci200,
 	 * clock rate 8 MHz
 	 */
 	slot_ctrl = 0;
-	writew(slot_ctrl, (unsigned short *)(tpci200->info->interface_regs +
-					     control_reg[dev->slot]));
+	writew(slot_ctrl,
+	       (void __iomem *)(tpci200->info->interface_regs +
+				control_reg[dev->slot]));
 }
 
 static int tpci200_free_irq(struct ipack_device *dev)
@@ -878,7 +885,7 @@ static int tpci200_slot_map_space(struct ipack_device *dev,
 {
 	int res;
 	unsigned int size_to_map;
-	void *phys_address;
+	void __iomem *phys_address;
 	struct ipack_addr_space *virt_addr_space;
 	struct tpci200_board *tpci200;
 
@@ -1041,7 +1048,7 @@ static void tpci200_uninstall(struct tpci200_board *tpci200)
 	kfree(tpci200->slots);
 }
 
-struct ipack_bus_ops tpci200_bus_ops = {
+static struct ipack_bus_ops tpci200_bus_ops = {
 	.map_space = tpci200_slot_map_space,
 	.unmap_space = tpci200_slot_unmap_space,
 	.request_irq = tpci200_request_irq,
diff --git a/drivers/staging/ipack/bridges/tpci200.h b/drivers/staging/ipack/bridges/tpci200.h
index 75801f6..c052107 100644
--- a/drivers/staging/ipack/bridges/tpci200.h
+++ b/drivers/staging/ipack/bridges/tpci200.h
@@ -147,9 +147,9 @@ struct tpci200_slot {
 struct tpci200_infos {
 	struct pci_dev			*pdev;
 	struct pci_device_id		*id_table;
-	void				*interface_regs;
-	void				*ioidint_space;
-	void				*mem8_space;
+	void __iomem			*interface_regs;
+	void __iomem			*ioidint_space;
+	void __iomem			*mem8_space;
 	spinlock_t			access_lock;
 	struct ipack_bus_device		drv;
 };
diff --git a/drivers/staging/ipack/devices/ipoctal.c b/drivers/staging/ipack/devices/ipoctal.c
index a28c677..c88f391 100644
--- a/drivers/staging/ipack/devices/ipoctal.c
+++ b/drivers/staging/ipack/devices/ipoctal.c
@@ -72,7 +72,7 @@ static inline void ipoctal_write_io_reg(struct ipoctal *ipoctal,
 {
 	unsigned long offset;
 
-	offset = ((void *) dest) - ipoctal->dev->io_space.address;
+	offset = ((void __iomem *) dest) - ipoctal->dev->io_space.address;
 	ipoctal->dev->ops->write8(ipoctal->dev, IPACK_IO_SPACE, offset, value);
 }
 
@@ -89,7 +89,7 @@ static inline unsigned char ipoctal_read_io_reg(struct ipoctal *ipoctal,
 	unsigned long offset;
 	unsigned char value;
 
-	offset = ((void *) src) - ipoctal->dev->io_space.address;
+	offset = ((void __iomem *) src) - ipoctal->dev->io_space.address;
 	ipoctal->dev->ops->read8(ipoctal->dev, IPACK_IO_SPACE, offset, &value);
 	return value;
 }
diff --git a/drivers/staging/ipack/ipack.h b/drivers/staging/ipack/ipack.h
index 3aa38c5..7f408ad 100644
--- a/drivers/staging/ipack/ipack.h
+++ b/drivers/staging/ipack/ipack.h
@@ -42,7 +42,7 @@ enum ipack_space {
  *	@size: size of the mapped space
  */
 struct ipack_addr_space {
-	void         *address;
+	void __iomem *address;
 	unsigned int size;
 };
 
-- 
1.7.10

