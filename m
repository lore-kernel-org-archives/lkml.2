Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757099Ab2FYPJE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 11:09:04 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:35843 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330Ab2FYPJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 11:09:03 -0400
From: Richard Genoud <richard.genoud@gmail.com>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH] UBI: add minimal amount of reserved erase blocks in Kconfig
Date: Mon, 25 Jun 2012 17:08:38 +0200
Message-Id: <1340636918-7505-1-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On NAND flash devices, UBI reserves some physical erase blocks (PEB) for
bad block handling.
Today, the number of reserved PEB can only be set as a percentage of the
total number of PEB in each UBI volume.
For example, for a NAND flash with 128KiB PEB, 2 MTD partition of 20MiB
(mtd0) and 100MiB (mtd1) and 2% reserved PEB:
- the UBI volume on mtd0 will have 2 PEB reserved
- the UBI volume on mtd1 will have 16 PEB reserved

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
bad PEB for each UBI volume.
(Worst case scenario: 20 bad blocks appears on the smallest UBI volume.)

=> The actual parameter MTD_UBI_BEB_RESERVE is not enough to cover this
scenario. We need to set a minimal number of reserved PEB for a UBI
volume.

That's what this patch introduce.

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
---
 drivers/mtd/ubi/Kconfig |   18 ++++++++++++++++++
 drivers/mtd/ubi/misc.c  |    5 +++--
 drivers/mtd/ubi/ubi.h   |    3 ---
 3 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/mtd/ubi/Kconfig b/drivers/mtd/ubi/Kconfig
index 738ee8d..6770b96 100644
--- a/drivers/mtd/ubi/Kconfig
+++ b/drivers/mtd/ubi/Kconfig
@@ -27,6 +27,24 @@ config MTD_UBI_WL_THRESHOLD
 	  life-cycle less than 10000, the threshold should be lessened (e.g.,
 	  to 128 or 256, although it does not have to be power of 2).
 
+config MTD_UBI_BEB_MIN_RESERVE
+	int "Minimal number of reserved eraseblocks for bad eraseblocks handling"
+	default 2
+	range 0 2147483647
+	depends on MTD_UBI
+	help
+	  If the MTD device admits of bad eraseblocks (e.g. NAND flash), UBI
+	  reserves some amount of physical eraseblocks to handle new bad
+	  eraseblocks. For example, if a flash physical eraseblock becomes bad,
+	  UBI uses these reserved physical eraseblocks to relocate the bad one.
+	  This option specifies the minimal amount of eraseblocks that will be
+	  reserved for bad eraseblock handling.
+	  If the device has less or as many eraseblocks as this value, the
+	  percentage value (MTD_UBI_BEB_RESERVE) is used.
+	  If the underlying flash does not admit of bad eraseblocks (e.g. NOR
+	  flash), this value is ignored and nothing is reserved.
+	  Leave the default value if unsure.
+
 config MTD_UBI_BEB_RESERVE
 	int "Percentage of reserved eraseblocks for bad eraseblocks handling"
 	default 1
diff --git a/drivers/mtd/ubi/misc.c b/drivers/mtd/ubi/misc.c
index f6a7d7a..c2c6db0 100644
--- a/drivers/mtd/ubi/misc.c
+++ b/drivers/mtd/ubi/misc.c
@@ -100,8 +100,9 @@ void ubi_calculate_reserved(struct ubi_device *ubi)
 {
 	ubi->beb_rsvd_level = ubi->good_peb_count/100;
 	ubi->beb_rsvd_level *= CONFIG_MTD_UBI_BEB_RESERVE;
-	if (ubi->beb_rsvd_level < MIN_RESEVED_PEBS)
-		ubi->beb_rsvd_level = MIN_RESEVED_PEBS;
+	if ((ubi->beb_rsvd_level < CONFIG_MTD_UBI_BEB_MIN_RESERVE) &&
+	    (ubi->good_peb_count > CONFIG_MTD_UBI_BEB_MIN_RESERVE))
+		ubi->beb_rsvd_level = CONFIG_MTD_UBI_BEB_MIN_RESERVE;
 }
 
 /**
diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
index a1a81c9..d321c74 100644
--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -59,9 +59,6 @@
 #define ubi_err(fmt, ...) printk(KERN_ERR "UBI error: %s: " fmt "\n", \
 				 __func__, ##__VA_ARGS__)
 
-/* Lowest number PEBs reserved for bad PEB handling */
-#define MIN_RESEVED_PEBS 2
-
 /* Background thread name pattern */
 #define UBI_BGT_NAME_PATTERN "ubi_bgt%dd"
 
-- 
1.7.2.5

