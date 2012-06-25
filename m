Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925Ab2FYPPn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 11:15:43 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:44865 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752658Ab2FYPPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 11:15:42 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAGl/6E9bdWOb/2dsb2JhbABEtiyBB4IZAQUnUhBRVwYTiA+4SpE1A5UukAGCYQ
X-IronPort-AV: E=Sophos;i="4.77,472,1336341600"; 
   d="scan'208";a="932086483"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] Staging: ipack/bridges/tpci200: remove unneeded lock in irq handler
Date: Mon, 25 Jun 2012 17:15:46 +0200
Message-Id: <1340637347-14303-3-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1340637347-14303-1-git-send-email-siglesias@igalia.com>
References: <1340637347-14303-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/ipack/bridges/tpci200.c |    5 -----
 drivers/staging/ipack/bridges/tpci200.h |    2 --
 2 files changed, 7 deletions(-)

diff --git a/drivers/staging/ipack/bridges/tpci200.c b/drivers/staging/ipack/bridges/tpci200.c
index ae9f803..2b83fa8 100644
--- a/drivers/staging/ipack/bridges/tpci200.c
+++ b/drivers/staging/ipack/bridges/tpci200.c
@@ -302,13 +302,10 @@ static irqreturn_t tpci200_interrupt(int irq, void *dev_id)
 {
 	struct tpci200_board *tpci200 = (struct tpci200_board *) dev_id;
 	int i;
-	unsigned long flags;
 	unsigned short status_reg, reg_value;
 	unsigned short unhandled_ints = 0;
 	irqreturn_t ret = IRQ_NONE;
 
-	spin_lock_irqsave(&tpci200->info->access_lock, flags);
-
 	/* Read status register */
 	status_reg = readw(tpci200->info->interface_regs +
 			   TPCI200_STATUS_REG);
@@ -351,7 +348,6 @@ static irqreturn_t tpci200_interrupt(int irq, void *dev_id)
 		}
 	}
 
-	spin_unlock_irqrestore(&tpci200->info->access_lock, flags);
 	return ret;
 }
 
@@ -414,7 +410,6 @@ static int tpci200_register(struct tpci200_board *tpci200)
 					   TPCI200_MEM8_SPACE_BAR),
 			TPCI200_MEM8_SIZE);
 
-	spin_lock_init(&tpci200->info->access_lock);
 	ioidint_base = pci_resource_start(tpci200->info->pdev,
 					  TPCI200_IO_ID_INT_SPACES_BAR);
 	mem_base = pci_resource_start(tpci200->info->pdev,
diff --git a/drivers/staging/ipack/bridges/tpci200.h b/drivers/staging/ipack/bridges/tpci200.h
index 97ff0d6..d04510a 100644
--- a/drivers/staging/ipack/bridges/tpci200.h
+++ b/drivers/staging/ipack/bridges/tpci200.h
@@ -136,7 +136,6 @@ struct tpci200_slot {
  * @interface_regs	Pointer to IP interface space (Bar 2)
  * @ioidint_space	Pointer to IP ID, IO and INT space (Bar 3)
  * @mem8_space		Pointer to MEM space (Bar 4)
- * @access_lock		Mutex lock for simultaneous access
  *
  */
 struct tpci200_infos {
@@ -145,7 +144,6 @@ struct tpci200_infos {
 	void __iomem			*interface_regs;
 	void __iomem			*ioidint_space;
 	void __iomem			*mem8_space;
-	spinlock_t			access_lock;
 	struct ipack_bus_device		*ipack_bus;
 };
 struct tpci200_board {
-- 
1.7.10

