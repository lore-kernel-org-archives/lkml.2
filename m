Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756375Ab2DDNNb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 09:13:31 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:50002 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756205Ab2DDNNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 09:13:30 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Mike Miller <mike.miller@hp.com>,
        "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
        iss_storagedev@hp.com
Subject: [PATCH v2] cciss: use check_signature
Date: Wed,  4 Apr 2012 22:13:22 +0900
Message-Id: <1333545203-12942-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use check_signature to find a signature in the mmio address.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Mike Miller <mike.miller@hp.com>
Cc: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: iss_storagedev@hp.com
---
v2: select CHECK_SIGNATURE in Kconfig

 drivers/block/Kconfig |    1 +
 drivers/block/cciss.c |    7 ++-----
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index a796407..9522682 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -131,6 +131,7 @@ config BLK_CPQ_DA
 config BLK_CPQ_CISS_DA
 	tristate "Compaq Smart Array 5xxx support"
 	depends on PCI
+	select CHECK_SIGNATURE
 	help
 	  This is the driver for Compaq Smart Array 5xxx controllers.
 	  Everyone using these boards should say Y here.
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index bda6d12..e04c63e 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -42,8 +42,8 @@
 #include <linux/compat.h>
 #include <linux/mutex.h>
 #include <linux/bitmap.h>
+#include <linux/io.h>
 #include <asm/uaccess.h>
-#include <asm/io.h>
 
 #include <linux/dma-mapping.h>
 #include <linux/blkdev.h>
@@ -4267,10 +4267,7 @@ static void __devinit cciss_find_board_params(ctlr_info_t *h)
 
 static inline bool CISS_signature_present(ctlr_info_t *h)
 {
-	if ((readb(&h->cfgtable->Signature[0]) != 'C') ||
-	    (readb(&h->cfgtable->Signature[1]) != 'I') ||
-	    (readb(&h->cfgtable->Signature[2]) != 'S') ||
-	    (readb(&h->cfgtable->Signature[3]) != 'S')) {
+	if (!check_signature(h->cfgtable->Signature, "CISS", 4)) {
 		dev_warn(&h->pdev->dev, "not a valid CISS config table\n");
 		return false;
 	}
-- 
1.7.4.4

