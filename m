Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758645Ab2EIRjP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 13:39:15 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47837 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756799Ab2EIRjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 13:39:08 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: tim.bird@am.sony.com, tglx@linutronix.de, dedekind1@gmail.com,
        linux-kernel@vger.kernel.org, Heinz.Egger@linutronix.de,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 3/7] [RFC] UBI: Export next_sqnum()
Date: Wed,  9 May 2012 19:38:41 +0200
Message-Id: <1336585125-127220-4-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1336585125-127220-1-git-send-email-richard@nod.at>
References: <1336585125-127220-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The checkpointing subsystem needs to read the next sequence nummber
directly.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/eba.c |   18 +++++++++---------
 drivers/mtd/ubi/ubi.h |    1 +
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/mtd/ubi/eba.c b/drivers/mtd/ubi/eba.c
index 2455d62..6c99e43 100644
--- a/drivers/mtd/ubi/eba.c
+++ b/drivers/mtd/ubi/eba.c
@@ -57,7 +57,7 @@
  * global sequence counter value. It also increases the global sequence
  * counter.
  */
-static unsigned long long next_sqnum(struct ubi_device *ubi)
+unsigned long long ubi_next_sqnum(struct ubi_device *ubi)
 {
 	unsigned long long sqnum;
 
@@ -522,7 +522,7 @@ retry:
 		goto out_put;
 	}
 
-	vid_hdr->sqnum = cpu_to_be64(next_sqnum(ubi));
+	vid_hdr->sqnum = cpu_to_be64(ubi_next_sqnum(ubi));
 	err = ubi_io_write_vid_hdr(ubi, new_pnum, vid_hdr);
 	if (err)
 		goto write_error;
@@ -634,7 +634,7 @@ int ubi_eba_write_leb(struct ubi_device *ubi, struct ubi_volume *vol, int lnum,
 	}
 
 	vid_hdr->vol_type = UBI_VID_DYNAMIC;
-	vid_hdr->sqnum = cpu_to_be64(next_sqnum(ubi));
+	vid_hdr->sqnum = cpu_to_be64(ubi_next_sqnum(ubi));
 	vid_hdr->vol_id = cpu_to_be32(vol_id);
 	vid_hdr->lnum = cpu_to_be32(lnum);
 	vid_hdr->compat = ubi_get_compat(ubi, vol_id);
@@ -695,7 +695,7 @@ write_error:
 		return err;
 	}
 
-	vid_hdr->sqnum = cpu_to_be64(next_sqnum(ubi));
+	vid_hdr->sqnum = cpu_to_be64(ubi_next_sqnum(ubi));
 	ubi_msg("try another PEB");
 	goto retry;
 }
@@ -750,7 +750,7 @@ int ubi_eba_write_leb_st(struct ubi_device *ubi, struct ubi_volume *vol,
 		return err;
 	}
 
-	vid_hdr->sqnum = cpu_to_be64(next_sqnum(ubi));
+	vid_hdr->sqnum = cpu_to_be64(ubi_next_sqnum(ubi));
 	vid_hdr->vol_id = cpu_to_be32(vol_id);
 	vid_hdr->lnum = cpu_to_be32(lnum);
 	vid_hdr->compat = ubi_get_compat(ubi, vol_id);
@@ -815,7 +815,7 @@ write_error:
 		return err;
 	}
 
-	vid_hdr->sqnum = cpu_to_be64(next_sqnum(ubi));
+	vid_hdr->sqnum = cpu_to_be64(ubi_next_sqnum(ubi));
 	ubi_msg("try another PEB");
 	goto retry;
 }
@@ -868,7 +868,7 @@ int ubi_eba_atomic_leb_change(struct ubi_device *ubi, struct ubi_volume *vol,
 	if (err)
 		goto out_mutex;
 
-	vid_hdr->sqnum = cpu_to_be64(next_sqnum(ubi));
+	vid_hdr->sqnum = cpu_to_be64(ubi_next_sqnum(ubi));
 	vid_hdr->vol_id = cpu_to_be32(vol_id);
 	vid_hdr->lnum = cpu_to_be32(lnum);
 	vid_hdr->compat = ubi_get_compat(ubi, vol_id);
@@ -936,7 +936,7 @@ write_error:
 		goto out_leb_unlock;
 	}
 
-	vid_hdr->sqnum = cpu_to_be64(next_sqnum(ubi));
+	vid_hdr->sqnum = cpu_to_be64(ubi_next_sqnum(ubi));
 	ubi_msg("try another PEB");
 	goto retry;
 }
@@ -1096,7 +1096,7 @@ int ubi_eba_copy_leb(struct ubi_device *ubi, int from, int to,
 		vid_hdr->data_size = cpu_to_be32(data_size);
 		vid_hdr->data_crc = cpu_to_be32(crc);
 	}
-	vid_hdr->sqnum = cpu_to_be64(next_sqnum(ubi));
+	vid_hdr->sqnum = cpu_to_be64(ubi_next_sqnum(ubi));
 
 	err = ubi_io_write_vid_hdr(ubi, to, vid_hdr);
 	if (err) {
diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
index 83fd308..8d2efb9 100644
--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -575,6 +575,7 @@ int ubi_eba_atomic_leb_change(struct ubi_device *ubi, struct ubi_volume *vol,
 int ubi_eba_copy_leb(struct ubi_device *ubi, int from, int to,
 		     struct ubi_vid_hdr *vid_hdr);
 int ubi_eba_init_scan(struct ubi_device *ubi, struct ubi_scan_info *si);
+unsigned long long ubi_next_sqnum(struct ubi_device *ubi);
 
 /* wl.c */
 int ubi_wl_get_peb(struct ubi_device *ubi, int dtype);
-- 
1.7.6.5

