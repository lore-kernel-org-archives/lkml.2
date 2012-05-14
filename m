Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184Ab2ENP4I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 11:56:08 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752341Ab2ENP4G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 11:56:06 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: tglx@linutronix.de, dedekind1@gmail.com, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 1/2] UBI: Kill data type hint
Date: Mon, 14 May 2012 17:55:51 +0200
Message-Id: <1337010952-39543-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We do not need this feature and to our shame it even was not working
and there was a bug found very recently.
	-- Artem Bityutskiy

Without the data type hint UBI2 (fastmap) will be easier to implement.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/cdev.c   |    8 +-----
 drivers/mtd/ubi/eba.c    |   20 +++++++-----------
 drivers/mtd/ubi/gluebi.c |    2 +-
 drivers/mtd/ubi/kapi.c   |   30 ++++++---------------------
 drivers/mtd/ubi/ubi.h    |   12 +++-------
 drivers/mtd/ubi/upd.c    |   12 +++-------
 drivers/mtd/ubi/vtbl.c   |    4 +-
 drivers/mtd/ubi/wl.c     |   50 +++++++--------------------------------------
 fs/ubifs/debug.c         |   12 +++++-----
 fs/ubifs/debug.h         |   15 +++++--------
 fs/ubifs/gc.c            |    2 +-
 fs/ubifs/io.c            |   42 +++++++++++++++-----------------------
 fs/ubifs/journal.c       |    2 +-
 fs/ubifs/log.c           |   10 ++++----
 fs/ubifs/lpt.c           |   13 ++++-------
 fs/ubifs/lpt_commit.c    |   10 +++-----
 fs/ubifs/master.c        |    4 +-
 fs/ubifs/orphan.c        |    5 +--
 fs/ubifs/recovery.c      |   13 +++++------
 fs/ubifs/replay.c        |    3 +-
 fs/ubifs/sb.c            |   21 +++++++------------
 fs/ubifs/super.c         |    2 -
 fs/ubifs/tnc_commit.c    |    6 +---
 fs/ubifs/ubifs.h         |   15 ++++---------
 include/linux/mtd/ubi.h  |   27 ++----------------------
 25 files changed, 110 insertions(+), 230 deletions(-)

diff --git a/drivers/mtd/ubi/cdev.c b/drivers/mtd/ubi/cdev.c
index ad76592..f406112 100644
--- a/drivers/mtd/ubi/cdev.c
+++ b/drivers/mtd/ubi/cdev.c
@@ -334,8 +334,7 @@ static ssize_t vol_cdev_direct_write(struct file *file, const char __user *buf,
 			break;
 		}
 
-		err = ubi_eba_write_leb(ubi, vol, lnum, tbuf, off, len,
-					UBI_UNKNOWN);
+		err = ubi_eba_write_leb(ubi, vol, lnum, tbuf, off, len);
 		if (err)
 			break;
 
@@ -477,9 +476,6 @@ static long vol_cdev_ioctl(struct file *file, unsigned int cmd,
 		if (req.lnum < 0 || req.lnum >= vol->reserved_pebs ||
 		    req.bytes < 0 || req.lnum >= vol->usable_leb_size)
 			break;
-		if (req.dtype != UBI_LONGTERM && req.dtype != UBI_SHORTTERM &&
-		    req.dtype != UBI_UNKNOWN)
-			break;
 
 		err = get_exclusive(desc);
 		if (err < 0)
@@ -532,7 +528,7 @@ static long vol_cdev_ioctl(struct file *file, unsigned int cmd,
 			err = -EFAULT;
 			break;
 		}
-		err = ubi_leb_map(desc, req.lnum, req.dtype);
+		err = ubi_leb_map(desc, req.lnum);
 		break;
 	}
 
