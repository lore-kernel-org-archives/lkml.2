Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063Ab2I0Kgy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 06:36:54 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:21131 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753279Ab2I0Kgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 06:36:53 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkgCAEQrZFBbdWObgWdsb2JhbABFuSqEZSMBARYmJ4IgAQEFJ0ASECAxVwYTiAm3b5E1A5VpiTyJWA
X-IronPort-AV: E=Sophos;i="4.80,496,1344204000"; 
   d="scan'208";a="956447808"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH 04/17] Staging: ipack/bridges/tpci200: change tpci200_slot->*_phys type.
Date: Thu, 27 Sep 2012 12:37:28 +0200
Message-Id: <1348742261-28145-4-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1348742261-28145-1-git-send-email-siglesias@igalia.com>
References: <1348742261-28145-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Taprogge <jens.taprogge@taprogge.org>

Previously the *_phys fields were of type ipack_addr_space, which use
void pointers to refer to memory addresses.  Since the *_phys fields
refer to unmapped memory, this is not correct.  Introduce a new struct
ipack_region (which uses phys_addr_t to refer to the start of a region)
and use that as a replacement for struct ipack_addr_space.

struct ipack_region is defined in ipack.h because it is planned to later
expose the physical addressed to the IPack Module drivers.

Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/ipack/bridges/tpci200.c |   41 ++++++++++++++-----------------
 drivers/staging/ipack/bridges/tpci200.h |   10 ++++----
 drivers/staging/ipack/ipack.h           |    9 ++++++-
 3 files changed, 32 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/ipack/bridges/tpci200.c b/drivers/staging/ipack/bridges/tpci200.c
index a804290..47b8a1b 100644
--- a/drivers/staging/ipack/bridges/tpci200.c
+++ b/drivers/staging/ipack/bridges/tpci200.c
@@ -89,13 +89,13 @@ static void tpci200_unregister(struct tpci200_board *tpci200)
 	pci_dev_put(tpci200->info->pdev);
 
 	for (i = 0; i < TPCI200_NB_SLOT; i++) {
-		tpci200->slots[i].io_phys.address = NULL;
+		tpci200->slots[i].io_phys.start = 0;
 		tpci200->slots[i].io_phys.size = 0;
-		tpci200->slots[i].id_phys.address = NULL;
+		tpci200->slots[i].id_phys.start = 0;
 		tpci200->slots[i].id_phys.size = 0;
-		tpci200->slots[i].int_phys.address = NULL;
+		tpci200->slots[i].int_phys.start = 0;
 		tpci200->slots[i].int_phys.size = 0;
-		tpci200->slots[i].mem_phys.address = NULL;
+		tpci200->slots[i].mem_phys.start = 0;
 		tpci200->slots[i].mem_phys.size = 0;
 	}
 }
