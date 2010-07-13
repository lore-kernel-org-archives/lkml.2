Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825Ab0GME4p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 00:56:45 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:36456 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231Ab0GME4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 00:56:42 -0400
From: Conke Hu <conke@maxwit.com>
To: support@simtec.co.uk, linux@simtec.co.uk, ben-linux@fluff.org,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Conke Hu <conke@maxwit.com>
Subject: [PATCH] s3c nand: parsing commad-line partitions prior to set->partitions
Date: Tue, 13 Jul 2010 12:56:30 +0800
Message-Id: <1278996990-4380-1-git-send-email-conke@maxwit.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current driver prevents command-line partitions from being parsed when built-in 
partitions are defined in s3c2410_nand_set object, but it is not desirable in some 
cases. This patch tries to parse commad-line partitions prior to the built-in.

Signed-off-by: Conke Hu <conke@maxwit.com>
---
 drivers/mtd/nand/s3c2410.c |   15 ++++++---------
 1 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/mtd/nand/s3c2410.c b/drivers/mtd/nand/s3c2410.c
index 239aadf..33d832d 100644
--- a/drivers/mtd/nand/s3c2410.c
+++ b/drivers/mtd/nand/s3c2410.c
@@ -727,15 +727,12 @@ static int s3c2410_nand_add_partition(struct s3c2410_nand_info *info,
 	if (set == NULL)
 		return add_mtd_device(&mtd->mtd);
 
-	if (set->nr_partitions == 0) {
-		mtd->mtd.name = set->name;
-		nr_part = parse_mtd_partitions(&mtd->mtd, part_probes,
-						&part_info, 0);
-	} else {
-		if (set->nr_partitions > 0 && set->partitions != NULL) {
-			nr_part = set->nr_partitions;
-			part_info = set->partitions;
-		}
+	mtd->mtd.name = set->name;
+	nr_part = parse_mtd_partitions(&mtd->mtd, part_probes, &part_info, 0);
+
+	if (nr_part <= 0 && set->nr_partitions > 0) {
+		nr_part = set->nr_partitions;
+		part_info = set->partitions;
 	}
 
 	if (nr_part > 0 && part_info)
-- 
1.7.0.4

