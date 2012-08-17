Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758067Ab2HQOgm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 10:36:42 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:62831 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758037Ab2HQOf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 10:35:56 -0400
From: Richard Genoud <richard.genoud@gmail.com>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Shmulik Ladkani <shmulik.ladkani@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org,
        Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH 4/8] UBI: prepare for max_beb_per1024 module parameter addition
Date: Fri, 17 Aug 2012 16:35:20 +0200
Message-Id: <1345214124-5478-5-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1345214124-5478-1-git-send-email-richard.genoud@gmail.com>
References: <1345214124-5478-1-git-send-email-richard.genoud@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch prepare the way for the addition of max_beb_per1024 module
parameter.
There's no functional change.

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
---
 drivers/mtd/ubi/build.c |   14 ++++++++------
 drivers/mtd/ubi/cdev.c  |    3 ++-
 drivers/mtd/ubi/ubi.h   |    3 ++-
 3 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
index 1f45f51..58fe53d 100644
--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -602,6 +602,7 @@ static int get_bad_peb_limit(const struct ubi_device *ubi, int max_beb_per1024)
 /**
  * io_init - initialize I/O sub-system for a given UBI device.
  * @ubi: UBI device description object
+ * @max_beb_per1024: maximum expected number of bad PEB per 1024 PEB
  *
  * If @ubi->vid_hdr_offset or @ubi->leb_start is zero, default offsets are
  * assumed:
@@ -614,10 +615,8 @@ static int get_bad_peb_limit(const struct ubi_device *ubi, int max_beb_per1024)
  * This function returns zero in case of success and a negative error code in
  * case of failure.
  */
-static int io_init(struct ubi_device *ubi)
+static int io_init(struct ubi_device *ubi, int max_beb_per1024)
 {
-	const int max_beb_per1024 = CONFIG_MTD_UBI_BEB_LIMIT;
-
 	if (ubi->mtd->numeraseregions != 0) {
 		/*
 		 * Some flashes have several erase regions. Different regions
@@ -839,6 +838,7 @@ static int autoresize(struct ubi_device *ubi, int vol_id)
  * @mtd: MTD device description object
  * @ubi_num: number to assign to the new UBI device
  * @vid_hdr_offset: VID header offset
+ * @max_beb_per1024: maximum number of expected bad blocks per 1024 eraseblocks
  *
  * This function attaches MTD device @mtd_dev to UBI and assign @ubi_num number
  * to the newly created UBI device, unless @ubi_num is %UBI_DEV_NUM_AUTO, in
@@ -849,7 +849,8 @@ static int autoresize(struct ubi_device *ubi, int vol_id)
  * Note, the invocations of this function has to be serialized by the
  * @ubi_devices_mutex.
  */
-int ubi_attach_mtd_dev(struct mtd_info *mtd, int ubi_num, int vid_hdr_offset)
+int ubi_attach_mtd_dev(struct mtd_info *mtd, int ubi_num,
+		       int vid_hdr_offset, int max_beb_per1024)
 {
 	struct ubi_device *ubi;
 	int i, err, ref = 0;
@@ -922,7 +923,7 @@ int ubi_attach_mtd_dev(struct mtd_info *mtd, int ubi_num, int vid_hdr_offset)
 	dbg_msg("sizeof(struct ubi_ainf_peb) %zu", sizeof(struct ubi_ainf_peb));
 	dbg_msg("sizeof(struct ubi_wl_entry) %zu", sizeof(struct ubi_wl_entry));
 
-	err = io_init(ubi);
+	err = io_init(ubi, max_beb_per1024);
 	if (err)
 		goto out_free;
 
@@ -1211,7 +1212,8 @@ static int __init ubi_init(void)
 
 		mutex_lock(&ubi_devices_mutex);
 		err = ubi_attach_mtd_dev(mtd, UBI_DEV_NUM_AUTO,
-					 p->vid_hdr_offs);
+					 p->vid_hdr_offs,
+					 CONFIG_MTD_UBI_BEB_LIMIT);
 		mutex_unlock(&ubi_devices_mutex);
 		if (err < 0) {
 			ubi_err("cannot attach mtd%d", mtd->index);
diff --git a/drivers/mtd/ubi/cdev.c b/drivers/mtd/ubi/cdev.c
index fb55678..619f914 100644
--- a/drivers/mtd/ubi/cdev.c
+++ b/drivers/mtd/ubi/cdev.c
@@ -1010,7 +1010,8 @@ static long ctrl_cdev_ioctl(struct file *file, unsigned int cmd,
 		 * 'ubi_attach_mtd_dev()'.
 		 */
 		mutex_lock(&ubi_devices_mutex);
-		err = ubi_attach_mtd_dev(mtd, req.ubi_num, req.vid_hdr_offset);
+		err = ubi_attach_mtd_dev(mtd, req.ubi_num, req.vid_hdr_offset,
+					 CONFIG_MTD_UBI_BEB_LIMIT);
 		mutex_unlock(&ubi_devices_mutex);
 		if (err < 0)
 			put_mtd_device(mtd);
diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
index c94612e..2a2475b 100644
--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -693,7 +693,8 @@ int ubi_io_write_vid_hdr(struct ubi_device *ubi, int pnum,
 			 struct ubi_vid_hdr *vid_hdr);
 
 /* build.c */
-int ubi_attach_mtd_dev(struct mtd_info *mtd, int ubi_num, int vid_hdr_offset);
+int ubi_attach_mtd_dev(struct mtd_info *mtd, int ubi_num,
+		       int vid_hdr_offset, int max_beb_per1024);
 int ubi_detach_mtd_dev(int ubi_num, int anyway);
 struct ubi_device *ubi_get_device(int ubi_num);
 void ubi_put_device(struct ubi_device *ubi);
-- 
1.7.2.5

