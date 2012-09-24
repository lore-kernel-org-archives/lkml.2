Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757657Ab2IXSbz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 14:31:55 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47840 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757602Ab2IXSbv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 14:31:51 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
        Heinz.Egger@linutronix.de, artem.bityutskiy@linux.intel.com,
        tim.bird@am.sony.com, Richard Weinberger <richard@nod.at>
Subject: [PATCH 06/10] UBI: Wire-up ->fm_sem
Date: Mon, 24 Sep 2012 20:31:28 +0200
Message-Id: <1348511492-91606-7-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1348511492-91606-1-git-send-email-richard@nod.at>
References: <1348511492-91606-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fastmap uses ->fm_sem to stop EBA changes while writing
a new fastmap.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/eba.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/ubi/eba.c b/drivers/mtd/ubi/eba.c
index 8af2ebf..50b3045 100644
--- a/drivers/mtd/ubi/eba.c
+++ b/drivers/mtd/ubi/eba.c
@@ -340,7 +340,9 @@ int ubi_eba_unmap_leb(struct ubi_device *ubi, struct ubi_volume *vol,
 
 	dbg_eba("erase LEB %d:%d, PEB %d", vol_id, lnum, pnum);
 
+	down_read(&ubi->fm_sem);
 	vol->eba_tbl[lnum] = UBI_LEB_UNMAPPED;
+	up_read(&ubi->fm_sem);
 	err = ubi_wl_put_peb(ubi, vol_id, lnum, pnum, 0);
 
 out_unlock:
@@ -548,7 +550,9 @@ retry:
 	mutex_unlock(&ubi->buf_mutex);
 	ubi_free_vid_hdr(ubi, vid_hdr);
 
+	down_read(&ubi->fm_sem);
 	vol->eba_tbl[lnum] = new_pnum;
+	up_read(&ubi->fm_sem);
 	ubi_wl_put_peb(ubi, vol_id, lnum, pnum, 1);
 
 	ubi_msg("data was successfully recovered");
@@ -665,7 +669,9 @@ retry:
 		}
 	}
 
+	down_read(&ubi->fm_sem);
 	vol->eba_tbl[lnum] = pnum;
+	up_read(&ubi->fm_sem);
 
 	leb_write_unlock(ubi, vol_id, lnum);
 	ubi_free_vid_hdr(ubi, vid_hdr);
@@ -783,7 +789,9 @@ retry:
 	}
 
 	ubi_assert(vol->eba_tbl[lnum] < 0);
+	down_read(&ubi->fm_sem);
 	vol->eba_tbl[lnum] = pnum;
+	up_read(&ubi->fm_sem);
 
 	leb_write_unlock(ubi, vol_id, lnum);
 	ubi_free_vid_hdr(ubi, vid_hdr);
@@ -904,7 +912,9 @@ retry:
 			goto out_leb_unlock;
 	}
 
+	down_read(&ubi->fm_sem);
 	vol->eba_tbl[lnum] = pnum;
+	up_read(&ubi->fm_sem);
 
 out_leb_unlock:
 	leb_write_unlock(ubi, vol_id, lnum);
@@ -1151,7 +1161,9 @@ int ubi_eba_copy_leb(struct ubi_device *ubi, int from, int to,
 	}
 
 	ubi_assert(vol->eba_tbl[lnum] == from);
+	down_read(&ubi->fm_sem);
 	vol->eba_tbl[lnum] = to;
+	up_read(&ubi->fm_sem);
 
 out_unlock_buf:
 	mutex_unlock(&ubi->buf_mutex);
-- 
1.7.6.5