diff --git a/drivers/mtd/ubi/eba.c b/drivers/mtd/ubi/eba.c
index 2455d62..bd5fdbf 100644
--- a/drivers/mtd/ubi/eba.c
+++ b/drivers/mtd/ubi/eba.c
@@ -507,7 +507,7 @@ static int recover_peb(struct ubi_device *ubi, int pnum, int vol_id, int lnum,
 		return -ENOMEM;
 
 retry:
-	new_pnum = ubi_wl_get_peb(ubi, UBI_UNKNOWN);
+	new_pnum = ubi_wl_get_peb(ubi);
 	if (new_pnum < 0) {
 		ubi_free_vid_hdr(ubi, vid_hdr);
 		return new_pnum;
@@ -585,7 +585,6 @@ write_error:
  * @buf: the data to write
  * @offset: offset within the logical eraseblock where to write
  * @len: how many bytes to write
- * @dtype: data type
  *
  * This function writes data to logical eraseblock @lnum of a dynamic volume
  * @vol. Returns zero in case of success and a negative error code in case
@@ -593,7 +592,7 @@ write_error:
  * written to the flash media, but may be some garbage.
  */
 int ubi_eba_write_leb(struct ubi_device *ubi, struct ubi_volume *vol, int lnum,
-		      const void *buf, int offset, int len, int dtype)
+		      const void *buf, int offset, int len)
 {
 	int err, pnum, tries = 0, vol_id = vol->vol_id;
 	struct ubi_vid_hdr *vid_hdr;
@@ -641,7 +640,7 @@ int ubi_eba_write_leb(struct ubi_device *ubi, struct ubi_volume *vol, int lnum,
 	vid_hdr->data_pad = cpu_to_be32(vol->data_pad);
 
 retry:
-	pnum = ubi_wl_get_peb(ubi, dtype);
+	pnum = ubi_wl_get_peb(ubi);
 	if (pnum < 0) {
 		ubi_free_vid_hdr(ubi, vid_hdr);
 		leb_write_unlock(ubi, vol_id, lnum);
@@ -707,7 +706,6 @@ write_error:
  * @lnum: logical eraseblock number
  * @buf: data to write
  * @len: how many bytes to write
- * @dtype: data type
  * @used_ebs: how many logical eraseblocks will this volume contain
  *
  * This function writes data to logical eraseblock @lnum of static volume
@@ -724,8 +722,7 @@ write_error:
  * code in case of failure.
  */
 int ubi_eba_write_leb_st(struct ubi_device *ubi, struct ubi_volume *vol,
-			 int lnum, const void *buf, int len, int dtype,
-			 int used_ebs)
+			 int lnum, const void *buf, int len, int used_ebs)
 {
 	int err, pnum, tries = 0, data_size = len, vol_id = vol->vol_id;
 	struct ubi_vid_hdr *vid_hdr;
@@ -763,7 +760,7 @@ int ubi_eba_write_leb_st(struct ubi_device *ubi, struct ubi_volume *vol,
 	vid_hdr->data_crc = cpu_to_be32(crc);
 
 retry:
-	pnum = ubi_wl_get_peb(ubi, dtype);
+	pnum = ubi_wl_get_peb(ubi);
 	if (pnum < 0) {
 		ubi_free_vid_hdr(ubi, vid_hdr);
 		leb_write_unlock(ubi, vol_id, lnum);
@@ -827,7 +824,6 @@ write_error:
  * @lnum: logical eraseblock number
  * @buf: data to write
  * @len: how many bytes to write
- * @dtype: data type
  *
  * This function changes the contents of a logical eraseblock atomically. @buf
  * has to contain new logical eraseblock data, and @len - the length of the
@@ -839,7 +835,7 @@ write_error:
  * LEB change may be done at a time. This is ensured by @ubi->alc_mutex.
  */
 int ubi_eba_atomic_leb_change(struct ubi_device *ubi, struct ubi_volume *vol,
-			      int lnum, const void *buf, int len, int dtype)
+			      int lnum, const void *buf, int len)
 {
 	int err, pnum, tries = 0, vol_id = vol->vol_id;
 	struct ubi_vid_hdr *vid_hdr;
@@ -856,7 +852,7 @@ int ubi_eba_atomic_leb_change(struct ubi_device *ubi, struct ubi_volume *vol,
 		err = ubi_eba_unmap_leb(ubi, vol, lnum);
 		if (err)
 			return err;
-		return ubi_eba_write_leb(ubi, vol, lnum, NULL, 0, 0, dtype);
+		return ubi_eba_write_leb(ubi, vol, lnum, NULL, 0, 0);
 	}
 
 	vid_hdr = ubi_zalloc_vid_hdr(ubi, GFP_NOFS);
@@ -881,7 +877,7 @@ int ubi_eba_atomic_leb_change(struct ubi_device *ubi, struct ubi_volume *vol,
 	vid_hdr->data_crc = cpu_to_be32(crc);
 
 retry:
-	pnum = ubi_wl_get_peb(ubi, dtype);
+	pnum = ubi_wl_get_peb(ubi);
 	if (pnum < 0) {
 		err = pnum;
 		goto out_leb_unlock;
diff --git a/drivers/mtd/ubi/gluebi.c b/drivers/mtd/ubi/gluebi.c
index 90b9882..4e44bee 100644
--- a/drivers/mtd/ubi/gluebi.c
+++ b/drivers/mtd/ubi/gluebi.c
@@ -227,7 +227,7 @@ static int gluebi_write(struct mtd_info *mtd, loff_t to, size_t len,
 		if (to_write > total_written)
 			to_write = total_written;
 
-		err = ubi_write(gluebi->desc, lnum, buf, offs, to_write);
+		err = ubi_leb_write(gluebi->desc, lnum, buf, offs, to_write);
 		if (err)
 			break;
 
diff --git a/drivers/mtd/ubi/kapi.c b/drivers/mtd/ubi/kapi.c
index 9fdb353..33ede23 100644
--- a/drivers/mtd/ubi/kapi.c
+++ b/drivers/mtd/ubi/kapi.c
@@ -426,11 +426,9 @@ EXPORT_SYMBOL_GPL(ubi_leb_read);
  * @buf: data to write
  * @offset: offset within the logical eraseblock where to write
  * @len: how many bytes to write
- * @dtype: expected data type
  *
  * This function writes @len bytes of data from @buf to offset @offset of
- * logical eraseblock @lnum. The @dtype argument describes expected lifetime of
- * the data.
+ * logical eraseblock @lnum.
  *
  * This function takes care of physical eraseblock write failures. If write to
  * the physical eraseblock write operation fails, the logical eraseblock is
@@ -447,7 +445,7 @@ EXPORT_SYMBOL_GPL(ubi_leb_read);
  * returns immediately with %-EBADF code.
  */
 int ubi_leb_write(struct ubi_volume_desc *desc, int lnum, const void *buf,
-		  int offset, int len, int dtype)
+		  int offset, int len)
 {
 	struct ubi_volume *vol = desc->vol;
 	struct ubi_device *ubi = vol->ubi;
@@ -466,17 +464,13 @@ int ubi_leb_write(struct ubi_volume_desc *desc, int lnum, const void *buf,
 	    offset & (ubi->min_io_size - 1) || len & (ubi->min_io_size - 1))
 		return -EINVAL;
 
-	if (dtype != UBI_LONGTERM && dtype != UBI_SHORTTERM &&
-	    dtype != UBI_UNKNOWN)
-		return -EINVAL;
-
 	if (vol->upd_marker)
 		return -EBADF;
 
 	if (len == 0)
 		return 0;
 
-	return ubi_eba_write_leb(ubi, vol, lnum, buf, offset, len, dtype);
+	return ubi_eba_write_leb(ubi, vol, lnum, buf, offset, len);
 }
 EXPORT_SYMBOL_GPL(ubi_leb_write);
 
@@ -486,7 +480,6 @@ EXPORT_SYMBOL_GPL(ubi_leb_write);
  * @lnum: logical eraseblock number to change
  * @buf: data to write
  * @len: how many bytes to write
- * @dtype: expected data type
  *
  * This function changes the contents of a logical eraseblock atomically. @buf
  * has to contain new logical eraseblock data, and @len - the length of the
@@ -497,7 +490,7 @@ EXPORT_SYMBOL_GPL(ubi_leb_write);
  * code in case of failure.
  */
 int ubi_leb_change(struct ubi_volume_desc *desc, int lnum, const void *buf,
-		   int len, int dtype)
+		   int len)
 {
 	struct ubi_volume *vol = desc->vol;
 	struct ubi_device *ubi = vol->ubi;
@@ -515,17 +508,13 @@ int ubi_leb_change(struct ubi_volume_desc *desc, int lnum, const void *buf,
 	    len > vol->usable_leb_size || len & (ubi->min_io_size - 1))
 		return -EINVAL;
 
-	if (dtype != UBI_LONGTERM && dtype != UBI_SHORTTERM &&
-	    dtype != UBI_UNKNOWN)
-		return -EINVAL;
-
 	if (vol->upd_marker)
 		return -EBADF;
 
 	if (len == 0)
 		return 0;
 
-	return ubi_eba_atomic_leb_change(ubi, vol, lnum, buf, len, dtype);
+	return ubi_eba_atomic_leb_change(ubi, vol, lnum, buf, len);
 }
 EXPORT_SYMBOL_GPL(ubi_leb_change);
 
@@ -626,7 +615,6 @@ EXPORT_SYMBOL_GPL(ubi_leb_unmap);
  * ubi_leb_map - map logical eraseblock to a physical eraseblock.
  * @desc: volume descriptor
  * @lnum: logical eraseblock number
- * @dtype: expected data type
  *
  * This function maps an un-mapped logical eraseblock @lnum to a physical
  * eraseblock. This means, that after a successful invocation of this
@@ -639,7 +627,7 @@ EXPORT_SYMBOL_GPL(ubi_leb_unmap);
  * eraseblock is already mapped, and other negative error codes in case of
  * other failures.
  */
-int ubi_leb_map(struct ubi_volume_desc *desc, int lnum, int dtype)
+int ubi_leb_map(struct ubi_volume_desc *desc, int lnum)
 {
 	struct ubi_volume *vol = desc->vol;
 	struct ubi_device *ubi = vol->ubi;
@@ -652,17 +640,13 @@ int ubi_leb_map(struct ubi_volume_desc *desc, int lnum, int dtype)
 	if (lnum < 0 || lnum >= vol->reserved_pebs)
 		return -EINVAL;
 
-	if (dtype != UBI_LONGTERM && dtype != UBI_SHORTTERM &&
-	    dtype != UBI_UNKNOWN)
-		return -EINVAL;
-
 	if (vol->upd_marker)
 		return -EBADF;
 
 	if (vol->eba_tbl[lnum] >= 0)
 		return -EBADMSG;
 
-	return ubi_eba_write_leb(ubi, vol, lnum, NULL, 0, 0, dtype);
+	return ubi_eba_write_leb(ubi, vol, lnum, NULL, 0, 0);
 }
 EXPORT_SYMBOL_GPL(ubi_leb_map);
 
diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
index b162790..e8b4566 100644
--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -222,8 +222,6 @@ struct ubi_volume_desc;
  * @upd_ebs: how many eraseblocks are expected to be updated
  * @ch_lnum: LEB number which is being changing by the atomic LEB change
  *           operation
- * @ch_dtype: data persistency type which is being changing by the atomic LEB
- *            change operation
  * @upd_bytes: how many bytes are expected to be received for volume update or
  *             atomic LEB change
  * @upd_received: how many bytes were already received for volume update or
@@ -270,7 +268,6 @@ struct ubi_volume {
 
 	int upd_ebs;
 	int ch_lnum;
-	int ch_dtype;
 	long long upd_bytes;
 	long long upd_received;
 	void *upd_buf;
@@ -525,18 +522,17 @@ int ubi_eba_unmap_leb(struct ubi_device *ubi, struct ubi_volume *vol,
 int ubi_eba_read_leb(struct ubi_device *ubi, struct ubi_volume *vol, int lnum,
 		     void *buf, int offset, int len, int check);
 int ubi_eba_write_leb(struct ubi_device *ubi, struct ubi_volume *vol, int lnum,
-		      const void *buf, int offset, int len, int dtype);
+		      const void *buf, int offset, int len);
 int ubi_eba_write_leb_st(struct ubi_device *ubi, struct ubi_volume *vol,
-			 int lnum, const void *buf, int len, int dtype,
-			 int used_ebs);
+			 int lnum, const void *buf, int len, int used_ebs);
 int ubi_eba_atomic_leb_change(struct ubi_device *ubi, struct ubi_volume *vol,
-			      int lnum, const void *buf, int len, int dtype);
+			      int lnum, const void *buf, int len);
 int ubi_eba_copy_leb(struct ubi_device *ubi, int from, int to,
 		     struct ubi_vid_hdr *vid_hdr);
 int ubi_eba_init_scan(struct ubi_device *ubi, struct ubi_scan_info *si);
 
 /* wl.c */
-int ubi_wl_get_peb(struct ubi_device *ubi, int dtype);
+int ubi_wl_get_peb(struct ubi_device *ubi);
 int ubi_wl_put_peb(struct ubi_device *ubi, int pnum, int torture);
 int ubi_wl_flush(struct ubi_device *ubi);
 int ubi_wl_scrub_peb(struct ubi_device *ubi, int pnum);
diff --git a/drivers/mtd/ubi/upd.c b/drivers/mtd/ubi/upd.c
index 425bf5a..11a28f9 100644
--- a/drivers/mtd/ubi/upd.c
+++ b/drivers/mtd/ubi/upd.c
@@ -186,14 +186,12 @@ int ubi_start_leb_change(struct ubi_device *ubi, struct ubi_volume *vol,
 	dbg_gen("start changing LEB %d:%d, %u bytes",
 		vol->vol_id, req->lnum, req->bytes);
 	if (req->bytes == 0)
-		return ubi_eba_atomic_leb_change(ubi, vol, req->lnum, NULL, 0,
-						 req->dtype);
+		return ubi_eba_atomic_leb_change(ubi, vol, req->lnum, NULL, 0);
 
 	vol->upd_bytes = req->bytes;
 	vol->upd_received = 0;
 	vol->changing_leb = 1;
 	vol->ch_lnum = req->lnum;
-	vol->ch_dtype = req->dtype;
 
 	vol->upd_buf = vmalloc(req->bytes);
 	if (!vol->upd_buf)
@@ -246,8 +244,7 @@ static int write_leb(struct ubi_device *ubi, struct ubi_volume *vol, int lnum,
 			return 0;
 		}
 
-		err = ubi_eba_write_leb(ubi, vol, lnum, buf, 0, len,
-					UBI_UNKNOWN);
+		err = ubi_eba_write_leb(ubi, vol, lnum, buf, 0, len);
 	} else {
 		/*
 		 * When writing static volume, and this is the last logical
@@ -259,8 +256,7 @@ static int write_leb(struct ubi_device *ubi, struct ubi_volume *vol, int lnum,
 		 * contain zeros, not random trash.
 		 */
 		memset(buf + len, 0, vol->usable_leb_size - len);
-		err = ubi_eba_write_leb_st(ubi, vol, lnum, buf, len,
-					   UBI_UNKNOWN, used_ebs);
+		err = ubi_eba_write_leb_st(ubi, vol, lnum, buf, len, used_ebs);
 	}
 
 	return err;
@@ -421,7 +417,7 @@ int ubi_more_leb_change_data(struct ubi_device *ubi, struct ubi_volume *vol,
 		       len - vol->upd_bytes);
 		len = ubi_calc_data_len(ubi, vol->upd_buf, len);
 		err = ubi_eba_atomic_leb_change(ubi, vol, vol->ch_lnum,
-						vol->upd_buf, len, UBI_UNKNOWN);
+						vol->upd_buf, len);
 		if (err)
 			return err;
 	}
diff --git a/drivers/mtd/ubi/vtbl.c b/drivers/mtd/ubi/vtbl.c
index 17cec0c..a6f4b13 100644
--- a/drivers/mtd/ubi/vtbl.c
+++ b/drivers/mtd/ubi/vtbl.c
@@ -106,7 +106,7 @@ int ubi_change_vtbl_record(struct ubi_device *ubi, int idx,
 			return err;
 
 		err = ubi_eba_write_leb(ubi, layout_vol, i, ubi->vtbl, 0,
-					ubi->vtbl_size, UBI_LONGTERM);
+					ubi->vtbl_size);
 		if (err)
 			return err;
 	}
@@ -158,7 +158,7 @@ int ubi_vtbl_rename_volumes(struct ubi_device *ubi,
 			return err;
 
 		err = ubi_eba_write_leb(ubi, layout_vol, i, ubi->vtbl, 0,
-					ubi->vtbl_size, UBI_LONGTERM);
+					ubi->vtbl_size);
 		if (err)
 			return err;
 	}
diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index 7c1a9bf..10a87e4 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -383,19 +383,15 @@ static struct ubi_wl_entry *find_wl_entry(struct rb_root *root, int diff)
 /**
  * ubi_wl_get_peb - get a physical eraseblock.
  * @ubi: UBI device description object
- * @dtype: type of data which will be stored in this physical eraseblock
  *
  * This function returns a physical eraseblock in case of success and a
  * negative error code in case of failure. Might sleep.
  */
-int ubi_wl_get_peb(struct ubi_device *ubi, int dtype)
+int ubi_wl_get_peb(struct ubi_device *ubi)
 {
 	int err;
 	struct ubi_wl_entry *e, *first, *last;
 
-	ubi_assert(dtype == UBI_LONGTERM || dtype == UBI_SHORTTERM ||
-		   dtype == UBI_UNKNOWN);
-
 retry:
 	spin_lock(&ubi->wl_lock);
 	if (!ubi->free.rb_node) {
@@ -413,43 +409,13 @@ retry:
 		goto retry;
 	}
 
-	switch (dtype) {
-	case UBI_LONGTERM:
-		/*
-		 * For long term data we pick a physical eraseblock with high
-		 * erase counter. But the highest erase counter we can pick is
-		 * bounded by the the lowest erase counter plus
-		 * %WL_FREE_MAX_DIFF.
-		 */
-		e = find_wl_entry(&ubi->free, WL_FREE_MAX_DIFF);
-		break;
-	case UBI_UNKNOWN:
-		/*
-		 * For unknown data we pick a physical eraseblock with medium
-		 * erase counter. But we by no means can pick a physical
-		 * eraseblock with erase counter greater or equivalent than the
-		 * lowest erase counter plus %WL_FREE_MAX_DIFF/2.
-		 */
-		first = rb_entry(rb_first(&ubi->free), struct ubi_wl_entry,
-					u.rb);
-		last = rb_entry(rb_last(&ubi->free), struct ubi_wl_entry, u.rb);
-
-		if (last->ec - first->ec < WL_FREE_MAX_DIFF)
-			e = rb_entry(ubi->free.rb_node,
-					struct ubi_wl_entry, u.rb);
-		else
-			e = find_wl_entry(&ubi->free, WL_FREE_MAX_DIFF/2);
-		break;
-	case UBI_SHORTTERM:
-		/*
-		 * For short term data we pick a physical eraseblock with the
-		 * lowest erase counter as we expect it will be erased soon.
-		 */
-		e = rb_entry(rb_first(&ubi->free), struct ubi_wl_entry, u.rb);
-		break;
-	default:
-		BUG();
-	}
+	first = rb_entry(rb_first(&ubi->free), struct ubi_wl_entry, u.rb);
+	last = rb_entry(rb_last(&ubi->free), struct ubi_wl_entry, u.rb);
+
+	if (last->ec - first->ec < WL_FREE_MAX_DIFF)
+		e = rb_entry(ubi->free.rb_node, struct ubi_wl_entry, u.rb);
+	else
+		e = find_wl_entry(&ubi->free, WL_FREE_MAX_DIFF/2);
 
 	paranoid_check_in_wl_tree(ubi, e, &ubi->free);
 
diff --git a/fs/ubifs/debug.c b/fs/ubifs/debug.c
index 1934084..eb8591a 100644
--- a/fs/ubifs/debug.c
+++ b/fs/ubifs/debug.c
@@ -2678,7 +2678,7 @@ static void cut_data(const void *buf, unsigned int len)
 }
 
 int dbg_leb_write(struct ubifs_info *c, int lnum, const void *buf,
-		  int offs, int len, int dtype)
+		  int offs, int len)
 {
 	int err, failing;
 
@@ -2688,7 +2688,7 @@ int dbg_leb_write(struct ubifs_info *c, int lnum, const void *buf,
 	failing = power_cut_emulated(c, lnum, 1);
 	if (failing)
 		cut_data(buf, len);
-	err = ubi_leb_write(c->ubi, lnum, buf, offs, len, dtype);
+	err = ubi_leb_write(c->ubi, lnum, buf, offs, len);
 	if (err)
 		return err;
 	if (failing)
@@ -2697,7 +2697,7 @@ int dbg_leb_write(struct ubifs_info *c, int lnum, const void *buf,
 }
 
 int dbg_leb_change(struct ubifs_info *c, int lnum, const void *buf,
-		   int len, int dtype)
+		   int len)
 {
 	int err;
 
@@ -2705,7 +2705,7 @@ int dbg_leb_change(struct ubifs_info *c, int lnum, const void *buf,
 		return -EROFS;
 	if (power_cut_emulated(c, lnum, 1))
 		return -EROFS;
-	err = ubi_leb_change(c->ubi, lnum, buf, len, dtype);
+	err = ubi_leb_change(c->ubi, lnum, buf, len);
 	if (err)
 		return err;
 	if (power_cut_emulated(c, lnum, 1))
@@ -2729,7 +2729,7 @@ int dbg_leb_unmap(struct ubifs_info *c, int lnum)
 	return 0;
 }
 
-int dbg_leb_map(struct ubifs_info *c, int lnum, int dtype)
+int dbg_leb_map(struct ubifs_info *c, int lnum)
 {
 	int err;
 
@@ -2737,7 +2737,7 @@ int dbg_leb_map(struct ubifs_info *c, int lnum, int dtype)
 		return -EROFS;
 	if (power_cut_emulated(c, lnum, 0))
 		return -EROFS;
-	err = ubi_leb_map(c->ubi, lnum, dtype);
+	err = ubi_leb_map(c->ubi, lnum);
 	if (err)
 		return err;
 	if (power_cut_emulated(c, lnum, 0))
diff --git a/fs/ubifs/debug.h b/fs/ubifs/debug.h
index 9f71765..1e63075 100644
--- a/fs/ubifs/debug.h
+++ b/fs/ubifs/debug.h
@@ -307,11 +307,10 @@ int dbg_check_data_nodes_order(struct ubifs_info *c, struct list_head *head);
 int dbg_check_nondata_nodes_order(struct ubifs_info *c, struct list_head *head);
 
 int dbg_leb_write(struct ubifs_info *c, int lnum, const void *buf, int offs,
-		  int len, int dtype);
-int dbg_leb_change(struct ubifs_info *c, int lnum, const void *buf, int len,
-		   int dtype);
+		  int len);
+int dbg_leb_change(struct ubifs_info *c, int lnum, const void *buf, int len);
 int dbg_leb_unmap(struct ubifs_info *c, int lnum);
-int dbg_leb_map(struct ubifs_info *c, int lnum, int dtype);
+int dbg_leb_map(struct ubifs_info *c, int lnum);
 
 /* Debugfs-related stuff */
 int dbg_debugfs_init(void);
@@ -455,13 +454,11 @@ dbg_check_nondata_nodes_order(struct ubifs_info *c,
 
 static inline int dbg_leb_write(struct ubifs_info *c, int lnum,
 				const void *buf, int offset,
-				int len, int dtype)               { return 0; }
+				int len)			  { return 0; }
 static inline int dbg_leb_change(struct ubifs_info *c, int lnum,
-				 const void *buf, int len,
-				 int dtype)                       { return 0; }
+				 const void *buf, int len)	  { return 0; }
 static inline int dbg_leb_unmap(struct ubifs_info *c, int lnum)   { return 0; }
-static inline int dbg_leb_map(struct ubifs_info *c, int lnum,
-			      int dtype)                          { return 0; }
+static inline int dbg_leb_map(struct ubifs_info *c, int lnum)	  { return 0; }
 
 static inline int dbg_is_chk_gen(const struct ubifs_info *c)      { return 0; }
 static inline int dbg_is_chk_index(const struct ubifs_info *c)    { return 0; }
diff --git a/fs/ubifs/gc.c b/fs/ubifs/gc.c
index ded29f6..04dd6f4 100644
--- a/fs/ubifs/gc.c
+++ b/fs/ubifs/gc.c
@@ -109,7 +109,7 @@ static int switch_gc_head(struct ubifs_info *c)
 		return err;
 
 	c->gc_lnum = -1;
-	err = ubifs_wbuf_seek_nolock(wbuf, gc_lnum, 0, UBI_LONGTERM);
+	err = ubifs_wbuf_seek_nolock(wbuf, gc_lnum, 0);
 	return err;
 }
 
diff --git a/fs/ubifs/io.c b/fs/ubifs/io.c
index 9228950..28b6486 100644
--- a/fs/ubifs/io.c
+++ b/fs/ubifs/io.c
@@ -115,7 +115,7 @@ int ubifs_leb_read(const struct ubifs_info *c, int lnum, void *buf, int offs,
 }
 
 int ubifs_leb_write(struct ubifs_info *c, int lnum, const void *buf, int offs,
-		    int len, int dtype)
+		    int len)
 {
 	int err;
 
@@ -123,9 +123,9 @@ int ubifs_leb_write(struct ubifs_info *c, int lnum, const void *buf, int offs,
 	if (c->ro_error)
 		return -EROFS;
 	if (!dbg_is_tst_rcvry(c))
-		err = ubi_leb_write(c->ubi, lnum, buf, offs, len, dtype);
+		err = ubi_leb_write(c->ubi, lnum, buf, offs, len);
 	else
-		err = dbg_leb_write(c, lnum, buf, offs, len, dtype);
+		err = dbg_leb_write(c, lnum, buf, offs, len);
 	if (err) {
 		ubifs_err("writing %d bytes to LEB %d:%d failed, error %d",
 			  len, lnum, offs, err);
@@ -135,8 +135,7 @@ int ubifs_leb_write(struct ubifs_info *c, int lnum, const void *buf, int offs,
 	return err;
 }
 
-int ubifs_leb_change(struct ubifs_info *c, int lnum, const void *buf, int len,
-		     int dtype)
+int ubifs_leb_change(struct ubifs_info *c, int lnum, const void *buf, int len)
 {
 	int err;
 
@@ -144,9 +143,9 @@ int ubifs_leb_change(struct ubifs_info *c, int lnum, const void *buf, int len,
 	if (c->ro_error)
 		return -EROFS;
 	if (!dbg_is_tst_rcvry(c))
-		err = ubi_leb_change(c->ubi, lnum, buf, len, dtype);
+		err = ubi_leb_change(c->ubi, lnum, buf, len);
 	else
-		err = dbg_leb_change(c, lnum, buf, len, dtype);
+		err = dbg_leb_change(c, lnum, buf, len);
 	if (err) {
 		ubifs_err("changing %d bytes in LEB %d failed, error %d",
 			  len, lnum, err);
@@ -175,7 +174,7 @@ int ubifs_leb_unmap(struct ubifs_info *c, int lnum)
 	return err;
 }
 
-int ubifs_leb_map(struct ubifs_info *c, int lnum, int dtype)
+int ubifs_leb_map(struct ubifs_info *c, int lnum)
 {
 	int err;
 
@@ -183,9 +182,9 @@ int ubifs_leb_map(struct ubifs_info *c, int lnum, int dtype)
 	if (c->ro_error)
 		return -EROFS;
 	if (!dbg_is_tst_rcvry(c))
-		err = ubi_leb_map(c->ubi, lnum, dtype);
+		err = ubi_leb_map(c->ubi, lnum);
 	else
-		err = dbg_leb_map(c, lnum, dtype);
+		err = dbg_leb_map(c, lnum);
 	if (err) {
 		ubifs_err("mapping LEB %d failed, error %d", lnum, err);
 		ubifs_ro_mode(c, err);
@@ -523,8 +522,7 @@ int ubifs_wbuf_sync_nolock(struct ubifs_wbuf *wbuf)
 	dirt = sync_len - wbuf->used;
 	if (dirt)
 		ubifs_pad(c, wbuf->buf + wbuf->used, dirt);
-	err = ubifs_leb_write(c, wbuf->lnum, wbuf->buf, wbuf->offs, sync_len,
-			      wbuf->dtype);
+	err = ubifs_leb_write(c, wbuf->lnum, wbuf->buf, wbuf->offs, sync_len);
 	if (err)
 		return err;
 
@@ -562,14 +560,12 @@ int ubifs_wbuf_sync_nolock(struct ubifs_wbuf *wbuf)
  * @wbuf: write-buffer
  * @lnum: logical eraseblock number to seek to
  * @offs: logical eraseblock offset to seek to
- * @dtype: data type
  *
  * This function targets the write-buffer to logical eraseblock @lnum:@offs.
  * The write-buffer has to be empty. Returns zero in case of success and a
  * negative error code in case of failure.
  */
-int ubifs_wbuf_seek_nolock(struct ubifs_wbuf *wbuf, int lnum, int offs,
-			   int dtype)
+int ubifs_wbuf_seek_nolock(struct ubifs_wbuf *wbuf, int lnum, int offs)
 {
 	const struct ubifs_info *c = wbuf->c;
 
@@ -592,7 +588,6 @@ int ubifs_wbuf_seek_nolock(struct ubifs_wbuf *wbuf, int lnum, int offs,
 	wbuf->avail = wbuf->size;
 	wbuf->used = 0;
 	spin_unlock(&wbuf->lock);
-	wbuf->dtype = dtype;
 
 	return 0;
 }
@@ -719,8 +714,7 @@ int ubifs_wbuf_write_nolock(struct ubifs_wbuf *wbuf, void *buf, int len)
 			dbg_io("flush jhead %s wbuf to LEB %d:%d",
 			       dbg_jhead(wbuf->jhead), wbuf->lnum, wbuf->offs);
 			err = ubifs_leb_write(c, wbuf->lnum, wbuf->buf,
-					      wbuf->offs, wbuf->size,
-					      wbuf->dtype);
+					      wbuf->offs, wbuf->size);
 			if (err)
 				goto out;
 
@@ -756,7 +750,7 @@ int ubifs_wbuf_write_nolock(struct ubifs_wbuf *wbuf, void *buf, int len)
 		       dbg_jhead(wbuf->jhead), wbuf->lnum, wbuf->offs);
 		memcpy(wbuf->buf + wbuf->used, buf, wbuf->avail);
 		err = ubifs_leb_write(c, wbuf->lnum, wbuf->buf, wbuf->offs,
-				      wbuf->size, wbuf->dtype);
+				      wbuf->size);
 		if (err)
 			goto out;
 
@@ -775,7 +769,7 @@ int ubifs_wbuf_write_nolock(struct ubifs_wbuf *wbuf, void *buf, int len)
 		dbg_io("write %d bytes to LEB %d:%d",
 		       wbuf->size, wbuf->lnum, wbuf->offs);
 		err = ubifs_leb_write(c, wbuf->lnum, buf, wbuf->offs,
-				      wbuf->size, wbuf->dtype);
+				      wbuf->size);
 		if (err)
 			goto out;
 
@@ -797,7 +791,7 @@ int ubifs_wbuf_write_nolock(struct ubifs_wbuf *wbuf, void *buf, int len)
 		dbg_io("write %d bytes to LEB %d:%d", n, wbuf->lnum,
 		       wbuf->offs);
 		err = ubifs_leb_write(c, wbuf->lnum, buf + written,
-				      wbuf->offs, n, wbuf->dtype);
+				      wbuf->offs, n);
 		if (err)
 			goto out;
 		wbuf->offs += n;
@@ -854,7 +848,6 @@ out:
  * @len: node length
  * @lnum: logical eraseblock number
  * @offs: offset within the logical eraseblock
- * @dtype: node life-time hint (%UBI_LONGTERM, %UBI_SHORTTERM, %UBI_UNKNOWN)
  *
  * This function automatically fills node magic number, assigns sequence
  * number, and calculates node CRC checksum. The length of the @buf buffer has
@@ -863,7 +856,7 @@ out:
  * success and a negative error code in case of failure.
  */
 int ubifs_write_node(struct ubifs_info *c, void *buf, int len, int lnum,
-		     int offs, int dtype)
+		     int offs)
 {
 	int err, buf_len = ALIGN(len, c->min_io_size);
 
@@ -879,7 +872,7 @@ int ubifs_write_node(struct ubifs_info *c, void *buf, int len, int lnum,
 		return -EROFS;
 
 	ubifs_prepare_node(c, buf, len, 1);
-	err = ubifs_leb_write(c, lnum, buf, offs, buf_len, dtype);
+	err = ubifs_leb_write(c, lnum, buf, offs, buf_len);
 	if (err)
 		dbg_dump_node(c, buf);
 
@@ -1056,7 +1049,6 @@ int ubifs_wbuf_init(struct ubifs_info *c, struct ubifs_wbuf *wbuf)
 	 */
 	size = c->max_write_size - (c->leb_start % c->max_write_size);
 	wbuf->avail = wbuf->size = size;
-	wbuf->dtype = UBI_UNKNOWN;
 	wbuf->sync_callback = NULL;
 	mutex_init(&wbuf->io_mutex);
 	spin_lock_init(&wbuf->lock);
diff --git a/fs/ubifs/journal.c b/fs/ubifs/journal.c
index 2f438ab..f6c5ccd 100644
--- a/fs/ubifs/journal.c
+++ b/fs/ubifs/journal.c
@@ -214,7 +214,7 @@ out:
 	err = ubifs_add_bud_to_log(c, jhead, lnum, offs);
 	if (err)
 		goto out_return;
-	err = ubifs_wbuf_seek_nolock(wbuf, lnum, offs, wbuf->dtype);
+	err = ubifs_wbuf_seek_nolock(wbuf, lnum, offs);
 	if (err)
 		goto out_unlock;
 
diff --git a/fs/ubifs/log.c b/fs/ubifs/log.c
index f9fd068..791e6ea 100644
--- a/fs/ubifs/log.c
+++ b/fs/ubifs/log.c
@@ -262,7 +262,7 @@ int ubifs_add_bud_to_log(struct ubifs_info *c, int jhead, int lnum, int offs)
 		 * an unclean reboot, because the target LEB might have been
 		 * unmapped, but not yet physically erased.
 		 */
-		err = ubifs_leb_map(c, bud->lnum, UBI_SHORTTERM);
+		err = ubifs_leb_map(c, bud->lnum);
 		if (err)
 			goto out_unlock;
 	}
@@ -270,7 +270,7 @@ int ubifs_add_bud_to_log(struct ubifs_info *c, int jhead, int lnum, int offs)
 	dbg_log("write ref LEB %d:%d",
 		c->lhead_lnum, c->lhead_offs);
 	err = ubifs_write_node(c, ref, UBIFS_REF_NODE_SZ, c->lhead_lnum,
-			       c->lhead_offs, UBI_SHORTTERM);
+			       c->lhead_offs);
 	if (err)
 		goto out_unlock;
 
@@ -422,7 +422,7 @@ int ubifs_log_start_commit(struct ubifs_info *c, int *ltail_lnum)
 
 	len = ALIGN(len, c->min_io_size);
 	dbg_log("writing commit start at LEB %d:0, len %d", c->lhead_lnum, len);
-	err = ubifs_leb_write(c, c->lhead_lnum, cs, 0, len, UBI_SHORTTERM);
+	err = ubifs_leb_write(c, c->lhead_lnum, cs, 0, len);
 	if (err)
 		goto out;
 
@@ -623,7 +623,7 @@ static int add_node(struct ubifs_info *c, void *buf, int *lnum, int *offs,
 		int sz = ALIGN(*offs, c->min_io_size), err;
 
 		ubifs_pad(c, buf + *offs, sz - *offs);
-		err = ubifs_leb_change(c, *lnum, buf, sz, UBI_SHORTTERM);
+		err = ubifs_leb_change(c, *lnum, buf, sz);
 		if (err)
 			return err;
 		*lnum = ubifs_next_log_lnum(c, *lnum);
@@ -702,7 +702,7 @@ int ubifs_consolidate_log(struct ubifs_info *c)
 		int sz = ALIGN(offs, c->min_io_size);
 
 		ubifs_pad(c, buf + offs, sz - offs);
-		err = ubifs_leb_change(c, write_lnum, buf, sz, UBI_SHORTTERM);
+		err = ubifs_leb_change(c, write_lnum, buf, sz);
 		if (err)
 			goto out_free;
 		offs = ALIGN(offs, c->min_io_size);
diff --git a/fs/ubifs/lpt.c b/fs/ubifs/lpt.c
index 66d59d0..dacae55 100644
--- a/fs/ubifs/lpt.c
+++ b/fs/ubifs/lpt.c
@@ -701,8 +701,7 @@ int ubifs_create_dflt_lpt(struct ubifs_info *c, int *main_lebs, int lpt_first,
 			alen = ALIGN(len, c->min_io_size);
 			set_ltab(c, lnum, c->leb_size - alen, alen - len);
 			memset(p, 0xff, alen - len);
-			err = ubifs_leb_change(c, lnum++, buf, alen,
-					       UBI_SHORTTERM);
+			err = ubifs_leb_change(c, lnum++, buf, alen);
 			if (err)
 				goto out;
 			p = buf;
@@ -732,8 +731,7 @@ int ubifs_create_dflt_lpt(struct ubifs_info *c, int *main_lebs, int lpt_first,
 				set_ltab(c, lnum, c->leb_size - alen,
 					    alen - len);
 				memset(p, 0xff, alen - len);
-				err = ubifs_leb_change(c, lnum++, buf, alen,
-						       UBI_SHORTTERM);
+				err = ubifs_leb_change(c, lnum++, buf, alen);
 				if (err)
 					goto out;
 				p = buf;
@@ -780,8 +778,7 @@ int ubifs_create_dflt_lpt(struct ubifs_info *c, int *main_lebs, int lpt_first,
 			alen = ALIGN(len, c->min_io_size);
 			set_ltab(c, lnum, c->leb_size - alen, alen - len);
 			memset(p, 0xff, alen - len);
-			err = ubifs_leb_change(c, lnum++, buf, alen,
-					       UBI_SHORTTERM);
+			err = ubifs_leb_change(c, lnum++, buf, alen);
 			if (err)
 				goto out;
 			p = buf;
@@ -806,7 +803,7 @@ int ubifs_create_dflt_lpt(struct ubifs_info *c, int *main_lebs, int lpt_first,
 		alen = ALIGN(len, c->min_io_size);
 		set_ltab(c, lnum, c->leb_size - alen, alen - len);
 		memset(p, 0xff, alen - len);
-		err = ubifs_leb_change(c, lnum++, buf, alen, UBI_SHORTTERM);
+		err = ubifs_leb_change(c, lnum++, buf, alen);
 		if (err)
 			goto out;
 		p = buf;
@@ -826,7 +823,7 @@ int ubifs_create_dflt_lpt(struct ubifs_info *c, int *main_lebs, int lpt_first,
 
 	/* Write remaining buffer */
 	memset(p, 0xff, alen - len);
-	err = ubifs_leb_change(c, lnum, buf, alen, UBI_SHORTTERM);
+	err = ubifs_leb_change(c, lnum, buf, alen);
 	if (err)
 		goto out;
 
diff --git a/fs/ubifs/lpt_commit.c b/fs/ubifs/lpt_commit.c
index cddd6bd..822e315 100644
--- a/fs/ubifs/lpt_commit.c
+++ b/fs/ubifs/lpt_commit.c
@@ -421,7 +421,7 @@ static int write_cnodes(struct ubifs_info *c)
 				alen = ALIGN(wlen, c->min_io_size);
 				memset(buf + offs, 0xff, alen - wlen);
 				err = ubifs_leb_write(c, lnum, buf + from, from,
-						       alen, UBI_SHORTTERM);
+						       alen);
 				if (err)
 					return err;
 			}
@@ -479,8 +479,7 @@ static int write_cnodes(struct ubifs_info *c)
 			wlen = offs - from;
 			alen = ALIGN(wlen, c->min_io_size);
 			memset(buf + offs, 0xff, alen - wlen);
-			err = ubifs_leb_write(c, lnum, buf + from, from, alen,
-					      UBI_SHORTTERM);
+			err = ubifs_leb_write(c, lnum, buf + from, from, alen);
 			if (err)
 				return err;
 			dbg_chk_lpt_sz(c, 2, c->leb_size - offs);
@@ -506,8 +505,7 @@ static int write_cnodes(struct ubifs_info *c)
 			wlen = offs - from;
 			alen = ALIGN(wlen, c->min_io_size);
 			memset(buf + offs, 0xff, alen - wlen);
-			err = ubifs_leb_write(c, lnum, buf + from, from, alen,
-					      UBI_SHORTTERM);
+			err = ubifs_leb_write(c, lnum, buf + from, from, alen);
 			if (err)
 				return err;
 			dbg_chk_lpt_sz(c, 2, c->leb_size - offs);
@@ -531,7 +529,7 @@ static int write_cnodes(struct ubifs_info *c)
 	wlen = offs - from;
 	alen = ALIGN(wlen, c->min_io_size);
 	memset(buf + offs, 0xff, alen - wlen);
-	err = ubifs_leb_write(c, lnum, buf + from, from, alen, UBI_SHORTTERM);
+	err = ubifs_leb_write(c, lnum, buf + from, from, alen);
 	if (err)
 		return err;
 
diff --git a/fs/ubifs/master.c b/fs/ubifs/master.c
index 278c238..e1bd367 100644
--- a/fs/ubifs/master.c
+++ b/fs/ubifs/master.c
@@ -379,7 +379,7 @@ int ubifs_write_master(struct ubifs_info *c)
 	c->mst_offs = offs;
 	c->mst_node->highest_inum = cpu_to_le64(c->highest_inum);
 
-	err = ubifs_write_node(c, c->mst_node, len, lnum, offs, UBI_SHORTTERM);
+	err = ubifs_write_node(c, c->mst_node, len, lnum, offs);
 	if (err)
 		return err;
 
@@ -390,7 +390,7 @@ int ubifs_write_master(struct ubifs_info *c)
 		if (err)
 			return err;
 	}
-	err = ubifs_write_node(c, c->mst_node, len, lnum, offs, UBI_SHORTTERM);
+	err = ubifs_write_node(c, c->mst_node, len, lnum, offs);
 
 	return err;
 }
diff --git a/fs/ubifs/orphan.c b/fs/ubifs/orphan.c
index c542c73..6c0a2c9 100644
--- a/fs/ubifs/orphan.c
+++ b/fs/ubifs/orphan.c
@@ -248,8 +248,7 @@ static int do_write_orph_node(struct ubifs_info *c, int len, int atomic)
 		ubifs_assert(c->ohead_offs == 0);
 		ubifs_prepare_node(c, c->orph_buf, len, 1);
 		len = ALIGN(len, c->min_io_size);
-		err = ubifs_leb_change(c, c->ohead_lnum, c->orph_buf, len,
-				       UBI_SHORTTERM);
+		err = ubifs_leb_change(c, c->ohead_lnum, c->orph_buf, len);
 	} else {
 		if (c->ohead_offs == 0) {
 			/* Ensure LEB has been unmapped */
@@ -258,7 +257,7 @@ static int do_write_orph_node(struct ubifs_info *c, int len, int atomic)
 				return err;
 		}
 		err = ubifs_write_node(c, c->orph_buf, len, c->ohead_lnum,
-				       c->ohead_offs, UBI_SHORTTERM);
+				       c->ohead_offs);
 	}
 	return err;
 }
diff --git a/fs/ubifs/recovery.c b/fs/ubifs/recovery.c
index 2a935b3..0c3bb1f 100644
--- a/fs/ubifs/recovery.c
+++ b/fs/ubifs/recovery.c
@@ -213,10 +213,10 @@ static int write_rcvrd_mst_node(struct ubifs_info *c,
 	mst->flags |= cpu_to_le32(UBIFS_MST_RCVRY);
 
 	ubifs_prepare_node(c, mst, UBIFS_MST_NODE_SZ, 1);
-	err = ubifs_leb_change(c, lnum, mst, sz, UBI_SHORTTERM);
+	err = ubifs_leb_change(c, lnum, mst, sz);
 	if (err)
 		goto out;
-	err = ubifs_leb_change(c, lnum + 1, mst, sz, UBI_SHORTTERM);
+	err = ubifs_leb_change(c, lnum + 1, mst, sz);
 	if (err)
 		goto out;
 out:
@@ -555,8 +555,7 @@ static int fix_unclean_leb(struct ubifs_info *c, struct ubifs_scan_leb *sleb,
 					ubifs_pad(c, buf, pad_len);
 				}
 			}
-			err = ubifs_leb_change(c, lnum, sleb->buf, len,
-					       UBI_UNKNOWN);
+			err = ubifs_leb_change(c, lnum, sleb->buf, len);
 			if (err)
 				return err;
 		}
