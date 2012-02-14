Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761144Ab2BNU4J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 15:56:09 -0500
Received: from www.linutronix.de ([62.245.132.108]:51583 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760950Ab2BNUzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 15:55:00 -0500
From: Richard Weinberger <rw@linutronix.de>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, tim.bird@am.sony.com,
        dedekind1@gmail.com, Richard Weinberger <rw@linutronix.de>
Subject: [RFC][PATCH 5/7] MTD: UBI: Make process_eb() checkpoint aware
Date: Tue, 14 Feb 2012 21:06:44 +0100
Message-Id: <1329250006-22944-6-git-send-email-rw@linutronix.de>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1329250006-22944-1-git-send-email-rw@linutronix.de>
References: <1329250006-22944-1-git-send-email-rw@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CONFIG_MTD_UBI_CHECKPOINT is not set, process_eb has to
remove all checkpointing volumes.

Signed-off-by: Richard Weinberger <rw@linutronix.de>
---
 drivers/mtd/ubi/scan.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/ubi/scan.c b/drivers/mtd/ubi/scan.c
index 0cb17d9..1d01fdc 100644
--- a/drivers/mtd/ubi/scan.c
+++ b/drivers/mtd/ubi/scan.c
@@ -1011,7 +1011,15 @@ static int process_eb(struct ubi_device *ubi, struct ubi_scan_info *si,
 	}
 
 	vol_id = be32_to_cpu(vidh->vol_id);
-	if (vol_id > UBI_MAX_VOLUMES && vol_id != UBI_LAYOUT_VOLUME_ID) {
+#ifdef CONFIG_MTD_UBI_CHECKPOINT
+	if (vol_id > UBI_MAX_VOLUMES &&
+		vol_id != UBI_LAYOUT_VOLUME_ID &&
+		vol_id != UBI_CP_SB_VOLUME_ID &&
+		vol_id != UBI_CP_DATA_VOLUME_ID)
+#else
+	if (vol_id > UBI_MAX_VOLUMES && vol_id != UBI_LAYOUT_VOLUME_ID)
+#endif
+	{
 		int lnum = be32_to_cpu(vidh->lnum);
 
 		/* Unsupported internal volume */
-- 
1.7.7

