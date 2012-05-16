Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932357Ab2EPMVC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 08:21:02 -0400
Received: from static.78-46-68-141.clients.your-server.de ([78.46.68.141]:47309
	"HELO eristoteles.iwoars.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1751117Ab2EPMVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 08:21:00 -0400
Date: Wed, 16 May 2012 14:20:56 +0200 (CEST)
From: Joel Reardon <joel@clambassador.com>
X-X-Sender: joel@eristoteles.iwoars.net
To: Artem Bityutskiy <dedekind1@gmail.com>
cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ubi: add volume id and LEB number to struct ubi_scan_leb
Message-ID: <alpine.DEB.2.00.1205161419590.27131@eristoteles.iwoars.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the volume id and LEB number to struct ubi_scan_leb when
scanning the LEBs at startup.  PEBs now added to the erase queue will know
their original LEB number and volume id, if available, and will be -1
otherwise (for instance, if the vid header is unreadable).

This was tested by creating an ubi device with 3 volumes and disabiling the
ubi_thread's do_work functionality. The different ubi volumes were formatted
to ubifs and had files created and erased.  The ubi modules was reloaded and
the list of LEB's added to the erased list was outputted, confirming the
volume ids and LEB numbers were appropriate.

Signed-off-by: Joel Reardon <reardonj@inf.ethz.ch>
---
 drivers/mtd/ubi/scan.c |   49 +++++++++++++++++++++++++++++------------------
 drivers/mtd/ubi/scan.h |    2 +
 2 files changed, 32 insertions(+), 19 deletions(-)

diff --git a/drivers/mtd/ubi/scan.c b/drivers/mtd/ubi/scan.c
index c26b1ad..3d87446 100644
--- a/drivers/mtd/ubi/scan.c
+++ b/drivers/mtd/ubi/scan.c
@@ -102,20 +102,23 @@ static struct ubi_vid_hdr *vidh;
  * add_to_list - add physical eraseblock to a list.
  * @si: scanning information
  * @pnum: physical eraseblock number to add
+ * @vol_id: the last used volume id for the PEB
+ * @lnum: the last used LEB number for the PEB
  * @ec: erase counter of the physical eraseblock
  * @to_head: if not zero, add to the head of the list
  * @list: the list to add to
  *
  * This function adds physical eraseblock @pnum to free, erase, or alien lists.
- * If @to_head is not zero, PEB will be added to the head of the list, which
- * basically means it will be processed first later. E.g., we add corrupted
- * PEBs (corrupted due to power cuts) to the head of the erase list to make
- * sure we erase them first and get rid of corruptions ASAP. This function
- * returns zero in case of success and a negative error code in case of
- * failure.
+ * It stores the @lnum and @vol_id alongside, which can both be -1 if they are
+ * not available, not readable, or not assigned. If @to_head is not zero, PEB
+ * will be added to the head of the list, which basically means it will be
+ * processed first later. E.g., we add corrupted PEBs (corrupted due to power
+ * cuts) to the head of the erase list to make sure we erase them first and
+ * get rid of corruptions ASAP. This function returns zero in case of success
+ * and a negative error code in case of failure.
  */
-static int add_to_list(struct ubi_scan_info *si, int pnum, int ec, int to_head,
-		       struct list_head *list)
+static int add_to_list(struct ubi_scan_info *si, int pnum, int vol_id,
+		       int lnum, int ec, int to_head, struct list_head *list)
 {
 	struct ubi_scan_leb *seb;

@@ -134,6 +137,8 @@ static int add_to_list(struct ubi_scan_info *si, int pnum, int ec, int to_head,
 		return -ENOMEM;

 	seb->pnum = pnum;
+	seb->vol_id = vol_id;
+	seb->lnum = lnum;
 	seb->ec = ec;
 	if (to_head)
 		list_add(&seb->u.list, list);
@@ -532,13 +537,16 @@ int ubi_scan_add_used(struct ubi_device *ubi, struct ubi_scan_info *si,
 			if (err)
 				return err;

-			err = add_to_list(si, seb->pnum, seb->ec, cmp_res & 4,
+			err = add_to_list(si, seb->pnum, seb->vol_id,
+					  seb->lnum, seb->ec, cmp_res & 4,
 					  &si->erase);
 			if (err)
 				return err;

 			seb->ec = ec;
 			seb->pnum = pnum;
+			seb->vol_id = vol_id;
+			seb->lnum = lnum;
 			seb->scrub = ((cmp_res & 2) || bitflips);
 			seb->copy_flag = vid_hdr->copy_flag;
 			seb->sqnum = sqnum;
@@ -553,8 +561,8 @@ int ubi_scan_add_used(struct ubi_device *ubi, struct ubi_scan_info *si,
 			 * This logical eraseblock is older than the one found
 			 * previously.
 			 */
-			return add_to_list(si, pnum, ec, cmp_res & 4,
-					   &si->erase);
+			return add_to_list(si, pnum, vol_id, lnum, ec,
+					   cmp_res & 4, &si->erase);
 		}
 	}

@@ -573,6 +581,7 @@ int ubi_scan_add_used(struct ubi_device *ubi, struct ubi_scan_info *si,

 	seb->ec = ec;
 	seb->pnum = pnum;
+	seb->vol_id = vol_id;
 	seb->lnum = lnum;
 	seb->scrub = bitflips;
 	seb->copy_flag = vid_hdr->copy_flag;
@@ -868,11 +877,11 @@ static int process_eb(struct ubi_device *ubi, struct ubi_scan_info *si,
 		break;
 	case UBI_IO_FF:
 		si->empty_peb_count += 1;
-		return add_to_list(si, pnum, UBI_SCAN_UNKNOWN_EC, 0,
+		return add_to_list(si, pnum, -1, -1, UBI_SCAN_UNKNOWN_EC, 0,
 				   &si->erase);
 	case UBI_IO_FF_BITFLIPS:
 		si->empty_peb_count += 1;
-		return add_to_list(si, pnum, UBI_SCAN_UNKNOWN_EC, 1,
+		return add_to_list(si, pnum, -1, -1, UBI_SCAN_UNKNOWN_EC, 1,
 				   &si->erase);
 	case UBI_IO_BAD_HDR_EBADMSG:
 	case UBI_IO_BAD_HDR:
@@ -984,7 +993,7 @@ static int process_eb(struct ubi_device *ubi, struct ubi_scan_info *si,
 			return err;
 		else if (!err)
 			/* This corruption is caused by a power cut */
-			err = add_to_list(si, pnum, ec, 1, &si->erase);
+			err = add_to_list(si, pnum, -1, -1, ec, 1, &si->erase);
 		else
 			/* This is an unexpected corruption */
 			err = add_corrupted(si, pnum, ec);
@@ -992,15 +1001,15 @@ static int process_eb(struct ubi_device *ubi, struct ubi_scan_info *si,
 			return err;
 		goto adjust_mean_ec;
 	case UBI_IO_FF_BITFLIPS:
-		err = add_to_list(si, pnum, ec, 1, &si->erase);
+		err = add_to_list(si, pnum, -1, -1, ec, 1, &si->erase);
 		if (err)
 			return err;
 		goto adjust_mean_ec;
 	case UBI_IO_FF:
 		if (ec_err)
-			err = add_to_list(si, pnum, ec, 1, &si->erase);
+			err = add_to_list(si, pnum, -1, -1, ec, 1, &si->erase);
 		else
-			err = add_to_list(si, pnum, ec, 0, &si->free);
+			err = add_to_list(si, pnum, -1, -1, ec, 0, &si->free);
 		if (err)
 			return err;
 		goto adjust_mean_ec;
@@ -1019,7 +1028,8 @@ static int process_eb(struct ubi_device *ubi, struct ubi_scan_info *si,
 		case UBI_COMPAT_DELETE:
 			ubi_msg("\"delete\" compatible internal volume %d:%d"
 				" found, will remove it", vol_id, lnum);
-			err = add_to_list(si, pnum, ec, 1, &si->erase);
+			err = add_to_list(si, pnum, vol_id, lnum,
+					  ec, 1, &si->erase);
 			if (err)
 				return err;
 			return 0;
@@ -1034,7 +1044,8 @@ static int process_eb(struct ubi_device *ubi, struct ubi_scan_info *si,
 		case UBI_COMPAT_PRESERVE:
 			ubi_msg("\"preserve\" compatible internal volume %d:%d"
 				" found", vol_id, lnum);
-			err = add_to_list(si, pnum, ec, 0, &si->alien);
+			err = add_to_list(si, pnum, vol_id, lnum,
+					  ec, 0, &si->alien);
 			if (err)
 				return err;
 			return 0;
diff --git a/drivers/mtd/ubi/scan.h b/drivers/mtd/ubi/scan.h
index d48aef1..e214647 100644
--- a/drivers/mtd/ubi/scan.h
+++ b/drivers/mtd/ubi/scan.h
@@ -28,6 +28,7 @@
  * struct ubi_scan_leb - scanning information about a physical eraseblock.
  * @ec: erase counter (%UBI_SCAN_UNKNOWN_EC if it is unknown)
  * @pnum: physical eraseblock number
+ * @vol_id: the volume identifier of the LEB.
  * @lnum: logical eraseblock number
  * @scrub: if this physical eraseblock needs scrubbing
  * @copy_flag: this LEB is a copy (@copy_flag is set in VID header of this LEB)
@@ -42,6 +43,7 @@
 struct ubi_scan_leb {
 	int ec;
 	int pnum;
+	int vol_id;
 	int lnum;
 	unsigned int scrub:1;
 	unsigned int copy_flag:1;
-- 
1.7.5.4