@@ -941,7 +940,7 @@ static int recover_head(struct ubifs_info *c, int lnum, int offs, void *sbuf)
 		err = ubifs_leb_read(c, lnum, sbuf, 0, offs, 1);
 		if (err)
 			return err;
-		return ubifs_leb_change(c, lnum, sbuf, offs, UBI_UNKNOWN);
+		return ubifs_leb_change(c, lnum, sbuf, offs);
 	}
 
 	return 0;
@@ -1071,7 +1070,7 @@ static int clean_an_unclean_leb(struct ubifs_info *c,
 	}
 
 	/* Write back the LEB atomically */
-	err = ubifs_leb_change(c, lnum, sbuf, len, UBI_UNKNOWN);
+	err = ubifs_leb_change(c, lnum, sbuf, len);
 	if (err)
 		return err;
 
@@ -1472,7 +1471,7 @@ static int fix_size_in_place(struct ubifs_info *c, struct size_entry *e)
 		len -= 1;
 	len = ALIGN(len + 1, c->min_io_size);
 	/* Atomically write the fixed LEB back again */
-	err = ubifs_leb_change(c, lnum, c->sbuf, len, UBI_UNKNOWN);
+	err = ubifs_leb_change(c, lnum, c->sbuf, len);
 	if (err)
 		goto out;
 	dbg_rcvry("inode %lu at %d:%d size %lld -> %lld",
diff --git a/fs/ubifs/replay.c b/fs/ubifs/replay.c
index b007637..b5c3ef7 100644
--- a/fs/ubifs/replay.c
+++ b/fs/ubifs/replay.c
@@ -154,8 +154,7 @@ static int set_bud_lprops(struct ubifs_info *c, struct bud_entry *b)
 
 	/* Make sure the journal head points to the latest bud */
 	err = ubifs_wbuf_seek_nolock(&c->jheads[b->bud->jhead].wbuf,
-				     b->bud->lnum, c->leb_size - b->free,
-				     UBI_SHORTTERM);
+				     b->bud->lnum, c->leb_size - b->free);
 
 out:
 	ubifs_release_lprops(c);
