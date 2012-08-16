Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932769Ab2HPOym (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 10:54:42 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:65370 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932331Ab2HPOyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 10:54:39 -0400
From: Richard Genoud <richard.genoud@gmail.com>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: linux-mtd@lists.infradead.org, Shmulik Ladkani <shmulik.ladkani@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH] UBI: use a config value for default BEB limit
Date: Thu, 16 Aug 2012 16:54:31 +0200
Message-Id: <1345128871-14939-1-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <CACQ1gAhRYSYehym1qA_Oj71KU4fB2+1MEUGi5Wfnb+E=t3jcxA@mail.gmail.com>
References: <CACQ1gAhRYSYehym1qA_Oj71KU4fB2+1MEUGi5Wfnb+E=t3jcxA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provides the possibility to adjust the default value for
"maximum expected number of bad blocks per 1024 blocks" from kernel
configuration.

sam9_l9260_defconfig has been adjusted as well. The nand device used by
this card has a NVB of 3996/4096 ie a MAX_BEB_LIMIT of 25/1024

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
---
 arch/arm/configs/sam9_l9260_defconfig |    1 +
 drivers/mtd/ubi/Kconfig               |   29 +++++++++++++++++++++++++++++
 drivers/mtd/ubi/ubi.h                 |    2 +-
 3 files changed, 31 insertions(+), 1 deletions(-)

diff --git a/arch/arm/configs/sam9_l9260_defconfig b/arch/arm/configs/sam9_l9260_defconfig
index 47dd71a..2c20c9e 100644
--- a/arch/arm/configs/sam9_l9260_defconfig
+++ b/arch/arm/configs/sam9_l9260_defconfig
@@ -39,6 +39,7 @@ CONFIG_MTD_NAND=y
 CONFIG_MTD_NAND_ATMEL=y
 CONFIG_MTD_NAND_PLATFORM=y
 CONFIG_MTD_UBI=y
+CONFIG_MTD_UBI_DEFAULT_BEB_LIMIT=25
 CONFIG_MTD_UBI_GLUEBI=y
 CONFIG_BLK_DEV_LOOP=y
 CONFIG_BLK_DEV_RAM=y
diff --git a/drivers/mtd/ubi/Kconfig b/drivers/mtd/ubi/Kconfig
index 7a57cc0..30e8370 100644
--- a/drivers/mtd/ubi/Kconfig
+++ b/drivers/mtd/ubi/Kconfig
@@ -27,6 +27,35 @@ config MTD_UBI_WL_THRESHOLD
 	  life-cycle less than 10000, the threshold should be lessened (e.g.,
 	  to 128 or 256, although it does not have to be power of 2).
 
+config MTD_UBI_DEFAULT_BEB_LIMIT
+	int "Maximum expected bad eraseblock count per 1024 eraseblocks"
+	default 20
+	range 0 256
+	help
+	  This option specifies the default value for maximum bad physical
+	  eraseblocks UBI expects on the MTD device (per 1024 eraseblocks).
+	  It will be used when the maximum bad PEB value is null in the
+	  UBI_IOCATT ioctl (e.g. when calling ubiattach) or in the kernel
+	  parameter ubi.mtd.
+	  If the underlying flash does not admit of bad eraseblocks
+	  (e.g. NOR flash), this value is ignored.
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
+	  partition UBI attaches. This means that if you have, say,  a NAND
+	  flash chip that admits a maximum 40 bad eraseblocks, and it is split
+	  on two MTD partitions of the same size, UBI will reserve 40
+	  eraseblocks when attaching a partition.
+
+	  Leave the default value if unsure.
+
 config MTD_UBI_GLUEBI
 	tristate "MTD devices emulation driver (gluebi)"
 	help
diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
index f926343..39a1e7e 100644
--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -51,7 +51,7 @@
 #define UBI_NAME_STR "ubi"
 
 /* Default number of maximum expected bad blocks per 1024 eraseblocks */
-#define MTD_UBI_DEFAULT_BEB_LIMIT 20
+#define MTD_UBI_DEFAULT_BEB_LIMIT CONFIG_MTD_UBI_DEFAULT_BEB_LIMIT
 
 /* Normal UBI messages */
 #define ubi_msg(fmt, ...) printk(KERN_NOTICE "UBI: " fmt "\n", ##__VA_ARGS__)
-- 
1.7.2.5

