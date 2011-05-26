Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757736Ab1EZM4U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 08:56:20 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:51405 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757670Ab1EZM4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 08:56:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=MqYI2ynprbRhbjUqkfk07lmMwr34dydQp9Kb+j3h7fOCcI8cTLuU2H277T1CrC3OLb
         O2Pz+eGES/CibFweNP8C7qJRVVoI7Vfw3MlrciAbk2oPRG6Gdcxj65J8TmaxhtoXevIf
         A9EMHtD1jk1twPePXPwE8HD8PbGwHZvabb28w=
From: Namhyung Kim <namhyung@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, Nick Piggin <npiggin@kernel.dk>
Cc: linux-kernel@vger.kernel.org, Laurent Vivier <Laurent.Vivier@bull.net>
Subject: [PATCH 5/5] brd: export module parameters
Date: Thu, 26 May 2011 21:55:57 +0900
Message-Id: <1306414557-2441-6-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.5.2
In-Reply-To: <1306414557-2441-1-git-send-email-namhyung@gmail.com>
References: <1306414557-2441-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export 'rd_nr', 'rd_size' and 'max_part' parameters to sysfs so user can
know that how many devices are allowed, how big each device is and how
many partitions are supported. If 'max_part' is 0, it means simply the
device doesn't support partitioning.

Also note that 'max_part' can be adjusted to power of 2 minus 1 form if
needed. User should check this value after the module loading if he/she
want to use that number correctly (i.e. fdisk, mknod, etc.).

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Laurent Vivier <Laurent.Vivier@bull.net>
---
 drivers/block/brd.c |   19 +++++++++++++++----
 1 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index d904d0da2928..dba1c32e1ddf 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -436,11 +436,11 @@ static int rd_nr;
 int rd_size = CONFIG_BLK_DEV_RAM_SIZE;
 static int max_part;
 static int part_shift;
-module_param(rd_nr, int, 0);
+module_param(rd_nr, int, S_IRUGO);
 MODULE_PARM_DESC(rd_nr, "Maximum number of brd devices");
-module_param(rd_size, int, 0);
+module_param(rd_size, int, S_IRUGO);
 MODULE_PARM_DESC(rd_size, "Size of each RAM disk in kbytes.");
-module_param(max_part, int, 0);
+module_param(max_part, int, S_IRUGO);
 MODULE_PARM_DESC(max_part, "Maximum number of partitions per RAM disk");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_BLOCKDEV_MAJOR(RAMDISK_MAJOR);
@@ -578,9 +578,20 @@ static int __init brd_init(void)
 	 */
 
 	part_shift = 0;
-	if (max_part > 0)
+	if (max_part > 0) {
 		part_shift = fls(max_part);
 
+		/*
+		 * Adjust max_part according to part_shift as it is exported
+		 * to user space so that user can decide correct minor number
+		 * if [s]he want to create more devices.
+		 *
+		 * Note that -1 is required because partition 0 is reserved
+		 * for the whole disk.
+		 */
+		max_part = (1UL << part_shift) - 1;
+	}
+
 	if ((1UL << part_shift) > DISK_MAX_PARTS)
 		return -EINVAL;
 
-- 
1.7.5.2

