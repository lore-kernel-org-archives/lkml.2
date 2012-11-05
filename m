Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932643Ab2KETxy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 14:53:54 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:49756 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753711Ab2KETxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 14:53:46 -0500
From: Xi Wang <xi.wang@gmail.com>
To: Xiangliang Yu <yuxiangl@marvell.com>
Cc: Xi Wang <xi.wang@gmail.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] [SCSI] mvsas: fix shift in mv_ffc64()
Date: Mon,  5 Nov 2012 14:53:03 -0500
Message-Id: <1352145183-29355-4-git-send-email-xi.wang@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1352145183-29355-1-git-send-email-xi.wang@gmail.com>
References: <1352145183-29355-1-git-send-email-xi.wang@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Invoking ffz(x) with x = ~0 is undefined.  This patch returns -1
for this case, and invokes __ffs64() instead.

Signed-off-by: Xi Wang <xi.wang@gmail.com>
---
 drivers/scsi/mvsas/mv_94xx.h |   14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_94xx.h b/drivers/scsi/mvsas/mv_94xx.h
index 8f7eb4f..487aa6f 100644
--- a/drivers/scsi/mvsas/mv_94xx.h
+++ b/drivers/scsi/mvsas/mv_94xx.h
@@ -258,21 +258,11 @@ enum sas_sata_phy_regs {
 #define SPI_ADDR_VLD_94XX         	(1U << 1)
 #define SPI_CTRL_SpiStart_94XX     	(1U << 0)
 
-#define mv_ffc(x)   ffz(x)
-
 static inline int
 mv_ffc64(u64 v)
 {
-	int i;
-	i = mv_ffc((u32)v);
-	if (i >= 0)
-		return i;
-	i = mv_ffc((u32)(v>>32));
-
-	if (i != 0)
-		return 32 + i;
-
-	return -1;
+	u64 x = ~v;
+	return x ? __ffs64(x) : -1;
 }
 
 #define r_reg_set_enable(i) \
-- 
1.7.10.4

