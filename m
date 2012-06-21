Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932834Ab2FUVwU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 17:52:20 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47843 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760479Ab2FUVu2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 17:50:28 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        Heinz.Egger@linutronix.de, thomas.wucher@linutronix.de,
        shmulik.ladkani@gmail.com, tglx@linutronix.de, tim.bird@am.sony.com,
        Marius.Mazarel@ugal.ro, artem.bityutskiy@linux.intel.com,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 09/15] UBI: Fastmap: Simplify attach by fastmap
Date: Thu, 21 Jun 2012 23:50:02 +0200
Message-Id: <1340315408-27375-10-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1340315408-27375-1-git-send-email-richard@nod.at>
References: <UBI fastmap updates>
 <1340315408-27375-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to check for this corner cases anymore.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/fastmap.c |   43 -------------------------------------------
 1 files changed, 0 insertions(+), 43 deletions(-)

diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
index ba69267..da303b6 100644
--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -707,49 +707,6 @@ static int ubi_attach_fastmap(struct ubi_device *ubi,
 	if (max_sqnum > ai->max_sqnum)
 		ai->max_sqnum = max_sqnum;
 
-	list_for_each_entry_safe(tmp_aeb, _tmp_aeb, &used, u.list) {
-		list_del(&tmp_aeb->u.list);
-		ubi_msg("moving PEB from used to erase: %i", tmp_aeb->pnum);
-		add_aeb(ai, &ai->erase, tmp_aeb->pnum, tmp_aeb->ec, 0);
-		kmem_cache_free(ai->aeb_slab_cache, tmp_aeb);
-	}
-
-	/*
-	 * Sort out dups. We are allowed to have duplicates here because
-	 * the fastmap can be written without refilling all pools.
-	 * E.g. If PEB X is in a pool fastmap may detect it as empty and
-	 * puts it into the free list. But ff PEB X is in the pool, get's
-	 * used and returned (e.g. by schedule_erase()) it remains in
-	 * the erase or free list too.
-	 * We could also sort out these dups while creating the fastmap.
-	 */
-	if (list_empty(&free))
-		goto out;
-
-	list_for_each_entry(aeb, &ai->free, u.list) {
-		list_for_each_entry_safe(tmp_aeb, _tmp_aeb, &free, u.list) {
-			if (aeb->pnum == tmp_aeb->pnum) {
-				aeb->scrub = tmp_aeb->scrub;
-				aeb->ec = tmp_aeb->ec;
-				list_del(&tmp_aeb->u.list);
-				kfree(tmp_aeb);
-				continue;
-			}
-		}
-	}
-
-	list_for_each_entry(aeb, &ai->erase, u.list) {
-		list_for_each_entry_safe(tmp_aeb, _tmp_aeb, &free, u.list) {
-			if (aeb->pnum == tmp_aeb->pnum) {
-				aeb->scrub = tmp_aeb->scrub;
-				aeb->ec = tmp_aeb->ec;
-				list_del(&tmp_aeb->u.list);
-				kfree(tmp_aeb);
-				continue;
-			}
-		}
-	}
-
 	list_for_each_entry_safe(tmp_aeb, _tmp_aeb, &free, u.list) {
 		list_del(&tmp_aeb->u.list);
 		list_add_tail(&tmp_aeb->u.list, &ai->free);
-- 
1.7.6.5

