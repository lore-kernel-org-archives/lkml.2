Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308Ab2HZFUs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 01:20:48 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50219 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415Ab2HZFUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 01:20:31 -0400
From: Huang Shijie <shijie8@gmail.com>
To: dwmw2@infradead.org
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        dedekind1@gmail.com, shmulik.ladkani@gmail.com,
        Huang Shijie <shijie8@gmail.com>
Subject: [PATCH 2/3] mtd: cmdlinepart: sort the unsorted partitions
Date: Sun, 26 Aug 2012 13:21:39 -0400
Message-Id: <1346001700-26895-2-git-send-email-shijie8@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1346001700-26895-1-git-send-email-shijie8@gmail.com>
References: <1346001700-26895-1-git-send-email-shijie8@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Assume we have a 1GB(8Gb) nand chip.
It is legit if we set the partitions as the following:
    gpmi-nand:1g@200m(rootfs),100m@0(boot),100m@100m(kernel)

But the current code can not parse out any partition with this
cmdline.

This patch sorts the unsorted partitions by the @offset.
For there are maybe only several partitions, i use the simple
Bubble sort algorithm.

Signed-off-by: Huang Shijie <shijie8@gmail.com>
---
 drivers/mtd/cmdlinepart.c |   29 +++++++++++++++++++++++++++++
 1 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/cmdlinepart.c b/drivers/mtd/cmdlinepart.c
index 0b7b2ad..f40d390 100644
--- a/drivers/mtd/cmdlinepart.c
+++ b/drivers/mtd/cmdlinepart.c
@@ -234,6 +234,32 @@ static struct mtd_partition * newpart(char *s,
 	return parts;
 }
 
+/* There are only several partitions, so the Bubble sort is enough. */
+static inline void sort_partitons(struct mtd_partition *parts, int num_parts)
+{
+	int i, j;
+
+	if (num_parts < 2)
+		return;
+
+	if (parts[0].offset == OFFSET_CONTINUOUS)
+		return;
+
+	/* sort by the offset */
+	for (i = 0; i < num_parts - 1; i++) {
+		for (j = 1; j < num_parts - i; j++) {
+			if (parts[j - 1].offset > parts[j].offset) {
+				struct mtd_partition tmp;
+
+				tmp = parts[j - 1];
+				parts[j - 1] = parts[j];
+				parts[j] = tmp;
+			}
+		}
+	}
+	return;
+}
+
 /*
  * Parse the command line.
  */
@@ -292,6 +318,9 @@ static int mtdpart_setup_real(char *s)
 		this_mtd->mtd_id = (char*)(this_mtd + 1);
 		strlcpy(this_mtd->mtd_id, mtd_id, mtd_id_len + 1);
 
+		/* sort the partitions */
+		sort_partitons(parts, num_parts);
+
 		/* link into chain */
 		this_mtd->next = partitions;
 		partitions = this_mtd;
-- 
1.7.4.4

