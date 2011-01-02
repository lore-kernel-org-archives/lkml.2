Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754318Ab1ABHsB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:48:01 -0500
Received: from mail.windriver.com ([147.11.1.11]:36047 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754176Ab1ABHYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:24:03 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org,
        Peter Oberparleiter <peter.oberparleiter@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 152/260] dasd: use correct label location for diag fba disks
Date: Sun,  2 Jan 2011 02:17:28 -0500
Message-Id: <1293952756-15010-153-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:22:57.0400 (UTC) FILETIME=[E0FBE780:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>

commit cffab6bc5511cd6f67a60bf16b62de4267b68c4c upstream.

Partition boundary calculation fails for DASD FBA disks under the
following conditions:
- disk is formatted with CMS FORMAT with a blocksize of more than
  512 bytes
- all of the disk is reserved to a single CMS file using CMS RESERVE
- the disk is accessed using the DIAG mode of the DASD driver

Under these circumstances, the partition detection code tries to
read the CMS label block containing partition-relevant information
from logical block offset 1, while it is in fact located at physical
block offset 1.

Fix this problem by using the correct CMS label block location
depending on the device type as determined by the DASD SENSE ID
information.

Signed-off-by: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/partitions/ibm.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/fs/partitions/ibm.c b/fs/partitions/ibm.c
index fc71aab..bae725b 100644
--- a/fs/partitions/ibm.c
+++ b/fs/partitions/ibm.c
@@ -74,6 +74,7 @@ ibm_partition(struct parsed_partitions *state, struct block_device *bdev)
 	} *label;
 	unsigned char *data;
 	Sector sect;
+	sector_t labelsect;
 
 	res = 0;
 	blocksize = bdev_logical_block_size(bdev);
@@ -98,9 +99,19 @@ ibm_partition(struct parsed_partitions *state, struct block_device *bdev)
 		goto out_freeall;
 
 	/*
+	 * Special case for FBA disks: label sector does not depend on
+	 * blocksize.
+	 */
+	if ((info->cu_type == 0x6310 && info->dev_type == 0x9336) ||
+	    (info->cu_type == 0x3880 && info->dev_type == 0x3370))
+		labelsect = info->label_block;
+	else
+		labelsect = info->label_block * (blocksize >> 9);
+
+	/*
 	 * Get volume label, extract name and type.
 	 */
-	data = read_dev_sector(bdev, info->label_block*(blocksize/512), &sect);
+	data = read_dev_sector(bdev, labelsect, &sect);
 	if (data == NULL)
 		goto out_readerr;
 
-- 
1.7.3.3

