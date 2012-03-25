Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756780Ab2CYS2I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 14:28:08 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:54718 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756718Ab2CYS2F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 14:28:05 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: kernel-janitors@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/s390/block/dasd_eckd.c: add missing dasd_sfree_request
Date: Sun, 25 Mar 2012 20:27:58 +0200
Message-Id: <1332700078-19444-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Extend some error paths to call dasd_sfree_request as done earlier in the
function.  The error-handling code is also moved to the end of the function.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/s390/block/dasd_eckd.c |   24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/s390/block/dasd_eckd.c b/drivers/s390/block/dasd_eckd.c
index c21871a..bc2e8a7 100644
--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -2844,6 +2844,7 @@ static struct dasd_ccw_req *dasd_eckd_build_cp_tpm_track(
 	sector_t recid, trkid;
 	unsigned int offs;
 	unsigned int count, count_to_trk_end;
+	int ret;
 
 	basedev = block->base;
 	if (rq_data_dir(req) == READ) {
@@ -2884,8 +2885,8 @@ static struct dasd_ccw_req *dasd_eckd_build_cp_tpm_track(
 
 	itcw = itcw_init(cqr->data, itcw_size, itcw_op, 0, ctidaw, 0);
 	if (IS_ERR(itcw)) {
-		dasd_sfree_request(cqr, startdev);
-		return ERR_PTR(-EINVAL);
+		ret = -EINVAL;
+		goto out_error;
 	}
 	cqr->cpaddr = itcw_get_tcw(itcw);
 	if (prepare_itcw(itcw, first_trk, last_trk,
@@ -2897,8 +2898,8 @@ static struct dasd_ccw_req *dasd_eckd_build_cp_tpm_track(
 		/* Clock not in sync and XRC is enabled.
 		 * Try again later.
 		 */
-		dasd_sfree_request(cqr, startdev);
-		return ERR_PTR(-EAGAIN);
+		ret = -EAGAIN;
+		goto out_error;
 	}
 	len_to_track_end = 0;
 	/*
@@ -2937,8 +2938,10 @@ static struct dasd_ccw_req *dasd_eckd_build_cp_tpm_track(
 					tidaw_flags = 0;
 				last_tidaw = itcw_add_tidaw(itcw, tidaw_flags,
 							    dst, part_len);
-				if (IS_ERR(last_tidaw))
-					return ERR_PTR(-EINVAL);
+				if (IS_ERR(last_tidaw)) {
+					ret = -EINVAL;
+					goto out_error;
+				}
 				dst += part_len;
 			}
 		}
@@ -2947,8 +2950,10 @@ static struct dasd_ccw_req *dasd_eckd_build_cp_tpm_track(
 			dst = page_address(bv->bv_page) + bv->bv_offset;
 			last_tidaw = itcw_add_tidaw(itcw, 0x00,
 						    dst, bv->bv_len);
-			if (IS_ERR(last_tidaw))
-				return ERR_PTR(-EINVAL);
+			if (IS_ERR(last_tidaw)) {
+				ret = -EINVAL;
+				goto out_error;
+			}
 		}
 	}
 	last_tidaw->flags |= TIDAW_FLAGS_LAST;
@@ -2968,6 +2973,9 @@ static struct dasd_ccw_req *dasd_eckd_build_cp_tpm_track(
 	cqr->buildclk = get_clock();
 	cqr->status = DASD_CQR_FILLED;
 	return cqr;
+out_error:
+	dasd_sfree_request(cqr, startdev);
+	return ERR_PTR(ret);
 }
 
 static struct dasd_ccw_req *dasd_eckd_build_cp(struct dasd_device *startdev,

