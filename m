Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757976Ab2HQOhg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 10:37:36 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:62831 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758045Ab2HQOgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 10:36:02 -0400
From: Richard Genoud <richard.genoud@gmail.com>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Shmulik Ladkani <shmulik.ladkani@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org,
        Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH 8/8] UBI: drop CONFIG_MTD_UBI_BEB_LIMIT
Date: Fri, 17 Aug 2012 16:35:24 +0200
Message-Id: <1345214124-5478-9-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1345214124-5478-1-git-send-email-richard.genoud@gmail.com>
References: <1345214124-5478-1-git-send-email-richard.genoud@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This option can be set by a kernel parameter and an ioctl, so we may not
need the kernel config option any more.

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
---
 arch/arm/configs/sam9_l9260_defconfig |    1 -
 drivers/mtd/ubi/Kconfig               |   29 -----------------------------
 drivers/mtd/ubi/build.c               |    4 ++--
 drivers/mtd/ubi/ubi.h                 |    3 +++
 include/mtd/ubi-user.h                |    2 +-
 5 files changed, 6 insertions(+), 33 deletions(-)

diff --git a/arch/arm/configs/sam9_l9260_defconfig b/arch/arm/configs/sam9_l9260_defconfig
index d11fea5..47dd71a 100644
--- a/arch/arm/configs/sam9_l9260_defconfig
+++ b/arch/arm/configs/sam9_l9260_defconfig
@@ -39,7 +39,6 @@ CONFIG_MTD_NAND=y
 CONFIG_MTD_NAND_ATMEL=y
 CONFIG_MTD_NAND_PLATFORM=y
 CONFIG_MTD_UBI=y
-CONFIG_MTD_UBI_BEB_LIMIT=30
 CONFIG_MTD_UBI_GLUEBI=y
 CONFIG_BLK_DEV_LOOP=y
 CONFIG_BLK_DEV_RAM=y
diff --git a/drivers/mtd/ubi/Kconfig b/drivers/mtd/ubi/Kconfig
index 56531a7..7a57cc0 100644
--- a/drivers/mtd/ubi/Kconfig
+++ b/drivers/mtd/ubi/Kconfig
@@ -27,35 +27,6 @@ config MTD_UBI_WL_THRESHOLD
 	  life-cycle less than 10000, the threshold should be lessened (e.g.,
 	  to 128 or 256, although it does not have to be power of 2).
 
-config MTD_UBI_BEB_LIMIT
-	int "Maximum expected bad eraseblock count per 1024 eraseblocks"
-	default 20
-	range 2 256
-	help
-	  This option specifies the maximum bad physical eraseblocks UBI
-	  expects on the MTD device (per 1024 eraseblocks). If the underlying
-	  flash does not admit of bad eraseblocks (e.g. NOR flash), this value
-	  is ignored.
-
-	  NAND datasheets often specify the minimum and maximum NVM (Number of
-	  Valid Blocks) for the flashes' endurance lifetime. The maximum
-	  expected bad eraseblocks per 1024 eraseblocks then can be calculated
-	  as "1024 * (1 - MinNVB / MaxNVB)", which gives 20 for most NANDs
-	  (MaxNVB is basically the total count of eraseblocks on the chip).
-
-	  To put it differently, if this value is 20, UBI will try to reserve
-	  about 1.9% of physical eraseblocks for bad blocks handling. And that
-	  will be 1.9% of eraseblocks on the entire NAND chip, not just the MTD
-	  partition UBI attaches. This means that if you have, say, a NAND
-	  flash chip admits maximum 40 bad eraseblocks, and it is split on two
-	  MTD partitions of the same size, UBI will reserve 40 eraseblocks when
-	  attaching a partition.
-
-	  This option can be overridden by the kernel parameter ubi.mtd and the
-	  ioctl UBI_IOCATT.
-
-	  Leave the default value if unsure.
-
 config MTD_UBI_GLUEBI
 	tristate "MTD devices emulation driver (gluebi)"
 	help
diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
index cc05022..d940a12 100644
--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -865,7 +865,7 @@ int ubi_attach_mtd_dev(struct mtd_info *mtd, int ubi_num,
 	 * behavior between ubiattach command and module parameter
 	 */
 	if (!max_beb_per1024)
-		max_beb_per1024 = CONFIG_MTD_UBI_BEB_LIMIT;
+		max_beb_per1024 = MTD_UBI_DEFAULT_BEB_LIMIT;
 
 	/*
 	 * Check if we already have the same MTD device attached.
@@ -1411,7 +1411,7 @@ MODULE_PARM_DESC(mtd, "MTD devices to attach. Parameter format: mtd=<name|num|pa
 		      "MTD devices may be specified by their number, name, or path to the MTD character device node.\n"
 		      "Optional \"vid_hdr_offs\" parameter specifies UBI VID header position to be used by UBI. (default value if 0 or not set)\n"
 		      "Optional \"max_beb_per1024\" parameter specifies the maximum expected bad eraseblock per 1024 eraseblocks. (default value ("
-		      __stringify(CONFIG_MTD_UBI_BEB_LIMIT) ") if 0 or not set)\n"
+		      __stringify(MTD_UBI_DEFAULT_BEB_LIMIT) ") if 0 or not set)\n"
 		      "\n"
 		      "Example 1: mtd=/dev/mtd0 - attach MTD device /dev/mtd0.\n"
 		      "Example 2: mtd=content,1984 mtd=4 - attach MTD device with name \"content\" using VID header offset 1984, and MTD device number 4 with default VID header offset.\n"
diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
index 2a2475b..2148f35 100644
--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -50,6 +50,9 @@
 /* UBI name used for character devices, sysfs, etc */
 #define UBI_NAME_STR "ubi"
 
+/* Default number of maximum expected bad blocks per 1024 eraseblocks */
+#define MTD_UBI_DEFAULT_BEB_LIMIT 20
+
 /* Normal UBI messages */
 #define ubi_msg(fmt, ...) printk(KERN_NOTICE "UBI: " fmt "\n", ##__VA_ARGS__)
 /* UBI warning messages */
diff --git a/include/mtd/ubi-user.h b/include/mtd/ubi-user.h
index 8168d9b..0b25f4c 100644
--- a/include/mtd/ubi-user.h
+++ b/include/mtd/ubi-user.h
@@ -260,7 +260,7 @@ enum {
  * any physical eraseblocks for new bad eraseblocks, but attempts to use
  * available eraseblocks (if any).
  * The accepted range is 0-255. If 0 is given, the default kernel config value
- * CONFIG_MTD_UBI_BEB_LIMIT will be used for compatibility.
+ * MTD_UBI_DEFAULT_BEB_LIMIT will be used for compatibility.
  */
 struct ubi_attach_req {
 	__s32 ubi_num;
-- 
1.7.2.5