diff --git a/fs/ubifs/sb.c b/fs/ubifs/sb.c
index 771f7fb..0c54bf7 100644
--- a/fs/ubifs/sb.c
+++ b/fs/ubifs/sb.c
@@ -196,7 +196,7 @@ static int create_default_filesystem(struct ubifs_info *c)
 	sup->rp_size = cpu_to_le64(tmp64);
 	sup->ro_compat_version = cpu_to_le32(UBIFS_RO_COMPAT_VERSION);
 
-	err = ubifs_write_node(c, sup, UBIFS_SB_NODE_SZ, 0, 0, UBI_LONGTERM);
+	err = ubifs_write_node(c, sup, UBIFS_SB_NODE_SZ, 0, 0);
 	kfree(sup);
 	if (err)
 		return err;
@@ -252,14 +252,12 @@ static int create_default_filesystem(struct ubifs_info *c)
 
 	mst->total_used = cpu_to_le64(UBIFS_INO_NODE_SZ);
 
-	err = ubifs_write_node(c, mst, UBIFS_MST_NODE_SZ, UBIFS_MST_LNUM, 0,
-			       UBI_UNKNOWN);
+	err = ubifs_write_node(c, mst, UBIFS_MST_NODE_SZ, UBIFS_MST_LNUM, 0);
 	if (err) {
 		kfree(mst);
 		return err;
 	}
