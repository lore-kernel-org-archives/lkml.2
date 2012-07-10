Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247Ab2GJQYV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 12:24:21 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:38141 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756282Ab2GJQYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 12:24:13 -0400
From: Richard Genoud <richard.genoud@gmail.com>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH 3/4] UBI: use the whole MTD device size to get bad_peb_limit
Date: Tue, 10 Jul 2012 18:23:41 +0200
Message-Id: <1341937423-16516-4-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1341937423-16516-1-git-send-email-richard.genoud@gmail.com>
References: <1341937423-16516-1-git-send-email-richard.genoud@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On NAND flash devices, UBI reserves some physical erase blocks (PEB) for
bad block handling.
Today, the number of reserved PEB can only be set as a percentage of the
total number of PEB in each MTD partition.
For example, for a NAND flash with 128KiB PEB, 2 MTD partition of 20MiB
(mtd0) and 100MiB (mtd1) and 2% reserved PEB:
- the UBI device on mtd0 will have 2 PEB reserved
- the UBI device on mtd1 will have 16 PEB reserved

The problem with this behaviour is that NAND flash manufacturers give a
minimum number of valid block (NVB) during the endurance life of the
device.
E.G.:
Parameter             Symbol    Min    Max    Unit      Notes
--------------------------------------------------------------
Valid block number     NVB     1004    1024   Blocks     1
Note:
1. Invalid blocks are block that contain one or more bad bits beyond
ECC. The device may contain bad blocks upon shipment. Additional bad
blocks may develop over time; however, the total number of available
blocks will not drop below NVB during the endurance life of the device.

>From this number we can deduce the maximum number of bad PEB that a
device will contain during its endurance life :
A 128MiB NAND flash (1024 PEB) will not have less than 20 bad blocks
during the flash endurance life.

BUT, the manufacturer doesn't tell where those bad block will appear. He
doesn't say either if they will be equally disposed on the whole device
(and I'm pretty sure they won't).
So, according to the datasheets, we should reserve the maximum number of
bad PEB for each UBI device.
(Worst case scenario: 20 bad blocks appears on the smallest MTD
partition.)

So this patch make UBI use the whole MTD device size to calculate the
Maximum bad expected eraseblocks.

The Kconfig option is in per1024 blocks, thus it can have a default
value of 20 which is *very* common for NAND devices.

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
---
 drivers/mtd/ubi/Kconfig |   14 ++++++++++----
 drivers/mtd/ubi/build.c |   17 ++++++++++++++---
 2 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/drivers/mtd/ubi/Kconfig b/drivers/mtd/ubi/Kconfig
index 145cda2..b77ffe1 100644
--- a/drivers/mtd/ubi/Kconfig
+++ b/drivers/mtd/ubi/Kconfig
@@ -28,15 +28,21 @@ config MTD_UBI_WL_THRESHOLD
 	  to 128 or 256, although it does not have to be power of 2).
 
 config MTD_UBI_BEB_LIMIT
-	int "Percentage of maximum expected bad eraseblocks"
-	default 2
-	range 0 25
+	int "Maximum expected bad eraseblocks per 1024 eraseblocks"
+	default 20
+	range 2 256
 	help
 	  If the MTD device admits of bad eraseblocks (e.g. NAND flash), UBI
 	  reserves some amount of physical eraseblocks to handle new bad
 	  eraseblocks.
 	  This option specifies the maximum bad eraseblocks UBI expects on the
-	  ubi device (percents of total number of flash eraseblocks).
+	  ubi device per 1024 eraseblocks.
+	  This value is often given in an other form in the NAND datasheet
+	  (min NVB i.e. minimal number of valid blocks). The maximum expected
+	  bad eraseblocks per 1024 is then:
+	    1024 * (1 - MinNVB / MaxNVB)
+	  Which gives 20 for most NAND devices.
+
 	  This limit is used in order to derive amount of eraseblock UBI
 	  reserves for handling new bad blocks.
 	  If the device has more bad eraseblocks than this limit, UBI does not
diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
index 62cc6ce..87b39c2 100644
--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -36,6 +36,7 @@
 #include <linux/namei.h>
 #include <linux/stat.h>
 #include <linux/miscdevice.h>
+#include <linux/mtd/partitions.h>
 #include <linux/log2.h>
 #include <linux/kthread.h>
 #include <linux/kernel.h>
@@ -610,12 +611,22 @@ static int io_init(struct ubi_device *ubi)
 	if (mtd_can_have_bb(ubi->mtd)) {
 		ubi->bad_allowed = 1;
 		if (CONFIG_MTD_UBI_BEB_LIMIT > 0) {
-			int percent = CONFIG_MTD_UBI_BEB_LIMIT;
+			int per1024 = CONFIG_MTD_UBI_BEB_LIMIT;
+			int device_peb_count;
+			uint64_t device_size;
 			int beb_limit;
 
-			beb_limit = mult_frac(ubi->peb_count, percent, 100);
+			/* we are using here the whole MTD device size and not
+			 * the MTD partition size because the maximum number of
+			 * bad blocks is a percentage of the whole device and
+			 * the bad blocks are not fairly disposed on a flash
+			 * device
+			 */
+			device_size = mtd_get_device_size(ubi->mtd);
+			device_peb_count = mtd_div_by_eb(device_size, ubi->mtd);
+			beb_limit = mult_frac(device_peb_count, per1024, 1024);
 			/* round it up */
-			if (mult_frac(beb_limit, 100, percent) < ubi->peb_count)
+			if (mult_frac(beb_limit, 1024, per1024) < ubi->peb_count)
 				beb_limit++;
 			ubi->bad_peb_limit = beb_limit;
 		}
-- 
1.7.2.5

