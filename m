Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932197Ab2DKNON (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 09:14:13 -0400
Received: from static.78-46-68-141.clients.your-server.de ([78.46.68.141]:44241
	"HELO eristoteles.iwoars.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1760177Ab2DKNOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 09:14:11 -0400
Date: Wed, 11 Apr 2012 15:14:09 +0200 (CEST)
From: Joel Reardon <joel@clambassador.com>
X-X-Sender: joel@eristoteles.iwoars.net
To: Artem Bityutskiy <dedekind1@gmail.com>
cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] UBI: allow atomic updates to sychronously erase old PEB
In-Reply-To: <1334147205.13842.8.camel@sauron.fi.intel.com>
Message-ID: <alpine.DEB.2.00.1204111513230.10181@eristoteles.iwoars.net>
References: <alpine.DEB.2.00.1203291653210.912@eristoteles.iwoars.net>    <4F748CD6.4080704@parrot.com>    <alpine.DEB.2.00.1203301413080.10066@eristoteles.iwoars.net>   <1333110503.5440.24.camel@sauron.fi.intel.com>   <alpine.DEB.2.00.1203301433270.10066@eristoteles.iwoars.net>
  <1333111321.5440.29.camel@sauron.fi.intel.com>  <alpine.DEB.2.00.1203301709080.10066@eristoteles.iwoars.net> <1334147205.13842.8.camel@sauron.fi.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a proposal for adding an immediate mode for atomic updates of LEBs in
UBI. The idea is that, if the erase parameter is non-zero, then the old PEB
will be erase after the new PEB is written, but before the function returns. It
will not go into a work queue. This is for security-relevant situations where,
for instance, the user needs assurance that sensitive information on an
eraseblock is actually gone after the update.

The function schedule_erase always returns zero, because the actual error
during erasure is not known at the time. Now, if it is immediate, then it has
the ability to return an error if that fails. This would mean some functions
higher up (i.e., change_leb), will be able to return "old PEB is now bad"
messages, indicating that the secure erasure has failed.  I want to check now
that this would be okay, or should the old PEB fail be ignored, or handled in
some other way.

This causes UBIFS to no longer compile as it does not provide a sync
parameter. Another patch follows to fix this.

Signed-off-by: Joel Reardon <reardonj@inf.ethz.ch>
---
 drivers/mtd/ubi/eba.c   |   20 +++++++++++---------
 drivers/mtd/ubi/kapi.c  |    7 ++++---
 drivers/mtd/ubi/ubi.h   |    5 +++--
 drivers/mtd/ubi/upd.c   |    5 +++--
 drivers/mtd/ubi/wl.c    |   19 ++++++++++++++++---
 include/linux/mtd/ubi.h |    6 +++---
 6 files changed, 40 insertions(+), 22 deletions(-)

diff --git a/drivers/mtd/ubi/eba.c b/drivers/mtd/ubi/eba.c
index cd26da8..bf97726 100644
--- a/drivers/mtd/ubi/eba.c
+++ b/drivers/mtd/ubi/eba.c
@@ -341,7 +341,7 @@ int ubi_eba_unmap_leb(struct ubi_device *ubi, struct ubi_volume *vol,
 	dbg_eba("erase LEB %d:%d, PEB %d", vol_id, lnum, pnum);

 	vol->eba_tbl[lnum] = UBI_LEB_UNMAPPED;
-	err = ubi_wl_put_peb(ubi, pnum, 0);
+	err = ubi_wl_put_peb(ubi, pnum, 0, 0);

 out_unlock:
 	leb_write_unlock(ubi, vol_id, lnum);
@@ -550,7 +550,7 @@ retry:
 	ubi_free_vid_hdr(ubi, vid_hdr);

 	vol->eba_tbl[lnum] = new_pnum;
-	ubi_wl_put_peb(ubi, pnum, 1);
+	ubi_wl_put_peb(ubi, pnum, 1, 0);

 	ubi_msg("data was successfully recovered");
 	return 0;
@@ -558,7 +558,7 @@ retry:
 out_unlock:
 	mutex_unlock(&ubi->buf_mutex);
 out_put:
-	ubi_wl_put_peb(ubi, new_pnum, 1);
+	ubi_wl_put_peb(ubi, new_pnum, 1, 0);
 	ubi_free_vid_hdr(ubi, vid_hdr);
 	return err;

@@ -568,7 +568,7 @@ write_error:
 	 * get another one.
 	 */
 	ubi_warn("failed to write to PEB %d", new_pnum);
-	ubi_wl_put_peb(ubi, new_pnum, 1);
+	ubi_wl_put_peb(ubi, new_pnum, 1, 0);
 	if (++tries > UBI_IO_RETRIES) {
 		ubi_free_vid_hdr(ubi, vid_hdr);
 		return err;
@@ -687,7 +687,7 @@ write_error:
 	 * eraseblock, so just put it and request a new one. We assume that if
 	 * this physical eraseblock went bad, the erase code will handle that.
 	 */
-	err = ubi_wl_put_peb(ubi, pnum, 1);
+	err = ubi_wl_put_peb(ubi, pnum, 1, 0);
 	if (err || ++tries > UBI_IO_RETRIES) {
 		ubi_ro_mode(ubi);
 		leb_write_unlock(ubi, vol_id, lnum);
@@ -807,7 +807,7 @@ write_error:
 		return err;
 	}

-	err = ubi_wl_put_peb(ubi, pnum, 1);
+	err = ubi_wl_put_peb(ubi, pnum, 1, 0);
 	if (err || ++tries > UBI_IO_RETRIES) {
 		ubi_ro_mode(ubi);
 		leb_write_unlock(ubi, vol_id, lnum);
@@ -828,6 +828,7 @@ write_error:
  * @buf: data to write
  * @len: how many bytes to write
  * @dtype: data type
+ * @sync: if this physical eraseblock should be syncronously erased
  *
  * This function changes the contents of a logical eraseblock atomically. @buf
  * has to contain new logical eraseblock data, and @len - the length of the
@@ -839,7 +840,8 @@ write_error:
  * LEB change may be done at a time. This is ensured by @ubi->alc_mutex.
  */
 int ubi_eba_atomic_leb_change(struct ubi_device *ubi, struct ubi_volume *vol,
-			      int lnum, const void *buf, int len, int dtype)
+			      int lnum, const void *buf, int len, int dtype,
+			      int sync)
 {
 	int err, pnum, tries = 0, vol_id = vol->vol_id;
 	struct ubi_vid_hdr *vid_hdr;
@@ -905,7 +907,7 @@ retry:
 	}

 	if (vol->eba_tbl[lnum] >= 0) {
-		err = ubi_wl_put_peb(ubi, vol->eba_tbl[lnum], 0);
+		err = ubi_wl_put_peb(ubi, vol->eba_tbl[lnum], 0, sync);
 		if (err)
 			goto out_leb_unlock;
 	}
@@ -930,7 +932,7 @@ write_error:
 		goto out_leb_unlock;
 	}

-	err = ubi_wl_put_peb(ubi, pnum, 1);
+	err = ubi_wl_put_peb(ubi, pnum, 1, sync);
 	if (err || ++tries > UBI_IO_RETRIES) {
 		ubi_ro_mode(ubi);
 		goto out_leb_unlock;
diff --git a/drivers/mtd/ubi/kapi.c b/drivers/mtd/ubi/kapi.c
index 9fdb353..1288992 100644
--- a/drivers/mtd/ubi/kapi.c
+++ b/drivers/mtd/ubi/kapi.c
@@ -487,6 +487,7 @@ EXPORT_SYMBOL_GPL(ubi_leb_write);
  * @buf: data to write
  * @len: how many bytes to write
  * @dtype: expected data type
+ * @sync: if non-zero then blocks until old block is erased
  *
  * This function changes the contents of a logical eraseblock atomically. @buf
  * has to contain new logical eraseblock data, and @len - the length of the
@@ -497,7 +498,7 @@ EXPORT_SYMBOL_GPL(ubi_leb_write);
  * code in case of failure.
  */
 int ubi_leb_change(struct ubi_volume_desc *desc, int lnum, const void *buf,
-		   int len, int dtype)
+		   int len, int dtype, int sync)
 {
 	struct ubi_volume *vol = desc->vol;
 	struct ubi_device *ubi = vol->ubi;
@@ -524,8 +525,8 @@ int ubi_leb_change(struct ubi_volume_desc *desc, int lnum, const void *buf,

 	if (len == 0)
 		return 0;
-
-	return ubi_eba_atomic_leb_change(ubi, vol, lnum, buf, len, dtype);
+	return ubi_eba_atomic_leb_change(ubi, vol, lnum, buf,
+					 len, dtype, sync);
 }
 EXPORT_SYMBOL_GPL(ubi_leb_change);

diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
index d51d75d..dc62255 100644
--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -532,14 +532,15 @@ int ubi_eba_write_leb_st(struct ubi_device *ubi, struct ubi_volume *vol,
 			 int lnum, const void *buf, int len, int dtype,
 			 int used_ebs);
 int ubi_eba_atomic_leb_change(struct ubi_device *ubi, struct ubi_volume *vol,
-			      int lnum, const void *buf, int len, int dtype);
+			      int lnum, const void *buf, int len, int dtype,
+			      int sync);
 int ubi_eba_copy_leb(struct ubi_device *ubi, int from, int to,
 		     struct ubi_vid_hdr *vid_hdr);
 int ubi_eba_init_scan(struct ubi_device *ubi, struct ubi_scan_info *si);

 /* wl.c */
 int ubi_wl_get_peb(struct ubi_device *ubi, int dtype);
-int ubi_wl_put_peb(struct ubi_device *ubi, int pnum, int torture);
+int ubi_wl_put_peb(struct ubi_device *ubi, int pnum, int torture, int sync);
 int ubi_wl_flush(struct ubi_device *ubi);
 int ubi_wl_scrub_peb(struct ubi_device *ubi, int pnum);
 int ubi_wl_init_scan(struct ubi_device *ubi, struct ubi_scan_info *si);
diff --git a/drivers/mtd/ubi/upd.c b/drivers/mtd/ubi/upd.c
index 425bf5a..7584aed 100644
--- a/drivers/mtd/ubi/upd.c
+++ b/drivers/mtd/ubi/upd.c
@@ -187,7 +187,7 @@ int ubi_start_leb_change(struct ubi_device *ubi, struct ubi_volume *vol,
 		vol->vol_id, req->lnum, req->bytes);
 	if (req->bytes == 0)
 		return ubi_eba_atomic_leb_change(ubi, vol, req->lnum, NULL, 0,
-						 req->dtype);
+						 req->dtype, 0);

 	vol->upd_bytes = req->bytes;
 	vol->upd_received = 0;
@@ -421,7 +421,8 @@ int ubi_more_leb_change_data(struct ubi_device *ubi, struct ubi_volume *vol,
 		       len - vol->upd_bytes);
 		len = ubi_calc_data_len(ubi, vol->upd_buf, len);
 		err = ubi_eba_atomic_leb_change(ubi, vol, vol->ch_lnum,
-						vol->upd_buf, len, UBI_UNKNOWN);
+						vol->upd_buf, len,
+						UBI_UNKNOWN, 0);
 		if (err)
 			return err;
 	}
diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index 0696e36..a9b1601 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -469,7 +469,6 @@ retry:
 		ubi_err("new PEB %d does not contain all 0xFF bytes", e->pnum);
 		return err;
 	}
-
 	return e->pnum;
 }

@@ -1128,13 +1127,14 @@ out_ro:
  * @ubi: UBI device description object
  * @pnum: physical eraseblock to return
  * @torture: if this physical eraseblock has to be tortured
+ * @sync: if this physical eraseblock should be synchronously erased
  *
  * This function is called to return physical eraseblock @pnum to the pool of
  * free physical eraseblocks. The @torture flag has to be set if an I/O error
  * occurred to this @pnum and it has to be tested. This function returns zero
  * in case of success, and a negative error code in case of failure.
  */
-int ubi_wl_put_peb(struct ubi_device *ubi, int pnum, int torture)
+int ubi_wl_put_peb(struct ubi_device *ubi, int pnum, int torture, int sync)
 {
 	int err;
 	struct ubi_wl_entry *e;
@@ -1199,8 +1199,21 @@ retry:
 		}
 	}
 	spin_unlock(&ubi->wl_lock);
+	if (sync) {
+		struct ubi_work *wl_wrk;
+
+		wl_wrk = kmalloc(sizeof(struct ubi_work), GFP_NOFS);
+		if (!wl_wrk)
+			return -ENOMEM;
+
+		wl_wrk->e = e;
+		wl_wrk->torture = torture;
+
+		err = erase_worker(ubi, wl_wrk, 0);
+	} else {
+		err = schedule_erase(ubi, e, torture);
+	}