-	err = ubifs_write_node(c, mst, UBIFS_MST_NODE_SZ, UBIFS_MST_LNUM + 1, 0,
-			       UBI_UNKNOWN);
+	err = ubifs_write_node(c, mst, UBIFS_MST_NODE_SZ, UBIFS_MST_LNUM + 1, 0);
 	kfree(mst);
 	if (err)
 		return err;
@@ -282,8 +280,7 @@ static int create_default_filesystem(struct ubifs_info *c)
 	key_write_idx(c, &key, &br->key);
 	br->lnum = cpu_to_le32(main_first + DEFAULT_DATA_LEB);
 	br->len  = cpu_to_le32(UBIFS_INO_NODE_SZ);
-	err = ubifs_write_node(c, idx, tmp, main_first + DEFAULT_IDX_LEB, 0,
-			       UBI_UNKNOWN);
+	err = ubifs_write_node(c, idx, tmp, main_first + DEFAULT_IDX_LEB, 0);
 	kfree(idx);
 	if (err)
 		return err;
@@ -315,8 +312,7 @@ static int create_default_filesystem(struct ubifs_info *c)
 	ino->flags = cpu_to_le32(UBIFS_COMPR_FL);
 
 	err = ubifs_write_node(c, ino, UBIFS_INO_NODE_SZ,
-			       main_first + DEFAULT_DATA_LEB, 0,
-			       UBI_UNKNOWN);
+			       main_first + DEFAULT_DATA_LEB, 0);
 	kfree(ino);
 	if (err)
 		return err;
