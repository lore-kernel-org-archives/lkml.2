Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756491Ab2I0KhA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 06:37:00 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:21131 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754108Ab2I0Kg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 06:36:57 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkECAEQrZFBbdWObgWdsb2JhbABFvg8jAQEWJieCIAEBBSdSECAmC1cGE4gJt2+RNQOVaZMU
X-IronPort-AV: E=Sophos;i="4.80,496,1344204000"; 
   d="scan'208";a="956447809"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH 05/17] Staging: ipack/bridges/tpci200: Store beginning of module memory regions in struct tpci200.
Date: Thu, 27 Sep 2012 12:37:29 +0200
Message-Id: <1348742261-28145-5-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1348742261-28145-1-git-send-email-siglesias@igalia.com>
References: <1348742261-28145-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Taprogge <jens.taprogge@taprogge.org>

tpci200_register is converted to use this.

A later patch will build on this.

Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/ipack/bridges/tpci200.c |   26 +++++++++++++++++---------
 drivers/staging/ipack/bridges/tpci200.h |    1 +
 drivers/staging/ipack/ipack.h           |    7 +++++--
 3 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/ipack/bridges/tpci200.c b/drivers/staging/ipack/bridges/tpci200.c
index 47b8a1b..5acaea2 100644
--- a/drivers/staging/ipack/bridges/tpci200.c
+++ b/drivers/staging/ipack/bridges/tpci200.c
@@ -242,7 +242,6 @@ static int tpci200_register(struct tpci200_board *tpci200)
 	int i;
 	int res;
 	phys_addr_t ioidint_base;
-	phys_addr_t mem_base;
 	unsigned short slot_ctrl;
 
 	if (pci_enable_device(tpci200->info->pdev) < 0)
@@ -293,7 +292,12 @@ static int tpci200_register(struct tpci200_board *tpci200)
 
 	ioidint_base = pci_resource_start(tpci200->info->pdev,
 					  TPCI200_IO_ID_INT_SPACES_BAR);
-	mem_base = pci_resource_start(tpci200->info->pdev,
+	tpci200->mod_mem[IPACK_IO_SPACE] = ioidint_base + TPCI200_IO_SPACE_OFF;
+	tpci200->mod_mem[IPACK_ID_SPACE] = ioidint_base + TPCI200_ID_SPACE_OFF;
+	tpci200->mod_mem[IPACK_INT_SPACE] =
+		ioidint_base + TPCI200_INT_SPACE_OFF;
+	tpci200->mod_mem[IPACK_MEM_SPACE] =
+		pci_resource_start(tpci200->info->pdev,
 				      TPCI200_MEM8_SPACE_BAR);
 
 	/* Set the default parameters of the slot
@@ -308,19 +312,23 @@ static int tpci200_register(struct tpci200_board *tpci200)
 
 	/* Set all slot physical address space */
 	for (i = 0; i < TPCI200_NB_SLOT; i++) {
-		tpci200->slots[i].io_phys.start = ioidint_base +
-			TPCI200_IO_SPACE_OFF + TPCI200_IO_SPACE_GAP*i;
+		tpci200->slots[i].io_phys.start =
+			tpci200->mod_mem[IPACK_IO_SPACE] +
+			TPCI200_IO_SPACE_GAP * i;
 		tpci200->slots[i].io_phys.size = TPCI200_IO_SPACE_SIZE;
 
-		tpci200->slots[i].id_phys.start = ioidint_base +
-			TPCI200_ID_SPACE_OFF + TPCI200_ID_SPACE_GAP*i;
+		tpci200->slots[i].id_phys.start =
+			tpci200->mod_mem[IPACK_ID_SPACE] +
+			TPCI200_ID_SPACE_GAP * i;
 		tpci200->slots[i].id_phys.size = TPCI200_ID_SPACE_SIZE;
 
-		tpci200->slots[i].int_phys.start = ioidint_base +
-			TPCI200_INT_SPACE_OFF + TPCI200_INT_SPACE_GAP * i;
+		tpci200->slots[i].int_phys.start =
+			tpci200->mod_mem[IPACK_INT_SPACE] +
+			TPCI200_INT_SPACE_GAP * i;
 		tpci200->slots[i].int_phys.size = TPCI200_INT_SPACE_SIZE;
 
-		tpci200->slots[i].mem_phys.start = mem_base +
+		tpci200->slots[i].mem_phys.start =
+			tpci200->mod_mem[IPACK_MEM_SPACE] +
 			TPCI200_MEM8_GAP * i;
 		tpci200->slots[i].mem_phys.size = TPCI200_MEM8_SIZE;
 
diff --git a/drivers/staging/ipack/bridges/tpci200.h b/drivers/staging/ipack/bridges/tpci200.h
index 59cb5b7..6b7c700 100644
--- a/drivers/staging/ipack/bridges/tpci200.h
+++ b/drivers/staging/ipack/bridges/tpci200.h
@@ -165,6 +165,7 @@ struct tpci200_board {
 	spinlock_t		regs_lock;
 	struct tpci200_slot	*slots;
 	struct tpci200_infos	*info;
+	phys_addr_t             mod_mem[IPACK_SPACE_COUNT];
 };
 
 #endif /* _TPCI200_H_ */
diff --git a/drivers/staging/ipack/ipack.h b/drivers/staging/ipack/ipack.h
index 9e543a5..a842eea 100644
--- a/drivers/staging/ipack/ipack.h
+++ b/drivers/staging/ipack/ipack.h
@@ -33,9 +33,12 @@ struct ipack_driver;
 
 enum ipack_space {
 	IPACK_IO_SPACE    = 0,
-	IPACK_ID_SPACE    = 1,
-	IPACK_MEM_SPACE   = 2,
+	IPACK_ID_SPACE,
+	IPACK_MEM_SPACE,
 	IPACK_INT_SPACE,
+	/* Dummy for counting the number of entries.  Must remain the last
+	 * entry */
+	IPACK_SPACE_COUNT,
 };
 
 /**
-- 
1.7.10.4

