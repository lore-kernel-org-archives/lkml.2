Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933762Ab2GDIHl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 04:07:41 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:46806 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932767Ab2GDIHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 04:07:34 -0400
From: Shmulik Ladkani <shmulik.ladkani@gmail.com>
To: Artem Bityutskiy <dedekind1@gmail.com>, Andrew Victor <linux@maxim.org.za>
Cc: Shmulik Ladkani <shmulik.ladkani@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org, Richard Weinberger <richard@nod.at>,
        Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH 1/5] ubi: introduce ubi->bad_peb_limit
Date: Wed,  4 Jul 2012 11:06:00 +0300
Message-Id: <1341389164-24409-2-git-send-email-shmulik.ladkani@gmail.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1341389164-24409-1-git-send-email-shmulik.ladkani@gmail.com>
References: <1341389164-24409-1-git-send-email-shmulik.ladkani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce 'ubi->bad_peb_limit', which specifies an upper limit of PEBs
ubi expects to go bad.
Currently, it is initialized to a fixed percentage of total PEBs in the
ubi device (configurable via CONFIG_MTD_UBI_BEB_LIMIT).

The 'bad_peb_limit' is intended to be used for calculating the amount of
PEBs ubi needs to reserve for bad eraseblock handling.

Signed-off-by: Shmulik Ladkani <shmulik.ladkani@gmail.com>
---
 arch/arm/configs/sam9_l9260_defconfig |    1 +
 drivers/mtd/ubi/Kconfig               |   11 +++++++++++
 drivers/mtd/ubi/build.c               |   13 ++++++++++++-
 drivers/mtd/ubi/ubi.h                 |    2 ++
 4 files changed, 26 insertions(+), 1 deletions(-)

diff --git a/arch/arm/configs/sam9_l9260_defconfig b/arch/arm/configs/sam9_l9260_defconfig
index ecf2531..f6917c9 100644
--- a/arch/arm/configs/sam9_l9260_defconfig
+++ b/arch/arm/configs/sam9_l9260_defconfig
@@ -40,6 +40,7 @@ CONFIG_MTD_NAND_ATMEL=y
 CONFIG_MTD_NAND_PLATFORM=y
 CONFIG_MTD_UBI=y
 CONFIG_MTD_UBI_BEB_RESERVE=3
+CONFIG_MTD_UBI_BEB_LIMIT=3
 CONFIG_MTD_UBI_GLUEBI=y
 CONFIG_BLK_DEV_LOOP=y
 CONFIG_BLK_DEV_RAM=y
diff --git a/drivers/mtd/ubi/Kconfig b/drivers/mtd/ubi/Kconfig
index 738ee8d..8df256f 100644
--- a/drivers/mtd/ubi/Kconfig
+++ b/drivers/mtd/ubi/Kconfig
@@ -42,6 +42,17 @@ config MTD_UBI_BEB_RESERVE
 	  eraseblocks (e.g. NOR flash), this value is ignored and nothing is
 	  reserved. Leave the default value if unsure.
 
+config MTD_UBI_BEB_LIMIT
+	int "Percentage of maximum expected bad eraseblocks"
+	default 2
+	range 0 25
+	help
+	  This option specifies the maximum bad eraseblocks UBI expects on the
+	  ubi device (percents of total number of flash eraseblocks).
+	  If the underlying flash does not admit of bad eraseblocks (e.g. NOR
+	  flash), this value is ignored.
+	  Leave the default value if unsure.
+
 config MTD_UBI_GLUEBI
 	tristate "MTD devices emulation driver (gluebi)"
 	help
diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
index 2c5ed5c..62cc6ce 100644
--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -607,8 +607,19 @@ static int io_init(struct ubi_device *ubi)
 	ubi->peb_count  = mtd_div_by_eb(ubi->mtd->size, ubi->mtd);
 	ubi->flash_size = ubi->mtd->size;
 
-	if (mtd_can_have_bb(ubi->mtd))
+	if (mtd_can_have_bb(ubi->mtd)) {
 		ubi->bad_allowed = 1;
+		if (CONFIG_MTD_UBI_BEB_LIMIT > 0) {
+			int percent = CONFIG_MTD_UBI_BEB_LIMIT;
+			int beb_limit;
+
+			beb_limit = mult_frac(ubi->peb_count, percent, 100);
+			/* round it up */
+			if (mult_frac(beb_limit, 100, percent) < ubi->peb_count)
+				beb_limit++;
+			ubi->bad_peb_limit = beb_limit;
+		}
+	}
 
 	if (ubi->mtd->type == MTD_NORFLASH) {
 		ubi_assert(ubi->mtd->writesize == 1);
diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
index a1a81c9..b5217ef 100644
--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -363,6 +363,7 @@ struct ubi_wl_entry;
  * @flash_size: underlying MTD device size (in bytes)
  * @peb_count: count of physical eraseblocks on the MTD device
  * @peb_size: physical eraseblock size
+ * @bad_peb_limit: top limit of expected bad physical eraseblocks
  * @bad_peb_count: count of bad physical eraseblocks
  * @good_peb_count: count of good physical eraseblocks
  * @corr_peb_count: count of corrupted physical eraseblocks (preserved and not
@@ -410,6 +411,7 @@ struct ubi_device {
 	int avail_pebs;
 	int beb_rsvd_pebs;
 	int beb_rsvd_level;
+	int bad_peb_limit;
 
 	int autoresize_vol_id;
 	int vtbl_slots;
-- 
1.7.9

