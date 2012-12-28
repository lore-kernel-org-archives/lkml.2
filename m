Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932457Ab2L1Tfg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:35:36 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55430 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932273Ab2L1TTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:19:02 -0500
Message-Id: <20121228190348.641050174@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:04:58 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Xi Wang <xi.wang@gmail.com>, Xiangliang Yu <yuxiangl@marvell.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 088/173] [SCSI] mvsas: fix undefined bit shift
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xi Wang <xi.wang@gmail.com>

commit beecadea1b8d67f591b13f7099559f32f3fd601d upstream.

The macro bit(n) is defined as ((u32)1 << n), and thus it doesn't work
with n >= 32, such as in mvs_94xx_assign_reg_set():

	if (i >= 32) {
		mvi->sata_reg_set |= bit(i);
		...
	}

The shift ((u32)1 << n) with n >= 32 also leads to undefined behavior.
The result varies depending on the architecture.

This patch changes bit(n) to do a 64-bit shift.  It also simplifies
mv_ffc64() using __ffs64(), since invoking ffz() with ~0 is undefined.

Signed-off-by: Xi Wang <xi.wang@gmail.com>
Acked-by: Xiangliang Yu <yuxiangl@marvell.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/mvsas/mv_94xx.h |   14 ++------------
 drivers/scsi/mvsas/mv_sas.h  |    2 +-
 2 files changed, 3 insertions(+), 13 deletions(-)

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
diff --git a/drivers/scsi/mvsas/mv_sas.h b/drivers/scsi/mvsas/mv_sas.h
index c04a4f5..da24955 100644
--- a/drivers/scsi/mvsas/mv_sas.h
+++ b/drivers/scsi/mvsas/mv_sas.h
@@ -69,7 +69,7 @@ extern struct kmem_cache *mvs_task_list_cache;
 #define DEV_IS_EXPANDER(type)	\
 	((type == EDGE_DEV) || (type == FANOUT_DEV))
 
-#define bit(n) ((u32)1 << n)
+#define bit(n) ((u64)1 << n)
 
 #define for_each_phy(__lseq_mask, __mc, __lseq)			\
 	for ((__mc) = (__lseq_mask), (__lseq) = 0;		\


