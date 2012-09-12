Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758674Ab2ILNGK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 09:06:10 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:15608 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757874Ab2ILMzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 08:55:48 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqECACCFUFBbdWObgWdsb2JhbABFu0AiAQEWJieCIAEBBSdSECAxVwYTiBG8YpFSA5VfiTOJVA
X-IronPort-AV: E=Sophos;i="4.80,410,1344204000"; 
   d="scan'208";a="950511717"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH 02/24] Staging: ipack/bridges/tpci200: Remove side effects of tpci200_{request,free}_irq.
Date: Wed, 12 Sep 2012 14:55:24 +0200
Message-Id: <1347454546-23236-2-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1347454546-23236-1-git-send-email-siglesias@igalia.com>
References: <1347454546-23236-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Taprogge <jens.taprogge@taprogge.org>

Use the __tpci200_{set,clear}_mask routines to access control
register.  Do not overwrite flags unrelated to interrupt handling.

Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/ipack/bridges/tpci200.c |   31 ++++++-------------------------
 1 file changed, 6 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/ipack/bridges/tpci200.c b/drivers/staging/ipack/bridges/tpci200.c
index 2560519..3285dad 100644
--- a/drivers/staging/ipack/bridges/tpci200.c
+++ b/drivers/staging/ipack/bridges/tpci200.c
@@ -278,37 +278,18 @@ out_disable_pci:
 static int __tpci200_request_irq(struct tpci200_board *tpci200,
 				 struct ipack_device *dev)
 {
-	unsigned short slot_ctrl;
-
-	/* Set the default parameters of the slot
-	 * INT0 enabled, level sensitive
-	 * INT1 enabled, level sensitive
-	 * error interrupt disabled
-	 * timeout interrupt disabled
-	 * recover time disabled
-	 * clock rate 8 MHz
-	 */
-	slot_ctrl = TPCI200_INT0_EN | TPCI200_INT1_EN;
-	writew(slot_ctrl, &tpci200->info->interface_regs->control[dev->slot]);
-
+	__tpci200_set_mask(
+			&tpci200->info->interface_regs->control[dev->slot],
+			TPCI200_INT0_EN | TPCI200_INT1_EN);
 	return 0;
 }
 
 static void __tpci200_free_irq(struct tpci200_board *tpci200,
 			       struct ipack_device *dev)
 {
-	unsigned short slot_ctrl;
-
-	/* Set the default parameters of the slot
-	 * INT0 disabled, level sensitive
-	 * INT1 disabled, level sensitive
-	 * error interrupt disabled
-	 * timeout interrupt disabled
-	 * recover time disabled
-	 * clock rate 8 MHz
-	 */
-	slot_ctrl = 0;
-	writew(slot_ctrl, &tpci200->info->interface_regs->control[dev->slot]);
+	__tpci200_clear_mask(
+			&tpci200->info->interface_regs->control[dev->slot],
+			TPCI200_INT0_EN | TPCI200_INT1_EN);
 }
 
 static int tpci200_free_irq(struct ipack_device *dev)
-- 
1.7.10.4

