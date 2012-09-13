Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757418Ab2IMKb6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 06:31:58 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:13502 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755439Ab2IMKbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 06:31:10 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApkCAMO0UVBbdWObgWdsb2JhbABFu3AiAQEWJieCIAEtUjCBDhOIEbwdkUcDlV+JM4lU
X-IronPort-AV: E=Sophos;i="4.80,416,1344204000"; 
   d="scan'208";a="951021177"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH v2 1/5] Staging: ipack: Add IPACK_INT_SPACE memory space.
Date: Thu, 13 Sep 2012 12:32:19 +0200
Message-Id: <1347532343-22948-1-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Taprogge <jens.taprogge@taprogge.org>

This will allow us to correctly access the IPack INT space.

Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/ipack/bridges/tpci200.c |   29 +++++++++++++++++++++++++++++
 drivers/staging/ipack/bridges/tpci200.h |    2 ++
 drivers/staging/ipack/ipack.h           |    2 ++
 3 files changed, 33 insertions(+)

diff --git a/drivers/staging/ipack/bridges/tpci200.c b/drivers/staging/ipack/bridges/tpci200.c
index 21b2b75..3462783 100644
--- a/drivers/staging/ipack/bridges/tpci200.c
+++ b/drivers/staging/ipack/bridges/tpci200.c
@@ -95,6 +95,8 @@ static void tpci200_unregister(struct tpci200_board *tpci200)
 		tpci200->slots[i].io_phys.size = 0;
 		tpci200->slots[i].id_phys.address = NULL;
 		tpci200->slots[i].id_phys.size = 0;
+		tpci200->slots[i].int_phys.address = NULL;
+		tpci200->slots[i].int_phys.size = 0;
 		tpci200->slots[i].mem_phys.address = NULL;
 		tpci200->slots[i].mem_phys.size = 0;
 	}
@@ -331,6 +333,11 @@ static int tpci200_register(struct tpci200_board *tpci200)
 			TPCI200_ID_SPACE_OFF + TPCI200_ID_SPACE_GAP*i;
 		tpci200->slots[i].id_phys.size = TPCI200_ID_SPACE_SIZE;
 
+		tpci200->slots[i].int_phys.address =
+			(void __iomem *)ioidint_base +
+			TPCI200_INT_SPACE_OFF + TPCI200_INT_SPACE_GAP * i;
+		tpci200->slots[i].int_phys.size = TPCI200_INT_SPACE_SIZE;
+
 		tpci200->slots[i].mem_phys.address =
 			(void __iomem *)mem_base + TPCI200_MEM8_GAP*i;
 		tpci200->slots[i].mem_phys.size = TPCI200_MEM8_SIZE;
@@ -391,6 +398,15 @@ static int tpci200_slot_unmap_space(struct ipack_device *dev, int space)
 		}
 		virt_addr_space = &dev->id_space;
 		break;
+	case IPACK_INT_SPACE:
+		if (dev->int_space.address == NULL) {
+			dev_info(&dev->dev,
+				 "Slot [%d:%d] INT space not mapped !\n",
+				 dev->bus_nr, dev->slot);
+			goto out_unlock;
+		}
+		virt_addr_space = &dev->int_space;
+		break;
 	case IPACK_MEM_SPACE:
 		if (dev->mem_space.address == NULL) {
 			dev_info(&dev->dev,
@@ -460,6 +476,19 @@ static int tpci200_slot_map_space(struct ipack_device *dev,
 		phys_address = tpci200->slots[dev->slot].id_phys.address;
 		size_to_map = tpci200->slots[dev->slot].id_phys.size;
 		break;
+	case IPACK_INT_SPACE:
+		if (dev->int_space.address != NULL) {
+			dev_err(&dev->dev,
+				"Slot [%d:%d] INT space already mapped !\n",
+				tpci200->number, dev->slot);
+			res = -EINVAL;
+			goto out_unlock;
+		}
+		virt_addr_space = &dev->int_space;
+
+		phys_address = tpci200->slots[dev->slot].int_phys.address;
+		size_to_map = tpci200->slots[dev->slot].int_phys.size;
+		break;
 	case IPACK_MEM_SPACE:
 		if (dev->mem_space.address != NULL) {
 			dev_err(&dev->dev,
diff --git a/drivers/staging/ipack/bridges/tpci200.h b/drivers/staging/ipack/bridges/tpci200.h
index e1f60f3..235d1fe 100644
--- a/drivers/staging/ipack/bridges/tpci200.h
+++ b/drivers/staging/ipack/bridges/tpci200.h
@@ -132,6 +132,7 @@ struct slot_irq {
  * @irq		Slot IRQ infos
  * @io_phys	IO physical base address register of the slot
  * @id_phys	ID physical base address register of the slot
+ * @int_phys	INT physical base address register of the slot
  * @mem_phys	MEM physical base address register of the slot
  *
  */
@@ -139,6 +140,7 @@ struct tpci200_slot {
 	struct slot_irq		*irq;
 	struct ipack_addr_space io_phys;
 	struct ipack_addr_space id_phys;
+	struct ipack_addr_space int_phys;
 	struct ipack_addr_space mem_phys;
 };
 
diff --git a/drivers/staging/ipack/ipack.h b/drivers/staging/ipack/ipack.h
index 9c3079d..f8405df 100644
--- a/drivers/staging/ipack/ipack.h
+++ b/drivers/staging/ipack/ipack.h
@@ -35,6 +35,7 @@ enum ipack_space {
 	IPACK_IO_SPACE    = 0,
 	IPACK_ID_SPACE    = 1,
 	IPACK_MEM_SPACE   = 2,
+	IPACK_INT_SPACE,
 };
 
 /**
@@ -71,6 +72,7 @@ struct ipack_device {
 	struct ipack_bus_device *bus;
 	struct ipack_addr_space id_space;
 	struct ipack_addr_space io_space;
+	struct ipack_addr_space int_space;
 	struct ipack_addr_space mem_space;
 	struct device dev;
 	u8                      *id;
-- 
1.7.10.4