@@ -335,8 +331,7 @@ static int create_default_filesystem(struct ubifs_info *c)
 		return -ENOMEM;
 
 	cs->ch.node_type = UBIFS_CS_NODE;
-	err = ubifs_write_node(c, cs, UBIFS_CS_NODE_SZ, UBIFS_LOG_LNUM,
-			       0, UBI_UNKNOWN);
+	err = ubifs_write_node(c, cs, UBIFS_CS_NODE_SZ, UBIFS_LOG_LNUM, 0);
 	kfree(cs);
 
 	ubifs_msg("default file-system created");
@@ -518,7 +513,7 @@ int ubifs_write_sb_node(struct ubifs_info *c, struct ubifs_sb_node *sup)
 	int len = ALIGN(UBIFS_SB_NODE_SZ, c->min_io_size);
 
 	ubifs_prepare_node(c, sup, UBIFS_SB_NODE_SZ, 1);
-	return ubifs_leb_change(c, UBIFS_SB_LNUM, sup, len, UBI_LONGTERM);
+	return ubifs_leb_change(c, UBIFS_SB_LNUM, sup, len);
 }
 
 /**
@@ -691,7 +686,7 @@ static int fixup_leb(struct ubifs_info *c, int lnum, int len)
 	if (err)
 		return err;
 
-	return ubifs_leb_change(c, lnum, c->sbuf, len, UBI_UNKNOWN);
+	return ubifs_leb_change(c, lnum, c->sbuf, len);
 }
 
 /**
diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index 76e4e05..7a3ce9f 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -813,13 +813,11 @@ static int alloc_wbufs(struct ubifs_info *c)
 		c->jheads[i].grouped = 1;
 	}
 
-	c->jheads[BASEHD].wbuf.dtype = UBI_SHORTTERM;
 	/*
 	 * Garbage Collector head likely contains long-term data and
 	 * does not need to be synchronized by timer. Also GC head nodes are
 	 * not grouped.
 	 */
