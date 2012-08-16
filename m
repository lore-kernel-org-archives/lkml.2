Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932202Ab2HPNKX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 09:10:23 -0400
Received: from mga01.intel.com ([192.55.52.88]:27094 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932107Ab2HPNKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 09:10:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,778,1336374000"; 
   d="scan'208";a="202652258"
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Richard Genoud <richard.genoud@gmail.com>,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>
Cc: MTD Maling List <linux-mtd@lists.infradead.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] UBI: use the whole MTD device size to get bad_peb_limit
Date: Thu, 16 Aug 2012 16:10:26 +0300
Message-Id: <1345122627-27151-1-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1341937423-16516-1-git-send-email-richard.genoud@gmail.com>
References: <1341937423-16516-1-git-send-email-richard.genoud@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Genoud <richard.genoud@gmail.com>

On NAND flash devices, UBI reserves some physical erase blocks (PEB) for
bad block handling. Today, the number of reserved PEB can only be set as a
percentage of the total number of PEB in each MTD partition. For example, for a
NAND flash with 128KiB PEB, 2 MTD partition of 20MiB (mtd0) and 100MiB (mtd1)
and 2% reserved PEB:
 - the UBI device on mtd0 will have 2 PEB reserved
 - the UBI device on mtd1 will have 16 PEB reserved

The problem with this behaviour is that NAND flash manufacturers give a
minimum number of valid block (NVB) during the endurance life of the
device, e.g.:

Parameter             Symbol    Min    Max    Unit      Notes
--------------------------------------------------------------
Valid block number     NVB     1004    1024   Blocks     1

>From this number we can deduce the maximum number of bad PEB that a device will
contain during its endurance life: a 128MiB NAND flash (1024 PEB) will not have
less than 20 bad blocks during the flash endurance life.

But the manufacturer doesn't tell where those bad block will appear. He doesn't
say either if they will be equally disposed on the whole device (and I'm pretty
sure they won't). So, according to the datasheets, we should reserve the
maximum number of bad PEB for each UBI device (worst case scenario: 20 bad
blocks appears on the smallest MTD partition).

So this patch make UBI use the whole MTD device size to calculate the maximum
bad expected eraseblocks.

The Kconfig option is in per1024 blocks, thus it can have a default value of 20
which is *very* common for NAND devices.

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 drivers/mtd/ubi/Kconfig |   27 +++++++++++++++++++++------
 drivers/mtd/ubi/build.c |   21 ++++++++++++++++++---
 2 files changed, 39 insertions(+), 9 deletions(-)

diff --git a/drivers/mtd/ubi/Kconfig b/drivers/mtd/ubi/Kconfig
index b2f4f0f..f326877 100644
--- a/drivers/mtd/ubi/Kconfig
+++ b/drivers/mtd/ubi/Kconfig
@@ -28,14 +28,29 @@ config MTD_UBI_WL_THRESHOLD
 	  to 128 or 256, although it does not have to be power of 2).
 
 config MTD_UBI_BEB_LIMIT
-	int "Percentage of maximum expected bad eraseblocks"
-	default 2
-	range 0 25
+	int "Maximum expected bad eraseblock count per 1024 eraseblocks"
+	default 20
+	range 2 256
 	help
 	  This option specifies the maximum bad physical eraseblocks UBI
-	  expects on the UBI device (percents of total number of physical
-	  eraseblocks on this MTD partition). If the underlying flash does not
-	  admit of bad eraseblocks (e.g. NOR flash), this value is ignored.
+	  expects on the MTD device (per 1024 eraseblocks). If the underlying
+	  flash does not admit of bad eraseblocks (e.g. NOR flash), this value
+	  is ignored.
+
+	  NAND datasheets often specify the minimum and maximum NVM (Number of
+	  Valid Blocks) for the flashes' endurance lifetime. The maximum
+	  expected bad eraseblocks per 1024 eraseblocks then can be calculated
+	  as "1024 * (1 - MinNVB / MaxNVB)", which gives 20 for most NANDs
+	  (MaxNVB is basically the total count of eraseblocks on the chip).
+
+	  To put it differently, if this value is 20, UBI will try to reserve
+	  about 1.9% of physical eraseblocks for bad blocks handling. And that
+	  will be 1.9% of eraseblocks on the entire NAND chip, not just the MTD
+	  partition UBI attaches. This means that if you have, say, a NAND
+	  flash chip admits maximum 40 bad eraseblocks, and it is split on two
+	  MTD partitions of the same size, UBI will reserve 40 eraseblocks when
+	  attaching a partition.
+
 	  Leave the default value if unsure.
 
 config MTD_UBI_GLUEBI
diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
index 7b6b5f9..738772c 100644
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
@@ -610,11 +611,25 @@ static int io_init(struct ubi_device *ubi)
 	if (mtd_can_have_bb(ubi->mtd)) {
 		ubi->bad_allowed = 1;
 		if (CONFIG_MTD_UBI_BEB_LIMIT > 0) {
-			int percent = CONFIG_MTD_UBI_BEB_LIMIT;
-			int limit = mult_frac(ubi->peb_count, percent, 100);
+			int per1024 = CONFIG_MTD_UBI_BEB_LIMIT;
+			int limit, device_pebs;
+			uint64_t device_size;
+
+			/*
+			 * Here we are using size of the entire flash chip and
+			 * not just the MTD partition size because the maximum
+			 * number of bad eraseblocks is a percentage of the
+			 * whole device and bad eraseblocks are not fairly
+			 * distributed over the flash chip. So the worst case
+			 * is that all the bad eraseblocks of the chip are in
+			 * the MTD partition we are attaching (ubi->mtd).
+			 */
+			device_size = mtd_get_device_size(ubi->mtd);
+			device_pebs = mtd_div_by_eb(device_size, ubi->mtd);
+			limit = mult_frac(device_pebs, per1024, 1024);
 
 			/* Round it up */
-			if (mult_frac(limit, 100, percent) < ubi->peb_count)
+			if (mult_frac(limit, 1024, per1024) < device_pebs)
 				limit += 1;
 			ubi->bad_peb_limit = limit;
 		}
-- 
1.7.10.4

