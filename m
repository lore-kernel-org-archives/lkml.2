Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932873Ab2KETx4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 14:53:56 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:49756 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951Ab2KETxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 14:53:38 -0500
From: Xi Wang <xi.wang@gmail.com>
To: Xiangliang Yu <yuxiangl@marvell.com>
Cc: Xi Wang <xi.wang@gmail.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] [SCSI] mvsas: fix shift in mvs_94xx_assign_reg_set()
Date: Mon,  5 Nov 2012 14:53:01 -0500
Message-Id: <1352145183-29355-2-git-send-email-xi.wang@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1352145183-29355-1-git-send-email-xi.wang@gmail.com>
References: <1352145183-29355-1-git-send-email-xi.wang@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The macro bit(n) is defined as ((u32)1 << n), and thus it doesn't
work with n >= 32, such as in mvs_94xx_assign_reg_set():

	if (i >= 32) {
		mvi->sata_reg_set |= bit(i);
		...
	}

The shift ((u32)1 << n) with n >= 32 also leads to undefined behavior.
The result varies depending on the architecture.

This patch changes bit(n) to do a 64-bit shift.

Signed-off-by: Xi Wang <xi.wang@gmail.com>
---
 drivers/scsi/mvsas/mv_sas.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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
-- 
1.7.10.4