-	err = schedule_erase(ubi, e, torture);
 	if (err) {
 		spin_lock(&ubi->wl_lock);
 		wl_tree_add(e, &ubi->used);
diff --git a/include/linux/mtd/ubi.h b/include/linux/mtd/ubi.h
index db4836b..13f8c63 100644
--- a/include/linux/mtd/ubi.h
+++ b/include/linux/mtd/ubi.h
@@ -210,7 +210,7 @@ int ubi_leb_read(struct ubi_volume_desc *desc, int lnum, char *buf, int offset,
 int ubi_leb_write(struct ubi_volume_desc *desc, int lnum, const void *buf,
 		  int offset, int len, int dtype);
 int ubi_leb_change(struct ubi_volume_desc *desc, int lnum, const void *buf,
-		   int len, int dtype);
+		   int len, int dtype, int sync);
 int ubi_leb_erase(struct ubi_volume_desc *desc, int lnum);
 int ubi_leb_unmap(struct ubi_volume_desc *desc, int lnum);
 int ubi_leb_map(struct ubi_volume_desc *desc, int lnum, int dtype);
@@ -239,12 +239,12 @@ static inline int ubi_write(struct ubi_volume_desc *desc, int lnum,

 /*
  * This function is the same as the 'ubi_leb_change()' functions, but it does
- * not have the data type argument.
+ * not have the data type argument or the synchronous erasure argument.
  */
 static inline int ubi_change(struct ubi_volume_desc *desc, int lnum,
 				    const void *buf, int len)
 {
-	return ubi_leb_change(desc, lnum, buf, len, UBI_UNKNOWN);
+	return ubi_leb_change(desc, lnum, buf, len, UBI_UNKNOWN, 0);
 }

 #endif /* !__LINUX_UBI_H__ */
-- 
1.7.5.4