-	c->jheads[GCHD].wbuf.dtype = UBI_LONGTERM;
 	c->jheads[GCHD].wbuf.no_timer = 1;
 	c->jheads[GCHD].grouped = 0;
 
diff --git a/fs/ubifs/tnc_commit.c b/fs/ubifs/tnc_commit.c
index 4c15f07..0b05ff35 100644
--- a/fs/ubifs/tnc_commit.c
+++ b/fs/ubifs/tnc_commit.c
@@ -322,8 +322,7 @@ static int layout_leb_in_gaps(struct ubifs_info *c, int *p)
 				  0, 0, 0);
 	if (err)
 		return err;
-	err = ubifs_leb_change(c, lnum, c->ileb_buf, c->ileb_len,
-			       UBI_SHORTTERM);
+	err = ubifs_leb_change(c, lnum, c->ileb_buf, c->ileb_len);
 	if (err)
 		return err;
 	dbg_gc("LEB %d wrote %d index nodes", lnum, tot_written);
@@ -959,8 +958,7 @@ static int write_index(struct ubifs_info *c)
 		}
 
 		/* The buffer is full or there are no more znodes to do */
-		err = ubifs_leb_write(c, lnum, c->cbuf, buf_offs, blen,
-				      UBI_SHORTTERM);
+		err = ubifs_leb_write(c, lnum, c->cbuf, buf_offs, blen);
 		if (err)
 			return err;
 		buf_offs += blen;
