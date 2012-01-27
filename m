Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418Ab2A0OY5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 09:24:57 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38756 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755336Ab2A0OYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 09:24:55 -0500
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org
Subject: [PATCH] mtd/ubi: use memchr_inv
Date: Fri, 27 Jan 2012 23:24:51 +0900
Message-Id: <1327674295-3700-4-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1327674295-3700-1-git-send-email-akinobu.mita@gmail.com>
References: <1327674295-3700-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use memchr_inv to check if the data contains all 0xFF bytes.  It is
faster than looping for each byte.
This also removes ubi_check_pattern which is no longer used.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Artem Bityutskiy <dedekind1@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd@lists.infradead.org
---
 drivers/mtd/ubi/io.c   |   14 +++++---------
 drivers/mtd/ubi/misc.c |   19 -------------------
 drivers/mtd/ubi/scan.c |    2 +-
 drivers/mtd/ubi/ubi.h  |    1 -
 4 files changed, 6 insertions(+), 30 deletions(-)

diff --git a/drivers/mtd/ubi/io.c b/drivers/mtd/ubi/io.c
index 5cde4e5..9fc27d3 100644
--- a/drivers/mtd/ubi/io.c
+++ b/drivers/mtd/ubi/io.c
@@ -435,8 +435,7 @@ static int torture_peb(struct ubi_device *ubi, int pnum)
 		if (err)
 			goto out;
 
-		err = ubi_check_pattern(ubi->peb_buf1, 0xFF, ubi->peb_size);
-		if (err == 0) {
+		if (memchr_inv(ubi->peb_buf1, 0xFF, ubi->peb_size)) {
 			ubi_err("erased PEB %d, but a non-0xFF byte found",
 				pnum);
 			err = -EIO;
@@ -454,9 +453,7 @@ static int torture_peb(struct ubi_device *ubi, int pnum)
 		if (err)
 			goto out;
 
-		err = ubi_check_pattern(ubi->peb_buf1, patterns[i],
-					ubi->peb_size);
-		if (err == 0) {
+		if (memchr_inv(ubi->peb_buf1, patterns[i], ubi->peb_size)) {
 			ubi_err("pattern %x checking failed for PEB %d",
 				patterns[i], pnum);
 			err = -EIO;
@@ -783,7 +780,7 @@ int ubi_io_read_ec_hdr(struct ubi_device *ubi, int pnum,
 		 * 0xFF. If yes, this physical eraseblock is assumed to be
 		 * empty.
 		 */
-		if (ubi_check_pattern(ec_hdr, 0xFF, UBI_EC_HDR_SIZE)) {
+		if (!memchr_inv(ec_hdr, 0xFF, UBI_EC_HDR_SIZE)) {
 			/* The physical eraseblock is supposedly empty */
 			if (verbose)
 				ubi_warn("no EC header found at PEB %d, "
@@ -1039,7 +1036,7 @@ int ubi_io_read_vid_hdr(struct ubi_device *ubi, int pnum,
 		if (mtd_is_eccerr(read_err))
 			return UBI_IO_BAD_HDR_EBADMSG;
 
-		if (ubi_check_pattern(vid_hdr, 0xFF, UBI_VID_HDR_SIZE)) {
+		if (!memchr_inv(vid_hdr, 0xFF, UBI_VID_HDR_SIZE)) {
 			if (verbose)
 				ubi_warn("no VID header found at PEB %d, "
 					 "only 0xFF bytes", pnum);
@@ -1427,8 +1424,7 @@ int ubi_dbg_check_all_ff(struct ubi_device *ubi, int pnum, int offset, int len)
 		goto error;
 	}
 
-	err = ubi_check_pattern(buf, 0xFF, len);
-	if (err == 0) {
+	if (memchr_inv(buf, 0xFF, len)) {
 		ubi_err("flash region at PEB %d:%d, length %d does not "
 			"contain all 0xFF bytes", pnum, offset, len);
 		goto fail;
diff --git a/drivers/mtd/ubi/misc.c b/drivers/mtd/ubi/misc.c
index f6a7d7a..0e4b9a2 100644
--- a/drivers/mtd/ubi/misc.c
+++ b/drivers/mtd/ubi/misc.c
@@ -103,22 +103,3 @@ void ubi_calculate_reserved(struct ubi_device *ubi)
 	if (ubi->beb_rsvd_level < MIN_RESEVED_PEBS)
 		ubi->beb_rsvd_level = MIN_RESEVED_PEBS;
 }
-
-/**
- * ubi_check_pattern - check if buffer contains only a certain byte pattern.
- * @buf: buffer to check
- * @patt: the pattern to check
- * @size: buffer size in bytes
- *
- * This function returns %1 in there are only @patt bytes in @buf, and %0 if
- * something else was also found.
- */
-int ubi_check_pattern(const void *buf, uint8_t patt, int size)
-{
-	int i;
-
-	for (i = 0; i < size; i++)
-		if (((const uint8_t *)buf)[i] != patt)
-			return 0;
-	return 1;
-}
diff --git a/drivers/mtd/ubi/scan.c b/drivers/mtd/ubi/scan.c
index 0cb17d9..54a56acc 100644
--- a/drivers/mtd/ubi/scan.c
+++ b/drivers/mtd/ubi/scan.c
@@ -808,7 +808,7 @@ static int check_corruption(struct ubi_device *ubi, struct ubi_vid_hdr *vid_hdr,
 	if (err)
 		goto out_unlock;
 
-	if (ubi_check_pattern(ubi->peb_buf1, 0xFF, ubi->leb_size))
+	if (!memchr_inv(ubi->peb_buf1, 0xFF, ubi->leb_size))
 		goto out_unlock;
 
 	ubi_err("PEB %d contains corrupted VID header, and the data does not "
diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
index d51d75d..2ff1eb6 100644
--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -519,7 +519,6 @@ int ubi_calc_data_len(const struct ubi_device *ubi, const void *buf,
 		      int length);
 int ubi_check_volume(struct ubi_device *ubi, int vol_id);
 void ubi_calculate_reserved(struct ubi_device *ubi);
-int ubi_check_pattern(const void *buf, uint8_t patt, int size);
 
 /* eba.c */
 int ubi_eba_unmap_leb(struct ubi_device *ubi, struct ubi_volume *vol,
-- 
1.7.4.4

