Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696Ab2FWNEV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 09:04:21 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47840 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754382Ab2FWNDm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 09:03:42 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        Heinz.Egger@linutronix.de, thomas.wucher@linutronix.de,
        shmulik.ladkani@gmail.com, tglx@linutronix.de, tim.bird@am.sony.com,
        Marius.Mazarel@ugal.ro, artem.bityutskiy@linux.intel.com,
        nyoushchenko@mvista.com, Richard Weinberger <richard@nod.at>
Subject: [PATCH 6/7] UBI: Fastmap: Reuse all fastmap PEB if no free PEBs are available
Date: Sat, 23 Jun 2012 15:03:21 +0200
Message-Id: <1340456602-46050-7-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1340456602-46050-1-git-send-email-richard@nod.at>
References: <1340456602-46050-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/fastmap.c |   42 ++++++++++++++++++++++++++++++++----------
 1 files changed, 32 insertions(+), 10 deletions(-)

diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
index acd0561..ecbed52 100644
--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -1423,7 +1423,7 @@ int ubi_update_fastmap(struct ubi_device *ubi)
 		tmp_e = ubi_wl_get_fm_peb(ubi, 0);
 		spin_unlock(&ubi->wl_lock);
 
-		if (!tmp_e) {
+		if (!tmp_e && !old_fm) {
 			int j;
 			ubi_err("could not get any free erase block");
 
@@ -1432,10 +1432,28 @@ int ubi_update_fastmap(struct ubi_device *ubi)
 
 			ret = -ENOSPC;
 			goto err;
-		}
+		} else if (!tmp_e && old_fm) {
+			ret = erase_block(ubi, old_fm->e[i]->pnum);
+			if (ret < 0) {
+				int j;
+
+				for (j = 1; j < i; j++)
+					ubi_wl_put_fm_peb(ubi, new_fm->e[j], 0);
+
+				ubi_err("could not erase old fastmap PEB");
+				goto err;
+			}
 
-		new_fm->e[i]->pnum = tmp_e->pnum;
-		new_fm->e[i]->ec = tmp_e->ec;
+			new_fm->e[i]->pnum = old_fm->e[i]->pnum;
+			new_fm->e[i]->ec = old_fm->e[i]->ec;
+		} else {
+			new_fm->e[i]->pnum = tmp_e->pnum;
+			new_fm->e[i]->ec = tmp_e->ec;
+
+			if (old_fm)
+				ubi_wl_put_fm_peb(ubi, old_fm->e[i],
+						  old_fm->to_be_tortured[i]);
+		}
 	}
 
 	spin_lock(&ubi->wl_lock);
@@ -1447,7 +1465,11 @@ int ubi_update_fastmap(struct ubi_device *ubi)
 		if (!tmp_e) {
 			ret = erase_block(ubi, old_fm->e[0]->pnum);
 			if (ret < 0) {
+				int i;
 				ubi_err("could not erase old anchor PEB");
+
+				for (i = 1; i < new_fm->used_blocks; i++)
+					ubi_wl_put_fm_peb(ubi, new_fm->e[i], 0);
 				goto err;
 			}
 
@@ -1461,14 +1483,14 @@ int ubi_update_fastmap(struct ubi_device *ubi)
 			new_fm->e[0]->pnum = tmp_e->pnum;
 			new_fm->e[0]->ec = tmp_e->ec;
 		}
-
-		/* return all other fastmap block to the wl system */
-		for (i = 1; i < old_fm->used_blocks; i++)
-			ubi_wl_put_fm_peb(ubi, old_fm->e[i],
-					  old_fm->to_be_tortured[i]);
 	} else {
 		if (!tmp_e) {
-			ubi_err("could not find an anchor PEB");
+			int i;
+			ubi_err("could not find any anchor PEB");
+
+			for (i = 1; i < new_fm->used_blocks; i++)
+				ubi_wl_put_fm_peb(ubi, new_fm->e[i], 0);
+
 			ret = -ENOSPC;
 			goto err;
 		}
-- 
1.7.6.5

