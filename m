Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758059Ab2HQOgQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 10:36:16 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:51378 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758035Ab2HQOfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 10:35:54 -0400
From: Richard Genoud <richard.genoud@gmail.com>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Shmulik Ladkani <shmulik.ladkani@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org,
        Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH 2/8] UBI: separate bad_peb_limit in a function
Date: Fri, 17 Aug 2012 16:35:18 +0200
Message-Id: <1345214124-5478-3-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1345214124-5478-1-git-send-email-richard.genoud@gmail.com>
References: <1345214124-5478-1-git-send-email-richard.genoud@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional changes here, just to prepare for next patch.

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
---
 drivers/mtd/ubi/build.c |   57 ++++++++++++++++++++++++++++-------------------
 1 files changed, 34 insertions(+), 23 deletions(-)

diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
index 738772c..82d11e1 100644
--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -565,6 +565,37 @@ void ubi_free_internal_volumes(struct ubi_device *ubi)
 	}
 }
 
+static int get_bad_peb_limit(const struct ubi_device *ubi, int max_beb_per1024)
+{
+	int limit, device_pebs;
+	uint64_t device_size;
+
+	/*
+	 * We don't want a division by 0, and having max_beb_per1024 == 0 is ok
+	 */
+	if (!max_beb_per1024)
+		return 0;
+
+	/*
+	 * Here we are using size of the entire flash chip and
+	 * not just the MTD partition size because the maximum
+	 * number of bad eraseblocks is a percentage of the
+	 * whole device and bad eraseblocks are not fairly
+	 * distributed over the flash chip. So the worst case
+	 * is that all the bad eraseblocks of the chip are in
+	 * the MTD partition we are attaching (ubi->mtd).
+	 */
+	device_size = mtd_get_device_size(ubi->mtd);
+	device_pebs = mtd_div_by_eb(device_size, ubi->mtd);
+	limit = mult_frac(device_pebs, max_beb_per1024, 1024);
+
+	/* Round it up */
+	if (mult_frac(limit, 1024, max_beb_per1024) < device_pebs)
+		limit += 1;
+
+	return limit;
+}
+
 /**
  * io_init - initialize I/O sub-system for a given UBI device.
  * @ubi: UBI device description object
@@ -582,6 +613,8 @@ void ubi_free_internal_volumes(struct ubi_device *ubi)
  */
 static int io_init(struct ubi_device *ubi)
 {
+	const int max_beb_per1024 = CONFIG_MTD_UBI_BEB_LIMIT;
+
 	if (ubi->mtd->numeraseregions != 0) {
 		/*
 		 * Some flashes have several erase regions. Different regions
@@ -610,29 +643,7 @@ static int io_init(struct ubi_device *ubi)
 
 	if (mtd_can_have_bb(ubi->mtd)) {
 		ubi->bad_allowed = 1;
-		if (CONFIG_MTD_UBI_BEB_LIMIT > 0) {
-			int per1024 = CONFIG_MTD_UBI_BEB_LIMIT;
-			int limit, device_pebs;
-			uint64_t device_size;
-
-			/*
-			 * Here we are using size of the entire flash chip and
-			 * not just the MTD partition size because the maximum
-			 * number of bad eraseblocks is a percentage of the
-			 * whole device and bad eraseblocks are not fairly
-			 * distributed over the flash chip. So the worst case
-			 * is that all the bad eraseblocks of the chip are in
-			 * the MTD partition we are attaching (ubi->mtd).
-			 */
-			device_size = mtd_get_device_size(ubi->mtd);
-			device_pebs = mtd_div_by_eb(device_size, ubi->mtd);
-			limit = mult_frac(device_pebs, per1024, 1024);
-
-			/* Round it up */
-			if (mult_frac(limit, 1024, per1024) < device_pebs)
-				limit += 1;
-			ubi->bad_peb_limit = limit;
-		}
+		ubi->bad_peb_limit = get_bad_peb_limit(ubi, max_beb_per1024);
 	}
 
 	if (ubi->mtd->type == MTD_NORFLASH) {
-- 
1.7.2.5