diff --git a/fs/ubifs/ubifs.h b/fs/ubifs/ubifs.h
index 93d59ac..c8e7a42 100644
--- a/fs/ubifs/ubifs.h
+++ b/fs/ubifs/ubifs.h
@@ -650,8 +650,6 @@ typedef int (*ubifs_lpt_scan_callback)(struct ubifs_info *c,
  * @avail: number of bytes available in the write-buffer
  * @used:  number of used bytes in the write-buffer
  * @size: write-buffer size (in [@c->min_io_size, @c->max_write_size] range)
- * @dtype: type of data stored in this LEB (%UBI_LONGTERM, %UBI_SHORTTERM,
- * %UBI_UNKNOWN)
  * @jhead: journal head the mutex belongs to (note, needed only to shut lockdep
  *         up by 'mutex_lock_nested()).
  * @sync_callback: write-buffer synchronization callback
@@ -685,7 +683,6 @@ struct ubifs_wbuf {
 	int avail;
 	int used;
 	int size;
-	int dtype;
 	int jhead;
 	int (*sync_callback)(struct ubifs_info *c, int lnum, int free, int pad);
 	struct mutex io_mutex;
@@ -1468,22 +1465,20 @@ void ubifs_ro_mode(struct ubifs_info *c, int err);
 int ubifs_leb_read(const struct ubifs_info *c, int lnum, void *buf, int offs,
 		   int len, int even_ebadmsg);
 int ubifs_leb_write(struct ubifs_info *c, int lnum, const void *buf, int offs,
-		    int len, int dtype);
-int ubifs_leb_change(struct ubifs_info *c, int lnum, const void *buf, int len,
-		     int dtype);
+		    int len);
+int ubifs_leb_change(struct ubifs_info *c, int lnum, const void *buf, int len);
 int ubifs_leb_unmap(struct ubifs_info *c, int lnum);
-int ubifs_leb_map(struct ubifs_info *c, int lnum, int dtype);
+int ubifs_leb_map(struct ubifs_info *c, int lnum);
 int ubifs_is_mapped(const struct ubifs_info *c, int lnum);
 int ubifs_wbuf_write_nolock(struct ubifs_wbuf *wbuf, void *buf, int len);
-int ubifs_wbuf_seek_nolock(struct ubifs_wbuf *wbuf, int lnum, int offs,
-			   int dtype);
+int ubifs_wbuf_seek_nolock(struct ubifs_wbuf *wbuf, int lnum, int offs);
 int ubifs_wbuf_init(struct ubifs_info *c, struct ubifs_wbuf *wbuf);
 int ubifs_read_node(const struct ubifs_info *c, void *buf, int type, int len,
 		    int lnum, int offs);
 int ubifs_read_node_wbuf(struct ubifs_wbuf *wbuf, void *buf, int type, int len,
 			 int lnum, int offs);
 int ubifs_write_node(struct ubifs_info *c, void *node, int len, int lnum,
-		     int offs, int dtype);
+		     int offs);
 int ubifs_check_node(const struct ubifs_info *c, const void *buf, int lnum,
 		     int offs, int quiet, int must_chk_crc);
 void ubifs_prepare_node(struct ubifs_info *c, void *buf, int len, int pad);
diff --git a/include/linux/mtd/ubi.h b/include/linux/mtd/ubi.h
index db4836b..9838dce 100644
--- a/include/linux/mtd/ubi.h
+++ b/include/linux/mtd/ubi.h
@@ -208,12 +208,12 @@ void ubi_close_volume(struct ubi_volume_desc *desc);
 int ubi_leb_read(struct ubi_volume_desc *desc, int lnum, char *buf, int offset,
 		 int len, int check);
 int ubi_leb_write(struct ubi_volume_desc *desc, int lnum, const void *buf,
-		  int offset, int len, int dtype);
+		  int offset, int len);
 int ubi_leb_change(struct ubi_volume_desc *desc, int lnum, const void *buf,
-		   int len, int dtype);
+		   int len);
 int ubi_leb_erase(struct ubi_volume_desc *desc, int lnum);
 int ubi_leb_unmap(struct ubi_volume_desc *desc, int lnum);
-int ubi_leb_map(struct ubi_volume_desc *desc, int lnum, int dtype);
+int ubi_leb_map(struct ubi_volume_desc *desc, int lnum);
 int ubi_is_mapped(struct ubi_volume_desc *desc, int lnum);
 int ubi_sync(int ubi_num);
 
@@ -226,25 +226,4 @@ static inline int ubi_read(struct ubi_volume_desc *desc, int lnum, char *buf,
 {
 	return ubi_leb_read(desc, lnum, buf, offset, len, 0);
 }
-
-/*
- * This function is the same as the 'ubi_leb_write()' functions, but it does
- * not have the data type argument.
- */
-static inline int ubi_write(struct ubi_volume_desc *desc, int lnum,
-			    const void *buf, int offset, int len)
-{
-	return ubi_leb_write(desc, lnum, buf, offset, len, UBI_UNKNOWN);
-}
-
-/*
- * This function is the same as the 'ubi_leb_change()' functions, but it does
- * not have the data type argument.
- */
-static inline int ubi_change(struct ubi_volume_desc *desc, int lnum,
-				    const void *buf, int len)
-{
-	return ubi_leb_change(desc, lnum, buf, len, UBI_UNKNOWN);
-}
-
 #endif /* !__LINUX_UBI_H__ */
-- 
1.7.6.5