@@ -241,8 +241,8 @@ static int tpci200_register(struct tpci200_board *tpci200)
 {
 	int i;
 	int res;
-	unsigned long ioidint_base;
-	unsigned long mem_base;
+	phys_addr_t ioidint_base;
+	phys_addr_t mem_base;
 	unsigned short slot_ctrl;
 
 	if (pci_enable_device(tpci200->info->pdev) < 0)
@@ -308,23 +308,20 @@ static int tpci200_register(struct tpci200_board *tpci200)
 
 	/* Set all slot physical address space */
 	for (i = 0; i < TPCI200_NB_SLOT; i++) {
-		tpci200->slots[i].io_phys.address =
-			(void __iomem *)ioidint_base +
+		tpci200->slots[i].io_phys.start = ioidint_base +
 			TPCI200_IO_SPACE_OFF + TPCI200_IO_SPACE_GAP*i;
 		tpci200->slots[i].io_phys.size = TPCI200_IO_SPACE_SIZE;
 
-		tpci200->slots[i].id_phys.address =
-			(void __iomem *)ioidint_base +
+		tpci200->slots[i].id_phys.start = ioidint_base +
 			TPCI200_ID_SPACE_OFF + TPCI200_ID_SPACE_GAP*i;
 		tpci200->slots[i].id_phys.size = TPCI200_ID_SPACE_SIZE;
 
-		tpci200->slots[i].int_phys.address =
-			(void __iomem *)ioidint_base +
+		tpci200->slots[i].int_phys.start = ioidint_base +
 			TPCI200_INT_SPACE_OFF + TPCI200_INT_SPACE_GAP * i;
 		tpci200->slots[i].int_phys.size = TPCI200_INT_SPACE_SIZE;
 
-		tpci200->slots[i].mem_phys.address =
-			(void __iomem *)mem_base + TPCI200_MEM8_GAP*i;
+		tpci200->slots[i].mem_phys.start = mem_base +
+			TPCI200_MEM8_GAP * i;
 		tpci200->slots[i].mem_phys.size = TPCI200_MEM8_SIZE;
 
 		writew(slot_ctrl, &tpci200->info->interface_regs->control[i]);
@@ -419,11 +416,11 @@ out_unlock:
 }
 
 static int tpci200_slot_map_space(struct ipack_device *dev,
-				  unsigned int memory_size, int space)
+				  ssize_t memory_size, int space)
 {
 	int res = 0;
-	unsigned int size_to_map;
-	void __iomem *phys_address;
+	size_t size_to_map;
+	phys_addr_t phys_address;
 	struct ipack_addr_space *virt_addr_space;
 	struct tpci200_board *tpci200;
 
@@ -445,7 +442,7 @@ static int tpci200_slot_map_space(struct ipack_device *dev,
 		}
 		virt_addr_space = &dev->io_space;
 
-		phys_address = tpci200->slots[dev->slot].io_phys.address;
+		phys_address = tpci200->slots[dev->slot].io_phys.start;
 		size_to_map = tpci200->slots[dev->slot].io_phys.size;
 		break;
 	case IPACK_ID_SPACE:
@@ -458,7 +455,7 @@ static int tpci200_slot_map_space(struct ipack_device *dev,
 		}
 		virt_addr_space = &dev->id_space;
 
-		phys_address = tpci200->slots[dev->slot].id_phys.address;
+		phys_address = tpci200->slots[dev->slot].id_phys.start;
 		size_to_map = tpci200->slots[dev->slot].id_phys.size;
 		break;
 	case IPACK_INT_SPACE:
@@ -471,7 +468,7 @@ static int tpci200_slot_map_space(struct ipack_device *dev,
 		}
 		virt_addr_space = &dev->int_space;
 
-		phys_address = tpci200->slots[dev->slot].int_phys.address;
+		phys_address = tpci200->slots[dev->slot].int_phys.start;
 		size_to_map = tpci200->slots[dev->slot].int_phys.size;
 		break;
 	case IPACK_MEM_SPACE:
@@ -486,14 +483,14 @@ static int tpci200_slot_map_space(struct ipack_device *dev,
 
 		if (memory_size > tpci200->slots[dev->slot].mem_phys.size) {
 			dev_err(&dev->dev,
-				"Slot [%d:%d] request is 0x%X memory, only 0x%X available !\n",
+				"Slot [%d:%d] request is 0x%zX memory, only 0x%zX available !\n",
 				dev->bus->bus_nr, dev->slot, memory_size,
 				tpci200->slots[dev->slot].mem_phys.size);
 			res = -EINVAL;
 			goto out_unlock;
 		}
 
-		phys_address = tpci200->slots[dev->slot].mem_phys.address;
+		phys_address = tpci200->slots[dev->slot].mem_phys.start;
 		size_to_map = memory_size;
 		break;
 	default:
diff --git a/drivers/staging/ipack/bridges/tpci200.h b/drivers/staging/ipack/bridges/tpci200.h
index e4ed0a3..59cb5b7 100644
--- a/drivers/staging/ipack/bridges/tpci200.h
+++ b/drivers/staging/ipack/bridges/tpci200.h
@@ -137,11 +137,11 @@ struct slot_irq {
  *
  */
 struct tpci200_slot {
-	struct slot_irq		*irq;
-	struct ipack_addr_space io_phys;
-	struct ipack_addr_space id_phys;
-	struct ipack_addr_space int_phys;
-	struct ipack_addr_space mem_phys;
+	struct slot_irq	    *irq;
+	struct ipack_region  io_phys;
+	struct ipack_region  id_phys;
+	struct ipack_region  int_phys;
+	struct ipack_region  mem_phys;
 };
 
 /**
diff --git a/drivers/staging/ipack/ipack.h b/drivers/staging/ipack/ipack.h
index e2987d5..9e543a5 100644
--- a/drivers/staging/ipack/ipack.h
+++ b/drivers/staging/ipack/ipack.h
@@ -50,6 +50,13 @@ struct ipack_addr_space {
 };
 
 /**
+ */
+struct ipack_region {
+	phys_addr_t start;
+	size_t      size;
+};
+
+/**
  *	struct ipack_device
  *
  *	@slot: Slot where the device is plugged in the carrier board
@@ -124,7 +131,7 @@ struct ipack_driver {
  *	@reset_timeout: Resets the state returned by get_timeout.
  */
 struct ipack_bus_ops {
-	int (*map_space) (struct ipack_device *dev, unsigned int memory_size, int space);
+	int (*map_space) (struct ipack_device *dev, ssize_t memory_size, int space);
 	int (*unmap_space) (struct ipack_device *dev, int space);
 	int (*request_irq) (struct ipack_device *dev,
 			    irqreturn_t (*handler)(void *), void *arg);
-- 
1.7.10.4

